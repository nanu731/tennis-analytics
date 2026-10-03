# Phase 2AC 1.0.0. Offline candidate membership only; no count/outcome aggregation.
ac_dir <- 'data/pilot/2024-event-batch-membership'
ac_outputs <- c('target-batches','candidate-history-membership','summary')
ac_pins <- c(
 'DATA_LICENSE.md'='f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880',
 'R/build_event_batch_membership.R'='e42d4aa6879550c71f665c5b2dd2dd8c0499a89d8223d1e4f5537cc325030146',
 'R/test_event_batch_membership.R'='94cead42d03c7c5f584a7803f27a8950e4148cc19977d717349d51f8c0846e51',
 'data/pilot/event-batch-membership/candidate-history-membership.csv'='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
 'data/pilot/event-batch-membership/summary.csv'='04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246',
 'data/pilot/event-batch-membership/target-batches.csv'='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
 'data/pilot/source-defined-cohort-admission/cohort-membership.csv'='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
 'data/pilot/source-defined-cohort-admission/row-dispositions.csv'='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'docs/event-batch-membership-audit.md'='9ffc26c83c91a295a4f79352ae326eeb7a56700976b398560175650b24c07a4a',
 'docs/source-label-event-batching-decision.md'='7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c',
 'R/release_2024_source_admission_v2.R'='f09f026e56b58b020a530c3126ab8172e44843003d2d55ff03ce34dbf9404854',
 'R/test_2024_source_admission_v2.R'='0b66e735876c3e714cc76eddfff77c59daa1b5250be0f243901151d34e82b4c1',
 'docs/2024-source-admission-v2.md'='0e80d6c8e6f2f98a6ec80369ab1b669646db88b546b24b453e0ac8f6e658c27d',
 'data/pilot/2024-source-admission-v2/provenance.csv'='430074a631dd7d7b3d9d459741dbb1c482ce0424839f219504994a57dc2c593b',
 'data/pilot/2024-source-admission-v2/row-dispositions.csv'='ed80d3f9a5c8c7b4dbf41b1fb49d1567fd9e275a9f5e6330dcb340971bd508a2',
 'data/pilot/2024-source-admission-v2/membership.csv'='81c3f1079dd5af0dd0bc7cc4d8d055ab2d685c055e509073e8248e29cdf2ae83',
 'data/pilot/2024-source-admission-v2/cell-summary.csv'='38b375114ced0de355c873fbe5179200a049abb9765dc8a5b49595e54d467d16',
 'data/pilot/2024-source-admission-v2/field-availability.csv'='e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1',
 'data/pilot/2024-source-admission-v2/summary.csv'='2f0c7f3d1b48891f6cf1761c68428f88d3d9539029992dc4ffa2477cc88abfa5')
ac_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
ac_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
ac_verify <- function(pins=ac_pins) {
 ac_need(all(vapply(names(pins),ac_hash,'')==pins),'Frozen input missing or changed')
}
ac_helpers <- function() {
 ac_verify();e<-new.env(parent=globalenv())
 allow<-c('ebm_need','ebm_hash','ebm_read','ebm_sort','ebm_label_valid','ebm_summarize','ebm_install','ebm_ignored','ebm_convention','ebm_chronology')
 found<-character()
 for(x in parse('R/build_event_batch_membership.R'))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow) {
  eval(x,e);found<-c(found,as.character(x[[2]]))
 }
 ac_need(setequal(found,allow),'Pure helper allowlist mismatch')
 e$ebm_outputs<-ac_outputs;e$ebm_dir<-ac_dir;e$ebm_verify<-ac_verify;e
}
ac_read_inputs <- function(e=ac_helpers()) {
 e$ebm_ignored();ac_verify()
 list(dm=e$ebm_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
 dd=e$ebm_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'),
 vm=e$ebm_read('data/pilot/2024-source-admission-v2/membership.csv'),
 vd=e$ebm_read('data/pilot/2024-source-admission-v2/row-dispositions.csv'))
}
ac_prepare <- function(m,d,cohort,e,expected=NULL) {
 # Phase 2M linkage/label safeguards, extended only to a separately qualified 2024 cohort.
 fields<-c('match_id','audit_tour','audit_season','cell_id','event','surface','round',
 'player_a_id','player_b_id','audit_source_path','audit_source_row','count_origin')
 ac_need(all(fields %in% names(m))&&all(c(fields,'tourney_date','membership','completion_status','quarantined','exclusion_reasons') %in% names(d)),'Required frozen schema missing')
 ac_need(nrow(m)>0&&!anyNA(m$match_id)&&all(nzchar(m$match_id))&&!anyDuplicated(m$match_id),'Missing/duplicate cohort IDs')
 if(!is.null(expected))ac_need(nrow(m)==expected,'Frozen cohort size changed')
 inc<-d[d$membership=='INCLUDED',,drop=FALSE]
 ac_need(!anyDuplicated(inc$match_id)&&setequal(m$match_id,inc$match_id),'Frozen membership/exclusion mismatch')
 dd<-inc[match(m$match_id,inc$match_id),]
 for(k in fields)ac_need(identical(m[[k]],dd[[k]]),paste('Frozen linkage mismatch',k))
 ac_need(all(dd$completion_status=='source_reported_normal'&dd$quarantined=='FALSE'&dd$exclusion_reasons==''),'Excluded status in admitted universe')
 seasons<-if(cohort=='DEVELOPMENT')c('ATP 2023','WTA 2021','WTA 2023') else c('ATP 2024','WTA 2024')
 ac_need(all(paste(m$audit_tour,m$audit_season) %in% seasons),'Unauthorized tour/season')
 ac_need(all(grepl('^[0-9]+$',m$player_a_id)&grepl('^[0-9]+$',m$player_b_id))&&all(m$player_a_id!=m$player_b_id),'Invalid player slots')
 ac_need(all(vapply(seq_len(nrow(m)),function(i)order(c(m$player_a_id[i],m$player_b_id[i]),method='radix')[1]==1,TRUE)),'Nonneutral frozen slots')
 panel<-d[d$cell_id %in% m$cell_id,,drop=FALSE]
 ac_need(all(e$ebm_label_valid(panel$tourney_date)),'Missing/invalid source label')
 ac_need(all(substr(panel$tourney_date,1,4)==panel$audit_season),'Source label/season conflict')
 for(cell in unique(m$cell_id)) {
  z<-panel[panel$cell_id==cell,]
  ac_need(length(unique(z$tourney_date))==1&&length(unique(z$audit_tour))==1,'Conflicting labels/tour within event cell')
 }
 x<-m[fields];names(x)[names(x)=='audit_tour']<-'tour';names(x)[names(x)=='audit_season']<-'season'
 x$cohort<-cohort;x$match_key<-paste(cohort,x$match_id,sep='|')
 x$source_tourney_date<-dd$tourney_date;x$batch_key<-paste(x$tour,x$source_tourney_date,sep='|')
 e$ebm_sort(x,c('tour','source_tourney_date','cell_id','match_key'))
}
ac_membership <- function(target,pool,e) {
 rows<-vector('list',2*nrow(target));k<-0L
 for(i in seq_len(nrow(target)))for(slot in c('a','b')) {
  player<-target[[paste0('player_',slot,'_id')]][i]
  prior<-which(pool$tour==target$tour[i]&pool$source_tourney_date<target$source_tourney_date[i]&
   (pool$player_a_id==player|pool$player_b_id==player))
  n<-length(prior);k<-k+1L
  rows[[k]]<-data.frame(target_match_id=target$match_id[i],target_key=target$match_key[i],target_cohort=target$cohort[i],
   target_slot=slot,player_id=player,tour=target$tour[i],target_batch_key=target$batch_key[i],
   target_source_date=target$source_tourney_date[i],target_cell=target$cell_id[i],
   target_event=target$event[i],target_surface=target$surface[i],
   prior_match_id=if(n)pool$match_id[prior] else '',prior_key=if(n)pool$match_key[prior] else '',
   prior_cohort=if(n)pool$cohort[prior] else '',prior_batch_key=if(n)pool$batch_key[prior] else '',
   prior_source_date=if(n)pool$source_tourney_date[prior] else '',prior_cell=if(n)pool$cell_id[prior] else '',
   prior_count_origin=if(n)pool$count_origin[prior] else '',
   prior_player_slot=if(n)ifelse(pool$player_a_id[prior]==player,'a','b') else '',
   membership_status=if(n)'ELIGIBLE_EARLIER_BATCH' else 'EMPTY_HISTORY',
   empty_reason=if(n)'' else 'NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT',
   empty_detail=if(n)'' else if(target$source_tourney_date[i]==min(pool$source_tourney_date[pool$tour==target$tour[i]]))'TOUR_FIRST_OBSERVED_BATCH' else 'PLAYER_FIRST_OBSERVED_BATCH',
   stringsAsFactors=FALSE)
 }
 e$ebm_sort(do.call(rbind,rows),c('tour','target_source_date','target_cell','target_key','target_slot','prior_source_date','prior_key'))
}
ac_build <- function(dm,dd,vm,vd,e=ac_helpers(),production=TRUE) {
 dev<-ac_prepare(dm,dd,'DEVELOPMENT',e,if(production)2580L else NULL)
 x<-ac_prepare(vm,vd,'VALIDATION_2024',e,if(production)1901L else NULL)
 pool<-e$ebm_sort(rbind(dev,x),c('tour','source_tourney_date','cell_id','match_key'))
 ac_need(!anyDuplicated(pool$match_key),'Qualified key collision')
 for(tour in unique(x$tour))ac_need(all(dev$source_tourney_date[dev$tour==tour]<min(x$source_tourney_date[x$tour==tour])),'Development labels not strictly before validation')
 if(production)ac_need(length(unique(dev$cell_id))==30&&length(unique(x$cell_id))==20,'Frozen event-cell universe changed')
 h<-ac_membership(x,pool,e);links<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
 for(slot in c('a','b')) {
  for(cohort in c('ALL','DEVELOPMENT','VALIDATION_2024')) {
   use<-links$target_slot==slot;if(cohort!='ALL')use<-use&links$prior_cohort==cohort
   field<-switch(cohort,ALL='history_matches',DEVELOPMENT='development_matches',VALIDATION_2024='validation_matches')
   x[[paste0(slot,'_',field)]]<-as.integer(table(factor(links$target_key[use],levels=x$match_key)))
  }
  empty<-h[h$target_slot==slot&h$membership_status=='EMPTY_HISTORY',];idx<-match(x$match_key,empty$target_key)
  x[[paste0(slot,'_empty_reason')]]<-ifelse(is.na(idx),'',empty$empty_reason[idx])
  x[[paste0(slot,'_empty_detail')]]<-ifelse(is.na(idx),'',empty$empty_detail[idx])
 }
 ac_need(sum(x$a_history_matches+x$b_history_matches)==nrow(links),'Link accounting mismatch')
 ac_need(length(unique(paste(h$target_key,h$target_slot)))==2*nrow(x)&&
 !anyDuplicated(paste(h$target_key,h$target_slot,h$prior_key)),'Slot/duplicate contribution mismatch')
 s<-e$ebm_summarize(x,h)
 for(i in seq_len(nrow(s))) {
  use<-switch(s$level[i],overall=rep(TRUE,nrow(x)),tour=x$tour==s$tour[i],
   season=x$tour==s$tour[i]&x$season==s$group[i],batch=x$batch_key==s$group[i],
   event=x$cell_id==s$group[i],surface=x$tour==s$tour[i]&x$surface==s$group[i])
  slots<-if(s$player_slot[i]=='ALL')c('a','b') else s$player_slot[i]
  depth<-unlist(x[use,paste0(slots,'_history_matches'),drop=FALSE],use.names=FALSE)
  s$median_memberships[i]<-median(depth)
  s$development_memberships[i]<-sum(unlist(x[use,paste0(slots,'_development_matches'),drop=FALSE]))
  s$validation_memberships[i]<-sum(unlist(x[use,paste0(slots,'_validation_matches'),drop=FALSE]))
 }
 r<-setNames(list(x,h,s),ac_outputs)
 for(k in names(r)) {
  r[[k]]$convention<-e$ebm_convention;r[[k]]$verified_chronology_decision<-e$ebm_chronology
  r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';r[[k]]$release_version<-'2AC-1.0.0'
 }
 r
}
ac_main <- function(write_outputs=TRUE) {
 e<-ac_helpers();inputs<-ac_read_inputs(e);r<-do.call(ac_build,c(inputs,list(e=e)))
 ac_verify();if(write_outputs)e$ebm_install(r,ac_dir);r
}
if(sys.nframe()==0L) {
 ac_need(length(commandArgs(trailingOnly=TRUE))==0L,'Offline runner takes no arguments')
 r<-ac_main();print(r[[3]][r[[3]]$level=='tour'&r[[3]]$player_slot=='ALL',])
}
