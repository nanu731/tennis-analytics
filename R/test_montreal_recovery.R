# Base-R regression and fail-closed tests. Run from the repository root, offline.
source("R/implement_montreal_recovery.R")

test_montreal_recovery <- function() {
  # Guard every existing acquisition entry point used by relevant regression tests.
  request_names <- c("mr_request","annual_2021_request")
  original_requests <- mget(request_names,envir=.GlobalEnv)
  on.exit(for(name in request_names)assign(name,original_requests[[name]],envir=.GlobalEnv),add=TRUE)
  for (name in request_names)
    assign(name,function(...)stop("Network forbidden in Phase 1I tests"),envir=.GlobalEnv)
  e <- mro_load(); release <- mro_build(e); results <- character()
  record <- function(name) { results <<- c(results,name); message("PASS: ",name) }
  expect_reject <- function(name, bad) {
    path <- tempfile("montreal-rejection-",tmpdir="data/pilot/development-2021",fileext=".rds")
    on.exit(if(file.exists(path))unlink(path),add=TRUE)
    before <- list.files(dirname(path),all.files=TRUE)
    error <- tryCatch(mro_publish(bad,path),error=identity)
    stopifnot(inherits(error,"error"),!file.exists(path),identical(before,list.files(dirname(path),all.files=TRUE)))
    record(name)
  }
  f <- release$field_decisions; st <- release$status_resolutions
  stopifnot(nrow(f)==126,all(table(f$source_audit_id)==18),length(unique(f$source_audit_id))==7,
    !anyDuplicated(paste(f$source_audit_id,f$source_field)),all(is.na(f$original_source_value)),
    all(f$original_source_raw_value==""),all(f$recovery_disposition==mro_disposition()),
    all(f$policy_version=="1.0.0"),release$policy_status=="ADOPTED",!release$modeling_authorized,
    release$event_admission=="NOT_EVALUATED",release$analytical_coverage=="NOT_EVALUATED",
    release$tour_season_gate=="NOT_TESTED",all(st$structured_status_conflict),
    all(st$operational_resolution[1:7]==mro_resolution()),
    identical(st$source_score[8:9],c("6-1 4-3 RET+H64","2-6 6-2")),
    identical(st$operational_resolution[8:9],c("official_retirement_confirmed_suffix_meaning_unresolved","official_retirement_confirmed_source_marker_missing")),
    all(st$model_eligibility=="NOT_EVALUATED"),release$source_bundles==47,release$supplemental_bundles==7,
    release$apparent_play_denominator==54,all(release$structural_checks$evaluated_rows==1),
    all(release$structural_checks$flagged_rows==0),all(release$structural_checks$not_evaluable_rows==0))
  record("seven complete bundles, 126 unique decisions, missing sources and separate nine status resolutions")
  required <- setdiff(names(f),c("original_source_value","original_source_raw_value","raw_fraction","numerator","denominator"))
  mro_required_text(f,required); mro_fingerprints(); mro_git_boundary()
  record("required provenance, source/reference pins, rights state and Git ignore boundary")
  bad <- e; bad$audit$`feasibility-dispositions`$audit_id[1] <- "sackmann:WTA:2022-806:238"
  expect_reject("out-of-scope source",bad)
  bad <- e; bad$audit$`feasibility-dispositions`$official_match_code[1] <- "LS008"
  expect_reject("out-of-scope official code",bad)
  bad <- e; bad$source$selected$raw$w_ace[bad$source$selected$raw$match_num=="238"] <- "0"
  expect_reject("partial source bundle",bad)
  bad <- e; bad$audit$`field-comparisons`$source_value[1] <- "999"
  bad$audit$`field-comparisons`$comparison_state[1] <- "source_and_official_conflict"
  expect_reject("populated-source count conflict",bad)
  bad <- e; bad$audit$`official-stat-observations`$value[1] <- NA_integer_
  expect_reject("partial official bundle",bad)
  bad <- e; bad$audit$`official-stat-observations` <- bad$audit$`official-stat-observations`[-1,]
  expect_reject("missing official field",bad)
  bad <- e; bad$audit$`field-comparisons` <- rbind(bad$audit$`field-comparisons`,bad$audit$`field-comparisons`[1,])
  expect_reject("duplicate source-field link",bad)
  bad <- e; bad$audit$`official-stat-observations`$raw_fraction[5] <- ""
  expect_reject("percentage-only reconstruction",bad)
  bad <- e; bad$audit$`official-stat-observations`$scope[1] <- "sum_of_set_panels"
  expect_reject("set-panel summation",bad)
  bad <- e; bad$audit$`official-stat-observations`$locator[1] <- NA_character_
  expect_reject("missing required locator",bad)
  bad <- e; bad$audit$`reference-match-inventory`$page_a_id[1] <- NA_character_
  expect_reject("ambiguous player orientation",bad)
  bad <- e; bad$audit$`official-stat-observations`$source_side[1:2] <- rev(bad$audit$`official-stat-observations`$source_side[1:2])
  expect_reject("incorrect one-sided source orientation",bad)
  bad <- e; bad$refs$sha256[4] <- paste(rep("0",64),collapse="")
  expect_reject("changed reference fingerprint",bad)
  bad <- e; bad$refs$sha256[4] <- ""
  expect_reject("missing reference fingerprint",bad)
  bad <- e; bad$source$provenance$sha256[2] <- "changed"
  expect_reject("changed source fingerprint",bad)
  bad <- e; bad$audit$`structural-checks`$flagged_rows[1] <- 1L
  expect_reject("failed mandatory check",bad)
  bad <- e; bad$audit$`structural-checks`$evaluated_rows[1] <- 0L
  bad$audit$`structural-checks`$not_evaluable_rows[1] <- 1L
  expect_reject("unavailable mandatory check",bad)
  bad <- e; bad$audit$`structural-checks` <- bad$audit$`structural-checks`[-1,]
  expect_reject("missing mandatory check",bad)
  bad <- e; bad$source$selected$raw$score[bad$source$selected$raw$match_num=="238"] <- "6-3 7-5 RET+H64"
  expect_reject("unexplained suffix dependency",bad)
  bad <- e; bad$audit$`status-evidence`$card_completed[1] <- "false"
  expect_reject("insufficient completion fields",bad)
  bad <- e; bad$audit$`status-evidence`$official_visible_finished[1] <- "Scheduled"
  expect_reject("missing visible finished evidence",bad)
  bad <- e; bad$audit$`status-evidence`$draw_evidence_state[1] <- "status_conflict"
  expect_reject("unresolved completion conflict",bad)
  bad <- e; bad$audit$`status-evidence`$structured_status_conflict[1] <- FALSE
  expect_reject("attempted removal of scheduled conflict",bad)
  bad <- e; bad$audit$`status-evidence`$match_page_retiring_player[8] <- "another-player"
  expect_reject("conflicting retirement identity",bad)
  bad <- e; bad$audit$`feasibility-dispositions` <- bad$audit$`feasibility-dispositions`[-1,]
  expect_reject("fewer than seven recovery bundles",bad)
  for (i in 1:7) {
    bad <- e; bad$audit$`official-stat-observations`$parse_state[(i-1)*20+1] <- "missing"
    expect_reject(paste("single failed bundle",i,"withholds entire release"),bad)
  }
  # Synthetic page reversal: correct two-sided swap preserves source-side counts;
  # a one-sided swap must be detectably different. These synthetic pages are never released.
  html <- anomaly_html(e$refs$local_path[e$refs$reference_id=="LS001"])
  card <- mrf_card(html,"LS001"); parsed <- mrf_stats(html,"LS001",card)
  swapped <- card; swapped$team <- rev(card$team); swapped$winner_side <- 3-card$winner_side
  blocks <- strsplit(mrf_tab(html),'<div class="compare-stats-block__row">',fixed=TRUE)[[1]]
  for(i in seq_along(blocks)) for(cls in c("stat","detail")) {
    values <- anomaly_matches(paste0('(?s)<div class="compare-stats-block__',cls,' [^>]*>.*?</div>'),blocks[i])
    if(length(values)==2) {
      blocks[i] <- sub(values[1],"MRO_SWAP_FIRST",blocks[i],fixed=TRUE)
      blocks[i] <- sub(values[2],values[1],blocks[i],fixed=TRUE)
      blocks[i] <- sub("MRO_SWAP_FIRST",values[2],blocks[i],fixed=TRUE)
    }
  }
  reversed_html <- paste0('<div class="mc-stats__tab-content js-match-stats"',paste(blocks,collapse='<div class="compare-stats-block__row">'))
  normalized <- function(x) x$value[order(paste(x$source_side,x$field))]
  stopifnot(identical(normalized(parsed),normalized(mrf_stats(reversed_html,"LS001",swapped))),
    !identical(normalized(parsed),normalized(mrf_stats(html,"LS001",swapped))),
    !identical(normalized(parsed),normalized(mrf_stats(reversed_html,"LS001",card))))
  record("correct two-sided reversal and incorrect one-sided reversals distinguished")
  protected <- unique(c(e$refs$local_path,names(mro_pins()),e$source$provenance$path,
    list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE)))
  before <- mrf_snapshot(protected)
  first <- implement_montreal_recovery(); state <- mrf_snapshot(mro_path())
  second <- implement_montreal_recovery()
  stopifnot(identical(first,second),identical(first,release),identical(state,mrf_snapshot(mro_path())),
    identical(before,mrf_snapshot(protected)))
  record("deterministic release bytes/mtime and immutable source/reference/Phase 1G outputs")
  # Two independent serializations have identical bytes; no wall-clock time enters a release.
  paths <- c(tempfile(),tempfile()); on.exit(unlink(paths),add=TRUE)
  saveRDS(first,paths[1],version=3,compress=FALSE);saveRDS(second,paths[2],version=3,compress=FALSE)
  stopifnot(pilot_sha256(paths[1])==pilot_sha256(paths[2]))
  bad <- e; bad$audit$`official-stat-observations`$parse_state[1] <- "missing"
  stopifnot(inherits(tryCatch(mro_publish(bad),error=identity),"error"),identical(state,mrf_snapshot(mro_path())))
  record("byte-identical serialization and failed rerun preserves prior immutable release without returning success")
  mro_git_boundary(); record("populated release and raw/extracted data remain untracked")
  message(length(results)," Phase 1I checks passed.")
  invisible(results)
}
if (sys.nframe()==0L) test_montreal_recovery()
