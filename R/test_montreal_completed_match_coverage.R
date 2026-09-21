# Offline Phase 1M contracts. Mutation fixtures are never published as evidence.
source("R/audit_montreal_completed_match_coverage.R")

test_montreal_completed_match_coverage <- function() {
  requests <- c("mr_request","annual_2021_request")
  old <- mget(requests,envir=.GlobalEnv)
  on.exit(for(name in requests) assign(name,old[[name]],envir=.GlobalEnv),add=TRUE)
  for(name in requests) assign(name,function(...) stop("Network forbidden in Phase 1M"),envir=.GlobalEnv)
  results <- character()
  pass <- function(name) { results <<- c(results,name); message("PASS: ",name) }
  reject <- function(name, expression) {
    error <- tryCatch(force(expression),error=identity)
    stopifnot(inherits(error,"error")); pass(name)
  }
  input <- mmc_load(); mmc_validate_inputs(input)
  protected <- unique(c(input$evidence$source$provenance$path,input$evidence$refs$local_path,
    names(mro_pins()),mro_path(),list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE),
    list.files(mji_dir(),full.names=TRUE)))
  before <- mrf_snapshot(protected)
  original_input <- serialize(input,NULL,version=3)
  o <- mmc_derive(input); d <- o$dispositions; s <- o$summary
  stopifnot(nrow(d)==55,!anyDuplicated(d$source_audit_id),nrow(o$count_links)==55,
    s$normally_completed==49,s$retirements==5,s$walkovers==1,s$unresolved==0)
  pass("all 55 records uniquely disposed; current validated evidence derives 49/5/1")
  excluded <- d$classification %in% c("retirement","walkover")
  flags <- c("included_in_completed_denominator","included_in_valid_numerator","four_factors_status_eligible",
    "elo_update_status_eligible","rolling_history_status_eligible","forecast_evaluation_status_eligible")
  stopifnot(sum(excluded)==6,!any(as.matrix(d[excluded,flags])),sum(d$classification=="retirement" & d$count_origin=="original_source")==5)
  pass("all retirements and walkover preserved; partial statistics excluded from numerator and every history/use flag")
  stopifnot(s$valid_original_bundles==42,s$valid_overlay_bundles==7,
    abs(s$source_only_pct-100*42/49)<1e-10,s$source_plus_overlay_pct==100,
    s$required_valid_bundles==45,s$numerical_event_gate=="PASS",
    !any(montreal_fields() %in% names(d)),!any(montreal_fields() %in% names(o$count_links)))
  pass("42 original and seven separate recovered bundles; 42/49, 49/49 and ceiling threshold 45")
  stopifnot(s$historical_source_bundles==47,s$historical_apparent_play_denominator==54,
    s$historical_source_plus_overlay==54,s$event_admission=="NOT_EVALUATED",
    s$canonical_analytical_population=="NOT_IMPLEMENTED",s$chronology=="UNRESOLVED",
    s$same_day_ordering=="UNRESOLVED",s$tour_season_gate=="NOT_TESTED",
    !s$modeling_authorized,s$publication=="BLOCKED_PENDING_RIGHTS_REVIEW")
  pass("historical measures preserved and numerical PASS cannot authorize admission or modeling")

  # Synthetic count losses exercise the denominator independently of production
  # fingerprint rejection. Status evidence and links remain exactly unchanged.
  eligible_source <- d$source_audit_id[d$included_in_valid_numerator & d$count_origin=="original_source"]
  raw_ids <- paste0("sackmann:WTA:2021-806:",input$evidence$source$selected$raw$match_num)
  bad <- input; ix <- match(eligible_source[1],raw_ids)
  bad$evidence$source$selected$raw$w_ace[ix] <- NA_character_
  lost <- mmc_derive(bad)
  stopifnot(lost$summary$normally_completed==49,lost$summary$valid_original_bundles==41,
    lost$dispositions$included_in_completed_denominator[match(eligible_source[1],d$source_audit_id)])
  reject("changed source counts cannot pass the current-evidence boundary",mmc_validate_inputs(bad,input))
  pass("one missing required count reduces numerator without shrinking denominator")
  bad$evidence$source$selected$raw[match(eligible_source[1:5],raw_ids),montreal_fields()] <- NA_character_
  lost <- mmc_derive(bad)
  stopifnot(lost$summary$normally_completed==49,lost$summary$valid_original_bundles==37,
    lost$summary$numerical_event_gate=="FAIL",lost$summary$required_valid_bundles==45)
  pass("five missing bundles cannot manufacture coverage by dropping completed matches")
  for(value in c("malformed","-1","999999")) {
    bad <- input; bad$evidence$source$selected$raw$w_ace[ix] <- value
    lost <- mmc_derive(bad)
    stopifnot(lost$summary$normally_completed==49,lost$summary$valid_original_bundles==41)
  }
  pass("malformed, negative and structurally impossible original counts excluded without denominator loss")

  li <- match(eligible_source[1],input$inventory$links$source_audit_id)
  bad <- input; bad$inventory$links$html_status[li] <- "unresolved"
  unknown <- mmc_derive(bad)
  stopifnot(unknown$dispositions$classification[li]=="unresolved_conflicting",
    unknown$summary$numerical_event_gate=="WITHHELD",!unknown$dispositions$included_in_completed_denominator[li])
  pass("unknown status never defaults to complete or improves a published gate")
  id49 <- "sackmann:WTA:2021-806:253"; li49 <- match(id49,d$source_audit_id)
  stopifnot(d$source_status[li49]=="unresolved",d$source_score[li49]=="2-6 6-2",
    d$classification[li49]=="retirement",d$applicable_resolution[li49]=="official_retirement_confirmed_source_marker_missing")
  pass("Ferro–Tomljanovic uses the adopted Phase 1I determination without rewriting its source status")
  for(change in c("missing","code","policy","score","retirement")) {
    bad <- input; st <- bad$overlay$status_resolutions; j <- which(st$audit_id==id49)
    if(change=="missing") st <- st[-j,]
    if(change=="code") st$match_code[j] <- "LS048"
    if(change=="policy") st$policy_version[j] <- "unapproved"
    if(change=="score") st$source_score[j] <- "6-2 6-2"
    if(change=="retirement") st$pdf_retirement[j] <- FALSE
    bad$overlay$status_resolutions <- st
    rejected <- mmc_derive(bad)
    stopifnot(rejected$dispositions$classification[li49]=="unresolved_conflicting",rejected$summary$numerical_event_gate=="WITHHELD")
    reject(paste("Phase 1I exact-evidence boundary:",change),mmc_validate_inputs(bad,input))
  }

  # The same boundary called by the public audit rejects altered validated input
  # objects before deriving/publishing anything. Existing policy suites separately
  # exercise their detailed live-byte, parsing and policy failure conditions.
  mutations <- list(
    missing_fingerprint=function(x) { x$evidence$refs$sha256[1] <- NA_character_; x },
    changed_fingerprint=function(x) { x$evidence$refs$sha256[1] <- paste(rep("0",64),collapse=""); x },
    manifest_pin=function(x) { x$overlay$manifest_pins[1] <- "changed"; x },
    linkage=function(x) { x$inventory$links$html_record_id[1] <- "wrong"; x },
    identity=function(x) { x$inventory$identities$state[1] <- "ambiguous"; x },
    round=function(x) { x$inventory$links$round[1] <- "INVALID_ROUND"; x },
    winner=function(x) { x$inventory$links$html_winner[1] <- "wrong"; x },
    score=function(x) { x$inventory$links$html_score[1] <- "6-0 6-0"; x },
    retirement_evidence=function(x) { x$inventory$status_resolutions$pdf_retirement_marker[1] <- FALSE; x },
    legend=function(x) { x$proof$details$legend_raw[1] <- "unknown"; x },
    raw_HTML_metadata=function(x) { x$proof$html$raw_status_marker[1] <- "unknown"; x },
    overlay_scope=function(x) { x$overlay$field_decisions$source_audit_id[1] <- eligible_source[1]; x },
    orientation=function(x) { x$overlay$field_decisions$source_side[1] <- "wrong"; x },
    provenance=function(x) { x$overlay$field_decisions$reference_path[1] <- NA_character_; x },
    structural_validation=function(x) { x$overlay$structural_checks$flagged_rows[1] <- 1L; x },
    unavailable_structural_check=function(x) { x$overlay$structural_checks$not_evaluable_rows[1] <- 1L; x }
  )
  for(name in names(mutations)) reject(paste("current evidence rejects",name),mmc_validate_inputs(mutations[[name]](input),input))
  bad <- input; bad$inventory$links <- rbind(bad$inventory$links,bad$inventory$links[1,])
  reject("duplicate disposition links fail derivation",mmc_derive(bad))
  bad <- input; bad$overlay$field_decisions <- rbind(bad$overlay$field_decisions,bad$overlay$field_decisions[1,])
  reject("duplicate count links fail derivation",mmc_derive(bad))
  bad <- mutations$overlay_scope(input)
  reject("unauthorized overlay bundle fails derivation",mmc_derive(bad))
  bad <- mutations$structural_validation(input)
  reject("failed recovery structural check fails derivation",mmc_derive(bad))
  bad <- mutations$round(input)
  reject("changed source round linkage fails derivation",mmc_derive(bad))
  for(change in c("duplicate_disposition","duplicate_count_link","retirement_relabel","walkover_inclusion","retirement_history")) {
    bad <- o
    if(change=="duplicate_disposition") bad$dispositions <- rbind(d,d[1,])
    if(change=="duplicate_count_link") bad$count_links <- rbind(o$count_links,o$count_links[1,])
    if(change=="retirement_relabel") bad$dispositions$classification[li49] <- "normally_completed"
    if(change=="walkover_inclusion") bad$dispositions$included_in_completed_denominator[d$classification=="walkover"] <- TRUE
    if(change=="retirement_history") bad$dispositions$rolling_history_status_eligible[li49] <- TRUE
    reject(paste("result validation rejects",change),mmc_validate_result(bad,input))
  }
  pass_report <- mmc_report(o); fail_report <- mmc_report(unknown)
  stopifnot(any(grepl("gate: **PASS**",pass_report,fixed=TRUE)),
    any(grepl("gate: **WITHHELD**",fail_report,fixed=TRUE)),!any(grepl("gate: **PASS**",fail_report,fixed=TRUE)))
  pass("report reflects the current computed gate instead of recycling a success claim")
  stopifnot(identical(original_input,serialize(input,NULL,version=3)),
    identical(o,mmc_derive(input)),identical(before,mrf_snapshot(protected)))
  pass("source and official objects, bytes and timestamps immutable; pure reruns identical")
  stopifnot(setequal(input$evidence$source$provenance$year,c(2021,2023)),
    !any(grepl("2025",protected,fixed=TRUE)),all(grepl("montreal-2021",input$evidence$refs$local_path,fixed=TRUE)))
  pass("all active manifested evidence paths scoped to 2021 references and 2021/2023 annuals; no 2025 input")
  first <- audit_montreal_completed_match_coverage()
  outputs <- c(list.files(mmc_dir(),full.names=TRUE),"docs/wta-2021-montreal-completed-match-coverage.md")
  saved <- mrf_snapshot(outputs)
  second <- audit_montreal_completed_match_coverage()
  stopifnot(identical(o,first),identical(first,second),identical(saved,mrf_snapshot(outputs)),
    identical(before,mrf_snapshot(protected)))
  for(path in list.files(mmc_dir(),full.names=TRUE)) mro_git_boundary(path)
  pass("public workflow reruns deterministic; four ignored outputs and report preserve bytes/mtime; protected evidence unchanged")
  message(length(results)," Phase 1M checks passed.")
  invisible(results)
}
if(sys.nframe()==0L) test_montreal_completed_match_coverage()
