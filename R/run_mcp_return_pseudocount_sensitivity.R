# Prospective fixed convention: q=(E_prior+0.5)/(N_prior+1), N_prior>0 only.
# The unsmoothed experiment remains primary; shared scoring/deletion code is frozen.
source('R/run_mcp_broader_return_transfer.R')
pseudo_prefix <- 'data/pilot/mcp-return-pseudocount-v1-'
pseudo_outputs <- transfer_outputs
pseudo_pins <- c(
 'R/run_mcp_broader_return_transfer.R'='172076d3cf727e2b4bd796bfb69168448238690539e8df34d2ea18396305956c',
 'R/run_mcp_return_transfer.R'='4585e162b044e1a6e3b064fbd455692fa7540f67ec4767ffb68924dad91d5909',
 'data/pilot/mcp-broader-return-transfer-v1-observation-counts.csv'='d63e9ec872b7d3ff031ee78213766a95aeb13c441801c571b15ccfb59ff8a7ea',
 'data/pilot/mcp-broader-return-transfer-v1-target-estimates.csv'='00fa277b0e2b18e73b9eedab6570e8dd53fd0d5a589174ca4cb47a01eb0095fa',
 'data/pilot/mcp-broader-return-transfer-v1-paired-scores.csv'='ba50d678d3892d237a1d0ac89fc2bed6767d2a0b62f9f5e3a8e44e6a6f6f4a67',
 'data/pilot/mcp-broader-return-transfer-v1-stability.csv'='50e940a005b22cc495d75a0ec4245075a4f48a7e3e961bce7bd1001502a9b6d5',
 'data/pilot/mcp-broader-return-transfer-v1-summary.csv'='0a535f5b0016ebf76b02f1b1862feac88f3e2250e72728f5b33d890662f858bd')
pseudo_verify <- function() {
 wide_transfer_verify()
 for(f in names(pseudo_pins))mcp_need(mcp_sha(f)==pseudo_pins[[f]],paste('Primary input pin changed:',f))
 invisible(TRUE)
}
pseudo_load <- function() {
 pseudo_verify()
 setNames(lapply(pseudo_outputs,function(k)read.csv(paste0(wide_transfer_prefix,k,'.csv'),stringsAsFactors=FALSE)),pseudo_outputs)
}
pseudo_rate <- function(e,n) {
 mcp_need(length(e)==length(n)&&all(is.finite(e)&is.finite(n)&n>=0&e>=0&e<=n&e==floor(e)&n==floor(n)),'Invalid prior counts')
 q<-rep(NA_real_,length(n));use<-n>0;q[use]<-(e[use]+0.5)/(n[use]+1);q
}
pseudo_estimates <- function(original) {
 x<-original
 for(f in c('estimate','brier','log_loss','infinite_cause'))x[[paste0('primary_personal_',f)]]<-original[[paste0('personal_',f)]]
 x$personal_estimate<-NA_real_;ii<-which(x$eligible)
 x$personal_estimate[ii]<-pseudo_rate(x$prior_errors[ii],x$prior_attempts[ii])
 x$personal_brier<-x$personal_log_loss<-x$signed_departure<-x$absolute_departure<-NA_real_
 for(i in which(x$paired_mask)){
  e<-x$errors[i];n<-x$usable_attempts[i];q<-x$personal_estimate[i]
  x$personal_brier[i]<-(e*(1-q)^2+(n-e)*q^2)/n
  x$personal_log_loss[i]<-transfer_log_sum(e,n,q)/n
  x$signed_departure[i]<-e/n-q;x$absolute_departure[i]<-abs(e/n-q)
 }
 x$personal_infinite_cause<-ifelse(x$paired_mask,'NONE','NOT_SCORED')
 mcp_need(sum(x$paired_mask)==312&&identical(x$paired_mask,original$paired_mask),'Frozen 312-ID comparison mask')
 mcp_need(all(is.finite(x$personal_log_loss[x$paired_mask])),'Positive prior counts must give finite sensitivity loss')
 x
}
pseudo_comparison <- function(x,comparison) {
 mcp_need(comparison%in%c('SENSITIVITY_MINUS_REFERENCE','SENSITIVITY_MINUS_PRIMARY_PERSONAL'),'Unknown comparison')
 if(comparison=='SENSITIVITY_MINUS_PRIMARY_PERSONAL')for(f in c('estimate','brier','log_loss'))x[[paste0('reference_',f)]]<-x[[paste0('primary_personal_',f)]]
 x
}
run_mcp_pseudocount <- function(input=pseudo_load()) {
 x<-pseudo_estimates(input[['target-estimates']]);scores<-stability<-list()
 for(comparison in c('SENSITIVITY_MINUS_REFERENCE','SENSITIVITY_MINUS_PRIMARY_PERSONAL')){
  z<-pseudo_comparison(x,comparison)
  scores[[comparison]]<-cbind(data.frame(comparison),do.call(rbind,lapply(c('ATP','WTA'),function(tour)do.call(rbind,lapply(c('FIRST','SECOND'),function(context)
   cbind(data.frame(tour,context),transfer_score(z[z$tour==tour&z$context==context,])))))))
  stability[[comparison]]<-cbind(data.frame(comparison),transfer_stability(z[z$eligible,]))
 }
 y<-input$summary
 for(i in seq_len(nrow(y))){q<-x[x$tour==y$tour[i]&x$paired_mask,]
  y$primary_personal_infinite_cells[i]<-sum(is.infinite(q$primary_personal_log_loss))
  y$personal_infinite_cells[i]<-sum(is.infinite(q$personal_log_loss))
  y$personal_zero_estimate_cells[i]<-sum(q$personal_estimate==0);y$personal_one_estimate_cells[i]<-sum(q$personal_estimate==1)
  y$personal_probability_min[i]<-min(q$personal_estimate);y$personal_probability_max[i]<-max(q$personal_estimate)
 }
 r<-list('observation-counts'=input[['observation-counts']],'target-estimates'=x,'paired-scores'=do.call(rbind,scores),stability=do.call(rbind,stability),summary=y)
 for(k in names(r)){
  rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_RETURN_PSEUDOCOUNT_SENSITIVITY_1.0.0'
  r[[k]]$convention<-'FIXED_E_PLUS_0.5_OVER_N_PLUS_1_POSITIVE_PRIOR_N_ONLY'
 }
 r
}
pseudo_install <- function(r) {
 mcp_need(identical(names(r),pseudo_outputs),'Exact sensitivity output scope')
 paths<-paste0(pseudo_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.pseudocount-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);pseudo_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing sensitivity release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file install failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline sensitivity takes no arguments')
 r<-run_mcp_pseudocount();pseudo_install(r)
 print(r[['paired-scores']][,c('comparison','tour','context','difference_brier','difference_log_loss','difference_brier_opportunity_weighted','difference_log_loss_opportunity_weighted')],row.names=FALSE)
 print(r$summary[,c('tour','paired_cells','primary_personal_infinite_cells','personal_infinite_cells','personal_probability_min','personal_probability_max')],row.names=FALSE)
}
