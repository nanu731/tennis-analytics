# Phase 2I diagnostic 1.0.0. Offline aggregate-only; no admission changes.
sg_version <- '1.0.0'
sg_dir <- 'data/pilot/service-game-convention-diagnostic'
sg_outputs <- c('discrepancy-summary','hypothesis-summary')
sg_hash <- function(path) {
  if(!file.exists(path)||dir.exists(path))return('MISSING')
  strsplit(system2('shasum',c('-a','256',shQuote(path)),stdout=TRUE),' ')[[1]][1]
}
sg_need <- function(ok,message) if(!isTRUE(ok))stop(message,call.=FALSE)
sg_read <- function(path)read.csv(path,colClasses='character',na.strings=NULL,check.names=FALSE)
# Independent pins from the verified Phase 2H baseline; no historical runner is invoked.
sg_pins <-  c(`R/audit_source_defined_cohort.R` = "73b79972d2d4bb0c8d651df1d080ed92bf9b0357987af65dbd53e839db5f7bb6",
`R/test_source_defined_cohort.R` = "cf36933bccbd30457f9042804be78fcdbc54c8c925ca9e1bc742d24f3b7361eb",
`docs/source-defined-cohort-audit.md` = "5aa928d4f270357739b384337a71e79bc79f52461cbd7740a00c839e5698f38b",
`data/pilot/source-defined-cohort-admission/cell-coverage.csv` = "b50f5126e6e29ca6ee214e87fec660a8e96d7dc7d088df56b898cfb075abb91c",
`data/pilot/source-defined-cohort-admission/cohort-membership.csv` = "398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10",
`data/pilot/source-defined-cohort-admission/field-availability.csv` = "260fa9bdfb7c486749f639d9358b5732bd42008236523cc49f5086fc5a1b4468",
`data/pilot/source-defined-cohort-admission/input-provenance.csv` = "ed39e3e7907271786b3b97f3dada42c1b5384e4f03a45e5fab2e48fb0b2325f5",
`data/pilot/source-defined-cohort-admission/row-dispositions.csv` = "24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6",
`data/pilot/source-defined-cohort-admission/summary.csv` = "b2e9953f1eeb0a9f28ae092fb1720b089bb15ce96ff5de6275be69068670d950",
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
`R/analyze_exploratory_four_factors_pilots.R` = "49061142662178a0366330d1c5064b8d8716f8bf96923050d9d429b2bdbdc6d9",
`R/test_exploratory_four_factors_pilots.R` = "3f23ab8d8c8881d420e46e9fcdc0e912b7f8769e8c078ce7c3866dd776c557b2",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
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
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
PROJECT_CONTEXT.md = "df21ae0f5b4b1035a016a2b29e807d31c4eca19d61fe1728405cc1e1a53894e6",
AGENTS.override.md = "7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b",
`docs/occam-candidate-and-data-decision.md` = "028dcca5e8477e4d41d18e431514868e966a64f7d474a09efcf7b7cba272dab4"
)
sg_verify <- function(pins=sg_pins) {
  observed<-setNames(vapply(names(pins),sg_hash,''),names(pins))
  sg_need(identical(observed,pins),'Missing or changed saved evidence; diagnostic blocked')
  invisible(observed)
}
sg_reference <- function() {
  # Reuse a pinned prior extraction and its pinned underlying saved pages, not a fresh scrape.
  p<-sg_read('data/pilot/anomaly/anomaly-source-comparison.csv')
  p<-p[p$source_match_key=='sackmann:WTA:2023-609:268',]
  counts<-p[p$field %in% c('w_SvGms','l_SvGms') & p$reference_id=='wta_match',]
  scores<-p[p$field=='score' & p$reference_id %in% c('wta_match','wta_draw_page','wta_draw_pdf','tennis_abstract'),]
  sg_need(nrow(counts)==2 && setequal(counts$field,c('w_SvGms','l_SvGms')) &&
    all(counts$source_value=='11' & counts$reference_value=='11') &&
    all(counts$structural_assessment=='structurally invalid') && nrow(scores)==4 &&
    all(scores$source_value=='4-6 6-4 6-3') &&
    all(scores$reference_value==ifelse(scores$reference_id=='wta_draw_pdf','46 64 63','4-6 6-4 6-3')),
    'Saved anomaly evidence linkage changed')
  # No saved source definition or independently authenticated provider convention supports a TB adjustment.
  list(error_id='WTA:2023-609:268',documented_tb_convention=FALSE)
}
sg_arithmetic <- function(score,service_total,parser,best_of='3') {
  parsed<-parser(score,best_of)
  sg_need(parsed$status=='source_reported_normal','Outside unchanged Phase 2H score-parser support')
  pairs<-do.call(rbind,lapply(strsplit(strsplit(gsub('\\([0-9]+\\)','',trimws(score)),' +')[[1]],'-'),as.numeric))
  games<-sum(pairs);tb<-sum(pmin(pairs[,1],pairs[,2])==6 & pmax(pairs[,1],pairs[,2])==7)
  expected<-games-tb
  sg_need(is.finite(service_total)&&service_total>=0&&service_total==floor(service_total),'Unevaluable service total')
  sg_need(expected==parsed$games,'Arithmetic disagrees with frozen parser')
  c(scored_games=games,tiebreaks=tb,service_games=service_total,expected=expected,discrepancy=service_total-expected)
}
sg_patterns <- c('BASELINE_ZERO_TB','BASELINE_WITH_TB','ONE_EXTRA_PER_TB','TWO_EXTRAS_PER_TB',
                 'SAVED_NON_TB_ERROR','OTHER_POSITIVE','OTHER_NEGATIVE','DOCUMENTED_TB_CONVENTION')
sg_labels <- setNames(c(rep('ARITHMETICALLY_CONSISTENT_UNVERIFIED',4),'DEMONSTRATED_SOURCE_ERROR',
                       'UNRESOLVED','UNRESOLVED','UNRESOLVED'),sg_patterns)
sg_basis <- setNames(c('Equality without tie-breaks cannot distinguish conventions',
  'Fits current aggregate rule; no blanket independent verification',
  'S=G with T>0; no saved independently supported provider convention',
  'S=G+T with T>0; exploratory repeated arithmetic only',
  'Pinned prior comparison and adopted quarantine: corroborated score 29 versus recorded total 22; true side counts unknown',
  'Positive residual not explained by tested tie-break additions',
  'Negative residual; source error versus incomplete observation unresolved',
  'No saved definition establishes the proposed provider convention'),sg_patterns)
sg_classify <- function(delta,tb,saved_error=FALSE) {
  if(saved_error) {
    sg_need(delta==-7&&tb==0,'Saved error arithmetic changed')
    return('SAVED_NON_TB_ERROR')
  }
  if(delta==0)return(if(tb==0)'BASELINE_ZERO_TB' else 'BASELINE_WITH_TB')
  if(tb>0&&delta==tb)return('ONE_EXTRA_PER_TB')
  if(tb>0&&delta==2*tb)return('TWO_EXTRAS_PER_TB')
  if(delta>0)'OTHER_POSITIVE' else 'OTHER_NEGATIVE'
}
sg_rows <- function() {
  sg_verify()
  prior<-new.env(parent=globalenv());sys.source('R/audit_source_defined_cohort.R',envir=prior)
  d<-sg_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv')
  n<-d[d$completion_status=='source_reported_normal',,drop=FALSE]
  sg_need(nrow(n)==2818&&!anyDuplicated(n$match_id),'Normal-record population changed')
  ref<-sg_reference()
  arithmetic<-t(vapply(seq_len(nrow(n)),function(i)sg_arithmetic(n$score[i],
    as.numeric(n$effective_w_SvGms[i])+as.numeric(n$effective_l_SvGms[i]),prior$sa_score,n$best_of[i]),numeric(5)))
  x<-data.frame(tour=n$audit_tour,year=n$audit_season,event=n$event,surface=n$surface,
                round=n$round,best_of=n$best_of,arithmetic,stringsAsFactors=FALSE)
  x$pattern<-vapply(seq_len(nrow(x)),function(i)sg_classify(x$discrepancy[i],x$tiebreaks[i],
    n$match_id[i]==ref$error_id),'')
  x$evidence_status<-unname(sg_labels[x$pattern]);x$conflict<-x$discrepancy!=0
  frozen_flag<-grepl('service_games_score_conflict',n$count_reasons,fixed=TRUE)
  sg_need(identical(x$conflict,frozen_flag)&&sum(x$conflict)==237,'All-237 accounting differs from frozen flags')
  sg_need(sum(grepl('service_games_score_conflict',d$count_reasons,fixed=TRUE))==237,'Flagged rows outside diagnostic population')
  sg_need(all(n$membership[x$conflict]=='EXCLUDED'),'A flagged row is no longer excluded')
  sg_need(sum(n$count_origin=='approved_recovery_overlay')==7 &&
    all(n$effective_w_SvGms[n$count_origin=='original_source']==n$w_SvGms[n$count_origin=='original_source']) &&
    all(n$effective_l_SvGms[n$count_origin=='original_source']==n$l_SvGms[n$count_origin=='original_source']),
    'Unexpected effective/raw count difference')
  x # transient arithmetic, no player/source identifiers, never written as a row-level release
}
sg_dimensions <- c('tour','year','event','surface','round','best_of','tiebreaks')
sg_groups <- function(x) {
  specs<-list(overall=character(),tour='tour',year='year',event='event',surface='surface',
    round='round',best_of='best_of',tiebreaks='tiebreaks',tour_year=c('tour','year'),
    cell=c('tour','year','event','surface'),cell_round=c('tour','year','event','surface','round'),
    cell_tiebreaks=c('tour','year','event','surface','tiebreaks'),
    joint=sg_dimensions)
  out<-list()
  for(name in names(specs)) {
    fields<-specs[[name]]
    keys<-if(length(fields))do.call(paste,c(x[fields],sep='|')) else rep('ALL',nrow(x))
    for(key in sort(unique(keys),method='radix')) {
      ids<-which(keys==key); meta<-as.list(setNames(rep('ALL',length(sg_dimensions)),sg_dimensions))
      for(field in fields)meta[[field]]<-as.character(x[[field]][ids[1]])
      out[[length(out)+1]]<-list(meta=data.frame(version=sg_version,grouping=name,meta,
        stringsAsFactors=FALSE),ids=ids)
    }
  }
  out
}
sg_summarize <- function(x) {
  discrepancy<-hypothesis<-list()
  for(group in sg_groups(x)) {
    z<-x[group$ids,,drop=FALSE];denom<-nrow(z);conflicts<-sum(z$conflict)
    common<-cbind(group$meta,data.frame(normal_denominator=denom,group_conflicts=conflicts,
      conflict_rate=conflicts/denom,positive_tb_normal=sum(z$tiebreaks>0),
      denominator_basis='ALL_SOURCE_REPORTED_NORMAL_RECORDS'))
    # Distributions partition the whole normal-record group, including zero discrepancies.
    key<-paste(z$discrepancy,z$pattern,sep='|')
    for(k in sort(unique(key),method='radix')) {
      a<-z[key==k,,drop=FALSE]
      discrepancy[[length(discrepancy)+1]]<-cbind(common,data.frame(
        signed_discrepancy=a$discrepancy[1],pattern=a$pattern[1],evidence_status=a$evidence_status[1],
        records=nrow(a),fraction_of_normal=nrow(a)/denom,
        scored_games_sum=sum(a$scored_games),ordinary_tiebreaks_sum=sum(a$tiebreaks),
        recorded_service_games_sum=sum(a$service_games),current_expected_sum=sum(a$expected),
        signed_discrepancy_sum=sum(a$discrepancy),evidence_basis=unname(sg_basis[a$pattern[1]])))
    }
    # Disjoint patterns plus an explicit zero-evidence row; never count T=0 as TB-hypothesis support.
    for(pattern in sg_patterns) {
      take<-z$pattern==pattern;n<-sum(take)
      hypothesis[[length(hypothesis)+1]]<-cbind(common,data.frame(pattern=pattern,
        evidence_status=unname(sg_labels[pattern]),records=n,fraction_of_normal=n/denom,
        flagged_records=sum(z$conflict[take]),fraction_of_group_conflicts=if(conflicts)sum(z$conflict[take])/conflicts else NA_real_,
        evidence_basis=unname(sg_basis[pattern]),recommendation='PRESERVE_CURRENT_EXCLUSION_RULE'))
    }
  }
  setNames(list(do.call(rbind,discrepancy),do.call(rbind,hypothesis)),sg_outputs)
}
sg_lines <- function(x) {
  con<-textConnection('out','w',local=TRUE);on.exit(close(con))
  write.table(x,con,sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double');out
}
sg_publish <- function(result,dir=sg_dir) {
  sg_need(identical(names(result),sg_outputs),'Unexpected output scope');sg_verify()
  lines<-lapply(result,sg_lines);paths<-file.path(dir,paste0(sg_outputs,'.csv'))
  if(dir.exists(dir)) {
    sg_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing release scope differs; preserve it')
    sg_need(all(vapply(seq_along(paths),function(i)identical(readLines(paths[i],warn=FALSE),lines[[i]]),TRUE)),
      'Existing release bytes differ; preserve it')
    return(invisible(paths))
  }
  sg_need(dir.exists(dirname(dir)),'Output parent missing')
  stage<-tempfile('.service-game-',tmpdir=dirname(dir));dir.create(stage)
  on.exit(unlink(stage,recursive=TRUE),add=TRUE) # only this invocation's unpublished staging files
  for(i in seq_along(paths))writeLines(lines[[i]],file.path(stage,basename(paths[i])),useBytes=TRUE)
  sg_verify();sg_need(file.rename(stage,dir),'Atomic publication failed')
  invisible(paths)
}
diagnose_service_game_conflicts <- function(write_outputs=TRUE) {
  result<-sg_summarize(sg_rows());if(write_outputs)sg_publish(result);result
}
if(sys.nframe()==0L) {
  result<-diagnose_service_game_conflicts()
  print(result$`hypothesis-summary`[result$`hypothesis-summary`$grouping=='overall',
    c('pattern','evidence_status','records','normal_denominator','group_conflicts')],row.names=FALSE)
}
