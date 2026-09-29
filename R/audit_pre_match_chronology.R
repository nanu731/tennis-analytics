# Phase 2K 1.0.0: evidence audit only; no chronology reconstruction or histories.
pk_version <- "1.0.0"
pk_dir <- "data/pilot/pre-match-chronology-audit"
pk_outputs <- c("match-evidence-ledger", "dependency-evidence-ledger", "chronology-summary")
pk_pins <- c(AGENTS.override.md = "7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
`data/pilot/broader-shortlist-revalidation/analysis-samples.csv` = "51ea4947dc1a8eeb53507dff19a6e0c756da263a7ac36121c4a909717eba1209",
`data/pilot/broader-shortlist-revalidation/collinearity.csv` = "855e17d0f42390292fba687a25e13471c087d267135453d508a9f61611633788",
`data/pilot/broader-shortlist-revalidation/npr-increments.csv` = "cc7ce39361fbfb3464482278b6be6a59075229516379bb6169de849c7bcfbe20",
`data/pilot/broader-shortlist-revalidation/same-match-win.csv` = "bc60bcd950ba2c271a579850155ee2b4ac69beed073be5f3da7d0fe13bb864f3",
`data/pilot/broader-shortlist-revalidation/stability-and-decision.csv` = "8f36e5fc403eab6196c203702a748e72c7eb5a53a221db51f6553c2b1c5d4b4c",
`data/pilot/development-2021/montreal-chronology-evidence/conflicts.csv` = "8e938ad910ece05452105b67a82e027a5149b3baddad8af0e16e2db34afadd6f",
`data/pilot/development-2021/montreal-chronology-evidence/decisions.csv` = "cf9a4c1566f65acc24ce3ca8a1187bac7b3bcd47ab20fa48bf84804daca1d20e",
`data/pilot/development-2021/montreal-chronology-evidence/dispositions.csv` = "d2f137712fa2a775698c3109801629c106b03d2d6d88d76c670f7ff8e9ea94ad",
`data/pilot/development-2021/montreal-chronology-evidence/edges.csv` = "56b87368170b93da809a4fd47f8694eec462d5cc08d93c4e72a5d5e576c908f0",
`data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv` = "775d542da9631493885d3e28814e56ed84d1fe337dbc1d60542ef4dbf9781812",
`data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv` = "b3ebf221967bf54fb3b7f818065e55109b2d63faffed83d8f4a79ba6e3126640",
`data/pilot/development-2021/montreal-chronology-evidence/observations.csv` = "782f2867a2b1bc3005220448a7f9f17aeca27a75b0ba8019f3eecfef4dc82771",
`data/pilot/development-2021/montreal-chronology-evidence/options.csv` = "07f802ed255dfb918b5feb49074ca94bd53c3f3a52f79a1f106a94edcde02205",
`data/pilot/development-2021/montreal-chronology-evidence/players.csv` = "6f0e3136b2917ce94b0483fb7a4f2c5e9013d23e74ca185cea3299b3d34428bf",
`data/pilot/development-2021/montreal-chronology-evidence/summary.csv` = "4ebee91ecb18c06078b242b527422972724e682edc9f9e8861c7019de606678f",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/event-boundary-feasibility/event-boundary-evidence.csv` = "1a05809feba86664627c707a6b0b14b678bc06418b48c68473cc479ef0a74c61",
`data/pilot/exploratory-four-factors-analysis/association-summary.csv` = "a90edc88af0ffe0a32369b620669278861073c543da9d98393990f72aea1103e",
`data/pilot/exploratory-four-factors-analysis/availability-summary.csv` = "61f7d0c7ccbfa1de02430bd94368999bad94e34e5dca7324808ff820cddf284f",
`data/pilot/exploratory-four-factors-analysis/candidate-scorecard.csv` = "6f33f7e7696d86343f3a05e8fc1a13128c1b96e0cd5a093cf36007eb91d308f3",
`data/pilot/exploratory-four-factors-analysis/candidate-set-registry.csv` = "24ac927358e3f5f886f6aa6408d66fffacb1b7a25fa77516bb4ebab2ec74e3b5",
`data/pilot/exploratory-four-factors-analysis/collinearity-diagnostics.csv` = "2b93b53d46f713de9d2f64224a4c98d1d09b9e72f23e5cb925908ef32c7af9c1",
`data/pilot/exploratory-four-factors-analysis/decisions.csv` = "1e9df225d1a706275f1b61601544b0b04b69475e7247da462ea165cd9dd648a3",
`data/pilot/exploratory-four-factors-analysis/input-provenance.csv` = "0e457359a11578c4979e2f4d2e0683fd15632b203ecd1c517c5a612dd1afc51e",
`data/pilot/exploratory-four-factors-analysis/match-metrics.csv` = "b7d4c29823661c73948c2cc62d7938fc7ea9cb986dd7f227f4d56ee0ba2c32f5",
`data/pilot/exploratory-four-factors-analysis/npr-incremental-contributions.csv` = "0fcc7d2429f9b113cb98b3100543421090e564b16d5627e566dc42df65148aa1",
`data/pilot/exploratory-four-factors-analysis/npr-model-summary.csv` = "a3182007d5e84d48351c944bc5d9bd81e0de09565798dc94b52b88dc3b96adc9",
`data/pilot/exploratory-four-factors-analysis/reproduction-comparison.csv` = "fe7853eb9d386522f9ee6b27de92f7c58dff4755e0965ef2cdef388194c5e1dd",
`data/pilot/exploratory-four-factors-analysis/same-match-win-summary.csv` = "9572043881b14d0a1e7c61e312629b09efb1baae67f79f0d45a4f767d0630c72",
`data/pilot/exploratory-four-factors-analysis/stability-summary.csv` = "10b63188053b63476c9c3e8fbc20711b0f7720ebe9645b1b406a0f48ed2802a5",
`data/pilot/exploratory-four-factors-analysis/summary.csv` = "3dfad49e9c9bf81008ce06c40d9b07bf8691dd72b8e6a6a0d7ec733bdabe7f9a",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
`data/pilot/service-game-convention-diagnostic/discrepancy-summary.csv` = "ce77dfd1fd09c4fe3fff335f4edad286bef192fdbea7c736e14e08a17d4386c0",
`data/pilot/service-game-convention-diagnostic/hypothesis-summary.csv` = "abfbce4bfb3b0dcfa54b7ebb933ef4f82b196a48b560722a2b85c9861a4eb57c",
`data/pilot/source-defined-cohort-admission/cell-coverage.csv` = "b50f5126e6e29ca6ee214e87fec660a8e96d7dc7d088df56b898cfb075abb91c",
`data/pilot/source-defined-cohort-admission/cohort-membership.csv` = "398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10",
`data/pilot/source-defined-cohort-admission/field-availability.csv` = "260fa9bdfb7c486749f639d9358b5732bd42008236523cc49f5086fc5a1b4468",
`data/pilot/source-defined-cohort-admission/input-provenance.csv` = "ed39e3e7907271786b3b97f3dada42c1b5384e4f03a45e5fab2e48fb0b2325f5",
`data/pilot/source-defined-cohort-admission/row-dispositions.csv` = "24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6",
`data/pilot/source-defined-cohort-admission/summary.csv` = "b2e9953f1eeb0a9f28ae092fb1720b089bb15ce96ff5de6275be69068670d950",
`data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html` = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
`data/raw/reference/indian-wells-2023-anomaly/wta-draws.html` = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
`data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html` = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
`data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf` = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
`data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt` = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
`data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt` = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
`data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf` = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
`data/raw/reference/montreal-2021-feasibility/draw_html.html` = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
`data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf` = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
`data/raw/reference/montreal-2021-feasibility/LS001.html` = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
`data/raw/reference/montreal-2021-feasibility/LS002.html` = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
`data/raw/reference/montreal-2021-feasibility/LS003.html` = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
`data/raw/reference/montreal-2021-feasibility/LS004.html` = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
`data/raw/reference/montreal-2021-feasibility/LS005.html` = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
`data/raw/reference/montreal-2021-feasibility/LS006.html` = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
`data/raw/reference/montreal-2021-feasibility/LS007.html` = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
`data/raw/reference/montreal-2021-feasibility/LS042.html` = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
`data/raw/reference/montreal-2021-feasibility/LS049.html` = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
`data/raw/reference/montreal-2021-feasibility/overview.html` = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv` = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv` = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json` = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv` = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/broader-shortlist-revalidation.md` = "e2b80a74d6048bdcbfdad34e5f83fcd9213a7b76eaef2b0b83d4502ecd03f61b",
`docs/event-boundary-feasibility.md` = "19685452eb8af4d587ebb7c816f56748544c3037bae797dc81fe7344ce7f8b9b",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/occam-candidate-and-data-decision.md` = "028dcca5e8477e4d41d18e431514868e966a64f7d474a09efcf7b7cba272dab4",
`docs/service-game-convention-diagnostic.md` = "9ba3304f631a9b20d5ed41a8187c56cf0f739de776a7c95c28d0dd796407954d",
`docs/source-defined-cohort-audit.md` = "5aa928d4f270357739b384337a71e79bc79f52461cbd7740a00c839e5698f38b",
`docs/wta-2021-montreal-chronology-policy.md` = "cfbbe87732d813e4e31f1b2bd2478bb92d2329150fee8c951700ed97c31c421c",
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
PROJECT_CONTEXT.md = "da074cd4845d04d2cb3b6bc8dfc5b03a48ec5a667cf6ef48b0fc0fce11079b37",
`R/analyze_exploratory_four_factors_pilots.R` = "49061142662178a0366330d1c5064b8d8716f8bf96923050d9d429b2bdbdc6d9",
`R/audit_source_defined_cohort.R` = "73b79972d2d4bb0c8d651df1d080ed92bf9b0357987af65dbd53e839db5f7bb6",
`R/diagnose_service_game_conflicts.R` = "cd63780100bd845094f2aaf306ebae2036685159c14babf3618165efb838b206",
`R/revalidate_broader_shortlist.R` = "685d6a3ac26d5fd3e5ea8230fb716722d40c4ea6a9a26b2ddff3865cf86e642e",
`R/test_broader_shortlist.R` = "ca7a6fb3a3b827a9f5be9f40ce599a4d4ddb32ad8732c633acebc99df70f077c",
`R/test_exploratory_four_factors_pilots.R` = "3f23ab8d8c8881d420e46e9fcdc0e912b7f8769e8c078ce7c3866dd776c557b2",
`R/test_service_game_conflicts.R` = "269fe09f56325694dd4978cbefb63c72fa1d0fe650a625d67923300cd407a73d",
`R/test_source_defined_cohort.R` = "cf36933bccbd30457f9042804be78fcdbc54c8c925ca9e1bc742d24f3b7361eb"
)
pk_pins <- c(pk_pins,
  `data/pilot/inventory/inventory-summary.csv`="f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
  `data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv`="c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1")
pk_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
pk_hash <- function(p)if(!file.exists(p))'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
pk_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
pk_join <- function(x) {x<-as.character(x);paste(sort(unique(x[!is.na(x)&nzchar(x)]),method='radix'),collapse=';')}
pk_verify <- function(pins=pk_pins) {
  actual<-vapply(names(pins),pk_hash,'');bad<-names(pins)[actual!=pins]
  pk_need(!length(bad),paste('Frozen input missing/changed:',paste(bad,collapse=';')))
}
pk_ignored <- function(dir=pk_dir) {
  paths<-file.path(dir,paste0(pk_outputs,'.csv'))
  result<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
  pk_need(setequal(result,paths),'STOP: all output paths must already be ignored')
  invisible(TRUE)
}
# Synthetic-bound predicate: observed labels never enter it as verified bounds.
# Bounds must be externally justified in one reconciled clock/precision system.
pk_bound <- function(lower=NA_real_,upper=NA_real_,state='UNKNOWN',clock='UNKNOWN',role='UNKNOWN')
  list(lower=lower,upper=upper,state=state,clock=clock,role=role)
pk_valid <- function(b,role)identical(b$state,'VERIFIED')&&identical(b$role,role)&&
  identical(b$clock,'UTC_RECONCILED')&&length(b$lower)==1L&&length(b$upper)==1L&&
  is.finite(b$lower)&&is.finite(b$upper)&&b$lower<=b$upper
pk_release <- function(completion,availability,cutoff,target_start,precedence=FALSE,preplay_attested=FALSE,conflict=FALSE) {
  reasons<-character()
  if(conflict)reasons<-c(reasons,'CONFLICTING_EVIDENCE')
  for(role in c('completion','availability','cutoff')) {
    b<-get(role);if(!pk_valid(b,role))reasons<-c(reasons,paste0('UNVERIFIED_',toupper(role)))
  }
  preplay<-isTRUE(preplay_attested)||(pk_valid(cutoff,'cutoff')&&pk_valid(target_start,'start')&&cutoff$upper<target_start$lower)
  if(!preplay)reasons<-c(reasons,'NO_VERIFIED_PREPLAY_CUTOFF')
  if(pk_valid(cutoff,'cutoff')&&pk_valid(target_start,'start')&&cutoff$upper>=target_start$lower)
    reasons<-c(reasons,'CUTOFF_NOT_STRICTLY_PREPLAY')
  if(pk_valid(completion,'completion')&&pk_valid(availability,'availability')&&availability$upper<completion$lower)
    reasons<-c(reasons,'AVAILABILITY_PRECEDES_COMPLETION_CONFLICT')
  # Bracket precedence is reported separately; it cannot authenticate an unknown bound.
  if(pk_valid(completion,'completion')&&pk_valid(cutoff,'cutoff')&&completion$upper>=cutoff$lower)
    reasons<-c(reasons,'COMPLETION_NOT_STRICTLY_BEFORE_CUTOFF')
  if(pk_valid(availability,'availability')&&pk_valid(cutoff,'cutoff')&&availability$upper>=cutoff$lower)
    reasons<-c(reasons,'AVAILABILITY_NOT_STRICTLY_BEFORE_CUTOFF')
  list(supported=!length(reasons),reasons=pk_join(reasons))
}
pk_decide <- function(match_requirements,event_requirements,expected_matches,observed_matches) {
  complete<-length(expected_matches)>0&&!anyDuplicated(expected_matches)&&length(observed_matches)==length(expected_matches)&&!anyDuplicated(observed_matches)&&setequal(observed_matches,expected_matches)
  pass<-function(x)complete&&length(x)>0&&!anyNA(x)&&all(x)
  if(pass(match_requirements))'MATCH_SEQUENTIAL_SUPPORTED_BY_SAVED_EVIDENCE' else if(pass(event_requirements))
    'EVENT_ENTRY_ONLY_SUPPORTED_BY_SAVED_EVIDENCE' else 'NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE'
}
pk_inputs <- function() {
  pk_ignored();pk_verify()
  root<-'data/pilot/development-2021/montreal-chronology-evidence/'
  x<-list(m=pk_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
    d=pk_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'),
    md=pk_read(paste0(root,'dispositions.csv')),pages=pk_read(paste0(root,'match-page-observations.csv')),
    edges=pk_read(paste0(root,'edges.csv')),players=pk_read(paste0(root,'players.csv')),
    boundary=pk_read('data/pilot/event-boundary-feasibility/event-boundary-evidence.csv'))
  pk_need(nrow(x$m)==2580&&!anyDuplicated(x$m$match_id)&&setequal(x$m$match_id,x$d$match_id[x$d$membership=='INCLUDED']),'Frozen membership mismatch')
  x$d<-x$d[match(x$m$match_id,x$d$match_id),];pk_need(all(x$d$membership=='INCLUDED'),'Excluded row entered cohort')
  pk_need(identical(x$m$player_a_id,x$d$player_a_id)&&identical(x$m$player_b_id,x$d$player_b_id),'Orientation mismatch')
  x$boundary<-x$boundary[x$boundary$cell_id %in% x$m$cell_id,,drop=FALSE]
  # Fail if a future changed evidence schema demands a new interpretation.
  pk_need(all(x$boundary$bound_supported=='FALSE'),'Unexpected supported bound requires versioned review')
  pk_need(all(x$md$actual_start_date=='' & x$md$completion_date=='' & x$md$result_available_at==''),'Unexpected actual timing requires review')
  for(field in c('establishes_date','establishes_time','establishes_result_publication_time'))
    pk_need(all(x$edges[[field]]=='FALSE'),'Bracket timing promotion forbidden')
  # Verify saved observation paths and locator hashes without rerunning old audits.
  for(tab in list(x$pages,x$boundary))for(i in seq_len(nrow(tab))) {
    p<-tab$source_path[i];pk_need(p %in% names(pk_pins)&&pk_pins[[p]]==tab$sha256[i],'Observation provenance not pinned')
  }
  x
}
pk_matches <- function(input) {
  m<-input$m;d<-input$d;pages<-input$pages;md<-input$md;b<-input$boundary
  out<-m
  out$tourney_date_label<-d$tourney_date;out$source_match_num<-d$match_num
  out$source_order_role<-'LOCATOR_ONLY_NOT_CHRONOLOGY'
  out$duration_minutes_label<-d$minutes;out$duration_role<-'ELAPSED_DURATION_NOT_CLOCK_ANCHOR'
  out$completion_status<-d$completion_status
  out$completion_evidence<-ifelse(nzchar(m$pilot_policy),'SAVED_PILOT_CORROBORATION_SCOPED','SOURCE_REPORTED_NORMAL_ONLY')
  out$completion_time_status<-'UNKNOWN';out$actual_start_status<-'UNKNOWN'
  out$actual_start_lower<-out$actual_start_upper<-out$completion_upper<-out$availability_upper<-out$cutoff_lower<-'UNKNOWN'
  out$timing_precision<-out$timezone<-out$result_availability_status<-out$cutoff_status<-'UNKNOWN'
  out$source_provenance<-paste0('data/pilot/source-defined-cohort-admission/row-dispositions.csv#match_id=',m$match_id)
  p<-match(m$match_id,sub('^sackmann:','',pages$source_audit_id));has<-!is.na(p)
  out$published_match_start<-out$published_match_end<-out$published_status<-out$published_match_source<-out$published_match_locator<-out$published_match_sha256<-out$retrieved_at_utc<-''
  for(pair in list(c('published_match_start','published_start_date'),c('published_match_end','published_end_date'),
    c('published_status','published_status'),c('published_match_source','source_path'),c('published_match_locator','metadata_locator'),
    c('published_match_sha256','sha256'),c('retrieved_at_utc','retrieved_at_utc')))out[[pair[1]]][has]<-pages[[pair[2]]][p[has]]
  out$match_date_evidence<-ifelse(has,'PUBLISHED_LITERAL_SEMANTICS_UNVERIFIED','NO_SAVED_MATCH_DATE_EVIDENCE')
  out$retrieval_role<-ifelse(has,'RETRIEVAL_NOT_HISTORICAL_AVAILABILITY','NO_MATCH_PAGE_RETRIEVAL')
  out$published_event_text<-vapply(m$cell_id,function(cell)pk_join(b$observed_value[b$cell_id==cell & b$field %in% c('printed_draw_timing_text','published_event_window')]),'')
  out$event_text_role<-ifelse(nzchar(out$published_event_text),'PUBLISHED_LITERAL_NOT_ACTUAL_BOUND','NO_SAVED_BOUNDARY_LITERAL')
  out$event_cutoff_status<-out$event_completion_bound<-out$event_availability_bound<-'UNKNOWN'
  mi<-match(m$match_id,sub('^sackmann:','',md$source_audit_id));montreal<-!is.na(mi)
  out$player_chain_evidence<-ifelse(montreal,'SAVED_MONTREAL_PLAYER_CHAINS_ACCOUNTED','NOT_ESTABLISHED')
  e<-input$edges;from<-sub('^sackmann:','',e$from_audit_id);to<-sub('^sackmann:','',e$to_audit_id)
  good<-from %in% m$match_id & to %in% m$match_id
  out$admitted_direct_in_edges<-vapply(m$match_id,function(id)sum(to[good]==id),1L)
  out$admitted_direct_out_edges<-vapply(m$match_id,function(id)sum(from[good]==id),1L)
  out$chronology_conflicts<-vapply(seq_len(nrow(m)),function(i)pk_join(c(
    if(montreal[i])'MONTREAL_EVENT_WINDOW_DISAGREEMENT',if(has[i])'SCHEDULED_METADATA_FINISHED_CARD',
    if(montreal[i]&&md$official_code[mi[i]]=='LS007')'LS007_QF_PUBLISHED_DATE_DIFFERENCE')),'')
  out$missing_evidence<-'NO_VERIFIED_MATCH_START;NO_VERIFIED_COMPLETION_BOUND;NO_HISTORICAL_AVAILABILITY_BOUND;NO_VERIFIED_MATCH_CUTOFF;NO_VERIFIED_EVENT_CUTOFF;NO_VERIFIED_EVENT_RELEASE'
  out$match_sequential_supported<-out$event_entry_supported<-FALSE
  out
}
pk_row <- function(kind,approach,tour,player='',a='',b='',ca='',cb='',relation='UNORDERED',status='BLOCKED',reason='',provenance='',conditional=FALSE,eligible=TRUE) {
  n<-max(length(a),length(ca),length(player),1)
  data.frame(kind=rep_len(kind,n),approach=rep_len(approach,n),tour=rep_len(tour,n),player_id=rep_len(player,n),
    match_a=rep_len(a,n),match_b=rep_len(b,n),cell_a=rep_len(ca,n),cell_b=rep_len(cb,n),
    evidence_relation=rep_len(relation,n),status=rep_len(status,n),reason=rep_len(reason,n),
    provenance=rep_len(provenance,n),conditional_on_future_scope=rep_len(conditional,n),eligible_endpoints=rep_len(eligible,n),
    a_to_b_release_supported=FALSE,b_to_a_release_supported=FALSE,stringsAsFactors=FALSE)
}
pk_dependencies <- function(x,input) {
  rows<-list(pk_row('MATCH_CUTOFF','MATCH_SEQUENTIAL',x$audit_tour,a=x$match_id,ca=x$cell_id,
    reason='NO_VERIFIED_PREPLAY_MATCH_CUTOFF',provenance=x$source_provenance))
  cells<-unique(x[c('cell_id','audit_tour')]);cells<-cells[order(cells$cell_id,method='radix'),]
  rows[[length(rows)+1]]<-pk_row('EVENT_CUTOFF','EVENT_ENTRY',cells$audit_tour,ca=cells$cell_id,
    reason='NO_INDEPENDENT_PREPLAY_EVENT_BOUND',provenance='data/pilot/event-boundary-feasibility/event-boundary-evidence.csv')
  # Full unordered co-appearance graph, not a history or a selected prior sequence.
  for(tour in c('ATP','WTA')) {
    z<-x[x$audit_tour==tour,];players<-sort(unique(c(z$player_a_id,z$player_b_id)),method='radix')
    for(p in players) {
      idx<-which(z$player_a_id==p|z$player_b_id==p);idx<-idx[order(z$match_id[idx],method='radix')]
      if(length(idx)<2)next
      pairs<-combn(idx,2);a<-pairs[1,];bb<-pairs[2,]
      rows[[length(rows)+1]]<-pk_row('SHARED_PLAYER_MATCH_PAIR','MATCH_SEQUENTIAL',tour,player=p,
        a=z$match_id[a],b=z$match_id[bb],ca=z$cell_id[a],cb=z$cell_id[bb],conditional=TRUE,
        reason='NO_VERIFIED_CUTOFF_OR_COMPLETION_OR_AVAILABILITY;HISTORY_WINDOW_UNSELECTED',
        provenance='frozen Phase 2H exact player IDs; unordered co-appearance only')
    }
    cs<-cells$cell_id[cells$audit_tour==tour];pairs<-combn(cs,2)
    rows[[length(rows)+1]]<-pk_row('EVENT_RELEASE_PAIR','EVENT_ENTRY',tour,ca=pairs[1,],cb=pairs[2,],conditional=TRUE,
      reason='NO_VERIFIED_EVENT_COMPLETION_OR_AVAILABILITY_OR_CUTOFF;HISTORY_SCOPE_UNSELECTED',
      provenance='data/pilot/event-boundary-feasibility/event-boundary-evidence.csv')
    for(approach in c('MATCH_SEQUENTIAL','EVENT_ENTRY'))for(kind in c('INITIALIZATION_AND_HISTORY_SCOPE','FITTED_STATE_ASOF_AND_DEPENDENCY_SCOPE'))
      rows[[length(rows)+1]]<-pk_row(kind,approach,tour,reason='NOT_SPECIFIED_OR_VERIFIED;NO_HISTORY_OR_MODEL_IMPLEMENTED',provenance='adopted Montreal chronology policy D1/D2/D11/D12; Phase 1R specification')
  }
  e<-input$edges;a<-sub('^sackmann:','',e$from_audit_id);b<-sub('^sackmann:','',e$to_audit_id)
  good<-a %in% x$match_id & b %in% x$match_id
  pk_need(sum(good)==45&&nrow(e)==54,'Saved edge accounting changed')
  for(i in which(good)) {
    ia<-match(a[i],x$match_id);ib<-match(b[i],x$match_id)
    pk_need(e$player_id[i] %in% c(x$player_a_id[ia],x$player_b_id[ia])&&e$player_id[i] %in% c(x$player_a_id[ib],x$player_b_id[ib]),'Bracket identity mismatch')
  }
  rows[[length(rows)+1]]<-pk_row('SAVED_BRACKET_EDGE','ORDINAL_EVIDENCE_ONLY','WTA',player=e$player_id,a=a,b=b,
    ca='WTA|2021|Canada',cb='WTA|2021|Canada',relation='A_PRECEDES_B_PLAYER_RELATIVE_ONLY',
    status=ifelse(good,'PARTIAL_SUPPORT_NOT_RELEASE','EXCLUDED_ENDPOINT_AUDIT_ONLY'),eligible=good,
    reason=ifelse(good,'NO_ACTUAL_TIMING_OR_CUTOFF_OR_HISTORICAL_AVAILABILITY','EXCLUDED_ENDPOINT_NO_HISTORY_UPDATE'),
    provenance=paste(e$html_from_locator,e$html_to_locator,e$pdf_from_locator,e$pdf_to_locator,e$html_sha256,e$pdf_sha256,sep=' | '))
  out<-do.call(rbind,rows)
  # Attach direct feeder evidence to the matching unordered pair without orienting a history.
  pairkey<-function(player,a,b)paste(player,pmin(a,b),pmax(a,b),sep='|')
  candidates<-which(out$kind=='SHARED_PLAYER_MATCH_PAIR')
  edgekey<-pairkey(e$player_id[good],a[good],b[good])
  hit<-match(pairkey(out$player_id[candidates],out$match_a[candidates],out$match_b[candidates]),edgekey)
  ii<-candidates[!is.na(hit)];jj<-which(good)[hit[!is.na(hit)]]
  pk_need(length(ii)==45,'Direct feeder pairs not accounted for exactly')
  out$evidence_relation[ii]<-ifelse(out$match_a[ii]==a[jj],'A_PRECEDES_B_PLAYER_RELATIVE_ONLY','B_PRECEDES_A_PLAYER_RELATIVE_ONLY')
  out$provenance[ii]<-paste0(out$provenance[ii],'; saved edges.csv row ',jj)
  out<-out[order(out$kind,out$tour,out$player_id,out$cell_a,out$cell_b,out$match_a,out$match_b,method='radix'),]
  out$dependency_id<-sprintf('D%06d',seq_len(nrow(out)));rownames(out)<-NULL;out
}
pk_summary <- function(x,d,input,decision) {
  rows<-list();add<-function(section,measure,value,tour='',season='',cell='',surface='',unit='records',state='MEASURED',detail='')
    rows[[length(rows)+1]]<<-data.frame(section=section,tour=tour,season=season,cell_id=cell,surface=surface,measure=measure,value=as.character(value),unit=unit,evidence_status=state,detail=detail)
  groups<-list(list(z=x,field='all',id='ALL'))
  for(field in c('audit_tour','cell_id'))for(id in sort(unique(x[[field]]),method='radix'))groups[[length(groups)+1]]<-list(z=x[x[[field]]==id,],field=field,id=id)
  for(g in groups) {
    z<-g$z;tour<-pk_join(z$audit_tour);season<-pk_join(z$audit_season);surface<-pk_join(z$surface);cell<-if(g$field=='cell_id')g$id else ''
    counts<-c(admitted=nrow(z),source_reported_normal=sum(z$completion_status=='source_reported_normal'),
      scoped_pilot_completion=sum(z$completion_evidence=='SAVED_PILOT_CORROBORATION_SCOPED'),
      published_match_date_only=sum(nzchar(z$published_match_start)),verified_actual_start=sum(z$actual_start_status=='VERIFIED'),
      verified_completion_time=sum(z$completion_time_status=='VERIFIED'),verified_historical_availability=sum(z$result_availability_status=='VERIFIED'),
      verified_match_cutoff=sum(z$cutoff_status=='VERIFIED'),saved_player_chains=sum(z$player_chain_evidence=='SAVED_MONTREAL_PLAYER_CHAINS_ACCOUNTED'),
      chronology_conflict_records=sum(nzchar(z$chronology_conflicts)),match_sequential_supported=sum(z$match_sequential_supported),event_entry_supported=sum(z$event_entry_supported))
    for(k in names(counts))add(paste0('matches_',g$field),k,counts[k],tour,season,cell,surface)
  }
  for(t in c('ATP','WTA'))for(kind in unique(d$kind)) {
    z<-d[d$tour==t&d$kind==kind,];add('dependencies',kind,nrow(z),tour=t,unit='ledger_rows',detail=pk_join(z$status))
  }
  add('dependencies','shared_player_within_cell',sum(d$kind=='SHARED_PLAYER_MATCH_PAIR'&d$cell_a==d$cell_b),unit='unordered_player_pair_memberships')
  add('dependencies','shared_player_cross_cell',sum(d$kind=='SHARED_PLAYER_MATCH_PAIR'&d$cell_a!=d$cell_b),unit='unordered_player_pair_memberships')
  add('dependencies','supported_temporal_releases',sum(d$a_to_b_release_supported|d$b_to_a_release_supported),unit='ledger_rows')
  add('bracket','admitted_edges',sum(d$kind=='SAVED_BRACKET_EDGE'&d$eligible_endpoints),unit='edges',state='PLAYER_RELATIVE_ONLY')
  add('bracket','excluded_endpoint_edges',sum(d$kind=='SAVED_BRACKET_EDGE'&!d$eligible_endpoints),unit='edges',state='AUDIT_ONLY')
  b<-input$boundary
  for(i in seq_len(nrow(b)))add('saved_boundary_observation',b$field[i],b$observed_value[i],cell=b$cell_id[i],unit='saved_literal_or_missing_evidence',state=b$evidence_role[i],detail=paste(b$reason[i],b$source_path[i],b$locator[i],b$sha256[i],sep=' | '))
  page_ids<-sub('^sackmann:','',input$pages$source_audit_id)
  add('page_evidence','saved_pages',length(page_ids),unit='pages',state='PUBLISHED_LITERAL_ONLY')
  add('page_evidence','admitted_pages',sum(page_ids %in% x$match_id),unit='pages',state='PUBLISHED_LITERAL_ONLY')
  add('page_evidence','excluded_pages',sum(!page_ids %in% x$match_id),unit='pages',state='AUDIT_ONLY',detail=pk_join(input$pages$official_code[!page_ids %in% x$match_id]))
  add('scope','input_pins',length(pk_pins),unit='files');add('scope','event_cells',length(unique(x$cell_id)),unit='cells')
  add('scope','forecast_ready_cells',0,unit='cells',state='BLOCKED',detail='All expected cells retained; no cutoff or release is established')
  add('decision','terminal_decision',decision,unit='decision',state='FINAL_FOR_SAVED_SCOPE')
  out<-do.call(rbind,rows);rownames(out)<-NULL;out
}
audit_pre_match_chronology <- function(write_outputs=TRUE) {
  input<-pk_inputs();x<-pk_matches(input);d<-pk_dependencies(x,input)
  # A declared dependency scope is required before any positive project-wide claim.
  requirements<-function(approach) {
    z<-d[d$approach==approach,]
    c(if(approach=='MATCH_SEQUENTIAL')x$match_sequential_supported else x$event_entry_supported,
      ifelse(z$conditional_on_future_scope,z$a_to_b_release_supported|z$b_to_a_release_supported,z$status=='SUPPORTED'))
  }
  decision<-pk_decide(requirements('MATCH_SEQUENTIAL'),requirements('EVENT_ENTRY'),input$m$match_id,x$match_id)
  r<-setNames(list(x,d,pk_summary(x,d,input,decision)),pk_outputs)
  pk_verify();if(write_outputs)pk_publish(r);r
}
pk_publish <- function(r,dir=pk_dir) {
  pk_ignored();pk_verify();pk_need(identical(names(r),pk_outputs),'Output scope')
  stage<-tempfile('.phase2k-',tmpdir=dirname(dir));dir.create(stage);on.exit(unlink(stage,recursive=TRUE),add=TRUE)
  for(i in seq_along(r))write.table(r[[i]],file.path(stage,paste0(names(r)[i],'.csv')),sep=',',quote=TRUE,row.names=FALSE,na='UNKNOWN',eol='\n',qmethod='double')
  new<-file.path(stage,paste0(pk_outputs,'.csv'))
  if(dir.exists(dir)) {
    pk_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(new)),'Existing directory scope differs; preserve it')
    old<-file.path(dir,basename(new));pk_need(identical(unname(vapply(old,pk_hash,'')),unname(vapply(new,pk_hash,''))),'Existing release differs; preserve it')
  } else {
    pk_need(file.rename(stage,dir),'Atomic output release failed')
  }
  invisible(r)
}
if(sys.nframe()==0L) {r<-audit_pre_match_chronology();print(r[[3]][r[[3]]$section=='decision',c('measure','value')])}
