# Phase 2D: saved aggregate planning only. Sourcing performs no reads or writes.
pd_baseline <- 'f759edb80a775f987e61fd38dddfacab238e5f28'
pd_dir <- 'data/pilot/package-b-evidence-route-proposal'
pd_report <- 'docs/package-b-evidence-route-proposal.md'
pd_names <- c('input-provenance','cell-evidence-gaps','route-assessment','staged-execution-plan','decisions','summary')
pd_files <- function() c(file.path(pd_dir,paste0(pd_names,'.csv')),pd_report)
pd_need <- function(ok,why) if(!isTRUE(ok))stop(paste('Phase 2D BLOCKED:',why),call.=FALSE)
pd_trace <- new.env(parent=emptyenv());pd_trace$reads<-character()
pd_pins <- function()
c(.gitignore = "90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217",
AGENTS.md = "67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`data/pilot/development-2021/montreal-completed-match-coverage/summary.csv` = "288355b44a1a77c52a9674366b247962728c4736bb3026b1af53593adb32170b",
`data/pilot/development-2021/montreal-inventory/summary.csv` = "ae274408a0df303573d4f0273464e009fda670b4d95fc5e9cc3a252d141ddf56",
`data/pilot/development-2021/required-field-summary.csv` = "0e26a06d58a3d87e73fcd60fda19c01df1dbdf01f797657ff53c56d2d424804d",
`data/pilot/development-cohort-expansion-readiness/cell-prerequisites.csv` = "34a869ffde2e817af2f1717eae3f2ec0119959c5c6f6aa1c4680def79dd3b819",
`data/pilot/development-cohort-expansion-readiness/cell-readiness.csv` = "66ed229e23335514fa8d1abcacde62bbc033fc53cf954004d84833f5630c0d4f",
`data/pilot/development-cohort-expansion-readiness/current-context-requirements.csv` = "28a724f58dacea1f3131e21ea7d50a021a27093858637e9e30448dfa7842e425",
`data/pilot/development-cohort-expansion-readiness/decisions.csv` = "f3736b931504d99ceabcd80e82e8b148bbf6fb0fcd2deb2e62d79e080599e91c",
`data/pilot/development-cohort-expansion-readiness/input-provenance.csv` = "3e9cd0c56fb298a53e2f2cd29eea64c61f75466c7381d3af7bf54488e7e56c93",
`data/pilot/development-cohort-expansion-readiness/package-comparison.csv` = "dbc5d6438c96ab5204a117dd8b5c425025975d3e2cc88c8df6642edb4a9044fb",
`data/pilot/development-cohort-expansion-readiness/summary.csv` = "bea133007f852c9232375f39a085893b5219bff685e86e5089d02154dc0b013b",
`data/pilot/event-boundary-feasibility/event-cells.csv` = "76358755c89aeacf79ae452ad606eca755d52cab2bc3954c3ef0f58e64c12ae8",
`data/pilot/event-boundary-feasibility/source-candidates.csv` = "9229340b953dec55196a97c95ec0e807982ca1aaa434fb3533125a1d777062bd",
`data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv` = "7ea6feb58a428ab45bfabcc2a5c3a87eef0485f92062fa1e1cac4b4cade5d982",
`data/pilot/inventory/inventory-summary.csv` = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
`docs/2021-annual-source-audit.md` = "22ffb45943267d77b81bb69f67b65cd3650a4d7f4f83ae0658e2fd89c6cab9e5",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/development-cohort-expansion-readiness.md` = "dd219cdac7b993f94f80e98f71f64cd0ab16dae675af039d1d5c382b35d1ea10",
`docs/event-boundary-feasibility.md` = "19685452eb8af4d587ebb7c816f56748544c3037bae797dc81fe7344ce7f8b9b",
`docs/four-factors-candidate-metric-feasibility.md` = "413c4d67fb24f6e84faffe98008a65fa85cc5a5c13be60c9cd6e0d61af22eb59",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/indian-wells-inventory-reconciliation.md` = "8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e",
`docs/post-otd-analytical-path.md` = "14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
`docs/tennis-chronology-path-decision-brief.md` = "5eb5d3940ba444110679ba57e320d2b75f139f67e5528ef1917e9172912ed93e",
`docs/wta-2021-montreal-chronology-stage-a.md` = "842f603c0a1075ca58395f89a805b981a6f07fdda3f043de95ee169d0c62db12",
`docs/wta-2021-montreal-completed-match-coverage.md` = "168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8",
`docs/wta-2021-montreal-inventory-reconciliation.md` = "6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4",
`docs/wta-2021-montreal-recovery-verification.md` = "d15fd1dd7e43bc6e0740e1f9395b8c5c5d8d1bca204318df48c4f0ad2281f151",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
PROJECT_CONTEXT.md = "865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1"
)
pd_process <- function(command,args) {
  hash<-identical(command,'shasum')&&length(args)==3L&&identical(args[1:2],c('-a','256'))&&args[3]%in%names(pd_pins())
  git<-identical(command,'git')&&(identical(args,c('merge-base',pd_baseline,'HEAD'))||identical(args,c('ls-files','--','data/raw','data/pilot'))||identical(args,c('check-ignore','--',pd_files()[1:6])))
  pd_need(hash||git,'unapproved subprocess')
  z<-system2(command,vapply(args,shQuote,''),stdout=TRUE)
  pd_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'local verification failed');z
}
pd_allow <- function(p) {
  pd_need(is.character(p)&&length(p)==1L&&!is.na(p)&&p%in%names(pd_pins()),'unapproved input')
  pd_need(!grepl('2022|2024|2025|^data/raw/|match-metrics|eligibility-audit|player-event',p),'row-level or forbidden-season path')
  pd_need(file.exists(p)&&normalizePath(p)==file.path(normalizePath('.'),p),'missing or redirected input');TRUE
}
pd_read <- function(p) {
  pd_allow(p)
  hash<-strsplit(pd_process('shasum',c('-a','256',p)),' ')[[1]][1]
  pd_need(identical(hash,unname(pd_pins()[p])),'changed input')
  pd_trace$reads<-c(pd_trace$reads,p);readLines(p,warn=FALSE)
}
pd_load <- function() {
  pd_need(identical(pd_process('git',c('merge-base',pd_baseline,'HEAD')),pd_baseline),'baseline ancestry')
  pd_trace$reads<-character();x<-list()
  for(p in names(pd_pins())) {
    lines<-pd_read(p)
    x[[p]]<-if(endsWith(p,'.csv'))read.csv(text=paste(lines,collapse='\n'),stringsAsFactors=FALSE,na.strings=c('NA',''),check.names=FALSE) else lines
  }
  pd_need(identical(pd_trace$reads,names(pd_pins())),'exact read trace');x
}
pd_prior <- function(x,name)x[[paste0('data/pilot/development-cohort-expansion-readiness/',name,'.csv')]]
pd_categories <- function() list(
  MAIN_DRAW_INVENTORY=c('INVENTORY','MAIN_DRAW_SINGLES'),NONBYE_DENOMINATOR='NONBYE_DENOMINATOR',IDENTITY_LINKAGE='IDENTITY',
  MATCH_STATUS='STATUS',CROSS_REFERENCE_CONFLICTS='CONFLICTS',STATISTICAL_BUNDLE='BUNDLE_VALIDITY',COUNT_UNIVERSE='COUNT_UNIVERSE',
  QUARANTINE_RECOVERY=c('QUARANTINE','RECOVERY_IF_NEEDED'),PROVENANCE='PROVENANCE',LOCAL_RIGHTS='LOCAL_RIGHTS',
  PUBLICATION_RIGHTS='PUBLICATION_RIGHTS',SUCCESSOR_AUTHORITY=c('SUCCESSOR_PIN','COVERAGE_GATES','USER_AUTHORITY'))
pd_targets <- function()sort(c(paste(c('ATP','WTA'),2021,'Indian Wells',sep='|'),as.vector(outer(as.vector(outer(c('ATP','WTA'),c(2021,2023),paste,sep='|')),c('Roland-Garros','Wimbledon'),paste,sep='|'))))
pd_order <- function()c('Permissible use and rights','Inventory identity status and count validity','Reproducibility and provenance','Ten-cell coverage','Informative failure','Lowest necessary burden')
pd_next <- function()paste('Do you approve stopping Package B expansion under the current evidence and implementing only a new versioned current-context eligibility/count revalidation stage for ATP and WTA Indian Wells 2023 and WTA Montreal 2021,',
  'using their previously approved saved inputs, a new ignored data/pilot/current-context-pilot-revalidation/ output location, current context/protocol pins, exact membership/exclusion/count comparisons and preservation of every historical Phase 2A output,',
  'with at most those three pilots and no new cells, new metric or NPR calculation, factor selection, model, imputation, Elo, history, forecast, network, search, acquisition, contact, OTD work, 2022/2024/2025 access, publication or portfolio change, stopping on any unexplained evidence or rights-scope discrepancy?')
pd_validate <- function(x) {
  c<-pd_prior(x,'cell-readiness');p<-pd_prior(x,'cell-prerequisites');d<-pd_prior(x,'decisions')
  pd_need(nrow(c)==40L&&!anyDuplicated(c$cell_id)&&sum(c$saved_source_rows)==3832L,'40-cell saved universe')
  pd_need(sum(c$existing_pilot)==3L&&sum(c$evidence_state=='UNVETTED_NONPILOT')==37L,'three pilots and 37 unvetted')
  t<-c[c$selection_role=='B_PROPOSED_NEW',]
  pd_need(nrow(t)==10L&&identical(sort(t$cell_id),pd_targets())&&all(t$readiness=='BLOCKED_MULTIPLE'),'exact ten targets')
  pd_need(all(is.na(t$completed_denominator))&&all(is.na(t$valid_bundles))&&!any(c$new_cell_admitted),'unknown denominators and no admission')
  pd_need(all(t$reference_status=='NO_RECONCILING_REFERENCE_IN_SAVED_MANIFESTS')&&all(t$inventory_status=='NOT_TESTED')&&all(t$count_validation_status=='NOT_TESTED'),'target evidence missing')
  pd_need(nrow(p)==592L&&!anyDuplicated(paste(p$cell_id,p$prerequisite)),'inherited prerequisite universe')
  for(id in pd_targets())pd_need(setequal(p$prerequisite[p$cell_id==id],unlist(pd_categories())),'all sixteen prerequisites mapped')
  pd_need(identical(d$value[d$id=='PHASE_2C'],'READY_FOR_BOUNDED_EVIDENCE_PROPOSAL')&&all(d$value[d$id%in%c('Q6','Q8','Q9','Q10')]=='PENDING_USER_APPROVAL')&&d$value[d$id=='OTD']=='PAUSED_BY_USER_AFTER_PHASE_1S','historical authority')
  text<-function(p)paste(x[[p]],collapse='\n')
  pd_need(grepl('PROHIBITED',text('docs/wta-2021-montreal-chronology-stage-a.md'),fixed=TRUE)&&grepl('AMBIGUOUS_STOP_REQUIRED',text('docs/wta-2021-montreal-chronology-stage-a.md'),fixed=TRUE),'saved WTA rights stop')
  pd_need(grepl('outside the selected 2021',text('docs/tennis-chronology-path-decision-brief.md'),fixed=TRUE),'IBM scope limitation')
  m<-x[['data/manifests/inventory-reference-files.csv']]
  pd_need(nrow(m)==8L&&sum(m$acquisition_status=='unavailable')==2L&&all(grepl('2023',m$url)),'saved inventory manifests are pilot evidence only')
  t[order(t$cell_id),]
}
pd_gaps <- function(x) {
  targets<-pd_validate(x);p<-pd_prior(x,'cell-prerequisites');rows<-list()
  for(id in targets$cell_id)for(category in names(pd_categories())) {
    q<-p[p$cell_id==id&p$prerequisite%in%pd_categories()[[category]],]
    state<-if(category=='PROVENANCE')'PARTIAL_SAVED_SOURCE_ONLY' else if(category=='PUBLICATION_RIGHTS')'BLOCKED_PENDING_RIGHTS_REVIEW' else 'NOT_SATISFIED'
    rows[[length(rows)+1L]]<-data.frame(cell_id=id,category=category,phase_2c_prerequisites=paste(q$prerequisite,collapse=';'),
      saved_basis=paste(unique(q$saved_basis),collapse='; '),missing_evidence=paste(unique(q$required_evidence),collapse='; '),current_state=state,
      inherited_states=paste(unique(q$current_state),collapse=';'),rights_state=if(startsWith(id,'WTA'))'ARCHIVE_CONDITIONAL;WTA_PROGRAMMATIC_STOP;OTHER_REFERENCE_RIGHTS_UNKNOWN' else 'ARCHIVE_CONDITIONAL;ATP_REFERENCE_RIGHTS_UNKNOWN',
      evidence_route=paste(unique(q$evidence_route),collapse=';'),required_future_authority=paste(unique(q$required_stage),collapse=';'),
      disposition='TARGET_STOPPED_NO_EXECUTION_APPROVAL',completed_denominator=NA_integer_,new_cell_admitted=FALSE,stringsAsFactors=FALSE)
  }
  do.call(rbind,rows)
}
pd_routes <- function() {
  # These assessments report saved scope and a bounded judgment, not live provider findings.
  rows<-list(
    c('SAVED_TARGET_AUDIT','OFFLINE','INSUFFICIENT','Archive conditions inherited; new reference rights unknown','No target references; source rows cannot prove inventory/status','Source manifest pins exist; reference chain missing','10 source cells; 0 reconciled target cells','Cannot resolve absent evidence by reparsing annuals','Rejected as next execution; repeats known gaps'),
    c('WTA_OFFICIAL','MISSING_REFERENCE','BLOCKED_RIGHTS','Saved programmatic access PROHIBITED; retention ambiguous','Pilot HTML/PDF once supported status but cannot license new scope','Prior reference manifests; no target reference pin','5 WTA targets; none supported locally','Known rights stop before a new request','Do not retry terms or use another host as a workaround'),
    c('ATP_OFFICIAL','BOUNDED_DISCOVERY_CANDIDATE','UNRESOLVED_NOT_SELECTED','ATP/ProTennisLive access extraction retention unresolved','2023 IW precedent is useful; does not establish 2021 or Slam reference availability','Two direct ATP 403s; browser text not original response bytes','5 ATP targets only; cannot resolve mandatory WTA gate','Rights review could fail but no affirmative route is saved','Not a package-enabling diagnostic under rights-first order'),
    c('ORGANIZER_OR_ARCHIVE','BOUNDED_DISCOVERY_CANDIDATE','UNRESOLVED_NOT_SELECTED','New host or old capture does not grant upstream rights','No exact target document or archive capture is established','Only source classes named in historical brief; no immutable target','Ten targets potentially relevant; zero verified coverage','A general search has no evidence-backed success target here','No invented organizer endpoint; do not extend speculative discovery'),
    c('TENNIS_DATA_CO_UK','BOUNDED_DISCOVERY_CANDIDATE','UNRESOLVED_NOT_SELECTED','No verified primary terms or research/retention grant','Historical results/odds claim; status completeness and count suitability unknown','Prior timeout/TLS failures; lineage unverified','ATP/WTA 2021 claimed broadly, no target inventory proof','Another documentation probe may repeat known uncertainty','Not enough saved basis to choose over the governed stop'),
    c('TENNISDATA_APP','PERMISSION_REQUIRED','BLOCKED_RIGHTS','Saved download invitation conflicts with formal automation/copying terms','Raw count and target status availability unverified','No permission grant or target payload pin','Broad 2021 onward claim only','Written permission and recipient work would be separate','No contact, draft, alternate endpoint or permission assumption'),
    c('SLAM_PBP_AND_MCP','SUPPLEMENTARY','REJECTED_BURDEN','Conditional inherited licenses; origin/reference rights still matter','Selective charting not complete inventory; Slam FO extraction absent from 2023 onward','Snapshot/coverage and independence unresolved for targets','Not complete ten-cell evidence; Indian Wells not a Slam','Could falsify tactical ideas later, not supply missing full inventories now','Reject point-level expansion and duplicate-origin agreement as independent proof'),
    c('IBM_HISTORICAL','OUT_OF_SCOPE','REJECTED_COVERAGE','Apache scope only for covered historical files and notices','Saved release concerns 2014/2015 points and older sets, not target years','README year ambiguity remains; no modern release verified','0 verified 2021/2023 target coverage','Existing documentation already identifies period mismatch','No request and no panel change'),
    c('ACADEMIC_OR_TRACKING','PERMISSION_REQUIRED','REJECTED_BURDEN','Academic application or proprietary/media rights not granted','Academic index starts 2023; tracking clips not full aggregate reference','No project access grant or target artifact','Does not support the 2021 half of Package B as documented','High permission/schema burden before core validity evidence','Do not divert into applications tracking or new dependencies'),
    c('OTD','PAUSED','BLOCKED_USER_PAUSE','PAUSED_BY_USER_AFTER_PHASE_1S; access/retention unresolved','Historical schema lacks nine service counts; current payload not reviewed','Upstream overlap and immutable season isolation unresolved','No verified target evidence release','Pause is binding; no unused-slot reuse','No OTD access search draft contact or substitute resource'),
    c('POLICY_ONLY','USER_DECISION','INSUFFICIENT','A user decision is not a provider grant','Policy cannot create unknown statuses counts or denominators','Successor version can preserve evidence, not create new references','0 new targets admitted','Rules alone cannot close absent observations','No relaxed gates or transplant of event-specific recovery decisions'),
    c('EXISTING_PILOT_PIVOT','OFFLINE_PIVOT','SELECTED_PROPOSAL_ONLY','Use only inherited scoped local audit authority; stop on scope discrepancy; publication blocked','Three reconciled inventories and frozen count audits already exist','New version and current pins; old release must remain untouched','0 target additions; 3 existing pilots only','Exact old/new membership exclusion and count comparison can fail informatively','Request only bounded current-context eligibility/count revalidation; no new metrics')
  )
  z<-as.data.frame(do.call(rbind,rows),stringsAsFactors=FALSE)
  names(z)<-c('route_id','route_class','assessment','rights','validity','provenance','coverage','informative_failure','burden_and_disposition')
  z$selected<-z$route_id=='EXISTING_PILOT_PIVOT';z$executed<-FALSE;z
}
pd_decide <- function(gaps,routes) {
  pd_need(nrow(gaps)==120L&&all(gaps$current_state%in%c('NOT_SATISFIED','PARTIAL_SAVED_SOURCE_ONLY','BLOCKED_PENDING_RIGHTS_REVIEW'))&&!any(gaps$new_cell_admitted),'unknowns may not become a pass')
  pd_need(identical(routes,pd_routes()),'route assessment changed without new version/evidence')
  'STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE'
}
pd_stages <- function() {
  z<-data.frame(stage=c('D0_STOP_PACKAGE_B','P1_PILOT_REVALIDATION','P2_REVIEW_ONLY','B_REOPENING_NOT_REQUESTED'),
    diagnostic_scope=c('All ten proposed additions remain unvetted','ATP Indian Wells 2023; WTA Indian Wells 2023; WTA Montreal 2021','Same three pilots; no expansion','NONE; no later Package B cell order authorized or recommended'),
    future_action=c('Record terminal stop; no external discovery requested','Implement one versioned eligibility/count revalidation stage in data/pilot/current-context-pilot-revalidation/','Review discrepancies and whether later descriptive work is justified; no automatic next computation','Reopening requires materially new supplied rights/reference evidence and a separate user decision'),
    prerequisites=c('Pinned Phase 2C gaps and saved rights/source assessments','Explicit approval; inherited input/provenance and scoped-use checks; current context and Phase 2B pins; new output location','P1 completed or truthful blocked report; all historical outputs preserved','Evidence change must address rights, full inventory, status, counts and provenance; ATP-only success is insufficient'),
    pass_criteria=c('No viable package-wide route supported under ordered review; record inference limits','Exact membership exclusions original/recovered counts and quarantine compare to frozen pilot evidence; report descriptive-only boundary','User reviews named result and limitations; no model admission follows','Not evaluated in this task; no automatic revival'),
    fail_criteria=c('Do not conceal a newly supplied affirmative route; stop planner on changed pins','Any changed source, unsupported identity/status/count, altered quarantine, scope or unexplained comparison mismatch','Any recommendation treating pilot agreement as generalization or final factors','Absent rights or validity evidence cannot be substituted by high coverage'),
    unresolved_handling=c('Unknown is not prohibited, available, or passed; stop current route, not all future possibilities','Preserve missing evidence and prior files; withhold revalidation pass; no repair or source substitution','Record INCONCLUSIVE or BLOCKED; no repeated unrestricted planning','Keep Package B stopped; no search ladder'),
    stop_conditions=c('Zero access/search/contact/acquisition','Stop whole proposed pilot release on failed prerequisite; never silently drop a pilot','Stop at review; later analysis needs separate authority','No requests or reconciliation until an independently approved evidence change'),
    approval=c('Phase 2D proposal only','PENDING_USER_APPROVAL','Separate future analysis approval if warranted','NOT_REQUESTED'),
    cell_ceiling=c(10L,3L,3L,0L),new_cell_ceiling=0L,external_request_ceiling=0L,search_ceiling=0L,contact_ceiling=0L,
    new_metric_ceiling=0L,executed=FALSE,stringsAsFactors=FALSE)
  z
}
pd_build <- function(x) {
  gaps<-pd_gaps(x);routes<-pd_routes();decision<-pd_decide(gaps,routes)
  provenance<-data.frame(path=names(pd_pins()),role=ifelse(grepl('development-cohort-expansion-readiness',names(pd_pins())),'FROZEN_PHASE_2C_PLANNING','SAVED_AGGREGATE_MANIFEST_OR_DOCUMENT'),sha256=unname(pd_pins()),bytes=file.info(names(pd_pins()))$size,stringsAsFactors=FALSE)
  decisions<-data.frame(id=c('TERMINAL_DECISION','SELECTED_ROUTE','FIRST_DIAGNOSTIC','CELL_ADMISSION','OTD','FORBIDDEN_SEASONS','Q6','Q8','Q9','Q10','SUCCESSOR','NEXT_APPROVAL'),
    value=c(decision,'EXISTING_PILOT_PIVOT','THREE_EXISTING_PILOTS_ONLY_PENDING_APPROVAL','NONE','PAUSED_BY_USER_AFTER_PHASE_1S','2022/2024/2025_NOT_ACCESSED',rep('PENDING_USER_APPROVAL',4),'NOT_IMPLEMENTED',pd_next()),stringsAsFactors=FALSE)
  summary<-data.frame(item=c('target_cells','evidence_categories','gap_records','saved_source_rows_in_targets','completed_target_denominators','new_cells_admitted','routes_assessed','selected_routes','prior_inventory','prior_completed','prior_valid_bundles','external_requests','terminal_decision'),
    value=c('10','12','120','1206','UNKNOWN','0',as.character(nrow(routes)),'1','245','232','231','0',decision),stringsAsFactors=FALSE)
  setNames(list(provenance,gaps,routes,pd_stages(),decisions,summary),pd_names)
}
pd_table <- function(x) {
  clean<-function(v)gsub('|',' / ',ifelse(is.na(v),'NA',as.character(v)),fixed=TRUE)
  c(paste0('| ',paste(names(x),collapse=' | '),' |'),paste0('| ',paste(rep('---',ncol(x)),collapse=' | '),' |'),
    apply(x,1,function(v)paste0('| ',paste(clean(v),collapse=' | '),' |')))
}
pd_report_lines <- function(r) c(
  '# Phase 2D: Package B evidence-route proposal','',
  '**Terminal decision: STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE.** Version 1.0.0. Proposal completed; the pivot is not executed or approved. No target is admitted.','',
  paste('Started clean on main at',pd_baseline,'(Plan development cohort expansion), 30 ahead / zero behind existing local origin/main. No remote refresh or push.'),'',
  '## Purpose and authority','',
  'The flagship asks whether interpretable Four Factors explain player strengths and improve calibrated forecasts over surface-adjusted Elo. Distinctness, incremental NPR/winning information and future performance remain goals, not findings. Challenger remains deferred; portfolio was not modified. Phase 2D uses saved local aggregate evidence only. No acquisition, browser, search, contact, OTD access, new raw-row parsing, target reconciliation, metrics, model, factor selection, imputation, Elo, history or forecast is performed.','',
  'The ten-family panel, 2021-2023 development / 2024 validation / locked 2025 split, 90% event and full-panel 95% tour-season gates remain unchanged. No 2022/2024/2025 data is accessed. A stopped expansion is not a panel amendment. Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL; OTD remains PAUSED_BY_USER_AFTER_PHASE_1S.','',
  '## Saved facts and evidence scope','',
  'The planner reads exactly 37 pinned aggregate/manifest/document inputs. It reads all seven frozen Phase 2C tables and its report, the 27 Phase 2C input documents/manifests/aggregates, and two historical source/rights reports. Every path, hash, size and role appears below and in input-provenance.csv. It never follows a manifest URL or raw path. Current mutable status/contract prose is tested separately rather than circularly pinned.','',
  pd_table(r[[1]][c('path','role')]),'',
  'Saved facts: all 40 cells / 3,832 source rows remain visible in Phase 2C; three inventories are reconciled and 37 remain unvetted. Package B has 12 core cells (ATP/WTA, 2021/2023, Indian Wells/Roland-Garros/Wimbledon). ATP/WTA Indian Wells 2023 are the two existing core pilots. WTA Montreal 2021 remains supplementary, not a replacement. The ten target cells contain 1,206 source rows, not 1,206 completed matches. All target completed denominators stay NA.','',
  pd_table(unique(r[[2]][c('cell_id','completed_denominator','new_cell_admitted')])), '',
  'The inherited three pilots retain 245 inventory records, 232 completed and 231 valid bundles; one WTA Indian Wells bundle remains quarantined and Montreal retains 42 original plus seven separate recovery bundles. These are saved aggregate findings, not new match-level validation. Nine fields and annual rows do not establish a complete main draw, normal completion, count validity, independent corroboration or rights.','',
  '## Consolidated evidence gaps','',
  'There are 120 records: ten target cells by twelve categories. All sixteen Phase 2C prerequisites are mapped without omission. Each record preserves saved basis, exact missing evidence, inherited state, rights state, route and required stage. Provenance is partial source-only; publication is blocked; other categories are unsatisfied. All execution remains separately unauthorized.','',
  pd_table(data.frame(category=names(pd_categories()),inherited_prerequisites=vapply(pd_categories(),paste,'',collapse=';'))),'',
  'Locally executable later: hash/provenance checks and source structural checks, with existing scoped authority. They cannot supply missing official/reference inventory, non-bye denominators, identities or corroborated statuses. Counts need valid statuses and count universes first. Quarantine/recovery policy cannot be transplanted from another event; new resolutions require evidence and approval. Publication rights are a separate later gate, not an invented prerequisite for every private audit.','',
  '## Route assessment and terminal reasoning','',
  paste(seq_along(pd_order()),pd_order(),sep='. '),'',
  'This is an ordered review, not a weighted score. Unknown rights never become a prohibition finding or a permission grant. Prior user permission is not provider permission. The historical brief includes superseded OTD recommendations and an old unsent message: neither is adopted, revised, sent or reactivated here.','',
  pd_table(r[[3]][c('route_id','assessment','rights','validity','burden_and_disposition')]),'',
  '**Inference from saved evidence:** a 2023 ATP official-reference precedent makes a narrowly scoped ATP document investigation conceivable, but it leaves the known WTA automation barrier and all missing clay/grass target references unresolved. No saved evidence identifies a permissible, target-specific alternative likely to supply full inventory/status evidence across those gates. Choosing an ATP-only probe would defer the governing Package B barrier. Generic organizer/archive discovery has neither a verified target artifact nor a rights basis; tennis-data documentation has already failed and schema/rights remain unknown. These are reasons not to request another investigation now, not proof that all future discovery is futile.','',
  'The stop is a bounded research-effort judgment: the credible package-enabling route is not established from saved evidence. Do not invent a success probability, work-hour estimate or universal legal prohibition. Missing rights alone is not equated with nonexistence; the combination of unresolved permission, target-reference absence, limited substitutes and prior failed probes makes another ladder speculative. No outside source was rechecked. A materially new attributable permission or target reference supplied later can justify reconsideration under separate authority.','',
  '## Selected pivot and staged limits','',
  'No Package B diagnostic cell is selected because no defensible expansion route survived. The one proposed pivot diagnostic is the existing three-pilot group: ATP/WTA Indian Wells 2023 and WTA Montreal 2021. This is the smallest group that preserves both tours, the WTA quarantine and the separate Montreal recovery pathway already used by the frozen diagnostic release. Selecting only the easiest ATP pilot would omit those failure modes.','',
  'The next requested implementation is only a versioned current-context eligibility/count revalidation stage, before any further empirical analysis. Reconstruct the inherited approved pilot evidence and compare membership, exclusions, original/recovered counts and quarantine with frozen results; preserve saved metric diagnostics without recomputing them. The expected historical counts are comparison targets, never values to force. At most three pilots, zero new target cells, zero new metrics and zero external/search/contact requests.','',
  pd_table(r[[4]][c('stage','diagnostic_scope','approval','cell_ceiling','new_cell_ceiling','external_request_ceiling','new_metric_ceiling')]),'',
  'Full prerequisites, pass/fail/unresolved handling and stops are in staged-execution-plan.csv. Before P1: explicit user approval, current context/protocol pins, inherited scoped-use and provenance checks and a separate new output location. PASS means exact evidence agreement only; FAIL or UNRESOLVED withholds the whole release and preserves historical bytes. Any missing permission for an expanded use stops that use. A successful pilot comparison grants no new cell, metric, final-factor or forecast authority. P2 is review only. There is no automatic expansion or later ten-cell sequence. Reopening B requires genuinely new rights/reference evidence, a new decision and separately approved exact scope.','',
  '## Historical versions and analytical limitations','',
  'Phase 2A correctly refuses the current context with Phase 2A BLOCKED: input hash mismatch. Do not weaken or silently repin it. Only PROJECT_CONTEXT.md differs among its 86 historical pins. Phase 2A/2B/2C code, reports, tests and outputs stay unchanged. The successor remains NOT_IMPLEMENTED. Any successor needs a new version/location, current context and Phase 2B protocol pins, inherited-input revalidation, preservation and comparison of old results, separately approved new-cell gates and fail-closed unsupported evidence. The proposed P1 is only its eligibility/count stage, not a full empirical successor.','',
  'The unchanged Phase 2C suite is run against the clean Phase 2C baseline before current-authority documents change. Its old headline/data-universe assertions remain historical; they must not be edited to manufacture a current pass. New tests separately check current Phase 2D authority and preserve every Phase 2C artifact. See status for actual run results.','',
  'Package B still has one event family per surface and cannot isolate a general causal surface effect. Two seasons cannot establish broad temporal stability. The three retained pilots are hard-court convenience evidence: ATP has one event-season and WTA event/season effects are confounded. They cannot establish final Four Factors, surface stability, incremental future value or superiority to Elo. No final factors, models or imputation are selected; chronology and publication remain blocked.','',
  '## Exact next approval','',pd_next(),'',
  'This approval is PENDING_USER_APPROVAL. No proposed route is executed in Phase 2D. Do not initiate more discovery or unrestricted planning by default. The next task must end with a response-only ChatGPT Handoff of no more than 2,000 words.','',
  '## Reproduction and verification','',
  'The base-R planner is inert when sourced and writes only six ignored CSVs plus this report. All input paths are exact allowlisted SHA-256 pins; raw-row and forbidden-season paths and network-capable subprocesses are rejected. Changed/missing inputs fail before writes. Existing identical releases preserve bytes and timestamps; partial or changed releases are refused without overwrite.','',
  '[Planner](../R/plan_package_b_evidence_route.R), [tests](../R/test_package_b_evidence_route.R), [current status](status.md), [data contract](data-source-contract.md), [historical readiness](development-cohort-expansion-readiness.md) and [selection protocol](four-factors-definition-protocol.md). Actual verification is reported in status; software checks are not legal clearance or fresh data-availability verification.'
)
pd_render <- function(r) {
  pd_need(identical(names(r),pd_names),'exact output names')
  csv<-function(x){con<-textConnection('out','w',local=TRUE);on.exit(close(con));write.csv(x,con,row.names=FALSE,na='NA');out}
  lines<-lapply(r,csv);lines[[7]]<-pd_report_lines(r)
  lapply(lines,function(z)charToRaw(paste0(paste(z,collapse='\n'),'\n')))
}
pd_publish <- function(r) {
  pd_need(identical(r,pd_build(pd_load())),'result differs from pinned reconstruction')
  paths<-pd_files();bytes<-pd_render(r)
  pd_need(!length(pd_process('git',c('ls-files','--','data/raw','data/pilot'))),'restricted data tracked')
  pd_need(setequal(pd_process('git',c('check-ignore','--',paths[1:6])),paths[1:6]),'outputs must be ignored')
  for(p in unique(c('data','data/pilot',pd_dir,'docs',paths)))pd_need(is.na(Sys.readlink(p))||!nzchar(Sys.readlink(p)),'symlink output refused')
  if(dir.exists(pd_dir))pd_need(setequal(list.files(pd_dir,all.files=TRUE,no..=TRUE),basename(paths[1:6])),'partial or unexpected output directory')
  if(any(file.exists(paths))) {
    pd_need(all(file.exists(paths)),'partial release preserved')
    for(i in seq_along(paths))pd_need(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),bytes[[i]]),'changed release preserved')
    return(invisible(paths))
  }
  stage<-tempfile('phase2d-stage-');pd_need(dir.create(stage),'staging directory');installed<-character();done<-FALSE;created<-FALSE
  on.exit({if(!done){if(length(installed))unlink(installed);if(created&&!length(list.files(pd_dir,all.files=TRUE,no..=TRUE)))unlink(pd_dir,recursive=TRUE)};unlink(stage,recursive=TRUE)},add=TRUE)
  for(i in seq_along(bytes))writeBin(bytes[[i]],file.path(stage,as.character(i)))
  pd_need(dir.create(pd_dir),'approved aggregate directory');created<-TRUE
  for(i in seq_along(paths)){pd_need(!file.exists(paths[i]),'destination appeared; preserve it');installed<-c(installed,paths[i]);pd_need(file.copy(file.path(stage,as.character(i)),paths[i],overwrite=FALSE),'installation failed')}
  done<-TRUE;invisible(paths)
}
plan_package_b_evidence_route <- function(write_outputs=TRUE) {
  r<-pd_build(pd_load());if(write_outputs)pd_publish(r);r
}
if(sys.nframe()==0L){result<-plan_package_b_evidence_route();message('Phase 2D: ',result$decisions$value[1],'; no route execution or new cell admission.')}
