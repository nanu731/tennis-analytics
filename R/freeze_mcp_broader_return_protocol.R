# Completion eligibility and exposure only: no error numerators or scores.
source('R/build_mcp_repeated_player_sample.R')
broader_prefix <- 'data/pilot/mcp-broader-return-protocol-v1-'
broader_outputs <- c('match-eligibility','context-support','summary')
broader_count_fields <- c('tour','match_id','source_date','player','slot','player_a','player_b','event','surface','context','selected_player','observed_attempts','usable_attempts','withheld_attempts')
broader_pins <- c(
 'R/build_mcp_repeated_player_sample.R'='89ed023958ad378b89093f0b8235ca0ed9b631de21eb1b30d40f86a4ddb33a87',
 'docs/mcp-return-transfer-protocol.md'='fc012076f70e970493db5c6ff710add54e3efb87e2d116811b572c8110e68d36',
 'R/run_mcp_return_transfer.R'='4585e162b044e1a6e3b064fbd455692fa7540f67ec4767ffb68924dad91d5909',
 'data/pilot/mcp-stage1-match-inventory.csv'='aa06330bf214a18fbcb35117eee51a01adb592efaab0b4cbc36e59dad603ef04',
 'data/pilot/mcp-repeated-player-v1-sample.csv'='06bd5741f63fc47b8f9c683bad0ba5db543e45faea236e3290d10843ab574cdd',
 'data/pilot/mcp-repeated-player-v1-match-reconciliation.csv'='94ebcd4e2aa53a3214416b7c0b81aac695c8615f4b950d4e9f2d51378300f3e2',
 'data/pilot/mcp-repeated-player-v1-return-contexts.csv'='aa344121d581221b0aed12f3455b240cd1894c6a97b1219808f005ade2d1ec22')
broader_verify <- function() {
 repeat_verify()
 for(f in names(broader_pins))mcp_need(mcp_sha(f)==broader_pins[[f]],paste('Frozen input changed:',f))
 invisible(TRUE)
}
broader_load <- function() {
 broader_verify()
 read<-function(f,fields){x<-read.csv(f,stringsAsFactors=FALSE,check.names=FALSE);mcp_need(all(fields%in%names(x)),'Required evidence schema changed');x[,fields,drop=FALSE]}
 list(sample=read(paste0(repeat_prefix,'sample.csv'),c('match_id','tour_file','Date','player_a','player_b','event_label','Surface','points','selected_by')),
  evidence=read(paste0(mcp_prefix,'match-inventory.csv'),c('match_id','point_sequence_contiguous','starts_at_zero','bad_point_owner','status_note_cues','terminal_evidence')),
  completion=read(paste0(repeat_prefix,'match-reconciliation.csv'),c('match_id','expected_points','observed_points','point_total_agrees','chart_score_complete','score_conflict_points','terminal_conflicts')),
  counts=read(paste0(repeat_prefix,'return-contexts.csv'),broader_count_fields))
}
broader_eligibility <- function(input) {
 s<-input$sample;e<-input$evidence;m<-input$completion
 mcp_need(!anyDuplicated(s$match_id)&&!anyDuplicated(m$match_id)&&setequal(s$match_id,m$match_id),'Frozen sample/completion identity conflict')
 e<-e[e$match_id%in%s$match_id,];mcp_need(!anyDuplicated(e$match_id)&&setequal(e$match_id,s$match_id),'Missing/duplicate status identity')
 mcp_need(all(s$tour_file%in%c('ATP','WTA'))&&all(mcp_date_valid(as.character(s$Date)))&&all(nzchar(s$player_a)&nzchar(s$player_b)&s$player_a!=s$player_b),'Sample identity/date conflict')
 e<-e[match(s$match_id,e$match_id),];m<-m[match(s$match_id,m$match_id),]
 x<-cbind(s,e[,setdiff(names(e),'match_id'),drop=FALSE],m[,setdiff(names(m),'match_id'),drop=FALSE]);rownames(x)<-NULL
 reasons<-rep('',nrow(x));add<-function(mask,reason){mask[is.na(mask)]<-TRUE;reasons[mask]<<-ifelse(nzchar(reasons[mask]),paste(reasons[mask],reason,sep=';'),reason)}
 # All applicable reasons remain; unavailable internal evidence fails closed.
 add(is.na(x$status_note_cues),'STATUS_EVIDENCE_UNAVAILABLE')
 add(!is.na(x$status_note_cues)&x$status_note_cues>0,'STATUS_NOTE_CUE_REQUIRES_EXCLUSION')
 add(is.na(x$chart_score_complete),'CHART_COMPLETION_EVIDENCE_UNAVAILABLE')
 add(!is.na(x$chart_score_complete)&!x$chart_score_complete,'INCOMPLETE_CHART')
 add(is.na(x$terminal_conflicts),'TERMINAL_CONFLICT_EVIDENCE_UNAVAILABLE')
 add(!is.na(x$terminal_conflicts)&x$terminal_conflicts>0,'TERMINAL_OUTCOME_CONFLICT')
 add(x$score_conflict_points!=0,'SCORE_REPLAY_CONFLICT_OR_UNAVAILABLE')
 add(!x$point_total_agrees|x$expected_points!=x$points|x$observed_points!=x$points,'POINT_COVERAGE_CONFLICT_OR_UNAVAILABLE')
 add(!x$point_sequence_contiguous,'NONCONTIGUOUS_OR_UNKNOWN_POINTS')
 add(!x$starts_at_zero,'CHART_START_NOT_VERIFIED')
 add(x$bad_point_owner!=0,'POINT_OWNERSHIP_CONFLICT_OR_UNAVAILABLE')
 for(f in c('status_note_cues','terminal_conflicts','score_conflict_points','bad_point_owner'))
  mcp_need(all(is.na(x[[f]])|is.finite(x[[f]])&x[[f]]>=0&x[[f]]==floor(x[[f]])),'Malformed evidence count')
 x$exclusion_reasons<-reasons;x$eligible<-!nzchar(reasons)
 x$completion_basis<-ifelse(x$eligible,'INTERNALLY_CONSISTENT_CHART_ONLY','EXCLUDED_FROM_TARGETS_AND_HISTORIES')
 x$official_completion<-'NOT_VERIFIED_FROM_SAVED_EVIDENCE'
 x$source_date<-format(as.Date(as.character(x$Date),'%Y%m%d'),'%Y-%m-%d');x$batch_key<-paste(x$tour_file,x$source_date,sep='|')
 x$seed<-FALSE
 for(tour in c('ATP','WTA')){ii<-which(x$tour_file==tour&x$eligible);if(length(ii))x$seed[ii]<-x$source_date[ii]==min(x$source_date[ii])}
 x$match_disposition<-ifelse(!x$eligible,'COMPLETION_EXCLUDED',ifelse(x$seed,'SEED_NOT_EVALUATED','ELIGIBLE_EVALUATION_INVENTORY'))
 x[order(x$tour_file,x$source_date,x$match_id,method='radix'),]
}
broader_support <- function(counts,eligibility) {
 mcp_need(setequal(names(counts),broader_count_fields),'Availability-only fields required')
 x<-counts;e<-eligibility;key<-paste(x$match_id,x$slot,x$context,sep='|')
 wanted<-expand.grid(match_id=e$match_id,slot=c('A','B'),context=c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),stringsAsFactors=FALSE)
 mcp_need(!anyDuplicated(key)&&setequal(key,paste(wanted$match_id,wanted$slot,wanted$context,sep='|')),'Complete unique context inventory required')
 j<-match(x$match_id,e$match_id)
 mcp_need(!anyNA(j)&&all(x$tour==e$tour_file[j])&&all(x$source_date==e$source_date[j])&&all(x$player_a==e$player_a[j]&x$player_b==e$player_b[j]),'Context identity/date conflict')
 mcp_need(all(x$player==ifelse(x$slot=='A',e$player_a[j],e$player_b[j])),'Exact receiver identity required')
 for(f in c('observed_attempts','usable_attempts','withheld_attempts'))mcp_need(all(is.finite(x[[f]])&x[[f]]>=0&x[[f]]==floor(x[[f]])),'Invalid opportunity count')
 mcp_need(all(x$observed_attempts==x$usable_attempts+x$withheld_attempts)&&!any(x$usable_attempts[!x$context%in%c('FIRST','SECOND')]>0),'Opportunity accounting conflict')
 x$eligible<-e$eligible[j];x$seed<-e$seed[j];x$exclusion_reasons<-e$exclusion_reasons[j];x$batch_key<-e$batch_key[j]
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,x$context,method='radix'),];rows<-list()
 for(i in seq_len(nrow(x))){z<-x[i,];known<-z$context%in%c('FIRST','SECOND')
  prior<-x[x$eligible&x$tour==z$tour&x$context==z$context&x$source_date<z$source_date,]
  own<-prior[prior$player==z$player,];dates<-own$source_date[own$usable_attempts>0]
  n<-sum(own$usable_attempts);rn<-sum(prior$usable_attempts)
  # Completion first, then unknown context; original assessment precedence follows.
  reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(!known)'UNKNOWN_OR_UNSUPPORTED_CONTEXT' else if(z$seed)'SEED_NOT_EVALUATED' else if(z$usable_attempts==0)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(n==0)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else if(rn==0)'NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS' else 'PAIRED_SUPPORT_AVAILABLE'
  rows[[i]]<-cbind(z,data.frame(prior_matches=nrow(own),prior_usable_matches=sum(own$usable_attempts>0),prior_attempts=n,
   reference_matches=length(unique(prior$match_id)),reference_attempts=rn,
   prior_first_source_date=if(length(dates))min(dates) else '',prior_last_source_date=if(length(dates))max(dates) else '',
   days_since_first_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(min(dates))) else NA_real_,
   days_since_last_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else NA_real_,
   support_disposition=reason,paired_support=reason=='PAIRED_SUPPORT_AVAILABLE',stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
broader_summary <- function(e,h) {
 rows<-list();rng<-function(v,fun)if(length(v))fun(v) else NA_real_
 for(tour in c('ATP','WTA'))for(context in c('ALL','FIRST','SECOND')){
  m<-e[e$tour_file==tour,];z<-h[h$tour==tour,];if(context!='ALL')z<-z[z$context==context,]
  known<-z[z$context%in%c('FIRST','SECOND'),];a<-z[z$eligible,];p<-z[z$paired_support,]
  slots<-unique(p[,c('match_id','player')])
  rows[[length(rows)+1L]]<-data.frame(tour,context,inventory_matches=nrow(m),eligible_matches=sum(m$eligible),excluded_matches=sum(!m$eligible),
   eligible_batches=length(unique(m$source_date[m$eligible])),seed_matches=sum(m$seed),evaluation_matches=sum(m$eligible&!m$seed),
   inventory_context_targets=nrow(known),excluded_context_targets=sum(!known$eligible),seed_context_targets=sum(known$seed),
   supported_context_targets=nrow(p),supported_matches=length(unique(p$match_id)),supported_slots=nrow(slots),supported_players=length(unique(p$player)),
   supported_selected_players=length(unique(p$player[p$selected_player])),cold_start_context_targets=sum(known$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),
   no_target_context_targets=sum(known$support_disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),no_reference_context_targets=sum(known$support_disposition=='NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS'),
   inventory_observed_attempts=sum(z$observed_attempts),inventory_usable_attempts=sum(z$usable_attempts),
   eligible_observed_attempts=sum(a$observed_attempts),eligible_usable_attempts=sum(a$usable_attempts),eligible_withheld_attempts=sum(a$withheld_attempts),
   completion_excluded_usable_attempts=sum(z$usable_attempts[!z$eligible]),
   eligible_retention=if(sum(a$observed_attempts))sum(a$usable_attempts)/sum(a$observed_attempts) else NA_real_,
   supported_target_attempts=sum(p$usable_attempts),min_prior_matches=rng(p$prior_matches,min),max_prior_matches=rng(p$prior_matches,max),
   min_prior_attempts=rng(p$prior_attempts,min),max_prior_attempts=rng(p$prior_attempts,max),
   min_gap_days=rng(p$days_since_last_source_date,min),max_gap_days=rng(p$days_since_last_source_date,max),stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
freeze_mcp_broader_protocol <- function(input=broader_load()) {
 e<-broader_eligibility(input);h<-broader_support(input$counts,e)
 r<-list('match-eligibility'=e,'context-support'=h,summary=broader_summary(e,h))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_BROADER_RETURN_PROTOCOL_1.0.0';r[[k]]$revision<-mcp_revision
  r[[k]]$option<-'ALL_DATE_EXPANDING';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY'
  r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
  r[[k]]$claim<-'COMPLETION_ELIGIBILITY_AND_EXPOSURE_ONLY_NOT_ESTIMATION'}
 r
}
broader_install <- function(r) {
 mcp_need(identical(names(r),broader_outputs),'Exact output scope');paths<-paste0(broader_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.broader-protocol-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);broader_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing frozen protocol release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic output install failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline eligibility runner takes no arguments');r<-freeze_mcp_broader_protocol();broader_install(r);print(r$summary,row.names=FALSE)}
