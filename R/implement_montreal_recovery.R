# Phase 1I: approved local overlay only. No network, source repair or analytical use.
source("R/audit_montreal_reference_feasibility.R")

mro_version <- function() "1.0.0"
mro_name <- function() "WTA Montreal recovery and status-evidence policy"
mro_path <- function() "data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds"
mro_disposition <- function() "recovered_in_derived_overlay_source_preserved"
mro_resolution <- function() "completed_match_evidence_controls_for_scoped_recovery_scheduled_metadata_preserved"
mro_require <- function(ok, reason) {
  if (!isTRUE(ok)) stop("Montreal release withheld: ", reason, call.=FALSE)
}
mro_targets <- function() data.frame(
  code=sprintf("LS%03d", c(1:7,42,49)),
  audit_id=paste0("sackmann:WTA:2021-806:", c(238,300,299,298,297,296,295,260,253)),
  recovery=c(rep(TRUE,7),FALSE,FALSE), stringsAsFactors=FALSE)

mro_pins <- function() c(
  "data/manifests/montreal-reference-files.csv"="783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
  "data/manifests/development-source-files.csv"="2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
  "data/manifests/pilot-source-files.csv"="2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b")
mro_fingerprints <- function() {
  pins <- mro_pins()
  for (path in names(pins)) mro_require(file.exists(path) && pilot_sha256(path)==pins[[path]],
    paste("changed or missing policy-pinned manifest",path))
  refs <- mr_manifest()
  mro_require(nrow(refs)==12 && all(refs$retrieval_class=="original_response_bytes") &&
    all(refs$http_result=="200"), "all twelve original references required")
  list(refs=refs, source=montreal_load())
}
# Compare serialized CSV observations without conflating empty strings and numeric NA.
# The original files stay byte-for-byte unchanged; this is a read-only comparison.
mro_csv_lines <- function(x) {
  out <- character(); con <- textConnection("out","w",local=TRUE)
  write.csv(x,con,row.names=FALSE,na=""); close(con); out
}
mro_load <- function() {
  evidence <- mro_fingerprints()
  evidence$audit <- audit_montreal_reference_feasibility(write_outputs=FALSE)
  for (name in names(evidence$audit)) {
    path <- file.path("data/pilot/development-2021/montreal-reference-feasibility",paste0(name,".csv"))
    mro_require(file.exists(path) && identical(readLines(path,warn=FALSE),mro_csv_lines(evidence$audit[[name]])),
      paste("saved Phase 1G observation changed:",name))
  }
  evidence
}
mro_required_text <- function(x, fields) {
  mro_require(all(fields %in% names(x)),"required provenance column missing")
  for (field in fields) mro_require(!anyNA(x[[field]]) && all(nzchar(as.character(x[[field]]))),
    paste("unavailable required provenance:",field))
}
mro_git_boundary <- function(path=mro_path()) {
  tracked <- system2("git",c("ls-files","--","data/raw","data/pilot"),stdout=TRUE)
  mro_require(is.null(attr(tracked,"status")) && !length(tracked),"restricted data tracked by Git")
  ignored <- system2("git",c("check-ignore","--",shQuote(path)),stdout=TRUE,stderr=FALSE)
  mro_require(is.null(attr(ignored,"status")) && identical(ignored,path),"release path must be Git ignored")
}

mro_build <- function(evidence) {
  # Recheck live bytes and bind supplied observations to the immutable files.
  current <- mro_fingerprints()
  mro_require(identical(evidence$refs,current$refs),"reference fingerprint or metadata changed")
  mro_require(identical(evidence$source,current$source),"source observation or fingerprint changed")
  o <- evidence$audit; refs <- evidence$refs; e <- evidence$source; t <- mro_targets()
  s <- o$`official-stat-observations`; c <- o$`field-comparisons`; checks <- o$`structural-checks`
  status <- o$`status-evidence`; inv <- o$`reference-match-inventory`; pdf <- o$`pdf-target-evidence`
  d <- o$`feasibility-dispositions`
  mro_require(nrow(d)==9 && identical(as.character(d$official_match_code),t$code) &&
    identical(as.character(d$audit_id),t$audit_id),"exact seven recovery and two status mappings required")
  mro_require(nrow(status)==9 && identical(as.character(status$match_code),t$code) &&
    identical(as.character(status$audit_id),t$audit_id),"duplicate, incomplete or out-of-scope statuses")
  mro_require(nrow(c)==162 && !anyDuplicated(paste(c$audit_id,c$source_field)),"duplicate or missing source-field link")
  mro_require(nrow(s)==180 && !anyDuplicated(paste(s$audit_id,s$source_side,s$field)),"partial or duplicated official bundle")
  mro_require(nrow(inv)==18 && !anyDuplicated(paste(inv$audit_id,inv$reference_id)) && nrow(pdf)==9,
    "missing identity or draw evidence")
  mro_required_text(s,c("audit_id","match_code","reference_id","page_side","page_name","wta_player_id",
    "player_slug","source_side","field","raw_display","parse_state","scope","locator","extraction_method","orientation_basis"))
  mro_require(all(s$parse_state=="present") && all(s$scope=="whole_match_Match_tab"),"partial, unparseable or set-panel counts")
  mro_require(all(checks$evaluated_rows==1) && all(checks$flagged_rows==0) && all(checks$not_evaluable_rows==0),
    "failed or unavailable mandatory structural check")
  expected_checks <- c(paste0(montreal_fields(),"_nonnegative_integer"),
    unlist(lapply(c("w","l"),function(side)paste0(side,"_",c("aces_le_service_points","double_faults_le_service_points",
      "first_in_le_service_points","first_won_le_first_in","second_won_le_attempts","double_faults_le_attempts",
      "second_won_plus_df_le_attempts","saved_le_faced","faced_le_service_points","aces_le_service_wins",
      "zero_service_points","service_games_exceed_points")))),"service_games_vs_score_review",
    unlist(lapply(c("w","l"),function(side)paste0(side,"_",c("return_games_equal_opponent_service_games",
      "first_won_denominator_equal_first_in","second_won_denominator_equal_opportunities","saved_denominator_equal_faced")))))
  mro_require(length(expected_checks)==51 && nrow(checks)==459,"mandatory check set incomplete")
  fields <- list(); resolutions <- list()
  manifest <- annual_2021_manifest(); src <- manifest[manifest$tour=="WTA",]
  raw <- read.csv(src$local_path,colClasses="character",na.strings=NULL,check.names=FALSE)
  for (i in seq_len(nrow(t))) {
    code <- t$code[i]; id <- t$audit_id[i]; rec <- t$recovery[i]
    row <- e$selected$raw[e$selected$raw$match_num==sub(".*:","",id),,drop=FALSE]
    st <- status[i,,drop=FALSE]; obs <- s[s$audit_id==id,,drop=FALSE]
    cmp <- c[c$audit_id==id,,drop=FALSE]; ck <- checks[checks$audit_id==id,,drop=FALSE]
    ri <- refs[refs$reference_id==code,,drop=FALSE]; pi <- pdf[pdf$match_code==code,,drop=FALSE]
    identity <- inv[inv$audit_id==id,,drop=FALSE]
    mro_require(nrow(row)==1 && nrow(obs)==20 && nrow(cmp)==18 && nrow(ck)==51 && nrow(pi)==1 &&
      nrow(identity)==2 && setequal(identity$reference_id,c(code,"draw_html")),"missing or cross-linked bundle evidence")
    mro_require(setequal(ck$check,expected_checks) && !anyDuplicated(ck$check) && all(ck$match_code==code),"mandatory check identity changed")
    mro_require(all(obs$match_code==code) && all(obs$reference_id==code) && all(cmp$match_code==code) &&
      all(cmp$reference_id==code) && setequal(cmp$source_field,montreal_fields()),"out-of-scope field mapping")
    required <- obs[obs$required,,drop=FALSE]; key <- paste(required$source_side,required$field,sep="_")
    mro_require(nrow(required)==18 && setequal(key,montreal_fields()) && !anyDuplicated(key),"missing required field")
    required <- required[match(montreal_fields(),key),,drop=FALSE]; cmp <- cmp[match(montreal_fields(),cmp$source_field),,drop=FALSE]
    mro_require(all(identity$identity_result=="verified") && all(identity$score_result=="exact_numeric_agreement") &&
      pi$identity_result=="verified" && pi$score_result=="exact_numeric_agreement", "identity, winner or score conflict")
    mro_required_text(identity,c("page_a_name","page_a_id","page_a_slug","page_b_name","page_b_id","page_b_slug","advancing_side","locator"))
    # Reparse exact displayed evidence: a percentage alone can never supply a count.
    for (j in seq_len(nrow(obs))) {
      method <- obs$extraction_method[j]
      mro_require(method %in% c("displayed_integer","displayed_fraction_component_1","displayed_fraction_component_2"),"unsupported extraction method")
      component <- if (method=="displayed_integer") 0L else as.integer(sub(".*_","",method))
      parsed <- mrf_exact(obs$raw_display[j],obs$raw_fraction[j],component)
      mro_require(parsed$state=="present" && identical(parsed$value,as.integer(obs$value[j])) &&
        identical(parsed$numerator,as.integer(obs$numerator[j])) && identical(parsed$denominator,as.integer(obs$denominator[j])),
        "exact displayed count/fraction unavailable or changed")
    }
    card <- mrf_card(anomaly_html(ri$local_path),code)
    original_obs <- mrf_stats(anomaly_html(ri$local_path),code,card); original_obs$audit_id <- id
    mro_require(identical(mro_csv_lines(obs),mro_csv_lines(original_obs)),"orientation, locator or observation differs from pinned representation")
    mro_require(identical(as.character(cmp$source_value),unname(unlist(row[montreal_fields()]))) &&
      identical(as.integer(cmp$value),as.integer(required$value)) &&
      all(cmp$source_field==paste(cmp$source_side,cmp$field,sep="_")),"source/official comparison linkage changed")
    mro_require(st$card_completed=="true" && st$card_status=="F" && grepl("^Finished: [0-9]+:[0-9]{2}$",st$official_visible_finished) &&
      st$structured_score_agreement && st$structured_event_status=="http://schema.org/EventScheduled" && st$structured_status_conflict,
      "completion or preserved scheduled conflict unavailable")
    if (rec) {
      mro_require(all(is.na(row[montreal_fields()])) && all(is.na(cmp$source_value)) &&
        all(cmp$comparison_state=="source_missing_official_present"),"partial/populated source bundle or count conflict")
      mro_require(montreal_score(row$score,row$best_of)$numeric_completed_syntax &&
        !montreal_score(row$score,row$best_of)$unresolved_suffix && !grepl("[A-Za-z+]",row$score),"unexplained suffix or incomplete score dependency")
      mro_require(st$status_result=="completed_card_numeric_score_supported" && st$draw_evidence_state=="agreement" &&
        !pi$retirement && !nzchar(card$retired),"unresolved completion conflict")
      resolution <- mro_resolution()
    } else {
      expected <- c("official_retirement_confirmed_suffix_meaning_unresolved","official_retirement_confirmed_source_marker_missing")[i-7]
      expected_score <- c("6-1 4-3 RET+H64","2-6 6-2")[i-7]
      mro_require(st$status_result==expected && row$score==expected_score && st$source_score==expected_score &&
        st$draw_evidence_state=="numeric_agreement_HTML_retirement_marker_omitted" && pi$retirement &&
        pi$retiring_player==row$loser_name && st$pdf_retiring_player==row$loser_name &&
        mrf_plain_name(st$match_page_retiring_player)==tolower(row$loser_name) &&
        !nzchar(st$draw_html_retiring_player) && grepl("Ret'd",st$structured_score,fixed=TRUE) &&
        all(cmp$comparison_state=="source_and_official_exact"),"retirement evidence disagreement")
      resolution <- expected
    }
    st$operational_resolution <- resolution
    st$rule_scope <- if(rec) "LS001-LS007_count_recovery_only" else "LS042_LS049_retirement_observation_only"
    st$policy_name <- mro_name(); st$policy_version <- mro_version()
    st$reference_sha256 <- ri$sha256; st$reference_retrieved_at_utc <- ri$retrieved_at_utc
    st$draw_html_sha256 <- refs$sha256[refs$reference_id=="draw_html"]
    st$draw_pdf_sha256 <- refs$sha256[refs$reference_id=="draw_pdf"]
    st$draw_html_locator <- identity$locator[identity$reference_id=="draw_html"]
    st$draw_pdf_locator <- paste(pi$locator,pi$retirement_locator,sep="; ")
    st$source_sha256 <- src$sha256; st$source_path <- src$local_path
    st$model_eligibility <- "NOT_EVALUATED"; st$event_admission <- "NOT_EVALUATED"
    st$publication <- "BLOCKED_PENDING_RIGHTS_REVIEW"
    resolutions[[code]] <- st
    if (!rec) next
    source_index <- which(raw$tourney_id=="2021-806" & raw$match_num==row$match_num)
    mro_require(length(source_index)==1,"source physical row ambiguous")
    raw_values <- unname(unlist(raw[source_index,montreal_fields()]))
    mro_require(all(raw_values==""),"source missingness representation changed")
    identity <- identity[identity$reference_id==code,,drop=FALSE]
    f <- required
    f$source_audit_id <- id; f$source_field <- montreal_fields()
    f$original_source_value <- as.character(cmp$source_value)
    f$original_source_raw_value <- raw_values
    f$original_missingness_state <- "empty_CSV_cell_read_as_NA_character"
    f$source_winner_id <- row$winner_id; f$source_loser_id <- row$loser_id
    f$source_winner_name <- row$winner_name; f$source_loser_name <- row$loser_name
    f$source_score <- row$score; f$source_data_row <- source_index
    f$source_path <- src$local_path; f$source_sha256 <- src$sha256; f$source_byte_size <- src$byte_size
    f$source_git_blob <- src$source_git_blob; f$source_archive_commit <- src$pinned_commit
    f$source_retrieved_at_utc <- src$retrieved_at_utc
    f$source_url <- src$source_url; f$source_license_url <- src$license_url
    for (name in c("page_a_name","page_a_id","page_a_slug","page_b_name","page_b_id","page_b_slug","advancing_side")) f[[paste0("card_",name)]] <- identity[[name]]
    f$card_locator <- identity$locator
    f$orientation_validation <- "pinned_card_and_ordered_ab_columns_verified"
    f$extractor_version <- mrf_version(); f$reference_url <- ri$url; f$reference_path <- ri$local_path
    f$reference_sha256 <- ri$sha256; f$reference_byte_size <- ri$byte_size
    f$reference_retrieved_at_utc <- ri$retrieved_at_utc; f$reference_retrieval_class <- ri$retrieval_class
    f$draw_html_sha256 <- st$draw_html_sha256; f$draw_pdf_sha256 <- st$draw_pdf_sha256
    f$draw_html_locator <- st$draw_html_locator; f$draw_pdf_locator <- st$draw_pdf_locator
    f$structural_validation_state <- "passed_51_of_51_applicable_checks"
    f$validation_details <- paste(ck$check,collapse=";")
    f$status_resolution <- resolution; f$structured_event_status <- st$structured_event_status
    f$structured_status_conflict <- st$structured_status_conflict; f$status_locator <- st$locator
    f$recovery_disposition <- mro_disposition(); f$policy_name <- mro_name(); f$policy_version <- mro_version()
    f$rights_classification <- "user_authorized_local_noncommercial_recovery_no_provider_redistribution_grant"
    f$permitted_uses <- "local_recovery_overlay_verification"
    f$prohibited_uses <- "canonical_analysis;event_admission;modeling;publication;redistribution"
    mro_required_text(f,setdiff(names(f),c("original_source_value","original_source_raw_value","raw_fraction","numerator","denominator")))
    fields[[code]] <- f
  }
  f <- do.call(rbind,fields); rownames(f) <- NULL
  mro_require(length(fields)==7 && nrow(f)==126 && !anyDuplicated(paste(f$source_audit_id,f$source_field)),"incomplete atomic seven-bundle release")
  # Bind all remaining status/check/identity fields to a fresh read-only audit too.
  fresh <- audit_montreal_reference_feasibility(write_outputs=FALSE)
  mro_require(identical(o,fresh),"audit observations differ from pinned raw evidence")
  inventory <- montreal_inventory(e)
  mro_require(sum(inventory$apparent_played)==54 && sum(inventory$apparent_played & inventory$present_count==18)==47,"source cohort changed")
  result <- list(policy_name=mro_name(),policy_version=mro_version(),policy_status="ADOPTED",
    recovery_implemented=TRUE,status_precedence_implemented=TRUE,
    event_admission="NOT_EVALUATED",analytical_coverage="NOT_EVALUATED",modeling_authorized=FALSE,
    tour_season_gate="NOT_TESTED",publication="BLOCKED_PENDING_RIGHTS_REVIEW",
    source_bundles=47L,supplemental_bundles=7L,apparent_play_denominator=54L,
    field_decisions=f,status_resolutions=do.call(rbind,resolutions),structural_checks=checks,
    official_supporting_observations=s,reference_manifest=refs,source_manifest=src,manifest_pins=mro_pins())
  result
}

mro_publish <- function(evidence, path=mro_path()) {
  # Validation finishes before creating a temporary output. No subset can escape.
  release <- mro_build(evidence)
  mro_git_boundary(path)
  mro_require(dir.exists(dirname(path)),"existing ignored parent directory required")
  if (file.exists(path)) {
    mro_require(identical(readRDS(path),release),"existing release differs; preserve it for review")
    return(invisible(release))
  }
  stage <- tempfile(".montreal-release-",tmpdir=dirname(path))
  on.exit(unlink(stage),add=TRUE) # Only our uncommitted temporary file.
  saveRDS(release,stage,version=3,compress=FALSE)
  mro_require(identical(readRDS(stage),release),"staged serialization failed")
  mro_fingerprints(); mro_git_boundary(path)
  mro_require(!file.exists(path) && file.rename(stage,path),"atomic rename failed")
  invisible(release)
}
implement_montreal_recovery <- function() mro_publish(mro_load())

if (sys.nframe()==0L) {
  release <- implement_montreal_recovery()
  message("Atomic release: 7 bundles / 126 decisions; source 47/54; source plus overlay 54/54.")
  message("Event/analytical admission NOT_EVALUATED; modeling FALSE; publication blocked.")
}
