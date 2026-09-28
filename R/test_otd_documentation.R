# Offline only. Synthetic fixtures never use the production evidence roots.
source("R/review_otd_documentation.R")
test_otd_documentation <- function(check_repository=TRUE) {
  count<-0L;calls<-0L;roots<-character();original<-otd_curl
  assign("otd_curl",function(...)stop("LIVE TRANSPORT FORBIDDEN IN TESTS"),.GlobalEnv)
  trace("download.file",where=asNamespace("utils"),tracer=quote(stop("NETWORK FORBIDDEN")),print=FALSE)
  trace("url",where=baseenv(),tracer=quote(stop("NETWORK FORBIDDEN")),print=FALSE)
  trace("socketConnection",where=baseenv(),tracer=quote(stop("NETWORK FORBIDDEN")),print=FALSE)
  original_system2<-base::system2
  old_system2<-if(exists("system2",.GlobalEnv,inherits=FALSE))get("system2",.GlobalEnv) else NULL
  assign("system2",function(command,...) {
    otd_need(basename(command)%in%c("git","shasum","sha256sum"),"offline subprocess allowlist")
    original_system2(command,...)
  },.GlobalEnv)
  on.exit({
    assign("otd_curl",original,.GlobalEnv)
    for(n in c("url","socketConnection"))untrace(n,where=baseenv())
    untrace("download.file",where=asNamespace("utils"))
    if(is.null(old_system2))rm("system2",envir=.GlobalEnv) else assign("system2",old_system2,.GlobalEnv)
    unlink(roots,recursive=TRUE)
  },add=TRUE)
  check<-function(ok,label) {stopifnot(isTRUE(ok));count<<-count+1L;message("PASS: ",label)}
  reject<-function(expr,label)check(inherits(tryCatch(force(expr),error=identity),"error"),label)
  fixture<-function() {r<-tempfile("otd-fixture-");dir.create(r);roots<<-c(roots,r);r}
  fake<-function(http="200",text="# License\nSynthetic documentation only.",media="text/plain; charset=utf-8",
    exit=0L,redirect=FALSE,fail=FALSE)function(url,body,headers) {
      calls<<-calls+1L;otd_allow(url)
      if(fail)stop("Synthetic connection failure")
      writeLines(c("HTTP/1.1 200 Connection established","",paste0("HTTP/2 ",http),paste0("Content-Type: ",media),
        "ETag: synthetic-only",if(redirect)"Location: https://not-followed.invalid/", ""),headers)
      writeBin(charToRaw(text),body)
      list(exit=exit,error=if(exit)"Synthetic partial failure" else "")
    }
  call<-function(r,i=1L,transport=fake())otd_attempt(otd_urls()[i],r,transport=transport)
  approve<-function(r,i=1L)otd_review(i,"SUPPORTED_DOCUMENTATION_ONLY","SUPPORTED_DOCUMENTATION_ONLY","CONTINUE",
    "Synthetic explicit documentation permission, not real licensing evidence","synthetic lines 1-2",r)
  negative<-function(r,i=1L,access="AMBIGUOUS_STOP_REQUIRED",retention=access)
    otd_review(i,access,retention,"STOP","Synthetic rights stop","synthetic lines 1-2",r)
  snap<-function(r) {p<-sort(list.files(r,recursive=TRUE,full.names=TRUE,all.files=TRUE));
    data.frame(path=p,sha=vapply(p,pilot_sha256,""),bytes=file.info(p)$size,mtime=as.numeric(file.info(p)$mtime),row.names=NULL)}
  r<-fixture();before<-calls
  before_files<-list.files(r,all.files=TRUE,no..=TRUE)
  isolated<-new.env(parent=globalenv())
  sys.source("R/review_otd_documentation.R",envir=isolated)
  check(calls==before && identical(before_files,list.files(r,all.files=TRUE,no..=TRUE)),"sourcing defines functions without acquisition or output")
  check(identical(otd_urls(),c(
    "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA_LICENSE.md",
    "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA.md",
    "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/docs/SCHEMA.md",
    "https://github.com/ryantjx/tennis-match-data")),"exact four approved targets/order")
  for(i in 2:4)reject(call(r,i),paste("cannot start at request",i))
  bad<-c(paste0(otd_urls(),"?raw=1"),paste0(otd_urls(),"/"),sub("https:","http:",otd_urls()),
    "https://api.github.com/repos/ryantjx/tennis-match-data",
    "https://github.com/search?q=tennis","https://www.wtatennis.com/terms-and-conditions",
    "https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/2025.csv",
    "https://github.com/ryantjx/tennis-match-data/releases/download/v3/matches.parquet",
    "https://github.com/ryantjx/tennis-match-data/archive/main.zip",
    "https://github.com/ryantjx/tennis-match-data/raw/main/script.js")
  for(u in bad)reject(otd_attempt(u,r,transport=fake()),paste("unapproved target",u))
  reject(otd_attempt(otd_urls()[1]),"ordinary call cannot acquire")
  reject(original(otd_urls()[1],"body","headers","."),"transport helper also requires explicit live mode")
  reject(otd_attempt(otd_urls()[1],r,live=TRUE),"temporary root cannot use live transport")
  reject(otd_attempt(otd_urls()[1],".",transport=fake()),"fixtures cannot write production evidence")
  check(calls==before,"rejected requests consume no synthetic transport calls")
  args<-otd_curl_args(otd_urls()[1],"body","headers")
  check(args[1]=="--disable" && args[match("--request",args)+1]=="GET" && "--no-location"%in%args &&
    args[match("--max-redirs",args)+1]=="0" && args[match("--retry",args)+1]=="0" &&
    args[match("--proto",args)+1]=="=https" &&
    !any(c("-L","--location","--retry-all-errors","--netrc","--user","--cookie","--config")%in%args) &&
    sum(args%in%otd_urls())==1L,"direct public GET, no curl config/auth/redirect/retry/subresources")
  r<-fixture();call(r);reject(call(r,2L),"readable license alone never clears rights")
  reject(otd_review(1L,"AMBIGUOUS_STOP_REQUIRED","SUPPORTED_DOCUMENTATION_ONLY","CONTINUE","bad","fixture",r),
    "silence/ambiguity cannot be recorded as continued permission")
  reject(otd_review(1L,"SUPPORTED_DOCUMENTATION_ONLY","SUPPORTED_DOCUMENTATION_ONLY","CONTINUE","bad","",r),
    "affirmative review requires an evidence locator")
  reject(otd_audit(r,TRUE),"unreviewed response cannot finalize")
  for(state in c("PROHIBITED","AMBIGUOUS_STOP_REQUIRED")) {
    r<-fixture();call(r);negative(r,access=state);before<-calls
    reject(call(r,2L),paste("rights-first stop",state));m<-otd_audit(r,TRUE)
    check(sum(m$attempt_consumed)==1L && all(m$state[-1]=="NOT_ATTEMPTED_STOPPED") && calls==before,
      paste("unused slots withheld after",state))
  }
  r<-fixture();call(r);negative(r,access="SUPPORTED_DOCUMENTATION_ONLY",retention="AMBIGUOUS_STOP_REQUIRED")
  reject(call(r,2L),"retention gate independently blocks")
  for(kind in c("connection","redirect","404","bot","binary","partial","empty")) {
    r<-fixture();t<-switch(kind,connection=fake(fail=TRUE),redirect=fake("302",redirect=TRUE),
      `404`=fake("404"),bot=fake(text="<html><title>Just a moment</title>verify you are human</html>",media="text/html"),
      binary=fake(media="application/octet-stream"),partial=fake(exit=28L),empty=fake(text=""))
    before<-calls;call(r,transport=t);x<-otd_load(r);m<-otd_audit(r,TRUE)
    check(length(x)==1L && calls==before+1L && m$state[1]=="FAILED_STOPPED" && !any(m$further_request_authorized),paste(kind,"counts and stops"))
    reject(call(r),paste(kind,"cannot retry"));reject(call(r,2L),paste(kind,"cannot continue"))
    if(kind!="connection")check(file.exists(otd_body(r,1L)) && nzchar(m$body_sha256[1]) && nzchar(m$header_sha256[1]),
      paste(kind,"original response and headers retained")) else check(m$body_sha256[1]=="" && m$http_status[1]=="UNAVAILABLE","no invented response on connection failure")
  }
  r<-fixture();call(r);approve(r);call(r,2L);negative(r,2L)
  reject(call(r,3L),"new conflict in a later document stops remaining requests")
  r<-fixture();for(i in 1:4){call(r,i);approve(r,i)}
  m<-otd_audit(r,TRUE);before<-calls;saved<-snap(r)
  check(nrow(m)==4L && all(m$attempt_consumed) && !any(m$further_request_authorized),"four-attempt lifetime ceiling")
  for(i in 1:4)reject(call(r,i),paste("no repeat after ceiling",i))
  check(identical(m,otd_audit(r,TRUE)) && identical(saved,snap(r)) && calls==before,"offline cache reuse and byte/mtime-stable aggregate")
  reject(approve(r),"manual review cannot overwrite")
  writeLines("tampered",otd_body(r,1L));reject(otd_audit(r),"response hash tampering rejected")
  r<-fixture();call(r);negative(r);otd_audit(r,TRUE)
  writeLines("changed headers",otd_headers(r,1L));reject(otd_audit(r),"header hash tampering rejected")
  r<-fixture();call(r);negative(r);otd_audit(r,TRUE)
  writeLines(strrep("0",64),paste0(otd_file(r,"response",1L),".sha256"));reject(otd_audit(r),"record seal tampering rejected")
  r<-fixture();call(r);negative(r);otd_audit(r,TRUE)
  write("changed",otd_manifest_path(r),append=TRUE);reject(otd_audit(r),"manifest hash tampering rejected")
  writeLines(pilot_sha256(otd_manifest_path(r)),paste0(otd_manifest_path(r),".sha256"))
  reject(otd_audit(r),"resealed manifest still must agree with immutable records")
  r<-fixture();call(r);negative(r);otd_audit(r,TRUE);dir.create(file.path(r,"docs"))
  writeLines(paste0("Manifest SHA-256: `",strrep("0",64),"`."),otd_paths(r)$report)
  reject(otd_audit(r),"report binds immutable manifest")
  unlink(c(otd_manifest_path(r),paste0(otd_manifest_path(r),".sha256")))
  reject(call(r),"missing reviewed cache cannot reset budget")
  for(stage in c("reservation","attempt","partial_body")) {
    r<-fixture();p<-otd_paths(r);dir.create(p$audit,recursive=TRUE);dir.create(p$raw,recursive=TRUE)
    dir.create(otd_reservation(r,1L))
    if(stage!="reservation")otd_seal(list(phase="1S",ordinal=1L,url=otd_urls()[1],method="GET",approvals="Q3,Q4",
      authority="APPROVED_DOCUMENTATION_PREFLIGHT_ONLY",request_at_utc="synthetic"),otd_file(r,"attempt",1L))
    if(stage=="partial_body")writeLines("partial license",otd_body(r,1L))
    saved<-snap(r);before<-calls
    reject(call(r),paste(stage,"interruption refuses retry"));reject(call(r,2L),paste(stage,"interruption refuses continuation"))
    check(identical(saved,snap(r)) && calls==before && otd_audit(r)$state[1]=="INTERRUPTED_NO_RETRY",paste(stage,"preserved and accounted"))
  }
  r<-fixture();call(r);writeLines("unexpected",file.path(otd_paths(r)$raw,"alternate.csv"))
  reject(otd_load(r),"unapproved artifact path blocks")
  r<-fixture();call(r);unlink(otd_file(r,"attempt",1L));reject(otd_load(r),"orphan seal blocks")
  r<-fixture();call(r);a<-otd_read(otd_file(r,"attempt",1L));a$ordinal<-2L
  saveRDS(a,otd_file(r,"attempt",1L),version=3)
  writeLines(pilot_sha256(otd_file(r,"attempt",1L)),paste0(otd_file(r,"attempt",1L),".sha256"))
  reject(otd_load(r),"resealed altered request identity cannot change order")
  if(check_repository) {
    m<-otd_audit(finalize=TRUE);before<-calls
    p<-otd_paths();paths<-c(list.files(p$raw,full.names=TRUE),list.files(p$audit,full.names=TRUE))
    paths<-paths[!file.info(paths)$isdir]
    s<-data.frame(path=paths,hash=vapply(paths,pilot_sha256,""),mtime=as.numeric(file.info(paths)$mtime))
    otd_audit(finalize=TRUE)
    check(identical(s,data.frame(path=paths,hash=vapply(paths,pilot_sha256,""),mtime=as.numeric(file.info(paths)$mtime))) && calls==before,
      "real saved evidence reused without requests or writes")
    check(all(vapply(paths,function(p)system2("git",c("check-ignore","-q",shQuote(p)))==0L,TRUE)) &&
      !length(system2("git",c("ls-files","--",shQuote(p$raw),shQuote(p$audit)),stdout=TRUE)),"raw and manifest ignored and untracked")
    check(!any(grepl("2025",m$url)) && all(m$url==otd_urls()) && sum(m$attempt_consumed)<=4L,"documentation-only targets; no 2025 payload")
    check(sum(m$attempt_consumed)==1L && m$http_status[1]=="200" && m$body_bytes[1]=="1528" &&
      m$body_sha256[1]=="51e17ec16942ccd9f2512da9bb0ee32389579632094859a7efc6322f2f80cc0f" &&
      m$access[1]=="AMBIGUOUS_STOP_REQUIRED" && m$retention[1]==m$access[1] &&
      all(m$state[-1]=="NOT_ATTEMPTED_STOPPED") && !any(m$further_request_authorized),"actual rights stop and single response pinned")
    report<-paste(readLines(p$report),collapse="\n")
    for(field in c("url","request_at_utc","finished_at_utc","media_type","body_bytes","body_sha256",
      "header_bytes","header_sha256","etag","attempt_record_sha256","response_record_sha256","review_record_sha256")) {
      value<-m[[field]][1];if(field=="body_bytes")value<-"1,528"
      stopifnot(grepl(value,report,fixed=TRUE))
    }
    check(TRUE,"report provenance agrees with sealed response and manifest")
    otd_document_contracts()
    check(TRUE,"current authority, unchanged gates and durable modeling guidance")
  }
  message(count," Phase 1S offline checks passed; no live transport.")
  invisible(count)
}

otd_document_contracts <- function() {
  docs<-vapply(c("docs/status.md","docs/data-source-contract.md","docs/otd-documentation-preflight.md"),
    function(p)paste(readLines(p),collapse="\n"),"")
  for(d in docs)for(token in c("Q3/Q4","APPROVED_DOCUMENTATION_PREFLIGHT_ONLY","Q1/Q2/Q6/Q8/Q9/Q10/Q11",
    "PENDING_USER_APPROVAL","Q5/Q7/Q12","APPROVED_SPECIFICATION_FEASIBILITY_ONLY",
    "NOT_IMPLEMENTED","NOT_EVALUATED","BLOCKED_PENDING_RIGHTS_REVIEW"))stopifnot(grepl(token,d,fixed=TRUE))
  context<-paste(readLines("PROJECT_CONTEXT.md"),collapse="\n")
  for(token in c("structural, sporadic, and eligibility-related","Mean imputation","missingness indicator",
    "predictive mean matching","chronological training sample or resample only","Never impute match outcomes",
    "Do not preselect mean imputation or PMM","Surface-adjusted Elo normally should not require statistical imputation",
    "Brier score","log loss","No imputation","2024","2025","not implemented"))stopifnot(grepl(token,context,fixed=TRUE))
  old<-system2("git",c("show",paste0(otd_baseline(),":docs/tennis-chronology-path-decision-brief.md")),stdout=TRUE)
  stopifnot(identical(readLines("docs/tennis-chronology-path-decision-brief.md"),old))
  invisible(TRUE)
}
if(sys.nframe()==0L)test_otd_documentation(!"--fixtures-only"%in%commandArgs(TRUE))
