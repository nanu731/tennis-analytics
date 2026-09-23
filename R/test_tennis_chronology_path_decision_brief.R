# Read-only documentation/evidence contracts. No acquisition module is sourced.
validate_tennis_chronology_path_brief <- function(lines) {
  need <- function(ok,reason) if(!isTRUE(ok)) stop(reason,call.=FALSE)
  text <- paste(lines,collapse="\n")
  paths <- grep("^## Path [1-4] —",lines,value=TRUE)
  need(identical(sub("^## Path ([1-4]).*","\\1",paths),as.character(1:4)),
    "Each path must appear once in order")
  decisions <- grep("^\\| Q[0-9]+ \\|",lines,value=TRUE)
  need(identical(sub("^\\| (Q[0-9]+) \\|.*","\\1",decisions),paste0("Q",1:12)),
    "Missing, reordered or duplicate Q decision")
  need(all(grepl(" | PENDING_USER_APPROVAL |",decisions,fixed=TRUE)) &&
    all(endsWith(decisions," | PENDING_USER_APPROVAL |")),"Every Q decision must remain pending")
  required <- c(
    "OFFLINE_DECISION_BRIEF; NOT_ADOPTED", "PROHIBITED", "AMBIGUOUS_STOP_REQUIRED",
    "D1–D13 remain ADOPTED", "A5–A8 remain PENDING_USER_APPROVAL",
    "Provider contact: UNSENT; contact authorization: FALSE", "New URL access: FALSE",
    "unused slot, order-of-play, Stages B/C/D, OTD, archives and searches remain unauthorized",
    "Operational chronology: NOT_IMPLEMENTED; event batching: NOT_IMPLEMENTED",
    "canonical population: NOT_IMPLEMENTED; chronology/model readiness: BLOCKED",
    "event admission: NOT_EVALUATED; modeling authorization: FALSE",
    "publication: BLOCKED_PENDING_RIGHTS_REVIEW", "No recommendation constitutes adoption",
    "None is a fresh provider, license or payload verification",
    "not a verified research-permission address", "Silence, automated replies",
    "Current authorization for all four requests is zero",
    "Earlier-round results from the same event must not enter later-round predictions",
    "`tourney_date` remains an event grouping/boundary label, never an actual match date",
    "Retirements, partial retirement statistics and walkovers remain excluded",
    "Require `A_j < C_e`", "Unknown availability cannot be cured by adding an arbitrary lag",
    "Calendar windows and inactivity remain blocked without reliable dates",
    "Shared-player updates generally do not", "K, minimum sample size and warm-up coverage are unselected",
    "not evidence of beating standard match-sequential surface Elo",
    "All Q1–Q12 remain PENDING_USER_APPROVAL", "No response means no authorization")
  for(value in required) need(grepl(value,text,fixed=TRUE),paste("Missing boundary:",value))
  invisible(required)
}

test_tennis_chronology_path_decision_brief <- function() {
  path <- "docs/tennis-chronology-path-decision-brief.md"
  lines <- readLines(path,warn=FALSE)
  required <- validate_tennis_chronology_path_brief(lines)
  count <- 0L
  reject <- function(x) {
    stopifnot(inherits(tryCatch(validate_tennis_chronology_path_brief(x),error=identity),"error"))
    count <<- count+1L
  }
  for(value in required) reject(gsub(value,"INVALID",lines,fixed=TRUE))
  for(id in c("Q1","Q12")) {
    bad <- lines; i <- grep(paste0("^\\| ",id," \\|"),bad)
    bad[i] <- sub("PENDING_USER_APPROVAL","APPROVED",bad[i],fixed=TRUE);reject(bad)
  }
  reject(c(lines,"| Q1 | Duplicate | PENDING_USER_APPROVAL |"))
  reject(lines[!grepl("^## Path 4 —",lines)])
  reject(c(lines,"## Path 1 — Duplicate"))

  # Adopted decisions and separately bounded acquisition authority are current.
  source("R/test_montreal_chronology_policy.R",local=TRUE)
  validate_montreal_chronology_policy(readLines("docs/wta-2021-montreal-chronology-policy.md"))
  plan <- readLines("docs/wta-2021-montreal-chronology-acquisition-plan.md")
  heads <- grep("^### A[0-9]+\\.",plan);ends <- c(heads[-1]-1L,length(plan))
  stopifnot(identical(sub("^### (A[0-9]+)\\..*","\\1",plan[heads]),paste0("A",1:10)))
  for(i in 5:8) stopifnot(sum(plan[heads[i]:ends[i]]==
    "Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.")==1L)
  stopifnot(sum(plan=="Approval: APPROVED_STAGE_A_ONLY; acquisition implemented: STAGE_A_ONLY.")==6L)

  # These are saved records, not a new audit or a reconstructed grant.
  manifest <- read.csv("data/pilot/development-2021/montreal-chronology-acquisition/stage-a-manifest.csv")
  stopifnot(nrow(manifest)==1L,manifest$http_status==200,
    manifest$rights=="PROHIBITED",manifest$retention=="AMBIGUOUS_STOP_REQUIRED",
    !manifest$another_request_authorized)
  dispositions <- read.csv("data/pilot/development-2021/montreal-chronology-evidence/dispositions.csv")
  stopifnot(nrow(dispositions)==55L,!anyDuplicated(dispositions$source_audit_id),
    sum(dispositions$classification=="normally_completed")==49L,
    sum(dispositions$classification=="retirement")==5L,
    sum(dispositions$classification=="walkover")==1L)
  status <- paste(readLines("docs/status.md"),collapse="\n")
  stopifnot(grepl("All 55 source rows link one-to-one",status,fixed=TRUE),
    grepl("All 55 non-bye records have unique dispositions",status,fixed=TRUE))

  # Reject accidental introduction of transport/process calls into this test.
  # Reading this local script's syntax does not evaluate the parsed expressions.
  calls <- function(x) {
    if(is.call(x)) c(if(is.symbol(x[[1L]])) as.character(x[[1L]]),
      unlist(lapply(as.list(x)[-1L],calls),use.names=FALSE))
    else if(is.expression(x) || is.pairlist(x)) unlist(lapply(x,calls),use.names=FALSE)
    else character()
  }
  forbidden <- c("system","system2","url","socketConnection","download.file",
    "msa_attempt","msa_curl","mr_request","annual_2021_request")
  stopifnot(!any(calls(parse(file="R/test_tennis_chronology_path_decision_brief.R")) %in% forbidden))
  message("Phase 1Q documentation contracts passed; ",count,
    " invalid-document mutations rejected; current policy/plan, saved rights and 55-record state verified.")
  invisible(TRUE)
}
if(sys.nframe()==0L) test_tennis_chronology_path_decision_brief()
