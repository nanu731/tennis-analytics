# Focused Phase 2P tests; no scoring or historical suite.
source('R/build_surface_elo_baseline.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
near<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-11,check.attributes=FALSE))
prior<-list.files('data/pilot',recursive=TRUE,full.names=TRUE);prior<-prior[!startsWith(prior,paste0(se_dir,'/'))];old_hashes<-vapply(prior,se_hash,'')
se_verify();check(TRUE,'All current-authority and frozen-input pins')
bad<-se_pins;bad[1]<-'wrong';check(fails(se_verify(bad)),'Changed pin fails')
check(fails(se_verify(c('/nonexistent/phase2p-input'='wrong'))),'Missing pin fails')
se_ignored();check(TRUE,'Output location already ignored');check(fails(se_ignored('R/nonignored')),'Unignored output blocked')
check(se_probability(1500,1500)==.5&&near(se_probability(1900,1500),10/11),'Exact logistic scale')
check(near(se_probability(1700,1432)+se_probability(1432,1700),1),'Probability complement')
x<-data.frame(match_id=paste0('f',1:8),tour=c(rep('WTA',6),rep('ATP',2)),season=c(rep('2021',4),rep('2023',4)),
 source_tourney_date=c('20210101','20210101','20210102','20210102','20230101','20230102','20230101','20230102'),
 cell_id=paste0('E',1:8),event=paste0('E',1:8),surface=c('Hard','Hard','Clay','Hard','Grass','Hard','Hard','Clay'),round='fixture',
 player_a_id='P',player_b_id=c('Q','R','Q','R','Q','Q','Q','U'),a_s08_complete=FALSE,b_s08_complete=FALSE,s08_stratum='NEITHER_COMPLETE',stringsAsFactors=FALSE)
x$batch_key<-paste(x$tour,x$source_tourney_date,sep='|');y<-c(1,1,0,1,1,0,0,1)
f<-se_replay(x,y);p<-f$p;u<-f$u
getp<-function(id)p[p$match_id==id,]
getu<-function(tour,label,player,component,surface='ALL')u[u$tour==tour&u$source_tourney_date==label&u$player_id==player&u$component==component&u$surface==surface,]
check(getp('f1')$p_a_primary==.5&&getp('f2')$p_a_primary==.5,'Same-batch probabilities frozen')
q<-getu('WTA','20210101','P','OVERALL');check(q$before==1500&&q$accumulated_delta==32&&q$after==1532&&q$batch_matches==2,'Sum two deltas, never average')
check(getp('f3')$a_overall==1532&&getp('f4')$a_overall==1532,'Same-date multi-event frozen overall state')
check(getp('f3')$a_surface==1500&&getp('f4')$a_surface==1532,'Simultaneous multi-surface states independent')
z<-getp('f3');check(z$a_blend==1516&&near(z$p_a_primary,se_probability(1516,1492)),'Blend ratings before logistic transform')
check(abs(z$p_a_primary-mean(c(z$p_a_overall,.5)))>1e-6,'Probability averaging negative control')
q<-getu('WTA','20210102','P','SURFACE','Clay');check(q$accumulated_delta==-16,'Surface update uses independent surface expectation')
q<-getu('WTA','20210102','P','OVERALL');expected<-32*((0-getp('f3')$p_a_overall)+(1-getp('f4')$p_a_overall))
check(near(q$accumulated_delta,expected),'Overall update uses overall expectation and summed matches')
check(getp('f5')$a_surface==1500&&getp('f5')$a_surface_prior_matches==0,'Unseen surface starts at 1500, not overall')
check(getp('f6')$a_surface==getu('WTA','20210102','P','SURFACE','Hard')$after,'Unused Hard state unchanged during Grass batch')
check(getp('f5')$a_overall==getu('WTA','20210102','P','OVERALL')$after&&getp('f5')$a_overall_prior_matches==4,'WTA continuity across missing 2022, no reset')
check(getp('f7')$a_overall==1500&&getp('f7')$a_surface==1500,'Tour separation with shared player IDs')
check(getp('f8')$b_overall_cold&&!getp('f8')$a_overall_cold&&getp('f8')$p_a_primary!=.5,'One cold player not forced to even probability')
check(all(p$p_a_primary[p$a_overall_cold&p$b_overall_cold]==.5),'Both overall cold gives .5')
for(ii in list(8:1,c(2,1,4,3,6,5,8,7),order(x$event,decreasing=TRUE)))check(identical(f,se_replay(x[ii,],y[ii])),'Row/event/within-batch permutation invariance')
xs<-x;xs[c('player_a_id','player_b_id')]<-xs[c('player_b_id','player_a_id')];fs<-se_replay(xs,1-y)
check(near(p$p_a_primary,1-fs$p$p_a_primary)&&near(p$p_a_overall,1-fs$p$p_a_overall),'Neutral slot probability complement')
check(near(u$after,fs$u$after),'Slot swap preserves player state')
z<-p[p$tour=='WTA'&p$source_tourney_date=='20210102',];dd<-se_match_deltas(z,c(0,1))
check(all(tapply(dd$delta_g,dd$match_id,sum)==0)&&all(tapply(dd$delta_s,dd$match_id,sum)==0),'Exact zero-sum match deltas')
check(fails(se_replay(x,rep(2,8))),'Invalid outcomes fail')
cat('Building full frozen Elo baseline\n')
i<-se_load();r<-do.call(se_build,c(i,list(expected_n=2580L)));p<-r[[1]];u<-r[[2]];s<-r[[3]]
check(nrow(p)==2580&&!anyDuplicated(p$match_id)&&setequal(p$match_id,i$x$match_id),'All frozen targets exactly once')
check(identical(as.integer(table(factor(p$s08_stratum,levels=c('BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')))),c(2026L,284L,270L)),'Exact S08 strata')
check(all(is.finite(as.matrix(p[c('p_a_primary','p_b_primary','p_a_overall','p_b_overall')]))),'Finite probabilities for every target')
check(all(p$p_a_primary>0&p$p_a_primary<1&p$p_a_overall>0&p$p_a_overall<1),'No boundary probabilities')
check(!any(grepl('winner|loser|outcome|^y$|score',names(p))),'No outcomes exported')
check(sum(p$a_overall_cold+p$b_overall_cold)==805&&sum(p$a_surface_cold+p$b_surface_cold)==1684,'Measured cold slots')
check(all(p$a_overall_prior_matches>=p$a_surface_prior_matches)&all(p$b_overall_prior_matches>=p$b_surface_prior_matches),'Surface history subset of overall')
check(sum(u$batch_matches[u$component=='OVERALL'])==5160&&sum(u$batch_matches[u$component=='SURFACE'])==5160,'Every admitted match updates both players/components')
ids<-unlist(strsplit(u$contributing_match_ids,';',fixed=TRUE));check(setequal(ids,p$match_id)&&!any(ids %in% i$d$match_id[i$d$membership!='INCLUDED']),'Exact contribution universe, frozen exclusions preserved')
check(all(vapply(strsplit(u$contributing_match_ids,';',fixed=TRUE),function(v)!anyDuplicated(v),TRUE)),'No duplicate contribution per player/component/batch')
# Independent dense-matrix replay, initialized for every known player before loops.
reference<-function(p,y) {
 out<-matrix(NA_real_,nrow(p),4,dimnames=list(p$match_id,c('a_overall','b_overall','a_surface','b_surface')))
 for(tour in unique(p$tour)) {
  players<-sort(unique(c(p$player_a_id[p$tour==tour],p$player_b_id[p$tour==tour])))
  state<-matrix(1500,length(players),4,dimnames=list(players,c('G','Hard','Clay','Grass')))
  for(label in sort(unique(p$source_tourney_date[p$tour==tour]))) {
   ii<-which(p$tour==tour&p$source_tourney_date==label);ii<-ii[order(p$match_id[ii])];change<-state*0
   for(j in ii) {
    a<-p$player_a_id[j];b<-p$player_b_id[j];surf<-p$surface[j]
    out[j,]<-c(state[a,'G'],state[b,'G'],state[a,surf],state[b,surf])
    for(component in c('G',surf)) {
     expected<-1/(1+10^((state[b,component]-state[a,component])/400))
     delta<-32*(y[j]-expected);change[a,component]<-change[a,component]+delta;change[b,component]<-change[b,component]-delta
    }
   }
   state<-state+change
  }
 }
 out
}
y<-as.integer(i$m$a_original_side[match(p$match_id,i$m$match_id)]=='winner')
ref<-reference(p,y);check(near(as.matrix(p[colnames(ref)]),ref),'Every pre-batch component rating independently reproduced')
check(near(p$p_a_primary,1/(1+10^(((ref[,'b_overall']+ref[,'b_surface'])-(ref[,'a_overall']+ref[,'a_surface']))/800))),'Every blended probability independently reproduced')
# Audit contributor sums from saved pre-batch output; target outcomes used only here for updates.
for(component in c('OVERALL','SURFACE')) {
 prob<-if(component=='OVERALL')p$p_a_overall else se_probability(p$a_surface,p$b_surface)
 dg<-32*(y-prob)
 parts<-rbind(data.frame(id=p$player_a_id,batch=p$batch_key,surface=if(component=='OVERALL')'ALL' else p$surface,delta=dg),data.frame(id=p$player_b_id,batch=p$batch_key,surface=if(component=='OVERALL')'ALL' else p$surface,delta=-dg))
 sums<-tapply(parts$delta,paste(parts$id,parts$batch,parts$surface,sep='|'),sum)
 z<-u[u$component==component,];keys<-paste(z$player_id,z$batch_key,z$surface,sep='|')
 check(near(z$accumulated_delta,as.numeric(sums[keys]))&&near(z$after,z$before+z$accumulated_delta),'Every accumulated delta/after state audited')
 check(all(abs(tapply(z$accumulated_delta,paste(z$batch_key,z$surface),sum))<1e-10),'Zero-sum batches within floating tolerance')
}
# Exact pre-batch overall/surface counts independently from the frozen membership links.
h<-i$h[i$h$membership_status=='ELIGIBLE_EARLIER_BATCH',];ps<-i$x$surface[match(h$prior_match_id,i$x$match_id)]
for(slot in c('a','b')) {
 hs<-h[h$target_slot==slot&ps==h$target_surface,];ct<-table(factor(hs$target_match_id,levels=p$match_id))
 check(identical(as.integer(ct),as.integer(p[[paste0(slot,'_surface_prior_matches')]])),'Surface cold counts from exact frozen membership')
}
cat('Testing full permutations and cutoff perturbations\n')
set.seed(3);ip<-lapply(i,function(z)z[sample(nrow(z)),]);r2<-do.call(se_build,c(ip,list(expected_n=2580L)));check(identical(r,r2),'Byte-level full result permutation invariance')
prepared<-se_prepare(i$x,i$h,i$m,i$d,i$f);yy<-prepared$y;late<-prepared$x$source_tourney_date>='20230529';yy[late]<-1-yy[late]
changed<-se_replay(prepared$x,yy);early<-p$source_tourney_date<='20230529'
check(identical(p[early,],changed$p[early,]),'Target/later outcomes cannot alter earlier or current probabilities')
check(!identical(p[!early,],changed$p[!early,]),'Earlier eligible outcome changes later state: positive control')
xx<-prepared$x;xx[c('player_a_id','player_b_id')]<-xx[c('player_b_id','player_a_id')];xx[c('a_s08_complete','b_s08_complete')]<-xx[c('b_s08_complete','a_s08_complete')]
swap<-se_replay(xx,1-prepared$y);check(near(p$p_a_primary,1-swap$p$p_a_primary)&&near(u$after,swap$u$after),'Full slot swap preserves state and complements probabilities')
# Whole-build failures must not repair or reduce the cohort.
bad<-i;bad$x<-bad$x[-1,];check(fails(do.call(se_build,bad)),'Missing target fails')
bad<-i;bad$h<-rbind(bad$h,bad$h[1,]);check(fails(do.call(se_build,bad)),'Duplicate membership fails')
bad<-i;bad$x$source_tourney_date[1]<-'';check(fails(do.call(se_build,bad)),'Missing label fails')
bad<-i;bad$m$a_original_side[1]<-'unknown';check(fails(do.call(se_build,bad)),'Invalid result linkage fails')
bad<-i;bad$d$membership[which(bad$d$match_id==bad$m$match_id[1])]<-'EXCLUDED';check(fails(do.call(se_build,bad)),'Excluded target blocked')
bad<-i;bad$f$all_s08_differences_defined[1]<-ifelse(bad$f$all_s08_differences_defined[1]=='TRUE','FALSE','TRUE');check(fails(do.call(se_build,bad)),'Completeness conflict fails')
# Actual WTA season continuity for every carried player/component at its next update.
groups<-split(seq_len(nrow(u)),paste(u$tour,u$player_id,u$component,u$surface))
cross<-0L;continuous<-TRUE
for(ii in groups)if(length(ii)>1) {
 continuous<-continuous&&near(u$before[ii[-1]],u$after[ii[-length(ii)]])
 cross<-cross+sum(u$season[ii[-1]]!=u$season[ii[-length(ii)]])
}
check(continuous,'Every player/component state continues, including unused surfaces')
check(cross>0,'Observed WTA cross-season continuity exercised')
for(level in c('batch_key','cell_id','surface'))for(tour in c('ATP','WTA'))for(stratum in c('ALL','BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')) {
 z<-s[s$record_type=='COVERAGE'&s$level==level&s$tour==tour&s$stratum==stratum,];total<-s[s$record_type=='COVERAGE'&s$level=='tour'&s$tour==tour&s$stratum==stratum,]
 check(sum(z$targets)==total$targets&&sum(z$primary_available)==total$targets&&sum(z$overall_cold_slots)==total$overall_cold_slots&&sum(z$surface_cold_slots)==total$surface_cold_slots,'Coverage partitions agree')
}
check(all(vapply(r,function(z)all(z$convention==se_convention)&all(z$verified_chronology_decision==se_chronology),TRUE)),'Assumption and chronology labels everywhere')
cat('Testing deterministic serialization and atomic installation\n')
scratch<-tempfile('phase2p-test-');dir.create(scratch);e<-new.env(parent=environment(se_install));e$se_ignored<-function(dir)se_need(startsWith(dir,paste0(scratch,'/')),'Scratch guard')
install<-se_install;environment(install)<-e;one<-file.path(scratch,'one');two<-file.path(scratch,'two');broken<-file.path(scratch,'broken')
check(fails(install(r,broken,function(stage){check(!dir.exists(broken),'No partial final directory');stop('injected interruption')})),'Interrupted staging blocked')
check(!dir.exists(broken)&&!any(grepl('stage',list.files(scratch,all.files=TRUE))),'Interrupted staging cleaned')
check(fails(install(r,broken,function(stage)writeLines('corrupt',file.path(stage,'summary.csv')))),'Staged corruption blocked')
install(r,one,function(stage)check(setequal(list.files(stage),paste0(se_outputs,'.csv'))&&!dir.exists(one),'Complete staging before atomic rename'))
install(r2,two);hashes<-function(dir)unname(vapply(file.path(dir,paste0(se_outputs,'.csv')),se_hash,''))
check(identical(hashes(one),hashes(two)),'Independent reruns byte-identical')
old<-hashes(one);install(r,one);check(identical(old,hashes(one)),'Existing identical release preserved')
bad<-r;bad[[1]]$p_a_primary[1]<-.999;check(fails(install(bad,one))&&identical(old,hashes(one)),'Differing release never overwritten')
check(identical(vapply(prior,se_hash,''),old_hashes),'Historical pilot artifacts preserved')
scope<-c('R/build_surface_elo_baseline.R','R/test_surface_elo_baseline.R','docs/surface-elo-baseline-audit.md','docs/status.md','docs/data-source-contract.md')
check(setequal(system2('git',c('diff','--name-only','0ccea947232283cf43edcdd2b507c17aa16b332b'),stdout=TRUE),scope),'Exact five-file tracked scope')
check(!length(system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)),'No accidental untracked files')
saveRDS(r,'/private/tmp/phase2p-tested.rds');cat(sprintf('PASS: %d focused checks; independent replay, cutoffs, atomic installation and preservation.\n',checks))
