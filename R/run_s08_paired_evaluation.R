# Phase 2R: fixed zero-intercept S08 and paired descriptive evaluation, base R only.
sq_version <- '1.0.0'
sq_metrics <- c('dM03','dM05','dM11','dM12')
sq_convention <- 'SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY'
sq_chronology <- 'NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE'
sq_dir <- 'data/pilot/s08-paired-evaluation'
sq_outputs <- c('fold-readiness','target-predictions','model-fits','paired-scores','stability')
sq_scope <- c('R/run_s08_paired_evaluation.R','R/test_s08_paired_evaluation.R',
 'docs/s08-paired-evaluation-results.md','docs/s08-forecast-evaluation-protocol.md',
 'PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
sq_need <- function(ok,why) if(!isTRUE(ok)) stop(why,call.=FALSE)
sq_hash <- function(p) if(!file.exists(p)) 'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
sq_read <- function(p) read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
sq_sort <- function(x,fields) { x<-x[do.call(order,c(unname(x[fields]),list(method='radix'))),,drop=FALSE];rownames(x)<-NULL;x }
sq_bind <- function(rows) {
 fields<-unique(unlist(lapply(rows,names)));rows<-lapply(rows,function(r){for(k in setdiff(fields,names(r)))r[[k]]<-NA;r[fields]})
 out<-do.call(rbind,lapply(rows,as.data.frame,stringsAsFactors=FALSE));rownames(out)<-NULL;out
}
sq_join <- function(x,y,fields) {
 sq_need(!anyDuplicated(y$match_id)&&setequal(x$match_id,y$match_id),'Input universe/duplicate mismatch')
 y<-y[match(x$match_id,y$match_id),,drop=FALSE]
 for(k in fields)sq_need(identical(x[[k]],y[[k]]),paste('Input join mismatch:',k));y
}
sq_verify <- function(pins=sq_pins) sq_need(all(vapply(names(pins),sq_hash,'')==pins),'Missing or changed frozen input/authority')
sq_ignored <- function(dir=sq_dir) {
 paths<-file.path(dir,paste0(sq_outputs,'.csv'))
 got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
 sq_need(setequal(got,paths),'Output location must already be ignored')
}
sq_prepare <- function(x,f,e,m,d,expected_n=2580L) {
 sq_need(nrow(x)==expected_n&&!anyDuplicated(x$match_id),'Target accounting mismatch')
 x<-sq_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
 sq_need(all(x$tour %in% c('ATP','WTA'))&&all(x$season %in% c('2021','2023')),'Unauthorized tour/year')
 labels<-grepl('^[0-9]{8}$',x$source_tourney_date)
 date<-as.Date(x$source_tourney_date,format='%Y%m%d')
 sq_need(all(labels&!is.na(date)&format(date,'%Y%m%d')==x$source_tourney_date),'Invalid source label')
 sq_need(all(substr(x$source_tourney_date,1,4)==x$season)&all(x$batch_key==paste(x$tour,x$source_tourney_date,sep='|')),'Batch label mismatch')
 for(k in unique(x$cell_id))sq_need(length(unique(x$batch_key[x$cell_id==k]))==1,'Conflicting cell label')
 fields<-c('tour','season','cell_id','event','surface','round','batch_key','source_tourney_date','player_a_id','player_b_id')
 f<-sq_join(x,f,fields);e<-sq_join(x,e,fields)
 m<-sq_join(x,m,c('cell_id','event','surface','round','player_a_id','player_b_id'))
 sq_need(!anyDuplicated(d$match_id[d$match_id %in% x$match_id]),'Duplicate target disposition ID')
 sq_need(setequal(d$match_id[d$membership=='INCLUDED'],x$match_id),'Exclusions changed')
 d<-d[match(x$match_id,d$match_id),,drop=FALSE]
 sq_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS')&&identical(m$a_original_side,d$a_original_side),'Invalid membership/result orientation')
 for(k in c('winner_id','loser_id','player_a_id','player_b_id','cell_id','audit_source_path','audit_source_row'))sq_need(identical(m[[k]],d[[k]]),paste('Disposition conflict:',k))
 sq_need(all(m$a_original_side %in% c('winner','loser'))&&all(x$player_a_id!=x$player_b_id),'Invalid neutral identity')
 sq_need(all(x$player_a_id==ifelse(m$a_original_side=='winner',m$winner_id,m$loser_id))&&all(x$player_b_id==ifelse(m$a_original_side=='winner',m$loser_id,m$winner_id)),'Winner/slot mismatch')
 for(k in c('convention','verified_chronology_decision'))sq_need(identical(x[[k]],f[[k]])&&identical(x[[k]],e[[k]]),'Sensitivity label mismatch')
 sq_need(all(x$convention==sq_convention)&all(x$verified_chronology_decision==sq_chronology),'Incorrect sensitivity labels')
 for(k in sq_metrics)x[[k]]<-suppressWarnings(as.numeric(f[[k]]))
 slots<-sapply(c('a','b'),function(slot){
  rates<-sapply(sub('^d',paste0(slot,'_'),sq_metrics),function(k)suppressWarnings(as.numeric(f[[k]])))
  reasons<-sapply(sub('^d',paste0(slot,'_'),sq_metrics),function(k)f[[paste0(k,'_reason')]]=='DEFINED')
  sq_need(identical(unname(is.finite(rates)),unname(reasons)),'Slot rate/reason mismatch');rowSums(is.finite(rates))==4
 })
 for(k in sq_metrics) {
  a<-suppressWarnings(as.numeric(f[[sub('^d','a_',k)]]));b<-suppressWarnings(as.numeric(f[[sub('^d','b_',k)]]))
  ok<-is.finite(a)&is.finite(b)
  sq_need(all(is.finite(x[[k]])==ok)&&all(abs(x[[k]][ok]-(a-b)[ok])<1e-14),'Difference/slot mismatch')
  x[[paste0(k,'_reason')]]<-f[[paste0(k,'_reason')]]
 }
 x$complete<-rowSums(is.finite(as.matrix(x[sq_metrics])))==4
 sq_need(all(x$complete==(f$all_s08_differences_defined=='TRUE'))&&all(x$complete==apply(slots,1,all)),'Complete-vector mismatch')
 x$s08_stratum<-ifelse(x$complete,'BOTH_COMPLETE',ifelse(rowSums(slots)==1,'ONE_COMPLETE','NEITHER_COMPLETE'))
 sq_need(identical(x$s08_stratum,e$s08_stratum),'Elo completeness stratum mismatch')
 for(k in c('p_a_primary','p_a_overall')) {x[[k]]<-as.numeric(e[[k]]);sq_need(all(is.finite(x[[k]])&x[[k]]>=0&x[[k]]<=1),'Invalid frozen comparator')}
 x$y<-as.integer(m$a_original_side=='winner');x
}
sq_load <- function() {
 sq_ignored();sq_verify() # Verify ALL pins before reading any table, including outcomes.
 sq_prepare(sq_read('data/pilot/event-batch-membership/target-batches.csv'),
 sq_read('data/pilot/s08-batched-histories/target-s08-features.csv'),
 sq_read('data/pilot/surface-elo-baseline/target-elo-probabilities.csv'),
 sq_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
 sq_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))
}
sq_fit_diagnostics <- function(fit,y,warnings=character(),expected_rank) {
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
sq_glm <- function(X,y) {
 warnings<-character()
 fit<-tryCatch(withCallingHandlers(glm.fit(X,y,family=binomial(),intercept=FALSE,
  control=glm.control(epsilon=1e-8,maxit=25)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=identity)
 if(inherits(fit,'error'))return(list(fit=NULL,diag=list(reasons='FIT_ERROR',converged=FALSE,boundary=NA,extreme=NA,witness=NA,warnings=conditionMessage(fit))))
 list(fit=fit,diag=sq_fit_diagnostics(fit,y,warnings,ncol(X)))
}
sq_collinearity <- function(X) {
 # Registered centered diagnostics are separate from the uncentered forecast design.
 Z<-scale(X,center=TRUE,scale=TRUE)
 pearson<-max(abs(cor(X)[upper.tri(cor(X))]));sp<-cor(X,method='spearman');spearman<-max(abs(sp[upper.tri(sp)]))
 vif<-vapply(seq_len(ncol(X)),function(j){r<-lm.fit(cbind(1,Z[,-j,drop=FALSE]),Z[,j]);sum(Z[,j]^2)/sum(r$residuals^2)},0.0)
 ss<-svd(Z,nu=0,nv=0)$d
 list(pearson=pearson,spearman=spearman,vif=max(vif),condition=max(ss)/min(ss))
}
sq_readiness <- function(train) {
 X<-as.matrix(train[sq_metrics]);y<-train$y;n<-nrow(train)
 r<-list(training_n=n,training_batches=length(unique(train$batch_key)),class_0=sum(y==0),class_1=sum(y==1),
  count_gate='PASS',design_gate='NOT_RUN',fit_gate='NOT_RUN',rank=NA_integer_,pearson=NA_real_,spearman=NA_real_,vif=NA_real_,condition=NA_real_,
  converged=NA,boundary=NA,extreme=NA_integer_,witness=NA,warnings='',correlation_warning='',separation_status='NOT_RUN')
 for(k in sq_metrics){r[[paste0('sd_',k)]]<-NA_real_;r[[paste0('beta_',k)]]<-NA_real_}
 reasons<-character();fit<-NULL;scales<-rep(NA_real_,4)
 if(r$training_batches<5)reasons<-c(reasons,'INSUFFICIENT_BATCHES')
 if(n<100)reasons<-c(reasons,'INSUFFICIENT_MATCHES')
 if(r$class_0<25||r$class_1<25)reasons<-c(reasons,'INSUFFICIENT_CLASSES')
 if(length(reasons))r$count_gate<-'FAIL' else {
  scales<-apply(X,2,sd)
  for(k in sq_metrics)r[[paste0('sd_',k)]]<-scales[k]
  if(!all(is.finite(X))||!all(is.finite(scales)&scales>0))reasons<-c(reasons,'INVALID_OR_CONSTANT_PREDICTOR') else {
   Z<-sweep(X,2,scales,'/');r$rank<-qr(Z,tol=1e-7)$rank
   if(r$rank!=4)reasons<-c(reasons,'RANK_FAILURE')
   if(!length(reasons)) {
    col<-tryCatch(sq_collinearity(X),error=identity)
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
    fitted<-sq_glm(Z,y);fit<-fitted$fit;dd<-fitted$diag
    r[c('converged','boundary','extreme','witness','warnings')]<-dd[c('converged','boundary','extreme','witness','warnings')]
    reasons<-c(reasons,dd$reasons);r$fit_gate<-if(length(reasons))'FAIL' else 'PASS'
    r$separation_status<-if(isTRUE(dd$witness))'SEPARATION_INDICATION' else if(is.na(dd$witness))'UNRESOLVED' else 'NO_SEPARATION_DETECTED_BY_REGISTERED_DIAGNOSTICS'
    if(!is.null(fit))for(k in sq_metrics)r[[paste0('beta_',k)]]<-fit$coefficients[k]
   }
  }
  r$design_gate<-if(r$fit_gate!='NOT_RUN')'PASS' else 'FAIL'
 }
 r$ready<-length(reasons)==0;r$reasons<-if(r$ready)'PASS' else paste(reasons,collapse=';')
 list(record=r,fit=fit,sd=scales)
}
sq_eta <- function(X,fit,scales) as.vector(sweep(as.matrix(X),2,scales,'/')%*%fit$coefficients)
sq_walk <- function(x) {
 x<-sq_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
 sq_need(all(x$y %in% c(0,1))&&!anyDuplicated(x$match_id),'Invalid outcome/duplicate target')
 x$eta_s08<-NA_real_;x$p_s08<-NA_real_;x$fold_ready<-FALSE;x$fold_reasons<-'';x$prediction_reason<-''
 folds<-list();fits<-list()
 for(tour in sort(unique(x$tour),method='radix'))for(date in sort(unique(x$source_tourney_date[x$tour==tour]),method='radix')) {
  target<-which(x$tour==tour&x$source_tourney_date==date)
  tr<-which(x$tour==tour&x$source_tourney_date<date&x$complete)
  train<-x[tr,,drop=FALSE];f<-sq_readiness(train);r<-f$record
  meta<-list(tour=tour,batch_key=paste(tour,date,sep='|'),source_tourney_date=date,season=substr(date,1,4),
   event=paste(sort(unique(x$event[target])),collapse=';'),surface=paste(sort(unique(x$surface[target])),collapse=';'))
  r<-c(meta,r,list(targets=length(target),complete_targets=sum(x$complete[target]),training_match_ids=paste(train$match_id,collapse=';'),
   training_max_label=if(length(tr))max(train$source_tourney_date) else NA_character_))
  x$fold_ready[target]<-r$ready;x$fold_reasons[target]<-r$reasons
  eligible<-target[x$complete[target]]
  if(r$ready&&length(eligible)) {
   eta<-sq_eta(x[eligible,sq_metrics],f$fit,f$sd);p<-plogis(eta);ok<-is.finite(eta)&is.finite(p)
   x$eta_s08[eligible[ok]]<-eta[ok];x$p_s08[eligible[ok]]<-p[ok]
  }
  for(j in target) {
   why<-character()
   if(!x$complete[j])why<-c(why,'INCOMPLETE_S08',paste(sq_metrics[!is.finite(as.numeric(x[j,sq_metrics]))],unlist(x[j,paste0(sq_metrics[!is.finite(as.numeric(x[j,sq_metrics]))],'_reason')]),sep=':'))
   if(!r$ready)why<-c(why,strsplit(r$reasons,';',fixed=TRUE)[[1]])
   if(x$complete[j]&&r$ready&&!is.finite(x$p_s08[j]))why<-c(why,'NONFINITE_TARGET_PREDICTION')
   x$prediction_reason[j]<-if(length(why))paste(why,collapse=';') else 'PREDICTED'
  }
  r$predictions<-sum(is.finite(x$p_s08[target]));folds[[length(folds)+1L]]<-r
  fits[[length(fits)+1L]]<-c(list(record_type='FORECAST',level='batch_key',group=r$batch_key,stratum='ALL',model='S08',intercept=0),r[setdiff(names(r),'training_match_ids')])
 }
 x$paired<-x$complete&x$fold_ready&is.finite(x$p_s08)&is.finite(x$p_a_primary)&is.finite(x$p_a_overall)
 list(p=x,folds=sq_bind(folds),fits=sq_bind(fits))
}
sq_loss <- function(eta,y) pmax(eta,0)-y*eta+log1p(exp(-abs(eta)))
sq_probability_loss <- function(p,y) {r<-numeric(length(p));r[y==1]<--log(p[y==1]);r[y==0]<--log1p(-p[y==0]);r}
sq_accuracy <- function(p,y) ifelse(p==.5,.5,as.numeric((p>.5)==(y==1)))
sq_score_rows <- function(p) {
 for(model in c('s08','primary','overall')) {
  prob<-p[[switch(model,s08='p_s08',primary='p_a_primary',overall='p_a_overall')]]
  p[[paste0(model,'_logloss')]]<-NA_real_;p[[paste0(model,'_brier')]]<-NA_real_;p[[paste0(model,'_accuracy')]]<-NA_real_
  ii<-which(p$paired)
  p[[paste0(model,'_logloss')]][ii]<-if(model=='s08')sq_loss(p$eta_s08[ii],p$y[ii]) else sq_probability_loss(prob[ii],p$y[ii])
  p[[paste0(model,'_brier')]][ii]<-(prob[ii]-p$y[ii])^2
  p[[paste0(model,'_accuracy')]][ii]<-sq_accuracy(prob[ii],p$y[ii])
 }
 for(model in c('primary','overall'))for(metric in c('logloss','brier'))p[[paste0('difference_',model,'_',metric)]]<-p[[paste0('s08_',metric)]]-p[[paste0(model,'_',metric)]]
 p
}
sq_groups <- function(p) {
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
sq_calibration <- function(z,model) {
 y<-z$y;eta<-if(model=='s08')z$eta_s08 else qlogis(z[[paste0('p_a_',model)]])
 reasons<-character();n<-nrow(z)
 if(n<100)reasons<-c(reasons,'INSUFFICIENT_MATCHES')
 if(sum(y==0)<25||sum(y==1)<25)reasons<-c(reasons,'INSUFFICIENT_CLASSES')
 if(length(unique(z$batch_key))<5)reasons<-c(reasons,'INSUFFICIENT_BATCHES')
 # Boundary probabilities are not removed to obtain calibration support.
 prob<-if(model=='s08')z$p_s08 else z[[paste0('p_a_',model)]]
 if(!all(is.finite(eta))||any(prob<=0|prob>=1)||n<2||!is.finite(sd(eta))||sd(eta)==0)reasons<-c(reasons,'INVALID_OR_CONSTANT_LOGIT')
 X<-cbind(intercept=1,slope=eta)
 if(!length(reasons)&&qr(X,tol=1e-7)$rank!=2)reasons<-c(reasons,'RANK_FAILURE')
 intercept<-slope<-NA_real_;warnings<-''
 if(!length(reasons)) {
  f<-sq_glm(X,y);reasons<-f$diag$reasons;warnings<-f$diag$warnings
  if(!length(reasons)){intercept<-f$fit$coefficients[1];slope<-f$fit$coefficients[2]}
 }
 list(status=if(length(reasons))'CALIBRATION_NOT_ASSESSABLE' else 'DESCRIPTIVE_ONLY',
  reasons=if(length(reasons))paste(reasons,collapse=';') else 'PASS',intercept=unname(intercept),slope=unname(slope),warnings=warnings)
}
sq_summarize <- function(p) {
 rows<-list();cal<-list();reason_set<-sort(unique(unlist(strsplit(p$prediction_reason[p$prediction_reason!='PREDICTED'],';',fixed=TRUE))),method='radix')
 for(g in sq_groups(p)) {
  z<-p[g$ii,,drop=FALSE];sc<-z[z$paired,,drop=FALSE];meta<-g[setdiff(names(g),'ii')]
  common<-c(meta,list(targets=nrow(z),complete=sum(z$complete),ready_targets=sum(z$fold_ready),predictions=sum(is.finite(z$p_s08)),scored=nrow(sc),
   failed_targets=sum(!is.finite(z$p_s08)),batches=length(unique(z$batch_key)),scored_batches=length(unique(sc$batch_key)),
   scored_players=length(unique(c(sc$player_a_id,sc$player_b_id))),scored_events=length(unique(sc$cell_id))))
  for(model in c('s08','primary','overall')) {
   r<-c(list(record_type='SCORES',model=model,reason='ALL'),common)
   for(metric in c('logloss','brier','accuracy'))r[[metric]]<-if(nrow(sc))mean(sc[[paste0(model,'_',metric)]]) else NA_real_
   for(metric in c('logloss','brier'))r[[paste0('s08_minus_model_',metric)]]<-if(nrow(sc))mean(sc[[paste0('s08_',metric)]]-sc[[paste0(model,'_',metric)]]) else NA_real_
   rows[[length(rows)+1L]]<-r
   cc<-sq_calibration(sc,model)
   cal[[length(cal)+1L]]<-c(list(record_type='CALIBRATION',model=model),meta,list(training_n=nrow(sc),training_batches=length(unique(sc$batch_key))),cc)
  }
  for(reason in reason_set) {
   count<-sum(vapply(strsplit(z$prediction_reason,';',fixed=TRUE),function(x)reason %in% x,TRUE))
   rows[[length(rows)+1L]]<-c(list(record_type='FAILURE',model='S08',reason=reason,reason_count=count),common)
  }
 }
 list(scores=sq_bind(rows),cal=sq_bind(cal))
}
sq_deletions <- function(p) {
 rows<-list()
 for(tour in sort(unique(p$tour),method='radix')) {
  z<-p[p$tour==tour&p$paired,,drop=FALSE]
  for(kind in c('BATCH','PLAYER')) {
   keys<-if(kind=='BATCH')sort(unique(z$batch_key),method='radix') else sort(unique(c(z$player_a_id,z$player_b_id)),method='radix')
   if(!length(keys))keys<-'NO_SCORED_ROWS'
   for(key in keys) {
    del<-if(kind=='BATCH')z$batch_key==key else z$player_a_id==key|z$player_b_id==key
    keep<-z[!del,,drop=FALSE]
    for(model in c('primary','overall'))for(metric in c('logloss','brier')) {
     field<-paste0('difference_',model,'_',metric);base<-if(nrow(z))mean(z[[field]]) else NA_real_;value<-if(nrow(keep))mean(keep[[field]]) else NA_real_
     rows[[length(rows)+1L]]<-list(tour=tour,deletion=kind,key=key,comparator=model,metric=metric,deleted=sum(del),retained=nrow(keep),
      retained_batches=length(unique(keep$batch_key)),retained_players=length(unique(c(keep$player_a_id,keep$player_b_id))),retained_events=length(unique(keep$cell_id)),
      base_difference=base,deleted_difference=value,change=value-base,sign_reversal=if(is.finite(base)&&is.finite(value))base*value<0 else NA,
      status=if(nrow(keep))'CONDITIONAL_SCORE_INFLUENCE' else 'NO_RETAINED_SCORES')
    }
   }
  }
 }
 sq_bind(rows)
}
sq_build <- function(x) {
 r<-sq_walk(x);p<-sq_score_rows(r$p);s<-sq_summarize(p)
 fits<-sq_bind(list(r$fits,s$cal))
 out<-setNames(list(r$folds,p,fits,s$scores,sq_deletions(p)),sq_outputs)
 for(k in names(out)) {out[[k]]$version<-sq_version;out[[k]]$convention<-sq_convention;out[[k]]$verified_chronology_decision<-sq_chronology;out[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 out
}
sq_install <- function(r,dir=sq_dir,before_install=function(stage)NULL) {
 sq_ignored(dir);sq_verify();sq_need(identical(names(r),sq_outputs),'Output scope mismatch')
 stage<-tempfile('.s08-paired-stage-',tmpdir=dirname(dir));sq_need(dir.create(stage),'Cannot stage output')
 on.exit(unlink(stage,recursive=TRUE),add=TRUE)
 for(k in names(r))write.table(r[[k]],file.path(stage,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
 paths<-file.path(stage,paste0(sq_outputs,'.csv'));hashes<-vapply(paths,sq_hash,'');before_install(stage)
 sq_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0),'Incomplete staging')
 sq_need(identical(vapply(paths,sq_hash,''),hashes),'Staged bytes changed');sq_verify()
 if(dir.exists(dir)) {
  sq_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing output scope differs')
  sq_need(identical(unname(vapply(file.path(dir,basename(paths)),sq_hash,'')),unname(hashes)),'Existing release differs; preserve it')
 } else sq_need(file.rename(stage,dir),'Atomic output installation failed')
 invisible(r)
}
run_s08_paired_evaluation <- function(write_outputs=TRUE) {x<-sq_load();r<-sq_build(x);if(write_outputs)sq_install(r);r}

sq_pins <- c(
`AGENTS.override.md`='7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b',
`docs/s08-forecast-evaluation-protocol.md`='0cb6c8ebf5bb7c2028817fa4f6f8052f35eaa761ee9fdf63c45790cc0f4b99de',
`docs/source-label-event-batching-decision.md`='7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c',
`docs/s08-batched-history-aggregation.md`='1ac223d78c40705877db3e2810b2c507631d39043ac23d178aaee5586d4c75c2',
`docs/surface-elo-baseline-audit.md`='1bbd2ca856cf4d42e1b5e557abd8d3eb759264fdd02d5e664a67ca0b439b6153',
`docs/source-defined-cohort-audit.md`='5aa928d4f270357739b384337a71e79bc79f52461cbd7740a00c839e5698f38b',
`data/pilot/event-batch-membership/target-batches.csv`='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
`data/pilot/event-batch-membership/candidate-history-membership.csv`='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
`data/pilot/s08-batched-histories/slot-history-aggregates.csv`='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
`data/pilot/s08-batched-histories/target-s08-features.csv`='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
`data/pilot/s08-batched-histories/summary.csv`='7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4',
`data/pilot/surface-elo-baseline/target-elo-probabilities.csv`='93505d79faf5e17eb3646c101ea6b21e8035e2acddbfe55c27f3236bb6c2392c',
`data/pilot/surface-elo-baseline/rating-update-ledger.csv`='a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c',
`data/pilot/surface-elo-baseline/summary.csv`='9cf5eb133ef8a213881250c855ddb98a96bf16209f82d21e6d7c6bc35e927469',
`data/pilot/source-defined-cohort-admission/cohort-membership.csv`='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
`data/pilot/source-defined-cohort-admission/row-dispositions.csv`='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6'
)
if(sys.nframe()==0L) {
 r<-run_s08_paired_evaluation()
 print(r[['paired-scores']][r[['paired-scores']]$record_type=='SCORES'&r[['paired-scores']]$level=='tour'&r[['paired-scores']]$stratum=='ALL',c('tour','model','targets','scored','logloss','brier','s08_minus_model_logloss','s08_minus_model_brier')],row.names=FALSE)
}
