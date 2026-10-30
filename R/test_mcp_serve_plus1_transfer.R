source('R/run_mcp_serve_plus1_transfer.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
allowed<-c('PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md','R/run_mcp_serve_plus1_transfer.R','R/test_mcp_serve_plus1_transfer.R','docs/mcp-serve-plus1-transfer-results.md')
old<-setdiff(old,allowed);old<-old[!startsWith(old,plus_transfer_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
input<-plus_transfer_load();r<-run_mcp_plus1_transfer(input);c<-r[['observation-counts']];x<-r[['target-estimates']];e<-input$eligibility
check(nrow(c)==1784&&nrow(x)==892&&length(unique(c$match_id))==223,'All inventory matches and contexts retained')
check(!anyDuplicated(paste(c$match_id,c$slot,c$context))&&!anyDuplicated(paste(x$match_id,x$slot,x$context)),'Unique paired units')
check(sum(x$paired_mask)==504&&sum(x$disposition=='COMPLETION_EXCLUDED')==12&&sum(x$seed)==8&&sum(x$disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS')==360,'Frozen disposition partition')
check(all(is.na(x$personal_estimate[!x$eligible])&is.na(x$reference_estimate[!x$eligible])),'Completion exclusions receive no estimates')
check(identical(x$paired_mask,x$paired_support)&&all(is.na(x$personal_brier[!x$paired_mask])&is.na(x$reference_brier[!x$paired_mask])),'One identical mask; no scores for abstentions')
check(!any(c$errors[c$context%in%c('UNKNOWN','UNSUPPORTED')]>0),'Unknown exposure never becomes an error or success')
# Numerators reconstructed from the separately pinned parser ledger, not state terminals.
a<-input$actions;s<-input$states
j<-match(a$action_id,s$action_id);check(!anyNA(j)&&!anyDuplicated(a$action_id),'Parser/state action identity join')
use<-a$domain=='Rally'&a$kind=='STROKE'&a$actor==a$server&a$in_play_shot==3&s$tennis_action_usable[j]&a$serve_number%in%c(1,2)
k<-match(paste(a$match_id,a$actor_neutral_slot,ifelse(a$serve_number==1,'FIRST','SECOND'),sep='|'),paste(c$match_id,c$slot,c$context,sep='|'))
check(!anyNA(k[use]),'Usable +1 parser serve-context ownership')
forced<-tabulate(k[use&a$terminal=='FORCED_ERROR'],nrow(c));unforced<-tabulate(k[use&a$terminal=='UNFORCED_ERROR'],nrow(c))
attempts<-tabulate(k[use],nrow(c))
for(i in seq_len(nrow(c)))check(c$usable_attempts[i]==attempts[i]&&c$forced_errors[i]==forced[i]&&c$unforced_errors[i]==unforced[i]&&c$errors[i]==forced[i]+unforced[i],'Independent owned attempt/error reconstruction')
# Direct Bernoulli losses with boundary cases; no helper implementation used.
logloss<-function(errors,n,prob){if((prob==0&&errors>0)||(prob==1&&errors<n))return(Inf);v<-0;if(errors>0)v<-v-errors*log(prob);if(errors<n)v<-v-(n-errors)*log(1-prob);v/n}
for(i in which(x$eligible)){
 z<-x[i,];prior<-c[c$eligible&c$tour==z$tour&c$context==z$context&as.Date(c$source_date)<as.Date(z$source_date),];own<-prior[prior$player==z$player,]
 check(z$prior_errors==sum(own$errors)&&z$prior_attempts==sum(own$usable_attempts)&&z$prior_matches==nrow(own),'Independent personal count pool')
 check(z$reference_errors==sum(prior$errors)&&z$reference_attempts==sum(prior$usable_attempts)&&z$reference_matches==length(unique(prior$match_id)),'Independent reference count pool')
 check(z$prior_forced_errors==sum(own$forced_errors)&&z$prior_unforced_errors==sum(own$unforced_errors),'Error-subcount history')
 q<-if(nrow(own)&&sum(own$usable_attempts)>0)sum(own$errors)/sum(own$usable_attempts) else NA_real_
 check(same(q,z$personal_estimate),'Unsmoothed pooled ratio, not averaged match rates')
 if(z$paired_mask){for(model in c('personal','reference')){
  prob<-z[[paste0(model,'_estimate')]];outcomes<-c(rep(1,z$errors),rep(0,z$usable_attempts-z$errors))
  check(same(mean((outcomes-prob)^2),z[[paste0(model,'_brier')]]),'Independent action-level Brier')
  check(same(logloss(z$errors,z$usable_attempts,prob),z[[paste0(model,'_log_loss')]]),'Independent natural-log loss')
 };check(same(z$signed_departure,z$errors/z$usable_attempts-z$personal_estimate)&&same(z$absolute_departure,abs(z$signed_departure)),'Measurement departures')}
}
# Test stable endpoint arithmetic explicitly, including Inf minus Inf.
for(fixture in list(c(0,5,0),c(5,5,1),c(1,5,0),c(4,5,1),c(1,5,0.2),c(0,5,1e-14))){check(same(transfer_log_sum(fixture[1],fixture[2],fixture[3])/fixture[2],logloss(fixture[1],fixture[2],fixture[3])),'Stable log endpoint fixture')}
zz<-x[x$paired_mask,][1,];zz$personal_log_loss<-Inf;zz$reference_log_loss<-Inf;check(is.na(transfer_score(zz)$difference_log_loss)&&transfer_score(zz)$comparison_status=='INDETERMINATE_LOG_COMPARISON','Inf minus Inf not a tie')
check(transfer_score(x[FALSE,])$comparison_status=='UNEVALUABLE','Empty comparison abstains')
# Frozen identity, support, completion, absence and unknown boundaries.
b<-input$frozen[['point-opportunity-dispositions']];h<-input$frozen[['context-support']]
check(nrow(b)==43310&&sum(e$points)==43310&&sum(!e$eligible)==3,'Complete inventory and unchanged completion exclusions')
check(setequal(plus_transfer_key(x[x$paired_mask,]),plus_transfer_key(h[h$paired_support,])),'Exact frozen 504 IDs before scoring')
check(all(b$context[b$disposition=='KNOWN_ABSENT']=='NOT_APPLICABLE')&&!any(b$denominator_member[b$disposition!='VALIDATED_ATTEMPT']),'Known absence, withheld prefix and unknown are not trials')
check(all(c$errors==c$forced_errors+c$unforced_errors&c$errors<=c$usable_attempts),'Numerator bounds and ownership')
check(sum(x$disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS')==8&&sum(x$disposition=='NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS')==0,'Zero-target/ref dispositions retained')
for(tour in c('ATP','WTA'))for(context in c('FIRST','SECOND')){
 v<-x[x$tour==tour&x$context==context&x$paired_mask,]
 expected<-if(tour=='ATP')if(context=='FIRST')120 else 118 else if(context=='FIRST')134 else 132
 check(nrow(v)==expected,'Context-specific mask, not all-context slots')
}
pin<-plus_transfer_pins;plus_transfer_pins[1]<-paste(rep('0',64),collapse='');check(fails(plus_transfer_verify()),'Source/code hash conflict fails closed');plus_transfer_pins<-pin
for(field in c('paired_support','source_date','usable_attempts')){
 bad<-input;bad$frozen[['context-support']][[field]][1]<-if(field=='paired_support')!h[[field]][1] else if(field=='source_date')'invalid' else h[[field]][1]+1
 check(fails(plus_transfer_support(bad)),paste('Frozen support conflict rejected',field))
}
bad<-input;bad$eligibility$eligible[1]<-!e$eligible[1];check(fails(plus_transfer_support(bad)),'Completion change rejected')
bad<-input;bad$states$post_terminal_status[1]<-'INVENTED';check(fails(plus_transfer_support(bad)),'Parser/state authority conflict rejected')
# Frozen mask survives error-outcome perturbations; current/later changes cannot enter q.
cols<-c('prior_errors','prior_attempts','reference_errors','reference_attempts','personal_estimate','reference_estimate')
for(tour in c('ATP','WTA')){
 dates<-sort(unique(c$source_date[c$tour==tour&c$eligible]));ties<-names(which(table(c$source_date[c$tour==tour&c$eligible&c$context=='FIRST'&c$slot=='A'])>1))
 cuts<-unique(c(dates[1],dates[ceiling(length(dates)/2)],tail(dates,1),head(ties,1)))
 for(cut in cuts){q<-c;mask<-q$tour==tour&q$source_date>=cut;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];q$forced_errors[mask]<-q$errors[mask];q$unforced_errors[mask]<-0L
  alt<-wide_transfer_estimates(q);ii<-x$tour==tour&x$source_date==cut
  check(same(x[ii,cols],alt[ii,cols]),'Current/simultaneous/later outcomes cannot affect pre-batch estimates');check(identical(x$paired_mask,alt$paired_mask),'Outcomes cannot select comparison IDs')
 }
}
q<-c;mask<-!q$eligible;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];q$forced_errors[mask]<-q$errors[mask];q$unforced_errors[mask]<-0L
alt<-wide_transfer_estimates(q);check(same(x[,cols],alt[,cols]),'Excluded outcomes cannot update any history')
z<-x[x$paired_mask,][1,];q<-c;j<-which(q$eligible&q$tour==z$tour&q$context==z$context&q$player==z$player&q$source_date<z$source_date&q$errors<q$usable_attempts)[1]
q$errors[j]<-q$errors[j]+1L;q$forced_errors[j]<-q$forced_errors[j]+1L;alt<-wide_transfer_estimates(q);ii<-which(x$match_id==z$match_id&x$slot==z$slot&x$context==z$context)
check(same(alt$personal_estimate[ii]-x$personal_estimate[ii],1/x$prior_attempts[ii]),'Eligible earlier error positive control')
set.seed(41);q<-input;q$states<-q$states[sample(nrow(q$states)),];q$eligibility<-q$eligibility[sample(nrow(q$eligibility)),];q$actions<-q$actions[sample(nrow(q$actions)),];q$frozen[['context-support']]<-q$frozen[['context-support']][sample(nrow(q$frozen[['context-support']])),]
rr<-run_mcp_plus1_transfer(q);for(k in names(r))check(identical(r[[k]],rr[[k]]),paste('Action/match/within-batch permutation',k))
# Independent whole-match and opportunity-weighted aggregation and every deletion.
score<-function(z){z<-z[z$paired_mask,];out<-c(paired_cells=nrow(z),scored_matches=length(unique(z$match_id)),target_attempts=sum(z$usable_attempts))
 for(kind in c('brier','log_loss'))for(model in c('personal','reference')){
  vals<-if(nrow(z))vapply(seq_len(nrow(z)),function(i){p<-z[[paste0(model,'_estimate')]][i];n<-z$usable_attempts[i];er<-z$errors[i];if(kind=='brier')(er*(1-p)^2+(n-er)*p^2)/n else logloss(er,n,p)},0.0) else numeric()
  out[paste(model,kind,sep='_')]<-if(nrow(z))mean(vapply(split(vals,z$match_id),mean,0.0)) else NA_real_
  out[paste(model,kind,'opportunity_weighted',sep='_')]<-if(nrow(z))sum(vals*z$usable_attempts)/sum(z$usable_attempts) else NA_real_
 }
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')){v<-out[paste0('personal_',kind,suffix)]-out[paste0('reference_',kind,suffix)];out[paste0('difference_',kind,suffix)]<-if(is.nan(v))NA_real_ else v};out}
for(i in seq_len(nrow(r[['paired-scores']]))){z<-r[['paired-scores']][i,];ref<-score(x[x$tour==z$tour&x$context==z$context,]);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent paired aggregation',k))}
st<-r$stability
for(i in seq_len(nrow(st))){z<-st[i,];v<-x[x$eligible&!x$seed&x$tour==z$tour&x$context==z$context,]
 remove<-if(z$deletion_type=='MATCH')v$match_id==z$deleted_id else v$player_a==z$deleted_id|v$player_b==z$deleted_id
 ref<-score(v[!remove,]);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent score deletion',k))
 check(z$deleted_evaluation_matches==length(unique(v$match_id[remove]))&&z$deleted_paired_cells==sum(v$paired_mask[remove]),'Both-slot player/all-match deletion accounting')
}
for(tour in c('ATP','WTA'))for(context in c('FIRST','SECOND')){v<-x[x$tour==tour&x$context==context&x$eligible&!x$seed,];z<-st[st$tour==tour&st$context==context,]
 check(setequal(z$deleted_id[z$deletion_type=='MATCH'],v$match_id)&&setequal(z$deleted_id[z$deletion_type=='PLAYER'],c(v$player_a,v$player_b)),'Every eligible match and either-slot player enumerated, including zero-impact')}
# Independent rerun from pinned files, immutable install and historical preservation.
rr<-run_mcp_plus1_transfer();for(k in names(r)){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(rr[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte rerun',k));unlink(c(f,g))}
plus_transfer_install(r);check(length(system2('git',c('check-ignore','--',shQuote(paste0(plus_transfer_prefix,plus_transfer_outputs,'.csv'))),stdout=TRUE))==6,'Ignored outputs in existing location')
check(identical(oldpins,setNames(vapply(old,mcp_sha,''),old)),'Historical artifacts preserved')
# Slot relabeling changes IDs only, never physical player pools or scores.
q<-c;q$slot<-ifelse(q$slot=='A','B','A');q$player_a<-c$player_b;q$player_b<-c$player_a
alt<-wide_transfer_estimates(q);j<-match(paste(x$match_id,x$player,x$context),paste(alt$match_id,alt$player,alt$context))
check(!anyNA(j)&&same(x[,cols],alt[j,cols])&&same(x$personal_brier,alt$personal_brier[j]),'Neutral slot-swap estimates and losses')
for(tour in c('ATP','WTA'))for(context in c('FIRST','SECOND'))check(same(transfer_score(x[x$tour==tour&x$context==context,]),transfer_score(alt[alt$tour==tour&alt$context==context,])),'Slot-swap scores')
# Each supported slot retains the frozen usable history/batch count and gaps.
for(i in which(x$paired_mask)){
 z<-x[i,];v<-c[c$eligible&c$tour==z$tour&c$context==z$context&c$player==z$player&c$source_date<z$source_date&c$usable_attempts>0,]
 check(z$prior_usable_matches==nrow(v)&&z$prior_batches==length(unique(v$source_date)),'Usable prior depth/batches')
 check(z$days_since_last_source_date==as.numeric(as.Date(z$source_date)-as.Date(max(v$source_date))),'Nominal source-label gap')
}
for(i in seq_len(nrow(r[['coverage-summary']]))){z<-r[['coverage-summary']][i,];p<-b[b$match_id==z$match_id,]
 check(z$points==nrow(p)&&z$known_absences==sum(p$disposition=='KNOWN_ABSENT')&&z$unknown_opportunities==sum(p$disposition=='UNKNOWN_OPPORTUNITY')&&z$unvalidated_prefixes==sum(p$disposition=='UNVALIDATED_OBSERVED_PREFIX'),'All match/point dispositions preserved')}
wrong<-r;wrong[['paired-scores']]$difference_brier[1]<-0;check(fails(plus_transfer_install(wrong)),'Atomic preflight refuses differing existing release')
check(all(vapply(names(r),function(k)mcp_sha(paste0(plus_transfer_prefix,k,'.csv'))=={f<-tempfile();mcp_write(r[[k]],f);sha<-mcp_sha(f);unlink(f);sha},FALSE)),'Failed preflight changed no output')
tracked<-system2('git',c('diff','--name-only'),stdout=TRUE);untracked<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
check(all(c(tracked,untracked)%in%allowed),'No tracked or untracked changes outside exact six-file scope')
check(length(r)==6&&identical(names(r),plus_transfer_outputs),'Exact six generated outputs')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(old)))
