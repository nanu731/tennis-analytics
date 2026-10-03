# Phase 2AK: frozen count histories and synchronous Elo, offline base R; no fitting/scoring.
ak_dir <- 'data/pilot/2025-feature-elo-construction'
ak_outputs <- c('slot-history-aggregates','target-s08-features','target-elo-probabilities','rating-update-ledger','summary')
ak_pins <- c(
 'DATA_LICENSE.md'='f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880',
 'R/acquire_audit_2025_source.R'='3023a66c69c0a86ae9f7e90c2663d8080bfb3001b91113fe73d8d7f63ce51d80',
 'R/aggregate_2024_s08_batch_histories.R'='d99a1b0f8ac9bc6742828093b9a2c88d4809a0d1616c6b60edf5df843866aa2c',
 'R/aggregate_s08_batch_histories.R'='aad5e2fb478657814a36c2dc2786d8068fba287bb96cec92a25b56426a1899ca',
 'R/build_2024_event_batch_membership.R'='896726adc2137a4a06fa0af334eec6d2d744a34d772510a9574d6f52e6c11ee7',
 'R/build_2024_surface_elo_baseline.R'='15cccc7581ff05dc2660b3a21df4d166e50a6a7d8979aead9b94c4d7b2216cab',
 'R/build_2025_event_batch_membership.R'='f2cb2a21b0758f7e6394ab913b12f4022c2407fe2c73f300b60a051e4a9b9c69',
 'R/build_event_batch_membership.R'='e42d4aa6879550c71f665c5b2dd2dd8c0499a89d8223d1e4f5537cc325030146',
 'R/build_surface_elo_baseline.R'='a0bb7ac4193a5a9a9f3c0e9843958e7cccb2c1196f22216dc345c743c1a45117',
 'R/release_2024_source_admission_v2.R'='f09f026e56b58b020a530c3126ab8172e44843003d2d55ff03ce34dbf9404854',
 'R/test_2024_event_batch_membership.R'='aecdc8c506fe4c86439e73766bb3b16b5f2e057f0f1b3bc8a6a816ded2b96ffa',
 'R/test_2024_s08_batch_histories.R'='cd28f0df911018855c00e32dfeb3b69b202d3389862d2e2f40b5aac38fb7ec3c',
 'R/test_2024_source_admission_v2.R'='0b66e735876c3e714cc76eddfff77c59daa1b5250be0f243901151d34e82b4c1',
 'R/test_2024_surface_elo_baseline.R'='6c81b76b937bb5a7eb7bb6d3ddf498e315f0ee2429a277a5e1986f35149cfa68',
 'R/test_2025_event_batch_membership.R'='88a3223abc2689febbb8457081570d0a33208dc7456950a17214aac179e6476d',
 'R/test_2025_source_admission.R'='7589b46386827e810dab9edc19485d62659f102e84a845b224ab0d9fab926a6b',
 'R/test_event_batch_membership.R'='94cead42d03c7c5f584a7803f27a8950e4148cc19977d717349d51f8c0846e51',
 'R/test_s08_batch_histories.R'='5ec2addd502bb025882972b26328989e036e89c446f58e1722c5a0209b4ad183',
 'R/test_surface_elo_baseline.R'='3c8485d760642ef261ca8deae19f8f5143ae2911acfbdedc6d9e1ed4866105df',
 'data/manifests/final-test-2025-source-files.csv'='744543f6ec52d6b1293ad4a90e0e1888aa4cde8627aea31c2f37cd8f18970622',
 'data/pilot/2024-event-batch-membership/candidate-history-membership.csv'='c3d1e7c570ac9791517117044abe00faee9ae6b1b53f5fc5a5f43b78074f9fe0',
 'data/pilot/2024-event-batch-membership/summary.csv'='661334dfa6697454ccbdb421323cea39829e488fc0c9d9d360c3525efe7bd435',
 'data/pilot/2024-event-batch-membership/target-batches.csv'='d5baad965f192dc4a0c7fe93cbfded6bd3be9c0f7caa9c58cfdefb1499442162',
 'data/pilot/2024-s08-batched-history-aggregation/slot-history-aggregates.csv'='18d8f6f9a1bf2422e1a083479d00be64336cabb0d5f3303a5ca962f22942e65d',
 'data/pilot/2024-s08-batched-history-aggregation/summary.csv'='ca293aa88c380ebcdc5d0e70c5b6404a23e1207339343360164638208fbde61f',
 'data/pilot/2024-s08-batched-history-aggregation/target-s08-features.csv'='712cb89b5acd85af54306019a4c160171d9cd443777cba5587ad3e8975e7b883',
 'data/pilot/2024-source-admission-v2/cell-summary.csv'='38b375114ced0de355c873fbe5179200a049abb9765dc8a5b49595e54d467d16',
 'data/pilot/2024-source-admission-v2/field-availability.csv'='e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1',
 'data/pilot/2024-source-admission-v2/membership.csv'='81c3f1079dd5af0dd0bc7cc4d8d055ab2d685c055e509073e8248e29cdf2ae83',
 'data/pilot/2024-source-admission-v2/provenance.csv'='430074a631dd7d7b3d9d459741dbb1c482ce0424839f219504994a57dc2c593b',
 'data/pilot/2024-source-admission-v2/row-dispositions.csv'='ed80d3f9a5c8c7b4dbf41b1fb49d1567fd9e275a9f5e6330dcb340971bd508a2',
 'data/pilot/2024-source-admission-v2/summary.csv'='2f0c7f3d1b48891f6cf1761c68428f88d3d9539029992dc4ffa2477cc88abfa5',
 'data/pilot/2024-surface-elo-baseline/rating-update-ledger.csv'='6c46ac9a9ff93b5bf00cf9f6b959215426f7d9b7206c43373588a885a7c099a6',
 'data/pilot/2024-surface-elo-baseline/summary.csv'='21931bd5b74e7e6d2c64ac7ab9da14d91b47032e24d5a50490fe6d82ef85ce35',
 'data/pilot/2024-surface-elo-baseline/target-elo-probabilities.csv'='3a945231e7e24bb866904958469b551662be6ec0bdb2b449a462720090127eca',
 'data/pilot/2025-event-batch-membership/candidate-history-membership.csv'='ed9616954b4df7cb50fb4c5bee1381ef72842ee0abbd6f64f3f47fa1d86b9350',
 'data/pilot/2025-event-batch-membership/summary.csv'='a7bc3d3a3dfa117d2c8a30cfe8b4ce803df054c88d6fc58f0950529bc5ecb360',
 'data/pilot/2025-event-batch-membership/target-batches.csv'='55c4cb37255b368f2760262fc3ffb0500904738fd1f29696c023fbf0f8219de3',
 'data/pilot/2025-source-admission/cell-summary.csv'='2a18a583cd2d8c53221d16505a2bf165a6bd515e35f14f2956dd79e5e5be8602',
 'data/pilot/2025-source-admission/field-availability.csv'='34d26c131503243d6b789eaf29842acf3747b2b73323bba5465156163d5a4a2f',
 'data/pilot/2025-source-admission/membership.csv'='1d1d977ccef767db0316d302f20aa0563ec913caab4dfa70fd9daa537415b6ce',
 'data/pilot/2025-source-admission/provenance.csv'='1696121bdaf5faf4c2678e193cbb5ad047e241daed2441171d1c5279c34a79f5',
 'data/pilot/2025-source-admission/row-dispositions.csv'='6272a513d780c7524bcb7c6cb1608093816b87451b57c531b010bf9fae5b3703',
 'data/pilot/2025-source-admission/summary.csv'='f36bbef4e5ab8f3492b9f5b907c85f4e1f4d4739dd2138501a922d7149cccf95',
 'data/pilot/event-batch-membership/candidate-history-membership.csv'='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
 'data/pilot/event-batch-membership/summary.csv'='04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246',
 'data/pilot/event-batch-membership/target-batches.csv'='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
 'data/pilot/s08-batched-histories/slot-history-aggregates.csv'='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
 'data/pilot/s08-batched-histories/summary.csv'='7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4',
 'data/pilot/s08-batched-histories/target-s08-features.csv'='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
 'data/pilot/source-defined-cohort-admission/cohort-membership.csv'='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
 'data/pilot/source-defined-cohort-admission/row-dispositions.csv'='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6',
 'data/pilot/surface-elo-baseline/rating-update-ledger.csv'='a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c',
 'data/pilot/surface-elo-baseline/summary.csv'='9cf5eb133ef8a213881250c855ddb98a96bf16209f82d21e6d7c6bc35e927469',
 'data/pilot/surface-elo-baseline/target-elo-probabilities.csv'='93505d79faf5e17eb3646c101ea6b21e8035e2acddbfe55c27f3236bb6c2392c',
 'docs/2024-event-batch-membership-audit.md'='7495ecbc4508980b1b4dc73f6ee22f1c786c284e4c703db3c24ca7c65736bf60',
 'docs/2024-s08-batched-history-aggregation.md'='bd1a6c34bef4cea5c146418876449a333958548d72fc8d3d0b6d1eae9f99f5c5',
 'docs/2024-source-admission-v2.md'='0e80d6c8e6f2f98a6ec80369ab1b669646db88b546b24b453e0ac8f6e658c27d',
 'docs/2024-surface-elo-baseline-audit.md'='6107eeb427faea6e024ace1bf7c7d010b30adaf44e85343d9410c87c0f1e449f',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'docs/2025-event-batch-membership-audit.md'='f29fa858e510cb22ddc1acdd131be4cdfc5c5d937469f19dd64e7c0102b16d90',
 'docs/2025-locked-final-test-protocol.md'='353159859d4a0ed2b104c691e717a8bab01e33ba1fb0ce03314e876ea4e8f6ae',
 'docs/2025-source-admission-audit.md'='5214bf1ef83b55bc9799c2c3daa8240ae23419bfa10d154d1907bd93d9241582',
 'docs/2025-source-conflict-review.md'='4e3a8d15b89c448c5d1b46996b4c0c2ad73e6b87e173956045b1cd6f4cf36f02',
 'docs/event-batch-membership-audit.md'='9ffc26c83c91a295a4f79352ae326eeb7a56700976b398560175650b24c07a4a',
 'docs/s08-batched-history-aggregation.md'='1ac223d78c40705877db3e2810b2c507631d39043ac23d178aaee5586d4c75c2',
 'docs/source-label-event-batching-decision.md'='7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c',
 'docs/surface-elo-baseline-audit.md'='1bbd2ca856cf4d42e1b5e557abd8d3eb759264fdd02d5e664a67ca0b439b6153')
ak_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
ak_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
ak_verify <- function(pins=ak_pins)ak_need(all(vapply(names(pins),ak_hash,'')==pins),'Missing/changed Phase 2AK input')
ak_import <- function(path,allow,e) {
 found<-character()
 for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow){eval(x,e);found<-c(found,as.character(x[[2]]))}
 ak_need(setequal(found,allow),'Pure helper allowlist mismatch')
}
ak_helpers <- function() {
 ak_verify();e<-new.env(parent=globalenv())
 ak_import('R/build_2024_surface_elo_baseline.R',c('ae_dir','ae_outputs','ae_pins','ae_need','ae_hash','ae_verify','ae_import','ae_helpers','ae_write','ae_outcomes','ae_terminal','ae_reconcile','ae_prepare','ae_replay','ae_build'),e)
 base<-e$ae_helpers()
 for(k in ls(base,all.names=TRUE))e[[k]]<-base[[k]]
 ak_import('R/build_2025_event_batch_membership.R',c('aj_dir','aj_outputs','aj_pins','aj_need','aj_hash','aj_verify','aj_helpers','aj_fields','aj_disposition_fields','aj_read_columns','aj_read_inputs','aj_prepare','aj_membership','aj_build'),e)
 ak_import('R/aggregate_s08_batch_histories.R',c('s08_need','s08_hash','s08_metrics','s08_components','s08_counts','s08_pool','s08_summarize','s08_build'),e)
 ak_import('R/aggregate_2024_s08_batch_histories.R',c('ad_need','ad_chars','ad_aggregate'),e)
 e$ebm_sort<-e$se_sort;e$ebm_convention<-e$se_convention;e$ebm_chronology<-e$se_chronology
 # Exact AJ reconstruction precedes the unchanged pooling helper.
 e$s08_validate_membership<-function(x,h,m,d,expected_n=NULL)list(x=x,h=h)
 e$s08_outputs<-c('slot-history-aggregates','target-s08-features','summary')
 # Imported installer functions retain their own environment; bind output scope there.
 environment(e$se_install)$se_dir<-ak_dir;environment(e$se_install)$se_outputs<-ak_outputs
 environment(e$se_install)$se_verify<-ak_verify
 environment(e$se_ignored)$se_dir<-ak_dir;environment(e$se_ignored)$se_outputs<-ak_outputs
 e$se_ignored();e
}
ak_reconcile <- function(e) {
 # Reconcile both complete frozen releases before any 2025 input processing.
 dev<-e$ae_reconcile(e);v<-e$ae_prepare(e,dev);replay<-e$ae_build(v,dev,e)
 path<-'data/pilot/2024-surface-elo-baseline/'
 tmp<-tempfile();on.exit(unlink(tmp),add=TRUE)
 for(k in seq_along(replay)) {e$ae_write(replay[[k]],tmp);ak_need(ak_hash(tmp)==ak_hash(paste0(path,names(replay)[k],'.csv')),'Phase 2AE replay differs from frozen bytes')}
 fields<-c('tour','source_tourney_date','batch_key','component','surface','player_id','before','prior_matches','batch_matches','accumulated_delta','after','after_matches')
 du<-e$se_read('data/pilot/surface-elo-baseline/rating-update-ledger.csv')
 vu<-e$se_read(paste0(path,'rating-update-ledger.csv'))
 saved<-e$ae_terminal(rbind(du[fields],vu[fields]),e)
 rebuilt<-e$ae_terminal(rbind(du[fields],replay[[2]][fields]),e)
 residual<-max(unlist(lapply(names(saved$states),function(t)unlist(lapply(c('g','s','ng','ns'),function(k){
  a<-saved$states[[t]][[k]];b<-rebuilt$states[[t]][[k]];ak_need(setequal(names(a),names(b)),'Terminal state key mismatch');abs(a-b[names(a)])})))))
 ak_need(residual<1e-10,'Phase 2AE terminal reconciliation failed')
 records<-list()
 for(t in names(saved$states))for(component in c('OVERALL','SURFACE')) {
  field<-if(component=='OVERALL')'g' else 's';cf<-if(component=='OVERALL')'ng' else 'ns'
  z<-vu[vu$tour==t&vu$component==component,];keys<-if(component=='OVERALL')z$player_id else paste(z$player_id,z$surface,sep='|')
  untouched<-setdiff(names(dev$states[[t]][[field]]),keys)
  ak_need(identical(saved$states[[t]][[field]][untouched],dev$states[[t]][[field]][untouched])&&identical(saved$states[[t]][[cf]][untouched],dev$states[[t]][[cf]][untouched]),'Untouched development state lost')
  records[[length(records)+1L]]<-data.frame(record_type='RECONCILIATION',level='tour',tour=t,group=t,component=component,
   terminal_states=length(saved$states[[t]][[field]]),untouched_development_states=length(untouched),chain_residual=saved$chain_residual,replay_residual=residual)
 }
 saved$reconciliation<-do.call(rbind,records);saved
}
ak_read_inputs <- function(e) {
 ak_verify();e$se_ignored();i<-e$aj_read_inputs(e$aj_helpers())
 dirs<-c(d='source-defined-cohort-admission',v='2024-source-admission-v2',t='2025-source-admission')
 fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
 for(k in names(dirs)) {
  root<-paste0('data/pilot/',dirs[k],'/')
  i[[paste0(k,'m')]]<-e$aj_read_columns(paste0(root,if(k=='d')'cohort-membership.csv' else 'membership.csv'),c(e$aj_fields,'a_original_side','winner_id','loser_id'))
  i[[paste0(k,'d')]]<-e$aj_read_columns(paste0(root,'row-dispositions.csv'),c(e$aj_disposition_fields,'game_reconciliation','a_original_side','winner_id','loser_id',paste0('effective_w_',fields),paste0('effective_l_',fields)))
 }
 i$x<-e$se_read('data/pilot/2025-event-batch-membership/target-batches.csv')
 i$h<-e$se_read('data/pilot/2025-event-batch-membership/candidate-history-membership.csv');i
}
ak_validate <- function(i,e) {
 expected<-do.call(e$aj_build,c(i[c('dm','dd','vm','vd','tm','td','cells')],list(e=e$aj_helpers())))
 x<-e$se_sort(i$x,c('tour','source_tourney_date','cell_id','match_key'))
 h<-e$se_sort(i$h,c('tour','target_source_date','target_cell','target_key','target_slot','prior_source_date','prior_key'))
 ak_need(identical(e$ad_chars(x),e$ad_chars(expected[[1]])),'Frozen Phase 2AJ targets differ')
 ak_need(identical(e$ad_chars(h),e$ad_chars(expected[[2]])),'Frozen Phase 2AJ membership differs')
 list(x=x,h=h)
}
ak_count_inputs <- function(i,h) {
 mf<-c('match_id','player_a_id','player_b_id','a_original_side')
 fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
 df<-c('match_id','membership','game_reconciliation','a_original_side','winner_id','loser_id',paste0('effective_w_',fields),paste0('effective_l_',fields))
 combine<-function(kind,fields) {
  rows<-list();cohorts<-c(d='DEVELOPMENT',v='VALIDATION_2024',t='FINAL_TEST_2025')
  for(k in names(cohorts)){z<-i[[paste0(k,kind)]][fields];z$match_id<-paste(cohorts[k],z$match_id,sep='|');rows[[k]]<-z}
  do.call(rbind,rows)
 }
 m<-combine('m',mf);d<-combine('d',df)
 keys<-sort(unique(h$prior_key[h$membership_status=='ELIGIBLE_EARLIER_BATCH']),method='radix')
 m<-m[match(keys,m$match_id),,drop=FALSE];d<-d[match(keys,d$match_id),,drop=FALSE]
 ak_need(!anyNA(m$match_id)&&!anyNA(d$match_id)&&!anyDuplicated(m$match_id),'Missing/duplicate count contributor')
 list(m=m,d=d)
}
ak_features <- function(x,h,counts,e) {
 r<-e$ad_aggregate(x,h,counts,e)
 for(k in 1:2)r[[k]]$cohort<-'FINAL_TEST_2025'
 r
}
ak_elo_input <- function(x,f,m,d,e) {
 ak_need(setequal(x$match_key,f$match_key)&&!anyDuplicated(f$match_key),'Feature target universe mismatch')
 f<-f[match(x$match_key,f$match_key),]
 for(k in c('match_id','tour','season','source_tourney_date','batch_key','surface','player_a_id','player_b_id'))ak_need(identical(as.character(x[[k]]),as.character(f[[k]])),paste('Feature metadata mismatch',k))
 for(slot in c('a','b')) {
  rates<-as.matrix(f[paste0(slot,'_',e$s08_metrics)])
  reasons<-as.matrix(f[paste0(slot,'_',e$s08_metrics,'_reason')])
  ak_need(all(is.finite(rates)==(reasons=='DEFINED')),'Feature reason mismatch')
  x[[paste0(slot,'_s08_complete')]]<-rowSums(is.finite(rates))==4
 }
 both<-x$a_s08_complete&x$b_s08_complete
 ak_need(identical(both,f$both_candidates_feature_complete)&&identical(both,f$all_s08_differences_defined),'Full-vector eligibility mismatch')
 x$s08_stratum<-ifelse(both,'BOTH_COMPLETE',ifelse(x$a_s08_complete|x$b_s08_complete,'ONE_COMPLETE','NEITHER_COMPLETE'))
 ak_need(all(x$surface %in% c('Hard','Clay','Grass')),'Unsupported target surface')
 list(x=x,y=e$ae_outcomes(x,m,d))
}
ak_bind <- function(tables) {
 fields<-unique(unlist(lapply(tables,names)))
 tables<-lapply(tables,function(z){for(k in setdiff(fields,names(z)))z[[k]]<-NA;z[fields]})
 r<-do.call(rbind,tables);rownames(r)<-NULL;r
}
ak_build <- function(i,terminal,e) {
 checked<-ak_validate(i,e);f<-ak_features(checked$x,checked$h,ak_count_inputs(i,checked$h),e)
 inp<-ak_elo_input(checked$x,f[[2]],i$tm,i$td,e)
 er<-e$ae_replay(inp$x,inp$y,terminal$states,e);p<-er$p;u<-er$u
 ak_need(nrow(f[[1]])==3756&&nrow(f[[2]])==1878&&nrow(p)==1878,'Target/slot count failure')
 ak_need(!anyDuplicated(p$match_id)&&!anyDuplicated(paste(f[[1]]$match_key,f[[1]]$slot)),'Duplicate target/slot')
 ak_need(sum(f[[1]]$history_matches)==146374,'Membership contribution count changed')
 j<-match(p$match_id,inp$x$match_id)
 for(slot in c('a','b'))ak_need(all(p[[paste0(slot,'_overall_prior_matches')]]==as.integer(inp$x[[paste0(slot,'_history_matches')]][j])),'Elo history differs from Phase 2AJ')
 for(component in c('OVERALL','SURFACE'))ak_need(sum(u$batch_matches[u$component==component])==2*nrow(p),'Update accounting failed')
 ak_need(max(abs(tapply(u$accumulated_delta,paste(u$batch_key,u$component,u$surface),sum)))<1e-10,'Batch delta balance failed')
 fs<-f[[3]];fs$record_type<-'FEATURE';es<-e$se_summary(p,u)
 cells<-i$cells[i$cells$round=='ALL',];cs<-data.frame(record_type='CELL_INVENTORY',level='cell_id',tour=cells$tour,group=cells$cell_id,surface=cells$surface,
  targets=as.integer(cells$admitted_source_records),excluded_panel_records=as.integer(cells$excluded_source_records),admission_cell_state=cells$state)
 for(tour in unique(es$tour[es$record_type=='UPDATE'])) {
  z<-u[u$tour==tour,];j<-es$record_type=='UPDATE'&es$tour==tour
  es$max_batch_balance_residual[j]<-max(abs(tapply(z$accumulated_delta,paste(z$batch_key,z$component,z$surface),sum)))
 }
 summary<-ak_bind(list(fs,es,terminal$reconciliation,cs))
 summary<-e$se_sort(summary,c('record_type','level','tour','group','metric','slot','stratum','component','surface'))
 r<-setNames(list(f[[1]],f[[2]],p,u,summary),ak_outputs)
 for(k in names(r)) {
  r[[k]]$version<-r[[k]]$release_version<-'2AK-1.0.0'
  r[[k]]$convention<-e$se_convention;r[[k]]$verified_chronology_decision<-e$se_chronology
  r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
  r[[k]]$analysis_label<-'2025 locked source-label final-test sensitivity'
  r[[k]]$cohort_scope<-'1878 admitted records; ATP 10 cells; WTA 8 cells; WTA Canada/Cincinnati excluded; no full-panel WTA claim'
  r[[k]]$factor_status<-'S02_PAUSED;S08_PROVISIONAL;REDUCED_THREE_FACTOR_COMPARATOR'
  r[[k]]$m05_interpretation_gate<-'M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED'
  r[[k]]$M05_canonical_name<-'Double-Fault Rate per Second-Serve Opportunity'
 }
 for(k in 1:3)ak_need(!any(grepl('outcome|winner|loser|original_side',names(r[[k]]))),'Outcome exported in feature/probability table')
 ak_verify();r
}
ak_main <- function(write_outputs=TRUE) {
 e<-ak_helpers();terminal<-ak_reconcile(e);i<-ak_read_inputs(e);r<-ak_build(i,terminal,e)
 if(write_outputs)e$se_install(r,ak_dir);r
}
if(sys.nframe()==0L) {ak_need(length(commandArgs(trailingOnly=TRUE))==0L,'Offline runner takes no arguments');r<-ak_main();print(r[[5]][r[[5]]$record_type=='COVERAGE'&r[[5]]$level=='tour',c('tour','stratum','targets','overall_cold_slots','surface_cold_slots','min_primary','max_primary')],row.names=FALSE)}
