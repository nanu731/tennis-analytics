# Phase 1F: offline source review, never an acquisition or eligibility pipeline.
source("R/audit_2021_annual_data.R")

montreal_version <- function() "WTA Montreal admission review 1.0.0"
montreal_fields <- function() annual_required()$field[annual_required()$group == "count"]
montreal_rounds <- function() c("R64", "R32", "R16", "QF", "SF", "F")

montreal_score <- function(score, best_of) {
  evidence <- annual_status(score)
  # Extract the literal suffix after a recognized token; do not interpret it.
  token <- "(?i)(?<![A-Z])RET(?:IREMENT|IRED|IRE)?(?![A-Z])"
  suffix <- vapply(score, function(s) {
    if (is.na(s)) return(NA_character_)
    hit <- regexpr(token, s, perl = TRUE)
    if (hit[1] < 0L) return("")
    trimws(substring(s, hit[1] + attr(hit, "match.length")))
  }, "", USE.NAMES = FALSE)
  component <- vapply(score, function(s) {
    if (is.na(s)) return(NA_character_)
    found <- regmatches(s,regexpr(token,s,perl=TRUE))
    if (length(found)) found else ""
  }, "", USE.NAMES = FALSE)
  unresolved <- !is.na(suffix) & nzchar(suffix)
  classification <- evidence$marker
  classification[evidence$retirement & unresolved] <- "recognized_retirement_marker_with_unresolved_suffix"
  completed <- mapply(pilot_score, score, best_of, USE.NAMES = FALSE) == "score_consistent_with_completion"
  completion_unresolved <- evidence$marker == "numeric_score_syntax" & !completed
  classification[completion_unresolved] <- "numeric_score_without_completion_evidence"
  data.frame(recognized_marker = evidence$marker, recognized_retirement_component = component, retirement = evidence$retirement,
    walkover = evidence$walkover, unresolved_residue = suffix, unresolved_suffix = unresolved,
    score_classification = classification,
    interpretation_state = ifelse(unresolved | completion_unresolved, "unresolved", "syntax_observation_only"),
    numeric_completed_syntax = completed, completion_unresolved = completion_unresolved, apparent_played = evidence$apparent_played)
}

montreal_bundle <- function(x) {
  fields <- montreal_fields()
  annual_require_columns(x)
  present <- as.data.frame(lapply(x[fields], function(v) !annual_missing(v)))
  malformed <- as.data.frame(lapply(x[fields], function(v) !annual_missing(v) & !grepl("^[0-9]+$", v)))
  n <- rowSums(present)
  data.frame(present_count = n, winner_present_count = rowSums(present[1:9]),
    loser_present_count = rowSums(present[10:18]), malformed_count = rowSums(malformed),
    bundle_state = ifelse(n == 0, "whole_bundle_missing", ifelse(n == 18, "whole_bundle_present", "partial_bundle")),
    missing_fields = vapply(seq_len(nrow(x)), function(i) paste(fields[!unlist(present[i, ])], collapse = ";"), ""))
}

montreal_structural <- function(x, score) {
  # Reuse count bounds/game rules, but never transfer the pilot quarantine policy.
  # The game/score check is not applied to an unresolved suffix. Only this
  # temporary validation input omits score; raw score remains in the inventory.
  do.call(rbind, lapply(seq_len(nrow(x)), function(i) {
    check_input <- x[i, , drop = FALSE]
    if (score$unresolved_suffix[i]) check_input$score <- NA_character_
    check <- pilot_audit_event(check_input, "WTA")$checks
    failed <- check$check[check$flagged_rows > 0]
    game <- check[check$check == "service_games_vs_score_review", ]
    data.frame(applicable_count_flags = paste(failed, collapse = ";"),
      applicable_count_checks_passed = !length(failed),
      game_score_check = if (score$unresolved_suffix[i]) "not_evaluable_unresolved_suffix" else
        if (!game$evaluated_rows) "not_evaluable" else if (game$flagged_rows) "flagged" else "passed")
  }))
}

montreal_select <- function(annual, candidate) {
  if (nrow(candidate) != 1L || candidate$tour != "WTA" || candidate$tourney_id != "2021-806" ||
      candidate$event_family_annotation != "Canada" || candidate$family_collision)
    stop("Exact Phase 1E WTA Montreal candidate unavailable or ambiguous.")
  index <- which(!is.na(annual$tourney_id) & annual$tourney_id == "2021-806")
  x <- annual[index, , drop = FALSE]
  fields <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size")
  if (!length(index) || anyDuplicated(x$match_num) ||
      any(vapply(fields, function(f) anyNA(x[[f]]) || !all(x[[f]] == candidate[[f]]), TRUE)) ||
      nrow(x) != candidate$source_rows) stop("Source event differs from Phase 1E candidate.")
  list(raw = x, index = index)
}

montreal_load <- function() {
  manifests <- list(`2021` = annual_2021_manifest(), `2023` = pilot_read_manifest(pilot_config()))
  files <- list(); provenance <- list()
  for (year in names(manifests)) for (i in seq_len(nrow(manifests[[year]]))) {
    r <- manifests[[year]][i, ]
    annual_2021_validate(r$local_path, r)
    files[[paste(r$tour, year)]] <- annual_2021_csv(r$local_path)
    provenance[[length(provenance) + 1L]] <- data.frame(tour = r$tour, year = year,
      path = r$local_path, size = r$byte_size, rows = r$row_count, sha256 = r$sha256, blob = r$source_git_blob)
  }
  candidates <- annual_candidates(files[["WTA 2021"]], "WTA")$candidates
  saved <- read.csv("data/pilot/development-2021/event-candidates.csv", colClasses = vapply(candidates,class,""))
  old <- saved[saved$tour == "WTA", names(candidates), drop = FALSE]
  rownames(old) <- rownames(candidates) <- NULL
  if (!isTRUE(all.equal(old, candidates, check.attributes = FALSE))) stop("Phase 1E candidate output differs from raw evidence.")
  selected <- montreal_select(files[["WTA 2021"]], candidates[candidates$tourney_id == "2021-806", ])
  list(files = files, provenance = do.call(rbind, provenance), candidates = candidates, selected = selected)
}

montreal_inventory <- function(evidence) {
  x <- evidence$selected$raw
  score <- montreal_score(x$score, x$best_of); bundle <- montreal_bundle(x)
  structural <- montreal_structural(x, score)
  raw_fields <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size",
    "match_num", "round", "winner_id", "winner_name", "loser_id", "loser_name", "score", "best_of", "minutes",
    "winner_rank", "winner_rank_points", "loser_rank", "loser_rank_points", montreal_fields())
  out <- cbind(data.frame(audit_id = paste("sackmann", "WTA", x$tourney_id, x$match_num, sep = ":"),
    tour = "WTA", season = 2021, source_data_row = evidence$selected$index,
    source_csv_line = evidence$selected$index + 1L, event_family_annotation = "Canada"), x[raw_fields], score, bundle, structural)
  out$complete_without_applicable_flags <- out$present_count == 18 & out$malformed_count == 0 & out$applicable_count_checks_passed
  out$official_inventory_state <- "unverified"
  out$modeling_admission <- "not_authorized"
  out$review_version <- montreal_version()
  out <- out[order(match(out$round, montreal_rounds()), out$match_num), ]
  rownames(out) <- NULL
  out
}

montreal_sensitivity <- function(x) {
  complete <- x$present_count == 18
  masks <- list(all_source_rows = rep(TRUE, nrow(x)), non_walkover = !x$walkover,
    phase1e_apparent_play = x$apparent_played, numeric_completed_syntax = x$numeric_completed_syntax,
    all_excluding_retirements = !x$retirement, apparent_play_excluding_retirements = x$apparent_played & !x$retirement,
    all_excluding_suffix = !x$unresolved_suffix, apparent_play_excluding_suffix = x$apparent_played & !x$unresolved_suffix,
    complete_bundles_only = complete, complete_bundles_without_applicable_flags_only = x$complete_without_applicable_flags)
  definitions <- c("All source rows; includes walkover", "All rows minus explicit walkover",
    "Positive scored games and no walkover; Phase 1E sensitivity", "Best-of-three completion-consistent numeric score syntax only",
    "All rows minus recognized RET; retains walkover", "Apparent-play rows minus recognized RET",
    "All rows minus unresolved suffix; retains walkover", "Apparent-play rows minus unresolved suffix",
    "Select on all 18 fields present; circular completeness diagnostic", "Select on complete bundles without applicable flags; circular diagnostic")
  do.call(rbind, lapply(seq_along(masks), function(i) {
    take <- masks[[i]]; n <- sum(take); c <- sum(take & complete); v <- sum(take & x$complete_without_applicable_flags)
    target <- ceiling(9L * n / 10L)
    data.frame(scenario = names(masks)[i], denominator_definition = definitions[i], denominator = n,
      complete_bundles = c, presence_pct = if (n) 100*c/n else NA_real_, complete_without_applicable_flags = v,
      applicable_valid_pct = if (n) 100*v/n else NA_real_, included_retirements = sum(take & x$retirement),
      included_suffix_rows = sum(take & x$unresolved_suffix), included_missing_bundles = sum(take & x$present_count == 0),
      included_walkovers = sum(take & x$walkover), required_bundles_at_90pct = target,
      minimum_additional_valid_bundles_arithmetic = max(0L, target-v),
      recovery_interpretation = "conditional_lower_bound; unevaluable checks or later invalidations may increase shortfall; no recovery authorization",
      presence_reaches_90pct = n > 0 && c >= target, applicable_valid_reaches_90pct = n > 0 && v >= target,
      approved_eligibility_rule = FALSE,
      caveat = if (i >= 9) "Circular selection excludes absent data; cannot establish coverage or admission" else
        "Source-only sensitivity; official inventory, chronology and status eligibility unapproved",
      included_audit_ids = paste(x$audit_id[take], collapse = ";"), excluded_audit_ids = paste(x$audit_id[!take], collapse = ";"))
  }))
}

montreal_suffixes <- function(files) {
  result <- list()
  for (label in names(files)) {
    x <- files[[label]]; s <- montreal_score(x$score, x$best_of)
    plus_h <- grepl("+H", x$score, fixed = TRUE); ret_plus <- grepl("RET+", x$score, fixed = TRUE)
    exact <- grepl("RET\\+H[0-9]+$", x$score)
    take <- which(plus_h | ret_plus | exact | (s$retirement & s$unresolved_suffix))
    if (!length(take)) next
    tour <- strsplit(label, " ")[[1]][1]; year <- strsplit(label, " ")[[1]][2]
    result[[label]] <- cbind(data.frame(tour = tour, season = year, source_data_row = take,
      audit_id = paste("sackmann", tour, x$tourney_id[take], x$match_num[take], sep = ":")),
      x[take, c("tourney_id", "tourney_name", "match_num", "round", "winner_id", "winner_name", "loser_id", "loser_name", "score")],
      s[take, c("recognized_marker", "recognized_retirement_component", "unresolved_residue", "score_classification", "interpretation_state")],
      data.frame(matches_plus_H = plus_h[take], matches_RET_plus = ret_plus[take], matches_RET_H_digits = exact[take],
        meaning = "unresolved; similar syntax is not an interpretation"))
  }
  do.call(rbind, result)
}

montreal_dispositions <- function(x) {
  result <- list()
  for (i in seq_len(nrow(x))) {
    types <- c(if (x$present_count[i] == 0) "whole_statistical_bundle_missing",
      if (x$unresolved_suffix[i]) "recognized_status_with_unresolved_suffix",
      if (x$completion_unresolved[i]) "numeric_score_without_completion_evidence")
    for (type in types) {
      missing <- type == "whole_statistical_bundle_missing"
      suffix <- type == "recognized_status_with_unresolved_suffix"
      result[[length(result)+1L]] <- cbind(x[i, c("audit_id", "tour", "season", "source_data_row", "tourney_id", "tourney_name",
        "match_num", "round", "winner_id", "winner_name", "loser_id", "loser_name", "score")],
        data.frame(anomaly_type = type, affected_fields = if (missing) paste(montreal_fields(), collapse = ";") else "score",
          observed_evidence = if (missing) "0/18 counts present; identity/result/score preserved" else if (suffix)
            paste0("RET recognized; residue ", x$unresolved_residue[i], " unresolved") else "Numeric score lacks best-of-three completion evidence; no status marker; raw score preserved",
          validation_state = if (missing) "verified_whole_bundle_absence" else if (suffix) "verified_literal_suffix_unresolved" else "verified_score_completion_unresolved",
          permitted_uses = "preserve_source_identity_result_score;event_annotation;descriptive_inventory_candidacy;local_review",
          prohibited_uses = "Four_Factors;factor_weights;player_factor_summaries;missing_count_dependent_uses;Elo;forecasting;model_admission",
          review_state = "pending_user_decision_no_repair_or_eligibility_policy_adopted",
          reason_codes = paste(c(if (missing) "missing_required_counts" else if (suffix) "unresolved_score_suffix" else "status_unresolved", "official_inventory_unverified",
            "chronology_unresolved", "eligibility_policy_unresolved"), collapse = ";"),
          review_version = montreal_version(), adopted_eligibility_policy = FALSE, modeling_admission = "not_authorized"))
    }
  }
  do.call(rbind, result)
}

montreal_round_coverage <- function(evidence) {
  x <- evidence$files[["WTA 2021"]]; rows <- list()
  for (i in seq_len(nrow(evidence$candidates))) {
    candidate <- evidence$candidates[i, ]; z <- x[x$tourney_id == candidate$tourney_id, ]
    s <- montreal_score(z$score, z$best_of); b <- montreal_bundle(z)
    rounds <- c("R128", montreal_rounds())
    for (round in rounds[rounds %in% z$round]) {
      take <- z$round == round; played <- take & s$apparent_played
      rows[[length(rows)+1L]] <- data.frame(tour = "WTA", season = 2021, event_family_annotation = candidate$event_family_annotation,
        tourney_id = candidate$tourney_id, round = round, source_rows = sum(take), apparent_played = sum(played),
        whole_bundles_present = sum(take & b$present_count == 18), whole_bundles_missing = sum(take & b$present_count == 0),
        partial_bundles = sum(take & b$present_count > 0 & b$present_count < 18),
        apparent_play_complete = sum(played & b$present_count == 18),
        apparent_play_missing_bundle = sum(played & b$present_count == 0),
        apparent_presence_pct = if (sum(played)) 100*sum(played & b$present_count == 18)/sum(played) else NA_real_)
    }
  }
  do.call(rbind, rows)
}

montreal_progression <- function(x) {
  result <- list(); rounds <- montreal_rounds()
  for (i in seq_len(length(rounds)-1L)) {
    from <- x[x$round == rounds[i], ]; to <- x[x$round == rounds[i+1L], ]
    winners <- from$winner_id; participants <- c(to$winner_id, to$loser_id)
    extra <- setdiff(participants, winners)
    # R32 may have first-observed entrants; do not invent official bye records.
    coherent <- !anyDuplicated(winners) && !anyDuplicated(participants) && all(winners %in% participants) &&
      (i == 1L || setequal(winners, participants))
    result[[i]] <- data.frame(from_round = rounds[i], to_round = rounds[i+1L], advancing_source_winners = length(winners),
      next_round_players = length(participants), additional_first_observed_ids = paste(extra, collapse = ";"),
      internally_coherent = coherent, official_inventory_verified = FALSE)
  }
  do.call(rbind, result)
}

montreal_player_history <- function(x) {
  missing <- x[x$present_count == 0, ]; players <- unique(c(missing$winner_id, missing$loser_id))
  do.call(rbind, lapply(sort(players), function(id) {
    earlier <- x$round %in% c("R64", "R32", "R16") & (x$winner_id == id | x$loser_id == id)
    names <- unique(c(x$winner_name[x$winner_id == id], x$loser_name[x$loser_id == id]))
    data.frame(player_id = id, source_name = paste(names, collapse = ";"), earlier_round_rows = sum(earlier),
      earlier_apparent_play_rows = sum(earlier & x$apparent_played), earlier_complete_bundles = sum(earlier & x$present_count == 18),
      earlier_apparent_complete_bundles = sum(earlier & x$apparent_played & x$present_count == 18),
      earlier_audit_ids = paste(x$audit_id[earlier], collapse = ";"),
      ordering_basis = "round stage only; not actual match chronology")
  }))
}

review_wta_2021_montreal <- function() {
  evidence <- montreal_load(); inventory <- montreal_inventory(evidence)
  rounds <- montreal_round_coverage(evidence); local <- rounds[rounds$tourney_id == "2021-806", ]
  inventory$round_source_rows <- local$source_rows[match(inventory$round, local$round)]
  inventory$round_whole_bundles_present <- local$whole_bundles_present[match(inventory$round, local$round)]
  outputs <- list(`match-bundle-inventory` = inventory, `anomaly-dispositions` = montreal_dispositions(inventory),
    `denominator-sensitivity` = montreal_sensitivity(inventory), `round-coverage` = rounds,
    `score-suffix-review` = montreal_suffixes(evidence$files), `source-progression` = montreal_progression(inventory),
    `affected-player-history` = montreal_player_history(inventory))
  outputs$`review-checks` <- montreal_checks(outputs)
  if (!all(outputs$`review-checks`$passed)) stop("Review expectation failed; inspect local evidence before writing outputs.")
  directory <- "data/pilot/development-2021/montreal-review"
  dir.create(directory, showWarnings = FALSE)
  for (name in names(outputs)) pilot_write_csv(outputs[[name]], paste0(directory, "/", name, ".csv"))
  montreal_report(outputs, evidence)
  invisible(outputs)
}

montreal_checks <- function(o) {
  x <- o$`match-bundle-inventory`; missing <- x[x$present_count == 0, ]; s <- o$`denominator-sensitivity`
  checks <- list()
  add <- function(name, observed, expected) {
    checks[[length(checks)+1L]] <<- data.frame(check = name, observed = paste(observed, collapse = ";"),
      expected = paste(expected, collapse = ";"), passed = identical(as.character(observed), as.character(expected)))
  }
  add("event_id", unique(x$tourney_id), "2021-806"); add("source_name", unique(x$tourney_name), "Montreal")
  add("date_surface_level_draw", unique(paste(x$tourney_date,x$surface,x$tourney_level,x$draw_size)), "20210809 Hard P 64")
  add("source_rows", nrow(x), 55); add("walkovers", sum(x$walkover), 1)
  add("walkover_counts_all_zero", all(unlist(x[x$walkover,montreal_fields()]) == "0"), TRUE)
  add("retirements", sum(x$retirement), 4); add("suffix_rows", sum(x$unresolved_suffix), 1)
  add("whole_missing_bundles", nrow(missing), 7); add("partial_bundles", sum(x$present_count > 0 & x$present_count < 18), 0)
  add("missing_both_players", all(missing$winner_present_count == 0 & missing$loser_present_count == 0), TRUE)
  add("all_18_raw_fields_missing", all(is.na(missing[montreal_fields()])), TRUE)
  add("missing_QF_SF_F", as.integer(table(factor(missing$round, levels = c("QF","SF","F")))), c(4,2,1))
  add("earlier_apparent_play_gaps", sum(x$apparent_played & x$round %in% c("R64","R32","R16") & x$present_count != 18), 0)
  add("missing_matches_with_minutes", sum(!annual_missing(missing$minutes)), 6)
  add("final_number_and_missing_minutes", identical(x$match_num[x$round == "F"], "238") && is.na(x$minutes[x$round == "F"]), TRUE)
  add("missing_result_fields_present", !any(annual_missing(unlist(missing[c("winner_id","winner_name","loser_id","loser_name","score")]))), TRUE)
  expected <- data.frame(match_num = c("298","297","296","295","300","299","238"),
    round = c("QF","QF","QF","QF","SF","SF","F"), winner_id = c("214544","201662","202429","202468","201662","202429","202429"),
    loser_id = c("201458","204427","221103","202460","214544","202468","201662"),
    winner_name = c("Aryna Sabalenka","Karolina Pliskova","Camila Giorgi","Jessica Pegula","Karolina Pliskova","Camila Giorgi","Camila Giorgi"),
    loser_name = c("Victoria Azarenka","Sara Sorribes Tormo","Coco Gauff","Ons Jabeur","Aryna Sabalenka","Jessica Pegula","Karolina Pliskova"),
    score = c("6-2 6-4","6-4 6-0","6-4 7-6(2)","1-6 7-6(4) 6-0","6-3 6-4","6-3 3-6 6-1","6-3 7-5"))
  for (i in seq_len(nrow(expected))) {
    actual <- missing[missing$match_num == expected$match_num[i], names(expected), drop = FALSE]
    add(paste0("source_match_",expected$match_num[i]), as.character(unlist(actual)), as.character(unlist(expected[i,])))
  }
  suffix <- x[x$unresolved_suffix, ]
  add("literal_Montreal_suffix", c(suffix$match_num,suffix$score,suffix$unresolved_residue,suffix$interpretation_state), c("260","6-1 4-3 RET+H64","+H64","unresolved"))
  analog <- o$`score-suffix-review`
  add("local_suffix_analog_count", nrow(analog), 2)
  add("local_suffix_analog_keys", sort(paste(analog$tourney_id,analog$match_num,sep=":")), c("2021-806:260","2023-902:289"))
  add("Miami_literal", analog$score[analog$tourney_id == "2023-902"], "7-6(0) 0-2 RET+H61")
  add("all_suffixes_unresolved", all(analog$interpretation_state == "unresolved"), TRUE)
  add("baseline_C_N", c(s$complete_bundles[s$scenario == "phase1e_apparent_play"],s$denominator[s$scenario == "phase1e_apparent_play"]), c(47,54))
  add("completed_C_N", c(s$complete_bundles[s$scenario == "numeric_completed_syntax"],s$denominator[s$scenario == "numeric_completed_syntax"]), c(42,49))
  add("retirement_exclusion_C_N", c(s$complete_bundles[s$scenario == "apparent_play_excluding_retirements"],s$denominator[s$scenario == "apparent_play_excluding_retirements"]), c(43,50))
  add("unmarked_incomplete_score", c(x$match_num[x$completion_unresolved],x$score[x$completion_unresolved]), c("253","2-6 6-2"))
  add("each_denominator_accounts_for_rows", all(vapply(seq_len(nrow(s)),function(i) {
    split <- function(z) if (nzchar(z)) strsplit(z,";",fixed=TRUE)[[1]] else character()
    included <- split(s$included_audit_ids[i]); excluded <- split(s$excluded_audit_ids[i])
    length(included)==s$denominator[i] && !length(intersect(included,excluded)) && setequal(c(included,excluded),x$audit_id)
  },TRUE)), TRUE)
  add("threshold_uses_declared_N", all(s$required_bundles_at_90pct == ceiling(9*s$denominator/10)), TRUE)
  add("no_eligibility_approval", all(!s$approved_eligibility_rule), TRUE)
  add("no_model_admission", all(x$modeling_admission == "not_authorized"), TRUE)
  add("official_inventory_unverified", all(x$official_inventory_state == "unverified"), TRUE)
  add("source_progression_coherent", all(o$`source-progression`$internally_coherent), TRUE)
  add("all_eight_players_have_earlier_counts", nrow(o$`affected-player-history`)==8 && all(o$`affected-player-history`$earlier_apparent_complete_bundles > 0), TRUE)
  other <- o$`round-coverage`;other <- other[other$tourney_id != "2021-806" & other$round %in% c("QF","SF","F"), ]
  add("other_nine_events_late_round_whole_gaps", sum(other$whole_bundles_missing), 0)
  add("separate_anomaly_dispositions", c(sum(o$`anomaly-dispositions`$anomaly_type == "whole_statistical_bundle_missing"),
    sum(o$`anomaly-dispositions`$anomaly_type == "recognized_status_with_unresolved_suffix"),
    sum(o$`anomaly-dispositions`$anomaly_type == "numeric_score_without_completion_evidence")), c(7,1,1))
  do.call(rbind, checks)
}

montreal_report <- function(o, e) {
  x <- o$`match-bundle-inventory`; missing <- x[x$present_count == 0, ]; s <- o$`denominator-sensitivity`
  rounds <- o$`round-coverage`; local <- rounds[rounds$tourney_id == "2021-806", ]
  lines <- c("# Phase 1F: WTA 2021 Montreal admission review", "",
    "**Completed follow-up:** the user subsequently authorized Option A investigation. [Phase 1G reference feasibility](wta-2021-montreal-reference-feasibility.md) found seven complete, structurally acceptable official candidate bundles and corroborated both retirements, while preserving metadata/draw conflicts and unresolved suffix meaning. This report retains its historical source-only findings; no source repair or admission policy was adopted.", "",
    "Generated by `R/review_wta_2021_montreal.R`; do not hand-edit calculated findings. Review date: **2026-09-14**.", "",
    "**Completed:** offline evidence review. **Review specification:** WTA Montreal admission review 1.0.0. This is not an adopted repair, quarantine or eligibility policy. No acquisition, repair, imputation, event admission or modeling occurred.", "",
    "## Objective and evidence boundaries", "",
    "The flagship asks whether interpretable Four Factors can improve calibration over surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred. This review investigates Montreal count absence and unexplained score text without changing the ten-family panel, 2021–2023 development / 2024 validation / 2025 locked-test split or 90%/95% thresholds.", "",
    "**Verified locally** means observed saved bytes or a calculation from those bytes. **Source-only coherence** is not official confirmation. **Arithmetic** does not establish recoverability. **Recommendation** means an unimplemented choice requiring user approval. Suffix meaning, data-loss cause, official inventories, chronology and model eligibility remain unresolved.", "",
    "## Local evidence and provenance", "",
    "All four annual files below were verified against their original manifests for sizes, SHA-256, Git blob identifiers and row counts before reading. Archive pin: `83733587353df8a41f2fd4f516147d5aa83f5a8d`. The [development manifest](../data/manifests/development-source-files.csv) and [pilot manifest](../data/manifests/pilot-source-files.csv) remain unchanged, including retrieval times. Existing 2021 API metadata hashes were verified offline.", "",
    pilot_markdown_table(e$provenance),
    "Inputs also include saved Phase 1E event-candidates, event-cell-summary, field/status summaries and the [2021 source audit](2021-annual-source-audit.md). Candidate records are recomputed and compared before selecting exact WTA source ID `2021-806`; no alias expansion or nearest-name selection occurs. Existing [count checks](../R/audit_pilot_data.R) and [source contract](data-source-contract.md) supply the applicable constraints.", "",
    "Inherited licensing evidence identifies Jeff Sackmann / Tennis Abstract, CC BY-NC-SA 4.0, an archive claiming June 2026 snapshots and a mirror that adds no rights. No licensing source was accessed or new fact discovered; [DATA_LICENSE.md](../DATA_LICENSE.md) remains unchanged. Local research authorization is not public-release approval.", "",
    pilot_markdown_table(unique(x[c("tour","season","event_family_annotation","tourney_id","tourney_name","tourney_date","surface","tourney_level","draw_size")])),
    paste0("Observed source rows: **",nrow(x),"**; apparent play: **",sum(x$apparent_played),"**; walkovers: **",sum(x$walkover),"**; recognized retirement markers: **",sum(x$retirement),"**; unresolved suffix rows: **",sum(x$unresolved_suffix),"**. Annual data rows 1810–1864 (CSV lines 1811–1865, header included) identify this source block. They are locators, not time order."), "",
    "## Seven missing bundles", "",
    pilot_markdown_table(missing[c("audit_id","source_data_row","round","winner_id","winner_name","loser_id","loser_name","score","minutes")] ),
    paste0("Each affected row lacks every required field: `",paste(montreal_fields(),collapse=";"),"`. Both players have 0/9 counts. Identity, source winner/loser, score and ranking fields remain separately preserved. No unavailable count becomes zero."), "",
    "All seven are whole-bundle gaps: four QFs, two SFs and the final. Six have recorded minutes; the final has none. Final match number **238** remains literal source text, smaller than the QF/SF match numbers. No replacement number or chronology is inferred.", "",
    pilot_markdown_table(local[c("round","source_rows","apparent_played","whole_bundles_present","whole_bundles_missing","partial_bundles","apparent_presence_pct")]),
    "All earlier apparent-play rows have all 18 counts. The R16 walkover, Gauff–Konta (`2021-806:289`), also has 18 populated count cells, all zero; it is a presence observation, not valid played-match statistics. The existing checks flag zero service points on both sides.", "",
    "## Source progression and player pattern", "",
    pilot_markdown_table(o$`source-progression`),
    "Source winners appear in the next round without duplicate next-round player appearances. R64→R32 has eight additional first-observed IDs; this is not an invented official bye inventory. From R32 onward, advancing winners exactly match next-round participants, including QF→SF→F. This checks internal source progression, not official draw completeness, actual dates or completion order.", "",
    pilot_markdown_table(o$`affected-player-history`[c("player_id","source_name","earlier_round_rows","earlier_apparent_play_rows","earlier_apparent_complete_bundles")]),
    "All eight affected players have populated counts in earlier Montreal apparent-play rounds. The observed gap is round-concentrated and affects both players and every required field in each late-round match; it is not a persistent absence for those player IDs or one isolated field. This pattern does not identify a cause. Collection failure, transfer loss or an omitted update are untested possibilities, not findings.", "",
    "The other nine WTA 2021 target events have zero whole-bundle gaps in their QF/SF/F rows. The generated round-coverage table includes all ten events and distinguishes source rows, walkovers, apparent play, partial bundles and whole absence. Their presence does not establish structural accuracy or official inventory coverage.", "",
    "## Score suffix review", "",
    pilot_markdown_table(o$`score-suffix-review`[c("tour","season","tourney_id","match_num","round","winner_name","loser_name","score","recognized_retirement_component","unresolved_residue","score_classification")]),
    "Literal `RET` and unresolved `+H64` remain separate; `6-1 4-3 RET+H64` is unchanged. Classification is `recognized_retirement_marker_with_unresolved_suffix`, with interpretation state `unresolved`. The comparison score `7-6(0) 0-2 RET+H61` is likewise preserved. The four local annual files contain exactly these two matches for +H, RET+, RET+H followed by digits, or a suffix after a recognized retirement token. Similar syntax supplies no meaning for H64/H61.", "",
    "## Denominator sensitivity and threshold arithmetic", "",
    "Every scenario is descriptive and lists all included/excluded audit IDs in its CSV. No scenario is an approved eligibility rule. The structural numerator means complete bundles without flags from applicable existing checks, not independent verification of valid statistics. Unknown suffixes prevent the game/score check; count bounds still run. Pilot quarantine/admission fields are not imported into this review.", "",
    pilot_markdown_table(s[c("scenario","denominator","complete_bundles","presence_pct","complete_without_applicable_flags","applicable_valid_pct","included_retirements","included_suffix_rows","included_missing_bundles","included_walkovers")]),
    pilot_markdown_table(s[c("scenario","required_bundles_at_90pct","minimum_additional_valid_bundles_arithmetic","presence_reaches_90pct","applicable_valid_reaches_90pct")]),
    "Baseline: **47/54 = 87.0370%**. At least **49** complete bundles without applicable flags are required for 90%, so the arithmetic shortfall is **two**. Numeric completed-score syntax gives **42/49 = 85.7143%**, requiring **45**, a shortfall of **three**. Excluding RET from all rows retains the walkover: 44/51 populated, but only 43/51 without applicable flags; its arithmetic shortfall is three. Excluding RET from apparent play instead gives **43/50 = 86%**, requiring 45, a shortfall of two. These explicitly different definitions prevent silent denominator changes.", "",
    "**Additional unresolved source observation:** Ferro–Tomljanovic (`2021-806:253`, R64) has score `2-6 6-2` and all 18 counts. Two split sets do not establish completion of a best-of-three match. There is no RET marker to justify retirement classification. It remains in apparent-play and retirement-exclusion sensitivities, but not completed-score syntax; this explains the 43/50 versus 42/49 difference. Its game/score check is not evaluable. No missing set, status or result correction is inferred.", "",
    "All-row presence is 48/55; applicable unflagged coverage is 47/55 because the all-zero walkover is flagged. Excluding the suffix from apparent play gives 46/53, requiring two additional bundles. Count-complete-only scenarios pass numerically by excluding missing data from their denominators; those circular diagnostics cannot establish event coverage.", "",
    "Required numerator = ceiling(0.90 × declared denominator); additional bundles = max(0, required numerator − complete bundles without applicable flags). These are conditional lower bounds: unevaluable checks or later invalidations may increase the shortfall. Recovery must concern missing rows already inside that denominator, remain structurally acceptable under a later approved procedure and preserve provenance. Arithmetic neither authorizes acquisition nor proves recoverable statistics exist. Official inventory may change denominators; status and suffix decisions may also change eligibility. The 95% tour-season gate was not tested.", "",
    "## Machine-readable review dispositions", "",
    "Nine dispositions separate seven `whole_statistical_bundle_missing` records, one `recognized_status_with_unresolved_suffix` record and one `numeric_score_without_completion_evidence` record. The last reuses `status_unresolved`. Review name/version is WTA Montreal admission review 1.0.0; `adopted_eligibility_policy=FALSE`. Each retains match/player identities, raw score, field list, observed evidence, validation and review states, permitted/prohibited uses and reasons.", "",
    "Reuse `missing_required_counts` and `chronology_unresolved`; `unresolved_score_suffix` specifies the unresolved syntax, while `official_inventory_unverified` and `eligibility_policy_unresolved` express distinct uncompleted reviews. No new quarantine policy is adopted. Permitted uses are source identity/result/score preservation, event annotation, descriptive inventory candidacy and local review. Four Factors, weights, player-factor summaries, missing-count-dependent calculations, Elo, forecasts and modeling admission remain prohibited.", "",
    "## Admission choices — no option implemented", "",
    "| Option | Evidence and data requirements | Methodological cost and comparability | Licensing and user decision | Phase 1F authority |",
    "| --- | --- | --- | --- | --- |",
    "| A: investigate recovery of all seven bundles (preferred investigation) | Separately approved exact URLs; preserved source bytes, times, sizes and hashes; match/round/player linkage; whole-match counts with both player orientations; field-level agreement/conflicts; existing structural checks; official inventory and suffix/status evidence | Best chance to preserve the fixed panel and comparable Elo/Four Factors evaluation if trustworthy counts exist. Recovery is unproven; agreement may share upstream errors. Keep source/recovered values separate. | Review source terms, local caching, transformation and eventual redistribution rights. User must approve bounded source access; any replacement procedure needs separate approval. | No acquisition or recovery authorized |",
    "| B: retain Montreal for result-only work, exclude from Four Factors | Reliable identities/results, reconciled inventory and approved chronology/status rules before any Elo use | Different match populations can confound Elo versus Four Factors comparisons; requires an explicitly reviewed common evaluation population or separate reporting. ATP/WTA samples become asymmetric. | Existing restrictions remain; result-only does not remove rights obligations. User must approve population/evaluation changes. | Not approved; Elo remains prohibited |",
    "| C: exclude event from both models | Documented exclusion and revised panel/evaluation specification | Loses WTA Canadian hard-court representation; excluding ATP Canada too would lose further scope. ATP/WTA comparability depends on the choice; no effect size is known. | No new rights granted. Explicit user approval to change the fixed panel required. | Event retained; exclusion not approved |",
    "| D: revise 90% floor | Methodological rationale applied consistently across the panel, with a documented sensitivity analysis | Changing a threshold after observing a failing cell risks outcome-driven rule selection and biased factor samples/comparisons. ATP/WTA rules must remain transparent; 95% gate is separate. | No licensing change. User must approve any methodological revision. | Threshold unchanged |",
    "| E: impute/reconstruct counts | Later evidence and a separately approved reconstruction policy would be prerequisites | Counts cannot be estimated from scores, averages, adjacent rounds, rounded percentages or model predictions in this task; invented counts can distort factors and model comparison. | Reconstruction does not erase source restrictions. Separate evidence/policy approval required. | Prohibited |", "",
    "## Recommended next milestone and unresolved decisions", "",
    "**Historical Phase 1F recommendation (Phase 1G is now completed above):** a separately authorized, bounded reference-feasibility investigation for all seven missing-bundle matches, the suffix row and the unmarked two-set score. First settle the exact URL allowlist and permissible local use; verify whether complete match statistics and inventory/status evidence actually exist. Preserve observations/conflicts and report field availability, without automatic substitution or admission. This is Option A investigation, not a claim that recovery will succeed or permission to access any URL now.", "",
    "The user selected Option A investigation in Phase 1G; recovery and admission remain unapproved. Further source access, replacement/reconstruction rules, inventory resolution, status eligibility, chronology, evaluation populations, threshold/panel changes and public derived-output rights remain decisions. 2022/2024/2025 acquisition stays closed. No Four Factors, weights, Elo, forecasts or predictive evaluation was performed.", "",
    "## Existing Indian Wells state", "",
    "ATP/WTA 2023 inventory gates remain PASS. ATP precedence policy 1.0.0 retains four resolved PDF conflicts across the two approved branches and three conflicting match links. WTA quarantine policy 1.0.0 still excludes the Andreescu–Stearns count bundle, retains inventory/played-denominator membership and all four reasons; valid-count coverage remains 93/94 WTA and 95/95 ATP. Those policies and outputs are unchanged and do not authorize Montreal admission.", "",
    "## Reproduction, verification and limitations", "",
    "From the repository root: `Rscript R/review_wta_2021_montreal.R --self-test`. This uses only local manifest validation and files; no acquisition function is called. Missing or mismatched evidence stops before review outputs are written. Generated CSVs live under ignored `data/pilot/development-2021/montreal-review/`: match-bundle-inventory, anomaly-dispositions, denominator-sensitivity, round-coverage, score-suffix-review, source-progression, affected-player-history and review-checks. There is no full annual copy or canonical dataset.", "",
    paste0("The generated review-checks table contains ",nrow(o$`review-checks`)," passing source/denominator/disposition checks. In-memory tests cover missing/partial/malformed/zero bundles, count bounds, suffix edge cases, selection failures and explicit denominator accounting. Repeated review and Phase 1E runs are checked for identical bytes and timestamps; earlier evidence, policies, raw inventory and manifests are preserved. Documentation links/anchors, paths, placeholders, ignore rules and Git whitespace are checked before commit."), "",
    "During development, default CSV type inference caused a candidate comparison to fail; reading with the recomputed candidate column classes fixed the comparison without changing saved values. A synthetic missing-score case exposed automatic vector names becoming invalid data-frame row names; disabling those names fixed it. No acquisition was attempted and no external availability, official Montreal reference, suffix definition or licensing fact was verified.", "",
    "The Phase 1E rerun test now selects its own CSV files explicitly so the authorized review subdirectory is not treated as a file to hash. No dependency, portfolio work, push, publication or deployment occurred. Every next task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.", "")
  while (length(lines) && !nzchar(tail(lines,1))) lines <- head(lines,-1)
  path <- "docs/wta-2021-montreal-admission-review.md"
  if (!file.exists(path) || !identical(readLines(path,warn=FALSE),lines)) writeLines(lines,path,useBytes=TRUE)
}

montreal_self_test <- function(o) {
  reject <- function(expr) stopifnot(inherits(tryCatch(force(expr),error=identity),"error"))
  e <- montreal_load(); x <- e$selected$raw; original <- x
  z <- x[x$match_num == "294", , drop=FALSE]
  if (!nrow(z)) z <- x[which(montreal_bundle(x)$present_count == 18)[1], , drop=FALSE]
  z[montreal_fields()] <- NA_character_
  stopifnot(montreal_bundle(z)$present_count == 0,all(is.na(z[montreal_fields()])))
  z$w_ace <- "0";stopifnot(montreal_bundle(z)$present_count == 1,montreal_bundle(z)$bundle_state == "partial_bundle")
  z$w_ace <- "unknown";stopifnot(montreal_bundle(z)$malformed_count == 1)
  z$w_ace <- "-1";stopifnot(montreal_bundle(z)$malformed_count == 1)
  z$w_ace <- "1.5";stopifnot(montreal_bundle(z)$malformed_count == 1)
  z <- x[which(x$match_num == "294"),,drop=FALSE];z$w_1stIn <- as.character(as.numeric(z$w_svpt)+1)
  stopifnot(!montreal_structural(z,montreal_score(z$score,z$best_of))$applicable_count_checks_passed)
  score <- c("6-1 4-3 RET+H64","7-6(0) 0-2 RET+H61","6-1 RET","6-1 RET+X?","6-1 RET H64","W/O",NA_character_)
  s <- montreal_score(score,rep("3",length(score)))
  stopifnot(identical(s$unresolved_residue[1:5],c("+H64","+H61","","+X?","H64")),
    all(s$interpretation_state[c(1,2,4,5)] == "unresolved"),all(s$retirement[1:5]),!any(s$numeric_completed_syntax[1:5]),
    all(s$recognized_retirement_component[1:5] == "RET"))
  s <- montreal_score("2-6 6-2","3")
  stopifnot(s$completion_unresolved,!s$retirement,s$score_classification == "numeric_score_without_completion_evidence")
  bad <- e$candidates[e$candidates$tourney_id == "2021-806", ];bad$tourney_id <- "2023-806"
  reject(montreal_select(e$files[["WTA 2021"]],bad))
  bad <- e$candidates[e$candidates$tourney_id == "2021-806", ];bad$tour <- "ATP"
  reject(montreal_select(e$files[["WTA 2021"]],bad))
  stopifnot(identical(x,original),all(o$`review-checks`$passed))
  inventory <- o$`match-bundle-inventory`;source <- e$files[["WTA 2021"]][inventory$source_data_row, ]
  for (f in intersect(names(source),names(inventory))) stopifnot(identical(source[[f]],inventory[[f]]))
  paths <- c(list.files("data/pilot/development-2021/montreal-review",full.names=TRUE),"docs/wta-2021-montreal-admission-review.md")
  snapshot <- function() data.frame(path=paths,sha256=vapply(paths,pilot_sha256,""),mtime=as.numeric(file.info(paths)$mtime))
  before <- snapshot();review_wta_2021_montreal();review_wta_2021_montreal()
  stopifnot(identical(before,snapshot()))
  message("Montreal source, synthetic failure-path, raw-preservation and deterministic-rerun checks passed.")
}

if (sys.nframe() == 0L) {
  output <- review_wta_2021_montreal()
  if ("--self-test" %in% commandArgs(trailingOnly=TRUE)) montreal_self_test(output)
  print(output$`denominator-sensitivity`[c("scenario","denominator","complete_bundles","presence_pct","complete_without_applicable_flags","minimum_additional_valid_bundles_arithmetic")],row.names=FALSE)
}
