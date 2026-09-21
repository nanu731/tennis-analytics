# Offline evidence contracts; no ordering method or model is executed.
source("R/audit_montreal_chronology_evidence.R")

test_montreal_chronology_evidence <- function() {
  requests <- c("mr_request","annual_2021_request"); saved <- mget(requests,envir=.GlobalEnv)
  on.exit(for(name in requests) assign(name,saved[[name]],envir=.GlobalEnv),add=TRUE)
  for(name in requests) assign(name,function(...)stop("Network forbidden in Phase 1N"),envir=.GlobalEnv)
  results <- character()
  pass <- function(name) { results <<- c(results,name);message("PASS: ",name) }
  reject <- function(name,expr) { e <- tryCatch(force(expr),error=identity);stopifnot(inherits(e,"error"));pass(name) }
  input <- mnc_load();mnc_validate_inputs(input)
  protected <- unique(c(input$base$evidence$refs$local_path,input$base$evidence$source$provenance$path,
    names(mro_pins()),mro_path(),list.files(mmc_dir(),full.names=TRUE),list.files(mji_dir(),full.names=TRUE),
    list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE)))
  before <- mrf_snapshot(protected); original <- serialize(input,NULL,version=3)
  o <- mnc_derive(input);s <- o$summary;d <- o$dispositions
  stopifnot(nrow(d)==55,!anyDuplicated(d$source_audit_id),s$normally_completed==49,s$retirements==5,s$walkovers==1,
    sum(d$included_in_completed_denominator)==49,
    !any(d$included_in_completed_denominator[d$classification %in% c("retirement","walkover")]))
  pass("all 55 dispositions preserve the Phase 1M 49/5/1 eligibility split")
  stopifnot(s$only_event_level_dates==46,s$saved_match_page_dates==9,s$completed_with_page_dates==7,
    s$completed_only_event_dates==42,setequal(o$match_page_observations$official_code,mro_targets()$code),
    all(is.na(d$published_start_date[d$published_date_role=="no_saved_match_page"])),
    all(is.na(d$published_end_date[d$published_date_role=="no_saved_match_page"])))
  pass("only the exact nine saved pages contribute published dates; 46 absent pages inherit nothing")
  absent <- c("verified_scheduled_date","scheduled_time","actual_start_date","actual_start_time","completion_date",
    "completion_time","suspension_interval","resumption_time","result_available_at","timezone","exact_total_order")
  stopifnot(all(vapply(d[absent],function(z)all(is.na(z)),TRUE)),all(d$source_event_week_date=="20210809"),
    all(nzchar(d$timing_missing_reason)),all(o$match_page_observations$precision=="day"),
    all(o$match_page_observations$timezone_state=="NOT_ESTABLISHED"))
  pass("event-week and retrieval timestamps never fill actual, scheduled, completion, timezone or within-day fields")
  stopifnot(identical(o$event_observations$value,c("20210809","Aug 9 - Aug 15, 2021","August 7-15 2021")),
    all(o$match_page_observations$published_status=="http://schema.org/EventScheduled"),
    all(o$match_page_observations$finished_card),sum(d$ls007_date_difference)==1,
    d$published_start_date[which(d$official_code=="LS007")]=="2021-08-14")
  pass("event windows, all nine scheduled/finished differences and LS007 remain distinct unresolved observations")
  stopifnot(s$player_relative_edges==54,s$completed_to_completed_edges==45,s$players_with_accounted_chains==56,
    s$completed_with_within_event_chain_evidence==49,s$same_published_day_edges==1,s$published_date_reversals==0,
    all(o$players$within_event_chain_accounted),!any(o$edges$operational_order_implemented))
  same <- o$edges[o$edges$same_published_day,]
  stopifnot(same$from_audit_id=="sackmann:WTA:2021-806:295",same$to_audit_id=="sackmann:WTA:2021-806:299")
  pass("54 corroborated progression edges; 45 completed endpoints; one LS007-to-LS003 same-published-day edge")
  raw <- input$base$evidence$source$selected$raw
  ids <- paste0("sackmann:WTA:2021-806:",raw$match_num)
  for(i in seq_len(nrow(o$edges))) {
    e <- o$edges[i,]; a <- raw[match(e$from_audit_id,ids),]; b <- raw[match(e$to_audit_id,ids),]
    stopifnot(e$player_id==a$winner_id,e$player_id %in% c(b$winner_id,b$loser_id),
      match(b$round,mji_rounds())==match(a$round,mji_rounds())+1)
  }
  pass("every edge shares exactly its advancing player and valid next bracket round; unrelated results are unordered")
  shuffled <- input
  shuffled$base$evidence$source$selected$raw <- raw[rev(seq_len(nrow(raw))),]
  stopifnot(identical(o,mnc_derive(shuffled)))
  pass("source-row permutation leaves every disposition, observation and partial-order relation unchanged")
  # Renumber identifiers only in a synthetic graph fixture, leaving bracket keys
  # and player identities unchanged; production fingerprint checks forbid this edit.
  bad <- input$base; new_ids <- paste0("synthetic:",rev(seq_along(ids)))
  bad$inventory$links$source_audit_id <- new_ids[match(bad$inventory$links$source_audit_id,ids)]
  # mnc_edges forms source audit IDs with the namespace below; give its raw rows
  # reversed arbitrary match numbers and map the synthetic identifiers consistently.
  nums <- as.character(rev(seq_along(ids)))
  new_ids <- paste0("sackmann:WTA:2021-806:",nums)
  bad$evidence$source$selected$raw$match_num <- nums
  bad$inventory$links$source_audit_id <- new_ids[match(input$base$inventory$links$source_audit_id,ids)]
  e <- mnc_edges(bad)
  e$from_audit_id <- ids[match(e$from_audit_id,new_ids)];e$to_audit_id <- ids[match(e$to_audit_id,new_ids)]
  e <- e[order(e$player_id,e$from_audit_id,e$to_audit_id),];rownames(e)<-NULL
  stopifnot(identical(e,mnc_edges(input$base)))
  pass("arbitrary source match numbers identify records but cannot select precedence")

  mutations <- list(
    missing_fingerprint=function(x){x$base$evidence$refs$sha256[1]<-NA_character_;x},
    changed_fingerprint=function(x){x$base$evidence$refs$sha256[1]<-"changed";x},
    identity=function(x){x$base$inventory$identities$state[1]<-"ambiguous";x},
    round=function(x){x$base$inventory$links$round[1]<-"invalid";x},
    winner=function(x){x$base$inventory$links$source_winner[1]<-"wrong";x},
    score=function(x){x$base$inventory$links$source_score[1]<-"wrong";x},
    locator=function(x){x$timing$pages$metadata_locator[1]<-NA_character_;x},
    published_date=function(x){x$timing$pages$published_start_date[1]<-"2021-08-16";x},
    event_date=function(x){x$timing$events$value[1]<-"20210810";x},
    retrieval_time=function(x){x$timing$pages$retrieved_at_utc[1]<-"2021-08-09T00:00:00Z";x},
    absent_page=function(x){x$timing$pages<-x$timing$pages[-1,];x},
    unauthorized_page=function(x){x$timing$pages$official_code[1]<-"LS008";x})
  for(name in names(mutations)) reject(paste("fresh-evidence boundary rejects",name),mnc_validate_inputs(mutations[[name]](input),input))
  bad <- input;bad$timing$pages <- rbind(bad$timing$pages,bad$timing$pages[1,])
  reject("duplicate match-date observations fail",mnc_derive(bad))
  bad <- input;bad$timing$events <- rbind(bad$timing$events,bad$timing$events[1,])
  reject("duplicate event-window observations fail",mnc_derive(bad))
  bad <- input;bad$timing$pages$published_start_date[bad$timing$pages$official_code=="LS004"] <- "2021-08-16"
  reject("published date contradicting its player's later-round date fails closed",mnc_derive(bad))
  bad <- input$base;bad$inventory$html$winner[1]<-"unrelated player"
  reject("contradictory bracket progression cannot create edges",mnc_edges(bad))
  html <- anomaly_html(input$base$evidence$refs$local_path[input$base$evidence$refs$reference_id=="LS007"])
  reject("duplicate exact match metadata blocked",mnc_match_metadata(paste(html,html),"LS007"))
  reject("another page cannot substitute for a missing page",mnc_match_metadata(html,"LS008"))
  changed <- sub('"startDate": "2021-08-14"','"startDate": "2021-08-14", "startDate": "2021-08-13"',html,fixed=TRUE)
  reject("duplicate conflicting date keys blocked",mnc_match_metadata(changed,"LS007"))
  changed <- sub('"startDate": "2021-08-14"','"startDate": "2021-08-14T00:00:00Z"',html,fixed=TRUE)
  reject("new timestamp precision requires review, never silent promotion",mnc_match_metadata(changed,"LS007"))
  for(field in c("actual_start_date","completion_time","timezone","exact_total_order")) {
    bad <- o;bad$dispositions[[field]][1] <- "invented"
    reject(paste("reject derived timing invention",field),mnc_validate_result(bad,input))
  }
  bad<-o;bad$edges<-rbind(bad$edges,bad$edges[1,])
  reject("duplicate derived precedence edge rejected",mnc_validate_result(bad,input))
  bad<-o;bad$decisions$approval[1]<-"APPROVED";bad$decisions$implemented[1]<-TRUE
  reject("proposal cannot be promoted to approval or implementation",mnc_validate_result(bad,input))
  stopifnot(nrow(o$decisions)==13,all(o$decisions$status=="PROPOSED_NOT_APPROVED"),
    all(o$decisions$approval=="PENDING_USER_APPROVAL"),!any(o$decisions$implemented),
    all(o$options$fully_sufficient_completed_records==0),all(o$options$model_readiness=="BLOCKED"),
    !s$modeling_authorized,s$chronology_policy=="NOT_ADOPTED",s$event_admission=="NOT_EVALUATED",
    s$canonical_analytical_population=="NOT_IMPLEMENTED",s$tour_season_gate=="NOT_TESTED",
    s$publication=="BLOCKED_PENDING_RIGHTS_REVIEW")
  pass("all 13 decisions remain proposed; narrow evidence coverage never implies model readiness")
  # The proposal was renamed on adoption; test the exact historical Git object.
  proposal_ref <- "5156ac2c34972bbef4584df62667f0bfda6f44c0:docs/wta-2021-montreal-chronology-policy-proposal.md"
  stopifnot(identical(system2("git",c("rev-parse",shQuote(proposal_ref)),stdout=TRUE),
    "6e383568aaac82d235c2a4f13f6683fb09c3545a"))
  proposal <- system2("git",c("show",shQuote(proposal_ref)),stdout=TRUE)
  stopifnot(is.null(attr(proposal,"status")))
  stopifnot(sum(grepl("^### D[0-9]+\\.",proposal))==13,
    sum(grepl("Approval: PENDING_USER_APPROVAL; implemented: FALSE",proposal,fixed=TRUE))==13,
    any(grepl("PROPOSED_NOT_APPROVED",proposal,fixed=TRUE)))
  pass("written proposal has exactly 13 numbered unapproved, unimplemented decisions")
  stopifnot(identical(original,serialize(input,NULL,version=3)),identical(o,mnc_derive(input)),
    identical(before,mrf_snapshot(protected)),!any(grepl("2025",protected,fixed=TRUE)),
    setequal(input$base$evidence$source$provenance$year,c(2021,2023)))
  pass("pure reruns deterministic, observations immutable, active evidence excludes 2025")
  first <- audit_montreal_chronology_evidence()
  outputs <- list.files(mnc_dir(),full.names=TRUE);snap <- mrf_snapshot(outputs)
  second <- audit_montreal_chronology_evidence()
  stopifnot(identical(first,o),identical(first,second),identical(snap,mrf_snapshot(outputs)),
    identical(before,mrf_snapshot(protected)),length(outputs)==10)
  for(path in outputs)mro_git_boundary(path)
  pass("public reruns preserve identical objects and ten ignored tables; earlier evidence and outputs unchanged")
  message(length(results)," Phase 1N checks passed.")
  invisible(results)
}
if(sys.nframe()==0L) test_montreal_chronology_evidence()
