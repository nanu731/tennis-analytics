# Documentation contracts only: no chronology processing or acquisition.
validate_montreal_chronology_policy <- function(lines) {
  need <- function(ok, reason) if (!isTRUE(ok)) stop(reason,call.=FALSE)
  text <- paste(lines,collapse="\n")
  has <- function(value) grepl(value,text,fixed=TRUE)
  headers <- grep("^### D[0-9]+\\.",lines)
  need(identical(sub("^### (D[0-9]+)\\..*","\\1",lines[headers]),paste0("D",1:13)),
    "Policy must contain each decision exactly once")
  end <- c(headers[-1]-1,length(lines))
  for(i in seq_along(headers)) {
    block <- lines[headers[i]:end[i]]
    need(sum(block=="Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.")==1,
      paste("Approval/implementation mismatch for",i))
  }
  required <- c("Policy version 1.0.0: ADOPTED", "last-K versus elapsed-calendar-time windows remain UNSELECTED",
    "default is BLOCK_DEPENDENT_RESULT", "No arbitrary tie-break is allowed",
    "daily batching is CANDIDATE_ONLY, NOT_ACTIVATED",
    "verified date semantics, a defined time basis, validation and separate approval",
    "USE_SPECIFIC_DEPENDENCY_GATE", "Universal exact timestamps are not required",
    "Safe evidence is required for every dependency", "PLANNING_ONLY",
    "No URL requests, downloads, scraping, hidden API use, browser automation or new raw-data files",
    "Retirements, their partial statistics and walkovers remain excluded",
    "Missing or conflicting evidence fails closed", "before the applicable prespecified cutoff",
    "Source tourney_date, event windows, retrieval times, CSV row order, match_num",
    "do not order unrelated matches or establish calendar dates",
    "Keep original start, suspension, resumption, final completion and availability separate",
    "corroboration for primary use", "event-specific evidence audits plus explicit cross-event chronology",
    "| Operational chronology | NOT_IMPLEMENTED |", "| Chronology/model readiness | BLOCKED |",
    "| Event admission | NOT_EVALUATED |", "| Canonical analytical population | NOT_IMPLEMENTED |",
    "| Modeling authorization | FALSE |", "| Publication | BLOCKED_PENDING_RIGHTS_REVIEW |",
    "5156ac2c34972bbef4584df62667f0bfda6f44c0", "6e383568aaac82d235c2a4f13f6683fb09c3545a")
  for(value in required) need(has(value),paste("Missing adopted requirement:",value))
  invisible(TRUE)
}

test_montreal_chronology_policy <- function() {
  path <- "docs/wta-2021-montreal-chronology-policy.md"
  lines <- readLines(path);validate_montreal_chronology_policy(lines)
  reject <- function(x) stopifnot(inherits(tryCatch(validate_montreal_chronology_policy(x),error=identity),"error"))
  reject(c(lines,"### D1. Duplicate"))
  reject(sub("Approval: APPROVED;","Approval: PENDING_USER_APPROVAL;",lines,fixed=TRUE))
  reject(sub("operational chronology: NOT_IMPLEMENTED.","operational chronology: IMPLEMENTED.",lines,fixed=TRUE))
  mutations <- c("remain UNSELECTED", "BLOCK_DEPENDENT_RESULT", "CANDIDATE_ONLY, NOT_ACTIVATED",
    "Universal exact timestamps are not required", "PLANNING_ONLY", "every dependency",
    "| Chronology/model readiness | BLOCKED |", "| Modeling authorization | FALSE |")
  for(value in mutations) reject(gsub(value,"INVALID",lines,fixed=TRUE))
  stopifnot(!file.exists("docs/wta-2021-montreal-chronology-policy-proposal.md"))
  # Historical proposal remains recoverable and keeps the original pending state.
  ref <- "5156ac2c34972bbef4584df62667f0bfda6f44c0:docs/wta-2021-montreal-chronology-policy-proposal.md"
  historic <- system2("git",c("show",shQuote(ref)),stdout=TRUE)
  stopifnot(is.null(attr(historic,"status")),
    sum(historic=="Approval: PENDING_USER_APPROVAL; implemented: FALSE.")==13)
  decisions <- read.csv("data/pilot/development-2021/montreal-chronology-evidence/decisions.csv")
  summary <- read.csv("data/pilot/development-2021/montreal-chronology-evidence/summary.csv")
  stopifnot(nrow(decisions)==13,all(decisions$status=="PROPOSED_NOT_APPROVED"),
    all(decisions$approval=="PENDING_USER_APPROVAL"),!any(decisions$implemented),
    summary$chronology_policy=="NOT_ADOPTED",summary$chronology_model_readiness=="BLOCKED",
    summary$actual_start_dates==0,summary$completion_dates==0,!summary$modeling_authorized)
  message("Policy adoption contracts passed; 11 invalid-document mutations rejected; historical proposal/output states preserved.")
  invisible(TRUE)
}
if(sys.nframe()==0L)test_montreal_chronology_policy()
