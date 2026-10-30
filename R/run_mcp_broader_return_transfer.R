# Frozen ALL_DATE_EXPANDING experiment; shared loss/deletion formulas are unchanged.
source('R/freeze_mcp_broader_return_protocol.R')
source('R/run_mcp_return_transfer.R')
wide_transfer_prefix <- 'data/pilot/mcp-broader-return-transfer-v1-'
wide_transfer_outputs <- transfer_outputs
wide_transfer_pins <- c(
 'docs/mcp-broader-return-transfer-protocol.md'='1d98da4b869c1c34f2022c08df99346e6739ce2df02c9477f7a28d61533dd312',
 'R/freeze_mcp_broader_return_protocol.R'='97b8588509e9da65ca99d5a4f1c94579e154d3ccd21da903e2eeb2e341dcaf3b',
 'data/pilot/mcp-broader-return-protocol-v1-match-eligibility.csv'='c54ea1ad73b9d228979235b8090a705b2d01d29107433431d9b9eacf11c8eda3',
 'data/pilot/mcp-broader-return-protocol-v1-context-support.csv'='64567fe04d807a1219e780a457314d34cf2744e0a74c9863ab4042477e45dfd7',
 'data/pilot/mcp-broader-return-protocol-v1-summary.csv'='af5faf044dbbe6150f40ffbec93f57cf90f505831086ebb4b46568216e701421',
 'data/pilot/mcp-repeated-player-v1-action-states.csv'='c9ff96dd67716c42064ea6fd7e27b7804b119dafeb444e5d39735b4ea6b25ce2',
 'data/pilot/mcp-repeated-player-v1-actions.csv'='4d1dd07d783bbd689031731fe160996e8978a6f8dfd896ed56eb345a783c487a')
wide_transfer_verify <- function() {
 broader_verify()
 for(f in names(wide_transfer_pins))mcp_need(mcp_sha(f)==wide_transfer_pins[[f]],paste('Frozen experiment pin changed:',f))
 invisible(TRUE)
}
wide_transfer_load <- function() {
 wide_transfer_verify()
 list(eligibility=read.csv(paste0(broader_prefix,'match-eligibility.csv'),stringsAsFactors=FALSE),
  support=read.csv(paste0(broader_prefix,'context-support.csv'),stringsAsFactors=FALSE),
  summary=read.csv(paste0(broader_prefix,'summary.csv'),stringsAsFactors=FALSE),
  states=read.csv(paste0(repeat_prefix,'action-states.csv'),stringsAsFactors=FALSE))
}
wide_transfer_counts <- function(input) {
 e<-input$eligibility;h<-input$support;s<-input$states
 mcp_need(nrow(e)==159&&!anyDuplicated(e$match_id)&&nrow(h)==1272,'Frozen inventory accounting')
 mcp_need(all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE')&&all(e$eligible%in%c(TRUE,FALSE)),'Frozen completion authority')
 # Revalidate the frozen support with availability only, before adding numerators.
 availability<-h[,broader_count_fields,drop=FALSE]
 rebuilt<-broader_support(availability,e);key<-function(x)paste(x$match_id,x$slot,x$context,sep='|')
 j<-match(key(rebuilt),key(h));mcp_need(!anyNA(j)&&!anyDuplicated(key(h)),'Frozen support join')
 for(f in names(rebuilt))mcp_need(isTRUE(all.equal(rebuilt[[f]],h[[f]][j],check.attributes=FALSE,tolerance=0)),paste('Frozen support mismatch:',f))
 mcp_need(!anyDuplicated(s$action_id)&&setequal(s$match_id,e$match_id),'State inventory/action identities')
 x<-s[s$owner_domain=='Return'&s$post_kind=='STROKE',]
 contexts<-context_classify(x[,context_pre_fields,drop=FALSE],'Return')$serve_number
 ix<-match(x$match_id,e$match_id)
 mcp_need(!anyNA(ix)&&all(x$actor_name==ifelse(x$actor_neutral_slot=='A',e$player_a[ix],e$player_b[ix]))&&all(x$actor_neutral_slot%in%c('A','B')),'Exact Return ownership')
 k<-match(paste(x$match_id,x$actor_neutral_slot,contexts,sep='|'),key(h));mcp_need(!anyNA(k),'Return action context join')
 count<-function(mask)tabulate(k[mask],nbins=nrow(h))
 u<-x$tennis_action_usable
 mcp_need(all(count(rep(TRUE,nrow(x)))==h$observed_attempts)&&all(count(u)==h$usable_attempts),'Frozen Return denominator reconciliation')
 counts<-h[,c(broader_count_fields,'eligible','seed','exclusion_reasons','batch_key','support_disposition','paired_support'),drop=FALSE]
 counts$unknown_execution_count<-counts$withheld_attempts
 counts$forced_errors<-count(u&x$post_terminal_status=='FORCED_ERROR')
 counts$unforced_errors<-count(u&x$post_terminal_status=='UNFORCED_ERROR');counts$errors<-counts$forced_errors+counts$unforced_errors
 mcp_need(all(counts$errors<=counts$usable_attempts)&&!any(counts$errors[!counts$context%in%c('FIRST','SECOND')]>0),'Error count bounds/context')
 counts$context_disposition<-ifelse(counts$context%in%c('FIRST','SECOND'),'RECORDED_CONTEXT','UNKNOWN_OR_UNSUPPORTED_CONTEXT')
 counts$withheld_disposition<-ifelse(counts$withheld_attempts>0,'WITHHELD_ACTION','NONE')
 counts[order(counts$tour,counts$source_date,counts$match_id,counts$slot,counts$context,method='radix'),]
}
wide_transfer_estimates <- function(counts) {
 # The verified original estimator sees eligible histories/targets only.
 # Its date predicate freezes every target in a simultaneous batch before update.
 estimated<-transfer_estimates(counts[counts$eligible,])
 inventory<-counts[counts$context%in%c('FIRST','SECOND'),]
 key<-function(x)paste(x$match_id,x$slot,x$context,sep='|');j<-match(key(inventory),key(estimated))
 mcp_need(identical(is.na(j),!inventory$eligible),'Excluded matches cannot receive estimates')
 x<-estimated[j,];for(f in names(inventory))x[[f]]<-inventory[[f]]
 x$disposition[!x$eligible]<-'COMPLETION_EXCLUDED';x$paired_mask[!x$eligible]<-FALSE
 mcp_need(identical(x$paired_mask,x$paired_support),'One unchanged personal/reference paired mask')
 expected<-ifelse(x$paired_support,'PAIRED_SUPPORTED',x$support_disposition)
 mcp_need(identical(x$disposition,expected),'Frozen failure precedence')
 cause<-function(prob,loss){ifelse(!x$paired_mask,'NOT_SCORED',ifelse(!is.infinite(loss),'NONE',
  ifelse(prob==0&x$errors>0,'ZERO_ESTIMATE_WITH_TARGET_ERRORS',ifelse(prob==1&x$usable_attempts>x$errors,'ONE_ESTIMATE_WITH_TARGET_NONERRORS','UNRESOLVED_STOP'))))}
 x$personal_infinite_cause<-cause(x$personal_estimate,x$personal_log_loss)
 x$reference_infinite_cause<-cause(x$reference_estimate,x$reference_log_loss)
 mcp_need(!any(x$personal_infinite_cause=='UNRESOLVED_STOP'|x$reference_infinite_cause=='UNRESOLVED_STOP'),'Unexplained infinite loss')
 rownames(x)<-NULL;x
}
wide_transfer_summary <- function(input,counts,x) {
 y<-input$summary[input$summary$context=='ALL',];y<-y[,setdiff(names(y),c('release','revision','option','chronology','exposure','uncertainty','claim')),drop=FALSE]
 for(i in seq_len(nrow(y))){tour<-y$tour[i];z<-x[x$tour==tour,];q<-z[z$paired_mask,];c<-counts[counts$tour==tour,]
  for(reason in unique(z$disposition))y[i,paste0('disposition_',reason)]<-sum(z$disposition==reason)
  y$paired_cells[i]<-nrow(q);y$scored_matches[i]<-length(unique(q$match_id));y$scored_identities[i]<-length(unique(q$player))
  y$personal_infinite_cells[i]<-sum(is.infinite(q$personal_log_loss));y$reference_infinite_cells[i]<-sum(is.infinite(q$reference_log_loss))
  y$personal_zero_estimate_cells[i]<-sum(q$personal_estimate==0);y$personal_one_estimate_cells[i]<-sum(q$personal_estimate==1)
  y$unknown_unsupported_context_cells[i]<-sum(!c$context%in%c('FIRST','SECOND'));y$unknown_unsupported_observed_attempts[i]<-sum(c$observed_attempts[!c$context%in%c('FIRST','SECOND')])
 }
 rownames(y)<-NULL;y
}
run_mcp_broader_transfer <- function(input=wide_transfer_load()) {
 counts<-wide_transfer_counts(input);x<-wide_transfer_estimates(counts)
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)do.call(rbind,lapply(c('FIRST','SECOND'),function(context)
  cbind(data.frame(tour,context),transfer_score(x[x$tour==tour&x$context==context,]))))))
 r<-list('observation-counts'=counts,'target-estimates'=x,'paired-scores'=scores,
  stability=transfer_stability(x[x$eligible,]),summary=wide_transfer_summary(input,counts,x))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_BROADER_RETURN_TRANSFER_1.0.0';r[[k]]$revision<-mcp_revision
  r[[k]]$option<-'ALL_DATE_EXPANDING';r[[k]]$claim<-'RETROSPECTIVE_OBSERVED_QA_USABLE_RETURN_ERRORS_INTERNAL_CHART_COMPLETION_ONLY'
  r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
wide_transfer_install <- function(r) {
 mcp_need(identical(names(r),wide_transfer_outputs),'Exact experiment output scope');paths<-paste0(wide_transfer_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.broader-transfer-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);wide_transfer_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing experiment release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file install failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline experiment takes no arguments');r<-run_mcp_broader_transfer();wide_transfer_install(r)
 print(r$summary[,c('tour','inventory_matches','eligible_matches','evaluation_matches','paired_cells','scored_matches','scored_identities','personal_infinite_cells')],row.names=FALSE)
 print(r[['paired-scores']][,c('tour','context','paired_cells','scored_matches','difference_brier','difference_log_loss','difference_brier_opportunity_weighted','difference_log_loss_opportunity_weighted')],row.names=FALSE)}
