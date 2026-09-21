# Phase 1N: evidence and a proposal only; no operational chronology or models.
# Historical reproduction: proposal-era states intentionally remain unchanged.
# Current approval is recorded in docs/wta-2021-montreal-chronology-policy.md.
source("R/audit_montreal_completed_match_coverage.R")

mnc_dir <- function() "data/pilot/development-2021/montreal-chronology-evidence"
mnc_need <- function(ok, reason) {
  if (!isTRUE(ok)) stop("Montreal chronology evidence withheld: ",reason,call.=FALSE)
}
mnc_policy <- function() data.frame(version="0.1.0",status="PROPOSED_NOT_APPROVED",
  decision=paste0("D",1:13),approval="PENDING_USER_APPROVAL",implemented=FALSE)

mnc_match_metadata <- function(html, code) {
  blocks <- anomaly_matches('(?s)<script type="application/ld\\+json">.*?</script>',html)
  blocks <- blocks[grepl(paste0('"value": "',code,'"'),blocks,fixed=TRUE)]
  mnc_need(length(blocks)==1,"missing/duplicate exact match SportsEvent block")
  block <- blocks[1]
  for (field in c("startDate","endDate","eventStatus"))
    mnc_need(length(anomaly_matches(paste0('"',field,'"\\s*:'),block))==1,
      paste("missing/duplicate metadata field",field))
  md <- mrf_metadata(html,code); card <- mrf_card(html,code)
  mnc_need(all(grepl("^2021-[0-9]{2}-[0-9]{2}$",c(md$date,md$end_date))) &&
    !anyNA(as.Date(c(md$date,md$end_date))) && md$date<=md$end_date,
    "published date precision, year or interval changed")
  mnc_need(md$json_status=="http://schema.org/EventScheduled" &&
    card$completed=="true" && card$status=="F","finished/scheduled evidence changed")
  # New timing fields need semantic review, not an automatic upgrade to actual time.
  mnc_need(!grepl('"(startTime|endTime|actualStartDate|actualEndDate|timeZone|timezone|suspendedAt|resumedAt)"',block),
    "new timing semantics require review")
  data.frame(official_code=code,published_start_date=md$date,published_end_date=md$end_date,
    published_status=md$json_status,finished_card=TRUE,published_duration=md$duration,
    metadata_locator=md$locator,precision="day",timezone_state="NOT_ESTABLISHED",
    semantic_role="published_SportsEvent_dates_scheduling_or_play_semantics_unverified",
    verification_state="verified_literal_not_verified_actual_time")
}

mnc_extract <- function(base) {
  refs <- base$evidence$refs
  getref <- function(id) refs[refs$reference_id==id,,drop=FALSE]
  overview <- anomaly_html(getref("overview")$local_path)
  window <- unique(trimws(anomaly_matches("Aug [0-9]+ - Aug [0-9]+, 2021",overview)))
  pdf <- mrf_pdf_lines(getref("draw_pdf")$local_path)
  header <- pdf[pdf$y<90 & grepl("^August [0-9]+-[0-9]+ 2021$",pdf$text),,drop=FALSE]
  mnc_need(length(window)==1 && nrow(header)==1,"event-window evidence missing or ambiguous")
  source_date <- unique(base$evidence$source$selected$raw$tourney_date)
  mnc_need(identical(source_date,"20210809") && window=="Aug 9 - Aug 15, 2021" &&
    header$text=="August 7-15 2021","event labels differ from the reviewed baseline; retain discrepancy for review")
  event <- data.frame(reference_id=c("annual_source","overview","draw_pdf"),
    field=c("tourney_date","published_event_window","published_event_window"),
    value=c(source_date,window,header$text),
    semantic_role=c("event_week_label_not_match_date",rep("published_event_window_not_match_date",2)),
    locator=c("WTA 2021-806 source rows; tourney_date","displayed tournament overview date range",
      paste0("PDF p1 header TOURNAMENT DATES; x=",header$x,"; y=",header$y)),
    source_path=c(base$overlay$source_manifest$local_path,getref("overview")$local_path,getref("draw_pdf")$local_path),
    sha256=c(base$overlay$source_manifest$sha256,getref("overview")$sha256,getref("draw_pdf")$sha256),
    retrieved_at_utc=c(base$overlay$source_manifest$retrieved_at_utc,getref("overview")$retrieved_at_utc,getref("draw_pdf")$retrieved_at_utc),
    precision=c("event_week","date_range","date_range"),timezone_state="NOT_ESTABLISHED",
    verification_state="verified_literal_not_actual_match_timing")
  target <- mro_targets(); pages <- list()
  mnc_need(setequal(refs$reference_id[nzchar(refs$match_code)],target$code),"saved match-page scope changed")
  for (i in seq_len(nrow(target))) {
    code <- target$code[i]; ref <- getref(code); html <- anomaly_html(ref$local_path)
    z <- mnc_match_metadata(html,code)
    z$source_audit_id <- target$audit_id[i]
    li <- base$inventory$links[base$inventory$links$source_audit_id==z$source_audit_id,,drop=FALSE]
    raw <- base$evidence$source$selected$raw
    row <- raw[paste0("sackmann:WTA:2021-806:",raw$match_num)==z$source_audit_id,,drop=FALSE]
    mnc_need(nrow(li)==1 && nrow(row)==1 && li$official_code==code &&
      mrf_identity(mrf_card(html,code),row,li$round),"match-page identity, round, winner or score changed")
    z$round <- li$round; z$source_path <- ref$local_path; z$sha256 <- ref$sha256
    z$retrieved_at_utc <- ref$retrieved_at_utc
    pages[[i]] <- z
  }
  pages <- do.call(rbind,pages); rownames(pages) <- NULL
  mnc_need(setequal(pages$published_start_date,c("2021-08-09","2021-08-13","2021-08-14","2021-08-15")) &&
    all(pages$published_start_date==pages$published_end_date),"published date observations changed")
  qf <- pages[pages$round=="QF",]
  mnc_need(nrow(qf)==4 && qf$published_start_date[qf$official_code=="LS007"]=="2021-08-14" &&
    all(qf$published_start_date[qf$official_code!="LS007"]=="2021-08-13"),"quarterfinal date difference changed")
  list(events=event,pages=pages)
}

mnc_load <- function() {
  base <- mmc_load()
  mnc_need(base$inventory$state=="COMPLETE" && all(base$inventory$criteria$passed),"inventory unresolved")
  list(base=base,timing=mnc_extract(base))
}
mnc_validate_inputs <- function(input,current=mnc_load()) {
  mnc_need(identical(input,current),"fingerprint, linkage, observation or locator differs from freshly validated evidence")
  invisible(TRUE)
}

mnc_edges <- function(base) {
  inv <- base$inventory; links <- inv$links; raw <- base$evidence$source$selected$raw
  h <- mji_attach_ids(inv$html,inv$identities); p <- mji_attach_ids(inv$pdf,inv$identities)
  mnc_need(mji_bracket(h) && mji_bracket(p),"invalid official bracket progression")
  out <- list()
  for (i in seq_len(nrow(links))) {
    a <- links[i,]; k <- match(a$round,mji_rounds())
    mnc_need(!is.na(k),"unknown round")
    if (k==length(mji_rounds())) next
    hr <- h[h$record_id==a$html_record_id,]; pr <- p[p$record_id==a$pdf_record_id,]
    hn <- h[h$round==mji_rounds()[k+1] & h$bracket_position==ceiling(hr$bracket_position/2),]
    pn <- p[p$round==mji_rounds()[k+1] & p$bracket_position==ceiling(pr$bracket_position/2),]
    mnc_need(nrow(hr)==1 && nrow(pr)==1 && nrow(hn)==1 && nrow(pn)==1 &&
      hn$match_key==pn$match_key,"ambiguous or contradictory feeder relation")
    next_link <- links[links$match_key==hn$match_key,,drop=FALSE]
    mnc_need(nrow(next_link)==1 && next_link$html_record_id==hn$record_id &&
      next_link$pdf_record_id==pn$record_id,"next result linkage missing")
    next_raw <- raw[paste0("sackmann:WTA:2021-806:",raw$match_num)==next_link$source_audit_id,]
    mnc_need(nrow(next_raw)==1 && a$source_winner %in% c(next_raw$winner_id,next_raw$loser_id),
      "progression does not share the advancing player")
    out[[length(out)+1]] <- data.frame(player_id=a$source_winner,from_audit_id=a$source_audit_id,
      to_audit_id=next_link$source_audit_id,from_round=a$round,to_round=next_link$round,
      html_from_locator=hr$locator,html_to_locator=hn$locator,pdf_from_locator=pr$locator,pdf_to_locator=pn$locator,
      html_sha256=hr$reference_sha256,pdf_sha256=pr$reference_sha256,
      evidence_role="same_player_bracket_advancement_precedence_only",
      establishes_date=FALSE,establishes_time=FALSE,establishes_result_publication_time=FALSE,
      operational_order_implemented=FALSE)
  }
  edges <- do.call(rbind,out)
  edges <- edges[order(edges$player_id,edges$from_audit_id,edges$to_audit_id),];rownames(edges)<-NULL
  mnc_need(!anyDuplicated(edges[c("player_id","from_audit_id","to_audit_id")]),"duplicate edges")
  edges
}

mnc_derive <- function(input) {
  coverage <- mmc_derive(input$base); d <- coverage$dispositions
  d <- d[order(d$source_audit_id),];rownames(d)<-NULL
  pages <- input$timing$pages; event <- input$timing$events
  mnc_need(!anyDuplicated(pages$official_code) && !anyDuplicated(pages$source_audit_id) &&
    setequal(pages$official_code,mro_targets()$code) &&
    setequal(pages$source_audit_id,mro_targets()$audit_id),"missing, duplicate or unauthorized page evidence")
  mnc_need(!anyDuplicated(event$reference_id) && nrow(event)==3,"duplicate/missing event observations")
  edges <- mnc_edges(input$base)
  row <- match(d$source_audit_id,pages$source_audit_id)
  dispositions <- d[c("source_audit_id","official_code","round","classification","included_in_completed_denominator")]
  dispositions$source_event_week_date <- event$value[event$reference_id=="annual_source"]
  dispositions$published_start_date <- pages$published_start_date[row]
  dispositions$published_end_date <- pages$published_end_date[row]
  dispositions$published_status <- pages$published_status[row]
  dispositions$published_date_role <- ifelse(is.na(row),"no_saved_match_page","published_semantics_unverified")
  dispositions$match_page_retrieved_at_utc <- pages$retrieved_at_utc[row]
  dispositions$source_retrieved_at_utc <- input$base$overlay$source_manifest$retrieved_at_utc
  dispositions$timezone <- NA_character_
  # No source under this bounded extraction establishes any of these concepts.
  unknown_fields <- c("verified_scheduled_date","scheduled_time","actual_start_date","actual_start_time",
    "completion_date","completion_time","suspension_interval","resumption_time","result_available_at","exact_total_order")
  for (name in unknown_fields) dispositions[[name]] <- NA_character_
  dispositions$timing_missing_reason <- ifelse(is.na(row),"event_level_information_only_no_match_page",
    "published_dates_only_actual_schedule_completion_timezone_not_established")
  dispositions$chronology_model_ready <- FALSE
  dispositions$chronology_policy <- "NOT_ADOPTED"
  dispositions$bracket_evidence <- "validated_player_relative_progressions_no_operational_order"
  dispositions$ls007_date_difference <- !is.na(dispositions$official_code) & dispositions$official_code=="LS007"
  # Long observations preserve semantic roles and missingness rather than filling dates.
  observations <- list()
  add <- function(id,field,value,role,source,locator,precision,timezone,state,reason,hash) {
    observations[[length(observations)+1]] <<- data.frame(source_audit_id=id,field=field,value=value,
      semantic_role=role,source=source,locator=locator,precision=precision,timezone_state=timezone,
      verification_state=state,missing_reason=reason,sha256=hash)
  }
  for(i in seq_len(nrow(dispositions))) {
    z <- dispositions[i,]; j <- row[i]
    for(k in seq_len(nrow(event))) add(z$source_audit_id,paste(event$reference_id[k],event$field[k],sep=":"),
      event$value[k],event$semantic_role[k],event$source_path[k],event$locator[k],event$precision[k],
      event$timezone_state[k],event$verification_state[k],NA_character_,event$sha256[k])
    for(field in c("published_start_date","published_end_date")) add(z$source_audit_id,field,pages[[field]][j],
      "published_match_date_not_actual_or_verified_schedule",pages$source_path[j],pages$metadata_locator[j],
      if(is.na(j)) NA_character_ else "day","NOT_ESTABLISHED",
      if(is.na(j)) "NOT_AVAILABLE" else "verified_literal_only",if(is.na(j)) "no_saved_match_page" else NA_character_,pages$sha256[j])
    add(z$source_audit_id,"source_retrieved_at_utc",z$source_retrieved_at_utc,"acquisition_not_play_time",
      input$base$overlay$source_manifest$local_path,"source manifest retrieved_at_utc","second","UTC","verified_manifest",NA_character_,input$base$overlay$source_manifest$sha256)
    add(z$source_audit_id,"match_page_retrieved_at_utc",z$match_page_retrieved_at_utc,"acquisition_not_play_time",
      pages$source_path[j],"reference manifest retrieved_at_utc",if(is.na(j)) NA_character_ else "second",
      if(is.na(j)) "NOT_AVAILABLE" else "UTC",if(is.na(j)) "NOT_AVAILABLE" else "verified_manifest",
      if(is.na(j)) "no_saved_match_page" else NA_character_,pages$sha256[j])
    for(field in c(unknown_fields,"timezone")) add(z$source_audit_id,field,NA_character_,field,
      "bounded_source_and_reference_audit","no_verified_field_in_scoped_evidence",NA_character_,"NOT_ESTABLISHED",
      "NOT_ESTABLISHED",z$timing_missing_reason,NA_character_)
  }
  observations <- do.call(rbind,observations);rownames(observations)<-NULL
  mnc_need(!anyDuplicated(observations[c("source_audit_id","field")]),"duplicate chronology observations")
  eligible <- dispositions$included_in_completed_denominator
  page_count <- sum(!is.na(row)); complete_pages <- sum(eligible & !is.na(row))
  edges$both_endpoints_normally_completed <- edges$from_audit_id %in% dispositions$source_audit_id[eligible] &
    edges$to_audit_id %in% dispositions$source_audit_id[eligible]
  a <- match(edges$from_audit_id,pages$source_audit_id); b <- match(edges$to_audit_id,pages$source_audit_id)
  edges$same_published_day <- !is.na(a) & !is.na(b) & pages$published_start_date[a]==pages$published_start_date[b]
  edges$published_date_reversal <- !is.na(a) & !is.na(b) & pages$published_start_date[a]>pages$published_start_date[b]
  mnc_need(!any(edges$published_date_reversal),"published dates contradict advancement; no chronology readiness")
  # Verify every player's observed successive result has precisely its own edge.
  raw <- input$base$evidence$source$selected$raw; checks <- list()
  for(player in sort(unique(c(raw$winner_id,raw$loser_id)))) {
    z <- raw[raw$winner_id==player | raw$loser_id==player,]; ranks <- match(z$round,mji_rounds())
    mnc_need(!anyDuplicated(ranks),"duplicate player round; cannot infer progression")
    z <- z[order(ranks),]; ids <- paste0("sackmann:WTA:2021-806:",z$match_num)
    expected <- if(length(ids)>1) paste(head(ids,-1),tail(ids,-1)) else character()
    actual <- edges[edges$player_id==player,]
    mnc_need(setequal(expected,paste(actual$from_audit_id,actual$to_audit_id)),"incomplete player-relative chain")
    checks[[player]] <- data.frame(player_id=player,appearances=length(ids),precedence_edges=nrow(actual),
      within_event_chain_accounted=TRUE,establishes_cross_event_order=FALSE)
  }
  players <- do.call(rbind,checks);rownames(players)<-NULL
  conflicts <- data.frame(issue=c("event_window_difference","scheduled_metadata_finished_result", "LS007_quarterfinal_date_difference",
    "same_player_same_published_day","actual_timing_timezone_missing","cross_event_boundary_unestablished"),
    affected_records=c(nrow(d),page_count,1,sum(edges$same_published_day),nrow(d),nrow(d)),
    count_unit=c("records","saved_pages","page","precedence_edges","records","records"),
    state="UNRESOLVED",decision=paste0("D",c(9,3,9,6,8,12)))
  options <- data.frame(option=c("exact_timestamps","verified_date_conservative_batch","published_dates_as_operational","bracket_partial_order_only"),
    completed_denominator=sum(eligible),narrow_evidence_records=c(0L,0L,complete_pages,sum(eligible)),
    evidence_meaning=c("verified_actual_start_and_result_availability","verified_play_completion_days_and_timezone",
      "published_pages_only_semantics_unverified_LS007_flagged","complete_within_event_player_progressions_only"),
    fully_sufficient_completed_records=0L,model_readiness="BLOCKED",policy_status="PROPOSED_NOT_APPROVED")
  summary <- data.frame(results=nrow(d),normally_completed=sum(eligible),retirements=sum(d$classification=="retirement"),
    walkovers=sum(d$classification=="walkover"),event_level_date_records=nrow(d),only_event_level_dates=nrow(d)-page_count,
    saved_match_page_dates=page_count,completed_with_page_dates=complete_pages,completed_only_event_dates=sum(eligible)-complete_pages,
    actual_start_dates=sum(!is.na(dispositions$actual_start_date)),actual_start_times=sum(!is.na(dispositions$actual_start_time)),
    completion_dates=sum(!is.na(dispositions$completion_date)),completion_times=sum(!is.na(dispositions$completion_time)),
    player_relative_edges=nrow(edges),completed_to_completed_edges=sum(edges$both_endpoints_normally_completed),
    players_with_accounted_chains=nrow(players),completed_with_within_event_chain_evidence=sum(eligible),
    same_published_day_edges=sum(edges$same_published_day),published_date_reversals=sum(edges$published_date_reversal),
    chronology_policy="NOT_ADOPTED",chronology_model_readiness="BLOCKED",exact_total_order="NOT_ESTABLISHED",
    event_admission="NOT_EVALUATED",canonical_analytical_population="NOT_IMPLEMENTED",tour_season_gate="NOT_TESTED",
    modeling_authorized=FALSE,publication="BLOCKED_PENDING_RIGHTS_REVIEW")
  list(dispositions=dispositions,observations=observations,edges=edges,players=players,
    event_observations=event,match_page_observations=pages,conflicts=conflicts,options=options,summary=summary,decisions=mnc_policy())
}

mnc_validate_result <- function(result,input) {
  mnc_need(identical(result,mnc_derive(input)),"derived chronology or proposal state changed")
  invisible(TRUE)
}

audit_montreal_chronology_evidence <- function(write_outputs=TRUE) {
  input <- mnc_load()
  paths <- unique(c(input$base$evidence$refs$local_path,input$base$evidence$source$provenance$path,
    names(mro_pins()),mro_path(),list.files(mmc_dir(),full.names=TRUE),list.files(mji_dir(),full.names=TRUE)))
  before <- mrf_snapshot(paths)
  mnc_validate_inputs(input)
  result <- mnc_derive(input); mnc_validate_result(result,input)
  mnc_need(identical(before,mrf_snapshot(paths)),"protected evidence or earlier outputs changed")
  if(write_outputs) {
    mro_git_boundary(paste0(mnc_dir(),"/summary.csv"));dir.create(mnc_dir(),showWarnings=FALSE)
    for(name in names(result)) pilot_write_csv(result[[name]],file.path(mnc_dir(),paste0(gsub("_","-",name),".csv")))
  }
  invisible(result)
}
if(sys.nframe()==0L) print(audit_montreal_chronology_evidence()$summary,row.names=FALSE)
