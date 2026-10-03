# Phase 2AJ: offline context-only inputs, synthetic forbidden-field perturbations.
source('R/build_2025_event_batch_membership.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern=''){a<-tryCatch({force(expr);NULL},error=identity);ok(inherits(a,'error')&&grepl(pattern,conditionMessage(a),fixed=TRUE),paste('fail closed',pattern))}
e<-aj_helpers();i<-aj_read_inputs(e)
for(p in names(aj_pins))ok(aj_hash(p)==aj_pins[[p]],paste('pin',p))
p<-aj_pins;p[1]<-'bad';fail(aj_verify(p),'Frozen input');fail(e$ebm_ignored('R/not-ignored'),'already be ignored')
for(z in i)ok(!any(grepl('^(winner_|loser_|w_|l_|effective_)|^score$',names(z))),'forbidden fields not loaded')
r<-do.call(aj_build,c(i,list(e=e)));x<-r[[1]];h<-r[[2]];s<-r[[3]]
l<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',];empty<-h[h$membership_status=='EMPTY_HISTORY',]
dev<-aj_prepare(i$dm,i$dd,'DEVELOPMENT',e);v<-aj_prepare(i$vm,i$vd,'VALIDATION_2024',e);f<-aj_prepare(i$tm,i$td,'FINAL_TEST_2025',e);pool<-rbind(dev,v,f)
ok(nrow(x)==1878&&!anyDuplicated(x$match_id)&&setequal(x$match_id,i$tm$match_id),'all 1878 targets once')
ok(length(unique(paste(h$target_key,h$target_slot)))==3756,'all 3756 slots represented')
ok(!anyDuplicated(paste(h$target_key,h$target_slot,h$prior_key)),'no duplicate contribution or placeholder')
ok(!anyDuplicated(pool$match_key),'qualified namespaces unique')
ok(all(x$batch_key==paste(x$tour,x$source_tourney_date,sep='|')),'exact batch keys')
j<-match(l$prior_key,pool$match_key);t<-match(l$target_key,x$match_key)
ok(!anyNA(j)&&!anyNA(t),'exact admitted joins')
ok(all(pool$tour[j]==x$tour[t]&pool$tour[j]==l$tour),'same tour')
ok(all(pool$source_tourney_date[j]<x$source_tourney_date[t]),'strict earlier batch')
ok(!any(l$prior_batch_key==l$target_batch_key),'no same batch')
ok(all(l$prior_match_id==pool$match_id[j]&l$prior_cohort==pool$cohort[j]),'original IDs and cohorts')
for(slot in c('a','b')) {
 q<-l$target_slot==slot;ok(all(l$player_id[q]==x[[paste0('player_',slot,'_id')]][t[q]]),'exact target player')
 q<-l$prior_player_slot==slot;ok(all(l$player_id[q]==pool[[paste0('player_',slot,'_id')]][j[q]]),'exact prior player either slot')
 ok(all(x[[paste0(slot,'_history_matches')]]==x[[paste0(slot,'_development_matches')]]+x[[paste0(slot,'_validation_matches')]]+x[[paste0(slot,'_final_test_matches')]]),'three-cohort origin totals')
}
# Independent join proves every eligible link is present, not only validity of kept links.
long<-function(z)do.call(rbind,lapply(c('a','b'),function(slot)data.frame(tour=z$tour,player=z[[paste0('player_',slot,'_id')]],key=z$match_key,date=z$source_tourney_date,slot=slot)))
a<-merge(long(x),long(pool),by=c('tour','player'),suffixes=c('_target','_prior'));a<-a[a$date_prior<a$date_target,]
key<-function(target,slot,prior)paste(target,slot,prior,sep='::')
ok(setequal(key(a$key_target,a$slot_target,a$key_prior),key(l$target_key,l$target_slot,l$prior_key))&&nrow(a)==nrow(l),'independent complete membership reconstruction')
for(cohort in c('DEVELOPMENT','VALIDATION_2024','FINAL_TEST_2025')) {
 d<-switch(cohort,DEVELOPMENT=i$dd,VALIDATION_2024=i$vd,FINAL_TEST_2025=i$td)
 excluded<-paste(cohort,d$match_id[d$membership!='INCLUDED'],sep='|');ok(!any(l$prior_key %in% excluded),'frozen exclusions never contribute')
}
pm<-i$vd$audit_tour=='WTA'&i$vd$audit_season=='2024'&i$vd$event %in% c('Canada','Cincinnati')&i$vd$tourney_level=='PM'
oldpm<-i$vd$match_id[pm&i$vd$membership=='INCLUDED'];ret<-i$vd$match_id[pm&i$vd$membership=='EXCLUDED']
ok(length(oldpm)==105&&length(ret)==5,'historical PM admissions preserved')
ok(all(paste('VALIDATION_2024',oldpm,sep='|') %in% pool$match_key),'all 105 remain eligible inventory')
ok(!any(paste('VALIDATION_2024',ret,sep='|') %in% l$prior_key),'historical PM retirements remain excluded')
want<-a$key_prior %in% paste('VALIDATION_2024',oldpm,sep='|');actual<-l$prior_key %in% paste('VALIDATION_2024',oldpm,sep='|')
ok(setequal(key(a$key_target[want],a$slot_target[want],a$key_prior[want]),key(l$target_key[actual],l$target_slot[actual],l$prior_key[actual])),'eligible historical PM exact linkage')
pm25<-i$td$audit_tour=='WTA'&i$td$event %in% c('Canada','Cincinnati')&i$td$tourney_level=='PM'&grepl('level_conflict',i$td$context_reasons)
fmt<-i$td$audit_tour=='ATP'&i$td$event=='Roland-Garros'&grepl('match_format_conflict',i$td$context_reasons)
ok(sum(pm25)==190&&sum(fmt)==6,'exact excluded 2025 contexts')
ok(!any(paste('FINAL_TEST_2025',i$td$match_id[pm25|fmt],sep='|') %in% c(l$prior_key,x$match_key)),'all 196 blocked rows contribute zero')
ok(all(empty$prior_key==''&empty$prior_match_id==''&empty$prior_cohort==''),'blank prior placeholders')
ok(all(empty$empty_reason=='NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT'),'explicit empty reason')
ok(nrow(empty)==sum(x$a_history_matches==0)+sum(x$b_history_matches==0),'empty slot reconciliation')
for(z in r)ok(all(z$analysis_label=='2025 locked source-label final-test sensitivity'&z$verified_chronology_decision==e$ebm_chronology&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'&z$m05_interpretation_gate=='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED'),'required limitations')
cc<-s[s$level=='event'&s$player_slot=='ALL',]
ok(nrow(cc)==20&&!anyDuplicated(cc$group),'all twenty expected cells')
bb<-cc[cc$group %in% c('WTA|2025|Canada','WTA|2025|Cincinnati'),]
ok(nrow(bb)==2&&all(bb$target_matches==0&bb$candidate_memberships==0&bb$empty_player_slots==0&bb$admission_cell_state=='WHOLLY_BLOCKED_CELL'&bb$excluded_panel_records==95),'blocked cells zero targets not cold starts')
# Independently verify every summary partition and its depth distribution.
for(k in seq_len(nrow(s))) {
 q<-s[k,];use<-switch(q$level,overall=rep(TRUE,nrow(x)),tour=x$tour==q$tour,season=x$tour==q$tour&x$season==q$group,batch=x$batch_key==q$group,event=x$cell_id==q$group,surface=x$tour==q$tour&x$surface==q$group)
 slots<-if(q$player_slot=='ALL')c('a','b') else q$player_slot;depth<-unlist(x[use,paste0(slots,'_history_matches'),drop=FALSE],use.names=FALSE)
 ok(q$target_matches==sum(use)&&q$target_player_slots==length(depth)&&q$candidate_memberships==sum(depth)&&q$empty_player_slots==sum(depth==0),'summary accounting')
 if(length(depth))ok(all(c(q$min_memberships,q$p25_memberships,q$median_memberships,q$p75_memberships,q$max_memberships)==unname(quantile(depth,c(0,.25,.5,.75,1),type=7))),'depth distribution') else ok(all(is.na(c(q$min_memberships,q$p25_memberships,q$median_memberships,q$p75_memberships,q$max_memberships))),'no-target depth undefined')
 ok(q$candidate_memberships==q$development_memberships+q$validation_memberships+q$earlier_final_test_memberships,'summary cohort decomposition')
}
# Three-cohort collision, simultaneous events, opposite slot, cross-tour IDs and empty cells.
mk<-function(ids,tours,years,cells,dates,pa,pb){
 m<-i$tm[rep(1,length(ids)),];m$match_id<-ids;m$audit_tour<-tours;m$audit_season<-years;m$cell_id<-cells;m$event<-cells;m$player_a_id<-pa;m$player_b_id<-pb;m$audit_source_row<-as.character(seq_along(ids));m$audit_source_path<-'synthetic'
 d<-i$td[rep(which(i$td$membership=='INCLUDED')[1],length(ids)),]
 for(k in intersect(names(m),names(d)))d[[k]]<-m[[k]]
 d$tourney_date<-dates;d$membership<-'INCLUDED';d$completion_status<-'source_reported_normal';d$quarantined<-'FALSE';d$exclusion_reasons<-'';list(m=m,d=d)
}
df<-mk(c('collision','dw'),c('ATP','WTA'),c('2023','2023'),c('D','DW'),c('20230101','20230101'),c('100','100'),c('200','900'))
vf<-mk(c('collision','vw'),c('ATP','WTA'),c('2024','2024'),c('V','VW'),c('20240101','20240101'),c('100','100'),c('300','950'))
tf<-mk(c('collision','t2','t3','t4','wt','wl'),c('ATP','ATP','ATP','ATP','WTA','WTA'),rep('2025',6),c('T1','T2','T3','T4','W1','W2'),c('20250101','20250201','20250201','20250301','20250101','20250201'),c('100','100','100','200','100','100'),c('300','400','500','600','700','800'))
ex<-tf$d[1,];ex$match_id<-'retired';ex$membership<-'EXCLUDED';ex$completion_status<-'retirement';ex$exclusion_reasons<-'status_retirement';tf$d<-rbind(tf$d,ex)
fc<-i$cells[rep(1,6),];fc$tour<-tf$m$audit_tour;fc$season<-'2025';fc$event<-fc$cell_id<-tf$m$cell_id;fc$surface<-tf$m$surface;fc$round<-'ALL';fc$admitted_source_records<-'1'
f<-aj_build(df$m,df$d,vf$m,vf$d,tf$m,tf$d,fc,e,FALSE);fl<-f[[2]][f[[2]]$membership_status=='ELIGIBLE_EARLIER_BATCH',]
get<-function(id,slot='a')fl$prior_key[fl$target_match_id==id&fl$target_slot==slot]
ok(setequal(get('t2'),c('DEVELOPMENT|collision','VALIDATION_2024|collision','FINAL_TEST_2025|collision')),'three qualified collisions distinct')
ok(identical(get('t2'),get('t3')),'simultaneous events equal prior inventory')
ok(!'FINAL_TEST_2025|t2' %in% get('t3')&&!'FINAL_TEST_2025|t3' %in% get('t2'),'simultaneous events never contribute')
ok('DEVELOPMENT|collision' %in% get('t4'),'prior B to target A')
ok(setequal(get('wl'),c('DEVELOPMENT|dw','VALIDATION_2024|vw','FINAL_TEST_2025|wt')),'cross-tour IDs separated')
for(ord in list(6:1,c(2,3,1,6,5,4),c(1,3,2,4,5,6)))ok(identical(f,aj_build(df$m[2:1,],df$d[2:1,],vf$m[2:1,],vf$d[2:1,],tf$m[ord,],tf$d[nrow(tf$d):1,],fc[6:1,],e,FALSE)),'row/event/within-batch permutation')
for(label in c('',NA,'20250230','20251301','2025011','20240101')){d<-tf$d;d$tourney_date[1]<-label;fail(aj_build(df$m,df$d,vf$m,vf$d,tf$m,d,fc,e,FALSE))}
d<-tf$d;d$tourney_date[nrow(d)]<-'20250102';fail(aj_build(df$m,df$d,vf$m,vf$d,tf$m,d,fc,e,FALSE),'Conflicting labels')
fail(aj_build(df$m,df$d,vf$m,vf$d,tf$m[-1,],tf$d,fc,e,FALSE),'membership/exclusion')
fail(aj_build(df$m,df$d,vf$m,vf$d,rbind(tf$m,tf$m[1,]),tf$d,fc,e,FALSE),'duplicate')
q<-df;q$m$player_a_id[1]<-q$d$player_a_id[1]<-'050';q$m$player_b_id[1]<-q$d$player_b_id[1]<-'060'
ok(!identical(f,aj_build(q$m,q$d,vf$m,vf$d,tf$m,tf$d,fc,e,FALSE)),'eligible-linkage positive control')
j<-lapply(i,function(z)z[nrow(z):1,,drop=FALSE]);ok(identical(r,do.call(aj_build,c(j,list(e=e)))),'full saved permutation')
# Added synthetic fields only: actual outcomes/scores/counts were never loaded.
j<-i
for(k in c('dm','dd','vm','vd','tm','td'))for(field in c('winner_id','loser_id','score','w_svpt','l_svpt','effective_w_df'))j[[k]][[field]]<-'SYNTHETIC_PERTURBATION'
ok(identical(r,do.call(aj_build,c(j,list(e=e)))),'target and later outcomes/scores/counts irrelevant')
tmp<-tempfile('aj-tests-');dir.create(tmp)
atomic_tests<-function(){
 on.exit(unlink(tmp,recursive=TRUE),add=TRUE)
 fixture<-file.path(tmp,'reader.csv');write.csv(j$td[1:2,],fixture,row.names=FALSE)
 z<-aj_read_columns(fixture,aj_disposition_fields);ok(!any(c('winner_id','loser_id','score','w_svpt','l_svpt','effective_w_df') %in% names(z)),'reader discards forbidden columns')
 w<-j$td[1:2,];w$score<-'DIFFERENT';w$winner_id<-'999';w$w_svpt<-'999';write.csv(w,fixture,row.names=FALSE)
 ok(identical(z,aj_read_columns(fixture,aj_disposition_fields)),'reader invariant to changed synthetic forbidden values')
 dirs<-file.path(tmp,c('one','two'));files<-paste0(aj_outputs,'.csv')
 for(dest in dirs){script<-paste0("source('R/build_2025_event_batch_membership.R');e<-aj_helpers();e$ebm_ignored<-function(...)NULL;e$ebm_install(aj_main(FALSE),",deparse(dest),")");status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)),stdout=FALSE,stderr=FALSE);ok(status==0,'independent rerun')}
 for(k in files)ok(aj_hash(file.path(dirs[1],k))==aj_hash(file.path(dirs[2],k)),paste('byte-identical',k))
 scratch<-aj_helpers();scratch$ebm_ignored<-function(...)NULL;dest<-file.path(tmp,'atomic')
 fail(scratch$ebm_install(r,dest,function(stage)stop('INTERRUPTED')),'INTERRUPTED');ok(!dir.exists(dest),'interruption no partial release')
 fail(scratch$ebm_install(r,dest,function(stage)cat('changed',file=file.path(stage,'summary.csv'))),'Staged bytes changed');ok(!dir.exists(dest),'corrupt stage never installed')
 scratch$ebm_install(r,dest);before<-vapply(file.path(dest,files),aj_hash,'');scratch$ebm_install(r,dest);ok(identical(before,vapply(file.path(dest,files),aj_hash,'')),'idempotent installation')
 bad<-r;bad[[1]]$match_id[1]<-'corrupt';fail(scratch$ebm_install(bad,dest),'Existing output bytes differ');ok(identical(before,vapply(file.path(dest,files),aj_hash,'')),'existing release retained')
 if(dir.exists(aj_dir))for(k in files)ok(aj_hash(file.path(aj_dir,k))==aj_hash(file.path(dirs[1],k)),paste('installed rerun bytes',k))
}
atomic_tests();e$ebm_ignored();ok(TRUE,'three outputs ignored')
if(dir.exists(aj_dir))ok(setequal(list.files(aj_dir,all.files=TRUE,no..=TRUE),paste0(aj_outputs,'.csv')),'exact output scope')
aj_verify();ok(TRUE,'historical input pins preserved')
expected<-c('PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md','R/build_2025_event_batch_membership.R','R/test_2025_event_batch_membership.R','docs/2025-event-batch-membership-audit.md')
changed<-system2('git',c('diff','--name-only','cbc619885c2b825641bf4c8ebe8245bf161fcc36'),stdout=TRUE);other<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
added<-expected[!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)&file.exists(expected)]
ok(all(unique(c(changed,other,added)) %in% expected),'no files outside six-file scope')
cat(n,'Phase 2AJ focused checks passed\n')
