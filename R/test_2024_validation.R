# Phase 2AF: focused frozen-rule, integration, failure and selection checks.
source('R/run_2024_validation.R')
n<-0L
ok<-function(z,label){n<<-n+1L;if(!isTRUE(z))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),pattern)}
eq<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
e<-af_helpers();for(path in names(af_pins))ok(af_hash(path)==af_pins[[path]],paste('pin',path))
bad<-af_pins;bad[1]<-'bad';fail(af_verify(bad),'mismatch');fail(e$sq_ignored('R/not-ignored'),'already be ignored')
i<-af_load(e);w<-af_walk(i,e);r<-af_build(i,e);p<-r[['target-predictions']];folds<-r[['fold-readiness']];st<-r[['stability']]
ok(nrow(p)==1901&&!anyDuplicated(p$match_key)&&setequal(p$match_id,i$val$match_id),'1901 exact targets')
ok(nrow(folds)==40&&length(unique(folds$batch_key))==20&&!anyDuplicated(folds[c('model','batch_key')]),'20 required batches / 40 fits')
ok(sum(i$dev$complete)==2026&&all(table(i$dev$tour[i$dev$complete])==c(612,1414)),'all development complete rows retained')
ok(identical(p$p_a_primary,i$val$p_a_primary)&&identical(p$p_a_overall,i$val$p_a_overall),'frozen Elo equality without replay')
# Independent reconstruction of every training universe, fold scale and prediction.
for(j in seq_len(nrow(folds))){f<-folds[j,];dev<-i$dev[i$dev$tour==f$tour&i$dev$complete,];prior<-i$val[i$val$tour==f$tour&i$val$complete&i$val$source_tourney_date<f$source_tourney_date,];train<-rbind(dev[c('match_key','source_tourney_date','batch_key','y',e$sq_metrics)],prior[c('match_key','source_tourney_date','batch_key','y',e$sq_metrics)])
 ids<-strsplit(f$training_keys,';',fixed=TRUE)[[1]];ok(setequal(ids,train$match_key)&&!anyDuplicated(ids)&&all(train$source_tourney_date<f$source_tourney_date),'exact original features and training cutoff')
 metrics<-if(f$model=='full')e$sq_metrics else e$mw_metrics
 ok(eq(as.numeric(f[paste0('sd_',metrics)]),unname(vapply(train[metrics],sd,0.0))),'sample SD training only')
 mate<-folds[folds$batch_key==f$batch_key&folds$model!=f$model,];ok(identical(f$training_keys,mate$training_keys)&&identical(f$target_keys,mate$target_keys),'identical factor model IDs')
 z<-p[p$batch_key==f$batch_key&p$complete,];eta<-as.vector(sweep(as.matrix(z[metrics]),2,as.numeric(f[paste0('sd_',metrics)]),'/')%*%as.numeric(f[paste0('beta_',metrics)]))
 if(f$ready)ok(eq(eta,z[[paste0('eta_',f$model)]])&&eq(plogis(eta),z[[paste0('p_',f$model)]]),'zero-intercept forecast reconstruction')
}
# Registered gates: count -> finite SD -> rank -> collinearity -> fit, no rescue.
set.seed(172);fixture<-as.data.frame(matrix(rnorm(800),200,4));names(fixture)<-e$sq_metrics;fixture$y<-rep(0:1,100);fixture$batch_key<-rep(paste0('B',1:5),each=40)
for(model in c('full','reduced')){
 fn<-if(model=='full')e$sq_readiness else e$mw_readiness
 z<-fixture[1:10,];z$dM03<-0;f<-fn(z)$record;ok(f$count_gate=='FAIL'&&f$design_gate=='NOT_RUN'&&f$fit_gate=='NOT_RUN'&&grepl('INSUFFICIENT_MATCHES',f$reasons),'count precedence')
 z<-fixture;z$dM03<-0;f<-fn(z)$record;ok(f$design_gate=='FAIL'&&f$fit_gate=='NOT_RUN'&&f$reasons=='INVALID_OR_CONSTANT_PREDICTOR','constant gate')
 z<-fixture;z$dM03<-NA_real_;ok(fn(z)$record$reasons=='INVALID_OR_CONSTANT_PREDICTOR','nonfinite predictor')
 z<-fixture;z$dM11<-z$dM03;f<-fn(z)$record;ok(f$reasons=='RANK_FAILURE'&&f$fit_gate=='NOT_RUN','rank precedence')
 z<-fixture;z$dM11<-z$dM03+rnorm(200,sd=.01);f<-fn(z)$record;ok(grepl('NEAR_REDUNDANCY',f$reasons)&&f$fit_gate=='NOT_RUN','collinearity gate')
 z<-fixture;z$y<-as.integer(z$dM03>0);f<-fn(z)$record;ok(!f$ready&&f$fit_gate=='FAIL','separation/extreme safeguard')
 f<-fn(fixture);ok(f$record$ready&&f$record$rank==if(model=='full')4 else 3,'correct rank ready fixture')
 metrics<-if(model=='full')e$sq_metrics else e$mw_metrics;eta<-e$sq_eta(fixture[metrics],f$fit,f$sd);ok(max(abs(plogis(eta)+plogis(-eta)-1))<1e-14,'slot complement fixture')
}
ff<-list(converged=FALSE,rank=2,coefficients=c(NA,1),linear.predictors=c(0,1),fitted.values=c(.5,.75),boundary=TRUE)
d<-e$sq_fit_diagnostics(ff,c(0,1),'fixture warning',4);ok(all(c('NONCONVERGENCE','FITTED_RANK_FAILURE','FITTING_WARNING','NONFINITE_FIT','BOUNDARY_FIT') %in% d$reasons),'all fit reasons retained')
# Inject failure at the existing model seam; do not let it select a different comparison cohort.
blocked<-function(train){z<-e$sq_readiness(train);z$record$ready<-FALSE;z$record$reasons<-'FITTING_WARNING';z$record$fit_gate<-'FAIL';z}
bw<-af_walk(i,e,fit_full=blocked);ok(all(!bw$p$paired)&&all(is.na(bw$p$p_full))&&sum(is.finite(bw$p$p_reduced))==1783,'failed full preserves reduced availability but no pairs')
bs<-af_score(bw$p,e);bd<-af_selection(bs,bw$folds,af_deletions(bs,e),e);ok(all(bd$decision=='SELECTION_UNRESOLVED'),'failed required gate abstention')
set.seed(9);ii<-i;ii$dev<-i$dev[sample(nrow(i$dev)),];ii$val<-i$val[sample(nrow(i$val)),];wp<-af_walk(ii,e);ok(identical(w,wp),'row/event/within-batch permutation invariance')
for(batch in unique(i$val$batch_key)){
 ii<-i;j<-which(ii$val$batch_key==batch);ii$val$y[j]<-1-ii$val$y[j];wp<-af_walk(ii,e)
 keep<-w$p$tour!=i$val$tour[j[1]]|w$p$source_tourney_date<=i$val$source_tourney_date[j[1]]
 cols<-c('match_key','p_full','p_reduced','eta_full','eta_reduced','full_ready','reduced_ready')
 ok(identical(w$p[keep,cols],wp$p[keep,cols]),paste('current/later outcome invariant',batch))
}
ii<-i;ii$dev$y<-1-ii$dev$y;wp<-af_walk(ii,e);ok(any(abs(wp$p$p_full-w$p$p_full)>1e-6,na.rm=TRUE),'eligible earlier outcome positive control')
# Synthetic same-date two-event grouping retains one fit and cannot leak either event's outcomes.
ii<-i;dates<-sort(unique(ii$val$source_tourney_date[ii$val$tour=='ATP']));j<-which(ii$val$tour=='ATP'&ii$val$source_tourney_date==dates[2]);ii$val$source_tourney_date[j]<-dates[1];ii$val$batch_key[j]<-paste('ATP',dates[1],sep='|')
a<-af_walk(ii,e);jj<-ii$val$batch_key==paste('ATP',dates[1],sep='|');ii$val$y[j]<-1-ii$val$y[j];b<-af_walk(ii,e);keep<-a$p$batch_key==paste('ATP',dates[1],sep='|')
ok(identical(a$p[keep,c('p_full','p_reduced')],b$p[keep,c('p_full','p_reduced')])&&sum(a$folds$batch_key==paste('ATP',dates[1],sep='|'))==2,'same-date events freeze together')
ii<-i
for(cohort in c('dev','val')){z<-ii[[cohort]];z[e$sq_metrics]<--z[e$sq_metrics];z$y<-1-z$y;tmp<-z$player_a_id;z$player_a_id<-z$player_b_id;z$player_b_id<-tmp;z$p_a_primary<-1-z$p_a_primary;z$p_a_overall<-1-z$p_a_overall;ii[[cohort]]<-z}
wp<-af_walk(ii,e);ok(eq(wp$p$p_full,1-w$p$p_full)&&eq(wp$p$p_reduced,1-w$p$p_reduced),'global relabeling complements')
mask<-p$complete&p$full_ready&p$reduced_ready&is.finite(p$p_full)&is.finite(p$p_reduced)&is.finite(p$p_a_primary)&is.finite(p$p_a_overall)
ok(identical(p$paired,mask)&&sum(mask)==1783,'one common mask all four methods')
for(model in af_models){ok(all(is.na(p[[paste0(model,'_logloss')]][!mask]))&&all(is.finite(p[[paste0(model,'_logloss')]][mask])),'identical score IDs');prob<-p[[switch(model,primary='p_a_primary',overall='p_a_overall',paste0('p_',model))]][mask];y<-p$y[mask];ok(eq(p[[paste0(model,'_logloss')]][mask],-ifelse(y==1,log(prob),log1p(-prob)))&&eq(p[[paste0(model,'_brier')]][mask],(prob-y)^2),'independent losses')}
ok(identical(e$sq_loss(c(-1000,1000),c(1,0)),c(1000,1000))&&all(is.finite(e$sq_loss(c(-1000,1000),c(0,1)))),'stable extreme logit losses')
ok(identical(e$sq_accuracy(c(.5,.5,.6,.4),c(1,0,1,0)),c(.5,.5,1,1)),'accuracy half-credit ties')
# Calibration gates and every exported diagnostic reproduce the frozen function.
z<-p[p$tour=='ATP'&p$paired,];z$eta_s08<-z$eta_full;z$p_s08<-z$p_full
ok(e$sq_calibration(z[1:99,],'s08')$status=='CALIBRATION_NOT_ASSESSABLE','calibration minimum sample')
v<-z;v$batch_key<-'one';ok(grepl('INSUFFICIENT_BATCHES',e$sq_calibration(v,'s08')$reasons),'calibration batches')
v<-z;v$y<-0;ok(grepl('INSUFFICIENT_CLASSES',e$sq_calibration(v,'s08')$reasons),'calibration classes')
v<-z;v$p_s08[1]<-0;ok(grepl('INVALID_OR_CONSTANT_LOGIT',e$sq_calibration(v,'s08')$reasons),'calibration boundary')
v<-z;v$eta_s08<-0;ok(grepl('INVALID_OR_CONSTANT_LOGIT',e$sq_calibration(v,'s08')$reasons),'calibration constant')
# Every score deletion independently removes the batch or the player from either slot.
for(j in seq_len(nrow(st))){q<-st[j,];z<-p[p$tour==q$tour&p$paired,];remove<-if(q$deletion=='BATCH')z$batch_key==q$key else z$player_a_id==q$key|z$player_b_id==q$key;field<-paste0('difference_',q$comparison,'_',q$metric);value<-mean(z[[field]][!remove]);ok(sum(remove)==q$deleted&&sum(!remove)==q$retained&&eq(value,q$deleted_difference)&&identical(q$sign_reversal,mean(z[[field]])*value<0),'exact frozen deletion')}
# Exhaustive sign truth table: no tolerance, no player/calibration tie-breaker.
grid<-expand.grid(a=c(-1,0,1),b=c(-1,0,1),c=c(-1,0,1),d=c(-1,0,1),gate=c(FALSE,TRUE),deletion=c('same','tie','reverse','missing'),stringsAsFactors=FALSE)
for(j in seq_len(nrow(grid))){z<-grid[j,];d<-as.numeric(z[1:4]);bv<-switch(z$deletion,same=d,tie=rep(0,4),reverse=-d,missing=rep(NA_real_,4));want<-'SELECTION_UNRESOLVED';if(z$gate&&z$deletion!='missing'){if(all(d>0)&&all(bv>=0))want<-'FULL_S08_PREFERRED_FROZEN_2025_FORECASTING_CANDIDATE';if(all(d<0)&&all(bv<=0))want<-'REDUCED_PREFERRED_FROZEN_2025_FORECASTING_CANDIDATE'};ok(af_decide(d,z$gate,bv)==want,'selection truth table')}
for(d in list(c(1,1,NA,1),c(1,1,Inf,1),c(1,1,1),numeric()))ok(af_decide(d,TRUE,rep(1,4))=='SELECTION_UNRESOLVED','missing/nonfinite comparison')
ok(af_decide(rep(1,4),TRUE,numeric())=='SELECTION_UNRESOLVED'&&af_decide(rep(1,4),TRUE,rep(1,4),FALSE)=='SELECTION_UNRESOLVED','empty/absent batch comparison')
q<-p;q$p_full[which(q$complete)[1]]<-Inf;ok(all(af_selection(q,folds,st,e)$decision=='SELECTION_UNRESOLVED'),'nonfinite prediction cannot escape mask')
# Independent process rerun plus atomic install, interrupted/corrupted stages and refusal to overwrite.
tmp<-tempfile('af-test-');dir.create(tmp);orig<-e$sq_ignored;e$sq_ignored<-function(dir)NULL
fail(e$sq_install(r,file.path(tmp,'interrupted'),function(stage)stop('interrupted')),'interrupted');ok(!dir.exists(file.path(tmp,'interrupted')),'no partial installation')
fail(e$sq_install(r,file.path(tmp,'corrupt'),function(stage)cat('x',file=file.path(stage,'stability.csv'),append=TRUE)),'Staged bytes changed')
e$sq_install(r,file.path(tmp,'release'));files<-file.path(tmp,'release',paste0(af_outputs,'.csv'));hashes<-vapply(files,af_hash,'');e$sq_install(r,file.path(tmp,'release'));ok(identical(hashes,vapply(files,af_hash,'')),'identical install retained')
q<-r;q[[2]]$p_full[1]<-.1;fail(e$sq_install(q,file.path(tmp,'release')),'Existing release differs');ok(identical(hashes,vapply(files,af_hash,'')),'existing release preserved');e$sq_ignored<-orig
script<-file.path(tmp,'rerun.R');writeLines(c("source('R/run_2024_validation.R')","r<-run_2024_validation(FALSE)",sprintf("for(j in seq_along(r))write.table(r[[j]],file.path(%s,paste0(names(r)[j],'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\\n',qmethod='double')",deparse(tmp))),script)
ok(system2(file.path(R.home('bin'),'Rscript'),shQuote(script))==0,'independent process')
ok(identical(unname(hashes),unname(vapply(file.path(tmp,paste0(af_outputs,'.csv')),af_hash,''))),'six independent byte-identical files')
af_verify();ok(TRUE,'historical input/protocol hashes preserved');unlink(tmp,recursive=TRUE)
cat(n,'Phase 2AF checks passed\n')
