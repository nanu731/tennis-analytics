# Frozen match-average terminal-balance scoring; no re-estimation or point loss.
source('R/run_mcp_direct_serve_transfer.R')
balance_prefix <- 'data/pilot/mcp-serve-terminal-balance-v1-'
balance_outputs <- c('target-estimates','paired-scores','stability','coverage-summary','summary')
balance_definition_pin <- 'a0fa2a556cd90ba32fffb56a679135e99901092d8cbcaf9987cc3df4e0e01e30'
balance_pins <- c(
 'R/run_mcp_direct_serve_transfer.R'='bba408b6ad4cd7b6d8cc3cad05407777cb7398236239d79ee2689e2f5fb0d51c',
 'R/test_mcp_direct_serve_transfer.R'='0b777c13c53bd457cfb75952579f8c56062ea838a817340b2543dbe5d3aad804',
 'docs/mcp-direct-serve-transfer-results.md'='b9245ec406491462f5085f848a6c252abfa3e4f00f564233511187a8f476cacd',
 'data/pilot/mcp-direct-serve-transfer-v1-coverage-summary.csv'='e09545015c930becfbd5e5671cfe9754a5505192470cdebbfe6e3a0df920e0d6',
 'data/pilot/mcp-direct-serve-transfer-v1-observation-counts.csv'='f72740e265f3c9f84105c60fd00e6e2e71a8e60dcc62750201c0e90f4c6c56d5',
 'data/pilot/mcp-direct-serve-transfer-v1-paired-scores.csv'='7dbb2168f1d8ace7eff0f515aafb3dd27e79ee21d31cf200caedac4d3c9b1572',
 'data/pilot/mcp-direct-serve-transfer-v1-point-dispositions.csv'='4eb029c52b4255ef9880abfa3e18539bd4098cb31a7ed5f96f77c56fdfbeade3',
 'data/pilot/mcp-direct-serve-transfer-v1-stability.csv'='30b956803edcc3e45f831c01a724417f52d7e146e37edfbc7c8bd373bffcdb42',
 'data/pilot/mcp-direct-serve-transfer-v1-summary.csv'='e97b9a66154bd6f2f9482911c97ccf3e3b94bbc002fa960063a1c1e4e738b3b4',
 'data/pilot/mcp-direct-serve-transfer-v1-target-estimates.csv'='649b21d22676f9d5e6ec680171f646c7f46f313e74b619cc2b197c1a5f371b46')
balance_verify <- function() {
 direct_verify() # Reuses the saved rights/provenance, source and QA pin chain.
 for(f in names(balance_pins))mcp_need(mcp_sha(f)==balance_pins[[f]],paste('Frozen balance input changed:',f))
 lines<-readLines('docs/mcp-serve-terminal-balance-transfer-results.md',warn=FALSE)
 cut<-match('## Measured results and coverage',lines);mcp_need(!is.na(cut),'Prospective balance boundary missing')
 lines<-head(lines,cut-1L);while(length(lines)&&tail(lines,1)=='')lines<-head(lines,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(lines,f)
 mcp_need(mcp_sha(f)==balance_definition_pin,'Prospective balance specification changed');invisible(TRUE)
}
balance_load <- function(){balance_verify();setNames(lapply(direct_outputs,function(k)read.csv(paste0(direct_prefix,k,'.csv'),stringsAsFactors=FALSE)),direct_outputs)}
balance_key <- function(x)paste(x$match_id,x$slot,sep='|')
balance_check <- function(input) {
 mcp_need(identical(names(input),direct_outputs),'Frozen input scope')
 x<-input[['target-estimates']];c<-input[['observation-counts']];p<-input[['point-dispositions']]
 mcp_need(nrow(x)==446&&nrow(c)==446&&nrow(p)==43310&&!anyDuplicated(balance_key(x))&&!anyDuplicated(balance_key(c))&&!anyDuplicated(p$point_id)&&setequal(balance_key(x),balance_key(c)),'Unique full inventory accounting')
 # Keyed comparison to the pinned release rejects any changed mask or estimates.
 frozen<-read.csv(paste0(direct_prefix,'target-estimates.csv'),stringsAsFactors=FALSE)
 j<-match(balance_key(x),balance_key(frozen));mcp_need(!anyNA(j),'Target namespace conflict')
 for(f in names(frozen))mcp_need(identical(x[[f]],frozen[[f]][j]),paste('Changed frozen target field:',f))
 j<-match(balance_key(c),balance_key(x))
 for(f in setdiff(names(c),c('release','claim','specification_sha256')))mcp_need(identical(c[[f]],x[[f]][j]),paste('Frozen count/target disagreement:',f))
 mcp_need(all(rowSums(c[,direct_classes])==c$N)&&all(c$inventory_points==c$N+c$withheld_points+c$completion_excluded_points)&&sum(x$paired_mask)==255&&identical(as.integer(table(x$tour[x$paired_mask])),c(120L,135L)),'Frozen denominator/mask reconciliation')
 k<-match(balance_key(p),balance_key(c));mcp_need(!anyNA(k),'Unlinked service point')
 mcp_need(identical(as.integer(tabulate(k[p$included],nrow(c))),as.integer(c$N)),'Independent point denominator')
 for(cl in direct_classes)mcp_need(identical(as.integer(tabulate(k[p$included&p$point_class==cl],nrow(c))),as.integer(c[[cl]])),paste('Independent frozen class sum',cl))
 mcp_need(all(p$included==(p$eligible&p$qa_validated))&&all(p$point_class[!p$qa_validated]=='UNRESOLVED')&&all(x$N[!x$eligible]==0),'Frozen exclusions and unknowns')
 mcp_need(all(x$N[x$paired_mask]>0&x$prior_N[x$paired_mask]>0&x$reference_N[x$paired_mask]>0)&&all(!x$seed[x$paired_mask]&x$eligible[x$paired_mask]),'Positive denominators and abstention mask')
 mcp_need(all(x$prior_last_date[x$paired_mask]<x$source_date[x$paired_mask]),'Strict earlier source-date label')
 for(model in c('personal','reference')) {
  q<-as.matrix(x[x$paired_mask,paste0(model,'_p_',direct_classes)])
  mcp_need(all(is.finite(q)&q>=0&q<=1)&&all(abs(rowSums(q)-1)<1e-12),'Finite frozen supported class probabilities')
  mcp_need(all(abs(x[[paste0(model,'_expected_balance')]][x$paired_mask]-(q[,1]-q[,2]))<1e-12),'Frozen expected balance identity')
 }
 invisible(TRUE)
}
balance_targets <- function(x) {
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,method='radix'),];rownames(x)<-NULL
 observed<-ifelse(x$N>0,(x$ACE-x$DOUBLE_FAULT)/x$N,NA_real_)
 mcp_need(isTRUE(all.equal(observed,x$balance,tolerance=1e-12,check.attributes=FALSE)),'Frozen observed balance mismatch')
 for(model in c('personal','reference')) {
  predicted<-x[[paste0(model,'_p_ACE')]]-x[[paste0(model,'_p_DOUBLE_FAULT')]]
  x[[paste0(model,'_balance_squared_error')]]<-ifelse(x$paired_mask,(predicted-observed)^2,NA_real_)
 }
 x
}
balance_score <- function(x) {
 z<-x[x$paired_mask,];out<-data.frame(paired_slots=nrow(z),scored_matches=length(unique(z$match_id)),target_points=sum(z$N),comparison_status='DESCRIPTIVE_BALANCE_ONLY',stringsAsFactors=FALSE)
 bad<-if(!nrow(z))'UNEVALUABLE_NO_SUPPORTED_TARGETS' else if(any(!is.finite(z$N)|z$N<=0))'UNEVALUABLE_INVALID_DENOMINATOR' else if(any(!is.finite(z$personal_balance_squared_error)|!is.finite(z$reference_balance_squared_error)))'UNEVALUABLE_NONFINITE_LOSS' else ''
 for(model in c('personal','reference')) {
  values<-z[[paste0(model,'_balance_squared_error')]]
  out[[paste0(model,'_squared_error')]]<-if(nzchar(bad))NA_real_ else mean(vapply(split(values,z$match_id),mean,0.0))
  out[[paste0(model,'_squared_error_opportunity_weighted')]]<-if(nzchar(bad))NA_real_ else sum(z$N*values)/sum(z$N)
 }
 if(nzchar(bad))out$comparison_status<-bad
 out$difference_squared_error<-out$personal_squared_error-out$reference_squared_error
 out$difference_squared_error_opportunity_weighted<-out$personal_squared_error_opportunity_weighted-out$reference_squared_error_opportunity_weighted
 out
}
balance_direction <- function(d)if(!is.finite(d))'UNEVALUABLE' else if(d<0)'PERSONAL_LOWER' else if(d>0)'REFERENCE_LOWER' else 'TIE'
balance_stability <- function(x) {
 rows<-list()
 for(tour in c('ATP','WTA')) {
  z<-x[x$tour==tour&x$eligible&!x$seed,];base<-balance_score(z)
  for(type in c('MATCH','PLAYER'))for(id in sort(unique(if(type=='MATCH')z$match_id else c(z$player_a,z$player_b)),method='radix')) {
   remove<-if(type=='MATCH')z$match_id==id else z$player_a==id|z$player_b==id
   out<-balance_score(z[!remove,]);out$deleted_evaluation_matches<-length(unique(z$match_id[remove]));out$deleted_paired_slots<-sum(z$paired_mask[remove])
   for(suffix in c('','_opportunity_weighted')) {
    f<-paste0('difference_squared_error',suffix);a<-out[[f]];b<-base[[f]]
    out[[paste0('change',suffix)]]<-if(is.finite(a)&&is.finite(b))a-b else NA_real_
    out[[paste0('direction',suffix)]]<-balance_direction(a)
    out[[paste0('direction_status',suffix)]]<-if(!is.finite(a)||!is.finite(b))'UNEVALUABLE' else if(a==0||b==0)'TIE_INVOLVED' else if(sign(a)!=sign(b))'REVERSED' else 'PRESERVED'
   }
   rows[[length(rows)+1L]]<-cbind(data.frame(tour,deletion_type=type,deleted_id=id,stringsAsFactors=FALSE),out)
  }
 }
 do.call(rbind,rows)
}
run_mcp_serve_terminal_balance <- function(input=balance_load()) {
 balance_verify();balance_check(input) # Entire frozen mask and denominator reconciled before scoring.
 x<-balance_targets(input[['target-estimates']]);scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)cbind(data.frame(tour),balance_score(x[x$tour==tour,]))))
 cov<-input[['coverage-summary']];cov<-cov[order(cov$tour,cov$source_date,cov$match_id,method='radix'),];summary<-input$summary[order(input$summary$tour,method='radix'),]
 r<-list('target-estimates'=x,'paired-scores'=scores,stability=balance_stability(x),'coverage-summary'=cov,summary=summary)
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_SERVE_TERMINAL_BALANCE_TRANSFER_1.0.0';r[[k]]$source_release<-'MCP_DIRECT_SERVE_TRANSFER_1.0.0';r[[k]]$specification_sha256<-balance_definition_pin;r[[k]]$claim<-'EXPLORATORY_MATCH_AVERAGE_TERMINAL_BALANCE_NOT_POINT_LOSS_SKILL_OR_FACTOR'}
 r
}
balance_install <- function(r) {
 mcp_need(identical(names(r),balance_outputs),'Exact balance output scope');paths<-paste0(balance_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing flat ignored location required')
 stage<-vapply(paths,function(p)tempfile('.serve-balance-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);balance_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing balance release')
 created<-character();success<-FALSE;on.exit(if(!success)unlink(created),add=TRUE)
 for(i in seq_along(paths))if(!file.exists(paths[i])){mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file balance installation failed');created<-c(created,paths[i])}
 success<-TRUE;invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline balance experiment takes no arguments');r<-run_mcp_serve_terminal_balance();balance_install(r);print(r[['paired-scores']],row.names=FALSE)}
