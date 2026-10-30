# Execute the frozen conditional +1 measurement; numerical helpers are unchanged.
source('R/build_mcp_serve_plus1_protocol.R')
source('R/run_mcp_broader_return_transfer.R')
plus_transfer_prefix <- 'data/pilot/mcp-serve-plus1-transfer-v1-'
plus_transfer_outputs <- c('observation-counts','target-estimates','paired-scores','stability','coverage-summary','summary')
plus_transfer_pins <- c(
 'R/build_mcp_serve_plus1_protocol.R'='2ed4762638e3998f62186c490cd648a7469dcba87aab906dbd979b154dc237b4',
 'R/run_mcp_broader_return_transfer.R'='172076d3cf727e2b4bd796bfb69168448238690539e8df34d2ea18396305956c',
 'docs/mcp-serve-plus1-transfer-protocol.md'='4ff44f1242874c14f8dedcb604de94a6a548f91218a5f1c016d044bbba3e5424',
 'point-opportunity-dispositions'='6cfa061d57cbedc0e9e2d94f71c0f797ba8d42a7b46c8adc622199a3553c20bc',
 'context-counts'='215edf35024cb12cc3db4244be0b4b532c141eb37c1f85f3e2f581bad75c3e09',
 'context-support'='68e96ed0419d1026451c9ab219dd3c6754565b814f9414bb2fb2386f56de0450',
 'match-coverage'='f92f6df40ec6092a068d0c4dcc390dde56129dbd0a63e9c8d09098246c05a4f0',
 'summary'='dbf4dc9140ad65af4b1c96bd76e5bea426920227efa3a988759b826c3babcee5')
plus_transfer_verify <- function() {
 plus_protocol_verify()
 for(k in names(plus_transfer_pins)) {
  path<-if(k%in%plus_protocol_outputs)paste0(plus_protocol_prefix,k,'.csv') else k
  mcp_need(mcp_sha(path)==plus_transfer_pins[[k]],paste('Frozen +1 execution pin changed:',k))
 }
 invisible(TRUE)
}
plus_transfer_load <- function() {
 plus_transfer_verify();input<-plus_protocol_load()
 input$frozen<-setNames(lapply(plus_protocol_outputs,function(k)read.csv(paste0(plus_protocol_prefix,k,'.csv'),stringsAsFactors=FALSE)),plus_protocol_outputs)
 input
}
plus_transfer_key <- function(x)paste(x$match_id,x$slot,x$context,sep='|')
plus_transfer_support <- function(input) {
 # Availability and the complete supported-ID mask are checked before numerators.
 b<-input$frozen[['point-opportunity-dispositions']];c<-input$frozen[['context-counts']];h<-input$frozen[['context-support']]
 rebuilt_b<-plus_protocol_points(input);mcp_need(nrow(b)==43310&&!anyDuplicated(b$point_id),'Complete point inventory')
 j<-match(b$point_id,rebuilt_b$point_id);mcp_need(!anyNA(j),'Frozen point join')
 for(f in setdiff(names(b),c('release','sample_release','revision','owner_domain','option','claim','chronology','exposure','uncertainty')))
  mcp_need(identical(b[[f]],rebuilt_b[[f]][j]),paste('Frozen point availability mismatch:',f))
 rebuilt_c<-plus_protocol_counts(input,b);j<-match(plus_transfer_key(c),plus_transfer_key(rebuilt_c))
 mcp_need(nrow(c)==1784&&!anyDuplicated(plus_transfer_key(c))&&!anyNA(j),'Complete context inventory')
 for(f in names(rebuilt_c))mcp_need(isTRUE(all.equal(c[[f]],rebuilt_c[[f]][j],tolerance=if(f=='retention')1e-12 else 0,scale=1,check.attributes=FALSE)),paste('Frozen count mismatch:',f))
 rebuilt<-broader_support(c[,broader_count_fields,drop=FALSE],input$eligibility)
 j<-match(plus_transfer_key(rebuilt),plus_transfer_key(h));mcp_need(nrow(h)==1784&&!anyNA(j)&&!anyDuplicated(plus_transfer_key(h)),'Frozen support identity')
 for(f in names(rebuilt))mcp_need(isTRUE(all.equal(rebuilt[[f]],h[[f]][j],tolerance=0,check.attributes=FALSE)),paste('Frozen support mismatch:',f))
 mcp_need(sum(h$paired_support)==504&&identical(sort(plus_transfer_key(h[h$paired_support,])),sort(plus_transfer_key(rebuilt[rebuilt$paired_support,]))),'Exact 504 supported context IDs required')
 for(tour in c('ATP','WTA'))for(context in c('FIRST','SECOND')) {
  expected<-if(tour=='ATP')if(context=='FIRST')120L else 118L else if(context=='FIRST')134L else 132L
  mcp_need(sum(h$paired_support&h$tour==tour&h$context==context)==expected,'Frozen category/context support count')
 }
 invisible(TRUE)
}
plus_transfer_counts <- function(input) {
 plus_transfer_support(input)
 b<-input$frozen[['point-opportunity-dispositions']];h<-input$frozen[['context-support']];s<-input$states
 x<-h[,c(broader_count_fields,'eligible','seed','exclusion_reasons','batch_key','support_disposition','paired_support'),drop=FALSE]
 for(f in c('qa_usable_attempts','unvalidated_observed_prefixes','unknown_opportunities','unknown_binary_labels','unknown_error_subtype_attempts','retention','prior_usable_matches','prior_batches'))x[[f]]<-h[[f]]
 j<-match(b$plus1_action_id,s$action_id);k<-match(plus_transfer_key(b),plus_transfer_key(x));u<-b$denominator_member
 mcp_need(!anyNA(j[u])&&!anyNA(k[u])&&all(s$owner_domain[j[u]]=='Rally'&s$owner_role[j[u]]=='SERVER')&&all(s$actor_name[j[u]]==b$player[u]),'Exclusive owned +1 count linkage')
 terminal<-rep('',nrow(b));terminal[b$observed_prefix]<-s$post_terminal_status[j[b$observed_prefix]]
 x$forced_errors<-tabulate(k[u&terminal=='FORCED_ERROR'],nrow(x))
 x$unforced_errors<-tabulate(k[u&terminal=='UNFORCED_ERROR'],nrow(x));x$errors<-x$forced_errors+x$unforced_errors
 x$unknown_execution_count<-x$withheld_attempts
 mcp_need(all(x$errors<=x$usable_attempts)&&!any(x$errors[!x$context%in%c('FIRST','SECOND')]),'Annotated error count bounds')
 x$rate_status<-ifelse(x$usable_attempts>0,'OBSERVED_CONDITIONAL_ERROR_FREQUENCY','UNDEFINED_ZERO_DENOMINATOR')
 x$context_disposition<-ifelse(x$context%in%c('FIRST','SECOND'),'RECORDED_CONTEXT','UNKNOWN_OR_UNSUPPORTED_CONTEXT')
 x$withheld_disposition<-ifelse(x$withheld_attempts>0,'WITHHELD_ACTION','NONE')
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,x$context,method='radix'),];rownames(x)<-NULL;x
}
plus_transfer_summary <- function(input,x) {
 y<-input$frozen$summary
 y<-y[,setdiff(names(y),c('release','sample_release','revision','owner_domain','option','claim','chronology','exposure','uncertainty')),drop=FALSE]
 # ALL rows are coverage only: FIRST/SECOND losses are never pooled.
 for(i in seq_len(nrow(y))) {
  z<-x[x$tour==y$tour[i],];if(y$context[i]!='ALL')z<-z[z$context==y$context[i],]
  p<-z[z$paired_mask,]
  y$scored_context_targets[i]<-nrow(p);y$scored_matches[i]<-length(unique(p$match_id));y$scored_identities[i]<-length(unique(p$player))
  y$scored_attempts[i]<-sum(p$usable_attempts);y$scored_errors[i]<-sum(p$errors)
  y$personal_infinite_cells[i]<-sum(is.infinite(p$personal_log_loss));y$reference_infinite_cells[i]<-sum(is.infinite(p$reference_log_loss))
  y$personal_zero_estimates[i]<-sum(p$personal_estimate==0);y$personal_one_estimates[i]<-sum(p$personal_estimate==1)
 }
 y
}
run_mcp_plus1_transfer <- function(input=plus_transfer_load()) {
 counts<-plus_transfer_counts(input);x<-wide_transfer_estimates(counts)
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)do.call(rbind,lapply(c('FIRST','SECOND'),function(context)
  cbind(data.frame(tour,context),transfer_score(x[x$tour==tour&x$context==context,]))))))
 r<-list('observation-counts'=counts,'target-estimates'=x,'paired-scores'=scores,
  stability=transfer_stability(x[x$eligible,]),'coverage-summary'=input$frozen[['match-coverage']],summary=plus_transfer_summary(input,x))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_SERVE_PLUS1_TRANSFER_1.0.0';r[[k]]$source_release<-'MCP_SERVE_PLUS1_TRANSFER_PROTOCOL_1.0.0'
  r[[k]]$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$owner_domain<-'Rally';r[[k]]$option<-'ALL_DATE_EXPANDING'
  r[[k]]$claim<-'ANNOTATED_ERRORS_CONDITIONAL_ON_REACHING_OBSERVED_QA_USABLE_PLUS1_ATTEMPTS_NOT_SKILL'
  r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
plus_transfer_install <- function(r) {
 mcp_need(identical(names(r),plus_transfer_outputs),'Exact +1 execution output scope');paths<-paste0(plus_transfer_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored flat location required')
 stage<-vapply(paths,function(p)tempfile('.plus-transfer-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);plus_transfer_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing +1 release')
 installed<-character();complete<-FALSE;on.exit(if(!complete)unlink(installed),add=TRUE)
 for(i in seq_along(paths))if(!file.exists(paths[i])){mcp_need(file.rename(stage[i],paths[i]),'Atomic file installation failed');installed<-c(installed,paths[i])}
 complete<-TRUE;invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline +1 experiment takes no arguments')
 input<-plus_transfer_load();plus_transfer_support(input)
 cat('PRE-SCORING VERIFIED: frozen specification, inventory, denominator reconstruction and exact 504 support IDs.\n')
 r<-run_mcp_plus1_transfer(input);plus_transfer_install(r)
 print(r[['paired-scores']][,c('tour','context','paired_cells','scored_matches','target_attempts','target_errors','personal_infinite_cells','reference_infinite_cells','difference_brier','difference_log_loss','difference_brier_opportunity_weighted','difference_log_loss_opportunity_weighted')],row.names=FALSE)
}
