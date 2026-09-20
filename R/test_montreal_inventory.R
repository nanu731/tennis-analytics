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
  message(length(results)," Phase 1J checks passed.")
  invisible(results)
}
if(sys.nframe()==0L)test_montreal_inventory()
