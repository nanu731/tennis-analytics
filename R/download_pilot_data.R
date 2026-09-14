# Run from the repository root: Rscript --vanilla R/download_pilot_data.R
# Base R download.file() performs acquisition; the existing shasum/sha256sum
# utility supplies SHA-256 because base R has no SHA-256 digest function.

pilot_config <- function() {
  pin <- "83733587353df8a41f2fd4f516147d5aa83f5a8d"
  archive <- "https://github.com/Aneeshers/tennis-sackmann-archive"
  raw_base <- paste0("https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/", pin)
  files <- c("atp_matches_2023.csv", "wta_matches_2023.csv")
  data.frame(
    tour = c("ATP", "WTA"), pinned_commit = pin,
    source_path = paste(c("atp", "wta"), files, sep = "/"),
    source_url = paste(raw_base, c("atp", "wta"), files, sep = "/"),
    local_path = file.path("data/raw/sackmann", pin, files),
    expected_bytes = c(625341, 569610),
    source_git_blob = c("f9cdafde0083793c943ecf0701bc5c51602ca215",
                        "fe2d1be2e1be1e9ab7cd503629ab784ee7385e5b"),
    license_id = "CC-BY-NC-SA-4.0",
    license_url = paste0(raw_base, "/LICENSE"),
    original_creator = "Jeff Sackmann / Tennis Abstract",
    original_repository = paste0("https://github.com/JeffSackmann/tennis_", c("atp", "wta")),
    archive_repository = archive,
    archive_relationship = "Archival mirror; preserves upstream README; claims June 2026 ATP/WTA snapshots; adds no rights",
    use_notes = "User-approved noncommercial educational research pilot; credit original creator; source-specific NC-SA conditions remain; raw data excluded from Git; review derived publication separately",
    stringsAsFactors = FALSE
  )
}

pilot_sha256 <- function(path) {
  utility <- Sys.which("shasum")
  args <- c("-a", "256", shQuote(path))
  if (!nzchar(utility)) {
    utility <- Sys.which("sha256sum")
    args <- shQuote(path)
  }
  if (!nzchar(utility)) stop("No existing shasum or sha256sum utility; no software will be installed.")
  result <- system2(utility, args, stdout = TRUE, stderr = TRUE)
  status <- attr(result, "status")
  if ((!is.null(status) && status != 0L) || length(result) != 1L ||
      !grepl("^[0-9a-fA-F]{64}[[:space:]]", result)) {
    stop("SHA-256 failed for ", path)
  }
  tolower(substr(result, 1L, 64L))
}

pilot_read_csv <- function(path) {
  # Character columns preserve original identifiers, dates and missing tokens.
  x <- read.csv(path, colClasses = "character", check.names = FALSE,
                na.strings = "", stringsAsFactors = FALSE, fill = FALSE,
                comment.char = "", fileEncoding = "UTF-8")
  if (!nrow(x) || ncol(x) < 2L || anyDuplicated(names(x)) ||
      !all(c("tourney_id", "tourney_name", "score", "winner_id", "loser_id") %in% names(x))) {
    stop("Expected a match CSV header and at least one data row: ", path)
  }
  x
}

pilot_write_csv <- function(x, path) {
  lines <- character()
  con <- textConnection("lines", "w", local = TRUE)
  write.csv(x, con, row.names = FALSE, na = "", eol = "\n")
  close(con)
  if (!file.exists(path) || !identical(readLines(path, warn = FALSE), lines)) {
    writeLines(lines, path, useBytes = TRUE)
  }
  invisible(path)
}

pilot_read_manifest <- function(config, path = "data/manifests/pilot-source-files.csv") {
  if (!file.exists(path)) return(NULL)
  m <- read.csv(path, colClasses = "character", check.names = FALSE,
                stringsAsFactors = FALSE, na.strings = "")
  required <- c(names(config), "retrieved_at_utc", "byte_size", "row_count", "sha256")
  if (!identical(names(m), required) || !nrow(m) || anyDuplicated(m$tour) ||
      any(!m$tour %in% config$tour) || anyNA(m)) stop("Invalid pilot manifest; refusing acquisition.")
  for (i in seq_len(nrow(m))) {
    expected <- config[match(m$tour[i], config$tour), , drop = FALSE]
    if (!all(as.character(m[i, names(config)]) == as.character(expected[1, ])) ||
        !grepl("^[0-9a-f]{64}$", m$sha256[i]) ||
        !grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", m$retrieved_at_utc[i])) {
      stop("Manifest metadata does not match the verified pilot source: ", m$tour[i])
    }
  }
  m
}

pilot_validate_file <- function(path, record) {
  if (!file.exists(path) || is.na(file.info(path)$size) || file.info(path)$size == 0) {
    stop("Missing or empty source file: ", path)
  }
  hash <- pilot_sha256(path)
  if ("sha256" %in% names(record) && hash != record$sha256) {
    stop("Checksum mismatch; refusing to replace or accept existing file: ", path)
  }
  size <- file.info(path)$size
  if (size != as.numeric(record$expected_bytes)) stop("Unexpected byte size: ", path)
  x <- pilot_read_csv(path)
  if ("row_count" %in% names(record) &&
      (nrow(x) != as.numeric(record$row_count) || size != as.numeric(record$byte_size))) {
    stop("Manifest size/row count mismatch: ", path)
  }
  list(sha256 = hash, byte_size = size, row_count = nrow(x))
}

download_pilot_data <- function() {
  if (!file.exists("AGENTS.md") || !file.exists("R/download_pilot_data.R") ||
      !dir.exists("data/manifests")) stop("Run from the prepared repository root.")
  config <- pilot_config()
  manifest_path <- "data/manifests/pilot-source-files.csv"
  manifest <- pilot_read_manifest(config, manifest_path)
  # Check every existing file before making any network request or manifest edit.
  for (i in seq_len(nrow(config))) {
    path <- config$local_path[i]
    if (file.exists(path)) {
      row <- if (is.null(manifest)) integer() else which(manifest$tour == config$tour[i])
      if (length(row) != 1L) stop("Existing unmanifested source file; provenance review required: ", path)
      pilot_validate_file(path, manifest[row, , drop = FALSE])
    }
  }
  dir.create(dirname(config$local_path[1]), recursive = TRUE, showWarnings = FALSE)
  if (!capabilities("libcurl")) stop("Base R libcurl support unavailable; no shell downloader used.")
  options(timeout = max(60, getOption("timeout")))
  for (i in seq_len(nrow(config))) {
    record <- config[i, , drop = FALSE]
    path <- record$local_path
    if (file.exists(path)) {
      message("Reused verified local file; no download: ", path)
      next
    }
    message("Downloading approved 2023 source: ", record$source_url)
    status <- tryCatch(download.file(record$source_url, path, method = "libcurl", mode = "wb"),
                       error = function(e) stop("Download failed: ", conditionMessage(e)))
    if (status != 0L) stop("Download failed; inspect any partial file: ", path)
    old <- if (is.null(manifest)) integer() else which(manifest$tour == record$tour)
    validation_record <- if (length(old)) manifest[old, , drop = FALSE] else record
    observed <- pilot_validate_file(path, validation_record)
    record$retrieved_at_utc <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    record$byte_size <- observed$byte_size
    record$row_count <- observed$row_count
    record$sha256 <- observed$sha256
    if (length(old)) manifest <- manifest[-old, , drop = FALSE]
    manifest <- rbind(manifest, record)
    manifest <- manifest[match(config$tour[config$tour %in% manifest$tour], manifest$tour), , drop = FALSE]
    rownames(manifest) <- NULL
    pilot_write_csv(manifest, manifest_path)
  }
  message("Pilot source verification complete. Manifest: ", manifest_path)
  invisible(manifest)
}

if (sys.nframe() == 0L) download_pilot_data()
