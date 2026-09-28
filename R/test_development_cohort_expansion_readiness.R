# Offline Phase 2C tests. Legacy empirical audit code is never invoked here.
source('R/plan_development_cohort_expansion.R')
er_files<-c('R/plan_development_cohort_expansion.R','R/test_development_cohort_expansion_readiness.R',ec_report_path,'docs/status.md','docs/data-source-contract.md')
er_git<-function(args) {
  ec_need(args[1]%in%c('show','rev-parse','hash-object','ls-tree','ls-files','check-ignore'),'read-only test Git')
  z<-system2('git',vapply(args,shQuote,''),stdout=TRUE)
  ec_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'test Git failed');z
}
er_hash<-function(p)strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
er_snapshot<-function(p)data.frame(path=p,sha=vapply(p,er_hash,''),size=file.info(p)$size,mtime=as.numeric(file.info(p)$mtime),row.names=NULL)
er_code_check<-function(code) {
  calls<-character()
  walk<-function(x) {
    if(missing(x))return()
    if(is.call(x)) {
      name<-if(is.symbol(x[[1]]))as.character(x[[1]]) else 'INDIRECT'
      calls<<-c(calls,name)
      if(name=='do.call')ec_need(identical(x[[2]],as.symbol('rbind')),'only fixed aggregate row-binding allowed')
      for(y in as.list(x)[-1])walk(y)
    } else if(is.expression(x)||is.pairlist(x))for(y in x)walk(y)
  }
  walk(parse(text=code,keep.source=FALSE))
  forbidden<-c('source','sys.source','eval','evalq','get','library','require','::',':::','INDIRECT','download.file','url','socketConnection','system','pipe',
    'lm','glm','nls','predict','optim','cor','cor.test','cov','svd','scale','mice','install.packages','readRDS','read.table')
  ec_need(!any(calls%in%forbidden),'no transport, modeling, metrics, raw parser or dynamic execution')
  ec_need(sum(calls=='system2')==1L&&grepl("system2(command,vapply(args,shQuote,''),stdout=TRUE)",code,fixed=TRUE),'one guarded local subprocess wrapper')
  ec_need(sum(calls=='read.csv')==1L&&grepl("read.csv(text=paste(ec_read(path),collapse='\\n')",code,fixed=TRUE),'CSV parser consumes allowlisted text only')
  TRUE
}
er_documents<-function(status,contract,report) {
  for(x in list(status,contract)) {
    headline<-strsplit(x,'\n',fixed=TRUE)[[1]][1:6]
    ec_need(any(grepl('READY_FOR_BOUNDED_EVIDENCE_PROPOSAL',headline,fixed=TRUE)),'current decision headline')
    ec_need(!any(grepl('PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION|READY_FOR_OFFLINE_RECONCILIATION',headline)),'no contradictory current headline')
    for(t in c('PAUSED_BY_USER_AFTER_PHASE_1S','PENDING_USER_APPROVAL','Q6','90%','95%','37','successor','Phase 2A'))ec_need(grepl(t,x,fixed=TRUE),paste('current boundary',t))
  }
  for(t in c('READY_FOR_BOUNDED_EVIDENCE_PROPOSAL','not an admitted or analysis-ready cohort','37 remain UNVETTED_NONPILOT',
    'No completed denominator','not READY_FOR_OFFLINE_RECONCILIATION','Phase 2A pins PROJECT_CONTEXT.md','Do not rerun it under altered inputs',
    'new audit version','never silently repin','NOT_IMPLEMENTED','95% tour-season gate','not a weighted convenience score',
    'all 18 combinations','ten-addition lower bound','No unknown becomes a pass','592','no more than 2,000 words'))
    ec_need(grepl(t,report,fixed=TRUE),paste('report boundary',t))
  TRUE
}
er_links<-function() {
  paths<-unique(c(grep('[.]md$',er_git('ls-files'),value=TRUE),list.files('docs',pattern='[.]md$',full.names=TRUE)))
  n<-a<-0L
  for(p in paths)for(h in unlist(regmatches(readLines(p,warn=FALSE),gregexpr('\\[[^][]*\\]\\([^)]+\\)',readLines(p,warn=FALSE),perl=TRUE)))) {
    target<-sub('^.*\\]\\((.*)\\)$','\\1',h);if(grepl('^[A-Za-z]+:',target))next
    bits<-strsplit(target,'#',fixed=TRUE)[[1]];dest<-if(startsWith(target,'#'))p else file.path(dirname(p),URLdecode(bits[1]))
    ec_need(file.exists(dest),paste('local link',p,target));n<-n+1L
    if(length(bits)>1L&&nzchar(bits[2])) {
      heads<-tolower(sub('^#{1,6} +','',grep('^#{1,6} ',readLines(dest,warn=FALSE),value=TRUE)))
      heads<-gsub(' ','-',gsub('[^[:alnum:] _-]','',gsub('[`*]','',heads)),fixed=TRUE)
      ec_need(URLdecode(bits[2])%in%heads,paste('anchor',p,target));a<-a+1L
    }
  }
  c(markdown=length(paths),links=n,anchors=a)
}
test_development_cohort_expansion_readiness<-function(publish=TRUE) {
  n<-0L;check<-function(ok,label){ec_need(ok,label);n<<-n+1L}
  reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=function(e)e),'error'),label)
  # Block namespace-qualified R transports as well as the planner's subprocess gate.
  trace('download.file',where=asNamespace('utils'),tracer=quote(stop('NO NETWORK')),print=FALSE)
  for(f in c('url','socketConnection'))trace(f,where=baseenv(),tracer=quote(stop('NO NETWORK')),print=FALSE)
  on.exit({untrace('download.file',where=asNamespace('utils'));for(f in c('url','socketConnection'))untrace(f,where=baseenv())},add=TRUE)
  check(identical(er_git(c('show','-s','--format=%H%n%s',ec_baseline)),c(ec_baseline,'Define Four Factors selection protocol')),'exact starting hash and message')
  baseline_paths<-er_git(c('ls-tree','-r','--name-only',ec_baseline))
  protected<-setdiff(baseline_paths,c('docs/status.md','docs/data-source-contract.md'))
  for(p in protected)check(identical(er_git(c('hash-object',p)),er_git(c('rev-parse',paste0(ec_baseline,':',p)))),paste('protected baseline file',p))
  # Reuse only the immutable prior test's literal output pins, not its test runner.
  prior<-new.env(parent=baseenv());sys.source('R/test_four_factors_definition_protocol.R',envir=prior)
  release_pins<-prior$fp_output_pins()
  for(p in names(release_pins))check(er_hash(file.path('data/pilot/four-factors-candidate-metric-feasibility',p))==release_pins[p],paste('frozen Phase 2A output',p))
  provenance<-read.csv('data/pilot/four-factors-candidate-metric-feasibility/input-provenance.csv',stringsAsFactors=FALSE)
  changed<-vapply(provenance$path,er_hash,'')!=provenance$sha256
  check(identical(provenance$path[changed],'PROJECT_CONTEXT.md'),'only historical context pin differs; current Phase 2A cannot pass')
  check(provenance$sha256[provenance$path=='PROJECT_CONTEXT.md']=='085276b9b29088afdcf4d2c0ab623eec23aa5ec00d035d8fc677fe568f860d60','historical context pin not silently replaced')
  old_data<-sort(setdiff(list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE),ec_paths()[1:7]))
  check(length(old_data)==162L,'exact preexisting data universe')
  before<-er_snapshot(c(protected,old_data))
  # Sourcing is inert: the input trace stays empty and every prior file stays unchanged.
  env<-new.env(parent=globalenv());sys.source(er_files[1],envir=env)
  check(!length(env$ec_trace$reads)&&identical(before,er_snapshot(c(protected,old_data))),'sourcing has no input reads or file effects')
  code<-paste(readLines(er_files[1]),collapse='\n');check(er_code_check(code),'production code boundary')
  for(s in c('utils::download.file("x","y")','system("curl x")','source("R/audit_four_factors_candidate_metrics.R")',
    'cor(x,y)','lm(y~x)','glm(y~x)','mice(x)','readRDS("x")','do.call("system",list("curl x"))','read.csv("data/raw/x.csv")'))
    reject(er_code_check(paste(code,s)),paste('reject forbidden call',s))
  for(path in c('data/raw/atp_matches_2021.csv','data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv',
    'data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv','../PROJECT_CONTEXT.md','/tmp/foreign.csv',paste0('data/raw/atp_',c(2022,2024,2025),'.csv')))
    reject(ec_read(path),paste('reject unapproved input',path))
  for(command in c('curl','wget','Rscript','python','sh','open'))reject(ec_process(command,'x'),paste('subprocess refused',command))
  reject(ec_process('git',c('fetch','origin')),'Git transport refused')
  reject(ec_process('shasum',c('-a','256','data/raw/atp_2025.csv')),'hash scope does not bypass forbidden path')
  reject(ec_process('git',c('show','HEAD:data/raw/atp_2025.csv')),'Git cannot bypass read allowlist')
  bad<-new.env(parent=environment(ec_read));bad$ec_pins<-function(){p<-ec_pins();p[1]<-paste(rep('0',64),collapse='');p}
  reader<-ec_read;environment(reader)<-bad;reject(reader(names(ec_pins())[1]),'altered input pin refuses before content parsing')
  input<-ec_load();r<-ec_build(input);cells<-r[[2]];packages<-r[[3]]
  check(setequal(input$reads,names(ec_pins()))&&length(input$reads)==27L,'27 exact allowed reads')
  check(identical(vapply(r,nrow,1L),setNames(c(27L,40L,3L,592L,9L,12L,16L),ec_names)),'aggregate output row contracts')
  check(nrow(cells)==40L&&!anyDuplicated(cells$cell_id)&&length(unique(cells$event_family))==10L,'40 unique cells and ten families')
  check(sum(cells$existing_pilot)==3L&&sum(cells$evidence_state=='UNVETTED_NONPILOT')==37L,'three reconciled / 37 unvetted')
  check(sum(cells$saved_source_rows)==3832L&&all(table(cells$tour,cells$season)==10L),'explicit balanced saved scope')
  check(all(is.na(cells$completed_denominator[!cells$existing_pilot]))&&all(is.na(cells$valid_bundles[!cells$existing_pilot])),'no fabricated completed denominator or validity')
  check(sum(cells$readiness=='BLOCKED_MULTIPLE')==10L&&sum(cells$readiness=='SAVED_SOURCE_ONLY_UNVETTED')==27L,'planning labels preserve evidence state')
  check(all(!cells$new_cell_admitted)&&all(cells$event_admission=='NOT_EVALUATED')&&all(cells$tour_season_95pct=='NOT_TESTED'),'no admission or gate change')
  check(all(cells$reference_status[!cells$existing_pilot]=='NO_RECONCILING_REFERENCE_IN_SAVED_MANIFESTS'),'missing references stay missing')
  check(all(cells$publication_derivative_rights=='BLOCKED_PENDING_RIGHTS_REVIEW'),'publication rights remain unresolved')
  check(all(is.na(cells$edition_city[cells$event_family=='Canada'&cells$tour=='ATP'])),'unknown Canada city never inferred from rotation')
  for(b in c('INVENTORY','STATUS','COUNTS','RIGHTS'))check(ec_classify(FALSE,TRUE,b)==paste0('BLOCKED_',b),paste('distinct readiness class',b))
  check(ec_classify(TRUE,TRUE,'RIGHTS')=='CURRENT_RECONCILED_PILOT','pilot label is historical inventory only')
  cov<-input$inputs[['data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv']]
  events<-input$inputs[['data/pilot/event-boundary-feasibility/event-cells.csv']]
  fields<-input$inputs[['data/pilot/development-2021/required-field-summary.csv']]
  for(type in c('duplicate','missing','denominator','surface','year','status','admission','source_rows')) {
    z<-cov
    if(type=='duplicate')z$cell_id[1]<-z$cell_id[2]
    if(type=='missing')z<-z[-1,]
    if(type=='denominator')z$completed_denominator[1]<-127L
    if(type=='surface')z$surface[1]<-'Clay'
    if(type=='year')z$season[1]<-2025L
    if(type=='status')z$status[1]<-'RECONCILED_PILOT'
    if(type=='admission')z$event_admission[1]<-'PASS'
    if(type=='source_rows')z$source_rows[1]<-126L
    reject(ec_validate_scope(z,events,fields),paste('reject scope mutation',type))
  }
  reject(ec_validate_scope(cov,events,fields[-which(fields$field=='w_df')[1],]),'missing structural count field')
  shuffled<-input
  for(k in c('data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv','data/pilot/event-boundary-feasibility/event-cells.csv'))shuffled$inputs[[k]]<-shuffled$inputs[[k]][40:1,]
  check(identical(ec_build(shuffled),r),'input row order cannot alter plan')
  check(identical(packages$core_cells,c(6L,12L,40L))&&identical(packages$total_cells,c(7L,13L,40L)),'core versus retained supplementary counts')
  check(identical(packages$new_unvetted,c(4L,10L,37L))&&identical(packages$core_existing,c(2L,2L,3L)),'exact additions and reuse')
  check(all(packages$core_ATP==packages$core_WTA)&&packages$core_2021[2]==6L&&packages$core_2023[2]==6L,'balanced B tour and season core')
  check(all(unlist(packages[2,c('core_hard','core_clay','core_grass')])==4L),'B crosses three surfaces')
  check(identical(ec_select(packages,cells),'B')&&identical(ec_order(),c('Named scientific gap','ATP/WTA separation',
    'Balanced season and surface contrasts','Matched families across seasons','Fewest new unvetted cells','Usable saved evidence',
    'Rights and reference burden','Informative failure','No favorable assumptions about missing evidence')),'prespecified order selects B')
  choices<-ec_anchor_options(cells);check(nrow(choices)==18L&&min(choices$new_cells)==10L,'enumerated matched-anchor minimum')
  check(all(choices$hard[choices$new_cells==10L]=='Indian Wells'),'reuse justifies hard anchor without optimistic evidence')
  check(setequal(choices$clay[choices$new_cells==10L],c('Madrid','Rome','Roland-Garros')),'clay alternatives remain honest structural tie')
  for(id in cells$cell_id[cells$selection_role=='B_PROPOSED_NEW']) {
    reduced<-cells[cells$selection_role%in%c('B_EXISTING_CORE','B_PROPOSED_NEW')&cells$cell_id!=id,]
    check(nrow(reduced)==11L&&any(table(factor(reduced$tour,levels=c('ATP','WTA')),factor(reduced$season,levels=c(2021,2023)),factor(reduced$surface,levels=c('Hard','Clay','Grass')))==0L),paste('each B addition necessary',id))
  }
  for(type in c('pooled','false_ready','no_balance','wrong_minimum')) {
    p<-packages
    if(type=='pooled')p$ATP_WTA_separate[2]<-FALSE
    if(type=='false_ready')p$entirely_offline_reconciliation[2]<-TRUE
    if(type=='no_balance')p$balanced_anchor[2]<-FALSE
    if(type=='wrong_minimum')p$new_unvetted[2]<-9L
    reject(ec_select(p,cells),paste('reject package override',type))
  }
  pre<-r[[4]];check(all(table(pre$cell_id)==16L)&&sum(pre$selected_B)==160L,'all 37 proposed cells including ten targets have every prerequisite')
  check(!any(pre$current_state=='PASS')&&all(nzchar(pre$evidence_route)),'missing evidence and routes explicit')
  check(all(r[[5]]$phase_2c_state=='DESIGN_ONLY_NOT_IMPLEMENTED'),'successor design only')
  check(r$decisions$value[1]=='READY_FOR_BOUNDED_EVIDENCE_PROPOSAL'&&r$summary$value[r$summary$measure=='decision']==r$decisions$value[1],'CSV decisions agree')
  check(all(r$decisions$value[r$decisions$id%in%c('Q6','Q8','Q9','Q10')]=='PENDING_USER_APPROVAL')&&r$decisions$value[r$decisions$id=='OTD']=='PAUSED_BY_USER_AFTER_PHASE_1S','unchanged authority')
  forbidden_columns<-c('player_a','player_b','winner_id','loser_id','match_id','NPR','correlation','coefficient','weight','prediction','elo')
  check(!any(unlist(lapply(r,names))%in%forbidden_columns),'no row-level or statistical output columns')
  check(identical(ec_build(ec_load()),r)&&identical(ec_render(r),ec_render(r)),'deterministic aggregate reconstruction and formatting')
  # Isolated initial-release and partial-release failures never touch research outputs.
  td<-tempfile('phase2c-publish-fixture-');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE)
  pe<-new.env(parent=environment(ec_publish));pe$ec_dir<-file.path(td,'output');pe$ec_report_path<-file.path(td,'report.md')
  pe$ec_paths<-function()c(file.path(pe$ec_dir,paste0(ec_names,'.csv')),pe$ec_report_path)
  pe$ec_process<-function(command,args)if(args[1]=='check-ignore')pe$ec_paths()[1:7] else character()
  copies<-0L;pe$file.copy<-function(...){copies<<-copies+1L;if(copies==3L)FALSE else base::file.copy(...)}
  pub<-ec_publish;environment(pub)<-pe
  reject(pub(r),'injected initial copy failure');check(!length(list.files(td,recursive=TRUE)),'failed initial installation leaves no partial release')
  writeLines('existing release fragment',pe$ec_report_path);fragment<-er_snapshot(pe$ec_report_path)
  reject(pub(r),'partial existing release refused');check(identical(fragment,er_snapshot(pe$ec_report_path)),'existing fragment bytes and mtime preserved')
  bad_result<-r;bad_result$decisions$value[1]<-'READY_FOR_OFFLINE_RECONCILIATION'
  reject(ec_publish(bad_result),'injected favorable output cannot be published')
  if(publish) {
    paths<-ec_publish(r);saved<-er_snapshot(paths);ec_publish(r)
    check(identical(saved,er_snapshot(paths)),'unchanged rerun preserves all output/report bytes and mtimes')
    reject(ec_publish(bad_result),'failed rerun cannot replace existing release')
    check(identical(saved,er_snapshot(paths)),'failed rerun preserves complete existing release')
    for(i in seq_along(paths))check(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),ec_render(r)[[i]]),paste('exact deterministic output',paths[i]))
    check(!length(er_git(c('ls-files','--','data/raw','data/pilot')))&&setequal(er_git(c('check-ignore','--',paths[1:7])),paths[1:7]),'ignored untracked aggregate-only release')
    text<-function(p)paste(readLines(p,warn=FALSE),collapse='\n')
    check(er_documents(text('docs/status.md'),text('docs/data-source-contract.md'),text(ec_report_path)),'current documents and generated report agree')
    reject(er_documents(sub('READY_FOR_BOUNDED_EVIDENCE_PROPOSAL','READY_FOR_OFFLINE_RECONCILIATION',text('docs/status.md'),fixed=TRUE),text('docs/data-source-contract.md'),text(ec_report_path)),'optimistic current headline rejected')
    for(p in er_files){x<-readLines(p,warn=FALSE);check(!any(grepl('[ \t]+$',x)),paste('whitespace',p));check(tail(readBin(p,'raw',n=file.info(p)$size),1)==as.raw(10),paste('newline',p))}
    links<-er_links();check(identical(links,er_links()),'deterministic local links and anchors')
  } else links<-c(markdown=NA,links=NA,anchors=NA)
  check(identical(before,er_snapshot(c(protected,old_data))),'every protected and previous data file preserves bytes size and mtime')
  check(setequal(setdiff(list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE),old_data),if(publish)ec_paths()[1:7] else intersect(ec_paths()[1:7],list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE))),'only seven approved aggregate outputs')
  message(n,' Phase 2C checks passed; ',paste(names(links),links,collapse=', '),'.')
  invisible(list(checks=n,links=links))
}
if(sys.nframe()==0L)test_development_cohort_expansion_readiness()
