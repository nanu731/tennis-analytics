# Entirely offline. All simulated responses are synthetic temporary fixtures.
source("R/acquire_montreal_chronology_stage_a.R")
test_montreal_chronology_stage_a <- function(check_repository=TRUE) {
  original<-msa_curl
  assign("msa_curl",function(...)stop("LIVE NETWORK FORBIDDEN IN TESTS"),envir=.GlobalEnv)
  on.exit(assign("msa_curl",original,envir=.GlobalEnv),add=TRUE)
  count<-0L;calls<-0L;roots<-character()
  pass<-function(label){count<<-count+1L;message("PASS: ",label)}
  reject<-function(expr,label){stopifnot(inherits(tryCatch(force(expr),error=identity),"error"));pass(label)}
  root<-function(){r<-tempfile("stage-a-fixture-");dir.create(r);roots<<-c(roots,r);r}
  on.exit(unlink(roots,recursive=TRUE),add=TRUE)
  fake<-function(http="200",html="<html><title>Terms and conditions</title>Fixture only</html>",
    redirect=FALSE,exit=0L,fail=FALSE) function(url,body,headers) {
      calls<<-calls+1L;msa_allow(url)
      if(fail)stop("Synthetic connection failure")
      writeLines(c(paste0("HTTP/2 ",http),"Content-Type: text/html",if(redirect)"Location: https://unrequested.invalid/"),headers)
      writeChar(html,body,eos=NULL,useBytes=TRUE)
      list(exit=exit,error=if(exit!=0L)"Synthetic transport failure" else "")
    }
  call<-function(r,i=1L,transport=fake())msa_attempt(msa_urls()[i],root=r,transport=transport)
  approve<-function(r)msa_review(1L,msa_supported(),msa_supported(),"Synthetic permission fixture only",root=r)
  r<-root();before<-calls
  reject(call(r,2L),"second request before first rejected")
  bad<-c(paste0(msa_urls(),"?x=1"),paste0(msa_urls(),"/"),sub("www\\.","",msa_urls()),
    sub("https:","http:",msa_urls()),sub("2021","2025",msa_urls()[2]),
    "https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS007",
    "https://www.wtatennis.com/api/scores","https://www.wtatennis.com/search",
    "https://web.archive.org/","https://nationalbankopen.com/",
    "https://github.com/ryantjx/tennis-match-data")
  for(url in bad)reject(msa_attempt(url,root=r,transport=fake()),paste("URL rejected:",url))
  stopifnot(calls==before);pass("all URL/order rejections occur before transport")
  args<-msa_curl_args(msa_urls()[1],"body","headers")
  stopifnot(args[1]=="--disable",args[match("--request",args)+1]=="GET",
    args[match("--max-redirs",args)+1]=="0",args[match("--retry",args)+1]=="0",
    "--no-location" %in% args,!any(c("--head","-I","-L","--location","--retry-all-errors") %in% args),
    sum(args %in% msa_urls())==1)
  pass("transport disables curl config, redirects and retries; one GET target")
  for(state in c("PROHIBITED","AMBIGUOUS_STOP_REQUIRED","UNAVAILABLE_OR_UNREADABLE")) {
    r<-root();call(r);msa_review(1L,state,state,"Synthetic negative review",root=r)
    before<-calls;reject(call(r,2L),paste("rights gate:",state));stopifnot(calls==before)
  }
  r<-root();call(r);msa_review(1L,msa_supported(),"AMBIGUOUS_STOP_REQUIRED","Retention unresolved",root=r)
  reject(call(r,2L),"retention independently blocks request two")
  r<-root();call(r);reject(call(r,2L),"readable terms without explicit review do not grant access")
  for(kind in c("failure","redirect","http403","login","bot","unreadable","partial")) {
    r<-root();transport<-switch(kind,failure=fake(fail=TRUE),redirect=fake("302",redirect=TRUE),
      http403=fake("403"),login=fake(html="<html><title>Login</title></html>"),
      bot=fake(html="<html><title>Just a moment</title>verify you are human</html>"),
      unreadable=fake(html="not html"),partial=fake(exit=28L))
    before<-calls;call(r,transport=transport);x<-msa_load(r)
    stopifnot(length(x)==1,calls==before+1,x[[1]]$attempt$ordinal==1L,!msa_can_proceed(x[[1]]))
    reject(call(r,2L),paste(kind,"blocks request two"));reject(call(r),paste(kind,"cannot retry"))
    stopifnot(calls==before+1)
    if(kind %in% c("failure","redirect","http403","partial")) {
      stopifnot(x[[1]]$response$local_path=="",x[[1]]$response$sha256=="",
        x[[1]]$response$retrieved_at_utc=="",!file.exists(msa_raw(r,1L)))
      pass(paste(kind,"consumes one attempt without invented retrieval"))
    }
    if(kind=="redirect")stopifnot(x[[1]]$response$redirect,
      x[[1]]$response$redirect_target=="https://unrequested.invalid/")
  }
  r<-root();call(r);approve(r)
  reject(msa_audit(r,TRUE),"open positive gate cannot publish a final manifest")
  call(r,2L)
  msa_review(2L,msa_supported(),msa_supported(),"Synthetic schedule-only page; stop at ceiling",root=r)
  m<-msa_audit(r,TRUE);before<-calls
  stopifnot(nrow(m)==2,!any(m$another_request_authorized),m$attempts_remaining[2]==0)
  reject(call(r),"third request rejected");reject(call(r,2L),"second URL retry rejected");stopifnot(calls==before)
  paths<-list.files(r,recursive=TRUE,full.names=TRUE);snap<-function()list(
    hashes=vapply(paths,pilot_sha256,""),size=file.info(paths)$size,mtime=file.info(paths)$mtime)
  saved<-snap();stopifnot(identical(msa_audit(r,TRUE),m),identical(saved,snap()),calls==before)
  pass("validated cached rerun preserves bytes and times with zero requests")
  writeLines("changed",msa_raw(r,1L));reject(msa_audit(r,TRUE),"changed raw bytes fail before report")
  stop_review<-function(r)msa_review(1L,"PROHIBITED","AMBIGUOUS_STOP_REQUIRED","Synthetic stop",root=r)
  r<-root();call(r);stop_review(r);msa_audit(r,TRUE)
  writeLines(strrep("0",64),paste0(msa_file(r,"response",1L),".sha256"))
  reject(msa_audit(r,TRUE),"changed fingerprint fails before report")
  r<-root();call(r);stop_review(r);msa_audit(r,TRUE)
  mf<-file.path(msa_paths(r)$audit,"stage-a-manifest.csv");write("tampered",mf,append=TRUE)
  reject(msa_audit(r,TRUE),"changed manifest fails before success")
  r<-root();call(r);stop_review(r);msa_audit(r,TRUE);dir.create(file.path(r,"docs"))
  writeLines(paste0("Manifest SHA-256: `",strrep("0",64),"`."),file.path(r,"docs/wta-2021-montreal-chronology-stage-a.md"))
  reject(msa_audit(r,TRUE),"tracked report fingerprint binds saved manifest")
  unlink(file.path(msa_paths(r)$audit,"stage-a-manifest.csv"))
  reject(msa_audit(r,TRUE),"missing reviewed manifest cannot be silently reconstructed")
  r<-root();dir.create(file.path(r,"docs"))
  writeLines("Manifest SHA-256: `previously-reviewed-fixture`.",file.path(r,"docs/wta-2021-montreal-chronology-stage-a.md"))
  before<-calls;reject(call(r),"missing reviewed cache cannot reset request budget");stopifnot(calls==before)
  r<-root();dir.create(msa_paths(r)$audit,recursive=TRUE)
  msa_seal(list(phase="1P_STAGE_A",approvals="A1,A2,A3,A4,A9,A10",ordinal=1L,url=msa_urls()[1],
    method="GET",request_at_utc="synthetic-reserved"),msa_file(r,"attempt",1L))
  reject(call(r),"interrupted reservation cannot retry");reject(call(r,2L),"interrupted reservation blocks continuation")
  reject(msa_audit(r,TRUE),"interrupted attempt cannot write success manifest")
  html<-paste0('<html><link rel="canonical" href="',msa_urls()[2],
    '"><h1>Montreal 2021</h1>Scheduled 13:00. Current tournament 2026.',
    '<a href="/literal-document.pdf">Schedule</a><script src="/unrequested.js"></script></html>')
  o<-msa_page_observations(html)
  stopifnot(o$canonical_matches,"/literal-document.pdf" %in% o$literal_links,o$links_followed==0L,
    o$historical_content=="NOT_VERIFIED",o$actual_start=="NOT_VERIFIED",o$completion=="NOT_VERIFIED",
    o$result_availability=="NOT_VERIFIED",!o$schedule_is_actual)
  unrelated<-msa_page_observations('<html><h1>Montreal 2026</h1><a href="/current.pdf">Today</a></html>')
  stopifnot(!unrelated$canonical_matches,unrelated$historical_content=="NOT_VERIFIED")
  pass("literal links never followed; historical header/current widgets and schedules cannot prove actual chronology")
  if(check_repository) {
    plan<-readLines("docs/wta-2021-montreal-chronology-acquisition-plan.md")
    heads<-grep("^### A[0-9]+\\.",plan);ends<-c(heads[-1]-1,length(plan))
    for(i in 1:10)stopifnot(sum(plan[heads[i]:ends[i]]==if(i %in% c(1:4,9:10))
      "Approval: APPROVED_STAGE_A_ONLY; acquisition implemented: STAGE_A_ONLY." else
      "Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.")==1)
    stopifnot(any(grepl("Stages B, C and D remain UNAUTHORIZED",plan,fixed=TRUE)))
    pass("six Stage A approvals; A5–A8 pending; later stages unauthorized")
    x<-msa_audit();paths<-c(list.files(msa_paths()$audit,full.names=TRUE),list.files(msa_paths()$raw,full.names=TRUE))
    for(path in paths)stopifnot(system2("git",c("check-ignore","-q",shQuote(path)))==0L,
      !length(system2("git",c("ls-files","--",shQuote(path)),stdout=TRUE)))
    stopifnot(!any(grepl("2025",paths)),all(x$url %in% msa_urls()),!any(x$another_request_authorized))
    pass("real Stage A provenance validated; raw/audit outputs ignored and untracked; no 2025 target")
  }
  message(count," Stage A offline checks passed; live transport was blocked throughout.")
  invisible(count)
}
if(sys.nframe()==0L)test_montreal_chronology_stage_a(!"--fixtures-only" %in% commandArgs(TRUE))
