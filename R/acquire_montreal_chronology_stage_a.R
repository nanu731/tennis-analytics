# Phase 1P: bounded Stage A only. Sourcing or running this file never requests data.
source("R/download_pilot_data.R")

msa_urls <- function() c("https://www.wtatennis.com/terms-and-conditions",
  "https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play")
msa_paths <- function(root=".") list(
  raw=file.path(root,"data/raw/reference/montreal-2021-chronology"),
  audit=file.path(root,"data/pilot/development-2021/montreal-chronology-acquisition"))
msa_need <- function(ok, why) if(!isTRUE(ok)) stop("Stage A withheld: ",why,call.=FALSE)
msa_allow <- function(url) {
  msa_need(length(url)==1L && !is.na(url) && url %in% msa_urls(),"URL outside exact Stage A allowlist")
  match(url,msa_urls())
}
msa_supported <- function() "ACCESS_AND_LOCAL_RETENTION_SUPPORTED_FOR_PROPOSED_STAGE_A_MODE"
msa_states <- function() c(msa_supported(),"PROHIBITED","AMBIGUOUS_STOP_REQUIRED","UNAVAILABLE_OR_UNREADABLE")
msa_raw <- function(root,i) file.path(msa_paths(root)$raw,
  c("wta-stage-a-terms.html","wta-stage-a-oop-index.html")[i])
msa_file <- function(root,kind,i) file.path(msa_paths(root)$audit,paste0(kind,"-",i,".rds"))

# Immutable records are sealed individually; the final manifest is additionally
# pinned in the tracked aggregate report. An interrupted reservation cannot retry.
msa_seal <- function(x,path) {
  msa_need(!file.exists(path) && !file.exists(paste0(path,".sha256")),"refusing existing record overwrite")
  saveRDS(x,path,version=3)
  writeLines(pilot_sha256(path),paste0(path,".sha256"))
}
msa_read <- function(path) {
  msa_need(file.exists(path) && file.exists(paste0(path,".sha256")),"missing record or fingerprint")
  msa_need(identical(readLines(paste0(path,".sha256")),pilot_sha256(path)),"changed record fingerprint")
  readRDS(path)
}
msa_load <- function(root=".") {
  p<-msa_paths(root); records<-list()
  for(i in 1:2) {
    a<-msa_file(root,"attempt",i);r<-msa_file(root,"response",i);v<-msa_file(root,"review",i)
    if(!file.exists(a)) {
      msa_need(!any(file.exists(c(r,v,msa_raw(root,i)))),"unreserved evidence")
      next
    }
    msa_need(i==1L || length(records)==1L,"request order changed")
    attempt<-msa_read(a)
    msa_need(identical(attempt$url,msa_urls()[i]) && identical(attempt$ordinal,i) &&
      attempt$method=="GET" && attempt$phase=="1P_STAGE_A" &&
      attempt$approvals=="A1,A2,A3,A4,A9,A10" && nzchar(attempt$request_at_utc),"attempt contract changed")
    response<-if(file.exists(r)) msa_read(r) else NULL
    review<-if(file.exists(v)) msa_read(v) else NULL
    if(!is.null(response)) {
      msa_need(response$attempt_sha256==pilot_sha256(a),"response detached from attempt")
      if(nzchar(response$local_path)) {
        msa_need(response$local_path==msa_raw(root,i) && response$http_status=="200" &&
          response$curl_exit==0L && !response$redirect,"invalid retained response")
        msa_need(file.exists(response$local_path) &&
          file.info(response$local_path)$size==response$byte_size &&
          pilot_sha256(response$local_path)==response$sha256,"saved bytes or fingerprint changed")
      } else msa_need(!nzchar(response$sha256) && !nzchar(response$retrieved_at_utc) &&
        !file.exists(msa_raw(root,i)),"invented failed-request evidence")
    } else msa_need(is.null(review) && !file.exists(msa_raw(root,i)),"interrupted acquisition requires review")
    if(!is.null(review)) {
      msa_need(!is.null(response) && review$response_sha256==pilot_sha256(r) &&
        review$rights %in% msa_states() && review$retention %in% msa_states(),"review fingerprint/state changed")
      msa_need(response$readable || (review$rights=="UNAVAILABLE_OR_UNREADABLE" &&
        review$retention=="UNAVAILABLE_OR_UNREADABLE"),"unreadable response cannot clear review")
    }
    if(i==2L) msa_need(msa_can_proceed(records[[1]]),"second request without rights clearance")
    records[[i]]<-list(attempt=attempt,response=response,review=review)
  }
  # Unknown artifacts cannot reset the budget or smuggle another provider/year.
  expected<-unlist(lapply(1:2,function(i)unlist(lapply(c("attempt","response","review"),function(k) {
    f<-basename(msa_file(root,k,i));c(f,paste0(f,".sha256"))}))))
  msa_need(all(list.files(p$audit,all.files=FALSE) %in% c(expected,"stage-a-manifest.csv","request-lock")),"unexpected audit artifact")
  msa_need(all(list.files(p$raw) %in% basename(vapply(1:2,function(i)msa_raw(root,i),""))),"unexpected raw artifact")
  # A dangling seal also blocks; never reconstruct missing evidence silently.
  seals<-list.files(p$audit,pattern="\\.sha256$",full.names=TRUE)
  msa_need(all(file.exists(sub("\\.sha256$","",seals))),"orphan fingerprint")
  manifest<-file.path(p$audit,"stage-a-manifest.csv")
  report<-file.path(root,"docs/wta-2021-montreal-chronology-stage-a.md")
  msa_need(!file.exists(report) || file.exists(manifest),"reviewed manifest missing; no reacquisition or reconstruction")
  if(file.exists(manifest)) {
    observed<-read.csv(manifest,colClasses="character",na.strings=NULL,check.names=FALSE)
    expected_table<-msa_manifest(records,root)
    expected_table[]<-lapply(expected_table,as.character)
    msa_need(identical(observed,expected_table),"saved manifest changed")
    if(file.exists(report)) {
      pin<-grep("^Manifest SHA-256: `",readLines(report),value=TRUE)
      msa_need(length(pin)==1 && sub("`\\.$","",sub("^Manifest SHA-256: `","",pin))==pilot_sha256(manifest),
        "manifest differs from reviewed report fingerprint")
    }
  }
  records
}
msa_can_proceed <- function(record) !is.null(record$response) && record$response$readable &&
  !record$response$redirect && record$response$http_status=="200" &&
  !is.null(record$review) && record$review$rights==msa_supported() && record$review$retention==msa_supported()

msa_curl_args <- function(url,body,headers) {
  msa_allow(url)
  c("--disable","--request","GET","--no-location","--max-redirs","0","--retry","0",
    "--proto","=https","--proto-redir","=https","--connect-timeout","20","--max-time","60",
    "--silent","--show-error","--dump-header",headers,"--output",body,url)
}
msa_curl <- function(url,body,headers) {
  args<-msa_curl_args(url,body,headers)
  # --disable is first, excluding ~/.curlrc. No -L, --retry-all-errors or browser.
  status<-system2("/usr/bin/curl",vapply(args,shQuote,""),stdout=TRUE,stderr=TRUE)
  code<-attr(status,"status");if(is.null(code))code<-0L
  list(exit=as.integer(code),error=paste(status,collapse="\n"))
}
msa_classify <- function(status,redirect,exit,path,ordinal) {
  if(exit!=0L || status!="200" || redirect || !file.exists(path) || file.info(path)$size==0)
    return("UNAVAILABLE_OR_UNREADABLE")
  html<-tryCatch(rawToChar(readBin(path,"raw",n=file.info(path)$size)),error=function(e)"")
  # These conservative screens never grant rights; a fingerprint-bound review is mandatory.
  if(grepl("<title[^>]*>[^<]*(sign in|log in|login|just a moment|access denied|captcha)|verify you are human",
    html,ignore.case=TRUE,perl=TRUE))return("LOGIN_OR_BOT_CHECK")
  if(!grepl("<html",html,ignore.case=TRUE))return("UNAVAILABLE_OR_UNREADABLE")
  if(ordinal==1L && !grepl("terms and conditions|terms &amp; conditions",html,ignore.case=TRUE))
    return("UNAVAILABLE_OR_UNREADABLE")
  "READABLE_PENDING_MANUAL_REVIEW"
}

# Explicit call only. A repeat attempt is rejected; msa_audit() is the offline rerun.
# Synthetic transports are confined to a temporary root and cannot touch live evidence.
msa_attempt <- function(url,root=".",live=FALSE,transport=NULL) {
  i<-msa_allow(url);records<-msa_load(root);p<-msa_paths(root)
  msa_need(length(records)<2L && i==length(records)+1L,"retry, third request or wrong order")
  msa_need(i==1L || msa_can_proceed(records[[1]]),"request two blocked by rights/retention gate")
  production<-normalizePath(root,mustWork=TRUE)==normalizePath(".")
  msa_need((production && isTRUE(live) && is.null(transport)) ||
    (!production && !live && is.function(transport) && startsWith(normalizePath(root),normalizePath(tempdir()))),
    "live request requires explicit authorization; fixtures must use temporary root")
  if(production) transport<-msa_curl
  dir.create(p$raw,recursive=TRUE,showWarnings=FALSE);dir.create(p$audit,recursive=TRUE,showWarnings=FALSE)
  lock<-file.path(p$audit,"request-lock")
  msa_need(dir.create(lock,showWarnings=FALSE),"concurrent/interrupted request lock")
  on.exit(unlink(lock,recursive=TRUE),add=TRUE)
  records<-msa_load(root)
  msa_need(i==length(records)+1L,"budget changed while acquiring lock")
  a<-list(phase="1P_STAGE_A",approvals="A1,A2,A3,A4,A9,A10",ordinal=i,url=url,
    request_at_utc=format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC"),method="GET")
  msa_seal(a,msa_file(root,"attempt",i)) # Persist consumption BEFORE any outbound attempt.
  body<-tempfile();headers<-tempfile()
  on.exit(unlink(c(body,headers)),add=TRUE)
  result<-tryCatch(transport(url,body,headers),error=function(e)list(exit=1L,error=conditionMessage(e)))
  h<-if(file.exists(headers))readLines(headers,warn=FALSE) else character()
  # Last response block excludes a possible proxy CONNECT status.
  starts<-grep("^HTTP/",h);if(length(starts))h<-h[tail(starts,1):length(h)]
  status<-if(length(starts))sub("^HTTP/[^ ]+ ([0-9]+).*","\\1",h[1]) else "UNAVAILABLE"
  location<-sub("^[Ll]ocation:[[:space:]]*","",grep("^location:",h,ignore.case=TRUE,value=TRUE))
  media<-sub("^[^:]+:[[:space:]]*","",grep("^content-type:",h,ignore.case=TRUE,value=TRUE))
  redirect<-grepl("^3[0-9][0-9]$",status) || length(location)>0
  kind<-msa_classify(status,redirect,result$exit,body,i)
  retained<-result$exit==0L && status=="200" && !redirect && file.exists(body) && file.info(body)$size>0
  path<-hash<-retrieved<-""
  if(retained) {
    path<-msa_raw(root,i);msa_need(!file.exists(path) && file.copy(body,path,overwrite=FALSE),"immutable response placement failed")
    hash<-pilot_sha256(path);retrieved<-format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC")
  }
  response<-list(attempt_sha256=pilot_sha256(msa_file(root,"attempt",i)),http_status=status,
    curl_exit=result$exit,redirect=redirect,redirect_target=paste(location,collapse=" | "),
    media_type=paste(media,collapse=" | "),byte_size=if(file.exists(body))file.info(body)$size else NA_real_,
    local_path=path,sha256=hash,retrieved_at_utc=retrieved,access=kind,
    readable=kind=="READABLE_PENDING_MANUAL_REVIEW",error=result$error)
  msa_seal(response,msa_file(root,"response",i))
  if(!response$readable) msa_review(i,"UNAVAILABLE_OR_UNREADABLE","UNAVAILABLE_OR_UNREADABLE",
    paste("Stop:",kind,"HTTP",status,"curl",result$exit),root=root)
  invisible(msa_load(root))
}
msa_review <- function(i,rights,retention,reason,root=".") {
  x<-msa_load(root)
  msa_need(i %in% seq_along(x) && !is.null(x[[i]]$response) && is.null(x[[i]]$review),"missing/already reviewed response")
  msa_need(rights %in% msa_states() && retention %in% msa_states() && length(reason)==1 && nzchar(reason),"invalid assessment")
  msa_need(x[[i]]$response$readable || (rights=="UNAVAILABLE_OR_UNREADABLE" && retention==rights),"unreadable review")
  msa_seal(list(rights=rights,retention=retention,reason=reason,
    reviewed_at_utc=format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC"),
    response_sha256=pilot_sha256(msa_file(root,"response",i))),msa_file(root,"review",i))
  invisible(msa_load(root))
}
msa_manifest <- function(x,root) {
  msa_need(length(x)>0,"no recorded attempt")
  do.call(rbind,lapply(seq_along(x),function(i) {
    a<-x[[i]]$attempt;r<-x[[i]]$response;v<-x[[i]]$review
    msa_need(!is.null(r) && !is.null(v),"incomplete request/review; no success report")
    data.frame(phase=a$phase,approval_ids=a$approvals,ordinal=i,url=a$url,
      request_at_utc=a$request_at_utc,method="GET",http_status=r$http_status,curl_exit=r$curl_exit,
      redirect=r$redirect,redirect_target=r$redirect_target,media_type=r$media_type,
      byte_size=if(is.na(r$byte_size))"" else as.character(r$byte_size),
      local_path=r$local_path,sha256=r$sha256,retrieved_at_utc=r$retrieved_at_utc,
      access=r$access,rights=v$rights,retention=v$retention,reason=v$reason,
      attempts_remaining=2L-i,another_request_authorized=i==1L && length(x)==1L && msa_can_proceed(x[[1]]),
      attempt_record_sha256=pilot_sha256(msa_file(root,"attempt",i)),
      response_record_sha256=pilot_sha256(msa_file(root,"response",i)),
      review_record_sha256=pilot_sha256(msa_file(root,"review",i)),error=r$error)
  }))
}
msa_audit <- function(root=".",write_manifest=FALSE) {
  x<-msa_load(root);m<-msa_manifest(x,root)
  if(write_manifest) {
    msa_need(!any(m$another_request_authorized),"Stage A still open; final manifest withheld")
    path<-file.path(msa_paths(root)$audit,"stage-a-manifest.csv")
    if(!file.exists(path))write.csv(m,path,row.names=FALSE,na="")
  }
  invisible(m)
}

# Literal links only, never followed. Even a matching canonical URL proves only
# page scope: manual attribution of historical content remains mandatory.
msa_page_observations <- function(html) {
  hits<-regmatches(html,gregexpr('href=["\x27][^"\x27]+["\x27]',html,perl=TRUE))[[1]]
  links<-unique(sub('["\x27]$','',sub('^href=["\x27]','',hits)))
  canonical<-grepl(paste0('<link rel="canonical" href="',msa_urls()[2],'"'),html,fixed=TRUE)
  list(literal_links=links,links_followed=0L,canonical_matches=canonical,
    historical_content="NOT_VERIFIED",actual_start="NOT_VERIFIED",completion="NOT_VERIFIED",
    result_availability="NOT_VERIFIED",schedule_is_actual=FALSE,
    next_action="MANUAL_REVIEW_ONLY_NO_REQUESTS")
}
if(sys.nframe()==0L) {m<-msa_audit();print(m[c("ordinal","http_status","rights","another_request_authorized")])}
