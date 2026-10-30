source('R/run_mcp_expanded_first_serve_fault_transfer.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/run_mcp_expanded_first_serve_fault_transfer.R','R/test_mcp_expanded_first_serve_fault_transfer.R','docs/mcp-expanded-first-serve-fault-transfer-results.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
old<-setdiff(old,allowed);old<-old[!startsWith(old,expanded_serve_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
input<-expanded_serve_load();r<-run_mcp_expanded_serve_transfer(input);c<-r[['observation-counts']];x<-r[['target-estimates']];a<-input$actions;s<-input$states;e<-input$eligibility
check(nrow(c)==1784&&nrow(x)==446&&nrow(r[['coverage-summary']])==223,'All inventory and neutral slots retained')
key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
check(!anyDuplicated(key(c))&&!anyDuplicated(key(x))&&setequal(x$match_id,e$match_id),'Unique FIRST target identities')
check(all(is.na(x$personal_estimate[!x$eligible])&is.na(x$reference_estimate[!x$eligible])),'Completion exclusions abstain')
check(all(is.na(x$personal_estimate[x$eligible&x$prior_attempts==0])),'Positive-denominator cold starts')
check(all(is.na(x$personal_brier[!x$paired_mask])&is.na(x$reference_brier[!x$paired_mask])),'Unscored contexts remain undefined')
# Independent parser-kind counts use frozen usability only after exact action-ID linkage.
j<-match(a$action_id,s$action_id);use<-s$tennis_action_usable[j]
k<-match(paste(a$match_id,a$actor_neutral_slot,serve_context(a$serve_number),sep='|'),key(c))
physical<-a$kind%in%c('SERVE','SERVE_FAULT')&!a$is_void
check(!anyNA(k[physical]),'Independent physical Serve ownership/context join')
observed<-tabulate(k[physical],nrow(c));usable<-tabulate(k[physical&use],nrow(c));faults<-tabulate(k[physical&use&a$kind=='SERVE_FAULT'],nrow(c))
for(i in seq_len(nrow(c)))check(c$observed_attempts[i]==observed[i]&&c$usable_attempts[i]==usable[i]&&c$withheld_attempts[i]==observed[i]-usable[i]&&c$errors[i]==faults[i],'Independent physical attempt/fault denominator')
check(sum(c$observed_attempts)==sum(physical)&&sum(c$usable_attempts)==sum(physical&use),'No admin/let/other-domain attempt credit')
check(all(c$first_serve_faults[c$context=='FIRST']==c$errors[c$context=='FIRST'])&&all(is.na(c$first_serve_faults[c$context!='FIRST'])),'Only FIRST faults define the measurement')
check(!any(c$usable_attempts[!c$context%in%c('FIRST','SECOND')]>0),'Unknown context withheld')
# Focused frozen-parser notation fixtures, including lets, forfeits and unknown attributes.
z<-action_sequence('cc4n','1st',1L,1L)$actions;check(sum(z$kind=='LET')==2&&sum(z$kind%in%c('SERVE','SERVE_FAULT'))==1&&sum(z$kind=='SERVE_FAULT')==1,'Lets are void, repeated attempt not counted')
z<-action_sequence('V','1st',1L,1L)$actions;check(all(z$kind=='FIRST_SERVE_FORFEIT')&&!any(z$kind%in%c('SERVE','SERVE_FAULT')),'Administrative forfeit is not a fault attempt')
z<-action_sequence('0e','1st',1L,1L)$actions;check(sum(z$kind=='SERVE_FAULT')==1&&grepl('UNKNOWN_FAULT_TYPE',z$unknowns,fixed=TRUE)&&grepl('UNKNOWN_SERVE_DIRECTION',z$unknowns,fixed=TRUE),'Unknown subtype/direction still has a documented fault')
z<-action_sequence('','1st',1L,1L)$actions;check(all(z$kind=='MISSING_SEQUENCE')&&!any(z$kind%in%c('SERVE','SERVE_FAULT')),'Missing sequence is not a synthesized attempt')
for(i in seq_len(nrow(e))){v<-r[['coverage-summary']][r[['coverage-summary']]$match_id==e$match_id[i],];b<-a[a$match_id==e$match_id[i],]
 check(v$void_lets==sum(b$kind=='LET')&&v$administrative_first_serve_forfeits==sum(b$kind=='FIRST_SERVE_FORFEIT'),'Independent void/admin coverage')
 check(v$missing_observation_rows==sum(b$observation=='MISSING_OBSERVATION')&&v$unsupported_observation_rows==sum(b$observation=='UNSUPPORTED_SUFFIX'),'Missing/unsupported rows remain inventory, not attempts')
 check(v$unknown_unobserved_attempt_count=='NOT_IDENTIFIABLE','Unobserved attempt count is explicitly unknown')
}
# Direct action-outcome losses and strictly earlier personal/reference pools.
logloss<-function(er,n,p){if((p==0&&er>0)||(p==1&&er<n))return(Inf);v<-0;if(er>0)v<-v-er*log(p);if(er<n)v<-v-(n-er)*log(1-p);v/n}
for(i in seq_len(nrow(x))){z<-x[i,];p<-c[c$eligible&c$context=='FIRST'&c$tour==z$tour&c$source_date<z$source_date,];own<-p[p$player==z$player,]
 check(z$prior_attempts==sum(own$usable_attempts)&&z$prior_errors==sum(own$errors)&&z$prior_matches==nrow(own),'Independent earlier personal pools')
 check(z$reference_attempts==sum(p$usable_attempts)&&z$reference_errors==sum(p$errors),'Independent earlier category reference')
 expected<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(z$seed)'SEED_NOT_EVALUATED' else if(z$usable_attempts==0)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(z$prior_attempts==0)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else if(z$reference_attempts==0)'NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS' else 'PAIRED_SUPPORTED'
 check(z$disposition==expected&&z$paired_mask==(expected=='PAIRED_SUPPORTED'),'Frozen failure precedence')
 for(model in c('personal','reference')){n<-if(model=='personal')z$prior_attempts else z$reference_attempts;er<-if(model=='personal')z$prior_errors else z$reference_errors;q<-if(z$eligible&&n>0)er/n else NA_real_
  check(same(z[[paste0(model,'_estimate')]],q),'Unsmoothed pooled ratio, no service-point substitution')
  if(z$paired_mask){outcomes<-c(rep(1,z$errors),rep(0,z$usable_attempts-z$errors));check(same(mean((outcomes-q)^2),z[[paste0(model,'_brier')]]),'Independent Brier');check(same(logloss(z$errors,z$usable_attempts,q),z[[paste0(model,'_log_loss')]]),'Independent natural log loss')}
 }
}
for(z in list(c(0,5,0),c(5,5,1),c(1,5,0),c(4,5,1),c(2,5,0.4)))check(same(transfer_log_sum(z[1],z[2],z[3])/z[2],logloss(z[1],z[2],z[3])),'Endpoint cases, including explicit Inf')
fixture<-x[x$paired_mask,][1,];fixture$personal_log_loss<-fixture$reference_log_loss<-Inf;check(is.na(transfer_score(fixture)$difference_log_loss),'Inf minus Inf is indeterminate')
check(transfer_score(x[FALSE,])$comparison_status=='UNEVALUABLE','Empty comparison abstains')
# Count perturbations test cutoffs independently of target loss.
cols<-c('prior_errors','prior_attempts','reference_errors','reference_attempts','personal_estimate','reference_estimate')
for(tour in c('ATP','WTA')){
 dates<-sort(unique(c$source_date[c$eligible&c$tour==tour]));ties<-names(which(table(c$source_date[c$eligible&c$tour==tour&c$slot=='A'&c$context=='FIRST'])>1))
 for(cut in unique(c(dates[1],dates[ceiling(length(dates)/2)],tail(dates,1),head(ties,1)))){q<-c;mask<-q$tour==tour&q$source_date>=cut;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];q$first_serve_faults[q$context=='FIRST']<-q$errors[q$context=='FIRST']
  alt<-serve_estimates(q);ii<-x$tour==tour&x$source_date==cut;check(same(x[ii,cols],alt[ii,cols]),'Current/later/simultaneous outcomes do not enter current estimates');check(identical(x$paired_mask,alt$paired_mask),'Numerators cannot choose the comparison mask')
  q<-c;mask<-q$tour==tour&q$source_date>=cut&q$context=='FIRST';q$usable_attempts[mask]<-q$usable_attempts[mask]+1L;q$observed_attempts[mask]<-q$observed_attempts[mask]+1L;alt<-serve_estimates(q);check(same(x[ii,cols],alt[ii,cols]),'Current/later opportunity counts cannot enter current history')
 }
}
q<-c;mask<-!q$eligible;q$errors[mask]<-q$usable_attempts[mask]-q$errors[mask];alt<-serve_estimates(q);check(same(x[,cols],alt[,cols]),'Excluded observations never update any pool')
z<-x[x$paired_mask,][1,];q<-c;j<-which(q$eligible&q$tour==z$tour&q$context=='FIRST'&q$player==z$player&q$source_date<z$source_date&q$errors<q$usable_attempts)[1]
q$errors[j]<-q$errors[j]+1;alt<-serve_estimates(q);ii<-match(key(z),key(x));check(same(alt$personal_estimate[ii]-x$personal_estimate[ii],1/z$prior_attempts),'Earlier eligible fault positive control')
# Same source category cannot receive cross-category observations.
q<-c;q$errors[q$tour=='ATP']<-q$usable_attempts[q$tour=='ATP']-q$errors[q$tour=='ATP'];alt<-serve_estimates(q);check(same(x[x$tour=='WTA',cols],alt[alt$tour=='WTA',cols]),'Category separation')
score<-function(z){z<-z[z$paired_mask,];out<-c(paired_cells=nrow(z),scored_matches=length(unique(z$match_id)),target_attempts=sum(z$usable_attempts))
 for(kind in c('brier','log_loss'))for(model in c('personal','reference')){vals<-if(nrow(z))vapply(seq_len(nrow(z)),function(i){p<-z[[paste0(model,'_estimate')]][i];n<-z$usable_attempts[i];er<-z$errors[i];if(kind=='brier')(er*(1-p)^2+(n-er)*p^2)/n else logloss(er,n,p)},0.0) else numeric()
  out[paste(model,kind,sep='_')]<-if(nrow(z))mean(vapply(split(vals,z$match_id),mean,0.0)) else NA_real_
  out[paste(model,kind,'opportunity_weighted',sep='_')]<-if(nrow(z))sum(vals*z$usable_attempts)/sum(z$usable_attempts) else NA_real_
 }
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')){v<-out[paste0('personal_',kind,suffix)]-out[paste0('reference_',kind,suffix)];out[paste0('difference_',kind,suffix)]<-if(is.nan(v))NA_real_ else v};out}
for(i in seq_len(nrow(r[['paired-scores']]))){z<-r[['paired-scores']][i,];ref<-score(x[x$tour==z$tour,]);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent whole-match/opportunity loss',k))}
for(i in seq_len(nrow(r$stability))){z<-r$stability[i,];v<-x[x$eligible&!x$seed&x$tour==z$tour,];remove<-if(z$deletion_type=='MATCH')v$match_id==z$deleted_id else v$player_a==z$deleted_id|v$player_b==z$deleted_id
 ref<-score(v[!remove,]);base<-score(v);for(k in names(ref))check(same(z[[k]],unname(ref[k])),paste('Independent frozen-prediction deletion',k))
 check(z$deleted_evaluation_matches==length(unique(v$match_id[remove]))&&z$deleted_paired_cells==sum(v$paired_mask[remove]),'Both-slot player deletion accounting')
 check(same(z$change_brier_difference,unname(ref['difference_brier']-base['difference_brier'])),'Deletion change')
}
for(tour in c('ATP','WTA')){v<-x[x$eligible&!x$seed&x$tour==tour,];z<-r$stability[r$stability$tour==tour,];check(setequal(z$deleted_id[z$deletion_type=='MATCH'],v$match_id)&&setequal(z$deleted_id[z$deletion_type=='PLAYER'],c(v$player_a,v$player_b)),'Every evaluation match/both-slot identity enumerated, including zero-impact')}
# Fail closed on modified ownership or denominator authority.
bad<-input;bad$states$actor_name[which(bad$states$post_kind=='SERVE')[1]]<-'CONFLICT';check(fails(expanded_serve_counts(bad)),'Identity conflict stops')
bad<-input;bad$states$tennis_action_usable[which(bad$states$post_kind=='LET')[1]]<-TRUE;check(fails(expanded_serve_counts(bad)),'Let cannot become a physical attempt')
set.seed(17);q<-input;q$states<-q$states[sample(nrow(q$states)),];q$actions<-q$actions[sample(nrow(q$actions)),];q$eligibility<-q$eligibility[sample(nrow(q$eligibility)),]
rr<-run_mcp_expanded_serve_transfer(q);for(k in names(r))check(same(r[[k]],rr[[k]]),paste('Row/event/within-batch permutation',k))
# coverage rows are sorted to source order by installer-independent identity.
j<-match(r[['coverage-summary']]$match_id,rr[['coverage-summary']]$match_id);check(same(r[['coverage-summary']],rr[['coverage-summary']][j,]),'Coverage permutation by identity')
rr<-run_mcp_expanded_serve_transfer();for(k in names(r)){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(rr[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte rerun',k));unlink(c(f,g))}
expanded_serve_install(r);paths<-paste0(expanded_serve_prefix,expanded_serve_outputs,'.csv');pins<-setNames(vapply(paths,mcp_sha,''),paths)
check(length(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE))==6,'Six ignored outputs in existing location')
bad<-r;bad$summary$paired_cells[1]<-bad$summary$paired_cells[1]+1;check(fails(expanded_serve_install(bad))&&identical(pins,setNames(vapply(paths,mcp_sha,''),paths)),'Atomic preflight refuses changed release without altering files')
check(fails(expanded_serve_install(r[rev(names(r))])),'Incorrect output scope stops');check(!length(list.files('data/pilot',pattern='^\\.expanded-serve-',all.files=TRUE)),'Atomic staging cleanup')
check(identical(oldpins,setNames(vapply(old,mcp_sha,''),old)),'Historical artifacts unchanged')

backup<-expanded_serve_pins;expanded_serve_pins[1]<-paste(rep('0',64),collapse='');check(fails(expanded_serve_verify()),'Input pin failure stops before processing');expanded_serve_pins<-backup
backup<-expanded_serve_definition_pin;expanded_serve_definition_pin<-paste(rep('0',64),collapse='');check(fails(expanded_serve_verify()),'Prospective definition pin failure stops');expanded_serve_definition_pin<-backup
check(identical(as.integer(table(x$tour[x$paired_mask])),c(120L,135L)),'Serve-specific support with positive target denominators')
check(!any(x$disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS')&&sum(x$disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS')==181,'Measured denominator/cold-start accounting')
h<-input$support[input$support$domain=='Serve'&input$support$context=='FIRST',];check(identical(x$paired_mask,h$supported[match(key(x),key(h))]),'Exact Serve support IDs independently match frozen audit')
bad<-input;bad$opportunities$usable_attempts[which(bad$opportunities$domain=='Serve'&bad$opportunities$context=='FIRST')[1]]<-0;check(fails(expanded_serve_support(bad,c)),'Opportunity authority conflict stops before scoring')
bad<-input;bad$support$supported[which(bad$support$domain=='Serve'&bad$support$context=='FIRST')[1]]<-!bad$support$supported[which(bad$support$domain=='Serve'&bad$support$context=='FIRST')[1]];check(fails(expanded_serve_support(bad,c)),'Support conflict stops before scoring')
# Zero target N abstains even with valid prior exposure; zero reference branch is retained.
z<-x[x$paired_mask,][1,];q<-c;i<-match(key(z),key(q));q$usable_attempts[i]<-0;q$errors[i]<-0;alt<-serve_estimates(q);i<-match(key(z),key(alt));check(alt$disposition[i]=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'&&!alt$paired_mask[i]&&is.na(alt$personal_brier[i]),'History support cannot substitute for target N')
# Neutral relabeling preserves physical measurements and both-slot deletions.
q<-input;q$eligibility$player_a<-input$eligibility$player_b;q$eligibility$player_b<-input$eligibility$player_a
for(k in c('states','actions'))q[[k]]$actor_neutral_slot<-ifelse(q[[k]]$actor_neutral_slot=='A','B',ifelse(q[[k]]$actor_neutral_slot=='B','A',q[[k]]$actor_neutral_slot))
a<-expanded_serve_counts(q);b<-c;b$slot<-ifelse(b$slot=='A','B','A');j<-match(key(b),key(a));for(f in c('player','observed_attempts','usable_attempts','errors'))check(identical(b[[f]],a[[f]][j]),'Slot-swap ownership/denominator symmetry')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(old)))
