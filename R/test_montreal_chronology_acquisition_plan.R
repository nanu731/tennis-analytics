# Offline planning checks: URL strings are never requested or written as data.
validate_montreal_chronology_plan <- function(lines) {
  need <- function(ok,reason) if(!isTRUE(ok))stop(reason,call.=FALSE)
  text <- paste(lines,collapse="\n")
  groups <- grep("^### G[0-9]+\\.",lines,value=TRUE)
  need(identical(sub("^### (G[0-9]+)\\..*","\\1",groups),paste0("G",1:7)),"Missing/duplicate source group")
  heads <- grep("^### A[0-9]+\\.",lines)
  need(identical(sub("^### (A[0-9]+)\\..*","\\1",lines[heads]),paste0("A",1:10)),"Missing/duplicate acquisition decision")
  ends <- c(heads[-1]-1,length(lines))
  for(i in seq_along(heads))need(sum(lines[heads[i]:ends[i]]==
    "Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.")==1,"Acquisition decision changed")
  required <- c("Plan version 0.1.0: PROPOSED_NOT_APPROVED", "Acquisition authorization: FALSE",
    "45 remaining coded results = 42 completed + three retirements", "LS013 must not be synthesized",
    "two direct public-page GET attempts / two response files",
    "three new exact document requests/files total across G3–G5",
    "42 completed-match pages plus seven additional daily timing documents: 49 attempts/files maximum",
    "four documentation requests plus one separately approved scoped payload",
    "No stage or unused budget carries forward automatically",
    "Dates for all matches would not automatically establish historical result availability",
    "independence is UNESTABLISHED", "No capture identifier, index URL or archived resource is verified",
    "Do not fetch an all-season asset containing 2025 to filter it afterward",
    "Player-relative ordinal Elo", "Same-day sequential Elo", "Daily-batched Elo", "Last-K Four Factors",
    "Elapsed-time histories", "Inactivity adjustments", "Cross-event/overlapping histories",
    "acquisition performed: NONE", "chronology/model readiness is BLOCKED",
    "publication is BLOCKED_PENDING_RIGHTS_REVIEW", "modeling authorization is FALSE")
  for(value in required)need(grepl(value,text,fixed=TRUE),paste("Missing plan boundary:",value))
  invisible(TRUE)
}

test_montreal_chronology_acquisition_plan <- function() {
  # Preserve all Phase 1O proposal assertions against its exact committed text.
  # Phase 1P separately tests current Stage A approval and request artifacts.
  ref<-"10816b9f839d6e501674cc6efe3d2053a7826d5f:docs/wta-2021-montreal-chronology-acquisition-plan.md"
  lines<-system2("git",c("show",shQuote(ref)),stdout=TRUE)
  stopifnot(is.null(attr(lines,"status")))
  validate_montreal_chronology_plan(lines)
  reject<-function(x)stopifnot(inherits(tryCatch(validate_montreal_chronology_plan(x),error=identity),"error"))
  reject(c(lines,"### A1. Duplicate"));reject(c(lines,"### G1. Duplicate"))
  for(value in c("Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.",
    "Acquisition authorization: FALSE", "two direct public-page GET attempts / two response files",
    "No stage or unused budget carries forward automatically", "independence is UNESTABLISHED",
    "acquisition performed: NONE"))reject(gsub(value,"INVALID",lines,fixed=TRUE))
  # Read only previously audited local tables. Empty CSV fields mean unknown.
  get<-function(path)read.csv(path,na.strings=c("","NA"),stringsAsFactors=FALSE)
  links<-get("data/pilot/development-2021/montreal-inventory/reconciliation-links.csv")
  d<-get("data/pilot/development-2021/montreal-chronology-evidence/dispositions.csv")
  refs<-get("data/manifests/montreal-reference-files.csv")
  stopifnot(nrow(links)==55,!anyDuplicated(links$source_audit_id),
    !anyDuplicated(links$official_code[!is.na(links$official_code)]))
  d<-d[match(links$source_audit_id,d$source_audit_id),]
  stopifnot(identical(links$official_code,d$official_code))
  codes<-links$official_code[!is.na(links$official_code)]
  saved<-refs$match_code[!is.na(refs$match_code)]
  remaining<-setdiff(codes,saved)
  stopifnot(length(codes)==54,length(saved)==9,length(remaining)==45,
    sum(d$classification[d$official_code %in% remaining]=="normally_completed")==42,
    sum(d$classification[d$official_code %in% remaining]=="retirement")==3,
    all(d$classification[is.na(d$official_code)]=="walkover"),!"LS013" %in% remaining,
    setequal(saved,c(sprintf("LS%03d",1:7),"LS042","LS049")))
  urls<-paste0("https://www.wtatennis.com/tournaments/806/montreal/2021/scores/",sort(remaining))
  stopifnot(length(unique(urls))==45,all(grepl("/2021/scores/LS[0-9]{3}$",urls)))
  # A URL in saved markup is evidence of a link only, never live availability.
  target<-"https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play"
  for(id in c("overview","draw_html")) {
    html<-paste(readLines(refs$local_path[refs$reference_id==id],warn=FALSE),collapse="\n")
    stopifnot(grepl(paste0('href="',target,'"'),html,fixed=TRUE))
  }
  source("R/acquire_montreal_chronology_stage_a.R")
  current<-msa_audit()
  stopifnot(nrow(current)==1,current$rights=="PROHIBITED",!current$another_request_authorized)
  message("Historical plan contracts passed; eight invalid-document mutations rejected; 45/42/3 scope and two local links verified; current authorized Stage A artifacts validated offline.")
  invisible(TRUE)
}
if(sys.nframe()==0L)test_montreal_chronology_acquisition_plan()
