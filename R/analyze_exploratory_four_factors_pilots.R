# Phase 2F release 1.0.0: registered exploratory same-match analysis; inert on source.
pf_baseline <- '6926b9139c8fb72ac11569d668b0560ced42675a'
pf_dir <- 'data/pilot/exploratory-four-factors-analysis'
pf_report <- 'docs/exploratory-four-factors-pilot-analysis.md'
pf_names <- c('input-provenance','match-metrics','reproduction-comparison','candidate-set-registry','availability-summary','association-summary','collinearity-diagnostics','npr-model-summary','npr-incremental-contributions','same-match-win-summary','stability-summary','candidate-scorecard','decisions','summary')
pf_need <- function(ok,why) if(!isTRUE(ok))stop(paste('Phase 2F BLOCKED:',why),call.=FALSE)
pf_trace <- new.env(parent=emptyenv());pf_trace$reads<-character();pf_trace$calls<-character();pf_trace$parsed<-character();pf_trace$fits<-character()
# Copied immutable count/identity helpers use this release's separate authority pins.
pf_fields <-
function ()
c("ace", "df", "svpt", "1stIn", "1stWon", "2ndWon", "SvGms", "bpFaced", "bpSaved")
pf_pair_validity <-
function (a, b)
{
    need <- pf_fields()
    pf_need(identical(names(a), need) && identical(names(b), need), "nine named counts each side")
    v <- c(a, b)
    bad <- any(!is.na(v) & (!is.finite(v) | v < 0 | v != floor(v)))
    for (x in list(a, b)) {
        A <- x["ace"]
        D <- x["df"]
        S <- x["svpt"]
        I <- x["1stIn"]
        F <- x["1stWon"]
        Q <- x["2ndWon"]
        G <- x["SvGms"]
        B <- x["bpFaced"]
        V <- x["bpSaved"]
        failures <- c(I > S, F > I, Q > S - I, D > S - I, Q + D > S - I, V > B, B > S, A > F + Q, G > S, S == 0)
        bad <- bad || any(failures, na.rm = TRUE)
    }
    list(invalid = bad, missing = anyNA(v))
}
pf_match_index <-
function (raw_ids, linked_ids)
{
    pf_need(!anyNA(c(raw_ids, linked_ids)) && !anyDuplicated(raw_ids) && !anyDuplicated(linked_ids) && setequal(raw_ids,
        linked_ids), "duplicate, ambiguous or missing match mapping")
    match(raw_ids, linked_ids)
}
pf_orientation <-
function (winner_id, loser_id)
{
    pf_need(!anyNA(c(winner_id, loser_id)) && all(grepl("^[0-9]+$", c(winner_id, loser_id))) && all(winner_id !=
        loser_id), "missing, ambiguous or identical source player IDs")
    vapply(seq_along(winner_id), function(k) order(c(winner_id[k], loser_id[k]), method = "radix")[1] == 1, TRUE)
}
pf_adapter <-
function (input)
{
    e <- pf_legacy()
    b <- input$base
    res <- list()
    raws <- list()
    bundles <- list()
    for (cell in c("ATP|2023|Indian Wells", "WTA|2023|Indian Wells", "WTA|2021|Canada")) {
        bits <- strsplit(cell, "|", fixed = TRUE)[[1]]
        tour <- bits[1]
        year <- as.integer(bits[2])
        fam <- bits[3]
        id <- if (year == 2021)
            "2021-806"
        else if (tour == "ATP")
            "2023-0404"
        else "2023-609"
        raw <- b$data[[paste(tour, year, sep = "|")]]
        raw <- raw[raw$tourney_id == id, , drop = FALSE]
        ids <- paste(tour, raw$tourney_id, raw$match_num, sep = ":")
        origin <- rep("original_source", nrow(raw))
        if (year == 2023) {
            links <- input$iw$`match-reconciliation`
            links <- links[links$tour == tour, , drop = FALSE]
            k <- pf_match_index(ids, links$source_id)
            links <- links[k, , drop = FALSE]
            o <- input$iw$`official-matches`
            o <- o[!o$bye & o$tour == tour, , drop = FALSE]
            o <- o[pf_match_index(links$official_id, o$official_id), , drop = FALSE]
            pf_need(all(o$winner_id == raw$winner_id & o$loser_id == raw$loser_id & o$round == raw$round), "official/source pair, winner or round mismatch")
            source <- input$iw$`source-matches`
            source <- source[source$tour == tour, , drop = FALSE]
            source <- source[pf_match_index(ids, source$source_id), , drop = FALSE]
            status <- ifelse(o$status == "completed", "normally_completed", o$status)
            quarantine <- source$statistical_bundle_quarantined & status == "normally_completed"
            evidence <- paste(links$reference_id, links$reference_locator, links$resolution_state, sep = ";")
            conflict <- nzchar(links$conflicts) | quarantine
            detail <- paste(links$conflicts, source$reason_codes, sep = ";")
            official_id <- links$official_id
            policy <- ifelse(links$resolution_state == "not_required", "corroborated_inventory", links$resolution_state)
        }
        else {
            d <- input$m$dispositions
            k <- pf_match_index(paste0("sackmann:", ids), d$source_audit_id)
            d <- d[k, , drop = FALSE]
            pf_need(all(d$status_resolved & !d$unresolved & d$winner_agreement & d$score_agreement), "Montreal unresolved status/linkage")
            pf_need(all(d$source_winner == raw$winner_id & d$round == raw$round & d$source_score == raw$score),
                "Montreal source link mismatch")
            pf_need(!anyNA(d$source_statistical_quarantine) && all(d$source_statistical_quarantine == "none_adopted_for_this_event"),
                "Montreal quarantine flag changed")
            status <- d$classification
            quarantine <- rep(FALSE, nrow(d))
            origin <- d$count_origin
            evidence <- paste(d$html_locator, d$pdf_locator, sep = ";")
            official_id <- d$official_code
            policy <- d$status_policy
            conflict <- !is.na(d$applicable_resolution)
            detail <- paste(d$source_status, d$html_status, d$pdf_status, d$applicable_resolution, sep = ";")
        }
        pf_need(all(status %in% c("normally_completed", "retirement", "walkover")), "unknown/conflicting status blocks all pilots")
        expected <- if (year == 2021)
            c(49L, 5L, 1L)
        else if (tour == "ATP")
            c(91L, 4L, 0L)
        else c(92L, 2L, 1L)
        pf_need(identical(as.integer(table(factor(status, levels = c("normally_completed", "retirement", "walkover")))),
            expected), "pilot status accounting changed")
        pf_need(identical(ids[quarantine], if (tour == "WTA" && year == 2023)
            "WTA:2023-609:268"
        else character()), "quarantine rule changed")
        oriented <- pf_orientation(raw$winner_id, raw$loser_id)
        counts <- raw
        if (year == 2021) {
            f <- input$mi$overlay$field_decisions
            targets <- e$mro_targets()
            targets <- targets[targets$recovery, ]
            pf_need(nrow(f) == 126 && !anyDuplicated(paste(f$source_audit_id, f$source_field)) && setequal(f$source_audit_id,
                targets$audit_id), "Montreal recovery scope changed")
            for (j in which(origin == "approved_recovery_overlay")) {
                ff <- f[f$source_audit_id == paste0("sackmann:", ids[j]), , drop = FALSE]
                fields <- c(paste0("w_", pf_fields()), paste0("l_", pf_fields()))
                pf_need(nrow(ff) == 18 && setequal(ff$source_field, fields) && all(is.na(raw[j, fields])) && status[j] ==
                  "normally_completed", "recovery missing, partial or outside completed scope")
                pf_need(all(ff$source_winner_id == raw$winner_id[j] & ff$source_loser_id == raw$loser_id[j]) &&
                  all(ff$policy_version == "1.0.0") && all(ff$structural_validation_state == "passed_51_of_51_applicable_checks"),
                  "recovery mapping/proof differs")
                counts[j, fields] <- as.list(ff$value[match(fields, ff$source_field)])
            }
            pf_need(sum(origin == "approved_recovery_overlay") == 7 && sum(status == "normally_completed" & origin ==
                "original_source") == 42, "42+7 recovery accounting")
        }
        valid <- logical(nrow(raw))
        reason <- character(nrow(raw))
        aa <- bb <- vector("list", nrow(raw))
        for (j in seq_len(nrow(raw))) {
            w <- setNames(as.numeric(counts[j, paste0("w_", pf_fields())]), pf_fields())
            l <- setNames(as.numeric(counts[j, paste0("l_", pf_fields())]), pf_fields())
            aa[[j]] <- if (oriented[j])
                w
            else l
            bb[[j]] <- if (oriented[j])
                l
            else w
            vv <- pf_pair_validity(w, l)
            ck <- e$pilot_audit_event(counts[j, , drop = FALSE], tour)$checks
            complete_checks <- all(ck$evaluated_rows == 1 & ck$flagged_rows == 0 & ck$not_evaluable_rows == 0)
            reason[j] <- if (status[j] != "normally_completed")
                paste0("excluded_", status[j])
            else if (quarantine[j])
                "quarantined_bundle"
            else if (vv$invalid || any(ck$flagged_rows > 0))
                "invalid_bundle"
            else if (vv$missing)
                "missing_input"
            else if (!complete_checks)
                "invalid_bundle"
            else "included"
            valid[j] <- reason[j] == "included"
        }
        pf_need(!any(status == "normally_completed" & !quarantine & !valid), "required pilot statistical bundle no longer validates")
        src <- b$records[[paste(tour, year, sep = "|")]]
        res[[cell]] <- data.frame(cell_id = cell, tour = tour, season = year, event = fam, surface = raw$surface,
            match_id = ids, source_tournament_id = raw$tourney_id, source_match_number = raw$match_num, round = raw$round,
            source_score = raw$score, source_winner_id = raw$winner_id, source_loser_id = raw$loser_id, source_winner_name = raw$winner_name,
            source_loser_name = raw$loser_name, player_a_id = ifelse(oriented, raw$winner_id, raw$loser_id), player_b_id = ifelse(oriented,
                raw$loser_id, raw$winner_id), player_a_name = ifelse(oriented, raw$winner_name, raw$loser_name),
            player_b_name = ifelse(oriented, raw$loser_name, raw$winner_name), a_original_side = ifelse(oriented,
                "winner", "loser"), b_original_side = ifelse(oriented, "loser", "winner"), official_id = official_id,
            status = status, completed_denominator = status == "normally_completed", quarantined = quarantine,
            valid_bundle = valid, exclusion_reason = reason, count_origin = origin, source_path = src$local_path,
            source_sha256 = src$sha256, status_evidence = evidence, status_policy = policy, conflict_preserved = conflict,
            conflict_detail = detail, source_missing_fields = rowSums(is.na(raw[c(paste0("w_", pf_fields()), paste0("l_",
                pf_fields()))])), scope = "audit_only_noncanonical", stringsAsFactors = FALSE)
        for (j in seq_len(nrow(raw))) bundles[[ids[j]]] <- list(a = aa[[j]], b = bb[[j]])
        raws[[cell]] <- raw
    }
    d <- do.call(rbind, res)
    d <- d[order(d$match_id, method = "radix"), ]
    rownames(d) <- NULL
    pf_need(nrow(d) == 245 && !anyDuplicated(d$match_id) && sum(d$valid_bundle) == 231, "complete pilot adapter accounting")
    list(eligibility = d, bundles = bundles, raw = raws)
}
pf_hash <-
function (p)
{
    pf_need(is.character(p) && length(p) == 1L && !is.na(p) && p %in% c(names(pf_pins()), names(pf_historical_pins())),
        "unapproved hash-only path")
    z <- system2("shasum", c("-a", "256", shQuote(p)), stdout = TRUE)
    pf_need(is.null(attr(z, "status")) && length(z) == 1L, "SHA-256 failed")
    substr(z, 1, 64)
}
pf_allow <-
function (p)
{
    pf_need(is.character(p) && length(p) == 1L && !is.na(p) && p %in% names(pf_pins()), "unapproved input path")
    pf_need(!grepl("2022|2024|2025", p) && file.exists(p) && identical(normalizePath(p), file.path(normalizePath("."),
        p)), "missing, redirected or forbidden input")
    pf_need(identical(pf_hash(p), unname(pf_pins()[p])), paste("changed input", p))
    TRUE
}
pf_guard <-
function (p)
{
    pf_allow(p)
    pf_trace$reads <- unique(c(pf_trace$reads, p))
    invisible(TRUE)
}
pf_read <-
function (p)
{
    pf_guard(p)
    readLines(p, warn = FALSE)
}
pf_csv <-
function (p)
read.csv(text = paste(pf_read(p), collapse = "\n"), stringsAsFactors = FALSE, check.names = FALSE)
pf_verify <-
function ()
{
    p <- names(pf_pins())
    for (f in p) pf_allow(f)
    data.frame(path = p, role = ifelse(grepl("^R/", p), "immutable_count_inventory_helper", ifelse(grepl("^data/raw/",
        p), "saved_source_or_reference", ifelse(grepl("manifest", p), "saved_manifest", ifelse(grepl("overlay",
        p), "approved_recovery_overlay", ifelse(grepl("^data/pilot/", p), "frozen_comparison", "current_or_adopted_authority"))))),
        sha256 = unname(pf_pins()), byte_size = file.info(p)$size, stringsAsFactors = FALSE)
}
pf_annual_map <-
function ()
setNames(c("2023-0404", "2023-609", "2021-806"), paste0("data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/",
    c("atp_matches_2023.csv", "wta_matches_2023.csv", "wta_matches_2021.csv")))
pf_scoped_csv <-
function (p, empty = FALSE, sparse = FALSE)
{
    pf_need(p %in% names(pf_annual_map()), "unapproved annual parse")
    lines <- pf_read(p)
    target <- pf_annual_map()[[p]]
    pf_need(startsWith(lines[1], "tourney_id,"), "annual header changed")
    ix <- which(startsWith(lines[-1], paste0(target, ",")))
    x <- read.csv(text = paste(c(lines[1], lines[ix + 1L]), collapse = "\n"), colClasses = "character", na.strings = if (empty)
        NULL
    else "", check.names = FALSE, fill = FALSE, comment.char = "", row.names = NULL)
    pf_need(length(ix) > 0L && all(x$tourney_id == target) && all(x$surface == "Hard") && !anyDuplicated(x$match_num),
        "pilot row scope")
    pf_trace$parsed <- unique(c(pf_trace$parsed, paste(p, target, sep = ":")))
    if (sparse) {
        out <- x[rep(NA_integer_, length(lines) - 1L), , drop = FALSE]
        out[] <- ""
        out[ix, ] <- x
        rownames(out) <- seq_len(nrow(out))
        return(out)
    }
    rownames(x) <- ix
    list(raw = x, index = ix)
}
pf_process <-
function (command, args = character(), ...)
{
    permitted <- c("git", "shasum", "sha256sum", "pdftotext", unname(Sys.which(c("git", "shasum", "sha256sum",
        "pdftotext"))), path.expand("~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext"))
    pf_need(is.character(command) && length(command) == 1L && !is.na(command) && nzchar(command) && command %in%
        permitted, "unapproved executable")
    a <- gsub("^['\"]|['\"]$", "", args)
    name <- basename(command)
    hash <- name %in% c("shasum", "sha256sum") && length(a) %in% c(1L, 3L) && tail(a, 1) %in% names(pf_pins()) &&
        (name == "sha256sum" || identical(head(a, 2), c("-a", "256")))
    pdf <- name == "pdftotext" && sum(a %in% names(pf_pins())) == 1L && all(a %in% c("-f", "-l", "1", "-layout",
        "-bbox-layout", "-", names(pf_pins()))) && grepl("[.]pdf$", a[a %in% names(pf_pins())])
    git <- name == "git" && length(a) %in% c(2L, 3L) && a[1] == "hash-object" && tail(a, 1) %in% names(pf_pins()) &&
        (length(a) == 2L || a[2] == "--no-filters")
    pf_need(isTRUE(hash) || isTRUE(pdf) || isTRUE(git), "unapproved subprocess")
    for (p in a[a %in% names(pf_pins())]) pf_guard(p)
    pf_trace$calls <- c(pf_trace$calls, name)
    z <- base::system2(command, args, ...)
    pf_need(is.null(attr(z, "status")) || attr(z, "status") == 0L, "local subprocess failure")
    z
}
pf_legacy <-
function ()
{
    e <- new.env(parent = globalenv())
    e$source <- function(file, ...) {
        pf_guard(file)
        sys.source(file, envir = e)
    }
    e$readLines <- function(con, ...) {
        pf_guard(con)
        base::readLines(con, ...)
    }
    e$readBin <- function(con, ...) {
        pf_guard(con)
        base::readBin(con, ...)
    }
    e$readRDS <- function(file, ...) {
        pf_guard(file)
        base::readRDS(file, ...)
    }
    e$read.csv <- function(file, ...) {
        if (missing(file))
            return(utils::read.csv(...))
        pf_guard(file)
        if (file %in% names(pf_annual_map()))
            return(pf_scoped_csv(file, empty = TRUE, sparse = TRUE))
        utils::read.csv(file, ...)
    }
    e$system2 <- pf_process
    e$write.csv <- function(x, file, ...) {
        pf_need(inherits(file, "textConnection"), "disk write forbidden")
        utils::write.csv(x, file, ...)
    }
    e$source("R/audit_montreal_completed_match_coverage.R")
    e$pilot_read_csv <- function(path) {
        if (path %in% names(pf_annual_map()))
            return(pf_scoped_csv(path)$raw)
        e$read.csv(path, colClasses = "character", check.names = FALSE, na.strings = "", fill = FALSE, comment.char = "")
    }
    e$pilot_validate_file <- function(path, record) {
        pf_guard(path)
        pf_need(pf_hash(path) == record$sha256 && file.info(path)$size == as.numeric(record$byte_size) && length(pf_read(path)) -
            1L == as.integer(record$row_count), "manifest byte/hash/physical-row mismatch")
        list(sha256 = pf_hash(path), byte_size = file.info(path)$size, row_count = as.integer(record$row_count))
    }
    e$annual_2021_manifest <- function(required = TRUE) {
        p <- "data/manifests/development-source-files.csv"
        m <- e$read.csv(p, colClasses = "character", check.names = FALSE, na.strings = "")
        m <- m[m$tour == "WTA", , drop = FALSE]
        pf_need(nrow(m) == 1L, "one WTA source manifest record")
        e$pilot_validate_file(m$local_path, m)
        api <- e$annual_2021_metadata(m$metadata_local_path, m)
        pf_need(api$sha == m$source_git_blob && api$size == m$byte_size, "WTA metadata mismatch")
        m
    }
    e$montreal_load <- function() {
        m <- e$annual_2021_manifest()
        s <- pf_scoped_csv(m$local_path)
        list(selected = s, provenance = data.frame(tour = m$tour, year = "2021", path = m$local_path, size = m$byte_size,
            rows = m$row_count, sha256 = m$sha256, blob = m$source_git_blob))
    }
    e$pilot_write_csv <- function(x, path) {
        pf_guard(path)
        z <- character()
        con <- textConnection("z", "w", local = TRUE)
        write.csv(x, con, row.names = FALSE, na = "")
        close(con)
        pf_need(identical(readLines(path, warn = FALSE), z), paste("frozen audit mismatch", path))
        invisible(path)
    }
    deny <- function(...) stop("CURRENT_CONTEXT_PILOTS_BLOCKED: forbidden acquisition or empirical operation",
        call. = FALSE)
    for (n in c(grep("^download_|_request$|^test_|^write_|^fc_", ls(e), value = TRUE), "annual_2021_csv", "annual_candidates",
        "annual_2021_validate", "montreal_suffixes", "download.file", "url", "socketConnection", "system", "pipe",
        "lm", "glm", "cor", "cov", "predict", "optim", "mice", "writeLines", "saveRDS")) assign(n, deny, e)
    e
}
pf_load <-
function ()
{
    before <- pf_verify()
    e <- pf_legacy()
    iw <- e$reconcile_indian_wells_inventory()
    mi <- e$mmc_load()
    m <- e$mmc_derive(mi)
    pf_need(all(iw$`inventory-summary`$inventory_gate == "PASS") && mi$inventory$state == "COMPLETE" && all(mi$inventory$criteria$passed),
        "inventory/status prerequisite")
    b <- list(data = list(), records = list())
    for (p in names(pf_annual_map())) {
        tour <- if (grepl("/atp_", p))
            "ATP"
        else "WTA"
        year <- if (grepl("2021", basename(p)))
            "2021"
        else "2023"
        k <- paste(tour, year, sep = "|")
        b$data[[k]] <- pf_scoped_csv(p)$raw
        manifest <- if (year == "2021")
            e$annual_2021_manifest()
        else e$pilot_read_manifest(e$pilot_config())
        b$records[[k]] <- manifest[manifest$tour == tour, , drop = FALSE]
    }
    pf_need(identical(before, pf_verify()), "inputs changed during reconstruction")
    list(base = b, iw = iw, mi = mi, m = m, provenance = before)
}
pf_cells <-
function ()
c("ATP|2023|Indian Wells", "WTA|2023|Indian Wells", "WTA|2021|Canada")
pf_fingerprint <-
function (ids)
{
    pf_need(is.character(ids) && !anyNA(ids) && !anyDuplicated(ids) && !any(grepl("[\r\n]", ids)), "unknown or duplicate set member")
    z <- system2("shasum", c("-a", "256"), input = c(as.character(length(ids)), sort(ids, method = "radix")), stdout = TRUE)
    pf_need(is.null(attr(z, "status")) && length(z) == 1L, "set digest failed")
    substr(z, 1, 64)
}
pf_set <-
function (actual, frozen, label)
{
    a <- pf_fingerprint(actual)
    b <- pf_fingerprint(frozen)
    pf_need(setequal(actual, frozen) && identical(a, b), paste("exact membership differs", label))
    data.frame(category = label, reconstructed_count = length(actual), frozen_count = length(frozen), reconstructed_fingerprint = a,
        frozen_fingerprint = b, agreement = "EXACT", discrepancy = "none", stringsAsFactors = FALSE)
}
pf_preserve <-
function ()
{
    pins <- pf_historical_pins()
    for (p in names(pins)) {
        pf_need(file.exists(p) && normalizePath(p) == file.path(normalizePath("."), p), paste("historical file missing or redirected",
            p))
        pf_need(identical(pf_hash(p), unname(pins[p])), paste("historical file changed", p))
    }
    data.frame(path = names(pins), sha256 = unname(pins), byte_size = file.info(names(pins))$size, mtime = as.numeric(file.info(names(pins))$mtime),
        row.names = NULL)
}

# The unchanged Phase 2A formulas are copied, never its empirical entry point.
pf_dictionary <-
function ()
{
    p <- "docs/post-otd-analytical-path.md"
    pf_allow(p)
    pf_need(pf_hash(p) == pf_pins()[[p]], "formula contract changed")
    rows <- grep("^\\| M[0-9][0-9] ", readLines(p), value = TRUE)
    x <- as.data.frame(do.call(rbind, lapply(rows, function(r) trimws(strsplit(r, "|", fixed = TRUE)[[1]][-1]))),
        stringsAsFactors = FALSE)
    names(x) <- c("metric", "numerator", "denominator", "source_fields", "interpretation", "range", "undefined_rule",
        "coupling", "overlap", "family", "failure_reason")
    x$id <- sprintf("M%02d", seq_len(nrow(x)))
    pf_need(nrow(x) == 15 && all(x$undefined_rule == "U1"), "complete catalogue required")
    x$expected_direction <- ifelse(x$id %in% c("M05", "M06", "M14"), "negative", "positive")
    x$direction_caveat <- ifelse(x$id == "M02", "hypothesis_only_first_in_quality_tradeoff", "same_match_hypothesis_not_verified_effect")
    x
}
pf_ratio <-
function (num, den, missing = FALSE, invalid = FALSE, upper = 1)
{
    reason <- if (invalid)
        "invalid_bundle"
    else if (missing || anyNA(c(num, den)))
        "missing_input"
    else if (!all(is.finite(c(num, den))) || den < 0 || num < 0 || (den > 0 && num/den > upper))
        "invalid_bundle"
    else if (den == 0 && num != 0)
        "invalid_bundle"
    else if (den == 0)
        "zero_opportunities"
    else "defined"
    list(value = if (reason == "defined") as.numeric(num/den) else NA_real_, reason = reason)
}
pf_side <-
function (a, b, external_invalid = FALSE)
{
    v <- pf_pair_validity(a, b)
    A <- a["ace"]
    D <- a["df"]
    S <- a["svpt"]
    I <- a["1stIn"]
    F <- a["1stWon"]
    Q <- a["2ndWon"]
    G <- a["SvGms"]
    B <- a["bpFaced"]
    V <- a["bpSaved"]
    s <- b["svpt"]
    i <- b["1stIn"]
    f <- b["1stWon"]
    q <- b["2ndWon"]
    g <- b["SvGms"]
    bb <- b["bpFaced"]
    vv <- b["bpSaved"]
    num <- unname(c(A, I, F, Q, D, D, Q, s - f - q, i - f, s - i - q, bb, bb - vv, V, B, F + Q))
    den <- unname(c(S, S, I, S - I, S - I, S, S - I - D, s, i, s - i, g, bb, B, G, S))
    out <- data.frame(id = sprintf("M%02d", 1:15), numerator = num, denominator = den, value = NA_real_, reason = "")
    for (k in 1:15) {
        z <- pf_ratio(num[k], den[k], v$missing, external_invalid || v$invalid, if (k %in% c(11, 14))
            Inf
        else 1)
        out$value[k] <- z$value
        out$reason[k] <- z$reason
    }
    out
}
pf_outcomes <-
function (a, b, invalid = FALSE)
{
    v <- pf_pair_validity(a, b)
    if (invalid || v$invalid || v$missing)
        return(c(NPR = NA_real_, equal_phase_NPR = NA_real_))
    sw <- a["1stWon"] + a["2ndWon"]
    ow <- b["1stWon"] + b["2ndWon"]
    S <- a["svpt"]
    s <- b["svpt"]
    wa <- sw + s - ow
    wb <- ow + S - sw
    pf_need(isTRUE(wa + wb == S + s), "paired point-universe reconciliation")
    c(NPR = unname(100 * (wa - wb)/(S + s)), equal_phase_NPR = unname(100 * (sw/S - ow/s)))
}
pf_metrics <-
function (adapter)
{
    d <- adapter$eligibility
    out <- d[c("cell_id", "tour", "season", "event", "surface", "match_id", "player_a_id", "player_b_id", "a_original_side",
        "b_original_side", "status", "count_origin", "completed_denominator", "valid_bundle", "quarantined")]
    ids <- sprintf("M%02d", 1:15)
    for (side in c("a", "b")) for (id in ids) {
        for (field in c("value", "numerator", "denominator")) out[[paste(side, id, field, sep = "_")]] <- NA_real_
        out[[paste(side, id, "reason", sep = "_")]] <- NA_character_
    }
    out$NPR <- out$equal_phase_NPR <- out$same_match_win <- NA_real_
    for (i in seq_len(nrow(d))) {
        pair <- adapter$bundles[[d$match_id[i]]]
        if (d$valid_bundle[i]) {
            a <- pf_side(pair$a, pair$b)
            b <- pf_side(pair$b, pair$a)
            for (side in c("a", "b")) for (k in 1:15) for (field in c("value", "numerator", "denominator", "reason")) out[[paste(side,
                ids[k], field, sep = "_")]][i] <- get(side)[[field]][k]
            o <- pf_outcomes(pair$a, pair$b)
            out$NPR[i] <- o[1]
            out$equal_phase_NPR[i] <- o[2]
            out$same_match_win[i] <- as.integer(d$a_original_side[i] == "winner")
        }
        else for (side in c("a", "b")) for (id in ids) out[[paste(side, id, "reason", sep = "_")]][i] <- if (d$quarantined[i])
            "invalid_bundle"
        else d$exclusion_reason[i]
    }
    for (id in ids) {
        out[[paste0("diff_", id)]] <- out[[paste0("a_", id, "_value")]] - out[[paste0("b_", id, "_value")]]
        for (side in c("a", "b")) {
            den <- out[[paste(side, id, "denominator", sep = "_")]]
            flag <- rep(FALSE, nrow(out))
            for (cell in unique(out$cell_id)) {
                ix <- which(out$cell_id == cell & is.finite(den) & den > 0)
                if (length(ix))
                  flag[ix] <- den[ix] == min(den[ix])
            }
            out[[paste(side, id, "sample_minimum_positive_denominator", sep = "_")]] <- flag
        }
    }
    out
}
pf_cor <-
function (x, y, method = "pearson")
{
    ok <- is.finite(x) & is.finite(y)
    n <- sum(ok)
    if (method == "spearman") {
        x <- round(x, 12)
        y <- round(y, 12)
    }
    reason <- if (n < 3)
        "insufficient_pairs"
    else if (length(unique(x[ok])) < 2 || length(unique(y[ok])) < 2)
        "constant_variable"
    else "defined"
    list(n = n, value = if (reason == "defined") unname(cor(x[ok], y[ok], method = method)) else NA_real_, reason = reason)
}

pf_historical_pins <- function()
c(.gitignore = "90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217",
AGENTS.md = "67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
LICENSE = "4d86cfe44cf70c29d2c976a2c274bfa26cb951adbe2bf496ad203c35dbf03319",
PROJECT_CONTEXT.md = "865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1",
`R/acquire_montreal_chronology_stage_a.R` = "1b33b09a92cfecb38cb84ec3578b28617e62ffef6140ee3a117a35103d4d2e6d",
`R/audit_2021_annual_data.R` = "4e376a0e1e2ee822515d2d227f457bed095cc4dca61a6285a29ec07311a423bd",
`R/audit_event_boundary_feasibility.R` = "4c22ad4be1e4e92e55fc8169859a9884730ab6f692b65c60512f17e4128d4da9",
`R/audit_four_factors_candidate_metrics.R` = "a25f4d2c0dfb4b17fc0a48ef1e389a79dcfef58f128f1f03b9e32a89e70494f5",
`R/audit_montreal_chronology_evidence.R` = "70721881800b2be310ce0a80c994203eb404ff44aae8afb509bd612f72ef2bae",
`R/audit_montreal_completed_match_coverage.R` = "f5e1b57c38a72cf13a7e2a3ce988ce1067b4ac2d53e389423aa8efe40cf84749",
`R/audit_montreal_reference_feasibility.R` = "d0935e2e0d1a72bd32252883f2d601dcc09cddbc906ca149b26512a36648d9f1",
`R/audit_pilot_data.R` = "82bed285763b478614c4c296f92eeb554a6ef104134080e054c7c7b720f6e608",
`R/audit_wta_anomaly.R` = "90b0c3d40fbe4a69e30de51b6a089ace535c26e62d32aeec6e1a9aa9429687a4",
`R/download_2021_annual_data.R` = "43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068",
`R/download_anomaly_references.R` = "596943db417128ff17498353864d8336b788b87add8e1fb2fcde24070d751c2d",
`R/download_inventory_references.R` = "077e4fe176a977f1d64f75b5f86d1e468e26baa5f7e27485adfee0655adc084b",
`R/download_montreal_references.R` = "a48984a9a9b87275ed561109e20d3e0331ce5aef6fc440044d53417291ff2287",
`R/download_pilot_data.R` = "5facb085d14f1c5007c97cd7008d77173cc9e7b74a96eca1c7bc49696ccb4299",
`R/implement_montreal_recovery.R` = "224d0dbcab70b184f0fc8ac67b924b2e15f77cbe698664a7594d4d11606c8e6d",
`R/plan_development_cohort_expansion.R` = "561b37cb007a1c6b452b1911f86bcf4d3eef082cfcac57ef7ff05f9f2dd97210",
`R/plan_package_b_evidence_route.R` = "2a97465f0fedcdfa52ec0c9903dc5cd25c7c7eef5bb29414d611ab2206232948",
`R/reconcile_indian_wells_inventory.R` = "84ae65145e3505e578a7287af2bf25d08f8e8f25d2bc35be7fb0b10ecd9fdb93",
`R/reconcile_montreal_inventory.R` = "52dd718b67a95aa01bc015daa66f8a5a739cc6ccd121c5229046ce68b3053e24",
`R/revalidate_current_context_pilots.R` = "0305d0a2c3265344925330e4edccb1bbf7bab3337ac953161fcdd8a00c4cc895",
`R/review_otd_documentation.R` = "77474a35741afc8d27e146c8eaac42bdfabb44c19213e8d72f9b999d98c1bc78",
`R/review_wta_2021_montreal.R` = "5b180b4a30521ed126fc75363065c5b376fac6dc7994bb73823dcac4064b07ef",
`R/test_current_context_pilot_revalidation.R` = "bc0530c14f1ceaa84e31c6eeb6b3c294a29140d59365c84a8a21ea01ff489c1c",
`R/test_development_cohort_expansion_readiness.R` = "f384985371cf2599e60597cbed4c905fa8895b35ff981bdd8352b51f811393be",
`R/test_event_boundary_feasibility.R` = "0f410913ef642ceb679b84bf474751e2e3a4f241deb08c5f050ebce494739989",
`R/test_four_factors_candidate_metrics.R` = "ad1a5570f42eda5e5d522adabc70700b210f1a49635bbf4dbfc7d92c60c2c14c",
`R/test_four_factors_definition_protocol.R` = "e21a3c111d07e044e0d736991e3dc854b6d4e2c89d3994337190eb14e564af14",
`R/test_montreal_chronology_acquisition_plan.R` = "59ebe0463105cecc7191141409bd6ffb2edbd006f0e7cf4e53020a6d149414aa",
`R/test_montreal_chronology_evidence.R` = "2f78a6f5e74c200b9339c8e2635facca4e285563a0439a3b63bc28de83b92888",
`R/test_montreal_chronology_policy.R` = "8a856ee34a03470e73a311b975e87b6e1d50c3a5090d57475c9e463aaba09eb3",
`R/test_montreal_chronology_stage_a.R` = "8caed2e08b45375272545847caf753beb1bd3b9668eda165c609832a167c9821",
`R/test_montreal_completed_match_coverage.R` = "ab6d680ae81c2e409161deed81822734eab79841402dca70e5f25ebb71067d7e",
`R/test_montreal_inventory.R` = "ddea19214b8b16733e6969139559da458feb0a928ffecfe2c10137a630108cbb",
`R/test_montreal_recovery.R` = "a247d4da067422a484d38155095fff35facc8a6bcfd93bd4ce2d440389638f70",
`R/test_otd_documentation.R` = "b6d4dd4195021f6b7b85b39f8d59c2710e625ab052e424fe3eb1ee429de8b443",
`R/test_package_b_evidence_route.R` = "51cf6359211b5198a0c51c72f80cc5936d9384e1dd6376a79f416bb617673d74",
`R/test_post_otd_analytical_path.R` = "1bceb436a51a3be3308b3a076b3b9bcbed6ee6b3ddd0a55216b4b85f78e39280",
`R/test_tennis_chronology_path_decision_brief.R` = "6918ad0177bf61ccb62c6b42219be39e28fdfc59ce5fbe98c8b611d32d556793",
README.md = "ff2973a538ef106f93888fd9f99a63901fa5e92f27e04f8c276bc056a948256f",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`docs/2021-annual-source-audit.md` = "22ffb45943267d77b81bb69f67b65cd3650a4d7f4f83ae0658e2fd89c6cab9e5",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/current-context-pilot-revalidation.md` = "ae355197b6ef77eae8c5027868ba2e8bcad459731249f4e73e3ce55dfec1adcc",
`docs/development-cohort-expansion-readiness.md` = "dd219cdac7b993f94f80e98f71f64cd0ab16dae675af039d1d5c382b35d1ea10",
`docs/event-boundary-feasibility.md` = "19685452eb8af4d587ebb7c816f56748544c3037bae797dc81fe7344ce7f8b9b",
`docs/four-factors-candidate-metric-feasibility.md` = "413c4d67fb24f6e84faffe98008a65fa85cc5a5c13be60c9cd6e0d61af22eb59",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/indian-wells-inventory-reconciliation.md` = "8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e",
`docs/otd-documentation-preflight.md` = "1f5d361425f614a0e78de9b108ed9a252b9af6db93946f051733e38468fb2054",
`docs/package-b-evidence-route-proposal.md` = "0cd8cc94043b37764456b46ed0a56cc941006ae88ae136dbd0f310ef12e3d3e8",
`docs/pilot-acquisition-audit.md` = "5ddf6cc62da5dc506af99021c768502fb8740d5d6367a56067e50b1d14c15275",
`docs/post-otd-analytical-path.md` = "14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
`docs/tennis-chronology-path-decision-brief.md` = "5eb5d3940ba444110679ba57e320d2b75f139f67e5528ef1917e9172912ed93e",
`docs/wta-2021-montreal-admission-review.md` = "93837e74f5ac13891933f730d323d142a56589c0c795566d571237ea5b0cb441",
`docs/wta-2021-montreal-chronology-acquisition-plan.md` = "42ae79f33005893711523ebb2606fb2154f6c5ba5f2e7c30e099956838c13904",
`docs/wta-2021-montreal-chronology-policy.md` = "cfbbe87732d813e4e31f1b2bd2478bb92d2329150fee8c951700ed97c31c421c",
`docs/wta-2021-montreal-chronology-stage-a.md` = "842f603c0a1075ca58395f89a805b981a6f07fdda3f043de95ee169d0c62db12",
`docs/wta-2021-montreal-completed-match-coverage.md` = "168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8",
`docs/wta-2021-montreal-inventory-reconciliation.md` = "6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4",
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-2021-montreal-recovery-verification.md` = "d15fd1dd7e43bc6e0740e1f9395b8c5c5d8d1bca204318df48c4f0ad2281f151",
`docs/wta-2021-montreal-reference-feasibility.md` = "b795e744ffd14b3f7f0734b30701e32031846b08e04b23a229718361cfe8fe77",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
`tennis-analytics-public-data-research.pdf` = "1c18296ff08f22a0284100788104640267275f8ff33fa7840014fb29c96224ad",
`data/pilot/anomaly/anomaly-coverage.csv` = "72e1a325e434645b9d440be30f759a84e99360857cc55832b434dca16ccd8e39",
`data/pilot/anomaly/anomaly-disposition.csv` = "3f5d084b1116954de31f2b1e3f4ba4c6880236a791cc2e4c5449d6e060a9c8eb",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
`data/pilot/anomaly/anomaly-validation-checks.csv` = "9593116997633f55c2fbd14e9d076aadd657c46cc773d481c5145575e4f3b583",
`data/pilot/anomaly/wta-draw-page1.png` = "3d42d3dce092ff9721bd9945bab71a1f5ed0ac77071c11290b9c16cb4753303e",
`data/pilot/atp_indian_wells_2023.csv` = "31b43453ed46a709fd51bd50b372ec2c605258d5a9814db13c963377def2ac6a",
`data/pilot/availability.csv` = "6557caa0c7188d24c2679fb97a7c73ef32c11884f0293a11c2dc4dfbe62a8d15",
`data/pilot/candidates.csv` = "ff9cb8262872f492a7061b43cae2ea23b4d3141fdc74b57f9a42441330d37c71",
`data/pilot/checks.csv` = "a902e755bc29e55f3506c6a2e2a0bd4da143f2aa777ac0adad3b83dbc63e24e0",
`data/pilot/coverage.csv` = "909f940f4e9bb937f97b8934968ade1ede306f66962e2536df2b5dce73097de0",
`data/pilot/current-context-pilot-revalidation/bundle-comparison.csv` = "3204450b7675f4e04f65bc68e9b4c1b0dbd109e824d5d0e6e911792bc6d5817f",
`data/pilot/current-context-pilot-revalidation/decisions.csv` = "c0b944b233a8ca61f6e8adb5109bfcc0ebb6d8fc66fa320ab324f8ccba04adb0",
`data/pilot/current-context-pilot-revalidation/exclusion-comparison.csv` = "1379430c6b4c775c500d29a1cf59c9fe434f39d652d2aaff94a6688b4fd67755",
`data/pilot/current-context-pilot-revalidation/input-provenance.csv` = "3d139dd958178cbfcacd6b72d9a557d49e2275a4772466cc34be03034dc11863",
`data/pilot/current-context-pilot-revalidation/pilot-comparison.csv` = "b815e76854148a3880d9d4d1233a9f053568f3dc893bdd59a264650b6789d174",
`data/pilot/current-context-pilot-revalidation/rights-scope.csv` = "50b383015f7f9ddcbd51bdf428704a77bce0aad3f320bae467978cd988410f66",
`data/pilot/current-context-pilot-revalidation/summary.csv` = "42335be8b41b404cdd6cf71eba43d7e4309ef434919dc4a3a7f1958d5c312b5c",
`data/pilot/development-2021/audit-checks.csv` = "c74483a5e316a6b5285339fe8f37daae713575cb33ea59f0cd2c119bc8bf35d1",
`data/pilot/development-2021/event-candidates.csv` = "d5d66ebe2c3c82708776a997549233d8f3898ee6d89aaced5ec7e8821fb2adcb",
`data/pilot/development-2021/event-cell-summary.csv` = "27f41af18cd215d575a11a24b8d749aac2f35e6621333b05105b5589ae78d3d8",
`data/pilot/development-2021/file-provenance-checks.csv` = "25833899b99a85c8d33485eb85d3754d2fb3cc9e4d975149a57952ccc6399765",
`data/pilot/development-2021/montreal-chronology-acquisition/attempt-1.rds` = "6e916914d611f8979c4f50c1cdc753004c11451d0d60b402f34033316525afa8",
`data/pilot/development-2021/montreal-chronology-acquisition/attempt-1.rds.sha256` = "cfe40b43ff86656b695516fd7c7fb0c364f66d2406279d748c0f98b85ee63a5f",
`data/pilot/development-2021/montreal-chronology-acquisition/response-1.rds` = "29169021bda2c231389e2eb5c382d1b31b3f30f25b09497abd2b376d046ee653",
`data/pilot/development-2021/montreal-chronology-acquisition/response-1.rds.sha256` = "cb43d2813d89b11114b14bda6afbee3550c88e86d89b216b1f011f7892c6f9a8",
`data/pilot/development-2021/montreal-chronology-acquisition/review-1.rds` = "0f12e94450eeb59dfa057531e8b817173171e233b6692cf1bf410a201c757d43",
`data/pilot/development-2021/montreal-chronology-acquisition/review-1.rds.sha256` = "5cc9ddf4801bc2be8cf8b62a7105ec58f23e35b7321afc90de2b041ad200f686",
`data/pilot/development-2021/montreal-chronology-acquisition/stage-a-manifest.csv` = "2265cb488c4e165a4b2ad288defd75adfe559d1972659f6a0e0f03a92165efd9",
`data/pilot/development-2021/montreal-chronology-evidence/conflicts.csv` = "8e938ad910ece05452105b67a82e027a5149b3baddad8af0e16e2db34afadd6f",
`data/pilot/development-2021/montreal-chronology-evidence/decisions.csv` = "cf9a4c1566f65acc24ce3ca8a1187bac7b3bcd47ab20fa48bf84804daca1d20e",
`data/pilot/development-2021/montreal-chronology-evidence/dispositions.csv` = "d2f137712fa2a775698c3109801629c106b03d2d6d88d76c670f7ff8e9ea94ad",
`data/pilot/development-2021/montreal-chronology-evidence/edges.csv` = "56b87368170b93da809a4fd47f8694eec462d5cc08d93c4e72a5d5e576c908f0",
`data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv` = "775d542da9631493885d3e28814e56ed84d1fe337dbc1d60542ef4dbf9781812",
`data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv` = "b3ebf221967bf54fb3b7f818065e55109b2d63faffed83d8f4a79ba6e3126640",
`data/pilot/development-2021/montreal-chronology-evidence/observations.csv` = "782f2867a2b1bc3005220448a7f9f17aeca27a75b0ba8019f3eecfef4dc82771",
`data/pilot/development-2021/montreal-chronology-evidence/options.csv` = "07f802ed255dfb918b5feb49074ca94bd53c3f3a52f79a1f106a94edcde02205",
`data/pilot/development-2021/montreal-chronology-evidence/players.csv` = "6f0e3136b2917ce94b0483fb7a4f2c5e9013d23e74ca185cea3299b3d34428bf",
`data/pilot/development-2021/montreal-chronology-evidence/summary.csv` = "4ebee91ecb18c06078b242b527422972724e682edc9f9e8861c7019de606678f",
`data/pilot/development-2021/montreal-completed-match-coverage/count-links.csv` = "35b1d84c77615af55e9c9e5b6500754720cfd97ff0f65ff4c0dc33a9e405172b",
`data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv` = "c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
`data/pilot/development-2021/montreal-completed-match-coverage/structural-checks.csv` = "2362fbea966688f221b602d5da16f47d725314215d2ec4f14c27eaa12ae2d788",
`data/pilot/development-2021/montreal-completed-match-coverage/summary.csv` = "288355b44a1a77c52a9674366b247962728c4736bb3026b1af53593adb32170b",
`data/pilot/development-2021/montreal-inventory/code-sequence.csv` = "3769366c8d3f23bafd3d6eb011c11c8be733ff0aea80a1de42699c57048e8df6",
`data/pilot/development-2021/montreal-inventory/criteria.csv` = "aa1d1b3805cc26a197d0d45436950fe88e1a8bc3b34ca60fabc7eb612fb0fa16",
`data/pilot/development-2021/montreal-inventory/html-draw.csv` = "611de6706379a6272f75fdbfd1a6a6a59f780cb22f195f7e63b892ee91b24302",
`data/pilot/development-2021/montreal-inventory/identity-decisions.csv` = "48a75d3a1021540671a06e18dbbe859b8f87a718480dab11c6fe6c35b906bc5f",
`data/pilot/development-2021/montreal-inventory/inventory-status-resolutions.csv` = "ac132b3dc41c005dec89ea129b6fce1150d6ba315bb4b3540793a3ba779221a0",
`data/pilot/development-2021/montreal-inventory/official-only.csv` = "c1a28e32fcf57307c9e14c01dbd769055e680009daa55f57f55f4f1185303fc7",
`data/pilot/development-2021/montreal-inventory/pdf-draw.csv` = "9c162cf73db7f3f0932ecf20aae3462000c655bd66a294fb1a70c370cd1a9c8c",
`data/pilot/development-2021/montreal-inventory/pdf-entrant-positions.csv` = "b04a559ea25c1a8a3c1ee731fac1e0d8ffcfb8e355416a71e0a3ff9ae29ee469",
`data/pilot/development-2021/montreal-inventory/provenance.csv` = "41170583116a2e625874cd71ecff2719b93b26239d0d991ad2988367602eec90",
`data/pilot/development-2021/montreal-inventory/reconciliation-links.csv` = "78be7c62d539103a77770c06f4ea019c70a63fc4e95a406cab693892247f4f1c",
`data/pilot/development-2021/montreal-inventory/reference-comparisons.csv` = "6e1e8ccf45a1596541e856831f4731f881698ee1803503deb7f8815c5ec3212a",
`data/pilot/development-2021/montreal-inventory/source-inventory.csv` = "e8c9ed1d8a54c915bf26844a1ec8ab2a25c649e1356b32ead3165b8ebe54e513",
`data/pilot/development-2021/montreal-inventory/summary.csv` = "ae274408a0df303573d4f0273464e009fda670b4d95fc5e9cc3a252d141ddf56",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/development-2021/montreal-reference-feasibility/coverage-scenarios.csv` = "180f6ba53e30677c3702ed3cd11274b4348075caa8411c97d83af071812516b4",
`data/pilot/development-2021/montreal-reference-feasibility/feasibility-dispositions.csv` = "0c879ab4d6fea166c8ee29784d6f73cccc9688c950457d99170ab809eb9f178c",
`data/pilot/development-2021/montreal-reference-feasibility/field-comparisons.csv` = "d687758bf17c808f85cf7d6e613a80d0629f9a9dacfdca0d618c561132d0ad5b",
`data/pilot/development-2021/montreal-reference-feasibility/official-stat-observations.csv` = "f498a9da20d037771622276332472c3d53bac1e6060141576a8e78b89391f008",
`data/pilot/development-2021/montreal-reference-feasibility/pdf-target-evidence.csv` = "7631d244260c8464e54b31c1a5cc74b7689652eb9154918d8826b4ed27a5ba54",
`data/pilot/development-2021/montreal-reference-feasibility/reference-checks.csv` = "e4999f73eb8768118a7f66ec929c145404447834723579c79c430b3658a43140",
`data/pilot/development-2021/montreal-reference-feasibility/reference-match-inventory.csv` = "77bd218219f554b056296d642d243eb4d796cb6f65681122959ffa806cce4ffe",
`data/pilot/development-2021/montreal-reference-feasibility/status-evidence.csv` = "3b9e6478ac9e1496d5ccdd67d0f15bbe8560cb3bbbfa8a0637fb78eb06c58023",
`data/pilot/development-2021/montreal-reference-feasibility/structural-checks.csv` = "f1d7ab46958d1e5448e7a5ee0249bbadd22518cf563a3bd9844b5aa9a0bfc133",
`data/pilot/development-2021/montreal-review/affected-player-history.csv` = "a096ba9e8b598c81b9f18d328f365f74bf476f8fa9e011787d76f62c5c6ffdd3",
`data/pilot/development-2021/montreal-review/anomaly-dispositions.csv` = "73963c688ca1eefd88f888676e2c08819f87fc48e744025c249aed7bf6732a97",
`data/pilot/development-2021/montreal-review/denominator-sensitivity.csv` = "a95f9c0f25ab722b2a66f952ab215975cff7010cb5be4f673c09b12bd3093189",
`data/pilot/development-2021/montreal-review/match-bundle-inventory.csv` = "93661f84350b7396a2849f2e975f43d45f5db3be4c78360bd51c3bd51a1c1860",
`data/pilot/development-2021/montreal-review/review-checks.csv` = "701a752146b245a83a31b5c53c1a6fc8eb45ae225866d5a6ee9b67fa273d52c7",
`data/pilot/development-2021/montreal-review/round-coverage.csv` = "11dfecd91562ce96101564219f9d5b14a9d19eee739f5c75a07a8f16477e1cc2",
`data/pilot/development-2021/montreal-review/score-suffix-review.csv` = "341f5b7bd53c8cfdc06de348089125881bb4418dedaa5c52e74bb4eba0006008",
`data/pilot/development-2021/montreal-review/source-progression.csv` = "87beb81ecea72031e47f788abbd2323a5a39a1b3f3b326d27c18e4808ddf4fd9",
`data/pilot/development-2021/required-field-summary.csv` = "0e26a06d58a3d87e73fcd60fda19c01df1dbdf01f797657ff53c56d2d424804d",
`data/pilot/development-2021/schema-comparison.csv` = "f42ad6acf1978cb163ab4767cb142c9cec25a6ca9c73c0bbc6cb33291ebf16d2",
`data/pilot/development-2021/score-review.csv` = "7df72dc063b36f9b45d34593ffd66448f24b2bf369ee5fae40272085b4c514b1",
`data/pilot/development-2021/score-status-summary.csv` = "f07dc5610c2db2b06ee3afcb4c01df4b62dbe76fb4468b5f255abf8835931b0d",
`data/pilot/development-2021/value-vocabulary.csv` = "27d8a82467cb2991bb0a1e3c1e871b8400fcdacbdf34c3a3c49fc78607355a19",
`data/pilot/development-cohort-expansion-readiness/cell-prerequisites.csv` = "34a869ffde2e817af2f1717eae3f2ec0119959c5c6f6aa1c4680def79dd3b819",
`data/pilot/development-cohort-expansion-readiness/cell-readiness.csv` = "66ed229e23335514fa8d1abcacde62bbc033fc53cf954004d84833f5630c0d4f",
`data/pilot/development-cohort-expansion-readiness/current-context-requirements.csv` = "28a724f58dacea1f3131e21ea7d50a021a27093858637e9e30448dfa7842e425",
`data/pilot/development-cohort-expansion-readiness/decisions.csv` = "f3736b931504d99ceabcd80e82e8b148bbf6fb0fcd2deb2e62d79e080599e91c",
`data/pilot/development-cohort-expansion-readiness/input-provenance.csv` = "3e9cd0c56fb298a53e2f2cd29eea64c61f75466c7381d3af7bf54488e7e56c93",
`data/pilot/development-cohort-expansion-readiness/package-comparison.csv` = "dbc5d6438c96ab5204a117dd8b5c425025975d3e2cc88c8df6642edb4a9044fb",
`data/pilot/development-cohort-expansion-readiness/summary.csv` = "bea133007f852c9232375f39a085893b5219bff685e86e5089d02154dc0b013b",
`data/pilot/event-boundary-feasibility/decisions.csv` = "ee77cff85d24d2cb2211cd3607957b46115b7f229903dc665b2dbeaf9e2962ba",
`data/pilot/event-boundary-feasibility/event-boundary-evidence.csv` = "1a05809feba86664627c707a6b0b14b678bc06418b48c68473cc479ef0a74c61",
`data/pilot/event-boundary-feasibility/event-cells.csv` = "76358755c89aeacf79ae452ad606eca755d52cab2bc3954c3ef0f58e64c12ae8",
`data/pilot/event-boundary-feasibility/event-pairs.csv` = "5771c03ceb5e5d8cb4b082a5c8f475e9f0ccb7f42864e6bb2da5a4d98c68314e",
`data/pilot/event-boundary-feasibility/input-provenance.csv` = "66944e572d4dc7ab4224a0ea5b758a6d75a31d3958256a1c86b0ebd2a5a03ff3",
`data/pilot/event-boundary-feasibility/player-event-dependencies.csv` = "8db61b852fa5d7465b5c3cd082f3dcad859ccdc2b6ef187b547c84f8ea6f5955",
`data/pilot/event-boundary-feasibility/scenarios.csv` = "c5359cb7f103cd6f63f71cc17a8b8e65355bf1551941ad9d84197aed1e9c2575",
`data/pilot/event-boundary-feasibility/source-candidates.csv` = "9229340b953dec55196a97c95ec0e807982ca1aaa434fb3533125a1d777062bd",
`data/pilot/event-boundary-feasibility/strategy-comparison.csv` = "f54de048d8c65d3f812585741177670c0259726f18879f01d5e7bdee23bc369c",
`data/pilot/event-boundary-feasibility/summary.csv` = "db8ecd40a52bf6803cfcf004bfcffda8a3d3df67094a2aca4173f49e26d33718",
`data/pilot/event.csv` = "968bfd42521ab8a40d30bf8ea4819f03b46fdd81ff85b699ab3ca31c5680c818",
`data/pilot/four-factors-candidate-metric-feasibility/association-summary.csv` = "1c8481ff2d7a8ffa0744d60fd756ed6fd35183d26a6e611f816a995fc1bb98b0",
`data/pilot/four-factors-candidate-metric-feasibility/candidate-dictionary.csv` = "34184649c3e20e9d0ee1224738dbedd59ff5fa49bc9161c66a80e5914ed52125",
`data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv` = "7ea6feb58a428ab45bfabcc2a5c3a87eef0485f92062fa1e1cac4b4cade5d982",
`data/pilot/four-factors-candidate-metric-feasibility/denominator-summary.csv` = "222b94f1544f58580fc680011323c5d83b7f8a3409a8c74169ddec9f66b31e12",
`data/pilot/four-factors-candidate-metric-feasibility/distribution-summary.csv` = "61f3c54bbffa28bb29c14ab352672a3009e5b32e63a92ae090b4de3d98900052",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
`data/pilot/four-factors-candidate-metric-feasibility/input-provenance.csv` = "63ebeaec1a754242be1cf55721efa1b5349bfb53fc3daf38903bee66a5a94924",
`data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv` = "08fab6a064cde564a6dc949e41c2ee46fcf7a69a327322fffed62168196d945d",
`data/pilot/four-factors-candidate-metric-feasibility/matrix-diagnostics.csv` = "220144d8fcaceb0e4c59c333d4ec23c36b2ad7001c3c080fc50f137705460dc5",
`data/pilot/four-factors-candidate-metric-feasibility/metric-availability.csv` = "7601e8261ea0c6f1dde8faf04fb0d9da880949bf9bf63b4e42374435d6391e2f",
`data/pilot/four-factors-candidate-metric-feasibility/missingness-summary.csv` = "95e4ed1f8563265db097958e3587c3b004675505730ffd5e549cf99b171660f5",
`data/pilot/four-factors-candidate-metric-feasibility/redundancy-map.csv` = "7dd57550d3ce1bdd8646d00e9673f340c4000b3dbf12fbd4a4d5e2ec6cce4fd0",
`data/pilot/four-factors-candidate-metric-feasibility/sensitivity-summary.csv` = "a3f16f79d7bc9def780256f3a9ab9b7ad568e6f93fececfe17427a1f4544423e",
`data/pilot/four-factors-candidate-metric-feasibility/summary.csv` = "617825c03b3098df820503211bd5c9b200ce88e0c30a05235871c457b14043cf",
`data/pilot/identities.csv` = "ca4a10a2482d08cb74a19014f9d755e1a735decd58170cb9ac498a3d4ebf8680",
`data/pilot/inventory/atp-page-1.png` = "4122e2c6bf3fd394a1e18d160d963d2dbaa2bfceb649777b7f9e17e8cfefe151",
`data/pilot/inventory/atp-page-2.png` = "8e9a33cbd0adbb40dc5de0b4cd8f3bd62dc405f522e4e24b77999f48b38c5011",
`data/pilot/inventory/atp-pdf-observations.csv` = "260b281c7992e79b47dafc21a236c24fe5fa33e5b38b2cdd581c630b2a0e91cd",
`data/pilot/inventory/conflicts.csv` = "1a5234946b836f4f2c1b6ca26f1222b3a5ae4fd7d880c2db475ff597696f61f6",
`data/pilot/inventory/identity-review.csv` = "57b29e77bd6a31e525eb6b2289275313ab45999732774cf8c1cc9e3bb1fbb3d9",
`data/pilot/inventory/inventory-summary.csv` = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
`data/pilot/inventory/match-reconciliation.csv` = "e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
`data/pilot/inventory/normalization-decisions.csv` = "e8e63e2947ff0f36781013d0f06308c1e4b64206f6f2764932bb7f5532360225",
`data/pilot/inventory/official-matches.csv` = "3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
`data/pilot/inventory/official-only.csv` = "3d170c1cc2c66e7a957cf8b32f743d2631463c0b3a2d90888bf917c8ad32e544",
`data/pilot/inventory/reference-comparison.csv` = "e8fa870adcf0818c32b6f2df13a724f90a000c1bf3d3e12340c4041198b70e4e",
`data/pilot/inventory/reference-conflicts.csv` = "8a7df76185b3f591c2fc2067941b6a2a0e8108b9ebe6fc5f41c3d8ceeb4d0f7a",
`data/pilot/inventory/round-summary.csv` = "f4d34ec90b25ee96473ebedcd43e0589ca2b92dfb6d6c6386923d90d020f9466",
`data/pilot/inventory/source-matches.csv` = "c5beb37d7453558cec3501ed1f28db27c3c634d953d99cb3e5c4763a7595145f",
`data/pilot/inventory/source-only.csv` = "a0297e28dbfdea9291ec165c821b17fe9fdbb512360550412010addfeee6777d",
`data/pilot/inventory/status-summary.csv` = "64c7b7975bd58f03a74cc343528890bcd7c1372750f1ba0c1d4401ccd851b352",
`data/pilot/inventory/wta-page-1.png` = "2b220bd7aed99c5a04840012a8b30483eef548663b89db1334e2dcea3b0bdd71",
`data/pilot/inventory/wta-page-2.png` = "32231a4a5e4e32a1923e87196ee2a0f4ae0a10b99d57cf78f78fd45ed9078970",
`data/pilot/otd-documentation/attempt-1.rds` = "ac1f2208f5efbed8d0b62bc6801d8db9842c25554ceb19728aec6b0e26f0930d",
`data/pilot/otd-documentation/attempt-1.rds.sha256` = "a16934d60c54978971f4424e58be70df5cfc19fb71d1a94a119dc72f824b163b",
`data/pilot/otd-documentation/manifest.csv` = "156973b5af3abc7864e28eab1e88318c369b988d3ab4f6c602ab796658354aee",
`data/pilot/otd-documentation/manifest.csv.sha256` = "a29628e170552899573442aea803cfc21df5de5d0bfc8a0e19e6219b1c13b1ac",
`data/pilot/otd-documentation/response-1.rds` = "bc15b4f2494d31f347ae29df012c38fb2bf6a27396ec799f82a1a3d6e125026d",
`data/pilot/otd-documentation/response-1.rds.sha256` = "e60f3d69de55cb082854bd294bea2e73e2a4810f3f941d96d2383cda4445c607",
`data/pilot/otd-documentation/review-1.rds` = "c741444b2cffca17c5d60446ba8d747e33ea1e252df5fa9df61d2b0bca80bef3",
`data/pilot/otd-documentation/review-1.rds.sha256` = "6db1fc95e1e059cda4a5acef4353113d53fc50d4fd365d62d41a223105e93807",
`data/pilot/package-b-evidence-route-proposal/cell-evidence-gaps.csv` = "830dbd35fd603c7da5a1012c4f7e73220e21402b9dda9985e3eda843affeb2a2",
`data/pilot/package-b-evidence-route-proposal/decisions.csv` = "70828d4b104f11cf1b3e02455e9c25f8b74ea32e14a5e202f2193a0111c977d7",
`data/pilot/package-b-evidence-route-proposal/input-provenance.csv` = "6a7b33b7d5e52645850b982ae5abb3e96d2cfb925131c5c8367906e26ae52efd",
`data/pilot/package-b-evidence-route-proposal/route-assessment.csv` = "b91b3cec9602d2307653fb0e1c8f6b3ee68d4a31badc29f112da92212139470c",
`data/pilot/package-b-evidence-route-proposal/staged-execution-plan.csv` = "ff908155b5ac119f5cdc5319ae5f104811788bc2cf1f302ce7bd923f0d71f61a",
`data/pilot/package-b-evidence-route-proposal/summary.csv` = "358fdbb1d60c6c168e1ac93afb19763d94f703af02efa9859fd70db6a063118d",
`data/pilot/rounds.csv` = "f32cdb94b64e95d0aa63ce7bbf4166cd352879aa313502ca6c843bc0ec6d8b04",
`data/pilot/rows.csv` = "fce15646c8383093f14f361424510abbfbf0ba0f41065e5aa41453947bd56b5c",
`data/pilot/statuses.csv` = "6a36fd87568819f69ea472bb04c9b3915853d413e6c8c61b858b2ad86b2bef69",
`data/pilot/wta_indian_wells_2023.csv` = "03afd50a16de2d955f8e45760bc2e9667362288f2c791ccacb5c1047908b149f",
`data/raw/.DS_Store` = "c48ea71611f2bcd9c21742eb62bd03b4063eb27fb2bc01a6b9bd27f45fcb0cac",
`data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html` = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
`data/raw/reference/indian-wells-2023-anomaly/wta-draws.html` = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
`data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html` = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
`data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf` = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
`data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt` = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
`data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt` = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
`data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf` = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
`data/raw/reference/montreal-2021-chronology/wta-stage-a-terms.html` = "f0185c0ec14067732a3797e3604ef686edf739241371ca91d41fb741cf558918",
`data/raw/reference/montreal-2021-feasibility/draw_html.html` = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
`data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf` = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
`data/raw/reference/montreal-2021-feasibility/LS001.html` = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
`data/raw/reference/montreal-2021-feasibility/LS002.html` = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
`data/raw/reference/montreal-2021-feasibility/LS003.html` = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
`data/raw/reference/montreal-2021-feasibility/LS004.html` = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
`data/raw/reference/montreal-2021-feasibility/LS005.html` = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
`data/raw/reference/montreal-2021-feasibility/LS006.html` = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
`data/raw/reference/montreal-2021-feasibility/LS007.html` = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
`data/raw/reference/montreal-2021-feasibility/LS042.html` = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
`data/raw/reference/montreal-2021-feasibility/LS049.html` = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
`data/raw/reference/montreal-2021-feasibility/overview.html` = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
`data/raw/reference/otd-documentation/response-1.body` = "51e17ec16942ccd9f2512da9bb0ee32389579632094859a7efc6322f2f80cc0f",
`data/raw/reference/otd-documentation/response-1.headers` = "3851615d6390eefe24d80018601602619175a7010fa6627b2b038fcf4fe33e63",
`data/raw/sackmann/.DS_Store` = "34c0710c3eb41078e4def3824febe392b2cd803b364c79e1e8b6cf0c5653ddef",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.csv` = "b9b1d31a4b0b9273b8f338cbb1347c5a847ad2361334ec760a286f5990fba347",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.metadata.json` = "1b51d087b873bb723c9d36d9f5c1d0a7a1157ba8e41a00cfbe8edb2ea1723a71",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv` = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv` = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json` = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv` = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18"
)

# Registered before fitting. No empirical ranking can alter this registry.
pf_registry <- function() {
  serve<-rep(c('M01','M02','M03'),each=3)
  security<-rep(c('M04','M05','M06'),3)
  data.frame(set_id=c(sprintf('S%02d',1:9),sprintf('T%02d',1:3)),
    role=c(rep('PRIMARY_ALTERNATIVE',9),rep('SENSITIVITY_ONLY',3)),
    serve_creation=c(serve,'M01','M02','M03'),second_serve_security=c(security,rep('M07',3)),
    return_pressure='M11',conversion_recovery='M12',
    cohort='within_slice_common_complete_all_registered_metrics',
    denominator_sensitivity='intersection_of_all_registered_metric_strict_lower_quartile_masks',
    stringsAsFactors=FALSE)
}
pf_spec <- function() list(reproduction_tolerance=5e-12,increment_numeric_zero=1e-10,
  glm_epsilon=1e-8,glm_maxit=25L,residual_flag=3,leverage_multiplier=2,
  collinearity=c(review=.8,warning=.9,near=.95,vif_concern=5,vif_unacceptable=10,condition=30),
  uncertainty='NOT_ASSESSABLE_UNDER_PILOT_DESIGN',practical_effect_margin='PENDING_SPECIFICATION')
pf_terms <- function(set) unname(unlist(set[c('serve_creation','second_serve_security','return_pressure','conversion_recovery')]))
pf_registered <- function(set) {
  reg<-pf_registry();i<-match(set$set_id,reg$set_id)
  pf_need(length(i)==1L&&!is.na(i)&&identical(unname(unlist(set)),unname(unlist(reg[i,,drop=FALSE]))),'unregistered candidate set')
  ids<-pf_terms(set);pairs<-list(c('M03','M09'),c('M04','M10'),c('M08','M15'),c('M11','M14'),c('M12','M13'))
  pf_need(length(ids)==4L&&!anyDuplicated(ids)&&!any(vapply(pairs,function(p)all(p%in%ids),TRUE)),'duplicate/complement coexistence')
  pf_need(!any(ids%in%c('M08','M15'))&&(!'M07'%in%ids||set$role=='SENSITIVITY_ONLY'),'candidate role violation');TRUE
}
pf_modeled_metrics <- function() sort(unique(unlist(pf_registry()[3:6],use.names=FALSE)))
pf_role <- function(id) ifelse(id%in%c('M08','M15'),'BENCHMARK_ONLY',ifelse(id=='M07','SENSITIVITY_ONLY','PRIMARY_ALTERNATIVE'))
pf_expected <- function(id) ifelse(id%in%c('M05','M06','M14'),'negative','positive')
pf_direction <- function(x) ifelse(!is.finite(x),'undefined',ifelse(abs(x)<=sqrt(.Machine$double.eps),'numerically_zero',ifelse(x>0,'positive','negative')))
pf_reason <- function(a,b) ifelse(a=='invalid_bundle'|b=='invalid_bundle','invalid_bundle',
  ifelse(a=='missing_input'|b=='missing_input','missing_input',ifelse(a=='zero_opportunities'|b=='zero_opportunities','zero_opportunities','defined')))
pf_reproduce <- function(input=pf_load()) {
  adapter<-pf_adapter(input);a<-adapter$eligibility
  old<-pf_csv('data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv')
  k<-pf_match_index(a$match_id,old$match_id);old<-old[k,,drop=FALSE]
  for(n in names(a))pf_need(identical(as.character(a[[n]]),as.character(old[[n]])),paste('frozen eligibility mismatch',n))
  pop<-pf_csv('data/pilot/current-context-pilot-revalidation/pilot-comparison.csv')
  rights<-pf_csv('data/pilot/current-context-pilot-revalidation/rights-scope.csv')
  decisions<-pf_csv('data/pilot/current-context-pilot-revalidation/decisions.csv')
  pf_need(identical(pop$cell_id,pf_cells())&&all(pop$status=='PASS')&&
    all(rights$scope_state=='SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD')&&
    decisions$value[decisions$id=='TERMINAL_DECISION']=='CURRENT_CONTEXT_PILOTS_REVALIDATED','Phase 2E population gate')
  for(cell in pf_cells()) {
    d<-a[a$cell_id==cell,,drop=FALSE];p<-pop[pop$cell_id==cell,,drop=FALSE]
    for(category in c('inventory','completed','accepted','excluded','quarantined','recovered','original')) {
      mask<-switch(category,inventory=rep(TRUE,nrow(d)),completed=d$completed_denominator,accepted=d$valid_bundle,
        excluded=!d$valid_bundle,quarantined=d$quarantined,recovered=d$valid_bundle&d$count_origin=='approved_recovery_overlay',
        original=d$valid_bundle&d$count_origin=='original_source')
      pf_need(sum(mask)==p[[paste0(category,'_count')]]&&pf_fingerprint(d$match_id[mask])==p[[paste0(category,'_fingerprint')]],paste('Phase 2E membership',cell,category))
    }
  }
  adapter$eligibility<-a[a$valid_bundle,,drop=FALSE]
  pf_need(nrow(adapter$eligibility)==231L&&all(adapter$eligibility$status=='normally_completed')&&!any(adapter$eligibility$quarantined),'exact eligible population')
  # Only the 231 admitted bundles enter any metric/outcome calculation.
  x<-pf_metrics(adapter);frozen<-pf_csv('data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv')
  frozen<-frozen[frozen$valid_bundle,,drop=FALSE]
  comparison<-pf_compare_metrics(x,frozen)
  pf_trace$reproduction<-TRUE
  list(metrics=x,comparison=comparison,eligibility=adapter$eligibility)
}
pf_compare_metrics <- function(x,frozen) {
  k<-pf_match_index(x$match_id,frozen$match_id);frozen<-frozen[k,,drop=FALSE]
  pf_need(identical(names(x),names(frozen)),'metric schema mismatch')
  out<-list()
  for(n in names(x)) {
    a<-x[[n]];b<-frozen[[n]];floating<-grepl('_value$|^diff_|^NPR$|^equal_phase_NPR$',n)
    pf_need(identical(is.na(a),is.na(b)),paste('availability mismatch',n))
    if(floating) {
      ok<-!is.na(a);error<-abs(a[ok]-b[ok]);tol<-pf_spec()$reproduction_tolerance*pmax(1,abs(b[ok]))
      pf_need(all(is.finite(a[ok]))&&all(is.finite(b[ok]))&&all(error<=tol),paste('floating reproduction mismatch',n))
      max_error<-if(any(ok))max(error) else NA_real_
    } else {pf_need(identical(as.character(a),as.character(b)),paste('exact reproduction mismatch',n));max_error<-0}
    out[[n]]<-data.frame(field=n,rows=nrow(x),defined=sum(!is.na(a)),comparison=if(floating)'12_significant_digit_representation_tolerance' else 'EXACT',
      max_absolute_error=max_error,tolerance=if(floating)'5e-12 * max(1, abs(frozen))' else 'zero',result='AGREES',stringsAsFactors=FALSE)
  }
  do.call(rbind,out)
}
pf_slices <- function(x) {
  out<-setNames(lapply(pf_cells(),function(c)which(x$cell_id==c)),paste0('cell:',pf_cells()))
  out[['tour:ATP']]<-which(x$tour=='ATP');out[['tour:WTA']]<-which(x$tour=='WTA');out
}
pf_common <- function(x) complete.cases(x[c(paste0('diff_',pf_modeled_metrics()),'NPR','equal_phase_NPR','same_match_win')])
pf_denominator_mask <- function(x,id) {
  den<-pmin(x[[paste0('a_',id,'_denominator')]],x[[paste0('b_',id,'_denominator')]])
  pos<-den[is.finite(den)&den>0];cut<-if(length(pos))unname(quantile(pos,.25,type=1)) else NA_real_
  keep<-is.finite(den)&is.finite(cut)&den>cut
  list(keep=keep,cut=cut,den=den)
}
pf_model_mask <- function(x,sensitivity) {
  keep<-pf_common(x)
  if(sensitivity=='lower_denominator_quartile')for(id in pf_modeled_metrics())keep<-keep&pf_denominator_mask(x,id)$keep
  pf_need(sensitivity%in%c('full','lower_denominator_quartile'),'unregistered sample rule');keep
}
pf_availability <- function(x) {
  out<-list()
  for(g in names(pf_slices(x))) {
    z<-x[pf_slices(x)[[g]],,drop=FALSE];common<-pf_common(z)
    m12<-!is.finite(z$diff_M12)
    for(id in sprintf('M%02d',1:15))for(side in c('a','b','difference')) {
      dm<-pf_denominator_mask(z,id)
      if(side=='difference') {v<-z[[paste0('diff_',id)]];den<-dm$den;reason<-pf_reason(z[[paste0('a_',id,'_reason')]],z[[paste0('b_',id,'_reason')]])}
      else {v<-z[[paste(side,id,'value',sep='_')]];den<-z[[paste(side,id,'denominator',sep='_')]];reason<-z[[paste(side,id,'reason',sep='_')]]}
      positive<-den[is.finite(den)&den>0]
      qs<-if(length(positive))unname(quantile(positive,c(0,.25,.5,.75,1),type=1)) else rep(NA_real_,5)
      out[[length(out)+1L]]<-data.frame(slice=g,tour=z$tour[1],metric=id,side=side,role=pf_role(id),eligible_matches=nrow(z),
        defined_observations=sum(is.finite(v)),zero_opportunity=sum(reason=='zero_opportunities'),missing_input=sum(reason=='missing_input'),
        invalid_bundle=sum(reason=='invalid_bundle'),common_complete_n=sum(common),m12_undefined_matches=sum(m12),
        denominator_positive_n=length(positive),denominator_min=qs[1],denominator_q25=qs[2],denominator_median=qs[3],
        denominator_q75=qs[4],denominator_max=qs[5],difference_tail_cut=dm$cut,metric_tail_retained=sum(dm$keep&is.finite(v)),
        common_model_tail_n=sum(pf_model_mask(z,'lower_denominator_quartile')),stringsAsFactors=FALSE)
    }
  };do.call(rbind,out)
}
pf_associations <- function(x,dict) {
  out<-list()
  for(g in names(pf_slices(x))) {
    z<-x[pf_slices(x)[[g]],,drop=FALSE];common<-pf_common(z)
    for(id in dict$id)for(sensitivity in c('full','lower_denominator_quartile'))for(sample in c('pairwise','common_complete')) {
      mask<-if(sample=='pairwise')rep(TRUE,nrow(z)) else common
      if(sensitivity=='lower_denominator_quartile')mask<-mask&pf_denominator_mask(z,id)$keep
      for(y in c('NPR','equal_phase_NPR','same_match_win'))for(method in c('pearson','spearman')) {
        co<-pf_cor(z[[paste0('diff_',id)]][mask],z[[y]][mask],method);direction<-pf_direction(co$value)
        d<-dict[dict$id==id,,drop=FALSE]
        out[[length(out)+1L]]<-data.frame(slice=g,tour=z$tour[1],metric=id,outcome=y,method=method,sample=sample,sensitivity=sensitivity,
          eligible_n=nrow(z),pair_count=co$n,common_complete_n=sum(common),analysis_common_n=sum(mask&common),correlation=co$value,
          reason=co$reason,expected_direction=pf_expected(id),observed_direction=direction,
          direction_agreement=if(direction%in%c('positive','negative'))ifelse(direction==pf_expected(id),'AGREES','REVERSED') else 'UNDEFINED',
          role=pf_role(id),coupling=d$coupling,interpretation='EXPLORATORY_SAME_MATCH_ASSOCIATION',
          uncertainty=pf_spec()$uncertainty,stringsAsFactors=FALSE)
      }
    }
  };do.call(rbind,out)
}

# Diagnostics and numerical conventions registered before empirical fitting.
pf_rank <- function(x) {
  d<-svd(x,nu=0,nv=0)$d
  if(!length(d)||max(d)==0)return(0L)
  sum(d>max(dim(x))*.Machine$double.eps*max(d))
}
pf_collinearity <- function(x) {
  x<-as.matrix(x);p<-ncol(x);n<-nrow(x)
  means<-colMeans(x);sds<-apply(x,2,sd)
  constant<-!is.finite(sds)|sds==0
  near<-!constant&sds<=sqrt(.Machine$double.eps)*pmax(1,abs(means))
  z<-matrix(0,n,p,dimnames=dimnames(x));good<-!constant
  if(any(good))z[,good]<-scale(x[,good,drop=FALSE])
  rank<-pf_rank(z);d<-svd(z,nu=0,nv=0)$d
  ci<-rep(Inf,p);if(length(d)&&max(d)>0)ci[seq_along(d)]<-ifelse(d>max(n,p)*.Machine$double.eps*max(d),max(d)/d,Inf)
  vif<-rep(Inf,p)
  if(rank==p&&!any(near))vif<-diag(solve(crossprod(z)/(n-1)))
  pc<-suppressWarnings(cor(x));sc<-suppressWarnings(cor(round(x,12),method='spearman'))
  rr<-c(abs(pc[upper.tri(pc)]),abs(sc[upper.tri(sc)]));maxr<-if(any(is.finite(rr)))max(rr[is.finite(rr)]) else NA_real_
  if(!is.finite(maxr))maxr<-NA_real_
  rclass<-if(!is.finite(maxr))'UNDEFINED' else if(maxr>=.95)'NEAR_REDUNDANT' else if(maxr>=.9)'SENSITIVITY_WARNING' else if(maxr>=.8)'PRACTICAL_REVIEW' else 'BELOW_REVIEW_BOUNDARY'
  vclass<-if(max(vif)>=10)'UNACCEPTABLE' else if(max(vif)>=5)'PRIMARY_CONCERN' else 'BELOW_CONCERN_BOUNDARY'
  cclass<-if(max(ci)>=30)'FAILURE_REVIEW' else 'BELOW_REVIEW_BOUNDARY'
  gate<-if(rank<p||any(constant|near))'AUTOMATIC_FAILURE' else if(rclass=='NEAR_REDUNDANT'||vclass=='UNACCEPTABLE'||cclass=='FAILURE_REVIEW')'FAIL' else if(rclass%in%c('PRACTICAL_REVIEW','SENSITIVITY_WARNING')||vclass=='PRIMARY_CONCERN')'CONCERN' else 'NO_NUMERICAL_GATE_FAILURE'
  list(rank=rank,z=z,mean=means,sd=sds,constant=constant,near=near,vif=vif,ci=ci,pearson=pc,spearman=sc,
    max_correlation=maxr,correlation_class=rclass,vif_class=vclass,condition_class=cclass,gate=gate)
}
pf_ols <- function(design,y) {
  n<-length(y);p<-ncol(design);rank<-pf_rank(design)
  if(rank<p||n<=p||any(!is.finite(design))||any(!is.finite(y)))return(list(ok=FALSE,rank=rank))
  f<-lm.fit(design,y,tol=max(dim(design))*.Machine$double.eps,singular.ok=FALSE)
  sse<-sum(f$residuals^2);sst<-sum((y-mean(y))^2)
  r2<-if(sst>0)1-sse/sst else NA_real_
  h<-rowSums(qr.Q(f$qr)^2);mse<-sse/(n-p)
  student<-if(mse>0)f$residuals/sqrt(mse*pmax(0,1-h)) else rep(NA_real_,n)
  list(ok=TRUE,rank=rank,beta=f$coefficients,r2=r2,adjusted=1-(1-r2)*(n-1)/(n-p),sse=sse,
    residual_max=max(abs(f$residuals)),residual_flag=sum(abs(student)>pf_spec()$residual_flag,na.rm=TRUE),
    leverage_flag=sum(h>pf_spec()$leverage_multiplier*p/n),max_leverage=max(h))
}
pf_increment <- function(full,reduced) {
  delta<-full-reduced
  pf_need(!is.finite(delta)||delta>=-pf_spec()$increment_numeric_zero,'negative nested-model increment beyond numerical tolerance')
  c(semi_partial_r2=delta,partial_r2=if(is.finite(reduced)&&1-reduced>pf_spec()$increment_numeric_zero)delta/(1-reduced) else NA_real_)
}
pf_losses <- function(eta,y) c(log_loss=mean(pmax(eta,0)+log1p(exp(-abs(eta)))-y*eta),brier=mean((plogis(eta)-y)^2))
pf_logistic <- function(design,y) {
  n<-length(y);p<-ncol(design)
  if(pf_rank(design)<p||n<=p||length(unique(y))<2)return(list(ok=FALSE,warning='rank_sample_or_outcome_failure'))
  warnings<-character()
  f<-withCallingHandlers(glm.fit(design,y,family=binomial(),control=glm.control(epsilon=pf_spec()$glm_epsilon,maxit=pf_spec()$glm_maxit)),
    warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
  eta<-f$linear.predictors;pr<-plogis(eta);margin<-(2*y-1)*eta
  witness<-if(all(margin>sqrt(.Machine$double.eps)))'COMPLETE_SEPARATION_WITNESS' else if(all(margin>=-sqrt(.Machine$double.eps))&&any(margin>sqrt(.Machine$double.eps)))'QUASI_SEPARATION_WITNESS' else 'NO_WITNESS_NOT_PROOF_OF_ABSENCE'
  extreme<-sum(pr<=.Machine$double.eps|pr>=1-.Machine$double.eps)
  unstable<-!f$converged||f$boundary||extreme>0||length(warnings)>0||witness!='NO_WITNESS_NOT_PROOF_OF_ABSENCE'
  list(ok=TRUE,beta=f$coefficients,converged=f$converged,boundary=f$boundary,iterations=f$iter,
    witness=witness,extreme=extreme,unstable=unstable,warning=paste(unique(warnings),collapse=';'),loss=pf_losses(eta,y))
}
pf_design <- function(z,ids,event=FALSE) {
  x<-as.matrix(z[paste0('diff_',ids)]);colnames(x)<-ids
  if(event)x<-cbind(x,event_Montreal_2021=as.integer(z$cell_id=='WTA|2021|Canada'))
  d<-pf_collinearity(x);scaled<-d$z
  # The event coefficient is a 0/1 contrast; condition/VIF use its standardized column.
  if(event)scaled[,'event_Montreal_2021']<-x[,'event_Montreal_2021']
  list(diag=d,design=cbind(intercept=1,scaled))
}
pf_diag_rows <- function(key,d,ids,dict) {
  out<-list();terms<-names(d$sd)
  for(j in seq_along(terms))out[[length(out)+1L]]<-cbind(key,data.frame(kind='predictor',term=terms[j],partner='',
    value=d$vif[j],pearson=NA_real_,spearman=NA_real_,constant=d$constant[j],near_constant=d$near[j],
    rank=d$rank,columns=length(terms),max_condition=max(d$ci),classification=if(d$vif[j]>=10)'UNACCEPTABLE' else if(d$vif[j]>=5)'PRIMARY_CONCERN' else 'BELOW_CONCERN_BOUNDARY',
    set_gate=d$gate,shared_source_warning='Same-match point counts and opportunities overlap; distinct mechanisms are not established.'))
  for(j in seq_along(d$ci))out[[length(out)+1L]]<-cbind(key,data.frame(kind='condition_index',term=paste0('dimension_',j),partner='',
    value=d$ci[j],pearson=NA_real_,spearman=NA_real_,constant=FALSE,near_constant=FALSE,rank=d$rank,columns=length(terms),max_condition=max(d$ci),
    classification=if(d$ci[j]>=30)'FAILURE_REVIEW' else 'BELOW_REVIEW_BOUNDARY',set_gate=d$gate,shared_source_warning='Centered unit-SD predictors; intercept excluded.'))
  pairs<-combn(seq_along(terms),2)
  for(j in seq_len(ncol(pairs))) {
    a<-pairs[1,j];b<-pairs[2,j];r<-max(abs(c(d$pearson[a,b],d$spearman[a,b])),na.rm=TRUE)
    warning<-if(all(terms[c(a,b)]%in%dict$id))paste(dict$source_fields[match(terms[c(a,b)],dict$id)],collapse=' / ') else 'Event-season control is confounded.'
    out[[length(out)+1L]]<-cbind(key,data.frame(kind='pair',term=terms[a],partner=terms[b],value=NA_real_,
      pearson=d$pearson[a,b],spearman=d$spearman[a,b],constant=FALSE,near_constant=FALSE,rank=d$rank,columns=length(terms),max_condition=max(d$ci),
      classification=if(!is.finite(r))'UNDEFINED' else if(r>=.95)'NEAR_REDUNDANT' else if(r>=.9)'SENSITIVITY_WARNING' else if(r>=.8)'PRACTICAL_REVIEW' else 'BELOW_REVIEW_BOUNDARY',
      set_gate=d$gate,shared_source_warning=warning))
  };do.call(rbind,out)
}
pf_models <- function(x,dict) {
  pf_need(isTRUE(pf_trace$reproduction),'metric reproduction must precede extensions')
  reg<-pf_registry();lapply(seq_len(nrow(reg)),function(i)pf_registered(reg[i,,drop=FALSE]))
  collin<-npr<-inc<-win<-list()
  for(g in names(pf_slices(x)))for(sens in c('full','lower_denominator_quartile')) {
    z<-x[pf_slices(x)[[g]],,drop=FALSE];z<-z[pf_model_mask(z,sens),,drop=FALSE]
    pf_need(length(unique(z$tour))==1,'pooled tour fit forbidden');fp<-pf_fingerprint(z$match_id)
    for(i in seq_len(nrow(reg)))for(event in if(g=='tour:WTA')c(FALSE,TRUE) else FALSE) {
      set<-reg[i,,drop=FALSE];pf_registered(set);ids<-pf_terms(set)
      pf_trace$fits<-c(pf_trace$fits,set$set_id)
      key<-data.frame(slice=g,tour=z$tour[1],sensitivity=sens,set_id=set$set_id,role=set$role,
        adjustment=if(event)'CONFOUNDED_EVENT_SEASON' else 'none',n=nrow(z),row_fingerprint=fp,stringsAsFactors=FALSE)
      d<-pf_design(z,ids,event);collin[[length(collin)+1L]]<-pf_diag_rows(key,d$diag,ids,dict)
      f<-pf_ols(d$design,z$NPR)
      for(term in colnames(d$design))npr[[length(npr)+1L]]<-cbind(key,data.frame(term=term,
        coefficient=if(f$ok)unname(f$beta[term]) else NA_real_,direction=if(f$ok)pf_direction(f$beta[term]) else 'undefined',
        expected_direction=if(term%in%ids)pf_expected(term) else 'not_specified',
        r_squared=if(f$ok)f$r2 else NA_real_,adjusted_r_squared=if(f$ok)f$adjusted else NA_real_,rank=f$rank,
        max_condition=max(d$diag$ci),max_vif=max(d$diag$vif),collinearity_gate=d$diag$gate,
        fit_status=if(f$ok)'FITTED_EXPLORATORY' else 'NOT_FITTED_RANK_OR_SAMPLE_FAILURE',
        residual_max=if(f$ok)f$residual_max else NA_real_,large_residual_count=if(f$ok)f$residual_flag else NA_integer_,
        high_leverage_count=if(f$ok)f$leverage_flag else NA_integer_,max_leverage=if(f$ok)f$max_leverage else NA_real_,
        uncertainty=pf_spec()$uncertainty))
      for(id in ids) {
        reduced<-d$design[,colnames(d$design)!=id,drop=FALSE];r<-pf_ols(reduced,z$NPR)
        v<-if(f$ok&&r$ok)pf_increment(f$r2,r$r2) else c(semi_partial_r2=NA,partial_r2=NA)
        inc[[length(inc)+1L]]<-cbind(key,data.frame(removed_metric=id,full_r_squared=if(f$ok)f$r2 else NA_real_,reduced_r_squared=if(r$ok)r$r2 else NA_real_,
          semi_partial_r_squared=unname(v[1]),partial_r_squared=unname(v[2]),numerically_nonzero=is.finite(v[1])&&v[1]>pf_spec()$increment_numeric_zero,
          reduced_row_fingerprint=fp,control_retained=event,practical_magnitude=pf_spec()$practical_effect_margin,uncertainty=pf_spec()$uncertainty))
      }
      # No event adjustment is authorized for the descriptive win model.
      if(!event) {
        fwin<-pf_logistic(d$design,z$same_match_win)
        for(removed in c('none',ids)) {
          rwin<-if(removed=='none')fwin else pf_logistic(d$design[,colnames(d$design)!=removed,drop=FALSE],z$same_match_win)
          terms<-if(removed=='none')colnames(d$design) else removed
          for(term in terms)win[[length(win)+1L]]<-cbind(key,data.frame(removed_metric=removed,term=term,
            coefficient=if(removed=='none'&&rwin$ok)unname(rwin$beta[term]) else NA_real_,
            direction=if(removed=='none'&&rwin$ok)pf_direction(rwin$beta[term]) else 'not_applicable',
            converged=rwin$ok&&rwin$converged,boundary=if(rwin$ok)rwin$boundary else NA,
            iterations=if(rwin$ok)rwin$iterations else NA_integer_,
            separation=if(rwin$ok)rwin$witness else 'NOT_ASSESSABLE',unstable=!rwin$ok||rwin$unstable,
            extreme_probability_count=if(rwin$ok)rwin$extreme else NA_integer_,warning=rwin$warning,
            apparent_log_loss=if(rwin$ok)unname(rwin$loss[1]) else NA_real_,apparent_brier=if(rwin$ok)unname(rwin$loss[2]) else NA_real_,
            reduced_minus_full_log_loss=if(rwin$ok&&fwin$ok)unname(rwin$loss[1]-fwin$loss[1]) else NA_real_,
            reduced_minus_full_brier=if(rwin$ok&&fwin$ok)unname(rwin$loss[2]-fwin$loss[2]) else NA_real_,
            reduced_row_fingerprint=fp,interpretation='SAME_MATCH_DESCRIPTIVE_FIT',uncertainty=pf_spec()$uncertainty))
        }
      }
    }
  }
  list(collinearity=do.call(rbind,collin),npr=do.call(rbind,npr),increments=do.call(rbind,inc),win=do.call(rbind,win))
}

pf_stability <- function(models,associations) {
  out<-list()
  comparisons<-list(c('cell:ATP|2023|Indian Wells','cell:WTA|2023|Indian Wells','cross_tour_same_event_season'),
    c('cell:WTA|2023|Indian Wells','cell:WTA|2021|Canada','CONFOUNDED_EVENT_SEASON'),c('tour:ATP','tour:WTA','cross_tour_convenience_samples'))
  n<-models$npr;n<-n[n$term%in%pf_modeled_metrics(),,drop=FALSE]
  w<-models$win;w<-w[w$removed_metric=='none'&w$term%in%pf_modeled_metrics(),,drop=FALSE]
  compare<-function(a,b,kind,context,value,gate=FALSE) {
    keys<-intersect(c('set_id','term','metric','outcome','method','sample','sensitivity','adjustment'),names(a))
    if(context=='denominator_sensitivity')keys<-setdiff(keys,'sensitivity')
    if(context=='pairwise_vs_common_complete')keys<-setdiff(keys,'sample')
    if(context=='CONFOUNDED_EVENT_ADJUSTMENT')keys<-setdiff(keys,'adjustment')
    k<-function(z)do.call(paste,c(z[keys],sep='|'))
    j<-match(k(a),k(b));pf_need(!anyNA(j)&&!anyDuplicated(k(b)),'stability comparison mapping');b<-b[j,,drop=FALSE]
    for(i in seq_len(nrow(a))) {
      av<-a[[value]][i];bv<-b[[value]][i]
      out[[length(out)+1L]]<<-data.frame(kind=kind,context=context,slice_a=a$slice[i],slice_b=b$slice[i],
        set_id=if('set_id'%in%names(a))a$set_id[i] else '',metric=if('term'%in%names(a))a$term[i] else a$metric[i],
        outcome=if('outcome'%in%names(a))a$outcome[i] else if(kind=='npr_coefficient')'NPR' else 'same_match_win',
        method=if('method'%in%names(a))a$method[i] else 'conditional_coefficient',
        sample_a=if('sample'%in%names(a))a$sample[i] else a$sensitivity[i],sample_b=if('sample'%in%names(b))b$sample[i] else b$sensitivity[i],
        value_a=av,value_b=bv,change=bv-av,sign_reversal=is.finite(av)&&is.finite(bv)&&pf_direction(av)%in%c('positive','negative')&&pf_direction(bv)%in%c('positive','negative')&&sign(av)!=sign(bv),
        collinearity_a=if(gate)a$collinearity_gate[i] else 'not_applicable',collinearity_b=if(gate)b$collinearity_gate[i] else 'not_applicable',
        changed_collinearity=gate&&a$collinearity_gate[i]!=b$collinearity_gate[i],
        magnitude_interpretation='PENDING_SPECIFICATION',uncertainty=pf_spec()$uncertainty,stringsAsFactors=FALSE)
    }
  }
  for(pair in comparisons) {
    compare(n[n$slice==pair[1]&n$sensitivity=='full'&n$adjustment=='none',],n[n$slice==pair[2]&n$sensitivity=='full'&n$adjustment=='none',],'npr_coefficient',pair[3],'coefficient',TRUE)
    compare(w[w$slice==pair[1]&w$sensitivity=='full',],w[w$slice==pair[2]&w$sensitivity=='full',],'win_coefficient',pair[3],'coefficient')
    compare(associations[associations$slice==pair[1]&associations$sensitivity=='full',],associations[associations$slice==pair[2]&associations$sensitivity=='full',],'association',pair[3],'correlation')
  }
  for(g in unique(n$slice)) {
    compare(n[n$slice==g&n$sensitivity=='full'&n$adjustment=='none',],n[n$slice==g&n$sensitivity!='full'&n$adjustment=='none',],'npr_coefficient','denominator_sensitivity','coefficient',TRUE)
    compare(w[w$slice==g&w$sensitivity=='full',],w[w$slice==g&w$sensitivity!='full',],'win_coefficient','denominator_sensitivity','coefficient')
    compare(associations[associations$slice==g&associations$sample=='pairwise',],associations[associations$slice==g&associations$sample=='common_complete',],'association','pairwise_vs_common_complete','correlation')
    compare(associations[associations$slice==g&associations$sensitivity=='full',],associations[associations$slice==g&associations$sensitivity!='full',],'association','denominator_sensitivity','correlation')
  }
  compare(n[n$slice=='tour:WTA'&n$adjustment=='none',],n[n$slice=='tour:WTA'&n$adjustment!='none',],'npr_coefficient','CONFOUNDED_EVENT_ADJUSTMENT','coefficient',TRUE)
  # Numeric loss of unique contribution is distinct from an unapproved practical margin.
  inc<-models$increments;inc$term<-inc$removed_metric;inc$coefficient<-inc$semi_partial_r_squared
  for(g in unique(inc$slice))compare(inc[inc$slice==g&inc$sensitivity=='full'&inc$adjustment=='none',],inc[inc$slice==g&inc$sensitivity!='full'&inc$adjustment=='none',],'npr_increment','denominator_sensitivity','coefficient')
  for(pair in comparisons)compare(inc[inc$slice==pair[1]&inc$sensitivity=='full'&inc$adjustment=='none',],inc[inc$slice==pair[2]&inc$sensitivity=='full'&inc$adjustment=='none',],'npr_increment',pair[3],'coefficient')
  compare(inc[inc$slice=='tour:WTA'&inc$adjustment=='none',],inc[inc$slice=='tour:WTA'&inc$adjustment!='none',],'npr_increment','CONFOUNDED_EVENT_ADJUSTMENT','coefficient')
  wi<-models$win;wi<-wi[wi$removed_metric!='none',];wi$coefficient<-wi$reduced_minus_full_log_loss
  for(pair in comparisons)compare(wi[wi$slice==pair[1]&wi$sensitivity=='full',],wi[wi$slice==pair[2]&wi$sensitivity=='full',],'win_log_loss_increment',pair[3],'coefficient')
  for(g in unique(wi$slice))compare(wi[wi$slice==g&wi$sensitivity=='full',],wi[wi$slice==g&wi$sensitivity!='full',],'win_log_loss_increment','denominator_sensitivity','coefficient')
  result<-do.call(rbind,out)
  result$outcome[result$kind=='npr_increment']<-'NPR'
  result$numeric_increment_lost<-result$kind=='npr_increment'&is.finite(result$value_a)&is.finite(result$value_b)&result$value_a>pf_spec()$increment_numeric_zero&result$value_b<=pf_spec()$increment_numeric_zero
  result
}
pf_terminal <- function(models) {
  n<-models$npr;i<-models$increments;reg<-pf_registry();survive<-support<-logical(nrow(reg))
  for(k in seq_len(nrow(reg))) {
    a<-n[n$set_id==reg$set_id[k]&n$slice%in%c('tour:ATP','tour:WTA')&n$sensitivity=='full'&n$adjustment=='none'&n$term%in%pf_terms(reg[k,]),]
    b<-i[i$set_id==reg$set_id[k]&i$slice%in%c('tour:ATP','tour:WTA')&i$sensitivity=='full'&i$adjustment=='none',]
    survive[k]<-nrow(a)==8&&all(a$fit_status=='FITTED_EXPLORATORY')&&!any(a$collinearity_gate%in%c('FAIL','AUTOMATIC_FAILURE'))
    support[k]<-survive[k]&&all(a$direction==a$expected_direction)&&nrow(b)==8&&all(b$numerically_nonzero)
  }
  # A numerical zero in every primary alternative in both tours warrants family review.
  b<-i[i$slice%in%c('tour:ATP','tour:WTA')&i$sensitivity=='full'&i$adjustment=='none'&grepl('^S',i$set_id),]
  repeated<-vapply(3:6,function(col) {
    rows<-vapply(seq_len(nrow(b)),function(j)b$removed_metric[j]==reg[match(b$set_id[j],reg$set_id),col],TRUE)
    any(rows)&&all(is.finite(b$semi_partial_r_squared[rows]))&&all(!b$numerically_nonzero[rows])
  },TRUE)
  decision<-if(any(support[1:9]))'PILOT_DIAGNOSTICS_SUPPORT_CANDIDATE_REFINEMENT' else if(!any(survive)||any(repeated))'PILOT_DIAGNOSTICS_REQUIRE_FAMILY_REVISION' else 'PILOT_DIAGNOSTICS_INCONCLUSIVE'
  list(decision=decision,support=reg$set_id[support&reg$role=='PRIMARY_ALTERNATIVE'],survive=reg$set_id[survive],repeated=names(reg)[3:6][repeated])
}
pf_next <- function(decision) {
  action<-switch(decision,PILOT_DIAGNOSTICS_SUPPORT_CANDIDATE_REFINEMENT='candidate-refinement protocol',
    PILOT_DIAGNOSTICS_REQUIRE_FAMILY_REVISION='family-revision proposal',PILOT_DIAGNOSTICS_INCONCLUSIVE='review of unresolved pilot diagnostics')
  paste('Approve one offline documentation-only',action,'using this frozen Phase 2F release to address sign instability, same-match coupling, conversion/recovery interpretation, practical-effect margins and missing uncertainty evidence; select no final factors, change no formulas, fit no new models, acquire no data, admit no new cells, build no histories or forecasts, and keep Package B stopped, OTD paused and publication blocked.')
}
pf_scorecard <- function(models,associations,stability) {
  criteria<-c('Measurement validity','Interpretation and algebraic role','Nonredundancy','Collinearity','NPR association','Same-match win association',
    'Incremental NPR contribution','Same-match conditional win contribution','ATP/WTA consistency','Event sensitivity','Denominator sensitivity','Missing evidence required for final qualification')
  out<-list();reg<-pf_registry()
  for(tour in c('ATP','WTA'))for(id in sprintf('M%02d',1:15)) {
    sets<-reg$set_id[vapply(seq_len(nrow(reg)),function(k)id%in%pf_terms(reg[k,]),TRUE)]
    if(!length(sets))sets<-''
    for(set in sets)for(k in seq_along(criteria)) {
      cont<-if(id%in%c('M08','M15'))'BENCHMARK_ONLY' else if(id=='M07')'CONTINUE_AS_SENSITIVITY' else 'CONTINUE_AS_PRIMARY_ALTERNATIVE'
      status<-cont;reason<-'Defined counts and unchanged formula; continuation is exploratory only.'
      a<-associations[associations$slice==paste0('tour:',tour)&associations$metric==id&associations$sensitivity=='full'&associations$sample=='common_complete',]
      n<-models$npr[models$npr$slice==paste0('tour:',tour)&models$npr$set_id==set&models$npr$term==id&models$npr$sensitivity=='full'&models$npr$adjustment=='none',]
      i<-models$increments[models$increments$slice==paste0('tour:',tour)&models$increments$set_id==set&models$increments$removed_metric==id&models$increments$sensitivity=='full'&models$increments$adjustment=='none',]
      w<-models$win[models$win$slice==paste0('tour:',tour)&models$win$set_id==set&models$win$sensitivity=='full'&models$win$removed_metric=='none'&models$win$term==id,]
      if(k==1&&id%in%c('M12','M13')){status<-'CONCERN';reason<-'Zero opportunities remain structurally undefined; common-complete selection changes population.'}
      if(k==2){status<-if(id%in%c('M08','M15'))'BENCHMARK_ONLY' else 'CONCERN';reason<-'Shared same-match counts; conditional outcomes are not independent mechanisms. M02 positive direction is a hypothesis; conversion is not adjusted clutch skill.'}
      if(k==3){status<-if(id%in%c('M09','M10','M13','M14'))'FAIL' else cont;reason<-'Exact difference classes: 03/09, 04/10, 08/15, 11/-14, 12/13; no coexistence permitted.'}
      if(k==4){status<-if(!nrow(n))'NOT_ASSESSABLE' else if(n$collinearity_gate%in%c('FAIL','AUTOMATIC_FAILURE'))'FAIL' else if(n$collinearity_gate=='CONCERN')'CONCERN' else cont;reason<-'Registered set diagnostic; no threshold relaxed.'}
      if(k%in%c(5,6)){aa<-a[a$outcome==if(k==5)'NPR' else 'same_match_win',];status<-if(any(aa$direction_agreement=='REVERSED'))'CONCERN' else cont;reason<-'Univariate signs, not independent support or future performance.'}
      if(k==7){status<-if(!nrow(i))'NOT_ASSESSABLE' else if(!i$numerically_nonzero)'CONCERN' else 'PENDING_SPECIFICATION';reason<-'Unique R-squared increment is exploratory; practical-effect margin and uncertainty are unavailable.'}
      if(k==8){status<-if(!nrow(w))'NOT_ASSESSABLE' else if(w$unstable||w$direction!=pf_expected(id))'CONCERN' else 'PENDING_SPECIFICATION';reason<-'Apparent same-match conditional fit; separation check is not a complete separation proof; practical margin pending.'}
      if(k%in%c(9,10,11)) {
        context<-if(k==9)'cross_tour_convenience_samples' else if(k==10)'CONFOUNDED_EVENT_SEASON' else 'denominator_sensitivity'
        ss<-stability[stability$context==context&stability$metric==id&stability$set_id==set,]
        if(k==11)ss<-ss[ss$slice_a==paste0('tour:',tour)|startsWith(ss$slice_a,paste0('cell:',tour,'|')),,drop=FALSE]
        status<-if(k==10&&tour=='ATP')'NOT_ASSESSABLE' else if(any(ss$sign_reversal|ss$numeric_increment_lost))'UNSTABLE' else 'INCONCLUSIVE'
        reason<-if(k==10)'Only WTA has two cells; event and season are confounded.' else 'Small convenience samples; changes are descriptive and practical size has no approved threshold.'
      }
      if(k==12){status<-'NOT_ASSESSABLE';reason<-'Surface and independent season stability, opponent adjustment, event/player-aware uncertainty and future utility unavailable.'}
      out[[length(out)+1L]]<-data.frame(tour=tour,set_id=set,metric=id,precedence=k,criterion=criteria[k],status=status,reason=reason,stringsAsFactors=FALSE)
    }
  };do.call(rbind,out)
}
pf_build <- function() {
  before<-pf_preserve();pf_trace$reproduction<-FALSE
  provenance<-pf_verify();dict<-pf_dictionary();r<-pf_reproduce();x<-r$metrics
  availability<-pf_availability(x);association<-pf_associations(x,dict);models<-pf_models(x,dict)
  stability<-pf_stability(models,association);terminal<-pf_terminal(models)
  decisions<-data.frame(id=c('TERMINAL_DECISION','PRIMARY_SETS_MEETING_REFINEMENT_RULE','SETS_WITHOUT_FATAL_NUMERICAL_GATE','REPEATED_NUMERIC_ZERO_FAMILIES',
    'PACKAGE_B','OTD','Q6','Q8','Q9','Q10','PUBLICATION','FINAL_FACTORS','UNCERTAINTY','PRACTICAL_EFFECT_MARGIN','NEXT_APPROVAL'),
    value=c(terminal$decision,paste(terminal$support,collapse=';'),paste(terminal$survive,collapse=';'),paste(terminal$repeated,collapse=';'),
      'STOPPED','PAUSED_BY_USER_AFTER_PHASE_1S',rep('PENDING_USER_APPROVAL',4),'BLOCKED_PENDING_RIGHTS_REVIEW','NOT_SELECTED',pf_spec()$uncertainty,'PENDING_SPECIFICATION',pf_next(terminal$decision)))
  summary<-data.frame(item=c('release','baseline','valid_matches','ATP_IW_2023','WTA_IW_2023','WTA_Montreal_2021','separate_recovery','reproduced_fields','terminal_decision','R_version',
    'scope','surface_stability','independent_season_stability','uncertainty','probability_interpretation','reproduction_tolerance','increment_numeric_zero'),
    value=c('1.0.0',pf_baseline,nrow(x),sum(x$cell_id==pf_cells()[1]),sum(x$cell_id==pf_cells()[2]),sum(x$cell_id==pf_cells()[3]),sum(x$count_origin=='approved_recovery_overlay'),nrow(r$comparison),terminal$decision,as.character(getRversion()),
      'three_hard_court_convenience_pilots_only','NOT_ASSESSABLE','NOT_ASSESSABLE',pf_spec()$uncertainty,'same-match descriptive fit only','5e-12 * max(1, abs(frozen))','1e-10'))
  result<-setNames(list(provenance,x,r$comparison,pf_registry(),availability,association,models$collinearity,models$npr,models$increments,models$win,stability,
    pf_scorecard(models,association,stability),decisions,summary),pf_names)
  pf_need(identical(before,pf_preserve())&&identical(provenance,pf_verify()),'inputs changed during analysis')
  pf_contract(result);result
}
pf_contract <- function(r) {
  pf_need(identical(names(r),pf_names)&&all(vapply(r,is.data.frame,TRUE)),'complete output schema')
  x<-r$`match-metrics`;pf_need(nrow(x)==231&&!anyDuplicated(x$match_id)&&all(x$valid_bundle)&&all(x$status=='normally_completed')&&!any(x$quarantined),'analysis population contract')
  pf_need(!any(grepl('name',names(x),ignore.case=TRUE)),'player names in local metrics')
  pf_need(all(r$`reproduction-comparison`$result=='AGREES')&&identical(r$`candidate-set-registry`,pf_registry()),'reproduction or registration contract')
  for(t in c('npr-model-summary','npr-incremental-contributions','same-match-win-summary')) {
    z<-r[[t]];pf_need(all(z$set_id%in%pf_registry()$set_id)&&all(z$tour%in%c('ATP','WTA')),'set or tour contract')
    if('reduced_row_fingerprint'%in%names(z))pf_need(identical(z$row_fingerprint,z$reduced_row_fingerprint),'nested comparison row contract')
  }
  allowed<-c('CONCERN','FAIL','UNSTABLE','INCONCLUSIVE','NOT_ASSESSABLE','PENDING_SPECIFICATION','CONTINUE_AS_PRIMARY_ALTERNATIVE','CONTINUE_AS_SENSITIVITY','BENCHMARK_ONLY')
  pf_need(all(r$`candidate-scorecard`$status%in%allowed),'scorecard status contract')
  expected<-pf_terminal(list(npr=r$`npr-model-summary`,increments=r$`npr-incremental-contributions`))$decision
  pf_need(identical(r$decisions$value[r$decisions$id=='TERMINAL_DECISION'],expected),'terminal decision contract');TRUE
}
pf_render <- function(result) lapply(result,function(x) {
  # Preserve existing 12-significant-digit CSV convention; internal calculations stay double precision.
  for(n in names(x))if(is.numeric(x[[n]]))x[[n]]<-signif(x[[n]],12)
  z<-character();con<-textConnection('z','w',local=TRUE);write.csv(x,con,row.names=FALSE,na='NA');close(con)
  charToRaw(paste0(paste(z,collapse='\n'),'\n'))
})
pf_publish <- function(result,current=pf_build()) {
  pf_need(identical(result,current),'release differs from current complete reconstruction');pf_contract(result)
  before<-pf_preserve();pf_verify();bytes<-pf_render(result);paths<-file.path(pf_dir,paste0(pf_names,'.csv'))
  tracked<-system2('git',c('ls-files','--','data/raw','data/pilot'),stdout=TRUE)
  ignored<-system2('git',c('check-ignore','--',vapply(paths,shQuote,'')),stdout=TRUE)
  pf_need(is.null(attr(tracked,'status'))&&!length(tracked)&&identical(ignored,paths),'ignored untracked output boundary')
  if(dir.exists(pf_dir)) {
    pf_need(setequal(list.files(pf_dir,all.files=TRUE,no..=TRUE),basename(paths)),'partial or foreign existing release')
    for(i in seq_along(paths))pf_need(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),bytes[[i]]),'existing release differs; preserve for review')
    return(invisible(paths))
  }
  stage<-tempfile('.phase2f-stage-',tmpdir=dirname(pf_dir));pf_need(dir.create(stage),'cannot stage complete release')
  on.exit(unlink(stage,recursive=TRUE),add=TRUE) # Only this invocation's new staging directory.
  for(i in seq_along(paths)) {
    p<-file.path(stage,basename(paths[i]));writeBin(bytes[[i]],p)
    pf_need(identical(readBin(p,'raw',n=file.info(p)$size),bytes[[i]]),'staged bytes differ')
  }
  pf_verify();pf_need(identical(before,pf_preserve()),'historical file changed during release')
  pf_need(!dir.exists(pf_dir)&&file.rename(stage,pf_dir),'atomic directory installation failed');invisible(paths)
}

pf_pins <- function()
c(.gitignore = "90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217",
AGENTS.md = "67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`data/pilot/anomaly/anomaly-coverage.csv` = "72e1a325e434645b9d440be30f759a84e99360857cc55832b434dca16ccd8e39",
`data/pilot/anomaly/anomaly-disposition.csv` = "3f5d084b1116954de31f2b1e3f4ba4c6880236a791cc2e4c5449d6e060a9c8eb",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
`data/pilot/anomaly/anomaly-validation-checks.csv` = "9593116997633f55c2fbd14e9d076aadd657c46cc773d481c5145575e4f3b583",
`data/pilot/atp_indian_wells_2023.csv` = "31b43453ed46a709fd51bd50b372ec2c605258d5a9814db13c963377def2ac6a",
`data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv` = "c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
`data/pilot/development-2021/montreal-inventory/html-draw.csv` = "611de6706379a6272f75fdbfd1a6a6a59f780cb22f195f7e63b892ee91b24302",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/development-2021/montreal-reference-feasibility/coverage-scenarios.csv` = "180f6ba53e30677c3702ed3cd11274b4348075caa8411c97d83af071812516b4",
`data/pilot/development-2021/montreal-reference-feasibility/feasibility-dispositions.csv` = "0c879ab4d6fea166c8ee29784d6f73cccc9688c950457d99170ab809eb9f178c",
`data/pilot/development-2021/montreal-reference-feasibility/field-comparisons.csv` = "d687758bf17c808f85cf7d6e613a80d0629f9a9dacfdca0d618c561132d0ad5b",
`data/pilot/development-2021/montreal-reference-feasibility/official-stat-observations.csv` = "f498a9da20d037771622276332472c3d53bac1e6060141576a8e78b89391f008",
`data/pilot/development-2021/montreal-reference-feasibility/pdf-target-evidence.csv` = "7631d244260c8464e54b31c1a5cc74b7689652eb9154918d8826b4ed27a5ba54",
`data/pilot/development-2021/montreal-reference-feasibility/reference-checks.csv` = "e4999f73eb8768118a7f66ec929c145404447834723579c79c430b3658a43140",
`data/pilot/development-2021/montreal-reference-feasibility/reference-match-inventory.csv` = "77bd218219f554b056296d642d243eb4d796cb6f65681122959ffa806cce4ffe",
`data/pilot/development-2021/montreal-reference-feasibility/status-evidence.csv` = "3b9e6478ac9e1496d5ccdd67d0f15bbe8560cb3bbbfa8a0637fb78eb06c58023",
`data/pilot/development-2021/montreal-reference-feasibility/structural-checks.csv` = "f1d7ab46958d1e5448e7a5ee0249bbadd22518cf563a3bd9844b5aa9a0bfc133",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
`data/pilot/inventory/atp-pdf-observations.csv` = "260b281c7992e79b47dafc21a236c24fe5fa33e5b38b2cdd581c630b2a0e91cd",
`data/pilot/inventory/conflicts.csv` = "1a5234946b836f4f2c1b6ca26f1222b3a5ae4fd7d880c2db475ff597696f61f6",
`data/pilot/inventory/identity-review.csv` = "57b29e77bd6a31e525eb6b2289275313ab45999732774cf8c1cc9e3bb1fbb3d9",
`data/pilot/inventory/inventory-summary.csv` = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
`data/pilot/inventory/match-reconciliation.csv` = "e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
`data/pilot/inventory/normalization-decisions.csv` = "e8e63e2947ff0f36781013d0f06308c1e4b64206f6f2764932bb7f5532360225",
`data/pilot/inventory/official-matches.csv` = "3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
`data/pilot/inventory/official-only.csv` = "3d170c1cc2c66e7a957cf8b32f743d2631463c0b3a2d90888bf917c8ad32e544",
`data/pilot/inventory/reference-comparison.csv` = "e8fa870adcf0818c32b6f2df13a724f90a000c1bf3d3e12340c4041198b70e4e",
`data/pilot/inventory/reference-conflicts.csv` = "8a7df76185b3f591c2fc2067941b6a2a0e8108b9ebe6fc5f41c3d8ceeb4d0f7a",
`data/pilot/inventory/round-summary.csv` = "f4d34ec90b25ee96473ebedcd43e0589ca2b92dfb6d6c6386923d90d020f9466",
`data/pilot/inventory/source-matches.csv` = "c5beb37d7453558cec3501ed1f28db27c3c634d953d99cb3e5c4763a7595145f",
`data/pilot/inventory/source-only.csv` = "a0297e28dbfdea9291ec165c821b17fe9fdbb512360550412010addfeee6777d",
`data/pilot/inventory/status-summary.csv` = "64c7b7975bd58f03a74cc343528890bcd7c1372750f1ba0c1d4401ccd851b352",
`data/pilot/package-b-evidence-route-proposal/cell-evidence-gaps.csv` = "830dbd35fd603c7da5a1012c4f7e73220e21402b9dda9985e3eda843affeb2a2",
`data/pilot/package-b-evidence-route-proposal/decisions.csv` = "70828d4b104f11cf1b3e02455e9c25f8b74ea32e14a5e202f2193a0111c977d7",
`data/pilot/package-b-evidence-route-proposal/input-provenance.csv` = "6a7b33b7d5e52645850b982ae5abb3e96d2cfb925131c5c8367906e26ae52efd",
`data/pilot/package-b-evidence-route-proposal/route-assessment.csv` = "b91b3cec9602d2307653fb0e1c8f6b3ee68d4a31badc29f112da92212139470c",
`data/pilot/package-b-evidence-route-proposal/staged-execution-plan.csv` = "ff908155b5ac119f5cdc5319ae5f104811788bc2cf1f302ce7bd923f0d71f61a",
`data/pilot/package-b-evidence-route-proposal/summary.csv` = "358fdbb1d60c6c168e1ac93afb19763d94f703af02efa9859fd70db6a063118d",
`data/pilot/wta_indian_wells_2023.csv` = "03afd50a16de2d955f8e45760bc2e9667362288f2c791ccacb5c1047908b149f",
`data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html` = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
`data/raw/reference/indian-wells-2023-anomaly/wta-draws.html` = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
`data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html` = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
`data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf` = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
`data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt` = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
`data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt` = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
`data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf` = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
`data/raw/reference/montreal-2021-feasibility/draw_html.html` = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
`data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf` = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
`data/raw/reference/montreal-2021-feasibility/LS001.html` = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
`data/raw/reference/montreal-2021-feasibility/LS002.html` = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
`data/raw/reference/montreal-2021-feasibility/LS003.html` = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
`data/raw/reference/montreal-2021-feasibility/LS004.html` = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
`data/raw/reference/montreal-2021-feasibility/LS005.html` = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
`data/raw/reference/montreal-2021-feasibility/LS006.html` = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
`data/raw/reference/montreal-2021-feasibility/LS007.html` = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
`data/raw/reference/montreal-2021-feasibility/LS042.html` = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
`data/raw/reference/montreal-2021-feasibility/LS049.html` = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
`data/raw/reference/montreal-2021-feasibility/overview.html` = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv` = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv` = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json` = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv` = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/data-source-contract.md` = "d5f8547d7252895137bc4c2d5ec394d32da898f03a2477951f65ae4b2bcedd44",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/indian-wells-inventory-reconciliation.md` = "8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e",
`docs/package-b-evidence-route-proposal.md` = "0cd8cc94043b37764456b46ed0a56cc941006ae88ae136dbd0f310ef12e3d3e8",
`docs/post-otd-analytical-path.md` = "14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
`docs/wta-2021-montreal-chronology-stage-a.md` = "842f603c0a1075ca58395f89a805b981a6f07fdda3f043de95ee169d0c62db12",
`docs/wta-2021-montreal-completed-match-coverage.md` = "168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8",
`docs/wta-2021-montreal-inventory-reconciliation.md` = "6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4",
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
PROJECT_CONTEXT.md = "865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1",
`R/audit_2021_annual_data.R` = "4e376a0e1e2ee822515d2d227f457bed095cc4dca61a6285a29ec07311a423bd",
`R/audit_montreal_completed_match_coverage.R` = "f5e1b57c38a72cf13a7e2a3ce988ce1067b4ac2d53e389423aa8efe40cf84749",
`R/audit_montreal_reference_feasibility.R` = "d0935e2e0d1a72bd32252883f2d601dcc09cddbc906ca149b26512a36648d9f1",
`R/audit_pilot_data.R` = "82bed285763b478614c4c296f92eeb554a6ef104134080e054c7c7b720f6e608",
`R/audit_wta_anomaly.R` = "90b0c3d40fbe4a69e30de51b6a089ace535c26e62d32aeec6e1a9aa9429687a4",
`R/download_2021_annual_data.R` = "43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068",
`R/download_anomaly_references.R` = "596943db417128ff17498353864d8336b788b87add8e1fb2fcde24070d751c2d",
`R/download_inventory_references.R` = "077e4fe176a977f1d64f75b5f86d1e468e26baa5f7e27485adfee0655adc084b",
`R/download_montreal_references.R` = "a48984a9a9b87275ed561109e20d3e0331ce5aef6fc440044d53417291ff2287",
`R/download_pilot_data.R` = "5facb085d14f1c5007c97cd7008d77173cc9e7b74a96eca1c7bc49696ccb4299",
`R/implement_montreal_recovery.R` = "224d0dbcab70b184f0fc8ac67b924b2e15f77cbe698664a7594d4d11606c8e6d",
`R/reconcile_indian_wells_inventory.R` = "84ae65145e3505e578a7287af2bf25d08f8e8f25d2bc35be7fb0b10ecd9fdb93",
`R/reconcile_montreal_inventory.R` = "52dd718b67a95aa01bc015daa66f8a5a739cc6ccd121c5229046ce68b3053e24",
`R/review_wta_2021_montreal.R` = "5b180b4a30521ed126fc75363065c5b376fac6dc7994bb73823dcac4064b07ef",
`data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv` = "08fab6a064cde564a6dc949e41c2ee46fcf7a69a327322fffed62168196d945d",
`data/pilot/current-context-pilot-revalidation/input-provenance.csv` = "3d139dd958178cbfcacd6b72d9a557d49e2275a4772466cc34be03034dc11863",
`data/pilot/current-context-pilot-revalidation/pilot-comparison.csv` = "b815e76854148a3880d9d4d1233a9f053568f3dc893bdd59a264650b6789d174",
`data/pilot/current-context-pilot-revalidation/exclusion-comparison.csv` = "1379430c6b4c775c500d29a1cf59c9fe434f39d652d2aaff94a6688b4fd67755",
`data/pilot/current-context-pilot-revalidation/bundle-comparison.csv` = "3204450b7675f4e04f65bc68e9b4c1b0dbd109e824d5d0e6e911792bc6d5817f",
`data/pilot/current-context-pilot-revalidation/rights-scope.csv` = "50b383015f7f9ddcbd51bdf428704a77bce0aad3f320bae467978cd988410f66",
`data/pilot/current-context-pilot-revalidation/decisions.csv` = "c0b944b233a8ca61f6e8adb5109bfcc0ebb6d8fc66fa320ab324f8ccba04adb0",
`data/pilot/current-context-pilot-revalidation/summary.csv` = "42335be8b41b404cdd6cf71eba43d7e4309ef434919dc4a3a7f1958d5c312b5c",
`R/revalidate_current_context_pilots.R` = "0305d0a2c3265344925330e4edccb1bbf7bab3337ac953161fcdd8a00c4cc895",
`R/test_current_context_pilot_revalidation.R` = "bc0530c14f1ceaa84e31c6eeb6b3c294a29140d59365c84a8a21ea01ff489c1c",
`docs/current-context-pilot-revalidation.md` = "ae355197b6ef77eae8c5027868ba2e8bcad459731249f4e73e3ce55dfec1adcc"
)

pf_table <- function(x) {
  for(n in names(x))if(is.numeric(x[[n]]))x[[n]]<-vapply(x[[n]],function(v)if(is.na(v))'NA' else format(signif(v,4),trim=TRUE,scientific=FALSE),'')
  for(n in names(x))x[[n]]<-gsub('|',' / ',as.character(x[[n]]),fixed=TRUE)
  c(paste0('| ',paste(names(x),collapse=' | '),' |'),paste0('| ',paste(rep('---',ncol(x)),collapse=' | '),' |'),
    unname(apply(x,1,function(row)paste0('| ',paste(row,collapse=' | '),' |'))))
}
pf_report_text <- function(r) {
  decision<-r$decisions$value[r$decisions$id=='TERMINAL_DECISION'];x<-r$`match-metrics`;n<-r$`npr-model-summary`;i<-r$`npr-incremental-contributions`;w<-r$`same-match-win-summary`;s<-r$`stability-summary`;a<-r$`association-summary`;co<-r$`collinearity-diagnostics`
  main<-n[n$slice%in%c('tour:ATP','tour:WTA')&n$sensitivity=='full'&n$adjustment=='none'&n$term=='intercept',]
  table<-main[c('tour','set_id','n','r_squared','adjusted_r_squared','max_vif','max_condition','collinearity_gate')]
  for(j in 1:4) {
    table[[paste0('metric_',j)]]<-NA_character_;table[[paste0('beta_',j)]]<-NA_real_;table[[paste0('unique_R2_',j)]]<-NA_real_
    for(k in seq_len(nrow(table))) {
      id<-pf_terms(pf_registry()[match(table$set_id[k],pf_registry()$set_id),])[j]
      table[[paste0('metric_',j)]][k]<-id
      table[[paste0('beta_',j)]][k]<-n$coefficient[n$tour==table$tour[k]&n$slice==paste0('tour:',table$tour[k])&n$set_id==table$set_id[k]&n$term==id&n$sensitivity=='full'&n$adjustment=='none']
      table[[paste0('unique_R2_',j)]][k]<-i$semi_partial_r_squared[i$slice==paste0('tour:',table$tour[k])&i$set_id==table$set_id[k]&i$removed_metric==id&i$sensitivity=='full'&i$adjustment=='none']
    }
  }
  assoc<-a[a$slice%in%c('tour:ATP','tour:WTA')&a$sensitivity=='full'&a$sample=='pairwise'&a$method=='pearson',c('tour','metric','outcome','pair_count','correlation','direction_agreement')]
  assoc<-reshape(assoc,idvar=c('tour','metric'),timevar='outcome',direction='wide')
  fullwin<-w[w$slice%in%c('tour:ATP','tour:WTA')&w$sensitivity=='full'&w$removed_metric=='none'&w$term=='intercept',c('tour','set_id','n','converged','unstable','separation','apparent_log_loss','apparent_brier')]
  availability<-unique(r$`availability-summary`[c('slice','eligible_matches','common_complete_n','m12_undefined_matches','common_model_tail_n')])
  gates<-unique(co[co$kind=='predictor',c('slice','sensitivity','set_id','adjustment','set_gate')]);badgates<-gates[gates$set_gate%in%c('FAIL','AUTOMATIC_FAILURE'),]
  reversals<-s[s$sign_reversal&s$kind=='npr_coefficient',c('context','slice_a','slice_b','set_id','metric','value_a','value_b')]
  winreversals<-s[s$sign_reversal&s$kind=='win_coefficient',]
  adjusted<-n[n$slice=='tour:WTA'&n$adjustment!='none'&n$sensitivity=='full'&n$term=='event_Montreal_2021',c('set_id','n','coefficient','r_squared','max_vif','max_condition','collinearity_gate')]
  increments<-i[i$slice%in%c('tour:ATP','tour:WTA')&i$sensitivity=='full'&i$adjustment=='none',]
  inc_ranges<-aggregate(increments[c('semi_partial_r_squared','partial_r_squared')],increments[c('tour','removed_metric')],function(v)paste(format(signif(range(v),4),trim=TRUE),collapse=' to '))
  score<-as.data.frame(table(r$`candidate-scorecard`$criterion,r$`candidate-scorecard`$status),stringsAsFactors=FALSE);names(score)<-c('criterion','status','rows');score<-score[score$rows>0,]
  stable_summary<-aggregate(s[c('sign_reversal','changed_collinearity','numeric_increment_lost')],s[c('kind','context')],sum)
  c('# Exploratory Four Factors pilot analysis','',paste0('**',decision,'**. All 231 current-context match rows reproduce the frozen Phase 2A metrics. This is an exploratory same-match result from three hard-court convenience samples, not final factor selection or evidence of future forecasting value.'),'',
    paste('Primary alternatives meeting the registered two-tour numerical refinement rule:',if(nzchar(r$decisions$value[2]))r$decisions$value[2] else 'none','.'),
    'The rule checks full-rank fits, unacceptable collinearity, prespecified directions and numerical nonzero NPR increments. It does not rank sets by fit, establish four independent mechanisms, supply practical-effect margins or resolve instability. All twelve sets remain reported below.','',
    'The main concerns are conditional direction and sample sensitivity. S04–S06 fail the two-tour direction requirement because M02 is negative in WTA. ATP S07 reverses M11 and M12 signs after denominator filtering; WTA M01 changes sign between event-season cells in S02/S03. These findings prevent a final stability claim. Some cell-level logistic fits have separation or extreme-probability warnings despite strong apparent fit.','',
    '## Scope and reconstruction','',
    'The release uses only ATP Indian Wells 2023, WTA Indian Wells 2023 and WTA Montreal 2021. Phase 2E verified 245 inventory matches: 91/92/49 completed, with the single completed WTA Indian Wells statistical quarantine excluded. All retirements and walkovers remain excluded. The resulting 231 bundles comprise 91 ATP, 91 WTA Indian Wells and 49 Montreal matches; Montreal retains 42 original bundles plus seven separately reconstructed recovery bundles. No raw file or historical release was changed.','',
    paste('Reconstruction agrees across',nrow(r$`reproduction-comparison`),'fields, including exact memberships, identifiers, result-neutral source-ID orientation, eligibility, all denominators and undefined reasons. Maximum floating representation difference:',format(max(r$`reproduction-comparison`$max_absolute_error,na.rm=TRUE),digits=5),'.'),
    'Only floating metric/outcome values use 5e-12 * max(1, abs(frozen)) tolerance for historical 12-significant-digit serialization. NA patterns and all other fields compare exactly. Reproduction completes before any extended fit. Match-level CSVs contain source IDs for reproducibility, no player names, and remain ignored/local.','',
    '## Availability and denominator sensitivity','',pf_table(availability),'',
    'Only M12/M13 have structural match-difference gaps among these valid bundles. No missing input or invalid bundle enters this analysis. Side-specific zero opportunities and minimum, quartile, median and maximum positive denominators for all fifteen metrics appear in availability-summary.csv. A defined zero remains distinct from an unavailable value. No imputation or missingness-indicator model was fitted.','',
    'Full models use a common-complete cohort across all nine registered predictors. The denominator sensitivity retains only rows above each metric’s within-slice positive paired-minimum denominator lower quartile (type 1), intersecting all nine masks. This keeps identical samples across candidate sets and may remove many rows; it is not a coverage/admission threshold. Univariate sensitivity retains the inherited metric-specific mask. Predictors are restandardized within the retained sample, so coefficient changes also reflect changed variation and selection.','',
    '## Registered alternatives and algebraic facts','',pf_table(r$`candidate-set-registry`[1:6]),'',
    'M08/M15 are broad benchmarks and never enter a registered model. M07 is sensitivity-only. Exact A-minus-B identities remain dM03=dM09, dM04=dM10, dM08=dM15, dM11=-dM14 and dM12=dM13. No duplicate or signed complement coexists in a set. M05 and M06 are related alternatives, not exact duplicate differences. M06=M05*(1-M02), M04=M07*(1-M05), and M15=M02*M03+(1-M02)*M04 are within-side nonlinear identities.','',
    'Equal-phase NPR is exactly 100*dM08=100*dM15. NPR shares point counts with these rates and the other point-outcome ingredients. High correlation with these outcomes is not independent construct validity. M11/M12 share break-opportunity structure; raw conversion is not conversion above expectation or established clutch skill. M02’s positive direction is a hypothesis with a first-serve quality tradeoff.','',
    '## Same-match associations','',pf_table(assoc),'',
    'The complete local association table contains Pearson and Spearman, NPR/equal-phase NPR/same-match win, exact pair counts and common-complete counts, expected/observed signs, roles and coupling, across all three cells and both tour aggregates. Spearman preserves the inherited 12-decimal tie convention. Pairwise and common-complete samples are compared explicitly. The ATP aggregate duplicates its only cell; it is not a replication.','',
    '## Collinearity and conditional NPR results','',
    'Coefficients are NPR units per one sample SD of the named A-minus-B predictor, conditional on the other three. Each full and leave-one-factor-out fit keeps identical rows, orientation and scaling. An intercept is included. Ordinary R-squared describes same-match fit; adjusted R-squared is only a separate diagnostic. Neither is forecast performance or causal importance.','',
    pf_table(table[c('tour','set_id','n','r_squared','adjusted_r_squared','max_vif','max_condition','collinearity_gate')]),'',
    'Conditional coefficients and semi-partial R-squared (full minus reduced):','',pf_table(table[c('tour','set_id',unlist(lapply(1:4,function(j)c(paste0('metric_',j),paste0('beta_',j),paste0('unique_R2_',j)))))]),'',
    'Partial R-squared divides the ordinary increment by one minus reduced R-squared; it is undefined when that denominator is numerically zero. These are conditional unique contributions, not normalized allocations of explained variance or published weights. No LMG/Shapley allocation was calculated. Ranges across every registered alternative, including sensitivity sets, follow:','',pf_table(inc_ranges),'',
    'The unchanged .80/.90/.95 correlation, VIF 5/10 and condition-index 30 rules apply. Rank deficiency is an automatic failure; no predictor dropping or generalized inverse is used. Centered/unit-SD condition indices omit the intercept. Pairwise Pearson/Spearman, each VIF, each condition index, near-constant columns and shared-count warnings are retained in collinearity-diagnostics.csv. Sets with fatal numerical gates in any requested slice/sensitivity are listed here:','',
    if(nrow(badgates))pf_table(badgates) else 'No registered set reached a correlation, VIF, rank or condition-index concern boundary in the requested slices. Maximum VIF was below 5 and maximum condition index below 30. This does not resolve shared-count interpretation or stability.','',
    paste('Across all NPR fits,',sum(n$large_residual_count[n$term=='intercept'],na.rm=TRUE),'residual flags and',sum(n$high_leverage_count[n$term=='intercept'],na.rm=TRUE),'leverage flags were recorded, counting the same match again when it appears in another model. These are model-by-row diagnostics, not distinct-match counts.'),
    'Flags use absolute internally studentized residual >3 and leverage >2p/n; residual maxima and counts remain in the local model table. No p-values, standard errors or confidence intervals are reported.','',
    '## Confounded WTA event adjustment','',pf_table(adjusted),'',
    'The indicator equals one for Montreal 2021 and zero for Indian Wells 2023; its coefficient is an NPR-unit conditional contrast. It remains in every reduced comparison. Event and season cannot be disentangled, and an indicator does not adjust opponents, player dependence or the selection of these events. The local tables also retain this adjustment under the denominator sensitivity.','',
    '## Same-match win diagnostics','',pf_table(fullwin),'',
    'These are apparent in-sample binomial fits to the same matches whose statistics form the predictors. They are not pre-match probabilities, calibration estimates or forecasts. Log loss uses stable softplus arithmetic without clipping; Brier score is squared error. Full and reduced comparisons keep identical rows. Removing a predictor need not worsen apparent Brier score because logistic fitting optimizes likelihood, not Brier score.','',
    'All coefficient directions, full/reduced loss changes, convergence, boundary status, iteration counts, numerical warnings and separation witnesses remain in same-match-win-summary.csv. A signed fitted linear predictor that separates outcomes is sufficient evidence of separation; failure to find that witness does not prove its absence. Extreme probabilities or nonconvergence flag instability. No penalized or tuned replacement fit is used. Coefficients from unstable fits must not be treated as reliable effects.','',
    'Unstable full logistic fits by requested slice (including the duplicate ATP cell/aggregate):','',
    pf_table(w[w$term=='intercept'&w$unstable,c('slice','sensitivity','set_id','converged','separation','extreme_probability_count','warning')]),'',
    '## Stability and sensitivity','',pf_table(stable_summary),'',
    'Counts above describe comparisons, not independent replications. NPR coefficient sign reversals are shown below; numeric changes for every comparison remain in stability-summary.csv. A scientifically large-change threshold remains PENDING_SPECIFICATION; no threshold was chosen after seeing results.','',
    if(nrow(reversals))pf_table(reversals) else 'No NPR coefficient sign reversal was observed in the specified comparisons.',
    paste('Same-match logistic coefficient sign reversals:',nrow(winreversals),'; examine convergence/separation flags before interpreting them.'),'',
    'Comparisons cover ATP versus WTA Indian Wells, the two WTA event-season cells, tour aggregates, full versus denominator-filtered samples and pairwise versus common-complete associations. WTA cell differences are confounded by event and season. ATP has only one event-season. All three cells are hard-court convenience samples. Surface stability and independent-season stability are NOT_ASSESSABLE. Uncertainty is NOT_ASSESSABLE_UNDER_PILOT_DESIGN: no approved event/player-aware uncertainty implementation exists and these pilots have too few event clusters. No resampling or uncertainty intervals were calculated.','',
    '## Exploratory scorecard','',pf_table(score),'',
    'The local scorecard records metric, candidate set, tour and all twelve criteria in the approved precedence, with reasons and no total. CONTINUE statuses preserve alternatives for review, not final success. Exact duplicate alternatives fail coexistence; benchmarks remain BENCHMARK_ONLY. Structural conversion gaps, shared-count interpretation, reversed conditional signs, separation and sensitivity concerns cannot be compensated by high R-squared. Practical incremental-effect margins remain PENDING_SPECIFICATION; missing future, surface, season and uncertainty evidence remains NOT_ASSESSABLE.','',
    '## Decision and next approval','',paste0('**',decision,'**.'),
    'The terminal rule was registered before fitting. Support means at least one primary set meets the specified numerical and directional checks in both full tour samples; it does not endorse the numerically best fit, suppress failed alternatives, establish stability or select final factors. A family-revision result calls for a proposal, not an unapproved replacement. Inconclusive means the pilots cannot defensibly distinguish those outcomes.','',
    paste('**Exact recommended next approval:**',pf_next(decision)),'',
    'Final factors, practical-effect margins, new fields/formulas/composites, dependency or structural changes, broader data admission, uncertainty methods, opponent/history adjustments and any forecasting implementation require separate applicable approvals. Package B remains STOPPED; OTD remains PAUSED_BY_USER_AFTER_PHASE_1S; Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL. Publication is BLOCKED_PENDING_RIGHTS_REVIEW. No source or licensing permission was upgraded. Challenger work and portfolio integration remain deferred.','',
    '## Reproducibility and verification','',pf_table(data.frame(output=paste0(names(r),'.csv'),rows=vapply(r,nrow,1L))),'',
    'The new release pins current context/contract, unchanged Phase 2B rules, saved three-pilot inputs and frozen comparisons. Source code and tests are inert when sourced. The production entry point reconstructs and compares a complete release before atomic directory installation. Existing identical releases preserve bytes and mtimes; changed inputs, disagreements, partial releases and conflicting bytes fail closed. Only staging files newly created by the current invocation are cleaned up after interruption.','',
    'Run `Rscript R/analyze_exploratory_four_factors_pilots.R` and `Rscript R/test_exploratory_four_factors_pilots.R`. Base R only; no dependency was added. The test suite blocks network/browser transports and checks formulas, memberships, registration, known-answer model arithmetic, scope, historical pins, failed publication and deterministic output. Actual final verification counts are recorded in [status](status.md).','',
    'The unchanged Phase 2E suite passed on the clean Phase 2E baseline before current-document edits. Its seven frozen tables and original historical authority remain separately checked after implementation; its former current-document assertions are not weakened. The old Phase 2A empirical entry point is never invoked; its actual context-hash refusal remains required.','',
    'No network, search, download, contact, OTD resumption, other event content, 2022/2024/2025 data, history, Elo, forecast, final weight, portfolio edit, publication or push is part of this release. Saved whole annual files are hashed, but only the three literal event prefixes are parsed as data; unrelated rows remain opaque. Historical file preservation includes hashes, byte sizes and modification times.','',
    'See [source authority](data-source-contract.md#phase-2f-exploratory-authority-and-prespecified-implementation), [standing context](../PROJECT_CONTEXT.md), [Phase 2B protocol](four-factors-definition-protocol.md), [Phase 2E bridge](current-context-pilot-revalidation.md), [implementation](../R/analyze_exploratory_four_factors_pilots.R) and [tests](../R/test_exploratory_four_factors_pilots.R). Future ChatGPT handoffs remain response-only and no more than 2,000 words.')
}
pf_main <- function() {
  r<-pf_build();pf_publish(r)
  text<-pf_report_text(r)
  if(file.exists(pf_report))pf_need(identical(readLines(pf_report),text),'existing report differs; preserve for review') else writeLines(text,pf_report)
  message(r$decisions$value[r$decisions$id=='TERMINAL_DECISION']);invisible(r)
}
if(sys.nframe()==0L)pf_main()
