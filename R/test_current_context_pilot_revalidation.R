# Offline Phase 2E tests. Historical scripts are sourced inertly for their contracts.
source('R/revalidate_current_context_pilots.R')
source('R/test_package_b_evidence_route.R')
pe_test_files<-c('R/revalidate_current_context_pilots.R','R/test_current_context_pilot_revalidation.R',
  'docs/current-context-pilot-revalidation.md','docs/status.md','docs/data-source-contract.md')
pe_test_contract <- function(r) {
  pe_need(identical(names(r),pe_names)&&identical(vapply(r[-1],nrow,1L),setNames(c(3L,27L,15L,3L,14L,13L),pe_names[-1])),'complete seven-table shape')
  p<-r$`pilot-comparison`;d<-r$decisions
  pe_need(identical(p$cell_id,pe_cells())&&all(p$status=='PASS')&&all(p$agreement=='EXACT'),'three exact pilot passes')
  for(n in c('inventory','completed','excluded','accepted','retirements','walkovers','byes','quarantined','recovered','original','unresolved_statuses','invalid_bundles')) {
    pe_need(identical(p[[paste0(n,'_count')]],p[[paste0(n,'_frozen_count')]])&&
      identical(p[[paste0(n,'_fingerprint')]],p[[paste0(n,'_frozen_fingerprint')]]),paste('exact comparison',n))
  }
  pe_need(identical(p$inventory_count,c(95L,95L,55L))&&identical(p$completed_count,c(91L,92L,49L))&&
    identical(p$accepted_count,c(91L,91L,49L)),'derived historical aggregate targets')
  pe_need(identical(p$original_count,c(91L,91L,42L))&&identical(p$recovered_count,c(0L,0L,7L))&&
    identical(p$quarantined_count,c(0L,1L,0L)),'distinct quarantine/recovery')
  pe_need(identical(p$byes_count,c(32L,32L,8L))&&identical(p$bracket_blocks_including_byes,c(127L,127L,63L)),'full main-draw bye reconciliation')
  pe_need(all(r$`rights-scope`$scope_state=='SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD')&&
    all(r$`rights-scope`$publication=='BLOCKED_PENDING_RIGHTS_REVIEW'),'local scope separate from publishing')
  pe_need(sum(d$id=='TERMINAL_DECISION')==1L&&d$value[1]=='CURRENT_CONTEXT_PILOTS_REVALIDATED','one terminal decision')
  for(id in c('PACKAGE_B','OTD','FORBIDDEN_SEASONS','METRIC_MODEL_AUTHORITY','Q6','Q8','Q9','Q10','PUBLICATION','NEXT_APPROVAL'))
    pe_need(identical(d$value[d$id==id],switch(id,PACKAGE_B='STOPPED',OTD='PAUSED_BY_USER_AFTER_PHASE_1S',
      FORBIDDEN_SEASONS='2022/2024/2025_NOT_ACCESSED',METRIC_MODEL_AUTHORITY='NONE',PUBLICATION='BLOCKED_PENDING_RIGHTS_REVIEW',
      NEXT_APPROVAL=pe_next(),'PENDING_USER_APPROVAL')),paste('unchanged authority',id))
  pe_need(!any(unlist(lapply(r,names))%in%c('match_id','source_id','winner_name','loser_name','score','NPR','elo','probability','forecast')),'aggregate schemas')
  TRUE
}
pe_test_code <- function(code) {
  calls<-character()
  walk<-function(x){if(missing(x))return();if(is.call(x)){if(is.symbol(x[[1]]))calls<<-c(calls,as.character(x[[1]])) else if(is.call(x[[1]])&&as.character(x[[1]][[1]])%in%c('::',':::'))calls<<-c(calls,as.character(x[[1]][[3]]));for(y in as.list(x)[-1])walk(y)}else if(is.expression(x)||is.pairlist(x))for(y in x)walk(y)}
  walk(parse(text=code))
  pe_need(!any(calls%in%c('lm','glm','cor','cov','predict','optim','mice','fc_metrics','fc_side','fc_outcomes','fc_cor','fc_load','download.file','url','socketConnection','browseURL','system','pipe','install.packages')),'no empirical or transport calls')
  pe_need(!any(calls%in%c('library','require','eval','evalq')),'no additional dependencies or evaluation')
  TRUE
}
test_current_context_pilot_revalidation <- function() {
  n<-0L;check<-function(ok,label){pe_need(ok,label);n<<-n+1L}
  reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=function(e)e),'error'),label)
  trace('download.file',where=asNamespace('utils'),tracer=quote(stop('NO NETWORK')),print=FALSE)
  for(f in c('url','socketConnection'))trace(f,where=baseenv(),tracer=quote(stop('NO NETWORK')),print=FALSE)
  for(f in c('lm','glm','cor','cov','predict','optim'))trace(f,where=asNamespace('stats'),tracer=quote(stop('NO EMPIRICAL CALCULATION')),print=FALSE)
  on.exit({untrace('download.file',where=asNamespace('utils'));for(f in c('url','socketConnection'))untrace(f,where=baseenv());
    for(f in c('lm','glm','cor','cov','predict','optim'))untrace(f,where=asNamespace('stats'))},add=TRUE)
  check(identical(er_git(c('show','-s','--format=%H%n%s',pe_baseline)),c(pe_baseline,'Define Package B evidence route')),'approved baseline')
  before<-pe_preserve();check(nrow(before)==241L&&sum(startsWith(before$path,'data/'))>=175L,'complete historical preservation boundary')
  protected<-setdiff(er_git(c('ls-tree','-r','--name-only',pe_baseline)),pe_test_files[4:5])
  for(p in protected)check(identical(er_git(c('hash-object',p)),er_git(c('rev-parse',paste0(pe_baseline,':',p)))),paste('prior tracked blob',p))
  e<-new.env(parent=globalenv());sys.source(pe_test_files[1],envir=e)
  check(!length(e$pe_trace$reads)&&!length(e$pe_trace$calls)&&!length(e$pe_trace$parsed)&&identical(before,pe_preserve()),'sourcing is inert')
  code<-paste(readLines(pe_test_files[1]),collapse='\n');check(pe_test_code(code),'static capability boundary')
  for(s in c('lm(y~x)','glm(y~x)','cor(x,y)','fc_outcomes(a,b)','fc_metrics(a)','download.file("x","y")','url("x")','system("curl x")','install.packages("x")','utils::download.file("x","y")','stats::lm(y~x)'))reject(pe_test_code(paste(code,s)),'reject appended forbidden capability')
  for(p in c('data/raw/atp_matches_2022.csv','data/raw/wta_matches_2024.csv','data/raw/atp_matches_2025.csv',
    'data/raw/otd/payload','../PROJECT_CONTEXT.md','/tmp/foreign','docs/status.md',
    'data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv'))reject(pe_read(p),paste('reject content path',p))
  for(command in c('curl','wget','python','Rscript','sh','open'))reject(pe_process(command,'x'),paste('reject subprocess',command))
  reject(pe_process('git',c('fetch','origin')),'no Git transport')
  reject(pe_hash('/tmp/foreign'),'hash-only reader cannot bypass allowlists')
  reject(pe_process('/tmp/shasum',c('-a','256','PROJECT_CONTEXT.md')),'foreign executable with trusted basename rejected')
  reject(pe_process('shasum',c('-a','256','/tmp/foreign')),'no hash argument bypass')
  reject(pe_process('pdftotext',c('-bbox-layout','/tmp/foreign','-')),'no PDF path bypass')
  b<-new.env(parent=environment(pe_allow));b$pe_hash<-function(p)paste(rep('0',64),collapse='');f<-pe_allow;environment(f)<-b
  reject(f('PROJECT_CONTEXT.md'),'changed pin rejected')
  b$file.exists<-function(...)FALSE;reject(f('PROJECT_CONTEXT.md'),'missing input rejected')
  check(pe_fingerprint(c('b','a'))==pe_fingerprint(c('a','b')),'order invariant full-set digest')
  reject(pe_set(c('a','b'),c('a','c'),'same-count substitution'),'equal counts unequal membership fails')
  reject(pe_set(c('a','a'),c('a','b'),'duplicate'),'duplicate membership fails')
  reject(pe_set(c('a',NA),c('a','b'),'unknown'),'unknown member never zero')
  reject(pe_match_index(c('a','b'),c('a','c')),'missing identity linkage')
  reject(pe_orientation(c('1',NA),c('2','3')),'unknown source orientation')
  reject(pe_orientation('1','1'),'same-player orientation')
  check(identical(pe_orientation(c('1','2'),c('2','1')),c(TRUE,FALSE)),'orientation swaps independently of result')
  rights<-rep('SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD',3)
  check(pe_decide(rep('PASS',3),rights)=='CURRENT_CONTEXT_PILOTS_REVALIDATED','three supported passes')
  check(pe_decide(c('PASS','FAIL','PASS'),rights)=='CURRENT_CONTEXT_PILOTS_BLOCKED','one failure blocks all')
  check(pe_decide(c('PASS','UNKNOWN','PASS'),rights)=='CURRENT_CONTEXT_PILOTS_INCONCLUSIVE','unknown prevents pass')
  check(pe_decide(rep('PASS',3),c(rights[1:2],'RIGHTS_SCOPE_CONFLICT'))=='CURRENT_CONTEXT_PILOTS_BLOCKED','rights conflict blocks')
  check(pe_decide(rep('PASS',3),c(rights[1:2],'RIGHTS_SCOPE_UNRESOLVED'))=='CURRENT_CONTEXT_PILOTS_INCONCLUSIVE','rights unknown unresolved')
  reject(pe_decide(c('PASS','PASS'),rights),'cannot drop failed pilot');reject(pe_decide(c('PASS',NA,'PASS'),rights),'unknown status cannot pass')
  pe_trace$reads<-pe_trace$calls<-pe_trace$parsed<-character()
  input<-pe_load();r<-pe_build(input);check(pe_test_contract(r),'full revalidation contract')
  for(state in c('RIGHTS_SCOPE_UNRESOLVED','RIGHTS_SCOPE_CONFLICT')) {
    gate<-new.env(parent=environment(pe_build));gate$pe_rights<-function(){z<-pe_rights();z$scope_state[1]<-state;z}
    build<-pe_build;environment(build)<-gate
    expected<-if(state=='RIGHTS_SCOPE_UNRESOLVED')'CURRENT_CONTEXT_PILOTS_INCONCLUSIVE' else 'CURRENT_CONTEXT_PILOTS_BLOCKED'
    check(startsWith(tryCatch({build(input);''},error=conditionMessage),expected),'full build preserves terminal failure classification')
  }
  check(all(pe_trace$reads%in%names(pe_pins()))&&!any(grepl('2022|2024|2025',pe_trace$reads)),'only pinned allowed content paths')
  check(setequal(pe_trace$parsed,paste(names(pe_annual_map()),pe_annual_map(),sep=':')),'only three annual pilot selections parsed')
  check(all(pe_trace$calls%in%c('git','shasum','sha256sum','pdftotext')),'only guarded local processes')
  a<-pe_adapter(input)$eligibility
  check(!any(a$valid_bundle[a$status%in%c('retirement','walkover')]),'retirement and walkover excluded')
  check(sum(a$quarantined)==1L&&!any(a$valid_bundle[a$quarantined]),'whole WTA quarantine excluded')
  m<-a[a$cell_id=='WTA|2021|Canada',];check(sum(m$valid_bundle&m$count_origin=='original_source')==42L&&
    sum(m$valid_bundle&m$count_origin=='approved_recovery_overlay')==7L,'42 original plus seven distinct recovered')
  z<-input;z$mi$overlay$field_decisions<-z$mi$overlay$field_decisions[-1,];reject(pe_adapter(z),'partial recovery rejected')
  z<-input;z$m$dispositions$status_resolved[1]<-FALSE;reject(pe_adapter(z),'unresolved Montreal status rejected')
  z<-input;z$iw$`source-matches`$statistical_bundle_quarantined[]<-FALSE;reject(pe_adapter(z),'quarantine removal rejected')
  z<-input;z$base$data[['ATP|2023']]$winner_id[1]<-NA;reject(pe_adapter(z),'missing source identity rejected')
  z<-input;z$iw$`match-reconciliation`<-z$iw$`match-reconciliation`[-1,];reject(pe_adapter(z),'partial linked inventory rejected')
  check(identical(r,pe_build(input))&&identical(pe_render(r),pe_render(pe_build(input))),'deterministic aggregate derivation')
  text<-paste(vapply(pe_render(r),rawToChar,''),collapse='\n')
  for(name in unique(c(a$source_winner_name,a$source_loser_name)))check(!grepl(name,text,fixed=TRUE),'no player names in CSVs')
  check(!grepl('(ATP|WTA):[0-9]{4}-[0-9]+:[0-9]+|[0-9]+-[0-9]+ [0-9]+-[0-9]+',text),'no match IDs or scores')
  # Complete in-memory result is bound to the independently derived current result;
  # production's default current argument repeats reconstruction, not just labels.
  paths<-pe_publish(r,current=pe_build(input));saved<-er_snapshot(paths)
  pe_publish(r,current=pe_build(input));check(identical(saved,er_snapshot(paths)),'byte-stable rerun preserves mtimes')
  z<-r;z$`pilot-comparison`$accepted_count[1]<-90L;reject(pe_publish(z,current=r),'changed result withheld')
  b<-new.env(parent=environment(pe_publish));b$pe_verify<-function()stop('changed input');pub<-pe_publish;environment(pub)<-b
  reject(pub(r,current=r),'changed input stops publication');check(identical(saved,er_snapshot(paths)),'failed run preserves prior release')
  b2<-new.env(parent=environment(pe_publish));b2$pe_preserve<-function()stop('historical file changed');pub2<-pe_publish;environment(pub2)<-b2
  reject(pub2(r,current=r),'historical change blocks release');check(identical(saved,er_snapshot(paths)),'historical failure preserves outputs')
  # Temporary-only release injection: no previous repository output is changed.
  td<-tempfile('phase2e-test-');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE)
  fixture<-new.env(parent=environment(pe_publish));fixture$pe_dir<-file.path(td,'release')
  fixture$system2<-function(command,args,...)if(args[1]=='check-ignore')file.path(fixture$pe_dir,paste0(pe_names,'.csv')) else character()
  pub<-pe_publish;environment(pub)<-fixture
  writes<-0L;fixture$writeBin<-function(...){writes<<-writes+1L;if(writes==3L)stop('simulated staging interruption');base::writeBin(...)}
  reject(pub(r,current=r),'interrupted staging');check(!length(list.files(td,all.files=TRUE,no..=TRUE)),'interruption leaves no partial release')
  rm('writeBin',envir=fixture);fixture$file.rename<-function(...)FALSE
  reject(pub(r,current=r),'initial installation failure');check(!length(list.files(td,all.files=TRUE,no..=TRUE)),'failed rename has no partial release')
  dir.create(fixture$pe_dir);writeLines('preserve',file.path(fixture$pe_dir,'summary.csv'));partial<-er_snapshot(file.path(fixture$pe_dir,'summary.csv'))
  reject(pub(r,current=r),'pre-existing partial installation blocks');check(identical(partial,er_snapshot(partial$path)),'partial pre-existing bytes preserved')
  # Read-only historical tests: no empirical entry point or old publication runner.
  oldtext<-function(p)paste(er_git(c('show',paste0(pe_baseline,':',p))),collapse='\n')
  check(pt_documents(oldtext('docs/status.md'),oldtext('docs/data-source-contract.md'),paste(readLines(pd_report),collapse='\n')),'Phase 2D historical authority contract')
  dr<-setNames(lapply(pd_files()[1:6],function(p)read.csv(p,stringsAsFactors=FALSE)),pd_names)
  check(pt_contract(dr),'Phase 2D frozen aggregate contract')
  for(p in pd_files())check(er_hash(p)==pe_pins()[[p]],paste('Phase 2D artifact pin',p))
  for(p in ec_paths())check(er_hash(p)==pd_pins()[[p]],paste('Phase 2C artifact pin',p))
  old<-new.env(parent=globalenv());sys.source('R/test_four_factors_definition_protocol.R',envir=old)
  for(p in names(old$fp_output_pins()))check(er_hash(file.path('data/pilot/four-factors-candidate-metric-feasibility',p))==old$fp_output_pins()[p],paste('Phase 2A output pin',p))
  audit<-new.env(parent=globalenv());sys.source('R/audit_four_factors_candidate_metrics.R',envir=audit)
  for(f in c('fc_load','fc_adapter','fc_metrics','fc_side','fc_outcomes','fc_cor'))assign(f,function(...)stop('NO EMPIRICAL ENTRY'),audit)
  check(identical(tryCatch({audit$fc_verify();NULL},error=conditionMessage),'Phase 2A BLOCKED: input hash mismatch'),'actual historical context refusal remains')
  for(i in seq_along(paths))check(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),pe_render(r)[[i]]),paste('serialized byte inspection',i))
  for(p in pe_test_files){lines<-readLines(p);check(!any(grepl('[ \t]+$',lines))&&identical(tail(readBin(p,'raw',n=file.info(p)$size),1),as.raw(10)),paste('whitespace/newline',p))}
  links<-er_links();check(identical(links,er_links()),'Markdown links/anchors')
  check(!length(er_git(c('ls-files','--','data/raw','data/pilot')))&&setequal(er_git(c('check-ignore','--',paths)),paths),'all seven outputs ignored/untracked')
  check(identical(before,pe_preserve()),'all 241 historical files hash size mtime unchanged')
  changed<-system2('git',c('diff','--name-only',pe_baseline),stdout=TRUE)
  check(all(changed%in%pe_test_files)&&all(er_git(c('ls-files','--others','--exclude-standard'))%in%pe_test_files),'only five authorized repository files')
  data<-list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE)
  olddata<-before$path[startsWith(before$path,'data/')&!startsWith(before$path,'data/manifests/')]
  check(setequal(setdiff(data,before$path),paths)&&length(data)==182L,'exactly seven new data files')
  message(n,' Phase 2E checks passed; ',paste(names(links),links,collapse=', '),'.')
  invisible(list(checks=n,links=links))
}
if(sys.nframe()==0L)test_current_context_pilot_revalidation()
