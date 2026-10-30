source('R/run_mcp_direct_serve_transfer.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/run_mcp_direct_serve_transfer.R','R/test_mcp_direct_serve_transfer.R','docs/mcp-direct-serve-transfer-results.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
old<-setdiff(old,allowed);old<-old[!startsWith(old,direct_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
# Prospectively specified arithmetic fixtures pass before empirical comparative scoring.
check(same(direct_prob(c(2,1,7)),c(.2,.1,.7))&&all(is.na(direct_prob(c(0,0,0)))),'Unsmoothed pools and undefined cold starts')
check(direct_loss(c(1,0,0),c(0,1,0),'brier')==2&&direct_loss(c(1,0,0),c(1,0,0),'brier')==0,'Multiclass sum normalization, range endpoints')
check(same(direct_loss(c(1,1,1),rep(1/3,3),'brier'),2/3),'No division by class count')
check(direct_loss(c(0,0,1),c(0,0,1),'log_loss')==0&&is.infinite(direct_loss(c(1,0,0),c(0,0,1),'log_loss')),'Zero-count 0log0 and explicit contradiction')
check(fails(direct_loss(c(1,0,0),c(.1,.1,.1),'brier'))&&fails(direct_loss(c(1,-1,2),c(.1,.1,.8),'log_loss')),'Invalid probabilities/counts fail closed')
i<-direct_load();p<-direct_points(i);c<-direct_counts(p,i$eligibility);pre<-direct_estimates(c,FALSE)
check(nrow(p)==43310&&!anyDuplicated(p$point_id)&&nrow(c)==446&&!anyDuplicated(paste(c$match_id,c$slot)),'Complete unique point and slot inventory')
# Independent point-level terminal counting uses parser records linked to frozen states.
a<-i$actions;s<-i$states;raw<-i$points;e<-i$eligibility
pk<-paste(raw$match_id,raw$Pt,sep='|');j<-match(p$point_id,pk);mi<-match(p$match_id,e$match_id)
valid<-raw$tennis_sequence_validated[j]&raw$terminal_agrees[j]&raw$score_status[j]=='PASS'
check(identical(p$qa_validated,valid)&&identical(p$included,valid&e$eligible[mi]),'Independent point sequence/score/completion gate')
check(all(p$point_class[!valid]=='UNRESOLVED')&&all(!p$included[!p$eligible]),'Unresolved observations never become OTHER; excluded never contribute')
check(all(p$point_class[valid&!raw$terminal[j]%in%c('ACE','DOUBLE_FAULT')]=='OTHER'),'OTHER only fully validated distinct terminals')
check(all(p$point_class[valid&raw$terminal[j]=='UNRETURNABLE']=='OTHER')&&all(p$point_class[valid&raw$terminal[j]=='INCORRECT_CHALLENGE']=='OTHER'),'Collapsed unreturnables/admin challenges not ACE')
for(cl in c('ACE','DOUBLE_FAULT')) {
 ai<-which(a$terminal==cl&!a$is_void);sj<-match(a$action_id[ai],s$action_id)
 keep<-s$tennis_action_usable[sj];ap<-paste(a$match_id[ai],a$Pt[ai],sep='|');ids<-ap[keep]
 check(!anyDuplicated(ids)&&setequal(ids,p$point_id[p$qa_validated&p$point_class==cl]),paste('Independent unique direct terminal',cl))
 check(all(a$domain[ai[keep]]=='Serve'&a$actor[ai[keep]]==a$server[ai[keep]]),paste('Server-exclusive terminal ownership',cl))
}
for(k in seq_len(nrow(c))){z<-c[k,];b<-p[p$match_id==z$match_id&p$slot==z$slot,];use<-b[b$included,]
 check(z$inventory_points==nrow(b)&&z$N==nrow(use)&&all(as.numeric(z[,direct_classes])==vapply(direct_classes,function(cl)sum(use$point_class==cl),0L)), 'Independent unique denominator and three-class sums')
 check(same(z$balance,if(nrow(use))(sum(use$point_class=='ACE')-sum(use$point_class=='DOUBLE_FAULT'))/nrow(use) else NA_real_),'Descriptive balance; empty stays undefined')
}
check(all(c$N+c$withheld_points+c$completion_excluded_points==c$inventory_points)&&sum(c$inventory_points)==43310,'All unknown/excluded dispositions retained')
check(all(is.na(pre$personal_p_ACE[!pre$eligible|pre$prior_N==0])),'Excluded and zero-history probabilities undefined')
cat('Pre-scoring specification, classification and denominator checks passed.\n')
r<-run_mcp_direct_serve_transfer(i);x<-r[['target-estimates']]
check(identical(pre$paired_mask,x$paired_mask),'Pre-score and scored masks identical')
probcols<-c(paste0('personal_p_',direct_classes),paste0('reference_p_',direct_classes))
for(k in seq_len(nrow(x))){z<-x[k,];prior<-c[c$eligible&c$tour==z$tour&c$source_date<z$source_date,];own<-prior[prior$player==z$player,]
 pc<-colSums(own[,direct_classes]);rc<-colSums(prior[,direct_classes]);n<-sum(pc);rn<-sum(rc)
 check(all(as.numeric(z[,paste0('prior_',direct_classes)])==pc)&&all(as.numeric(z[,paste0('reference_',direct_classes)])==rc)&&z$prior_N==n&&z$reference_N==rn,'Independent strictly earlier personal/reference pools')
 check(z$prior_matches==nrow(own)&&z$prior_usable_matches==sum(own$N>0),'History depth retains zero observations')
 reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(z$seed)'SEED_NOT_EVALUATED' else if(!z$N)'NO_VALIDATED_TARGET_POINTS' else if(!n)'NO_PRIOR_PLAYER_POINTS' else if(!rn)'NO_PRIOR_REFERENCE_POINTS' else 'PAIRED_SUPPORTED'
 check(z$disposition==reason&&z$paired_mask==(reason=='PAIRED_SUPPORTED'),'Abstention precedence and positive-denominator mask')
 if(z$paired_mask)for(model in c('personal','reference')){
  q<-as.numeric(z[,paste0(model,'_p_',direct_classes)]);cc<-as.numeric(z[,direct_classes]);expected<-if(model=='personal')pc/n else rc/rn
  check(same(q,expected)&&same(sum(q),1),'Personal/reference probabilities on identical IDs')
  labels<-rep(seq_len(3),cc);pointloss<-vapply(labels,function(cl)sum((q-as.numeric(seq_len(3)==cl))^2),0.0)
  check(same(z[[paste0(model,'_brier')]],mean(pointloss)),'Independent point-indicator Brier')
  check(same(z[[paste0(model,'_log_loss')]],mean(-log(q[labels]))),'Independent point log loss and infinities')
  check(same(z[[paste0(model,'_expected_balance')]],q[1]-q[2]),'Expected balance is descriptive only')
 } else check(all(is.na(z[,c('personal_brier','reference_brier','personal_log_loss','reference_log_loss')])),'Abstentions not silently scored')
}
# Perturb class outcomes in current and later simultaneous batches: forecasts fixed.
z<-x[x$paired_mask,][1,];forecast<-c(probcols,'prior_N','reference_N');key<-function(v)paste(v$match_id,v$slot,sep='|')
q<-c;mask<-q$tour==z$tour&q$source_date>=z$source_date;q[mask,direct_classes]<-q[mask,rev(direct_classes)];alt<-direct_estimates(q,FALSE)
mask<-x$tour==z$tour&x$source_date<=z$source_date;check(same(x[mask,forecast],alt[mask,forecast]),'Current/later class counts cannot alter current forecasts')
q<-c;j<-which(q$eligible&q$tour==z$tour&q$player==z$player&q$source_date<z$source_date&q$OTHER>0)[1];q$OTHER[j]<-q$OTHER[j]-1;q$ACE[j]<-q$ACE[j]+1;alt<-direct_estimates(q,FALSE);k<-match(key(z),key(x))
check(same(alt$personal_p_ACE[k]-x$personal_p_ACE[k],1/z$prior_N),'Earlier-count positive control')
q<-c;mask<-q$tour=='ATP';q[mask,direct_classes]<-q[mask,rev(direct_classes)];alt<-direct_estimates(q,FALSE);check(same(x[x$tour=='WTA',forecast],alt[alt$tour=='WTA',forecast]),'Category separation')
q<-c;k<-which(q$eligible&!q$seed&q$N>0)[1];q[k,direct_classes]<-0;q$N[k]<-0;alt<-direct_estimates(q,FALSE);check(alt$disposition[k]=='NO_VALIDATED_TARGET_POINTS'&&!alt$paired_mask[k],'Prior support cannot supply target denominator')
q<-c;q$N[1]<-q$N[1]+1;check(fails(direct_estimates(q)),'Invalid class partition stops')
q<-c;q$source_date[1]<-'INVALID';check(fails(direct_estimates(q)),'Invalid chronology label stops')
# Independently aggregate point-constructed losses on the shared mask.
score<-function(v){v<-v[v$paired_mask,];out<-c(paired_slots=nrow(v),scored_matches=length(unique(v$match_id)),target_points=sum(v$N))
 for(model in c('personal','reference'))for(kind in c('brier','log_loss')){loss<-vapply(seq_len(nrow(v)),function(k){z<-v[k,];q<-as.numeric(z[,paste0(model,'_p_',direct_classes)]);labels<-rep(seq_len(3),as.numeric(z[,direct_classes]));if(kind=='brier')mean(vapply(labels,function(cl)sum((q-as.numeric(seq_len(3)==cl))^2),0.0)) else mean(-log(q[labels]))},0.0)
 out[paste(model,kind,sep='_')]<-if(nrow(v))mean(tapply(loss,v$match_id,mean)) else NA_real_;out[paste(model,kind,'opportunity_weighted',sep='_')]<-if(nrow(v))sum(loss*v$N)/sum(v$N) else NA_real_}
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')){d<-out[paste0('personal_',kind,suffix)]-out[paste0('reference_',kind,suffix)];out[paste0('difference_',kind,suffix)]<-if(is.nan(d))NA_real_ else d};out}
for(k in seq_len(nrow(r[['paired-scores']]))){z<-r[['paired-scores']][k,];ref<-score(x[x$tour==z$tour,]);for(f in names(ref))check(same(z[[f]],unname(ref[f])),paste('Independent aggregation',f))}
for(k in seq_len(nrow(r$stability))){z<-r$stability[k,];v<-x[x$eligible&!x$seed&x$tour==z$tour,];remove<-if(z$deletion_type=='MATCH')v$match_id==z$deleted_id else v$player_a==z$deleted_id|v$player_b==z$deleted_id;ref<-score(v[!remove,]);base<-score(v)
 for(f in names(ref))check(same(z[[f]],unname(ref[f])),paste('Every frozen prediction deletion',f))
 check(z$deleted_evaluation_matches==length(unique(v$match_id[remove]))&&z$deleted_paired_slots==sum(v$paired_mask[remove]),'Both-slot deletion removes complete matches')
 check(same(z$change_brier_difference,unname(ref['difference_brier']-base['difference_brier'])),'Deletion difference arithmetic')
}
for(tour in c('ATP','WTA')){v<-x[x$eligible&!x$seed&x$tour==tour,];z<-r$stability[r$stability$tour==tour,];check(setequal(z$deleted_id[z$deletion_type=='MATCH'],v$match_id)&&setequal(z$deleted_id[z$deletion_type=='PLAYER'],c(v$player_a,v$player_b)),'Complete zero-impact and both-slot deletion inventory')}
fake<-x[x$paired_mask,][1,];fake$personal_log_loss<-Inf;fake$reference_log_loss<-Inf;check(is.na(direct_score(fake)$difference_log_loss),'Inf minus Inf stays indeterminate')
check(is.na(direct_score(x[FALSE,])$difference_brier),'Empty comparison explicitly undefined')
# Frozen ownership and terminal authority conflicts stop, not guessed repairs.
bad<-i;bad$points$terminal_agrees[which(bad$points$tennis_sequence_validated)[1]]<-FALSE;check(fails(direct_points(bad)),'Recorded winner conflict stops')
bad<-i;bad$states$post_terminal_status[which(bad$states$post_terminal_status=='ACE')[1]]<-'UNRETURNABLE';check(fails(direct_points(bad)),'Parser/state terminal conflict stops')
bad<-i;bad$points<-rbind(bad$points,bad$points[1,]);check(fails(direct_points(bad)),'Duplicate point denominator stops')
# Neutral relabeling changes no physical ownership or scores.
q<-i;q$eligibility$player_a<-i$eligibility$player_b;q$eligibility$player_b<-i$eligibility$player_a
for(f in c('states','actions'))q[[f]]$actor_neutral_slot<-ifelse(q[[f]]$actor_neutral_slot=='A','B',ifelse(q[[f]]$actor_neutral_slot=='B','A',q[[f]]$actor_neutral_slot))
pp<-direct_points(q);cc<-direct_counts(pp,q$eligibility);b<-c;b$slot<-ifelse(b$slot=='A','B','A');j<-match(key(b),key(cc));for(f in c('player','N',direct_classes,'balance'))check(same(b[[f]],cc[[f]][j]),'Neutral slot ownership invariance')
set.seed(31);q<-i;for(f in c('points','states','actions','eligibility','plus'))q[[f]]<-q[[f]][sample(nrow(q[[f]])),]
rr<-run_mcp_direct_serve_transfer(q);for(f in names(r))check(same(r[[f]],rr[[f]]),paste('Row/event/within-batch permutation',f))
rr<-run_mcp_direct_serve_transfer();for(f in names(r)){a<-tempfile();b<-tempfile();mcp_write(r[[f]],a);mcp_write(rr[[f]],b);check(mcp_sha(a)==mcp_sha(b),paste('Independent byte rerun',f));unlink(c(a,b))}
direct_install(r);paths<-paste0(direct_prefix,direct_outputs,'.csv');pins<-setNames(vapply(paths,mcp_sha,''),paths)
check(length(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE))==7,'Seven outputs remain ignored in existing flat location')
bad<-r;bad$summary$paired_slots[1]<-bad$summary$paired_slots[1]+1;check(fails(direct_install(bad))&&identical(pins,setNames(vapply(paths,mcp_sha,''),paths)),'Atomic preflight refuses differing release without overwrite')
check(fails(direct_install(r[rev(names(r))])),'Exact output scope enforced');check(!length(list.files('data/pilot',pattern='^\\.direct-serve-',all.files=TRUE)),'Staging cleanup')
backup<-direct_definition_pin;direct_definition_pin<-strrep('0',64);check(fails(direct_verify()),'Specification pin failure stops');direct_definition_pin<-backup
backup<-direct_decision_pin;direct_decision_pin<-strrep('0',64);check(fails(direct_verify()),'Decision pin failure stops');direct_decision_pin<-backup
backup<-plus_protocol_pins;plus_protocol_pins[1]<-strrep('0',64);check(fails(direct_verify()),'Input/source chain pin failure stops');plus_protocol_pins<-backup
check(identical(oldpins,setNames(vapply(old,mcp_sha,''),old)),'Historical artifacts byte-for-byte preserved')
# Final scope accepts only this task's tracked/untracked deliverables.
changed<-unique(c(system2('git',c('diff','--name-only','HEAD'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)))
check(all(changed%in%allowed),'Exact six-file tracked scope')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged; %d slots scored.\n',checks,length(old),sum(x$paired_mask)))
