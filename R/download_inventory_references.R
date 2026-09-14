# Phase 1C allowlist. Run from the repository root; base R and existing SHA utility.
source("R/download_anomaly_references.R")

inventory_reference_config <- function() {
  prior <- anomaly_reference_manifest()
  w <- prior[match(c("wta_draw_pdf", "wta_draw_page", "wta_match"), prior$reference_id), ]
  config <- data.frame(reference_id = c("atp_draw_pdf", "atp_results", "atp_draw_page", w$reference_id),
    tour = rep(c("ATP", "WTA"), each = 3),
    publisher = c("ATP / ProTennisLive", "ATP", "ATP", rep("WTA", 3)),
    title = c("Indian Wells 2023 singles draw PDF", "Indian Wells 2023 results archive",
      "Indian Wells 2023 ATP draw", w$title),
    url = c("https://www.protennislive.com/posting/2023/404/mds.pdf",
      "https://www.atptour.com/en/scores/archive/indian-wells/404/2023/results",
      "https://www.atptour.com/en/scores/archive/indian-wells/404/2023/draws", w$url),
    local_path = c(file.path("data/raw/reference/indian-wells-2023-inventory",
      c("atp-mds.pdf", "atp-results.html", "atp-draws.html")), w$local_path),
    document_type = rep(c("PDF", "HTML", "HTML"), 2), classification = "official",
    inventory_role = c("Bracket, entrants, progression and results", "Non-bye results and status",
      "Draw positions and byes", "Bracket, entrants and available results",
      "Complete singles result cards and byes", "LS033 result/status support; Phase 1B preserved"),
    rights_limitation = c(rep("Local user-authorized audit only; provider extraction and republication rights not established; no open-data grant inferred", 3), w$rights_limitation),
    prior_manifest_reference = c(rep("", 3), paste0("data/manifests/anomaly-reference-files.csv#", w$reference_id)),
    stringsAsFactors = FALSE)
  browser <- config[2:3, ]
  browser$reference_id <- c("atp_results_browser", "atp_draw_browser")
  browser$local_path <- file.path("data/raw/reference/indian-wells-2023-inventory", paste0(browser$reference_id, ".txt"))
  browser$document_type <- "browser_service_text"
  browser$inventory_role <- c("Browser-rendered results cross-check; not original HTTP bytes",
    "Browser-rendered draw cross-check; not original HTTP bytes")
  browser$prior_manifest_reference <- c("inventory-reference-files.csv#atp_results", "inventory-reference-files.csv#atp_draw_page")
  rbind(config, browser)
}

inventory_validate_reference <- function(record) {
  path <- record$local_path
  if (!file.exists(path) || file.info(path)$size <= 0) stop("Missing reference: ", path)
  if (pilot_sha256(path) != record$sha256 || file.info(path)$size != as.numeric(record$byte_size))
    stop("Reference hash/size conflict; refusing overwrite: ", path)
  bytes <- readBin(path, "raw", n = file.info(path)$size)
  if (record$document_type == "PDF") {
    if (rawToChar(head(bytes, 5)) != "%PDF-") stop("Not a PDF: ", path)
  } else if (record$document_type == "browser_service_text") {
    if (!startsWith(rawToChar(bytes), "Browser-service representation; not original HTTP response bytes.") ||
        !grepl(record$url, rawToChar(bytes), fixed = TRUE)) stop("Unexpected browser representation.")
  } else if (!grepl("<html", rawToChar(bytes), ignore.case = TRUE) ||
             !grepl("Indian Wells", rawToChar(bytes), ignore.case = TRUE)) stop("Unexpected HTML: ", path)
  invisible(TRUE)
}

inventory_reference_manifest <- function(require_all = TRUE) {
  config <- inventory_reference_config()
  path <- "data/manifests/inventory-reference-files.csv"
  if (!file.exists(path)) {
    if (require_all) stop("Run the inventory reference downloader first.")
    return(NULL)
  }
  m <- read.csv(path, colClasses = "character", na.strings = NULL, check.names = FALSE)
  extra <- c("sha256", "byte_size", "retrieved_at_utc", "acquisition_status", "attempted_at_utc", "acquisition_note")
  if (!identical(names(m), c(names(config), extra)) || anyNA(m) || anyDuplicated(m$reference_id) ||
      any(!m$reference_id %in% config$reference_id)) stop("Invalid inventory manifest.")
  for (i in seq_len(nrow(m))) {
    expected <- config[match(m$reference_id[i], config$reference_id), ]
    if (!identical(unname(unlist(m[i, names(config)])), unname(unlist(expected)))) stop("Allowlist metadata changed.")
    if (!m$acquisition_status[i] %in% c("acquired", "reused", "browser_capture", "unavailable")) stop("Unknown acquisition state.")
    if (m$acquisition_status[i] != "unavailable") {
      if (!grepl("^[0-9a-f]{64}$", m$sha256[i]) || !grepl("T.*Z$", m$retrieved_at_utc[i])) stop("Missing provenance.")
      inventory_validate_reference(m[i, ])
    } else if (file.exists(m$local_path[i])) stop("Unexpected bytes for unavailable reference; review required.")
  }
  if (require_all && !setequal(m$reference_id, config$reference_id)) stop("Incomplete inventory manifest.")
  m
}

download_inventory_references <- function() {
  config <- inventory_reference_config()
  prior <- anomaly_reference_manifest()
  # Verify all Phase 1B bytes, even the supplementary file not used in this inventory.
  for (i in seq_len(nrow(prior))) anomaly_validate_reference(prior[i, ])
  m <- inventory_reference_manifest(FALSE)
  for (i in 1:3) if (file.exists(config$local_path[i]) &&
    (is.null(m) || !config$reference_id[i] %in% m$reference_id)) stop("Unmanifested ATP reference; review required.")
  dir.create(dirname(config$local_path[1]), recursive = TRUE, showWarnings = FALSE)
  for (i in seq_len(nrow(config))) {
    record <- config[i, ]
    if (!is.null(m) && record$reference_id %in% m$reference_id) {
      message("Preserved recorded reference state: ", record$reference_id)
      next
    }
    record$retrieved_at_utc <- record$byte_size <- record$sha256 <- ""
    record$acquisition_status <- "unavailable"
    record$attempted_at_utc <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    record$acquisition_note <- ""
    if (record$document_type == "browser_service_text") {
      if (!file.exists(record$local_path)) stop("Direct ATP HTTP returned 403. Restore the manifested browser-service capture; do not fabricate HTML.")
      header <- readLines(record$local_path, n = 3L)
      record$retrieved_at_utc <- sub("^Retrieved UTC: ", "", header[3])
      record$byte_size <- as.character(file.info(record$local_path)$size)
      record$sha256 <- pilot_sha256(record$local_path)
      record$acquisition_status <- "browser_capture"
      record$attempted_at_utc <- ""
      record$acquisition_note <- "Captured existing browsing-service text views of allowlisted URL after direct HTTP 403; service says crawled two months ago; access time is not origin retrieval time; immutable overlapping views, not raw HTML"
      inventory_validate_reference(record)
    } else if (record$tour == "WTA") {
      p <- prior[prior$reference_id == record$reference_id, ]
      record[c("retrieved_at_utc", "byte_size", "sha256")] <- p[c("retrieved_at_utc", "byte_size", "sha256")]
      record$acquisition_status <- "reused"
      record$attempted_at_utc <- ""
      record$acquisition_note <- "Verified original Phase 1B bytes; no request made"
    } else {
      # A temporary response cannot replace an existing manifested file.
      temp <- tempfile(fileext = if (record$document_type == "PDF") ".pdf" else ".html")
      warnings <- character()
      result <- tryCatch(withCallingHandlers(download.file(record$url, temp, method = "libcurl", mode = "wb"),
        warning = function(w) { warnings <<- c(warnings, conditionMessage(w)); invokeRestart("muffleWarning") }),
        error = function(e) conditionMessage(e))
      if (identical(result, 0L)) {
        record$retrieved_at_utc <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
        record$byte_size <- as.character(file.info(temp)$size)
        record$sha256 <- pilot_sha256(temp)
        check <- record; check$local_path <- temp
        inventory_validate_reference(check)
        if (!file.copy(temp, record$local_path, overwrite = FALSE)) stop("Could not preserve acquired reference.")
        record$acquisition_status <- "acquired"
      } else record$acquisition_note <- paste(c(warnings, as.character(result)), collapse = "; ")
      # Failed retrievals have no invented bytes, hash or retrieval timestamp.
    }
    m <- rbind(m, record)
    pilot_write_csv(m, "data/manifests/inventory-reference-files.csv")
  }
  invisible(inventory_reference_manifest())
}

if (sys.nframe() == 0L) download_inventory_references()
