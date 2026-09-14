# Run from the repository root: Rscript --vanilla R/audit_pilot_data.R
# This script makes no network requests and creates no ratings or features.
source("R/download_pilot_data.R")

pilot_quarantine_state <- function(joint_complete, structural_conflict, status,
                                   cross_source_conflict = FALSE, identity_ambiguous = FALSE,
                                   chronology_resolved = FALSE, reference_available = TRUE,
                                   status_conflict = FALSE) {
  # Policy v1 separates statistical validity from inventory and model admission.
  inputs <- c(joint_complete, structural_conflict, cross_source_conflict,
              identity_ambiguous, chronology_resolved, reference_available, status_conflict)
  if (anyNA(inputs) || length(status) != 1L || is.na(status)) stop("Explicit policy evidence flags required.")
  reasons <- c(if (!joint_complete) "missing_required_counts",
    if (structural_conflict) "structural_count_conflict",
    if (cross_source_conflict) "cross_source_conflict",
    if (status_conflict || !status %in% c("score_consistent_with_completion", "walkover_marker")) "status_unresolved",
    if (!chronology_resolved) "chronology_unresolved",
    if (identity_ambiguous) "identity_ambiguous",
    if (!reference_available) "reference_unavailable")
  quarantined <- !joint_complete || structural_conflict || cross_source_conflict || identity_ambiguous
  played <- status != "walkover_marker"
  data.frame(policy_version = "1.0.0", source_row_present = TRUE,
    required_fields_present = joint_complete, structural_checks_passed = joint_complete && !structural_conflict,
    statistical_bundle_quarantined = quarantined, included_in_event_inventory = TRUE,
    included_in_played_denominator = played,
    included_in_valid_numerator = played && !quarantined,
    factor_statistics_candidate = played && !quarantined && !status_conflict && status == "score_consistent_with_completion",
    eligible_for_factor_analysis = FALSE, eligible_for_rating_updates = FALSE,
    eligible_for_chronological_forecasting = FALSE,
    reason_codes = paste(reasons, collapse = ";"), stringsAsFactors = FALSE)
}

pilot_score <- function(score, best_of) {
  if (is.na(score) || !nzchar(trimws(score))) return("missing_score")
  s <- toupper(trimws(score))
  if (grepl("W/O|WALKOVER|WALK OVER|^WO$", s)) return("walkover_marker")
  if (grepl("RET", s)) return("retirement_marker")
  if (grepl("DEF", s)) return("default_marker")
  if (grepl("ABD|ABN|ABAND|SUSP|UNFIN|CANC", s)) return("unfinished_marker")
  if (!grepl("^[0-9]+-[0-9]+(\\([0-9]+\\))?( [0-9]+-[0-9]+(\\([0-9]+\\))?)*$", s)) {
    return("other_marker_or_format")
  }
  tokens <- strsplit(gsub("\\([0-9]+\\)", "", s), " ")[[1]]
  pairs <- lapply(strsplit(tokens, "-"), as.numeric)
  a <- vapply(pairs, `[`, numeric(1), 1)
  b <- vapply(pairs, `[`, numeric(1), 2)
  normal <- (pmax(a, b) == 6 & pmin(a, b) <= 4) |
    (pmax(a, b) == 7 & pmin(a, b) %in% c(5, 6))
  needed <- suppressWarnings(as.numeric(best_of)) %/% 2 + 1
  # Pilot best-of-three score syntax only; this is not a universal score parser.
  if (is.na(needed) || !all(normal) || sum(a > b) != needed ||
      sum(b > a) >= needed || length(a) > as.numeric(best_of) ||
      any(cumsum(a > b)[-length(a)] >= needed)) return("numeric_unfinished_or_inconsistent")
  "score_consistent_with_completion"
}

pilot_game_check <- function(score, status, winner_games, loser_games) {
  if (anyNA(c(score, winner_games, loser_games)) ||
      !status %in% c("score_consistent_with_completion", "retirement_marker")) return(NA)
  tokens <- strsplit(trimws(gsub(" RET.*$", "", score)), " ")[[1]]
  if (!all(grepl("^[0-9]+-[0-9]+(\\([0-9]+\\))?$", tokens))) return(NA)
  pairs <- lapply(strsplit(gsub("\\([0-9]+\\)", "", tokens), "-"), as.numeric)
  games <- sum(unlist(pairs))
  tiebreaks <- sum(vapply(pairs, function(p) identical(sort(p), c(6, 7)), logical(1)))
  difference <- winner_games + loser_games - (games - tiebreaks)
  # Exclude completed tie-break games from service-game totals. A retirement
  # may include the current unfinished service game, so allow zero or one extra.
  !(difference %in% if (status == "retirement_marker") c(0, 1) else 0)
}

pilot_audit_event <- function(x, tour) {
  suffixes <- c("ace", "df", "svpt", "1stIn", "1stWon", "2ndWon", "SvGms", "bpFaced", "bpSaved")
  fields <- c(paste0("w_", suffixes), paste0("l_", suffixes))
  context <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level",
               "draw_size", "round", "match_num", "score", "best_of", "winner_id", "loser_id",
               "winner_name", "loser_name")
  if (!all(c(fields, context) %in% names(x))) stop("Missing required pilot columns: ", tour)
  n <- nrow(x)
  numeric_counts <- as.data.frame(lapply(x[fields], function(v) suppressWarnings(as.numeric(v))))
  present <- !is.na(x[fields]) & x[fields] != ""
  bad <- matrix(FALSE, n, length(fields), dimnames = list(NULL, fields))
  checks <- list()
  add_check <- function(name, failed, columns = character()) {
    evaluated <- !is.na(failed)
    flag <- evaluated & failed
    checks[[name]] <<- data.frame(tour = tour, check = name, evaluated_rows = sum(evaluated),
                                 flagged_rows = sum(flag), not_evaluable_rows = sum(!evaluated))
    if (length(columns)) bad[flag, columns] <<- TRUE
    flag
  }
  for (f in fields) {
    v <- numeric_counts[[f]]
    invalid <- present[, f] & (!is.finite(v) | v < 0 | v != floor(v))
    add_check(paste0(f, "_nonnegative_integer"), invalid, f)
  }
  for (side in c("w_", "l_")) {
    get <- function(f) numeric_counts[[paste0(side, f)]]
    bound <- function(name, flag, f) add_check(paste0(side, name), flag, paste0(side, f))
    bound("aces_le_service_points", get("ace") > get("svpt"), "ace")
    bound("double_faults_le_service_points", get("df") > get("svpt"), "df")
    bound("first_in_le_service_points", get("1stIn") > get("svpt"), "1stIn")
    bound("first_won_le_first_in", get("1stWon") > get("1stIn"), "1stWon")
    attempts <- get("svpt") - get("1stIn")
    attempts[is.na(attempts) | attempts < 0] <- NA_real_
    bound("second_won_le_attempts", get("2ndWon") > attempts, "2ndWon")
    bound("double_faults_le_attempts", get("df") > attempts, "df")
    bound("second_won_plus_df_le_attempts", get("2ndWon") + get("df") > attempts, c("2ndWon", "df"))
    bound("saved_le_faced", get("bpSaved") > get("bpFaced"), "bpSaved")
    bound("faced_le_service_points", get("bpFaced") > get("svpt"), "bpFaced")
    bound("aces_le_service_wins", get("ace") > get("1stWon") + get("2ndWon"), "ace")
    bound("zero_service_points", get("svpt") == 0, "svpt")
    bound("service_games_exceed_points", get("SvGms") > get("svpt"), "SvGms")
  }
  status <- mapply(pilot_score, x$score, x$best_of, USE.NAMES = FALSE)
  games_flag <- mapply(pilot_game_check, x$score, status, numeric_counts$w_SvGms,
                       numeric_counts$l_SvGms, USE.NAMES = FALSE)
  add_check("service_games_vs_score_review", games_flag, c("w_SvGms", "l_SvGms"))
  joint <- rowSums(present) == length(fields)
  suspicious <- rowSums(bad) > 0L
  non_walkover <- status != "walkover_marker"
  completed_syntax <- status == "score_consistent_with_completion"
  cohorts <- list(all_source_rows = rep(TRUE, n), non_walkover_rows = non_walkover,
                  completed_score_syntax = completed_syntax)
  coverage <- do.call(rbind, lapply(names(cohorts), function(cohort) {
    take <- cohorts[[cohort]]
    denom <- sum(take)
    complete <- sum(joint[take])
    valid <- sum(joint[take] & !suspicious[take])
    data.frame(tour = tour, cohort = cohort, denominator = denom, joint_complete = complete,
               joint_pct = if (denom) 100 * complete / denom else NA_real_,
               joint_missing = denom - complete, joint_missing_pct = if (denom) 100 * (denom - complete) / denom else NA_real_,
               complete_without_count_flags = valid,
               unflagged_pct = if (denom) 100 * valid / denom else NA_real_)
  }))
  availability <- do.call(rbind, lapply(fields, function(f) data.frame(
    tour = tour, field = f, rows = n, nonmissing = sum(present[, f]),
    nonmissing_pct = 100 * sum(present[, f]) / n,
    zeros = sum(numeric_counts[[f]] == 0, na.rm = TRUE),
    suspicious_or_invalid = sum(bad[, f])
  )))
  # Repeated player appearances are expected; an ID occurring on both sides of
  # one match or mapping to different names is a separate ambiguity check.
  ids <- c(x$winner_id, x$loser_id)
  names <- c(x$winner_name, x$loser_name)
  mapping <- unique(data.frame(id = ids, name = names))
  id_names <- table(mapping$id)
  name_ids <- table(mapping$name)
  identities <- data.frame(tour = tour,
    check = c("duplicate_full_rows_excess", "duplicate_tournament_match_keys_excess", "missing_match_keys",
              "missing_player_id_slots", "same_id_both_sides", "ids_with_multiple_names", "names_with_multiple_ids",
              "repeated_player_appearances_expected"),
    count = c(sum(duplicated(x)), sum(duplicated(x[c("tourney_id", "match_num")])),
              sum(is.na(x$tourney_id) | is.na(x$match_num)), sum(is.na(ids)),
              sum(x$winner_id == x$loser_id, na.rm = TRUE), sum(id_names > 1),
              sum(name_ids > 1), length(ids) - length(unique(ids))))
  raw_duplicates <- duplicated(x) | duplicated(x, fromLast = TRUE)
  key_duplicates <- duplicated(x[c("tourney_id", "match_num")]) |
    duplicated(x[c("tourney_id", "match_num")], fromLast = TRUE)
  row_audit <- data.frame(tour = tour, tourney_id = x$tourney_id, match_num = x$match_num,
    score = x$score, status_evidence = status, joint_complete = joint,
    count_review = suspicious, service_games_review = games_flag,
    duplicate_row = raw_duplicates, duplicate_key = key_duplicates,
    missing_player_id = is.na(x$winner_id) | is.na(x$loser_id),
    same_player_both_sides = x$winner_id == x$loser_id,
    stringsAsFactors = FALSE)
  policy <- do.call(rbind, lapply(seq_len(n), function(i) pilot_quarantine_state(
    joint[i], suspicious[i], status[i], identity_ambiguous =
      is.na(x$winner_id[i]) || is.na(x$loser_id[i]) || x$winner_id[i] == x$loser_id[i])))
  row_audit <- cbind(row_audit, policy)
  for (i in seq_len(nrow(coverage))) {
    valid <- sum(policy$included_in_valid_numerator & cohorts[[coverage$cohort[i]]])
    coverage$complete_without_count_flags[i] <- valid
    coverage$unflagged_pct[i] <- if (coverage$denominator[i]) 100 * valid / coverage$denominator[i] else NA_real_
  }
  status_levels <- c("score_consistent_with_completion", "retirement_marker", "walkover_marker",
    "default_marker", "unfinished_marker", "numeric_unfinished_or_inconsistent", "other_marker_or_format", "missing_score")
  statuses <- do.call(rbind, lapply(status_levels, function(s) data.frame(tour = tour,
    status_evidence = s, rows = sum(status == s), joint_complete = sum(joint[status == s]))))
  event_fields <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size", "best_of")
  if (any(vapply(x[event_fields], function(v) length(unique(v)) != 1L || anyNA(v), logical(1)))) {
    stop("Conflicting event metadata: ", tour)
  }
  event <- cbind(data.frame(tour = tour), x[1, event_fields, drop = FALSE],
    data.frame(matches = n, unique_players = length(unique(ids[!is.na(ids)])),
               schema_columns = ncol(x), actual_match_date_column = FALSE))
  list(event = event, availability = availability, coverage = coverage,
       checks = do.call(rbind, checks), identities = identities, statuses = statuses,
       rows = row_audit, rounds = data.frame(tour = tour, round = names(table(x$round)),
                                           rows = as.integer(table(x$round))))
}

pilot_markdown_table <- function(x) {
  values <- lapply(x, function(v) {
    if (is.numeric(v)) v <- format(round(v, 4), trim = TRUE, scientific = FALSE)
    v[is.na(v)] <- "not evaluable"
    gsub("|", "\\|", as.character(v), fixed = TRUE)
  })
  y <- as.data.frame(values, stringsAsFactors = FALSE, check.names = FALSE)
  c(paste0("| ", paste(names(x), collapse = " | "), " |"),
    paste0("| ", paste(rep("---", ncol(x)), collapse = " | "), " |"),
    apply(y, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |")), "")
}

pilot_write_report <- function(tables, manifest, subsets) {
  inventory_path <- "data/pilot/inventory/inventory-summary.csv"
  if (!file.exists(inventory_path)) stop("Run the offline inventory reconciliation before regenerating the current pilot report.")
  inventory <- read.csv(inventory_path, stringsAsFactors = FALSE)
  if (!all(inventory$reference_manifest_sha256 == pilot_sha256("data/manifests/inventory-reference-files.csv")) ||
      !all(inventory$pilot_manifest_sha256 == pilot_sha256("data/manifests/pilot-source-files.csv")))
    stop("Inventory summary provenance changed; regenerate reconciliation first.")
  config <- pilot_config()
  pin <- config$pinned_commit[1]
  base <- paste0("https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/", pin)
  rows <- tables$rows
  unusual <- rows[rows$status_evidence != "score_consistent_with_completion" | rows$count_review,
                  c("tour", "tourney_id", "match_num", "score", "status_evidence", "joint_complete", "count_review")]
  review <- do.call(rbind, lapply(names(subsets), function(tour) {
    x <- subsets[[tour]]
    selected <- rows$match_num[rows$tour == tour & rows$count_review]
    cbind(data.frame(tour = rep(tour, sum(x$match_num %in% selected))),
          x[x$match_num %in% selected, c("tourney_id", "match_num", "score", "w_SvGms", "l_SvGms"), drop = FALSE])
  }))
  threshold <- tables$coverage[tables$coverage$cohort == "non_walkover_rows", ]
  threshold$event_90pct_numerical <- ifelse(threshold$unflagged_pct >= 90, "PASS", "FAIL")
  threshold$season_95pct_admission <- "NOT ESTABLISHED: one event only"
  lines <- c(
    "# 2023 Indian Wells acquisition audit", "",
    "Generated by `R/audit_pilot_data.R`; do not edit generated findings or tables manually.", "",
    "Phase 1B follow-up: the original pilot detected the anomaly without inspecting the official match page. [Official comparison and adopted quarantine policy](wta-anomaly-and-quarantine-policy.md) now preserve that history and the new evidence. Raw annual files and both subsets remain unchanged.", "",
    "Phase 1C follow-up: [complete Indian Wells reconciliation](indian-wells-inventory-reconciliation.md) links all 95 results-inventory matches per tour. WTA passes inventory; ATP remains blocked by official PDF identity conflicts in two branches, affecting three non-bye matches and one bye entry. Phase 1B checked only match 268's official presence.", "",
    "Evidence labels apply to each following paragraph/table: **Directly verified from downloaded bytes**, **Directly verified from source documentation**, **Previously reported**, **Proposed**, or **Unresolved**. User approvals are recorded as the authority for the proposed pilot design, not as source evidence.", "",
    "## 1. Pilot purpose", "",
    "**Proposed (user-approved pilot):** Test the 2023 Indian Wells ATP/WTA main-draw singles source, using base R and locally retained annual files. The intended use is noncommercial educational portfolio research. Do not generalize this pilot to other events, seasons, or tours. No model, rating, factor, forecast, or actual match timestamp is constructed.", "",
    "## 2. Source and pinned revision", "",
    paste0("**Directly verified from source documentation:** [Archive commit](https://github.com/Aneeshers/tennis-sackmann-archive/commit/", pin, ") `", pin, "` and [archive README](", base, "/README.md) identify an archival mirror of Jeff Sackmann's datasets. The mirror claims June 2026 ATP/WTA upstream snapshots and grants no additional rights."), "",
    paste0("**Directly verified from source documentation:** Pinned directory listings confirm `atp/atp_matches_2023.csv` and `wta/wta_matches_2023.csv`, not the example `tennis_atp/` and `tennis_wta/` paths. [ATP listing](https://api.github.com/repos/Aneeshers/tennis-sackmann-archive/contents/atp?ref=", pin, ") and [WTA listing](https://api.github.com/repos/Aneeshers/tennis-sackmann-archive/contents/wta?ref=", pin, ") supply raw URLs, byte sizes, and Git blob identifiers. Only these two annual files were acquired."), "",
    "## 3. Files acquired", "",
    "**Directly verified from downloaded bytes:** Annual CSVs are unchanged under the pinned raw directory. The tracked [manifest](../data/manifests/pilot-source-files.csv) records retrieval time, paths, license, creator, mirror relationship, and checksums. Source URL and revision provenance were checked against directory documentation.", "",
    pilot_markdown_table(manifest[c("tour", "source_path", "retrieved_at_utc", "row_count")]),
    paste0("- [", manifest$tour, " raw source](", manifest$source_url, ")"), "",
    "## 4. Raw hashes and sizes", "",
    "**Directly verified from downloaded bytes:** SHA-256 is calculated by the existing system checksum utility; no package was installed. CSV row counts exclude headers. Source files are never rewritten.", "",
    pilot_markdown_table(manifest[c("tour", "byte_size", "row_count", "sha256")]),
    "## 5. Exact event selection", "",
    "**Directly verified from downloaded bytes:** Candidate names were searched case-insensitively for `indian|wells|paribas` in the annual tournament values. Each tour returned one unique candidate. Selection then uses the exact observed tour-specific ID/name, date label, and hard surface; ambiguous changes stop the script.", "",
    pilot_markdown_table(tables$candidates),
    "## 6. ATP event summary", "",
    "**Directly verified from downloaded bytes:** Raw source labels and observed row/player counts follow; draw size is not corrected to match the observed player count.", "",
    pilot_markdown_table(tables$event[tables$event$tour == "ATP", ]),
    "## 7. WTA event summary", "",
    "**Directly verified from downloaded bytes:** The two files have matching 49-column headers. Repeated player appearances across matches are expected. Main-draw rows may include players whose entry code says qualifier; those are not qualifying-round matches.", "",
    pilot_markdown_table(tables$event[tables$event$tour == "WTA", ]),
    "**Directly verified from downloaded bytes:** Source round counts, including nonplayed rows, follow.", "",
    pilot_markdown_table(tables$rounds),
    paste0("**Directly verified from source documentation:** The [dictionary](", base, "/atp/matches_data_dictionary.txt) says draw sizes may be rounded to powers of two. Thus ATP's 128 is not proof of 128 participants. Original category codes M and PM are retained. Phase 1C verifies 128 bracket positions, 32 byes and 96 entrants on each tour's HTML draw; ATP PDF identities still conflict with its HTML records."), "",
    "## 8. Required-field availability", "",
    "**Directly verified from downloaded bytes:** Each percentage uses all source event rows, including walkovers. Zeros are counted separately from missing values. Suspicious counts include constraint flags and both service-game fields of a match needing score reconciliation; they are not asserted corrections.", "",
    pilot_markdown_table(tables$availability),
    "## 9. Joint completeness", "",
    "**Directly verified from downloaded bytes:** Joint completeness requires all nine counts on both sides. `non_walkover_rows` retains retirements and is a pilot sensitivity denominator, not a settled retirement policy. `completed_score_syntax` is a separate sensitivity view, not an official completion status. Count-flagged rows stay in denominators and source subsets but leave the unflagged numerator.", "",
    pilot_markdown_table(tables$coverage),
    "## 10. Count validation", "",
    "**Proposed:** Nonnegative finite integer checks and component bounds screen impossible values. Second-serve opportunities use service points minus first serves in only when nonnegative. Service-game review compares both players' games against scored games minus completed tie-break games; retirement rows may include one unfinished service game. This pilot scoring rule requires review before wider format coverage.", "",
    "**Directly verified from downloaded bytes:** All executed checks are listed, including unevaluable comparisons. Missingness is measured separately; a missing value is not a negative-number violation. Algebraic consistency is not independent confirmation of source correctness.", "",
    pilot_markdown_table(tables$checks),
    "**Directly verified from downloaded bytes:** Count-review rows, preserved without correction:", "",
    pilot_markdown_table(review),
    "**Directly verified in Phase 1B:** The saved official WTA LS033 page repeats the two service-game counts of 11 and agrees on all 18 required counts. Published agreement does not repair the 22-versus-29 game conflict or prove independent source accuracy. Official draw evidence confirms this match's players/result/round/score only. Supplementary Tennis Abstract break-point counts disagree; neither source is selected as a correction. See the [Phase 1B evidence and hashes](wta-anomaly-and-quarantine-policy.md).", "",
    "**Implemented policy (user-approved Phase 1B):** Match 268's entire statistical bundle is quarantined under policy 1.0.0 with `structural_count_conflict`; supplementary disagreement also receives `cross_source_conflict` in the anomaly disposition. Preserve the row in inventory and the played denominator, exclude it from the valid numerator, Four Factors, factor weights and strength summaries. Raw values stay unchanged. Chronology/status gates prohibit rating and forecast admission. Correct service-game values remain unknown.", "",
    pilot_markdown_table(rows[rows$tour == "WTA" & rows$match_num %in% c("268", "270"),
      c("match_num", "required_fields_present", "structural_checks_passed", "statistical_bundle_quarantined",
        "included_in_event_inventory", "included_in_played_denominator", "included_in_valid_numerator",
        "factor_statistics_candidate", "eligible_for_factor_analysis", "eligible_for_rating_updates",
        "eligible_for_chronological_forecasting")]),
    "## 11. Duplicates and identities", "",
    "**Directly verified from downloaded bytes:** Duplicate full rows and tournament-match keys, missing identifiers, same-player matches, and ID/name mapping conflicts are checked within each pilot event. Cross-source canonical identity has not been established. Repeated appearances are reported separately from identity errors.", "",
    pilot_markdown_table(tables$identities),
    "## 12. Scores and statuses", "",
    "**Directly verified from downloaded bytes:** Neither file provides a dedicated completion/retirement/walkover status column. Labels below describe observed score syntax or explicit markers; they do not invent an official completion status. Retirement rows are retained with their partial-match statistics. The WTA walkover has none of the 18 required counts populated.", "",
    pilot_markdown_table(tables$statuses),
    "**Directly verified from downloaded bytes:** All unusual-marker or count-review rows:", "",
    pilot_markdown_table(unusual),
    "## 13. Dates and ordering", "",
    "**Directly verified from downloaded bytes:** The only date/status-like header is `tourney_date`; every selected row carries `20230306`. There is no actual match-date, start-time, or completion-time column. Match number, row position, and round remain source labels.", "",
    paste0("**Directly verified from source documentation:** The [dictionary](", base, "/atp/matches_data_dictionary.txt) describes tournament-week dates and potentially arbitrary match numbers. [ATP README](", base, "/atp/UPSTREAM_README.md) dates rankings/age to the tournament date; [WTA README](", base, "/wta/UPSTREAM_README.md) points to the same format."), "",
    "**Unresolved:** Exact chronological Elo updates and rolling statistics cannot be justified from these fields alone. Phase 1B records WTA's match-specific date 2023-03-12 and Tennis Abstract's URL label 20230311, without resolving timezone or actual-play semantics. WTA's completed card also conflicts with its scheduled JSON-LD status. No canonical date or event-wide chronology is inferred; actual-date/completion-order policy remains required before forecasts.", "",
    "## 14. Provisional thresholds", "",
    "**Proposed (user-approved provisional thresholds):** 90% per event cell and 95% per tour-season. The following numerical comparison uses observed non-walkover rows, retains retirements, and excludes count-review rows only from the valid numerator.", "",
    pilot_markdown_table(threshold[c("tour", "denominator", "joint_complete", "joint_pct", "complete_without_count_flags", "unflagged_pct", "event_90pct_numerical", "season_95pct_admission")]),
    "**Directly verified in Phase 1C:** Each results-inventory match has one source row, with no unmatched result/source rows or duplicate links. ATP has three matches flagged for conflicting PDF identity evidence; its gate is withheld. WTA passes inventory without repairing the quarantined statistics. The 95% tour-season gate remains untested; retirement and chronology policies still block model admission.", "",
    pilot_markdown_table(inventory[c("tour", "official_non_bye", "linked_matches", "matched_conflicts", "inventory_gate")]),
    "## 15. Changes to the earlier contract's evidence", "",
    "**Directly verified from downloaded bytes:** Both annual headers contain the required statistical and identity columns; availability is demonstrated for these two events only. WTA walkovers can exist with absent counts; retirement rows here retain all required counts. Actual match-date/status fields are absent. ATP draw size can differ from observed participants. Service-game inconsistencies can survive nonmissingness and simple bounds.", "",
    "**Previously reported:** The PDF's full-panel 99.26% service-point completeness was not reproduced. It is neither this pilot's denominator nor an all-field completeness result. [Contract](data-source-contract.md) retains those distinctions.", "",
    "## 16. Licensing and attribution", "",
    paste0("**Directly verified from source documentation:** [Pinned archive license](", base, "/LICENSE) and preserved upstream READMEs identify Jeff Sackmann / Tennis Abstract and CC BY-NC-SA 4.0. Attribution, noncommercial use, change notices, and applicable share-alike conditions remain. The archive adds no rights."), "",
    "**Proposed (user-approved local use):** Preserve raw files outside Git; track provenance and aggregate audit evidence with source attribution. See [DATA_LICENSE.md](../DATA_LICENSE.md). Original code and third-party data have separate licenses. Player-level derived publication and portfolio compatibility require review; this milestone publishes nothing.", "",
    "## 17. Questions answered", "",
    "**Directly verified from downloaded bytes:** The two approved annual files are obtainable and parseable; exact pilot identities are distinguishable; required counts largely exist; explicit score markers expose walkovers/retirements; one count inconsistency and the match-date limitation are visible. Local subsets retain all event rows and original columns.", "",
    "## 18. Open questions and implementation limits", "",
    "**Unresolved:** Correct statistics for quarantined WTA match 268; ATP official-reference precedence for the Carreño Busta/Albot and Kudla/Wawrinka branches; final retirement/default rules; exact-date and completion-order evidence; generalization beyond one shared hard-court event; later source versions and derived-publication rights. No broader season, canonical table or model has been validated. Phase 1C uses preserved browser-service text after direct ATP HTML returned 403; that capture is not an original HTTP response and requires restoration for fresh offline reproduction.", "",
    paste0("**Previously reported (this task's runtime and code verification):** This report was generated using ", R.version.string, ". The download script uses base R libcurl and the installed checksum utility. Existing files must agree with the manifest before reuse. Outputs contain repository-relative paths."), "",
    "**Previously reported (this task's tool log):** The first sandboxed base-R download failed DNS resolution; the authorized network-enabled retry succeeded using the same script and URLs. No shell downloader or package fallback was used. Browser directory views failed, but pinned GitHub directory metadata was available. PDF extraction initially warned about standard fonts; its text was readable and subsequent extraction supplied the bundled font path.", "",
    "## 19. Expansion recommendation", "",
    "**Proposed:** Do not expand the development panel yet. Review Phase 1C's ATP official-reference conflicts and explicitly settle precedence before closing that gate. WTA inventory passage and high numerical coverage alone do not authorize broader acquisition or modeling.", "",
    "## 20. Exact next milestone", "",
    "**Proposed:** Phase 1D: approve and implement an event-scoped official-reference precedence decision for the two conflicting ATP branches, using existing evidence first; regenerate reconciliation and gate documentation. Preserve the dissenting PDF observations and WTA quarantine. Do not acquire another season or start ratings. Any later expansion requires separately authorized files, paths and tools; chronology policy must precede ratings.", "",
    "**Proposed:** Every next task must end with a written ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000; do not send it or create another task without a separate request.", ""
  )
  while (length(lines) && !nzchar(tail(lines, 1))) lines <- head(lines, -1)
  writeLines(lines, "docs/pilot-acquisition-audit.md", useBytes = TRUE)
}

audit_pilot_data <- function() {
  config <- pilot_config()
  manifest <- pilot_read_manifest(config)
  if (is.null(manifest) || !setequal(manifest$tour, config$tour)) stop("Both manifested source files are required.")
  results <- list()
  subsets <- list()
  candidates <- list()
  for (i in seq_len(nrow(config))) {
    tour <- config$tour[i]
    record <- manifest[match(tour, manifest$tour), , drop = FALSE]
    pilot_validate_file(config$local_path[i], record)
    annual <- pilot_read_csv(config$local_path[i])
    event_cols <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size")
    if (!all(event_cols %in% names(annual))) stop("Missing event context: ", tour)
    candidate <- unique(annual[grepl("indian|wells|paribas", annual$tourney_name, ignore.case = TRUE), event_cols])
    candidates[[tour]] <- cbind(tour = tour, candidate)
    # These values were inspected in the two downloaded annual files before
    # implementing this selector. Ambiguous or changed labels stop the pilot.
    expected_id <- c(ATP = "2023-0404", WTA = "2023-609")[[tour]]
    expected_name <- c(ATP = "Indian Wells Masters", WTA = "Indian Wells")[[tour]]
    if (nrow(candidate) != 1L || candidate$tourney_id != expected_id ||
        candidate$tourney_name != expected_name || candidate$tourney_date != "20230306" ||
        candidate$surface != "Hard") stop("Indian Wells source identity requires review: ", tour)
    x <- annual[!is.na(annual$tourney_id) & annual$tourney_id == expected_id, , drop = FALSE]
    if (any(x$best_of != "3") || anyNA(x$best_of)) stop("Pilot requires observed best-of-three singles.")
    # Explicitly inspect date/status column names; never fabricate match dates.
    date_fields <- grep("date|time|status|retir|walk", names(x), ignore.case = TRUE, value = TRUE)
    if (!identical(date_fields, "tourney_date")) stop("Unexpected date/status fields require review: ", tour)
    subsets[[tour]] <- x
    results[[tour]] <- pilot_audit_event(x, tour)
  }
  dir.create("data/pilot", showWarnings = FALSE)
  for (tour in names(subsets)) pilot_write_csv(subsets[[tour]], paste0("data/pilot/", tolower(tour), "_indian_wells_2023.csv"))
  tables <- lapply(names(results[[1]]), function(name) do.call(rbind, lapply(results, `[[`, name)))
  names(tables) <- names(results[[1]])
  tables$candidates <- do.call(rbind, candidates)
  for (name in names(tables)) pilot_write_csv(tables[[name]], paste0("data/pilot/", name, ".csv"))
  pilot_write_report(tables, manifest, subsets)
  message("Pilot audit complete; generated subsets and audit tables under ignored data/pilot/.")
  print(tables$event, row.names = FALSE)
  print(tables$coverage, row.names = FALSE)
  print(tables$checks[tables$checks$flagged_rows > 0L, ], row.names = FALSE)
  invisible(tables)
}

if (sys.nframe() == 0L) audit_pilot_data()
