# Phase 1E offline source profiling. No canonical tables or admission decisions.
source("R/download_2021_annual_data.R")
source("R/audit_pilot_data.R") # Reuse the existing Markdown table formatter only.

annual_required <- function() {
  groups <- list(context = c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size", "round", "match_num", "best_of"),
    identity = c("winner_id", "loser_id", "winner_name", "loser_name"), score = "score",
    ranking = c("winner_rank", "winner_rank_points", "loser_rank", "loser_rank_points"),
    count = c(paste0("w_", c("ace", "df", "svpt", "1stIn", "1stWon", "2ndWon", "SvGms", "bpFaced", "bpSaved")),
      paste0("l_", c("ace", "df", "svpt", "1stIn", "1stWon", "2ndWon", "SvGms", "bpFaced", "bpSaved"))))
  do.call(rbind, lapply(names(groups), function(g) data.frame(group = g, field = groups[[g]])))
}

annual_require_columns <- function(x) {
  absent <- setdiff(annual_required()$field, names(x))
  if (length(absent)) stop("Required columns absent: ", paste(absent, collapse = ";"))
  invisible(TRUE)
}
annual_missing <- function(x) is.na(x) | !nzchar(trimws(x))
annual_values <- function(x) paste(sort(unique(x[!annual_missing(x)])), collapse = ";")
annual_valid_date <- function(x) {
  d <- suppressWarnings(as.Date(x, "%Y%m%d"))
  !annual_missing(x) & grepl("^[0-9]{8}$", x) & !is.na(d) & format(d, "%Y%m%d") == x
}

annual_status <- function(scores) {
  s <- toupper(trimws(scores)); s[is.na(s)] <- ""
  wo <- grepl("(^|[^A-Z])(W/O|WO|WALKOVER|WALK OVER)($|[^A-Z])", s)
  ret <- grepl("(^|[^A-Z])RET(IR(E(D|MENT)?)?)?($|[^A-Z])", s)
  def <- grepl("(^|[^A-Z])DEF(AULT(ED)?)?[.]?($|[^A-Z])", s)
  unfinished <- grepl("ABD|ABN|ABANDONED|SUSPENDED|UNFINISHED|CANCELLED|CANCELED", s)
  residue <- gsub("W/O|WALKOVER|WALK OVER|\\bWO\\b|RETIREMENT|RETIRED|RET|DEFAULTED|DEFAULT|DEF[.]?|ABANDONED|SUSPENDED|UNFINISHED|CANCELLED|CANCELED|ABD|ABN", "", s, perl = TRUE)
  unknown <- grepl("[^0-9()\\[\\] .-]", residue, perl = TRUE)
  numeric <- grepl("^[0-9]+-[0-9]+(\\([0-9]+\\))?( [0-9]+-[0-9]+(\\([0-9]+\\))?)*$", s)
  marker <- ifelse(s == "", "missing_score", ifelse(wo, "walkover_marker", ifelse(ret, "retirement_marker",
    ifelse(def, "default_marker", ifelse(unfinished, "unfinished_marker", ifelse(numeric, "numeric_score_syntax", "other_format"))))))
  # Positive scored games are apparent-play evidence, not settled eligibility.
  played <- !wo & vapply(s, function(z) {
    sets <- regmatches(z, gregexpr("[0-9]+-[0-9]+", z))[[1]]
    length(sets) > 0L && sum(as.numeric(unlist(strsplit(sets, "-", fixed = TRUE)))) > 0
  }, TRUE)
  data.frame(marker = marker, retirement = ret, walkover = wo, default = def, unfinished = unfinished,
    unrecognized_status_text = unknown, apparent_played = played, stringsAsFactors = FALSE)
}

annual_schema_compare <- function(a, b, left, right) {
  data.frame(left = left, right = right, exact_ordered_header = identical(names(a), names(b)),
    left_columns = paste(names(a), collapse = ";"), right_columns = paste(names(b), collapse = ";"),
    added_in_right = paste(setdiff(names(b), names(a)), collapse = ";"),
    absent_in_right = paste(setdiff(names(a), names(b)), collapse = ";"),
    reordered = setequal(names(a), names(b)) && !identical(names(a), names(b)),
    renamed_fields = "not_inferred; additions/absences reported literally", parse_mode = "character; blank CSV cells become NA in memory only",
    left_levels = annual_values(a$tourney_level), right_levels = annual_values(b$tourney_level),
    left_statuses = annual_values(annual_status(a$score)$marker), right_statuses = annual_values(annual_status(b$score)$marker))
}

annual_aliases <- function() {
  # Literal aliases from data-source-contract.md section 7; no fuzzy matching.
  list(`Australian Open` = c("Australian Open", "AO"), `Roland-Garros` = c("Roland Garros", "Roland-Garros", "French Open"),
    Wimbledon = c("Wimbledon", "The Championships"), `US Open` = c("US Open", "U.S. Open"),
    `Indian Wells` = c("Indian Wells", "BNP Paribas Open"), Miami = c("Miami", "Miami Open", "Miami Open presented by Itau", "Miami Open presented by Itaú"),
    Madrid = c("Madrid", "Mutua Madrid Open"), Rome = c("Rome", "Roma", "Italian Open", "Internazionali BNL d'Italia"),
    Canada = c("Canada", "Canadian Open", "Rogers Cup", "National Bank Open", "Omnium Banque Nationale", "Montreal", "Toronto"),
    Cincinnati = c("Cincinnati", "Cincinnati Open", "Western & Southern Open"))
}
annual_alias_hit <- function(name, alias) {
  if (annual_missing(name)) return(FALSE)
  chars <- strsplit(alias, "", fixed = TRUE)[[1]]
  escaped <- paste0(ifelse(grepl("[[:alnum:] ]", chars), chars, paste0("\\", chars)), collapse = "")
  grepl(paste0("(?<![[:alnum:]])", escaped, "(?![[:alnum:]])"), name, ignore.case = TRUE, perl = TRUE)
}
annual_candidates <- function(x, tour, year = 2021L, aliases = annual_aliases()) {
  metadata <- c("tourney_id", "tourney_name", "tourney_date", "surface", "tourney_level", "draw_size")
  events <- unique(x[metadata]); rows <- list(); cells <- list()
  count_fields <- annual_required()$field[annual_required()$group == "count"]
  for (i in seq_len(nrow(events))) {
    e <- events[i, ]
    families <- names(aliases)[vapply(aliases, function(a) any(vapply(a, function(z) annual_alias_hit(e$tourney_name, z), TRUE)), TRUE)]
    in_year <- !annual_missing(e$tourney_id) && startsWith(e$tourney_id, paste0(year, "-")) &&
      isTRUE(annual_valid_date(e$tourney_date)) && substr(e$tourney_date, 1, 4) == as.character(year)
    if (!in_year || !length(families)) next
    take <- rep(TRUE, nrow(x))
    for (f in metadata) take <- take & if (is.na(e[[f]])) is.na(x[[f]]) else !is.na(x[[f]]) & x[[f]] == e[[f]]
    z <- x[take, ]; status <- annual_status(z$score)
    present <- as.data.frame(lapply(z[count_fields], function(v) !annual_missing(v)))
    joint <- rowSums(present) == 18L
    for (family in families) rows[[length(rows)+1L]] <- cbind(data.frame(tour = tour, event_family_annotation = family), e,
      data.frame(source_rows = nrow(z), distinct_winner_ids = length(unique(z$winner_id[!annual_missing(z$winner_id)])),
        distinct_loser_ids = length(unique(z$loser_id[!annual_missing(z$loser_id)])),
        distinct_player_ids = length(unique(c(z$winner_id[!annual_missing(z$winner_id)], z$loser_id[!annual_missing(z$loser_id)]))),
        rounds = annual_values(z$round), retirement_markers = sum(status$retirement), walkover_markers = sum(status$walkover),
        default_markers = sum(status$default), unfinished_markers = sum(status$unfinished), unknown_status_rows = sum(status$unrecognized_status_text),
        apparent_played_rows = sum(status$apparent_played), jointly_present_apparent_played = sum(joint & status$apparent_played),
        joint_presence_pct = if (any(status$apparent_played)) 100*sum(joint & status$apparent_played)/sum(status$apparent_played) else NA_real_,
        duplicate_source_rows = sum(duplicated(z)), family_collision = length(families) > 1L,
        inventory_gate = "NOT_TESTED", modeling_admission = "NOT_AUTHORIZED"))
  }
  candidates <- if (length(rows)) do.call(rbind, rows) else data.frame(tour=character(),event_family_annotation=character(),
    tourney_id=character(),tourney_name=character(),tourney_date=character(),surface=character(),tourney_level=character(),draw_size=character(),
    source_rows=integer(),distinct_winner_ids=integer(),distinct_loser_ids=integer(),distinct_player_ids=integer(),rounds=character(),
    retirement_markers=integer(),walkover_markers=integer(),default_markers=integer(),unfinished_markers=integer(),unknown_status_rows=integer(),
    apparent_played_rows=integer(),jointly_present_apparent_played=integer(),joint_presence_pct=numeric(),duplicate_source_rows=integer(),
    family_collision=logical(),inventory_gate=character(),modeling_admission=character())
  for (family in names(aliases)) {
    e <- candidates[candidates$event_family_annotation == family, ]
    state <- if (!nrow(e)) "missing" else if (nrow(e) != 1L || any(e$family_collision)) "ambiguous" else "found_candidate"
    cells[[family]] <- data.frame(tour = tour, year = year, event_family_annotation = family,
      candidate_records = nrow(e), source_ids = annual_values(e$tourney_id), state = state,
      inventory_gate = "NOT_TESTED", modeling_admission = "NOT_AUTHORIZED")
  }
  list(candidates = candidates, cells = do.call(rbind, cells))
}

annual_profile <- function(x, tour, year) {
  annual_require_columns(x); required <- annual_required(); status <- annual_status(x$score)
  present <- as.data.frame(lapply(x[required$field[required$group=="count"]], function(v) !annual_missing(v)))
  profile <- do.call(rbind, lapply(names(x), function(f) {
    v <- x[[f]]; missing <- annual_missing(v); g <- required$group[match(f, required$field)]
    numeric <- !is.na(g) && g %in% c("count", "ranking")
    invalid <- if (numeric) !missing & (!grepl("^[0-9]+$", v) | suppressWarnings(as.numeric(v)) < 0) else rep(FALSE,length(v))
    data.frame(tour=tour,year=year,field=f,group=if(is.na(g)) "other_source_field" else g, required_column=!is.na(g),
      rows=nrow(x),missing=sum(missing),missing_pct=100*mean(missing), literal_NA=sum(v=="NA",na.rm=TRUE),
      surrounding_whitespace=sum(!missing & trimws(v)!=v,na.rm=TRUE), noninteger_or_negative=sum(invalid,na.rm=TRUE),
      parse_class=class(v)[1])
  }))
  flags <- list(duplicate_full_rows=duplicated(x), duplicate_tournament_match_keys=duplicated(x[c("tourney_id","match_num")]),
    missing_tournament_id=annual_missing(x$tourney_id), malformed_tournament_id=!annual_missing(x$tourney_id)&!grepl("^[0-9]{4}-[A-Za-z0-9-]+$",x$tourney_id),
    tournament_id_outside_file_year=!annual_missing(x$tourney_id)&!startsWith(x$tourney_id,paste0(year,"-")),
    missing_winner_id=annual_missing(x$winner_id), missing_loser_id=annual_missing(x$loser_id),
    missing_winner_name=annual_missing(x$winner_name),missing_loser_name=annual_missing(x$loser_name),
    malformed_player_id=(!annual_missing(x$winner_id)&!grepl("^[0-9]+$",x$winner_id))|(!annual_missing(x$loser_id)&!grepl("^[0-9]+$",x$loser_id)),
    same_id_both_sides=!annual_missing(x$winner_id)&!annual_missing(x$loser_id)&x$winner_id==x$loser_id,
    invalid_date=!annual_valid_date(x$tourney_date), date_outside_file_year=annual_valid_date(x$tourney_date)&substr(x$tourney_date,1,4)!=as.character(year),
    unrecognized_status_text=status$unrecognized_status_text,
    apparent_played_missing_count_bundle=status$apparent_played & rowSums(present)<18L,
    walkover_with_any_counts=status$walkover & rowSums(present)>0L)
  checks <- do.call(rbind,lapply(names(flags),function(f)data.frame(tour=tour,year=year,check=f,rows=nrow(x),flagged=sum(flags[[f]],na.rm=TRUE))))
  markers <- c("numeric_score_syntax","retirement_marker","walkover_marker","default_marker","unfinished_marker","other_format","missing_score")
  scores <- do.call(rbind,lapply(markers,function(k)data.frame(tour=tour,year=year,marker=k,rows=sum(status$marker==k),
    unrecognized_status_rows=sum(status$marker==k & status$unrecognized_status_text))))
  vocabulary <- do.call(rbind,lapply(c("surface","tourney_level","round","best_of"),function(f){v<-ifelse(annual_missing(x[[f]]),"<missing>",x[[f]]);t<-table(v);data.frame(tour=tour,year=year,field=f,value=names(t),rows=as.integer(t))}))
  unusual <- x[status$unrecognized_status_text | status$marker %in% c("other_format","missing_score"),c("tourney_id","match_num","tourney_name","score")]
  unusual <- cbind(data.frame(tour=rep(tour,nrow(unusual)),year=rep(year,nrow(unusual))),unusual)
  list(fields=profile,checks=checks,scores=scores,vocabulary=vocabulary,unusual=unusual)
}

audit_2021_annual_data <- function() {
  m <- annual_2021_manifest(); prior <- pilot_read_manifest(pilot_config())
  files <- list(); profiles <- list(); provenance <- list(); candidates <- cells <- list()
  for (i in 1:2) {
    r<-m[i,]; files[[paste(r$tour,2021)]]<-annual_2021_csv(r$local_path)
    p<-prior[prior$tour==r$tour,];pilot_validate_file(p$local_path,p)
    files[[paste(r$tour,2023)]]<-annual_2021_csv(p$local_path)
    x<-files[[paste(r$tour,2021)]]
    annual_require_columns(x);annual_require_columns(files[[paste(r$tour,2023)]])
    provenance[[i]]<-data.frame(tour=r$tour,year=2021,local_path=r$local_path,rows=nrow(x),columns=ncol(x),
      byte_size=file.info(r$local_path)$size,sha256=pilot_sha256(r$local_path),git_blob=annual_2021_blob(r$local_path),
      duplicate_columns=anyDuplicated(names(x)),empty_headers=sum(!nzchar(names(x))),
      date_min=min(x$tourney_date[annual_valid_date(x$tourney_date)]),date_max=max(x$tourney_date[annual_valid_date(x$tourney_date)]),
      source_row_namespace=paste(r$tour,2021,sep=":"), integrity="PASS")
    c<-annual_candidates(x,r$tour);candidates[[i]]<-c$candidates;cells[[i]]<-c$cells
  }
  for(label in names(files)){p<-strsplit(label," ")[[1]];profiles[[label]]<-annual_profile(files[[label]],p[1],as.integer(p[2]))}
  comparisons <- rbind(annual_schema_compare(files[['ATP 2021']],files[['ATP 2023']],"ATP 2021","ATP 2023"),
    annual_schema_compare(files[['WTA 2021']],files[['WTA 2023']],"WTA 2021","WTA 2023"),
    annual_schema_compare(files[['ATP 2021']],files[['WTA 2021']],"ATP 2021","WTA 2021"))
  outputs<-list(`file-provenance-checks`=do.call(rbind,provenance),`schema-comparison`=comparisons,
    `required-field-summary`=do.call(rbind,lapply(profiles,`[[`,"fields")),`event-candidates`=do.call(rbind,candidates),
    `event-cell-summary`=do.call(rbind,cells),`score-status-summary`=do.call(rbind,lapply(profiles,`[[`,"scores")),
    `audit-checks`=do.call(rbind,lapply(profiles,`[[`,"checks")),`value-vocabulary`=do.call(rbind,lapply(profiles,`[[`,"vocabulary")),
    `score-review`=do.call(rbind,lapply(profiles,`[[`,"unusual")))
  dir.create('data/pilot/development-2021',showWarnings=FALSE)
  for(name in names(outputs))pilot_write_csv(outputs[[name]],paste0('data/pilot/development-2021/',name,'.csv'))
  annual_2021_report(outputs,m)
  print(outputs$`file-provenance-checks`,row.names=FALSE)
  print(outputs$`event-cell-summary`[c('tour','event_family_annotation','state')],row.names=FALSE)
  invisible(outputs)
}

annual_2021_report <- function(o, m) {
  candidates<-o$`event-candidates`;cells<-o$`event-cell-summary`;fields<-o$`required-field-summary`
  counts<-annual_required();missing<-data.frame(field=counts$field,group=counts$group)
  for(t in c('ATP','WTA'))missing[[paste0(t,'_missing')]]<-fields$missing[match(paste(t,2021,missing$field),paste(fields$tour,fields$year,fields$field))]
  provenance<-m[c('tour','retrieved_at_utc','byte_size','row_count','source_git_blob','sha256')]
  schema<-o$`schema-comparison`[c('left','right','exact_ordered_header','added_in_right','absent_in_right','reordered')]
  schema$added_in_right[schema$added_in_right=='']<-'none';schema$absent_in_right[schema$absent_in_right=='']<-'none'
  lines<-c('# Phase 1E: 2021 annual tennis source audit','',
    'Generated by `R/audit_2021_annual_data.R`; do not hand-edit generated findings. Verification date: **2026-09-14**. Acquisition and source audit complete; no 2021 event is admitted for modeling.','',
    '## Scope and evidence labels','',
    '**User-approved:** acquire only ATP/WTA 2021 annual files and their two pinned GitHub metadata responses for local noncommercial educational research. Existing 2023 files are comparison inputs only. No 2022, 2024, 2025, rankings, player, point, tracking, odds or official draw files were acquired.','',
    '**Verified from bytes** describes local parsing, checksums and calculated source summaries. **Inherited documentation** identifies previously reviewed archive/license/dictionary statements, not new external verification. **Proposed** means a recommendation, not an approved method. **Unresolved** describes missing evidence or decisions. The flagship Four Factors versus surface-adjusted Elo research and deferred Challenger project remain unchanged.','',
    '## Provenance and acquisition','',
    paste0('Archive revision: `',m$pinned_commit[1],'`. The separate [development manifest](../data/manifests/development-source-files.csv) contains exactly two 2021 records; the [2023 pilot manifest](../data/manifests/pilot-source-files.csv) was not migrated or duplicated.'),'',
    unlist(lapply(1:2,function(i)c(paste0('- ',m$tour[i],': [raw CSV](',m$source_url[i],'); [pinned API metadata](',m$metadata_url[i],').'),paste0('  Local CSV: `',m$local_path[i],'`; metadata: `',m$metadata_local_path[i],'`.')))),'',
    pilot_markdown_table(provenance),
    pilot_markdown_table(m[c('tour','metadata_retrieved_at_utc','metadata_byte_size','metadata_sha256')]),
    '**Verified:** API name, path, type, raw download URL and API URL match the approved revision. Raw sizes and Git blob SHA-1 match API metadata; SHA-256 and full CSV parsing pass. Both tours validated in temporary files before either final CSV was placed. Metadata JSON is retained locally for offline verification. No raw bytes were rewritten.','',
    '**Implemented:** base R `download.file(method="curl")` uses the existing system curl with configuration and redirects disabled; R libcurl follows redirects automatically. Only four exact URLs are allowed. Non-200 responses, redirects, error bodies, malformed CSVs and metadata/hash mismatches stop acceptance. This changes transport control, not data source; no dependency was installed. Both valid files and recorded timestamps are reused without requests or writes. A placement failure leaves the milestone incomplete and preserves partial files for review.','',
    '## License and historical snapshot context','',
    '**Inherited documentation:** Jeff Sackmann / Tennis Abstract created the underlying data; the Aneeshers mirror adds no rights. Existing evidence identifies CC BY-NC-SA 4.0 and an archive claiming June 2026 ATP/WTA snapshots. These historical 2021 records are from that later snapshot, not a contemporaneous 2021 capture. Later corrections and historical feature-availability timing are not independently established. See [DATA_LICENSE.md](../DATA_LICENSE.md) and the [source contract](data-source-contract.md).','',
    'Preserve attribution, source revision, license links, noncommercial and applicable share-alike obligations. Local acquisition authorization is not public-release approval. No raw CSV, complete match table or generated audit CSV is committed or published. Future derived-output rights remain a separate review. License/dictionary URLs were not fetched again.','',
    '## File and schema checks','',
    pilot_markdown_table(o$`file-provenance-checks`[c('tour','rows','columns','duplicate_columns','empty_headers','date_min','date_max','integrity')]),
    pilot_markdown_table(schema),
    '**Verified:** all four annual files have the same ordered 49-column header. No added, absent or reordered columns were found in the three requested comparisons; no rename was inferred. All 36 contract-required identity/context/score/ranking/count columns exist. Character parsing preserves IDs, dates and literal source values; blank cells become missing in memory only. This is structural compatibility, not statistical correctness.','',
    paste0('Ordered header: `',o$`schema-comparison`$left_columns[1],'`.'),'',
    'Tour-specific value handling remains necessary. ATP 2021/2023 level vocabularies are A/D/F/G/M. WTA 2021 has D/F/G/I/O/P/PM/W; WTA 2023 has D/F/G/I/P/PM. These are raw codes, not newly verified official classifications. All four files contain hard, clay and grass values. Source best-of formats and bracketed score notation require later format-aware handling; a common header does not justify identical transformations.','',
    '**Comparison warning:** ATP 2023 has 53 missing surface labels and one winner name with surrounding whitespace; neither is filled or normalized. Each 2023 count field has 171 missing ATP values and 238 missing WTA values. Ranking/ranking-points gaps are ATP winner 22, loser 31; WTA winner 23, loser 55. No literal NA tokens or malformed nonmissing required numeric tokens were found in the four files. These full-file observations extend the profile beyond the original two-event pilot without changing its evidence.','',
    '## Twenty target cells: source candidates only','',
    'Matching uses only the contract section 7 literal aliases, case-insensitively with alphanumeric boundaries. No nearest-name or fuzzy matches. Tournament IDs and valid date labels must both identify 2021. Family labels below are audit annotations; source names/IDs remain untouched. Multiple metadata records, multiple candidate IDs or a name matching several families produce an ambiguous cell. Missing cells remain explicit.','',
    pilot_markdown_table(cells[c('tour','event_family_annotation','candidate_records','state')]),
    pilot_markdown_table(candidates[c('tour','event_family_annotation','tourney_id','tourney_name','tourney_date','surface','tourney_level','draw_size','source_rows')]),
    pilot_markdown_table(candidates[c('tour','event_family_annotation','distinct_winner_ids','distinct_loser_ids','distinct_player_ids','rounds','retirement_markers','walkover_markers','default_markers','unfinished_markers','unknown_status_rows','duplicate_source_rows')]),
    '**Verified:** 10 found candidate cells, zero missing and zero ambiguous per tour. No duplicate candidate source rows were found. Canada remains one family annotation: ATP source Canada Masters, WTA source Montreal. ATP Canada has 47 source rows; no official count was acquired to assess that number. Source draw sizes are not treated as entrant counts.','',
    'The source date labels differ across tours, including Madrid (ATP May 3; WTA April 29) and Indian Wells (ATP October 4; WTA October 6). They are tournament-level labels, not actual match dates or a verified event calendar.','',
    '## Count presence and missingness','',
    'Apparent play means at least one positive scored-game count and no walkover marker. It is a descriptive sensitivity cohort, not eligibility or independent completion verification. Joint presence requires all 18 count cells; no bound reconciliation, statistical repair or factor-data admission is performed. Unknown suffixes remain flagged even when score digits supply apparent-play evidence.','',
    pilot_markdown_table(candidates[c('tour','event_family_annotation','apparent_played_rows','jointly_present_apparent_played','joint_presence_pct')]),
    '**Warning:** WTA Canada/Montreal has 47/54 jointly populated apparent-play rows (87.0370%), below the provisional 90% event floor even before official reconciliation or structural validity checks. Seven source matches lack the entire 18-count bundle: four quarterfinals, two semifinals and the final. This is a source-availability warning, not a passed or finalized failed inventory/admission gate. The other 19 cells have 100% joint presence in this descriptive cohort.','',
    pilot_markdown_table(missing),
    '**Verified:** ATP 2021 is missing each count field in 97 rows except both service-game fields (96). WTA 2021 is missing each count field in 94 rows. Ranking/ranking-points gaps are ATP winner 4, loser 26; WTA winner 2, loser 11. Required identity/context/score cells have no missing values. Nonmissing required counts/rank values contain no noninteger or negative tokens; this does not test numerator bounds or true statistical accuracy.','',
    '## Status syntax and audit warnings','',
    pilot_markdown_table(o$`score-status-summary`),
    pilot_markdown_table(o$`audit-checks`[o$`audit-checks`$flagged>0,]),
    'No completely duplicated rows, duplicate tournament/match keys, missing or malformed tournament/player identifiers, same-player ID collisions, invalid dates or wrong-file-year date/ID labels were found in the four inspected annual files. File/tour/year and physical row position provide the audit namespace; no production identity system is created.','',
    '**Warning:** WTA 2021 Montreal `2021-806:260` contains `6-1 4-3 RET+H64`. The retirement marker is recorded and the unexplained suffix remains flagged. Existing WTA 2023 Miami `2023-902:289` similarly contains `7-6(0) 0-2 RET+H61`; this is a new source-profile observation, not a change to the Indian Wells policy. Neither suffix is corrected or assigned a meaning.','',
    'The other-format category contains bracketed match-tie-break strings: four ATP 2021, eight WTA 2021, six ATP 2023 and zero WTA 2023. They are not automatically labeled unfinished or invalid. Explicit unfinished markers and missing scores are zero; this is a marker count, not proof every match completed. Walkover rows with counts are reported separately and not admitted as played merely because counts exist.','',
    '## Existing policies and admission boundaries','',
    'Indian Wells 2023 ATP/WTA inventory gates remain PASS. [ATP precedence policy 1.0.0](atp-inventory-reference-precedence-policy.md) still preserves four resolved PDF conflicts and three conflicting match links, scoped only to its two branches. [WTA quarantine policy 1.0.0](wta-anomaly-and-quarantine-policy.md) still excludes Andreescu–Stearns statistical counts while retaining inventory and played-denominator membership. Existing outputs and evidence are preserved.','',
    'No 2021 candidate has official confirmation or an inventory PASS. The 95% tour-season factor-data gate is untested; the 2021–2023 development panel is incomplete. Retirement/default eligibility, exact match dates, within-day/completion order, rating history and later statistical methods remain unresolved. No Four Factors, Elo, regression, forecasts or predictive evaluation are authorized. 2022, 2024 and 2025 stay closed.','',
    '## Reproduction and verification','',
    'From the repository root, run `Rscript R/download_2021_annual_data.R`, then `Rscript R/audit_2021_annual_data.R --self-test`. Existing matching files require no network requests. The offline audit creates nine ignored CSVs under `data/pilot/development-2021/` and this tracked report; it does not alter the previous pilot or policy outputs. Missing/changed files stop rather than trigger fallback acquisition.','',
    'Outputs: file-provenance-checks, schema-comparison, required-field-summary, event-candidates, event-cell-summary, score-status-summary, audit-checks, value-vocabulary and score-review. All are aggregate/schema summaries or a small list of exceptional score locators; no redundant full match table is generated.','',
    'Tests cover allowlist/pin, API path/revision, blob/size/checksum integrity, malformed/HTML CSV rejection, required-field failure, visible schema differences, alias collisions, missing/ambiguous cells, wrong-year exclusion and status evidence. Final checks include downloader idempotence, byte-identical audit reruns, unchanged prior data/policy hashes, allowed raw inventory, ignore rules, documentation links/anchors, paths/placeholders, complete diff and Git whitespace.','',
    '**Failed approaches:** the sandboxed request could not resolve api.github.com; the explicitly authorized network-enabled retry used the same four-URL downloader and succeeded. No source fallback occurred. An in-memory parser refactor exposed a trailing-newline counting issue; single-row synthetic tests exposed vector simplification in joint-count calculation. Temporary report-assembly syntax errors were also corrected before final verification. These fixes did not edit raw bytes. The narrow metadata scalar parser rejects unexpected response formatting rather than guessing.','',
    '## Smallest recommended next milestone','',
    '**Historical Phase 1E recommendation:** the Phase 1F review below is now [completed](wta-2021-montreal-admission-review.md). It confirms the gaps and provides denominator sensitivities and unimplemented admission options. See [current status](status.md) for the proposed Phase 1G reference-feasibility investigation; no new acquisition or admission is authorized.','',
    '**Proposed Phase 1F:** review the WTA 2021 Canada/Montreal missing-statistics pattern and unexplained score suffix using saved local evidence first; document affected rows and an admission-review plan without repairing values or assuming eligibility. Any official-reference acquisition needs a separate explicit URL allowance. This focused review should precede a decision on wider acquisition; 2022 requires its own authorization, not automatic continuation.','',
    'No portfolio files, models, analytical plots, publishing, deployment, push or pull request are part of this milestone. The next task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.','')
  while(length(lines)&&!nzchar(tail(lines,1)))lines<-head(lines,-1)
  path<-'docs/2021-annual-source-audit.md'
  if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
}

annual_2021_self_test <- function() {
  reject <- function(expr) stopifnot(inherits(tryCatch(force(expr),error=identity),"error"))
  config<-annual_2021_config();m<-annual_2021_manifest()
  stopifnot(all(config$pinned_commit=="83733587353df8a41f2fd4f516147d5aa83f5a8d"),
    length(unique(c(config$source_url,config$metadata_url)))==4L,
    !anyDuplicated(paste(m$tour,m$source_path)),!anyDuplicated(m$local_path))
  reject(annual_2021_allow_url(paste0(config$source_url[1],"?unapproved")))
  text<-paste(readLines(m$metadata_local_path[1]),collapse="\n")
  reject(annual_2021_metadata(NULL,config[1,],sub(config$source_path[1],"atp/atp_matches_2022.csv",text,fixed=TRUE)))
  reject(annual_2021_metadata(NULL,config[1,],sub(config$pinned_commit[1],"main",text,fixed=TRUE)))
  reject(annual_2021_metadata(NULL,config[1,],"<html>error</html>"))
  bad<-m[1,];bad$sha256<-paste(rep("0",64),collapse="")
  reject(annual_2021_validate(m$local_path[1],bad))
  for(text in c("<html>error</html>","", "a,a\n1,2\n", "tourney_id,tourney_name,score,winner_id,loser_id,bad header\n2021-1,X,6-1,1,2,3\n", "tourney_id,tourney_name,score,winner_id,loser_id\n2021-1,X,6-1,1\n"))
    reject(annual_2021_csv(bytes=charToRaw(text)))
  x<-annual_2021_csv(m$local_path[1]);y<-x[setdiff(names(x),"w_svpt")]
  reject(annual_require_columns(y))
  stopifnot(grepl("w_svpt",annual_schema_compare(x,y,"x","y")$absent_in_right,fixed=TRUE),
    annual_schema_compare(x,x[rev(names(x))],"x","reversed")$reordered)
  z<-x[1,,drop=FALSE];z$tourney_id<-"2021-TEST";z$tourney_date<-"20210101";z$tourney_name<-"Miami"
  a<-annual_candidates(z,"ATP");stopifnot(sum(a$cells$state=="found_candidate")==1L,sum(a$cells$state=="missing")==9L)
  z$tourney_name<-"Miami Madrid";a<-annual_candidates(z,"ATP")
  stopifnot(all(a$candidates$family_collision),sum(a$cells$state=="ambiguous")==2L,sum(a$cells$state=="found_candidate")==0L)
  z$tourney_name<-"Miami";w<-z;w$tourney_id<-"2021-SECOND"
  stopifnot(annual_candidates(rbind(z,w),"ATP")$cells$state[6]=="ambiguous")
  z$tourney_id<-"2022-TEST";a<-annual_candidates(z,"ATP")
  stopifnot(!nrow(a$candidates),all(a$cells$state=="missing"),identical(names(a$candidates),names(annual_candidates(x,"ATP")$candidates)))
  z$tourney_id<-"2021-TEST";z$tourney_date<-"20220101"
  stopifnot(!nrow(annual_candidates(z,"ATP")$candidates),!annual_alias_hit("Chaoyang","AO"))
  st<-annual_status(c("6-1 4-3 RET+H64","W/O","6-0 4-4 Def.","SUSPENDED","mystery","0-0 RET"))
  stopifnot(st$retirement[1],st$unrecognized_status_text[1],!st$apparent_played[2],st$default[3],st$unfinished[4],st$unrecognized_status_text[5],!st$apparent_played[6])
  stopifnot(!annual_valid_date("20210230"),!annual_valid_date("2021-01-01"))
  # File + tour + year + physical row is the audit identity, not a player link.
  prior<-pilot_read_manifest(pilot_config());keys<-character()
  for(records in list(m,prior))for(i in seq_len(nrow(records))){
    r<-records[i,];rows<-annual_2021_csv(r$local_path)
    year<-sub(".*_([0-9]{4})[.]csv$","\\1",r$local_path)
    keys<-c(keys,paste(r$local_path,r$tour,year,seq_len(nrow(rows)),sep=":"))
  }
  stopifnot(!anyDuplicated(keys),length(keys)==sum(as.numeric(m$row_count),as.numeric(prior$row_count)))
  snapshot<-function(paths)data.frame(path=paths,sha256=vapply(paths,pilot_sha256,""),mtime=as.numeric(file.info(paths)$mtime))
  paths<-c(m$local_path,m$metadata_local_path,"data/manifests/development-source-files.csv")
  before<-snapshot(paths)
  # Any accidental request in either rerun must fail without reaching the net.
  original_request<-annual_2021_request
  assign("annual_2021_request",function(...)stop("Unexpected network request during reuse test."),envir=.GlobalEnv)
  on.exit(assign("annual_2021_request",original_request,envir=.GlobalEnv),add=TRUE)
  download_2021_annual_data();download_2021_annual_data()
  stopifnot(identical(before,snapshot(paths)))
  paths<-c(list.files("data/pilot/development-2021",pattern="[.]csv$",full.names=TRUE),"docs/2021-annual-source-audit.md")
  before<-snapshot(paths)
  invisible(capture.output(audit_2021_annual_data()));invisible(capture.output(audit_2021_annual_data()))
  stopifnot(identical(before,snapshot(paths)))
  message("Phase 1E in-memory tests passed: allowlist/pin, metadata, checksum, malformed CSV, required/schema fields, aliases, ambiguous/missing/year cells and status evidence.")
  message("Annual/tour row namespaces and downloader/audit rerun bytes and timestamps passed; network disabled during reruns.")
  invisible(TRUE)
}

if (sys.nframe()==0L) {
  audit_2021_annual_data()
  if ("--self-test" %in% commandArgs(trailingOnly=TRUE)) annual_2021_self_test()
}
