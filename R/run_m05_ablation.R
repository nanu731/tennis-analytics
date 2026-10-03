# Phase 2W: one reduced-model ablation; frozen full S08 is never refitted.
mw_version <- '1.0.0'
mw_metrics <- c('dM03','dM11','dM12')
mw_convention <- 'SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY'
mw_chronology <- 'NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE'
mw_dir <- 'data/pilot/m05-ablation'
mw_outputs <- c('fold-readiness','model-fits','target-predictions','paired-scores','stability')
# Numerical helpers retain Phase 2R behavior; readiness changes dimension only.
mw_need <- function(ok,why) if(!isTRUE(ok)) stop(why,call.=FALSE)
mw_hash <- function(p) if(!file.exists(p)) 'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
mw_read <- function(p) read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
mw_sort <- function(x,fields) { x<-x[do.call(order,c(unname(x[fields]),list(method='radix'))),,drop=FALSE];rownames(x)<-NULL;x }
mw_bind <- function(rows) {
 fields<-unique(unlist(lapply(rows,names)));rows<-lapply(rows,function(r){for(k in setdiff(fields,names(r)))r[[k]]<-NA;r[fields]})
 out<-do.call(rbind,lapply(rows,as.data.frame,stringsAsFactors=FALSE));rownames(out)<-NULL;out
}
mw_join <- function(x,y,fields) {
 mw_need(!anyDuplicated(y$match_id)&&setequal(x$match_id,y$match_id),'Input universe/duplicate mismatch')
 y<-y[match(x$match_id,y$match_id),,drop=FALSE]
 for(k in fields)mw_need(identical(x[[k]],y[[k]]),paste('Input join mismatch:',k));y
}
mw_verify <- function(pins=mw_pins) mw_need(all(vapply(names(pins),mw_hash,'')==pins),'Missing or changed frozen input/authority')
mw_ignored <- function(dir=mw_dir) {
 paths<-file.path(dir,paste0(mw_outputs,'.csv'))
 got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
 mw_need(setequal(got,paths),'Output location must already be ignored')
}
mw_fit_diagnostics <- function(fit,y,warnings=character(),expected_rank) {
 reasons<-character()
 if(!isTRUE(fit$converged))reasons<-c(reasons,'NONCONVERGENCE')
 if(fit$rank!=expected_rank)reasons<-c(reasons,'FITTED_RANK_FAILURE')
 if(length(warnings))reasons<-c(reasons,'FITTING_WARNING')
 finite<-all(is.finite(c(fit$coefficients,fit$linear.predictors,fit$fitted.values)))
 if(!finite)reasons<-c(reasons,'NONFINITE_FIT')
 if(isTRUE(fit$boundary))reasons<-c(reasons,'BOUNDARY_FIT')
 extreme<-if(finite)sum(fit$fitted.values<=1e-8|fit$fitted.values>=1-1e-8) else NA_integer_
 if(!is.na(extreme)&&extreme>0)reasons<-c(reasons,'EXTREME_TRAINING_PROBABILITY')
 margins<-(2*y-1)*fit$linear.predictors
 witness<-if(finite) all(margins>=-1e-8)&&any(margins>1e-8) else NA
 if(isTRUE(witness))reasons<-c(reasons,'SEPARATION_INDICATION')
 list(reasons=reasons,converged=isTRUE(fit$converged),boundary=isTRUE(fit$boundary),extreme=extreme,witness=witness,warnings=paste(warnings,collapse=';'))
}
mw_glm <- function(X,y) {
 warnings<-character()
 fit<-tryCatch(withCallingHandlers(glm.fit(X,y,family=binomial(),intercept=FALSE,
  control=glm.control(epsilon=1e-8,maxit=25)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=identity)
 if(inherits(fit,'error'))return(list(fit=NULL,diag=list(reasons='FIT_ERROR',converged=FALSE,boundary=NA,extreme=NA,witness=NA,warnings=conditionMessage(fit))))
 list(fit=fit,diag=mw_fit_diagnostics(fit,y,warnings,ncol(X)))
}
mw_collinearity <- function(X) {
 # Registered centered diagnostics are separate from the uncentered forecast design.
 Z<-scale(X,center=TRUE,scale=TRUE)
 pearson<-max(abs(cor(X)[upper.tri(cor(X))]));sp<-cor(X,method='spearman');spearman<-max(abs(sp[upper.tri(sp)]))
 vif<-vapply(seq_len(ncol(X)),function(j){r<-lm.fit(cbind(1,Z[,-j,drop=FALSE]),Z[,j]);sum(Z[,j]^2)/sum(r$residuals^2)},0.0)
 ss<-svd(Z,nu=0,nv=0)$d
 list(pearson=pearson,spearman=spearman,vif=max(vif),condition=max(ss)/min(ss))
}
mw_readiness <- function(train) {
 X<-as.matrix(train[mw_metrics]);y<-train$y;n<-nrow(train)
 r<-list(training_n=n,training_batches=length(unique(train$batch_key)),class_0=sum(y==0),class_1=sum(y==1),
  count_gate='PASS',design_gate='NOT_RUN',fit_gate='NOT_RUN',rank=NA_integer_,pearson=NA_real_,spearman=NA_real_,vif=NA_real_,condition=NA_real_,
  converged=NA,boundary=NA,extreme=NA_integer_,witness=NA,warnings='',correlation_warning='',separation_status='NOT_RUN')
 for(k in mw_metrics){r[[paste0('sd_',k)]]<-NA_real_;r[[paste0('beta_',k)]]<-NA_real_}
 reasons<-character();fit<-NULL;scales<-rep(NA_real_,3)
 if(r$training_batches<5)reasons<-c(reasons,'INSUFFICIENT_BATCHES')
 if(n<100)reasons<-c(reasons,'INSUFFICIENT_MATCHES')
 if(r$class_0<25||r$class_1<25)reasons<-c(reasons,'INSUFFICIENT_CLASSES')
 if(length(reasons))r$count_gate<-'FAIL' else {
  scales<-apply(X,2,sd)
  for(k in mw_metrics)r[[paste0('sd_',k)]]<-scales[k]
  if(!all(is.finite(X))||!all(is.finite(scales)&scales>0))reasons<-c(reasons,'INVALID_OR_CONSTANT_PREDICTOR') else {
   Z<-sweep(X,2,scales,'/');r$rank<-qr(Z,tol=1e-7)$rank
   if(r$rank!=3)reasons<-c(reasons,'RANK_FAILURE')
   if(!length(reasons)) {
    col<-tryCatch(mw_collinearity(X),error=identity)
    if(inherits(col,'error')||!all(is.finite(unlist(col))))reasons<-c(reasons,'COLLINEARITY_DIAGNOSTIC_FAILURE') else {
     r[names(col)]<-col
     mc<-max(r$pearson,r$spearman)
     r$correlation_warning<-if(mc>=.9)'SENSITIVITY_WARNING' else if(mc>=.8)'PRACTICAL_REVIEW' else 'NONE'
     if(mc>=.95)reasons<-c(reasons,'NEAR_REDUNDANCY')
     if(r$vif>=5)reasons<-c(reasons,if(r$vif>=10)'VIF_UNACCEPTABLE' else 'VIF_CONCERN')
     if(r$condition>=30)reasons<-c(reasons,'CONDITION_FAILURE')
    }
   }
   if(!length(reasons)) {
    fitted<-mw_glm(Z,y);fit<-fitted$fit;dd<-fitted$diag
    r[c('converged','boundary','extreme','witness','warnings')]<-dd[c('converged','boundary','extreme','witness','warnings')]
    reasons<-c(reasons,dd$reasons);r$fit_gate<-if(length(reasons))'FAIL' else 'PASS'
    r$separation_status<-if(isTRUE(dd$witness))'SEPARATION_INDICATION' else if(is.na(dd$witness))'UNRESOLVED' else 'NO_SEPARATION_DETECTED_BY_REGISTERED_DIAGNOSTICS'
    if(!is.null(fit))for(k in mw_metrics)r[[paste0('beta_',k)]]<-fit$coefficients[k]
   }
  }
  r$design_gate<-if(r$fit_gate!='NOT_RUN')'PASS' else 'FAIL'
 }
 r$ready<-length(reasons)==0;r$reasons<-if(r$ready)'PASS' else paste(reasons,collapse=';')
 list(record=r,fit=fit,sd=scales)
}
mw_eta <- function(X,fit,scales) as.vector(sweep(as.matrix(X),2,scales,'/')%*%fit$coefficients)
mw_loss <- function(eta,y) pmax(eta,0)-y*eta+log1p(exp(-abs(eta)))
mw_probability_loss <- function(p,y) {r<-numeric(length(p));r[y==1]<--log(p[y==1]);r[y==0]<--log1p(-p[y==0]);r}
mw_groups <- function(p) {
 out<-list()
 for(tour in sort(unique(p$tour),method='radix'))for(level in c('tour','season','batch_key','event','surface')) {
  values<-sort(unique(p[[level]][p$tour==tour]),method='radix')
  for(value in values)for(stratum in c('ALL','BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')) {
   ii<-which(p$tour==tour&p[[level]]==value&(stratum=='ALL'|p$s08_stratum==stratum))
   out[[length(out)+1L]]<-list(tour=tour,level=level,group=value,stratum=stratum,ii=ii)
  }
 }
 out
}
mw_install <- function(r,dir=mw_dir,before_install=function(stage)NULL) {
 mw_ignored(dir);mw_verify();mw_need(identical(names(r),mw_outputs),'Output scope mismatch')
 stage<-tempfile('.m05-ablation-stage-',tmpdir=dirname(dir));mw_need(dir.create(stage),'Cannot stage output')
 on.exit(unlink(stage,recursive=TRUE),add=TRUE)
 for(k in names(r))write.table(r[[k]],file.path(stage,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
 paths<-file.path(stage,paste0(mw_outputs,'.csv'));hashes<-vapply(paths,mw_hash,'');before_install(stage)
 mw_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0),'Incomplete staging')
 mw_need(identical(vapply(paths,mw_hash,''),hashes),'Staged bytes changed');mw_verify()
 if(dir.exists(dir)) {
  mw_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing output scope differs')
  mw_need(identical(unname(vapply(file.path(dir,basename(paths)),mw_hash,'')),unname(hashes)),'Existing release differs; preserve it')
 } else mw_need(file.rename(stage,dir),'Atomic output installation failed')
 invisible(r)
}
mw_num <- function(x){x[x %in% c('NA','')]<-NA_character_;v<-suppressWarnings(as.numeric(x));mw_need(all(is.na(x)|!is.na(v)),'Invalid numeric input');v}
mw_near <- function(a,b) isTRUE(all.equal(a,b,tolerance=1e-10,check.attributes=FALSE))
mw_load <- function() {
 mw_ignored();mw_verify() # All pins before reading any outcomes or fitting.
 list(p=mw_read('data/pilot/s08-paired-evaluation/target-predictions.csv'),
 f=mw_read('data/pilot/s08-paired-evaluation/fold-readiness.csv'),
 features=mw_read('data/pilot/s08-batched-histories/target-s08-features.csv'),
 batches=mw_read('data/pilot/event-batch-membership/target-batches.csv'),
 membership=mw_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'))
}
mw_prepare <- function(p,f,features,batches,membership) {
 p<-mw_sort(p,c('tour','source_tourney_date','cell_id','match_id'))
 mw_need(nrow(p)==2580&&!anyDuplicated(p$match_id),'Frozen 2580-target universe')
 fields<-c('tour','season','cell_id','event','surface','round','batch_key','source_tourney_date','player_a_id','player_b_id')
 features<-mw_join(p,features,fields);batches<-mw_join(p,batches,fields)
 membership<-mw_join(p,membership,c('cell_id','event','surface','round','player_a_id','player_b_id'))
 mw_need(all(p$season %in% c('2021','2023'))&&all(p$batch_key==paste(p$tour,p$source_tourney_date,sep='|')),'Scope/batch labels')
 mw_need(all(p$convention==mw_convention&p$verified_chronology_decision==mw_chronology),'Sensitivity labels')
 mw_need(all(as.integer(p$y)==as.integer(membership$a_original_side=='winner')),'Outcome ownership')
 mw_need(all(membership$a_original_side %in% c('winner','loser')),'Invalid outcome side')
 for(k in mw_metrics)mw_need(mw_near(mw_num(p[[k]]),mw_num(features[[k]])),'Frozen reduced feature mismatch')
 mw_need(all((p$complete=='TRUE')==(features$all_s08_differences_defined=='TRUE')),'Frozen completeness mismatch')
 mw_need(nrow(f)==30&&!anyDuplicated(f$batch_key)&&setequal(f$batch_key,p$batch_key),'Frozen fold universe')
 f<-mw_sort(f,c('tour','source_tourney_date'));f$attempted<-f$ready=='TRUE'
 mw_need(sum(f$attempted)==18&&sum(f$attempted&f$tour=='ATP')==4,'Exact attempted folds')
 # Discard M05 values entirely; original complete/paired flags define the cohort.
 keep<-c('match_id',fields,mw_metrics,'complete','s08_stratum','y','p_s08','eta_s08','paired','fold_ready','fold_reasons','prediction_reason')
 p<-p[keep];p$full_probability_text<-p$p_s08
 for(k in c(mw_metrics,'y','p_s08','eta_s08'))p[[k]]<-mw_num(p[[k]])
 names(p)[names(p)=='p_s08']<-'p_full';names(p)[names(p)=='eta_s08']<-'eta_full'
 names(p)[names(p)=='paired']<-'full_paired';names(p)[names(p)=='fold_ready']<-'full_ready'
 names(p)[names(p)=='fold_reasons']<-'full_fold_reasons';names(p)[names(p)=='prediction_reason']<-'full_prediction_reason'
 for(k in c('complete','full_paired','full_ready'))p[[k]]<-p[[k]]=='TRUE'
 mw_need(sum(p$full_paired)==1278&&sum(p$full_paired&p$tour=='ATP')==211,'Frozen scored IDs')
 mw_need(all(p$y %in% c(0,1))&&all(is.finite(as.matrix(p[p$complete,mw_metrics]))),'Frozen complete values')
 mw_need(identical(p$full_ready,f$attempted[match(p$batch_key,f$batch_key)]),'Attempted target mapping')
 mw_need(identical(p$full_fold_reasons,f$reasons[match(p$batch_key,f$batch_key)]),'Frozen reasons mismatch')
 mw_need(all(p$full_paired==(p$complete&p$full_ready))&&all(is.finite(p$p_full)==p$full_paired),'Frozen target mask')
 mw_need(all(p$p_full[p$full_paired]>0&p$p_full[p$full_paired]<1)&&mw_near(p$p_full[p$full_paired],plogis(p$eta_full[p$full_paired])),'Frozen full probabilities')
 for(j in seq_len(nrow(f))){
  ids<-if(f$training_match_ids[j]=='')character() else strsplit(f$training_match_ids[j],';',fixed=TRUE)[[1]]
  expected<-p$match_id[p$tour==f$tour[j]&p$source_tourney_date<f$source_tourney_date[j]&p$complete]
  mw_need(identical(ids,expected)&&length(ids)==as.integer(f$training_n[j]),'Exact training membership/cutoff')
  ii<-p$batch_key==f$batch_key[j]
  mw_need(sum(ii)==as.integer(f$targets[j])&&sum(p$full_paired[ii])==as.integer(f$predictions[j]),'Exact target membership')
 }
 list(p=p,f=f)
}
mw_walk <- function(i,fit_function=mw_readiness) {
 p<-mw_sort(i$p,c('tour','source_tourney_date','cell_id','match_id'));frozen<-mw_sort(i$f,c('tour','source_tourney_date'))
 p$eta_reduced<-p$p_reduced<-NA_real_;p$reduced_ready<-FALSE;p$comparison_reason<-p$full_prediction_reason
 folds<-list();fits<-list()
 for(j in seq_len(nrow(frozen))){
  ff<-frozen[j,];ids<-if(ff$training_match_ids=='')character() else strsplit(ff$training_match_ids,';',fixed=TRUE)[[1]]
  tr<-p[match(ids,p$match_id),,drop=FALSE];target<-which(p$batch_key==ff$batch_key);eligible<-target[p$full_paired[target]]
  mw_need(!anyNA(tr$match_id)&&!anyDuplicated(ids)&&all(tr$tour==ff$tour&tr$source_tourney_date<ff$source_tourney_date)&all(tr$complete),'Training linkage/cutoff')
  meta<-as.list(ff[c('tour','batch_key','source_tourney_date','season','event','surface','training_match_ids','training_max_label')])
  if(ff$attempted){
   fit<-fit_function(tr);r<-fit$record
   for(k in mw_metrics)mw_need(mw_near(r[[paste0('sd_',k)]],mw_num(ff[[paste0('sd_',k)]]))||r$count_gate=='FAIL'||r$design_gate=='FAIL','Frozen training SD agreement')
   if(r$ready){
    eta<-mw_eta(p[eligible,mw_metrics],fit$fit,fit$sd);prob<-plogis(eta);ok<-is.finite(eta)&is.finite(prob)
    p$eta_reduced[eligible[ok]]<-eta[ok];p$p_reduced[eligible[ok]]<-prob[ok];p$reduced_ready[target]<-TRUE
    p$comparison_reason[eligible]<-ifelse(ok,'PAIRED','NONFINITE_TARGET_PREDICTION')
   } else p$comparison_reason[eligible]<-paste0('REDUCED_FOLD_FAILED:',r$reasons)
  } else {
   r<-as.list(ff[c('training_n','training_batches','class_0','class_1','count_gate','design_gate','fit_gate','ready','reasons')])
   for(k in c('training_n','training_batches','class_0','class_1'))r[[k]]<-as.integer(r[[k]])
   r$ready<-FALSE # Copy original reasons and gates; never run readiness or fit.
  }
  r<-c(meta,list(attempted=ff$attempted,full_reasons=ff$reasons,full_scored=length(eligible),targets=length(target)),r)
  r$predictions<-sum(is.finite(p$p_reduced[target]));folds[[j]]<-r
  if(ff$attempted)fits[[length(fits)+1L]]<-c(list(model='M03_M11_M12',intercept=0),r[setdiff(names(r),'training_match_ids')])
 }
 p$paired<-p$full_paired&p$reduced_ready&is.finite(p$p_reduced)&is.finite(p$p_full)
 list(p=p,folds=mw_bind(folds),fits=mw_bind(fits))
}
mw_score <- function(p){
 for(model in c('reduced','full')){
  p[[paste0(model,'_logloss')]]<-p[[paste0(model,'_brier')]]<-NA_real_;ii<-which(p$paired)
  p[[paste0(model,'_logloss')]][ii]<-mw_loss(p[[paste0('eta_',model)]][ii],p$y[ii])
  p[[paste0(model,'_brier')]][ii]<-(p[[paste0('p_',model)]][ii]-p$y[ii])^2
 }
 for(metric in c('logloss','brier'))p[[paste0('difference_',metric)]]<-p[[paste0('reduced_',metric)]]-p[[paste0('full_',metric)]]
 p
}
mw_classify <- function(differences,complete_tours){
 if(length(differences)!=4||length(complete_tours)!=2||!all(complete_tours)||any(!is.finite(differences)))return('M05_ABLATION_MIXED')
 if(all(differences>0))return('M05_FULL_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS')
 if(all(differences<0))return('M05_REDUCED_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS')
 'M05_ABLATION_MIXED'
}
mw_summarize <- function(p){
 rows<-list();reasons<-sort(unique(p$comparison_reason[p$comparison_reason!='PAIRED']),method='radix')
 for(g in mw_groups(p)){
  z<-p[g$ii,,drop=FALSE];sc<-z[z$paired,,drop=FALSE];meta<-g[setdiff(names(g),'ii')]
  r<-c(list(record_type='SCORES',reason='ALL'),meta,list(targets=nrow(z),full_scored=sum(z$full_paired),paired=nrow(sc),
   no_comparison=nrow(z)-nrow(sc),reduced_failures=sum(z$full_paired&!z$paired),batches=length(unique(z$batch_key)),paired_batches=length(unique(sc$batch_key)),
   comparison_status=if(!nrow(sc))'NO_PAIRED_ROWS' else if(nrow(sc)!=sum(z$full_paired))'PARTIAL_PAIRED_ROWS' else 'COMPLETE_FROZEN_SCORED_COHORT'))
  for(metric in c('logloss','brier'))for(model in c('reduced','full','difference'))r[[paste0(model,'_',metric)]]<-if(nrow(sc))mean(sc[[paste0(model,'_',metric)]]) else NA_real_
  rows[[length(rows)+1L]]<-r
  for(reason in reasons)rows[[length(rows)+1L]]<-c(list(record_type='FAILURE',reason=reason,reason_count=sum(z$comparison_reason==reason)),meta,list(targets=nrow(z),full_scored=sum(z$full_paired),paired=nrow(sc)))
 }
 out<-mw_bind(rows);t<-out[out$record_type=='SCORES'&out$level=='tour'&out$stratum=='ALL',]
 decision<-mw_classify(as.numeric(as.matrix(t[c('difference_logloss','difference_brier')])),t$comparison_status=='COMPLETE_FROZEN_SCORED_COHORT')
 list(scores=out,decision=decision)
}
mw_deletions <- function(p){
 rows<-list()
 for(tour in c('ATP','WTA')){
  z<-p[p$tour==tour&p$paired,,drop=FALSE]
  for(kind in c('BATCH','PLAYER')){
   keys<-if(kind=='BATCH')sort(unique(z$batch_key),method='radix') else sort(unique(c(z$player_a_id,z$player_b_id)),method='radix')
   if(!length(keys))keys<-'NO_SCORED_ROWS'
   for(key in keys){
    del<-if(kind=='BATCH')z$batch_key==key else z$player_a_id==key|z$player_b_id==key;keep<-z[!del,,drop=FALSE]
    for(metric in c('logloss','brier')){
     field<-paste0('difference_',metric);base<-if(nrow(z))mean(z[[field]]) else NA_real_;value<-if(nrow(keep))mean(keep[[field]]) else NA_real_
     rows[[length(rows)+1L]]<-list(tour=tour,deletion=kind,key=key,metric=metric,deleted=sum(del),retained=nrow(keep),retained_batches=length(unique(keep$batch_key)),
      base_difference=base,deleted_difference=value,change=value-base,sign_reversal=if(is.finite(base)&&is.finite(value))base*value<0 else NA,
      status=if(nrow(keep))'CONDITIONAL_SCORE_INFLUENCE' else 'NO_RETAINED_SCORES')
    }
   }
  }
 }
 mw_bind(rows)
}
mw_build <- function(i,fit_function=mw_readiness){
 w<-mw_walk(i,fit_function);p<-mw_score(w$p);s<-mw_summarize(p)
 out<-setNames(list(w$folds,w$fits,p,s$scores,mw_deletions(p)),mw_outputs)
 for(k in names(out)){out[[k]]$version<-mw_version;out[[k]]$convention<-mw_convention;out[[k]]$verified_chronology_decision<-mw_chronology;out[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';out[[k]]$classification<-s$decision}
 out
}
run_m05_ablation <- function(write_outputs=TRUE){i<-do.call(mw_prepare,mw_load());r<-mw_build(i);if(write_outputs)mw_install(r);r}

mw_pins <- c(
`AGENTS.override.md`='7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b',
`R/run_s08_paired_evaluation.R`='14cb2e7daf66a7190735bc96d13768fa059c9954dbbf316d2ed284719cd50d5e',
`docs/s08-forecast-evaluation-protocol.md`='0cb6c8ebf5bb7c2028817fa4f6f8052f35eaa761ee9fdf63c45790cc0f4b99de',
`docs/s08-paired-evaluation-results.md`='e5f0caab97d1338cbf88b6912213d5c72b2372208f340e3d5375faa7b2954b94',
`docs/m05-role-clarification-decision.md`='c162ddfd5be5f69634711f604d49fd1a10235a6a814da1a0553a5305b7c81496',
`data/pilot/s08-paired-evaluation/fold-readiness.csv`='b419e1883269201a70fa78bd0aa398d56b0a18456147f587780edf719f280ed9',
`data/pilot/s08-paired-evaluation/model-fits.csv`='46300fa049333fb36d0eec96ec6d51669f9f6e8742e36be0fe231cd94cfc9726',
`data/pilot/s08-paired-evaluation/paired-scores.csv`='c2d419f8cfadd1a91da5bc4380b7d29d55af1fae1ea1b04f8da2846431790b4e',
`data/pilot/s08-paired-evaluation/stability.csv`='08176292218802df34225159fabe984ac0abbbacf7909aa5b928a882570519ad',
`data/pilot/s08-paired-evaluation/target-predictions.csv`='d7d7b774c1ce7c4f303820208fbed196f38fe058b0d1ad763c02e0f6880ea433',
`data/pilot/s08-batched-histories/target-s08-features.csv`='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
`data/pilot/event-batch-membership/target-batches.csv`='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
`data/pilot/source-defined-cohort-admission/cohort-membership.csv`='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10'
)
if(sys.nframe()==0L){r<-run_m05_ablation();s<-r[['paired-scores']];print(s[s$record_type=='SCORES'&s$level=='tour'&s$stratum=='ALL',c('tour','paired','difference_logloss','difference_brier','classification')],row.names=FALSE)}
