# Phase 2AE focused tests; no historical suite, fitting or scoring.
source('R/build_2024_surface_elo_baseline.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern=''){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),paste('fail closed',pattern))}
eq<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
e<-ae_helpers()
for(p in names(ae_pins))ok(ae_hash(p)==ae_pins[[p]],paste('input pin',p))
for(p in names(e$ac_pins))ok(ae_hash(p)==e$ac_pins[[p]],paste('inherited pin',p))
bad<-ae_pins;bad[1]<-'bad';fail(ae_verify(bad),'Missing/changed');fail(e$se_ignored('R/not-ignored'),'already be ignored')
t<-ae_reconcile(e)
ok(t$chain_residual==0&&t$replay_residual<1e-10,'development byte replay and terminal reconciliation')
ok(identical(vapply(t$states,function(s)length(s$g),1L),c(ATP=193L,WTA=267L)),'development overall states')
ok(identical(vapply(t$states,function(s)length(s$s),1L),c(ATP=388L,WTA=599L)),'development surface states')
ul<-e$se_read('data/pilot/surface-elo-baseline/rating-update-ledger.csv')
v<-ul;v$after[1]<-as.numeric(v$after[1])+1;fail(ae_terminal(v,e),'delta reconciliation')
v<-ul;v$prior_matches[1]<-1;fail(ae_terminal(v,e),'count reconciliation')
v<-rbind(ul,ul[1,]);fail(ae_terminal(v,e),'Duplicate')
v<-ul;v$before[1]<-as.numeric(v$before[1])+1;v$after[1]<-as.numeric(v$after[1])+1;fail(ae_terminal(v,e),'chain reconciliation')
i<-ae_prepare(e,t);r<-ae_build(i,t,e);p<-r[[1]];u<-r[[2]];s<-r[[3]]
ok(nrow(p)==1901&&!anyDuplicated(p$match_id)&&setequal(p$match_id,i$x$match_id),'1901 unique targets')
ok(identical(as.integer(table(p$tour)),c(944L,957L)),'tour totals')
ok(length(unique(p$batch_key))==20&&length(unique(p$cell_id))==20,'all batches/events')
probcols<-c('p_a_primary','p_b_primary','p_a_overall','p_b_overall')
ok(all(is.finite(as.matrix(p[probcols])))&&all(as.matrix(p[probcols])>0&as.matrix(p[probcols])<1),'finite nonboundary probabilities')
ok(!any(grepl('outcome|winner|loser|original_side',names(p))),'no target outcomes exported')
ok(all(p$p_a_primary+p$p_b_primary==1)&all(p$p_a_overall+p$p_b_overall==1),'probability complements')
ok(eq(p$p_a_primary,1/(1+10^((.5*p$b_overall+.5*p$b_surface-.5*p$a_overall-.5*p$a_surface)/400))),'blend then logistic')
ok(eq(p$p_a_overall,1/(1+10^((p$b_overall-p$a_overall)/400))),'overall logistic')
avg<-(p$p_a_overall+1/(1+10^((p$b_surface-p$a_surface)/400)))/2
ok(any(abs(p$p_a_primary-avg)>1e-6),'not probability averaging')
for(slot in c('a','b'))for(kind in c('overall','surface')) {
 cold<-p[[paste0(slot,'_',kind,'_cold')]]
 ok(all(p[[paste0(slot,'_',kind)]][cold]==1500),'unseen state exactly 1500')
 ok(identical(cold,p[[paste0(slot,'_',kind,'_prior_matches')]]==0),'cold count agrees')
}
# Independently join every player-batch update to frozen target ratings and outcomes.
y<-i$y[match(p$match_id,i$x$match_id)]
for(component in c('OVERALL','SURFACE')) {
 kind<-tolower(component);expectation<-1/(1+10^((p[[paste0('b_',kind)]]-p[[paste0('a_',kind)]])/400))
 delta<-32*(y-expectation)
 d<-rbind(data.frame(tour=p$tour,batch=p$batch_key,player=p$player_a_id,surface=p$surface,id=p$match_id,delta=delta),data.frame(tour=p$tour,batch=p$batch_key,player=p$player_b_id,surface=p$surface,id=p$match_id,delta=-delta))
 key<-paste(d$batch,d$player,if(component=='OVERALL')'ALL' else d$surface)
 zz<-u[u$component==component,];uk<-paste(zz$batch_key,zz$player_id,zz$surface)
 sums<-tapply(d$delta,key,sum);counts<-table(key)
 ok(eq(zz$accumulated_delta,as.numeric(sums[uk])),'independent component expectations and summed updates')
 ok(all(zz$batch_matches==as.integer(counts[uk]))&&sum(zz$batch_matches)==3802,'all contributions exactly twice')
 ok(all(vapply(seq_len(nrow(zz)),function(j)setequal(strsplit(zz$contributing_match_ids[j],';',fixed=TRUE)[[1]],d$id[key==uk[j]]),TRUE)),'exact contribution IDs no exclusions')
 ok(max(abs(zz$after-zz$before-zz$accumulated_delta))<1e-10,'unclipped after arithmetic')
 ok(max(abs(tapply(zz$accumulated_delta,paste(zz$batch_key,zz$surface),sum)))<1e-10,'zero-sum batch by component/surface')
 # Reconstruct pre-batch states independently from latest earlier saved ledger rows.
 for(slot in c('a','b')) {
  player<-p[[paste0('player_',slot,'_id')]]
  combined<-rbind(ul[ul$component==component,c('tour','source_tourney_date','player_id','surface','after','after_matches')],zz[c('tour','source_tourney_date','player_id','surface','after','after_matches')])
  got<-vapply(seq_len(nrow(p)),function(j){rows<-which(combined$tour==p$tour[j]&combined$player_id==player[j]&combined$source_tourney_date<p$source_tourney_date[j]&(component=='OVERALL'|combined$surface==p$surface[j]));if(!length(rows))return(1500);as.numeric(combined$after[rows[which.max(as.numeric(combined$source_tourney_date[rows]))]])},0.0)
  ok(eq(got,p[[paste0(slot,'_',kind)]]),'strict previous-state ownership/surface continuity')
 }
}
ok(any(abs(u$accumulated_delta)>32),'batch deltas remain greater than K where accumulated')
ok(all(u$after_matches==u$prior_matches+u$batch_matches),'update count continuity')
strata<-table(p$tour,factor(p$s08_stratum,levels=c('BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')))
ok(identical(as.integer(strata),c(871L,912L,71L,45L,2L,0L)),'exact Phase 2AD strata')
for(tour in c('ATP','WTA')){
 z<-s[s$level=='tour'&s$tour==tour&s$record_type=='COVERAGE'&s$stratum=='ALL',]
 ok(z$targets==sum(p$tour==tour)&&z$primary_available==z$targets&&z$overall_available==z$targets,'summary denominator')
}
set.seed(17);perm<-sample(nrow(i$x));rp<-ae_replay(i$x[perm,],i$y[perm],t$states,e)
ok(identical(rp$p,p)&&identical(rp$u,u),'row/event/within-batch permutation invariance')
# Every actual batch: change only its outcomes; every probability up through it is unchanged.
for(batch in unique(i$x$batch_key)) {
 yy<-i$y;ii<-which(i$x$batch_key==batch);yy[ii]<-1-yy[ii]
 rr<-ae_replay(i$x,yy,t$states,e)
 keep<-p$tour!=i$x$tour[ii[1]]|p$source_tourney_date<=i$x$source_tourney_date[ii[1]]
 ok(identical(rr$p[keep,],p[keep,]),paste('own/later outcome independence',batch))
}
swap<-i$x;swap$player_a_id<-i$x$player_b_id;swap$player_b_id<-i$x$player_a_id
swap$a_s08_complete<-i$x$b_s08_complete;swap$b_s08_complete<-i$x$a_s08_complete
rr<-ae_replay(swap,1-i$y,t$states,e)
ok(eq(rr$p$p_a_primary,1-p$p_a_primary)&&eq(rr$p$p_a_overall,1-p$p_a_overall),'global neutral slot complements')
ok(eq(rr$u,u),'slot swaps preserve updates')
# Same-date multi-event/multi-surface fixture with repeated player and untouched Grass state.
f<-i$x[rep(1,4),];f$match_id<-paste0('fixture',1:4);f$match_key<-paste0('FIXTURE|',f$match_id);f$event<-c('one','two','three','four');f$cell_id<-f$event
f$player_a_id<-'p';f$player_b_id<-c('q','r','s','q');f$surface<-c('Hard','Clay','Hard','Grass');f$source_tourney_date<-c(rep('20240101',3),'20240201');f$batch_key<-paste('ATP',f$source_tourney_date,sep='|')
ss<-list(ATP=list(g=numeric(),s=c('p|Grass'=1600),ng=numeric(),ns=c('p|Grass'=1),last_date='20231231'))
fr<-ae_replay(f,c(1,1,1,0),ss,e)
ok(all(fr$p$p_a_primary[1:3]==.5),'multi-event/multi-surface simultaneous probabilities')
z<-fr$u[fr$u$source_tourney_date=='20240101'&fr$u$player_id=='p'&fr$u$component=='OVERALL',]
ok(z$before==1500&&z$accumulated_delta==48&&z$after==1548,'sum not clip/average/sequential')
ok(fr$p$a_surface[4]==1600,'unused surface unchanged')
fp<-ae_replay(f[4:1,],c(0,1,1,1),ss,e);ok(identical(fr,fp),'fixture order invariance')
fr2<-ae_replay(f,c(0,0,0,0),ss,e)
ok(identical(fr$p[1:3,],fr2$p[1:3,])&&fr$p$p_a_primary[4]!=fr2$p$p_a_primary[4],'later batch outcome positive control')
bad<-t$states;bad$ATP$last_date<-'20250101';fail(ae_replay(i$x,i$y,bad,e),'Non-earlier')
fail(ae_replay(i$x,rep(2,nrow(i$x)),t$states,e),'Invalid neutral')
# Atomic installation uses temporary test directories; production ignore gate tested separately.
tmp<-tempfile('ae-tests-');dir.create(tmp)
original_ignore<-e$se_ignored;e$se_ignored<-function(dir)NULL
fail(e$se_install(r,file.path(tmp,'interrupted'),function(stage)stop('fixture interruption')),'fixture interruption')
ok(!dir.exists(file.path(tmp,'interrupted')),'interruption leaves no partial release')
fail(e$se_install(r,file.path(tmp,'corrupt'),function(stage)cat('changed',file=file.path(stage,'summary.csv'),append=TRUE)),'Staged bytes changed')
ok(!dir.exists(file.path(tmp,'corrupt')),'corruption not installed')
e$se_install(r,file.path(tmp,'release'));hashes<-vapply(file.path(tmp,'release',paste0(ae_outputs,'.csv')),ae_hash,'')
e$se_install(r,file.path(tmp,'release'));ok(identical(hashes,vapply(names(hashes),ae_hash,'')),'identical reinstall')
changed<-r;changed[[1]]$p_a_primary[1]<-.123;fail(e$se_install(changed,file.path(tmp,'release')),'Existing bytes differ')
ok(identical(hashes,vapply(names(hashes),ae_hash,'')),'existing release preserved')
e$se_ignored<-original_ignore
# Independent R process rebuilds/reconciles from saved inputs and serializes the three tables.
script<-file.path(tmp,'rerun.R')
writeLines(c("source('R/build_2024_surface_elo_baseline.R')","r<-build_2024_surface_elo_baseline(FALSE)",sprintf("for(j in seq_along(r))ae_write(r[[j]],file.path(%s,paste0(names(r)[j],'.csv')))",deparse(tmp))),script)
ok(system2(file.path(R.home('bin'),'Rscript'),shQuote(script))==0,'independent process rerun')
ok(identical(unname(hashes),unname(vapply(file.path(tmp,paste0(ae_outputs,'.csv')),ae_hash,''))),'three byte-identical outputs')
for(z in r)ok(all(z$convention==e$se_convention)&all(z$verified_chronology_decision==e$se_chronology)&all(z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),'every output limitations')
ae_verify();e$ac_verify();ok(TRUE,'historical dependency pins unchanged')
unlink(tmp,recursive=TRUE)
cat(n,'Phase 2AE focused checks passed\n')
