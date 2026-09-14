# Offline Phase 1C inventory audit, deliberately scoped to the saved 2023 layouts.
source("R/download_inventory_references.R")
source("R/audit_wta_anomaly.R")

inventory_name <- function(x) {
  x <- gsub("\\[[0-9]+\\]", "", x)
  x <- vapply(strsplit(x, ",", fixed = TRUE), function(p) {
    if (length(p) == 2L) paste(p[2], p[1]) else paste(p, collapse = " ")
  }, character(1), USE.NAMES = FALSE)
  x <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
  x <- tolower(gsub("['’.]", "", x))
  trimws(gsub("[^a-z0-9]+", " ", x))
}

inventory_resolve_name <- function(name, roster) {
  n <- inventory_name(name); r <- inventory_name(roster)
  exact <- which(gsub(" ", "", r, fixed = TRUE) == gsub(" ", "", n, fixed = TRUE))
  if (length(exact)) return(exact)
  # Initials/prefixes must agree with every remaining name token. Never surname alone.
  a <- strsplit(n, " ", fixed = TRUE)[[1]]
  which(vapply(strsplit(r, " ", fixed = TRUE), function(b) {
    length(a) >= 2L && length(a) <= length(b) &&
      identical(tail(a, -1), tail(b, length(a)-1L)) && startsWith(b[1], a[1]) && nchar(a[1]) <= 3L
  }, logical(1)))
}

inventory_round <- function(x) {
  x <- toupper(gsub("[ -]", "", x))
  x <- sub("^ROUNDOF", "R", x)
  map <- c(FINAL = "F", FINALS = "F", SEMIFINAL = "SF", SEMIFINALS = "SF",
    QUARTERFINAL = "QF", QUARTERFINALS = "QF", R8 = "QF", R4 = "SF", R2 = "F")
  x[x %in% names(map)] <- map[x[x %in% names(map)]]
  x[!x %in% c("R128", "R64", "R32", "R16", "QF", "SF", "F")] <- NA_character_
  unname(x)
}

inventory_score <- function(x, reverse = FALSE, compact = FALSE) {
  if (is.na(x) || !nzchar(trimws(x))) return(NA_character_)
  x <- toupper(x)
  x <- gsub("[–—−]", "-", x)
  x <- gsub("RET['’]?D|RETIRED|RETIREMENT", "RET", x)
  x <- gsub("WALK[ -]?OVER|W/O", "WO", x)
  x <- gsub("\\s*-\\s*", "-", x, perl = TRUE)
  x <- gsub("\\s*\\(\\s*([0-9]+)\\s*\\)", "(\\1)", x, perl = TRUE)
  x <- trimws(gsub("\\s+", " ", x, perl = TRUE))
  if (x == "WO") return(x)
  tokens <- strsplit(x, " ", fixed = TRUE)[[1]]
  if (compact) tokens <- sub("^([0-9])([0-9])(\\([0-9]+\\))?$", "\\1-\\2\\3", tokens)
  if (!all(grepl("^[0-9]+-[0-9]+(\\([0-9]+\\))?$|^RET$", tokens))) return(NA_character_)
  if (reverse) tokens <- sub("^([0-9]+)-([0-9]+)(.*)$", "\\2-\\1\\3", tokens)
  paste(tokens, collapse = " ")
}

inventory_status <- function(score, bye = FALSE) {
  if (bye) return("bye")
  if (is.na(score)) return("unresolved")
  if (score == "WO") return("walkover")
  if (grepl("RET$", score)) return("retirement")
  if (pilot_score(score, "3") == "score_consistent_with_completion") "completed" else "unresolved"
}

inventory_record <- function(tour, id, round, p1, p2, winner, raw_score, ref, locator,
                             method, raw_text, compact = FALSE, review = "parsed") {
  bye <- any(toupper(c(p1, p2)) == "BYE")
  score <- inventory_score(raw_score, compact = compact)
  status <- inventory_status(score, bye)
  loser <- if (winner == p1) p2 else if (winner == p2) p1 else NA_character_
  data.frame(tour = tour, event = "Indian Wells", event_year = 2023,
    official_tournament_id = if (tour == "ATP") "404" else "609", draw = "main-draw singles",
    official_id = id, round = inventory_round(round), player_one = p1, player_two = p2,
    winner = winner, loser = loser, normalized_score = score, raw_score = raw_score,
    status = status, bye = bye, played = if (status == "unresolved") NA else !status %in% c("bye", "walkover"),
    retirement = status == "retirement", walkover = status == "walkover",
    reference_id = ref, reference_locator = locator, extraction_method = method,
    review_state = review, raw_text = raw_text, stringsAsFactors = FALSE)
}

inventory_pdf <- function(path) {
  executable <- Sys.getenv("ANOMALY_PDFTOTEXT", unset = "")
  if (!nzchar(executable)) executable <- unname(Sys.which("pdftotext"))
  if (!nzchar(executable)) executable <- path.expand(
    "~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext")
  if (!file.exists(executable)) stop("Existing pdftotext required; no dependency will be installed.")
  xml <- system2(executable, c("-bbox-layout", shQuote(path), "-"), stdout = TRUE)
  if (!is.null(attr(xml, "status"))) stop("PDF extraction failed.")
  pages <- anomaly_matches("(?s)<page .*?</page>", paste(xml, collapse = "\n"))
  if (length(pages) != 2L) stop("Expected exactly two draw pages.")
  lapply(pages, function(p) {
    lines <- anomaly_matches("(?s)<line .*?</line>", p)
    data.frame(x = as.numeric(vapply(lines, function(z) anomaly_capture('xMin="([^"]+)"', z), "")),
      y = as.numeric(vapply(lines, function(z) anomaly_capture('yMin="([^"]+)"', z), "")),
      text = gsub("&apos;", "'", unname(vapply(lines, anomaly_text, "")), fixed = TRUE), stringsAsFactors = FALSE)
  })
}

inventory_atp_pdf <- function(pages) {
  result <- list(); finals <- character(); champion <- character()
  for (page in 1:2) {
    d <- pages[[page]]; d <- d[d$y > 118 & d$y < 610, ]; d <- d[order(d$y, d$x), ]
    roster <- d[d$x > 75 & d$x < 100 & grepl(",|^BYE$", d$text), ]
    if (nrow(roster) != 64L) stop("ATP PDF entrant extraction needs review.")
    entrants <- if (page == 1L) sub("^[A-Z]{3} ", "", roster$text) else roster$text
    prior <- entrants
    for (stage in 1:6) {
      # Measured starts of result columns in the saved PDF, in PDF points.
      if (stage < 5L) {
        left <- c(193, 298, 363, 428)[stage]
        cells <- d[d$x >= left & d$x < left + 1, ]
      } else if (stage == 5L) cells <- d[d$x >= 488 & d$x < 489, ] else
        cells <- d[(d$x > 481 & d$x < 486) | (d$x > 496 & d$x < 497 & d$y > 350 & d$y < 370), ]
      cells <- cells[order(cells$y), ]
      is_score <- grepl("^[0-9]|^WO$", cells$text)
      names <- cells[!is_score, ]; scores <- cells[is_score, ]
      if (nrow(names) != length(prior) / 2L) stop("ATP result column count changed: page ", page, " stage ", stage)
      advancing <- character(nrow(names))
      for (i in seq_len(nrow(names))) {
        pair <- prior[c(2L*i - 1L, 2L*i)]
        selected <- inventory_resolve_name(names$text[i], pair)
        advancing[i] <- if (length(selected) == 1L) pair[selected] else names$text[i]
        bye <- "BYE" %in% pair
        after <- if (i == nrow(names)) Inf else names$y[i+1L]
        score <- scores$text[scores$y > names$y[i] & scores$y < after]
        if (bye && length(score) || !bye && length(score) != 1L) stop("ATP score placement requires review.")
        r <- c("R128", "R64", "R32", "R16", "QF", "SF")[stage]
        locator <- paste0("page ", page, "; result ", r, "; block ", i, "; x=", names$x[i], "; y=", names$y[i])
        result[[length(result)+1L]] <- inventory_record("ATP", paste("ATP-PDF", page, r, i, sep = ":"),
          r, pair[1], pair[2], advancing[i], if (bye) "" else score,
          "atp_draw_pdf", locator, "bbox-layout bracket traversal", paste(c(pair, names$text[i], score), collapse = " | "), TRUE,
          review = if (length(selected) == 1L) "parsed" else "internal PDF identity conflict: winner absent from feeder pair")
      }
      prior <- advancing
    }
    finals[page] <- prior
    ch <- d[d$x > 462 & d$x < 464, ]
    sc <- d[d$x > 495 & d$x < 496, ]
    if (nrow(ch) != 1L || nrow(sc) != 1L) stop("ATP champion box requires review.")
    champion[page] <- ch$text
    if (page == 1) final_score <- sc$text else if (sc$text != final_score) stop("ATP champion boxes disagree.")
  }
  if (length(unique(champion)) != 1L) stop("ATP champion names disagree.")
  win <- inventory_resolve_name(champion[1], finals)
  if (length(win) != 1L) stop("ATP final winner ambiguous.")
  result[[length(result)+1L]] <- inventory_record("ATP", "ATP-PDF:F", "F", finals[1], finals[2], finals[win],
    final_score, "atp_draw_pdf", "champion box on both pages", "bbox-layout champion box; duplicate box verified",
    paste(champion[1], final_score), TRUE)
  do.call(rbind, result)
}

inventory_wta_html <- function(html, pdf) {
  # The first seven round containers are the singles draw; doubles follows.
  sections <- strsplit(html, 'data-round-class-index="', fixed = TRUE)[[1]][-1]
  if (length(sections) < 7L) stop("WTA round containers unavailable.")
  result <- list()
  for (stage in 1:7) {
    section <- sections[stage]
    round <- anomaly_capture('data-round="([^"]+)"', section)
    round <- inventory_round(paste0("R", round))
    blocks <- anomaly_matches('(?s)class="tennis-match tennis-match--slim [^>]*>.*?</table>', section)
    if (length(blocks) != 2^(7-stage)) stop("WTA round cardinality changed: ", stage)
    for (i in seq_along(blocks)) {
      b <- blocks[i]
      id <- anomaly_capture('js-match-0609-2023-(LS[0-9]+)', b)
      if (is.na(id)) id <- paste0("WTA-HTML:", round, ":block", i)
      teams <- lapply(c("a", "b"), function(side) {
        tr <- anomaly_capture(paste0('(?s)(<tr class="match-table__row js-team-', side, '[^>]*>.*?</tr>)'), b)
        if (is.na(tr)) stop("WTA team row missing.")
        name <- anomaly_text(anomaly_capture('(?s)<span class="match-table__player-fullname">(.*?)</span>', tr))
        if (is.na(name) && grepl("BYE", tr, fixed = TRUE)) name <- "BYE"
        slug <- anomaly_capture('href="/players/[0-9]+/([^"/]+)', tr)
        full <- if (is.na(slug)) name else gsub("-", " ", slug, fixed = TRUE)
        cells <- anomaly_matches('(?s)<td class="match-table__score-cell js-score-set-[^>]*>.*?</td>', tr)
        sets <- vapply(cells, function(c) anomaly_text(gsub("(?s)<sup.*?</sup>", "", c, perl = TRUE)), "")
        tb <- vapply(cells, function(c) anomaly_capture('(?s)<sup[^>]*>([0-9]+)</sup>', c), "")
        list(name = name, full = full, sets = unname(sets), tb = unname(tb),
          winner = grepl("is-winner", strsplit(tr, ">", fixed = TRUE)[[1]][1]), raw = anomaly_text(tr))
      })
      bye <- any(vapply(teams, `[[`, "", "name") == "BYE")
      win <- which(vapply(teams, `[[`, TRUE, "winner"))
      if (length(win) != 1L) stop("WTA winner requires review: ", id)
      a <- teams[[win]]; z <- teams[[3L-win]]
      if (length(a$sets) != length(z$sets)) stop("WTA set count conflict: ", id)
      score <- paste(paste0(a$sets, "-", z$sets,
        ifelse(!is.na(z$tb) & z$sets < a$sets, paste0("(", z$tb, ")"),
          ifelse(!is.na(a$tb) & a$sets < z$sets, paste0("(", a$tb, ")"), ""))), collapse = " ")
      if (!length(a$sets)) score <- ""
      if (grepl('title="Walk over"', b, fixed = TRUE)) score <- "WO"
      reference <- "wta_draw_page"
      locator <- paste0("singles ", round, "; block ", i, "; ", id)
      review <- "parsed"
      # Explicit reviewed PDF evidence fills missing retirement markers in HTML.
      if (round == "R64" && a$full %in% c("sorana cirstea", "rebecca peterson")) {
        page <- if (a$full == "sorana cirstea") 1L else 2L
        expected <- if (page == 1L) "61 RET" else "30 RET"
        evidence <- pdf[[page]][pdf[[page]]$text == expected, ]
        if (nrow(evidence) != 1L || inventory_score(expected, compact = TRUE) != paste(score, "RET"))
          stop("Reviewed WTA retirement evidence changed.")
        score <- paste(score, "RET")
        reference <- "wta_draw_page;wta_draw_pdf"
        locator <- paste0(locator, "; PDF page ", page, "; ", expected, "; x=", evidence$x, "; y=", evidence$y)
        review <- "reviewed PDF retirement marker; HTML F alone insufficient"
      }
      if (!grepl('data-status="F"', b, fixed = TRUE)) stop("WTA status attribute changed.")
      result[[length(result)+1L]] <- inventory_record("WTA", id, round,
        teams[[1]]$full, teams[[2]]$full, a$full, score, reference, locator,
        "scoped HTML team/set cells and player-link slugs", paste(vapply(teams, `[[`, "", "raw"), collapse = " | "), review = review)
    }
  }
  do.call(rbind, result)
}

inventory_browser_lines <- function(path) {
  # Browser output can place successive source-line labels on one physical line.
  parts <- unlist(strsplit(gsub(" L([0-9]+): ", "\nL\\1: ", readLines(path, warn = FALSE), perl = TRUE), "\n", fixed = TRUE))
  parts <- parts[grepl("^L[0-9]+: ", parts)]
  numbers <- as.integer(sub("^L([0-9]+):.*", "\\1", parts))
  values <- sub("^L[0-9]+: ", "", parts)
  values <- sub("\n.*", "", values)
  values <- trimws(values)
  unique_pairs <- unique(data.frame(line = numbers, text = values))
  if (anyDuplicated(unique_pairs$line)) stop("Overlapping browser views disagree; review required.")
  unique_pairs <- unique_pairs[order(unique_pairs$line), ]
  unique_pairs$plain <- gsub("\uE200cite\uE202[^\uE201]*?†([^\uE201]*)\uE201", "\\1", unique_pairs$text, perl = TRUE)
  unique_pairs
}

inventory_atp_browser <- function(lines, pdf) {
  start <- which(lines$plain == "####  Final")
  end <- which(lines$plain == "####  2nd Round Qualifying")
  if (length(start) != 1L || length(end) != 1L) stop("ATP main-draw boundaries unavailable.")
  lines <- lines[start:(end-1L), ]
  if (any(diff(lines$line) != 1L)) stop("Missing browser source lines inside ATP main-draw results.")
  starts <- grep("^(Finals|Semi-Finals|Quarter-Finals|Round of [0-9]+) -", lines$plain)
  result <- list()
  for (i in seq_along(starts)) {
    last <- if (i < length(starts)) starts[i+1L]-1L else nrow(lines)
    block <- lines[starts[i]:last, ]
    round <- inventory_round(sub(" -.*", "", block$plain[1]))
    players <- which(grepl("†", block$text, fixed = TRUE) &
      !grepl("Image:|H2H|Stats", block$plain))
    if (length(players) != 2L) stop("ATP browser player parsing failed at line ", block$line[1])
    names <- trimws(sub(" \\([^)]*\\)$", "", block$plain[players]))
    names[toupper(names) == "BYE"] <- "BYE"
    if ("BYE" %in% names) {
      result[[i]] <- inventory_record("ATP", paste0("ATP-RESULTS:L", block$line[1]), round,
        names[1], names[2], names[names != "BYE"], "", "atp_results_browser",
        paste0("browser source lines ", block$line[1], "-", tail(block$line, 1)),
        "saved browser-service result text; explicit bye", paste(block$text, collapse = "\n"))
      next
    }
    read_sets <- function(lo, hi) {
      v <- block$plain[lo:hi]; v <- v[grepl("^[0-9]+( [0-9]+)?$", v)]
      strsplit(v, " ", fixed = TRUE)
    }
    a <- read_sets(players[1]+1L, players[2]-1L)
    b <- read_sets(players[2]+1L, nrow(block))
    if (length(a) != length(b) || !length(a)) stop("ATP browser set parsing failed at ", block$line[1], ": ", paste(block$plain, collapse = " | "))
    score <- paste(vapply(seq_along(a), function(j) {
      loser_tb <- if (as.integer(a[[j]][1]) < as.integer(b[[j]][1])) tail(a[[j]], -1) else tail(b[[j]], -1)
      paste0(a[[j]][1], "-", b[[j]][1], if (length(loser_tb)) paste0("(", loser_tb, ")") else "")
    }, ""), collapse = " ")
    # Results are winner-first in this representation, cross-checked against PDF
    # outcomes. Incomplete results require the PDF's explicit retirement marker.
    candidates <- which(!pdf$bye & pdf$round == round & vapply(seq_len(nrow(pdf)), function(k) {
      p <- c(pdf$player_one[k], pdf$player_two[k])
      length(inventory_resolve_name(names[1], p)) == 1L && length(inventory_resolve_name(names[2], p)) == 1L
    }, logical(1)))
    status <- inventory_status(score)
    if (status == "unresolved") {
      if (length(candidates) != 1L || !pdf$retirement[candidates] ||
          paste(score, "RET") != pdf$normalized_score[candidates]) stop("ATP incomplete result lacks confirmed retirement evidence.")
      score <- paste(score, "RET")
    }
    result[[i]] <- inventory_record("ATP", paste0("ATP-RESULTS:L", block$line[1]), round,
      names[1], names[2], names[1], score, "atp_results_browser",
      paste0("browser source lines ", block$line[1], "-", tail(block$line, 1)),
      "saved browser-service result text; winner-first orientation checked against PDF",
      paste(block$text, collapse = "\n"))
  }
  do.call(rbind, result)
}

inventory_sources <- function() {
  m <- pilot_read_manifest(pilot_config())
  anomaly <- audit_wta_anomaly()$`anomaly-disposition`
  result <- list()
  for (i in seq_len(nrow(m))) {
    rec <- m[i, ]; pilot_validate_file(rec$local_path, rec)
    annual <- pilot_read_csv(rec$local_path)
    path <- paste0("data/pilot/", tolower(rec$tour), "_indian_wells_2023.csv")
    x <- pilot_read_csv(path)
    id <- if (rec$tour == "ATP") "2023-0404" else "2023-609"
    expected <- annual[annual$tourney_id == id, ]
    rownames(x) <- rownames(expected) <- NULL
    if (!identical(x, expected)) stop("Subset no longer matches the annual file cell by cell.")
    state <- pilot_audit_event(x, rec$tour)$rows
    if (rec$tour == "WTA") {
      flags <- intersect(names(state), names(anomaly))
      state[state$match_num == "268", flags] <- anomaly[1, flags]
    }
    result[[rec$tour]] <- cbind(data.frame(tour = rec$tour, event = "Indian Wells", event_year = 2023,
      draw = "main-draw singles", source_id = paste(rec$tour, x$tourney_id, x$match_num, sep = ":"),
      source_tournament_id = x$tourney_id, source_match_number = x$match_num,
      source_winner_id = x$winner_id, source_loser_id = x$loser_id,
      winner = x$winner_name, loser = x$loser_name, raw_round = x$round,
      round = inventory_round(x$round), raw_score = x$score,
      normalized_score = vapply(x$score, inventory_score, ""),
      status = vapply(x$score, function(s) inventory_status(inventory_score(s)), ""),
      source_row_locator = paste0(path, ":CSV-row-", seq_len(nrow(x))+1L), stringsAsFactors = FALSE),
      state[setdiff(names(state), c("tour", "tourney_id", "match_num", "score"))])
  }
  do.call(rbind, result)
}

inventory_key <- function(tour, year, draw, round, a, b) {
  ifelse(is.na(a) | is.na(b) | is.na(round), NA_character_,
    paste(tour, "Indian Wells", year, draw, round, pmin(a, b), pmax(a, b), sep = "|"))
}

inventory_link_identities <- function(official, source) {
  decisions <- list()
  for (tour in c("ATP", "WTA")) {
    s <- source[source$tour == tour, ]
    roster <- unique(rbind(data.frame(id = s$source_winner_id, name = s$winner),
      data.frame(id = s$source_loser_id, name = s$loser)))
    if (anyDuplicated(roster$id)) stop("Source identity maps to multiple names; review required.")
    names <- unique(unlist(official[official$tour == tour, c("player_one", "player_two", "winner", "loser")]))
    names <- names[!is.na(names) & toupper(names) != "BYE"]
    for (name in names) {
      lookup <- name
      # Reviewed event-local alias; retain both labels and never change source bytes.
      alias <- tour == "ATP" && inventory_name(name) == "albert ramos vinolas"
      if (alias) lookup <- "Albert Ramos"
      matches <- inventory_resolve_name(lookup, roster$name)
      decisions[[length(decisions)+1L]] <- data.frame(tour = tour, official_name = name,
        normalized_name = inventory_name(name), candidates = paste(roster$name[matches], collapse = ";"),
        source_player_id = if (length(matches) == 1L) roster$id[matches] else NA_character_,
        resolution = if (length(matches) == 1L) "unique" else if (length(matches)) "ambiguous" else "unmatched",
        method = if (alias) "reviewed alias: ATP Ramos-Vinolas / Sackmann Ramos; unique given name, opponent and round corroboration" else
          if (length(matches) == 1L && gsub(" ", "", inventory_name(name)) == gsub(" ", "", inventory_name(roster$name[matches])))
          "full-name normalization; compare joined tokens for spaced initials/transliteration" else "initial/prefix plus full remaining surname; unique event roster required",
        stringsAsFactors = FALSE)
    }
  }
  decisions <- do.call(rbind, decisions)
  map <- function(names) decisions$source_player_id[match(paste(official$tour, names), paste(decisions$tour, decisions$official_name))]
  official$player_one_id <- map(official$player_one)
  official$player_two_id <- map(official$player_two)
  official$winner_id <- map(official$winner)
  official$loser_id <- map(official$loser)
  official$identity_unresolved <- !official$bye & (is.na(official$player_one_id) |
    is.na(official$player_two_id) | is.na(official$winner_id) | is.na(official$loser_id))
  list(official = official, decisions = decisions)
}

inventory_match <- function(official, source) {
  official <- official[!official$bye, ]
  ok <- with(official, inventory_key(tour, event_year, draw, round, player_one_id, player_two_id))
  sk <- with(source, inventory_key(tour, event_year, draw, round, source_winner_id, source_loser_id))
  duplicates <- function(k) !is.na(k) & (duplicated(k) | duplicated(k, fromLast = TRUE))
  od <- duplicates(ok); sd <- duplicates(sk)
  official$disposition <- ifelse(official$identity_unresolved, "identity_ambiguous", "official_only")
  source$disposition <- rep("source_only", nrow(source))
  source$disposition[sd] <- "identity_ambiguous"
  links <- list()
  for (i in seq_len(nrow(official))) {
    j <- if (is.na(ok[i])) integer() else which(!is.na(sk) & sk == ok[i])
    if (od[i] || length(j) > 1L || any(sd[j])) {
      official$disposition[i] <- "identity_ambiguous"
      if (length(j)) source$disposition[j] <- "identity_ambiguous"
      next
    }
    if (length(j) != 1L || official$identity_unresolved[i]) next
    conflicts <- c(if (official$winner_id[i] != source$source_winner_id[j]) "winner",
      if (official$loser_id[i] != source$source_loser_id[j]) "loser",
      if (!identical(official$normalized_score[i], source$normalized_score[j])) "score",
      if (!identical(official$status[i], source$status[j])) "status",
      if (!is.na(official$played[i]) && official$played[i] != source$included_in_played_denominator[j]) "played")
    exact <- official$winner[i] == source$winner[j] && official$loser[i] == source$loser[j] &&
      official$raw_score[i] == source$raw_score[j] && official$round[i] == source$raw_round[j]
    disposition <- if (official$status[i] == "unresolved" || source$status[j] == "unresolved") "status_unresolved" else
      if (length(conflicts)) "matched_with_conflict" else if (isTRUE(exact)) "matched_exact" else "matched_normalized"
    official$disposition[i] <- source$disposition[j] <- disposition
    links[[length(links)+1L]] <- data.frame(tour = official$tour[i], official_id = official$official_id[i],
      source_id = source$source_id[j], round = official$round[i], disposition = disposition,
      conflicts = paste(conflicts, collapse = ";"), official_raw_score = official$raw_score[i],
      source_raw_score = source$raw_score[j], official_normalized_score = official$normalized_score[i],
      source_normalized_score = source$normalized_score[j], official_winner = official$winner[i], source_winner = source$winner[j],
      reference_id = official$reference_id[i], reference_locator = official$reference_locator[i], stringsAsFactors = FALSE)
  }
  links <- if (length(links)) do.call(rbind, links) else data.frame(tour = character(), official_id = character(),
    source_id = character(), round = character(), disposition = character(), conflicts = character())
  if (anyDuplicated(links$official_id) || anyDuplicated(links$source_id)) stop("Duplicate accepted links.")
  list(official = official, source = source, links = links, duplicate_candidates = c(sum(od), sum(sd)))
}

inventory_atp_draw_check <- function(lines, results) {
  starts <- which(lines$plain %in% c("Round of 128", "Round of 64", "Round of 32", "Round of 16",
    "Quarter-Finals", "Semi-Finals", "Finals"))
  if (length(starts) != 7L) stop("ATP browser draw round headings changed.")
  checks <- list()
  for (stage in 1:7) {
    end <- if (stage < 7L) starts[stage+1L]-1L else which(lines$line == 2612L)
    d <- lines[starts[stage]:end, ]
    if (any(diff(d$line) != 1L)) stop("Missing browser draw source lines.")
    round <- inventory_round(d$plain[1])
    ends <- grep("^H2H", d$plain)
    if (length(ends) != 2^(7-stage)) stop("ATP browser draw match count changed.")
    prior <- 1L
    for (i in seq_along(ends)) {
      b <- d[prior:ends[i], ]; prior <- ends[i]+1L
      player_rows <- which((grepl("†", b$text, fixed = TRUE) & !grepl("Image:|H2H|Stats", b$plain)) | trimws(b$plain) == "Bye")
      if (length(player_rows) != 2L) stop("ATP draw player extraction requires review.")
      names <- trimws(sub(" \\([^)]*\\)$", "", b$plain[player_rows])); names[toupper(names) == "BYE"] <- "BYE"
      candidates <- which(results$round == round & vapply(seq_len(nrow(results)), function(k) {
        pair <- c(results$player_one[k], results$player_two[k])
        length(inventory_resolve_name(names[1], pair)) == 1L && length(inventory_resolve_name(names[2], pair)) == 1L
      }, TRUE))
      if (length(candidates) != 1L) stop("ATP result/draw player pair conflict: ", paste(names, collapse = " / "))
      r <- results[candidates, ]
      get_sets <- function(lo, hi) {
        s <- b$plain[lo:hi]; strsplit(s[grepl("^[0-9]+( [0-9]+)?$", s)], " ", fixed = TRUE)
      }
      a <- get_sets(player_rows[1]+1L, player_rows[2]-1L)
      z <- get_sets(player_rows[2]+1L, nrow(b))
      if (length(a) != length(z)) stop("ATP draw score lengths conflict.")
      if (!r$bye && length(inventory_resolve_name(names[1], r$winner)) != 1L) {tmp <- a; a <- z; z <- tmp}
      score <- paste(vapply(seq_along(a), function(j) {
        tb <- if (as.integer(a[[j]][1]) < as.integer(z[[j]][1])) tail(a[[j]], -1) else tail(z[[j]], -1)
        paste0(a[[j]][1], "-", z[[j]][1], if (length(tb)) paste0("(", tb, ")") else "")
      }, ""), collapse = " ")
      expected <- if (r$bye) "" else sub(" RET$", "", r$normalized_score)
      checks[[length(checks)+1L]] <- data.frame(reference_id = "atp_draw_browser", official_id = r$official_id,
        round = round, locator = paste0("browser source lines ", b$line[1], "-", tail(b$line, 1)),
        check = "unordered pair and winner-oriented set values versus results; retirement marker checked in PDF",
        observed = paste(names, collapse = " / "), expected = paste(r$player_one, r$player_two, collapse = " / "),
        score_observed = score, score_expected = expected, passed = identical(score, expected), stringsAsFactors = FALSE)
    }
  }
  do.call(rbind, checks)
}

inventory_pdf_crosscheck <- function(pdf, official) {
  checks <- list()
  for (i in seq_len(nrow(pdf))) {
    p <- pdf[i, ]
    candidates <- which(official$round == p$round & vapply(seq_len(nrow(official)), function(j) {
      pair <- c(official$player_one[j], official$player_two[j])
      length(inventory_resolve_name(p$player_one, pair)) == 1L && length(inventory_resolve_name(p$player_two, pair)) == 1L
    }, TRUE))
    j <- if (length(candidates) == 1L) candidates else NA_integer_
    matches <- !is.na(j) && length(inventory_resolve_name(p$winner, official$winner[j])) == 1L &&
      identical(p$normalized_score, official$normalized_score[j]) && identical(p$status, official$status[j])
    checks[[i]] <- data.frame(reference_id = "atp_draw_pdf", official_id = if (is.na(j)) "" else official$official_id[j],
      round = p$round, locator = p$reference_locator, check = "PDF feeder pair, winner, score and status versus results",
      observed = paste(p$player_one, p$player_two, p$winner, sep = " / "),
      expected = if (is.na(j)) "unmatched PDF pair; requires source-precedence review" else paste(official$player_one[j], official$player_two[j], official$winner[j], sep = " / "),
      score_observed = p$normalized_score, score_expected = if (is.na(j)) NA_character_ else official$normalized_score[j],
      passed = matches, stringsAsFactors = FALSE)
  }
  do.call(rbind, checks)
}

inventory_wta_roster_check <- function(pages, official) {
  roster <- do.call(rbind, lapply(seq_along(pages), function(i) {
    d <- pages[[i]]; d <- d[d$y > 75 & d$y < 650 & d$x < 100 & grepl(",|^Bye$", d$text), ]
    d <- d[order(d$y), ]; if (nrow(d) != 64L) stop("WTA PDF roster count changed.")
    data.frame(position = (i-1L)*64L + seq_len(64), page = i, y = d$y,
      name = sub("^[0-9]+ ", "", d$text), raw_text = d$text)
  }))
  first <- official[official$round == "R128", ]
  html_names <- as.vector(t(as.matrix(first[c("player_one", "player_two")])))
  if (length(html_names) != 128L) stop("WTA HTML draw positions changed.")
  passed <- mapply(function(n, h) {
    length(inventory_resolve_name(n, h)) == 1L
  }, roster$name, html_names)
  data.frame(reference_id = "wta_draw_pdf", official_id = rep(first$official_id, each = 2), round = "R128",
    locator = paste0("page ", roster$page, "; draw position ", roster$position, "; y=", roster$y),
    check = "PDF entrant/bye versus HTML draw position", observed = roster$name, expected = html_names,
    score_observed = "", score_expected = "", passed = passed, stringsAsFactors = FALSE)
}

reconcile_indian_wells_inventory <- function() {
  refs <- inventory_reference_manifest()
  get <- function(id) refs$local_path[match(id, refs$reference_id)]
  atp_pdf <- inventory_atp_pdf(inventory_pdf(get("atp_draw_pdf")))
  atp <- inventory_atp_browser(inventory_browser_lines(get("atp_results_browser")), atp_pdf)
  atp_draw <- inventory_atp_draw_check(inventory_browser_lines(get("atp_draw_browser")), atp)
  pdf_checks <- inventory_pdf_crosscheck(atp_pdf, atp)
  wta_pdf <- inventory_pdf(get("wta_draw_pdf"))
  wta <- inventory_wta_html(anomaly_html(get("wta_draw_page")), wta_pdf)
  wta_checks <- inventory_wta_roster_check(wta_pdf, wta)
  ls033 <- anomaly_wta_card(anomaly_html(get("wta_match")))
  target <- wta[wta$official_id == "LS033", ]
  ls_check <- data.frame(reference_id = "wta_match", official_id = "LS033", round = "R64",
    locator = "LS033 team a/b; data-completed=true; data-status=F",
    check = "saved Phase 1B card result agrees; scheduled JSON-LD remains separate unresolved metadata",
    observed = ls033$score, expected = target$normalized_score,
    score_observed = ls033$score, score_expected = target$normalized_score,
    passed = ls033$score == target$normalized_score && ls033$winner_side == 2L)
  references <- rbind(atp_draw, pdf_checks, wta_checks, ls_check)
  if (!all(atp_draw$passed) || !all(wta_checks$passed) || !ls_check$passed) stop("Official reference check changed; review before export.")
  source <- inventory_sources()
  identities <- inventory_link_identities(rbind(atp, wta), source)
  matched <- inventory_match(identities$official, source)
  # Four observed PDF contradictions are retained; no PDF/source identity repair
  # or approved exception is inferred from agreement of the other two pages.
  conflicts <- references[!references$passed, ]
  if (nrow(conflicts)) {
    expected_locators <- c("page 1; result R128; block 8", "page 1; result R128; block 30",
      "page 1; result R64; block 4", "page 1; result R64; block 15")
    if (nrow(conflicts) != 4L || !all(vapply(expected_locators, function(x) any(startsWith(conflicts$locator, x)), TRUE)))
      stop("New official PDF conflicts require explicit review.")
    affected <- matched$links$tour == "ATP" & (
      matched$links$round == "R128" & matched$links$official_winner == "Stan Wawrinka" |
      matched$links$round == "R64" & matched$links$official_winner %in% c("Andy Murray", "Stan Wawrinka"))
    if (sum(affected) != 3L) stop("ATP affected branch locators changed.")
    matched$links$conflicts[affected] <- ifelse(nzchar(matched$links$conflicts[affected]),
      paste0(matched$links$conflicts[affected], ";official_reference_identity_conflict"), "official_reference_identity_conflict")
    matched$links$disposition[affected] <- "matched_with_conflict"
    matched$official$disposition[matched$official$official_id %in% matched$links$official_id[affected]] <- "matched_with_conflict"
    matched$source$disposition[matched$source$source_id %in% matched$links$source_id[affected]] <- "matched_with_conflict"
  }
  all_official <- identities$official
  all_official$disposition <- "bye_not_a_match"
  all_official$disposition[!all_official$bye] <- matched$official$disposition[match(
    all_official$official_id[!all_official$bye], matched$official$official_id)]
  summary <- list(); rounds <- list(); statuses <- list()
  for (tour in c("ATP", "WTA")) {
    o <- all_official[all_official$tour == tour, ]; n <- o[!o$bye, ]
    s <- matched$source[matched$source$tour == tour, ]; links <- matched$links[matched$links$tour == tour, ]
    ref_conflicts <- if (tour == "ATP") nrow(conflicts) else 0L
    unresolved <- sum(n$status == "unresolved") + sum(s$status == "unresolved")
    ambiguous <- sum(n$disposition == "identity_ambiguous") + sum(s$disposition == "identity_ambiguous")
    missing <- sum(n$disposition == "official_only") + sum(s$disposition == "source_only")
    duplicates <- sum(duplicated(links$official_id)) + sum(duplicated(links$source_id))
    gate <- nrow(links) == nrow(n) && nrow(links) == nrow(s) &&
      unresolved == 0L && ambiguous == 0L && missing == 0L && duplicates == 0L &&
      !any(links$disposition == "matched_with_conflict") && ref_conflicts == 0L
    denom <- sum(n$played, na.rm = TRUE)
    valid <- sum(s$included_in_valid_numerator)
    summary[[tour]] <- data.frame(tour = tour, draw_positions = 2L*sum(o$round == "R128"),
      byes = sum(o$bye), entrants = 2L*sum(o$round == "R128")-sum(o$bye), official_non_bye = nrow(n),
      played = denom, walkovers = sum(n$walkover), retirements = sum(n$retirement), source_rows = nrow(s),
      exact = sum(links$disposition == "matched_exact"), normalized = sum(links$disposition == "matched_normalized"),
      matched_conflicts = sum(links$disposition == "matched_with_conflict"), official_only = sum(n$disposition == "official_only"),
      source_only = sum(s$disposition == "source_only"), ambiguous_identities = ambiguous, unresolved_statuses = unresolved,
      duplicate_links = duplicates, official_reference_conflicts = ref_conflicts,
      linked_matches = nrow(links), recall_denominator = nrow(n), recall_pct = 100*nrow(links)/nrow(n),
      precision_denominator = nrow(s), precision_pct = 100*nrow(links)/nrow(s),
      inventory_gate = if (gate) "PASS" else if (ref_conflicts) "BLOCKED_OFFICIAL_REFERENCE_CONFLICT" else "BLOCKED_RECONCILIATION",
      aggregate_source_coverage = if (nrow(links) == nrow(n) && !missing) "COMPLETE_AGAINST_RESULT_INVENTORY" else "INCOMPLETE",
      jointly_present_played = sum(s$required_fields_present & s$included_in_played_denominator),
      joint_complete_pct = 100*sum(s$required_fields_present & s$included_in_played_denominator)/denom,
      structural_valid_played = sum(s$structural_checks_passed & s$included_in_played_denominator),
      structural_invalid_played = sum(s$required_fields_present & !s$structural_checks_passed & s$included_in_played_denominator),
      valid_numerator = valid, valid_pct = 100*valid/denom,
      event_90pct_numerical = if (valid/denom >= .90) "PASS_NUMERICAL_ONLY" else "FAIL",
      event_factor_data_gate = if (gate) "NOT_ADMITTED_RETIREMENT_POLICY" else "NOT_ADMITTED_INVENTORY_AND_RETIREMENT",
      tour_season_95pct = "NOT_TESTED", rating_readiness = "BLOCKED_CHRONOLOGY_AND_STATUS_POLICY",
      forecast_readiness = "BLOCKED_CHRONOLOGY_AND_STATUS_POLICY", stringsAsFactors = FALSE)
    rounds[[tour]] <- do.call(rbind, lapply(c("R128", "R64", "R32", "R16", "QF", "SF", "F"), function(r)
      data.frame(tour = tour, round = r, official_non_bye = sum(n$round == r), source_rows = sum(s$round == r),
        official_byes = sum(o$round == r & o$bye), linked = sum(links$round == r))))
    statuses[[tour]] <- do.call(rbind, lapply(c("completed", "retirement", "walkover", "unresolved", "bye"), function(st)
      data.frame(tour = tour, status = st, official_rows = sum(o$status == st), source_rows = sum(s$status == st))))
  }
  normalization <- data.frame(kind = "identity", tour = identities$decisions$tour,
    locator = identities$decisions$official_name, raw_value = identities$decisions$official_name,
    normalized_value = identities$decisions$candidates, rule = identities$decisions$method,
    review_state = identities$decisions$resolution, stringsAsFactors = FALSE)
  normalization <- rbind(normalization, data.frame(kind = "score", tour = all_official$tour,
    locator = all_official$reference_locator, raw_value = all_official$raw_text,
    normalized_value = all_official$normalized_score,
    rule = "preserve set order and tie-break losing points; winner orientation; explicit WO/RET; no empty-to-completed conversion",
    review_state = all_official$review_state))
  manual <- data.frame(kind = "manual_review", tour = c("ATP", "ATP", "WTA", "WTA", "WTA", "WTA", "ATP"),
    locator = c("PDF page 1 positions 15-16 / R64 block 4", "PDF page 1 positions 59-60 / R64 block 15",
      "PDF page 1 positions 21-24; HTML LS037", "PDF page 2 positions 105-108; HTML LS058",
      "PDF page 2 R32 Tsurenko-Sabalenka; HTML R32 block 16", "PDF both champion boxes; HTML LS001",
      "PDF both halves: first rounds, four Ret'd cells, QF/SF and champion boxes"),
    raw_value = c("Carreño Busta versus Albot", "Kudla versus Wawrinka", "61 RET", "30 RET", "WO; no HTML match ID",
      "PDF released 17 Mar 2023 7:49 PM; blank final result", "Selected page images visually inspected"),
    normalized_value = c("no identity substitution approved", "no identity substitution approved", "6-1 RET", "3-0 RET",
      "walkover; unplayed; retain as inventory match", "final obtained from saved HTML, not inferred from blank PDF", "parser geometry and scores checked"),
    rule = c(rep("Preserve contradictory official records; defer source precedence to user", 2),
      rep("PDF explicit status supplies HTML's absent marker", 2), "scoped round/player card plus PDF corroboration",
      "document version controls evidence scope", "visual spot checks; not independent measurement"),
    review_state = c(rep("reviewed; user decision required", 2), rep("reviewed", 5)))
  normalization <- rbind(normalization, manual)
  outputs <- list(`official-matches` = all_official, `source-matches` = matched$source,
    `match-reconciliation` = matched$links,
    `official-only` = matched$official[matched$official$disposition == "official_only", ],
    `source-only` = matched$source[matched$source$disposition == "source_only", ],
    conflicts = matched$links[matched$links$disposition %in% c("matched_with_conflict", "status_unresolved"), ],
    `identity-review` = identities$decisions, `status-summary` = do.call(rbind, statuses),
    `inventory-summary` = do.call(rbind, summary), `normalization-decisions` = normalization,
    `round-summary` = do.call(rbind, rounds), `reference-comparison` = references,
    `reference-conflicts` = conflicts, `atp-pdf-observations` = atp_pdf)
  outputs$`inventory-summary`$reference_manifest_sha256 <- pilot_sha256("data/manifests/inventory-reference-files.csv")
  outputs$`inventory-summary`$pilot_manifest_sha256 <- pilot_sha256("data/manifests/pilot-source-files.csv")
  if (anyNA(all_official$disposition) || anyNA(matched$source$disposition) ||
      anyDuplicated(all_official$official_id) || anyDuplicated(matched$source$source_id)) stop("Disposition/identifier contract failed.")
  q <- matched$source[matched$source$source_id == "WTA:2023-609:268", ]
  stopifnot(nrow(q) == 1L, q$statistical_bundle_quarantined, q$included_in_event_inventory,
    q$included_in_played_denominator, !q$included_in_valid_numerator, !q$eligible_for_factor_analysis,
    grepl("chronology_unresolved", q$reason_codes, fixed = TRUE))
  dir.create("data/pilot/inventory", recursive = TRUE, showWarnings = FALSE)
  for (name in names(outputs)) pilot_write_csv(outputs[[name]], paste0("data/pilot/inventory/", name, ".csv"))
  print(outputs$`inventory-summary`[c("tour", "official_non_bye", "linked_matches", "matched_conflicts", "inventory_gate")], row.names = FALSE)
  invisible(outputs)
}

inventory_self_test <- function(outputs) {
  o <- outputs$`official-matches`; s <- outputs$`source-matches`
  first <- outputs$`match-reconciliation`[1, ]
  a <- o[o$official_id == first$official_id, ]; b <- s[s$source_id == first$source_id, ]
  clean <- inventory_match(a, b)
  stopifnot(nrow(clean$links) == 1L)
  swap <- a
  swap$player_one_id <- a$player_two_id; swap$player_two_id <- a$player_one_id
  stopifnot(nrow(inventory_match(swap, b)$links) == 1L)
  reverse <- a; reverse$winner_id <- a$loser_id; reverse$loser_id <- a$winner_id
  reverse$normalized_score <- inventory_score(a$normalized_score, reverse = TRUE)
  stopifnot(inventory_match(reverse, b)$links$disposition == "matched_with_conflict")
  bad_score <- a; bad_score$normalized_score <- "6-0 6-0"
  stopifnot(inventory_match(bad_score, b)$links$disposition == "matched_with_conflict")
  stopifnot(inventory_name("  García, José-Luis ") == "jose luis garcia",
    length(inventory_resolve_name("J.J. Wolf", "J J Wolf")) == 1L,
    length(inventory_resolve_name("Xin Yu Wang", "Xinyu Wang")) == 1L,
    length(inventory_resolve_name("Xiyu Wang", "Xinyu Wang")) == 0L,
    length(inventory_resolve_name("J. Smith", c("John Smith", "James Smith"))) == 2L,
    length(inventory_resolve_name("Smith", c("John Smith", "James Smith"))) == 0L,
    inventory_name("O’Connell, Christopher") == "christopher oconnell")
  stopifnot(identical(inventory_round(c("Round of 64", "Semi-Finals", "F")), c("R64", "SF", "F")),
    inventory_score("76(5) 32 Ret'd", compact = TRUE) == "7-6(5) 3-2 RET",
    inventory_score("7 – 6 (5) 6-3") == "7-6(5) 6-3",
    inventory_score("6-7(5) 3-6", reverse = TRUE) == "7-6(5) 6-3",
    inventory_score("W/O") == "WO", is.na(inventory_score("")),
    inventory_status("", TRUE) == "bye", inventory_status("WO") == "walkover",
    inventory_status("3-0 RET") == "retirement", inventory_status("3-0") == "unresolved",
    inventory_score("7-6(5) 6-3") != inventory_score("7-6(6) 6-3"))
  empty <- inventory_match(a, b[FALSE, ])
  stopifnot(empty$official$disposition == "official_only")
  empty <- inventory_match(a[FALSE, ], b)
  stopifnot(empty$source$disposition == "source_only")
  duplicated_source <- rbind(b, b); duplicated_source$source_id[2] <- "test-only-duplicate"
  duplicate <- inventory_match(a, duplicated_source)
  stopifnot(!nrow(duplicate$links), duplicate$official$disposition == "identity_ambiguous",
    all(duplicate$source$disposition == "identity_ambiguous"))
  duplicate_official <- rbind(a, a); duplicate_official$official_id[2] <- "test-only-official-duplicate"
  stopifnot(!nrow(inventory_match(duplicate_official, b)$links))
  ambiguous <- a; ambiguous$player_one_id <- NA_character_; ambiguous$identity_unresolved <- TRUE
  stopifnot(inventory_match(ambiguous, b)$official$disposition == "identity_ambiguous")
  unknown <- a; unknown$status <- "unresolved"; unknown$played <- NA
  stopifnot(inventory_match(unknown, b)$links$disposition == "status_unresolved")
  bye <- a; bye$bye <- TRUE
  stopifnot(!nrow(inventory_match(bye, b[FALSE, ])$official))
  message("Inventory in-memory tests passed: pair symmetry, orientation, names, rounds, scores, statuses, conflicts, unmatched and duplicate/ambiguous identities.")
  invisible(TRUE)
}

if (sys.nframe() == 0L) {
  output <- reconcile_indian_wells_inventory()
  if ("--self-test" %in% commandArgs(trailingOnly = TRUE)) inventory_self_test(output)
}
