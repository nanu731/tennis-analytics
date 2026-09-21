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

# Phase 1L: separately approved inventory-only policy, never a Phase 1I extension.
mji_status_policy <- function() list(name="WTA Montreal inventory status-detail policy",version="1.0.0",
  resolution="pdf_retirement_corroborated_html_omission_preserved")
mji_status_targets <- function() data.frame(code=c("LS036","LS054","LS026"),
  audit_id=paste0("sackmann:WTA:2021-806:",c(266,248,276)),round=c("R64","R64","R32"),
  score=c("6-4 3-1 RET","4-6 5-2 RET","5-0 RET"),retiring_player=c("Marie Bouzkova","Shuai Zhang","Anastasia Potapova"),
  legend_y=c(650.1954,671.0754,678.4194),stringsAsFactors=FALSE)
mji_status_evidence <- function() {
  # Re-read pinned bytes, not previously supplied extraction/provenance labels.
  verified<-mro_fingerprints();refs<-verified$refs
  hr<-refs[refs$reference_id=="draw_html",];pr<-refs[refs$reference_id=="draw_pdf",]
  html<-anomaly_html(hr$local_path);xml<-mji_pdf_xml(pr$local_path)
  h<-mji_html(html,hr);p<-mji_pdf(xml,pr);targets<-mji_status_targets()
  lines<-anomaly_matches('(?s)<line .*?</line>',xml)
  mji_need(grepl("RETIREMENTS/WALKOVERS",mji_clean(xml),fixed=TRUE),"PDF retirement legend heading missing")
  blocks<-strsplit(html,'<div class="tournament-draw__lines-container js-match-table"',fixed=TRUE)[[1]]
  details<-list()
  for(i in seq_len(nrow(targets))) {
    t<-targets[i,];b<-blocks[grepl(paste0("js-match-0806-2021-",t$code),blocks,fixed=TRUE)]
    mji_need(length(b)==1,"Policy HTML block missing or duplicate")
    b<-strsplit(b,"</table>",fixed=TRUE)[[1]][1]
    legend<-lines[vapply(lines,function(z)isTRUE(abs(as.numeric(anomaly_capture('xMin="([^"]+)"',z))-494.3688)<.01 &&
      abs(as.numeric(anomaly_capture('yMin="([^"]+)"',z))-t$legend_y)<.01),TRUE)]
    mji_need(length(legend)==1 && startsWith(mji_clean(legend),t$retiring_player),"PDF named retiring player missing/different")
    a<-h[which(h$official_code==t$code),]
    mji_need(nrow(a)==1&&!a$retirement_marker&&a$raw_status_marker=="data-status=F"&&a$status=="unresolved",
      "HTML no longer matches approved omission representation")
    details[[i]]<-data.frame(code=t$code,retiring_player=t$retiring_player,legend_raw=mji_clean(legend),
      legend_raw_xml=legend,legend_locator=paste0("PDF p1 RETIREMENTS/WALKOVERS x=494.3688 y=",t$legend_y),
      html_raw_block=b,html_locator=a$locator,stringsAsFactors=FALSE)
  }
  list(policy=mji_status_policy(),targets=targets,reference_manifest=refs,source_provenance=verified$source$provenance,
    source=verified$source$selected$raw,html=h,pdf=p,details=do.call(rbind,details))
}
mji_apply_status_policy <- function(links,h,p,source,identities,evidence) {
  empty<-data.frame(source_audit_id=character(),official_code=character(),policy_name=character(),policy_version=character(),resolution=character())
  withheld<-function(reason)list(links=links,resolutions=empty,policy_check=reason)
  if(is.null(evidence))return(withheld("not_requested_historical_policy_only"))
  fresh<-tryCatch(mji_status_evidence(),error=function(e)NULL)
  if(is.null(fresh)||!identical(evidence,fresh))return(withheld("evidence_missing_changed_or_not_bound_to_pinned_bytes"))
  t<-evidence$targets
  if(anyDuplicated(links$match_key)||anyDuplicated(h$match_key)||anyDuplicated(p$match_key)||
     any(identities$state!="resolved")||anyNA(c(h$match_key,p$match_key))||
     any(links$html_link_count!=1|links$pdf_link_count!=1))return(withheld("identity_or_unique_link_gate_failed"))
  same_row<-function(a,b)identical(lapply(a,identity),lapply(b,identity))
  rows<-list();indices<-integer()
  for(i in seq_len(nrow(t))) {
    z<-t[i,];li<-which(links$source_audit_id==z$audit_id&links$official_code==z$code)
    if(length(li)!=1)return(withheld("exact_scope_missing_or_duplicate"))
    l<-links[li,];hi<-which(h$record_id==l$html_record_id);pi<-which(p$record_id==l$pdf_record_id)
    eh<-evidence$html[which(evidence$html$official_code==z$code),]
    ep<-evidence$pdf[evidence$pdf$record_id==l$pdf_record_id,]
    si<-which(paste0("sackmann:WTA:2021-806:",source$match_num)==z$audit_id)
    es<-evidence$source[paste0("sackmann:WTA:2021-806:",evidence$source$match_num)==z$audit_id,]
    if(length(hi)!=1||length(pi)!=1||length(si)!=1||nrow(eh)!=1||nrow(ep)!=1||nrow(es)!=1)
      return(withheld("required_record_unavailable"))
    a<-h[hi,];b<-p[pi,];d<-evidence$details[i,]
    # Full raw-record equality binds markers, score cells, IDs, metadata and locators.
    if(!same_row(a[,names(eh)],eh)||!same_row(b[,names(ep)],ep)||!same_row(source[si,],es))
      return(withheld("observation_changed_or_unavailable"))
    loser<-if(b$winner_side==1)b$player_two_full else b$player_one_full
    valid<-isTRUE(l$round==z$round&&l$winner_agreement&&l$score_agreement&&
      l$source_score==z$score&&l$pdf_score==z$score&&l$html_score==mji_numeric(z$score)&&
      l$source_status=="retirement"&&l$pdf_status=="retirement"&&l$html_status=="unresolved"&&
      b$retirement_marker&&!a$retirement_marker&&!a$walkover_marker&&a$raw_status_marker=="data-status=F"&&
      mji_norm(loser)==mji_norm(z$retiring_player)&&d$retiring_player==z$retiring_player&&
      all(nzchar(c(a$locator,b$locator,d$legend_locator,a$reference_sha256,b$reference_sha256))))
    if(!valid)return(withheld("corroboration_or_status_gate_failed"))
    sr<-evidence$source_provenance[evidence$source_provenance$tour=="WTA"&evidence$source_provenance$year==2021,]
    rows[[i]]<-data.frame(source_audit_id=z$audit_id,official_code=z$code,policy_name=evidence$policy$name,
      policy_version=evidence$policy$version,resolution=evidence$policy$resolution,derived_inventory_status="retirement",
      retiring_player=z$retiring_player,source_score=l$source_score,html_score=l$html_score,pdf_score=l$pdf_score,
      pdf_raw_score=b$raw_score,pdf_retirement_marker=b$retirement_marker,pdf_legend_raw=d$legend_raw,
      pdf_legend_locator=d$legend_locator,html_retirement_marker=a$retirement_marker,html_status_metadata=a$raw_status_marker,
      html_omission_preserved=TRUE,original_reference_conflict=TRUE,
      conflict_history="Phase_1J_and_1K_unresolved_HTML_omission_source_PDF_RET",
      html_locator=a$locator,pdf_locator=b$locator,html_sha256=a$reference_sha256,pdf_sha256=b$reference_sha256,
      html_byte_size=a$reference_byte_size,pdf_byte_size=b$reference_byte_size,source_path=sr$path,
      source_sha256=sr$sha256,source_byte_size=sr$size,source_git_blob=sr$blob,
      evidence_check="all_required_conditions_passed",scope="inventory_only_no_canonical_admission",stringsAsFactors=FALSE)
    indices<-c(indices,li)
  }
  # Publish all three derived decisions together only after every condition passes.
  links$adopted_resolution[indices]<-evidence$policy$resolution
  links$status_resolved[indices]<-TRUE;links$unresolved[indices]<-FALSE
  links$comparison_state[indices]<-"adopted_inventory_status_policy_resolution"
  list(links=links,resolutions=do.call(rbind,rows),policy_check="all_three_resolved")
}

mji_compare <- function(html,pdf,source,overlay,evidence_verified=FALSE,policy_evidence=NULL) {
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
  policy_result<-mji_apply_status_policy(links,h,p,source,identity,policy_evidence)
  links<-policy_result$links
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
    html=html,pdf=pdf,source_inventory=src,links=links,reference_comparisons=references,official_only=unmatched,code_sequence=code,
    status_resolutions=policy_result$resolutions,policy_check=policy_result$policy_check)
}

mji_totals <- function(x,representation) {
  if(is.null(x))return(data.frame(representation=representation,bracket_positions=NA_integer_,entrants=NA_integer_,byes=NA_integer_,bracket_blocks=NA_integer_,nonbye_results=NA_integer_,walkovers=NA_integer_,explicit_retirements=NA_integer_,unresolved_status=NA_integer_))
  first<-x[x$round=="R64",];names<-c(first$player_one_full,first$player_two_full)
  data.frame(representation=representation,bracket_positions=length(names),entrants=sum(names!="BYE"),byes=sum(x$bye),
    bracket_blocks=nrow(x),nonbye_results=sum(!x$bye),walkovers=sum(x$walkover_marker),explicit_retirements=sum(x$retirement_marker),unresolved_status=sum(x$status=="unresolved"))
}
mji_report <- function(o,source_rows) {
  totals<-rbind(mji_totals(o$html,"HTML"),mji_totals(o$pdf,"PDF"))
  reviewed<-!is.null(o$links)&&o$state=="COMPLETE"&&all(o$criteria$passed)&&
    source_rows==55&&all(totals$bracket_positions==64&totals$entrants==56&totals$byes==8&totals$nonbye_results==55)&&
    nrow(o$status_resolutions)==3&&!any(o$links$unresolved)
  if(!isTRUE(reviewed)) {
    lines<-c("# WTA 2021 Montreal inventory reconciliation","",paste0("Reconciliation state: **",o$state,"**."),"",
      "This run differs from the reviewed Phase 1L profile. No successful-run narrative is reused. Admission and analytical coverage remain NOT_EVALUATED; chronology is unresolved; modeling remains FALSE; publication remains blocked.","",
      pilot_markdown_table(totals),"",if(!is.null(o$criteria))pilot_markdown_table(o$criteria) else paste("Extraction blocker:",o$error))
    if(!is.null(o$links))lines<-c(lines,"",pilot_markdown_table(o$links[o$links$unresolved,c("source_audit_id","official_code","comparison_state")]))
    path<-"docs/wta-2021-montreal-inventory-reconciliation.md"
    if(!file.exists(path)||!identical(readLines(path,warn=FALSE),lines))writeLines(lines,path,useBytes=TRUE)
    return(invisible(totals))
  }
  lines<-c("# WTA 2021 Montreal inventory reconciliation","",
    paste0("Phase 1L, 2026-09-21. **Inventory reconciliation: ",o$state,".** Source rows: ",source_rows,". This is not event admission."),"",
    "## Current boundaries","",
    "Event admission and analytical coverage remain NOT_EVALUATED; modeling_authorized remains FALSE. Actual chronology and same-day ordering remain unresolved. The approved PROJECT_CONTEXT.md excludes retirements and walkovers from primary Four Factors, Elo updates and evaluation; that population design is not implemented here. No canonical analytical table is created. Publication remains blocked pending rights review.","",
    "## Independent inventories","",pilot_markdown_table(totals),"",
    "HTML isolates main-draw singles, traversing all six rounds, byes and uncoded cards. PDF independently extracts the left roster and word-coordinate result columns, then follows bracket advancement. Neither parser uses source rows as its template. Original names, scores, markers, omissions, locators and reference fingerprints remain in unchanged local extraction tables.","")
  if(!is.null(o$links)) {
    l<-o$links
    rounds<-data.frame(round=mji_rounds(),HTML_nonbye=vapply(mji_rounds(),function(r)sum(o$html$round==r&!o$html$bye),0L),PDF_nonbye=vapply(mji_rounds(),function(r)sum(o$pdf$round==r&!o$pdf$bye),0L))
    agg<-data.frame(measure=c("one_to_one_source_links","source_only_unmatched","official_only_unmatched","duplicate_source_keys","duplicate_HTML_keys","duplicate_PDF_keys","unresolved_identities","winner_conflicts","numeric_score_conflicts","raw_HTML_retirement_omissions","Phase_1I_scoped_resolutions","Phase_1L_inventory_resolutions","unresolved_status_details","unresolved_reference_conflicts"),
      value=c(sum(l$html_link_count==1&l$pdf_link_count==1),sum(l$html_link_count==0|l$pdf_link_count==0),nrow(o$official_only),sum(duplicated(o$source_inventory$match_key)),
        sum(duplicated(l$html_record_id[!is.na(l$html_record_id)])),sum(duplicated(l$pdf_record_id[!is.na(l$pdf_record_id)])),sum(o$identities$state!="resolved"),sum(!l$winner_agreement),sum(!l$score_agreement),
        sum(l$html_status=="unresolved"&l$pdf_status=="retirement",na.rm=TRUE),sum(l$comparison_state=="existing_adopted_match_scoped_resolution"),nrow(o$status_resolutions),sum(!l$status_resolved),sum(!o$reference_comparisons$resolved)))
    lines<-c(lines,pilot_markdown_table(rounds),"","## Linkage and status resolution","",pilot_markdown_table(agg),"",
      "Links use event/draw, round and unordered player IDs, followed by winner, score and status comparison. Source row order and match_num never establish chronology. Numeric agreement is not raw-string equality; RET and suffix evidence remain separate.","",
      paste("Policy validation:",o$policy_check),"",
      "[WTA Montreal inventory status-detail policy 1.0.0](wta-2021-montreal-inventory-status-policy.md) is separately adopted for LS036/266, LS054/248 and LS026/276. The resolution is pdf_retirement_corroborated_html_omission_preserved. All three must pass fresh pinned-byte validation, exact scope, source/PDF RET, named PDF legend identity, matching pair/round/advancement/score, unique linkage, unchanged HTML omission/F metadata and required locators. Any failed condition withholds all three derived resolutions.","",
      "Raw official extractions and source rows are not rewritten. The separate ignored inventory-status-resolutions.csv preserves source/PDF scores, PDF legend text/locator, named retiring player, HTML omission and F metadata, fingerprints, original conflict history and policy/version. All five original HTML retirement omissions remain visible. LS042/LS049 retain their two existing Phase 1I resolutions; LS001-LS007 recovery, H64/H61 and the immutable Phase 1I release are not altered.","",
      "## Completion criteria","",
      "COMPLETE requires all fourteen pre-existing criteria; no criterion was removed or weakened. Missing extraction evidence yields BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE; unresolved comparisons yield REVIEW_REQUIRED. Completion is an inventory result only.","",pilot_markdown_table(o$criteria),"")
    if(any(l$unresolved))lines<-c(lines,"## Unresolved records","",pilot_markdown_table(l[l$unresolved,c("source_audit_id","official_code","comparison_state")]),"")
  } else lines<-c(lines,"## Extraction blocker","",o$error,"")
  lines<-c(lines,"## Identity and code-sequence findings","",
    "The 56 event identities use deterministic normalization and exact roster decisions, including bounded Gauff/Cori-Coco and Riske/Riske Amritraj aliases, plus explicit ñ normalization. No fuzzy matching or global identity rule is introduced. The original HTML contains 62 unique LS codes and an uncoded Gauff-Konta R16 walkover card between LS012 and LS014. No LS013 identifier or missing match is synthesized; the publisher's reason for omitting the attribute remains unknown.","",
    "## Historical record","",
    "Phase 1J independently linked all 55 rows but returned REVIEW_REQUIRED: five HTML retirement omissions, two adopted Phase 1I resolutions and three unresolved details (LS036, LS054, LS026), with 12/14 criteria passing. Phase 1K drafted proposal 0.1.0 with D1-D8 pending; its commit was not approval. The Phase 1L user prompt explicitly approved those decisions and the project context. Current computed tables above, rather than approval alone, determine whether implementation passes.","",
    "## Evidence, preservation and rights","",
    "All twelve [Montreal references](../data/manifests/montreal-reference-files.csv), four relevant ATP/WTA 2021/2023 annual files and the three Phase 1I manifest pins are revalidated. Archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. The Phase 1I release is reconstructed in memory and compared to the existing RDS; its bytes and timestamp remain unchanged. No new acquisition or dependency is used.","",
    "Historical source-only statistical presence remains 47/54 = 87.0370%; separate implemented source-plus-overlay presence remains 54/54 = 100%, from 47 original and seven supplemental bundles. These are apparent-play presence measures, not the approved completed-match population's analytical coverage. The 90% event and 95% tour-season thresholds remain unchanged; neither admission nor a new eligible denominator is calculated.","",
    "Raw pages, complete official extractions, identities, linkage/conflict tables and populated recovery/status decisions remain ignored and untracked. Only code, tests, aggregate findings, policy and minimum audit identifiers are committed. [DATA_LICENSE.md](../DATA_LICENSE.md) remains controlling. User approval is not provider permission; publication of match-level or aggregate outputs requires rights review. Portfolio is untouched.","",
    "## Reproduction and verification","",
    "```sh","Rscript R/reconcile_montreal_inventory.R","Rscript R/test_montreal_inventory.R","Rscript R/test_montreal_recovery.R","```","",
    "The existing ignored Montreal inventory directory retains its twelve Phase 1J tables and adds only inventory-status-resolutions.csv as a separate derived layer. The raw html-draw, pdf-draw, pdf-entrant-positions, identity-decisions, source-inventory and provenance tables remain unchanged. Links, reference comparisons, criteria and summary reflect approved policy resolution without erasing original statuses.","",
    "Tests retain the historical fourteen-criterion/no-new-policy controls and add the adopted 1.0.0 rule: exact scope and three resolutions, named legend evidence, unchanged observations, zero unresolved conflicts, all criteria passing, no partial application, fingerprint/identity/result/round/score/marker/legend/status/locator mutations, other-event/match rejection, deterministic reruns, overlay immutability and Git boundaries. Relevant Phase 1E-1K regressions are run; current verification is recorded in [status](status.md).", "",
    "The initial Phase 1L record-equality check rejected PDF roster attributes even though the recorded fields matched. It was corrected to compare every field value while retaining separate full-bracket validation. No partial resolution was applied during that failed development run.","",
    "## Standing future-model requirement","",
    "[PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md) is adopted. Future factors and models must target future matches, not reproduce a few observed seasons. Preserve chronological 2021-2023 development, 2024 validation/model selection and locked 2025 final testing. Specify the complete tuning/evaluation protocol before modeling, prevent leakage, and assess stability across seasons, surfaces, events and tours. Phase 1L does not design that protocol or access 2025 data.","",
    "## Smallest recommended follow-up","",
    "A bounded offline audit of Montreal completed-match eligibility and count coverage under the approved context is recommended next, using existing saved evidence and separate recovery provenance. It must preserve every excluded audit record, report any remaining status/count blockers, and leave admission, chronology, canonical inputs and models unimplemented unless separately authorized. Actual dates/same-day ordering, wider data acquisition and publication rights remain separate decisions.","",
    "Phase 1L starts at bded8069163d41c886cf1576ea0fdd4cc1054b7b. Its commits are Adopt project research context and Implement Montreal inventory status policy; exact hashes and Git state are recorded in the final response. Every next task requires a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.")
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
    mji_compare(h,p,source_evidence$selected$raw,overlay,evidence_verified=TRUE,policy_evidence=mji_status_evidence())
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
    chronology="UNRESOLVED",retirement_walkover_eligibility="EXCLUDED_BY_APPROVED_PRIMARY_DESIGN_NOT_APPLIED",publication="BLOCKED_PENDING_RIGHTS_REVIEW")
  if(write_outputs) {
    mro_git_boundary(paste0(mji_dir(),"/summary.csv"))
    dir.create(mji_dir(),showWarnings=FALSE)
    mapping<-c(html="html-draw",pdf="pdf-draw",identities="identity-decisions",source_inventory="source-inventory",
      links="reconciliation-links",reference_comparisons="reference-comparisons",official_only="official-only",
      criteria="criteria",code_sequence="code-sequence",summary="summary",status_resolutions="inventory-status-resolutions")
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
