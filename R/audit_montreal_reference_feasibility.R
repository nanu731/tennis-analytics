# Phase 1G: offline observations and feasibility only; no repair/admission output.
source("R/download_montreal_references.R")
source("R/review_wta_2021_montreal.R")
source("R/audit_wta_anomaly.R")

mrf_version <- function() "WTA Montreal reference-feasibility review 1.0.0"
mrf_targets <- function() data.frame(code=sprintf("LS%03d",c(1:7,42,49)),
  match_num=c("238","300","299","298","297","296","295","260","253"),
  round=c("F","SF","SF",rep("QF",4),"R64","R64"))
mrf_round <- function(x) unname(c(Final="F",Semifinals="SF",Quarterfinals="QF",`Round of 64`="R64",`2`="F",`4`="SF",`8`="QF",`64`="R64")[x])
mrf_plain_name <- function(x) tolower(gsub("-"," ",x,fixed=TRUE))
mrf_source_name <- function(x) ifelse(x=="Coco Gauff","cori gauff",tolower(x))
mrf_abbr <- function(x) sub("^([^ ])[^ ]* ","\\1. ",x)
mrf_numeric_score <- function(x) sub(" RET.*$","",x)

mrf_card <- function(html,code,draw=FALSE) {
  anchor<-paste0(if(draw)'class="tennis-match tennis-match--slim js-match-' else 'class="tennis-match js-tennis-match js-match-',"0806-2021-",code)
  parts<-strsplit(html,anchor,fixed=TRUE)[[1]]
  if(length(parts)!=2L)stop("Unique expected event/year/match card unavailable: ",code)
  card<-strsplit(parts[2],"</table>",fixed=TRUE)[[1]][1]
  round<-if(draw) {
    containers<-strsplit(parts[1],'data-round-class-index="',fixed=TRUE)[[1]]
    mrf_round(anomaly_capture('data-round="([^"]+)"',tail(containers,1)))
  } else mrf_round(anomaly_text(anomaly_capture('(?s)<div class="tennis-match__round[^>]*>(.*?)</div>',card)))
  team<-lapply(c("a","b"),function(side){
    row<-anomaly_capture(paste0('(?s)(<tr class="match-table__row js-team-',side,'[^>]*>.*?</tr>)'),card)
    if(is.na(row))stop("Missing player row")
    cells<-anomaly_matches('(?s)<td class="match-table__score-cell[^>]*>.*?</td>',row)
    sets<-vapply(cells,function(c)anomaly_text(gsub('(?s)<sup.*?</sup>',"",c,perl=TRUE)),"")
    tb<-vapply(cells,function(c)anomaly_capture('(?s)<sup[^>]*>([0-9]+)</sup>',c),"")
    take<-grepl("^[0-9]+$",sets)
    list(side=side,name=anomaly_text(anomaly_capture('(?s)<span class="match-table__player-fullname">(.*?)</span>',row)),
      slug=anomaly_capture('href="/players/[0-9]+/([^"/]+)',row),
      wta_id=anomaly_capture('href="/players/([0-9]+)/',row),sets=sets[take],tb=tb[take],
      winner=grepl("is-winner",strsplit(row,">",fixed=TRUE)[[1]][1],fixed=TRUE),
      retired=grepl('title="Retired"',row,fixed=TRUE))
  })
  win<-which(vapply(team,`[[`,TRUE,"winner"))
  if(length(win)!=1||length(team[[1]]$sets)!=length(team[[2]]$sets)||!length(team[[1]]$sets))stop("Winner/score orientation unresolved")
  a<-team[[win]];b<-team[[3-win]]
  tb<-ifelse(as.numeric(a$sets)<as.numeric(b$sets),a$tb,b$tb)
  score<-paste(paste0(a$sets,"-",b$sets,ifelse(is.na(tb),"",paste0("(",tb,")"))),collapse=" ")
  list(team=team,winner_side=win,round=round,score=score,
    retired=paste(vapply(team[vapply(team,`[[`,TRUE,"retired")],`[[`,"","slug"),collapse=";"),
    completed=anomaly_capture('data-completed="([^"]+)"',card),status=anomaly_capture('data-status="([^"]+)"',card),
    locator=paste0("js-match-0806-2021-",code,"; scoped js-team-a/b; score cells"))
}

mrf_identity <- function(card,row,expected_round) {
  names<-vapply(card$team,function(t)mrf_plain_name(t$slug),"")
  expected<-mrf_source_name(c(row$winner_name,row$loser_name))
  abbr<-vapply(card$team,`[[`,"","name")
  expected_abbr<-mrf_abbr(c(row$winner_name,row$loser_name))
  isTRUE(row$tourney_id=="2021-806" && row$tourney_name=="Montreal" && row$round==expected_round &&
    card$round==expected_round && setequal(names,expected) && setequal(abbr,expected_abbr) &&
    names[card$winner_side]==expected[1] && card$score==mrf_numeric_score(row$score))
}

mrf_metadata <- function(html,code) {
  blocks<-anomaly_matches('(?s)<script type="application/ld\\+json">.*?</script>',html)
  blocks<-blocks[grepl(paste0('"value": "',code,'"'),blocks,fixed=TRUE)]
  if(length(blocks)!=1L)stop("Unique match metadata unavailable")
  b<-blocks[1]
  value<-function(label)anomaly_capture(paste0('(?s)"name": "',label,'",\\s*"value": "([^"]+)"'),b)
  get<-function(key)anomaly_capture(paste0('"',key,'": "([^"]+)"'),b)
  event<-anomaly_capture('(?s)<span class="mc-live-score__tournament-name[^>]*>(.*?)</span>',html)
  if(!grepl("Montreal, Canada",event,fixed=TRUE)||!grepl('tournaments/806/montreal/2021#singles',b,fixed=TRUE))stop("Displayed tournament identity mismatch")
  list(date=get("startDate"),end_date=get("endDate"),duration=value("Match Duration"),
    json_status=get("eventStatus"),round=value("Round"),score=value("Final Score"),event=anomaly_text(event),
    location=anomaly_capture('(?s)"location": \\{.*?"name": "([^"]+)"',b),
    locator=paste0("match SportsEvent Match Number=",code,"; startDate/endDate/Match Duration/eventStatus"))
}

mrf_tab <- function(html) {
  pieces<-strsplit(html,'class="mc-stats__tab-content js-match-stats"',fixed=TRUE)[[1]]
  if(length(pieces)!=2L)stop("Unique whole-match tab unavailable; no set substitution")
  strsplit(pieces[2],'class="mc-stats__tab-content js-set',fixed=TRUE)[[1]][1]
}
mrf_pair <- function(tab,label,section="Service") {
  area<-if(section=="Service")anomaly_capture('(?s)>Service</h3>(.*?)>Return</h3>',tab) else anomaly_capture('(?s)>Return</h3>(.*?)>Total Points</h3>',tab)
  blocks<-strsplit(area,'<div class="compare-stats-block__row">',fixed=TRUE)[[1]][-1]
  labs<-vapply(blocks,function(b)anomaly_text(anomaly_capture('(?s)<div class="compare-stats-block__label[^>]*>(.*?)</div>',b)),"")
  take<-which(labs==label)
  if(length(take)!=1)return(list(display=rep(NA_character_,2),detail=rep(NA_character_,2),state=if(length(take))"unparseable" else "missing"))
  bars<-anomaly_matches('compare-stats-block__bar--[ab]',blocks[take])
  if(!identical(bars,c("compare-stats-block__bar--a","compare-stats-block__bar--b")))stop("Statistics column orientation changed")
  b<-strsplit(blocks[take],'<div class="compare-stats-block__bars">',fixed=TRUE)[[1]][1]
  # Values explicitly hidden in the selected row cannot supply exact counts.
  if(grepl('(?i)(display\\s*:\\s*none|aria-hidden="true"|class="[^"]*is-hidden)',b,perl=TRUE))return(list(display=rep(NA_character_,2),detail=rep(NA_character_,2),state="missing"))
  read<-function(cls){
    v<-anomaly_matches(paste0('(?s)<div class="compare-stats-block__',cls,' [^>]*>.*?</div>'),b)
    if(length(v)!=2)return(rep(NA_character_,2))
    vapply(v,anomaly_text,"")
  }
  list(display=read("stat"),detail=read("detail"),state="parsed")
}
mrf_exact <- function(display,detail,component=0L) {
  fraction<-!is.na(detail)&&grepl("^[0-9]+/[0-9]+$",detail)
  parts<-if(fraction)as.integer(strsplit(detail,"/",fixed=TRUE)[[1]]) else c(NA_integer_,NA_integer_)
  value<-if(component>0)parts[component] else if(!is.na(display)&&grepl("^[0-9]+$",display))as.integer(display) else NA_integer_
  list(value=value,numerator=parts[1],denominator=parts[2],
    state=if(!is.na(value))"present" else if((is.na(display)||!nzchar(display))&&(is.na(detail)||!nzchar(detail)))"missing" else "unparseable")
}
mrf_stats <- function(html,code,card) {
  displayed<-vapply(c("a","b"),function(side)anomaly_text(anomaly_capture(paste0('(?s)<span class="mc-stats__name[^>]*js-team-',side,'-name">(.*?)</span>'),html)),"")
  if(any(!is.na(displayed)&nzchar(displayed))&&!identical(unname(displayed),unname(vapply(card$team,`[[`,"","name"))))stop("Statistics header orientation mismatch")
  tab<-mrf_tab(html)
  labels<-c("Aces","Double Faults","1st Serve","1st Serve","1st Serve Points Won","2nd Serve Points Won","Service Games Played","Break Points Faced","Break Points Saved","Return Games Played")
  fields<-c("ace","df","svpt","1stIn","1stWon","2ndWon","SvGms","bpFaced","bpSaved","return_games")
  components<-c(0,0,2,1,1,1,0,0,1,0)
  out<-list()
  for(i in seq_along(fields))for(side in 1:2){
    section<-if(i==10)"Return" else "Service";p<-mrf_pair(tab,labels[i],section)
    e<-mrf_exact(p$display[side],p$detail[side],components[i]);if(p$state!="parsed")e$state<-p$state
    out[[length(out)+1]]<-data.frame(reference_id=code,match_code=code,page_side=c("a","b")[side],
      page_name=card$team[[side]]$name,wta_player_id=card$team[[side]]$wta_id,player_slug=card$team[[side]]$slug,
      source_side=if(side==card$winner_side)"w" else "l",field=fields[i],required=i<=9,
      raw_display=p$display[side],raw_fraction=p$detail[side],numerator=e$numerator,denominator=e$denominator,
      value=e$value,parse_state=e$state,scope="whole_match_Match_tab",
      locator=paste("js-match-stats",section,labels[i],paste0("page_side_",c("a","b")[side]),sep=" / "),
      extraction_method=if(components[i])paste0("displayed_fraction_component_",components[i]) else "displayed_integer",
      orientation_basis="ordered a/b statistic columns and bar--a/bar--b classes; scoped match-card identities; name-bar empty in saved HTML")
  }
  do.call(rbind,out)
}
mrf_compare <- function(source,official,state="present",oriented=TRUE) {
  if(!oriented)return("orientation_unresolved")
  if(state=="missing")return("official_missing")
  if(state!="present"||is.na(official))return("official_unparseable")
  if(is.na(source)||!nzchar(source))return("source_missing_official_present")
  if(grepl("^[0-9]+$",source)&&as.numeric(source)==official)"source_and_official_exact" else "source_and_official_conflict"
}

mrf_structural <- function(row,observations,card) {
  # Reference-only adapter for existing checks; never copy or fill a source row.
  # Source event context satisfies the validator's shape contract; it is neither
  # a new official observation nor written out. No source match/count row is copied.
  winner<-card$team[[card$winner_side]];loser<-card$team[[3-card$winner_side]]
  z<-data.frame(tourney_id="reference:WTA:2021-806",tourney_name="Montreal",tourney_date=row$tourney_date,
    surface="Hard",tourney_level=row$tourney_level,draw_size=row$draw_size,round=card$round,
    match_num=observations$match_code[1],best_of=row$best_of,winner_id=winner$wta_id,loser_id=loser$wta_id,
    winner_name=winner$name,loser_name=loser$name)
  required<-observations[observations$required,]
  for(i in seq_len(nrow(required)))z[[paste(required$source_side[i],required$field[i],sep="_")]]<-as.character(required$value[i])
  z$score<-paste0(card$score,if(nzchar(card$retired))" RET" else "")
  check<-pilot_audit_event(z,"WTA")$checks
  add<-function(name,flag){check<<-rbind(check,data.frame(tour="WTA",check=name,evaluated_rows=as.integer(!is.na(flag)),flagged_rows=as.integer(isTRUE(flag)),not_evaluable_rows=as.integer(is.na(flag))))}
  get<-function(side,field,col="value")observations[observations$source_side==side&observations$field==field,col]
  for(side in c("w","l")) {
    other<-if(side=="w")"l" else "w"
    add(paste0(side,"_return_games_equal_opponent_service_games"),get(side,"return_games")!=get(other,"SvGms"))
    add(paste0(side,"_first_won_denominator_equal_first_in"),get(side,"1stWon","denominator")!=get(side,"1stIn"))
    add(paste0(side,"_second_won_denominator_equal_opportunities"),get(side,"2ndWon","denominator")!=get(side,"svpt")-get(side,"1stIn"))
    add(paste0(side,"_saved_denominator_equal_faced"),get(side,"bpSaved","denominator")!=get(side,"bpFaced"))
  }
  check$match_code<-observations$match_code[1]
  check$score_basis<-if(nzchar(card$retired))"official_RET_allow_zero_or_one_unfinished_service_game" else "official_completed_score_excluding_tiebreak_games"
  check
}

mrf_pdf_lines <- function(path) {
  executable<-Sys.getenv("ANOMALY_PDFTOTEXT",unset=unname(Sys.which("pdftotext")))
  if(!nzchar(executable))executable<-path.expand("~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext")
  if(!file.exists(executable))stop("Existing pdftotext required; set ANOMALY_PDFTOTEXT; do not install")
  text<-system2(executable,c("-f","1","-l","1","-bbox-layout",shQuote(path),"-"),stdout=TRUE)
  if(!is.null(attr(text,"status")))stop("PDF extraction failed")
  b<-anomaly_matches('(?s)<line [^>]*>.*?</line>',paste(text,collapse="\n"))
  data.frame(x=as.numeric(vapply(b,function(x)anomaly_capture('xMin="([^"]+)"',x),"")),
    y=as.numeric(vapply(b,function(x)anomaly_capture('yMin="([^"]+)"',x),"")),text=vapply(b,anomaly_text,""))
}
mrf_pdf_targets <- function(lines,targets,source) {
  # Nine visually reviewed branches of this pinned one-page draw; no full inventory.
  xs<-c(489.45,494.61,494.61,435.93,435.93,435.93,435.93,263.85,250.77)
  ys<-c(357.79,227.27,490.78,161.99,292.55,425.50,556.06,267.94,384.46)
  sx<-c(503.97,494.61,494.61,435.93,435.93,435.93,435.93,250.77,250.77)
  sy<-c(366.67,235.30,498.70,170.02,300.58,433.42,563.98,276.34,392.86)
  px<-c(494.61,435.93,435.93,377.25,377.25,377.25,377.25,55.77,69.93)
  py1<-c(227.27,161.99,425.50,129.35,259.91,392.86,523.42,267.83,384.46)
  py2<-c(490.78,292.55,556.06,194.63,325.30,458.03,588.59,276.46,392.98)
  grab<-function(x,y){v<-lines$text[abs(lines$x-x)<1&abs(lines$y-y)<1];if(length(v)==1)v else NA_character_}
  strip<-function(x)trimws(gsub(" \\[.*?\\]","",x))
  pdf_abbr<-function(x)sub("^K\\. Pliskova$","Ka. Pliskova",mrf_abbr(x))
  out<-lapply(seq_len(nrow(targets)),function(i){
    row<-source[source$match_num==targets$match_num[i],];winner<-grab(xs[i],ys[i]);score<-grab(sx[i],sy[i]);p1<-grab(px[i],py1[i]);p2<-grab(px[i],py2[i])
    names<-c(row$winner_name,row$loser_name)
    expected_pair<-if(i<=7)pdf_abbr(names) else vapply(names,function(n){v<-strsplit(n," ")[[1]];paste0(toupper(tail(v,1)),", ",v[1])},"")
    pair<-if(i<=7)setequal(strip(c(p1,p2)),expected_pair) else setequal(sub("^Q ","",c(p1,p2)),expected_pair)
    expected_win<-if(i==1)row$winner_name else pdf_abbr(row$winner_name)
    compact<-gsub("-","",mrf_numeric_score(row$score),fixed=TRUE)
    numeric<-sub(" RET$","",score)
    data.frame(match_code=targets$code[i],reference_id="draw_pdf",round=targets$round[i],
      player_one=p1,player_two=p2,advancing_player=winner,score=score,retirement=grepl(" RET$",score),
      retiring_player=if(i>=8) {
        name<-row$loser_name
        legend<-lines$text[abs(lines$x-494.37)<1&abs(lines$y-if(i==8)657.41 else 664.24)<1]
        if(length(legend)==1&&startsWith(legend,paste0(name," - ")))name else NA_character_
      } else "",
      identity_result=if(isTRUE(pair&&strip(winner)==expected_win))"verified" else "conflict",
      score_result=if(isTRUE(numeric==compact))"exact_numeric_agreement" else "conflict",
      retirement_locator=if(i>=8)paste0("PDF p1 retirement legend x=494.37 y=",if(i==8)"657.41" else "664.24") else "not_applicable",
      locator=paste0("PDF p1; branch ",targets$round[i],"; pair x=",px[i]," y=",py1[i],"/",py2[i],"; advancing x=",xs[i]," y=",ys[i],"; score x=",sx[i]," y=",sy[i]))
  })
  do.call(rbind,out)
}

mrf_draw_state <- function(match_card,draw_card,pdf) {
  if(pdf$identity_result!="verified"||pdf$score_result!="exact_numeric_agreement"||match_card$score!=draw_card$score)return("identity_or_score_conflict")
  if(nzchar(match_card$retired)&&!nzchar(draw_card$retired)&&isTRUE(pdf$retirement))return("numeric_agreement_HTML_retirement_marker_omitted")
  if(nzchar(match_card$retired)!=isTRUE(pdf$retirement)||match_card$retired!=draw_card$retired)return("status_conflict")
  "agreement"
}
mrf_coverage <- function(source_complete=47L,denominator=54L,present,valid,conservative) {
  candidates<-c(0L,present,valid,conservative)
  data.frame(scenario=c("original_source_only","separate_candidate_availability","hypothetical_passing_bundle_recovery","conservative_excluding_conflicted_candidates"),
    denominator=denominator,denominator_definition="Phase1E source apparent play; unchanged; not officially reconciled",source_complete_bundles=source_complete,
    official_candidate_bundles=candidates,structurally_acceptable_official_candidates=c(0L,valid,valid,conservative),
    remaining_missing_bundles=denominator-source_complete-candidates,coverage_pct=100*(source_complete+candidates)/denominator,
    could_reach_90pct=(source_complete+candidates)>=ceiling(denominator*.9),adopted_policy=FALSE,
    source_bundles_filled=0L,model_admission="not_authorized")
}

audit_montreal_reference_feasibility <- function() {
  refs<-mr_manifest();targets<-mrf_targets();e<-montreal_load();source<-e$selected$raw
  get<-function(id){r<-refs[refs$reference_id==id,];if(nrow(r)!=1||r$retrieval_class!="original_response_bytes")stop("Original reference unavailable: ",id);anomaly_html(r$local_path)}
  draw<-get("draw_html");pdf_lines<-mrf_pdf_lines(refs$local_path[refs$reference_id=="draw_pdf"])
  if(!any(grepl("MONTREAL, CAN",pdf_lines$text,fixed=TRUE))||!any(grepl("August 7-15 2021",pdf_lines$text,fixed=TRUE)))stop("PDF event/year header changed")
  pdf<-mrf_pdf_targets(pdf_lines,targets,source)
  overview<-get("overview")
  overview_date<-anomaly_text(anomaly_capture('(?s)(Aug 9 - Aug 15, 2021)',overview))
  if(is.na(overview_date))stop("Overview event date unavailable")
  inventories<-observations<-comparisons<-structural<-statuses<-dispositions<-list()
  refchecks<-refs[c("reference_id","retrieval_class","http_result","byte_size","sha256","retrieved_at_utc")]
  refchecks$checked<-"manifest_size_sha256_and_content"
  refchecks$result<-ifelse(refs$retrieval_class=="original_response_bytes","passed","reference_unavailable")
  for(i in seq_len(nrow(targets))) {
    code<-targets$code[i];row<-source[source$match_num==targets$match_num[i],,drop=FALSE]
    if(nrow(row)!=1)stop("Source target not unique")
    audit_id<-paste0("sackmann:WTA:2021-806:",row$match_num)
    result<-tryCatch({
      h<-get(code);card<-mrf_card(h,code);md<-mrf_metadata(h,code)
      if(!mrf_identity(card,row,targets$round[i])||mrf_round(md$round)!=targets$round[i]||!startsWith(md$date,"2021-"))stop("Match identity/result mismatch; orientation unresolved")
      drawcard<-mrf_card(draw,code,TRUE)
      drawok<-mrf_identity(drawcard,row,targets$round[i]);drawstate<-mrf_draw_state(card,drawcard,pdf[i,])
      if(!drawok)drawstate<-"identity_or_score_conflict"
      s<-mrf_stats(h,code,card);s$audit_id<-audit_id
      comparison<-s[s$required,c("audit_id","match_code","reference_id","source_side","field","value","parse_state","locator")]
      comparison$source_field<-paste(comparison$source_side,comparison$field,sep="_")
      comparison$source_value<-vapply(comparison$source_field,function(f)row[[f]],"")
      comparison$comparison_state<-mapply(mrf_compare,comparison$source_value,comparison$value,comparison$parse_state,USE.NAMES=FALSE)
      check<-mrf_structural(row,s,card);check$audit_id<-audit_id
      presence<-sum(s$required & !is.na(s$raw_display)&nzchar(s$raw_display))
      parsed<-sum(s$required&s$parse_state=="present")
      valid<-parsed==18&&all(check$flagged_rows==0)&&all(check$evaluated_rows==1)
      conflict<-any(comparison$comparison_state=="source_and_official_conflict")
      numeric_meta<-gsub(","," ",sub(" Ret'd$","",md$score),fixed=TRUE)
      metadata_score_agreement<-numeric_meta==card$score
      status<-if(i==8&&isTRUE(pdf$retirement[i])&&identical(card$retired,"tereza-martincova")&&identical(pdf$retiring_player[i],row$loser_name))"official_retirement_confirmed_suffix_meaning_unresolved" else
        if(i==9&&isTRUE(pdf$retirement[i])&&identical(card$retired,"ajla-tomljanovic")&&identical(pdf$retiring_player[i],row$loser_name))"official_retirement_confirmed_source_marker_missing" else
        if(i<=7&&!nzchar(card$retired)&&card$completed=="true"&&card$status=="F")"completed_card_numeric_score_supported" else "status_unresolved"
      state<-if(parsed<18)"official_counts_incomplete" else if(!valid)"official_bundle_structurally_invalid" else if(conflict)"official_counts_conflict_with_source" else if(i>=8)status else "official_counts_present_pending_recovery_policy"
      # The strict conservative scenario excludes even unresolved metadata conflicts.
      conservative<-valid&&!conflict&&drawstate=="agreement"&&metadata_score_agreement&&i<=7&&md$json_status!="http://schema.org/EventScheduled"
      duration_parts<-suppressWarnings(as.numeric(strsplit(md$duration,":",fixed=TRUE)[[1]]))
      duration_minutes<-if(length(duration_parts)==3&&!anyNA(duration_parts))duration_parts[1]*60+duration_parts[2] else NA_real_
      visible<-anomaly_text(anomaly_capture('(?s)<div class="tennis-match__status-time[^>]*>(.*?)</div>',strsplit(h,paste0('class="tennis-match js-tennis-match js-match-0806-2021-',code),fixed=TRUE)[[1]][2]))
      statusrow<-data.frame(audit_id=audit_id,match_code=code,source_score=row$score,official_numeric_score=card$score,
        match_page_retiring_player=card$retired,draw_html_retiring_player=drawcard$retired,pdf_retiring_player=pdf$retiring_player[i],
        pdf_retirement=pdf$retirement[i],draw_evidence_state=drawstate,status_result=status,suffix_meaning="unresolved_not_inferred",
        source_tournament_date=row$tourney_date,official_published_start_date=md$date,official_published_end_date=md$end_date,
        date_comparison="different_granularity_tournament_date_vs_published_match_date; actual chronology unestablished",
        source_minutes=row$minutes,official_duration=md$duration,official_visible_finished=visible,
        duration_comparison=if(is.na(row$minutes)||!nzchar(row$minutes))"source_missing_official_present" else if(!is.na(duration_minutes)&&as.numeric(row$minutes)==duration_minutes)"same_integer_minutes_seconds_not_in_source" else "duration_conflict",
        card_completed=card$completed,card_status=card$status,structured_event_status=md$json_status,
        structured_status_conflict=md$json_status=="http://schema.org/EventScheduled"&&card$status=="F",
        structured_score=md$score,structured_score_agreement=metadata_score_agreement,locator=paste(card$locator,md$locator,sep="; "))
      inventory<-do.call(rbind,lapply(1:2,function(j){c<-if(j==1)card else drawcard
        data.frame(audit_id=audit_id,match_code=code,reference_id=if(j==1)code else "draw_html",tour="WTA",event_id="806",year=2021,displayed_event=md$event,
          source_winner=row$winner_name,source_loser=row$loser_name,source_round=row$round,source_score=row$score,
          page_a_name=c$team[[1]]$name,page_a_id=c$team[[1]]$wta_id,page_a_slug=c$team[[1]]$slug,
          page_b_name=c$team[[2]]$name,page_b_id=c$team[[2]]$wta_id,page_b_slug=c$team[[2]]$slug,
          advancing_side=c("a","b")[c$winner_side],round=c$round,score=c$score,retired=c$retired,
          identity_result=if(j==1||drawok)"verified" else "conflict",score_result=if(c$score==mrf_numeric_score(row$score))"exact_numeric_agreement" else "conflict",
          locator=c$locator,identity_note=if(row$loser_name=="Coco Gauff")"bounded source Coco Gauff / WTA cori-gauff and PDF C. Gauff linkage; not a global identity crosswalk" else "source names, page abbreviations and full player slugs agree")
      }))
      list(s=s,comparison=comparison,check=check,statusrow=statusrow,inventory=inventory,presence=presence,parsed=parsed,valid=valid,conflict=conflict,status=status,state=state,conservative=conservative,drawstate=drawstate)
    },error=function(err)conditionMessage(err))
    ok<-is.list(result)
    if(ok){observations[[code]]<-result$s;comparisons[[code]]<-result$comparison;structural[[code]]<-result$check;statuses[[code]]<-result$statusrow;inventories[[code]]<-result$inventory}
    dispositions[[code]]<-data.frame(audit_id=audit_id,official_match_code=code,reference_ids=paste(code,"draw_html","draw_pdf",sep=";"),
      identity_result=if(ok)"verified" else "identity_or_orientation_unresolved",score_result=if(ok)"exact_numeric_agreement" else "not_compared",
      status_result=if(ok)result$status else "reference_or_parse_unresolved",required_fields_displayed=if(ok)result$presence else 0L,
      required_fields_exactly_parsed=if(ok)result$parsed else 0L,structural_check_result=if(ok&&result$valid)"passed_all_applicable_checks" else "not_passed",
      source_comparison_result=if(!ok)"orientation_unresolved" else if(result$conflict)"source_and_official_conflict" else if(i<=7)"source_missing_official_present" else "source_and_official_exact",
      recovery_feasibility_state=if(ok)result$state else "identity_or_orientation_unresolved",conservative_count_candidate=ok&&result$conservative,
      draw_comparison=if(ok)result$drawstate else "not_compared",error=if(ok)"" else result,
      rights_state="local_audit_only_no_WTA_redistribution_grant",permitted_uses="local_reference_audit;feasibility_review",
      prohibited_uses="source_repair;substitution;canonical_recovery;model_admission;Four_Factors;Elo;forecasting;publication;redistribution",
      review_version=mrf_version(),adopted_recovery_policy=FALSE,model_admission="not_authorized")
  }
  bind<-function(x)if(length(x))do.call(rbind,x) else data.frame()
  d<-bind(dispositions);missing<-d[1:7,]
  original<-montreal_inventory(e);baseline<-sum(original$apparent_played&original$present_count==18);denominator<-sum(original$apparent_played)
  if(baseline!=47L||denominator!=54L)stop("Source-only baseline changed")
  coverage<-mrf_coverage(baseline,denominator,sum(missing$required_fields_exactly_parsed==18),sum(missing$structural_check_result=="passed_all_applicable_checks"),sum(missing$conservative_count_candidate))
  o<-list(`reference-match-inventory`=bind(inventories),`official-stat-observations`=bind(observations),`field-comparisons`=bind(comparisons),
    `structural-checks`=bind(structural),`status-evidence`=bind(statuses),`feasibility-dispositions`=d,`coverage-scenarios`=coverage,`reference-checks`=refchecks,`pdf-target-evidence`=pdf)
  dir<-"data/pilot/development-2021/montreal-reference-feasibility"
  dir.create(dir,recursive=TRUE,showWarnings=FALSE)
  for(name in names(o))pilot_write_csv(o[[name]],file.path(dir,paste0(name,".csv")))
  mrf_report(o,refs)
  invisible(o)
}

mrf_report <- function(o,refs) {
  d<-o$`feasibility-dispositions`;s<-o$`status-evidence`;c<-o$`coverage-scenarios`;p<-o$`pdf-target-evidence`
  path<-"docs/wta-2021-montreal-reference-feasibility.md"
  expected<-nrow(s)==9&&all(d$required_fields_exactly_parsed==18)&&all(d$structural_check_result=="passed_all_applicable_checks")&&
    all(p$identity_result=="verified")&&all(p$score_result=="exact_numeric_agreement")&&
    all(s$structured_status_conflict)&&all(s$structured_score_agreement)&&
    all(s$draw_evidence_state[1:7]=="agreement")&&all(s$draw_evidence_state[8:9]=="numeric_agreement_HTML_retirement_marker_omitted")&&
    all(s$duration_comparison[-1]=="same_integer_minutes_seconds_not_in_source")&&
    all(d$source_comparison_result==c(rep("source_missing_official_present",7),rep("source_and_official_exact",2)))
  if(!isTRUE(expected)) {
    # Do not publish the reviewed narrative against failed or changed extraction.
    lines<-c("# WTA 2021 Montreal reference feasibility","",paste0("Review: ",mrf_version()),"",
      "**REVIEW_REQUIRED:** saved evidence or extraction differs from the reviewed Phase 1G findings. Affected comparisons are stopped; no substitution or admission is authorized.","",
      pilot_markdown_table(d),"",pilot_markdown_table(c))
    if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
    return(invisible(NULL))
  }
  supported<-sum(d$structural_check_result[1:7]=="passed_all_applicable_checks" & d$required_fields_exactly_parsed[1:7]==18)>=2
  conclusion<-if(supported)"SUPPORTED_PENDING_RECOVERY_POLICY" else "BLOCKED_INSUFFICIENT_ACCEPTABLE_CANDIDATES"
  lines<-c("# WTA 2021 Montreal reference feasibility", "",
    paste0("Review specification: **",mrf_version(),"**. **",conclusion,"**. This is a local reference investigation, not an adopted recovery, precedence, eligibility or admission policy."),"",
    "## Scope and authorization", "",
    "The user selected Phase 1F Option A investigation and authorized these exact twelve URLs for local noncommercial educational research and source auditing. No other URLs, searches, hidden APIs, player pages or events were accessed. Toronto in two allowed URL slugs does not identify the edition city: both pages display National Bank Open - Montreal, Canada, match IDs 0806-2021 and Montreal match metadata.","",
    pilot_markdown_table(refs[c("reference_id","url","retrieval_class","http_result","byte_size","retrieved_at_utc")]),
    "All twelve acquisitions succeeded on the first direct attempt with HTTP 200. Saved files are original response bytes, not browsing-service representations. The [provenance manifest](../data/manifests/montreal-reference-files.csv) records exact URL, purpose, publisher, media type, local path, size, SHA-256, attempt/retrieval times and rights limitations. Acquisition occurred on September 15 UTC, September 14 in the user's local time. No crawl/access time was invented. Redirects and nonallowlisted requests are rejected; matching manifested files are reused without changes.","",
    "**Rights:** existing [WTA rights analysis](../DATA_LICENSE.md) still governs. User authorization for local caching does not grant publication or redistribution rights. Public access supplies no open-data license. Raw references and extracted match tables remain ignored. No new verified licensing fact arose, so DATA_LICENSE.md is unchanged. Only code, manifest and compact audit documentation are committed.","",
    "## Identity and targeted draw checks", "",
    pilot_markdown_table(o$`reference-match-inventory`[o$`reference-match-inventory`$reference_id!="draw_html",c("audit_id","match_code","source_round","source_winner","source_loser","advancing_side","identity_result","score_result")]),
    "Match identity is checked before count orientation: WTA/source event, 806/2021 match code, displayed Montreal metadata, round, unordered pair, source names, page abbreviations/full slugs, winner and numeric set score. Page a/b order is saved separately. WTA player IDs are retained; no global identity crosswalk is created. Source Coco Gauff is linked only within this verified target to WTA cori-gauff / C. Gauff and the PDF branch; the source spelling is preserved.","",
    "Nine target branches of the one-page official PDF were visually reviewed, then checked offline with fixed bounding-box locators for entrants, advancement and score; retirement legend names have separate locators. All nine PDF player/round/result/numeric-score checks agree with the corresponding pages and source. HTML draw checks agree on the same nine pairs, rounds, advancements and scores. This is not complete Montreal inventory reconciliation and does not pass an inventory gate.","",
    pilot_markdown_table(p[c("match_code","identity_result","score_result","retirement")]),
    "The overview displays Aug 9–15, 2021; PDF header displays August 7–15 2021, MONTREAL, CAN and Hard. These distinct published windows are preserved; their scope difference is not explained or used to establish actual match chronology.","",
    "## Exact counts and structural checks", "",
    pilot_markdown_table(d[c("official_match_code","required_fields_displayed","required_fields_exactly_parsed","structural_check_result","source_comparison_result")]),
    "Each of LS001–LS007 contains all 18 required exact counts: ace, double fault, service points, first serves in, first-serve points won, second-serve points won, service games, break points faced and saved, for both players. Each status-review page also supplies 18 counts. Two extra return-game observations per match support cross-player checks: 180 observations total, including 162 required-field comparisons. These are separate reference observations; the seven Sackmann bundles remain entirely missing.","",
    "Only the unique whole-match Match tab is used. Service and Return sections are scoped separately from Featured Stats and set panels. Integers and displayed numerator/denominator fractions supply values; rounded percentages never reconstruct counts. Every field retains raw text, fraction components, locator, reference ID, scope, extraction method, page orientation and source-side mapping. The saved statistics name-bar is empty; ordering is tied to the page's a/b columns and bar classes, after the scoped match card verifies players. It is not independently confirmed by populated statistics-header names.","",
    paste0("Each of nine bundles passes ",nrow(o$`structural-checks`)/9," applicable checks, with zero flagged or unevaluable checks: nonnegative integers; existing count bounds (including second-serve wins plus double faults); service games versus score; cross-player return/service games; and displayed fraction denominator consistency. No existing quarantine or admission state is transferred."),"",
    "Completed tie-break games are excluded from service-game totals. LS006 and LS007 each include one tie-break set. Retirement handling permits zero or one current unfinished service game: LS042 has 15 service games against 14 finished scored games; LS049 has 16 against 16. This handles count structure without declaring eligibility or reconstructing missing points.","",
    "Of 162 required comparisons, 126 are source_missing_official_present and 36 are source_and_official_exact. LS042 and LS049 agree with all 18 populated source counts each. No required-count disagreement was found; agreement cannot establish independence or eliminate shared upstream errors.","",
    "## Status, dates and duration discrepancies", "",
    pilot_markdown_table(s[c("match_code","source_score","status_result","draw_evidence_state")]),
    "LS042 identifies Tereza Martincova as retired in the match card; its structured score also says Ret'd. The PDF has RET plus Martincova in its retirement legend. HTML draw has the same numeric score/advancement but omits RET. Source 6-1 4-3 RET+H64 is unchanged. Retirement is supported; neither H64 nor H61 has an established meaning.","",
    "LS049 identifies Ajla Tomljanovic as retired in the match card and Ret'd structured score; PDF RET/retirement legend corroborate her identity. HTML draw again omits RET. Source 2-6 6-2 remains literal source text; no marker or deciding set is inserted. No retirement-use policy follows from either finding.","",
    pilot_markdown_table(s[c("match_code","official_published_start_date","source_minutes","official_duration","duration_comparison")]),
    "Eight recorded source durations agree with the hours/minutes component of official durations; seconds are absent from the source, so exact second-level agreement is not claimed. The final's source minutes are missing while WTA records 01:40:31. Official published match dates differ in granularity from source tournament date 20210809 and are not verified actual-play dates. LS007 metadata is dated August 14 while other quarterfinal metadata is August 13; time zone and scheduling semantics remain unresolved.","",
    "All nine match-specific SportsEvent blocks say EventScheduled despite completed=true/status=F and visible Finished cards. This conflict is retained for every target. It does not negate exact count presence or corroborated retirement evidence, but any recovery/status precedence rule must explicitly address it. Generic hidden Upcoming UI labels are not match-status evidence.","",
    "## Coverage scenarios and feasibility", "",
    pilot_markdown_table(c[c("scenario","denominator","source_complete_bundles","official_candidate_bundles","structurally_acceptable_official_candidates","remaining_missing_bundles","coverage_pct","could_reach_90pct","adopted_policy")]),
    "The declared denominator is the unchanged 54 source apparent-play rows, not a reconciled official population. Source-only coverage remains 47/54 = 87.0370%, leaving seven missing bundles. Forty-nine bundles would reach 90%, so two acceptable later recoveries could close the arithmetic shortfall. All seven count candidates are complete and structurally acceptable, giving 54/54 potential availability and hypothetical recovery coverage. Neither scenario represents filled source cells or adopted coverage.","",
    "The strict conservative scenario excludes candidates with any retained conflict, including EventScheduled metadata: all seven are excluded, leaving 47/54. This intentionally differs from count-only hypothetical arithmetic. Resolving or approving treatment of these status metadata conflicts is a prerequisite for later use. The 95% tour-season gate was not tested; thresholds and panel remain unchanged.","",
    "## Review dispositions and next decision", "",
    "The nine feasibility dispositions preserve IDs, reference links, identity/score/status outcomes, field availability, structural result, comparison state, rights, permitted/prohibited uses and review version. Seven are official_counts_present_pending_recovery_policy; two retain their specific retirement finding. Every row prohibits source substitution, canonical recovery, model admission and publication. Review specification 1.0.0 is implemented; a recovery policy is not.","",
    "**Completed drafting follow-up:** [Phase 1H policy 0.1.0](draft-wta-2021-montreal-recovery-policy.md) now proposes a separate overlay, scoped completion/status evidence rules and ten pending user decisions. The draft is PROPOSED_NOT_APPROVED; recovery and status precedence remain unimplemented. This Phase 1G report retains its original evidence, conflicts and coverage scenarios. Next, the user should review and explicitly approve, reject or revise the proposal before any implementation prompt. Inventory, chronology, retirement eligibility, admission and publication rights remain separate gates.","",
    "No source repair, substitution, admission, factor computation, Elo, forecast, predictive evaluation, wider data acquisition, dependency, portfolio edit, push, publication or deployment occurred. 2022/2024/2025 remain closed. Four Factors versus surface-adjusted Elo remains the flagship; Challenger promotion readiness remains deferred until shared infrastructure is validated.","",
    "## Reproduction and verification", "",
    "From the repository root, run `Rscript R/download_montreal_references.R`, then `Rscript R/audit_montreal_reference_feasibility.R --self-test`. The audit uses saved files only and never calls a network function. It requires base R, existing SHA-256 tooling and existing pdftotext (optionally selected with ANOMALY_PDFTOTEXT); no dependency was added. Missing or mismatched bytes stop before overwrite; affected identity/parse failures are retained without source orientation/substitution.","",
    "Fresh-machine limits: third-party HTML may change or become unavailable. Downloading the same URL later does not reproduce these exact bytes; use an authorized copy matching the manifest, or document a new acquisition separately. There was no browsing-service fallback. PDF locators deliberately target this saved revision, not arbitrary future draw layouts. Earlier pinned annual files and Phase 1E outputs are prerequisites.","",
    "Generated ignored files under data/pilot/development-2021/montreal-reference-feasibility/: reference-match-inventory.csv, official-stat-observations.csv, field-comparisons.csv, structural-checks.csv, status-evidence.csv, feasibility-dispositions.csv, coverage-scenarios.csv, reference-checks.csv and pdf-target-evidence.csv. No full source/official combined match table is generated.","",
    "Synthetic checks cover allowlist and identity rejection, orientation reversal, whole-match isolation and duplicate Match-tab rejection, repeated set-panel isolation, integer/fraction parsing, percentage-only and missing values, hidden values, field comparison states, count failures, tie-break and retirement handling, preserved status/source text, draw conflicts, denominator accounting and prohibited adoption. Reruns must preserve output bytes and modification times, and downloader reruns must preserve saved reference bytes/times. Earlier raw/manifests/policies/generated CSVs are checked separately against the pre-acquisition snapshot.","",
    "Development checks exposed overly broad or exact assumptions: decorative aria-hidden bars initially suppressed visible counts; an empty statistics name-bar could not independently identify players; and Return-section/PDF-date labels differed from the first parser patterns. Parsers were narrowed to actual saved labels and visible value containers, with a/b class checks. A footer locator initially selected an earlier noncard occurrence and was corrected to the full card anchor. The reference-only validation adapter initially omitted required event context; existing source context now satisfies that interface without copying/filling a source match row or exporting mixed records. The report correctly switched to REVIEW_REQUIRED during that failure and was regenerated after correction. No retrieval failed, alternate source or set reconstruction was used.","",
    "Every next task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.")
  if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
}

mrf_snapshot <- function(paths) data.frame(path=paths,size=unname(file.info(paths)$size),
  sha256=unname(vapply(paths,pilot_sha256,"")),mtime=unname(as.numeric(file.info(paths)$mtime)))
mrf_self_test <- function(o) {
  reject<-function(expr)stopifnot(inherits(tryCatch(force(expr),error=identity),"error"))
  refs<-mr_manifest();t<-mrf_targets();source<-montreal_load()$selected$raw;original<-source
  h<-anomaly_html(refs$local_path[refs$reference_id=="LS001"]);card<-mrf_card(h,"LS001");row<-source[source$match_num=="238",]
  reject(mr_allow_url("https://www.wtatennis.com/tournaments/806/montreal/2022"))
  reject(mr_allow_url(paste0(mr_config()$url[1],"?extra=1")))
  reject(mr_match_guard(gsub("0806-2021-LS001","0806-2022-LS001",h,fixed=TRUE),"LS001"))
  reject(mr_match_guard(gsub("0806-2021-LS001","0999-2021-LS001",h,fixed=TRUE),"LS001"))
  reject(mr_match_guard(h,"LS002"))
  reject(mr_match_guard(gsub("karolina-pliskova","different-player",h,fixed=TRUE),"LS001"))
  reject(mr_match_guard(sub('(?s)(<div class="tennis-match__round[^>]*>)[[:space:]]*Final','\\1Quarterfinals',h,perl=TRUE),"LS001"))
  # Round markup includes whitespace, so directly test the parsed identity too.
  bad<-card;bad$round<-"QF";stopifnot(!mrf_identity(bad,row,"F"))
  bad<-card;bad$team[[1]]$slug<-"other-player";stopifnot(!mrf_identity(bad,row,"F"))
  bad<-card;bad$winner_side<-1L;stopifnot(!mrf_identity(bad,row,"F"))
  badrow<-row;badrow$tourney_id<-"2022-806";stopifnot(!mrf_identity(card,badrow,"F"))
  swapped<-card;swapped$team<-rev(card$team);swapped$winner_side<-3-card$winner_side
  stopifnot(mrf_identity(swapped,row,"F"))
  parsed<-mrf_stats(h,"LS001",card)
  # Synthetic reversal of each pair of whole-match values and both card identities.
  tab<-mrf_tab(h);blocks<-strsplit(tab,'<div class="compare-stats-block__row">',fixed=TRUE)[[1]]
  for(i in seq_along(blocks))for(cls in c("stat","detail")) {
    pattern<-paste0('(?s)<div class="compare-stats-block__',cls,' [^>]*>.*?</div>')
    values<-anomaly_matches(pattern,blocks[i])
    if(length(values)==2){blocks[i]<-sub(values[1],"MRF_PAIR_FIRST",blocks[i],fixed=TRUE);blocks[i]<-sub(values[2],values[1],blocks[i],fixed=TRUE);blocks[i]<-sub("MRF_PAIR_FIRST",values[2],blocks[i],fixed=TRUE)}
  }
  reversed_html<-paste0('<div class="mc-stats__tab-content js-match-stats"',paste(blocks,collapse='<div class="compare-stats-block__row">'))
  reversed<-mrf_stats(reversed_html,"LS001",swapped)
  key<-function(s)paste(s$source_side,s$field)
  stopifnot(identical(parsed$value,reversed$value[match(key(parsed),key(reversed))]))
  setcopy<-paste0(h,'<div class="mc-stats__tab-content js-set9-stats">',gsub("45/79","99/99",tab,fixed=TRUE))
  stopifnot(identical(parsed,mrf_stats(setcopy,"LS001",card)))
  reject(mrf_tab(paste0(h,'class="mc-stats__tab-content js-match-stats"',tab)))
  reject(mrf_tab(gsub("js-match-stats","js-set8-stats",h,fixed=TRUE)))
  stopifnot(mrf_exact("7",NA)$value==7,mrf_exact("57%","45/79",1)$value==45,mrf_exact("57%","45/79",2)$value==79,
    is.na(mrf_exact("57%",NA,1)$value),mrf_exact("57%",NA,1)$state=="unparseable",is.na(mrf_exact("",NA)$value),mrf_exact("0",NA)$value==0)
  missing<-mrf_stats(gsub("45/79","",h,fixed=TRUE),"LS001",card)
  stopifnot(is.na(missing$value[missing$page_side=="a"&missing$field=="svpt"]),all(nzchar(parsed$locator)))
  hidden<-gsub('class="compare-stats-block__stat ', 'style="display:none" class="compare-stats-block__stat ',h,fixed=TRUE)
  stopifnot(all(is.na(mrf_stats(hidden,"LS001",card)$value)))
  stopifnot(mrf_compare(NA,2)=="source_missing_official_present",mrf_compare("2",2)=="source_and_official_exact",
    mrf_compare("1",2)=="source_and_official_conflict",mrf_compare("1",NA,"missing")=="official_missing",
    mrf_compare("1",NA,"unparseable")=="official_unparseable",mrf_compare("1",2,oriented=FALSE)=="orientation_unresolved")
  invalid<-parsed;invalid$value[invalid$source_side=="w"&invalid$field=="1stIn"]<-1000L
  stopifnot(any(mrf_structural(row,invalid,card)$flagged_rows>0))
  invalid<-parsed;invalid$value[invalid$source_side=="w"&invalid$field=="ace"]<--1L
  stopifnot(any(mrf_structural(row,invalid,card)$flagged_rows>0))
  invalid<-parsed;invalid$value[invalid$source_side=="w"&invalid$field=="return_games"]<-99L
  stopifnot(any(mrf_structural(row,invalid,card)$flagged_rows>0))
  stopifnot(!pilot_game_check("6-4 7-6(2)","score_consistent_with_completion",11,11),
    pilot_game_check("6-4 7-6(2)","score_consistent_with_completion",12,11),
    !pilot_game_check("6-1 4-3 RET","retirement_marker",7,8),
    pilot_game_check("6-1 4-3","score_consistent_with_completion",7,8),
    !pilot_game_check("2-6 6-2 RET","retirement_marker",8,8))
  draw<-mrf_card(anomaly_html(refs$local_path[refs$reference_id=="draw_html"]),"LS001",TRUE)
  pdf<-o$`pdf-target-evidence`[1,];bad<-draw;bad$score<-"6-0 6-0"
  stopifnot(mrf_draw_state(card,bad,pdf)=="identity_or_score_conflict")
  badpdf<-pdf;badpdf$score_result<-"conflict";stopifnot(mrf_draw_state(card,draw,badpdf)=="identity_or_score_conflict")
  status<-o$`status-evidence`;s42<-status[status$match_code=="LS042",];s49<-status[status$match_code=="LS049",]
  stopifnot(s42$source_score=="6-1 4-3 RET+H64",s42$status_result=="official_retirement_confirmed_suffix_meaning_unresolved",
    s49$source_score=="2-6 6-2",s49$status_result=="official_retirement_confirmed_source_marker_missing",
    all(status$structured_status_conflict),all(status$draw_evidence_state[8:9]=="numeric_agreement_HTML_retirement_marker_omitted"))
  d<-o$`feasibility-dispositions`;cov<-o$`coverage-scenarios`
  stopifnot(all(d$required_fields_exactly_parsed==18),all(d$structural_check_result=="passed_all_applicable_checks"),
    !any(d$adopted_recovery_policy),all(d$model_admission=="not_authorized"),!any(cov$adopted_policy),all(cov$source_bundles_filled==0),
    cov$source_complete_bundles[1]==47,cov$denominator[1]==54,cov$official_candidate_bundles[3]==7,cov$official_candidate_bundles[4]==0,
    nrow(o$`official-stat-observations`)==180,nrow(o$`field-comparisons`)==162,
    sum(o$`field-comparisons`$comparison_state=="source_missing_official_present")==126,
    sum(o$`field-comparisons`$comparison_state=="source_and_official_exact")==36,
    all(o$`structural-checks`$flagged_rows==0),all(o$`structural-checks`$not_evaluable_rows==0),identical(source,original),
    all(is.na(source[source$match_num %in% t$match_num[1:7],montreal_fields()])))
  paths<-c(refs$local_path,"data/manifests/montreal-reference-files.csv",list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE),"docs/wta-2021-montreal-reference-feasibility.md")
  before<-mrf_snapshot(paths);download_montreal_references();audit_montreal_reference_feasibility();audit_montreal_reference_feasibility()
  stopifnot(identical(before,mrf_snapshot(paths)))
  badref<-refs[1,];badref$sha256<-paste(rep("0",64),collapse="");reject(mr_validate(badref))
  message("Phase 1G identity, extraction, comparison, structural/status, scope and byte/mtime rerun tests passed.")
}

if(sys.nframe()==0L){
  o<-audit_montreal_reference_feasibility()
  if("--self-test" %in% commandArgs(trailingOnly=TRUE))mrf_self_test(o)
  print(o$`coverage-scenarios`[c("scenario","source_complete_bundles","official_candidate_bundles","coverage_pct","adopted_policy")],row.names=FALSE)
}
