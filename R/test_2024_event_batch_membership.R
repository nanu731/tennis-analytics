# Phase 2AC focused tests; saved inputs and synthetic linkage fixtures only.
source('R/build_2024_event_batch_membership.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern=''){a<-tryCatch({force(expr);NULL},error=identity);ok(inherits(a,'error')&&grepl(pattern,conditionMessage(a),fixed=TRUE),paste('fail closed',pattern))}
e<-ac_helpers();i<-ac_read_inputs(e)
for(p in names(ac_pins))ok(ac_hash(p)==ac_pins[[p]],paste('pin',p))
p<-ac_pins;p[1]<-'bad';fail(ac_verify(p),'Frozen input');fail(e$ebm_ignored('R/not-ignored'),'already be ignored')
r<-do.call(ac_build,c(i,list(e=e)));x<-r[[1]];h<-r[[2]];s<-r[[3]]
l<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',];empty<-h[h$membership_status=='EMPTY_HISTORY',]
dev<-ac_prepare(i$dm,i$dd,'DEVELOPMENT',e);v<-ac_prepare(i$vm,i$vd,'VALIDATION_2024',e);pool<-rbind(dev,v)
ok(nrow(x)==1901&&!anyDuplicated(x$match_id)&&setequal(x$match_id,i$vm$match_id),'all 1901 targets exactly once')
ok(length(unique(paste(h$target_key,h$target_slot)))==3802,'all 3802 slots represented')
ok(!anyDuplicated(paste(h$target_key,h$target_slot,h$prior_key)),'no duplicate membership or empty placeholder')
ok(!anyDuplicated(pool$match_key),'qualified namespaces unique')
ok(length(intersect(dev$match_id,v$match_id))==0,'saved original namespaces currently disjoint')
ok(all(x$batch_key==paste(x$tour,x$source_tourney_date,sep='|')),'tour/date keys')
j<-match(l$prior_key,pool$match_key);t<-match(l$target_key,x$match_key)
ok(!anyNA(j)&&!anyNA(t),'exact admitted prior and target joins')
ok(all(pool$tour[j]==x$tour[t]&pool$tour[j]==l$tour),'same tour')
ok(all(pool$source_tourney_date[j]<x$source_tourney_date[t]),'strict earlier label')
ok(all(l$prior_match_id==pool$match_id[j]&l$prior_cohort==pool$cohort[j]),'unchanged IDs and origin')
for(slot in c('a','b')) {
 z<-l$target_slot==slot;ok(all(l$player_id[z]==x[[paste0('player_',slot,'_id')]][t[z]]),'exact target player')
 z<-l$prior_player_slot==slot;ok(all(l$player_id[z]==pool[[paste0('player_',slot,'_id')]][j[z]]),'exact prior player either slot')
 ok(all(x[[paste0(slot,'_history_matches')]]==x[[paste0(slot,'_development_matches')]]+x[[paste0(slot,'_validation_matches')]]),'history origin totals')
}
# Independent long-player merge proves complete inclusion, not just valid retained links.
long<-function(z,target=FALSE)do.call(rbind,lapply(c('a','b'),function(slot)data.frame(tour=z$tour,player=z[[paste0('player_',slot,'_id')]],key=z$match_key,date=z$source_tourney_date,slot=slot)))
a<-merge(long(x),long(pool),by=c('tour','player'),suffixes=c('_target','_prior'))
a<-a[a$date_prior<a$date_target,]
key<-function(target,slot,prior)paste(target,slot,prior,sep='::')
ok(setequal(key(a$key_target,a$slot_target,a$key_prior),key(l$target_key,l$target_slot,l$prior_key))&&nrow(a)==nrow(l),'independent all-pairs membership completeness')
for(cohort in c('DEVELOPMENT','VALIDATION_2024')) {
 d<-if(cohort=='DEVELOPMENT')i$dd else i$vd
 excluded<-paste(cohort,d$match_id[d$membership!='INCLUDED'],sep='|')
 ok(!any(l$prior_key %in% excluded),'no frozen exclusion contributes')
}
pm<-i$vd$audit_tour=='WTA'&i$vd$audit_season=='2024'&i$vd$event %in% c('Canada','Cincinnati')&i$vd$tourney_level=='PM'
new<-i$vd$match_id[pm&i$vd$membership=='INCLUDED'];ret<-i$vd$match_id[pm&i$vd$membership=='EXCLUDED']
ok(length(new)==105&&length(ret)==5,'approved 105/five accounting')
ok(!any(l$prior_match_id %in% ret),'five Toronto retirements never contribute')
newlinks<-l[l$prior_cohort=='VALIDATION_2024'&l$prior_match_id %in% new,]
ok(all(newlinks$prior_source_date<newlinks$target_source_date)&all(newlinks$tour=='WTA'),'newly admitted records obey cutoff/tour')
ok(setequal(key(newlinks$target_key,newlinks$target_slot,newlinks$prior_key),key(a$key_target[a$key_prior %in% paste('VALIDATION_2024',new,sep='|')],a$slot_target[a$key_prior %in% paste('VALIDATION_2024',new,sep='|')],a$key_prior[a$key_prior %in% paste('VALIDATION_2024',new,sep='|')])),'new admissions complete exact player join')
ok(all(empty$prior_key==''&empty$prior_match_id==''&empty$prior_cohort==''),'explicit empty placeholders')
ok(all(empty$empty_reason=='NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT'),'inherited empty reason')
ok(nrow(empty)==sum(x$a_history_matches==0)+sum(x$b_history_matches==0),'cold-start accounting')
for(z in r)ok(all(z$convention==e$ebm_convention&z$verified_chronology_decision==e$ebm_chronology&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),'limitation labels')
# Synthetic cross-cohort ID collision, simultaneous events, opposite prior slot and cross-tour collision.
mk<-function(ids,tours,years,cells,dates,pa,pb){
 m<-i$vm[rep(1,length(ids)),];m$match_id<-ids;m$audit_tour<-tours;m$audit_season<-years;m$cell_id<-cells;m$event<-cells;m$player_a_id<-pa;m$player_b_id<-pb;m$audit_source_row<-as.character(seq_along(ids));m$audit_source_path<-'synthetic'
 d<-i$vd[rep(which(i$vd$membership=='INCLUDED')[1],length(ids)),]
 for(k in intersect(names(m),names(d)))d[[k]]<-m[[k]]
 d$tourney_date<-dates;d$membership<-'INCLUDED';d$completion_status<-'source_reported_normal';d$quarantined<-'FALSE';d$exclusion_reasons<-'';list(m=m,d=d)
}
df<-mk(c('collision','dw'),c('ATP','WTA'),c('2023','2023'),c('D','DW'),c('20230101','20230101'),c('100','100'),c('200','900'))
vf<-mk(c('collision','t2','t3','t4','wt','wl'),c('ATP','ATP','ATP','ATP','WTA','WTA'),rep('2024',6),c('V1','V2','V3','V4','W1','W2'),c('20240101','20240201','20240201','20240301','20240101','20240201'),c('100','100','100','200','100','100'),c('300','400','500','600','700','800'))
ex<-vf$d[1,];ex$match_id<-'retired';ex$membership<-'EXCLUDED';ex$completion_status<-'retirement';ex$exclusion_reasons<-'status_retirement';vf$d<-rbind(vf$d,ex)
f<-ac_build(df$m,df$d,vf$m,vf$d,e,FALSE);fl<-f[[2]][f[[2]]$membership_status=='ELIGIBLE_EARLIER_BATCH',]
get<-function(id,slot='a')fl$prior_key[fl$target_match_id==id&fl$target_slot==slot]
ok(setequal(get('t2'),c('DEVELOPMENT|collision','VALIDATION_2024|collision')),'cohort-qualified collision distinct')
ok(identical(get('t2'),get('t3')),'simultaneous events use identical frozen prior inventory')
ok(!'VALIDATION_2024|t2' %in% get('t3')&&! 'VALIDATION_2024|t3' %in% get('t2'),'same-date events never contribute')
ok('DEVELOPMENT|collision' %in% get('t4'),'prior player B can feed target A')
ok(setequal(get('wl'),c('DEVELOPMENT|dw','VALIDATION_2024|wt')),'cross-tour player IDs separated')
for(ordering in list(6:1,c(2,3,1,6,5,4),c(1,3,2,4,5,6)))ok(identical(f,ac_build(df$m[2:1,],df$d[2:1,],vf$m[ordering,],vf$d[nrow(vf$d):1,],e,FALSE)),'row/event/within-batch permutation')
for(label in c('',NA,'20240230','20241301','2024011','20230101')){d<-vf$d;d$tourney_date[1]<-label;fail(ac_build(df$m,df$d,vf$m,d,e,FALSE))}
d<-vf$d;d$tourney_date[nrow(d)]<-'20240102';fail(ac_build(df$m,df$d,vf$m,d,e,FALSE),'Conflicting labels')
fail(ac_build(df$m,df$d,vf$m[-1,],vf$d,e,FALSE),'membership/exclusion')
fail(ac_build(df$m,df$d,rbind(vf$m,vf$m[1,]),vf$d,e,FALSE),'duplicate')
q<-df; q$m$player_a_id[1]<-'050';q$m$player_b_id[1]<-'060';q$d$player_a_id[1]<-'050';q$d$player_b_id[1]<-'060'
ok(!identical(f,ac_build(q$m,q$d,vf$m,vf$d,e,FALSE)),'positive eligible-linkage control')
# Full-cohort permutations and outcome/count perturbations; frozen admission is not recomputed.
j<-lapply(i,function(z)z[nrow(z):1,,drop=FALSE]);ok(identical(r,do.call(ac_build,c(j,list(e=e)))),'full saved permutation')
j<-i
for(k in c('dd','vd'))for(field in grep('^(winner_|loser_|w_|l_|effective_)|^score$',names(j[[k]]),value=TRUE))j[[k]][[field]]<-'PERTURBED'
ok(identical(r,do.call(ac_build,c(j,list(e=e)))),'all target/later outcomes and counts irrelevant')
# Independent processes and inherited atomic installer, isolated from production ignore guard.
tmp<-tempfile('ac-tests-');dir.create(tmp)
atomic_tests<-function(){
 on.exit(unlink(tmp,recursive=TRUE),add=TRUE)
 dirs<-file.path(tmp,c('one','two'));files<-paste0(ac_outputs,'.csv')
 for(dest in dirs){script<-paste0("source('R/build_2024_event_batch_membership.R');e<-ac_helpers();e$ebm_ignored<-function(...)NULL;e$ebm_install(ac_main(FALSE),",deparse(dest),")");status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)),stdout=FALSE,stderr=FALSE);ok(status==0,'independent rerun')}
 for(k in files)ok(ac_hash(file.path(dirs[1],k))==ac_hash(file.path(dirs[2],k)),paste('byte-identical',k))
 scratch<-ac_helpers();scratch$ebm_ignored<-function(...)NULL;dest<-file.path(tmp,'atomic')
 fail(scratch$ebm_install(r,dest,function(stage)stop('INTERRUPTED')),'INTERRUPTED');ok(!dir.exists(dest),'interruption exposes no partial release')
 fail(scratch$ebm_install(r,dest,function(stage)cat('changed',file=file.path(stage,'summary.csv'))),'Staged bytes changed');ok(!dir.exists(dest),'corrupt stage never installed')
 scratch$ebm_install(r,dest);before<-vapply(file.path(dest,files),ac_hash,'');scratch$ebm_install(r,dest);ok(identical(before,vapply(file.path(dest,files),ac_hash,'')),'idempotent install')
 bad<-r;bad[[1]]$match_id[1]<-'corrupt';fail(scratch$ebm_install(bad,dest),'Existing output bytes differ');ok(identical(before,vapply(file.path(dest,files),ac_hash,'')),'existing release retained')
 ok(!any(grepl('event-batch-stage',list.files(tmp,all.files=TRUE))),'scratch stages cleaned')
 if(dir.exists(ac_dir))for(k in files)ok(ac_hash(file.path(ac_dir,k))==ac_hash(file.path(dirs[1],k)),paste('installed rerun bytes',k))
}
atomic_tests();e$ebm_ignored();ok(TRUE,'three outputs ignored')
if(dir.exists(ac_dir))ok(setequal(list.files(ac_dir,all.files=TRUE,no..=TRUE),paste0(ac_outputs,'.csv')),'exact output scope')
ac_verify();ok(TRUE,'historical pins preserved')
expected<-c('PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md','R/build_2024_event_batch_membership.R','R/test_2024_event_batch_membership.R','docs/2024-event-batch-membership-audit.md')
changed<-system2('git',c('diff','--name-only','9537249390fcc3d9b59060feeca66ed6b1d4af6f'),stdout=TRUE)
other<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
added<-expected[!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)&file.exists(expected)]
ok(setequal(unique(c(changed,other,added)),expected),'exact six-file scope')
cat(n,'Phase 2AC focused checks passed\n')
