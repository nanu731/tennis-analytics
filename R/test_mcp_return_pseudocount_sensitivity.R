source('R/run_mcp_return_pseudocount_sensitivity.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/run_mcp_return_pseudocount_sensitivity.R','R/test_mcp_return_pseudocount_sensitivity.R','docs/mcp-return-pseudocount-sensitivity.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
old<-setdiff(old,allowed);old<-old[!startsWith(old,pseudo_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
input<-pseudo_load();r<-run_mcp_pseudocount(input);x<-r[['target-estimates']];original<-input[['target-estimates']];counts<-input[['observation-counts']]
check(nrow(x)==636&&nrow(counts)==1272&&length(unique(x$match_id))==159,'All inventory retained')
check(sum(x$paired_mask)==312&&sum(x$disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS')==304&&sum(x$seed)==8&&sum(x$disposition=='COMPLETION_EXCLUDED')==12,'Frozen accounting')
key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
check(identical(key(x),key(original))&&!anyDuplicated(key(x)),'Exact inventory/context IDs')
changed<-c('release','personal_estimate','personal_brier','personal_log_loss','personal_infinite_cause','signed_departure','absolute_departure')
for(k in setdiff(names(original),changed))check(identical(x[[k]],original[[k]]),paste('Frozen target field',k))
for(k in setdiff(names(counts),'release'))check(identical(r[['observation-counts']][[k]],counts[[k]]),paste('Frozen count field',k))
for(f in c('estimate','brier','log_loss','infinite_cause'))check(identical(x[[paste0('primary_personal_',f)]],original[[paste0('personal_',f)]]),'Primary personal values retained including Inf')
check(all(is.na(x$personal_estimate[!x$eligible|(!is.na(x$prior_attempts)&x$prior_attempts==0)])),'Excluded/cold starts never initialized')
check(all(is.na(x$personal_brier[!x$paired_mask])&is.na(x$personal_log_loss[!x$paired_mask])),'Unscored rows retain abstention')
check(same(pseudo_rate(c(0,0,4,1),c(0,4,4,2)),c(NA,0.1,0.9,0.5)),'Independent fixed formula fixture including N=0')
for(z in list(list(-1,2),list(3,2),list(1.5,2),list(1,NA),list(1,-2),list(c(1,2),2)))check(fails(pseudo_rate(z[[1]],z[[2]])),'Invalid prior count fails')
logloss<-function(e,n,q){if((q==0&&e>0)||(q==1&&e<n))return(Inf);v<-0;if(e>0)v<-v-e*log(q);if(e<n)v<-v-(n-e)*log(1-q);v/n}
for(i in which(x$eligible)){
 z<-x[i,];prior<-counts[counts$eligible&counts$tour==z$tour&counts$context==z$context&counts$source_date<z$source_date,];own<-prior[prior$player==z$player,]
 check(z$prior_attempts==sum(own$usable_attempts)&&z$prior_errors==sum(own$errors),'Training-only personal count reconstruction')
 check(z$reference_attempts==sum(prior$usable_attempts)&&z$reference_errors==sum(prior$errors),'Unchanged training-only reference reconstruction')
 expected<-if(sum(own$usable_attempts)>0)(sum(own$errors)+1/2)/(sum(own$usable_attempts)+1) else NA_real_
 check(same(z$personal_estimate,expected),'Independent fixed pooled-count formula')
 if(z$paired_mask){for(model in c('personal','reference')){
  q<-z[[paste0(model,'_estimate')]];a<-c(rep(1,z$errors),rep(0,z$usable_attempts-z$errors))
  check(same(mean((a-q)^2),z[[paste0(model,'_brier')]]),'Independent Bernoulli Brier')
  check(same(logloss(z$errors,z$usable_attempts,q),z[[paste0(model,'_log_loss')]]),'Independent stable natural-log loss')
 };check(same(z$signed_departure,z$errors/z$usable_attempts-z$personal_estimate)&&same(z$absolute_departure,abs(z$signed_departure)),'Updated measurement departure')}
}
check(sum(is.infinite(x$primary_personal_log_loss))==3&&!any(is.infinite(x$personal_log_loss)),'Three primary endpoint failures preserved, sensitivity finite')
check(all(x$personal_estimate[x$paired_mask]>0&x$personal_estimate[x$paired_mask]<1),'No sensitivity endpoints')
# Current/later, simultaneous and excluded errors cannot change pre-batch pools.
cols<-c('prior_errors','prior_attempts','personal_estimate','reference_estimate')
for(tour in c('ATP','WTA')){
 dates<-sort(unique(counts$source_date[counts$eligible&counts$tour==tour]));ties<-names(which(table(counts$source_date[counts$eligible&counts$tour==tour&counts$slot=='A'&counts$context=='FIRST'])>1))
 for(cut in unique(c(dates[1],dates[ceiling(length(dates)/2)],tail(dates,1),head(ties,1)))){
  q<-counts;mask<-q$tour==tour&q$source_date>=cut;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];q$forced_errors[mask]<-q$errors[mask];q$unforced_errors[mask]<-0
  alt<-pseudo_estimates(wide_transfer_estimates(q));ii<-x$tour==tour&x$source_date==cut
  check(same(x[ii,cols],alt[ii,cols]),'Current/later/same-date perturbation invariance');check(identical(x$paired_mask,alt$paired_mask),'Fixed masks under outcomes')
 }
}
q<-counts;mask<-!q$eligible;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];q$forced_errors[mask]<-q$errors[mask];q$unforced_errors[mask]<-0
alt<-pseudo_estimates(wide_transfer_estimates(q));check(same(x[,cols],alt[,cols]),'Excluded data never enters estimates')
z<-x[x$paired_mask,][1,];q<-counts;j<-which(q$eligible&q$tour==z$tour&q$context==z$context&q$player==z$player&q$source_date<z$source_date&q$errors<q$usable_attempts)[1]
q$errors[j]<-q$errors[j]+1;q$forced_errors[j]<-q$forced_errors[j]+1;alt<-pseudo_estimates(wide_transfer_estimates(q));ii<-match(key(z),key(x))
check(same(alt$personal_estimate[ii]-x$personal_estimate[ii],1/(z$prior_attempts+1)),'Earlier eligible error positive control')
# Independent match pooling and all deletions; no hidden re-estimation.
score<-function(z){z<-z[z$paired_mask,];out<-c(paired_cells=nrow(z),scored_matches=length(unique(z$match_id)),target_attempts=sum(z$usable_attempts))
 for(kind in c('brier','log_loss'))for(model in c('personal','reference')){
  vals<-if(nrow(z))vapply(seq_len(nrow(z)),function(i){p<-z[[paste0(model,'_estimate')]][i];n<-z$usable_attempts[i];e<-z$errors[i];if(kind=='brier')(e*(1-p)^2+(n-e)*p^2)/n else logloss(e,n,p)},0.0) else numeric()
  out[paste(model,kind,sep='_')]<-if(nrow(z))mean(vapply(split(vals,z$match_id),mean,0.0)) else NA_real_
  out[paste(model,kind,'opportunity_weighted',sep='_')]<-if(nrow(z))sum(vals*z$usable_attempts)/sum(z$usable_attempts) else NA_real_
 }
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')){v<-out[paste0('personal_',kind,suffix)]-out[paste0('reference_',kind,suffix)];out[paste0('difference_',kind,suffix)]<-if(is.nan(v))NA_real_ else v};out}
check(nrow(r[['paired-scores']])==8&&nrow(r$stability)==1232,'Both fixed comparisons and all 616 deletions each')
for(i in seq_len(nrow(r[['paired-scores']]))){z<-r[['paired-scores']][i,];v<-pseudo_comparison(x,z$comparison);ref<-score(v[v$tour==z$tour&v$context==z$context,]);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent paired loss',k))}
for(i in seq_len(nrow(r$stability))){z<-r$stability[i,];v<-pseudo_comparison(x,z$comparison);v<-v[v$eligible&!v$seed&v$tour==z$tour&v$context==z$context,]
 remove<-if(z$deletion_type=='MATCH')v$match_id==z$deleted_id else v$player_a==z$deleted_id|v$player_b==z$deleted_id
 ref<-score(v[!remove,]);base<-score(v);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent deletion',k))
 check(z$deleted_evaluation_matches==length(unique(v$match_id[remove]))&&z$deleted_paired_cells==sum(v$paired_mask[remove]),'Both-slot/all-match deletion accounting')
 check(same(z$change_brier_difference,unname(ref['difference_brier']-base['difference_brier'])),'Deletion change')
}
for(comparison in unique(r$stability$comparison)){
 st<-r$stability[r$stability$comparison==comparison,];primary<-input$stability
 check(same(st[,c('tour','context','deletion_type','deleted_id','deleted_evaluation_matches','deleted_paired_cells')],primary[,c('tour','context','deletion_type','deleted_id','deleted_evaluation_matches','deleted_paired_cells')]),'Every frozen deletion ID/count including zero impact')
}
set.seed(42);alt<-pseudo_estimates(original[sample(nrow(original)),]);alt<-alt[match(key(x),key(alt)),];check(same(pseudo_estimates(original),alt),'Row/within-batch permutation invariance')
rr<-run_mcp_pseudocount();for(k in names(r)){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(rr[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte rerun',k));unlink(c(f,g))}
pseudo_install(r);paths<-paste0(pseudo_prefix,pseudo_outputs,'.csv');pins<-setNames(vapply(paths,mcp_sha,''),paths)
check(length(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE))==5,'Five ignored outputs')
bad<-r;bad$summary$paired_cells[1]<-bad$summary$paired_cells[1]+1
check(fails(pseudo_install(bad))&&identical(pins,setNames(vapply(paths,mcp_sha,''),paths)),'Immutable install preflight leaves every file unchanged')
check(fails(pseudo_install(r[rev(names(r))])),'Incorrect output scope fails')
check(!length(list.files('data/pilot',pattern='^\\.pseudocount-',all.files=TRUE)),'Atomic stage cleanup')
check(identical(oldpins,setNames(vapply(old,mcp_sha,''),old)),'Historical artifacts unchanged')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(old)))
