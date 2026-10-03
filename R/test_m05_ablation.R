# Focused Phase 2W tests; historical runners/suites are not executed.
source('R/run_m05_ablation.R')
ncheck<-0L
check<-function(x,label){if(!isTRUE(x))stop(label,call.=FALSE);ncheck<<-ncheck+1L}
fails<-function(expr,label)check(inherits(tryCatch(force(expr),error=identity),'error'),label)
near<-mw_near
prior<-list.files('data/pilot',recursive=TRUE,full.names=TRUE);prior<-prior[!startsWith(prior,paste0(mw_dir,'/'))];before<-vapply(prior,mw_hash,'')
mw_verify();check(length(mw_pins)==13,'13 frozen pins');bad<-mw_pins;bad[1]<-'wrong';fails(mw_verify(bad),'changed pin fails');fails(mw_verify(c('missing-mw-input'='x')),'missing pin fails')
mw_ignored();fails(mw_ignored('R/not-ignored'),'unignored output fails')
# Textual helper comparison enforces exact historical numerical behavior.
extract<-function(path,name){e<-parse(path);e[[which(vapply(e,function(z)is.call(z)&&identical(z[[1]],as.name('<-'))&&is.symbol(z[[2]])&&as.character(z[[2]])==name,TRUE))]]}
for(name in c('fit_diagnostics','glm','collinearity','readiness','eta','loss','probability_loss')){
 old<-paste(deparse(extract('R/run_s08_paired_evaluation.R',paste0('sq_',name))),collapse='\n');old<-gsub('sq_','mw_',old,fixed=TRUE)
 if(name=='readiness'){old<-sub('rep(NA_real_, 4)','rep(NA_real_, 3)',old,fixed=TRUE);old<-sub('r$rank != 4','r$rank != 3',old,fixed=TRUE)}
 new<-paste(deparse(extract('R/run_m05_ablation.R',paste0('mw_',name))),collapse='\n');check(identical(old,new),paste('Frozen helper, dimension-only changes:',name))
}
x<-mw_load();i<-do.call(mw_prepare,x)
check(nrow(i$p)==2580&&sum(i$p$full_paired)==1278&&sum(i$f$attempted)==18,'frozen universes')
check(!'dM05' %in% names(i$p),'M05 values absent after cohort freeze')
for(field in c('tour','season','surface','batch_key','player_a_id')){bad<-x;bad$features[[field]][1]<-'WRONG';fails(do.call(mw_prepare,bad),'invalid feature join')}
bad<-x;bad$p<-bad$p[-1,];fails(do.call(mw_prepare,bad),'target removal')
bad<-x;bad$features<-rbind(bad$features,bad$features[1,]);fails(do.call(mw_prepare,bad),'duplicate feature target')
bad<-x;j<-which(bad$f$ready=='TRUE')[1];bad$f$training_match_ids[j]<-paste(bad$f$training_match_ids[j],bad$f$training_match_ids[j],sep=';');fails(do.call(mw_prepare,bad),'duplicate training IDs')
bad<-x;bad$f$training_match_ids[j]<-sub('^[^;]+;','',bad$f$training_match_ids[j]);fails(do.call(mw_prepare,bad),'missing training ID')
bad<-x;j<-which(bad$p$paired=='TRUE')[1];bad$p$paired[j]<-'FALSE';fails(do.call(mw_prepare,bad),'frozen scored mask')
bad<-x;bad$p$y[1]<-as.character(1-as.integer(bad$p$y[1]));fails(do.call(mw_prepare,bad),'wrong neutral outcome')
bad<-x;bad$p$p_s08[j]<-'0.99';fails(do.call(mw_prepare,bad),'altered full probability')
fails(mw_num('not a number'),'invalid numeric token')
check(is.na(mw_num('NA')),'saved missing token')
# Balanced rank-three fixture, including a nonzero feature mean.
g<-expand.grid(rep(list(c(-1,1)),4));tr<-as.data.frame(g[rep(1:16,each=8),1:3]);names(tr)<-mw_metrics
tr$y<-rep(as.integer(g[[4]]==1),each=8);tr$batch_key<-rep(paste0('B',1:8),length.out=nrow(tr));tr$dM03<-tr$dM03+.2
f<-mw_readiness(tr);check(f$record$ready&&f$record$rank==3&&length(f$fit$coefficients)==3,'rank three and zero intercept')
check(near(f$sd,vapply(tr[mw_metrics],sd,0.0)),'sample SDs')
check(near(mw_eta(tr[mw_metrics],f$fit,f$sd),as.vector(sweep(as.matrix(tr[mw_metrics]),2,f$sd,'/')%*%coef(f$fit))),'no centering')
check(near(plogis(mw_eta(tr[mw_metrics],f$fit,f$sd))+plogis(mw_eta(-tr[mw_metrics],f$fit,f$sd)),rep(1,nrow(tr))),'slot complementarity')
bad<-tr;bad$batch_key<-'B';a<-mw_readiness(bad)$record;check(a$reasons=='INSUFFICIENT_BATCHES'&&a$design_gate=='NOT_RUN'&&a$fit_gate=='NOT_RUN','count gate precedence')
a<-mw_readiness(tr[1:10,])$record;check(grepl('INSUFFICIENT_MATCHES',a$reasons)&&grepl('INSUFFICIENT_CLASSES',a$reasons),'all count failures')
bad<-tr;bad$dM03<-1;a<-mw_readiness(bad)$record;check(a$reasons=='INVALID_OR_CONSTANT_PREDICTOR'&&a$fit_gate=='NOT_RUN','constant gate precedence')
bad<-tr;bad$dM11<-bad$dM03;check(mw_readiness(bad)$record$reasons=='RANK_FAILURE','rank gate')
bad<-tr;bad$dM11<-bad$dM03+.001*bad$dM11;check(grepl('NEAR_REDUNDANCY',mw_readiness(bad)$record$reasons),'near redundancy')
bad<-tr;bad$dM11<-bad$dM03+.4*bad$dM11;check(grepl('VIF_CONCERN',mw_readiness(bad)$record$reasons),'VIF concern')
bad<-tr;bad$y<-as.integer(bad$dM03>.2);a<-mw_readiness(bad)$record;check(!a$ready&&grepl('SEPARATION_INDICATION',a$reasons),'separation withheld')
fake<-list(converged=FALSE,rank=2,coefficients=c(1,1,1),linear.predictors=c(-100,100),fitted.values=c(0,1),boundary=TRUE)
a<-mw_fit_diagnostics(fake,c(0,1),'fixture warning',3)
check(identical(a$reasons,c('NONCONVERGENCE','FITTED_RANK_FAILURE','FITTING_WARNING','BOUNDARY_FIT','EXTREME_TRAINING_PROBABILITY','SEPARATION_INDICATION')),'fit failure order')
fake$coefficients[1]<-Inf;check('NONFINITE_FIT' %in% mw_fit_diagnostics(fake,c(0,1),expected_rank=3)$reasons,'nonfinite fit')
check(near(mw_loss(c(0,1000,-1000),c(1,0,1)),c(log(2),1000,1000)),'stable log loss')
check(identical(mw_probability_loss(c(0,1,0,1),c(0,1,1,0)),c(0,0,Inf,Inf)),'no probability clipping')
check(mw_classify(rep(1,4),c(TRUE,TRUE))=='M05_FULL_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS','full classification')
check(mw_classify(rep(-1,4),c(TRUE,TRUE))=='M05_REDUCED_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS','reduced classification')
for(d in list(c(0,1,1,1),c(-1,1,1,1),c(NA,1,1,1)))check(mw_classify(d,c(TRUE,TRUE))=='M05_ABLATION_MIXED','ties/mixed/missing')
check(mw_classify(rep(1,4),c(TRUE,FALSE))=='M05_ABLATION_MIXED','failed tour comparison')
cat('Building reduced ablation and independent checks\n')
r<-mw_build(i);p<-r[['target-predictions']];fs<-r[['fold-readiness']];st<-r[['stability']];sc<-r[['paired-scores']]
check(nrow(p)==2580&&!anyDuplicated(p$match_id)&&identical(p$match_id,i$p$match_id),'all targets preserved')
check(nrow(fs)==30&&sum(fs$attempted)==18&&nrow(r[['model-fits']])==18,'only eighteen fits')
check(identical(as.integer(table(p$tour[p$paired])),c(211L,1067L)),'paired counts')
check(identical(p$full_probability_text,i$p$full_probability_text)&&identical(p$p_full,i$p$p_full),'full probability equality')
check(identical(p$full_paired,i$p$full_paired)&&identical(p$paired,p$full_paired),'no new complete rows')
check(identical(fs$reasons[!fs$attempted],i$f$reasons[!i$f$attempted]),'never-attempted reasons copied')
check(identical(p$comparison_reason[!p$full_ready],p$full_prediction_reason[!p$full_ready]),'never-attempted target reasons copied')
for(j in which(fs$attempted)){
 a<-fs[j,];train<-i$p[match(strsplit(a$training_match_ids,';',fixed=TRUE)[[1]],i$p$match_id),]
 check(identical(a$training_match_ids,i$f$training_match_ids[j])&&all(train$source_tourney_date<a$source_tourney_date),'exact training IDs and cutoff')
 sd0<-vapply(train[mw_metrics],sd,0.0);z<-as.data.frame(sweep(as.matrix(train[mw_metrics]),2,sd0,'/'));z$y<-train$y
 ref<-glm(y~0+dM03+dM11+dM12,data=z,family=binomial(),control=glm.control(epsilon=1e-8,maxit=25))
 ii<-p$batch_key==a$batch_key&p$full_paired;new<-as.data.frame(sweep(as.matrix(p[ii,mw_metrics]),2,sd0,'/'))
 check(near(p$p_reduced[ii],as.numeric(predict(ref,new,type='response'))),'independent formula fit/prediction')
 check(near(as.numeric(a[paste0('sd_',mw_metrics)]),sd0),'fold-only scaling')
 check(near(p$p_reduced[ii]+as.numeric(predict(ref,-new,type='response')),rep(1,sum(ii))),'actual slot swap')
}
for(model in c('full','reduced')){
 check(identical(which(is.finite(p[[paste0(model,'_logloss')]])),which(p$paired)),'identical loss masks')
 z<-p[p$paired,];prob<-z[[paste0('p_',model)]]
 check(near(z[[paste0(model,'_logloss')]],-ifelse(z$y==1,log(prob),log1p(-prob))),'independent log loss')
 check(near(z[[paste0(model,'_brier')]],(prob-z$y)^2),'Brier identity')
}
for(j in seq_len(nrow(st))){
 a<-st[j,];z<-p[p$tour==a$tour&p$paired,];del<-if(a$deletion=='BATCH')z$batch_key==a$key else z$player_a_id==a$key|z$player_b_id==a$key
 check(sum(del)==a$deleted&&sum(!del)==a$retained&&near(mean(z[[paste0('difference_',a$metric)]][!del]),a$deleted_difference),'independent both-slot score deletion')
}
for(g in mw_groups(p)){
 a<-sc[sc$record_type=='SCORES'&sc$tour==g$tour&sc$level==g$level&sc$group==g$group&sc$stratum==g$stratum,];z<-p[g$ii,];zz<-z[z$paired,]
 check(nrow(a)==1&&a$targets==nrow(z)&&a$paired==nrow(zz),'complete group coverage')
 for(m in c('logloss','brier'))check(near(a[[paste0('difference_',m)]],if(nrow(zz))mean(zz[[paste0('difference_',m)]]) else NA_real_),'group paired loss')
}
# Reduced-fold failures cannot silently shrink the cohort into a uniform result.
fail_fit<-function(train){a<-mw_readiness(train);a$record$ready<-FALSE;a$record$reasons<-'FITTING_WARNING';a$record$fit_gate<-'FAIL';a}
rr<-mw_build(i,fail_fit);check(!any(rr[['target-predictions']]$paired)&&all(rr[['paired-scores']]$classification=='M05_ABLATION_MIXED'),'failed fits yield no comparisons')
check(all(is.na(rr[['target-predictions']]$p_reduced)),'failed fits withhold probabilities')
# M05 values never affect frozen membership, readiness, fit or exported results.
bad<-x;bad$p$dM05<-'NA';bad$features$dM05<-'999999';ii<-do.call(mw_prepare,bad);check(identical(ii,i),'M05 irrelevance after cohort freezing')
rr<-mw_build(ii);check(identical(r,rr),'M05 irrelevance throughout pipeline')
bad<-lapply(x,function(z)z[nrow(z):1,,drop=FALSE]);rr<-mw_build(do.call(mw_prepare,bad));check(identical(r,rr),'row/fold/event permutation invariance')
# Own target and future information cannot enter an earlier prediction.
cut<-'20230703';target<-i$p$tour=='ATP'&i$p$source_tourney_date==cut
bad<-i;later<-bad$p$tour=='ATP'&bad$p$source_tourney_date>cut;bad$p$y[later]<-1-bad$p$y[later];bad$p$dM03[later]<-bad$p$dM03[later]*2
bad$f<-bad$f[bad$f$tour=='ATP'&bad$f$source_tourney_date<=cut,,drop=FALSE]
rr<-mw_walk(bad)$p;check(near(rr$p_reduced[target],p$p_reduced[target]),'later information isolation')
bad<-i;bad$p$y[target]<-1-bad$p$y[target];rr<-mw_walk(bad)$p;check(near(rr$p_reduced[target],p$p_reduced[target]),'own outcome isolation')
bad<-i;bad$p[mw_metrics]<--bad$p[mw_metrics];bad$p$y<-1-bad$p$y;bad$p$p_full<-1-bad$p$p_full;bad$p$eta_full<--bad$p$eta_full
rr<-mw_score(mw_walk(bad)$p);check(near(rr$p_reduced,1-p$p_reduced)&&near(rr$difference_logloss,p$difference_logloss),'global relabeling')
# Atomic installation and byte equality, preserving any existing release.
tmp<-tempfile('m05-ablation-test-',tmpdir='data/pilot')
tryCatch({
 fails(mw_install(r,tmp,function(stage)stop('interruption')),'interrupted stage')
 check(!dir.exists(tmp),'no partial output')
 fails(mw_install(r,tmp,function(stage)cat('bad',file=file.path(stage,'paired-scores.csv'),append=TRUE)),'staged corruption')
 check(!dir.exists(tmp),'corrupt stage not installed')
 mw_install(r,tmp);hash<-vapply(file.path(tmp,paste0(mw_outputs,'.csv')),mw_hash,'');rr<-mw_build(i);mw_install(rr,tmp)
 check(identical(hash,vapply(file.path(tmp,paste0(mw_outputs,'.csv')),mw_hash,'')),'byte-identical independent rerun')
 badr<-r;badr[['target-predictions']]$p_reduced[which(p$paired)[1]]<-.5;fails(mw_install(badr,tmp),'conflicting release refused')
 check(identical(hash,vapply(file.path(tmp,paste0(mw_outputs,'.csv')),mw_hash,'')),'existing release preserved')
},finally=unlink(tmp,recursive=TRUE))
mw_install(r);mw_verify();check(identical(before,vapply(prior,mw_hash,'')),'all prior pilot artifacts unchanged')
allowed<-c('R/run_m05_ablation.R','R/test_m05_ablation.R','docs/m05-ablation-results.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
check(all(file.exists(allowed)),'six files exist')
changed<-unique(c(system2('git',c('diff','--name-only'),stdout=TRUE),system2('git',c('diff','--cached','--name-only'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)))
check(all(changed %in% allowed),'exact allowed tracked scope')
check(setequal(list.files(mw_dir),paste0(mw_outputs,'.csv')),'five ignored outputs');mw_ignored()
check(all(vapply(r,function(z)all(z$convention==mw_convention&z$verified_chronology_decision==mw_chronology&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),TRUE)),'all boundary labels')
cat(ncheck,'Phase 2W focused checks passed\n')
