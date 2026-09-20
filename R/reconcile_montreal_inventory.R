# Phase 1J: saved main-draw inventory only; no admission, chronology or count merge.
source("R/implement_montreal_recovery.R")
source("R/reconcile_indian_wells_inventory.R")

mji_dir <- function() "data/pilot/development-2021/montreal-inventory"
mji_rounds <- function() c("R64","R32","R16","QF","SF","F")
mji_contract <- function() data.frame(criterion=c(
  "pinned_evidence_and_overlay_unchanged", "main_draw_singles_isolated",
  "HTML_bracket_positions_entrants_byes_progression", "PDF_bracket_positions_entrants_byes_progression",
  "event_scoped_identities_resolved", "unique_source_keys", "unique_official_keys",
  "every_source_has_one_official_nonbye", "every_official_nonbye_has_one_source",
  "round_winner_score_agree", "status_differences_within_existing_policy_scope",
  "HTML_PDF_agree_or_existing_scoped_resolution", "code_gaps_accounted_for_without_inventing_codes",
  "source_reference_overlay_layers_separate"), stringsAsFactors=FALSE)
# COMPLETE requires every criterion, irrespective of eventual row totals. A parser
# failure is BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE; an unresolved comparison is REVIEW_REQUIRED.
mji_need <- function(ok, text) if(!isTRUE(ok)) stop(text,call.=FALSE)
mji_norm <- function(x) inventory_name(gsub("-"," ",chartr("ñÑ","nN",x),fixed=TRUE))
mji_clean <- function(x) gsub("&apos;","'",anomaly_text(x),fixed=TRUE)
mji_round <- function(x) unname(c(`64`="R64",`32`="R32",`16`="R16",`8`="QF",`4`="SF",`2`="F")[x])
mji_provenance <- function(x, ref, method) {
  x$reference_id<-ref$reference_id;x$reference_sha256<-ref$sha256
  x$reference_byte_size<-ref$byte_size;x$reference_retrieved_at_utc<-ref$retrieved_at_utc
  x$extraction_method<-method;x$event<-"WTA:2021:806:main-draw-singles"
  x
}
mji_record <- function(ref, round, position, code, p1, p2, id1, id2, full1, full2,
                       winner_side, score, raw, marker, locator, review="parsed",compact=FALSE) {
  bye <- any(c(p1,p2)=="BYE")
  normalized <- if(bye) "" else inventory_score(score,compact=compact)
  status <- inventory_status(normalized,bye)
  data.frame(record_id=paste(ref,round,position,sep=":"),round=round,bracket_position=position,
    official_code=code,player_one=p1,player_two=p2,player_one_id=id1,player_two_id=id2,
    player_one_full=full1,player_two_full=full2,winner_side=winner_side,
    winner=if(winner_side==1)full1 else if(winner_side==2)full2 else NA_character_,
    raw_score=score,normalized_score=normalized,status=status,raw_status_marker=marker,
    retirement_marker=grepl("RET",marker,fixed=TRUE),walkover_marker=grepl("WO",marker,fixed=TRUE),
    bye=bye,raw_text=raw,locator=locator,parser_review_state=review,stringsAsFactors=FALSE)
}

mji_html <- function(html,ref) {
  # Split actual event tabs, not navigation labels or all page-wide LS code hits.
  tabs<-anomaly_matches('(?s)<div class="tournament-draw__tab[^>]*data-event-type="[A-Z]+"[^>]*>',html)
  starts<-gregexpr('<div class="tournament-draw__tab[^>]*data-event-type="[A-Z]+"[^>]*>',html,perl=TRUE)[[1]]
  which_tab<-which(grepl('data-event-type="LS"',tabs,fixed=TRUE))
  mji_need(length(which_tab)==1,"Unique main-draw singles tab unavailable")
  i<-which_tab;end<-if(i<length(starts))starts[i+1]-1 else nchar(html)
  tab<-substr(html,starts[i],end)
  mji_need(!grepl('data-event-type="(LD|RS|RD)"|js-match-0806-2021-(LD|RS|RD)',tab,perl=TRUE),"Doubles/qualifying contamination inside singles tab")
  pieces<-strsplit(tab,'data-round-class-index="',fixed=TRUE)[[1]][-1]
  mji_need(length(pieces)==6,"Six singles round containers required")
  result<-list()
  for(piece in pieces) {
    round<-mji_round(anomaly_capture('data-round="([0-9]+)"',piece))
    mji_need(!is.na(round),"Unknown singles round")
    cards<-strsplit(piece,'<div class="tournament-draw__lines-container js-match-table"',fixed=TRUE)[[1]][-1]
    for(j in seq_along(cards)) {
      block<-strsplit(cards[j],"</table>",fixed=TRUE)[[1]][1]
      counter<-anomaly_capture('data-match-counter="([0-9]+)"',block)
      code<-anomaly_capture('js-match-0806-2021-(LS[0-9]{3})',block)
      names<-ids<-full<-character();sets<-tb<-raw_cells<-list();win<-logical();byes<-logical()
      for(side in c("a","b")) {
        row<-anomaly_capture(paste0('(?s)(<tr class="match-table__row js-team-',side,'[^>]*>.*?</tr>)'),block)
        mji_need(!is.na(row),"Missing HTML team row")
        bye<-grepl('match-table__player-name--bye',row,fixed=TRUE);byes<-c(byes,bye)
        name<-if(bye)"BYE" else mji_clean(anomaly_capture('(?s)<span class="match-table__player-fullname">(.*?)</span>',row))
        id<-if(bye)"" else anomaly_capture('href="/players/([0-9]+)/',row)
        slug<-if(bye)"BYE" else anomaly_capture('href="/players/[0-9]+/([^"/]+)',row)
        names<-c(names,name);ids<-c(ids,id);full<-c(full,slug)
        win<-c(win,grepl("is-winner",strsplit(row,">",fixed=TRUE)[[1]][1],fixed=TRUE))
        cells<-anomaly_matches('(?s)<td class="match-table__score-cell[^>]*>.*?</td>',row)
        raw_cells[[side]]<-paste(cells,collapse="\n")
        scores<-vapply(cells,function(z)mji_clean(gsub('(?s)<sup.*?</sup>',"",z,perl=TRUE)),"")
        tiebreak<-vapply(cells,function(z)anomaly_capture('(?s)<sup[^>]*>([0-9]+)</sup>',z),"")
        take<-grepl("^[0-9]+$",scores);sets[[side]]<-scores[take];tb[[side]]<-tiebreak[take]
      }
      mji_need(sum(win)==1&&!anyNA(c(names,ids,full)),"HTML identity/advancement unavailable")
      w<-which(win);l<-3-w;wo<-grepl('title="Walk over"',block,fixed=TRUE)
      ret<-grepl('title="Retired"',block,fixed=TRUE)
      mji_need(length(sets[[1]])==length(sets[[2]]),"Unequal HTML score cells")
      if(any(byes)) score<-"" else if(wo)score<-"WO" else {
        loser_tb<-ifelse(as.numeric(sets[[w]])<as.numeric(sets[[l]]),tb[[w]],tb[[l]])
        score<-paste(paste0(sets[[w]],"-",sets[[l]],ifelse(is.na(loser_tb),"",paste0("(",loser_tb,")"))),collapse=" ")
        if(ret)score<-paste(score,"RET")
      }
      marker<-paste(c(if(wo)"WO",if(ret)"RET",paste0("data-status=",anomaly_capture('data-status="([^"]+)"',block))),collapse=";")
      record<-mji_record("draw_html",round,j,code,names[1],names[2],ids[1],ids[2],full[1],full[2],w,score,
        paste(c(names,score,marker),collapse=" | "),marker,paste0("data-event-type=LS; round=",round,"; DOM block=",j,"; data-match-counter=",counter))
      record$score_cells_a_raw<-raw_cells[["a"]];record$score_cells_b_raw<-raw_cells[["b"]]
      result[[length(result)+1]]<-record
    }
  }
  mji_provenance(do.call(rbind,result),ref,"LS-tab round containers; complete match-table traversal including uncoded and bye cards")
}

mji_pdf_xml <- function(path) {
  executable<-Sys.getenv("ANOMALY_PDFTOTEXT",unset=unname(Sys.which("pdftotext")))
  if(!nzchar(executable))executable<-path.expand("~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext")
  mji_need(file.exists(executable),"Existing pdftotext unavailable")
  x<-system2(executable,c("-bbox-layout",shQuote(path),"-"),stdout=TRUE)
  mji_need(is.null(attr(x,"status")),"PDF text extraction failed")
  paste(x,collapse="\n")
}
mji_pdf <- function(xml,ref) {
  pages<-anomaly_matches('(?s)<page .*?</page>',xml)
  mji_need(length(pages)==1,"Expected pinned one-page singles PDF")
  plain<-mji_clean(pages[1])
  mji_need(all(vapply(c("MAIN DRAW SINGLES","MONTREAL, CAN","August 7-15 2021"),function(x)grepl(x,plain,fixed=TRUE),TRUE)) &&
    !grepl("MAIN DRAW DOUBLES|QUALIFYING SINGLES",plain),"PDF singles/event/year isolation failed")
  lines<-anomaly_matches('(?s)<line .*?</line>',pages[1]); roster<-cells<-list()
  # These measured column starts belong to the pinned PDF, never to source rows.
  anchors<-c(250.77,318.57,377.25,435.93,494.61)
  for(line in lines) {
    words<-anomaly_matches('(?s)<word .*?</word>',line)
    x<-as.numeric(vapply(words,function(z)anomaly_capture('xMin="([^"]+)"',z),""))
    y<-as.numeric(vapply(words,function(z)anomaly_capture('yMin="([^"]+)"',z),""))
    text<-vapply(words,mji_clean,"")
    if(!length(x)||min(y)<100||max(y)>631)next
    # Entrant names start in the left bracket column; strip only printed seed/Q/WC tokens.
    take<-x>69 & x<220
    if(any(take) && (any(grepl(",",text[take],fixed=TRUE))||(sum(take)==1 && text[take]=="BYE"))) {
      roster[[length(roster)+1]]<-data.frame(y=min(y[take]),name=paste(text[take],collapse=" "),locator=paste0("PDF p1 entrant x=",min(x[take])," y=",min(y[take])))
    }
    at_column<-vapply(x,function(v)any(abs(v-anchors)<.5)||abs(v-263.85)<.5,TRUE)
    at_final<-(abs(x-489.45)<.5|abs(x-503.97)<.5)&y>350&y<375
    start<-which((at_column|at_final) &
      grepl("^([A-Za-z]+[.]|[0-9]+(\\([0-9]+\\))?|WO|Camila)$",text))
    for(k in seq_along(start)) {
      a<-start[k];b<-if(k<length(start))start[k+1]-1 else length(x)
      col<-if(abs(x[a]-489.45)<.5||abs(x[a]-503.97)<.5)6L else if(abs(x[a]-263.85)<.5)1L else which.min(abs(x[a]-anchors))
      cells[[length(cells)+1]]<-data.frame(stage=col,x=x[a],y=y[a],text=paste(text[a:b],collapse=" "),
        locator=paste0("PDF p1 word segment x=",x[a]," y=",y[a]))
    }
  }
  roster<-do.call(rbind,roster);roster<-roster[order(roster$y),];rownames(roster)<-NULL
  mji_need(nrow(roster)>1 && log2(nrow(roster))==round(log2(nrow(roster))),"PDF bracket entrant positions incomplete")
  cells<-do.call(rbind,cells);prior<-roster$name;out<-list()
  mji_need(length(prior)==64,"Pinned PDF's numbered 64-position bracket changed")
  for(stage in 1:6) {
    z<-cells[cells$stage==stage,];z<-z[order(z$y),]
    is_score<-grepl("^[0-9]|^WO$",z$text);advance<-z[!is_score,];scores<-z[is_score,]
    mji_need(nrow(advance)==length(prior)/2,paste("PDF result column incomplete",stage,nrow(advance)))
    next_round<-character(nrow(advance))
    for(i in seq_len(nrow(advance))) {
      pair<-prior[c(2*i-1,2*i)];selected<-inventory_resolve_name(advance$text[i],pair)
      mji_need(length(selected)==1,paste("PDF advancing identity ambiguous",stage,i,advance$text[i]))
      next_round[i]<-pair[selected];bye<-"BYE" %in% pair
      end<-if(i<nrow(advance))advance$y[i+1] else Inf
      sc<-scores[scores$y>advance$y[i]&scores$y<end,,drop=FALSE]
      mji_need(if(bye)nrow(sc)==0 else nrow(sc)==1,paste("PDF score placement missing/ambiguous",stage,i))
      score<-if(bye)"" else sc$text
      marker<-if(grepl("RET$",score))"RET" else if(score=="WO")"WO" else "no_explicit_status_marker"
      locator<-paste(c(advance$locator[i],sc$locator),collapse="; ")
      out[[length(out)+1]]<-mji_record("draw_pdf",mji_rounds()[stage],i,NA_character_,pair[1],pair[2],"","",pair[1],pair[2],selected,
        score,paste(c(pair,advance$text[i],score),collapse=" | "),marker,locator,compact=TRUE)
    }
    prior<-next_round
  }
  x<-mji_provenance(do.call(rbind,out),ref,"pinned PDF word-coordinate columns; left roster and independent feeder-bracket traversal")
  attr(x,"roster")<-roster
  x
}

mji_bracket <- function(x) {
  ok<-nrow(x)==63&&!anyDuplicated(x$record_id)&&all(x$parser_review_state=="parsed")
  entrants<-x[x$round=="R64",];roster<-c(entrants$player_one_full,entrants$player_two_full)
  ok<-ok && length(roster)==64 && !anyDuplicated(mji_norm(roster[roster!="BYE"]))
  for(k in seq_along(mji_rounds())) {
    z<-x[x$round==mji_rounds()[k],];z<-z[order(z$bracket_position),]
    ok<-ok && nrow(z)==64/2^k && identical(as.integer(z$bracket_position),seq_len(nrow(z)))
    if(k>1) {
      prev<-x[x$round==mji_rounds()[k-1],];prev<-prev[order(prev$bracket_position),]
      for(i in seq_len(nrow(z)))ok<-ok && setequal(mji_norm(c(z$player_one_full[i],z$player_two_full[i])),mji_norm(prev$winner[c(2*i-1,2*i)]))
    }
    ok<-ok && all(vapply(seq_len(nrow(z)),function(i)z$winner[i] %in% c(z$player_one_full[i],z$player_two_full[i]) && z$winner[i]!="BYE",TRUE))
  }
  isTRUE(ok && sum(x$bye)==sum(roster=="BYE") && all(x$round[x$bye]=="R64"))
}

mji_source_roster <- function(source) unique(rbind(
  data.frame(source_id=source$winner_id,source_name=source$winner_name),
  data.frame(source_id=source$loser_id,source_name=source$loser_name)))
mji_key <- function(round,a,b) {
  ifelse(is.na(a)|is.na(b)|is.na(round),NA_character_,paste("WTA:2021:806:main-draw-singles",round,pmin(a,b),pmax(a,b),sep="|"))
}
mji_identities <- function(html,pdf,source) {
  first<-html[html$round=="R64",]
  roster<-unique(rbind(data.frame(official_id=first$player_one_id,html_display=first$player_one,html_full=first$player_one_full),
    data.frame(official_id=first$player_two_id,html_display=first$player_two,html_full=first$player_two_full)))
  roster<-roster[roster$html_full!="BYE",];roster<-roster[order(roster$official_id),]
  pr<-pdf[pdf$round=="R64",];pdf_names<-unique(c(pr$player_one_full,pr$player_two_full));pdf_names<-pdf_names[pdf_names!="BYE"]
  sr<-mji_source_roster(source);decisions<-list()
  for(i in seq_len(nrow(roster))) {
    r<-roster[i,];name<-mji_norm(r$html_full)
    alias<-name %in% c("cori gauff","alison riske")
    lookup<-if(name=="cori gauff")"coco gauff" else if(name=="alison riske")"alison riske amritraj" else name
    candidates<-which(mji_norm(sr$source_name)==lookup);p<-which(mji_norm(pdf_names)==name)
    unique_id<-length(candidates)==1 && length(p)==1 && sum(roster$official_id==r$official_id)==1
    decisions[[i]]<-data.frame(official_id=r$official_id,html_display=r$html_display,html_full=r$html_full,
      pdf_original_names=paste(pdf_names[p],collapse=";"),source_candidate_ids=paste(sr$source_id[candidates],collapse=";"),
      source_candidate_names=paste(sr$source_name[candidates],collapse=";"),
      source_id=if(unique_id)sr$source_id[candidates] else NA_character_,
      source_name=if(unique_id)sr$source_name[candidates] else NA_character_,
      method=if(alias)"bounded_alias_pending_opponent_round_corroboration" else "exact_normalized_full_event_roster",
      scope="WTA_2021_806_main_draw_singles_only",state=if(unique_id)"resolved" else "ambiguous_or_unmatched_identity",
      corroborating_opponents_rounds="",stringsAsFactors=FALSE)
  }
  d<-do.call(rbind,decisions)
  # All opponent/round corroboration is recorded before constructing match links.
  for(i in seq_len(nrow(d))) {
    games<-html[!html$bye & (html$player_one_id==d$official_id[i]|html$player_two_id==d$official_id[i]),]
    checks<-character();resolved<-TRUE
    for(j in seq_len(nrow(games))) {
      g<-games[j,];other<-if(g$player_one_id==d$official_id[i])g$player_two_id else g$player_one_id
      opponent<-d$source_id[match(other,d$official_id)]
      key<-mji_key(g$round,d$source_id[i],opponent)
      sk<-mji_key(source$round,source$winner_id,source$loser_id)
      hits<-which(!is.na(sk)&!is.na(key)&sk==key)
      checks<-c(checks,paste(g$round,other,opponent,paste(source$match_num[hits],collapse=","),sep=":"))
      resolved<-resolved && length(hits)==1
    }
    d$corroborating_opponents_rounds[i]<-paste(checks,collapse=";")
    if(d$method[i]=="bounded_alias_pending_opponent_round_corroboration") {
      existing<-games$official_code=="LS006"
      gauff<-mji_norm(d$html_full[i])=="cori gauff"
      scope_ok<-if(gauff)nrow(games)>1&&any(existing,na.rm=TRUE) else nrow(games)==1&&games$round=="R64"
      if(resolved && scope_ok && d$state[i]=="resolved")
        d$method[i]<-if(gauff)"existing_LS006_alias_extended_to_event_after_all_opponent_round_checks" else "Riske_Riske_Amritraj_exact_event_candidate_R64_opponent_corroborated"
      else {d$state[i]<-"ambiguous_or_unmatched_identity";d$source_id[i]<-NA_character_}
    }
  }
  d
}
mji_attach_ids <- function(x,identities) {
  lookup<-function(full) identities$source_id[match(mji_norm(full),mji_norm(identities$html_full))]
  x$source_player_one_id<-lookup(x$player_one_full);x$source_player_two_id<-lookup(x$player_two_full)
  x$source_winner_id<-lookup(x$winner)
  x$match_key<-mji_key(x$round,x$source_player_one_id,x$source_player_two_id)
  x
}
mji_numeric <- function(score) sub(" RET.*$","",score)
mji_policy_resolution <- function(id,code,hs,ps,source_score) {
  # No general precedence is inferred from the two adopted retirement observations.
  if(isTRUE(id=="sackmann:WTA:2021-806:260" && code=="LS042" && hs=="unresolved" && ps=="retirement" && source_score=="6-1 4-3 RET+H64"))
    return("official_retirement_confirmed_suffix_meaning_unresolved")
  if(isTRUE(id=="sackmann:WTA:2021-806:253" && code=="LS049" && hs=="unresolved" && ps=="retirement" && source_score=="2-6 6-2"))
    return("official_retirement_confirmed_source_marker_missing")
  NA_character_
}
mji_code_state <- function(html) {
  codes<-html$official_code[!is.na(html$official_code)];gap<-setdiff(sprintf("LS%03d",1:63),codes)
  un<-html[is.na(html$official_code),]
  expected<-length(gap)==1&&gap=="LS013"&&nrow(un)==1&&un$round=="R16"&&un$bracket_position==6&&un$walkover_marker
  data.frame(unique_codes=length(unique(codes)),duplicate_codes=anyDuplicated(codes)>0,
    absent_code_labels=paste(gap,collapse=";"),uncoded_records=nrow(un),
    uncoded_record_ids=paste(un$record_id,collapse=";"),
    state=if(expected&&!anyDuplicated(codes))"code_gap_accounted_for_by_uncoded_walkover_card_no_code_assigned" else "unexplained_code_gap_or_duplicate",
    cause="Underlying reason for omitted code attribute unknown; no LS013 code synthesized",stringsAsFactors=FALSE)
}

mji_compare <- function(html,pdf,source,overlay,evidence_verified=FALSE) {
  mji_need(all(source$tourney_id=="2021-806"&source$tourney_name=="Montreal"),"Source event outside scoped Montreal inventory")
  contract<-mji_contract();gates<-setNames(rep(FALSE,nrow(contract)),contract$criterion)
  identity<-mji_identities(html,pdf,source)
  h<-mji_attach_ids(html,identity);p<-mji_attach_ids(pdf,identity)
  sk<-mji_key(source$round,source$winner_id,source$loser_id)
  src<-data.frame(audit_id=paste0("sackmann:WTA:2021-806:",source$match_num),round=source$round,
    winner_id=source$winner_id,loser_id=source$loser_id,source_score=source$score,
    source_status=ifelse(grepl("RET",source$score),"retirement",ifelse(source$score %in% c("W/O","WO"),"walkover",vapply(source$score,inventory_status,""))),
    numeric_score=mji_numeric(gsub("W/O","WO",source$score,fixed=TRUE)),match_key=sk,stringsAsFactors=FALSE)
  # Match numbers survive only as source identifiers, never as linkage or time order.
  h<-h[!h$bye,];p<-p[!p$bye,];links<-list();refs<-list()
  for(i in seq_len(nrow(src))) {
    s<-src[i,];hi<-which(!is.na(h$match_key)&!is.na(s$match_key)&h$match_key==s$match_key)
    pi<-which(!is.na(p$match_key)&!is.na(s$match_key)&p$match_key==s$match_key)
    state<-if(sum(src$match_key==s$match_key,na.rm=TRUE)>1)"duplicate_source_key" else if(length(hi)>1||length(pi)>1)"duplicate_official_key" else
      if(length(hi)!=1||length(pi)!=1)"source_only_unmatched" else "linked"
    hs<-ps<-hc<-pc<-hr<-pr<-hw<-pw<-policy<-NA_character_;winner_ok<-score_ok<-status_ok<-FALSE
    if(state=="linked") {
      a<-h[hi,];b<-p[pi,];hs<-a$status;ps<-b$status;hc<-a$normalized_score;pc<-b$normalized_score
      hr<-a$record_id;pr<-b$record_id;hw<-a$source_winner_id;pw<-b$source_winner_id
      winner_ok<-isTRUE(hw==s$winner_id&&pw==s$winner_id)
      score_ok<-isTRUE(mji_numeric(hc)==s$numeric_score&&mji_numeric(pc)==s$numeric_score)
      policy<-mji_policy_resolution(s$audit_id,a$official_code,hs,ps,s$source_score)
      # An adopted decision controls only its exact corroborated result/score.
      if(!winner_ok||!score_ok)policy<-NA_character_
      status_ok<-isTRUE(hs==ps&&ps==s$source_status&&ps!="unresolved") || !is.na(policy)
      state<-if(!winner_ok)"linked_with_winner_or_result_conflict" else if(!score_ok)"linked_with_score_conflict" else
        if(!is.na(policy))"existing_adopted_match_scoped_resolution" else if(!status_ok)"linked_with_status_detail_difference" else "exact_identity_result_score_agreement"
    }
    overlay_present<-s$audit_id %in% unique(overlay$field_decisions$source_audit_id)
    count_present<-all(!is.na(source[i,montreal_fields()]))
    links[[i]]<-data.frame(source_audit_id=s$audit_id,match_key=s$match_key,round=s$round,
      html_record_id=hr,pdf_record_id=pr,official_code=if(length(hi)==1)h$official_code[hi] else NA_character_,
      html_link_count=length(hi),pdf_link_count=length(pi),source_winner=s$winner_id,html_winner=hw,pdf_winner=pw,
      source_score=s$source_score,html_score=hc,pdf_score=pc,source_status=s$source_status,html_status=hs,pdf_status=ps,
      comparison_state=state,winner_agreement=winner_ok,score_agreement=score_ok,status_resolved=status_ok,
      adopted_resolution=policy,unresolved=!(winner_ok&&score_ok&&status_ok),
      count_layer=if(overlay_present)"approved_supplemental_overlay_bundle_separate" else if(s$source_status=="walkover")"source_walkover_outside_apparent_play_count_coverage" else if(count_present)"original_source_counts" else "source_counts_missing",
      source_statistical_quarantine="none_adopted_for_this_event",analytical_eligibility="NOT_EVALUATED",chronology="UNRESOLVED",stringsAsFactors=FALSE)
  }
  links<-do.call(rbind,links);links<-links[order(links$match_key,links$source_audit_id),];rownames(links)<-NULL
  for(i in seq_len(nrow(h))) {
    a<-h[i,];pi<-which(!is.na(p$match_key)&!is.na(a$match_key)&p$match_key==a$match_key)
    li<-which(links$html_record_id==a$record_id)
    result<-"HTML_PDF_reference_conflict";resolved<-FALSE
    if(length(pi)==1 && length(li)==1) {
      b<-p[pi,];l<-links[li,]
      agree<-isTRUE(a$source_winner_id==b$source_winner_id && mji_numeric(a$normalized_score)==mji_numeric(b$normalized_score))
      if(agree&&a$status==b$status&&a$status!="unresolved"){result<-"exact_identity_result_score_agreement";resolved<-TRUE}
      else if(agree&&!is.na(l$adopted_resolution)){result<-"existing_adopted_match_scoped_resolution";resolved<-TRUE}
    }
    refs[[i]]<-data.frame(html_record_id=a$record_id,pdf_record_id=if(length(pi)==1)p$record_id[pi] else NA_character_,
      official_code=a$official_code,comparison_state=result,resolved=resolved,
      html_raw_score=a$raw_score,pdf_raw_score=if(length(pi)==1)p$raw_score[pi] else NA_character_,
      html_status=a$status,pdf_status=if(length(pi)==1)p$status[pi] else NA_character_)
  }
  references<-do.call(rbind,refs)
  uh<-h$record_id[is.na(h$match_key)|!h$match_key %in% src$match_key]
  up<-p$record_id[is.na(p$match_key)|!p$match_key %in% src$match_key]
  unmatched<-rbind(data.frame(representation=rep("draw_html",length(uh)),record_id=uh),
    data.frame(representation=rep("draw_pdf",length(up)),record_id=up))
  code<-mji_code_state(html)
  gates[1]<-isTRUE(evidence_verified) # Supplied by the validated outer workflow.
  gates[2]<-all(html$event=="WTA:2021:806:main-draw-singles")&&all(pdf$event=="WTA:2021:806:main-draw-singles")
  gates[3]<-mji_bracket(html);gates[4]<-mji_bracket(pdf)
  gates[5]<-all(identity$state=="resolved") && !anyNA(c(h$match_key,p$match_key)) && nrow(identity)==nrow(mji_source_roster(source))
  gates[6]<-!anyNA(sk)&&!anyDuplicated(sk)
  gates[7]<-!anyDuplicated(h$match_key)&&!anyDuplicated(p$match_key)
  gates[8]<-all(links$html_link_count==1&links$pdf_link_count==1)
  gates[9]<-nrow(unmatched)==0&&nrow(h)==nrow(src)&&nrow(p)==nrow(src)
  gates[10]<-all(links$winner_agreement&links$score_agreement)
  gates[11]<-all(links$status_resolved)
  gates[12]<-all(references$resolved)&&nrow(references)==nrow(p)
  gates[13]<-code$state=="code_gap_accounted_for_by_uncoded_walkover_card_no_code_assigned"
  gates[14]<-!any(montreal_fields() %in% names(links))&&sum(links$count_layer=="approved_supplemental_overlay_bundle_separate")==7
  contract$passed<-unname(gates)
  list(state=if(all(gates))"COMPLETE" else "REVIEW_REQUIRED",criteria=contract,identities=identity,
    html=html,pdf=pdf,source_inventory=src,links=links,reference_comparisons=references,official_only=unmatched,code_sequence=code)
}

mji_totals <- function(x,representation) {
  if(is.null(x))return(data.frame(representation=representation,bracket_positions=NA_integer_,entrants=NA_integer_,byes=NA_integer_,bracket_blocks=NA_integer_,nonbye_results=NA_integer_,walkovers=NA_integer_,explicit_retirements=NA_integer_,unresolved_status=NA_integer_))
  first<-x[x$round=="R64",];names<-c(first$player_one_full,first$player_two_full)
  data.frame(representation=representation,bracket_positions=length(names),entrants=sum(names!="BYE"),byes=sum(x$bye),
    bracket_blocks=nrow(x),nonbye_results=sum(!x$bye),walkovers=sum(x$walkover_marker),explicit_retirements=sum(x$retirement_marker),unresolved_status=sum(x$status=="unresolved"))
}
mji_report <- function(o,source_rows) {
  totals<-rbind(mji_totals(o$html,"HTML"),mji_totals(o$pdf,"PDF"))
  reviewed<-!is.null(o$links) && o$state=="REVIEW_REQUIRED" && source_rows==55 &&
    all(totals$bracket_positions==64&totals$entrants==56&totals$byes==8&totals$nonbye_results==55) &&
    all(o$links$html_link_count==1&o$links$pdf_link_count==1) && all(o$links$winner_agreement&o$links$score_agreement) &&
    setequal(o$links$official_code[o$links$unresolved],c("LS026","LS036","LS054")) &&
    all(o$identities$state=="resolved") && nrow(o$official_only)==0
  if(!isTRUE(reviewed)) {
    lines<-c("# WTA 2021 Montreal inventory reconciliation","",paste0("Reconciliation state: **",o$state,"**."),"",
      "The result differs from the reviewed Phase 1J profile; no saved narrative is reused. Event admission and analytical coverage remain NOT_EVALUATED; modeling remains FALSE; publication remains blocked.","",
      pilot_markdown_table(totals),"",if(!is.null(o$criteria))pilot_markdown_table(o$criteria) else paste("Extraction blocker:",o$error))
    path<-"docs/wta-2021-montreal-inventory-reconciliation.md"
    if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
    return(invisible(totals))
  }
  lines<-c("# WTA 2021 Montreal inventory reconciliation", "",
    paste0("Phase 1J, 2026-09-20. **Inventory reconciliation: ",o$state,".** Source rows: ",source_rows,". This is not an event-admission pass."),"",
    "## Contract fixed before comparison", "",
    "The implementation defines fourteen criteria before comparing totals. COMPLETE requires every criterion: independent singles isolation and bracket traversal; entrants/byes/round advancement; resolved event identities; unique keys and one-to-one non-bye links in both directions; agreeing rounds, winners and scores; status/reference differences covered by an existing exact scoped policy; accounted code gaps; immutable evidence and separate recovery layers. Parser insufficiency yields BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE; unresolved comparisons yield REVIEW_REQUIRED. Source row totals are not parser targets.","",
    "Event admission and analytical coverage remain NOT_EVALUATED; modeling_authorized remains FALSE. Chronology and retirement/walkover analytical eligibility remain unresolved. Publication remains blocked pending rights review.","",
    "## Independently extracted official inventories", "",pilot_markdown_table(totals),"",
    "HTML extraction isolates the data-event-type=LS tab, excluding LD doubles and RS qualifying. It traverses every round container and match table, including byes and cards with no LS code. IDs, abbreviations, full player slugs, winner indicators, score cells, tie-break superscripts, status attributes, markers/omissions and DOM locators remain separate observations.","",
    "PDF extraction uses the pinned one-page MAIN DRAW SINGLES header, Montreal/year checks, independently read left-column entrants and measured result-column coordinates. Word-level segments separate adjacent columns that pdftotext merges into one line. Feeder pairs are constructed from prior PDF advancement, never Sackmann. Entrant/result coordinates and original compact scores remain local. The complete PDF layout was visually inspected. Neither parser receives source rows as a template.","")
  if(!is.null(o$links)) {
    rounds<-data.frame(round=mji_rounds(),HTML_nonbye=vapply(mji_rounds(),function(r)sum(o$html$round==r&!o$html$bye),0L),PDF_nonbye=vapply(mji_rounds(),function(r)sum(o$pdf$round==r&!o$pdf$bye),0L))
    l<-o$links;un<-l[l$unresolved,]
    aggregate<-data.frame(measure=c("one_to_one_source_links","source_only_unmatched","official_only_unmatched","duplicate_source_keys","duplicate_HTML_keys","duplicate_PDF_keys","ambiguous_or_unmatched_identities","winner_conflicts","score_conflicts","raw_status_detail_differences","existing_scoped_resolutions","unresolved_status_differences","unresolved_HTML_PDF_conflicts"),
      value=c(sum(l$html_link_count==1&l$pdf_link_count==1),sum(l$html_link_count==0|l$pdf_link_count==0),nrow(o$official_only),
        sum(duplicated(o$source_inventory$match_key)),sum(duplicated(l$html_record_id[!is.na(l$html_record_id)])),sum(duplicated(l$pdf_record_id[!is.na(l$pdf_record_id)])),
        sum(o$identities$state!="resolved"),sum(!l$winner_agreement),sum(!l$score_agreement),sum(l$html_status!=l$pdf_status,na.rm=TRUE),sum(!is.na(l$adopted_resolution)),sum(!l$status_resolved),sum(!o$reference_comparisons$resolved)))
    lines<-c(lines,pilot_markdown_table(rounds),"","## Linkage and comparison results","",pilot_markdown_table(aggregate),"",
      "Links use the event/draw, round and unordered resolved source-player ID pair. Winner, score and status comparisons occur afterward. Source match_num is retained only in the audit identifier; row order and match number are not dates, sequencing or linkage keys.","",
      "HTML and PDF each yield 63 bracket blocks: eight bye advancements and 55 non-bye results. The latter include one walkover; 54 describe apparent play. Score agreement here means normalized winner-oriented numeric score agreement, with RET/WO/suffix detail retained and separately evaluated; it does not mean the raw strings agree.","",
      "## Identity decisions","",
      "The event-scoped table records all 56 entrants, source candidate IDs/names, official IDs, both original labels, normalization method and opponent/round corroboration. No fuzzy matching is used. Case, punctuation, name order and explicit ñ-to-n normalization are formatting rules. General transliteration on this runtime split Garbiñe incorrectly; the explicit character rule preserves Garbine without changing originals.","",
      "Cori Gauff/Coco Gauff extends the already documented LS006 linkage only within this event, after all four opponent/round pairings agree, including the uncoded walkover. Alison Riske/Alison Riske Amritraj is a bounded exact candidate decision corroborated by the shared R64 Sorana Cirstea pairing in both official representations and source. It is not a global alias or a claim about the reason for the name change. All other full event-roster names resolve by deterministic normalization.","",
      "## LS-code sequence","",pilot_markdown_table(o$code_sequence),"",
      "The HTML contains 62 unique supplied LS codes in the LS001–LS063 range. The uncoded R16 block at position 6, between coded LS012 and LS014 blocks, contains Gauff versus Konta and an explicit WO advancement. The PDF independently shows the same pair and walkover, and the source has its corresponding row. Thus an uncoded card accounts for the result at the code-sequence gap; no match is synthesized and no LS013 code is assigned. The publisher's reason for omitting the attribute remains unknown. Eight bye cards are retained separately; they do not explain this particular gap.","",
      "## Remaining blockers","",
      pilot_markdown_table(un[c("source_audit_id","official_code","round","source_status","html_status","pdf_status","comparison_state")]),"",
      "LS036 (Sakkari–Bouzkova), LS054 (Konta–Zhang) and LS026 (Gauff–Potapova) have RET in source/PDF but no retirement marker in the HTML draw; numeric scores and advancing players agree. They remain unresolved status-detail/reference conflicts. The saved PDF also names the retiring players in its retirement legend. No new match-page evidence was acquired, and the existing LS042/LS049 policy was not extended to these matches.","",
      "The adopted policy resolves only LS042/Martincova and LS049/Tomljanovic in this audit, preserving their raw HTML omissions, source scores and EventScheduled observations in the unchanged Phase 1I layer. H64/H61 remain unexplained. The seven completed-match recovery resolutions are neither rewritten nor generalized. There are no remaining identity, round, winner, normalized numeric score, duplicate or unmatched conflicts; the three status differences prevent COMPLETE.","",
      "## Criterion results","",pilot_markdown_table(o$criteria),"")
  } else lines<-c(lines,"## Extraction blocker","",o$error,"","No incomplete official extraction is promoted to a complete inventory.","")
  lines<-c(lines,"## Evidence, separation and rights","",
    "All twelve files in [the Montreal manifest](../data/manifests/montreal-reference-files.csv), relevant annual files and the three Phase 1I manifest pins are revalidated. Archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. The Phase 1I release is rebuilt in memory and compared with the existing RDS; its bytes, size and timestamp remain unchanged. No recovered count is merged into this inventory. The audit labels 47 original bundles and seven supplemental bundles separately, and retains no analytical eligibility decision.","",
    "Source-only statistical presence remains 47/54 = 87.0370%; the separate implemented source-plus-overlay presence remains 54/54 = 100%. Neither is valid analytical coverage. The 90% event and 95% tour-season thresholds are unchanged; no admission gate or tour-season coverage test was performed.","",
    "Raw pages, full draw extractions, event identity decisions, linkage/conflict tables and the recovery release remain ignored and untracked. Only code, tests, aggregate findings and the minimum blocker identifiers are committed. Local research authorization is not provider permission. [DATA_LICENSE.md](../DATA_LICENSE.md) and [recovery policy 1.0.0](wta-2021-montreal-recovery-policy.md) continue to govern; match-level and aggregate publication require separate rights review. Portfolio is untouched.","",
    "## Reproduction and verification","",
    "Run from the repository root with existing base R, SHA-256 tools and pdftotext:","",
    "```sh","Rscript R/reconcile_montreal_inventory.R","Rscript R/test_montreal_inventory.R","```","",
    "Generated local tables live in data/pilot/development-2021/montreal-inventory/: html-draw.csv, pdf-draw.csv, pdf-entrant-positions.csv, identity-decisions.csv, source-inventory.csv, reconciliation-links.csv, reference-comparisons.csv, official-only.csv, criteria.csv, code-sequence.csv, summary.csv and provenance.csv. No new dependency or network access is used. Missing fingerprints stop before output; parser insufficiency is reported explicitly.","",
    "Tests cover singles isolation; independent HTML/PDF rounds and bracket traversal; doubles/qualifying contamination; code uniqueness/gaps; entrants/byes/progression; walkover and retirement omissions; tie-break/incomplete scores; reversed orientation; exact names and bounded aliases; ambiguous/unmatched identities; unmatched/duplicate keys; winner/score/reference conflicts; exact existing-policy scope; one-to-one gates; source-order independence; separate overlay; immutable files; deterministic outputs; Git ignore/tracking boundaries. Synthetic deletion, duplication and changed-match cases must never report COMPLETE. Existing relevant Phase 1E–1I tests are run without weakening historical gates.","",
    "**Phase 1J verification:** all 18 new named tests and all 38 existing Phase 1I checks passed. Relevant Phase 1E/1F/1G suites and Phase 1H evidence checks passed without weakening gates. All 117 protected pre-existing files, including 91 existing data files and the Phase 1I release, retain SHA-256, size and modification time. Documentation links/anchors, whitespace, restricted-data staging/tracking and the full diff are checked before commit. The initial preflight printed an oversized validation object; later checks suppress object printing. This affected tool output only, not data or verification.","",
    "Development checks stopped on PDF bye text attributes, tie-break tokens, and a final-column coordinate that also matched part of a semifinal score. The parser now uses explicit bye text, complete tie-break tokens and the bounded final-box vertical range. Word coordinates separate the overlapping Pavlyuchenkova/adjacent-score line. No source record was used to fill a PDF gap. The first identity pass exposed the Riske label difference and platform-specific ñ transliteration; both received explicit bounded handling with original observations preserved.","",
    "## Standing future-model requirement","",
    "User requirement: future factors and models must target performance on future matches, not reproduce one season or a few observed seasons. Use chronological development/validation and prevent later information entering earlier predictions. Preserve 2021–2023 development, 2024 validation/model selection and locked 2025 final testing. Specify the complete tuning/evaluation protocol before modeling. Favor stable interpretable specifications and assess sensitivity across seasons, surfaces, events, ATP and WTA. Phase 1J neither designs that protocol nor accesses 2025 data.","",
    "## Smallest recommended follow-up","",
    "Saved evidence suffices for full bracket extraction and one-to-one linkage, but not for declaring all status differences resolved under current policy. The next bounded task should draft a user-reviewable inventory-only status-detail policy for precisely LS036, LS054 and LS026 using the saved HTML/PDF and source evidence. Preserve every omission and leave retirement eligibility, chronology, analytical coverage, admission and models blocked. This is a recommendation, not an adopted precedence extension. No new URL is currently required to draft that decision; any later acquisition needs its own exact allowlist and authorization.","",
    "Phase 1J starts at 13be0fd3f8d2d222e51c972319a540f8db798429. Completion commit message: Reconcile Montreal inventory offline. The final response records the resulting hash and Git state. Every next task requires a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.")
  path<-"docs/wta-2021-montreal-inventory-reconciliation.md"
  if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
  invisible(totals)
}

reconcile_montreal_inventory <- function(write_outputs=TRUE) {
  refs<-mr_manifest();source_evidence<-montreal_load()
  paths<-unique(c(refs$local_path,names(mro_pins()),source_evidence$provenance$path,mro_path(),
    list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE)))
  before<-mrf_snapshot(paths)
  mji_need(file.exists(mro_path()),"Existing Phase 1I release required; this task must not create it")
  overlay<-mro_build(mro_load())
  mji_need(identical(overlay,readRDS(mro_path())),"Phase 1I release differs from verified reconstruction")
  getref<-function(id)refs[refs$reference_id==id,,drop=FALSE]
  h<-p<-NULL
  o<-tryCatch({
    h<-mji_html(anomaly_html(getref("draw_html")$local_path),getref("draw_html"))
    p<-mji_pdf(mji_pdf_xml(getref("draw_pdf")$local_path),getref("draw_pdf"))
    mji_compare(h,p,source_evidence$selected$raw,overlay,evidence_verified=TRUE)
  },error=function(e)list(state="BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE",error=conditionMessage(e),html=h,pdf=p))
  mji_need(identical(before,mrf_snapshot(paths)),"Protected evidence or overlay changed during reconciliation")
  if(!is.null(o$source_inventory)) {
    source_ref<-source_evidence$provenance[source_evidence$provenance$tour=="WTA"&source_evidence$provenance$year==2021,]
    o$source_inventory$source_path<-source_ref$path
    o$source_inventory$source_sha256<-source_ref$sha256
    o$source_inventory$source_byte_size<-source_ref$size
    o$source_inventory$source_git_blob<-source_ref$blob
  }
  o$summary<-data.frame(reconciliation_state=o$state,source_rows=nrow(source_evidence$selected$raw),
    event_admission="NOT_EVALUATED",analytical_coverage="NOT_EVALUATED",modeling_authorized=FALSE,
    chronology="UNRESOLVED",retirement_walkover_eligibility="UNRESOLVED",publication="BLOCKED_PENDING_RIGHTS_REVIEW")
  if(write_outputs) {
    mro_git_boundary(paste0(mji_dir(),"/summary.csv"))
    dir.create(mji_dir(),showWarnings=FALSE)
    mapping<-c(html="html-draw",pdf="pdf-draw",identities="identity-decisions",source_inventory="source-inventory",
      links="reconciliation-links",reference_comparisons="reference-comparisons",official_only="official-only",
      criteria="criteria",code_sequence="code-sequence",summary="summary")
    for(name in names(mapping))if(!is.null(o[[name]]))pilot_write_csv(o[[name]],file.path(mji_dir(),paste0(mapping[[name]],".csv")))
    if(!is.null(p)) {
      roster<-attr(p,"roster");roster$bracket_position<-seq_len(nrow(roster))
      pilot_write_csv(mji_provenance(roster,getref("draw_pdf"),"PDF p1 left bracket names ordered by y coordinate"),file.path(mji_dir(),"pdf-entrant-positions.csv"))
    }
    pilot_write_csv(refs,file.path(mji_dir(),"provenance.csv"))
    mji_report(o,nrow(source_evidence$selected$raw))
  }
  invisible(o)
}
if(sys.nframe()==0L) {
  o<-reconcile_montreal_inventory()
  print(o$summary,row.names=FALSE)
}
