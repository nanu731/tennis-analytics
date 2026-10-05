# Phase 2AL: locked 2025 factor fitting and four-method final evaluation; base R only.
# Frozen Phase 2R/2W numerics and Phase 2AF integration are imported, never modified.
al_version <- '2AL-1.0.0'
al_dir <- 'data/pilot/2025-locked-evaluation'
al_outputs <- c('fold-readiness','target-predictions','model-fits','paired-scores','stability','final-conclusions')
al_code <- c(runner='R/run_2025_locked_evaluation.R',tests='R/test_2025_locked_evaluation.R')
al_tours <- c('ATP','WTA')
al_unresolved <- 'LOCKED_TEST_LOSS_COMPARISON_MIXED_OR_UNRESOLVED'
al_pins <- c(
 'R/run_2024_validation.R'='0a150402bb73f1da28378f33206f4911dc82db252154339e28a469bc56a47cae',
 'R/run_s08_paired_evaluation.R'='14cb2e7daf66a7190735bc96d13768fa059c9954dbbf316d2ed284719cd50d5e',
 'R/run_m05_ablation.R'='474d30e45deac623056cae45c419a33a2ce3535701a2e3fa436124149287fdbf',
 'R/build_surface_elo_baseline.R'='a0bb7ac4193a5a9a9f3c0e9843958e7cccb2c1196f22216dc345c743c1a45117',
 'R/build_2024_surface_elo_baseline.R'='15cccc7581ff05dc2660b3a21df4d166e50a6a7d8979aead9b94c4d7b2216cab',
 'R/build_2025_features_elo.R'='4c5f0fba9f998d5b117bce3b77bdb7349422a569a56e1bebf56f91adfa381148',
 'docs/2025-locked-final-test-protocol.md'='353159859d4a0ed2b104c691e717a8bab01e33ba1fb0ce03314e876ea4e8f6ae',
 'docs/2025-feature-elo-construction-audit.md'='9c8980004ea56e4d23fa7dea83e62b9d79f1efd91f07236688d659320c9c7b7c',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'docs/2024-validation-results.md'='18c12e91abb8e49de713d60ac8aac829412f4e21251f2f1f209ff7e75a71517c',
 'data/pilot/2025-event-batch-membership/target-batches.csv'='55c4cb37255b368f2760262fc3ffb0500904738fd1f29696c023fbf0f8219de3',
 'data/pilot/2025-feature-elo-construction/target-s08-features.csv'='2a356f435dfa1863fc9383b24e923d86c68d3e5baaf917504b78f99628475882',
 'data/pilot/2025-feature-elo-construction/target-elo-probabilities.csv'='2ec3df6b8214f3f878b468001784d4bd3363f68b3accb95a31badaf33f2ca4d0',
 'data/pilot/2025-feature-elo-construction/rating-update-ledger.csv'='3033a245a534ba8b6e07b0c87238a52c64d15564fe2fba2cea4126d5435a24c4',
 'data/pilot/2025-feature-elo-construction/summary.csv'='07a9461734c56040fbdd3c3c56c0847ad8219047fe3010e4faea9dbd19e46a90',
 'data/pilot/2025-source-admission/membership.csv'='1d1d977ccef767db0316d302f20aa0563ec913caab4dfa70fd9daa537415b6ce',
 'data/pilot/2025-source-admission/row-dispositions.csv'='6272a513d780c7524bcb7c6cb1608093816b87451b57c531b010bf9fae5b3703',
 'data/pilot/surface-elo-baseline/rating-update-ledger.csv'='a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c',
 'data/pilot/2024-surface-elo-baseline/rating-update-ledger.csv'='6c46ac9a9ff93b5bf00cf9f6b959215426f7d9b7206c43373588a885a7c099a6')
al_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
al_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
al_verify <- function(pins=al_pins)al_need(all(vapply(names(pins),al_hash,'')==pins),'STOP: frozen protocol/input mismatch')
al_import <- function(path,allow,e){found<-character();for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow){eval(x,e);found<-c(found,as.character(x[[2]]))};al_need(setequal(found,allow),'Helper allowlist mismatch')}
al_helpers <- function(){
 al_verify();a<-new.env(parent=globalenv())
 al_import('R/run_2024_validation.R',c('af_dir','af_outputs','af_models','af_pairs','af_pins','af_need','af_hash','af_verify','af_import','af_helpers','af_prepare','af_load','af_walk','af_score','af_summarize','af_deletions'),a)
 e<-a$af_helpers() # Verifies all 40 Phase 2AF pins and imports the frozen 2R/2W numerics.
 al_import('R/build_surface_elo_baseline.R',c('se_sort','se_probability'),e)
 al_import('R/build_2024_surface_elo_baseline.R',c('ae_need','ae_terminal'),e)
 e$af<-a;e$sq_dir<-al_dir;e$sq_outputs<-al_outputs;e$sq_verify<-al_verify;e$sq_ignored()
 e$al_prepare<-al_prepare;environment(e$al_prepare)<-e;e
}
# Phase 2AF preparation checks with the separately admitted 2025 year/cardinality and Phase 2AK outcome rules.
al_prepare <- function(x,f,e,m,d,expected_n=1878L) {
 sq_need(nrow(x)==expected_n&&!anyDuplicated(x$match_id),'Target accounting mismatch')
 x<-sq_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
 sq_need(all(x$tour %in% c('ATP','WTA'))&&all(x$season=='2025'),'Unauthorized tour/year')
 labels<-grepl('^[0-9]{8}$',x$source_tourney_date)
 date<-as.Date(x$source_tourney_date,format='%Y%m%d')
 sq_need(all(labels&!is.na(date)&format(date,'%Y%m%d')==x$source_tourney_date),'Invalid source label')
 sq_need(all(substr(x$source_tourney_date,1,4)==x$season)&all(x$batch_key==paste(x$tour,x$source_tourney_date,sep='|')),'Batch label mismatch')
 for(k in unique(x$cell_id))sq_need(length(unique(x$batch_key[x$cell_id==k]))==1,'Conflicting cell label')
 fields<-c('tour','season','cell_id','event','surface','round','batch_key','source_tourney_date','player_a_id','player_b_id')
 f<-sq_join(x,f,fields);e<-sq_join(x,e,fields)
 sq_need(all(x$cohort=='FINAL_TEST_2025')&&identical(x$match_key,paste(x$cohort,x$match_id,sep='|'))&&identical(x$match_key,f$match_key)&&identical(x$match_key,e$match_key),'Cohort key mismatch')
 m<-sq_join(x,m,c('cell_id','event','surface','round','player_a_id','player_b_id'))
 sq_need(!anyDuplicated(d$match_id[d$match_id %in% x$match_id]),'Duplicate target disposition ID')
 sq_need(setequal(d$match_id[d$membership=='INCLUDED'],x$match_id),'Exclusions changed')
 d<-d[match(x$match_id,d$match_id),,drop=FALSE]
 sq_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS'&d$quarantined=='FALSE'&d$completion_status=='source_reported_normal')&&identical(m$a_original_side,d$a_original_side),'Invalid membership/result orientation')
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
 sq_need(all(x$complete==(f$all_s08_differences_defined=='TRUE'))&&all(x$complete==(f$both_candidates_feature_complete=='TRUE'))&&all(x$complete==apply(slots,1,all)),'Complete-vector mismatch')
 x$s08_stratum<-ifelse(x$complete,'BOTH_COMPLETE',ifelse(rowSums(slots)==1,'ONE_COMPLETE','NEITHER_COMPLETE'))
 sq_need(identical(x$s08_stratum,e$s08_stratum),'Elo completeness stratum mismatch')
 for(k in c('p_a_primary','p_a_overall')) {x[[k]]<-as.numeric(e[[k]]);sq_need(all(is.finite(x[[k]])&x[[k]]>=0&x[[k]]<=1),'Invalid frozen comparator')}
 x$y<-as.integer(m$a_original_side=='winner');x
}
# Ledger-only reconciliation: Phase 2AE terminal states carry into every Phase 2AK pre-batch rating.
al_reconcile <- function(e){
 fields<-c('tour','source_tourney_date','batch_key','component','surface','player_id','before','prior_matches','batch_matches','accumulated_delta','after','after_matches')
 du<-e$sq_read('data/pilot/surface-elo-baseline/rating-update-ledger.csv')[fields]
 vu<-e$sq_read('data/pilot/2024-surface-elo-baseline/rating-update-ledger.csv')[fields]
 ku<-e$sq_read('data/pilot/2025-feature-elo-construction/rating-update-ledger.csv')[fields]
 al_need(nrow(ku)==3900&&all(substr(ku$source_tourney_date,1,4)=='2025'),'Phase 2AK ledger cardinality mismatch')
 pre<-e$ae_terminal(rbind(du,vu),e);chain<-e$ae_terminal(rbind(du,vu,ku),e) # Full chain from 1500 through 2025.
 for(t in al_tours)al_need(all(ku$source_tourney_date[ku$tour==t]>pre$states[[t]]$last_date),'Carried state cutoff conflict')
 saved<-e$sq_read('data/pilot/2025-feature-elo-construction/summary.csv');saved<-saved[saved$record_type=='RECONCILIATION',]
 expected<-c('ATP|OVERALL'=248,'ATP|SURFACE'=552,'WTA|OVERALL'=298,'WTA|SURFACE'=695)
 al_need(nrow(saved)==4&&setequal(paste(saved$tour,saved$component,sep='|'),names(expected)),'Phase 2AK reconciliation records missing')
 for(j in seq_len(nrow(saved))){k<-paste(saved$tour[j],saved$component[j],sep='|');n<-length(pre$states[[saved$tour[j]]][[if(saved$component[j]=='OVERALL')'g' else 's']])
  al_need(n==expected[[k]]&&as.integer(saved$terminal_states[j])==n&&all(as.numeric(unlist(saved[j,c('chain_residual','replay_residual')]))<1e-10),'Phase 2AE/2AK terminal-state mismatch')}
 p<-e$sq_read('data/pilot/2025-feature-elo-construction/target-elo-probabilities.csv')
 key<-paste(ku$batch_key,ku$component,ku$surface,ku$player_id);before<-as.numeric(ku$before);residual<-0
 for(slot in c('a','b')){
  id<-p[[paste0('player_',slot,'_id')]]
  g<-before[match(paste(p$batch_key,'OVERALL','ALL',id),key)];s<-before[match(paste(p$batch_key,'SURFACE',p$surface,id),key)]
  residual<-max(residual,abs(g-as.numeric(p[[paste0(slot,'_overall')]])),abs(s-as.numeric(p[[paste0(slot,'_surface')]])),abs(.5*g+.5*s-as.numeric(p[[paste0(slot,'_blend')]])))
 }
 blend<-function(slot)as.numeric(p[[paste0(slot,'_blend')]]);overall<-function(slot)as.numeric(p[[paste0(slot,'_overall')]])
 residual<-max(residual,abs(e$se_probability(blend('a'),blend('b'))-as.numeric(p$p_a_primary)),abs(e$se_probability(overall('a'),overall('b'))-as.numeric(p$p_a_overall)))
 al_need(is.finite(residual)&&residual<1e-10,'Pre-batch Elo ratings/probabilities do not reconcile with carried states')
 data.frame(record_type='INPUT_RECONCILIATION',tour=rep(al_tours,each=2),component=rep(c('OVERALL','SURFACE'),2),
  terminal_states_before_2025=unname(expected),phase_2ak_chain_residual=as.numeric(saved$chain_residual[match(names(expected),paste(saved$tour,saved$component,sep='|'))]),
  phase_2ak_replay_residual=as.numeric(saved$replay_residual[match(names(expected),paste(saved$tour,saved$component,sep='|'))]),
  combined_chain_residual=chain$chain_residual,target_rating_probability_residual=residual,stringsAsFactors=FALSE)
}
al_load <- function(e){
 al_verify() # All pins pass before any 2025 outcome is read.
 prior<-e$af$af_load(e);rec<-al_reconcile(e);read<-e$sq_read
 fin<-e$al_prepare(read('data/pilot/2025-event-batch-membership/target-batches.csv'),read('data/pilot/2025-feature-elo-construction/target-s08-features.csv'),read('data/pilot/2025-feature-elo-construction/target-elo-probabilities.csv'),read('data/pilot/2025-source-admission/membership.csv'),read('data/pilot/2025-source-admission/row-dispositions.csv'))
 required<-unique(fin[c('tour','batch_key')]);rownames(required)<-NULL
 al_need(sum(fin$complete)==1777&&nrow(required)==18&&all(table(fin$tour[fin$complete])==c(951,826)),'Frozen 2025 completeness/batch mismatch')
 cells<-read('data/pilot/2025-feature-elo-construction/summary.csv');cells<-cells[cells$record_type=='CELL_INVENTORY',]
 al_need(nrow(cells)==20,'All twenty expected cells required')
 list(dev=prior$dev,val=prior$val,fin=fin,required=required,cells=data.frame(tour=cells$tour,cell_id=cells$group,surface=cells$surface,targets=as.integer(cells$targets),excluded_panel_records=as.integer(cells$excluded_panel_records),admission_cell_state=cells$admission_cell_state,stringsAsFactors=FALSE),reconciliation=rec)
}
al_fields <- function(e)c('match_id','cohort','match_key','tour','season','batch_key','source_tourney_date','cell_id','event','surface','round','player_a_id','player_b_id','complete','s08_stratum',e$sq_metrics,paste0(e$sq_metrics,'_reason'),'p_a_primary','p_a_overall','y')
# The frozen Phase 2AF walk receives all development and 2024 rows as earlier training history.
al_walk <- function(i,e,fit_full=e$sq_readiness,fit_reduced=e$mw_readiness){
 fields<-al_fields(e);prior<-rbind(i$dev[fields],i$val[fields])
 al_need(all(prior$cohort %in% c('DEVELOPMENT','VALIDATION_2024'))&&all(i$fin$cohort=='FINAL_TEST_2025'),'Cohort roles')
 for(t in unique(i$fin$tour))al_need(all(prior$source_tourney_date[prior$tour==t]<min(i$fin$source_tourney_date[i$fin$tour==t])),'Prior history is not earlier')
 w<-e$af$af_walk(list(dev=prior,val=i$fin[fields]),e,fit_full,fit_reduced)
 al_need(nrow(w$folds)==2*nrow(i$required)&&setequal(w$folds$batch_key,i$required$batch_key)&&!anyDuplicated(w$folds[c('model','batch_key')]),'Required fold universe')
 count<-function(keys,cohort)vapply(strsplit(keys,';',fixed=TRUE),function(k)sum(startsWith(k,paste0(cohort,'|'))),0L)
 f<-w$folds;f$season<-'2025';f$training_prior_n<-f$training_development_n;f$training_final_test_n<-f$training_validation_n
 f$training_development_n<-count(f$training_keys,'DEVELOPMENT');f$training_validation_2024_n<-count(f$training_keys,'VALIDATION_2024');f$training_validation_n<-NULL
 al_need(all(f$training_development_n+f$training_validation_2024_n==f$training_prior_n)&&all(count(f$training_keys,'FINAL_TEST_2025')==f$training_final_test_n)&&all(f$training_n==f$training_prior_n+f$training_final_test_n),'Training composition')
 fits<-w$fits;j<-match(paste(fits$model,fits$batch_key),paste(f$model,f$batch_key));fits$season<-'2025'
 for(k in c('training_prior_n','training_final_test_n','training_development_n','training_validation_2024_n'))fits[[k]]<-f[[k]][j];fits$training_validation_n<-NULL
 list(p=w$p,folds=f,fits=fits)
}
al_loss_label <- function(d,gates,batch,complete=TRUE){
 if(!isTRUE(gates)||!isTRUE(complete)||length(d)!=4||any(!is.finite(d))||!length(batch)||any(!is.finite(batch)))return(c(al_unresolved,'FAILED_REQUIRED_GATE_OR_UNEVALUABLE_COMPARISON'))
 if(any(d==0))return(c(al_unresolved,'FULL_SAMPLE_TIE'))
 if(!(all(d<0)||all(d>0)))return(c(al_unresolved,'MIXED_TOUR_OR_METRIC_DIRECTIONS'))
 if(any(batch==0))return(c(al_unresolved,'BATCH_DELETION_TIE'))
 if(any(sign(batch)!=sign(d[1])))return(c(al_unresolved,'BATCH_DELETION_REVERSAL'))
 if(all(d<0))c('CANDIDATE_HAS_LOWER_LOCKED_TEST_LOSS_THAN_SURFACE_ELO','ALL_STRICT_AND_BATCH_DELETION_STABLE') else c('SURFACE_ELO_HAS_LOWER_LOCKED_TEST_LOSS_THAN_CANDIDATE','ALL_STRICT_AND_BATCH_DELETION_STABLE')
}
# cal: tour-level overall common-mask calibration rows (tour, model, status, intercept, slope).
al_calibration_label <- function(cal,candidate){
 why<-character()
 for(t in al_tours){
  pick<-function(m)cal[cal$tour==t&cal$model==m,,drop=FALSE];C<-pick(candidate);E<-pick('primary')
  v<-suppressWarnings(as.numeric(c(C$intercept,C$slope,E$intercept,E$slope)))
  if(nrow(C)!=1||nrow(E)!=1||!identical(c(C$status,E$status),rep('DESCRIPTIVE_ONLY',2))||length(v)!=4||!all(is.finite(v))){why<-c(why,paste0(t,':UNSUPPORTED_FAILED_OR_MISSING_FIT'));next}
  a<-abs(v[c(1,3)]);s<-abs(v[c(2,4)]-1)
  if(a[1]==a[2]&&s[1]==s[2])why<-c(why,paste0(t,':BOTH_MEASURE_TIE')) else if(!(a[1]<=a[2]&&s[1]<=s[2]))why<-c(why,paste0(t,if(a[1]<=a[2]||s[1]<=s[2])':TRADEOFF' else ':CANDIDATE_NOT_CLOSER'))
 }
 if(length(why))c('CALIBRATION_COMPARISON_UNRESOLVED',paste(why,collapse=';')) else c('DESCRIPTIVELY_BETTER_CALIBRATION_THAN_SURFACE_ELO','EACH_TOUR_NO_WORSE_AND_ONE_STRICTLY_CLOSER')
}
al_conclude <- function(p,folds,deletions,cal,required,e){
 gates<-nrow(folds)==2*nrow(required)&&!anyDuplicated(folds[c('model','batch_key')])&&setequal(folds$batch_key,required$batch_key)&&all(folds$ready)
 numerical<-all(vapply(e$af$af_models,function(m)all(is.finite(p[[paste0(m,'_logloss')]][p$paired]))&&all(is.finite(p[[paste0(m,'_brier')]][p$paired])),TRUE))
 numerical<-numerical&&all(vapply(c('full','reduced'),function(m){q<-p[[paste0('p_',m)]][p$complete];eta<-p[[paste0('eta_',m)]][p$complete];all(is.finite(q)&q>=0&q<=1&is.finite(eta))},TRUE))&&all(vapply(c('p_a_primary','p_a_overall'),function(m)all(is.finite(p[[m]])&p[[m]]>=0&p[[m]]<=1),TRUE))
 scored<-unique(p[p$paired,c('tour','batch_key')]);tc<-cal[cal$level=='tour'&cal$stratum=='ALL',]
 mean_diff<-function(t,field){z<-p[p$tour==t&p$paired,];if(nrow(z))mean(z[[field]]) else NA_real_}
 full<-folds[folds$model=='full',];rows<-list()
 for(candidate in c('full','reduced')){
  pair<-paste0(candidate,'_primary')
  d<-unlist(lapply(al_tours,function(t)vapply(c('logloss','brier'),function(m)mean_diff(t,paste0('difference_',pair,'_',m)),0.0)))
  b<-deletions[deletions$deletion=='BATCH'&deletions$comparison==pair,]
  complete<-all(al_tours %in% p$tour[p$paired])&&nrow(b)==2*nrow(scored)&&setequal(b$key,scored$batch_key)&&all(b$status=='CONDITIONAL_SCORE_INFLUENCE')
  loss<-al_loss_label(d,gates&&numerical,as.numeric(b$deleted_difference),complete);calibration<-al_calibration_label(tc,candidate)
  for(t in al_tours){
   z<-p[p$tour==t,];bt<-b[b$tour==t,];f<-full[full$tour==t,];cc<-function(m,k){v<-tc[[k]][tc$tour==t&tc$model==m];if(length(v)==1)v else NA}
   r<-list(record_type='CONCLUSION',candidate=candidate,candidate_role=if(candidate=='full')'FULL_S08_PROVISIONAL_FOUR_COMPONENT_HYPOTHESIS' else 'REDUCED_THREE_FACTOR_COMPARATOR',
    primary_comparator='primary_surface_elo',tour=t,loss_label=loss[1],loss_reason=loss[2],calibration_label=calibration[1],calibration_reason=calibration[2],
    all_required_gates_pass=gates,all_numerical_checks_pass=numerical,batch_deletions_evaluable=complete,required_batches=sum(required$tour==t),scored_batches=sum(scored$tour==t),
    full_pass=sum(folds$ready[folds$tour==t&folds$model=='full']),reduced_pass=sum(folds$ready[folds$tour==t&folds$model=='reduced']),
    targets=nrow(z),complete=sum(z$complete),paired=sum(z$paired),nonpredicted_full=sum(!is.finite(z$p_full)),nonpredicted_reduced=sum(!is.finite(z$p_reduced)),
    candidate_minus_primary_logloss=mean_diff(t,paste0('difference_',pair,'_logloss')),candidate_minus_primary_brier=mean_diff(t,paste0('difference_',pair,'_brier')),
    batch_deleted_min_logloss=if(nrow(bt))min(bt$deleted_difference[bt$metric=='logloss']) else NA_real_,batch_deleted_max_logloss=if(nrow(bt))max(bt$deleted_difference[bt$metric=='logloss']) else NA_real_,
    batch_deleted_min_brier=if(nrow(bt))min(bt$deleted_difference[bt$metric=='brier']) else NA_real_,batch_deleted_max_brier=if(nrow(bt))max(bt$deleted_difference[bt$metric=='brier']) else NA_real_,
    batch_reversals=sum(bt$sign_reversal,na.rm=TRUE),batch_ties=sum(bt$deleted_difference==0,na.rm=TRUE),batch_unevaluable=sum(bt$status!='CONDITIONAL_SCORE_INFLUENCE'),
    descriptive_candidate_minus_overall_logloss=mean_diff(t,paste0('difference_',candidate,'_overall_logloss')),descriptive_candidate_minus_overall_brier=mean_diff(t,paste0('difference_',candidate,'_overall_brier')),
    descriptive_reduced_minus_full_logloss=mean_diff(t,'difference_reduced_full_logloss'),descriptive_reduced_minus_full_brier=mean_diff(t,'difference_reduced_full_brier'),
    candidate_calibration_status=cc(candidate,'status'),candidate_intercept=cc(candidate,'intercept'),candidate_slope=cc(candidate,'slope'),
    elo_calibration_status=cc('primary','status'),elo_intercept=cc('primary','intercept'),elo_slope=cc('primary','slope'),
    m05_full_folds=nrow(f),m05_negative=sum(is.finite(f$beta_dM05)&f$beta_dM05<0),m05_nonnegative=sum(is.finite(f$beta_dM05)&f$beta_dM05>=0),m05_missing=sum(!is.finite(f$beta_dM05)),
    m05_direction_requirement='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED',interpretation='NO_FINAL_FOUR_FACTORS_QUALIFICATION;NO_MODEL_SELECTION;NO_STATISTICAL_SUPERIORITY_CLAIM')
   rows[[length(rows)+1L]]<-r
  }
 }
 e$sq_bind(rows)
}
al_build <- function(i,e,fit_full=e$sq_readiness,fit_reduced=e$mw_readiness){
 al_verify();w<-al_walk(i,e,fit_full,fit_reduced);p<-e$af$af_score(w$p,e);s<-e$af$af_summarize(p,e)
 del<-e$af$af_deletions(p,e);del<-cbind(record_type='DELETION',del,stringsAsFactors=FALSE)
 cal<-s$cal;cal$intercept<-as.numeric(cal$intercept);cal$slope<-as.numeric(cal$slope)
 conclusions<-al_conclude(p,w$folds,del,cal,i$required,e)
 cells<-i$cells;cells$record_type<-'CELL_INVENTORY';cells$level<-'cell_id';cells$group<-cells$cell_id
 cells$evaluated_targets<-vapply(cells$cell_id,function(k)sum(p$cell_id==k),0L);cells$paired<-vapply(cells$cell_id,function(k)sum(p$cell_id==k&p$paired),0L)
 al_need(sum(cells$targets)==nrow(p)&&all(cells$evaluated_targets==cells$targets),'Cell/target accounting')
 scores<-e$sq_bind(list(s$scores,cells[setdiff(names(cells),'cell_id')],i$reconciliation))
 hashes<-vapply(al_code,al_hash,'');conclusions$runner_sha256<-hashes[['runner']];conclusions$tests_sha256<-hashes[['tests']]
 out<-setNames(list(w$folds,p,w$fits,scores,e$sq_bind(list(del,cal)),conclusions),al_outputs)
 for(k in names(out)){z<-out[[k]]
  z$version<-al_version;z$convention<-e$sq_convention;z$verified_chronology_decision<-e$sq_chronology;z$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
  z$analysis_label<-'2025 locked source-label final-test sensitivity'
  z$cohort_scope<-'1878 admitted records; ATP 10 cells; WTA 8 cells; WTA Canada/Cincinnati excluded; no full-panel WTA claim'
  z$factor_status<-'SELECTION_UNRESOLVED;S02_PAUSED;S08_PROVISIONAL;REDUCED_THREE_FACTOR_COMPARATOR'
  z$m05_interpretation_gate<-'M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED';out[[k]]<-z}
 al_verify();out
}
run_2025_locked_evaluation <- function(write_outputs=TRUE){e<-al_helpers();i<-al_load(e);r<-al_build(i,e);if(write_outputs)e$sq_install(r);r}
if(sys.nframe()==0L){al_need(length(commandArgs(trailingOnly=TRUE))==0L,'Offline runner takes no arguments');r<-run_2025_locked_evaluation();print(r[['final-conclusions']][c('candidate','tour','loss_label','calibration_label','candidate_minus_primary_logloss','candidate_minus_primary_brier')],row.names=FALSE)}
