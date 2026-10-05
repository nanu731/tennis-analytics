# Phase 2AL focused checks. Default mode uses synthetic fixtures only and never reads 2025 outcomes.
# Mode 'installed' runs after the single locked run: independent byte-identical rerun plus output consistency.
source('R/run_2025_locked_evaluation.R')
n<-0L
ok<-function(z,label){n<<-n+1L;if(!isTRUE(z))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),pattern)}
eq<-function(a,b,tol=1e-10)isTRUE(all.equal(a,b,tolerance=tol,check.attributes=FALSE))
mode<-commandArgs(trailingOnly=TRUE);mode<-if(length(mode))mode[1] else 'synthetic'
e<-al_helpers();metrics<-e$sq_metrics
write_csv<-function(z,path)write.table(z,path,sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
# Synthetic cohorts in the frozen prepared-row format. elo: partial signal, pure noise, or oracle with hidden information.
al_fixture <- function(seed=11,elo='partial'){
 set.seed(seed);beta<-c(.9,-.3,.7,.6);players<-sprintf('P%03d',1:80);metrics<-c('dM03','dM05','dM11','dM12')
 make<-function(cohort,tour,dates,size,empty=character()){
  do.call(rbind,lapply(dates,function(date){
   ids<-t(replicate(size,sample(players,2)));X<-matrix(rnorm(4*size),size,4);eta<-as.vector(X%*%beta);hidden<-rnorm(size,sd=1.5)
   truth<-if(elo=='oracle')eta+hidden else eta;y<-rbinom(size,1,plogis(truth))
   z<-data.frame(match_id=sprintf('%s-%s-%03d',tour,date,seq_len(size)),cohort=cohort,tour=tour,season=substr(date,1,4),batch_key=paste(tour,date,sep='|'),
    source_tourney_date=date,cell_id=paste(tour,date,sep=':'),event=paste0('E',substr(date,5,6)),surface=c('Hard','Clay','Grass')[1+as.integer(substr(date,5,6))%%3],
    round='R32',player_a_id=ids[,1],player_b_id=ids[,2],stringsAsFactors=FALSE)
   z$match_key<-paste(cohort,z$match_id,sep='|')
   for(k in 1:4){z[[metrics[k]]]<-X[,k];z[[paste0(metrics[k],'_reason')]]<-'DEFINED'}
   miss<-runif(size)<.06|date %in% empty;z$dM05[miss]<-NA;z$dM05_reason[miss]<-'EMPTY_HISTORY'
   z$complete<-!miss;z$s08_stratum<-ifelse(miss,'ONE_COMPLETE','BOTH_COMPLETE')
   z$p_a_primary<-switch(elo,partial=plogis(.7*eta+rnorm(size,sd=.5)),noise=plogis(rnorm(size,sd=.3)),oracle=plogis(truth))
   z$p_a_overall<-plogis(.6*eta+rnorm(size,sd=.6));z$y<-as.integer(y);z
  }))
 }
 dev<-val<-fin<-list()
 for(t in c('ATP','WTA')){
  dev[[t]]<-make('DEVELOPMENT',t,c('20210111','20210301','20210315','20210510','20210524','20230116','20230306'),35)
  val[[t]]<-make('VALIDATION_2024',t,c('20240115','20240304','20240318','20240506','20240520'),35)
  fin[[t]]<-make('FINAL_TEST_2025',t,c('20250113','20250303','20250310','20250505','20250519','20250630'),60,empty='20250310')
 }
 dev<-do.call(rbind,dev);val<-do.call(rbind,val);fin<-do.call(rbind,fin);rownames(dev)<-rownames(val)<-rownames(fin)<-NULL
 required<-unique(fin[c('tour','batch_key')]);rownames(required)<-NULL
 cells<-unique(fin[c('tour','cell_id','surface')]);cells$targets<-as.integer(table(fin$cell_id)[cells$cell_id]);cells$excluded_panel_records<-0L;cells$admission_cell_state<-'SYNTHETIC_ADMITTED'
 cells<-rbind(cells,data.frame(tour='WTA',cell_id='WTA:blocked',surface='Hard',targets=0L,excluded_panel_records=95L,admission_cell_state='SYNTHETIC_WHOLLY_EXCLUDED'));rownames(cells)<-NULL
 list(dev=dev,val=val,fin=fin,required=required,cells=cells,reconciliation=data.frame(record_type='INPUT_RECONCILIATION',tour='SYNTHETIC',stringsAsFactors=FALSE))
}
predicted<-function(r,model)r[[paste0('p_',model)]]

if(mode=='synthetic'){
 # Pins and guards, without reading any 2025 table.
 for(path in names(al_pins))ok(al_hash(path)==al_pins[[path]],paste('pin',path))
 bad<-al_pins;bad[length(bad)]<-'bad';fail(al_verify(bad),'mismatch');fail(e$sq_ignored('R/not-ignored'),'already be ignored')
 ok(identical(e$sq_outputs,al_outputs)&&e$sq_dir==al_dir,'six-output 2AF layout bound to 2AL location')
 i<-al_fixture();r<-al_build(i,e);p<-r[['target-predictions']];folds<-r[['fold-readiness']];st<-r[['stability']];fc<-r[['final-conclusions']]
 ok(identical(names(r),al_outputs)&&all(vapply(r,function(z)all(z$version=='2AL-1.0.0'&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'&z$m05_interpretation_gate=='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED'),TRUE)),'labels on every output')
 ok(nrow(p)==nrow(i$fin)&&setequal(p$match_key,i$fin$match_key)&&all(p$season=='2025'),'all targets retained')
 ok(nrow(folds)==2*nrow(i$required)&&all(folds$season=='2025')&&!anyDuplicated(folds[c('model','batch_key')]),'every required batch fitted once per model')
 empty<-folds[folds$batch_key %in% c('ATP|20250310','WTA|20250310'),];ok(nrow(empty)==4&&all(empty$complete_targets==0)&&all(empty$predictions==0)&&all(empty$ready),'required batch with no complete targets still fitted')
 # Independent reconstruction of each training universe, scale and zero-intercept prediction.
 prior<-rbind(i$dev[al_fields(e)],i$val[al_fields(e)])
 for(j in seq_len(nrow(folds))){f<-folds[j,]
  want<-c(prior$match_key[prior$tour==f$tour&prior$complete],i$fin$match_key[i$fin$tour==f$tour&i$fin$complete&i$fin$source_tourney_date<f$source_tourney_date])
  ids<-strsplit(f$training_keys,';',fixed=TRUE)[[1]];ok(setequal(ids,want)&&!anyDuplicated(ids),'exact original vectors and strict earlier-batch cutoff')
  ok(f$training_development_n==sum(startsWith(ids,'DEVELOPMENT|'))&&f$training_validation_2024_n==sum(startsWith(ids,'VALIDATION_2024|'))&&f$training_final_test_n==sum(startsWith(ids,'FINAL_TEST_2025|')),'training composition')
  all_rows<-rbind(prior,i$fin[al_fields(e)]);train<-all_rows[match(ids,all_rows$match_key),]
  mm<-if(f$model=='full')metrics else e$mw_metrics
  ok(eq(as.numeric(f[paste0('sd_',mm)]),unname(vapply(train[mm],sd,0.0)),1e-12),'sample SD from training only')
  mate<-folds[folds$batch_key==f$batch_key&folds$model!=f$model,];ok(identical(f$training_keys,mate$training_keys)&&identical(f$target_keys,mate$target_keys),'identical model IDs')
  z<-p[p$batch_key==f$batch_key&p$complete,];if(nrow(z)){eta<-as.vector(sweep(as.matrix(z[mm]),2,as.numeric(f[paste0('sd_',mm)]),'/')%*%as.numeric(f[paste0('beta_',mm)]))
  ok(eq(eta,z[[paste0('eta_',f$model)]],1e-12)&&eq(plogis(eta),z[[paste0('p_',f$model)]],1e-12),'zero-intercept reconstruction')}
 }
 ok(all(!is.finite(p$p_full[!p$complete]))&&all(grepl('INCOMPLETE_S08',p$full_reason[!p$complete]))&&all(grepl('dM05:EMPTY_HISTORY',p$reduced_reason[!p$complete])),'removing M05 cannot enlarge reduced eligibility')
 # Gate precedence: count -> design -> rank -> collinearity -> fit, with no rescue.
 set.seed(172);fx<-as.data.frame(matrix(rnorm(800),200,4));names(fx)<-metrics;fx$y<-rep(0:1,100);fx$batch_key<-rep(paste0('B',1:5),each=40)
 for(model in c('full','reduced')){fn<-if(model=='full')e$sq_readiness else e$mw_readiness
  z<-fx[1:10,];z$dM03<-0;g<-fn(z)$record;ok(g$count_gate=='FAIL'&&g$design_gate=='NOT_RUN'&&g$fit_gate=='NOT_RUN'&&grepl('INSUFFICIENT_MATCHES',g$reasons)&&grepl('INSUFFICIENT_BATCHES',g$reasons),'count precedence retains all count failures')
  z<-fx;z$batch_key<-'one';ok(fn(z)$record$reasons=='INSUFFICIENT_BATCHES','five contributing batches')
  z<-fx;z$y<-c(rep(0,180),rep(1,20));ok(fn(z)$record$reasons=='INSUFFICIENT_CLASSES','25 outcomes per class')
  z<-fx;z$dM03<-0;g<-fn(z)$record;ok(g$design_gate=='FAIL'&&g$fit_gate=='NOT_RUN'&&g$reasons=='INVALID_OR_CONSTANT_PREDICTOR','constant predictor')
  z<-fx;z$dM11<-NA_real_;ok(fn(z)$record$reasons=='INVALID_OR_CONSTANT_PREDICTOR','nonfinite predictor')
  z<-fx;z$dM11<-z$dM03;g<-fn(z)$record;ok(g$reasons=='RANK_FAILURE'&&g$fit_gate=='NOT_RUN','rank precedence')
  z<-fx;z$dM11<-z$dM03+rnorm(200,sd=.01);g<-fn(z)$record;ok(grepl('NEAR_REDUNDANCY',g$reasons)&&g$fit_gate=='NOT_RUN','collinearity failure')
  z<-fx;z$y<-as.integer(z$dM03>0);g<-fn(z)$record;ok(!g$ready&&g$fit_gate=='FAIL','separation/extreme safeguard')
  g<-fn(fx);ok(g$record$ready&&g$record$rank==if(model=='full')4 else 3,'ready fixture rank')
 }
 d<-e$sq_fit_diagnostics(list(converged=FALSE,rank=2,coefficients=c(NA,1),linear.predictors=c(0,1),fitted.values=c(.5,.75),boundary=TRUE),c(0,1),'w',4)
 ok(all(c('NONCONVERGENCE','FITTED_RANK_FAILURE','FITTING_WARNING','NONFINITE_FIT','BOUNDARY_FIT') %in% d$reasons),'all fit reasons retained')
 # One model's failure cannot be rescued by the other, and both labels abstain.
 blocked<-function(fn)function(train){z<-fn(train);z$record$ready<-FALSE;z$record$reasons<-'FITTING_WARNING';z$record$fit_gate<-'FAIL';z}
 bf<-al_build(i,e,fit_full=blocked(e$sq_readiness));q<-bf[['target-predictions']]
 ok(!any(q$paired)&&all(is.na(q$p_full))&&sum(is.finite(q$p_reduced))==sum(q$complete),'failed full keeps reduced predictions but no common mask')
 ok(all(bf[['final-conclusions']]$loss_label==al_unresolved)&&all(bf[['final-conclusions']]$calibration_label=='CALIBRATION_COMPARISON_UNRESOLVED'),'failed full abstains')
 br<-al_build(i,e,fit_reduced=blocked(e$mw_readiness));ok(all(br[['final-conclusions']]$loss_label==al_unresolved)&&all(grepl('FAILED_REQUIRED_GATE',br[['final-conclusions']]$loss_reason)),'failed reduced fold also blocks the full label')
 bo<-al_build(i,e,fit_full=function(train)if(train$tour[1]=='ATP'&&max(train$source_tourney_date)<'2025')blocked(e$sq_readiness)(train) else e$sq_readiness(train))
 ok(all(bo[['final-conclusions']]$loss_label==al_unresolved)&&sum(!bo[['fold-readiness']]$ready)==1,'a single failed required fold blocks both candidates in both tours')
 miss<-al_build(i,e,fit_full=function(train){z<-blocked(e$sq_readiness)(train);for(k in metrics)z$record[[paste0('beta_',k)]]<-NA_real_;z});mf<-miss[['final-conclusions']]
 ok(all(mf$m05_missing==mf$m05_full_folds)&&all(mf$m05_negative+mf$m05_nonnegative==0),'missing M05 fits counted, not dropped')
 ok(all(fc$m05_negative+fc$m05_nonnegative+fc$m05_missing==fc$m05_full_folds)&&all(fc$m05_direction_requirement=='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED')&&all(grepl('NO_FINAL_FOUR_FACTORS_QUALIFICATION',fc$interpretation)),'M05 signs reported and limitation binding')
 # Permutations, outcome invariance, earlier-outcome positive controls and global slot swaps.
 w<-al_walk(i,e);set.seed(9);ii<-i;for(k in c('dev','val','fin'))ii[[k]]<-i[[k]][sample(nrow(i[[k]])),];ok(identical(w,al_walk(ii,e)),'row/event permutation invariance')
 cols<-c('match_key','p_full','p_reduced','eta_full','eta_reduced','full_ready','reduced_ready')
 for(b in unique(i$fin$batch_key)){ii<-i;j<-which(ii$fin$batch_key==b);t<-ii$fin$tour[j[1]];date<-ii$fin$source_tourney_date[j[1]]
  later<-which(ii$fin$tour==t&ii$fin$source_tourney_date>=date);ii$fin$y[later]<-1-ii$fin$y[later];wp<-al_walk(ii,e)
  keep<-w$p$tour!=t|w$p$source_tourney_date<=date;ok(identical(w$p[keep,cols],wp$p[keep,cols]),paste('current/later outcome invariance',b))}
 ii<-i;ii$dev$y<-1-ii$dev$y;ok(any(abs(al_walk(ii,e)$p$p_full-w$p$p_full)>1e-6,na.rm=TRUE),'earlier development outcome positive control')
 ii<-i;j<-ii$fin$batch_key=='ATP|20250113';ii$fin$y[j]<-1-ii$fin$y[j];wp<-al_walk(ii,e);later<-w$p$tour=='ATP'&w$p$source_tourney_date>'20250113'
 ok(any(abs(wp$p$p_full[later]-w$p$p_full[later])>1e-8,na.rm=TRUE),'completed earlier 2025 batch enters later training')
 ii<-i;for(k in c('dev','val','fin')){z<-ii[[k]];z[metrics]<--z[metrics];z$y<-1L-z$y;tmp<-z$player_a_id;z$player_a_id<-z$player_b_id;z$player_b_id<-tmp;z$p_a_primary<-1-z$p_a_primary;z$p_a_overall<-1-z$p_a_overall;ii[[k]]<-z}
 rs<-al_build(ii,e);ps<-rs[['target-predictions']]
 ok(eq(ps$p_full,1-p$p_full)&&eq(ps$p_reduced,1-p$p_reduced)&&identical(ps$paired,p$paired),'global slot swap complements probabilities')
 for(m in al_models<-c('full','reduced','primary','overall'))ok(eq(ps[[paste0(m,'_logloss')]],p[[paste0(m,'_logloss')]],1e-9)&&eq(ps[[paste0(m,'_brier')]],p[[paste0(m,'_brier')]],1e-9),paste('slot swap preserves',m,'losses'))
 ok(identical(rs[['final-conclusions']][c('loss_label','calibration_label')],fc[c('loss_label','calibration_label')]),'slot swap preserves labels')
 # One common four-method mask and independent stable losses.
 mask<-p$complete&p$full_ready&p$reduced_ready&is.finite(p$p_full)&is.finite(p$p_reduced)&is.finite(p$p_a_primary)&is.finite(p$p_a_overall)
 ok(identical(p$paired,mask)&&sum(mask)==sum(p$complete),'single common mask')
 for(m in al_models){prob<-p[[switch(m,primary='p_a_primary',overall='p_a_overall',paste0('p_',m))]];y<-p$y
  ok(all(is.na(p[[paste0(m,'_logloss')]][!mask]))&&eq(p[[paste0(m,'_logloss')]][mask],-ifelse(y[mask]==1,log(prob[mask]),log1p(-prob[mask])))&&eq(p[[paste0(m,'_brier')]][mask],(prob[mask]-y[mask])^2),paste('independent',m,'losses'))}
 ok(identical(e$sq_loss(c(-1000,1000),c(1,0)),c(1000,1000))&&all(is.finite(e$sq_loss(c(-1000,1000),c(0,1)))),'stable extreme-logit loss')
 ok(identical(e$sq_probability_loss(c(0,1),c(0,1)),c(0,0))&&identical(e$sq_probability_loss(c(0,1),c(1,0)),c(Inf,Inf)),'exact boundary Elo loss flagged as nonfinite, not clipped')
 ok(identical(e$sq_accuracy(c(.5,.5,.6,.4),c(1,0,1,0)),c(.5,.5,1,1)),'accuracy half-credit ties')
 q<-p;q$p_full[which(q$complete)[1]]<-Inf;q$full_logloss[which(q$paired)[1]]<-Inf
 ok(all(al_conclude(q,folds,st[st$record_type=='DELETION',],st[st$record_type=='CALIBRATION',],i$required,e)$loss_label==al_unresolved),'nonfinite prediction or loss cannot escape')
 ok(all(fc$paired==vapply(fc$tour,function(t)sum(p$paired&p$tour==t),0L))&&all(fc$targets==vapply(fc$tour,function(t)sum(p$tour==t),0L)),'all-target and paired counts')
 sc<-r[['paired-scores']];cells<-sc[sc$record_type=='CELL_INVENTORY',];ok(nrow(cells)==nrow(i$cells)&&cells$targets[cells$group=='WTA:blocked']==0&&cells$paired[cells$group=='WTA:blocked']==0,'zero-target cell retained, not manufactured')
 fr<-sc[sc$record_type=='FAILURE'&sc$level=='tour'&sc$stratum=='ALL',];ok(all(vapply(c('ATP','WTA'),function(t)sum(fr$reason_count[fr$tour==t&fr$model=='full'])==sum(!is.finite(p$p_full[p$tour==t])),TRUE)),'every nonprediction reason counted')
 # Calibration support gates and the exhaustive descriptive comparison truth table.
 z<-p[p$tour=='ATP'&p$paired,];z$eta_s08<-z$eta_full;z$p_s08<-z$p_full
 ok(e$sq_calibration(z[1:99,],'s08')$status=='CALIBRATION_NOT_ASSESSABLE','calibration minimum sample')
 v<-z;v$batch_key<-'one';ok(grepl('INSUFFICIENT_BATCHES',e$sq_calibration(v,'s08')$reasons),'calibration batches')
 v<-z;v$y<-0;ok(grepl('INSUFFICIENT_CLASSES',e$sq_calibration(v,'s08')$reasons),'calibration classes')
 v<-z;v$p_s08[1]<-0;ok(grepl('INVALID_OR_CONSTANT_LOGIT',e$sq_calibration(v,'s08')$reasons),'boundary probability not removed')
 v<-z;v$eta_s08<-0;ok(grepl('INVALID_OR_CONSTANT_LOGIT',e$sq_calibration(v,'s08')$reasons),'constant logit')
 v<-z;v$p_a_primary[1]<-1;ok(e$sq_calibration(v,'primary')$status=='CALIBRATION_NOT_ASSESSABLE','Elo boundary not assessable')
 levels<-c(.1,.2,.3);cases<-expand.grid(aa=levels,sa=levels,aw=levels,sw=levels,support=c('ok','candidate','elo'),stringsAsFactors=FALSE)
 for(j in seq_len(nrow(cases))){x<-cases[j,]
  cal<-data.frame(tour=rep(c('ATP','WTA'),each=2),model=rep(c('full','primary'),2),status='DESCRIPTIVE_ONLY',intercept=c(if(j%%2)-x$aa else x$aa,.2,x$aw,-.2),slope=c(1+x$sa,1+.2,1-x$sw,1-.2),stringsAsFactors=FALSE)
  if(x$support=='candidate')cal$status[3]<-'CALIBRATION_NOT_ASSESSABLE';if(x$support=='elo')cal$intercept[2]<-NA
  better<-function(a,s)a<=.2&&s<=.2&&(a<.2||s<.2)
  want<-if(x$support=='ok'&&better(x$aa,x$sa)&&better(x$aw,x$sw))'DESCRIPTIVELY_BETTER_CALIBRATION_THAN_SURFACE_ELO' else 'CALIBRATION_COMPARISON_UNRESOLVED'
  ok(al_calibration_label(cal,'full')[1]==want,'calibration truth table')}
 base<-data.frame(tour=rep(c('ATP','WTA'),each=2),model=rep(c('full','primary'),2),status='DESCRIPTIVE_ONLY',intercept=c(.1,.2,.1,.2),slope=c(1.1,1.2,1.1,1.2),stringsAsFactors=FALSE)
 ok(al_calibration_label(base[-3,],'full')[1]=='CALIBRATION_COMPARISON_UNRESOLVED'&&al_calibration_label(base[0,],'full')[1]=='CALIBRATION_COMPARISON_UNRESOLVED','missing tour calibration unresolved')
 v<-base;v$slope[1]<-Inf;ok(al_calibration_label(v,'full')[1]=='CALIBRATION_COMPARISON_UNRESOLVED','nonfinite calibration unresolved')
 tc<-st[st$record_type=='CALIBRATION'&st$level=='tour'&st$stratum=='ALL',];ok(all(vapply(c('full','reduced'),function(m)identical(unique(fc$calibration_label[fc$candidate==m]),al_calibration_label(tc,m)[1]),TRUE)),'calibration label uses tour-level common-mask fits')
 # Every deletion independently removes the batch or the player from either slot, without refitting.
 de<-st[st$record_type=='DELETION',]
 for(j in seq_len(nrow(de))){x<-de[j,];z<-p[p$tour==x$tour&p$paired,];rm<-if(x$deletion=='BATCH')z$batch_key==x$key else z$player_a_id==x$key|z$player_b_id==x$key
  field<-paste0('difference_',x$comparison,'_',x$metric);value<-mean(z[[field]][!rm]);ok(sum(rm)==x$deleted&&sum(!rm)==x$retained&&eq(value,x$deleted_difference,1e-14)&&identical(x$sign_reversal,mean(z[[field]])*value<0),'exact deletion')}
 ok(setequal(unique(de$comparison),names(e$af$af_pairs))&&all(c('BATCH','PLAYER') %in% de$deletion),'five comparisons, batch and player deletions')
 # Exhaustive loss-label cases against an independent statement of the frozen rule.
 grid<-expand.grid(a=c(-1,0,1),b=c(-1,0,1),c=c(-1,0,1),d=c(-1,0,1),gate=c(FALSE,TRUE),complete=c(FALSE,TRUE),deletion=c('same','tie','reverse','one_reverse','one_tie','missing','empty'),stringsAsFactors=FALSE)
 for(j in seq_len(nrow(grid))){x<-grid[j,];d<-as.numeric(x[1:4])*c(.01,.02,.03,.04)
  bv<-switch(x$deletion,same=rep(d,3),tie=rep(0,12),reverse=-rep(d,3),one_reverse=c(-d[1],rep(d,3)[-1]),one_tie=c(0,rep(d,3)[-1]),missing=c(NA,rep(d,3)[-1]),empty=numeric())
  ev<-x$gate&&x$complete&&length(bv)&&all(is.finite(bv))
  want<-if(ev&&all(d<0)&&all(bv<0))'CANDIDATE_HAS_LOWER_LOCKED_TEST_LOSS_THAN_SURFACE_ELO' else if(ev&&all(d>0)&&all(bv>0))'SURFACE_ELO_HAS_LOWER_LOCKED_TEST_LOSS_THAN_CANDIDATE' else al_unresolved
  got<-al_loss_label(d,x$gate,bv,x$complete);ok(got[1]==want&&nzchar(got[2]),'loss truth table')}
 for(d in list(c(-1,-1,NA,-1),c(-1,-1,-Inf,-1),c(-1,-1,-1),numeric()))ok(al_loss_label(d,TRUE,rep(-1,4))[1]==al_unresolved,'missing/nonfinite comparison')
 # Integration positive controls: uninformative Elo loses; oracle Elo with hidden information wins.
 rn<-al_build(al_fixture(21,'noise'),e)[['final-conclusions']];ok(all(rn$loss_label=='CANDIDATE_HAS_LOWER_LOCKED_TEST_LOSS_THAN_SURFACE_ELO'),'favorable candidate positive control')
 ro<-al_build(al_fixture(21,'oracle'),e)[['final-conclusions']];ok(all(ro$loss_label=='SURFACE_ELO_HAS_LOWER_LOCKED_TEST_LOSS_THAN_CANDIDATE'),'favorable Elo positive control')
 ii<-i;ii$fin<-ii$fin[ii$fin$tour=='ATP',];ii$required<-ii$required[ii$required$tour=='ATP',];ii$cells<-ii$cells[ii$cells$tour=='ATP',]
 ok(all(al_build(ii,e)[['final-conclusions']]$loss_label==al_unresolved),'missing tour unresolved')
 # Ledger chain: carried untouched states pass; a reset to 1500 fails closed.
 led<-data.frame(tour='ATP',source_tourney_date=c('20210111','20250113','20250113'),batch_key=c('ATP|20210111','ATP|20250113','ATP|20250113'),component='OVERALL',surface='ALL',player_id=c('P1','P1','P2'),before=c(1500,1516,1500),prior_matches=c(0,1,0),batch_matches=1,accumulated_delta=c(16,-16,16),after=c(1516,1500,1516),after_matches=c(1,2,1),stringsAsFactors=FALSE)
 ok(e$ae_terminal(led,e)$states$ATP$g[['P1']]==1500,'carried state chain');led$before[2]<-1500;led$after[2]<-1484;fail(e$ae_terminal(led,e),'chain reconciliation failed')
 # Atomic installation and independent byte-identical synthetic rerun.
 tmp<-tempfile('al-test-');dir.create(tmp);orig<-e$sq_ignored;e$sq_ignored<-function(dir)NULL
 fail(e$sq_install(r,file.path(tmp,'interrupted'),function(stage)stop('interrupted')),'interrupted');ok(!dir.exists(file.path(tmp,'interrupted')),'no partial installation')
 fail(e$sq_install(r,file.path(tmp,'corrupt'),function(stage)cat('x',file=file.path(stage,'stability.csv'),append=TRUE)),'Staged bytes changed')
 e$sq_install(r,file.path(tmp,'release'));files<-file.path(tmp,'release',paste0(al_outputs,'.csv'));hashes<-vapply(files,al_hash,'');e$sq_install(r,file.path(tmp,'release'));ok(identical(hashes,vapply(files,al_hash,'')),'identical reinstall retained')
 q<-r;q[[2]]$p_full[1]<-.1;fail(e$sq_install(q,file.path(tmp,'release')),'Existing release differs');ok(identical(hashes,vapply(files,al_hash,'')),'existing release preserved');e$sq_ignored<-orig
 script<-file.path(tmp,'rerun.R');writeLines(c("source('R/run_2025_locked_evaluation.R')",paste('al_fixture <-',paste(deparse(al_fixture),collapse='\n')),"e<-al_helpers();r<-al_build(al_fixture(),e)",
  sprintf("for(k in names(r))write.table(r[[k]],file.path(%s,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\\n',qmethod='double')",deparse(tmp))),script)
 ok(system2(file.path(R.home('bin'),'Rscript'),shQuote(script))==0,'independent process')
 ok(identical(unname(hashes),unname(vapply(file.path(tmp,paste0(al_outputs,'.csv')),al_hash,''))),'six independent byte-identical synthetic files')
 unlink(tmp,recursive=TRUE);al_verify();ok(TRUE,'inputs unchanged after synthetic checks')
 cat(n,'Phase 2AL synthetic checks passed\n')
} else if(mode=='installed'){
 files<-file.path(al_dir,paste0(al_outputs,'.csv'));ok(all(file.exists(files)),'six installed outputs');e$sq_ignored()
 installed<-vapply(files,al_hash,'');tmp<-tempfile('al-installed-');dir.create(tmp);script<-file.path(tmp,'rerun.R')
 writeLines(c("source('R/run_2025_locked_evaluation.R')","r<-run_2025_locked_evaluation(FALSE)",sprintf("for(k in names(r))write.table(r[[k]],file.path(%s,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\\n',qmethod='double')",deparse(tmp))),script)
 ok(system2(file.path(R.home('bin'),'Rscript'),shQuote(script))==0,'independent real-input process')
 ok(identical(unname(installed),unname(vapply(file.path(tmp,paste0(al_outputs,'.csv')),al_hash,''))),'independent byte-identical locked rerun');unlink(tmp,recursive=TRUE)
 rd<-function(k)read.csv(file.path(al_dir,paste0(k,'.csv')),stringsAsFactors=FALSE,check.names=FALSE)
 p<-rd('target-predictions');folds<-rd('fold-readiness');st<-rd('stability');fc<-rd('final-conclusions')
 ok(nrow(p)==1878&&!anyDuplicated(p$match_key)&&nrow(folds)==36&&length(unique(folds$batch_key))==18,'1878 targets and 18 required batches')
 mask<-p$complete&p$full_ready&p$reduced_ready&is.finite(p$p_full)&is.finite(p$p_reduced)&is.finite(p$p_a_primary)&is.finite(p$p_a_overall);ok(identical(p$paired,mask),'installed common mask')
 for(m in c('full','reduced','primary','overall')){prob<-p[[switch(m,primary='p_a_primary',overall='p_a_overall',paste0('p_',m))]];y<-p$y
  ok(eq(p[[paste0(m,'_logloss')]][mask],-ifelse(y[mask]==1,log(prob[mask]),log1p(-prob[mask])),1e-9)&&eq(p[[paste0(m,'_brier')]][mask],(prob[mask]-y[mask])^2,1e-12),paste('installed',m,'losses'))}
 for(j in seq_len(nrow(fc))){x<-fc[j,];z<-p[p$tour==x$tour&p$paired,];pair<-paste0(x$candidate,'_primary')
  ok(eq(mean(z[[paste0('difference_',pair,'_logloss')]]),x$candidate_minus_primary_logloss,1e-12)&&eq(mean(z[[paste0('difference_',pair,'_brier')]]),x$candidate_minus_primary_brier,1e-12),'installed paired differences')}
 for(cand in c('full','reduced')){x<-fc[fc$candidate==cand,];b<-st[st$record_type=='DELETION'&st$deletion=='BATCH'&st$comparison==paste0(cand,'_primary'),]
  got<-al_loss_label(c(rbind(x$candidate_minus_primary_logloss,x$candidate_minus_primary_brier)),all(x$all_required_gates_pass&x$all_numerical_checks_pass),b$deleted_difference,all(x$batch_deletions_evaluable))
  ok(all(x$loss_label==got[1]),paste('installed loss label',cand))
  ok(all(x$calibration_label==al_calibration_label(st[st$record_type=='CALIBRATION'&st$level=='tour'&st$stratum=='ALL',],cand)[1]),paste('installed calibration label',cand))}
 al_verify();ok(TRUE,'inputs unchanged');cat(n,'Phase 2AL installed-output checks passed\n')
} else stop('Unknown test mode')
