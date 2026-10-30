# Option A only: retrospective annotated Return errors, not skill or win forecasts.
source('R/audit_mcp_opportunity_context.R')
transfer_prefix <- 'data/pilot/mcp-return-transfer-v1-'
transfer_outputs <- c('observation-counts','target-estimates','paired-scores','stability','summary')
transfer_context_pins <- c(
 dictionary='ed2fce2ac242bc1cf7b9ebaaf02e4a5cded149ca1f8288f8ae2276a4de61cd05',
 'context-summary'='6630898e21ed059320730821a6a04bc451f007732c545b0c48c522f75c793b94',
 'coverage-summary'='1777e842998d6abc5d50e273704803e90d567d220573b36a1cd2250ec528444b',
 'measurement-checks'='c0ee60ac388288725a9c49c634e63d5179527b4a04ef09e6baad9ffa64937276')
transfer_verify <- function() {
 context_verify()
 mcp_need(mcp_sha('docs/mcp-return-transfer-protocol.md')=='fc012076f70e970493db5c6ff710add54e3efb87e2d116811b572c8110e68d36','Frozen transfer protocol changed')
 for(k in names(transfer_context_pins))mcp_need(mcp_sha(paste0(context_prefix,k,'.csv'))==transfer_context_pins[[k]],'Frozen context pin failed')
 invisible(TRUE)
}
transfer_load <- function() {
 transfer_verify()
 list(sample=mcp_read(paste0(mcp_prefix,'prototype-sample.csv')),
  counts=read.csv(paste0(context_prefix,'context-summary.csv'),stringsAsFactors=FALSE,na.strings='NA'))
}
transfer_counts <- function(input) {
 m<-input$sample
 mcp_need(!anyDuplicated(m$match_id)&&all(mcp_date_valid(m$Date))&&all(m$tour_file%in%c('ATP','WTA')),'Invalid match identity/date/tour')
 mcp_need(all(nzchar(m$player_a)&nzchar(m$player_b)&m$player_a!=m$player_b),'Ambiguous player identity')
 x<-input$counts
 x<-x[x$scope=='match_player'&x$domain=='Return'&x$view=='serve_number',]
 key<-paste(x$match_id,x$slot,x$context,sep='|')
 mcp_need(nrow(x)==8*nrow(m)&&!anyDuplicated(key),'Complete unique perspective/context inventory required')
 expected_keys<-expand.grid(match_id=m$match_id,slot=c('A','B'),context=c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),stringsAsFactors=FALSE)
 mcp_need(setequal(key,paste(expected_keys$match_id,expected_keys$slot,expected_keys$context,sep='|')),'Missing or unsupported perspective/context key')
 ix<-match(x$match_id,m$match_id)
 mcp_need(!anyNA(ix)&&all(x$tour==m$tour_file[ix])&&all(x$slot%in%c('A','B')),'Conflicting match/context join')
 expected<-ifelse(x$slot=='A',m$player_a[ix],m$player_b[ix])
 mcp_need(all(x$player==expected)&&setequal(x$context,c('FIRST','SECOND','UNKNOWN','UNSUPPORTED')),'Player/context conflict')
 for(f in c('observed_attempts','usable_attempts','unknown_execution_count','forced_errors','unforced_errors','errors'))
  mcp_need(all(is.finite(x[[f]])&x[[f]]>=0&x[[f]]==floor(x[[f]])),'Invalid count')
 mcp_need(all(x$errors==x$forced_errors+x$unforced_errors&x$errors<=x$usable_attempts&
  x$usable_attempts+x$unknown_execution_count==x$observed_attempts),'Invalid count bounds/partition')
 mcp_need(!any(x$usable_attempts[x$context%in%c('UNKNOWN','UNSUPPORTED')]),'Unscorable context cannot enter counts')
 x<-x[,c('tour','match_id','player','slot','context','observed_attempts','usable_attempts','unknown_execution_count','forced_errors','unforced_errors','errors')]
 x$source_date<-format(as.Date(m$Date[ix],'%Y%m%d'),'%Y-%m-%d')
 x$event<-m$event_label[ix];x$surface<-m$Surface[ix]
 x$player_a<-m$player_a[ix];x$player_b<-m$player_b[ix]
 x$batch_key<-paste(x$tour,x$source_date,sep='|')
 seeds<-tapply(x$source_date,x$tour,min)
 x$seed<-x$source_date==seeds[x$tour]
 x$context_disposition<-ifelse(x$context%in%c('FIRST','SECOND'),'RECORDED_CONTEXT','UNKNOWN_OR_UNSUPPORTED_CONTEXT')
 x$withheld_disposition<-ifelse(x$unknown_execution_count>0,'WITHHELD_ACTION','NONE')
 x[order(x$tour,x$source_date,x$match_id,x$slot,x$context,method='radix'),]
}
transfer_log_sum <- function(e,n,q) {
 # Explicit cases preserve infinite losses and avoid 0 * log(0) -> NaN.
 mcp_need(length(q)==1L&&is.finite(q)&&q>=0&&q<=1&&is.finite(n)&&is.finite(e)&&n>=e&&e>=0,'Invalid loss inputs')
 if((q==0&&e>0)||(q==1&&n>e))return(Inf)
 -(if(e>0)e*log(q) else 0)-(if(n>e)(n-e)*log1p(-q) else 0)
}
transfer_estimates <- function(counts) {
 x<-counts[counts$context%in%c('FIRST','SECOND'),];rows<-list()
 for(i in seq_len(nrow(x))) {
  z<-x[i,];prior<-x[x$tour==z$tour&x$context==z$context&x$source_date<z$source_date,]
  personal<-prior[prior$player==z$player,]
  n<-sum(personal$usable_attempts);e<-sum(personal$errors)
  rn<-sum(prior$usable_attempts);re<-sum(prior$errors)
  dates<-personal$source_date[personal$usable_attempts>0]
  reason<-if(z$seed)'SEED_NOT_EVALUATED' else if(z$usable_attempts==0)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else
   if(n==0)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else if(rn==0)'NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS' else 'PAIRED_SUPPORTED'
  q<-execution_ratio(e,n);rq<-execution_ratio(re,rn);supported<-reason=='PAIRED_SUPPORTED'
  loss<-function(prob,type)if(!supported)NA_real_ else if(type=='brier')
   (z$errors*(1-prob)^2+(z$usable_attempts-z$errors)*prob^2)/z$usable_attempts else
   transfer_log_sum(z$errors,z$usable_attempts,prob)/z$usable_attempts
  rows[[i]]<-cbind(z,data.frame(prior_matches=length(unique(personal$match_id)),prior_attempts=n,prior_errors=e,
   prior_forced_errors=sum(personal$forced_errors),prior_unforced_errors=sum(personal$unforced_errors),
   reference_matches=length(unique(prior$match_id)),reference_attempts=rn,reference_errors=re,
   prior_first_date=if(length(dates))min(dates) else '',prior_last_date=if(length(dates))max(dates) else '',
   days_since_last_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else NA_real_,
   days_since_first_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(min(dates))) else NA_real_,
   personal_estimate=q,reference_estimate=rq,disposition=reason,paired_mask=supported,
   target_error_rate=execution_ratio(z$errors,z$usable_attempts),
   signed_departure=if(supported)z$errors/z$usable_attempts-q else NA_real_,
   absolute_departure=if(supported)abs(z$errors/z$usable_attempts-q) else NA_real_,
   personal_brier=loss(q,'brier'),reference_brier=loss(rq,'brier'),
   personal_log_loss=loss(q,'log'),reference_log_loss=loss(rq,'log'),stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
transfer_score <- function(x) {
 x<-x[x$paired_mask,]
 result<-data.frame(paired_cells=nrow(x),scored_matches=length(unique(x$match_id)),target_attempts=sum(x$usable_attempts),
  target_errors=sum(x$errors),personal_infinite_cells=sum(is.infinite(x$personal_log_loss)),reference_infinite_cells=sum(is.infinite(x$reference_log_loss)))
 for(kind in c('brier','log_loss'))for(model in c('personal','reference')) {
  values<-x[[paste(model,kind,sep='_')]]
  result[[paste(model,kind,sep='_')]]<-if(nrow(x))mean(vapply(split(values,x$match_id),mean,0.0)) else NA_real_
  result[[paste(model,kind,'opportunity_weighted',sep='_')]]<-if(nrow(x))sum(values*x$usable_attempts)/sum(x$usable_attempts) else NA_real_
 }
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')) {
  a<-result[[paste0('personal_',kind,suffix)]];b<-result[[paste0('reference_',kind,suffix)]]
  # Inf - Inf is indeterminate, not zero or a comparison victory.
  result[[paste0('difference_',kind,suffix)]]<-if(is.infinite(a)&&is.infinite(b))NA_real_ else a-b
 }
 result$comparison_status<-if(!nrow(x))'UNEVALUABLE' else if(is.na(result$difference_log_loss))'INDETERMINATE_LOG_COMPARISON' else 'DESCRIPTIVE_ONLY'
 result
}
transfer_stability <- function(x) {
 rows<-list()
 for(tour in c('ATP','WTA'))for(context in c('FIRST','SECOND')) {
  z<-x[x$tour==tour&x$context==context&!x$seed,];base<-transfer_score(z)
  for(type in c('MATCH','PLAYER')) {
   ids<-if(type=='MATCH')sort(unique(z$match_id),method='radix') else sort(unique(c(z$player_a,z$player_b)),method='radix')
   for(id in ids) {
    remove<-if(type=='MATCH')z$match_id==id else z$player_a==id|z$player_b==id
    score<-transfer_score(z[!remove,]);score$deleted_evaluation_matches<-length(unique(z$match_id[remove]))
    score$deleted_paired_cells<-sum(z$paired_mask[remove])
    score$change_brier_difference<-score$difference_brier-base$difference_brier
    score$change_log_difference<-score$difference_log_loss-base$difference_log_loss
    rows[[length(rows)+1L]]<-cbind(data.frame(tour,context,deletion_type=type,deleted_id=id,stringsAsFactors=FALSE),score)
   }
  }
 }
 do.call(rbind,rows)
}
transfer_summary <- function(x,counts,input) {
 rows<-list()
 for(tour in c('ATP','WTA')) {
  z<-x[x$tour==tour,];supported<-z[z$paired_mask,];c<-counts[counts$tour==tour,]
  slots<-unique(z[,c('match_id','player','seed','paired_mask')]);ev<-slots[!slots$seed,]
  counts_by_match<-tapply(ev$paired_mask,ev$match_id,sum)
  rows[[length(rows)+1L]]<-data.frame(tour,inventory_matches=length(unique(z$match_id)),inventory_slots=nrow(slots),
   inventory_context_targets=nrow(z),seed_matches=length(unique(z$match_id[z$seed])),seed_context_targets=sum(z$seed),
   evaluation_matches=length(unique(z$match_id[!z$seed])),supported_matches=length(unique(supported$match_id)),
   supported_slots=nrow(unique(supported[,c('match_id','player')])),supported_context_targets=nrow(supported),
   distinct_supported_players=length(unique(supported$player)),
   no_history_context_targets=sum(z$disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),
   no_target_context_targets=sum(z$disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),
   no_reference_context_targets=sum(z$disposition=='NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS'),
   both_supported_matches=sum(counts_by_match==2),one_supported_matches=sum(counts_by_match==1),neither_supported_matches=sum(counts_by_match==0),
   observed_return_attempts=sum(c$observed_attempts),usable_return_attempts=sum(c$usable_attempts),withheld_return_attempts=sum(c$unknown_execution_count),
   unknown_unsupported_attempts=sum(c$observed_attempts[c$context%in%c('UNKNOWN','UNSUPPORTED')]),
   min_prior_matches=min(supported$prior_matches),max_prior_matches=max(supported$prior_matches),
   min_prior_attempts=min(supported$prior_attempts),max_prior_attempts=max(supported$prior_attempts),
   min_source_gap_days=min(supported$days_since_last_source_date),max_source_gap_days=max(supported$days_since_last_source_date),stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
run_mcp_return_transfer <- function(input=transfer_load()) {
 counts<-transfer_counts(input);x<-transfer_estimates(counts)
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)do.call(rbind,lapply(c('FIRST','SECOND'),function(context)
  cbind(data.frame(tour,context),transfer_score(x[x$tour==tour&x$context==context,]))))))
 r<-list('observation-counts'=counts,'target-estimates'=x,'paired-scores'=scores,
  stability=transfer_stability(x),summary=transfer_summary(x,counts,input))
 for(k in names(r)) {
  rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_RETURN_TRANSFER_1.0.0';r[[k]]$option<-'A_ALL_DATE_EXPANDING'
  r[[k]]$source_release<-'MCP_OPPORTUNITY_CONTEXT_1.0.0';r[[k]]$revision<-mcp_revision
  r[[k]]$claim<-'RETROSPECTIVE_OBSERVED_QA_USABLE_RETURN_ERRORS_NOT_SKILL';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY'
  r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
 }
 r
}
transfer_install <- function(r,prefix=transfer_prefix) {
 mcp_need(identical(names(r),transfer_outputs),'Exact transfer output scope')
 paths<-paste0(prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.return-stage-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i])
 transfer_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing transfer release')
 installed<-character();complete<-FALSE
 on.exit(if(!complete)unlink(installed),add=TRUE)
 for(i in seq_along(paths))if(!file.exists(paths[i])) {
  mcp_need(file.rename(stage[i],paths[i]),'Atomic file installation failed');installed<-c(installed,paths[i])
 }
 complete<-TRUE;invisible(r)
}
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline Option A runner takes no arguments')
 r<-run_mcp_return_transfer();transfer_install(r)
 print(r$summary[,1:28],row.names=FALSE)
 print(r[['paired-scores']][,1:21],row.names=FALSE)
}
