# Focused Phase 2M tests. Synthetic fixtures are not new source records.
source('R/build_event_batch_membership.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
prior_files<-list.files('data/pilot',recursive=TRUE,full.names=TRUE)
prior_files<-prior_files[!startsWith(prior_files,paste0(ebm_dir,'/'))]
prior_hashes<-vapply(prior_files,ebm_hash,'')
ebm_verify();check(TRUE,'Frozen input pins')
pins<-ebm_pins;pins[1]<-'invalid';check(fails(ebm_verify(pins)),'Changed pin fails')
check(fails(ebm_ignored('R/nonignored-fixture')),'Unignored destination fails')
ebm_ignored();check(TRUE,'Three authorized outputs ignored')
# One event contains two matches; two other events share a date and a player.
m<-data.frame(match_id=paste0('fixture',1:7),audit_tour=c(rep('ATP',5),rep('WTA',2)),audit_season='2023',
 cell_id=c('A1','A1','A2','A3','A4','W1','W2'),event=c('E1','E1','E2','E3','E4','E1','E2'),surface='Hard',round='fixture',
 player_a_id=c('1','1','1','1','4','1','1'),player_b_id=c('2','3','4','5','1','7','8'),
 audit_source_path='synthetic',audit_source_row=as.character(1:7),count_origin='synthetic',stringsAsFactors=FALSE)
d<-m;d$tourney_date<-c('20230101','20230101','20230102','20230102','20230103','20230101','20230102');d$membership<-'INCLUDED'
ex<-d[1,];ex$match_id<-'excluded';ex$player_a_id<-'4';ex$player_b_id<-'6';ex$membership<-'EXCLUDED';ex$audit_source_row<-'8';d<-rbind(d,ex)
f<-ebm_build(m,d);h<-f[[2]];links<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
get<-function(id,slot)links$prior_match_id[links$target_match_id==id&links$target_slot==slot]
check(nrow(f[[1]])==7,'Fixture complete target universe')
check(setequal(get('fixture3','a'),c('fixture1','fixture2')),'Earlier completed batch admitted')
check(setequal(get('fixture4','a'),c('fixture1','fixture2')),'Same-date events read identical frozen inventory')
check(!'fixture3' %in% get('fixture4','a')&&! 'fixture4' %in% get('fixture3','a'),'Tied shared-player events cannot update one another')
check(identical(get('fixture5','a'),'fixture3'),'Prior link from opposite player slot')
check(setequal(get('fixture5','b'),paste0('fixture',1:4)),'Target B links both prior slots')
check(identical(get('fixture7','a'),'fixture6'),'Tour separation even with identical player IDs')
check(!'excluded' %in% links$prior_match_id,'Excluded result never updates')
check(all(h$empty_reason[h$membership_status=='EMPTY_HISTORY']=='NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT'),'Explicit empty histories')
check(!any(links$prior_source_date>=links$target_source_date),'No same/later label contributions')
check(identical(f[[1]]$batch_key[3:4],rep('ATP|20230102',2)),'Simultaneous batch key')
for(ordering in list(7:1,c(3,4,1,2,7,6,5),c(2,1,4,3,5,6,7)))check(identical(f,ebm_build(m[ordering,],d[nrow(d):1,])),'Row/event/within-batch permutation invariant')
# Outcome/count changes cannot alter membership, even when values become invalid for a statistical analysis.
dc<-d;dc$score<-'changed';dc$winner_id<-'changed';dc$loser_id<-'changed';dc$w_ace<-NA;dc$l_svpt<--999
check(identical(f,ebm_build(m,dc)),'Outcome/count fields never select membership')
mm<-m;dd<-d;mm[1,c('player_a_id','player_b_id')]<-c('9','10');dd[1,c('player_a_id','player_b_id')]<-c('9','10')
check(!identical(f[[2]],ebm_build(mm,dd)[[2]]),'Positive control: earlier eligible linkage matters')
for(label in c('',NA,'not-a-label','20230230','20231301','2023011','20230101 ','20220101','20240229')) {
  dd<-d;dd$tourney_date[1]<-label;check(fails(ebm_build(m,dd)),'Missing/invalid/season-conflicting label rejected')
}
dd<-d;dd$tourney_date[2]<-'20230102';check(fails(ebm_build(m,dd)),'Conflicting labels in one admitted event rejected')
dd<-d;dd$tourney_date[8]<-'20230102';check(fails(ebm_build(m,dd)),'Excluded record cannot hide an event-label conflict')
check(fails(ebm_build(m[-1,],d,7L)),'Missing target blocked')
check(fails(ebm_build(rbind(m,m[1,]),d)),'Duplicate target blocked')
dd<-d;dd$membership[8]<-'INCLUDED';check(fails(ebm_build(m,dd)),'Membership expansion blocked')
check(all(ebm_label_valid(c('20200229','20230101')))&&!any(ebm_label_valid(c('20210229','20230230'))),'Strict calendar-label validation')
cat('Building full frozen inventory\n')
i<-ebm_load();r<-ebm_build(i$m,i$d,2580L);x<-r[[1]];h<-r[[2]];s<-r[[3]];links<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',];empty<-h[h$membership_status=='EMPTY_HISTORY',]
check(nrow(x)==2580&&!anyDuplicated(x$match_id)&&setequal(x$match_id,i$m$match_id),'All frozen targets exactly once')
check(length(unique(x$batch_key))==30&&length(unique(x$cell_id))==30,'Thirty real batches and cells')
check(identical(x$batch_key,paste(x$tour,x$source_tourney_date,sep='|')),'Batch key exact')
check(nrow(links)==56999&&nrow(empty)==805,'Measured membership/empty counts')
check(sum(x$a_history_matches==0|x$b_history_matches==0)==541&&sum(x$a_history_matches==0&x$b_history_matches==0)==264,'Cold-start target accounting')
check(sum(x$a_history_matches)+sum(x$b_history_matches)==nrow(links),'No placeholder counted as membership')
check(all(!nzchar(empty$prior_match_id)&!nzchar(empty$prior_batch_key)),'Empty histories have no fabricated prior')
check(all(nzchar(empty$empty_reason)&nzchar(empty$empty_detail)),'Every empty history has reasons')
check(all(links$prior_source_date<links$target_source_date),'Strict earlier-label invariant')
check(!any(links$prior_batch_key==links$target_batch_key),'Zero same-batch contributions')
excluded<-i$d$match_id[i$d$membership!='INCLUDED'];check(!any(links$prior_match_id %in% excluded),'All frozen exclusions preserved')
check(all(links$prior_match_id %in% i$m$match_id),'No unadmitted histories')
# Independent all-pairs join, rather than the production per-target filter.
p<-rbind(data.frame(id=x$match_id,tour=x$tour,date=x$source_tourney_date,player=x$player_a_id,slot='a'),
         data.frame(id=x$match_id,tour=x$tour,date=x$source_tourney_date,player=x$player_b_id,slot='b'))
j<-merge(p,p,by=c('tour','player'),suffixes=c('_target','_prior'))
j<-j[j$date_prior<j$date_target,]
expected<-paste(j$id_target,j$slot_target,j$player,j$id_prior,j$slot_prior,sep='|')
actual<-paste(links$target_match_id,links$target_slot,links$player_id,links$prior_match_id,links$prior_player_slot,sep='|')
check(!anyDuplicated(actual)&&setequal(actual,expected)&&length(actual)==length(expected),'Independent exact player linkage for every membership')
check(nrow(unique(h[c('target_match_id','target_slot')]))==5160,'Both slots including empty histories represented')
# Full second build permutes source/target rows independently, then compares every byte later.
set.seed(2023);m2<-i$m[sample(nrow(i$m)),];d2<-i$d[sample(nrow(i$d)),]
r2<-ebm_build(m2,d2,2580L);check(identical(r,r2),'Full cohort permutation invariant')
for(ordering in list(order(i$m$cell_id,decreasing=TRUE),rev(seq_len(nrow(i$m)))))
 check(identical(x[,names(ebm_prepare(i$m,i$d))],ebm_prepare(i$m[ordering,],i$d)),'Event and within-batch order canonicalized')
mutated<-i$d;rows<-mutated$tourney_date>='20230529'
for(field in c('score','winner_id','loser_id',grep('^(w_|l_|effective_)',names(mutated),value=TRUE)))mutated[[field]][rows]<-'perturbed'
check(identical(ebm_prepare(i$m,mutated),ebm_prepare(i$m,i$d)),'Target/later outcomes and counts do not enter prepared inputs')
check(identical(r,ebm_build(i$m,mutated,2580L)),'Full target/later perturbation leaves all outputs unchanged')
# Player-slot swapping changes labels, not the underlying candidate relation.
ms<-m;ds<-d;ms[c('player_a_id','player_b_id')]<-ms[c('player_b_id','player_a_id')];ds[c('player_a_id','player_b_id')]<-ds[c('player_b_id','player_a_id')]
fs<-ebm_build(ms,ds);canonical<-function(z)sort(paste(z$target_match_id,z$player_id,z$prior_match_id,z$membership_status))
check(identical(canonical(f[[2]]),canonical(fs[[2]])),'Slot swap equivariance')
check(identical(f[[1]]$a_history_matches,fs[[1]]$b_history_matches),'Swapped slot cardinalities')
for(level in c('batch','event','surface'))for(tour in c('ATP','WTA'))for(slot in c('ALL','a','b')) {
 z<-s[s$level==level&s$tour==tour&s$player_slot==slot,];total<-s[s$level=='tour'&s$tour==tour&s$player_slot==slot,]
 check(sum(z$candidate_memberships)==total$candidate_memberships&&sum(z$empty_player_slots)==total$empty_player_slots,'Summary partition accounting')
}
check(all(x$convention==ebm_convention)&&all(h$convention==ebm_convention)&&all(s$convention==ebm_convention),'Sensitivity labels in every output')
check(all(s$verified_chronology_decision==ebm_chronology),'Phase 2K finding retained')
check(!any(grepl('elapsed|inactivity|decay|rating|forecast|^M[0-9]',names(x))),'No unapproved analytical fields')
cat('Testing independent serialized reruns and atomic installation\n')
# Isolate filesystem fault tests outside the repository. The real Git-ignore guard
# is tested above; the private clone permits only this newly created scratch root.
scratch<-tempfile('phase2m-tests-');dir.create(scratch)
env<-new.env(parent=environment(ebm_install));env$ebm_ignored<-function(dir)ebm_need(startsWith(dir,paste0(scratch,'/')),'Fixture escaped scratch root')
install<-ebm_install;environment(install)<-env
a<-file.path(scratch,'one');b<-file.path(scratch,'two');broken<-file.path(scratch,'broken')
check(fails(install(r,broken,function(stage){check(!dir.exists(broken),'Final directory absent before atomic rename');stop('injected write failure')})),'Interrupted stage does not install')
check(!dir.exists(broken)&&!any(grepl('stage',list.files(scratch,all.files=TRUE))),'Failed stage cleaned, no partial release')
check(fails(install(r,broken,function(stage)writeLines('corruption',file.path(stage,'summary.csv')))),'Staged corruption fails closed')
check(!dir.exists(broken),'Corrupt output not installed')
install(r,a,function(stage)check(setequal(list.files(stage),paste0(ebm_outputs,'.csv'))&&!dir.exists(a),'All files staged before single rename'))
install(r2,b);hashes<-function(dir)unname(vapply(file.path(dir,paste0(ebm_outputs,'.csv')),ebm_hash,''))
check(identical(hashes(a),hashes(b)),'Byte-identical independently rebuilt outputs')
old<-hashes(a);install(r,a);check(identical(old,hashes(a)),'Identical existing output preserved')
bad<-r;bad[[1]]$a_history_matches[1]<-999L;check(fails(install(bad,a))&&identical(old,hashes(a)),'Changed output never overwrites release')
check(setequal(list.files(a),paste0(ebm_outputs,'.csv')),'Exactly three serialized outputs')
ebm_verify();check(identical(vapply(prior_files,ebm_hash,''),prior_hashes),'Every prior pilot artifact unchanged')
expected_scope<-c('R/build_event_batch_membership.R','R/test_event_batch_membership.R','docs/event-batch-membership-audit.md','docs/status.md','docs/data-source-contract.md')
changed<-system2('git',c('diff','--name-only','13718231cb6c04144d2235030142a9438d39662a'),stdout=TRUE)
check(setequal(changed,expected_scope),'Exact five-file tracked scope')
check(!length(system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)),'No accidental untracked files')
saveRDS(r,'/private/tmp/phase2m-tested.rds')
cat(sprintf('PASS: %d focused checks; exact memberships and byte-identical reruns.\n',checks))
