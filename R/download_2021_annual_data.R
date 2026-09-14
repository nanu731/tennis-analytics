# Bounded Phase 1E acquisition. Run from the repository root; no R packages.
source("R/download_pilot_data.R")

annual_2021_config <- function() {
  x <- pilot_config()
  x <- x[setdiff(names(x), c("expected_bytes", "source_git_blob"))]
  for (field in c("source_path", "source_url", "local_path")) x[[field]] <- sub("2023", "2021", x[[field]], fixed = TRUE)
  x$metadata_url <- paste0("https://api.github.com/repos/Aneeshers/tennis-sackmann-archive/contents/",
    x$source_path, "?ref=", x$pinned_commit)
  x$metadata_local_path <- sub("[.]csv$", ".metadata.json", x$local_path)
  x$use_notes <- "User-approved local noncommercial educational research; Jeff Sackmann / Tennis Abstract attribution; CC BY-NC-SA 4.0; mirror adds no rights; no raw or derived-table publication authorized"
  x
}

annual_2021_allow_url <- function(url) {
  x <- annual_2021_config()
  if (length(url) != 1L || is.na(url) || !url %in% c(x$source_url, x$metadata_url)) stop("URL outside Phase 1E allowlist.")
  invisible(TRUE)
}

annual_2021_request <- function(url, dest) {
  annual_2021_allow_url(url)
  if (!nzchar(Sys.which("curl"))) stop("Existing curl required for redirect refusal; no dependency will be installed.")
  headers <- tempfile()
  # Base R libcurl follows redirects. The existing system-curl method permits
  # disabling redirects/configuration so no fifth URL can be requested.
  status <- download.file(url, dest, method = "curl", mode = "wb", quiet = TRUE,
    extra = c("-q", "--fail", "--no-location", "--max-redirs 0", "--proto '=https'",
      "--connect-timeout 20", "--max-time 60", "--dump-header", shQuote(headers)))
  h <- readLines(headers, warn = FALSE)
  codes <- sub("^HTTP/[^ ]+ ([0-9]+).*", "\\1", h[grepl("^HTTP/", h)])
  if (status != 0L || !length(codes) || tail(codes, 1) != "200" || any(grepl("^location:", h, ignore.case = TRUE)))
    stop("Unexpected HTTP status or redirect for authorized URL: ", url)
  format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}

annual_2021_metadata <- function(path, config, text = NULL) {
  if (is.null(text)) text <- paste(readLines(path, warn = FALSE), collapse = "\n")
  if (!startsWith(trimws(text), "{")) stop("Metadata is not a JSON object.")
  # Only named top-level scalar fields are needed; reject unfamiliar formatting
  # rather than attempt to interpret nested links or fetch them.
  scalar <- function(key, numeric = FALSE) {
    pattern <- paste0('(?m)^  "', key, '": ', if (numeric) '([0-9]+)' else '"([^"\\\\]*)"', ',?$')
    hit <- regmatches(text, gregexpr(pattern, text, perl = TRUE))[[1]]
    if (length(hit) != 1L) stop("Missing/ambiguous metadata scalar: ", key)
    sub(pattern, "\\1", hit, perl = TRUE)
  }
  m <- list(name = scalar("name"), path = scalar("path"), type = scalar("type"),
    download_url = scalar("download_url"), url = scalar("url"), sha = scalar("sha"), size = scalar("size", TRUE))
  if (m$name != basename(config$source_path) || m$path != config$source_path || m$type != "file" ||
      m$download_url != config$source_url || m$url != config$metadata_url ||
      !grepl("^[0-9a-f]{40}$", m$sha) || as.numeric(m$size) <= 0) stop("Pinned API metadata mismatch.")
  m
}

annual_2021_csv <- function(path = NULL, bytes = NULL) {
  if (is.null(bytes)) bytes <- readBin(path, "raw", n = file.info(path)$size)
  prefix <- head(bytes, 128L)
  if (!length(prefix) || any(prefix == as.raw(0)) || grepl("^\\s*<", rawToChar(prefix))) stop("Empty, binary or HTML CSV response.")
  withCallingHandlers({
    content <- rawToChar(bytes)
    con <- textConnection(strsplit(content, "\n", fixed = TRUE)[[1]]); on.exit(close(con), add = TRUE)
    counts <- count.fields(con, sep = ",", quote = '"', comment.char = "", blank.lines.skip = FALSE)
    if (length(counts) < 2L || anyNA(counts) || any(counts != counts[1]) || counts[1] < 2L)
      stop("Malformed CSV field counts.")
    x <- read.csv(text = content, colClasses = "character", check.names = FALSE, na.strings = "",
      fill = FALSE, comment.char = "", fileEncoding = "UTF-8", row.names = NULL)
    if (ncol(x) != counts[1] || nrow(x) != length(counts)-1L || anyNA(names(x)) ||
        any(!grepl("^[A-Za-z][A-Za-z0-9_]*$", names(x))) || anyDuplicated(names(x)) ||
        !all(c("tourney_id", "tourney_name", "score", "winner_id", "loser_id") %in% names(x))) stop("Malformed match CSV/header.")
    x
  }, warning = function(w) stop("CSV parse warning: ", conditionMessage(w)))
}

annual_2021_blob <- function(path) {
  value <- system2("git", c("hash-object", "--no-filters", shQuote(path)), stdout = TRUE, stderr = TRUE)
  if (!is.null(attr(value, "status")) || length(value) != 1L || !grepl("^[0-9a-f]{40}$", value)) stop("Git blob calculation failed.")
  value
}

annual_2021_validate <- function(path, record) {
  if (!file.exists(path) || file.info(path)$size != as.numeric(record$byte_size) ||
      annual_2021_blob(path) != record$source_git_blob) stop("Size/blob mismatch; refusing overwrite: ", path)
  sha <- pilot_sha256(path)
  if ("sha256" %in% names(record) && sha != record$sha256) stop("Checksum mismatch; refusing overwrite: ", path)
  x <- annual_2021_csv(path)
  if ("row_count" %in% names(record) && nrow(x) != as.numeric(record$row_count)) stop("Recorded row count mismatch.")
  list(sha256 = sha, row_count = nrow(x))
}

annual_2021_manifest <- function(required = TRUE) {
  path <- "data/manifests/development-source-files.csv"
  if (!file.exists(path)) {if (required) stop("No completed Phase 1E manifest."); return(NULL)}
  m <- read.csv(path, colClasses = "character", check.names = FALSE, na.strings = "")
  config <- annual_2021_config()
  extra <- c("metadata_retrieved_at_utc", "metadata_sha256", "metadata_byte_size", "source_git_blob",
    "byte_size", "retrieved_at_utc", "row_count", "sha256")
  if (!identical(names(m), c(names(config), extra)) || nrow(m) != 2L || anyNA(m) ||
      !identical(m$tour, config$tour)) stop("Incomplete or malformed development manifest.")
  for (i in 1:2) {
    if (!identical(unname(unlist(m[i, names(config)])), as.character(unlist(config[i, ])))) stop("Manifest configuration changed.")
    r <- m[i, ]
    for (field in c("retrieved_at_utc", "metadata_retrieved_at_utc"))
      if (!grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", r[[field]])) stop("Missing timestamp.")
    if (pilot_sha256(r$metadata_local_path) != r$metadata_sha256 ||
        file.info(r$metadata_local_path)$size != as.numeric(r$metadata_byte_size)) stop("Saved metadata hash/size conflict.")
    api <- annual_2021_metadata(r$metadata_local_path, r)
    if (api$sha != r$source_git_blob || api$size != r$byte_size) stop("Manifest/API conflict.")
    annual_2021_validate(r$local_path, r)
  }
  m
}

download_2021_annual_data <- function() {
  config <- annual_2021_config()
  manifest <- annual_2021_manifest(FALSE)
  if (!is.null(manifest)) {message("Reused both verified 2021 files and metadata; no requests or writes."); return(invisible(manifest))}
  if (any(file.exists(c(config$local_path, config$metadata_local_path)))) stop("Unmanifested 2021 files exist; preserve and review before acquisition.")
  temp_csv <- temp_meta <- character(2)
  records <- list()
  # Neither final CSV nor manifest is written until BOTH tours fully validate.
  for (i in 1:2) {
    r <- config[i, ]; temp_meta[i] <- tempfile(fileext = ".json"); temp_csv[i] <- tempfile(fileext = ".csv")
    r$metadata_retrieved_at_utc <- annual_2021_request(r$metadata_url, temp_meta[i])
    api <- annual_2021_metadata(temp_meta[i], r)
    r$metadata_sha256 <- pilot_sha256(temp_meta[i]); r$metadata_byte_size <- file.info(temp_meta[i])$size
    r$source_git_blob <- api$sha; r$byte_size <- as.numeric(api$size)
    r$retrieved_at_utc <- annual_2021_request(r$source_url, temp_csv[i])
    v <- annual_2021_validate(temp_csv[i], r)
    r$row_count <- v$row_count; r$sha256 <- v$sha256
    records[[i]] <- r
  }
  manifest <- do.call(rbind, records)
  dir.create(dirname(config$local_path[1]), recursive = TRUE, showWarnings = FALSE)
  for (i in 1:2) {
    if (!file.copy(temp_meta[i], config$metadata_local_path[i], overwrite = FALSE) ||
        !file.copy(temp_csv[i], config$local_path[i], overwrite = FALSE)) stop("Final placement failed; milestone incomplete; preserve partial files for review.")
  }
  pilot_write_csv(manifest, "data/manifests/development-source-files.csv")
  invisible(annual_2021_manifest())
}

if (sys.nframe() == 0L) download_2021_annual_data()
