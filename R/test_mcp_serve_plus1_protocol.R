source('R/build_mcp_serve_plus1_protocol.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/build_mcp_serve_plus1_protocol.R','R/test_mcp_serve_plus1_protocol.R','docs/mcp-serve-plus1-transfer-protocol.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)));old<-setdiff(old,allowed);old<-old[!startsWith(old,plus_protocol_prefix)];pins<-setNames(vapply(old,mcp_sha,''),old)
input<-plus_protocol_load();r<-build_mcp_plus1_protocol_support(input);b<-r[['point-opportunity-dispositions']];c<-r[['context-counts']];h<-r[['context-support']];cv<-r[['match-coverage']];s<-input$states;e<-input$eligibility
key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
check(nrow(b)==43310&&!anyDuplicated(b$point_id)&&nrow(c)==1784&&nrow(h)==1784&&nrow(cv)==223,'All points/slots/context inventories retained')
check(setequal(b$point_id,input$plus$point_id)&&setequal(c$match_id,e$match_id)&&!anyDuplicated(key(c)),'Frozen identity accounting')
check(all(b$context[b$disposition=='KNOWN_ABSENT']=='NOT_APPLICABLE')&&!any(b$denominator_member[b$disposition%in%c('KNOWN_ABSENT','UNKNOWN_OPPORTUNITY','UNVALIDATED_OBSERVED_PREFIX')]),'Absences/unknowns/withheld prefixes are not trials')
check(!any(h$paired_support[!h$eligible|!h$context%in%c('FIRST','SECOND')|h$seed]),'Frozen exclusions, unknowns and seeds abstain')
check(!any(vapply(r,function(x)any(grepl('estimate|loss|brier|(^errors$)|error_rate|forecast',names(x))),FALSE)),'No prediction/error-frequency/loss output')
# Independent pre-action context and owned-action denominator reconstruction.
j<-match(input$plus$plus1_action_id,s$action_id);known<-input$plus$observed_prefix
pre<-s[j[known],];number<-ifelse(pre$pre_serve_number==1,'FIRST',ifelse(pre$pre_serve_number==2,'SECOND','UNKNOWN'));number[is.na(number)]<-'UNKNOWN'
bad<-pre$pre_boundary%in%c('UNKNOWN','TERMINAL')|pre$pre_next_domain!='Rally';bad[is.na(bad)]<-TRUE
role_unknown<-is.na(pre$pre_next_actor_role)|is.na(pre$pre_in_play_strokes)|!pre$pre_next_actor_role%in%c('SERVER','RECEIVER')
number[role_unknown]<-'UNKNOWN';number[bad|(!role_unknown&!(pre$pre_next_actor_role=='SERVER'&pre$pre_in_play_strokes==2))]<-'UNSUPPORTED'
expected<-rep('UNKNOWN',nrow(input$plus));expected[input$plus$disposition=='KNOWN_ABSENT']<-'NOT_APPLICABLE';expected[known]<-number
check(identical(b$context,expected[match(b$point_id,input$plus$point_id)]),'Independent pre-action FIRST/SECOND/unknown classification')
bi<-match(input$plus$point_id,b$point_id);check(all(b$raw_first[bi]==input$plus$raw_first)&all(b$raw_second[bi]==input$plus$raw_second),'Raw notation unchanged')
for(i in seq_len(nrow(c))){z<-c[i,];v<-b[b$match_id==z$match_id&b$slot==z$slot&b$context==z$context,]
 check(z$observed_attempts==sum(v$observed_prefix)&&z$usable_attempts==sum(v$denominator_member)&&z$withheld_attempts==sum(v$observed_prefix)-sum(v$denominator_member),'Independent context denominator/withholding')
 check(z$qa_usable_attempts==sum(v$usable_attempt)&&z$unknown_opportunities==sum(v$disposition=='UNKNOWN_OPPORTUNITY'),'Independent QA/unknown opportunity accounting')
 check(same(z$retention,if(z$observed_attempts)z$usable_attempts/z$observed_attempts else NA_real_)&&z$rate_status==if(z$usable_attempts)'NOT_CALCULATED_SUPPORT_ONLY' else 'UNDEFINED_ZERO_DENOMINATOR','Undefined zero denominators; no rate calculation')
}
for(i in seq_len(nrow(cv))){z<-cv[i,];v<-b[b$match_id==z$match_id,]
 check(z$points==sum(v$disposition=='KNOWN_ABSENT')+sum(v$disposition=='UNKNOWN_OPPORTUNITY')+sum(v$observed_prefix),'Independent point partition')
 check(z$known_absences==sum(v$disposition=='KNOWN_ABSENT')&&z$unvalidated_prefixes==sum(v$disposition=='UNVALIDATED_OBSERVED_PREFIX'),'Known absence and withheld observations remain separate')
}
for(i in seq_len(nrow(h))){z<-h[i,];prior<-c[c$tour==z$tour&c$context==z$context&c$source_date<z$source_date&c$match_id%in%e$match_id[e$eligible],];own<-prior[prior$player==z$player,]
 check(z$prior_attempts==sum(own$usable_attempts)&&z$reference_attempts==sum(prior$usable_attempts),'Independent strictly earlier personal/reference N')
 check(z$prior_matches==nrow(own)&&z$prior_usable_matches==sum(own$usable_attempts>0)&&z$prior_batches==length(unique(own$source_date[own$usable_attempts>0])),'Independent match/batch history depth')
 expected<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(!z$context%in%c('FIRST','SECOND'))'UNKNOWN_OR_UNSUPPORTED_CONTEXT' else if(z$seed)'SEED_NOT_EVALUATED' else if(!z$usable_attempts)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(!z$prior_attempts)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else if(!z$reference_attempts)'NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS' else 'PAIRED_SUPPORT_AVAILABLE'
 check(z$support_disposition==expected&&z$paired_support==(expected=='PAIRED_SUPPORT_AVAILABLE'),'Frozen failure precedence and identical future masks')
}
# Pre-action function accepts only registered fields; current/future observations cannot enter.
p<-s[which(s$tennis_action_usable&s$owner_domain=='Rally'&s$owner_role=='SERVER'&s$pre_in_play_strokes==2)[1],context_pre_fields,drop=FALSE]
check(fails(plus_protocol_context(cbind(p,current_error='FORCED_ERROR'))),'Post-action fields rejected by allowlist')
for(number in c(1L,2L,NA_integer_)){q<-p;q$pre_serve_number<-number;check(plus_protocol_context(q)==if(is.na(number))'UNKNOWN' else if(number==1)'FIRST' else 'SECOND','Recorded serve contexts')}
q<-p;q$pre_boundary<-'TERMINAL';check(plus_protocol_context(q)=='UNSUPPORTED','Terminal/unsupported pre-boundary withheld')
z<-action_sequence('4f3fe#','1st',1L,1L)$actions;last<-tail(z,1);check(last$domain=='Rally'&&last$in_play_shot==3&&last$terminal=='FORCED_ERROR'&&grepl('UNKNOWN_ERROR_TYPE',last$unknowns,fixed=TRUE),'Attempted +1 error with unknown subtype has known binary annotation')
z<-action_sequence('4f3fn@','1st',1L,1L)$actions;check(tail(z$in_play_shot,1)==3&&tail(z$terminal,1)=='UNFORCED_ERROR','Attempted error counts despite rallyCount convention')
# Hypothetical unobserved binary label cannot gain denominator credit; unknown subtype alone can.
q<-b;i<-which(q$denominator_member)[1];q$binary_label_observed[i]<-FALSE;q$denominator_member[i]<-FALSE;alt<-plus_protocol_counts(input,q);j<-match(key(b[i,]),key(c));check(alt$usable_attempts[j]==c$usable_attempts[j]-1&&alt$withheld_attempts[j]==c$withheld_attempts[j]+1&&alt$unknown_binary_labels[j]==c$unknown_binary_labels[j]+1,'Unknown binary label remains exposure, not a trial')
q<-b;q$unknown_error_subtype[i]<-TRUE;alt<-plus_protocol_counts(input,q);check(identical(alt$usable_attempts,c$usable_attempts),'Unknown subtype does not remove known binary-label trial')
# Context and support do not use terminal error type or target error frequencies.
q<-input;ix<-which(q$states$post_terminal_status=='FORCED_ERROR'&q$states$owner_domain=='Rally');q$states$post_terminal_status[ix]<-'UNFORCED_ERROR';ai<-match(q$states$action_id[ix],q$actions$action_id);q$actions$terminal[ai]<-'UNFORCED_ERROR';alt<-build_mcp_plus1_protocol_support(q);for(k in names(r))check(same(r[[k]],alt[[k]]),'Error subtype cannot choose contexts/eligibility/support')
cols<-c('prior_attempts','reference_attempts','prior_usable_matches','prior_batches')
for(tour in c('ATP','WTA')){dates<-sort(unique(e$source_date[e$tour_file==tour&e$eligible]));ties<-names(which(table(e$source_date[e$tour_file==tour&e$eligible])>1))
 for(cut in unique(c(dates[1],dates[ceiling(length(dates)/2)],tail(dates,1),head(ties,1)))){q<-c;mask<-q$tour==tour&q$source_date>=cut&q$context%in%c('FIRST','SECOND');q$observed_attempts[mask]<-q$observed_attempts[mask]+1;q$usable_attempts[mask]<-q$usable_attempts[mask]+1;a<-broader_support(q[,broader_count_fields,drop=FALSE],e);j<-match(key(h),key(a));ii<-h$tour==tour&h$source_date==cut
  check(same(h[ii,c('prior_attempts','reference_attempts','prior_usable_matches')],a[j[ii],c('prior_attempts','reference_attempts','prior_usable_matches')]),'Current/later/simultaneous exposure cannot enter prior pools')
 }
}
z<-h[h$paired_support,][1,];q<-c;i<-which(q$tour==z$tour&q$player==z$player&q$context==z$context&q$source_date<z$source_date&q$match_id%in%e$match_id[e$eligible]&q$usable_attempts>0)[1];q$observed_attempts[i]<-q$observed_attempts[i]+1;q$usable_attempts[i]<-q$usable_attempts[i]+1;a<-broader_support(q[,broader_count_fields,drop=FALSE],e);j<-match(key(z),key(a));check(a$prior_attempts[j]==z$prior_attempts+1&&a$reference_attempts[j]==z$reference_attempts+1,'Earlier eligible exposure positive control')
# Slot swap preserves exact source player measurements.
q<-input;q$eligibility$player_a<-e$player_b;q$eligibility$player_b<-e$player_a
for(k in c('states','actions'))q[[k]]$actor_neutral_slot<-ifelse(q[[k]]$actor_neutral_slot=='A','B',ifelse(q[[k]]$actor_neutral_slot=='B','A',q[[k]]$actor_neutral_slot))
pb<-plus_protocol_points(q);pc<-plus_protocol_counts(q,pb);ref<-c;ref$slot<-ifelse(ref$slot=='A','B','A');j<-match(key(ref),key(pc));for(f in c('player','observed_attempts','usable_attempts','withheld_attempts'))check(identical(ref[[f]],pc[[f]][j]),'Neutral slot-swap ownership symmetry')
q<-input;q$plus$server[1]<-3L-input$plus$server[1];check(fails(build_mcp_plus1_protocol_support(q)),'Server authority conflict stops')
q<-input;q$plus$point_id[1]<-q$plus$point_id[2];check(fails(build_mcp_plus1_protocol_support(q)),'Duplicate point stops')
backup<-plus_protocol_pins;plus_protocol_pins[1]<-paste(rep('0',64),collapse='');check(fails(plus_protocol_verify()),'Input hash conflict stops');plus_protocol_pins<-backup
backup<-plus_protocol_definition_pin;plus_protocol_definition_pin<-paste(rep('0',64),collapse='');check(fails(plus_protocol_verify()),'Prospective definition pin stops');plus_protocol_definition_pin<-backup
set.seed(29);q<-input;for(k in names(q))q[[k]]<-q[[k]][sample(nrow(q[[k]])),];alt<-build_mcp_plus1_protocol_support(q);for(k in names(r))check(same(r[[k]],alt[[k]]),paste('Row/event/within-batch permutation',k))
alt<-build_mcp_plus1_protocol_support();for(k in names(r)){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(alt[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte-identical rerun',k));unlink(c(f,g))}
plus_protocol_install(r);paths<-paste0(plus_protocol_prefix,plus_protocol_outputs,'.csv');installed<-setNames(vapply(paths,mcp_sha,''),paths)
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'All five outputs ignored')
bad<-r;bad$summary$supported_context_targets[1]<-bad$summary$supported_context_targets[1]+1;check(fails(plus_protocol_install(bad))&&identical(installed,setNames(vapply(paths,mcp_sha,''),paths)),'Atomic preflight refuses differing output without altering release')
check(fails(plus_protocol_install(r[rev(names(r))])),'Wrong output scope stops');check(!length(list.files('data/pilot',pattern='^\\.plus-protocol-',all.files=TRUE)),'Staging cleanup')
check(identical(pins,setNames(vapply(old,mcp_sha,''),old)),'Historical artifacts unchanged')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(old)))
