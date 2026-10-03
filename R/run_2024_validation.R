# Phase 2AF: frozen 2024 whole-batch validation; base R only.
af_dir <- 'data/pilot/2024-validation'
af_outputs <- c('fold-readiness','target-predictions','model-fits','paired-scores','stability','selection-decision')
af_models <- c('full','reduced','primary','overall')
af_pairs <- list(reduced_full=c('reduced','full'),full_primary=c('full','primary'),full_overall=c('full','overall'),reduced_primary=c('reduced','primary'),reduced_overall=c('reduced','overall'))
af_pins <- c(
 'R/run_m05_ablation.R'='474d30e45deac623056cae45c419a33a2ce3535701a2e3fa436124149287fdbf',
 'R/run_s08_paired_evaluation.R'='14cb2e7daf66a7190735bc96d13768fa059c9954dbbf316d2ed284719cd50d5e',
 'data/pilot/event-batch-membership/candidate-history-membership.csv'='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
 'data/pilot/event-batch-membership/summary.csv'='04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246',
 'data/pilot/event-batch-membership/target-batches.csv'='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
 'data/pilot/s08-batched-histories/slot-history-aggregates.csv'='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
 'data/pilot/s08-batched-histories/summary.csv'='7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4',
 'data/pilot/s08-batched-histories/target-s08-features.csv'='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
 'data/pilot/source-defined-cohort-admission/cell-coverage.csv'='b50f5126e6e29ca6ee214e87fec660a8e96d7dc7d088df56b898cfb075abb91c',
 'data/pilot/source-defined-cohort-admission/cohort-membership.csv'='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
 'data/pilot/source-defined-cohort-admission/field-availability.csv'='260fa9bdfb7c486749f639d9358b5732bd42008236523cc49f5086fc5a1b4468',
 'data/pilot/source-defined-cohort-admission/input-provenance.csv'='ed39e3e7907271786b3b97f3dada42c1b5384e4f03a45e5fab2e48fb0b2325f5',
 'data/pilot/source-defined-cohort-admission/row-dispositions.csv'='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6',
 'data/pilot/source-defined-cohort-admission/summary.csv'='b2e9953f1eeb0a9f28ae092fb1720b089bb15ce96ff5de6275be69068670d950',
 'data/pilot/surface-elo-baseline/rating-update-ledger.csv'='a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c',
 'data/pilot/surface-elo-baseline/summary.csv'='9cf5eb133ef8a213881250c855ddb98a96bf16209f82d21e6d7c6bc35e927469',
 'data/pilot/surface-elo-baseline/target-elo-probabilities.csv'='93505d79faf5e17eb3646c101ea6b21e8035e2acddbfe55c27f3236bb6c2392c',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'docs/m05-ablation-results.md'='64bb423b55550235f060718347792b7fc7e151dea2c77fe3130f861d185917ae',
 'docs/s08-forecast-evaluation-protocol.md'='0cb6c8ebf5bb7c2028817fa4f6f8052f35eaa761ee9fdf63c45790cc0f4b99de',
 'docs/s08-paired-evaluation-results.md'='e5f0caab97d1338cbf88b6912213d5c72b2372208f340e3d5375faa7b2954b94',
 'data/pilot/2024-source-admission-v2/provenance.csv'='430074a631dd7d7b3d9d459741dbb1c482ce0424839f219504994a57dc2c593b',
 'data/pilot/2024-source-admission-v2/row-dispositions.csv'='ed80d3f9a5c8c7b4dbf41b1fb49d1567fd9e275a9f5e6330dcb340971bd508a2',
 'data/pilot/2024-source-admission-v2/membership.csv'='81c3f1079dd5af0dd0bc7cc4d8d055ab2d685c055e509073e8248e29cdf2ae83',
 'data/pilot/2024-source-admission-v2/cell-summary.csv'='38b375114ced0de355c873fbe5179200a049abb9765dc8a5b49595e54d467d16',
 'data/pilot/2024-source-admission-v2/field-availability.csv'='e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1',
 'data/pilot/2024-source-admission-v2/summary.csv'='2f0c7f3d1b48891f6cf1761c68428f88d3d9539029992dc4ffa2477cc88abfa5',
 'R/build_2024_event_batch_membership.R'='896726adc2137a4a06fa0af334eec6d2d744a34d772510a9574d6f52e6c11ee7',
 'data/pilot/2024-event-batch-membership/target-batches.csv'='d5baad965f192dc4a0c7fe93cbfded6bd3be9c0f7caa9c58cfdefb1499442162',
 'data/pilot/2024-event-batch-membership/candidate-history-membership.csv'='c3d1e7c570ac9791517117044abe00faee9ae6b1b53f5fc5a5f43b78074f9fe0',
 'data/pilot/2024-event-batch-membership/summary.csv'='661334dfa6697454ccbdb421323cea39829e488fc0c9d9d360c3525efe7bd435',
 'docs/2024-s08-batched-history-aggregation.md'='bd1a6c34bef4cea5c146418876449a333958548d72fc8d3d0b6d1eae9f99f5c5',
 'data/pilot/2024-s08-batched-history-aggregation/slot-history-aggregates.csv'='18d8f6f9a1bf2422e1a083479d00be64336cabb0d5f3303a5ca962f22942e65d',
 'data/pilot/2024-s08-batched-history-aggregation/target-s08-features.csv'='712cb89b5acd85af54306019a4c160171d9cd443777cba5587ad3e8975e7b883',
 'data/pilot/2024-s08-batched-history-aggregation/summary.csv'='ca293aa88c380ebcdc5d0e70c5b6404a23e1207339343360164638208fbde61f',
 'R/build_2024_surface_elo_baseline.R'='15cccc7581ff05dc2660b3a21df4d166e50a6a7d8979aead9b94c4d7b2216cab',
 'docs/2024-surface-elo-baseline-audit.md'='6107eeb427faea6e024ace1bf7c7d010b30adaf44e85343d9410c87c0f1e449f',
 'data/pilot/2024-surface-elo-baseline/target-elo-probabilities.csv'='3a945231e7e24bb866904958469b551662be6ec0bdb2b449a462720090127eca',
 'data/pilot/2024-surface-elo-baseline/rating-update-ledger.csv'='6c46ac9a9ff93b5bf00cf9f6b959215426f7d9b7206c43373588a885a7c099a6',
 'data/pilot/2024-surface-elo-baseline/summary.csv'='21931bd5b74e7e6d2c64ac7ab9da14d91b47032e24d5a50490fe6d82ef85ce35')
af_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
af_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
af_verify <- function(pins=af_pins)af_need(all(vapply(names(pins),af_hash,'')==pins),'STOP: frozen protocol/input mismatch')
af_import <- function(path,allow,e){found<-character();for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow){eval(x,e);found<-c(found,as.character(x[[2]]))};af_need(setequal(found,allow),'Helper allowlist mismatch')}
af_helpers <- function(){
 af_verify();e<-new.env(parent=globalenv())
 af_import('R/run_s08_paired_evaluation.R',c('sq_metrics','sq_convention','sq_chronology','sq_need','sq_hash','sq_read','sq_sort','sq_bind','sq_join','sq_prepare','sq_fit_diagnostics','sq_glm','sq_collinearity','sq_readiness','sq_eta','sq_loss','sq_probability_loss','sq_accuracy','sq_groups','sq_calibration','sq_ignored','sq_install'),e)
 af_import('R/run_m05_ablation.R',c('mw_metrics','mw_fit_diagnostics','mw_glm','mw_collinearity','mw_readiness','mw_eta'),e)
 e$sq_dir<-af_dir;e$sq_outputs<-af_outputs;e$sq_verify<-af_verify;e$sq_ignored()
 e$af_prepare<-af_prepare;environment(e$af_prepare)<-e;e
}
# Phase 2R preparation checks unchanged except the separately admitted year/cardinality.
af_prepare <- function(x,f,e,m,d,expected_n=1901L) {
 sq_need(nrow(x)==expected_n&&!anyDuplicated(x$match_id),'Target accounting mismatch')
 x<-sq_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
 sq_need(all(x$tour %in% c('ATP','WTA'))&&all(x$season=='2024'),'Unauthorized tour/year')
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
af_load <- function(e=af_helpers()){
 af_verify() # All pins and the immutable protocol pass before any outcome read.
 read<-e$sq_read
 dev<-e$sq_prepare(read('data/pilot/event-batch-membership/target-batches.csv'),read('data/pilot/s08-batched-histories/target-s08-features.csv'),read('data/pilot/surface-elo-baseline/target-elo-probabilities.csv'),read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))
 val<-e$af_prepare(read('data/pilot/2024-event-batch-membership/target-batches.csv'),read('data/pilot/2024-s08-batched-history-aggregation/target-s08-features.csv'),read('data/pilot/2024-surface-elo-baseline/target-elo-probabilities.csv'),read('data/pilot/2024-source-admission-v2/membership.csv'),read('data/pilot/2024-source-admission-v2/row-dispositions.csv'))
 af_need(sum(dev$complete)==2026&&sum(val$complete)==1783&&length(unique(val$batch_key))==20,'Frozen completeness/batch mismatch')
 dev$cohort<-'DEVELOPMENT';val$cohort<-'VALIDATION_2024'
 for(name in c('dev','val')){z<-get(name);z$match_key<-paste(z$cohort,z$match_id,sep='|');assign(name,z)}
 list(dev=dev,val=val)
}
af_walk <- function(i,e,fit_full=e$sq_readiness,fit_reduced=e$mw_readiness){
 fields<-c('match_id','cohort','match_key','tour','season','batch_key','source_tourney_date','cell_id','event','surface','round','player_a_id','player_b_id','complete','s08_stratum',e$sq_metrics,paste0(e$sq_metrics,'_reason'),'p_a_primary','p_a_overall','y')
 dev<-e$sq_sort(i$dev[fields],c('tour','source_tourney_date','cell_id','match_key'));x<-e$sq_sort(i$val[fields],c('tour','source_tourney_date','cell_id','match_key'))
 af_need(!anyDuplicated(c(dev$match_key,x$match_key))&&all(c(dev$y,x$y) %in% c(0,1)),'Duplicate key/invalid outcome')
 for(model in c('full','reduced')){x[[paste0('eta_',model)]]<-x[[paste0('p_',model)]]<-NA_real_;x[[paste0(model,'_ready')]]<-FALSE;x[[paste0(model,'_reason')]]<-''}
 folds<-list();fits<-list()
 for(tour in sort(unique(x$tour),method='radix'))for(date in sort(unique(x$source_tourney_date[x$tour==tour]),method='radix')){
  target<-which(x$tour==tour&x$source_tourney_date==date);eligible<-target[x$complete[target]]
  trdev<-dev[dev$tour==tour&dev$complete&dev$source_tourney_date<date,fields];trval<-x[x$tour==tour&x$complete&x$source_tourney_date<date,fields]
  train<-e$sq_sort(rbind(trdev,trval),c('tour','source_tourney_date','cell_id','match_key'))
  af_need(all(train$source_tourney_date<date)&&all(train$tour==tour),'Training cutoff/tour violation')
  for(model in c('full','reduced')){
   metrics<-if(model=='full')e$sq_metrics else e$mw_metrics
   f<-if(model=='full')fit_full(train) else fit_reduced(train);r<-f$record
   meta<-list(tour=tour,season='2024',batch_key=paste(tour,date,sep='|'),source_tourney_date=date,event=paste(sort(unique(x$event[target])),collapse=';'),surface=paste(sort(unique(x$surface[target])),collapse=';'),model=model)
   r<-c(meta,r,list(targets=length(target),complete_targets=length(eligible),training_development_n=nrow(trdev),training_validation_n=nrow(trval),training_max_label=if(nrow(train))max(train$source_tourney_date) else NA_character_,training_keys=paste(train$match_key,collapse=';'),target_keys=paste(x$match_key[eligible],collapse=';')))
   x[[paste0(model,'_ready')]][target]<-r$ready
   if(r$ready&&length(eligible)){
    eta<-e$sq_eta(x[eligible,metrics],f$fit,f$sd);prob<-plogis(eta);valid<-is.finite(eta)&is.finite(prob)&prob>=0&prob<=1
    x[[paste0('eta_',model)]][eligible[valid]]<-eta[valid];x[[paste0('p_',model)]][eligible[valid]]<-prob[valid]
   }
   for(j in target){why<-character();if(!x$complete[j])why<-c(why,'INCOMPLETE_S08',paste(e$sq_metrics[!is.finite(as.numeric(x[j,e$sq_metrics]))],unlist(x[j,paste0(e$sq_metrics[!is.finite(as.numeric(x[j,e$sq_metrics]))],'_reason')]),sep=':'));if(!r$ready)why<-c(why,strsplit(r$reasons,';',fixed=TRUE)[[1]]);if(x$complete[j]&&r$ready&&!is.finite(x[[paste0('p_',model)]][j]))why<-c(why,'NONFINITE_TARGET_PREDICTION');x[[paste0(model,'_reason')]][j]<-if(length(why))paste(why,collapse=';') else 'PREDICTED'}
   r$predictions<-sum(is.finite(x[[paste0('p_',model)]][target]));folds[[length(folds)+1L]]<-r
   fits[[length(fits)+1L]]<-c(list(record_type='FORECAST',level='batch_key',group=r$batch_key,stratum='ALL',intercept=0),r[setdiff(names(r),c('training_keys','target_keys'))])
  }
 }
 valid<-function(p)is.finite(p)&p>=0&p<=1
 x$paired<-x$complete&x$full_ready&x$reduced_ready&valid(x$p_full)&valid(x$p_reduced)&valid(x$p_a_primary)&valid(x$p_a_overall)
 x$comparison_reason<-ifelse(x$paired,'PAIRED',paste0('full:',x$full_reason,'|reduced:',x$reduced_reason))
 for(model in af_models){p<-x[[switch(model,primary='p_a_primary',overall='p_a_overall',paste0('p_',model))]];x[[paste0('boundary_',model)]]<-is.finite(p)&p %in% c(0,1)}
 list(p=x,folds=e$sq_bind(folds),fits=e$sq_bind(fits))
}
af_score <- function(p,e){
 ii<-which(p$paired)
 for(model in af_models){prob<-p[[switch(model,primary='p_a_primary',overall='p_a_overall',paste0('p_',model))]]
  for(metric in c('logloss','brier','accuracy'))p[[paste0(model,'_',metric)]]<-NA_real_
  p[[paste0(model,'_logloss')]][ii]<-if(model %in% c('full','reduced'))e$sq_loss(p[[paste0('eta_',model)]][ii],p$y[ii]) else e$sq_probability_loss(prob[ii],p$y[ii])
  p[[paste0(model,'_brier')]][ii]<-(prob[ii]-p$y[ii])^2;p[[paste0(model,'_accuracy')]][ii]<-e$sq_accuracy(prob[ii],p$y[ii])
 }
 for(pair in names(af_pairs))for(metric in c('logloss','brier'))p[[paste0('difference_',pair,'_',metric)]]<-p[[paste0(af_pairs[[pair]][1],'_',metric)]]-p[[paste0(af_pairs[[pair]][2],'_',metric)]]
 p
}
af_summarize <- function(p,e){
 rows<-list();cal<-list()
 for(g in e$sq_groups(p)){
  z<-p[g$ii,,drop=FALSE];sc<-z[z$paired,,drop=FALSE];meta<-g[setdiff(names(g),'ii')]
  common<-c(meta,list(targets=nrow(z),complete=sum(z$complete),paired=nrow(sc),batches=length(unique(z$batch_key)),paired_batches=length(unique(sc$batch_key)),paired_players=length(unique(c(sc$player_a_id,sc$player_b_id)))))
  for(model in af_models){prob<-z[[switch(model,primary='p_a_primary',overall='p_a_overall',paste0('p_',model))]]
   r<-c(list(record_type='SCORES',model=model,reason='ALL'),common,list(predictions=sum(is.finite(prob)),boundary_predictions=sum(z[[paste0('boundary_',model)]])))
   for(metric in c('logloss','brier','accuracy'))r[[metric]]<-if(nrow(sc))mean(sc[[paste0(model,'_',metric)]]) else NA_real_
   rows[[length(rows)+1L]]<-r
   cz<-sc;if(model %in% c('full','reduced')){cz$eta_s08<-cz[[paste0('eta_',model)]];cz$p_s08<-cz[[paste0('p_',model)]]}
   cc<-e$sq_calibration(cz,if(model %in% c('full','reduced'))'s08' else model)
   cal[[length(cal)+1L]]<-c(list(record_type='CALIBRATION',model=model),meta,list(training_n=nrow(sc),training_batches=length(unique(sc$batch_key))),cc)
  }
  for(pair in names(af_pairs)){r<-c(list(record_type='COMPARISON',model=pair,reason='ALL'),common);for(metric in c('logloss','brier'))r[[metric]]<-if(nrow(sc))mean(sc[[paste0('difference_',pair,'_',metric)]]) else NA_real_;rows[[length(rows)+1L]]<-r}
  for(model in c('full','reduced'))for(reason in sort(unique(p[[paste0(model,'_reason')]]),method='radix'))if(reason!='PREDICTED')rows[[length(rows)+1L]]<-c(list(record_type='FAILURE',model=model,reason=reason,reason_count=sum(z[[paste0(model,'_reason')]]==reason)),common)
 }
 list(scores=e$sq_bind(rows),cal=e$sq_bind(cal))
}
af_deletions <- function(p,e){
 rows<-list()
 for(tour in c('ATP','WTA')){z<-p[p$tour==tour&p$paired,,drop=FALSE]
  for(kind in c('BATCH','PLAYER')){
   keys<-if(kind=='BATCH')sort(unique(z$batch_key),method='radix') else sort(unique(c(z$player_a_id,z$player_b_id)),method='radix');if(!length(keys))keys<-'NO_SCORED_ROWS'
   for(key in keys){del<-if(kind=='BATCH')z$batch_key==key else z$player_a_id==key|z$player_b_id==key;keep<-z[!del,,drop=FALSE]
    for(pair in names(af_pairs))for(metric in c('logloss','brier')){
     field<-paste0('difference_',pair,'_',metric);base<-if(nrow(z))mean(z[[field]]) else NA_real_;value<-if(nrow(keep))mean(keep[[field]]) else NA_real_
     rows[[length(rows)+1L]]<-list(tour=tour,deletion=kind,key=key,comparison=pair,metric=metric,deleted=sum(del),retained=nrow(keep),retained_batches=length(unique(keep$batch_key)),retained_players=length(unique(c(keep$player_a_id,keep$player_b_id))),base_difference=base,deleted_difference=value,change=value-base,sign_reversal=if(is.finite(base)&&is.finite(value))base*value<0 else NA,status=if(nrow(keep)&&is.finite(value)&&is.finite(base))'CONDITIONAL_SCORE_INFLUENCE' else 'UNEVALUABLE_DELETION')
    }
   }
  }
 };e$sq_bind(rows)
}
af_decide <- function(d,all_gates,batch_values,comparisons_complete=TRUE){
 if(!isTRUE(all_gates)||!isTRUE(comparisons_complete)||length(d)!=4||any(!is.finite(d))||!length(batch_values)||any(!is.finite(batch_values)))return('SELECTION_UNRESOLVED')
 if(all(d>0)&&all(batch_values>=0))return('FULL_S08_PREFERRED_FROZEN_2025_FORECASTING_CANDIDATE')
 if(all(d<0)&&all(batch_values<=0))return('REDUCED_PREFERRED_FROZEN_2025_FORECASTING_CANDIDATE')
 'SELECTION_UNRESOLVED'
}
af_selection <- function(p,folds,stability,e){
 d<-unlist(lapply(c('ATP','WTA'),function(t) vapply(c('logloss','brier'),function(m){z<-p[p$tour==t&p$paired,];if(nrow(z))mean(z[[paste0('difference_reduced_full_',m)]]) else NA_real_},0.0)))
 batch<-stability[stability$deletion=='BATCH'&stability$comparison=='reduced_full',]
 expected<-unique(p[c('tour','batch_key')]);gates<-nrow(folds)==2*nrow(expected)&&!anyDuplicated(folds[c('model','batch_key')])&&setequal(folds$batch_key,expected$batch_key)&&all(folds$ready)
 numerical<-all(vapply(af_models,function(m)all(is.finite(p[[paste0(m,'_logloss')]][p$paired]))&&all(is.finite(p[[paste0(m,'_brier')]][p$paired])),TRUE))
 numerical<-numerical&&all(vapply(c('full','reduced'),function(m){q<-p[[paste0('p_',m)]][p$complete];eta<-p[[paste0('eta_',m)]][p$complete];all(is.finite(q)&q>=0&q<=1&is.finite(eta))},TRUE))&&all(vapply(c('p_a_primary','p_a_overall'),function(m)all(is.finite(p[[m]])&p[[m]]>=0&p[[m]]<=1),TRUE))
 complete<-all(c('ATP','WTA') %in% p$tour[p$paired])&&nrow(batch)==2*nrow(expected)&&setequal(batch$key,expected$batch_key)&&all(batch$status=='CONDITIONAL_SCORE_INFLUENCE')
 decision<-af_decide(d,gates&&numerical,batch$deleted_difference,complete)
 full<-folds[folds$model=='full',];m05<-nrow(full)==nrow(expected)&&all(full$ready)&&all(is.finite(full$beta_dM05))&&all(full$beta_dM05<0)
 rows<-list()
 for(tour in c('ATP','WTA')){z<-p[p$tour==tour,];f<-full[full$tour==tour,];b<-batch[batch$tour==tour,];sc<-z[z$paired,]
  rows[[length(rows)+1L]]<-list(tour=tour,decision=decision,all_required_gates_pass=gates,all_numerical_checks_pass=numerical,batch_deletions_evaluable=complete,required_batches=length(unique(z$batch_key)),full_pass=sum(f$ready),reduced_pass=sum(folds$ready[folds$tour==tour&folds$model=='reduced']),targets=nrow(z),complete=sum(z$complete),paired=nrow(sc),difference_logloss=if(nrow(sc))mean(sc$difference_reduced_full_logloss) else NA_real_,difference_brier=if(nrow(sc))mean(sc$difference_reduced_full_brier) else NA_real_,batch_reversals=sum(b$sign_reversal,na.rm=TRUE),batch_ties=sum(b$deleted_difference==0,na.rm=TRUE),m05_negative=sum(is.finite(f$beta_dM05)&f$beta_dM05<0),m05_nonnegative=sum(is.finite(f$beta_dM05)&f$beta_dM05>=0),m05_missing=sum(!is.finite(f$beta_dM05)),m05_direction_requirement=if(m05)'NEGATIVE_DIRECTION_REQUIREMENT_SATISFIED_ONLY' else 'M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED',selection_reasons=if(!gates||!numerical||!complete)'FAILED_REQUIRED_GATE_OR_UNEVALUABLE_COMPARISON' else if(any(d==0))'FULL_SAMPLE_TIE' else if(!(all(d>0)||all(d<0)))'MIXED_TOUR_OR_METRIC_DIRECTIONS' else if(any(batch$sign_reversal))'BATCH_DIRECTION_REVERSAL' else 'PRESPECIFIED_PREFERENCE',interpretation='NO_FINAL_FOUR_FACTORS_QUALIFICATION')
 };e$sq_bind(rows)
}
af_build <- function(i,e=af_helpers()){
 w<-af_walk(i,e);p<-af_score(w$p,e);s<-af_summarize(p,e);stability<-af_deletions(p,e);decision<-af_selection(p,w$folds,stability,e)
 out<-setNames(list(w$folds,p,e$sq_bind(list(w$fits,s$cal)),s$scores,stability,decision),af_outputs)
 for(k in names(out)){out[[k]]$version<-'2AF-1.0.0';out[[k]]$convention<-e$sq_convention;out[[k]]$verified_chronology_decision<-e$sq_chronology;out[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'};out
}
run_2024_validation <- function(write_outputs=TRUE){e<-af_helpers();i<-af_load(e);r<-af_build(i,e);if(write_outputs)e$sq_install(r);r}
if(sys.nframe()==0L){r<-run_2024_validation();print(r[['selection-decision']],row.names=FALSE)}
