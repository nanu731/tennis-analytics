# Phase 2AK: focused frozen-data and synthetic component tests; no historical suite.
source('R/build_2025_features_elo.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern=''){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),paste('fail closed',pattern))}
eq<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
e<-ak_helpers();terminal<-ak_reconcile(e);i<-ak_read_inputs(e)
for(p in names(ak_pins))ok(ak_hash(p)==ak_pins[[p]],paste('pin',p))
p<-ak_pins;p[1]<-'changed';fail(ak_verify(p),'Missing/changed')
fail(e$se_ignored('R/not-ignored'),'already be ignored')
r<-ak_build(i,terminal,e);slots<-r[[1]];targets<-r[[2]];summary<-r[[5]]
ok(nrow(slots)==3756&&!anyDuplicated(paste(slots$match_key,slots$slot)),'3756 slots exactly once')
ok(nrow(targets)==1878&&!anyDuplicated(targets$match_key)&&setequal(targets$match_id,i$x$match_id),'1878 targets original IDs')
ok(sum(slots$history_matches)==146374,'all frozen contributions accounted for')
# Independent reconstruction: join each original player ID to raw winner/loser effective columns,
# then grouped sums (rowsum), without calling production component/count/pool functions.
dl<-i$dd;vl<-i$vd;dl$key<-paste('DEVELOPMENT',dl$match_id,sep='|');vl$key<-paste('VALIDATION_2024',vl$match_id,sep='|')
fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
keep<-c('key','membership','winner_id','loser_id',paste0('effective_w_',fields),paste0('effective_l_',fields))
tl<-i$td;tl$key<-paste('FINAL_TEST_2025',tl$match_id,sep='|');raw<-rbind(dl[,keep],vl[,keep],tl[,keep]);links<-i$h[i$h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
j<-match(links$prior_key,raw$key);z<-raw[j,];won<-links$player_id==z$winner_id
ok(!anyNA(j)&&all(z$membership=='INCLUDED')&&all(won|links$player_id==z$loser_id),'admitted player ownership independent join')
component_value<-function(field,own=TRUE){w<-as.numeric(z[[paste0('effective_w_',field)]]);l<-as.numeric(z[[paste0('effective_l_',field)]]);ifelse(if(own)won else !won,w,l)}
parts<-cbind(M03_num=component_value('1stWon'),M03_den=component_value('1stIn'),M05_num=component_value('df'),M05_den=component_value('svpt')-component_value('1stIn'),M11_num=component_value('bpFaced',FALSE),M11_den=component_value('SvGms',FALSE),M12_num=component_value('bpFaced',FALSE)-component_value('bpSaved',FALSE),M12_den=component_value('bpFaced',FALSE))
sums<-rowsum(parts,paste(links$target_key,links$target_slot,sep='::'),reorder=TRUE)
ix<-match(paste(slots$match_key,slots$slot,sep='::'),rownames(sums));expected<-sums[ix,,drop=FALSE]
for(field in colnames(expected))ok(eq(slots[[field]],expected[,field]),paste('every pooled count',field))
for(metric in e$s08_metrics){
 den<-expected[,paste0(metric,'_den')];num<-expected[,paste0(metric,'_num')];rate<-ifelse(!is.na(den)&den>0,num/den,NA_real_)
 reason<-ifelse(is.na(den),'EMPTY_HISTORY',ifelse(den==0,'ZERO_POOLED_DENOMINATOR','DEFINED'))
 ok(eq(slots[[paste0(metric,'_rate')]],rate),paste('every rate',metric));ok(identical(slots[[paste0(metric,'_reason')]],unname(reason)),paste('every reason',metric))
 a<-rate[match(paste(targets$match_key,'a',sep='::'),paste(slots$match_key,slots$slot,sep='::'))];b<-rate[match(paste(targets$match_key,'b',sep='::'),paste(slots$match_key,slots$slot,sep='::'))]
 ok(eq(targets[[paste0('d',metric)]],a-b),paste('every neutral difference',metric))
}
ok(all(links$prior_source_date<links$target_source_date),'strict cutoff for every contribution')
ok(all(slots$last_history_source_label[slots$history_matches>0]<slots$source_tourney_date[slots$history_matches>0]),'pooled history cutoff')
ok(all(is.na(as.matrix(slots[slots$history_matches==0,grep('_(num|den|rate)$',names(slots))]))),'empty counts and rates undefined')
ok(all(slots$M11_rate[slots$M11_rate>1&!is.na(slots$M11_rate)]>1),'M11 uncapped')
for(metric in c('M03','M05','M12'))ok(all(slots[[paste0(metric,'_rate')]]>=0&slots[[paste0(metric,'_rate')]]<=1,na.rm=TRUE),'bounded component rates')
ok(identical(targets$both_candidates_feature_complete,targets$all_s08_differences_defined),'shared full-vector eligibility')
ok(identical(targets$reduced_components_defined,complete.cases(targets[c('dM03','dM11','dM12')])),'reduced availability diagnostic only')
for(tour in c('ATP','WTA'))for(metric in e$s08_metrics)for(slot in c('ALL','a','b','difference')){
 z<-if(slot=='difference')targets[targets$tour==tour,] else slots[slots$tour==tour & (slot=='ALL'|slots$slot==slot),]
 value<-z[[if(slot=='difference')paste0('d',metric) else paste0(metric,'_rate')]]
 s<-summary[summary$record_type=='FEATURE'&summary$level=='tour'&summary$tour==tour&summary$metric==metric&summary$slot==slot,]
 ok(nrow(s)==1&&s$n==nrow(z)&&s$defined==sum(is.finite(value))&&s$undefined==sum(!is.finite(value)),paste('tour availability',tour,metric,slot))
}
# Defined zero, every zero denominator, empty histories and unequal-denominator pooling.
parts0<-as.data.frame(as.list(setNames(rep(0,8),colnames(parts))))
p<-e$s08_pool(parts0);ok(all(is.na(unlist(p[paste0(e$s08_metrics,'_rate')]))),'all zero denominators undefined')
ok(all(unlist(p[paste0(e$s08_metrics,'_reason')])=='ZERO_POOLED_DENOMINATOR'),'all zero denominator reasons')
p<-e$s08_pool(parts0[FALSE,]);ok(all(is.na(unlist(p[grep('_(num|den|rate)$',names(p))]))),'synthetic empty sums/rates undefined')
c1<-e$s08_components(c(df=2,svpt=20,`1stIn`=10,`1stWon`=8),c(bpFaced=8,bpSaved=3,SvGms=4))
c2<-e$s08_components(c(df=4,svpt=40,`1stIn`=30,`1stWon`=12),c(bpFaced=0,bpSaved=0,SvGms=6))
p<-e$s08_pool(as.data.frame(rbind(c1,c2)));ok(p$M03_rate==.5&&p$M03_rate!=mean(c(.8,.4)),'pool counts never average rates')
ok(p$M05_rate==.3&&p$M11_rate==.8&&p$M12_rate==5/8,'own/opponent formula fixture')
p<-e$s08_pool(as.data.frame(t(c1)));ok(p$M11_rate==2,'synthetic intensity above one uncapped')
# Exact frozen-ledger guards; missing, duplicate and altered cutoff contributions are rejected.
q<-i;q$h<-q$h[-1,];fail(ak_validate(q,e),'membership differs')
q<-i;q$h<-rbind(q$h,q$h[1,]);fail(ak_validate(q,e),'membership differs')
q<-i;q$h$prior_source_date[1]<-q$h$target_source_date[1];fail(ak_validate(q,e),'membership differs')
q<-i;q$x$player_a_id[1]<-'999999';fail(ak_validate(q,e),'targets differ')
# Input, event and within-batch permutations leave the full release unchanged.
q<-lapply(i,function(d)d[nrow(d):1,,drop=FALSE]);ok(identical(r,ak_build(q,terminal,e)),'full permutation invariance')
# Swap target slots after validation, retaining each prior contributor's original slot ownership.
checked<-ak_validate(i,e);counts<-ak_count_inputs(i,checked$h);xx<-checked$x;hh<-checked$h
xx[c('player_a_id','player_b_id')]<-xx[c('player_b_id','player_a_id')]
for(suffix in c('history_matches','development_matches','validation_matches','final_test_matches','empty_reason','empty_detail'))xx[paste0(c('a_','b_'),suffix)]<-xx[paste0(c('b_','a_'),suffix)]
hh$target_slot<-ifelse(hh$target_slot=='a','b','a');swap<-ak_features(xx,hh,counts,e)
for(metric in e$s08_metrics){ok(eq(r[[2]][[paste0('d',metric)]],-swap[[2]][[paste0('d',metric)]]),paste('swap difference',metric));ok(eq(r[[2]][[paste0('a_',metric)]],swap[[2]][[paste0('b_',metric)]]),paste('swap player rate',metric))}
# For a selected target batch, corrupt all same/later outcomes and effective counts after
# freezing membership. They must never reach that target's count parser; later targets may differ.
use<-checked$x$batch_key=='WTA|20250630';tx<-checked$x[use,];th<-checked$h[checked$h$target_key %in% tx$match_key,]
base<-ak_features(tx,th,ak_count_inputs(i,th),e)
q<-i;mut<-q$td$audit_tour=='WTA'&q$td$tourney_date>='20250630'
for(field in grep('^(winner_|loser_|w_|l_|effective_)|^score$',names(q$td),value=TRUE))q$td[[field]][mut]<-'PERTURBED'
ok(identical(base,ak_features(tx,th,ak_count_inputs(q,th),e)),'target and later outcomes/counts unused')
# Outcome-only swap of a contributing result with its count sides preserves player ownership.
c<-ak_count_inputs(i,th);q<-c;k<-1L;q$d$winner_id[k]<-c$d$loser_id[k];q$d$loser_id[k]<-c$d$winner_id[k]
q$d$a_original_side[k]<-q$m$a_original_side[k]<-if(c$m$a_original_side[k]=='winner')'loser' else 'winner'
for(field in fields){q$d[[paste0('effective_w_',field)]][k]<-c$d[[paste0('effective_l_',field)]][k];q$d[[paste0('effective_l_',field)]][k]<-c$d[[paste0('effective_w_',field)]][k]}
ok(identical(base,ak_features(tx,th,q,e)),'winner-label swap with player counts unchanged')
q<-c;field<-'effective_w_1stWon';q$d[[field]][1]<-as.character(as.numeric(q$d[[field]][1])-1)
ok(!identical(base[[2]],ak_features(tx,th,q,e)[[2]]),'earlier admitted count positive control')

# All frozen exclusions and exact context scope remain outside parsed contributions.
counts<-ak_count_inputs(i,checked$h)
for(cohort in c('DEVELOPMENT','VALIDATION_2024','FINAL_TEST_2025')) {
 d<-switch(cohort,DEVELOPMENT=i$dd,VALIDATION_2024=i$vd,FINAL_TEST_2025=i$td)
 excluded<-paste(cohort,d$match_id[d$membership!='INCLUDED'],sep='|')
 ok(!any(counts$m$match_id %in% excluded),'excluded counts never contribute')
}
pm<-i$td$audit_tour=='WTA'&i$td$event %in% c('Canada','Cincinnati')&i$td$tourney_level=='PM'&grepl('level_conflict',i$td$context_reasons)
fmt<-i$td$audit_tour=='ATP'&i$td$event=='Roland-Garros'&grepl('match_format_conflict',i$td$context_reasons)
ok(sum(pm)==190&&sum(fmt)==6,'all 196 blocked context rows accounted')
ok(!any(paste('FINAL_TEST_2025',i$td$match_id[pm|fmt],sep='|') %in% c(counts$m$match_id,targets$match_key)),'blocked contexts zero contributions or targets')
cc<-summary[summary$record_type=='CELL_INVENTORY',]
ok(nrow(cc)==20&&sum(cc$targets)==1878&&sum(cc$targets==0)==2,'all twenty cells reported')
ok(setequal(cc$group[cc$targets==0],c('WTA|2025|Canada','WTA|2025|Cincinnati')),'two WTA zero-target contexts')
for(k in 1:3)ok(!any(grepl('outcome|winner|loser|original_side',names(r[[k]]))),'features and probabilities omit outcomes')
# Terminal reconstruction includes untouched development states and detects corrupted chains.
ok(all(terminal$reconciliation$chain_residual==0&terminal$reconciliation$replay_residual==0),'AE exact replay and state reconciliation')
ok(identical(terminal$reconciliation$terminal_states,c(248L,552L,298L,695L)),'terminal overall/surface state cardinalities')
ok(identical(terminal$reconciliation$untouched_development_states,c(42L,107L,102L,251L)),'untouched development states preserved')
ul<-e$se_read('data/pilot/surface-elo-baseline/rating-update-ledger.csv');vl<-e$se_read('data/pilot/2024-surface-elo-baseline/rating-update-ledger.csv')
fields<-c('tour','source_tourney_date','batch_key','component','surface','player_id','before','prior_matches','batch_matches','accumulated_delta','after','after_matches')
combined<-rbind(ul[fields],vl[fields]);v<-combined;v$after[1]<-as.numeric(v$after[1])+1;fail(e$ae_terminal(v,e),'delta reconciliation')
v<-combined;v$prior_matches[1]<-1;fail(e$ae_terminal(v,e),'count reconciliation')
v<-rbind(combined,combined[1,]);fail(e$ae_terminal(v,e),'Duplicate')
v<-combined;v$before[1]<-as.numeric(v$before[1])+1;v$after[1]<-as.numeric(v$after[1])+1;fail(e$ae_terminal(v,e),'chain reconciliation')
# Frozen Phase 2P/2AE numerical tests against every new update.
inp<-ak_elo_input(checked$x,targets,i$tm,i$td,e);p<-r[[3]];u<-r[[4]];base_p<-e$ae_replay(inp$x,inp$y,terminal$states,e)
probcols<-c('p_a_primary','p_b_primary','p_a_overall','p_b_overall')
ok(all(is.finite(as.matrix(p[probcols])))&&all(as.matrix(p[probcols])>0&as.matrix(p[probcols])<1),'finite nonboundary probabilities')
ok(!any(grepl('outcome|winner|loser|original_side',names(p))),'no target outcomes exported')
ok(all(p$p_a_primary+p$p_b_primary==1)&all(p$p_a_overall+p$p_b_overall==1),'probability complements')
ok(eq(p$p_a_primary,1/(1+10^((.5*p$b_overall+.5*p$b_surface-.5*p$a_overall-.5*p$a_surface)/400))),'blend then logistic')
ok(eq(p$p_a_overall,1/(1+10^((p$b_overall-p$a_overall)/400))),'overall logistic')
avg<-(p$p_a_overall+1/(1+10^((p$b_surface-p$a_surface)/400)))/2
ok(any(abs(p$p_a_primary-avg)>1e-6),'not probability averaging')
for(slot in c('a','b'))for(kind in c('overall','surface')) {
 cold<-p[[paste0(slot,'_',kind,'_cold')]]
 ok(all(p[[paste0(slot,'_',kind)]][cold]==1500),'unseen state exactly 1500')
 ok(identical(cold,p[[paste0(slot,'_',kind,'_prior_matches')]]==0),'cold count agrees')
}
# Independently join every player-batch update to frozen target ratings and outcomes.
y<-inp$y[match(p$match_id,inp$x$match_id)]
for(component in c('OVERALL','SURFACE')) {
 kind<-tolower(component);expectation<-1/(1+10^((p[[paste0('b_',kind)]]-p[[paste0('a_',kind)]])/400))
 delta<-32*(y-expectation)
 d<-rbind(data.frame(tour=p$tour,batch=p$batch_key,player=p$player_a_id,surface=p$surface,id=p$match_id,delta=delta),data.frame(tour=p$tour,batch=p$batch_key,player=p$player_b_id,surface=p$surface,id=p$match_id,delta=-delta))
 key<-paste(d$batch,d$player,if(component=='OVERALL')'ALL' else d$surface)
 zz<-u[u$component==component,];uk<-paste(zz$batch_key,zz$player_id,zz$surface)
 sums<-tapply(d$delta,key,sum);counts<-table(key)
 ok(eq(zz$accumulated_delta,as.numeric(sums[uk])),'independent component expectations and summed updates')
 ok(all(zz$batch_matches==as.integer(counts[uk]))&&sum(zz$batch_matches)==3756,'all contributions exactly twice')
 ok(all(vapply(seq_len(nrow(zz)),function(j)setequal(strsplit(zz$contributing_match_ids[j],';',fixed=TRUE)[[1]],d$id[key==uk[j]]),TRUE)),'exact contribution IDs no exclusions')
 ok(max(abs(zz$after-zz$before-zz$accumulated_delta))<1e-10,'unclipped after arithmetic')
 ok(max(abs(tapply(zz$accumulated_delta,paste(zz$batch_key,zz$surface),sum)))<1e-10,'zero-sum batch by component/surface')
 # Reconstruct pre-batch states independently from latest earlier saved ledger rows.
 for(slot in c('a','b')) {
  player<-p[[paste0('player_',slot,'_id')]]
  combined<-rbind(ul[ul$component==component,c('tour','source_tourney_date','player_id','surface','after','after_matches')],vl[vl$component==component,c('tour','source_tourney_date','player_id','surface','after','after_matches')],zz[c('tour','source_tourney_date','player_id','surface','after','after_matches')])
  got<-vapply(seq_len(nrow(p)),function(j){rows<-which(combined$tour==p$tour[j]&combined$player_id==player[j]&combined$source_tourney_date<p$source_tourney_date[j]&(component=='OVERALL'|combined$surface==p$surface[j]));if(!length(rows))return(1500);as.numeric(combined$after[rows[which.max(as.numeric(combined$source_tourney_date[rows]))]])},0.0)
  ok(eq(got,p[[paste0(slot,'_',kind)]]),'strict previous-state ownership/surface continuity')
 }
}
ok(any(abs(u$accumulated_delta)>32),'batch deltas remain greater than K where accumulated')
ok(all(u$after_matches==u$prior_matches+u$batch_matches),'update count continuity')
strata<-table(p$tour,factor(p$s08_stratum,levels=c('BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')))
ok(all(strata[,'BOTH_COMPLETE']==tapply(targets$both_candidates_feature_complete,targets$tour,sum)),'S08 strata reconcile')
for(tour in c('ATP','WTA')){
 z<-summary[summary$level=='tour'&summary$tour==tour&summary$record_type=='COVERAGE'&!is.na(summary$stratum)&summary$stratum=='ALL',]
 ok(z$targets==sum(p$tour==tour)&&z$primary_available==z$targets&&z$overall_available==z$targets,'summary denominator')
}
set.seed(17);perm<-sample(nrow(inp$x));rp<-e$ae_replay(inp$x[perm,],inp$y[perm],terminal$states,e)
ok(identical(rp,base_p),'row/event/within-batch permutation invariance')
# Every actual batch: change only its outcomes; every probability up through it is unchanged.
for(batch in unique(inp$x$batch_key)) {
 yy<-inp$y;ii<-which(inp$x$batch_key==batch);yy[ii]<-1-yy[ii]
 rr<-e$ae_replay(inp$x,yy,terminal$states,e)
 keep<-p$tour!=inp$x$tour[ii[1]]|p$source_tourney_date<=inp$x$source_tourney_date[ii[1]]
 ok(identical(rr$p[keep,],base_p$p[keep,]),paste('own/later outcome independence',batch))
}
swap<-inp$x;swap$player_a_id<-inp$x$player_b_id;swap$player_b_id<-inp$x$player_a_id
swap$a_s08_complete<-inp$x$b_s08_complete;swap$b_s08_complete<-inp$x$a_s08_complete
rr<-e$ae_replay(swap,1-inp$y,terminal$states,e)
ok(eq(rr$p$p_a_primary,1-p$p_a_primary)&&eq(rr$p$p_a_overall,1-p$p_a_overall),'global neutral slot complements')
ok(eq(rr$u,base_p$u),'slot swaps preserve updates')
# Same-date multi-event/multi-surface fixture with repeated player and untouched Grass state.
f<-inp$x[rep(1,4),];f$match_id<-paste0('fixture',1:4);f$match_key<-paste0('FIXTURE|',f$match_id);f$event<-c('one','two','three','four');f$cell_id<-f$event
f$player_a_id<-'p';f$player_b_id<-c('q','r','s','q');f$surface<-c('Hard','Clay','Hard','Grass');f$source_tourney_date<-c(rep('20250101',3),'20250201');f$batch_key<-paste('ATP',f$source_tourney_date,sep='|')
ss<-list(ATP=list(g=numeric(),s=c('p|Grass'=1600),ng=numeric(),ns=c('p|Grass'=1),last_date='20241231'))
fr<-e$ae_replay(f,c(1,1,1,0),ss,e)
ok(all(fr$p$p_a_primary[1:3]==.5),'multi-event/multi-surface simultaneous probabilities')
z<-fr$u[fr$u$source_tourney_date=='20250101'&fr$u$player_id=='p'&fr$u$component=='OVERALL',]
ok(z$before==1500&&z$accumulated_delta==48&&z$after==1548,'sum not clip/average/sequential')
ok(fr$p$a_surface[4]==1600,'unused surface unchanged')
fp<-e$ae_replay(f[4:1,],c(0,1,1,1),ss,e);ok(identical(fr,fp),'fixture order invariance')
fr2<-e$ae_replay(f,c(0,0,0,0),ss,e)
ok(identical(fr$p[1:3,],fr2$p[1:3,])&&fr$p$p_a_primary[4]!=fr2$p$p_a_primary[4],'later batch outcome positive control')
bad<-terminal$states;bad$ATP$last_date<-'20260101';fail(e$ae_replay(inp$x,inp$y,bad,e),'Non-earlier')
fail(e$ae_replay(inp$x,rep(2,nrow(inp$x)),terminal$states,e),'Invalid neutral')

# A prior outcome changes later states, but counts/features do not depend on its result label.
ok(any(p$a_overall_prior_matches>0),'carried histories present')
# Atomic staging and two independent full reconciliations/reruns.
tmp<-tempfile('ak-tests-');dir.create(tmp)
atomic<-function(){
 on.exit(unlink(tmp,recursive=TRUE),add=TRUE);files<-paste0(ak_outputs,'.csv')
 scratch<-ak_helpers();environment(scratch$se_install)$se_ignored<-function(...)NULL
 dest<-file.path(tmp,'atomic')
 fail(scratch$se_install(r,dest,function(stage)stop('INTERRUPTED')),'INTERRUPTED');ok(!dir.exists(dest),'no interrupted final directory')
 fail(scratch$se_install(r,dest,function(stage)cat('bad',file=file.path(stage,'summary.csv'))),'Staged bytes changed');ok(!dir.exists(dest),'no corrupt directory')
 scratch$se_install(r,dest);hashes<-vapply(file.path(dest,files),ak_hash,'');scratch$se_install(r,dest);ok(identical(hashes,vapply(file.path(dest,files),ak_hash,'')),'idempotent installation')
 bad<-r;bad[[2]]$dM03[1]<-99;fail(scratch$se_install(bad,dest),'Existing bytes differ');ok(identical(hashes,vapply(file.path(dest,files),ak_hash,'')),'no overwrite')
 for(run in c('one','two')) {
  dest2<-file.path(tmp,run)
  script<-paste0("source('R/build_2025_features_elo.R');e<-ak_helpers();environment(e$se_install)$se_ignored<-function(...)NULL;e$se_install(ak_main(FALSE),",deparse(dest2),")")
  status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)));ok(status==0,'independent full reconciliation and build')
  for(file in files)ok(ak_hash(file.path(dest2,file))==ak_hash(file.path(dest,file)),paste('independent bytes',run,file))
 }
 if(dir.exists(ak_dir))for(file in files)ok(ak_hash(file.path(ak_dir,file))==ak_hash(file.path(dest,file)),paste('installed bytes',file))
}
atomic();e$se_ignored();ok(TRUE,'five outputs ignored');ak_verify();ok(TRUE,'all input pins preserved')
for(z in r)ok(all(z$analysis_label=='2025 locked source-label final-test sensitivity'&z$verified_chronology_decision==e$se_chronology&z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'&z$m05_interpretation_gate=='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED'),'all output limitations')
if(dir.exists(ak_dir))ok(setequal(list.files(ak_dir,all.files=TRUE,no..=TRUE),paste0(ak_outputs,'.csv')),'exact five-output scope')
expected<-c('R/build_2025_features_elo.R','R/test_2025_features_elo.R','docs/2025-feature-elo-construction-audit.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
changed<-system2('git',c('diff','--name-only','433c12f689dee1fa080647b3132ba89d7c6a9785'),stdout=TRUE);other<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
added<-expected[!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)&file.exists(expected)]
ok(all(unique(c(changed,other,added)) %in% expected),'no tracked files outside six-file scope')
cat(n,'Phase 2AK focused checks passed\n')
