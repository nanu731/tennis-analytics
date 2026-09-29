# Focused Phase 2R checks only. Does not invoke any historical suite.
source('R/run_s08_paired_evaluation.R')
checks<-0L
check<-function(ok,label){if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
near<-function(a,b,tol=1e-10)isTRUE(all.equal(a,b,tolerance=tol,check.attributes=FALSE))
prior<-list.files('data/pilot',recursive=TRUE,full.names=TRUE);prior<-prior[!startsWith(prior,paste0(sq_dir,'/'))];before<-vapply(prior,sq_hash,'')
sq_verify();check(TRUE,'All 16 literal input/authority pins')
bad<-sq_pins;bad[1]<-'wrong';check(fails(sq_verify(bad)),'Changed pin fails');check(fails(sq_verify(c('/nonexistent/sq-input'='x'))),'Missing pin fails')
sq_ignored();check(TRUE,'Outputs already ignored');check(fails(sq_ignored('R/not-ignored')),'Nonignored output blocked')
i<-list(x=sq_read('data/pilot/event-batch-membership/target-batches.csv'),f=sq_read('data/pilot/s08-batched-histories/target-s08-features.csv'),
 e=sq_read('data/pilot/surface-elo-baseline/target-elo-probabilities.csv'),m=sq_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),d=sq_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))
x<-do.call(sq_prepare,i)
check(nrow(x)==2580&&!anyDuplicated(x$match_id),'Exactly 2580 unique targets')
check(identical(as.integer(table(factor(x$s08_stratum,levels=c('BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')))),c(2026L,284L,270L)),'Frozen completeness strata')
check(all(x$y %in% c(0,1)),'Binary neutral labels')
check(identical(x$match_id,sort(x$match_id))==FALSE,'Canonical order is batch order, not match-ID chronology')
for(field in c('tour','season','cell_id','surface','batch_key','source_tourney_date','player_a_id','player_b_id')) {
 bad<-i;bad$f[[field]][1]<-'WRONG';check(fails(do.call(sq_prepare,bad)),paste('Reject feature join',field))
}
bad<-i;bad$e<-bad$e[-1,];check(fails(do.call(sq_prepare,bad)),'Missing comparator fails')
bad<-i;bad$f<-rbind(bad$f,bad$f[1,]);check(fails(do.call(sq_prepare,bad)),'Duplicate feature target fails')
bad<-i;bad$m$a_original_side[1]<-'unknown';check(fails(do.call(sq_prepare,bad)),'Invalid outcome linkage fails')
bad<-i;bad$d$membership[match(bad$x$match_id[1],bad$d$match_id)]<-'EXCLUDED';check(fails(do.call(sq_prepare,bad)),'Exclusion change fails')
bad<-i;bad$d<-rbind(bad$d,bad$d[match(bad$x$match_id[1],bad$d$match_id),]);check(fails(do.call(sq_prepare,bad)),'Duplicate relevant disposition fails')
check(sum(i$d$match_id=='')==5471&&all(i$d$membership[i$d$match_id=='']=='OUTSIDE_PANEL'),'Outside-panel empty IDs remain outside the target join')
for(label in c('','20231301','20230230','20240101','2023-01-01')) {
 bad<-i;bad$x$source_tourney_date[1]<-label;check(fails(do.call(sq_prepare,bad)),'Missing/invalid/unauthorized label fails')
}
bad<-i;bad$x$batch_key[1]<-'wrong';check(fails(do.call(sq_prepare,bad)),'Conflicting batch key fails')
bad<-i;bad$f$dM03[1]<-'0';check(fails(do.call(sq_prepare,bad)),'Frozen undefined difference cannot become zero')
bad<-i;bad$e$p_a_primary[1]<-'NaN';check(fails(do.call(sq_prepare,bad)),'Nonfinite comparator fails')
# Balanced deterministic fixtures: full Cartesian sign design plus offsets tests SD-only scaling.
fixture<-expand.grid(rep(list(c(-1,1)),5));train<-as.data.frame(fixture[rep(1:32,each=4),1:4]);names(train)<-sq_metrics
train$y<-rep(as.integer(fixture[[5]]==1),each=4);train$batch_key<-rep(paste0('B',1:8),length.out=nrow(train))
train$dM03<-train$dM03+.2
f<-sq_readiness(train);check(f$record$ready,'Balanced full-rank fixture passes')
check(f$record$rank==4&&length(f$fit$coefficients)==4,'Four-predictor rank, no intercept')
check(near(f$sd,vapply(train[sq_metrics],sd,0.0)),'Sample SD scaling')
X<-as.matrix(train[sq_metrics]);eta<-sq_eta(X,f$fit,f$sd)
check(near(plogis(eta)+plogis(sq_eta(-X,f$fit,f$sd)),rep(1,nrow(train))),'Isolated target-slot complementarity')
check(mean((X/f$sd[1])[,1])!=0,'Fixture retains nonzero mean')
bad<-train;bad$batch_key<-'B';f1<-sq_readiness(bad)
check(f1$record$reasons=='INSUFFICIENT_BATCHES'&&f1$record$design_gate=='NOT_RUN'&&f1$record$fit_gate=='NOT_RUN','Count failure blocks downstream checks')
f1<-sq_readiness(train[1:10,]);check(grepl('INSUFFICIENT_MATCHES',f1$record$reasons)&&grepl('INSUFFICIENT_CLASSES',f1$record$reasons),'All applicable count failures')
bad<-train;bad$y<-0;check(grepl('INSUFFICIENT_CLASSES',sq_readiness(bad)$record$reasons),'Class gate')
bad<-train;bad$dM03<-1;f1<-sq_readiness(bad);check(f1$record$reasons=='INVALID_OR_CONSTANT_PREDICTOR'&&f1$record$fit_gate=='NOT_RUN','Constant predictor blocks fit')
bad<-train;bad$dM03[1]<-Inf;check(grepl('INVALID_OR_CONSTANT_PREDICTOR',sq_readiness(bad)$record$reasons),'Nonfinite predictor blocks fit')
bad<-train;bad$dM05<-bad$dM03;check(sq_readiness(bad)$record$reasons=='RANK_FAILURE','Rank deficiency blocks fit')
bad<-train;bad$dM05<-bad$dM03+.001*bad$dM05;check(grepl('NEAR_REDUNDANCY',sq_readiness(bad)$record$reasons),'Registered collinearity failure')
bad<-train;bad$dM05<-bad$dM03+.4*bad$dM05;check(grepl('VIF_CONCERN',sq_readiness(bad)$record$reasons),'VIF concern withholds fold')
bad<-train;bad$dM03<-bad$dM03-.2;bad$y<-as.integer(bad$dM03>0);f1<-sq_readiness(bad)
check(!f1$record$ready&&grepl('SEPARATION_INDICATION',f1$record$reasons),'Complete separation fixture withheld')
bad<-train;bad$dM03<-rep(c(-1,0,1,0),length.out=nrow(bad));bad$y<-ifelse(bad$dM03>0,1,ifelse(bad$dM03<0,0,bad$y));f1<-sq_readiness(bad)
check(!f1$record$ready,'Quasi-separated fixture withheld')
fake<-list(converged=FALSE,rank=4,coefficients=rep(1,4),linear.predictors=c(-100,100),fitted.values=c(0,1),boundary=TRUE)
d<-sq_fit_diagnostics(fake,c(0,1),'fixture warning',4)
check(all(c('NONCONVERGENCE','FITTING_WARNING','BOUNDARY_FIT','EXTREME_TRAINING_PROBABILITY','SEPARATION_INDICATION') %in% d$reasons),'All detected fit failures retained')
fake$coefficients[1]<-Inf;check('NONFINITE_FIT' %in% sq_fit_diagnostics(fake,c(0,1),expected_rank=4)$reasons,'Nonfinite coefficient fails')
check(near(sq_loss(c(0,1000,-1000),c(1,0,1)),c(log(2),1000,1000)),'Stable natural-log loss without clipping')
check(near(sq_probability_loss(c(.2,.8),c(0,1)),-log(c(.8,.8))),'Probability loss identities')
check(identical(sq_probability_loss(c(0,1,0,1),c(0,1,1,0)),c(0,0,Inf,Inf)),'Boundary loss is explicit, never clipped')
check(identical(sq_accuracy(c(.5,.6,.4),c(0,1,0)),c(.5,1,1)),'Half-credit ties and fixed accuracy threshold')
cat('Computing fixed full-cohort evaluation\n')
r<-sq_build(x);p<-r[['target-predictions']];folds<-r[['fold-readiness']];sc<-r[['paired-scores']];fits<-r[['model-fits']];st<-r[['stability']]
check(nrow(p)==2580&&!anyDuplicated(p$match_id)&&setequal(p$match_id,x$match_id),'No target loss after evaluation')
check(nrow(folds)==30&&sum(folds$ready)==18,'30 batches, 18 ready folds')
check(identical(as.integer(tapply(p$paired,p$tour,sum)),c(211L,1067L)),'Measured paired counts by tour')
check(all(is.na(p$p_s08[!p$fold_ready]))&&all(is.na(p$p_s08[!p$complete])),'Failures and incomplete vectors withhold predictions')
check(sum(!is.finite(p$p_s08))==1302&&sum(!p$complete)==554,'Full failure accounting')
check(sum(!p$complete&p$fold_ready)==148&&sum(p$complete&!p$fold_ready)==748,'Readiness and completeness overlap accounted')
check(all(folds$reasons[!folds$ready] %in% c('INSUFFICIENT_BATCHES','INSUFFICIENT_BATCHES;INSUFFICIENT_MATCHES','INSUFFICIENT_BATCHES;INSUFFICIENT_MATCHES;INSUFFICIENT_CLASSES')),'Measured failures are readiness only')
for(j in seq_len(nrow(folds))) {
 f<-folds[j,];tr<-x[x$tour==f$tour&x$source_tourney_date<f$source_tourney_date&x$complete,,drop=FALSE]
 check(identical(paste(tr$match_id,collapse=';'),f$training_match_ids)&&nrow(tr)==f$training_n,'Exact whole-batch earlier training membership')
 check(!nrow(tr)||all(tr$source_tourney_date<f$source_tourney_date),'Strict cutoff without same-date contributions')
 if(f$ready) {
  # Independent formula-interface fit and prediction using only training SDs.
  sd0<-vapply(tr[sq_metrics],sd,0.0);z<-as.data.frame(sweep(as.matrix(tr[sq_metrics]),2,sd0,'/'));z$y<-tr$y
  ref<-glm(y~0+dM03+dM05+dM11+dM12,data=z,family=binomial(),control=glm.control(epsilon=1e-8,maxit=25))
  ii<-which(p$batch_key==f$batch_key&p$complete);new<-as.data.frame(sweep(as.matrix(p[ii,sq_metrics]),2,sd0,'/'))
  check(near(p$p_s08[ii],as.numeric(predict(ref,new,type='response'))),'Independent zero-intercept formula fit/prediction')
  check(near(as.numeric(f[paste0('sd_',sq_metrics)]),sd0),'Saved SDs from this training fold only')
  check(near(p$p_s08[ii]+as.numeric(predict(ref,-new,type='response')),rep(1,length(ii))),'Actual fold isolated-slot complementarity')
 }
}
for(ii in list(rev(seq_len(nrow(x))),order(x$event,decreasing=TRUE),order(x$batch_key,rev(seq_len(nrow(x)))))) {
 rr<-sq_walk(x[ii,]);check(identical(rr,sq_walk(x)),'Row/event/within-batch permutation invariance')
}
# Later features/outcomes cannot change an earlier fold; target outcomes cannot change their own prediction.
cut<-'20230703';bad<-x;later<-bad$tour=='ATP'&bad$source_tourney_date>cut;bad$y[later]<-1-bad$y[later];bad$dM03[later]<-bad$dM03[later]*10
rr<-sq_walk(bad)$p;ii<-p$tour=='ATP'&p$source_tourney_date<=cut
check(near(rr$p_s08[ii],p$p_s08[ii]),'Later outcomes/features do not affect earlier folds')
bad<-x;target<-bad$tour=='ATP'&bad$source_tourney_date==cut;bad$y[target]<-1-bad$y[target];rr<-sq_walk(bad)$p
check(near(rr$p_s08[target],p$p_s08[target]),'Target outcome isolation')
bad<-x;bad$y[bad$tour=='WTA']<-1-bad$y[bad$tour=='WTA'];rr<-sq_walk(bad)$p
check(near(rr$p_s08[p$tour=='ATP'],p$p_s08[p$tour=='ATP']),'ATP/WTA model separation')
bad<-x;early<-which(bad$tour=='ATP'&bad$source_tourney_date<cut&bad$complete)[1];bad$dM03[early]<-bad$dM03[early]+.1;rr<-sq_walk(bad)$p
check(any(abs(rr$p_s08[target]-p$p_s08[target])>1e-7,na.rm=TRUE),'Eligible earlier feature positive control')
bad<-x;bad[sq_metrics]<--bad[sq_metrics];bad$y<-1-bad$y;bad[c('player_a_id','player_b_id')]<-bad[c('player_b_id','player_a_id')];bad$p_a_primary<-1-bad$p_a_primary;bad$p_a_overall<-1-bad$p_a_overall
rr<-sq_score_rows(sq_walk(bad)$p)
check(identical(rr$paired,p$paired)&&near(rr$p_s08,1-p$p_s08),'Global relabeling complements predictions with same eligibility')
for(k in c('s08_logloss','s08_brier','primary_logloss','overall_brier'))check(near(rr[[k]],p[[k]]),'Global relabeling preserves losses')
for(model in c('s08','primary','overall')) {
 check(identical(which(!is.na(p[[paste0(model,'_logloss')]])),which(p$paired)),'All models share exact scored mask')
 z<-p[p$paired,];prob<-z[[switch(model,s08='p_s08',primary='p_a_primary',overall='p_a_overall')]]
 check(near(z[[paste0(model,'_logloss')]],-ifelse(z$y==1,log(prob),log1p(-prob))),'Independent loss check')
 check(near(z[[paste0(model,'_brier')]],(prob-z$y)^2),'Independent Brier check')
}
cal<-fits[fits$record_type=='CALIBRATION'&fits$level=='tour'&fits$stratum=='ALL',]
check(all(cal$status[cal$tour=='ATP']=='CALIBRATION_NOT_ASSESSABLE')&&all(cal$reasons[cal$tour=='ATP']=='INSUFFICIENT_BATCHES'),'ATP calibration blocked at four scored batches')
check(all(cal$status[cal$tour=='WTA']=='DESCRIPTIVE_ONLY'),'WTA calibration support gates pass')
for(model in c('s08','primary','overall')) {
 z<-p[p$tour=='WTA'&p$paired,];eta<-if(model=='s08')z$eta_s08 else qlogis(z[[paste0('p_a_',model)]])
 ref<-glm(z$y~eta,family=binomial(),control=glm.control(epsilon=1e-8,maxit=25));a<-cal[cal$tour=='WTA'&cal$model==model,]
 check(near(c(a$intercept,a$slope),coef(ref)),'Independent calibration intercept/slope')
}
z<-p[p$tour=='WTA'&p$paired,];z$p_a_primary[1]<-0
check(grepl('INVALID_OR_CONSTANT_LOGIT',sq_calibration(z,'primary')$reasons),'Calibration boundary not silently dropped')
z<-p[p$tour=='WTA'&p$paired,];z$eta_s08<-0;z$p_s08<-.5
check(grepl('INVALID_OR_CONSTANT_LOGIT',sq_calibration(z,'s08')$reasons),'Constant calibration logit blocked')
for(j in seq_len(nrow(st))) {
 a<-st[j,];z<-p[p$tour==a$tour&p$paired,];del<-if(a$deletion=='BATCH')z$batch_key==a$key else z$player_a_id==a$key|z$player_b_id==a$key
 field<-paste0('difference_',a$comparator,'_',a$metric)
 sq_need(sum(del)==a$deleted&&sum(!del)==a$retained,'Deletion accounting')
 sq_need(near(mean(z[[field]][!del]),a$deleted_difference),'Independent deletion calculation')
}
check(TRUE,'Every batch/player deletion independently recomputed in both slots')
check(any(st$sign_reversal,na.rm=TRUE),'Influential sign reversals retained')
check(all(sc$scored[sc$stratum %in% c('ONE_COMPLETE','NEITHER_COMPLETE')]==0),'Unavailable strata explicitly retained')
check(all(sc$targets[sc$level=='tour'&sc$stratum=='ALL'&sc$record_type=='SCORES'] %in% c(846,1734)),'No all-target denominator shrinkage')
check(!any(grepl('p.value|std.error|conf.low|conf.high',names(fits))),'No IID inference exported')
check(all(vapply(r,function(z)all(z$convention==sq_convention&z$verified_chronology_decision==sq_chronology&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),TRUE)),'Labels on every output row')
# Same-date multi-event fixture retains a single frozen fit.
bad<-x;ii<-bad$tour=='ATP'&bad$source_tourney_date==cut;bad$cell_id[ii]<-rep(c('fixtureA','fixtureB'),length.out=sum(ii));rr<-sq_walk(bad)$p
check(near(rr$p_s08[match(p$match_id,rr$match_id)],p$p_s08),'Same-date multiple events share a fit')
# Every aggregate uses its stated denominator; the same scored IDs feed all models.
for(j in which(sc$record_type=='SCORES')) {
 a<-sc[j,];ii<-p$tour==a$tour&p[[a$level]]==a$group&(a$stratum=='ALL'|p$s08_stratum==a$stratum)
 z<-p[ii,];zz<-z[z$paired,]
 sq_need(nrow(z)==a$targets&&nrow(zz)==a$scored&&sum(!is.finite(z$p_s08))==a$failed_targets,'Summary denominator mismatch')
 if(nrow(zz))sq_need(near(mean(zz[[paste0(a$model,'_logloss')]]),a$logloss),'Summary score mismatch')
}
check(TRUE,'Every summary denominator and log loss independently checked')
empty<-p;empty$paired<-FALSE;empty$p_s08<-NA_real_;empty$eta_s08<-NA_real_
st0<-sq_deletions(empty)
check(all(st0$status=='NO_RETAINED_SCORES')&&all(is.na(st0$deleted_difference)),'Zero scored cohort remains explicit')
z<-p[p$tour=='WTA'&p$paired,][1:99,]
check(grepl('INSUFFICIENT_MATCHES',sq_calibration(z,'s08')$reasons),'Calibration minimum sample gate')
z<-p[p$tour=='WTA'&p$paired,];z$y<-0
check(grepl('INSUFFICIENT_CLASSES',sq_calibration(z,'s08')$reasons),'Calibration class-balance gate')
check(all(st$retained+st$deleted==ifelse(st$tour=='ATP',211,1067)),'All deletion rows account for paired cohort')
for(k in names(r))check(!anyDuplicated(names(r[[k]])),paste('Unambiguous output schema',k))

# Existing historical bytes and exact tracked scope; no historical suite is executed.
base<-'72780222565a6fb9e0ea04fe9b5f33955a2ea2ff'
tracked<-system2('git',c('ls-tree','-r','--name-only',base),stdout=TRUE)
for(path in setdiff(tracked,sq_scope)) {
 old<-system2('git',c('rev-parse',shQuote(paste0(base,':',path))),stdout=TRUE)
 now<-system2('git',c('hash-object','--',shQuote(path)),stdout=TRUE)
 sq_need(identical(old,now),paste('Historical tracked file changed:',path))
}
check(TRUE,'All historical tracked blobs preserved outside authorized scope')
check(identical(before,vapply(prior,sq_hash,'')),'All prior pilot files preserved')
check(all(file.exists(sq_scope)),'Seven requested tracked files exist')
changed<-system2('git',c('diff',base,'--name-only'),stdout=TRUE);other<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
check(all(c(changed,other) %in% sq_scope),'No unintended tracked/untracked scope')
# Atomic installation: stage interruptions cannot create a visible partial release.
probe<-paste0(sq_dir,'-test-',Sys.getpid())
check(!dir.exists(probe),'Atomic fixture destination absent')
check(fails(sq_install(r,probe,function(stage)stop('simulated interruption')))&&!dir.exists(probe),'Interrupted stage leaves no release')
check(fails(sq_install(r,probe,function(stage)cat('corrupt',file=file.path(stage,'paired-scores.csv'),append=TRUE)))&&!dir.exists(probe),'Corrupted stage fails without release')
# Build twice; serialize both independently; compare every byte via hashes before final install.
r2<-sq_build(x);check(identical(r,r2),'Deterministic independent rebuild')
sq_install(r,probe);hash1<-vapply(file.path(probe,paste0(sq_outputs,'.csv')),sq_hash,'')
sq_install(r2,probe);hash2<-vapply(file.path(probe,paste0(sq_outputs,'.csv')),sq_hash,'');check(identical(hash1,hash2),'Byte-identical independent reruns')
bad<-r;bad[[1]]$training_n[1]<-999
check(fails(sq_install(bad,probe))&&identical(hash1,vapply(file.path(probe,paste0(sq_outputs,'.csv')),sq_hash,'')),'Existing release protected from replacement')
unlink(probe,recursive=TRUE);check(!dir.exists(probe),'Temporary test release cleaned')
sq_install(r);check(setequal(list.files(sq_dir),paste0(sq_outputs,'.csv')),'Exactly five installed outputs')
check(identical(unname(hash1),unname(vapply(file.path(sq_dir,paste0(sq_outputs,'.csv')),sq_hash,''))),'Installed files equal independently tested build')
check(identical(before,vapply(prior,sq_hash,'')),'Historical artifacts unchanged after installation')
cat(sprintf('Phase 2R: %d focused checks passed; all row-level deletion identities additionally checked.\n',checks))
