# Focused Phase 2H checks. Does not load or run any historical empirical suite.
source('R/audit_source_defined_cohort.R')
historical_paths<-list.files('data/pilot/exploratory-four-factors-analysis',full.names=TRUE)
historical_before<-data.frame(path=historical_paths,hash=vapply(historical_paths,sa_hash,''),
  size=file.info(historical_paths)$size,mtime=as.numeric(file.info(historical_paths)$mtime))
checks<-0L
check<-function(ok,label) {
  if(!isTRUE(ok))stop('FAIL: ',label,call.=FALSE)
  checks<<-checks+1L
}
throws<-function(expr) inherits(tryCatch({force(expr);NULL},error=function(e)e),'error')
status<-function(score,bo='3')sa_score(score,bo)$status
for(s in c('6-0 6-0','6-7(2) 7-5 7-6(10)','7-6 6-4'))check(status(s)=='source_reported_normal',paste('completion',s))
check(status('6-0 6-0','5')=='unfinished','best of five cannot finish at two sets')
check(status('6-0 6-0 6-0','5')=='source_reported_normal','best of five completion')
for(s in c('6-0','4-6 6-4','6-0 6-0 6-1','6-7 6-7','6-0 5-2','6-0(2) 6-0',
           '6-0 6-0 6-0 6-0','6-0 0-6 0-6 6-0'))check(status(s)=='unfinished',paste('incomplete',s))
for(s in c('6-4 3-0 RET','6-1 4-3 RET+H64','RET'))check(status(s)=='retirement','explicit retirement')
check(status('W/O')=='walkover','walkover');check(status('6-0 DEF')=='default','default')
check(status('ABANDONED')=='abandoned','abandoned');check(status('SUSP')=='unfinished','suspended')
check(status('RET W/O')=='ambiguous','conflicting markers');check(status('')=='ambiguous','missing score')
check(status('6-0 6-0','1')=='ambiguous','unsupported format')
for(s in c('6-4 4-6 9-7','[10-8]','6-0 6-0 X'))check(status(s)=='ambiguous','unsupported syntax never admitted')

hashes<-setNames(vapply(names(sa_pins),sa_hash,''),names(sa_pins))
check(identical(unname(hashes),unname(sa_pins)),'all independent input pins match')
inputs<-sa_inputs()
for(i in seq_len(nrow(inputs))) {
  check(sa_preflight(inputs[i,],hashes)$ok,'saved-use, manifest, SHA, size and blob')
  changed<-hashes;changed[inputs$path[i]]<-'MISSING'
  check(!sa_preflight(inputs[i,],changed)$ok,'missing annual fails closed')
  changed<-hashes;changed[inputs$manifest[i]]<-'CHANGED'
  check(!sa_preflight(inputs[i,],changed)$ok,'changed manifest fails closed')
}
changed<-hashes;changed['DATA_LICENSE.md']<-'CHANGED'
check(all(vapply(seq_len(3),function(i)!sa_preflight(inputs[i,],changed)$ok,TRUE)),'unknown saved rights blocks all files')
panel<-sa_panel();check(nrow(panel)==30&&!anyDuplicated(panel$cell_id),'30 unique expected cells')
check(setequal(panel$event,c('Australian Open','Roland-Garros','Wimbledon','US Open','Indian Wells','Miami','Madrid','Rome','Canada','Cincinnati')),'unchanged ten families')

r<-audit_source_defined_cohort(FALSE);d<-r$`row-dispositions`;p<-d[d$membership!='OUTSIDE_PANEL',]
check(nrow(d)==8393&&nrow(p)==2922,'full source ledger and panel accounting')
check(sum(p$membership=='INCLUDED')==2580&&sum(p$membership=='EXCLUDED')==342,'measured membership accounting')
for(input in inputs$file) {
  original<-sa_read(inputs$path[inputs$file==input]);z<-d[d$audit_file==input,]
  check(identical(unname(as.matrix(original)),unname(as.matrix(z[,names(original)]))),'all original values and row order preserved')
}
check(all(d$membership[d$panel_disposition=='OUTSIDE_PANEL']=='OUTSIDE_PANEL'),'off-panel analysis excluded')
check(all(nzchar(p$exclusion_reasons[p$membership=='EXCLUDED']))&&all(!nzchar(p$exclusion_reasons[p$membership=='INCLUDED'])),'all exclusions have reasons; inclusions have none')
check(all(p$completion_status[p$membership=='INCLUDED']=='source_reported_normal'),'affirmative completion required')
check(all(p$statistics_disposition[p$membership=='INCLUDED']=='PASS'),'valid counts required')
check(all(p$identity_disposition[p$membership=='INCLUDED']=='PASS'),'identity required')
check(all(vapply(seq_len(nrow(p)),function(i)identical(sort(c(p$winner_id[i],p$loser_id[i]),method='radix'),
  c(p$player_a_id[i],p$player_b_id[i])),TRUE)),'every A/B pair is outcome neutral')

pilot<-sa_read(sa_pilot_path);overlay<-readRDS(sa_overlay_path)$field_decisions
old<-p[match(pilot$match_id,p$match_id),]
check(identical(old$membership=='INCLUDED',pilot$valid_bundle=='TRUE'),'all 245 historical eligibility decisions agree')
check(all(ifelse(old$completion_status=='source_reported_normal','normally_completed',old$completion_status)==pilot$status),'pilot statuses retained')
check(identical(old$pilot_conflict_detail,pilot$conflict_detail),'all pilot conflict text preserved')
check(sum(old$count_origin=='approved_recovery_overlay')==7,'overlay exact seven records')
check(setequal(names(r),sa_files),'exact six-file output scope')
check(sum(old$quarantined=='TRUE')==1&&old$membership[old$match_id=='WTA:2023-609:268']=='EXCLUDED','quarantine retained')
check(old$completion_status[old$match_id=='WTA:2021-806:253']=='retirement','unmarked retirement override retained')

raw_cols<-c(names(sa_read(inputs$path[1])),'audit_file','audit_tour','audit_season','audit_source_path','audit_source_row')
one<-p[p$membership=='INCLUDED'&p$audit_tour=='ATP',raw_cols][1,,drop=FALSE]
empty_pilot<-pilot[FALSE,];empty_overlay<-overlay[FALSE,]
admit<-function(x)sa_dispositions(x,empty_pilot,empty_overlay)
check(admit(one)$membership=='INCLUDED','valid fixture')
recovered<-p[p$count_origin=='approved_recovery_overlay',raw_cols][1,,drop=FALSE]
bad_overlay<-overlay;bad_overlay$value[1]<-'-1'
# Deliberately break a referenced field link, then ensure no fallback can admit it.
bad_overlay$source_winner_id<-'999999'
check(grepl('pilot_overlay_conflict',sa_dispositions(recovered,pilot,bad_overlay)$exclusion_reasons),'overlay linkage conflict excluded')
bad_pilot<-pilot;bad_pilot$source_winner_id<-'999999'
check(grepl('pilot_link_conflict',sa_dispositions(recovered,bad_pilot,overlay)$exclusion_reasons),'pilot linkage conflict excluded')
x<-recovered;x$w_ace<-'1'
check(grepl('pilot_overlay_conflict',sa_dispositions(x,pilot,overlay)$exclusion_reasons),'recovery cannot replace a populated source field')
x<-one;x$surface<-'Clay';check(grepl('surface_conflict',admit(x)$exclusion_reasons),'surface mismatch')
x<-one;x$tourney_name<-'Unreviewed';check(grepl('event_label_conflict',admit(x)$exclusion_reasons),'label mismatch')
x<-one;x$tourney_id<-'2023-UNREVIEWED';check(grepl('unresolved_source_edition',admit(x)$exclusion_reasons),'unknown edition ID fails closed')
x<-one;x$tourney_id<-'2023-UNREVIEWED';check(all(grepl('multiple_source_editions',admit(rbind(one,x))$exclusion_reasons)),'multiple edition IDs exclude entire candidate cell')
x<-one;x$round<-'Q1';check(grepl('non_main_draw_or_unknown_round',admit(x)$exclusion_reasons),'qualifying excluded')
x<-one;x$tourney_date<-'20230230';check(grepl('event_date_or_season_conflict',admit(x)$exclusion_reasons),'impossible event date')
x<-one;x$best_of<-'3';check(grepl('match_format_conflict',admit(x)$exclusion_reasons),'event match format')
x<-one;x$winner_id<-x$loser_id;check(grepl('identity_same_player',admit(x)$exclusion_reasons),'self match excluded')
x<-one;x$winner_id<-'';check(grepl('identity_missing',admit(x)$exclusion_reasons),'missing ID excluded')
x<-one;x$winner_name<-'';check(grepl('identity_missing',admit(x)$exclusion_reasons),'missing name excluded')
x<-one;x$winner_name<-'Conflicting name';check(all(grepl('identity_conflicting_id',admit(rbind(one,x))$exclusion_reasons)),'conflicting names excluded')
x<-one;x$winner_id<-'9999999';check(all(grepl('identity_name_collision',admit(rbind(one,x))$exclusion_reasons)),'unresolved name collision excluded')
x<-one;x$winner_hand<-if(one$winner_hand=='R')'L' else 'R';check(all(grepl('identity_conflicting_id',admit(rbind(one,x))$exclusion_reasons)),'hand conflict excluded')
check(all(grepl('duplicate_source_key',admit(rbind(one,one))$exclusion_reasons)),'all duplicate copies excluded')
x<-one;x$match_num<-'999999';check(all(grepl('duplicate_encounter',admit(rbind(one,x))$exclusion_reasons)),'duplicate encounter despite distinct source keys')
x<-one;x$w_ace<-'';check(grepl('missing_count:w_ace',admit(x)$exclusion_reasons),'missing counts')
for(value in c('-1','0.5','Inf','NaN','oops')) {
  x<-one;x$w_ace<-value;check(grepl('invalid_integer:w_ace',admit(x)$exclusion_reasons),'strict integer count')
}
x<-one;x$w_ace<-'0';check(!grepl('w_ace',admit(x)$exclusion_reasons),'zero aces allowed')
x<-one;x$w_svpt<-'0';check(grepl('positive_service',admit(x)$exclusion_reasons),'zero service points excluded')
x<-one;x$w_df<-x$w_svpt;check(grepl('second_won_df',admit(x)$exclusion_reasons),'double faults remain in second serve opportunities')
x<-one;x$w_SvGms<-'0';check(grepl('service_games_score_conflict',admit(x)$exclusion_reasons),'service game/score conflict')
x<-one;x$score<-'RET';x$w_ace<-'';x$l_df<-'999999';x$loser_name<-''
reason<-admit(x)$exclusion_reasons
check(all(vapply(c('status_retirement','missing_count:w_ace','count_bound:l_df','identity_missing'),grepl,TRUE,x=reason,fixed=TRUE)),'simultaneous exclusion reasons retained')
x<-one
for(field in sub('^winner_','',grep('^winner_',names(one),value=TRUE))) {
  if(paste0('loser_',field) %in% names(one)) {x[[paste0('winner_',field)]]<-one[[paste0('loser_',field)]];x[[paste0('loser_',field)]]<-one[[paste0('winner_',field)]]}
}
for(field in sub('^w_','',grep('^w_',names(one),value=TRUE))) {x[[paste0('w_',field)]]<-one[[paste0('l_',field)]];x[[paste0('l_',field)]]<-one[[paste0('w_',field)]]}
x$score<-one$score # Outcome reversal with another valid winning score, same game total.
swapped<-admit(x);check(swapped$membership=='INCLUDED'&&swapped$player_a_id==admit(one)$player_a_id&&swapped$player_b_id==admit(one)$player_b_id,'flipped winner/count sides preserve neutral membership')

files<-data.frame(file=inputs$file,state='VERIFIED')
noevent<-p[p$cell_id!='WTA|2021|Canada',]
cv<-sa_coverage(noevent,files)$coverage
check(sum(cv$round=='ALL')==30&&cv$state[cv$cell_id=='WTA|2021|Canada'&cv$round=='ALL']=='ABSENT_SOURCE_CELL','absent expected cell reported')
files$state[3]<-'BLOCKED';cv<-sa_coverage(noevent,files)$coverage
check(sum(cv$state=='FILE_BLOCKED')==10&&all(is.na(cv$observed_source_rows[cv$state=='FILE_BLOCKED'])),'blocked file cells unknown, not zero')
cv<-r$`cell-coverage`;check(sum(cv$round=='ALL')==30&&all(cv$state=='OBSERVED'),'all actual expected cells observed')
check(sum(cv$official_inventory_recall!='UNKNOWN')==3&&all(cv$official_inventory_recall[cv$official_inventory_recall!='UNKNOWN']=='1'),'only saved pilot denominators have recall')
check(all(cv$official_gate=='NOT_TESTED_BY_SOURCE_RECORD_RETENTION'),'official coverage gates not passed by proxy')
check(nrow(r$`field-availability`)==18*nrow(cv),'all required fields in each reported group')

# Inject one missing-file fingerprint without touching saved evidence; other files still run.
e<-new.env(parent=globalenv());sys.source('R/audit_source_defined_cohort.R',envir=e)
original_hash<-e$sa_hash;reads<-character();original_read<-e$sa_read
# Functions inherited from the audit keep their private environment and actual pin registry.
e$sa_hash<-function(path)if(path==inputs$path[3])'MISSING' else original_hash(path)
e$sa_read<-function(path){reads<<-c(reads,path);original_read(path)}
blocked<-e$sa_build()
check(!inputs$path[3] %in% reads,'blocked annual never parsed')
check(sum(blocked$`cell-coverage`$state=='FILE_BLOCKED')==10&&nrow(blocked$`cohort-membership`)==1755,'per-file failure preserves other audited files')
# Shared saved-use failure returns an explicit empty, six-table audit, not assumed admissions.
e$sa_hash<-function(path)if(path=='DATA_LICENSE.md')'MISSING' else original_hash(path)
blocked<-e$sa_build();check(nrow(blocked$`row-dispositions`)==0&&sum(blocked$`cell-coverage`$state=='FILE_BLOCKED')==30,'all blocked files still produce expected cells')

# Render two independent runs to fresh temporary releases; compare actual bytes.
r2<-audit_source_defined_cohort(FALSE)
check(identical(lapply(r,sa_lines),lapply(r2,sa_lines)),'independent deterministic rebuild')
tmp<-tempfile('phase2h-check-',tmpdir=tempdir());dir.create(tmp)
a<-file.path(tmp,'a');b<-file.path(tmp,'b');sa_publish(r,a);sa_publish(r2,b)
check(identical(vapply(list.files(a,full.names=TRUE),sa_hash,''),setNames(vapply(list.files(b,full.names=TRUE),sa_hash,''),list.files(a,full.names=TRUE))),'six byte-identical rerun files')
check(length(sa_publish(r,a))==6,'identical existing release accepted')
changed<-r;changed$summary$value[1]<-'different'
check(throws(sa_publish(changed,a)),'changed release refuses overwrite')
check(identical(vapply(list.files(a,full.names=TRUE),sa_hash,''),setNames(vapply(list.files(b,full.names=TRUE),sa_hash,''),list.files(a,full.names=TRUE))),'failed replacement preserves bytes')
writeLines('fixture',file.path(a,'unexpected.txt'))
check(throws(sa_publish(r,a)),'unexpected release file refuses overwrite')
unlink(tmp,recursive=TRUE) # Only this test's own temporary fixtures.
check(identical(hashes,setNames(vapply(names(sa_pins),sa_hash,''),names(sa_pins))),'all pinned inputs unchanged after tests')
historical_after<-data.frame(path=historical_paths,hash=vapply(historical_paths,sa_hash,''),
  size=file.info(historical_paths)$size,mtime=as.numeric(file.info(historical_paths)$mtime))
check(length(historical_paths)==14&&identical(historical_before,historical_after),'all fourteen Phase 2F outputs untouched')
cat('PASS:',checks,'focused Phase 2H checks\n')
