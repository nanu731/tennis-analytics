# Offline Phase 2D contracts. Legacy helpers are sourced inertly; no old audit runs.
source('R/plan_package_b_evidence_route.R')
source('R/test_development_cohort_expansion_readiness.R')
pt_files<-c('R/plan_package_b_evidence_route.R','R/test_package_b_evidence_route.R',pd_report,'docs/status.md','docs/data-source-contract.md')
pt_code<-function(code) {
  calls<-character()
  walk<-function(x){if(missing(x))return();if(is.call(x)){n<-if(is.symbol(x[[1]]))as.character(x[[1]]) else 'INDIRECT';calls<<-c(calls,n);if(n=='do.call')pd_need(identical(x[[2]],as.symbol('rbind')),'fixed aggregate binding only');for(y in as.list(x)[-1])walk(y)}else if(is.expression(x)||is.pairlist(x))for(y in x)walk(y)}
  walk(parse(text=code,keep.source=FALSE))
  bad<-c('source','sys.source','eval','evalq','get','library','require','::',':::','INDIRECT','download.file','url','socketConnection','system','pipe','readRDS','read.table','lm','glm','nls','predict','optim','cor','cov','svd','scale','mice','install.packages')
  pd_need(!any(calls%in%bad),'forbidden code capability')
  pd_need(sum(calls=='system2')==1L&&grepl("system2(command,vapply(args,shQuote,''),stdout=TRUE)",code,fixed=TRUE),'guarded subprocess only')
  pd_need(sum(calls=='read.csv')==1L&&grepl("read.csv(text=paste(lines,collapse='\\n')",code,fixed=TRUE),'CSV from pinned text only')
  pd_need(sum(calls=='readLines')==1L&&grepl('pd_trace$reads<-c(pd_trace$reads,p);readLines(p,warn=FALSE)',code,fixed=TRUE),'single traced content reader')
  pd_need(sum(calls=='readBin')==1L,'binary reads limited to existing output equality');TRUE
}
pt_contract<-function(r) {
  pd_need(identical(names(r),pd_names)&&identical(vapply(r,nrow,1L),setNames(c(37L,120L,12L,4L,12L,13L),pd_names)),'six aggregate table shapes')
  g<-r[[2]];s<-r[[4]];d<-r[[5]]
  pd_need(identical(sort(unique(g$cell_id)),pd_targets())&&!anyDuplicated(paste(g$cell_id,g$category)),'unique ten-by-twelve gaps')
  for(id in pd_targets())pd_need(setequal(g$category[g$cell_id==id],names(pd_categories())),'all categories per target')
  for(id in pd_targets())pd_need(setequal(unlist(strsplit(g$phase_2c_prerequisites[g$cell_id==id],';',fixed=TRUE)),unlist(pd_categories())),'all sixteen inherited prerequisites retained')
  pd_need(all(is.na(g$completed_denominator))&&!any(g$new_cell_admitted)&&all(nzchar(g$missing_evidence)),'no invented denominator or evidence')
  pd_need(sum(g$current_state=='PARTIAL_SAVED_SOURCE_ONLY')==10L&&sum(g$current_state=='BLOCKED_PENDING_RIGHTS_REVIEW')==10L&&sum(g$current_state=='NOT_SATISFIED')==100L,'no unknown promoted')
  pd_need(identical(d$value[d$id=='TERMINAL_DECISION'],pd_decide(g,r[[3]]))&&sum(d$id=='TERMINAL_DECISION')==1L,'single supported terminal decision')
  pd_need(sum(r[[3]]$selected)==1L&&r[[3]]$route_id[r[[3]]$selected]=='EXISTING_PILOT_PIVOT'&&!any(r[[3]]$executed),'one unexecuted pivot')
  pd_need(identical(s,pd_stages())&&!any(s$executed),'exact bounded stages cannot broaden')
  pd_need(all(s$new_cell_ceiling==0L)&all(s$external_request_ceiling==0L)&all(s$search_ceiling==0L)&all(s$contact_ceiling==0L)&all(s$new_metric_ceiling==0L),'zero expansion/external/metric ceilings')
  for(n in c('diagnostic_scope','prerequisites','pass_criteria','fail_criteria','unresolved_handling','stop_conditions','approval'))pd_need(all(nzchar(s[[n]])),paste('stage field',n))
  pd_need(d$value[d$id=='CELL_ADMISSION']=='NONE'&&d$value[d$id=='OTD']=='PAUSED_BY_USER_AFTER_PHASE_1S'&&all(d$value[d$id%in%c('Q6','Q8','Q9','Q10')]=='PENDING_USER_APPROVAL'),'authority retained')
  pd_need(d$value[d$id=='SUCCESSOR']=='NOT_IMPLEMENTED'&&d$value[d$id=='FORBIDDEN_SEASONS']=='2022/2024/2025_NOT_ACCESSED'&&d$value[d$id=='NEXT_APPROVAL']==pd_next(),'future scope not implemented')
  pd_need(!any(unlist(lapply(r,names))%in%c('match_id','player_a','player_b','winner_id','loser_id','NPR','coefficient','weight','prediction','elo')),'aggregate planning only');TRUE
}
pt_documents<-function(status,contract,report) {
  for(x in list(status,contract)) {
    h<-paste(strsplit(x,'\n',fixed=TRUE)[[1]][1:7],collapse='\n')
    pd_need(grepl('CURRENT PHASE 2D|Phase 2D COMPLETE',h)&&grepl('STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE',h,fixed=TRUE),'current Phase 2D headline')
    pd_need(!grepl('READY_FOR_BOUNDED_EVIDENCE_PROPOSAL|READY_TO_REQUEST_OFFLINE_EVIDENCE_EXECUTION|READY_TO_REQUEST_BOUNDED_EXTERNAL_DISCOVERY',h),'no conflicting current headline')
    for(t in c('PAUSED_BY_USER_AFTER_PHASE_1S','PENDING_USER_APPROVAL','Q6','90%','95%','37','successor','Phase 2A'))pd_need(grepl(t,x,fixed=TRUE),paste('document boundary',t))
  }
  for(t in c('STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE','not proof that all future discovery is futile','one event family per surface','Two seasons cannot establish broad temporal stability','Phase 2A BLOCKED: input hash mismatch','NOT_IMPLEMENTED','No Package B diagnostic cell is selected','zero new target cells','no automatic expansion','PENDING_USER_APPROVAL','no more than 2,000 words'))pd_need(grepl(t,report,fixed=TRUE),paste('report claim',t))
  TRUE
}
test_package_b_evidence_route<-function(publish=TRUE) {
  n<-0L;check<-function(ok,label){pd_need(ok,label);n<<-n+1L};reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=function(e)e),'error'),label)
  trace('download.file',where=asNamespace('utils'),tracer=quote(stop('NO NETWORK')),print=FALSE)
  for(f in c('url','socketConnection'))trace(f,where=baseenv(),tracer=quote(stop('NO NETWORK')),print=FALSE)
  on.exit({untrace('download.file',where=asNamespace('utils'));for(f in c('url','socketConnection'))untrace(f,where=baseenv())},add=TRUE)
  check(identical(er_git(c('show','-s','--format=%H%n%s',pd_baseline)),c(pd_baseline,'Plan development cohort expansion')),'exact baseline record')
  protected<-setdiff(er_git(c('ls-tree','-r','--name-only',pd_baseline)),pt_files[4:5])
  for(p in protected)check(identical(er_git(c('hash-object',p)),er_git(c('rev-parse',paste0(pd_baseline,':',p)))),paste('protected',p))
  old_data<-sort(setdiff(list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE),pd_files()[1:6]))
  check(length(old_data)==169L,'all 169 prior data files retained')
  before<-er_snapshot(c(protected,old_data));env<-new.env(parent=globalenv());sys.source(pt_files[1],envir=env)
  check(!length(env$pd_trace$reads)&&identical(before,er_snapshot(c(protected,old_data))),'inert sourcing')
  code<-paste(readLines(pt_files[1]),collapse='\n');check(pt_code(code),'static capability boundary')
  for(m in c('read.csv("data/raw/x.csv")','readLines("data/raw/x.csv")','readBin("data/raw/x.csv","raw")','utils::download.file("x","y")','system("curl x")','source("legacy.R")','do.call("system",list("x"))','lm(y~x)','cor(x,y)','mice(x)','get("url")'))reject(pt_code(paste(code,m)),paste('reject forbidden call',m))
  for(p in c('data/raw/atp_matches_2021.csv','data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv',paste0('data/raw/atp_',c(2022,2024,2025),'.csv'),'../PROJECT_CONTEXT.md','/tmp/foreign','docs/status.md'))reject(pd_read(p),paste('reject foreign input',p))
  for(command in c('curl','wget','python','sh','Rscript','open'))reject(pd_process(command,'x'),paste('reject process',command))
  reject(pd_process('git',c('fetch','origin')),'no git transport');reject(pd_process('shasum',c('-a','256','data/raw/atp_2025.csv')),'no hash path bypass')
  bad<-new.env(parent=environment(pd_read));bad$pd_pins<-function(){z<-pd_pins();z[1]<-paste(rep('0',64),collapse='');z};reader<-pd_read;environment(reader)<-bad
  reject(reader(names(pd_pins())[1]),'changed input pin')
  bad2<-new.env(parent=environment(pd_allow));bad2$file.exists<-function(...)FALSE;allow<-pd_allow;environment(allow)<-bad2
  reject(allow(names(pd_pins())[1]),'missing input rejected')
  x<-pd_load();check(identical(pd_trace$reads,names(pd_pins()))&&length(pd_trace$reads)==37L,'exact 37 content reads')
  r<-pd_build(x);check(pt_contract(r),'full planning contract')
  check(identical(pd_order(),c('Permissible use and rights','Inventory identity status and count validity','Reproducibility and provenance','Ten-cell coverage','Informative failure','Lowest necessary burden')),'ordered criteria no convenience score')
  for(field in c('completed_denominator','valid_bundles','new_cell_admitted','reference_status','readiness')){
    z<-x;p<-'data/pilot/development-cohort-expansion-readiness/cell-readiness.csv';i<-which(z[[p]]$selection_role=='B_PROPOSED_NEW')[1]
    z[[p]][[field]][i]<-switch(field,completed_denominator=95L,valid_bundles=95L,new_cell_admitted=TRUE,reference_status='PASS',readiness='CURRENT_RECONCILED_PILOT')
    reject(pd_build(z),paste('reject optimistic inherited',field))
  }
  for(field in c('current_state','missing_evidence','completed_denominator','new_cell_admitted')){
    z<-r;z[[2]][[field]][1]<-switch(field,current_state='PASS',missing_evidence='',completed_denominator=95L,new_cell_admitted=TRUE)
    reject(pt_contract(z),paste('reject favorable gap',field))}
  for(field in c('assessment','rights','coverage','selected')){z<-r;z[[3]][[field]][3]<-if(field=='selected')TRUE else 'PASS';reject(pt_contract(z),paste('rights cannot be offset',field))}
  for(field in c('cell_ceiling','new_cell_ceiling','external_request_ceiling','search_ceiling','contact_ceiling','new_metric_ceiling')){z<-r;z[[4]][[field]][2]<-10L;reject(pt_contract(z),paste('no stage broadening',field))}
  for(field in c('pass_criteria','fail_criteria','unresolved_handling','stop_conditions')){z<-r;z[[4]][[field]][2]<-'';reject(pt_contract(z),paste('stage cannot omit',field))}
  for(id in c('OTD','Q6','Q8','Q9','Q10','SUCCESSOR','CELL_ADMISSION','FORBIDDEN_SEASONS','NEXT_APPROVAL')){z<-r;z[[5]]$value[z[[5]]$id==id]<-'APPROVED';reject(pt_contract(z),paste('reject unauthorized',id))}
  z<-r;z[[5]]$value[1]<-'READY_TO_REQUEST_BOUNDED_EXTERNAL_DISCOVERY';reject(pt_contract(z),'reject unsupported external route')
  z<-r;z[[5]]<-rbind(z[[5]],z[[5]][1,]);reject(pt_contract(z),'exactly one terminal decision')
  check(identical(r,pd_build(pd_load()))&&identical(pd_render(r),pd_render(pd_build(x))),'deterministic build')
  # A complete failure injection stays inside temporary fixtures.
  td<-tempfile('phase2d-fixture-');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE)
  pe<-new.env(parent=environment(pd_publish));pe$pd_dir<-file.path(td,'outputs');pe$pd_report<-file.path(td,'report.md')
  pe$pd_files<-function()c(file.path(pe$pd_dir,paste0(pd_names,'.csv')),pe$pd_report)
  pe$pd_process<-function(command,args)if(args[1]=='check-ignore')pe$pd_files()[1:6] else character()
  copies<-0L;pe$file.copy<-function(...){copies<<-copies+1L;if(copies==3L)FALSE else base::file.copy(...)}
  pub<-pd_publish;environment(pub)<-pe
  reject(pub(r),'initial installation failure');check(!length(list.files(td,recursive=TRUE)),'no partial failed release')
  writeLines('preserve existing',pe$pd_report);saved<-er_snapshot(pe$pd_report);reject(pub(r),'partial release fails closed');check(identical(saved,er_snapshot(pe$pd_report)),'existing fragment preserved')
  # Historical empirical release checked by immutable pins, never recalculated.
  prior<-new.env(parent=baseenv());sys.source('R/test_four_factors_definition_protocol.R',envir=prior)
  for(p in names(prior$fp_output_pins()))check(er_hash(file.path('data/pilot/four-factors-candidate-metric-feasibility',p))==prior$fp_output_pins()[p],paste('Phase 2A frozen output',p))
  provenance<-read.csv('data/pilot/four-factors-candidate-metric-feasibility/input-provenance.csv',stringsAsFactors=FALSE)
  check(identical(provenance$path[vapply(provenance$path,er_hash,'')!=provenance$sha256],'PROJECT_CONTEXT.md'),'sole historical input mismatch preserved')
  audit<-new.env(parent=globalenv());sys.source('R/audit_four_factors_candidate_metrics.R',envir=audit)
  refusal<-tryCatch({audit$fc_verify();NULL},error=conditionMessage)
  check(identical(refusal,'Phase 2A BLOCKED: input hash mismatch'),'actual historical verifier refuses current context; no empirical analysis invoked')
  for(p in ec_paths())check(er_hash(p)==pd_pins()[p],paste('Phase 2C frozen output/report',p))
  oldtext<-function(p)paste(er_git(c('show',paste0(pd_baseline,':',p))),collapse='\n')
  check(er_documents(oldtext('docs/status.md'),oldtext('docs/data-source-contract.md'),paste(readLines(ec_report_path),collapse='\n')),'unchanged historical Phase 2C authority contract')
  if(publish){
    paths<-pd_publish(r);saved<-er_snapshot(paths);pd_publish(r);check(identical(saved,er_snapshot(paths)),'unchanged rerun bytes and mtimes')
    z<-r;z[[5]]$value[1]<-'READY_TO_REQUEST_OFFLINE_EVIDENCE_EXECUTION';reject(pd_publish(z),'favorable release rejected');check(identical(saved,er_snapshot(paths)),'failed result preserves existing release')
    be<-new.env(parent=environment(pd_publish));be$pd_load<-function()stop('changed or missing input');pub2<-pd_publish;environment(pub2)<-be
    reject(pub2(r),'input failure before writes');check(identical(saved,er_snapshot(paths)),'input failure preserves release')
    for(i in seq_along(paths))check(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),pd_render(r)[[i]]),paste('output bytes',paths[i]))
    for(i in 1:6)check(identical(read.csv(paths[i],stringsAsFactors=FALSE,na.strings='NA'),read.csv(text=rawToChar(pd_render(r)[[i]]),stringsAsFactors=FALSE,na.strings='NA')),paste('CSV readback',i))
    text<-function(p)paste(readLines(p),collapse='\n')
    check(pt_documents(text('docs/status.md'),text('docs/data-source-contract.md'),text(pd_report)),'current documentation')
    reject(pt_documents(sub('STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE','READY_TO_REQUEST_BOUNDED_EXTERNAL_DISCOVERY',text('docs/status.md'),fixed=TRUE),text('docs/data-source-contract.md'),text(pd_report)),'optimistic headline rejected')
    for(p in pt_files){lines<-readLines(p);check(!any(grepl('[ \t]+$',lines))&&identical(tail(readBin(p,'raw',n=file.info(p)$size),1),as.raw(10)),paste('whitespace newline',p))}
    links<-er_links();check(identical(links,er_links()),'links and anchors stable')
    check(!length(er_git(c('ls-files','--','data/raw','data/pilot')))&&setequal(er_git(c('check-ignore','--',paths[1:6])),paths[1:6]),'six outputs ignored untracked')
  }else links<-c(markdown=NA,links=NA,anchors=NA)
  check(identical(before,er_snapshot(c(protected,old_data))),'all protected and prior data bytes size mtime')
  # This fixed read-only invocation adds no transport or arbitrary subprocess scope.
  changed<-system2('git',c('diff','--name-only',pd_baseline),stdout=TRUE)
  check(is.null(attr(changed,'status')),'read-only file scope check succeeded')
  check(all(changed%in%pt_files),'exact permitted tracked changes')
  untracked<-er_git(c('ls-files','--others','--exclude-standard'))
  check(all(untracked%in%pt_files),'no accidental untracked repository files')
  check(setequal(setdiff(list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE),old_data),if(publish)pd_files()[1:6] else intersect(pd_files()[1:6],list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE))),'only six new aggregate data files')
  message(n,' Phase 2D checks passed; ',paste(names(links),links,collapse=', '),'.')
  invisible(list(checks=n,links=links))
}
if(sys.nframe()==0L)test_package_b_evidence_route()
