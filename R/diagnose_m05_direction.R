# Phase 2T: frozen arithmetic and descriptive summaries only; no estimation.
md_version <- '1.0.0'
md_dir <- 'data/pilot/m05-direction-diagnostic'
md_outputs <- c('fold-diagnostics','target-diagnostics','group-summary','summary')
md_metrics <- c('dM03','dM05','dM11','dM12')
md_convention <- 'SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY'
md_chronology <- 'NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE'
md_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
md_hash <- function(p)if(!file.exists(p))'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
md_verify <- function(pins=md_pins)md_need(all(vapply(names(pins),md_hash,'')==pins),'Missing/changed diagnostic input')
md_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
md_num <- function(x)suppressWarnings(as.numeric(x))
md_near <- function(a,b)length(a)==length(b)&&all(is.na(a)==is.na(b))&&all(abs(a[is.finite(a)]-b[is.finite(a)])<1e-10)&&all(is.finite(a)==is.finite(b))
md_sort <- function(x,fields){x<-x[do.call(order,c(unname(x[fields]),list(method='radix'))),,drop=FALSE];rownames(x)<-NULL;x}
md_bind <- function(rows){fields<-unique(unlist(lapply(rows,names)));rows<-lapply(rows,function(r){for(k in setdiff(fields,names(r)))r[[k]]<-NA;r[fields]});x<-do.call(rbind,lapply(rows,as.data.frame,stringsAsFactors=FALSE));rownames(x)<-NULL;x}
md_ignored <- function(dir=md_dir){paths<-file.path(dir,paste0(md_outputs,'.csv'));got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE));md_need(setequal(paths,got),'Output location must already be ignored')}
md_load <- function(){md_ignored();md_verify();list(
 p=md_read('data/pilot/s08-paired-evaluation/target-predictions.csv'),
 f=md_read('data/pilot/s08-paired-evaluation/model-fits.csv'),
 r=md_read('data/pilot/s08-paired-evaluation/fold-readiness.csv'),
 features=md_read('data/pilot/s08-batched-histories/target-s08-features.csv'),
 s=md_read('data/pilot/s08-batched-histories/slot-history-aggregates.csv'),
 h=md_read('data/pilot/event-batch-membership/candidate-history-membership.csv'),
 m=md_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
 d=md_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))}
md_components <- function(df,svpt,first){den<-svpt-first;md_need(all(is.finite(c(df,svpt,first)))&&all(c(df,svpt,first)>=0)&&all(c(df,svpt,first)==floor(c(df,svpt,first)))&&all(den>=df),'Invalid own count components');cbind(df=df,opportunities=den)}
md_reconstruct <- function(p,s,h,m,d){
 md_need(!anyDuplicated(m$match_id)&&setequal(m$match_id,p$match_id),'Membership universe')
 m<-m[match(p$match_id,m$match_id),];md_need(!anyDuplicated(d$match_id[d$match_id %in% p$match_id]),'Duplicate disposition')
 md_need(setequal(d$match_id[d$membership=='INCLUDED'],p$match_id),'Frozen exclusions differ');d<-d[match(p$match_id,d$match_id),]
 for(k in c('player_a_id','player_b_id'))md_need(identical(p[[k]],m[[k]])&&identical(m[[k]],d[[k]]),'Identity conflict')
 md_need(identical(m$a_original_side,d$a_original_side)&&all(m$a_original_side %in% c('winner','loser')),'Outcome orientation')
 md_need(all(p$y==as.integer(m$a_original_side=='winner'))&&all(d$game_reconciliation=='PASS'),'Outcome/count eligibility conflict')
 md_need(all(m$player_a_id==ifelse(m$a_original_side=='winner',d$winner_id,d$loser_id))&&all(m$player_b_id==ifelse(m$a_original_side=='winner',d$loser_id,d$winner_id)),'Count owner differs')
 pieces<-list()
 for(slot in c('a','b')){
  win<-if(slot=='a')m$a_original_side=='winner' else m$a_original_side=='loser'
  own<-function(field)ifelse(win,md_num(d[[paste0('effective_w_',field)]]),md_num(d[[paste0('effective_l_',field)]]))
  v<-md_components(own('df'),own('svpt'),own('1stIn'))
  pieces[[slot]]<-data.frame(key=paste(p$match_id,slot,sep='|'),player_id=p[[paste0('player_',slot,'_id')]],df=v[,1],opportunities=v[,2],stringsAsFactors=FALSE)
 }
 counts<-do.call(rbind,pieces);rownames(counts)<-NULL
 skey<-paste(s$match_id,s$slot,sep='|');md_need(!anyDuplicated(skey)&&setequal(skey,counts$key),'Slot universe')
 q<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',];keys<-paste(q$target_match_id,q$target_slot,sep='|')
 md_need(!anyDuplicated(paste(keys,q$prior_match_id,sep='|')),'Duplicate prior contribution')
 pi<-match(q$prior_match_id,p$match_id);ti<-match(q$target_match_id,p$match_id)
 md_need(!anyNA(c(pi,ti))&&all(p$tour[pi]==p$tour[ti])&&all(p$source_tourney_date[pi]<p$source_tourney_date[ti]),'History cutoff/tour failure')
 ci<-match(paste(q$prior_match_id,q$prior_player_slot,sep='|'),counts$key)
 md_need(!anyNA(ci)&&all(counts$player_id[ci]==q$player_id),'Prior count ownership failure')
 si<-match(keys,skey);md_need(!anyNA(si)&&all(s$player_id[si]==q$player_id),'Target player ownership failure')
 pooled<-rowsum(as.matrix(counts[ci,c('df','opportunities')]),keys,reorder=TRUE);n<-table(keys)
 ii<-match(skey,rownames(pooled));expected<-pooled[ii,,drop=FALSE];depth<-as.integer(n[match(skey,names(n))]);depth[is.na(depth)]<-0L
 md_need(md_near(md_num(s$M05_num),expected[,1])&&md_near(md_num(s$M05_den),expected[,2]),'Pooled ownership/denominator mismatch')
 md_need(identical(as.integer(s$history_matches),depth),'Prior-match depth mismatch')
 rates<-expected[,1]/expected[,2];rates[depth==0|expected[,2]==0]<-NA_real_
 md_need(md_near(md_num(s$M05_rate),rates),'Pooled M05 formula mismatch')
 md_need(sum(depth)==nrow(q),'History contribution accounting')
 list(slots=s,contributions=nrow(q),empty=sum(depth==0))
}
md_prepare <- function(p,f,r,features,s,h,m,d){
 p<-md_sort(p,c('tour','source_tourney_date','cell_id','match_id'))
 md_need(nrow(p)==2580&&!anyDuplicated(p$match_id)&&all(p$season %in% c('2021','2023')),'Frozen target scope')
 md_need(all(p$convention==md_convention&p$verified_chronology_decision==md_chronology),'Sensitivity labels')
 for(k in c(md_metrics,'y','eta_s08','p_s08'))p[[k]]<-md_num(p[[k]])
 p$complete<-p$complete=='TRUE';p$paired<-p$paired=='TRUE'
 md_need(sum(p$paired)==1278&&all(is.finite(as.matrix(p[p$paired,md_metrics]))),'Scored target count/features')
 md_need(!anyDuplicated(features$match_id)&&setequal(features$match_id,p$match_id),'Feature universe')
 features<-features[match(p$match_id,features$match_id),]
 for(k in c('tour','season','batch_key','cell_id','player_a_id','player_b_id'))md_need(identical(p[[k]],features[[k]]),'Feature metadata conflict')
 for(k in md_metrics)md_need(md_near(p[[k]],md_num(features[[k]])),'Frozen predictor conflict')
 rec<-md_reconstruct(p,s,h,m,d);skey<-paste(s$match_id,s$slot,sep='|')
 for(slot in c('a','b')){
  ss<-s[match(paste(p$match_id,slot,sep='|'),skey),]
  md_need(identical(ss$player_id,p[[paste0('player_',slot,'_id')]])&&identical(ss$batch_key,p$batch_key),'Slot context mismatch')
  p[[paste0(slot,'_df')]]<-md_num(ss$M05_num);p[[paste0(slot,'_opportunities')]]<-md_num(ss$M05_den)
  p[[paste0(slot,'_depth')]]<-as.integer(ss$history_matches);p[[paste0(slot,'_M05')]]<-md_num(ss$M05_rate)
  md_need(md_near(p[[paste0(slot,'_M05')]],md_num(features[[paste0(slot,'_M05')]])),'Slot feature mismatch')
 }
 md_need(md_near(p$dM05,p$a_M05-p$b_M05),'Difference ownership mismatch')
 p$min_opportunities<-pmin(p$a_opportunities,p$b_opportunities);p$min_depth<-pmin(p$a_depth,p$b_depth)
 f<-f[f$record_type=='FORECAST'&f$ready=='TRUE',];f<-md_sort(f,c('tour','source_tourney_date'))
 md_need(nrow(f)==18&&!anyDuplicated(f$batch_key)&&setequal(f$batch_key,p$batch_key[p$paired]),'18 ready folds required')
 rr<-r[match(f$batch_key,r$batch_key),];md_need(!anyNA(rr$batch_key)&&all(rr$ready=='TRUE'),'Fold readiness disagreement')
 for(k in c('training_n','training_batches','class_0','class_1',paste0('sd_',md_metrics),paste0('beta_',md_metrics)))md_need(md_near(md_num(f[[k]]),md_num(rr[[k]])),paste('Frozen coefficient/readiness conflict:',k))
 for(k in c(paste0('sd_',md_metrics),paste0('beta_',md_metrics),'intercept'))f[[k]]<-md_num(f[[k]])
 md_need(all(f$intercept==0),'Forecast intercept changed')
 list(p=p,f=f,r=rr,contributions=rec$contributions,empty=rec$empty)
}
md_cor <- function(a,b,method='pearson'){if(length(a)<2||any(!is.finite(c(a,b)))||sd(a)==0||sd(b)==0)NA_real_ else cor(a,b,method=method)}
md_distribution <- function(x,prefix){x<-x[is.finite(x)];v<-if(length(x))c(mean=mean(x),min=min(x),q25=unname(quantile(x,.25)),median=median(x),q75=unname(quantile(x,.75)),max=max(x)) else setNames(rep(NA_real_,6),c('mean','min','q25','median','q75','max'));as.list(setNames(v,paste0(prefix,'_',names(v))))}
md_stats <- function(z){
 n<-nrow(z);r<-list(n=n,class_0=sum(z$y==0),class_1=sum(z$y==1),association_status=if(n>=2&&length(unique(z$y))==2&&sd(z$dM05)>0)'DEFINED' else 'INSUFFICIENT_OR_CONSTANT',
  M05_class0_mean=if(any(z$y==0))mean(z$dM05[z$y==0]) else NA_real_,M05_class1_mean=if(any(z$y==1))mean(z$dM05[z$y==1]) else NA_real_,
  M05_y_pearson=md_cor(z$dM05,z$y),M05_y_spearman=md_cor(z$dM05,z$y,'spearman'))
 r$class_mean_difference<-r$M05_class1_mean-r$M05_class0_mean
 for(k in c('dM03','dM11','dM12'))for(method in c('pearson','spearman'))r[[paste0('M05_',k,'_',method)]]<-md_cor(z$dM05,z[[k]],method)
 for(slot in c('a','b')){
  r[[paste0(slot,'_pooled_df')]]<-sum(z[[paste0(slot,'_df')]])
  r[[paste0(slot,'_pooled_opportunities')]]<-sum(z[[paste0(slot,'_opportunities')]])
  r[[paste0(slot,'_pooled_rate')]]<-if(r[[paste0(slot,'_pooled_opportunities')]]>0)r[[paste0(slot,'_pooled_df')]]/r[[paste0(slot,'_pooled_opportunities')]] else NA_real_
  for(k in c('df','opportunities','depth','M05'))r<-c(r,md_distribution(z[[paste0(slot,'_',k)]],paste0(slot,'_',k)))
 }
 for(k in c('dM05','min_opportunities','min_depth'))r<-c(r,md_distribution(z[[k]],k))
 r$abs_difference_opportunity_spearman<-md_cor(abs(z$dM05),z$min_opportunities,'spearman')
 r$abs_difference_depth_spearman<-md_cor(abs(z$dM05),z$min_depth,'spearman')
 if('M05_contribution' %in% names(z)){
  r<-c(r,md_distribution(z$M05_contribution,'contribution'));r$absolute_contribution_sum<-sum(abs(z$M05_contribution))
  r$abs_contribution_opportunity_spearman<-md_cor(abs(z$M05_contribution),z$min_opportunities,'spearman')
  r$abs_contribution_depth_spearman<-md_cor(abs(z$M05_contribution),z$min_depth,'spearman')
  if(n){ii<-which(abs(z$M05_contribution)==max(abs(z$M05_contribution)));r$max_abs_contribution_ids<-paste(sort(z$match_id[ii]),collapse=';');r$max_contribution_min_opportunity<-min(z$min_opportunities[ii]);r$max_contribution_min_depth<-min(z$min_depth[ii])}
 }
 r
}
md_contributions <- function(z,f){
 sd0<-unlist(f[paste0('sd_',md_metrics)],use.names=FALSE);beta<-unlist(f[paste0('beta_',md_metrics)],use.names=FALSE)
 md_need(all(is.finite(sd0)&sd0>0)&&all(is.finite(beta)),'Invalid frozen parameters')
 components<-sweep(sweep(as.matrix(z[md_metrics]),2,sd0,'/'),2,beta,'*')
 z$M05_beta<-beta[2];z$M05_training_sd<-sd0[2];z$M05_standardized<-z$dM05/sd0[2];z$M05_contribution<-components[,2]
 z$reconstructed_eta<-rowSums(components);z$other_frozen_contribution<-rowSums(components[,-2,drop=FALSE]);z
}
md_profiles <- function(z,scope,key){
 out<-list()
 for(variable in c('min_opportunities','min_depth')){
  values<-sort(unique(z[[variable]]));n<-nrow(z);totald<-sum(abs(z$dM05));totalc<-sum(abs(z$M05_contribution))
  for(v in values){eq<-z[[variable]]==v;le<-z[[variable]]<=v
   out[[length(out)+1L]]<-list(record_type='EXACT_VALUE_CUMULATIVE',tour=z$tour[1],scope=scope,group=key,variable=variable,value=v,n=sum(eq),cumulative_n=sum(le),
    cumulative_match_share=sum(le)/n,absolute_difference_sum=sum(abs(z$dM05[eq])),absolute_contribution_sum=sum(abs(z$M05_contribution[eq])),
    cumulative_absolute_difference_share=if(totald>0)sum(abs(z$dM05[le]))/totald else NA_real_,
    cumulative_absolute_contribution_share=if(totalc>0)sum(abs(z$M05_contribution[le]))/totalc else NA_real_)
  }
 }
 out
}
md_build <- function(i){
 p<-i$p;folds<-list();targets<-list();groups<-list();summary<-list();training_ids<-character()
 for(j in seq_len(nrow(i$f))){
  f<-i$f[j,];rr<-i$r[j,];ids<-strsplit(rr$training_match_ids,';',fixed=TRUE)[[1]]
  tr<-p[match(ids,p$match_id),];expected<-p$match_id[p$tour==f$tour&p$source_tourney_date<f$source_tourney_date&p$complete]
  md_need(!anyNA(tr$match_id)&&!anyDuplicated(ids)&&setequal(ids,expected),'Training membership differs')
  tr<-md_sort(tr,c('tour','source_tourney_date','cell_id','match_id'));training_ids<-union(training_ids,tr$match_id)
  md_need(nrow(tr)==as.integer(f$training_n),'Training cardinality mismatch')
  for(k in md_metrics)md_need(md_near(sd(tr[[k]]),f[[paste0('sd_',k)]]),'Training-only SD mismatch')
  tr<-md_contributions(tr,f);z<-md_contributions(p[p$batch_key==f$batch_key&p$paired,],f)
  md_need(md_near(z$reconstructed_eta,z$eta_s08)&&md_near(plogis(z$reconstructed_eta),z$p_s08),'Frozen linear predictor reconstruction failure')
  z$abs_difference_rank<-rank(-abs(z$dM05),ties.method='average');z$abs_contribution_rank<-rank(-abs(z$M05_contribution),ties.method='average')
  z$opportunity_rank<-rank(z$min_opportunities,ties.method='average');z$depth_rank<-rank(z$min_depth,ties.method='average');targets[[j]]<-z
  row<-c(list(tour=f$tour,batch_key=f$batch_key,source_tourney_date=f$source_tourney_date,event=f$event,surface=f$surface,season=f$season,
   coefficient=f$beta_dM05,training_sd=f$sd_dM05,raw_difference_multiplier=f$beta_dM05/f$sd_dM05,training_n=nrow(tr),target_n=nrow(z)),
   setNames(md_stats(tr),paste0('training_',names(md_stats(tr)))),setNames(md_stats(z),paste0('target_',names(md_stats(z)))))
  prev<-if(j>1&&i$f$tour[j-1]==f$tour)i$f[j-1,] else NULL
  row$coefficient_change<-if(is.null(prev))NA_real_ else f$beta_dM05-prev$beta_dM05
  row$sd_change<-if(is.null(prev))NA_real_ else f$sd_dM05-prev$sd_dM05
  folds[[j]]<-row
  for(sample in c('TRAINING','TARGET')){
   zz<-if(sample=='TRAINING')tr else z
   for(level in c('ALL','season','surface','event')){
    values<-if(level=='ALL')'ALL' else sort(unique(p[[level]][p$tour==f$tour]),method='radix')
    for(value in values){sub<-if(level=='ALL')zz else zz[zz[[level]]==value,,drop=FALSE]
     groups[[length(groups)+1L]]<-c(list(tour=f$tour,fold=f$batch_key,sample=sample,level=level,group=value,match_share=if(nrow(zz))nrow(sub)/nrow(zz) else NA_real_,
      coefficient=f$beta_dM05,training_sd=f$sd_dM05),md_stats(sub))
    }
   }
  }
  summary<-c(summary,md_profiles(z,'FOLD',f$batch_key))
 }
 targets<-md_sort(do.call(rbind,targets),c('tour','source_tourney_date','cell_id','match_id'))
 md_need(nrow(targets)==1278&&!anyDuplicated(targets$match_id)&&setequal(targets$match_id,p$match_id[p$paired]),'1278 scored targets not preserved')
 for(tour in c('ATP','WTA')){
  z<-targets[targets$tour==tour,];summary[[length(summary)+1L]]<-c(list(record_type='TOUR_TARGET',tour=tour,scope='TOUR',group=tour),md_stats(z))
  tr<-p[p$tour==tour&p$match_id %in% training_ids,];summary[[length(summary)+1L]]<-c(list(record_type='UNIQUE_TRAINING',tour=tour,scope='TOUR',group=tour),md_stats(tr))
  summary<-c(summary,md_profiles(z,'TOUR',tour))
 }
 out<-setNames(list(md_bind(folds),targets,md_bind(groups),md_bind(summary)),md_outputs)
 for(k in names(out)){out[[k]]$version<-md_version;out[[k]]$convention<-md_convention;out[[k]]$verified_chronology_decision<-md_chronology;out[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';out[[k]]$M05_interpretation<-'LOWER_IS_BETTER'}
 out
}
md_install <- function(r,dir=md_dir,before_install=function(stage)NULL){
 md_ignored(dir);md_verify();md_need(identical(names(r),md_outputs),'Output scope mismatch')
 stage<-tempfile('.m05-stage-',tmpdir=dirname(dir));md_need(dir.create(stage),'Cannot stage outputs');on.exit(unlink(stage,recursive=TRUE),add=TRUE)
 for(k in names(r))write.table(r[[k]],file.path(stage,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
 paths<-file.path(stage,paste0(md_outputs,'.csv'));hash<-vapply(paths,md_hash,'');before_install(stage)
 md_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0)&&identical(hash,vapply(paths,md_hash,'')),'Staging failed integrity');md_verify()
 if(dir.exists(dir)){md_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing output scope differs');md_need(identical(unname(hash),unname(vapply(file.path(dir,basename(paths)),md_hash,''))),'Existing output differs; preserve release')} else md_need(file.rename(stage,dir),'Atomic installation failed')
 invisible(r)
}
diagnose_m05_direction <- function(write_outputs=TRUE){i<-do.call(md_prepare,md_load());r<-md_build(i);if(write_outputs)md_install(r);r}

md_pins <- c(
`AGENTS.override.md`='7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b',
`docs/s08-forecast-evaluation-protocol.md`='0cb6c8ebf5bb7c2028817fa4f6f8052f35eaa761ee9fdf63c45790cc0f4b99de',
`docs/s08-paired-evaluation-results.md`='e5f0caab97d1338cbf88b6912213d5c72b2372208f340e3d5375faa7b2954b94',
`docs/dependence-aware-uncertainty-feasibility.md`='7d4a12a596859eb78079484a147754acb5ff6b47d6b8744fd18c93a9c91ce73b',
`docs/s08-batched-history-aggregation.md`='1ac223d78c40705877db3e2810b2c507631d39043ac23d178aaee5586d4c75c2',
`data/pilot/s08-paired-evaluation/fold-readiness.csv`='b419e1883269201a70fa78bd0aa398d56b0a18456147f587780edf719f280ed9',
`data/pilot/s08-paired-evaluation/target-predictions.csv`='d7d7b774c1ce7c4f303820208fbed196f38fe058b0d1ad763c02e0f6880ea433',
`data/pilot/s08-paired-evaluation/model-fits.csv`='46300fa049333fb36d0eec96ec6d51669f9f6e8742e36be0fe231cd94cfc9726',
`data/pilot/s08-paired-evaluation/paired-scores.csv`='c2d419f8cfadd1a91da5bc4380b7d29d55af1fae1ea1b04f8da2846431790b4e',
`data/pilot/s08-paired-evaluation/stability.csv`='08176292218802df34225159fabe984ac0abbbacf7909aa5b928a882570519ad',
`data/pilot/s08-batched-histories/target-s08-features.csv`='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
`data/pilot/s08-batched-histories/slot-history-aggregates.csv`='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
`data/pilot/event-batch-membership/candidate-history-membership.csv`='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
`data/pilot/source-defined-cohort-admission/cohort-membership.csv`='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
`data/pilot/source-defined-cohort-admission/row-dispositions.csv`='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6'
)
if(sys.nframe()==0L){r<-diagnose_m05_direction();print(r[[1]][,c('tour','batch_key','coefficient','training_sd','training_M05_y_pearson','training_class_mean_difference')],row.names=FALSE)}
