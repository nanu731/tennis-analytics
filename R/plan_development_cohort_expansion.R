# Phase 2C: aggregate-only readiness planning. Sourcing defines functions only.
ec_baseline <- '3c59ca275be163facdf7504acba3f94f7cfed662'
ec_dir <- 'data/pilot/development-cohort-expansion-readiness'
ec_report_path <- 'docs/development-cohort-expansion-readiness.md'
ec_names <- c('input-provenance','cell-readiness','package-comparison','cell-prerequisites','current-context-requirements','decisions','summary')
ec_need <- function(ok, message) if (!isTRUE(ok)) stop(paste('Phase 2C BLOCKED:', message), call.=FALSE)
ec_paths <- function() c(file.path(ec_dir,paste0(ec_names,'.csv')),ec_report_path)
ec_trace <- new.env(parent=emptyenv())
ec_trace$reads <- character()

# Filled from the exact saved baseline; no raw annual or match-level input is allowed.
ec_pins <- function() c(
  '.gitignore'='90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217',
  'AGENTS.md'='67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d',
  'DATA_LICENSE.md'='f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880',
  'data/manifests/anomaly-reference-files.csv'='fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd',
  'data/manifests/development-source-files.csv'='2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4',
  'data/manifests/inventory-reference-files.csv'='b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721',
  'data/manifests/montreal-reference-files.csv'='783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe',
  'data/manifests/pilot-source-files.csv'='2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b',
  'data/pilot/development-2021/montreal-completed-match-coverage/summary.csv'='288355b44a1a77c52a9674366b247962728c4736bb3026b1af53593adb32170b',
  'data/pilot/development-2021/montreal-inventory/summary.csv'='ae274408a0df303573d4f0273464e009fda670b4d95fc5e9cc3a252d141ddf56',
  'data/pilot/development-2021/required-field-summary.csv'='0e26a06d58a3d87e73fcd60fda19c01df1dbdf01f797657ff53c56d2d424804d',
  'data/pilot/event-boundary-feasibility/event-cells.csv'='76358755c89aeacf79ae452ad606eca755d52cab2bc3954c3ef0f58e64c12ae8',
  'data/pilot/event-boundary-feasibility/source-candidates.csv'='9229340b953dec55196a97c95ec0e807982ca1aaa434fb3533125a1d777062bd',
  'data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv'='7ea6feb58a428ab45bfabcc2a5c3a87eef0485f92062fa1e1cac4b4cade5d982',
  'data/pilot/inventory/inventory-summary.csv'='f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6',
  'docs/2021-annual-source-audit.md'='22ffb45943267d77b81bb69f67b65cd3650a4d7f4f83ae0658e2fd89c6cab9e5',
  'docs/atp-inventory-reference-precedence-policy.md'='167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d',
  'docs/event-boundary-feasibility.md'='19685452eb8af4d587ebb7c816f56748544c3037bae797dc81fe7344ce7f8b9b',
  'docs/four-factors-candidate-metric-feasibility.md'='413c4d67fb24f6e84faffe98008a65fa85cc5a5c13be60c9cd6e0d61af22eb59',
  'docs/four-factors-definition-protocol.md'='5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c',
  'docs/indian-wells-inventory-reconciliation.md'='8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e',
  'docs/post-otd-analytical-path.md'='14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7',
  'docs/wta-2021-montreal-completed-match-coverage.md'='168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8',
  'docs/wta-2021-montreal-inventory-reconciliation.md'='6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4',
  'docs/wta-2021-montreal-recovery-verification.md'='d15fd1dd7e43bc6e0740e1f9395b8c5c5d8d1bca204318df48c4f0ad2281f151',
  'docs/wta-anomaly-and-quarantine-policy.md'='1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b',
  'PROJECT_CONTEXT.md'='865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1')

ec_allow <- function(path) {
  ec_need(is.character(path)&&length(path)==1L&&!is.na(path)&&path%in%names(ec_pins()),'unapproved input path')
  ec_need(!grepl('2022|2024|2025|^data/raw/|match-metrics|eligibility-audit|player-event',path),'raw, row-level or forbidden-season input')
  ec_need(file.exists(path)&&normalizePath(path)==file.path(normalizePath('.'),path),'missing or redirected input')
  invisible(TRUE)
}
ec_process <- function(command,args) {
  hash_ok <- identical(command,'shasum')&&length(args)==3L&&identical(args[1:2],c('-a','256'))&&args[3]%in%c(names(ec_pins()),ec_paths())
  git_ok <- identical(command,'git')&&(identical(args,c('rev-parse',ec_baseline))||identical(args,c('merge-base',ec_baseline,'HEAD'))||
    identical(args,c('ls-files','--','data/raw','data/pilot'))||identical(args,c('check-ignore','--',ec_paths()[1:7])))
  ec_need(hash_ok||git_ok,'network-capable or unapproved subprocess')
  z<-system2(command,vapply(args,shQuote,''),stdout=TRUE)
  ec_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'local verification subprocess failed');z
}
ec_hash <- function(path) strsplit(ec_process('shasum',c('-a','256',path)),' ')[[1]][1]
ec_read <- function(path) {
  ec_allow(path)
  ec_need(identical(ec_hash(path),unname(ec_pins()[path])),'input hash mismatch')
  ec_trace$reads<-c(ec_trace$reads,path)
  readLines(path,warn=FALSE)
}
ec_csv <- function(path) read.csv(text=paste(ec_read(path),collapse='\n'),stringsAsFactors=FALSE,na.strings=c('NA',''),check.names=FALSE)
ec_load <- function() {
  ec_trace$reads<-character()
  ec_need(identical(ec_process('git',c('rev-parse',ec_baseline)),ec_baseline),'exact baseline')
  ec_need(identical(ec_process('git',c('merge-base',ec_baseline,'HEAD')),ec_baseline),'baseline ancestry')
  x<-list()
  for(p in names(ec_pins())) x[[p]]<-if(endsWith(p,'.csv'))ec_csv(p) else ec_read(p)
  ec_need(setequal(ec_trace$reads,names(ec_pins())),'exact aggregate/document read trace')
  list(inputs=x,reads=ec_trace$reads,provenance=data.frame(path=names(ec_pins()),sha256=unname(ec_pins()),bytes=file.info(names(ec_pins()))$size,
    role=ifelse(endsWith(names(ec_pins()),'.csv'),'SAVED_AGGREGATE_OR_MANIFEST','REPOSITORY_DOCUMENT'),verification='HASH_CHECKED_LOCAL_ONLY',stringsAsFactors=FALSE))
}
ec_families <- function() c('Australian Open','Canada','Cincinnati','Indian Wells','Madrid','Miami','Roland-Garros','Rome','US Open','Wimbledon')
ec_pilots <- function() c('ATP|2023|Indian Wells','WTA|2021|Canada','WTA|2023|Indian Wells')
ec_order <- function() c('Named scientific gap','ATP/WTA separation','Balanced season and surface contrasts','Matched families across seasons',
  'Fewest new unvetted cells','Usable saved evidence','Rights and reference burden','Informative failure','No favorable assumptions about missing evidence')
ec_next <- function() paste('Do you approve a bounded evidence-route proposal for the ten unvetted Package B cells (ATP/WTA Indian Wells 2021 and ATP/WTA Roland-Garros and Wimbledon 2021/2023),',
  'using saved evidence only to specify missing inventory, identity, status, count and rights evidence and a staged stop-or-proceed decision,',
  'without browsing, searching, acquisition, contact, OTD work, reconciliation, cell admission, successor implementation, metric calculation, modeling, 2022/2024/2025 access or publication?')
ec_validate_scope <- function(cov,events,fields) {
  expected<-sort(as.vector(outer(as.vector(outer(c('ATP','WTA'),c(2021,2023),paste,sep='|')),ec_families(),paste,sep='|')))
  for(x in list(cov,events)) {
    ec_need(nrow(x)==40L&&!anyDuplicated(x$cell_id)&&identical(sort(x$cell_id),expected),'complete unique 40-cell universe')
    ec_need(all(x$season%in%c(2021,2023))&&all(x$tour%in%c('ATP','WTA')),'approved tours and years')
    ec_need(all(x$cell_id==paste(x$tour,x$season,x$event_family,sep='|')),'cell labels agree')
  }
  e<-events[match(cov$cell_id,events$cell_id),]
  ec_need(all(cov$source_rows==e$source_rows)&&sum(cov$source_rows)==3832L&&all(cov$surface==e$surface),'saved coverage and metadata agree')
  ec_need(all(cov$mapping_state=='found_candidate')&&all(e$candidate_records==1L),'unambiguous saved candidate mapping')
  expected_surface<-ifelse(cov$event_family=='Wimbledon','Grass',ifelse(cov$event_family%in%c('Roland-Garros','Madrid','Rome'),'Clay','Hard'))
  ec_need(identical(cov$surface,expected_surface),'saved surface labels consistent; not official revalidation')
  pilot<-cov$cell_id%in%ec_pilots()
  ec_need(sum(pilot)==3L&&all(cov$status[!pilot]=='UNVETTED_NONPILOT'),'exact three-pilot boundary')
  ec_need(all(is.na(cov$completed_denominator[!pilot]))&&all(is.na(cov$valid_bundles[!pilot])),'unvetted completed denominator and validity unknown')
  ec_need(sum(cov$completed_denominator[pilot])==232L&&sum(cov$valid_bundles[pilot])==231L,'inherited pilot counts')
  ec_need(all(cov$event_admission=='NOT_EVALUATED')&&all(cov$tour_season_95pct=='NOT_TESTED'),'admission gates unchanged')
  suffix<-c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpSaved','bpFaced')
  required<-c(paste0('w_',suffix),paste0('l_',suffix))
  for(t in c('ATP','WTA'))for(y in c(2021,2023)) {
    f<-fields[fields$tour==t&fields$year==y,]
    ec_need(nrow(f)==49L&&!anyDuplicated(f$field)&&all(required%in%f$field)&&all(f$required_column[match(required,f$field)]),'nine structural count columns on each side')
  }
  invisible(TRUE)
}
ec_classify <- function(pilot,proposed,blockers) {
  if(pilot)return('CURRENT_RECONCILED_PILOT')
  if(!proposed)return('SAVED_SOURCE_ONLY_UNVETTED')
  if(length(blockers)>1L)return('BLOCKED_MULTIPLE')
  ec_need(length(blockers)==1L&&blockers%in%c('INVENTORY','STATUS','COUNTS','RIGHTS'),'unknown readiness blocker')
  paste0('BLOCKED_',blockers)
}
ec_cells <- function(input) {
  cov<-input$inputs[['data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv']]
  e<-input$inputs[['data/pilot/event-boundary-feasibility/event-cells.csv']]
  f<-input$inputs[['data/pilot/development-2021/required-field-summary.csv']]
  ec_validate_scope(cov,e,f)
  candidates<-input$inputs[['data/pilot/event-boundary-feasibility/source-candidates.csv']]
  key<-paste(candidates$tour,candidates$season,candidates$event_family_annotation,sep='|')
  ec_need(nrow(candidates)==40L&&!anyDuplicated(key)&&setequal(key,cov$cell_id),'source metadata coverage')
  candidates<-candidates[match(cov$cell_id,key),]
  ec_need(all(candidates$source_rows==cov$source_rows)&&all(candidates$surface==cov$surface),'independent saved aggregates agree')
  slams<-candidates$event_family_annotation%in%c('Roland-Garros','Wimbledon')
  ec_need(sum(slams)==8L&&all(candidates$tourney_level[slams]=='G')&&all(candidates$draw_size[slams]==128L),'clay/grass design preference has saved source-label basis')
  iw<-input$inputs[['data/pilot/inventory/inventory-summary.csv']]
  mc<-input$inputs[['data/pilot/development-2021/montreal-completed-match-coverage/summary.csv']]
  mi<-input$inputs[['data/pilot/development-2021/montreal-inventory/summary.csv']]
  ec_need(nrow(iw)==2L&&all(iw$inventory_gate=='PASS')&&all(iw$official_non_bye==95L),'inherited Indian Wells inventory summary')
  ec_need(mi$reconciliation_state=='COMPLETE'&&mc$normally_completed==49L&&mc$valid_original_bundles==42L&&mc$valid_overlay_bundles==7L,'inherited Montreal summary')
  manifests<-input$inputs[c('data/manifests/development-source-files.csv','data/manifests/pilot-source-files.csv')]
  source_paths<-unlist(lapply(manifests,function(x)x$local_path),use.names=FALSE)
  ec_need(length(source_paths)==4L&&setequal(source_paths,unique(cov$source_path)),'exact four annuals by saved manifest only')
  for(x in manifests)ec_need(all(x$pinned_commit=='83733587353df8a41f2fd4f516147d5aa83f5a8d')&&all(x$license_id=='CC-BY-NC-SA-4.0'),'saved archive revision and conditional license label')
  cov<-cov[order(cov$cell_id,method='radix'),];e<-e[match(cov$cell_id,e$cell_id),]
  pilot<-cov$cell_id%in%ec_pilots();core<-cov$event_family%in%c('Indian Wells','Roland-Garros','Wimbledon')
  out<-data.frame(cell_id=cov$cell_id,tour=cov$tour,season=cov$season,event_family=cov$event_family,
    edition_city=ifelse(cov$event_family=='Canada'&cov$tour=='WTA','Montreal',ifelse(cov$event_family=='Indian Wells','Indian Wells',NA_character_)),
    city_evidence=ifelse(cov$event_family=='Canada'&cov$tour=='ATP','UNKNOWN_GENERIC_SOURCE_LABEL','SOURCE_LABEL_OR_EXISTING_PILOT_ONLY'),
    surface=cov$surface,surface_evidence='SAVED_SOURCE_LABEL_NOT_NEW_OFFICIAL_VERIFICATION',source_event_id=e$source_tournament_id,source_label=e$source_name,
    saved_source_rows=cov$source_rows,nine_count_fields_structurally_present=TRUE,count_presence_basis='196-row saved annual field summary; nine suffixes on both sides',
    inventory_status=ifelse(pilot,'RECONCILED_EVENT_LOCAL','NOT_TESTED'),reference_status=ifelse(pilot,'SAVED_SCOPED_REFERENCES','NO_RECONCILING_REFERENCE_IN_SAVED_MANIFESTS'),
    identity_mapping_status=ifelse(pilot,'EVENT_LOCAL_LINKS_NO_GLOBAL_CANONICAL_IDS','SOURCE_IDS_ONLY_NO_OFFICIAL_MATCH_LINKAGE'),
    status_eligibility_evidence=ifelse(pilot,'FROZEN_PILOT_COMPLETED_RULES','UNVETTED_NOT_INFERRED_FROM_SCORE'),
    count_validation_status=ifelse(pilot,'FROZEN_PILOT_VALIDATION','NOT_TESTED'),
    quarantine_conflict_status=ifelse(pilot,'SCOPED_POLICIES_PRESERVED','NOT_ASSESSED_NO_CLEAN_BILL'),
    recovery_layer_status=ifelse(cov$cell_id=='WTA|2021|Canada','SEVEN_SEPARATE_APPROVED_BUNDLES',ifelse(pilot,'NONE_APPROVED_FOR_THIS_CELL','NEED_UNKNOWN_NOT_AUTHORIZED')),
    local_research_rights='ARCHIVE_CONDITIONAL_NONCOMMERCIAL_SAVED_REVIEW;REFERENCE_RIGHTS_NOT_CLEARED_FOR_EXPANSION',
    publication_derivative_rights='BLOCKED_PENDING_RIGHTS_REVIEW',current_context_audit='PHASE_2A_CONTEXT_HASH_MISMATCH;SUCCESSOR_NOT_IMPLEMENTED',
    existing_pilot=pilot,evidence_state=ifelse(pilot,'RECONCILED_PILOT','UNVETTED_NONPILOT'),
    selection_role=ifelse(core,ifelse(pilot,'B_EXISTING_CORE','B_PROPOSED_NEW'),ifelse(pilot,'SUPPLEMENTARY_EXISTING','NOT_PROPOSED')),
    completed_denominator=cov$completed_denominator,valid_bundles=cov$valid_bundles,event_90pct=cov$event_90pct,tour_season_95pct=cov$tour_season_95pct,
    event_admission=cov$event_admission,new_cell_admitted=FALSE,
    scientific_contrast=ifelse(core,paste(cov$tour,cov$season,cov$surface,'matched-family anchor candidate'),ifelse(pilot,'WTA 2021 supplementary hard-event contrast','Later within-surface event replication; not selected now')),
    missing_prerequisites=ifelse(pilot,'SUCCESSOR_REVALIDATION;LOCAL_REFERENCE_RIGHTS_SCOPE;PUBLICATION_RIGHTS;95PCT_GATE;CHRONOLOGY_FOR_FORECAST',
      'INVENTORY;SINGLES;NONBYE_DENOMINATOR;IDENTITY;STATUS;CONFLICTS;COUNTS;QUARANTINE;COUNT_UNIVERSE;RECOVERY_IF_NEEDED;REFERENCE_PROVENANCE;REFERENCE_RIGHTS;PUBLICATION_RIGHTS;SUCCESSOR;GATES;AUTHORITY'),
    readiness=character(40),reason_code=ifelse(pilot,'EXISTING_PILOT_NOT_MODEL_ADMISSION',ifelse(core,'MISSING_MULTIPLE_REQUIRED_EVIDENCE_CLASSES','SAVED_ONLY_OUTSIDE_RECOMMENDATION')),
    stringsAsFactors=FALSE)
  for(i in seq_len(nrow(out)))out$readiness[i]<-ec_classify(pilot[i],core[i],c('INVENTORY','STATUS','COUNTS','RIGHTS'))
  out$quarantine_conflict_status[out$cell_id=='WTA|2023|Indian Wells']<-'ONE_COMPLETED_BUNDLE_QUARANTINED;METADATA_CONFLICT_PRESERVED'
  out$quarantine_conflict_status[out$cell_id=='ATP|2023|Indian Wells']<-'FOUR_PDF_DISSENTS_SCOPED_PRECEDENCE_PRESERVED'
  out$quarantine_conflict_status[out$cell_id=='WTA|2021|Canada']<-'HTML_RET_OMISSIONS_SCHEDULED_METADATA_AND_SUFFIX_UNCERTAINTY_PRESERVED'
  rownames(out)<-NULL;out
}

# Core package counts are separate from retained supplementary pilots.
ec_packages <- function(cells) {
  family<-cells$event_family%in%c('Indian Wells','Roland-Garros','Wimbledon')
  sets<-list(A=which(family&cells$season==2023),B=which(family),C=seq_len(nrow(cells)))
  answer<-list()
  for(id in names(sets)) {
    core<-cells[sets[[id]],];members<-cells[sort(unique(c(sets[[id]],which(cells$existing_pilot)))),]
    fresh<-core[!core$existing_pilot,]
    answer[[id]]<-data.frame(package=id,objective=switch(id,A='Surface probe',B='Balanced tour x season x surface anchor',C='Ten-family saved development panel'),
      core_cells=nrow(core),core_existing=sum(core$existing_pilot),supplementary_existing=nrow(members)-nrow(core),total_cells=nrow(members),
      existing_reconciled=sum(members$existing_pilot),new_unvetted=nrow(fresh),new_source_rows=sum(fresh$saved_source_rows),
      core_ATP=sum(core$tour=='ATP'),core_WTA=sum(core$tour=='WTA'),core_2021=sum(core$season==2021),core_2023=sum(core$season==2023),
      core_hard=sum(core$surface=='Hard'),core_clay=sum(core$surface=='Clay'),core_grass=sum(core$surface=='Grass'),
      matched_families_both_seasons=if(id=='A')0L else length(unique(core$event_family)),
      scientific_gap=if(id=='A')'Initial non-hard measurement probe' else if(id=='B')'Within-family season replication and tour-separated surface-context contrasts' else 'Broader within-surface event sensitivity and panel coverage',
      ATP_WTA_separate=TRUE,balanced_anchor=id!='A',
      potential_success_criteria='Measurement; denominator and missingness behavior; redundancy; later incremental NPR/winning checks after separate modeling approval',
      remaining_confounding=if(id=='A')'One core season; event equals surface; Montreal confounds season/event' else if(id=='B')'One family per surface; event/surface and ATP format remain confounded; two seasons only; IW 2021 autumn versus 2023 spring' else 'Grass only Wimbledon; two saved seasons; chronology and repeated-player dependence unresolved',
      saved_evidence='Pinned aggregate candidate metadata and field presence; inherited pilot inventories only',
      missing_inventory='Official complete final draw/results for every proposed new cell',missing_identity='One-to-one official/source player-pair round and winner links',
      missing_status='Normal completion/RET/WO and unresolved/default policies; no score-syntax inference',missing_counts='Whole-bundle validity; independent applicable universe checks; quarantine and recovery if needed',
      missing_rights='Reference access/retention/extraction scope unknown; conditional archive obligations; derivative publication unresolved',
      current_context_work='New versioned successor; current context/protocol pins; inherited revalidation and comparison; no historical repinning',
      entirely_offline_reconciliation=FALSE,expected_burden=paste(nrow(fresh),'unvetted inventories;',sum(fresh$saved_source_rows),'source rows, NOT completed matches; references and work-hours unknown'),
      expansion_risk='REFERENCE_AND_RIGHTS_GAPS;UNKNOWN_STATUS_AND_COUNTS;NO_METRIC_FEASIBILITY_GUARANTEE',
      recommendation=if(id=='B')'RECOMMENDED_EVIDENCE_TARGET_ONLY' else if(id=='A')'NOT_SELECTED_INADEQUATE_SEASON_CROSSING' else 'DEFER_BROADER_BURDEN',
      reason=if(id=='B')'Minimum 12-cell matched anchor; reuses two IW pilots; ten new cells; evidence missing' else if(id=='A')'Four additions are surface-probe minimum but cannot meet balanced objective' else '37 additions exceed minimum; more event replication is a later need, not an initial prerequisite',
      core_cell_ids=paste(core$cell_id,collapse=';'),supplementary_cell_ids=paste(setdiff(members$cell_id,core$cell_id),collapse=';'),
      decision='READY_FOR_BOUNDED_EVIDENCE_PROPOSAL',stringsAsFactors=FALSE)
  }
  z<-do.call(rbind,answer);rownames(z)<-NULL;z
}

ec_anchor_options <- function(cells) {
  families<-unique(cells[c('event_family','surface')])
  choices<-expand.grid(hard=families$event_family[families$surface=='Hard'],clay=families$event_family[families$surface=='Clay'],grass='Wimbledon',stringsAsFactors=FALSE)
  choices$new_cells<-integer(nrow(choices))
  for(i in seq_len(nrow(choices))) {
    z<-cells[cells$event_family%in%unlist(choices[i,1:3],use.names=FALSE),]
    ec_need(nrow(z)==12L&&all(table(z$tour,z$season,z$surface)==1L),'balanced anchor enumeration')
    choices$new_cells[i]<-sum(!z$existing_pilot)
  }
  choices[order(choices$new_cells,choices$hard,choices$clay,method='radix'),]
}
ec_select <- function(packages,cells) {
  ec_need(identical(packages$package,c('A','B','C'))&&all(packages$ATP_WTA_separate),'three tour-separated packages')
  eligible<-which(packages$balanced_anchor)
  chosen<-eligible[which.min(packages$new_unvetted[eligible])]
  alternatives<-ec_anchor_options(cells)
  ec_need(packages$package[chosen]=='B'&&packages$new_unvetted[chosen]==min(alternatives$new_cells)&&min(alternatives$new_cells)==10L,'smallest matched balanced objective')
  ec_need(packages$new_unvetted[1]==4L,'two tours times two missing surfaces is four-cell lower bound')
  ec_need(!any(packages$entirely_offline_reconciliation),'missing evidence cannot be promoted to offline readiness')
  'B'
}
ec_prerequisites <- function(cells,packages) {
  spec<-data.frame(
    prerequisite=c('INVENTORY','MAIN_DRAW_SINGLES','NONBYE_DENOMINATOR','IDENTITY','STATUS','CONFLICTS','BUNDLE_VALIDITY','QUARANTINE','COUNT_UNIVERSE','RECOVERY_IF_NEEDED','PROVENANCE','LOCAL_RIGHTS','PUBLICATION_RIGHTS','SUCCESSOR_PIN','COVERAGE_GATES','USER_AUTHORITY'),
    required_evidence=c('Complete final official bracket/results independently traversed; account for all rounds entrants and byes',
      'Edition tour and main-draw singles scope independently confirmed; exclude other competitions',
      'All official non-bye results linked; completed denominator only after status resolution, never source rows minus score markers',
      'Unique stable event/round/player-pair links and preserved source spellings/IDs; no name-only or match-number chronology joins',
      'Corroborated normal completion, retirement, walkover and explicit unresolved/default disposition; unknowns block',
      'Compare identity winner round score and status across references; retain dissent; new precedence needs scoped approval',
      'All nine integer nonnegative counts on both sides; full missing/invalid bundles withheld; accuracy not proved by presence',
      'Whole-bundle quarantine on failed validity, preserved completed denominator; no extrapolation of scoped IW policy resolutions',
      'Verified definitions and numerator bounds, paired point universe and applicable game/score/tie-break checks; distinguish tautology from independent accuracy',
      'Assess actual gaps first; any separate whole-bundle recovery requires exact evidence, provenance and specific policy approval; never impute or fill raw NA',
      'Revalidate saved source manifests plus exact new reference versions, fingerprints, retrieval representation and transformation lineage',
      'Review conditional archive noncommercial attribution/share-alike obligations and reference access, local retention and extraction rights for exact proposed use',
      'Separate derived-output/redistribution and portfolio rights review; no inference from MIT, free access or user approval',
      'Separately approved versioned successor with current context/protocol hashes, inherited validation and comparison, and unsupported-cell refusal',
      'Independently reconciled completed denominator then 90% event floor; fixed ten-family 95% tour-season gate remains NOT_TESTED by partial package',
      'Explicit separate authority for evidence route, acquisition if viable, reconciliation, successor, descriptive calculations and later modeling'),
    saved_basis=c('Source aggregate cell only','Source file family and report scope only','Source-row total only; no official denominator',
      'Source identifiers documented; no official crosswalk','Source syntax summaries only; not completion evidence','No new-cell conflict review',
      'Nine fields in saved schema; populated fields not validation','Existing whole-bundle principle only','Existing contract specification only',
      'No assessed new-cell need or approved recovery layer','Pinned annual manifests and aggregate provenance locally available',
      'Saved archive CC BY-NC-SA statement; no new reference clearance','BLOCKED_PENDING_RIGHTS_REVIEW','Current context and protocol locally available; no successor',
      'Existing 90%/95% rules only; no new denominator','Phase 2C planning only'),
    evidence_route=c(rep('MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK',6),
      'SAVED_ANNUALS_REQUIRE_LATER_APPROVED_VALIDATION_AFTER_STATUS','LATER_OFFLINE_POLICY_APPLICATION_NEW_RESOLUTIONS_NEED_APPROVAL',
      'SAVED_CONTRACT_PLUS_REFERENCE_CONVENTIONS_REQUIRED','UNKNOWN_NEED_MAY_REQUIRE_SEPARATE_EVIDENCE_AND_POLICY',
      'SAVED_PROVENANCE_RECHECK_POSSIBLE_NEW_REFERENCES_MISSING','SEPARATE_RIGHTS_REVIEW_OR_CLARIFICATION_NOT_AUTHORIZED',
      'SEPARATE_PUBLICATION_REVIEW_NOT_AUTHORIZED','SEPARATE_VERSIONED_IMPLEMENTATION_NOT_AUTHORIZED',
      'SEPARATE_RECONCILIATION_AND_FULL_SCOPE_GATE_WORK','USER_DECISION_REQUIRED'),stringsAsFactors=FALSE)
  answer<-list()
  for(id in cells$cell_id[!cells$existing_pilot]) {
    x<-spec;x$cell_id<-id
    x$packages<-paste(packages$package[vapply(strsplit(packages$core_cell_ids,';',fixed=TRUE),function(v)id%in%v,TRUE)],collapse=';')
    x$selected_B<-cells$selection_role[match(id,cells$cell_id)]=='B_PROPOSED_NEW'
    x$current_state<-ifelse(x$prerequisite=='PROVENANCE','PARTIAL_SAVED_SOURCE_ONLY',ifelse(x$prerequisite=='PUBLICATION_RIGHTS','BLOCKED_PENDING_RIGHTS_REVIEW','NOT_SATISFIED'))
    x$required_stage<-ifelse(x$prerequisite=='PUBLICATION_RIGHTS','BEFORE_PUBLICATION_STATUS_RECORDED_BEFORE_METRICS','BEFORE_NEW_CELL_METRICS')
    answer[[id]]<-x[c('cell_id','packages','selected_B','prerequisite','current_state','saved_basis','required_evidence','evidence_route','required_stage')]
  }
  z<-do.call(rbind,answer);rownames(z)<-NULL;z
}
ec_successor <- function() data.frame(
  requirement=c('NEW_VERSION','CURRENT_CONTEXT','INHERITED_INPUTS','HISTORICAL_RELEASE','PILOT_COMPARISON','NEW_CELL_ADMISSION','FAIL_CLOSED','GATES','AUTHORITY'),
  specification=c('Use a new audit version and separately approved output location; never overwrite Phase 2A',
    'Pin exact current PROJECT_CONTEXT.md and Phase 2B protocol plus applicable current data contract and approved cohort specification',
    'Revalidate every inherited source/reference/overlay/code input against provenance; schema, identities, statuses, conflicts, counts and scope',
    'Preserve all historical Phase 2A bytes and its original context hash; never silently repin',
    'Reconstruct inherited pilots independently and compare exact membership, exclusions, values and diagnostics with frozen output; investigate differences before extension',
    'Add cells only after separate inventory, identity, status, count, provenance, local-rights and coverage prerequisites pass',
    'Missing changed or unsupported evidence blocks the proposed release; never silently drop a failed proposed cell or substitute a source',
    'Preserve 90% event and 95% tour-season gates, quarantine, separate recovery, unadmitted states, locked 2025 and forecasting chronology restrictions',
    'Successor is NOT_IMPLEMENTED in Phase 2C; coding, calculations, locations and new evidence each need separate approved scope'),
  phase_2c_state='DESIGN_ONLY_NOT_IMPLEMENTED',stringsAsFactors=FALSE)
ec_build <- function(input) {
  cells<-ec_cells(input);packages<-ec_packages(cells);chosen<-ec_select(packages,cells)
  decisions<-data.frame(id=c('PHASE_2C','SELECTED_PACKAGE','CELL_ADMISSION','SUCCESSOR','OTD','Q6','Q8','Q9','Q10','EVENT_GATE','TOUR_SEASON_GATE','NEXT_APPROVAL'),
    value=c('READY_FOR_BOUNDED_EVIDENCE_PROPOSAL',chosen,'NONE','NOT_IMPLEMENTED','PAUSED_BY_USER_AFTER_PHASE_1S',rep('PENDING_USER_APPROVAL',4),
      '90% UNCHANGED;NO_NEW_PASS','95% UNCHANGED;NOT_TESTED',ec_next()),stringsAsFactors=FALSE)
  summary<-data.frame(measure=c('version','baseline','cells','source_rows','reconciled_pilots','unvetted','selected_core','selected_new','retained_supplementary',
    'new_cells_admitted','metrics_calculated','models_fitted','successor_implemented','phase_2a_current_context','decision','selection_basis'),
    value=c('1.0.0',ec_baseline,'40','3832','3','37','12','10','1','0','0','0','FALSE','EXPECTED_CONTEXT_HASH_REFUSAL',decisions$value[1],'LEXICOGRAPHIC_NO_WEIGHTED_SCORE'),stringsAsFactors=FALSE)
  list('input-provenance'=input$provenance,'cell-readiness'=cells,'package-comparison'=packages,'cell-prerequisites'=ec_prerequisites(cells,packages),
    'current-context-requirements'=ec_successor(),decisions=decisions,summary=summary)
}
ec_table <- function(x) {
  z<-x;for(n in names(z)){z[[n]]<-as.character(z[[n]]);z[[n]][is.na(z[[n]])]<-'NA';z[[n]]<-gsub('|',' / ',z[[n]],fixed=TRUE)}
  c(paste0('| ',paste(names(z),collapse=' | '),' |'),paste0('| ',paste(rep('---',ncol(z)),collapse=' | '),' |'),
    apply(z,1,function(row)paste0('| ',paste(row,collapse=' | '),' |')))
}
ec_report <- function(r) {
  cells<-r$`cell-readiness`;p<-r$`package-comparison`;new<-cells[cells$selection_role=='B_PROPOSED_NEW',]
  c('# Phase 2C: development-cohort expansion readiness', '',
    '**Decision: READY_FOR_BOUNDED_EVIDENCE_PROPOSAL.** Version 1.0.0. Planning only: Package B is a scientifically defensible evidence target, not an admitted or analysis-ready cohort.', '',
    paste('Started clean on main at',ec_baseline,'(Define Four Factors selection protocol). The flagship compares interpretable factors with surface-adjusted Elo; Challenger remains deferred. No portfolio modification, publication or push.'), '',
    '## Authority and evidence boundary', '',
    'Phase 2C implements aggregate saved-evidence planning, not expansion. No raw match-row parsing occurs in the planner. No acquisition, search, browser, contact, OTD resumption, 2022/2024/2025 data access, reconciliation of unvetted cells, new metric/outcome, model, factor selection, weights, imputation, history, Elo or forecast is performed.', '',
    'The [Phase 2B protocol](four-factors-definition-protocol.md) and [project context](../PROJECT_CONTEXT.md) remain unchanged. Four distinct mechanisms and freedom from overfitting are goals, not findings. Zero correlation is not required. The ten-family panel and 90% event / 95% tour-season gates are unchanged. Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL; OTD remains PAUSED_BY_USER_AFTER_PHASE_1S.', '',
    '## Exact saved input scope', '',
    paste('The planner pins',nrow(r$`input-provenance`),'aggregate/manifest/document inputs. input-provenance.csv records every exact path, SHA-256, byte size and role; every read is allowlisted, hash-checked and traced. It does not follow raw paths or URLs contained in manifests.'), '',
    'Source scope remains the four ATP/WTA 2021/2023 annuals at archive 83733587353df8a41f2fd4f516147d5aa83f5a8d. This planner reads their saved metadata summaries and acquisition manifests, not the annual rows. No current external rights or provider availability is verified.', '',
    ec_table(r$`input-provenance`[c('path','role')]), '',
    '## Forty-cell readiness findings', '',
    'All 40 candidate cells and 3,832 source rows remain visible. Exactly three are CURRENT_RECONCILED_PILOT; exactly 37 remain UNVETTED_NONPILOT. The ten selected new targets are BLOCKED_MULTIPLE; the other 27 are SAVED_SOURCE_ONLY_UNVETTED with selection role NOT_PROPOSED. No completed denominator or valid-count numerator is supplied for any unvetted cell.', '',
    'Readiness vocabulary also permits BLOCKED_INVENTORY, BLOCKED_STATUS, BLOCKED_COUNTS, BLOCKED_RIGHTS and NOT_PROPOSED. A planning classification does not change evidence_state or admission. CURRENT_RECONCILED_PILOT records inherited event-local work, not current model readiness. No unknown becomes a pass.', '',
    'Nine count suffixes on both sides are structurally present according to the 196-row saved four-annual field summary. Presence or completeness does not establish normal completion, validity, independent accuracy or rights. Surface labels come from saved source metadata, not a newly verified official calendar. Canada remains one family: WTA source labels identify Montreal; ATP generic Canada labels leave edition city NA. Other unsupported city fields remain NA, not invented.', '',
    'The inherited pilots retain 245 inventory records, 232 completed results and 231 valid bundles. ATP Indian Wells preserves four scoped PDF dissent resolutions; WTA Indian Wells preserves one quarantined completed bundle; Montreal preserves 42 original plus seven separately recovered bundles and raw status conflicts. No global canonical player linkage exists. The planner does not re-establish these facts by parsing matches.', '',
    ec_table(cells[c('tour','season','event_family','surface','saved_source_rows','evidence_state','selection_role','completed_denominator')]), '',
    '## Package definitions and comparison', '',
    'Package A: ATP/WTA Indian Wells, Roland-Garros and Wimbledon in 2023, plus the existing Montreal 2021 pilot as supplementary evidence. Four new clay/grass cells are the minimum for a two-tour surface probe. A 2021-only probe also needs four additions but lacks the existing ATP hard pilot in that season; 2023 aligns both existing Indian Wells pilots without inventing stronger evidence.', '',
    'Package B: the same three families crossed with both tours and 2021/2023: 12 core cells, two existing core pilots, ten new cells. Montreal 2021 is retained separately, producing 13 total retained/target cells and three existing pilots. It does not replace the matched Indian Wells hard anchor.', '',
    'Package C: all ten families in both tours and both saved seasons: 40 cells, three existing pilots, 37 additions. This is the broader saved slice of the eventual panel, not the complete development period; 2022 remains inaccessible. More within-surface event replication is useful later, but the larger burden is not the minimum initial anchor.', '',
    ec_table(p[c('package','core_cells','core_existing','supplementary_existing','total_cells','existing_reconciled','new_unvetted','new_source_rows','core_ATP','core_WTA','core_2021','core_2023','core_hard','core_clay','core_grass','matched_families_both_seasons')]), '',
    'Every source-row burden is a workload indicator, never a completed-match count or forecast sample size. Required references, valid bundles and work-hours are unknown.', '',
    ec_table(p[c('package','scientific_gap','remaining_confounding','entirely_offline_reconciliation','recommendation')]), '',
    '## Selection order, alternatives and minimality', '',
    paste0(seq_along(ec_order()),'. ',ec_order()), '',
    'This is a precedence order, not a weighted convenience score. A is minimal for its surface-probe objective but fails the preferred season crossing. B addresses that gap with fewer additions than C. No rights failure is offset by scientific utility: B remains only an evidence proposal.', '',
    'A balanced minimum has 2 tours x 2 seasons x 3 surfaces = 12 core cells. Enumerating all 18 combinations of six hard families, three clay families and the sole grass family confirms a ten-addition lower bound under the matched-family objective. Indian Wells reuses two reconciled cells; Canada would reuse one and other hard families none. Mixing IW 2023 with Montreal 2021 would sacrifice matched-family crossing; it is not an equivalent smaller anchor.', '',
    'Roland-Garros, Madrid and Rome tie at ten additions with Indian Wells/Wimbledon. Roland-Garros is the proposed clay representative because its saved G classification and 128 draw-size labels match Wimbledon across all four tour-season cells, yielding a more comparable clay/grass bracket context. This is a stated design preference, not evidence of better data, rights, more eligible matches or verified match-format rules. Those labels and actual competition formats require later confirmation. No missing rights/reference state is assumed favorable.', '',
    ec_table(ec_anchor_options(cells)), '',
    'Even B does not isolate a general causal surface effect: one event family represents each surface, ATP match-format differences need review, and Indian Wells moved from autumn 2021 to spring 2023 according to saved labels. It begins within-family season comparisons, not independent causal season effects. Montreal offers a WTA hard-event sensitivity in 2021 after IW 2021 reconciliation; comparable ATP within-surface event replication is absent. Two seasons cannot establish broad stability. C adds hard/clay event replication but still has only Wimbledon for grass.', '',
    'If separately admitted and authorized, B could begin tour-specific measurement, opportunity/missingness and nonredundancy checks across surface contexts and matched seasons, followed by separately approved incremental NPR/winning analysis. It cannot establish final factors, forecasting, 2024 validation or locked-2025 performance. Event/player-aware uncertainty and Phase 2B selection rules still apply.', '',
    '## Recommended cells', '',
    ec_table(new[c('tour','season','event_family','surface','source_event_id','saved_source_rows','readiness')]), '',
    'Existing core cells: ATP Indian Wells 2023 and WTA Indian Wells 2023. Supplementary only: WTA Montreal 2021. No cell is admitted by this list.', '',
    '## Cell-level prerequisites and evidence routes', '',
    'cell-prerequisites.csv supplies 592 records: 16 explicit prerequisites for each of the 37 cells proposed in A/B/C, with package membership, selected-B flag, current state, saved basis, required evidence, route and stage. All ten B targets carry every requirement below. Missing evidence remains missing; an available annual file is not a complete evidence package.', '',
    ec_table(unique(r$`cell-prerequisites`[c('prerequisite','saved_basis','required_evidence','evidence_route','required_stage')])), '',
    'Already saved aggregate scope/schema and source provenance can be checked offline now. Future count checks might use saved annuals after separate raw-row/reconciliation authority and status evidence. Required new-cell final inventories, reference provenance, official linkage and completion/status evidence are not present in the saved reference inventories. Obtaining or clarifying them requires a separately approved route with rights clearance; this phase drafts no URLs, searches, requests, contacts or request ceilings.', '',
    'Recovery need is unknown. Do not extrapolate Montreal recovery or Indian Wells precedence to new cells. Keep invalid/quarantined bundles and genuine missingness distinct. No source correction, imputation or score-syntax completion rule is proposed.', '',
    '## Rights and coverage limitations', '',
    'Saved documentation describes conditional CC BY-NC-SA 4.0 archive use for noncommercial research with attribution and applicable share-alike obligations; the mirror adds no rights. This is inherited documentation, not a new legal verification. Official/reference access, retention and extraction rights for expanded cells are not cleared. Existing pilot caching scope does not grant expansion permission. The saved WTA automated-access stop remains in force; ATP extraction rights remain unresolved. No substitute provider is approved.', '',
    'Publication and derivative rights remain BLOCKED_PENDING_RIGHTS_REVIEW for every cell. A later properly authorized private audit need not claim public-release clearance, but its local research/reference rights must pass independently. Retention/disposition of existing OTD evidence remains unresolved and no OTD action follows.', '',
    'Compute no new completed denominator or coverage percentage. Later reconciliation must preserve the non-bye universe and independently classify status before computing the 90% event gate. A partial anchor cannot satisfy or redefine the fixed ten-family 95% tour-season gate. Any later descriptive exception needs explicit bounded authority; factor-model admission remains blocked. No gate, panel or split is changed.', '',
    '## Historical Phase 2A and future current-context successor', '',
    'Historical Phase 2A pins PROJECT_CONTEXT.md before the Phase 2B success-criteria addition. Its unchanged entry point now correctly refuses the current context hash. The historical release is reproduced only with its original baseline code/context and saved evidence in an isolated historical environment. Do not rerun it under altered inputs, weaken its pin, overwrite its outputs or claim the current-context entry point passes.', '',
    ec_table(r$`current-context-requirements`), '',
    'These are requirements only; no successor is implemented. Current Phase 2B protocol/context are immutable inputs to this plan. Their future successor hashes must be fixed at its approved starting state. A difference in inherited pilot results must be investigated rather than overwritten or accepted because correlations improve.', '',
    '## Final decision and exact next user decision', '',
    '**READY_FOR_BOUNDED_EVIDENCE_PROPOSAL.** B is scientifically defensible, but required inventory, identity, status, count and reference-rights evidence is missing. It is not READY_FOR_OFFLINE_RECONCILIATION. The gaps are specific enough for a responsible bounded proposal, so this is not a no-defensible-expansion finding.', '',
    'The smallest next milestone is an offline evidence-route proposal for B, identifying a staged diagnostic first step, required evidence classes, rights prerequisites and explicit stop conditions. It may recommend stopping if no permissible route exists. Proposal approval would not authorize that route to be executed.', '',
    paste('**Exact next user approval:**',ec_next()), '',
    'No final factors, weights, practical margins, resampling implementation, denominator policy, dependency, acquisition, reconciliation, successor, model or publication is approved by this decision. Keep Q6/Q8-Q10 pending and OTD paused. The next task must end with a response-only ChatGPT Handoff of no more than 2,000 words.', '',
    '## Reproduction and verification', '',
    'Run Rscript R/plan_development_cohort_expansion.R and Rscript R/test_development_cohort_expansion_readiness.R from the repository root. The planner is inert when sourced. It reads only exact pinned aggregates/manifests/documents, rejects raw/row-level and forbidden-season paths, and permits only bounded local Git/hash subprocesses. No network-capable function is called.', '',
    'Seven CSVs remain ignored under data/pilot/development-cohort-expansion-readiness/: input-provenance, cell-readiness, package-comparison, cell-prerequisites, current-context-requirements, decisions and summary. These are aggregate planning artifacts, not player/match tables. NA is explicit, ordering and formatting are deterministic. Existing identical releases retain bytes and timestamps; changed or partial releases fail before replacement. An initial installation failure removes only newly created files and preserves any previous release.', '',
    'See [tests](../R/test_development_cohort_expansion_readiness.R), [status](status.md) and [data contract](data-source-contract.md) for actual verification results and current authority. Historical reports keep their milestone-specific recommendations; the current next-step record supersedes them. No fresh external state or research performance is verified.' )
}

ec_csv_lines <- function(x) {
  con<-textConnection('out','w',local=TRUE);on.exit(close(con))
  write.csv(x,con,row.names=FALSE,na='NA');out
}
ec_render <- function(r) {
  ec_need(identical(names(r),ec_names),'exact aggregate table names')
  z<-lapply(r,ec_csv_lines);z[[8]]<-ec_report(r)
  lapply(z,function(x)charToRaw(paste0(paste(x,collapse='\n'),'\n')))
}
ec_publish <- function(r) {
  # Fresh reconstruction is aggregate-only and binds output claims to all pinned inputs.
  ec_need(identical(r,ec_build(ec_load())),'supplied planning result differs from fresh pinned reconstruction')
  paths<-ec_paths();bytes<-ec_render(r)
  ec_need(!length(ec_process('git',c('ls-files','--','data/raw','data/pilot'))),'restricted data must be untracked')
  ec_need(setequal(ec_process('git',c('check-ignore','--',paths[1:7])),paths[1:7]),'all planning CSVs must be ignored')
  for(p in unique(c('data','data/pilot',ec_dir,'docs',paths)))
    ec_need(!nzchar(Sys.readlink(p))||is.na(Sys.readlink(p)),'symlink output path refused')
  if(dir.exists(ec_dir))ec_need(setequal(list.files(ec_dir,all.files=TRUE,no..=TRUE),basename(paths[1:7])),'partial or unexpected output directory')
  present<-file.exists(paths)
  if(any(present)) {
    ec_need(all(present),'partial existing release preserved without overwrite')
    for(i in seq_along(paths))ec_need(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),bytes[[i]]),'changed existing release preserved without overwrite')
    return(invisible(paths))
  }
  stage<-tempfile('phase2c-stage-');ec_need(dir.create(stage),'temporary staging directory')
  installed<-character();done<-FALSE;created_dir<-FALSE
  on.exit({if(!done){if(length(installed))unlink(installed);if(created_dir&&!length(list.files(ec_dir,all.files=TRUE,no..=TRUE)))unlink(ec_dir,recursive=TRUE)};unlink(stage,recursive=TRUE)},add=TRUE)
  for(i in seq_along(bytes))writeBin(bytes[[i]],file.path(stage,as.character(i)))
  ec_need(dir.create(ec_dir,recursive=FALSE),'approved aggregate directory creation');created_dir<-TRUE
  for(i in seq_along(paths)) {
    ec_need(!file.exists(paths[i]),'destination appeared during installation; preserve it')
    # Register destination first so an interrupted/failed copy is cleaned up too.
    installed<-c(installed,paths[i])
    ec_need(file.copy(file.path(stage,as.character(i)),paths[i],overwrite=FALSE),'aggregate installation failed')
  }
  done<-TRUE;invisible(paths)
}
plan_development_cohort_expansion <- function(write_outputs=TRUE) {
  inputs<-ec_load();r<-ec_build(inputs)
  if(write_outputs)ec_publish(r)
  r
}
if(sys.nframe()==0L) {
  result<-plan_development_cohort_expansion()
  message('Phase 2C: ',result$decisions$value[1],'; Package B, 12 core cells, 10 unvetted additions; no admission.')
}
