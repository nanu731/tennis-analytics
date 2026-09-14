# Offline Phase 1B audit. Base R parses saved HTML; existing pdftotext reads the PDF.
source("R/audit_pilot_data.R")
source("R/download_anomaly_references.R")

anomaly_matches <- function(pattern, text) {
  regmatches(text, gregexpr(pattern, text, perl = TRUE))[[1]]
}

anomaly_capture <- function(pattern, text) {
  m <- regexec(pattern, text, perl = TRUE)
  value <- regmatches(text, m)[[1]]
  if (length(value) < 2L) NA_character_ else value[2]
}

anomaly_text <- function(html) {
  x <- gsub("(?s)<[^>]+>", " ", html, perl = TRUE)
  x <- gsub("&nbsp;|&#160;", " ", x)
  x <- gsub("&amp;", "&", x, fixed = TRUE)
  trimws(gsub("[[:space:]]+", " ", x))
}

anomaly_html <- function(path) rawToChar(readBin(path, "raw", n = file.info(path)$size))

anomaly_wta_card <- function(html, draw = FALSE) {
  # Scope to LS033 before reading team rows; never match unrelated news or matches.
  anchor <- if (draw) 'class="tennis-match tennis-match--slim js-match-0609-2023-LS033' else
    'class="tennis-match js-tennis-match js-match-0609-2023-LS033'
  pieces <- strsplit(html, anchor, fixed = TRUE)[[1]]
  if (length(pieces) != 2L) stop("Unique LS033 match card unavailable.")
  card <- strsplit(pieces[2], "</table>", fixed = TRUE)[[1]][1]
  team <- lapply(c("a", "b"), function(side) {
    block <- anomaly_capture(paste0('(?s)(<tr class="match-table__row js-team-', side, '[^>]*>.*?</tr>)'), card)
    if (is.na(block)) stop("Player orientation unavailable in LS033 card.")
    opening <- strsplit(block, ">", fixed = TRUE)[[1]][1]
    cells <- anomaly_matches('(?s)<td class="match-table__score-cell[^>]*>.*?</td>', block)
    list(name = anomaly_text(anomaly_capture('(?s)<span class="match-table__player-fullname">(.*?)</span>', block)),
         score = vapply(cells, anomaly_text, character(1)), winner = grepl("is-winner", opening, fixed = TRUE))
  })
  if (length(team[[1]]$score) != 3L || length(team[[2]]$score) != 3L ||
      sum(vapply(team, `[[`, logical(1), "winner")) != 1L) stop("LS033 score/winner extraction requires review.")
  win <- which(vapply(team, `[[`, logical(1), "winner"))
  list(team = team, winner_side = win,
    score = paste(paste(team[[win]]$score, team[[3L - win]]$score, sep = "-"), collapse = " "),
    completed = anomaly_capture('data-completed="([^"]+)"', card),
    status = anomaly_capture('data-status="([^"]+)"', card))
}

anomaly_wta_statistics <- function(html) {
  tabs <- strsplit(html, 'class="mc-stats__tab-content js-match-stats"', fixed = TRUE)[[1]]
  if (length(tabs) != 2L) stop("Whole-match statistics tab unavailable.")
  match_tab <- strsplit(tabs[2], 'class="mc-stats__tab-content js-set1-stats', fixed = TRUE)[[1]][1]
  service <- anomaly_capture('(?s)>Service</h3>(.*?)>Return</h3>', match_tab)
  if (is.na(service)) stop("Whole-match Service section unavailable; no set-level substitution.")
  blocks <- strsplit(service, '<div class="compare-stats-block__row">', fixed = TRUE)[[1]][-1]
  labels <- vapply(blocks, function(b) anomaly_text(anomaly_capture(
    '(?s)<div class="compare-stats-block__label[^>]*>(.*?)</div>', b)), character(1))
  read_pair <- function(label, detail = FALSE) {
    take <- which(labels == label)
    if (length(take) != 1L) return(rep(NA_character_, 2))
    cls <- if (detail) "detail" else "stat"
    values <- anomaly_matches(paste0('(?s)<div class="compare-stats-block__', cls, ' [^>]*>.*?</div>'), blocks[take])
    if (length(values) != 2L) return(rep(NA_character_, 2))
    vapply(values, anomaly_text, character(1))
  }
  component <- function(x, part) vapply(x, function(v) {
    if (is.na(v) || !grepl("^[0-9]+/[0-9]+$", v)) return(NA_character_)
    strsplit(v, "/", fixed = TRUE)[[1]][part]
  }, character(1))
  first <- read_pair("1st Serve", TRUE)
  saved <- read_pair("Break Points Saved", TRUE)
  data.frame(ace = read_pair("Aces"), df = read_pair("Double Faults"),
    svpt = component(first, 2), `1stIn` = component(first, 1),
    `1stWon` = component(read_pair("1st Serve Points Won", TRUE), 1),
    `2ndWon` = component(read_pair("2nd Serve Points Won", TRUE), 1),
    SvGms = read_pair("Service Games Played"), bpFaced = read_pair("Break Points Faced"),
    bpSaved = component(saved, 1), check.names = FALSE, stringsAsFactors = FALSE)
}

anomaly_pdf_text <- function(path) {
  executable <- Sys.getenv("ANOMALY_PDFTOTEXT", unset = "")
  if (!nzchar(executable)) executable <- unname(Sys.which("pdftotext"))
  if (!nzchar(executable)) executable <- path.expand(
    "~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext")
  if (!file.exists(executable)) stop("Existing pdftotext unavailable; set ANOMALY_PDFTOTEXT. Do not install software.")
  x <- system2(executable, c("-f", "1", "-l", "1", "-layout", shQuote(path), "-"), stdout = TRUE)
  if (!is.null(attr(x, "status"))) stop("PDF extraction failed.")
  x
}

anomaly_compare <- function(original, observed, normalized = FALSE) {
  if (is.na(original) || is.na(observed) || !nzchar(original) || !nzchar(observed)) return("unavailable")
  if (identical(as.character(original), as.character(observed))) return("exact agreement")
  if (normalized) "normalized agreement" else "disagreement"
}

anomaly_validate_bundle <- function(row, comparison = NULL, reference_available = TRUE, status_conflict = FALSE) {
  result <- pilot_audit_event(row, "WTA")
  conflict <- !is.null(comparison) && any(comparison$comparison == "disagreement" & comparison$is_count)
  state <- pilot_quarantine_state(result$rows$joint_complete, result$rows$count_review,
    result$rows$status_evidence, cross_source_conflict = conflict,
    identity_ambiguous = result$rows$missing_player_id || isTRUE(result$rows$same_player_both_sides),
    reference_available = reference_available, status_conflict = status_conflict)
  list(state = state, checks = result$checks, rows = result$rows)
}

audit_wta_anomaly <- function() {
  refs <- anomaly_reference_manifest()
  for (i in seq_len(nrow(refs))) anomaly_validate_reference(refs[i, , drop = FALSE])
  get_ref <- function(id) refs$local_path[match(id, refs$reference_id)]
  source_manifest <- pilot_read_manifest(pilot_config())
  record <- source_manifest[source_manifest$tour == "WTA", , drop = FALSE]
  pilot_validate_file(record$local_path, record)
  annual <- pilot_read_csv(record$local_path)
  row <- annual[annual$tourney_id == "2023-609" & annual$match_num == "268", , drop = FALSE]
  if (nrow(row) != 1L || row$winner_name != "Bianca Andreescu" || row$loser_name != "Peyton Stearns" ||
      row$round != "R64" || row$score != "4-6 6-4 6-3") stop("Exact source match identity changed.")
  html <- anomaly_html(get_ref("wta_match"))
  card <- anomaly_wta_card(html)
  if (card$winner_side != 2L || card$team[[1]]$name != "P. Stearns" ||
      card$team[[2]]$name != "B. Andreescu") stop("Official/source player mapping requires review.")
  stats <- anomaly_wta_statistics(html)
  sports <- anomaly_matches('(?s)<script type="application/ld\\+json">.*?</script>', html)
  sports <- sports[grepl('"name": "Stearns vs. Andreescu"', sports, fixed = TRUE)]
  if (length(sports) != 1L) stop("Match-specific structured metadata unavailable.")
  date <- anomaly_capture('"startDate": "([^"]+)"', sports)
  duration <- anomaly_capture('(?s)"name": "Match Duration",\\s*"value": "([^"]+)"', sports)
  json_status <- anomaly_capture('"eventStatus": "([^"]+)"', sports)
  comparison <- list()
  add <- function(field, original, observed, ref, locator, normalized = FALSE, is_count = FALSE,
                  assessment = "not independently validated", note = "") {
    comparison[[length(comparison) + 1L]] <<- data.frame(source_match_key = "sackmann:WTA:2023-609:268",
      field = field, source_value = as.character(original), reference_value = as.character(observed),
      reference_id = ref, reference_locator = locator,
      comparison = anomaly_compare(original, observed, normalized), is_count = is_count,
      structural_assessment = assessment, note = note, stringsAsFactors = FALSE)
  }
  add("winner_name", row$winner_name, card$team[[2]]$name, "wta_match", "LS033 js-team-b is-winner", TRUE)
  add("loser_name", row$loser_name, card$team[[1]]$name, "wta_match", "LS033 js-team-a", TRUE)
  official_round <- anomaly_capture('"description": "BNP Paribas Open - ([^"]+)"', sports)
  add("round", row$round, official_round, "wta_match", "match SportsEvent description",
      normalized = identical(official_round, "Round of 64"))
  add("score", row$score, card$score, "wta_match", "LS033 team set-score cells")
  add("completion_status", NA_character_, paste(card$completed, card$status, sep = ";"), "wta_match",
      "LS033 data-completed; data-status", note = "Official card says completed/F; source has no status column.")
  add("status_structured_metadata", NA_character_, json_status, "wta_match", "match SportsEvent eventStatus",
      assessment = "unresolved", note = "EventScheduled conflicts with completed/F card; generic hidden UI labels are not status evidence.")
  add("actual_match_date", NA_character_, date, "wta_match", "match SportsEvent startDate; visible Start Time",
      assessment = "unresolved", note = "Published match-associated date only; timezone and actual-play semantics not established.")
  minute_parts <- suppressWarnings(as.numeric(strsplit(duration, ":", fixed = TRUE)[[1]]))
  same_minutes <- length(minute_parts) == 3L && !anyNA(minute_parts) &&
    as.numeric(row$minutes) == minute_parts[1] * 60 + minute_parts[2]
  add("duration", row$minutes, duration, "wta_match", "match SportsEvent Match Duration",
      same_minutes, note = "Sackmann integer minutes versus official HH:MM:SS; normalization compares hours/minutes only.")
  for (side in c("w_", "l_")) for (field in names(stats)) {
    official_side <- if (side == "w_") 2L else 1L
    add(paste0(side, field), row[[paste0(side, field)]], stats[[field]][official_side], "wta_match",
      paste0("whole-match Service section; official side ", official_side), is_count = TRUE,
      assessment = if (field == "SvGms") "structurally invalid" else "not independently validated",
      note = if (field == "SvGms") "Published agreement does not resolve 22 service games versus 29 score games." else
        "Numerator/denominator counts extracted from displayed fractions where applicable; no percentage reconstruction.")
  }
  draw <- anomaly_wta_card(anomaly_html(get_ref("wta_draw_page")), TRUE)
  add("score", row$score, draw$score, "wta_draw_page", "LS033 team set-score cells")
  add("winner_name", row$winner_name, draw$team[[draw$winner_side]]$name, "wta_draw_page", "LS033 winner row",
      normalized = draw$team[[draw$winner_side]]$name == "B. Andreescu")
  add("loser_name", row$loser_name, draw$team[[3L-draw$winner_side]]$name, "wta_draw_page", "LS033 opposing row",
      normalized = draw$team[[3L-draw$winner_side]]$name == "P. Stearns")
  pdf <- anomaly_pdf_text(get_ref("wta_draw_pdf"))
  stearns <- grep("STEARNS, Peyton", pdf, fixed = TRUE)
  andreescu <- grep("ANDREESCU, Bianca", pdf, fixed = TRUE)
  if (length(stearns) != 1L || length(andreescu) != 1L || andreescu != stearns + 2L) stop("PDF target draw positions require review.")
  pdf_score <- anomaly_capture("(46 64 63)", pdf[stearns + 1L])
  add("score", row$score, pdf_score, "wta_draw_pdf", "page 1, positions 6-8, R64 result column",
      normalized = !is.na(pdf_score) && pdf_score == gsub("-", "", row$score, fixed = TRUE),
      note = "Bracket placement also visually reviewed; no complete draw reconciliation performed.")
  add("winner_name", row$winner_name, anomaly_capture("(B\\. Andreescu)", pdf[stearns]), "wta_draw_pdf",
      "page 1 R64 advancing player beside positions 6-8", TRUE)
  ta <- anomaly_html(get_ref("tennis_abstract"))
  result_line <- anomaly_capture('<b>(Bianca Andreescu d\\. Peyton Stearns [^<]+)</b>', ta)
  add("score", row$score, anomaly_capture("Stearns (.*)$", result_line), "tennis_abstract", "visible result heading")
  add("date_url", NA_character_, anomaly_capture("charting/([0-9]{8})-", refs$url[refs$reference_id == "tennis_abstract"]),
      "tennis_abstract", "source URL date label", assessment = "unresolved",
      note = "URL says 20230311; WTA says 2023-03-12. No timezone reconciliation or canonical date selected.")
  overview <- anomaly_capture("(?s)var overview = '(.*?)';", ta)
  overview_rows <- anomaly_matches("(?s)<tr><td align=\"left\">(?:Peyton Stearns|Bianca Andreescu)</td>.*?</tr>", overview)
  # Only the first whole-match row per player; later set rows are excluded.
  for (i in seq_len(min(2L, length(overview_rows)))) {
    cells <- anomaly_matches("(?s)<td[^>]*>.*?</td>", overview_rows[i])
    values <- vapply(cells, anomaly_text, character(1))
    if (length(values) < 7L || !grepl("^[0-9]+/[0-9]+$", values[7])) next
    side <- if (values[1] == row$winner_name) "w_" else if (values[1] == row$loser_name) "l_" else stop("Charting orientation unknown.")
    bp <- strsplit(values[7], "/", fixed = TRUE)[[1]]
    for (j in 1:2) {
      field <- paste0(side, c("bpSaved", "bpFaced")[j])
      add(field, row[[field]], bp[j], "tennis_abstract", "overview whole-match BPSaved fraction", is_count = TRUE,
          note = "Supplementary conflicting observation; not an authorized correction.")
    }
  }
  comparison <- do.call(rbind, comparison)
  status_conflict <- identical(card$completed, "true") && identical(card$status, "F") &&
    !is.na(json_status) && grepl("EventScheduled$", json_status)
  validation <- anomaly_validate_bundle(row, comparison, status_conflict = status_conflict)
  official_game_conflict <- pilot_game_check(card$score, "score_consistent_with_completion",
    suppressWarnings(as.numeric(stats$SvGms[2])), suppressWarnings(as.numeric(stats$SvGms[1])))
  validation$checks <- rbind(validation$checks, data.frame(tour = "WTA",
    check = "official_service_games_vs_completed_score", evaluated_rows = as.integer(!is.na(official_game_conflict)),
    flagged_rows = as.integer(isTRUE(official_game_conflict)), not_evaluable_rows = as.integer(is.na(official_game_conflict))))
  if (!grepl("structural_count_conflict", validation$state$reason_codes, fixed = TRUE)) stop("Expected structural failure missing.")
  disposition <- data.frame(source_match_key = "sackmann:WTA:2023-609:268",
    reason_code = strsplit(validation$state$reason_codes, ";", fixed = TRUE)[[1]], stringsAsFactors = FALSE)
  conflict_fields <- unique(comparison$field[comparison$comparison == "disagreement" & comparison$is_count])
  disposition$affected_fields <- ifelse(disposition$reason_code == "structural_count_conflict", "w_SvGms;l_SvGms;entire statistical bundle",
    ifelse(disposition$reason_code == "cross_source_conflict", paste(conflict_fields, collapse = ";"),
      ifelse(disposition$reason_code == "status_unresolved", "completion_status;status_structured_metadata", "actual match date;completion order")))
  disposition$evidence_references <- "pilot-source-files.csv:WTA;anomaly-reference-files.csv:wta_match,wta_draw_pdf,wta_draw_page,tennis_abstract"
  selected <- comparison[comparison$is_count | comparison$field %in% c("actual_match_date", "date_url", "completion_status", "status_structured_metadata"), ]
  disposition$original_values <- paste(paste(selected$field, selected$source_value, sep = "="), collapse = ";")
  disposition$comparison_values <- paste(paste(selected$reference_id, selected$field, selected$reference_value, sep = ":"), collapse = ";")
  disposition$structural_test <- paste0("Completed ", row$score, ": 29 games, no tie-break; source service games=",
    row$w_SvGms, "+", row$l_SvGms, "; equality fails")
  disposition$disposition <- "quarantine_entire_statistical_bundle_preserve_inventory"
  disposition$permitted_uses <- "match inventory;provenance;result/identity/score/round audit;invalidity reporting"
  disposition$prohibited_uses <- "valid count numerator;Four Factors;factor weights;player-strength summaries;Elo updates;forecasting;unapproved reconstruction"
  disposition$review_status <- "quarantine adopted;correct values and chronology unresolved"
  disposition$policy_version <- "1.0.0"
  disposition <- cbind(disposition, validation$state[rep(1L, nrow(disposition)), setdiff(names(validation$state), "policy_version")])
  dir.create("data/pilot/anomaly", recursive = TRUE, showWarnings = FALSE)
  outputs <- list(`anomaly-source-comparison` = comparison, `anomaly-validation-checks` = validation$checks,
                  `anomaly-disposition` = disposition)
  coverage <- lapply(seq_len(nrow(source_manifest)), function(i) {
    rec <- source_manifest[i, , drop = FALSE]
    pilot_validate_file(rec$local_path, rec)
    x <- pilot_read_csv(rec$local_path)
    id <- if (rec$tour == "ATP") "2023-0404" else "2023-609"
    x <- x[x$tourney_id == id, , drop = FALSE]
    subset <- pilot_read_csv(paste0("data/pilot/", tolower(rec$tour), "_indian_wells_2023.csv"))
    rownames(x) <- rownames(subset) <- NULL
    if (!identical(x, subset)) stop("Pilot subset differs from annual source rows.")
    audit <- pilot_audit_event(x, rec$tour)
    states <- audit$rows
    # The investigated WTA bundle also has supplementary count conflicts.
    if (rec$tour == "WTA") {
      k <- which(states$match_num == "268")
      states[k, names(validation$state)] <- validation$state
    }
    denominator <- sum(states$included_in_played_denominator)
    numerator <- sum(states$included_in_valid_numerator)
    data.frame(tour = rec$tour, event_inventory_rows = nrow(x), walkovers = sum(states$status_evidence == "walkover_marker"),
      played_denominator = denominator, required_counts_present = sum(states$required_fields_present),
      structural_conflicts = sum(states$count_review),
      played_bundles_quarantined = sum(states$statistical_bundle_quarantined & states$included_in_played_denominator),
      valid_numerator = numerator, valid_pct = 100 * numerator / denominator,
      event_90pct = if (100 * numerator / denominator >= 90) "PASS_NUMERICAL_ONLY" else "FAIL",
      tour_season_95pct = "NOT_TESTED", factor_admission = "NOT_AUTHORIZED",
      rating_and_forecast_admission = "NOT_AUTHORIZED", retirement_policy = "UNRESOLVED")
  })
  outputs$`anomaly-coverage` <- do.call(rbind, coverage)
  for (name in names(outputs)) pilot_write_csv(outputs[[name]], paste0("data/pilot/anomaly/", name, ".csv"))
  message("Phase 1B: statistical bundle quarantined; inventory retained; no correction or model authorization.")
  print(validation$state, row.names = FALSE)
  invisible(outputs)
}

anomaly_self_test <- function() {
  m <- pilot_read_manifest(pilot_config())
  x <- pilot_read_csv(m$local_path[m$tour == "WTA"])
  event <- x[x$tourney_id == "2023-609", , drop = FALSE]
  real <- event[event$match_num == "268", , drop = FALSE]
  actual <- anomaly_validate_bundle(real)$state
  stopifnot(grepl("structural_count_conflict", actual$reason_codes, fixed = TRUE),
    actual$included_in_played_denominator, !actual$included_in_valid_numerator,
    !actual$factor_statistics_candidate, !actual$eligible_for_rating_updates)
  inspected <- pilot_audit_event(event, "WTA")$rows
  valid <- event[which(inspected$status_evidence == "score_consistent_with_completion" &
                        inspected$joint_complete & !inspected$count_review)[1], , drop = FALSE]
  good <- anomaly_validate_bundle(valid)$state
  stopifnot(!good$statistical_bundle_quarantined, good$included_in_valid_numerator)
  missing <- valid
  missing$w_SvGms <- NA_character_
  absent <- anomaly_validate_bundle(missing)$state
  stopifnot(grepl("missing_required_counts", absent$reason_codes, fixed = TRUE), !absent$included_in_valid_numerator)
  conflicting_value <- as.character(as.integer(valid$w_SvGms) + 1L)
  comparison <- data.frame(comparison = anomaly_compare(valid$w_SvGms, conflicting_value), is_count = TRUE)
  conflict <- anomaly_validate_bundle(valid, comparison)$state
  stopifnot(grepl("cross_source_conflict", conflict$reason_codes, fixed = TRUE), !conflict$included_in_valid_numerator)
  unresolved_status <- anomaly_validate_bundle(valid, status_conflict = TRUE)$state
  stopifnot(grepl("status_unresolved", unresolved_status$reason_codes, fixed = TRUE),
    !unresolved_status$factor_statistics_candidate, !unresolved_status$eligible_for_rating_updates)
  walkover <- anomaly_validate_bundle(event[event$match_num == "270", , drop = FALSE])$state
  stopifnot(walkover$included_in_event_inventory, !walkover$included_in_played_denominator,
    !grepl("structural_count_conflict", walkover$reason_codes, fixed = TRUE))
  stopifnot(isTRUE(pilot_game_check("4-6 6-4 6-3", "score_consistent_with_completion", 11, 11)),
    identical(pilot_game_check("6-4 6-4", "score_consistent_with_completion", 10, 10), FALSE))
  message("In-memory policy tests passed: real anomaly, valid match, missing service games, cross-source conflict, walkover.")
  invisible(TRUE)
}

if (sys.nframe() == 0L) {
  if ("--self-test" %in% commandArgs(trailingOnly = TRUE)) anomaly_self_test() else audit_wta_anomaly()
}
