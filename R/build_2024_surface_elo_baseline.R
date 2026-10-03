# Phase 2AE: frozen synchronous Elo continuation, base R; no scoring.
ae_dir <- 'data/pilot/2024-surface-elo-baseline'
ae_outputs <- c('target-elo-probabilities','rating-update-ledger','summary')
ae_pins <- c(
 'R/build_surface_elo_baseline.R'='a0bb7ac4193a5a9a9f3c0e9843958e7cccb2c1196f22216dc345c743c1a45117',
 'R/test_surface_elo_baseline.R'='3c8485d760642ef261ca8deae19f8f5143ae2911acfbdedc6d9e1ed4866105df',
 'docs/surface-elo-baseline-audit.md'='1bbd2ca856cf4d42e1b5e557abd8d3eb759264fdd02d5e664a67ca0b439b6153',
 'R/build_2024_event_batch_membership.R'='896726adc2137a4a06fa0af334eec6d2d744a34d772510a9574d6f52e6c11ee7',
 'R/aggregate_2024_s08_batch_histories.R'='d99a1b0f8ac9bc6742828093b9a2c88d4809a0d1616c6b60edf5df843866aa2c',
 'R/test_2024_s08_batch_histories.R'='cd28f0df911018855c00e32dfeb3b69b202d3389862d2e2f40b5aac38fb7ec3c',
 'docs/2024-s08-batched-history-aggregation.md'='bd1a6c34bef4cea5c146418876449a333958548d72fc8d3d0b6d1eae9f99f5c5',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'data/pilot/surface-elo-baseline/target-elo-probabilities.csv'='93505d79faf5e17eb3646c101ea6b21e8035e2acddbfe55c27f3236bb6c2392c',
 'data/pilot/surface-elo-baseline/rating-update-ledger.csv'='a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c',
 'data/pilot/surface-elo-baseline/summary.csv'='9cf5eb133ef8a213881250c855ddb98a96bf16209f82d21e6d7c6bc35e927469',
 'data/pilot/2024-event-batch-membership/target-batches.csv'='d5baad965f192dc4a0c7fe93cbfded6bd3be9c0f7caa9c58cfdefb1499442162',
 'data/pilot/2024-event-batch-membership/candidate-history-membership.csv'='c3d1e7c570ac9791517117044abe00faee9ae6b1b53f5fc5a5f43b78074f9fe0',
 'data/pilot/2024-event-batch-membership/summary.csv'='661334dfa6697454ccbdb421323cea39829e488fc0c9d9d360c3525efe7bd435',
 'data/pilot/2024-s08-batched-history-aggregation/slot-history-aggregates.csv'='18d8f6f9a1bf2422e1a083479d00be64336cabb0d5f3303a5ca962f22942e65d',
 'data/pilot/2024-s08-batched-history-aggregation/target-s08-features.csv'='712cb89b5acd85af54306019a4c160171d9cd443777cba5587ad3e8975e7b883',
 'data/pilot/2024-s08-batched-history-aggregation/summary.csv'='ca293aa88c380ebcdc5d0e70c5b6404a23e1207339343360164638208fbde61f')
ae_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
ae_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
ae_verify <- function(pins=ae_pins)ae_need(all(vapply(names(pins),ae_hash,'')==pins),'Missing/changed Phase 2AE input')
ae_import <- function(path,allow,e) {
 found<-character()
 for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow){eval(x,e);found<-c(found,as.character(x[[2]]))}
 ae_need(setequal(found,allow),'Pure helper allowlist mismatch')
}
ae_helpers <- function() {
 ae_verify();e<-new.env(parent=globalenv())
 ae_import('R/build_surface_elo_baseline.R',c('se_need','se_hash','se_read','se_sort','se_convention','se_chronology','se_probability','se_pre_batch','se_match_deltas','se_replay','se_summary','se_ignored','se_install'),e)
 ae_import('R/build_2024_event_batch_membership.R',c('ac_pins','ac_need','ac_hash','ac_verify','ac_helpers','ac_prepare','ac_dir','ac_outputs'),e)
 e$ac_verify();e$se_version<-'1.0.0';e$se_dir<-ae_dir;e$se_outputs<-ae_outputs
 e$se_verify<-function(){ae_verify();e$ac_verify()};e$se_ignored();e
}
ae_write <- function(z,path)write.table(z,path,sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
ae_outcomes <- function(x,m,d) {
 ae_need(!anyDuplicated(x$match_id)&&!anyDuplicated(m$match_id)&&setequal(x$match_id,m$match_id),'Outcome universe mismatch')
 ae_need(!anyDuplicated(d$match_id[d$membership=='INCLUDED']),'Duplicate admitted disposition')
 m<-m[match(x$match_id,m$match_id),];d<-d[match(x$match_id,d$match_id),]
 ae_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS'&d$quarantined=='FALSE'&d$completion_status=='source_reported_normal'),'Excluded outcome encountered')
 ae_need(all(m$a_original_side %in% c('winner','loser'))&&identical(m$a_original_side,d$a_original_side),'Invalid result orientation')
 ae_need(identical(m$winner_id,d$winner_id)&&identical(m$loser_id,d$loser_id)&&
 all(x$player_a_id==ifelse(m$a_original_side=='winner',m$winner_id,m$loser_id))&&
 all(x$player_b_id==ifelse(m$a_original_side=='winner',m$loser_id,m$winner_id)),'Result/player linkage mismatch')
 as.integer(m$a_original_side=='winner')
}
ae_terminal <- function(u,e) {
 fields<-c('before','prior_matches','batch_matches','accumulated_delta','after','after_matches')
 u[fields]<-lapply(u[fields],as.numeric)
 ae_need(all(is.finite(as.matrix(u[fields])))&&all(u$component %in% c('OVERALL','SURFACE')),'Invalid development states')
 ae_need(all(u$after_matches==u$prior_matches+u$batch_matches)&all(u$batch_matches>0)&all(u$after_matches==floor(u$after_matches)),'Development count reconciliation failed')
 ae_need(max(abs(u$after-u$before-u$accumulated_delta))<1e-10,'Development delta reconciliation failed')
 ae_need(!anyDuplicated(u[c('tour','batch_key','component','surface','player_id')]),'Duplicate development state')
 states<-list();residual<-0
 for(tour in sort(unique(u$tour))) {
  state<-list(g=numeric(),s=numeric(),ng=numeric(),ns=numeric())
  for(component in c('OVERALL','SURFACE')) {
   z<-e$se_sort(u[u$tour==tour&u$component==component,],c('source_tourney_date','player_id','surface'))
   key<-if(component=='OVERALL')z$player_id else paste(z$player_id,z$surface,sep='|')
   for(k in unique(key)) {
    v<-z[key==k,];prior<-c(1500,head(v$after,-1));counts<-c(0,head(v$after_matches,-1))
    residual<-max(residual,abs(v$before-prior))
    ae_need(all(abs(v$before-prior)<1e-10)&&all(v$prior_matches==counts),'Development chain reconciliation failed')
    field<-if(component=='OVERALL')'g' else 's';countfield<-if(component=='OVERALL')'ng' else 'ns'
    state[[field]][k]<-tail(v$after,1);state[[countfield]][k]<-tail(v$after_matches,1)
   }
  }
  state$last_date<-max(u$source_tourney_date[u$tour==tour]);states[[tour]]<-state
 }
 list(states=states,chain_residual=residual)
}
ae_reconcile <- function(e) {
 # Only development files are parsed until the complete replay and ledger check pass.
 path<-'data/pilot/surface-elo-baseline/'
 p<-e$se_read(paste0(path,'target-elo-probabilities.csv'));u<-e$se_read(paste0(path,'rating-update-ledger.csv'))
 m<-e$se_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv')
 d<-e$se_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv')
 ae_need(nrow(p)==2580&&nrow(u)==5532,'Development release cardinality mismatch')
 canonical<-e$ac_prepare(m,d,'DEVELOPMENT',e$ac_helpers(),2580L)
 canonical<-canonical[match(p$match_id,canonical$match_id),]
 for(k in c('tour','season','batch_key','source_tourney_date','cell_id','event','surface','round','player_a_id','player_b_id'))ae_need(identical(p[[k]],canonical[[k]]),paste('Development metadata mismatch',k))
 y<-ae_outcomes(p,m,d);p$a_s08_complete<-as.logical(p$a_s08_complete);p$b_s08_complete<-as.logical(p$b_s08_complete)
 replay<-e$se_replay(p,y);tables<-list(replay$p,replay$u,e$se_summary(replay$p,replay$u))
 tmp<-tempfile();on.exit(unlink(tmp),add=TRUE)
 for(j in seq_along(tables)){ae_write(tables[[j]],tmp);ae_need(ae_hash(tmp)==ae_hash(paste0(path,ae_outputs[j],'.csv')),'Development replay differs from frozen bytes')}
 terminal<-ae_terminal(u,e);other<-ae_terminal(replay$u,e)
 residual<-max(unlist(lapply(names(terminal$states),function(t)unlist(lapply(c('g','s'),function(k)abs(terminal$states[[t]][[k]]-other$states[[t]][[k]]))))))
 ae_need(residual<1e-10,'Development terminal reconciliation failed')
 terminal$replay_residual<-residual;terminal
}
ae_prepare <- function(e,terminal) {
 ae_need(is.list(terminal$states)&&setequal(names(terminal$states),c('ATP','WTA')),'Reconciled terminal states required')
 x<-e$se_read('data/pilot/2024-event-batch-membership/target-batches.csv')
 m<-e$se_read('data/pilot/2024-source-admission-v2/membership.csv');d<-e$se_read('data/pilot/2024-source-admission-v2/row-dispositions.csv')
 canonical<-e$ac_prepare(m,d,'VALIDATION_2024',e$ac_helpers(),1901L)
 canonical[]<-lapply(canonical,as.character)
 ae_need(identical(x[names(canonical)],canonical),'Frozen 2024 metadata mismatch')
 ae_need(all(x$surface %in% c('Hard','Clay','Grass')),'Unsupported target surface')
 for(t in unique(x$tour))ae_need(all(x$source_tourney_date[x$tour==t]>terminal$states[[t]]$last_date),'Development/target cutoff conflict')
 f<-e$se_read('data/pilot/2024-s08-batched-history-aggregation/target-s08-features.csv')
 ae_need(!anyDuplicated(f$match_id)&&setequal(f$match_id,x$match_id),'S08 target universe mismatch');f<-f[match(x$match_id,f$match_id),]
 for(k in c('tour','season','cell_id','surface','batch_key','source_tourney_date','player_a_id','player_b_id','match_key'))ae_need(identical(x[[k]],f[[k]]),paste('S08 metadata mismatch',k))
 for(slot in c('a','b')){
  rates<-sapply(paste0(slot,'_',c('M03','M05','M11','M12')),function(v)suppressWarnings(as.numeric(f[[v]])))
  defined<-sapply(paste0(slot,'_',c('M03','M05','M11','M12'),'_reason'),function(v)f[[v]]=='DEFINED')
  ae_need(identical(unname(is.finite(rates)),unname(defined)),'S08 completeness/reason conflict')
  x[[paste0(slot,'_s08_complete')]]<-rowSums(is.finite(rates))==4
 }
 both<-x$a_s08_complete&x$b_s08_complete
 ae_need(all(as.character(both)==f$all_s08_differences_defined)&all(as.character(both)==f$both_candidates_feature_complete),'S08 completeness flag mismatch')
 x$s08_stratum<-ifelse(both,'BOTH_COMPLETE',ifelse(x$a_s08_complete|x$b_s08_complete,'ONE_COMPLETE','NEITHER_COMPLETE'))
 list(x=x,y=ae_outcomes(x,m,d))
}
ae_replay <- function(x,y,states,e) {
 # Unchanged Phase 2P batch arithmetic; only the initial states and metadata differ.
 for(k in c("se_need","se_pre_batch","se_match_deltas","se_sort","se_convention","se_chronology"))assign(k,e[[k]])
 se_version<-"2AE-1.0.0"
 se_need(length(y)==nrow(x)&&all(y %in% c(0,1)),'Invalid neutral outcomes')
 context<-c('match_id','tour','season','batch_key','source_tourney_date','cell_id','event','surface','round','player_a_id','player_b_id','a_s08_complete','b_s08_complete','s08_stratum','match_key','cohort')
 probs<-list();updates<-list()
 for(tour in sort(unique(x$tour),method='radix')) {
  initial<-states[[tour]];ae_need(!is.null(initial),'Missing tour state')
  g<-initial$g;s<-initial$s;ng<-initial$ng;ns<-initial$ns
  ae_need(all(x$source_tourney_date[x$tour==tour]>initial$last_date),'Non-earlier initial state')
  for(label in sort(unique(x$source_tourney_date[x$tour==tour]),method='radix')) {
   ii<-which(x$tour==tour&x$source_tourney_date==label);ii<-ii[order(x$match_id[ii],method='radix')]
   z<-se_pre_batch(x[ii,context],g,s,ng,ns);probs[[length(probs)+1L]]<-z
   delta<-se_match_deltas(z,y[ii])
   for(component in c('OVERALL','SURFACE')) {
    keys<-if(component=='OVERALL')delta$player_id else paste(delta$player_id,delta$surface,sep='|')
    for(key in sort(unique(keys),method='radix')) {
     rows<-delta[keys==key,];id<-rows$player_id[1];surface<-if(component=='OVERALL')'ALL' else rows$surface[1]
     before<-if(component=='OVERALL')g[key] else s[key];count<-if(component=='OVERALL')ng[key] else ns[key]
     if(is.na(before))before<-1500;if(is.na(count))count<-0
     change<-sum(if(component=='OVERALL')rows$delta_g else rows$delta_s);after<-unname(before+change)
     updates[[length(updates)+1L]]<-data.frame(tour=tour,season=substr(label,1,4),batch_key=paste(tour,label,sep='|'),source_tourney_date=label,
      player_id=id,component=component,surface=surface,before=unname(before),prior_matches=unname(count),batch_matches=nrow(rows),
      accumulated_delta=change,after=after,after_matches=unname(count+nrow(rows)),contributing_match_ids=paste(rows$match_id,collapse=';'),stringsAsFactors=FALSE)
     if(component=='OVERALL') {g[key]<-after;ng[key]<-count+nrow(rows)} else {s[key]<-after;ns[key]<-count+nrow(rows)}
    }
   }
  }
 }
 p<-se_sort(do.call(rbind,probs),c('tour','source_tourney_date','cell_id','match_id'))
 u<-se_sort(do.call(rbind,updates),c('tour','source_tourney_date','component','surface','player_id'))
 for(name in c('p','u')) {z<-get(name);z$version<-se_version;z$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';z$convention<-se_convention;z$verified_chronology_decision<-se_chronology;assign(name,z)}
 list(p=p,u=u)
}
ae_build <- function(i,terminal,e) {
 r<-ae_replay(i$x,i$y,terminal$states,e);p<-r$p;u<-r$u
 j<-match(p$match_id,i$x$match_id)
 for(slot in c('a','b'))ae_need(all(p[[paste0(slot,'_overall_prior_matches')]]==as.integer(i$x[[paste0(slot,'_history_matches')]][j])),'Elo history differs from Phase 2AC')
 for(component in c('OVERALL','SURFACE'))ae_need(sum(u$batch_matches[u$component==component])==2*nrow(p),'Update contribution accounting failed')
 totals<-tapply(u$accumulated_delta,paste(u$batch_key,u$component,u$surface),sum)
 ae_need(max(abs(totals))<1e-10,'Batch delta balance failed')
 summary<-e$se_summary(p,u)
 summary$development_overall_states<-summary$development_surface_states<-NA_integer_
 summary$development_chain_residual<-summary$development_replay_residual<-NA_real_
 for(t in names(terminal$states)){
  j<-which(summary$record_type=='COVERAGE'&summary$level=='tour'&summary$tour==t&summary$stratum=='ALL')
  summary$development_overall_states[j]<-length(terminal$states[[t]]$g);summary$development_surface_states[j]<-length(terminal$states[[t]]$s)
  summary$development_chain_residual[j]<-terminal$chain_residual;summary$development_replay_residual[j]<-terminal$replay_residual
 }
 summary$version<-'2AE-1.0.0';summary$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
 setNames(list(p,u,summary),ae_outputs)
}
build_2024_surface_elo_baseline <- function(write_outputs=TRUE) {
 e<-ae_helpers();terminal<-ae_reconcile(e);i<-ae_prepare(e,terminal);r<-ae_build(i,terminal,e)
 if(write_outputs)e$se_install(r);r
}
if(sys.nframe()==0L){r<-build_2024_surface_elo_baseline();print(r[[3]][r[[3]]$record_type=='COVERAGE'&r[[3]]$level=='tour',c('tour','stratum','targets','overall_cold_slots','surface_cold_slots','min_primary','max_primary')],row.names=FALSE)}
