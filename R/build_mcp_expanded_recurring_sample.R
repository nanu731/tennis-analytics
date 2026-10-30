# Same selected players, earliest ten with ties; availability only, no scoring.
source('R/freeze_mcp_broader_return_protocol.R')
expand_prefix <- 'data/pilot/mcp-expanded-recurring-v1-'
expand_outputs <- c('selection-dispositions','player-selection','sample','actions','point-reconciliation','match-reconciliation','reason-summary','decoded-examples','parser-summary','action-states','serve-plus1','state-coverage','field-provenance','match-eligibility','opportunity-counts','history-support','player-support','coverage-summary','incremental-support')
expand_pins <- c(
 'R/freeze_mcp_broader_return_protocol.R'='97b8588509e9da65ca99d5a4f1c94579e154d3ccd21da903e2eeb2e341dcaf3b',
 'data/pilot/mcp-repeated-player-v1-player-selection.csv'='7f50f7519f11852a31fa1bc22d479151f19f2b2af30d56c5d22e8985ec7eed3a',
 'data/pilot/mcp-broader-return-protocol-v1-match-eligibility.csv'='c54ea1ad73b9d228979235b8090a705b2d01d29107433431d9b9eacf11c8eda3')
expand_verify <- function() {
 broader_verify()
 for(f in names(expand_pins))mcp_need(mcp_sha(f)==expand_pins[[f]],paste('Frozen expansion authority changed:',f))
 invisible(TRUE)
}
expand_original <- function()list(players=read.csv(paste0(repeat_prefix,'player-selection.csv'),stringsAsFactors=FALSE),sample=read.csv(paste0(repeat_prefix,'sample.csv'),stringsAsFactors=FALSE),eligibility=read.csv(paste0(broader_prefix,'match-eligibility.csv'),stringsAsFactors=FALSE))
expand_select <- function(inventory,original) {
 hashes<-setNames(original$players$selection_hash,paste(original$players$tour,original$players$player,sep='|'))
 memo<-function(tour,player){key<-paste(tour,player,sep='|');mcp_need(key%in%names(hashes),'Unexpected candidate identity');unname(hashes[[key]])}
 r<-repeat_select(inventory,hash=memo,matches=10L);p<-r[['player-selection']];old<-original$players
 key<-function(x)paste(x$tour[x$selected],x$player[x$selected],sep='|')
 mcp_need(sum(p$selected)==40&&all(table(p$tour[p$selected])==20)&&identical(key(p),key(old)),'Frozen forty-player selection changed; no replacement')
 mcp_need(all(original$sample$match_id%in%r$sample$match_id),'Original sample must remain inventoried')
 r$sample$inventory_origin<-ifelse(r$sample$match_id%in%original$sample$match_id,'ORIGINAL_FIVE_MATCH_SAMPLE','ADDED_TEN_MATCH_SAMPLE')
 r
}
expand_eligibility <- function(sample,metadata,completion,original) {
 fields<-c('match_id','tour_file','Date','player_a','player_b','event_label','Surface','points','selected_by')
 # Match the frozen read.csv loader's evidence types; preserve the raw frame.
 evidence<-metadata[,c('match_id','point_sequence_contiguous','starts_at_zero','bad_point_owner','status_note_cues','terminal_evidence')]
 for(f in c('point_sequence_contiguous','starts_at_zero'))evidence[[f]]<-as.logical(evidence[[f]])
 for(f in c('bad_point_owner','status_note_cues'))evidence[[f]]<-suppressWarnings(as.numeric(evidence[[f]]))
 e<-broader_eligibility(list(sample=sample[,fields],evidence=evidence,completion=completion[,c('match_id','expected_points','observed_points','point_total_agrees','chart_score_complete','score_conflict_points','terminal_conflicts')]))
 old<-original$eligibility;j<-match(old$match_id,e$match_id)
 for(f in c('eligible','exclusion_reasons','source_date','player_a','player_b','seed'))mcp_need(identical(e[[f]][j],old[[f]]),paste('Original completion disposition changed:',f))
 e$inventory_origin<-sample$inventory_origin[match(e$match_id,sample$match_id)];e
}
expand_opportunities <- function(states,sample,players) {
 s<-states[['action-states']];pl<-states[['serve-plus1']]
 spec<-data.frame(domain=c(rep('Serve',4),rep('Return',4),'Rally','Serve +1'),context=c(rep(c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),2),'ALL','ALL'),stringsAsFactors=FALSE)
 grid<-expand.grid(match_id=sample$match_id,slot=c('A','B'),spec=seq_len(nrow(spec)),stringsAsFactors=FALSE);j<-match(grid$match_id,sample$match_id)
 x<-data.frame(tour=sample$tour_file[j],match_id=grid$match_id,source_date=format(as.Date(sample$Date[j],'%Y%m%d'),'%Y-%m-%d'),player=ifelse(grid$slot=='A',sample$player_a[j],sample$player_b[j]),slot=grid$slot,player_a=sample$player_a[j],player_b=sample$player_b[j],event=sample$event_label[j],surface=sample$Surface[j],domain=spec$domain[grid$spec],context=spec$context[grid$spec],inventory_origin=sample$inventory_origin[j],stringsAsFactors=FALSE)
 x$selected_player<-paste(x$tour,x$player,sep='|')%in%paste(players$tour[players$selected],players$player[players$selected],sep='|')
 key<-function(z)paste(z$match_id,z$slot,z$domain,z$context,sep='|')
 physical<-s$post_kind%in%c('SERVE','SERVE_FAULT','STROKE');mi<-match(s$match_id,sample$match_id)
 expected<-ifelse(s$actor_neutral_slot=='A',sample$player_a[mi],sample$player_b[mi])
 mcp_need(!anyDuplicated(s$action_id)&&all(s$actor_name[physical]==expected[physical])&&all(s$actor_neutral_slot[physical]%in%c('A','B')),'Physical action ownership conflict')
 number<-ifelse(is.na(s$post_serve_number),'UNKNOWN',ifelse(s$post_serve_number==1,'FIRST',ifelse(s$post_serve_number==2,'SECOND','UNSUPPORTED')))
 ret<-s$owner_domain=='Return'&s$post_kind=='STROKE';number[ret]<-context_classify(s[ret,context_pre_fields,drop=FALSE],'Return')$serve_number
 context<-ifelse(s$owner_domain=='Rally','ALL',number)
 k<-match(paste(s$match_id,s$actor_neutral_slot,s$owner_domain,context,sep='|'),key(x));mcp_need(!anyNA(k[physical]),'Physical action/context join')
 count<-function(mask)tabulate(k[mask],nrow(x))
 x$observed_attempts<-count(physical);x$usable_attempts<-count(physical&s$tennis_action_usable);x$withheld_attempts<-x$observed_attempts-x$usable_attempts
 x$known_absences<-0L;x$unknown_opportunities<-0L;x$unvalidated_observed_prefixes<-0L
 # Exact server-to-neutral mapping is derived from observed parser identity, not outcomes.
 server_rows<-s[s$owner_domain=='Serve',c('match_id','server','actor_neutral_slot')];server_rows<-unique(server_rows)
 mcp_need(!anyDuplicated(paste(server_rows$match_id,server_rows$server))&&all(server_rows$actor_neutral_slot%in%c('A','B')),'Ambiguous saved server identity')
 pj<-match(paste(pl$match_id,pl$server),paste(server_rows$match_id,server_rows$server));mcp_need(!anyNA(pj),'Missing +1 server identity')
 pk<-match(paste(pl$match_id,server_rows$actor_neutral_slot[pj],'Serve +1','ALL',sep='|'),key(x));mcp_need(!anyNA(pk),'Plus-one opportunity join')
 pc<-function(mask)tabulate(pk[mask],nrow(x))
 x$observed_attempts<-x$observed_attempts+pc(pl$observed_prefix);x$usable_attempts<-x$usable_attempts+pc(pl$usable_attempt)
 x$withheld_attempts<-x$observed_attempts-x$usable_attempts
 x$known_absences<-pc(pl$disposition=='KNOWN_ABSENT');x$unknown_opportunities<-pc(pl$disposition=='UNKNOWN_OPPORTUNITY')
 x$unvalidated_observed_prefixes<-pc(pl$disposition=='UNVALIDATED_OBSERVED_PREFIX')
 mcp_need(all(x$observed_attempts==x$usable_attempts+x$withheld_attempts)&&all(x$usable_attempts>=0),'Opportunity/withholding accounting')
 x$retention<-ifelse(x$observed_attempts>0,x$usable_attempts/x$observed_attempts,NA_real_)
 x$denominator_basis<-ifelse(x$domain=='Serve +1','OBSERVED_PLUS1_PREFIXES;UNKNOWN_OPPORTUNITIES_SEPARATE','OBSERVED_OWNED_NONVOID_PHYSICAL_ATTEMPTS')
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,x$domain,x$context,method='radix'),];rownames(x)<-NULL;x
}
expand_history <- function(counts,eligibility) {
 x<-counts;j<-match(x$match_id,eligibility$match_id);mcp_need(!anyNA(j),'History completion identity missing')
 x$eligible<-eligibility$eligible[j];x$seed<-eligibility$seed[j];x$exclusion_reasons<-eligibility$exclusion_reasons[j];x$batch_key<-eligibility$batch_key[j];rows<-list()
 for(i in seq_len(nrow(x))){z<-x[i,];prior<-x[x$eligible&x$tour==z$tour&x$player==z$player&x$domain==z$domain&x$context==z$context&x$source_date<z$source_date,];usable<-prior[prior$usable_attempts>0,];known<-z$context%in%c('FIRST','SECOND','ALL');n<-sum(prior$usable_attempts)
  reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(!known)'UNKNOWN_OR_UNSUPPORTED_CONTEXT' else if(z$seed)'SEED_NOT_EVALUATED' else if(z$usable_attempts==0)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(n==0)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else 'PRIOR_SUPPORT_AVAILABLE'
  rows[[i]]<-cbind(z,data.frame(prior_matches=nrow(prior),prior_usable_matches=nrow(usable),prior_batches=length(unique(usable$source_date)),prior_attempts=n,prior_withheld_attempts=sum(prior$withheld_attempts),prior_old_attempts=sum(prior$usable_attempts[prior$inventory_origin=='ORIGINAL_FIVE_MATCH_SAMPLE']),prior_added_attempts=sum(prior$usable_attempts[prior$inventory_origin=='ADDED_TEN_MATCH_SAMPLE']),prior_first_date=if(nrow(usable))min(usable$source_date) else '',prior_last_date=if(nrow(usable))max(usable$source_date) else '',source_gap_days=if(nrow(usable))as.numeric(as.Date(z$source_date)-as.Date(max(usable$source_date))) else NA_real_,support_disposition=reason,supported=reason=='PRIOR_SUPPORT_AVAILABLE',stringsAsFactors=FALSE))
 }
 y<-do.call(rbind,rows);rownames(y)<-NULL;y
}
expand_player_support <- function(history) {
 h<-history;keys<-unique(paste(h$tour,h$player,h$domain,h$context,sep='|'));rows<-list()
 for(key in keys){z<-h[paste(h$tour,h$player,h$domain,h$context,sep='|')==key,];a<-z[z$eligible,];p<-z[z$supported,]
  rows[[length(rows)+1L]]<-data.frame(tour=z$tour[1],player=z$player[1],selected_player=z$selected_player[1],domain=z$domain[1],context=z$context[1],inventory_matches=nrow(z),eligible_matches=nrow(a),eligible_batches=length(unique(a$source_date)),usable_matches=sum(a$usable_attempts>0),usable_batches=length(unique(a$source_date[a$usable_attempts>0])),supported_targets=nrow(p),cold_starts=sum(z$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),eligible_observed_attempts=sum(a$observed_attempts),eligible_usable_attempts=sum(a$usable_attempts),eligible_withheld_attempts=sum(a$withheld_attempts),max_prior_usable_matches=if(nrow(p))max(p$prior_usable_matches) else NA_integer_,max_prior_attempts=if(nrow(p))max(p$prior_attempts) else NA_real_,stringsAsFactors=FALSE)
 }
 y<-do.call(rbind,rows);y<-y[order(y$tour,y$selected_player,y$player,y$domain,y$context,method='radix'),];rownames(y)<-NULL;y
}
expand_coverage <- function(history,eligibility,states) {
 h<-history;rows<-list()
 for(tour in c('ATP','WTA'))for(view in unique(paste(h$domain,h$context,sep='|'))){z<-h[h$tour==tour&paste(h$domain,h$context,sep='|')==view,];a<-z[z$eligible,];p<-z[z$supported,];e<-eligibility[eligibility$tour_file==tour,];s<-states[['action-states']][states[['action-states']]$tour_file==tour,]
  row<-data.frame(tour,domain=z$domain[1],context=z$context[1],inventory_matches=nrow(e),added_matches=sum(e$inventory_origin=='ADDED_TEN_MATCH_SAMPLE'),eligible_matches=sum(e$eligible),excluded_matches=sum(!e$eligible),inventory_batches=length(unique(e$source_date)),eligible_batches=length(unique(e$source_date[e$eligible])),source_date_min=min(e$source_date),source_date_max=max(e$source_date),points=sum(e$points),selected_players=length(unique(z$player[z$selected_player])),distinct_players=length(unique(z$player)),opponent_only_players=length(unique(z$player[!z$selected_player])),supported_targets=nrow(p),supported_matches=length(unique(p$match_id)),supported_players=length(unique(p$player)),supported_selected_players=length(unique(p$player[p$selected_player])),cold_starts=sum(z$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),no_target_attempts=sum(z$support_disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),inventory_observed_attempts=sum(z$observed_attempts),inventory_usable_attempts=sum(z$usable_attempts),eligible_observed_attempts=sum(a$observed_attempts),eligible_usable_attempts=sum(a$usable_attempts),eligible_withheld_attempts=sum(a$withheld_attempts),eligible_retention=if(sum(a$observed_attempts))sum(a$usable_attempts)/sum(a$observed_attempts) else NA_real_,eligible_known_absences=sum(a$known_absences),eligible_unknown_opportunities=sum(a$unknown_opportunities),eligible_unvalidated_prefixes=sum(a$unvalidated_observed_prefixes),missing_observation_rows=sum(s$missing_observation),unsupported_observation_rows=sum(s$unsupported_observation),authority_conflict_rows=sum(s$authority_conflict),unknown_unobserved_attempt_count='NOT_IDENTIFIABLE',stringsAsFactors=FALSE)
  for(field in c('prior_usable_matches','prior_attempts','source_gap_days'))for(type in c('min','median','max'))row[[paste(type,field,sep='_')]]<-if(nrow(p))get(type)(p[[field]]) else NA_real_
  rows[[length(rows)+1L]]<-row
 }
 do.call(rbind,rows)
}
expand_incremental <- function(history,baseline) {
 rows<-list();key<-function(z)paste(z$match_id,z$slot,z$domain,z$context,sep='|')
 for(tour in c('ATP','WTA'))for(view in unique(paste(history$domain,history$context,sep='|'))){z<-history[history$tour==tour&paste(history$domain,history$context,sep='|')==view,];old<-baseline[baseline$tour==tour&paste(baseline$domain,baseline$context,sep='|')==view,];common<-z[match(key(old),key(z)),];added<-z[z$inventory_origin=='ADDED_TEN_MATCH_SAMPLE',];op<-old[old$supported,];ep<-z[z$supported,]
  mcp_need(!anyNA(common$match_id)&&all(common$usable_attempts==old$usable_attempts)&&all(common$eligible==old$eligible)&&all(common$prior_attempts>=old$prior_attempts),'Original targets/counts/eligibility must be preserved; prior exposure can only grow')
  rows[[length(rows)+1L]]<-data.frame(tour,domain=z$domain[1],context=z$context[1],original_supported_targets=nrow(op),expanded_supported_targets=nrow(ep),common_target_support_gains=sum(common$supported&!old$supported),added_supported_targets=sum(added$supported),original_supported_players=length(unique(op$player)),expanded_supported_players=length(unique(ep$player)),new_supported_players=length(setdiff(unique(ep$player),unique(op$player))),original_supported_selected_players=length(unique(op$player[op$selected_player])),expanded_supported_selected_players=length(unique(ep$player[ep$selected_player])),original_eligible_usable_attempts=sum(old$usable_attempts[old$eligible]),expanded_eligible_usable_attempts=sum(z$usable_attempts[z$eligible]),common_targets_with_deeper_history=sum(common$prior_usable_matches>old$prior_usable_matches),common_max_history_gain=max(common$prior_usable_matches-old$prior_usable_matches),original_cold_starts=sum(old$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),expanded_cold_starts=sum(z$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
build_mcp_expanded_sample <- function(inventory=NULL,progress=FALSE) {
 expand_verify();original<-expand_original();if(is.null(inventory))inventory<-repeat_inventory()
 selection<-expand_select(inventory,original);sample<-selection$sample
 if(progress)cat('Ten-match selection frozen:',nrow(sample),'matches; same forty players\n')
 input<-repeat_points(sample);if(progress)cat('Pinned points loaded:',nrow(input$points),'\n')
 parser<-action_build(input);if(progress)cat('Frozen parser complete\n')
 states<-repeat_states(parser,sample);if(progress)cat('Frozen state rules complete\n')
 e<-expand_eligibility(sample,input$metadata,parser[['match-reconciliation']],original)
 counts<-expand_opportunities(states,sample,selection[['player-selection']]);history<-expand_history(counts,e)
 oldcounts<-counts[counts$inventory_origin=='ORIGINAL_FIVE_MATCH_SAMPLE',];baseline<-expand_history(oldcounts,original$eligibility)
 names(parser)[names(parser)=='summary']<-'parser-summary';names(states)[names(states)=='coverage-summary']<-'state-coverage'
 r<-c(selection,parser,states,list('match-eligibility'=e,'opportunity-counts'=counts,'history-support'=history,'player-support'=expand_player_support(history),'coverage-summary'=expand_coverage(history,e,states),'incremental-support'=expand_incremental(history,baseline)))
 for(k in names(r)){r[[k]]$component_release<-if('release'%in%names(r[[k]]))r[[k]]$release else 'CONTEXT_SELECTION_COMPLETION_OR_OBSERVABLE_SUPPORT';r[[k]]$release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$claim<-'EXPANDED_SUPPORT_INVENTORY_NOT_FACTOR_VALIDATION';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';rownames(r[[k]])<-NULL}
 mcp_need(identical(names(r),expand_outputs),'Exact expanded output scope');r
}
expand_install <- function(r) {
 mcp_need(identical(names(r),expand_outputs),'Expanded output scope');paths<-paste0(expand_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.mcp-expanded-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);expand_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing expanded release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file install failed');invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline builder takes no arguments');r<-build_mcp_expanded_sample(progress=TRUE);expand_install(r)
 keep<-r[['coverage-summary']]$context%in%c('FIRST','ALL');print(r[['coverage-summary']][keep,c('tour','domain','context','inventory_matches','eligible_matches','supported_targets','supported_players','eligible_usable_attempts','eligible_retention','median_prior_usable_matches','max_prior_usable_matches')],row.names=FALSE)}
