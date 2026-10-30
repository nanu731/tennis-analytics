source('R/run_mcp_serve_terminal_balance_transfer.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,scale=1,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/run_mcp_serve_terminal_balance_transfer.R','R/test_mcp_serve_terminal_balance_transfer.R','docs/mcp-serve-terminal-balance-transfer-results.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
old<-setdiff(old,allowed);old<-old[!startsWith(old,balance_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
# Estimand fixtures precede empirical scoring; balance MSE is not point MSE.
f<-data.frame(tour='ATP',source_date='2000-01-01',match_id='a',slot='A',N=2,ACE=1,DOUBLE_FAULT=1,OTHER=0,balance=0,paired_mask=TRUE,personal_p_ACE=.5,personal_p_DOUBLE_FAULT=.5,reference_p_ACE=1,reference_p_DOUBLE_FAULT=0)
z<-balance_targets(f)
check(z$personal_balance_squared_error==0&&z$reference_balance_squared_error==1,'Match-average balance squared error')
check(z$personal_balance_squared_error!=mean((0-c(1,-1))^2),'Point Z variance is not substituted into slot-average loss')
f$N<-0;f$ACE<-0;f$DOUBLE_FAULT<-0;f$balance<-NA_real_;f$paired_mask<-FALSE;z<-balance_targets(f)
check(is.na(z$personal_balance_squared_error)&&is.na(balance_score(z)$difference_squared_error),'Zero target denominator undefined and unscored')
f<-data.frame(match_id=c('a','a','b'),N=c(2,8,10),paired_mask=TRUE,personal_balance_squared_error=c(0,1,4),reference_balance_squared_error=c(1,1,1))
z<-balance_score(f);check(z$personal_squared_error==2.25&&z$reference_squared_error==1&&z$difference_squared_error==1.25,'Slot-then-match equal averaging')
check(z$personal_squared_error_opportunity_weighted==2.4&&z$difference_squared_error_opportunity_weighted==1.4,'Secondary N-weighted slot error, not point error')
check(balance_score(f[FALSE,])$comparison_status=='UNEVALUABLE_NO_SUPPORTED_TARGETS','Explicit empty comparison')
f$personal_balance_squared_error[1]<-Inf;z<-balance_score(f);check(z$comparison_status=='UNEVALUABLE_NONFINITE_LOSS'&&is.na(z$difference_squared_error),'Nonfinite supported result not dropped')
f$personal_balance_squared_error[1]<-0;f$N[1]<-0;check(balance_score(f)$comparison_status=='UNEVALUABLE_INVALID_DENOMINATOR','Invalid denominator not silently omitted')
check(balance_direction(0)=='TIE'&&balance_direction(NA_real_)=='UNEVALUABLE'&&balance_direction(-1)=='PERSONAL_LOWER','Tie/unevaluable direction handling')
i<-balance_load();balance_check(i);cat('PASS: prospective fixtures and frozen input/mask reconciliation before scoring.\n')
r<-run_mcp_serve_terminal_balance(i);x<-r[['target-estimates']];frozen<-i[['target-estimates']]
check(nrow(x)==446&&sum(x$paired_mask)==255&&!anyDuplicated(balance_key(x))&&nrow(r[['coverage-summary']])==223,'Exact all-inventory and supported accounting')
j<-match(balance_key(x),balance_key(frozen))
for(f in setdiff(names(frozen),c('release','claim','specification_sha256')))check(identical(x[[f]],frozen[[f]][j]),paste('Unchanged frozen field',f))
for(k in seq_len(nrow(x))){z<-x[k,];n<-z$N
 check(same(z$balance,if(n>0)(z$ACE-z$DOUBLE_FAULT)/n else NA_real_),'Observed pooled point Z average')
 for(model in c('personal','reference')){
  pred<-z[[paste0(model,'_p_ACE')]]-z[[paste0(model,'_p_DOUBLE_FAULT')]]
  loss<-if(z$paired_mask)(pred-z$balance)^2 else NA_real_
  check(same(z[[paste0(model,'_balance_squared_error')]],loss),'Independent squared slot-average error')
 }
}
check(all(is.na(x$personal_balance_squared_error[!x$paired_mask]))&&all(is.na(x$reference_balance_squared_error[!x$paired_mask])),'Cold starts/exclusions/unknowns retain abstention')
# Independent keyed point reconstruction verifies classification and denominator reuse.
p<-i[['point-dispositions']]
for(k in seq_len(nrow(x))){z<-x[k,];u<-p[p$included&p$match_id==z$match_id&p$slot==z$slot,];values<-c(ACE=1,DOUBLE_FAULT=-1,OTHER=0)[u$point_class]
 check(z$N==length(values)&&same(z$balance,if(length(values))mean(values) else NA_real_),'Independent point-value average, no point loss')
}
# Independent aggregation from predictions/target counts, not stored new losses.
score<-function(v){v<-v[v$paired_mask,];out<-c(paired_slots=nrow(v),scored_matches=length(unique(v$match_id)),target_points=sum(v$N))
 for(model in c('personal','reference')) {
  b<-(v$ACE-v$DOUBLE_FAULT)/v$N;h<-v[[paste0(model,'_p_ACE')]]-v[[paste0(model,'_p_DOUBLE_FAULT')]];loss<-(h-b)^2
  out[paste0(model,'_squared_error')]<-if(nrow(v))mean(tapply(loss,v$match_id,mean)) else NA_real_
  out[paste0(model,'_squared_error_opportunity_weighted')]<-if(nrow(v))sum(loss*v$N)/sum(v$N) else NA_real_
 }
 for(suffix in c('','_opportunity_weighted'))out[paste0('difference_squared_error',suffix)]<-out[paste0('personal_squared_error',suffix)]-out[paste0('reference_squared_error',suffix)];out}
for(k in seq_len(nrow(r[['paired-scores']]))){z<-r[['paired-scores']][k,];ref<-score(x[x$tour==z$tour,]);for(f in names(ref))check(same(z[[f]],unname(ref[f])),paste('Independent category score',f))}
for(k in seq_len(nrow(r$stability))){z<-r$stability[k,];v<-x[x$tour==z$tour&x$eligible&!x$seed,];remove<-if(z$deletion_type=='MATCH')v$match_id==z$deleted_id else v$player_a==z$deleted_id|v$player_b==z$deleted_id;ref<-score(v[!remove,]);base<-score(v)
 for(f in names(ref))check(same(z[[f]],unname(ref[f])),paste('Every frozen prediction deletion',f))
 check(z$deleted_evaluation_matches==length(unique(v$match_id[remove]))&&z$deleted_paired_slots==sum(v$paired_mask[remove]),'Both-slot deletion removes complete matches')
 for(suffix in c('','_opportunity_weighted'))check(same(z[[paste0('change',suffix)]],unname(ref[paste0('difference_squared_error',suffix)]-base[paste0('difference_squared_error',suffix)])),'Deletion signed change')
}
for(t in c('ATP','WTA')){v<-x[x$tour==t&x$eligible&!x$seed,];z<-r$stability[r$stability$tour==t,];oldz<-i$stability[i$stability$tour==t,]
 check(setequal(z$deleted_id[z$deletion_type=='MATCH'],v$match_id)&&setequal(z$deleted_id[z$deletion_type=='PLAYER'],c(v$player_a,v$player_b)),'All evaluation identities, including zero-impact')
 check(setequal(paste(z$deletion_type,z$deleted_id),paste(oldz$deletion_type,oldz$deleted_id)),'Identical inherited deletion inventory')
}
# Entire match deletion, not one-server loss; empty deletion remains unevaluable.
z<-x[x$paired_mask,][1,];z$eligible<-TRUE;z$seed<-FALSE;z$player_a<-'ONE';z$player_b<-'TWO';z$tour<-'ATP';zz<-z;zz$tour<-'WTA';out<-balance_stability(rbind(z,zz))
check(all(out$comparison_status=='UNEVALUABLE_NO_SUPPORTED_TARGETS'&out$direction_status=='UNEVALUABLE'&is.na(out$change)),'Unevaluable all-supported-match deletion disclosed')
# Frozen predictions must not be changed through target counts, source dates or masks.
for(f in c('paired_mask','N','source_date','personal_p_ACE','prior_N')){bad<-i;k<-which(bad[['target-estimates']]$paired_mask)[1]
 if(f=='paired_mask')bad[['target-estimates']][[f]][k]<-FALSE else if(f=='source_date')bad[['target-estimates']][[f]][k]<-'1999-01-01' else bad[['target-estimates']][[f]][k]<-bad[['target-estimates']][[f]][k]+.01
 check(fails(balance_check(bad)),paste('Changed frozen input fails closed',f))
}
# Neutral relabeling preserves server observations and numerical loss.
z<-frozen;z$slot<-ifelse(z$slot=='A','B','A');z$player_a<-frozen$player_b;z$player_b<-frozen$player_a;zz<-balance_targets(z);j<-match(paste(x$match_id,x$player),paste(zz$match_id,zz$player))
check(same(x[,c('personal_balance_squared_error','reference_balance_squared_error')],zz[j,c('personal_balance_squared_error','reference_balance_squared_error')]),'Neutral slot-swap loss invariance')
# Row/match/batch permutations leave frozen scores and outputs unchanged.
set.seed(72);q<-i;for(f in names(q))q[[f]]<-q[[f]][sample(nrow(q[[f]])),];rr<-run_mcp_serve_terminal_balance(q)
for(f in names(r))check(same(r[[f]],rr[[f]]),paste('Row/match/within-batch permutation',f))
rr<-run_mcp_serve_terminal_balance();for(f in names(r)){a<-tempfile();b<-tempfile();mcp_write(r[[f]],a);mcp_write(rr[[f]],b);check(mcp_sha(a)==mcp_sha(b),paste('Independent byte rerun',f));unlink(c(a,b))}
balance_install(r);paths<-paste0(balance_prefix,balance_outputs,'.csv');pins<-setNames(vapply(paths,mcp_sha,''),paths)
check(length(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE))==5,'Five ignored files in existing flat location')
bad<-r;bad$summary$paired_slots[1]<-bad$summary$paired_slots[1]+1;check(fails(balance_install(bad))&&identical(pins,setNames(vapply(paths,mcp_sha,''),paths)),'Atomic preflight preserves installed release')
check(fails(balance_install(r[rev(names(r))])),'Exact generated scope');check(!length(list.files('data/pilot',pattern='^\\.serve-balance-',all.files=TRUE)),'Staging cleanup')
backup<-balance_definition_pin;balance_definition_pin<-strrep('0',64);check(fails(balance_verify()),'Prospective specification pin failure stops');balance_definition_pin<-backup
backup<-balance_pins;balance_pins[1]<-strrep('0',64);check(fails(balance_verify()),'Frozen input pin failure stops');balance_pins<-backup
check(identical(oldpins,setNames(vapply(old,mcp_sha,''),old)),'Historical releases preserved byte-for-byte')
changed<-unique(c(system2('git',c('diff','--name-only','HEAD'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)))
check(all(changed%in%allowed),'Authorized six-file tracked scope')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged; %d frozen slots scored.\n',checks,length(old),sum(x$paired_mask)))
print(r[['paired-scores']][,1:10],row.names=FALSE)
for(t in c('ATP','WTA')){z<-r$stability[r$stability$tour==t,];cat(t,'deletions',nrow(z),'primary reversals',sum(z$direction_status=='REVERSED'),'weighted reversals',sum(z$direction_status_opportunity_weighted=='REVERSED'),'primary range',range(z$difference_squared_error),'\n');print(z[order(abs(z$change),decreasing=TRUE)[1:3],c('deletion_type','deleted_id','difference_squared_error','deleted_paired_slots')],row.names=FALSE)}
