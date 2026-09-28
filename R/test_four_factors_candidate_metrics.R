# Offline Phase 2A contract, synthetic and saved-evidence tests. No packages required.
source('R/audit_four_factors_candidate_metrics.R')
test_four_factors_candidate_metrics <- function() {
  n<-0L
  check<-function(ok,label){fc_need(isTRUE(ok),paste('test:',label));n<<-n+1L}
  reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=identity),'error'),label)
  close<-function(x,y)isTRUE(all.equal(unname(x),unname(y),tolerance=1e-12,check.attributes=FALSE))
  # All transports are blocked, including namespace-qualified calls in legacy code.
  for(f in c('download.file'))trace(f,where=asNamespace('utils'),tracer=quote(stop('NO NETWORK IN PHASE 2A TESTS')),print=FALSE)
  for(f in c('url','socketConnection'))trace(f,where=baseenv(),tracer=quote(stop('NO NETWORK IN PHASE 2A TESTS')),print=FALSE)
  on.exit({untrace('download.file',where=asNamespace('utils'));for(f in c('url','socketConnection'))untrace(f,where=baseenv())},add=TRUE)
  a<-setNames(c(8,3,80,50,35,15,12,6,4),fc_fields())
  b<-setNames(c(5,2,70,40,24,12,11,8,5),fc_fields())
  fa<-fc_side(a,b);fb<-fc_side(b,a)
  expected<-c(8/80,50/80,35/50,15/30,3/30,3/80,15/27,34/70,16/40,18/30,8/11,3/8,4/6,6/12,50/80)
  for(i in 1:15)check(close(fa$value[i],expected[i])&&fa$reason[i]=='defined',paste('M formula',i))
  check(close(fc_outcomes(a,b),c(100*(84-66)/150,100*(50/80-36/70))),'both independently calculated outcomes')
  check(close(fc_outcomes(a,b),-fc_outcomes(b,a)),'both outcomes reverse with slots')
  for(i in 1:15)check(close(fa$value[i]-fb$value[i],-(fb$value[i]-fa$value[i])),paste('difference sign',i))
  check(all(fc_side(a,b,TRUE)$reason=='invalid_bundle'),'whole invalid bundle withheld')
  for(f in fc_fields()) {
    aa<-a;aa[f]<-NA_real_;check(all(fc_side(aa,b)$reason=='missing_input')&&all(is.na(fc_side(aa,b)$value)),paste('missing bundle',f))
    for(value in c(-1,.5,Inf)) {aa<-a;aa[f]<-value;check(all(fc_side(aa,b)$reason=='invalid_bundle'),paste('invalid count',f,value))}
  }
  mutations<-list(c('1stIn',81),c('1stWon',51),c('2ndWon',31),c('df',31),c('2ndWon',28),c('bpSaved',7),c('bpFaced',81),c('ace',51),c('SvGms',81),c('svpt',0))
  for(z in mutations){aa<-a;aa[z[1]]<-as.numeric(z[2]);check(fc_pair_validity(aa,b)$invalid,paste('impossible universe',z[1],z[2]))}
  for(z in list(c(0,0,'zero_opportunities'),c(NA,1,'missing_input'),c(1,-1,'invalid_bundle'),c(2,1,'invalid_bundle'),c(1,0,'invalid_bundle'))) {
    r<-fc_ratio(as.numeric(z[1]),as.numeric(z[2]));check(is.na(r$value)&&r$reason==z[3],paste('U1',z[3]))
  }
  check(fc_ratio(0,1)$value==0&&fc_ratio(1,1)$value==1&&fc_ratio(2,1,upper=Inf)$value==2,'zero one and per-game ranges')
  aa<-a;bb<-b;aa[c('bpFaced','bpSaved')]<-0;bb[c('bpFaced','bpSaved')]<-0
  zz<-fc_side(aa,bb);check(all(zz$reason[c(12,13)]=='zero_opportunities')&&all(zz$value[c(11,14)]==0),'zero BP opportunities separate from zero pressure')
  aa<-a;aa[c('1stIn','1stWon','df','2ndWon')]<-c(80,50,0,0)
  check(all(fc_side(aa,b)$reason[c(4,5,7)]=='zero_opportunities'),'all first serves zero second opportunities')
  aa<-a;aa[c('1stIn','1stWon','df','2ndWon')]<-c(50,35,30,0)
  zz<-fc_side(aa,b);check(zz$value[4]==0&&zz$value[5]==1&&zz$reason[7]=='zero_opportunities','double faults included once; conditional universe empty')
  aa<-a;aa[c('1stIn','1stWon')]<-0;check(fc_side(aa,b)$reason[3]=='zero_opportunities','zero first serve opportunity')
  for(pair in list(c(3,9,1),c(4,10,1),c(8,15,1),c(11,14,-1),c(12,13,1)))check(close((fa$value-fb$value)[pair[1]],pair[3]*(fa$value-fb$value)[pair[2]]),'exact opposing difference identity')
  check(close(fa$value[8]+fb$value[15],1)&&close(fa$value[9]+fb$value[3],1)&&close(fa$value[10]+fb$value[4],1),'opponent complements')
  check(close(fa$value[6],fa$value[5]*(1-fa$value[2]))&&close(fa$value[4],fa$value[7]*(1-fa$value[5]))&&close(fa$value[15],fa$value[2]*fa$value[3]+(1-fa$value[2])*fa$value[4]),'nonlinear within-side identities')
  check(close(fc_outcomes(a,b)[2],100*(fa$value[15]-fb$value[15])),'equal-phase outcome decomposition')
  ids<-c('12','103','2');other<-c('14','100','1')
  check(identical(fc_orientation(ids,other),!fc_orientation(other,ids)),'stable IDs independent of result')
  check(identical(fc_orientation(rev(ids),rev(other)),rev(fc_orientation(ids,other))),'row order cannot set orientation')
  for(z in list(c(NA,'1'),c('1','1'),c('Name','2')))reject(fc_orientation(z[1],z[2]),'ambiguous player IDs rejected')
  check(identical(fc_match_index(c('a','b'),c('b','a')),c(2L,1L)),'exact mapping reorders')
  for(z in list(c('a','a'),c('a'),c('a','c'),c('a',NA)))reject(fc_match_index(c('a','b'),z),'duplicate missing ambiguous match rejected')
  check(fc_cor(1:2,1:2)$reason=='insufficient_pairs','two pairs declared insufficient')
  check(fc_cor(rep(1,4),1:4)$reason=='constant_variable','constant correlation')
  check(fc_cor(c(1:3,NA),c(1:3,4))$n==3,'finite pair count')
  check(close(fc_cor(c(0,1/3,1/3,1),1:4,'spearman')$value,fc_cor(c(0,1-2/3,1/3,1),1:4,'spearman')$value),'rational equality preserves Spearman ties')
  check(fc_matrix(data.frame(a=1:2,b=2:3))$state=='insufficient_sample','insufficient matrix')
  check(fc_matrix(data.frame(a=rep(1,4),b=rep(2,4)))$rank==0,'constant matrix')
  mm<-fc_matrix(data.frame(a=1:5,b=2*(1:5),c=c(1,3,2,4,2)))
  check(mm$rank==2&&is.infinite(mm$condition_number),'exact rank-deficient matrix')
  check(nzchar(fc_matrix(data.frame(a=1+(1:5)*1e-12,b=1:5))$near_constant_columns),'near constant reported')
  for(year in c('2022','2024','2025'))reject(fc_allow(paste0('data/raw/atp_',year,'.csv')),paste('forbidden year',year))
  reject(fc_allow('/tmp/foreign.csv'),'foreign absolute read');reject(fc_allow('../tennis-analytics/PROJECT_CONTEXT.md'),'nonliteral path rejected')
  check(length(fc_pins())==86&&all(nchar(fc_pins())==64),'86 exact SHA-256 input pins')
  # Pin mutation is in a private function environment; never mutate saved evidence.
  env<-new.env(parent=environment(fc_verify));env$fc_pins<-function(){p<-fc_pins();p[1]<-paste(rep('0',64),collapse='');p}
  bad_verify<-fc_verify;environment(bad_verify)<-env
  reject(bad_verify(),'altered expected hash rejected')
  le<-fc_legacy();reject(le$readLines('data/raw/atp_2025.csv'),'runtime read guard');reject(le$system2('curl','x'),'transport subprocess blocked')
  reject(le$system2('git','fetch'),'Git network/mutation blocked');reject(le$annual_2021_request(),'legacy acquisition blocked')
  message('Synthetic checks complete; reconstructing all pinned saved evidence.')
  input<-fc_load();check(all(input$reads%in%names(fc_pins())),'all actual legacy read paths allowed')
  save_provenance<-input$provenance
  adapter<-fc_adapter(input);r<-fc_build(input);d<-r$`eligibility-audit`;x<-r$`match-metrics`;dict<-r$`candidate-dictionary`
  check(nrow(d)==245&&sum(d$completed_denominator)==232&&sum(d$valid_bundle)==231,'full eligibility universe')
  check(sum(d$status=='retirement')==11&&sum(d$status=='walkover')==2&&sum(d$quarantined)==1,'all exclusions accounted')
  vals<-c(grep('^[ab]_M[0-9]+_(value|numerator|denominator)$|^diff_',names(x),value=TRUE),'NPR','equal_phase_NPR','same_match_win')
  check(all(is.na(as.matrix(x[!x$valid_bundle,vals]))),'all excluded and quarantined values withheld')
  q<-d[d$quarantined,];check(q$match_id=='WTA:2023-609:268'&&q$completed_denominator,'quarantine retained in denominator')
  check(sum(d$valid_bundle&d$count_origin=='approved_recovery_overlay')==7&&all(d$source_missing_fields[d$count_origin=='approved_recovery_overlay']==18),'seven separate recoveries and 126 original omissions')
  check(sum(d$valid_bundle&d$season==2021&d$count_origin=='original_source')==42,'Montreal 42 source bundles')
  cov<-r$`cell-coverage`;un<-cov$status=='UNVETTED_NONPILOT'
  check(nrow(cov)==40&&sum(cov$source_rows)==3832&&sum(un)==37&&all(is.na(cov$completed_denominator[un])),'all 40 source cells with 37 unvetted')
  check(all(cov$tour_season_95pct=='NOT_TESTED')&&all(cov$event_admission=='NOT_EVALUATED'),'unchanged model gates')
  # Mutate supplied reconstructed records, not files; every failure blocks the whole adapter.
  bad<-input;bad$iw$`match-reconciliation`<-rbind(bad$iw$`match-reconciliation`,bad$iw$`match-reconciliation`[1,]);reject(fc_adapter(bad),'duplicate inventory link')
  bad<-input;bad$iw$`match-reconciliation`<-bad$iw$`match-reconciliation`[-1,];reject(fc_adapter(bad),'missing inventory link')
  bad<-input;bad$iw$`official-matches`$winner_id[which(!bad$iw$`official-matches`$bye)[1]]<-'999';reject(fc_adapter(bad),'conflicting official winner')
  bad<-input;bad$m$dispositions$classification[1]<-'unknown';reject(fc_adapter(bad),'unknown status blocks audit')
  bad<-input;bad$m$dispositions$source_statistical_quarantine[1]<-'FALSE';reject(fc_adapter(bad),'unexpected quarantine contract token')
  bad<-input;bad$mi$overlay$field_decisions<-bad$mi$overlay$field_decisions[-1,];reject(fc_adapter(bad),'partial recovery rejected')
  bad<-input;bad$mi$overlay$field_decisions$source_audit_id[1]<-'outside';reject(fc_adapter(bad),'out of scope recovery')
  bad<-input;bad$mi$overlay$field_decisions$source_winner_id[1]<-'999';reject(fc_adapter(bad),'recovery orientation mismatch')
  bad<-input;bad$mi$overlay$field_decisions$structural_validation_state[1]<-'unknown';reject(fc_adapter(bad),'missing recovery validation proof')
  bad<-input;bad$iw$`source-matches`$statistical_bundle_quarantined<-FALSE;reject(fc_adapter(bad),'quarantine cannot disappear')
  swapped<-adapter
  for(k in names(swapped$bundles))swapped$bundles[[k]]<-list(a=adapter$bundles[[k]]$b,b=adapter$bundles[[k]]$a)
  swapped$eligibility$player_a_id<-d$player_b_id;swapped$eligibility$player_b_id<-d$player_a_id
  swapped$eligibility$a_original_side<-d$b_original_side;swapped$eligibility$b_original_side<-d$a_original_side
  sx<-fc_metrics(swapped)
  for(id in dict$id)for(f in c('value','numerator','denominator','reason'))check(identical(sx[[paste('a',id,f,sep='_')]],x[[paste('b',id,f,sep='_')]])&&identical(sx[[paste('b',id,f,sep='_')]],x[[paste('a',id,f,sep='_')]]),'every paired metric swaps')
  check(close(sx$NPR,-x$NPR)&&close(sx$equal_phase_NPR,-x$equal_phase_NPR)&&close(sx$same_match_win,1-x$same_match_win),'saved sample outcomes swap')
  check(!anyDuplicated(x$match_id)&&nrow(x)==245,'one inventory row per match')
  reject(fc_associations(rbind(x,x[1,]),dict),'duplicated association input rejected')
  assoc<-r$`association-summary`
  for(g in unique(assoc$group)) {
    ix<-fc_groups(x)[[g]];z<-x[ix,];common<-sum(z$valid_bundle&complete.cases(z[c(paste0('diff_',dict$id),'NPR','equal_phase_NPR','same_match_win')]))
    check(all(assoc$pair_count[assoc$group==g&assoc$sample=='common_complete']==common),'common complete exact sample')
    ar<-assoc[assoc$group==g&assoc$sample=='pairwise',]
    check(all(vapply(seq_len(nrow(ar)),function(i)ar$pair_count[i]==sum(is.finite(z[[paste0('diff_',ar$metric[i])]])&is.finite(z[[ar$outcome[i]]])),TRUE)),'each association exact pair count')
  }
  check(all(r$`matrix-diagnostics`$rank<=10)&&all(is.infinite(r$`matrix-diagnostics`$condition_number)),'real exact dependencies and rank')
  check(all(abs(r$`redundancy-map`$max_identity_residual)<=1e-12,na.rm=TRUE),'all verified identity residuals')
  check(all(r$`metric-availability`$missing_input==0)&&all(r$`distribution-summary`$out_of_range==0,na.rm=TRUE),'no selected missing inputs or range failures')
  se<-r$`sensitivity-summary`;check(all(c('exclude_recovery','exclude_lower_denominator_quartile','leave_one_match_range')%in%se$scenario)&&any(startsWith(se$scenario,'exclude_event:')),'all sensitivities reported')
  check(all(se$reason[startsWith(se$group,'cell:')&startsWith(se$scenario,'exclude_event:')]=='insufficient_pairs'),'sole event removal not falsely assessable')
  check(sum(r$summary$value=='NOT_ASSESSABLE')==3,'three unavailable comparisons')
  check(identical(save_provenance,fc_snapshot()),'all inputs unchanged after all calculations')
  # Parse the production AST, including nested calls, rather than matching prose strings.
  calls<-character();walk<-function(z){if(is.call(z)){calls<<-c(calls,paste(deparse(z[[1]]),collapse=''));for(i in seq_along(z)[-1])if(!identical(z[[i]],quote(expr=)))walk(z[[i]])}else if(is.expression(z)||is.pairlist(z))for(i in seq_along(z))if(!identical(z[[i]],quote(expr=)))walk(z[[i]])}
  walk(parse('R/audit_four_factors_candidate_metrics.R'))
  forbidden<-c('lm','glm','nls','predict','optim','mice','aregImpute','download.file','url','socketConnection','curl_fetch_memory','library','require','install.packages','eval','parse')
  check(!any(sub('^.*::','',calls)%in%forbidden),'no network fitting imputation dynamic evaluation or dependency calls')
  code<-paste(readLines('R/audit_four_factors_candidate_metrics.R'),collapse='\n')
  check(!any(calls%in%c('review_otd_documentation','download_2021_annual_data','download_pilot_data','annual_2021_request','mr_request')),'no direct OTD or acquisition execution')
  for(p in c('docs/status.md','docs/data-source-contract.md')) {
    text<-paste(readLines(p),collapse='\n')
    for(token in c('GO_TO_FACTOR_DEFINITION_PROTOCOL','PAUSED_BY_USER_AFTER_PHASE_1S','Q6/Q8','PENDING_USER_APPROVAL','NOT_TESTED','37','231'))check(grepl(token,text,fixed=TRUE),paste('current contract',p,token))
  }
  paths<-fc_publish(r);before<-fc_snapshot(paths)
  fc_publish(r);check(identical(before,fc_snapshot(paths)),'identical rerun preserves bytes and mtimes')
  changed<-r;changed$summary$value[1]<-'BAD';reject(fc_publish(changed),'changed release refused');check(identical(before,fc_snapshot(paths)),'failed publication preserves every prior file')
  ae<-new.env(parent=environment(audit_four_factors_candidate_metrics));ae$fc_load<-function()stop('input fingerprint mismatch fixture')
  failed_audit<-audit_four_factors_candidate_metrics;environment(failed_audit)<-ae
  reject(failed_audit(),'input failure stops public workflow');check(identical(before,fc_snapshot(paths)),'input failure preserves the complete prior release')
  # Fault injection isolates staging/installation in a temporary tree, not research files.
  td<-tempfile('phase2a-publish-test-');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE)
  pe<-new.env(parent=environment(fc_publish));pe$fc_dir<-function()file.path(td,'outputs');pe$fc_report_path<-file.path(td,'report.md')
  pe$system2<-function(command,args,...)if(args[1]=='check-ignore')tail(args,1) else character()
  copies<-0L;pe$file.copy<-function(...){copies<<-copies+1L;if(copies==3L)FALSE else base::file.copy(...)}
  pub<-fc_publish;environment(pub)<-pe
  reject(pub(r,pe$fc_dir(),pe$fc_report_path),'injected install failure');check(!length(list.files(td,recursive=TRUE)),'initial failure leaves no partial release')
  pe$file.copy<-base::file.copy
  writeLines('existing',pe$fc_report_path);reject(pub(r,pe$fc_dir(),pe$fc_report_path),'partial existing release refused')
  check(identical(readLines(pe$fc_report_path),'existing'),'partial existing file never overwritten')
  check(!length(system2('git',c('ls-files','--','data/raw','data/pilot'),stdout=TRUE)),'restricted raw and row outputs untracked')
  csvs<-paths[grepl('[.]csv$',paths)]
  check(setequal(system2('git',c('check-ignore','--',csvs),stdout=TRUE),csvs),'all 14 outputs ignored')
  check(identical(readLines(fc_report_path),fc_report(r)),'generated report exactly agrees with tables')
  for(i in seq_along(r))check(identical(readLines(paths[i]),fc_csv_lines(r[[i]])),paste('deterministic CSV',names(r)[i]))
  check(identical(save_provenance,fc_snapshot()),'all evidence hashes sizes mtimes preserved at end')
  message(n,' Phase 2A checks passed; no network, model or imputation.');invisible(list(checks=n,result=r))
}
if(sys.nframe()==0L)test_four_factors_candidate_metrics()
