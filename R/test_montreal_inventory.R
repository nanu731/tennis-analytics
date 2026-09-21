# Phase 1J offline tests; synthetic records never overwrite evidence or local outputs.
source("R/reconcile_montreal_inventory.R")

test_montreal_inventory <- function() {
  results<-character()
  pass<-function(name){results<<-c(results,name);message("PASS: ",name)}
  reject<-function(expr)stopifnot(inherits(tryCatch(force(expr),error=identity),"error"))
  refs<-mr_manifest();e<-montreal_load();s<-e$selected$raw;overlay<-readRDS(mro_path())
  path<-function(id)refs$local_path[refs$reference_id==id]
  ref<-function(id)refs[refs$reference_id==id,]
  html<-anomaly_html(path("draw_html"));xml<-mji_pdf_xml(path("draw_pdf"))
  h<-mji_html(html,ref("draw_html"));p<-mji_pdf(xml,ref("draw_pdf"))
  compare<-function(a=h,b=p,z=s)mji_compare(a,b,z,overlay,TRUE)
  o<-compare()
  invisible(mro_fingerprints());bad<-ref("draw_html");bad$sha256<-paste(rep("0",64),collapse="");reject(mr_validate(bad))
  bad<-annual_2021_manifest()[2,];bad$sha256<-paste(rep("0",64),collapse="");reject(annual_2021_validate(bad$local_path,bad))
  pass("reference, annual and manifest fingerprints validated; changed fingerprints rejected")
  stopifnot(mji_bracket(h),mji_bracket(p),nrow(h)==63,nrow(p)==63,sum(h$bye)==8,sum(p$bye)==8,
    mji_totals(h,"HTML")$entrants==56,mji_totals(p,"PDF")$entrants==56,
    identical(as.integer(table(factor(h$round[!h$bye],levels=mji_rounds()))),c(24L,16L,8L,4L,2L,1L)),
    all(h$event=="WTA:2021:806:main-draw-singles"),all(p$event=="WTA:2021:806:main-draw-singles"))
  pass("independent HTML/PDF entrants, byes, rounds, result blocks and feeder progression")
  contaminated<-sub('data-event-type="LS"','data-event-type="LD"',html,fixed=TRUE)
  reject(mji_html(contaminated,ref("draw_html")))
  contaminated<-sub('data-event-type="LS" data-tab-target="LS">','data-event-type="LS" data-tab-target="LS"> js-match-0806-2021-RS999',html,fixed=TRUE)
  reject(mji_html(contaminated,ref("draw_html")))
  # Unrelated doubles/qualifying content outside LS must have no effect.
  noisy<-gsub("js-match-0806-2021-LD001","js-match-0806-2021-LD999",html,fixed=TRUE)
  stopifnot(identical(h,mji_html(noisy,ref("draw_html"))))
  reject(mji_pdf(gsub("SINGLES","DOUBLES",xml,fixed=TRUE),ref("draw_pdf")))
  reject(mji_pdf(gsub("SINGLES","QUALIFYING SINGLES",xml,fixed=TRUE),ref("draw_pdf")))
  pass("singles isolation excludes doubles and qualifying; contaminated representations rejected")
  code<-mji_code_state(h)
  stopifnot(code$unique_codes==62,code$absent_code_labels=="LS013",code$uncoded_records==1,
    is.na(h$official_code[h$record_id=="draw_html:R16:6"]),h$walkover_marker[h$record_id=="draw_html:R16:6"])
  bad<-h;bad$official_code[2]<-bad$official_code[1];stopifnot(mji_code_state(bad)$duplicate_codes)
  bad<-h;bad$official_code[2]<-NA_character_;stopifnot(mji_code_state(bad)$state=="unexplained_code_gap_or_duplicate")
  pass("62 supplied codes and uncoded walkover explain gap without synthesizing LS013; extra gaps/duplicates fail")
  stopifnot(sum(h$walkover_marker)==1,sum(p$walkover_marker)==1,sum(p$retirement_marker)==5,sum(h$retirement_marker)==0,
    sum(o$links$comparison_state=="existing_adopted_match_scoped_resolution")==2,
    setequal(o$links$official_code[o$links$unresolved],c("LS026","LS036","LS054")),o$state=="REVIEW_REQUIRED")
  pass("walkover retained; five retirement omissions preserved; only two adopted resolutions applied")
  stopifnot(inventory_score("76(6) 63",compact=TRUE)=="7-6(6) 6-3",
    inventory_score("6-7(6) 3-6",reverse=TRUE)=="7-6(6) 6-3",inventory_status("5-0")=="unresolved",
    inventory_status("5-0 RET")=="retirement",all(o$links$score_agreement))
  pass("tie-break normalization and incomplete-score status remain distinct")
  stopifnot(mji_norm("MUGURUZA, Garbiñe")=="garbine muguruza",mji_norm("Sara Sorribes-Tormo")=="sara sorribes tormo",
    all(o$identities$state=="resolved"),sum(grepl("corroborated|extended",o$identities$method))==2)
  pass("event-scoped exact normalization and corroborated Gauff/Riske aliases")
  swapped<-h
  for(pair in list(c("player_one","player_two"),c("player_one_id","player_two_id"),c("player_one_full","player_two_full"))) {
    a<-swapped[[pair[1]]];swapped[[pair[1]]]<-swapped[[pair[2]]];swapped[[pair[2]]]<-a
  }
  swapped$winner_side<-3-swapped$winner_side
  stopifnot(identical(o$links,compare(swapped)$links),mji_bracket(swapped))
  pass("reversed player order preserves unordered-pair links and result comparisons")
  bad<-s;bad$winner_id[bad$winner_name=="Camila Giorgi"][1]<-"synthetic-second-identity"
  stopifnot(any(compare(z=bad)$identities$state!="resolved"))
  bad<-h;bad$player_one_full[1]<-"unmatched-person"
  stopifnot(compare(bad)$state!="COMPLETE",any(compare(bad)$identities$state!="resolved"))
  pass("ambiguous and unmatched identities cannot complete")
  bad<-s[-which(s$match_num=="238"),]
  stopifnot(nrow(compare(z=bad)$official_only)==2,compare(z=bad)$state!="COMPLETE")
  extra<-s[s$match_num=="238",];extra$match_num<-"synthetic-extra";extra$round<-"R64"
  bad<-rbind(s,extra);stopifnot(any(compare(z=bad)$links$comparison_state=="source_only_unmatched"))
  pass("official-only and source-only records retained as unmatched")
  bad<-rbind(s,s[1,]);stopifnot(any(compare(z=bad)$links$comparison_state=="duplicate_source_key"))
  bad<-rbind(h,h[!h$bye,][1,]);stopifnot(any(compare(bad)$links$comparison_state=="duplicate_official_key"))
  pass("duplicate source and official keys block one-to-one reconciliation")
  bad<-h;i<-which(bad$official_code=="LS001");bad$winner[i]<-if(bad$winner_side[i]==1)bad$player_two_full[i] else bad$player_one_full[i]
  stopifnot(any(compare(bad)$links$comparison_state=="linked_with_winner_or_result_conflict"))
  bad<-p;i<-which(bad$round=="F");bad$normalized_score[i]<-"6-0 6-0"
  stopifnot(any(compare(b=bad)$links$comparison_state=="linked_with_score_conflict"),any(!compare(b=bad)$reference_comparisons$resolved))
  pass("winner, score and HTML/PDF conflicts stay explicit")
  stopifnot(is.na(mji_policy_resolution("sackmann:WTA:2021-806:266","LS036","unresolved","retirement","6-4 3-1 RET")),
    is.na(mji_policy_resolution("sackmann:WTA:2021-806:260","LS049","unresolved","retirement","6-1 4-3 RET+H64")),
    is.na(mji_policy_resolution("sackmann:WTA:2022-806:260","LS042","unresolved","retirement","6-1 4-3 RET+H64")))
  pass("adopted status policy cannot extend across matches, codes or seasons")
  # Positive COMPLETE fixture supplies explicit HTML RET evidence synthetically.
  # It does not change saved HTML or grant a new precedence policy.
  complete<-h
  for(code in c("LS026","LS036","LS054")) {
    i<-which(complete$official_code==code);complete$status[i]<-"retirement"
    complete$retirement_marker[i]<-TRUE;complete$raw_status_marker[i]<-"RET;data-status=F"
    complete$normalized_score[i]<-paste(complete$normalized_score[i],"RET")
  }
  stopifnot(compare(complete)$state=="COMPLETE")
  i<-which(complete$official_code=="LS001")
  stopifnot(compare(complete[-i,])$state!="COMPLETE",compare(rbind(complete,complete[i,]))$state!="COMPLETE")
  bad<-complete;bad$normalized_score[i]<-"6-0 6-0";stopifnot(compare(bad)$state!="COMPLETE")
  bad<-p;bad$round[bad$round=="F"]<-"SF";stopifnot(compare(complete,bad)$state!="COMPLETE")
  pass("positive COMPLETE fixture; deleting, duplicating, changing or misrounding one match prevents false COMPLETE")
  stopifnot(identical(o$links,compare(z=s[rev(seq_len(nrow(s))),])$links))
  renumbered<-s;renumbered$match_num<-as.character(seq_len(nrow(s))+9000)
  no_id<-function(x)x[,setdiff(names(x),c("source_audit_id","adopted_resolution","comparison_state","status_resolved","unresolved","count_layer"))]
  stopifnot(identical(no_id(o$links),no_id(compare(z=renumbered)$links)))
  pass("row order does not affect links; match numbers identify source observations but never chronology or pairing")
  stopifnot(!any(montreal_fields() %in% names(o$links)),sum(o$links$count_layer=="original_source_counts")==47,
    sum(o$links$count_layer=="approved_supplemental_overlay_bundle_separate")==7,
    sum(o$links$count_layer=="source_walkover_outside_apparent_play_count_coverage")==1,
    all(o$links$analytical_eligibility=="NOT_EVALUATED"),all(o$links$chronology=="UNRESOLVED"))
  pass("47 original bundles, seven separate overlay labels and one walkover; no recovered values merged")
  protected<-unique(c(refs$local_path,e$provenance$path,names(mro_pins()),mro_path(),
    list.files("data/pilot/development-2021/montreal-reference-feasibility",full.names=TRUE)))
  before<-mrf_snapshot(protected)
  first<-reconcile_montreal_inventory();outpaths<-c(list.files(mji_dir(),full.names=TRUE),"docs/wta-2021-montreal-inventory-reconciliation.md")
  outputs<-mrf_snapshot(outpaths);second<-reconcile_montreal_inventory()
  stopifnot(identical(first,second),identical(before,mrf_snapshot(protected)),identical(outputs,mrf_snapshot(outpaths)),
    identical(readRDS(mro_path()),overlay))
  pass("source/reference/overlay immutable; local tables and report deterministic in bytes and timestamp")
  for(path in outpaths[startsWith(outpaths,"data/")])mro_git_boundary(path)
  stopifnot(!length(system("git diff --cached --name-only -- data/raw data/pilot",intern=TRUE)))
  pass("all restricted outputs ignored; no raw/extracted/recovered data staged or tracked")
  # Historical controls above intentionally omit the separately adopted 1L policy.
  # The production path below must pass the new policy with immutable evidence.
  proof<-mji_status_evidence()
  adopted<-function(a=h,b=p,z=s,evidence=proof)mji_compare(a,b,z,overlay,TRUE,evidence)
  current<-adopted();policy<-mji_status_policy()
  stopifnot(policy$name=="WTA Montreal inventory status-detail policy",policy$version=="1.0.0",
    current$state=="COMPLETE",all(current$criteria$passed),nrow(current$criteria)==14,
    nrow(current$status_resolutions)==3,setequal(current$status_resolutions$official_code,c("LS036","LS054","LS026")),
    all(current$status_resolutions$resolution==policy$resolution),!any(current$links$unresolved),
    all(current$reference_comparisons$resolved),nrow(current$official_only)==0)
  pass("Phase 1L adopted name/version, exact three derived resolutions, all fourteen criteria and COMPLETE")
  stopifnot(identical(current$html,h),identical(current$pdf,p),identical(current$source_inventory,o$source_inventory),
    sum(current$html$retirement_marker)==0,sum(current$pdf$retirement_marker)==5,
    sum(current$links$comparison_state=="existing_adopted_match_scoped_resolution")==2,
    all(current$status_resolutions$html_omission_preserved),all(current$status_resolutions$original_reference_conflict),
    all(current$status_resolutions$html_status_metadata=="data-status=F"),
    all(grepl("RET",current$status_resolutions$source_score)),all(grepl("RET",current$status_resolutions$pdf_raw_score)),
    all(nzchar(current$status_resolutions$pdf_legend_raw)),all(nzchar(current$status_resolutions$pdf_legend_locator)))
  pass("all five HTML omissions, source/PDF raw observations, legend provenance and two Phase 1I resolutions preserved")
  withheld<-function(a=h,b=p,z=s,evidence=proof){
    r<-tryCatch(adopted(a,b,z,evidence),error=function(e)NULL)
    if(!is.null(r))stopifnot(r$state!="COMPLETE",nrow(r$status_resolutions)==0,
      !any(r$links$adopted_resolution==policy$resolution,na.rm=TRUE))
  }
  for(code in c("LS036","LS054","LS026")) {
    ai<-which(h$official_code==code);li<-which(current$links$official_code==code)
    bi<-which(p$record_id==current$links$pdf_record_id[li]);si<-which(paste0("sackmann:WTA:2021-806:",s$match_num)==current$links$source_audit_id[li])
    bad<-s;bad$score[si]<-sub(" RET","",bad$score[si],fixed=TRUE);withheld(z=bad)
    bad<-p;bad$retirement_marker[bi]<-FALSE;bad$raw_score[bi]<-sub(" RET","",bad$raw_score[bi],fixed=TRUE);withheld(b=bad)
    pass(paste(code,"missing source or PDF RET withholds all three decisions"))
  }
  for(field in c("sha256","byte_size","local_path")) {
    bad<-proof;bad$reference_manifest[[field]][1]<-NA;withheld(evidence=bad)
    pass(paste("missing reference",field,"rejected without partial application"))
  }
  bad<-proof;bad$source_provenance$sha256[2]<-paste(rep("0",64),collapse="");withheld(evidence=bad)
  bad<-proof;bad$details$retiring_player[1]<-"Different Player";withheld(evidence=bad)
  bad<-proof;bad$details$legend_raw[1]<-"";withheld(evidence=bad)
  bad<-proof;bad$details$legend_locator[1]<-"";withheld(evidence=bad)
  pass("changed source fingerprint, wrong/missing PDF legend name and unavailable legend locator rejected")
  ai<-which(h$official_code=="LS036");bi<-which(p$record_id==current$links$pdf_record_id[which(current$links$official_code=="LS036")])
  for(field in c("reference_sha256","locator","raw_status_marker","raw_text","official_code","round","winner","player_two_full","normalized_score")) {
    bad<-h;bad[[field]][ai]<-switch(field,reference_sha256="",locator="",raw_status_marker="explicit_normal_completion_no_retirement",
      raw_text=paste(bad$raw_text[ai],"explicit non-retirement"),official_code="LS099",round="R32",winner=bad$player_two_full[ai],
      player_two_full="unmatched player",normalized_score="6-0 6-0")
    withheld(a=bad)
    pass(paste("HTML",field,"mutation rejected without partial application"))
  }
  bad<-h;bad$retirement_marker[ai]<-TRUE;withheld(a=bad)
  bad<-h;bad$walkover_marker[ai]<-TRUE;withheld(a=bad)
  bad<-p;bad$player_two_full[bi]<-"Different Retiring Player";withheld(b=bad)
  bad<-p;bad$locator[bi]<-"";withheld(b=bad)
  bad<-proof;bad$details$html_raw_block[1]<-paste(bad$details$html_raw_block[1],"non-retirement");withheld(evidence=bad)
  pass("changed omission representation, contradictory walkover, different retiring player and unavailable PDF locator rejected")
  withheld(a=rbind(h,h[ai,]));withheld(z=rbind(s,s[1,]))
  bad<-s;bad$winner_id[bad$winner_name=="Maria Sakkari"][1]<-"ambiguous-id";withheld(z=bad)
  bad<-s;bad$tourney_id<-"2022-806";withheld(z=bad)
  bad<-proof;bad$targets$code[1]<-"LS042";withheld(evidence=bad)
  bad<-proof;bad$targets$audit_id[1]<-"sackmann:ATP:2021-806:266";withheld(evidence=bad)
  pass("duplicate links, ambiguous identities, another event/tour/match cannot receive this policy")
  stopifnot(identical(o$links[o$links$official_code %in% c(sprintf("LS%03d",1:7),"LS042","LS049"),],
    current$links[current$links$official_code %in% c(sprintf("LS%03d",1:7),"LS042","LS049"),]),
    identical(readRDS(mro_path()),overlay),first$summary$reconciliation_state=="COMPLETE",
    first$summary$event_admission=="NOT_EVALUATED",first$summary$analytical_coverage=="NOT_EVALUATED",!first$summary$modeling_authorized,
    first$summary$chronology=="UNRESOLVED",first$summary$retirement_walkover_eligibility=="EXCLUDED_BY_APPROVED_PRIMARY_DESIGN_NOT_APPLIED")
  pass("Phase 1I scope/release unchanged; approved eligibility design is not canonical implementation or admission")
  stopifnot(setequal(proof$source_provenance$year,c(2021,2023)),!any(grepl("2025",proof$source_provenance$path,fixed=TRUE)),all(grepl("montreal-2021",proof$reference_manifest$local_path,fixed=TRUE)))
  pass("active evidence paths limited to saved 2021 references and 2021/2023 annuals; no 2025 input")
  # Capture report writes in memory: failed runs must not reuse the success narrative.
  report<-mji_report;capture<-new.env(parent=globalenv());environment(report)<-capture
  capture$file.exists<-function(...)FALSE
  capture$writeLines<-function(text,...)capture$lines<-text
  report(o,55)
  stopifnot(any(grepl("Reconciliation state: **REVIEW_REQUIRED**",capture$lines,fixed=TRUE)),
    !any(grepl("Policy validation: all_three_resolved",capture$lines,fixed=TRUE)))
  report(list(state="BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE",html=NULL,pdf=NULL,error="synthetic missing evidence"),55)
  stopifnot(any(grepl("Extraction blocker: synthetic missing evidence",capture$lines,fixed=TRUE)))
  pass("failed/insufficient report retains truthful state without reusing successful-run findings")
  message(length(results)," Phase 1J/1L checks passed.")
  invisible(results)
}
if(sys.nframe()==0L)test_montreal_inventory()
