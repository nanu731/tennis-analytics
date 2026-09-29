# Focused Phase 2N tests; no historical suite is run.
source('R/aggregate_s08_batch_histories.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
equal<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
prior<-list.files('data/pilot',recursive=TRUE,full.names=TRUE);prior<-prior[!startsWith(prior,paste0(s08_dir,'/'))]
old_hashes<-vapply(prior,s08_hash,'')
s08_verify();ebm_verify();check(TRUE,'All authority, effective-count and membership pins')
pins<-s08_pins;pins[1]<-'wrong';check(fails(s08_verify(pins)),'Changed pin fails')
pins<-setNames('wrong','/nonexistent/phase2n-input');check(fails(s08_verify(pins)),'Missing pin fails')
s08_ignored();check(TRUE,'Approved output location ignored')
check(fails(s08_ignored('R/not-ignored')),'Unignored output stops')
# Two unequal-denominator earlier matches; player P1 moves from A to B.
m<-data.frame(match_id=paste0('f',1:6),audit_tour=c(rep('ATP',5),'WTA'),audit_season='2023',
 cell_id=c('E1','E1','E2','E3','E4','W1'),event=c('E1','E1','E2','E3','E4','W1'),surface='Hard',round='fixture',
 player_a_id=c('P1','P3','P1','P1','P1','P1'),player_b_id=c('P2','P1','P4','P5','P6','P7'),
 audit_source_path='synthetic',audit_source_row=as.character(1:6),count_origin='synthetic',a_original_side=c('winner','loser',rep('winner',4)),stringsAsFactors=FALSE)
d<-m;d$tourney_date<-c('20230101','20230101','20230102','20230102','20230103','20230102')
d$membership<-'INCLUDED';d$game_reconciliation<-'PASS'
d$winner_id<-ifelse(m$a_original_side=='winner',m$player_a_id,m$player_b_id)
d$loser_id<-ifelse(m$a_original_side=='winner',m$player_b_id,m$player_a_id)
for(side in c('w','l'))for(field in c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved'))d[[paste0('effective_',side,'_',field)]]<-'0'
w<-list(df=c(2,4,1,1,1,1),svpt=c(20,40,20,20,20,20),`1stIn`=c(10,30,10,10,10,10),`1stWon`=c(8,12,8,8,8,8),SvGms=rep(4,6),bpFaced=rep(3,6),bpSaved=rep(1,6))
l<-list(df=rep(1,6),svpt=rep(20,6),`1stIn`=rep(10,6),`1stWon`=rep(5,6),SvGms=c(4,6,4,4,4,4),bpFaced=rep(0,6),bpSaved=rep(0,6))
for(field in names(w)) {d[[paste0('effective_w_',field)]]<-as.character(w[[field]]);d[[paste0('effective_l_',field)]]<-as.character(l[[field]])}
ex<-d[1,];ex$match_id<-'excluded';ex$membership<-'EXCLUDED';ex$audit_source_row<-'7';d<-rbind(d,ex)
b<-ebm_build(m,d);f<-s08_build(b[[1]],b[[2]],m,d)
a<-f[[1]][f[[1]]$match_id=='f3'&f[[1]]$slot=='a',]
check(a$history_matches==2,'Exactly two prior contributions')
check(a$M03_num==20&&a$M03_den==40&&a$M03_rate==.5,'Pooled first-serve counts, not average rates')
check(a$M03_rate!=mean(c(8/10,12/30)),'Unequal-denominator negative control')
check(a$M05_num==6&&a$M05_den==20&&a$M05_rate==.3,'Pooled double-fault conditional rate')
check(a$M11_num==0&&a$M11_den==10&&a$M11_rate==0,'Opponent games; defined zero return-pressure rate')
check(a$M12_num==0&&a$M12_den==0&&is.na(a$M12_rate)&&a$M12_reason=='ZERO_POOLED_DENOMINATOR','Nonempty history with no conversion opportunities')
c<-s08_components(c(df=1,svpt=20,`1stIn`=12,`1stWon`=9),c(bpFaced=8,bpSaved=3,SvGms=4))
check(c['M11_num']/c['M11_den']==2&&c['M12_num']/c['M12_den']==5/8,'Opponent orientation and M11 above one valid')
z<-as.data.frame(as.list(c*0));p<-s08_pool(z)
check(all(is.na(unlist(p[paste0(s08_metrics,'_rate')]))),'Every zero denominator undefined')
check(all(unlist(p[paste0(s08_metrics,'_reason')])=='ZERO_POOLED_DENOMINATOR'),'Zero denominator reasons for every metric')
p<-s08_pool(z[FALSE,]);check(all(is.na(unlist(p[grep('_(num|den|rate)$',names(p))])))&&all(unlist(p[paste0(s08_metrics,'_reason')])=='EMPTY_HISTORY'),'Empty sums and rates remain undefined')
check(all(is.na(f[[2]][f[[2]]$match_id=='f6',paste0('d',s08_metrics)])),'Cross-tour histories unavailable')
check(all(f[[1]]$history_matches[f[[1]]$match_id %in% c('f3','f4')&f[[1]]$slot=='a']==2),'Same-date events freeze identical history')
for(ordering in list(6:1,c(2,1,4,3,6,5)))check(identical(f,s08_build(b[[1]][ordering,],b[[2]][nrow(b[[2]]):1,],m[ordering,],d[nrow(d):1,])),'Row/event/within-batch invariance')
# Reverse every neutral slot, preserving winner/loser count ownership.
ms<-m;ds<-d;ms[c('player_a_id','player_b_id')]<-ms[c('player_b_id','player_a_id')];ds[c('player_a_id','player_b_id')]<-ds[c('player_b_id','player_a_id')]
ms$a_original_side<-ifelse(ms$a_original_side=='winner','loser','winner');ds$a_original_side<-ifelse(ds$a_original_side=='winner','loser','winner')
bs<-ebm_build(ms,ds);fs<-s08_build(bs[[1]],bs[[2]],ms,ds)
check(equal(as.matrix(f[[2]][paste0('d',s08_metrics)]),-as.matrix(fs[[2]][paste0('d',s08_metrics)])),'Slot swap reverses every difference including M05')
for(metric in s08_metrics)check(equal(f[[2]][[paste0('a_',metric)]],fs[[2]][[paste0('b_',metric)]]),'Swapped rates follow player')
check(all(f[[2]]$M05_interpretation=='LOWER_IS_BETTER;dM05=A_MINUS_B_UNREVERSED'),'M05 sign is not reversed')
# Ledger mutations cannot drop, duplicate, substitute, or add contributions.
check(fails(s08_build(b[[1]],rbind(b[[2]],b[[2]][1,]),m,d)),'Duplicate ledger row fails')
check(fails(s08_build(b[[1]],b[[2]][-1,],m,d)),'Missing membership/placeholder fails')
bad<-b[[2]];j<-which(bad$membership_status=='ELIGIBLE_EARLIER_BATCH')[1];bad$prior_match_id[j]<-'excluded'
check(fails(s08_build(b[[1]],bad,m,d)),'Excluded contribution fails')
bad<-b[[2]];bad$prior_source_date[j]<-bad$target_source_date[j]
check(fails(s08_build(b[[1]],bad,m,d)),'Same-batch label fails')
bad<-d;bad$effective_w_df[1]<-'999';check(fails(s08_build(b[[1]],b[[2]],m,bad)),'Invalid effective count fails')
bad<-d;bad$winner_id[1]<-'wrong';check(fails(s08_build(b[[1]],b[[2]],m,bad)),'Identity/count orientation fails')
cat('Building full frozen S08 histories\n')
i<-s08_load();r<-do.call(s08_build,c(i,list(expected_n=2580L)));sl<-r[[1]];t<-r[[2]];s<-r[[3]]
check(nrow(t)==2580&&!anyDuplicated(t$match_id)&&setequal(t$match_id,i$m$match_id),'All frozen targets exactly once')
check(nrow(sl)==5160&&!anyDuplicated(paste(sl$match_id,sl$slot)),'All neutral slots exactly once')
check(sum(sl$history_matches)==56999&&sum(sl$history_matches==0)==805,'Exact Phase 2M cardinalities')
check(sum(t$all_s08_differences_defined)==2026,'Measured common availability')
check(sum(sl$M12_reason=='ZERO_POOLED_DENOMINATOR')==19,'Measured conversion zero opportunities')
check(sum(sl$M11_rate>1,na.rm=TRUE)==178,'Valid return-pressure intensities above one')
check(all(sl$last_history_source_label[sl$history_matches>0]<sl$source_tourney_date[sl$history_matches>0]),'Strict earlier-batch bounds')
check(!any(i$h$prior_match_id[i$h$membership_status=='ELIGIBLE_EARLIER_BATCH'] %in% i$d$match_id[i$d$membership!='INCLUDED']),'Frozen exclusions absent')
# Independent all-link reconstruction directly from effective winner/loser counts.
links<-i$h[i$h$membership_status=='ELIGIBLE_EARLIER_BATCH',];di<-match(links$prior_match_id,i$d$match_id)
win<-links$player_id==i$d$winner_id[di];check(all(win|links$player_id==i$d$loser_id[di]),'Independent player ownership')
raw<-function(field,opponent=FALSE) {
 use_w<-if(opponent)!win else win
 ifelse(use_w,as.numeric(i$d[[paste0('effective_w_',field)]][di]),as.numeric(i$d[[paste0('effective_l_',field)]][di]))
}
ind<-data.frame(M03_num=raw('1stWon'),M03_den=raw('1stIn'),M05_num=raw('df'),M05_den=raw('svpt')-raw('1stIn'),
 M11_num=raw('bpFaced',TRUE),M11_den=raw('SvGms',TRUE),M12_num=raw('bpFaced',TRUE)-raw('bpSaved',TRUE),M12_den=raw('bpFaced',TRUE))
pool<-rowsum(ind,paste(links$target_match_id,links$target_slot,sep='|'),reorder=FALSE)
keep<-which(sl$history_matches>0);got<-as.matrix(sl[keep,names(ind)]);expected<-as.matrix(pool[match(paste(sl$match_id[keep],sl$slot[keep],sep='|'),rownames(pool)),])
check(equal(got,expected),'Every pooled numerator and denominator independently reconstructed')
for(metric in s08_metrics) {
 den<-sl[[paste0(metric,'_den')]];num<-sl[[paste0(metric,'_num')]];rate<-sl[[paste0(metric,'_rate')]]
 check(identical(is.na(rate),is.na(den)|den==0),'Undefined denominator mask')
 check(equal(rate[den>0&!is.na(den)],(num/den)[den>0&!is.na(den)]),'Every rate equals ratio of pooled counts')
 check(!any(is.infinite(rate)),'No infinite rate')
}
cat('Testing full permutations and target/later-count perturbations\n')
set.seed(2);i2<-lapply(i,function(z)z[sample(nrow(z)),]);r2<-do.call(s08_build,c(i2,list(expected_n=2580L)))
check(identical(r,r2),'Full output invariant to independently permuted inputs')
bad<-i;later<-bad$d$tourney_date>='20230529'
for(side in c('w','l')) {field<-paste0('effective_',side,'_svpt');bad$d[[field]][later]<-as.character(as.numeric(bad$d[[field]][later])+7)}
r3<-do.call(s08_build,bad);target<-t$source_tourney_date<='20230529'
check(identical(t[target,],r3[[2]][target,]),'Target-batch and later counts cannot affect earlier/target features')
check(!identical(t[!target,],r3[[2]][!target,]),'Positive control: eligible earlier counts affect later features')
# Dedicated earlier-record control changes only one fixture numerator.
dp<-d;dp$effective_w_1stWon[1]<-'9';fp<-s08_build(b[[1]],b[[2]],m,dp)
check(fp[[1]]$M03_rate[fp[[1]]$match_id=='f3'&fp[[1]]$slot=='a']==21/40,'One earlier numerator changes later pooled feature exactly')
check(all(vapply(r,function(z)all(z$convention==ebm_convention)&all(z$verified_chronology_decision==ebm_chronology),TRUE)),'Both labels in every output row')
for(level in c('batch_key','cell_id','surface'))for(tour in c('ATP','WTA'))for(slot in c('ALL','a','b','difference')) {
 for(metric in s08_metrics) {
  z<-s[s$level==level&s$tour==tour&s$slot==slot&s$metric==metric,];q<-s[s$level=='tour'&s$tour==tour&s$slot==slot&s$metric==metric,]
  check(sum(z$n)==q$n&&sum(z$defined)==q$defined&&sum(z$undefined)==q$undefined&&sum(z$empty_history)==q$empty_history&&sum(z$zero_denominator)==q$zero_denominator,'Summary partition accounting')
 }
}
cat('Testing deterministic serialization and atomic installation\n')
scratch<-tempfile('phase2n-test-');dir.create(scratch)
e<-new.env(parent=environment(s08_install));e$s08_ignored<-function(dir)s08_need(startsWith(dir,paste0(scratch,'/')),'Scratch guard')
install<-s08_install;environment(install)<-e
one<-file.path(scratch,'one');two<-file.path(scratch,'two');broken<-file.path(scratch,'broken')
check(fails(install(r,broken,function(stage){check(!dir.exists(broken),'No final directory before install');stop('injected interruption')})),'Interruption fails before install')
check(!dir.exists(broken)&&!any(grepl('stage',list.files(scratch,all.files=TRUE))),'No partial release or staging remains')
check(fails(install(r,broken,function(stage)writeLines('corrupt',file.path(stage,'summary.csv')))),'Staged corruption fails closed')
install(r,one,function(stage)check(setequal(list.files(stage),paste0(s08_outputs,'.csv'))&&!dir.exists(one),'Complete staged set before atomic rename'))
install(r2,two);hashes<-function(dir)unname(vapply(file.path(dir,paste0(s08_outputs,'.csv')),s08_hash,''))
check(identical(hashes(one),hashes(two)),'Independent reruns byte-identical')
old<-hashes(one);install(r,one);check(identical(old,hashes(one)),'Identical existing release preserved')
changed<-r;changed[[1]]$M03_rate[1]<-999
check(fails(install(changed,one))&&identical(old,hashes(one)),'Different existing release never overwritten')
check(setequal(list.files(one),paste0(s08_outputs,'.csv')),'Three output files only')
check(identical(vapply(prior,s08_hash,''),old_hashes),'Every previous pilot artifact preserved')
scope<-c('R/aggregate_s08_batch_histories.R','R/test_s08_batch_histories.R','docs/s08-batched-history-aggregation.md','docs/status.md','docs/data-source-contract.md')
check(setequal(system2('git',c('diff','--name-only','b3ec4ff1447fe194e14fdbfedc636dce6db692ef'),stdout=TRUE),scope),'Exact five-file tracked scope')
check(!length(system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)),'No accidental untracked files')
saveRDS(r,'/private/tmp/phase2n-tested.rds')
cat(sprintf('PASS: %d focused checks; full pooled-count reconstruction and deterministic atomic outputs.\n',checks))
