# Phase 1S. Sourcing is inert; ordinary execution validates saved evidence only.
source("R/download_pilot_data.R")

otd_baseline <- function() "6a07728030422f7040b0f75d5ea8497ff6f16439"
otd_urls <- function() c(
  "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA_LICENSE.md",
  "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA.md",
  "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/docs/SCHEMA.md",
  "https://github.com/ryantjx/tennis-match-data")
otd_need <- function(ok,why) if(!isTRUE(ok)) stop("OTD preflight withheld: ",why,call.=FALSE)
otd_paths <- function(root=".") list(raw=file.path(root,"data/raw/reference/otd-documentation"),
  audit=file.path(root,"data/pilot/otd-documentation"),
  report=file.path(root,"docs/otd-documentation-preflight.md"))
otd_file <- function(root,kind,i) file.path(otd_paths(root)$audit,paste0(kind,"-",i,".rds"))
otd_body <- function(root,i) file.path(otd_paths(root)$raw,paste0("response-",i,".body"))
otd_headers <- function(root,i) file.path(otd_paths(root)$raw,paste0("response-",i,".headers"))
otd_reservation <- function(root,i) file.path(otd_paths(root)$audit,paste0("reserved-",i))
otd_manifest_path <- function(root) file.path(otd_paths(root)$audit,"manifest.csv")
otd_now <- function() format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC")
otd_allow <- function(url) {
  otd_need(is.character(url) && length(url)==1L && !is.na(url) && url %in% otd_urls(),"exact URL allowlist")
  match(url,otd_urls())
}
otd_states <- function() c("SUPPORTED_DOCUMENTATION_ONLY","PROHIBITED","AMBIGUOUS_STOP_REQUIRED","UNAVAILABLE_OR_UNREADABLE")
otd_seal <- function(object,path) {
  otd_need(!file.exists(path) && !file.exists(paste0(path,".sha256")),"immutable record already exists")
  saveRDS(object,path,version=3)
  writeLines(pilot_sha256(path),paste0(path,".sha256"))
}
otd_read <- function(path) {
  otd_need(file.exists(path) && file.exists(paste0(path,".sha256")),"record or seal missing")
  otd_need(identical(readLines(paste0(path,".sha256")),pilot_sha256(path)),"record hash changed")
  readRDS(path)
}
otd_supported <- function(x) !is.null(x$response) && isTRUE(x$response$readable) &&
  !is.null(x$review) && x$review$access=="SUPPORTED_DOCUMENTATION_ONLY" &&
  x$review$retention=="SUPPORTED_DOCUMENTATION_ONLY" && x$review$disposition=="CONTINUE"
otd_stat <- function(path) if(file.exists(path)) list(bytes=file.info(path)$size,sha256=pilot_sha256(path)) else
  list(bytes=NA_real_,sha256="")

# Every reservation consumes a slot, including a process killed before transport.
# Unknown files, gaps, changed bytes and missing seals block rather than reset it.
otd_load <- function(root=".",check_manifest=TRUE) {
  p<-otd_paths(root);x<-list();expected<-character()
  for(i in 1:4) {
    paths<-vapply(c("attempt","response","review"),function(k)otd_file(root,k,i),"")
    expected<-c(expected,basename(paths),paste0(basename(paths),".sha256"),paste0("reserved-",i))
    reserved<-dir.exists(otd_reservation(root,i))
    if(!reserved) {
      otd_need(!any(file.exists(c(paths,paste0(paths,".sha256"),otd_body(root,i),otd_headers(root,i)))),"unreserved evidence")
      next
    }
    otd_need(i==length(x)+1L,"reservation order/gap")
    otd_need(i==1L || otd_supported(x[[i-1L]]),"preceding rights/review gate not cleared")
    a<-if(file.exists(paths[1]))otd_read(paths[1]) else NULL
    r<-if(file.exists(paths[2]))otd_read(paths[2]) else NULL
    v<-if(file.exists(paths[3]))otd_read(paths[3]) else NULL
    if(!is.null(a)) otd_need(identical(a$ordinal,i) && identical(a$url,otd_urls()[i]) &&
      a$method=="GET" && a$phase=="1S" && a$approvals=="Q3,Q4" &&
      a$authority=="APPROVED_DOCUMENTATION_PREFLIGHT_ONLY" && nzchar(a$request_at_utc),"attempt contract changed")
    if(!is.null(r)) {
      otd_need(!is.null(a) && r$attempt_sha256==pilot_sha256(paths[1]),"detached response")
      otd_need(identical(r$body,otd_stat(otd_body(root,i))) &&
        identical(r$headers,otd_stat(otd_headers(root,i))),"response/header bytes changed")
      otd_need(identical(r$readable,otd_readable(r,otd_body(root,i),i)),"response classification changed")
    }
    if(!is.null(v)) {
      otd_need(!is.null(r) && v$response_sha256==pilot_sha256(paths[2]) &&
        v$access %in% otd_states() && v$retention %in% otd_states() &&
        v$disposition %in% c("CONTINUE","STOP") && nzchar(v$reason) && nzchar(v$locator),"invalid review")
      otd_need(r$readable || (v$access=="UNAVAILABLE_OR_UNREADABLE" && v$retention==v$access && v$disposition=="STOP"),
        "unreadable document cannot clear rights")
      otd_need(v$disposition!="CONTINUE" || (v$access=="SUPPORTED_DOCUMENTATION_ONLY" && v$retention==v$access),
        "negative rights cannot continue")
    }
    x[[i]]<-list(attempt=a,response=r,review=v)
  }
  audit_files<-list.files(p$audit,all.files=TRUE,no..=TRUE)
  otd_need(all(audit_files %in% c(expected,"manifest.csv","manifest.csv.sha256")),"unexpected audit artifact")
  raw_files<-list.files(p$raw,all.files=TRUE,no..=TRUE)
  otd_need(all(raw_files %in% basename(c(vapply(1:4,function(i)otd_body(root,i),""),
    vapply(1:4,function(i)otd_headers(root,i),"")))),"unexpected raw artifact")
  all_paths<-c(file.path(p$audit,audit_files),file.path(p$raw,raw_files))
  otd_need(!any(nzchar(Sys.readlink(all_paths))),"symlink evidence refused")
  seals<-all_paths[endsWith(all_paths,".sha256")]
  otd_need(all(file.exists(sub("[.]sha256$","",seals))),"orphan hash seal")
  mf<-otd_manifest_path(root)
  otd_need(!file.exists(p$report) || file.exists(mf),"reviewed cache missing; no reacquisition")
  if(check_manifest && file.exists(mf)) {
    otd_need(identical(readLines(paste0(mf,".sha256")),pilot_sha256(mf)),"manifest seal changed")
    saved<-read.csv(mf,colClasses="character",na.strings=NULL,check.names=FALSE)
    expected_table<-otd_manifest(x,root);expected_table[]<-lapply(expected_table,as.character)
    otd_need(identical(saved,expected_table),"manifest differs from records")
    if(file.exists(p$report)) {
      pin<-grep("^Manifest SHA-256: `",readLines(p$report),value=TRUE)
      otd_need(identical(pin,paste0("Manifest SHA-256: `",pilot_sha256(mf),"`.")),"report manifest pin changed")
    }
  }
  x
}

otd_curl_args <- function(url,body,headers) {
  otd_allow(url)
  c("--disable","--request","GET","--no-location","--max-redirs","0","--retry","0",
    "--proto","=https","--proto-redir","=https","--connect-timeout","20","--max-time","60",
    "--max-filesize","2097152","--silent","--show-error","--dump-header",headers,"--output",body,url)
}
otd_live_root <- function(root) {
  exact<-normalizePath(path.expand("~/Documents/GitHub/tennis-analytics"),mustWork=TRUE)
  otd_need(normalizePath(root,mustWork=TRUE)==exact && normalizePath(getwd())==exact,"exact repository root required")
  head<-system2("git",c("rev-parse","HEAD"),stdout=TRUE)
  otd_need(identical(head,otd_baseline()),"live mode closed outside approved starting commit")
  for(parent in c("data/raw/reference","data/pilot"))
    otd_need(normalizePath(parent,mustWork=TRUE)==file.path(exact,parent),"storage parent redirected")
  for(path in unlist(otd_paths(root))[1:2]) if(dir.exists(path))
    otd_need(normalizePath(path)==file.path(exact,sub("^[.]/","",path)),"storage root redirected")
  invisible(TRUE)
}
otd_curl <- function(url,body,headers,root,live=FALSE) {
  otd_need(isTRUE(live) && identical(root,"."),"transport requires explicit live mode")
  otd_live_root(root);i<-otd_allow(url)
  otd_need(identical(body,otd_body(root,i)) && identical(headers,otd_headers(root,i)),"exact response paths required")
  otd_need(dir.exists(otd_reservation(root,i)) && file.exists(otd_file(root,"attempt",i)) &&
    !file.exists(otd_file(root,"response",i)) && !file.exists(body) && !file.exists(headers),"transport requires unused reservation")
  args<-otd_curl_args(url,body,headers)
  output<-suppressWarnings(system2("/usr/bin/curl",vapply(args,shQuote,""),stdout=TRUE,stderr=TRUE))
  exit<-attr(output,"status");if(is.null(exit))exit<-0L
  list(exit=as.integer(exit),error=paste(output,collapse="\n"))
}
otd_readable <- function(r,body,i) {
  if(r$curl_exit!=0L || r$http_status!="200" || r$redirect || !file.exists(body) ||
    file.info(body)$size==0 || !grepl("^text/(plain|markdown|html)(;|$)",r$media_type,ignore.case=TRUE)) return(FALSE)
  text<-tryCatch(rawToChar(readBin(body,"raw",n=file.info(body)$size)),error=function(e)"")
  if(!nzchar(text) || grepl("<title[^>]*>[^<]*(sign in|log in|access denied|just a moment)|verify you are human",
    text,ignore.case=TRUE,perl=TRUE))return(FALSE)
  if(i==1L && !grepl("license|licensing",text,ignore.case=TRUE))return(FALSE)
  TRUE # Readable is never a permission grant; manual review is mandatory.
}

otd_attempt <- function(url,root=".",live=FALSE,transport=NULL) {
  i<-otd_allow(url)
  otd_need(identical(root,".") || (isFALSE(live) && is.function(transport) &&
    startsWith(normalizePath(root,mustWork=TRUE),paste0(normalizePath(tempdir()),"/"))),"unapproved root")
  if(isTRUE(live)) {otd_need(is.null(transport),"live fixtures forbidden");otd_live_root(root)} else
    otd_need(root!="." && is.function(transport),"explicit live mode required; fixtures confined to temporary root")
  x<-otd_load(root);p<-otd_paths(root)
  otd_need(!file.exists(otd_manifest_path(root)) && !file.exists(p$report),"finalized review; no requests")
  otd_need(length(x)<4L && i==length(x)+1L,"four-attempt lifetime ceiling; retries/order changes refused")
  otd_need(i==1L || otd_supported(x[[i-1L]]),"rights-first stop or incomplete review")
  dir.create(p$raw,recursive=TRUE,showWarnings=FALSE);dir.create(p$audit,recursive=TRUE,showWarnings=FALSE)
  otd_need(dir.create(otd_reservation(root,i),showWarnings=FALSE),"concurrent/interrupted reservation")
  # Persistent reservation is deliberately never removed, including on failure.
  otd_seal(list(phase="1S",ordinal=i,url=url,method="GET",approvals="Q3,Q4",
    authority="APPROVED_DOCUMENTATION_PREFLIGHT_ONLY",request_at_utc=otd_now()),otd_file(root,"attempt",i))
  body<-otd_body(root,i);headers<-otd_headers(root,i)
  otd_need(!any(file.exists(c(body,headers))),"refusing response overwrite")
  result<-tryCatch(if(live)otd_curl(url,body,headers,root,live=TRUE) else transport(url,body,headers),
    error=function(e)list(exit=1L,error=conditionMessage(e)))
  # Retain original headers and any body even for non-200/redirect/partial responses.
  h<-if(file.exists(headers))readLines(headers,warn=FALSE) else character()
  starts<-grep("^HTTP/",h);if(length(starts))h<-h[tail(starts,1):length(h)]
  status<-if(length(starts))sub("^HTTP/[^ ]+ ([0-9]+).*","\\1",h[1]) else "UNAVAILABLE"
  value<-function(key)paste(sub("^[^:]+:[[:space:]]*","",grep(paste0("^",key,":"),h,ignore.case=TRUE,value=TRUE)),collapse=" | ")
  r<-list(attempt_sha256=pilot_sha256(otd_file(root,"attempt",i)),finished_at_utc=otd_now(),
    http_status=status,curl_exit=as.integer(result$exit),media_type=value("content-type"),
    redirect=grepl("^3[0-9][0-9]$",status) || nzchar(value("location")),redirect_target=value("location"),
    etag=value("etag"),last_modified=value("last-modified"),body=otd_stat(body),headers=otd_stat(headers),error=result$error)
  r$readable<-otd_readable(r,body,i)
  otd_seal(r,otd_file(root,"response",i))
  if(!r$readable)otd_review(i,"UNAVAILABLE_OR_UNREADABLE","UNAVAILABLE_OR_UNREADABLE","STOP",
    paste("Transport/media/readability stop; HTTP",status,"curl",r$curl_exit),"response and original headers",root)
  invisible(otd_load(root))
}
otd_review <- function(i,access,retention,disposition,reason,locator,root=".") {
  x<-otd_load(root)
  otd_need(i %in% seq_along(x) && !is.null(x[[i]]$response) && is.null(x[[i]]$review),"missing/already reviewed response")
  otd_need(access %in% otd_states() && retention %in% otd_states() && disposition %in% c("CONTINUE","STOP") &&
    length(reason)==1L && nzchar(reason) && length(locator)==1L && nzchar(locator),"invalid review")
  otd_need(disposition!="CONTINUE" || (access=="SUPPORTED_DOCUMENTATION_ONLY" && retention==access),"rights/retention not supported")
  otd_need(x[[i]]$response$readable || (access=="UNAVAILABLE_OR_UNREADABLE" && retention==access && disposition=="STOP"),"unreadable review")
  otd_seal(list(access=access,retention=retention,disposition=disposition,reason=reason,locator=locator,
    reviewed_at_utc=otd_now(),response_sha256=pilot_sha256(otd_file(root,"response",i))),otd_file(root,"review",i))
  invisible(otd_load(root))
}

otd_manifest <- function(x,root) {
  consumed<-length(x)
  terminal<-consumed>0L && (consumed==4L || (!is.null(x[[consumed]]$review) && !otd_supported(x[[consumed]])) ||
    is.null(x[[consumed]]$attempt) || is.null(x[[consumed]]$response))
  do.call(rbind,lapply(1:4,function(i) {
    z<-if(i<=consumed)x[[i]] else list(attempt=NULL,response=NULL,review=NULL)
    a<-z$attempt;r<-z$response;v<-z$review
    get<-function(z,key,default="")if(is.null(z))default else as.character(z[[key]])
    body<-otd_stat(otd_body(root,i));headers<-otd_stat(otd_headers(root,i))
    hash<-function(k) {p<-otd_file(root,k,i);if(file.exists(p))pilot_sha256(p) else ""}
    state<-if(i>consumed) {if(terminal)"NOT_ATTEMPTED_STOPPED" else "NOT_ATTEMPTED_PENDING"} else
      if(is.null(a)||is.null(r))"INTERRUPTED_NO_RETRY" else if(is.null(v))"AWAITING_MANUAL_REVIEW" else
      if(!r$readable)"FAILED_STOPPED" else if(!otd_supported(z))"REVIEWED_STOPPED" else "REVIEWED_DOCUMENTATION_ONLY"
    data.frame(ordinal=i,url=otd_urls()[i],authority="Q3/Q4_APPROVED_DOCUMENTATION_PREFLIGHT_ONLY",
      state=state,attempt_consumed=i<=consumed,total_consumed=consumed,unused_slots=4L-consumed,
      further_request_authorized=!terminal && consumed<4L && i==consumed+1L && (consumed==0L||otd_supported(x[[consumed]])),
      request_at_utc=get(a,"request_at_utc"),finished_at_utc=get(r,"finished_at_utc"),method=if(i<=consumed)"GET" else "",
      http_status=get(r,"http_status"),curl_exit=get(r,"curl_exit"),redirect=get(r,"redirect"),redirect_target=get(r,"redirect_target"),
      media_type=get(r,"media_type"),body_bytes=if(is.na(body$bytes))"" else as.character(body$bytes),body_sha256=body$sha256,
      header_bytes=if(is.na(headers$bytes))"" else as.character(headers$bytes),header_sha256=headers$sha256,
      etag=get(r,"etag"),last_modified=get(r,"last_modified"),access=get(v,"access"),retention=get(v,"retention"),
      reason=get(v,"reason",if(i>consumed && terminal)"Stopped earlier; unused slots do not authorize access" else ""),
      locator=get(v,"locator"),reviewed_at_utc=get(v,"reviewed_at_utc"),
      attempt_record_sha256=hash("attempt"),response_record_sha256=hash("response"),review_record_sha256=hash("review"),error=get(r,"error"))
  }))
}
otd_audit <- function(root=".",finalize=FALSE) {
  x<-otd_load(root);m<-otd_manifest(x,root)
  if(finalize) {
    otd_need(length(x)>0L && !any(m$further_request_authorized) && !any(m$state=="AWAITING_MANUAL_REVIEW"),"unfinished review")
    path<-otd_manifest_path(root)
    if(!file.exists(path)) {write.csv(m,path,row.names=FALSE,na="");writeLines(pilot_sha256(path),paste0(path,".sha256"))}
    otd_load(root)
  }
  m
}
if(sys.nframe()==0L)print(otd_audit()[c("ordinal","state","http_status","access","retention")])
