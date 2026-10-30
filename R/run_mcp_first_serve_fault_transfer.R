# Unsmoothed physical first-serve fault frequency; no Return support mask reuse.
source('R/run_mcp_broader_return_transfer.R')
serve_prefix <- 'data/pilot/mcp-first-serve-fault-transfer-v1-'
serve_outputs <- c('observation-counts','target-estimates','paired-scores','stability','coverage-summary','summary')
serve_definition_pin <- '89633738adef6154286f81fd80c55604bcb5f649c560d3be524855c0c0a691dd'
serve_pins <- c(
 'R/summarize_mcp_execution.R'='c7a61b4a5b2398f1eb5ff5e4369579c065c338c4ae3b4cd8d662dd6f7a45470c',
 'docs/mcp-execution-summary-audit.md'='e0f3f2120b69691776983504d044b71974aab472dfb2de6b3543d23416cc6e5b')
serve_verify <- function() {
 wide_transfer_verify()
 for(f in names(serve_pins))mcp_need(mcp_sha(f)==serve_pins[[f]],paste('Frozen Serve definition changed:',f))
 # The prospective section is immutable even after measured results are appended.
 lines<-readLines('docs/mcp-first-serve-fault-transfer-results.md',warn=FALSE)
 cut<-match('## Measured coverage and denominators',lines);if(!is.na(cut))lines<-head(lines,cut-1L)
 while(length(lines)&&tail(lines,1)=='')lines<-head(lines,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(lines,f)
 mcp_need(mcp_sha(f)==serve_definition_pin,'Prospective Serve specification changed')
 invisible(TRUE)
}
serve_load <- function() {
 serve_verify()
 list(eligibility=read.csv(paste0(broader_prefix,'match-eligibility.csv'),stringsAsFactors=FALSE),
  states=read.csv(paste0(repeat_prefix,'action-states.csv'),stringsAsFactors=FALSE),
  actions=read.csv(paste0(repeat_prefix,'actions.csv'),stringsAsFactors=FALSE))
}
serve_context <- function(number)ifelse(is.na(number),'UNKNOWN',ifelse(number==1,'FIRST',ifelse(number==2,'SECOND','UNSUPPORTED')))
serve_check <- function(input) {
 e<-input$eligibility;s<-input$states;a<-input$actions
 mcp_need(nrow(e)==159&&!anyDuplicated(e$match_id)&&all(mcp_date_valid(gsub('-','',e$source_date,fixed=TRUE))),'Frozen inventory/date accounting')
 mcp_need(all(e$eligible%in%c(TRUE,FALSE))&&all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE'),'Frozen completion authority')
 mcp_need(!anyDuplicated(s$action_id)&&!anyDuplicated(a$action_id)&&setequal(s$action_id,a$action_id)&&setequal(s$match_id,e$match_id),'Action/match identity conflict')
 j<-match(s$action_id,a$action_id);k<-match(s$match_id,e$match_id)
 for(pair in list(c('post_kind','kind'),c('post_serve_number','serve_number'),c('owner_domain','domain'),c('actor_name','actor_name'),c('actor_neutral_slot','actor_neutral_slot'),c('match_id','match_id'),c('raw_token','raw_token')))
  mcp_need(identical(s[[pair[1]]],a[[pair[2]]][j]),paste('Frozen parser/state authority:',pair[1]))
 mcp_need(all(s$tour_file==e$tour_file[k])&&all(s$revision==mcp_revision),'Category/provenance conflict')
 physical<-s$post_kind%in%c('SERVE','SERVE_FAULT')
 mcp_need(all(s$owner_domain[physical]=='Serve'&s$owner_role[physical]=='SERVER')&&all(s$actor_neutral_slot[physical]%in%c('A','B')),'Unique server-owned physical attempts')
 expected<-ifelse(s$actor_neutral_slot=='A',e$player_a[k],e$player_b[k])
 mcp_need(all(s$actor_name[physical]==expected[physical]),'Neutral server identity')
 mcp_need(all(s$tennis_action_usable[physical]==(s$transition_usable[physical]&!a$is_void[j[physical]]))&&
  !any(s$tennis_action_usable[physical]&(!s$point_validated[physical]|s$score_reconciliation_status[physical]!='PASS'|!s$local_boundary_supported[physical])),'Frozen usability gate conflict')
 mcp_need(!any(s$tennis_action_usable[s$post_kind%in%c('LET','FIRST_SERVE_FORFEIT','OUTCOME_ONLY','UNSUPPORTED_SUFFIX','POINT_PENALTY')]),'Void/admin/missing observations cannot gain attempt credit')
 invisible(TRUE)
}
serve_counts <- function(input) {
 serve_check(input);e<-input$eligibility;s<-input$states
 grid<-expand.grid(match_id=e$match_id,slot=c('A','B'),context=c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),stringsAsFactors=FALSE)
 j<-match(grid$match_id,e$match_id)
 x<-data.frame(tour=e$tour_file[j],match_id=grid$match_id,source_date=e$source_date[j],player=ifelse(grid$slot=='A',e$player_a[j],e$player_b[j]),slot=grid$slot,player_a=e$player_a[j],player_b=e$player_b[j],event=e$event_label[j],surface=e$Surface[j],context=grid$context,eligible=e$eligible[j],seed=e$seed[j],exclusion_reasons=e$exclusion_reasons[j],batch_key=e$batch_key[j],stringsAsFactors=FALSE)
 p<-s[s$post_kind%in%c('SERVE','SERVE_FAULT'),];key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
 k<-match(paste(p$match_id,p$actor_neutral_slot,serve_context(p$post_serve_number),sep='|'),key(x));mcp_need(!anyNA(k),'Physical attempt/context join')
 tally<-function(mask)tabulate(k[mask],nrow(x));u<-p$tennis_action_usable
 x$observed_attempts<-tally(rep(TRUE,nrow(p)));x$usable_attempts<-tally(u);x$withheld_attempts<-tally(!u)
 x$errors<-tally(u&p$post_kind=='SERVE_FAULT');x$first_serve_faults<-ifelse(x$context=='FIRST',x$errors,NA_integer_)
 x$known_serve_unknown_attributes<-tally(u&nzchar(p$post_explicit_unknowns))
 mcp_need(all(x$observed_attempts==x$usable_attempts+x$withheld_attempts&x$errors<=x$usable_attempts),'Physical denominator/fault partition')
 mcp_need(!any(x$usable_attempts[!x$context%in%c('FIRST','SECOND')]>0),'Unknown serve number cannot enter a usable denominator')
 x$context_disposition<-ifelse(!x$eligible,'COMPLETION_EXCLUDED',ifelse(x$context=='FIRST','TARGET_CONTEXT',ifelse(x$context=='SECOND','INVENTORIED_NOT_TARGET_CONTEXT','UNKNOWN_OR_UNSUPPORTED_CONTEXT')))
 x$withheld_disposition<-ifelse(x$withheld_attempts>0,'WITHHELD_ACTION','NONE')
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,x$context,method='radix'),];rownames(x)<-NULL;x
}
serve_estimates <- function(counts) {
 x<-counts[counts$context=='FIRST',];rows<-list()
 for(i in seq_len(nrow(x))){z<-x[i,];prior<-x[x$eligible&x$tour==z$tour&x$source_date<z$source_date,];own<-prior[prior$player==z$player,]
  n<-sum(own$usable_attempts);e<-sum(own$errors);rn<-sum(prior$usable_attempts);re<-sum(prior$errors);dates<-own$source_date[own$usable_attempts>0]
  reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(z$seed)'SEED_NOT_EVALUATED' else if(!z$usable_attempts)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(!n)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else if(!rn)'NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS' else 'PAIRED_SUPPORTED'
  paired<-reason=='PAIRED_SUPPORTED';q<-if(z$eligible)execution_ratio(e,n) else NA_real_;rq<-if(z$eligible)execution_ratio(re,rn) else NA_real_
  loss<-function(prob,type)if(!paired)NA_real_ else if(type=='brier')(z$errors*(1-prob)^2+(z$usable_attempts-z$errors)*prob^2)/z$usable_attempts else transfer_log_sum(z$errors,z$usable_attempts,prob)/z$usable_attempts
  rows[[i]]<-cbind(z,data.frame(prior_matches=length(unique(own$match_id)),prior_usable_matches=sum(own$usable_attempts>0),prior_attempts=n,prior_errors=e,reference_matches=length(unique(prior$match_id)),reference_attempts=rn,reference_errors=re,
   prior_first_date=if(length(dates))min(dates) else '',prior_last_date=if(length(dates))max(dates) else '',days_since_last_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else NA_real_,
   personal_estimate=q,reference_estimate=rq,disposition=reason,paired_mask=paired,target_error_rate=execution_ratio(z$errors,z$usable_attempts),
   signed_departure=if(paired)z$errors/z$usable_attempts-q else NA_real_,absolute_departure=if(paired)abs(z$errors/z$usable_attempts-q) else NA_real_,
   personal_brier=loss(q,'brier'),reference_brier=loss(rq,'brier'),personal_log_loss=loss(q,'log'),reference_log_loss=loss(rq,'log'),stringsAsFactors=FALSE))
 }
 x<-do.call(rbind,rows)
 cause<-function(q,loss)ifelse(!x$paired_mask,'NOT_SCORED',ifelse(!is.infinite(loss),'NONE',ifelse(q==0&x$errors>0,'ZERO_ESTIMATE_WITH_TARGET_FAULTS',ifelse(q==1&x$usable_attempts>x$errors,'ONE_ESTIMATE_WITH_TARGET_NONFAULTS','UNRESOLVED_STOP'))))
 x$personal_infinite_cause<-cause(x$personal_estimate,x$personal_log_loss);x$reference_infinite_cause<-cause(x$reference_estimate,x$reference_log_loss)
 mcp_need(!any(x$personal_infinite_cause=='UNRESOLVED_STOP'|x$reference_infinite_cause=='UNRESOLVED_STOP'),'Unexplained endpoint loss');rownames(x)<-NULL;x
}
serve_coverage <- function(input,counts) {
 e<-input$eligibility;s<-input$states;rows<-list()
 for(i in seq_len(nrow(e))){z<-e[i,];a<-s[s$match_id==z$match_id,];c<-counts[counts$match_id==z$match_id,]
  row<-data.frame(tour=z$tour_file,match_id=z$match_id,source_date=z$source_date,player_a=z$player_a,player_b=z$player_b,event=z$event_label,surface=z$Surface,eligible=z$eligible,seed=z$seed,exclusion_reasons=z$exclusion_reasons,points=z$points,stringsAsFactors=FALSE)
  for(context in c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'))for(field in c('observed_attempts','usable_attempts','withheld_attempts','errors'))row[[paste0(tolower(context),'_',field)]]<-sum(c[[field]][c$context==context])
  row$void_lets<-sum(a$post_kind=='LET');row$administrative_first_serve_forfeits<-sum(a$post_kind=='FIRST_SERVE_FORFEIT')
  row$missing_observation_rows<-sum(a$missing_observation);row$unsupported_observation_rows<-sum(a$unsupported_observation)
  row$unresolved_owner_rows<-sum(a$owner_domain=='UNRESOLVED');row$authority_conflict_rows<-sum(a$authority_conflict)
  row$unknown_unobserved_attempt_count<-'NOT_IDENTIFIABLE';row$first_attempt_retention<-execution_ratio(row$first_usable_attempts,row$first_observed_attempts)
  rows[[i]]<-row
 }
 y<-do.call(rbind,rows);y<-y[order(y$tour,y$source_date,y$match_id,method='radix'),];rownames(y)<-NULL;y
}
serve_summary <- function(x,coverage) {
 rows<-list()
 for(tour in c('ATP','WTA')){z<-x[x$tour==tour,];v<-z[z$paired_mask,];c<-coverage[coverage$tour==tour,];eligible<-z[z$eligible,]
  row<-data.frame(tour,inventory_matches=nrow(c),eligible_matches=sum(c$eligible),seed_matches=sum(c$eligible&c$seed),evaluation_matches=sum(c$eligible&!c$seed),paired_cells=nrow(v),scored_matches=length(unique(v$match_id)),scored_identities=length(unique(v$player)),
   inventory_first_attempts=sum(z$observed_attempts),inventory_usable_first_attempts=sum(z$usable_attempts),eligible_first_attempts=sum(eligible$observed_attempts),eligible_usable_first_attempts=sum(eligible$usable_attempts),eligible_withheld_first_attempts=sum(eligible$withheld_attempts),eligible_faults=sum(eligible$errors),eligible_retention=execution_ratio(sum(eligible$usable_attempts),sum(eligible$observed_attempts)),
   personal_infinite_cells=sum(is.infinite(v$personal_log_loss)),reference_infinite_cells=sum(is.infinite(v$reference_log_loss)),personal_zero_cells=sum(v$personal_estimate==0),personal_one_cells=sum(v$personal_estimate==1),void_lets=sum(c$void_lets),missing_observation_rows=sum(c$missing_observation_rows),unsupported_observation_rows=sum(c$unsupported_observation_rows),stringsAsFactors=FALSE)
  for(reason in unique(z$disposition))row[[paste0('disposition_',reason)]]<-sum(z$disposition==reason)
  for(field in c('prior_attempts','prior_usable_matches','days_since_last_source_date','usable_attempts'))for(type in c('min','max'))row[[paste(type,field,sep='_')]]<-if(nrow(v))get(type)(v[[field]]) else NA_real_
  rows[[tour]]<-row
 }
 do.call(rbind,rows)
}
run_mcp_serve_transfer <- function(input=serve_load()) {
 counts<-serve_counts(input);x<-serve_estimates(counts);cov<-serve_coverage(input,counts)
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)cbind(data.frame(tour,context='FIRST'),transfer_score(x[x$tour==tour,]))))
 r<-list('observation-counts'=counts,'target-estimates'=x,'paired-scores'=scores,stability=transfer_stability(x[x$eligible,]),'coverage-summary'=cov,summary=serve_summary(x,cov))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_FIRST_SERVE_FAULT_TRANSFER_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$measurement<-'PHYSICAL_FIRST_SERVE_FAULT_FREQUENCY';r[[k]]$option<-'ALL_DATE_EXPANDING';r[[k]]$claim<-'RETROSPECTIVE_OBSERVED_QA_USABLE_SERVE_ATTEMPTS_INTERNAL_CHART_COMPLETION_ONLY';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
serve_install <- function(r) {
 mcp_need(identical(names(r),serve_outputs),'Exact Serve output scope');paths<-paste0(serve_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.serve-transfer-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);serve_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing Serve release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file installation failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline experiment takes no arguments');r<-run_mcp_serve_transfer();serve_install(r)
 print(r$summary,row.names=FALSE);print(r[['paired-scores']][,c('tour','paired_cells','scored_matches','difference_brier','difference_log_loss','difference_brier_opportunity_weighted','difference_log_loss_opportunity_weighted')],row.names=FALSE)}
