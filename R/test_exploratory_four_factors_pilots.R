# Phase 2F offline tests; all empirical entry points remain inert when sourced.
source('R/analyze_exploratory_four_factors_pilots.R')
source('R/test_current_context_pilot_revalidation.R')
pf_test_git <- function(args) {
  pf_need(args[1]%in%c('show','rev-parse','hash-object','ls-tree','ls-files','check-ignore','diff','diff-tree'),'read-only Phase 2F test Git')
  z<-system2('git',vapply(args,shQuote,''),stdout=TRUE)
  pf_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'Phase 2F test Git failed');z
}
pf_test_files<-c('R/analyze_exploratory_four_factors_pilots.R','R/test_exploratory_four_factors_pilots.R',
  'docs/exploratory-four-factors-pilot-analysis.md','docs/status.md','docs/data-source-contract.md')
pf_test_code <- function(code) {
  calls<-character()
  walk<-function(x){if(missing(x))return();if(is.call(x)){if(is.symbol(x[[1]]))calls<<-c(calls,as.character(x[[1]])) else if(is.call(x[[1]])&&as.character(x[[1]][[1]])%in%c('::',':::'))calls<<-c(calls,as.character(x[[1]][[3]]));for(y in as.list(x)[-1])walk(y)}else if(is.expression(x)||is.pairlist(x))for(y in x)walk(y)}
  walk(parse(text=code))
  pf_need(!any(calls%in%c('download.file','url','socketConnection','browseURL','system','pipe','install.packages','library','require','eval','evalq',
    'step','stepAIC','glmnet','ginv','boot','sample','sample.int','confint','summary.lm','summary.glm','shapley','calc.relimp','predict','optim','mice')),'forbidden analysis or transport capability')
  TRUE
}
pf_test_math <- function(check,reject) {
  near<-function(a,b)isTRUE(all.equal(unname(a),unname(b),tolerance=1e-11,check.attributes=FALSE))
  a<-setNames(c(8,3,80,50,35,15,12,6,4),pf_fields());b<-setNames(c(5,2,70,40,24,12,11,8,5),pf_fields())
  expected<-c(8/80,50/80,35/50,15/30,3/30,3/80,15/27,34/70,16/40,18/30,8/11,3/8,4/6,6/12,50/80)
  for(i in 1:15)check(near(pf_side(a,b)$value[i],expected[i])&&pf_side(a,b)$reason[i]=='defined',paste('known formula',i))
  check(near(pf_outcomes(a,b),c(100*18/150,100*(50/80-36/70))),'known NPR outcomes')
  check(near(pf_outcomes(a,b),-pf_outcomes(b,a)),'outcome slot swap')
  for(i in 1:15)check(near(pf_side(a,b)$value[i]-pf_side(b,a)$value[i],-(pf_side(b,a)$value[i]-pf_side(a,b)$value[i])),'metric slot swap')
  for(field in pf_fields()) {
    aa<-a;aa[field]<-NA_real_;check(all(pf_side(aa,b)$reason=='missing_input')&&all(is.na(pf_side(aa,b)$value)),'missing whole bundle')
    for(v in c(-1,.5,Inf)){aa<-a;aa[field]<-v;check(all(pf_side(aa,b)$reason=='invalid_bundle'),'invalid whole bundle')}
  }
  for(z in list(c(0,0,'zero_opportunities'),c(NA,1,'missing_input'),c(2,1,'invalid_bundle'),c(1,0,'invalid_bundle'),c(1,-1,'invalid_bundle'))) {
    r<-pf_ratio(as.numeric(z[1]),as.numeric(z[2]));check(is.na(r$value)&&r$reason==z[3],'U1 unchanged')
  }
  aa<-a;bb<-b;aa[c('bpFaced','bpSaved')]<-bb[c('bpFaced','bpSaved')]<-0
  check(all(is.na(pf_side(aa,bb)$value[c(12,13)]))&&all(pf_side(aa,bb)$value[c(11,14)]==0),'undefined conversion differs from zero pressure')
  old<-new.env();sys.source('R/audit_four_factors_candidate_metrics.R',old)
  for(fn in c('side','ratio','outcomes','metrics','pair_validity','orientation'))check(identical(gsub('pf_','fc_',paste(deparse(body(get(paste0('pf_',fn)))),collapse='\n')),paste(deparse(body(old[[paste0('fc_',fn)]])),collapse='\n')),'formula implementation equals frozen source')
  h<-as.matrix(expand.grid(a=c(-1,1),b=c(-1,1),c=c(-1,1)))
  d<-pf_collinearity(h);check(d$rank==3&&near(d$vif,rep(1,3))&&near(d$ci,rep(1,3)),'orthogonal rank VIF and condition indices')
  x<-cbind(h[,1],.5*h[,1]+sqrt(.75)*h[,2]);colnames(x)<-c('a','b');d<-pf_collinearity(x)
  check(d$rank==2&&near(d$vif,rep(4/3,2))&&near(max(d$ci),sqrt(3)),'correlated known VIF and condition index')
  d<-pf_collinearity(cbind(a=h[,1],b=h[,1]));check(d$rank==1&&all(is.infinite(d$vif))&&is.infinite(max(d$ci))&&d$gate=='AUTOMATIC_FAILURE','duplicate rank failure')
  d<-pf_collinearity(cbind(a=h[,1],b=1));check(d$constant[2]&&d$gate=='AUTOMATIC_FAILURE','constant column failure')
  design<-cbind(intercept=1,a=h[,1],b=h[,2]);y<-2+3*h[,1]+4*h[,2]+2*h[,3]
  full<-pf_ols(design,y);reduced<-pf_ols(design[,c(1,3)],y);inc<-pf_increment(full$r2,reduced$r2)
  check(near(full$beta,c(2,3,4))&&near(full$r2,25/29)&&near(full$adjusted,1-(4/29)*7/5),'OLS known coefficients R2 and adjusted R2')
  check(near(inc,c(9/29,9/13)),'known semi-partial and partial R2')
  check(is.na(pf_increment(1,1)[2]),'undefined partial when reduced fits exactly')
  reject(pf_increment(.1,.2),'negative increment beyond representation error')
  check(!pf_ols(cbind(design,duplicate=h[,1]),y)$ok,'rank-deficient fit never rescued')
  yy<-rep(c(0,0,0,1,0,1,1,1),2);xx<-rep(rep(c(-1,1),each=4),2)
  f<-pf_logistic(cbind(intercept=1,x=xx),yy)
  check(f$ok&&f$converged&&!f$unstable&&near(f$beta,c(0,log(3))),'known binomial conditional coefficient')
  check(near(f$loss,c(-(3*log(.75)+log(.25))/4,.1875)),'known log loss and Brier')
  check(near(pf_losses(rep(0,4),c(0,1,0,1)),c(log(2),.25)),'balanced intercept losses')
  check(all(is.finite(pf_losses(c(-1000,1000),c(1,0))))&&near(pf_losses(c(-1000,1000),c(1,0)),c(1000,1)),'stable extreme log loss without clipping')
  f<-pf_logistic(cbind(intercept=1,x=rep(c(-1,1),each=10)),rep(c(0,1),each=10));check(f$unstable&&f$witness=='COMPLETE_SEPARATION_WITNESS','separation witness flagged without rescue')
  for(rho in c(.81,.91,.96)) {
    dd<-pf_collinearity(cbind(a=h[,1],b=rho*h[,1]+sqrt(1-rho^2)*h[,2]))
    check(dd$max_correlation>=rho-1e-12&&dd$correlation_class==if(rho>=.95)'NEAR_REDUNDANT' else if(rho>=.9)'SENSITIVITY_WARNING' else 'PRACTICAL_REVIEW','unchanged correlation classifications')
  }
  reg<-pf_registry();check(nrow(reg)==12&&identical(reg$set_id,c(sprintf('S%02d',1:9),sprintf('T%02d',1:3))),'prespecified registry order')
  for(k in 1:12)check(pf_registered(reg[k,,drop=FALSE]),'registered four-column set')
  for(id in c('M08','M09','M10','M13','M14','M15')){z<-reg[1,,drop=FALSE];z$serve_creation<-id;reject(pf_registered(z),'unregistered identity or benchmark substitution')}
  z<-reg[1,,drop=FALSE];z$second_serve_security<-'M07';reject(pf_registered(z),'M07 cannot enter primary set')
  check(identical(pf_orientation(c('1','2'),c('2','1')),c(TRUE,FALSE)),'neutral IDs before outcomes')
  reject(pf_set(c('a','b'),c('a','c'),'substitution'),'equal-count substitution fails')
  reject(pf_match_index(c('a','a'),c('a','b')),'duplicate IDs fail')
}
test_exploratory_four_factors_pilots <- function() {
  count<-0L;check<-function(ok,label){pf_need(isTRUE(ok),paste('test:',label));count<<-count+1L}
  reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=identity),'error'),label)
  trace('download.file',where=asNamespace('utils'),tracer=quote(stop('NO NETWORK')),print=FALSE)
  trace('browseURL',where=asNamespace('utils'),tracer=quote(stop('NO BROWSER')),print=FALSE)
  for(f in c('url','socketConnection'))trace(f,where=baseenv(),tracer=quote(stop('NO NETWORK')),print=FALSE)
  on.exit({untrace('download.file',where=asNamespace('utils'));untrace('browseURL',where=asNamespace('utils'));for(f in c('url','socketConnection'))untrace(f,where=baseenv())},add=TRUE)
  pf_test_math(check,reject)
  check(identical(pf_test_git(c('show','-s','--format=%H%n%s',pf_baseline)),c(pf_baseline,'Revalidate current-context pilot cohort')),'approved baseline commit')
  before<-pf_preserve();check(nrow(before)==251&&sum(startsWith(before$path,'data/'))==182,'251 protected files including 182 data files')
  protected<-setdiff(pf_test_git(c('ls-tree','-r','--name-only',pf_baseline)),pf_test_files[4:5])
  for(p in protected)check(identical(pf_test_git(c('hash-object',p)),pf_test_git(c('rev-parse',paste0(pf_baseline,':',p)))),paste('unchanged historical blob',p))
  e<-new.env();sys.source(pf_test_files[1],e);check(!length(e$pf_trace$reads)&&!length(e$pf_trace$fits)&&!length(e$pf_trace$parsed),'inert source')
  code<-paste(readLines(pf_test_files[1]),collapse='\n');check(pf_test_code(code),'static capability boundary')
  for(s in c('utils::download.file("x","y")','system("curl x")','stats::step(x)','MASS::ginv(x)','stats::confint(x)','sample(x)','relaimpo::calc.relimp(x)','utils::browseURL("x")'))reject(pf_test_code(paste(code,s)),'forbidden appended capability fails')
  for(p in c('data/raw/atp_matches_2022.csv','data/raw/wta_matches_2024.csv','data/raw/atp_matches_2025.csv','data/raw/otd/payload','../PROJECT_CONTEXT.md','docs/status.md'))reject(pf_read(p),'unapproved content path')
  for(command in c('curl','wget','python','Rscript','sh','open'))reject(pf_process(command,'x'),'forbidden subprocess')
  reject(pf_process('git',c('fetch','origin')),'no remote refresh')
  b<-new.env(parent=environment(pf_allow));b$pf_hash<-function(p)paste(rep('0',64),collapse='');allow<-pf_allow;environment(allow)<-b;reject(allow('PROJECT_CONTEXT.md'),'changed pin rejected')
  pf_trace$reads<-pf_trace$parsed<-pf_trace$calls<-pf_trace$fits<-character();pf_trace$reproduction<-FALSE
  reject(pf_models(data.frame(),data.frame()),'no extension before reproduction')
  r<-pf_build();check(pf_contract(r),'complete current release contract')
  x<-r$`match-metrics`;check(identical(as.integer(table(factor(x$cell_id,levels=pf_cells()))),c(91L,91L,49L)),'exact three-pilot counts')
  check(sum(x$count_origin=='approved_recovery_overlay')==7&&all(x$status=='normally_completed')&&!any(x$quarantined),'separate recovery and all exclusions')
  check(all(r$`reproduction-comparison`$rows==231)&&all(r$`reproduction-comparison`$result=='AGREES'),'every frozen field reproduced before extensions')
  frozen<-pf_csv('data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv');frozen<-frozen[frozen$valid_bundle,]
  for(field in c('match_id','a_original_side','a_M01_value','a_M12_reason','NPR','same_match_win')) {
    z<-x;if(is.numeric(z[[field]]))z[[field]][1]<-z[[field]][1]+.1 else z[[field]][1]<-'substitution'
    reject(pf_compare_metrics(z,frozen),paste('reproduction mutation',field))
  }
  z<-x;z$diff_M12[is.na(z$diff_M12)]<-0;reject(pf_compare_metrics(z,frozen),'structural gaps cannot become zero')
  check(sum(is.na(x$diff_M12[x$tour=='ATP']))==12&&sum(is.na(x$diff_M12[x$tour=='WTA']))==4,'structural M12 match losses')
  for(pair in list(c('M03','M09','1'),c('M04','M10','1'),c('M08','M15','1'),c('M11','M14','-1'),c('M12','M13','1')))check(max(abs(x[[paste0('diff_',pair[1])]]-as.numeric(pair[3])*x[[paste0('diff_',pair[2])]]),na.rm=TRUE)<1e-12,'observed exact algebraic class')
  check(all(pf_trace$fits%in%pf_registry()$set_id)&&setequal(pf_trace$fits,pf_registry()$set_id),'only all registered sets evaluated')
  for(g in names(pf_slices(x)))for(sens in c('full','lower_denominator_quartile')) {
    zz<-x[pf_slices(x)[[g]],];zz<-zz[pf_model_mask(zz,sens),]
    n<-r$`npr-model-summary`;n<-n[n$slice==g&n$sensitivity==sens,]
    check(length(unique(n$row_fingerprint))==1&&all(n$row_fingerprint==pf_fingerprint(zz$match_id))&&all(n$n==nrow(zz)),'identical model rows across all sets and controls')
    for(id in pf_modeled_metrics())if(sens!='full')check(all(pf_denominator_mask(x[pf_slices(x)[[g]],],id)$keep[pf_model_mask(x[pf_slices(x)[[g]],],sens)]),'common tail intersects every metric mask')
  }
  for(name in c('npr-incremental-contributions','same-match-win-summary'))check(identical(r[[name]]$row_fingerprint,r[[name]]$reduced_row_fingerprint),'full reduced exact rows')
  n<-r$`npr-model-summary`;check(all(n$tour[n$adjustment!='none']=='WTA')&&all(n$slice[n$adjustment!='none']=='tour:WTA'),'only WTA aggregate event sensitivity')
  i<-r$`npr-incremental-contributions`;check(all(i$control_retained[i$adjustment!='none']),'event control retained in every reduced fit')
  check(all(r$`same-match-win-summary`$adjustment=='none'),'no event-adjusted win models')
  check(!any(unlist(lapply(r,names))%in%c('p_value','p.value','conf_low','conf_high','weight','forecast','elo','calibration')),'no prohibited inference or forecast schema')
  check(all(pf_trace$reads%in%names(pf_pins()))&&!any(grepl('2022|2024|2025',pf_trace$reads)),'only pinned content paths')
  check(setequal(pf_trace$parsed,paste(names(pf_annual_map()),pf_annual_map(),sep=':')),'exact three annual event selections parsed')
  check(all(pf_trace$calls%in%c('git','shasum','sha256sum','pdftotext')),'local allowlisted processes only')
  old<-setNames(lapply(pe_names,function(n)pf_csv(paste0(pe_dir,'/',n,'.csv'))),pe_names)
  check(pe_test_contract(old),'unchanged Phase 2E seven-table historical contract')
  for(p in names(pe_historical_pins()))check(identical(pf_hash(p),unname(pe_historical_pins()[p])),'unchanged Phase 2E preservation pin')
  old_contract<-pf_test_git(c('show',paste0(pf_baseline,':docs/data-source-contract.md')))
  check(any(grepl('CURRENT PHASE 2E',old_contract,fixed=TRUE))&&any(grepl('Empirical successor calculations remain NOT_IMPLEMENTED',old_contract,fixed=TRUE)),'original Phase 2E current-headline preserved in Git')
  for(p in setdiff(names(pe_pins()),'docs/data-source-contract.md'))check(identical(pf_hash(p),unname(pe_pins()[p])),'unchanged Phase 2E input pin')
  oldhash<-substr(system2('shasum',c('-a','256'),input=old_contract,stdout=TRUE),1,64)
  check(identical(oldhash,unname(pe_pins()['docs/data-source-contract.md'])),'exact historical Phase 2E contract hash')
  audit<-new.env();sys.source('R/audit_four_factors_candidate_metrics.R',audit)
  check(identical(tryCatch({audit$fc_verify();NULL},error=conditionMessage),'Phase 2A BLOCKED: input hash mismatch'),'actual historical Phase 2A refusal retained')
  r2<-pf_build();check(identical(r,r2)&&identical(pf_render(r),pf_render(r2)),'independent complete reconstructions deterministic')
  paths<-pf_publish(r,current=r2);saved<-er_snapshot(paths);pf_publish(r,current=r2)
  check(identical(saved,er_snapshot(paths)),'identical release retains bytes size and mtimes')
  z<-r;z$`match-metrics`$NPR[1]<-0;reject(pf_publish(z,current=r2),'altered release withheld')
  fixture<-new.env(parent=environment(pf_publish));fixture$pf_verify<-function()stop('changed input');pub<-pf_publish;environment(pub)<-fixture
  reject(pub(r,current=r2),'changed input preserves release');check(identical(saved,er_snapshot(paths)),'prior release preserved')
  td<-tempfile('phase2f-test-');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE)
  fixture<-new.env(parent=environment(pf_publish));fixture$pf_dir<-file.path(td,'release')
  fixture$system2<-function(command,args,...)if(args[1]=='check-ignore')file.path(fixture$pf_dir,paste0(pf_names,'.csv')) else character()
  pub<-pf_publish;environment(pub)<-fixture;writes<-0L
  fixture$writeBin<-function(...){writes<<-writes+1L;if(writes==3L)stop('simulated interruption');base::writeBin(...)}
  reject(pub(r,current=r2),'interrupted staging');check(!length(list.files(td,all.files=TRUE,no..=TRUE)),'no partial release on staging failure')
  rm('writeBin',envir=fixture);fixture$file.rename<-function(...)FALSE
  reject(pub(r,current=r2),'failed atomic rename');check(!length(list.files(td,all.files=TRUE,no..=TRUE)),'no partial release on rename failure')
  dir.create(fixture$pf_dir);writeLines('preserve',file.path(fixture$pf_dir,'summary.csv'));partial<-er_snapshot(file.path(fixture$pf_dir,'summary.csv'))
  reject(pub(r,current=r2),'pre-existing partial release rejected');check(identical(partial,er_snapshot(partial$path)),'pre-existing partial bytes preserved')
  check(identical(readLines(pf_report),pf_report_text(r)),'generated report matches current reconstructed results')
  check(identical(before,pf_preserve()),'all 251 historical hashes sizes mtimes unchanged')
  data<-list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE)
  check(setequal(setdiff(data,before$path),paths)&&length(data)==196L,'exactly fourteen new data files; no old data removed')
  for(p in pf_test_files)check(!any(grepl('[ \t]+$',readLines(p)))&&identical(tail(readBin(p,'raw',n=file.info(p)$size),1),as.raw(10)),'source and document whitespace/newline')
  check(length(paths)==14&&setequal(list.files(pf_dir),paste0(pf_names,'.csv')),'exact fourteen outputs')
  check(!length(pf_test_git(c('ls-files','--','data/raw','data/pilot')))&&identical(pf_test_git(c('check-ignore','--',paths)),paths),'outputs ignored and untracked')
  links<-er_links();check(identical(links,er_links()),'Markdown local links and anchors')
  status<-paste(readLines('docs/status.md'),collapse='\n');report<-paste(readLines(pf_report),collapse='\n')
  decision<-r$decisions$value[r$decisions$id=='TERMINAL_DECISION']
  check(grepl(decision,status,fixed=TRUE)&&grepl(decision,report,fixed=TRUE)&&grepl(pf_next(decision),report,fixed=TRUE),'report status and exact next approval agree')
  changed<-union(pf_test_git(c('diff','--name-only',pf_baseline)),pf_test_git(c('ls-files','--others','--exclude-standard')))
  check(setequal(changed,pf_test_files)||(!length(changed)&&setequal(pf_test_git(c('diff-tree','--no-commit-id','--name-only','-r','HEAD')),pf_test_files)),'exact five-file scope')
  check(!length(pf_test_git(c('diff','--check',pf_baseline))),'whitespace check')
  cat(sprintf('Phase 2F: %d checks passed; terminal %s; %s\n',count,decision,paste(names(links),links,collapse=', ')));invisible(r)
}
if(sys.nframe()==0L)test_exploratory_four_factors_pilots()
