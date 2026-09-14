# Run from the repository root. Only the four user-authorized references are acquired.
source("R/download_pilot_data.R")

anomaly_reference_config <- function() {
  root <- "data/raw/reference/indian-wells-2023-anomaly"
  data.frame(
    reference_id = c("wta_match", "wta_draw_pdf", "wta_draw_page", "tennis_abstract"),
    publisher = c(rep("WTA", 3), "Tennis Abstract / Match Charting Project"),
    title = c("Stearns vs Andreescu: Indian Wells 2023 R64 LS033",
              "Indian Wells 2023 women's singles main draw",
              "Indian Wells 2023 WTA draws",
              "2023 Indian Wells R64: Stearns vs Andreescu charting"),
    url = c("https://www.wtatennis.com/tournaments/609/indian-wells/2023/scores/LS033",
            "https://wtafiles.wtatennis.com/pdf/draws/2023/609/MDS.pdf",
            "https://www.wtatennis.com/tournaments/609/indian-wells/2023/draws",
            "https://www.tennisabstract.com/charting/20230311-W-Indian_Wells-R64-Peyton_Stearns-Bianca_Andreescu.html"),
    local_path = file.path(root, c("wta-match-LS033.html", "wta-MDS.pdf", "wta-draws.html", "tennis-abstract.html")),
    classification = c(rep("official", 3), "supplementary"),
    evidentiary_purpose = c("Published match statistics, result and date evidence",
      "Confirm only this match's players, draw position and score",
      "Confirm only this match's inventory, round, result and score",
      "Crowdsourced corroboration and source-dependent date evidence; no correction authorized"),
    rights_limitation = c(rep("WTA copyrighted reference; local audit only; no open-data or republication grant inferred; prior terms review in source contract", 3),
      "Crowdsourced Tennis Abstract material; retain contributor attribution and applicable NC-SA conditions; no raw redistribution or correction authorization inferred"),
    stringsAsFactors = FALSE
  )
}

anomaly_reference_manifest <- function(require_all = TRUE) {
  config <- anomaly_reference_config()
  path <- "data/manifests/anomaly-reference-files.csv"
  if (!file.exists(path)) {
    if (require_all) stop("Acquire and manifest the authorized references first.")
    return(NULL)
  }
  m <- read.csv(path, colClasses = "character", check.names = FALSE, na.strings = "", stringsAsFactors = FALSE)
  if (!identical(names(m), c(names(config), "retrieved_at_utc", "byte_size", "sha256")) ||
      anyNA(m) || anyDuplicated(m$reference_id) || !nrow(m) ||
      any(!m$reference_id %in% config$reference_id)) stop("Invalid anomaly reference manifest.")
  for (i in seq_len(nrow(m))) {
    expected <- config[match(m$reference_id[i], config$reference_id), , drop = FALSE]
    if (!identical(unname(unlist(m[i, names(config)])), unname(unlist(expected))) ||
        !grepl("^[0-9a-f]{64}$", m$sha256[i]) ||
        !grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", m$retrieved_at_utc[i]) ||
        is.na(suppressWarnings(as.numeric(m$byte_size[i]))) || as.numeric(m$byte_size[i]) <= 0) {
      stop("Reference manifest differs from the approved configuration.")
    }
  }
  if (require_all && !setequal(m$reference_id, config$reference_id)) stop("Reference manifest is incomplete.")
  m
}

anomaly_validate_reference <- function(record) {
  path <- record$local_path
  if (!file.exists(path) || file.info(path)$size <= 0) stop("Missing/empty reference: ", path)
  hash <- pilot_sha256(path)
  if ("sha256" %in% names(record) &&
      (hash != record$sha256 || file.info(path)$size != as.numeric(record$byte_size))) {
    stop("Reference checksum/size mismatch; refusing overwrite: ", path)
  }
  bytes <- readBin(path, "raw", n = file.info(path)$size)
  if (record$reference_id == "wta_draw_pdf") {
    if (rawToChar(head(bytes, 5)) != "%PDF-") stop("Reference is not a PDF: ", path)
  } else {
    html <- rawToChar(bytes)
    if (!grepl("<html", html, ignore.case = TRUE) ||
        !grepl("Indian Wells|Indian_Wells", html, ignore.case = TRUE)) {
      stop("Unexpected HTML reference; inspect response without replacing it: ", path)
    }
  }
  list(byte_size = length(bytes), sha256 = hash)
}

download_anomaly_references <- function() {
  config <- anomaly_reference_config()
  m <- anomaly_reference_manifest(FALSE)
  # Validate every existing file before the first request or manifest write.
  for (i in seq_len(nrow(config))) if (file.exists(config$local_path[i])) {
    found <- if (is.null(m)) integer() else which(m$reference_id == config$reference_id[i])
    if (length(found) != 1L) stop("Existing unmanifested reference requires review: ", config$local_path[i])
    anomaly_validate_reference(m[found, , drop = FALSE])
  }
  dir.create(dirname(config$local_path[1]), recursive = TRUE, showWarnings = FALSE)
  if (!capabilities("libcurl")) stop("Base R libcurl is required; no software will be installed.")
  options(timeout = max(60, getOption("timeout")))
  for (i in seq_len(nrow(config))) {
    record <- config[i, , drop = FALSE]
    if (file.exists(record$local_path)) {
      message("Reused verified reference; no download: ", record$reference_id)
      next
    }
    message("Acquiring authorized reference: ", record$url)
    status <- tryCatch(download.file(record$url, record$local_path, method = "libcurl", mode = "wb"),
      error = function(e) stop("Reference acquisition failed; inspect any partial bytes: ", conditionMessage(e)))
    if (status != 0L) stop("Reference acquisition failed: ", record$url)
    old <- if (is.null(m)) integer() else which(m$reference_id == record$reference_id)
    observed <- anomaly_validate_reference(if (length(old)) m[old, , drop = FALSE] else record)
    record$retrieved_at_utc <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    record$byte_size <- observed$byte_size
    record$sha256 <- observed$sha256
    if (length(old)) m <- m[-old, , drop = FALSE]
    m <- rbind(m, record)
    m <- m[match(config$reference_id[config$reference_id %in% m$reference_id], m$reference_id), , drop = FALSE]
    rownames(m) <- NULL
    pilot_write_csv(m, "data/manifests/anomaly-reference-files.csv")
  }
  invisible(m)
}

if (sys.nframe() == 0L) download_anomaly_references()
