# Phase 2AD 1.0.0: base-R cumulative count aggregation; no model/rating.
ad_dir <- 'data/pilot/2024-s08-batched-history-aggregation'
ad_outputs <- c('slot-history-aggregates','target-s08-features','summary')
ad_pins <- c(
 'R/aggregate_s08_batch_histories.R'='aad5e2fb478657814a36c2dc2786d8068fba287bb96cec92a25b56426a1899ca',
 'R/test_s08_batch_histories.R'='5ec2addd502bb025882972b26328989e036e89c446f58e1722c5a0209b4ad183',
 'data/pilot/s08-batched-histories/slot-history-aggregates.csv'='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
 'data/pilot/s08-batched-histories/summary.csv'='7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4',
 'data/pilot/s08-batched-histories/target-s08-features.csv'='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'docs/s08-batched-history-aggregation.md'='1ac223d78c40705877db3e2810b2c507631d39043ac23d178aaee5586d4c75c2',
 'R/build_2024_event_batch_membership.R'='896726adc2137a4a06fa0af334eec6d2d744a34d772510a9574d6f52e6c11ee7',
 'R/test_2024_event_batch_membership.R'='aecdc8c506fe4c86439e73766bb3b16b5f2e057f0f1b3bc8a6a816ded2b96ffa',
 'docs/2024-event-batch-membership-audit.md'='7495ecbc4508980b1b4dc73f6ee22f1c786c284e4c703db3c24ca7c65736bf60',
 'data/pilot/2024-event-batch-membership/target-batches.csv'='d5baad965f192dc4a0c7fe93cbfded6bd3be9c0f7caa9c58cfdefb1499442162',
 'data/pilot/2024-event-batch-membership/candidate-history-membership.csv'='c3d1e7c570ac9791517117044abe00faee9ae6b1b53f5fc5a5f43b78074f9fe0',
 'data/pilot/2024-event-batch-membership/summary.csv'='661334dfa6697454ccbdb421323cea39829e488fc0c9d9d360c3525efe7bd435')
ad_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
ad_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
ad_verify <- function(pins=ad_pins)ad_need(all(vapply(names(pins),ad_hash,'')==pins),'Missing/changed Phase 2AD input')
ad_helpers <- function() {
 ad_verify();e<-new.env(parent=globalenv())
 import<-function(path,allow) {
  found<-character()
  for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow) {
   eval(x,e);found<-c(found,as.character(x[[2]]))
  }
  ad_need(setequal(found,allow),'Pure helper allowlist mismatch')
 }
 import('R/build_2024_event_batch_membership.R',c('ac_dir','ac_outputs','ac_pins','ac_need','ac_hash','ac_verify','ac_helpers','ac_read_inputs','ac_prepare','ac_membership','ac_build'))
 e$ac_verify()
 base<-e$ac_helpers()
 for(k in c('ebm_read','ebm_sort','ebm_convention','ebm_chronology'))e[[k]]<-base[[k]]
 import('R/aggregate_s08_batch_histories.R',c('s08_need','s08_hash','s08_metrics','s08_components','s08_counts','s08_pool','s08_summarize','s08_build','s08_ignored','s08_install'))
 # Phase 2AC exact validation replaces the historical Phase 2M-only validator.
 e$s08_validate_membership<-function(x,h,m,d,expected_n=NULL)list(x=x,h=h)
 e$s08_dir<-ad_dir;e$s08_outputs<-ad_outputs
 e$s08_verify<-ad_verify;e$ebm_verify<-e$ac_verify
 e
}
ad_read_inputs <- function(e=ad_helpers()) {
 e$s08_ignored();ad_verify();i<-e$ac_read_inputs()
 i$x<-e$ebm_read('data/pilot/2024-event-batch-membership/target-batches.csv')
 i$h<-e$ebm_read('data/pilot/2024-event-batch-membership/candidate-history-membership.csv')
 i
}
ad_chars <- function(d) {d[]<-lapply(d,as.character);rownames(d)<-NULL;d}
ad_validate <- function(i,e) {
 expected<-do.call(e$ac_build,c(i[c('dm','dd','vm','vd')],list(e=e$ac_helpers())))
 x<-e$ebm_sort(i$x,c('tour','source_tourney_date','cell_id','match_key'))
 h<-e$ebm_sort(i$h,c('tour','target_source_date','target_cell','target_key','target_slot','prior_source_date','prior_key'))
 ad_need(identical(ad_chars(x),ad_chars(expected[[1]])),'Frozen Phase 2AC targets differ')
 ad_need(identical(ad_chars(h),ad_chars(expected[[2]])),'Frozen Phase 2AC membership differs')
 list(x=x,h=h)
}
ad_count_inputs <- function(i,h) {
 # Only actual prior contributors reach count parsing; no target-only count is read.
 mf<-c('match_id','player_a_id','player_b_id','a_original_side')
 fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
 df<-c('match_id','membership','game_reconciliation','a_original_side','winner_id','loser_id',
 paste0('effective_w_',fields),paste0('effective_l_',fields))
 combine<-function(kind,fields) {
  a<-i[[paste0('d',kind)]][,fields];b<-i[[paste0('v',kind)]][,fields]
  a$match_id<-paste('DEVELOPMENT',a$match_id,sep='|')
  b$match_id<-paste('VALIDATION_2024',b$match_id,sep='|')
  rbind(a,b)
 }
 m<-combine('m',mf);d<-combine('d',df)
 keys<-sort(unique(h$prior_key[h$membership_status=='ELIGIBLE_EARLIER_BATCH']),method='radix')
 m<-m[match(keys,m$match_id),,drop=FALSE];d<-d[match(keys,d$match_id),,drop=FALSE]
 ad_need(!anyNA(m$match_id)&&!anyNA(d$match_id)&&!anyDuplicated(m$match_id),'Missing/duplicate count contributor')
 list(m=m,d=d)
}
ad_aggregate <- function(x,h,counts,e) {
 # Qualified keys are internal joins only; every original output ID is restored.
 original<-x$match_id;keys<-x$match_key
 xx<-x;xx$match_id<-xx$match_key
 hh<-h;hh$target_match_id<-hh$target_key;hh$prior_match_id<-hh$prior_key
 r<-e$s08_build(xx,hh,counts$m,counts$d)
 for(k in 1:2) {
  r[[k]]$match_key<-r[[k]]$match_id
  r[[k]]$match_id<-original[match(r[[k]]$match_key,keys)]
  ad_need(!anyNA(r[[k]]$match_id),'Output ID restoration failed')
  r[[k]]$cohort<-'VALIDATION_2024'
 }
 t<-r[[2]]
 t$reduced_components_defined<-complete.cases(t[c('dM03','dM11','dM12')])
 t$both_candidates_feature_complete<-t$all_s08_differences_defined
 r[[2]]<-t
 for(j in seq_len(nrow(r[[3]]))) {
  s<-r[[3]][j,]
  use<-switch(s$level,overall=rep(TRUE,nrow(t)),tour=t$tour==s$tour,
   season=t$tour==s$tour&t$season==s$group,batch_key=t$batch_key==s$group,
   cell_id=t$cell_id==s$group,surface=t$tour==s$tour&t$surface==s$group)
  r[[3]]$group_targets[j]<-sum(use)
  r[[3]]$full_s08_complete_targets[j]<-sum(t$all_s08_differences_defined[use])
  r[[3]]$reduced_component_complete_targets[j]<-sum(t$reduced_components_defined[use])
  r[[3]]$both_candidates_feature_complete_targets[j]<-sum(t$both_candidates_feature_complete[use])
 }
 for(k in names(r)) {
  r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';r[[k]]$release_version<-'2AD-1.0.0'
  r[[k]]$M05_canonical_name<-'Double-Fault Rate per Second-Serve Opportunity'
 }
 r
}
ad_build <- function(i,e=ad_helpers()) {
 checked<-ad_validate(i,e);counts<-ad_count_inputs(i,checked$h)
 r<-ad_aggregate(checked$x,checked$h,counts,e)
 ad_need(nrow(r[[1]])==3802&&nrow(r[[2]])==1901,'Target/slot accounting failure')
 ad_need(!anyDuplicated(paste(r[[1]]$match_key,r[[1]]$slot))&&!anyDuplicated(r[[2]]$match_key),'Duplicate target/slot')
 ad_need(sum(r[[1]]$history_matches)==101983,'Membership cardinality changed')
 ad_verify();e$ac_verify();r
}
ad_main <- function(write_outputs=TRUE) {
 e<-ad_helpers();r<-ad_build(ad_read_inputs(e),e)
 if(write_outputs)e$s08_install(r,ad_dir);r
}
if(sys.nframe()==0L) {
 ad_need(length(commandArgs(trailingOnly=TRUE))==0L,'Offline runner takes no arguments')
 r<-ad_main();print(r[[3]][r[[3]]$level=='tour'&r[[3]]$slot %in% c('ALL','difference'),1:16])
}
