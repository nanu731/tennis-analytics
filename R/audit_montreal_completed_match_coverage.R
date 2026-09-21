# Phase 1M: local status eligibility and count coverage, never model admission.
source("R/reconcile_montreal_inventory.R")

mmc_version <- function() "Montreal completed-match coverage audit 1.0.0"
mmc_dir <- function() "data/pilot/development-2021/montreal-completed-match-coverage"
mmc_need <- function(ok, reason) {
  if (!isTRUE(ok)) stop("Montreal coverage withheld: ", reason, call.=FALSE)
}

mmc_load <- function() {
  evidence <- mro_load()
  overlay <- mro_build(evidence)
  mmc_need(file.exists(mro_path()) && identical(overlay,readRDS(mro_path())),
    "existing recovery release differs from fresh validated reconstruction")
  proof <- mji_status_evidence()
  mmc_need(identical(evidence$source$selected$raw,proof$source),"source changed between evidence reads")
  inventory <- mji_compare(proof$html,proof$pdf,proof$source,overlay,TRUE,proof)
  list(evidence=evidence,overlay=overlay,proof=proof,inventory=inventory)
}

# A testable boundary also used by the public workflow: supplied observations
# must equal a second current reconstruction, not merely carry a valid hash label.
mmc_validate_inputs <- function(input, current=mmc_load()) {
  mmc_need(identical(input,current),"observations, provenance or policy proof differ from current pinned evidence")
  mmc_need(input$inventory$state=="COMPLETE" && all(input$inventory$criteria$passed),
    "inventory or adopted status evidence unresolved")
  invisible(TRUE)
}

mmc_classify <- function(link, overlay, status_resolutions) {
  result <- "unresolved_conflicting"
  linked <- isTRUE(link$html_link_count==1 && link$pdf_link_count==1 &&
    link$winner_agreement && link$score_agreement && link$status_resolved && !link$unresolved)
  if (!linked) return(result)
  # These records were reconstructed under their exact adopted policies above.
  old <- overlay$status_resolutions
  old <- old[old$audit_id==link$source_audit_id & old$match_code %in% c("LS042","LS049"),,drop=FALSE]
  new <- status_resolutions[status_resolutions$source_audit_id==link$source_audit_id,,drop=FALSE]
  retirement <- (nrow(old)==1 && isTRUE(old$match_code==link$official_code) &&
    isTRUE(old$operational_resolution==link$adopted_resolution) &&
    isTRUE(old$policy_name==mro_name() && old$policy_version==mro_version() &&
      old$source_score==link$source_score && old$pdf_retirement)) ||
    (nrow(new)==1 && isTRUE(new$official_code==link$official_code) &&
      isTRUE(new$policy_name==mji_status_policy()$name && new$policy_version==mji_status_policy()$version &&
        new$resolution==link$adopted_resolution && new$derived_inventory_status=="retirement" &&
        new$pdf_retirement_marker && new$source_score==link$source_score) &&
      isTRUE(link$adopted_resolution==mji_status_policy()$resolution))
  if (retirement && isTRUE(link$pdf_status=="retirement")) return("retirement")
  statuses <- unlist(link[c("source_status","html_status","pdf_status")],use.names=FALSE)
  if (!anyNA(statuses) && all(statuses=="walkover")) return("walkover")
  # Numeric completion in all three linked result representations is affirmative
  # support; a generic HTML F or a populated count bundle alone is insufficient.
  scores <- unlist(link[c("source_score","html_score","pdf_score")],use.names=FALSE)
  completed <- !anyNA(statuses) && all(statuses=="completed") &&
    all(vapply(scores,function(s) identical(inventory_status(s),"completed"),TRUE)) &&
    is.na(link$adopted_resolution)
  if (completed) result <- "normally_completed"
  result
}

mmc_derive <- function(input) {
  inv <- input$inventory; raw <- input$evidence$source$selected$raw; overlay <- input$overlay
  links <- inv$links; fields <- montreal_fields()
  ids <- paste0("sackmann:WTA:2021-806:",raw$match_num)
  mmc_need(!anyDuplicated(ids) && !anyDuplicated(links$source_audit_id) &&
    setequal(ids,links$source_audit_id),"missing or duplicate disposition links")
  f <- overlay$field_decisions; targets <- mro_targets(); targets <- targets[targets$recovery,]
  mmc_need(nrow(f)==18*nrow(targets) && !anyDuplicated(paste(f$source_audit_id,f$source_field)) &&
    setequal(f$source_audit_id,targets$audit_id),"unauthorized or duplicate count links")
  out <- checks <- count_links <- list()
  src <- overlay$source_manifest
  for (i in seq_len(nrow(links))) {
    link <- links[i,,drop=FALSE]; id <- link$source_audit_id
    row <- raw[match(id,ids),,drop=FALSE]
    mmc_need(isTRUE(row$round==link$round && row$winner_id==link$source_winner && row$score==link$source_score) &&
      isTRUE(mji_key(row$round,row$winner_id,row$loser_id)==link$match_key),"source identity, round, winner or score linkage changed")
    classification <- mmc_classify(link,overlay,inv$status_resolutions)
    eligible <- classification=="normally_completed"
    bundle <- montreal_bundle(row)
    ck <- pilot_audit_event(row,"WTA")$checks
    ck$source_audit_id <- id; ck$count_origin <- "original_source"
    valid <- bundle$present_count==18 && bundle$malformed_count==0 &&
      all(ck$evaluated_rows==1 & ck$flagged_rows==0 & ck$not_evaluable_rows==0)
    origin <- "original_source"
    count_state <- if (valid) "valid" else if (bundle$present_count<18) "missing_required_counts" else
      if (bundle$malformed_count>0 || any(ck$flagged_rows>0)) "invalid_required_counts" else "unevaluable_required_checks"
    ff <- f[f$source_audit_id==id,,drop=FALSE]
    resolution <- link$adopted_resolution
    policy <- if (!is.na(resolution)) {
      if (id %in% mji_status_targets()$audit_id) mji_status_policy()$name else mro_name()
    } else "corroborated_source_HTML_PDF_result_scores"
    if (nrow(ff)) {
      target <- targets[targets$audit_id==id,,drop=FALSE]
      mmc_need(eligible && nrow(target)==1 && isTRUE(target$code==link$official_code) &&
        setequal(ff$source_field,fields) && all(ff$match_code==target$code) &&
        all(ff$policy_version==mro_version()) && all(ff$policy_name==mro_name()) &&
        all(ff$status_resolution==mro_resolution()) &&
        all(ff$structural_validation_state=="passed_51_of_51_applicable_checks") &&
        bundle$present_count==0,"overlay scope, status, structural proof or source missingness changed")
      os <- overlay$status_resolutions
      os <- os[os$audit_id==id & os$match_code==target$code,,drop=FALSE]
      mmc_need(nrow(os)==1 && os$operational_resolution==mro_resolution(),"overlay completion policy missing")
      ck <- overlay$structural_checks[overlay$structural_checks$audit_id==id,,drop=FALSE]
      mmc_need(nrow(ck)==51 && !anyDuplicated(ck$check) && all(ck$match_code==target$code) &&
        all(ck$evaluated_rows==1 & ck$flagged_rows==0 & ck$not_evaluable_rows==0),"overlay structural validation failed")
      mmc_need(all(is.finite(ff$value) & ff$value>=0 & ff$value==floor(ff$value)),"overlay count unavailable or malformed")
      origin <- "approved_recovery_overlay"; count_state <- "valid"; valid <- TRUE
      resolution <- mro_resolution(); policy <- mro_name()
      ck$source_audit_id <- id; ck$count_origin <- origin
    }
    checks[[i]] <- ck[c("source_audit_id","count_origin","check","evaluated_rows","flagged_rows","not_evaluable_rows")]
    d <- link
    d$classification <- classification; d$included_in_completed_denominator <- eligible
    d$exclusion_reason <- switch(classification,normally_completed="none",retirement="retirement_including_partial_history",
      walkover="no_match_play",unresolved_conflicting="pending_status_or_linkage_review")
    d$count_origin <- origin; d$count_validation_state <- count_state
    d$included_in_valid_numerator <- eligible && valid
    for (name in c("four_factors_status_eligible","elo_update_status_eligible","rolling_history_status_eligible","forecast_evaluation_status_eligible")) d[[name]] <- eligible
    d$status_policy <- policy; d$status_policy_version <- "1.0.0"; d$applicable_resolution <- resolution
    d$audit_version <- mmc_version(); d$scope <- "event_audit_only_not_canonical_authorization"
    d$source_path <- src$local_path; d$source_sha256 <- src$sha256; d$source_git_blob <- src$source_git_blob
    d$source_archive_commit <- src$pinned_commit
    d$html_sha256 <- input$evidence$refs$sha256[input$evidence$refs$reference_id=="draw_html"]
    d$pdf_sha256 <- input$evidence$refs$sha256[input$evidence$refs$reference_id=="draw_pdf"]
    d$html_locator <- inv$html$locator[match(link$html_record_id,inv$html$record_id)]
    d$pdf_locator <- inv$pdf$locator[match(link$pdf_record_id,inv$pdf$record_id)]
    d$html_raw_score <- inv$html$raw_score[match(link$html_record_id,inv$html$record_id)]
    d$pdf_raw_score <- inv$pdf$raw_score[match(link$pdf_record_id,inv$pdf$record_id)]
    d$html_raw_status_marker <- inv$html$raw_status_marker[match(link$html_record_id,inv$html$record_id)]
    d$pdf_raw_status_marker <- inv$pdf$raw_status_marker[match(link$pdf_record_id,inv$pdf$record_id)]
    out[[i]] <- d
    count_links[[i]] <- data.frame(source_audit_id=id,count_origin=origin,
      required_fields_present=if(nrow(ff)) nrow(ff) else bundle$present_count,
      count_validation_state=count_state,included_in_valid_numerator=eligible && valid,
      provenance_path=if(nrow(ff)) mro_path() else src$local_path,
      policy=if(nrow(ff)) paste(mro_name(),mro_version()) else "unchanged_pinned_source_existing_count_checks")
  }
  dispositions <- do.call(rbind,out); count_links <- do.call(rbind,count_links); checks <- do.call(rbind,checks)
  for (name in c("dispositions","count_links","checks")) {
    z <- get(name); rownames(z) <- NULL; assign(name,z)
  }
  n <- sum(dispositions$included_in_completed_denominator)
  original <- sum(dispositions$included_in_valid_numerator & dispositions$count_origin=="original_source")
  recovered <- sum(dispositions$included_in_valid_numerator & dispositions$count_origin=="approved_recovery_overlay")
  unresolved <- sum(dispositions$classification=="unresolved_conflicting")
  trusted <- inv$state=="COMPLETE" && all(inv$criteria$passed) && unresolved==0
  summary <- data.frame(audit_version=mmc_version(),inventory_state=inv$state,total_results=nrow(dispositions),
    normally_completed=n,retirements=sum(dispositions$classification=="retirement"),
    walkovers=sum(dispositions$classification=="walkover"),unresolved=unresolved,
    valid_original_bundles=original,valid_overlay_bundles=recovered,
    source_only_pct=if(n>0) 100*original/n else NA_real_,
    source_plus_overlay_pct=if(n>0) 100*(original+recovered)/n else NA_real_,
    event_threshold=0.90,required_valid_bundles=ceiling(0.90*n),
    numerical_event_gate=if(!trusted || n==0) "WITHHELD" else if(original+recovered>=ceiling(0.90*n)) "PASS" else "FAIL",
    historical_apparent_play_denominator=overlay$apparent_play_denominator,
    historical_source_bundles=overlay$source_bundles,
    historical_source_plus_overlay=overlay$source_bundles+overlay$supplemental_bundles,
    event_admission="NOT_EVALUATED",canonical_analytical_population="NOT_IMPLEMENTED",
    chronology="UNRESOLVED",same_day_ordering="UNRESOLVED",tour_season_gate="NOT_TESTED",
    modeling_authorized=FALSE,publication="BLOCKED_PENDING_RIGHTS_REVIEW")
  list(dispositions=dispositions,count_links=count_links,checks=checks,summary=summary)
}

mmc_validate_result <- function(result, input) {
  mmc_need(identical(result,mmc_derive(input)),"derived dispositions/count links or summary altered")
  invisible(TRUE)
}

mmc_report <- function(result) {
  s <- result$summary
  c("# WTA Montreal 2021 completed-match eligibility and count coverage", "",
    paste0("Phase 1M; audit version 1.0.0. Numerical event gate: **",s$numerical_event_gate,"**. Event admission: **NOT_EVALUATED**."),"",
    "## Inventory and status eligibility", "",
    paste0("Fresh inventory state: ",s$inventory_state,". All ",s$total_results," non-bye results are preserved: ",
      s$normally_completed," normally completed, ",s$retirements," retirements, ",s$walkovers," walkover, ",s$unresolved," unresolved."),"",
    "All five retirement decisions must revalidate under the adopted Phase 1I and Phase 1L policies, including LS049/Ferro–Tomljanovic despite its missing source RET marker. The raw scores, five HTML omissions and scoped conflict history remain unchanged. Retirements and the walkover are excluded from the completed denominator, valid numerator and all Four Factors, Elo-update, rolling-history and evaluation status-eligibility flags in this event audit. These flags are not model authorization or a canonical panel selector.","",
    "Normal completion requires linked source/HTML/PDF winner and score agreement plus complete numeric result scores in all three representations. Generic F metadata and populated counts alone never establish completion. Unknown or conflicting status is preserved, excluded pending review and withholds a numerical PASS.","",
    "## Completed-match count coverage", "",
    "| Measure | Verified result |", "| --- | --- |",
    sprintf("| Valid unchanged original-source bundles | %d/%d = %.4f%% |",s$valid_original_bundles,s$normally_completed,s$source_only_pct),
    sprintf("| Separate approved overlay bundles | %d |",s$valid_overlay_bundles),
    sprintf("| Source plus approved overlay | %d/%d = %.4f%% |",s$valid_original_bundles+s$valid_overlay_bundles,s$normally_completed,s$source_plus_overlay_pct),
    sprintf("| Required at the unchanged 90%% event threshold | ceiling(0.90 × %d) = %d |",s$normally_completed,s$required_valid_bundles),
    paste0("| Numerical threshold result | ",s$numerical_event_gate," |"),"",
    "The denominator depends on validated completion evidence, never count availability. Missing, malformed or invalid counts reduce the numerator without removing normally completed matches from the denominator. All 18 required fields must pass the existing nonnegative-integer, component-bound and game/score checks; original bundles require all 43 checks evaluable and passing. Recovery requires all 51 checks per bundle, exact field links, orientation, provenance and the adopted seven-bundle policy. Structural consistency is not independent proof that every recorded statistic is correct. No filled-in Sackmann table is produced.","",
    "## Historical apparent-play measures", "",
    sprintf("Unchanged historical presence is %d/%d source-only and %d/%d with the separate overlay. These include retirements and are not completed-match analytical coverage.",s$historical_source_bundles,s$historical_apparent_play_denominator,s$historical_source_plus_overlay,s$historical_apparent_play_denominator),"",
    "## Evidence protections and reproduction", "",
    "The workflow reconstructs current evidence twice, validates pinned manifests and source/reference fingerprints, reparses official observations, rebuilds both adopted policy layers and compares the existing recovery release with its fresh reconstruction. Saved generated tables alone cannot establish a current pass. Missing or changed evidence stops the run before any output write; a previously saved result is not a fresh validation. Only existing local 2021/2023 evidence is read; no 2025 data or network is used.","",
    "```sh", "Rscript R/audit_montreal_completed_match_coverage.R", "Rscript R/test_montreal_completed_match_coverage.R", "```", "",
    "Four ignored local tables are written under data/pilot/development-2021/montreal-completed-match-coverage/: dispositions.csv (all results, raw evidence, linkage, decisions and provenance); count-links.csv (separate origins and validation); structural-checks.csv; summary.csv. No recovered count values or full official draw are committed. Existing raw evidence, manifests, generated observations and the populated Phase 1I overlay are preserved.","",
    "## Admission and remaining blockers", "",
    "| Gate | State |", "| --- | --- |", "| Event admission | NOT_EVALUATED |",
    "| Canonical analytical population | NOT_IMPLEMENTED |", "| Chronology and same-day ordering | UNRESOLVED |",
    "| 95% tour-season gate | NOT_TESTED |", "| Modeling authorization | FALSE |", "| Publication | BLOCKED_PENDING_RIGHTS_REVIEW |", "",
    "Numerical coverage passage does not admit Montreal, validate the full panel or resolve chronology. Actual-date evidence, same-day/suspended-match treatment, the LS007 date discrepancy and differing event windows remain unresolved. H64/H61 suffix meanings remain unknown even though scoped retirement occurrence is corroborated. Wider acquisition, canonical structures, dependencies, statistical choices and publication rights need their respective future review/authorization; local research permission is not a provider redistribution grant.","",
    "The smallest recommended next milestone is a bounded offline chronology-evidence inventory and policy proposal for this event, documenting which actual dates/completion order the existing references support and which remain unknown. It should not implement ordering, acquire data, admit events or start models. The flagship Four Factors versus surface-adjusted Elo project and deferred Challenger extension remain unchanged; portfolio was not modified.","",
    "See [current status](status.md), [data contract](data-source-contract.md), [inventory reconciliation](wta-2021-montreal-inventory-reconciliation.md), [recovery policy](wta-2021-montreal-recovery-policy.md) and [inventory status policy](wta-2021-montreal-inventory-status-policy.md).")
}

audit_montreal_completed_match_coverage <- function(write_outputs=TRUE) {
  input <- mmc_load()
  paths <- unique(c(input$evidence$refs$local_path,input$evidence$source$provenance$path,
    names(mro_pins()),mro_path(),list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE)))
  before <- mrf_snapshot(paths)
  mmc_validate_inputs(input)
  result <- mmc_derive(input)
  mmc_validate_result(result,input)
  mmc_need(identical(before,mrf_snapshot(paths)),"protected evidence changed during audit")
  if (write_outputs) {
    mro_git_boundary(paste0(mmc_dir(),"/summary.csv"))
    dir.create(mmc_dir(),showWarnings=FALSE)
    files <- c(dispositions="dispositions",count_links="count-links",checks="structural-checks",summary="summary")
    for (name in names(files)) pilot_write_csv(result[[name]],file.path(mmc_dir(),paste0(files[[name]],".csv")))
    path <- "docs/wta-2021-montreal-completed-match-coverage.md"; report <- mmc_report(result)
    if (!file.exists(path) || !identical(readLines(path,warn=FALSE),report)) writeLines(report,path)
  }
  invisible(result)
}
if (sys.nframe()==0L) print(audit_montreal_completed_match_coverage()$summary,row.names=FALSE)
