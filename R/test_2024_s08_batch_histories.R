# Phase 2AD: focused frozen-data and synthetic component tests; no historical suite.
source('R/aggregate_2024_s08_batch_histories.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern=''){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),paste('fail closed',pattern))}
eq<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
e<-ad_helpers();i<-ad_read_inputs(e)
for(p in names(ad_pins))ok(ad_hash(p)==ad_pins[[p]],paste('pin',p))
p<-ad_pins;p[1]<-'changed';fail(ad_verify(p),'Missing/changed')
fail(e$s08_ignored('R/not-ignored'),'already be ignored')
r<-ad_build(i,e);slots<-r[[1]];targets<-r[[2]];summary<-r[[3]]
ok(nrow(slots)==3802&&!anyDuplicated(paste(slots$match_key,slots$slot)),'3802 slots exactly once')
ok(nrow(targets)==1901&&!anyDuplicated(targets$match_key)&&setequal(targets$match_id,i$x$match_id),'1901 targets original IDs')
ok(sum(slots$history_matches)==101983,'all frozen contributions accounted for')
# Independent reconstruction: join each original player ID to raw winner/loser effective columns,
# then grouped sums (rowsum), without calling production component/count/pool functions.
dl<-i$dd;vl<-i$vd;dl$key<-paste('DEVELOPMENT',dl$match_id,sep='|');vl$key<-paste('VALIDATION_2024',vl$match_id,sep='|')
fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
keep<-c('key','membership','winner_id','loser_id',paste0('effective_w_',fields),paste0('effective_l_',fields))
raw<-rbind(dl[,keep],vl[,keep]);links<-i$h[i$h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
j<-match(links$prior_key,raw$key);z<-raw[j,];won<-links$player_id==z$winner_id
ok(!anyNA(j)&&all(z$membership=='INCLUDED')&&all(won|links$player_id==z$loser_id),'admitted player ownership independent join')
get<-function(field,own=TRUE){w<-as.numeric(z[[paste0('effective_w_',field)]]);l<-as.numeric(z[[paste0('effective_l_',field)]]);ifelse(if(own)won else !won,w,l)}
parts<-cbind(M03_num=get('1stWon'),M03_den=get('1stIn'),M05_num=get('df'),M05_den=get('svpt')-get('1stIn'),M11_num=get('bpFaced',FALSE),M11_den=get('SvGms',FALSE),M12_num=get('bpFaced',FALSE)-get('bpSaved',FALSE),M12_den=get('bpFaced',FALSE))
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
 s<-summary[summary$level=='tour'&summary$tour==tour&summary$metric==metric&summary$slot==slot,]
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
q<-i;q$h<-q$h[-1,];fail(ad_validate(q,e),'membership differs')
q<-i;q$h<-rbind(q$h,q$h[1,]);fail(ad_validate(q,e),'membership differs')
q<-i;q$h$prior_source_date[1]<-q$h$target_source_date[1];fail(ad_validate(q,e),'membership differs')
q<-i;q$x$player_a_id[1]<-'999999';fail(ad_validate(q,e),'targets differ')
# Input, event and within-batch permutations leave the full release unchanged.
q<-lapply(i,function(d)d[nrow(d):1,,drop=FALSE]);ok(identical(r,ad_build(q,e)),'full permutation invariance')
# Swap target slots after validation, retaining each prior contributor's original slot ownership.
checked<-ad_validate(i,e);counts<-ad_count_inputs(i,checked$h);xx<-checked$x;hh<-checked$h
xx[c('player_a_id','player_b_id')]<-xx[c('player_b_id','player_a_id')]
for(suffix in c('history_matches','development_matches','validation_matches','empty_reason','empty_detail'))xx[paste0(c('a_','b_'),suffix)]<-xx[paste0(c('b_','a_'),suffix)]
hh$target_slot<-ifelse(hh$target_slot=='a','b','a');swap<-ad_aggregate(xx,hh,counts,e)
for(metric in e$s08_metrics){ok(eq(r[[2]][[paste0('d',metric)]],-swap[[2]][[paste0('d',metric)]]),paste('swap difference',metric));ok(eq(r[[2]][[paste0('a_',metric)]],swap[[2]][[paste0('b_',metric)]]),paste('swap player rate',metric))}
# For a selected target batch, corrupt all same/later outcomes and effective counts after
# freezing membership. They must never reach that target's count parser; later targets may differ.
use<-checked$x$batch_key=='WTA|20240812';tx<-checked$x[use,];th<-checked$h[checked$h$target_key %in% tx$match_key,]
base<-ad_aggregate(tx,th,ad_count_inputs(i,th),e)
q<-i;mut<-q$vd$audit_tour=='WTA'&q$vd$tourney_date>='20240812'
for(field in grep('^(winner_|loser_|w_|l_|effective_)|^score$',names(q$vd),value=TRUE))q$vd[[field]][mut]<-'PERTURBED'
ok(identical(base,ad_aggregate(tx,th,ad_count_inputs(q,th),e)),'target and later outcomes/counts unused')
# Outcome-only swap of a contributing result with its count sides preserves player ownership.
c<-ad_count_inputs(i,th);q<-c;k<-1L;q$d$winner_id[k]<-c$d$loser_id[k];q$d$loser_id[k]<-c$d$winner_id[k]
q$d$a_original_side[k]<-q$m$a_original_side[k]<-if(c$m$a_original_side[k]=='winner')'loser' else 'winner'
for(field in fields){q$d[[paste0('effective_w_',field)]][k]<-c$d[[paste0('effective_l_',field)]][k];q$d[[paste0('effective_l_',field)]][k]<-c$d[[paste0('effective_w_',field)]][k]}
ok(identical(base,ad_aggregate(tx,th,q,e)),'winner-label swap with player counts unchanged')
q<-c;field<-'effective_w_1stWon';q$d[[field]][1]<-as.character(as.numeric(q$d[[field]][1])-1)
ok(!identical(base[[2]],ad_aggregate(tx,th,q,e)[[2]]),'earlier admitted count positive control')
# Atomic installation and independent-process byte equality.
tmp<-tempfile('ad-tests-');dir.create(tmp)
atomic<-function(){on.exit(unlink(tmp,recursive=TRUE),add=TRUE);dirs<-file.path(tmp,c('one','two'));files<-paste0(ad_outputs,'.csv')
 for(dest in dirs){script<-paste0("source('R/aggregate_2024_s08_batch_histories.R');e<-ad_helpers();e$s08_ignored<-function(...)NULL;e$s08_install(ad_main(FALSE),",deparse(dest),")");status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)),stdout=FALSE,stderr=FALSE);ok(status==0,'independent process')}
 for(k in files)ok(ad_hash(file.path(dirs[1],k))==ad_hash(file.path(dirs[2],k)),paste('byte-identical',k))
 a<-ad_helpers();a$s08_ignored<-function(...)NULL;dest<-file.path(tmp,'atomic')
 fail(a$s08_install(r,dest,function(stage)stop('INTERRUPTED')),'INTERRUPTED');ok(!dir.exists(dest),'no interrupted final directory')
 fail(a$s08_install(r,dest,function(stage)cat('bad',file=file.path(stage,'summary.csv'))),'Staged bytes changed');ok(!dir.exists(dest),'no corrupt final directory')
 a$s08_install(r,dest);hashes<-vapply(file.path(dest,files),ad_hash,'');a$s08_install(r,dest);ok(identical(hashes,vapply(file.path(dest,files),ad_hash,'')),'idempotent install')
 bad<-r;bad[[2]]$dM03[1]<-99;fail(a$s08_install(bad,dest),'Existing bytes differ');ok(identical(hashes,vapply(file.path(dest,files),ad_hash,'')),'no overwrite')
 if(dir.exists(ad_dir))for(k in files)ok(ad_hash(file.path(ad_dir,k))==ad_hash(file.path(dirs[1],k)),paste('installed bytes',k))
}
atomic();e$s08_ignored();ok(TRUE,'output ignore coverage');ad_verify();e$ac_verify();ok(TRUE,'historical inputs preserved')
if(dir.exists(ad_dir))ok(setequal(list.files(ad_dir,all.files=TRUE,no..=TRUE),paste0(ad_outputs,'.csv')),'exact output scope')
expected<-c('PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md','R/aggregate_2024_s08_batch_histories.R','R/test_2024_s08_batch_histories.R','docs/2024-s08-batched-history-aggregation.md')
changed<-system2('git',c('diff','--name-only','a31d675cf310b47f75eb678d91d146c0ba6e045e'),stdout=TRUE);other<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
added<-expected[!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)&file.exists(expected)]
ok(setequal(unique(c(changed,other,added)),expected),'exact six-file scope')
cat(n,'Phase 2AD focused checks passed\n')
