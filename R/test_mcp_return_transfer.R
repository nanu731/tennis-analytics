source('R/run_mcp_return_transfer.R')
checks<-0L
check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
fails<-function(expr)inherits(tryCatch({force(expr);NULL},error=identity),'error')
equal<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
allowed<-c('R/run_mcp_return_transfer.R','R/test_mcp_return_transfer.R','docs/mcp-return-transfer-results.md',
 'PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
paths<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
paths<-setdiff(paths,allowed);paths<-paths[!grepl('/mcp-return-transfer-v1-',paths)]
pins<-setNames(vapply(paths,mcp_sha,''),paths)
input<-transfer_load();r<-run_mcp_return_transfer(input);x<-r[['target-estimates']];c<-r[['observation-counts']]
saved_pins<-transfer_context_pins;transfer_context_pins[1]<-paste(rep('0',64),collapse='')
check(fails(transfer_verify()),'Input hash mismatch fails closed before processing')
transfer_context_pins<-saved_pins
check(nrow(c)==352&&nrow(x)==176&&length(unique(x$match_id))==44,'All inventory contexts and targets')
check(nrow(unique(x[,c('match_id','slot')]))==88,'All neutral perspectives')
check(identical(as.integer(r$summary$inventory_matches),c(20L,24L)),'Tour inventory')
for(t in c('ATP','WTA')) {
 z<-x[x$tour==t,];s<-r$summary[r$summary$tour==t,]
 check(s$seed_matches==1&&s$seed_context_targets==4,'Earliest batch seed')
 check(s$supported_matches==6&&s$supported_slots==6&&s$supported_context_targets==12,'Frozen Option A support')
 check(s$no_history_context_targets==if(t=='ATP')64 else 80,'Cold-start accounting')
 check(s$distinct_supported_players==if(t=='ATP')4 else 5,'Distinct recurring players')
 check(s$no_target_context_targets==0&&s$no_reference_context_targets==0,'No other scored-context abstentions')
 check(sum(z$paired_mask)+sum(z$seed)+sum(z$disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS')==nrow(z),'Exhaustive target dispositions')
}
# Independent action-level count reconstruction, using the frozen pre-action fields.
e<-execution_load();a<-e$states[e$states$owner_domain=='Return'&e$states$post_kind=='STROKE',]
keys<-context_classify(a[,context_pre_fields],'Return')$serve_number
for(i in seq_len(nrow(c))) {
 z<-c[i,];sel<-a$match_id==z$match_id&a$actor_neutral_slot==z$slot&keys==z$context
 usable<-sel&a$tennis_action_usable
 check(sum(sel)==z$observed_attempts&&sum(usable)==z$usable_attempts,'Independent observed/usable counts')
 check(sum(usable&a$post_terminal_status=='FORCED_ERROR')==z$forced_errors&&
  sum(usable&a$post_terminal_status=='UNFORCED_ERROR')==z$unforced_errors,'Independent error labels/ownership')
}
check(length(unique(e$states$point_id))==7333,'All frozen points retained')
check(sum(c$unknown_execution_count)==1005&&sum(c$observed_attempts[c$context=='UNSUPPORTED'])==3,'Withheld and unsupported exposures retained')
check(!any(c$usable_attempts[c$context%in%c('UNKNOWN','UNSUPPORTED')]),'Unknown contexts not treated as successes')
# Matrix date/identity selection independently reconstructs every pooled count.
for(i in seq_len(nrow(x))) {
 z<-x[i,];mask<-x$tour==z$tour&x$context==z$context&as.Date(x$source_date)<as.Date(z$source_date)
 pmask<-mask&x$player==z$player
 check(z$prior_attempts==sum(x$usable_attempts[pmask])&&z$prior_errors==sum(x$errors[pmask]),'Personal pooled counts')
 check(z$reference_attempts==sum(x$usable_attempts[mask])&&z$reference_errors==sum(x$errors[mask]),'Reference pooled counts')
 check(z$prior_matches==sum(pmask)&&z$reference_matches==length(unique(x$match_id[mask])),'Exact prior match inventory')
 check(equal(z$personal_estimate,if(sum(x$usable_attempts[pmask]))sum(x$errors[pmask])/sum(x$usable_attempts[pmask]) else NA_real_),'Count division, no averaging')
 if(z$paired_mask) {
  for(model in c('personal','reference')) {
   q<-z[[paste0(model,'_estimate')]];y<-c(rep(1,z$errors),rep(0,z$usable_attempts-z$errors))
   check(equal(mean((y-q)^2),z[[paste0(model,'_brier')]]),'Independent Bernoulli Brier expansion')
   check(equal(mean(-log(ifelse(y==1,q,1-q))),z[[paste0(model,'_log_loss')]]),'Independent Bernoulli log expansion')
  }
  dates<-x$source_date[pmask&x$usable_attempts>0]
  check(z$days_since_last_source_date==as.numeric(as.Date(z$source_date)-as.Date(max(dates))),'Elapsed source-label gaps')
 }
}
check(all(is.na(x$personal_estimate[x$prior_attempts==0]))&&!anyNA(x$personal_brier[x$paired_mask]),'Cold start never rescued by reference')
check(identical(!is.na(x$personal_brier),!is.na(x$reference_brier))&&identical(x$paired_mask,!is.na(x$personal_brier)),'Identical paired mask')
for(i in seq_len(nrow(r[['paired-scores']]))) {
 z<-r[['paired-scores']][i,];sel<-x[x$tour==z$tour&x$context==z$context&x$paired_mask,]
 check(z$scored_matches==6&&z$paired_cells==6,'Whole-match scoring support')
 for(model in c('personal','reference'))for(kind in c('brier','log_loss')) {
  values<-sel[[paste(model,kind,sep='_')]]
  matches<-unique(sel$match_id);ref<-sum(vapply(matches,function(id)mean(values[sel$match_id==id]),0.0))/length(matches)
  check(equal(ref,z[[paste(model,kind,sep='_')]]),'Equal whole-match loss reconstruction')
  check(equal(sum(values*sel$usable_attempts)/sum(sel$usable_attempts),z[[paste(model,kind,'opportunity_weighted',sep='_')]]),'Secondary pooled opportunity loss')
 }
}
# Every deletion removes whole matches; player identity in either slot matters.
d<-r$stability
for(i in seq_len(nrow(d))) {
 z<-d[i,];sel<-x[x$tour==z$tour&x$context==z$context&!x$seed,]
 mask<-if(z$deletion_type=='MATCH')sel$match_id!=z$deleted_id else sel$player_a!=z$deleted_id&sel$player_b!=z$deleted_id
 kept<-sel[mask&sel$paired_mask,]
 check(nrow(kept)==z$paired_cells&&length(unique(kept$match_id))==z$scored_matches,'Independent both-slot/whole-match deletion')
 check(equal(mean(kept$personal_brier-kept$reference_brier),z$difference_brier),'Frozen deletion difference')
}
# Counterfactuals never refit: current/later counts cannot change a current estimate.
prediction_fields<-c('prior_matches','prior_attempts','prior_errors','reference_matches','reference_attempts','reference_errors','personal_estimate','reference_estimate')
for(date in unique(c$batch_key)) {
 t<-c$tour[match(date,c$batch_key)];cut<-c$source_date[match(date,c$batch_key)]
 alt<-c;affected<-alt$tour==t&alt$source_date>=cut
 alt$errors[affected]<-alt$usable_attempts[affected]
 alt$forced_errors[affected]<-alt$errors[affected];alt$unforced_errors[affected]<-0
 alt$usable_attempts[affected]<-alt$usable_attempts[affected]+7
 y<-transfer_estimates(alt);mask<-x$tour==t&x$source_date==cut
 check(equal(x[mask,prediction_fields],y[mask,prediction_fields]),'Current/later batch count/error invariance')
}
# A synthetic same-date multi-match batch cannot train itself; earlier data is a positive control.
f<-c[c$context%in%c('FIRST','SECOND')&c$tour=='ATP',]
f<-f[1:8,];f$source_date<-rep(c('2000-01-01','2000-02-01'),each=4);f$seed<-f$source_date=='2000-01-01'
f$match_id<-rep(c('seed','target'),each=4);f$player<-rep(c('p','p','r','r'),2)
f$player_a<-'p';f$player_b<-'r';f$usable_attempts<-10;f$errors<-2;f$forced_errors<-2;f$unforced_errors<-0
f$observed_attempts<-10;f$unknown_execution_count<-0
later<-f[5:8,];later$match_id<-'simultaneous';f<-rbind(f,later)
v<-transfer_estimates(f)
check(all(v$prior_attempts[v$source_date=='2000-02-01']==10),'Simultaneous batch fixture')
alt<-f;alt$errors[alt$match_id=='seed']<-3;alt$forced_errors[alt$match_id=='seed']<-3
w<-transfer_estimates(alt)
check(all(w$personal_estimate[w$source_date=='2000-02-01']>v$personal_estimate[v$source_date=='2000-02-01']),'Earlier count positive control')
alt<-f;alt$usable_attempts[alt$match_id=='target']<-0;alt$errors[alt$match_id=='target']<-0
check(all(transfer_estimates(alt)$disposition[5:8]=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),'Zero target fixture abstains')
for(args in list(c(0,5,0),c(5,5,1),c(1,5,0),c(4,5,1),c(0,0,0))) {
 value<-do.call(transfer_log_sum,as.list(args))
 check(identical(value,if(args[1]==1||args[1]==4)Inf else 0),'Endpoint log loss retains infinities')
}
check(equal(transfer_log_sum(0,10,1e-15),-10*log1p(-1e-15)),'Stable near-zero log loss')
check(fails(transfer_log_sum(2,1,.5))&&fails(transfer_log_sum(0,1,NA_real_)),'Bad loss inputs fail')
single<-x[x$paired_mask,][1,,drop=FALSE];single$personal_log_loss<-Inf;single$reference_log_loss<-Inf
check(is.na(transfer_score(single)$difference_log_loss)&&transfer_score(single)$comparison_status=='INDETERMINATE_LOG_COMPARISON','Inf minus Inf not concealed')
check(transfer_score(single[FALSE,])$comparison_status=='UNEVALUABLE','Empty deletion remains unevaluable')
# Match weighting differs from cell weighting when two receivers are supported.
two<-x[x$paired_mask,][1:3,];two$match_id<-c('one','one','two');two$personal_brier<-c(0,0,1)
check(transfer_score(two)$personal_brier==.5,'Average cells within match then matches')
for(kind in c('duplicate','date','identity','count','context')) {
 alt<-input
 if(kind=='duplicate')alt$sample$match_id[2]<-alt$sample$match_id[1]
 if(kind=='date')alt$sample$Date[1]<-'20260230'
 if(kind=='identity')alt$sample$player_a[1]<-alt$sample$player_b[1]
 i<-which(alt$counts$scope=='match_player'&alt$counts$view=='serve_number')[1]
 if(kind=='count')alt$counts$errors[i]<-alt$counts$usable_attempts[i]+1
 if(kind=='context')alt$counts$context[i]<-'INVENTED'
 check(fails(run_mcp_return_transfer(alt)),paste('Fail-closed',kind))
}
set.seed(91);alt<-input;alt$sample<-alt$sample[sample(nrow(alt$sample)),];alt$counts<-alt$counts[sample(nrow(alt$counts)),]
check(identical(r,run_mcp_return_transfer(alt)),'Row/match/batch permutation invariance')
alt<-input;temp<-alt$sample$player_a;alt$sample$player_a<-alt$sample$player_b;alt$sample$player_b<-temp
alt$counts$slot<-ifelse(alt$counts$slot=='A','B',ifelse(alt$counts$slot=='B','A',alt$counts$slot))
y<-run_mcp_return_transfer(alt)[['target-estimates']]
ix<-match(paste(x$match_id,x$player,x$context),paste(y$match_id,y$player,y$context))
check(equal(x[,prediction_fields],y[ix,prediction_fields]),'Neutral slot relabeling')
again<-run_mcp_return_transfer()
for(k in names(r)) {
 a<-tempfile();b<-tempfile();mcp_write(r[[k]],a);mcp_write(again[[k]],b)
 check(mcp_sha(a)==mcp_sha(b),paste('Byte-identical independent rerun',k));unlink(c(a,b))
}
# Staging validates all files before changing destinations; differing releases are protected.
test_prefix<-paste0('data/pilot/.return-test-',Sys.getpid(),'-');test_paths<-paste0(test_prefix,transfer_outputs,'.csv')
transfer_install(r,test_prefix);testpins<-vapply(test_paths,mcp_sha,'')
bad<-r;bad$summary$inventory_matches[1]<-999
check(fails(transfer_install(bad,test_prefix))&&identical(testpins,vapply(test_paths,mcp_sha,'')),'Differing release preflight preserves every file')
transfer_install(r,test_prefix);check(identical(testpins,vapply(test_paths,mcp_sha,'')),'Idempotent atomic per-file install')
unlink(test_paths)
check(!length(list.files('data/pilot',pattern='^\\.return-stage-')),'No staging residue')
transfer_install(r)
for(i in seq_along(r))check(mcp_sha(paste0(transfer_prefix,names(r)[i],'.csv'))==testpins[i],'Installed bytes match staged rerun')
check(length(system2('git',c('check-ignore','--',shQuote(paste0(transfer_prefix,transfer_outputs,'.csv'))),stdout=TRUE))==5,'All five outputs ignored')
check(identical(pins,setNames(vapply(paths,mcp_sha,''),paths)),'Historical artifacts unchanged')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(paths)))
