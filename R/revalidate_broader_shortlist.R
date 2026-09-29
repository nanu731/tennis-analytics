# Phase 2J 1.0.0. Descriptive fitting only, from frozen Phase 2H membership.
# Decision mapping: primary registered direction/computability/rank/collinearity failures
# (NPR and warning-free same-match win) pause a set; shared primary failure (or both failed sets) requires family review.
# Deletion failures are all reported. No numerical repetition cutoff was registered,
# so no post-hoc pause threshold is created. Fit magnitude cannot select an alternative.
bj_version <- '1.0.0'
bj_dir <- 'data/pilot/broader-shortlist-revalidation'
bj_outputs <- c('analysis-samples','collinearity','npr-increments','same-match-win','stability-and-decision')
bj_metrics <- c('M01','M03','M05','M11','M12')
bj_sets <- list(S02=c('M01','M05','M11','M12'),S08=c('M03','M05','M11','M12'))
bj_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
bj_hash <- function(p)if(!file.exists(p))'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
bj_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
bj_pins <-  c(`R/audit_source_defined_cohort.R` = "73b79972d2d4bb0c8d651df1d080ed92bf9b0357987af65dbd53e839db5f7bb6",
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
AGENTS.override.md = "7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b",
`docs/occam-candidate-and-data-decision.md` = "028dcca5e8477e4d41d18e431514868e966a64f7d474a09efcf7b7cba272dab4",
`R/diagnose_service_game_conflicts.R` = "cd63780100bd845094f2aaf306ebae2036685159c14babf3618165efb838b206",
`R/test_service_game_conflicts.R` = "269fe09f56325694dd4978cbefb63c72fa1d0fe650a625d67923300cd407a73d",
`docs/service-game-convention-diagnostic.md` = "9ba3304f631a9b20d5ed41a8187c56cf0f739de776a7c95c28d0dd796407954d",
`data/pilot/service-game-convention-diagnostic/discrepancy-summary.csv` = "ce77dfd1fd09c4fe3fff335f4edad286bef192fdbea7c736e14e08a17d4386c0",
`data/pilot/service-game-convention-diagnostic/hypothesis-summary.csv` = "abfbce4bfb3b0dcfa54b7ebb933ef4f82b196a48b560722a2b85c9861a4eb57c",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c"
)
bj_verify <- function()bj_need(identical(setNames(vapply(names(bj_pins),bj_hash,''),names(bj_pins)),bj_pins),'Missing/changed frozen input')
bj_helpers <- function() {
  # Evaluate only these pinned pure definitions, never the empirical runner or old authority checks.
  allowed<-c('pf_spec','pf_rank','pf_collinearity','pf_ols','pf_increment','pf_losses','pf_logistic','pf_expected','pf_direction')
  e<-new.env(parent=globalenv());e$pf_need<-bj_need
  expressions<-parse('R/analyze_exploratory_four_factors_pilots.R')
  for(expr in expressions)if(is.call(expr)&&identical(expr[[1]],as.name('<-'))&&is.symbol(expr[[2]])&&
    as.character(expr[[2]]) %in% allowed)eval(expr,envir=e)
  bj_need(all(vapply(allowed,exists,TRUE,envir=e,inherits=FALSE)),'Pure helper allowlist incomplete');e
}
bj_side <- function(a,b) {
  nums<-c(M01=a['ace'],M03=a['1stWon'],M05=a['df'],M11=b['bpFaced'],M12=b['bpFaced']-b['bpSaved'])
  dens<-c(a['svpt'],a['1stIn'],a['svpt']-a['1stIn'],b['SvGms'],b['bpFaced'])
  names(nums)<-names(dens)<-bj_metrics
  values<-ifelse(dens>0,nums/dens,NA_real_)
  list(num=nums,den=dens,value=values)
}
bj_pair <- function(a,b) {
  aa<-bj_side(a,b);bb<-bj_side(b,a);sw<-a['1stWon']+a['2ndWon'];ow<-b['1stWon']+b['2ndWon']
  S<-a['svpt'];s<-b['svpt'];wa<-sw+s-ow;wb<-ow+S-sw
  c(setNames(aa$value-bb$value,bj_metrics),NPR=unname(100*(wa-wb)/(S+s)),
    equal_phase_NPR=unname(100*(sw/S-ow/s)))
}
bj_samples <- function() {
  bj_verify();d<-bj_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv')
  m<-bj_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv')
  bj_need(nrow(m)==2580&&!anyDuplicated(m$match_id)&&setequal(m$match_id,d$match_id[d$membership=='INCLUDED']),'Frozen membership mismatch')
  d<-d[match(m$match_id,d$match_id),];bj_need(all(d$membership=='INCLUDED')&&all(d$game_reconciliation=='PASS'),'Excluded row entered analysis')
  out<-data.frame(match_id=m$match_id,tour=m$audit_tour,season=m$audit_season,event=m$event,
    surface=m$surface,cell_id=m$cell_id,player_a_id=m$player_a_id,player_b_id=m$player_b_id,
    count_origin=m$count_origin,win=as.integer(m$a_original_side=='winner'),stringsAsFactors=FALSE)
  fields<-c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpFaced','bpSaved')
  rows<-vector('list',nrow(d))
  for(i in seq_len(nrow(d))) {
    w<-setNames(as.numeric(d[i,paste0('effective_w_',fields)]),fields)
    l<-setNames(as.numeric(d[i,paste0('effective_l_',fields)]),fields)
    a<-if(out$win[i])w else l;b<-if(out$win[i])l else w
    v<-bj_pair(a,b);swap<-bj_pair(b,a)
    bj_need(identical(is.na(v),is.na(swap))&&all(abs(v+swap)<1e-10,na.rm=TRUE),'Player-slot antisymmetry failed')
    sides<-list(a=bj_side(a,b),b=bj_side(b,a));z<-as.list(v)
    for(side in names(sides))for(metric in bj_metrics) {
      z[[paste(side,metric,'num',sep='_')]]<-unname(sides[[side]]$num[metric])
      z[[paste(side,metric,'den',sep='_')]]<-unname(sides[[side]]$den[metric])
    }
    rows[[i]]<-as.data.frame(z)
  }
  out<-cbind(out,do.call(rbind,rows));out$common_complete<-complete.cases(out[c(bj_metrics,'NPR','equal_phase_NPR')])
  out$exclusion_reason<-vapply(seq_len(nrow(out)),function(i)paste(bj_metrics[!is.finite(as.numeric(out[i,bj_metrics]))],collapse=';'),'')
  # Non-missing zero-opportunity M12 is forbidden; no sample-specific denominator threshold.
  bj_need(all(is.na(out$M12)==(out$a_M12_den==0|out$b_M12_den==0)),'M12 opportunity mask')
  frozen<-bj_read('data/pilot/exploratory-four-factors-analysis/match-metrics.csv')
  k<-match(frozen$match_id,out$match_id);bj_need(!anyNA(k),'Frozen pilot overlap missing')
  for(term in c(bj_metrics,'NPR','equal_phase_NPR')) {
    old<-suppressWarnings(as.numeric(frozen[[if(term %in% bj_metrics)paste0('diff_',term) else term]]))
    fresh<-out[[term]][k];bj_need(identical(is.na(old),is.na(fresh))&&all(abs(old-fresh)<=5e-12*pmax(1,abs(old)),na.rm=TRUE),'Frozen formula reproduction failed')
  }
  out
}
bj_drop <- function(x,kind,id) {
  if(kind=='leave_cell')x[x$cell_id!=id,,drop=FALSE] else if(kind=='leave_player')
    x[x$player_a_id!=id & x$player_b_id!=id,,drop=FALSE] else stop('Unknown deletion kind')
}
bj_contexts <- function(x,delete=TRUE) {
  contexts<-list();add<-function(kind,id,z)contexts[[length(contexts)+1]]<<-list(kind=kind,id=id,data=z)
  add('primary','ALL',x)
  for(field in c('season','surface','cell_id'))for(id in sort(unique(x[[field]]),method='radix'))add(field,id,x[x[[field]]==id,,drop=FALSE])
  if(delete) {
    for(id in sort(unique(x$cell_id),method='radix'))add('leave_cell',id,bj_drop(x,'leave_cell',id))
    for(id in sort(unique(c(x$player_a_id,x$player_b_id)),method='radix'))add('leave_player',id,bj_drop(x,'leave_player',id))
  };contexts
}
bj_design <- function(x,terms,fe,e) {
  raw<-as.matrix(x[terms]);controls<-NULL
  if(fe) {
    cells<-factor(x$cell_id,levels=sort(unique(x$cell_id),method='radix'))
    controls<-model.matrix(~cells)[,-1,drop=FALSE];raw<-cbind(raw,controls)
  }
  diag<-e$pf_collinearity(raw);design<-diag$z
  if(fe)design[,colnames(controls)]<-controls
  list(diag=diag,design=cbind(intercept=1,design))
}
bj_decide <- function(npr,win=NULL) {
  p<-npr[npr$kind=='primary' & npr$adjustment=='none' & npr$outcome=='NPR',]
  bad<-!p$fit_ok|p$gate %in% c('FAIL','AUTOMATIC_FAILURE')|p$direction!=p$expected_direction
  # Include the registered winning-direction check only for a computable, warning-free primary fit.
  if(!is.null(win)) {
    w<-win[win$kind=='primary' & win$term %in% bj_metrics & win$fit_ok & !win$unstable,,drop=FALSE]
    direction<-ifelse(abs(w$coefficient)<=sqrt(.Machine$double.eps),'numerically_zero',ifelse(w$coefficient>0,'positive','negative'))
    wp<-p[rep(1,nrow(w)),,drop=FALSE]
    for(field in intersect(names(wp),names(w)))wp[[field]]<-w[[field]]
    wp$outcome<-'same_match_win';wp$direction<-direction
    wp$expected_direction<-ifelse(w$term=='M05','negative','positive');wp$gate<-'NO_NUMERICAL_GATE_FAILURE'
    bad<-c(bad,wp$direction!=wp$expected_direction);p<-rbind(p,wp)
  }
  failed<-vapply(names(bj_sets),function(s)any(bad[p$set==s]),TRUE)
  shared<-any(vapply(c('M05','M11','M12'),function(term)any(vapply(c('ATP','WTA'),function(tour)
    all(vapply(names(bj_sets),function(s)any(bad[p$set==s & p$term==term & p$tour==tour]),TRUE)),TRUE)),TRUE))
  decision<-if(shared||all(failed))'SHARED_FACTOR_FAMILY_REVISION_REQUIRED' else if(failed['S02'])
    'S02_PAUSED_FOR_PRESPECIFIED_FAILURE' else if(failed['S08'])'S08_PAUSED_FOR_PRESPECIFIED_FAILURE' else 'BOTH_ALTERNATIVES_REMAIN_PROVISIONAL'
  list(decision=decision,failures=p[bad,c('tour','set','outcome','term','fit_ok','gate','direction','expected_direction')])
}
bj_build <- function(delete=TRUE) {
  x<-bj_samples();e<-bj_helpers();coll<-npr<-win<-list()
  for(tour in c('ATP','WTA')) {
    full<-x[x$tour==tour & x$common_complete,,drop=FALSE]
    for(ctx in bj_contexts(full,delete))for(set in names(bj_sets))for(fe in if(ctx$kind=='primary')c(FALSE,TRUE) else FALSE) {
      z<-ctx$data;terms<-bj_sets[[set]];d<-bj_design(z,terms,fe,e);dg<-d$diag
      key<-data.frame(tour=tour,kind=ctx$kind,omitted_or_slice=ctx$id,set=set,adjustment=if(fe)'event_cell_FE' else 'none',
        n=nrow(z),players=length(unique(c(z$player_a_id,z$player_b_id))),cells=length(unique(z$cell_id)),
        sample_id=paste(tour,ctx$kind,ctx$id,sep=':'),stringsAsFactors=FALSE)
      # Store all factor/actual-design gates; individual correlations, VIF and condition indices.
      cc<-list()
      for(j in seq_along(dg$vif))cc[[length(cc)+1]]<-data.frame(diagnostic='VIF',term=names(dg$sd)[j],partner='',value=dg$vif[j],pearson=NA_real_,spearman=NA_real_)
      for(j in seq_along(dg$ci))cc[[length(cc)+1]]<-data.frame(diagnostic='condition_index',term=as.character(j),partner='',value=dg$ci[j],pearson=NA_real_,spearman=NA_real_)
      pairs<-combn(seq_along(dg$sd),2)
      for(j in seq_len(ncol(pairs))) {a<-pairs[1,j];b<-pairs[2,j];cc[[length(cc)+1]]<-data.frame(diagnostic='pair',term=names(dg$sd)[a],partner=names(dg$sd)[b],value=NA_real_,pearson=dg$pearson[a,b],spearman=dg$spearman[a,b])}
      coll[[length(coll)+1]]<-cbind(key,do.call(rbind,cc),rank=dg$rank,columns=length(dg$sd),
        max_vif=max(dg$vif),max_condition=max(dg$ci),max_correlation=dg$max_correlation,
        correlation_class=dg$correlation_class,vif_class=dg$vif_class,condition_class=dg$condition_class,
        constant=any(dg$constant),near_constant=any(dg$near),gate=dg$gate)
      for(outcome in c('NPR','equal_phase_NPR')) {
        f<-e$pf_ols(d$design,z[[outcome]])
        for(term in terms) {
          reduced<-e$pf_ols(d$design[,colnames(d$design)!=term,drop=FALSE],z[[outcome]])
          inc<-if(f$ok&&reduced$ok)e$pf_increment(f$r2,reduced$r2) else c(NA_real_,NA_real_)
          beta<-if(f$ok)unname(f$beta[term]) else NA_real_
          npr[[length(npr)+1]]<-cbind(key,data.frame(outcome=outcome,term=term,coefficient=beta,
            intercept=if(f$ok)unname(f$beta['intercept']) else NA_real_,direction=e$pf_direction(beta),expected_direction=e$pf_expected(term),
            full_r2=if(f$ok)f$r2 else NA_real_,adjusted_r2=if(f$ok)f$adjusted else NA_real_,
            reduced_r2=if(reduced$ok)reduced$r2 else NA_real_,increment=unname(inc[1]),partial_r2=unname(inc[2]),
            fit_ok=f$ok&&reduced$ok,rank=f$rank,gate=dg$gate,
            uncertainty='UNCERTAINTY_NOT_ESTABLISHED',practical_effect='PENDING_SPECIFICATION'))
        }
      }
      if(!fe) {
        f<-e$pf_logistic(d$design,z$win)
        for(term in colnames(d$design))win[[length(win)+1]]<-cbind(key,data.frame(term=term,
          coefficient=if(f$ok)unname(f$beta[term]) else NA_real_,fit_ok=f$ok,
          converged=f$ok&&f$converged,boundary=if(f$ok)f$boundary else NA,
          separation=if(f$ok)f$witness else 'NOT_ASSESSABLE',extreme=if(f$ok)f$extreme else NA_integer_,
          unstable=!f$ok||f$unstable,warning=f$warning,
          apparent_log_loss=if(f$ok)unname(f$loss[1]) else NA_real_,apparent_brier=if(f$ok)unname(f$loss[2]) else NA_real_,
          uncertainty='UNCERTAINTY_NOT_ESTABLISHED'))
      }
    }
  }
  npr<-do.call(rbind,npr);win<-do.call(rbind,win);coll<-do.call(rbind,coll)
  primary<-npr[npr$kind=='primary' & npr$adjustment=='none',]
  key<-function(d)paste(d$tour,d$set,d$outcome,d$term,sep='|')
  base<-primary[match(key(npr),key(primary)),]
  stability<-npr[,c('tour','kind','omitted_or_slice','set','adjustment','n','players','cells','sample_id','outcome','term')]
  stability$coefficient<-npr$coefficient;stability$baseline_coefficient<-base$coefficient
  stability$increment<-npr$increment;stability$baseline_increment<-base$increment
  stability$sign_reversal<-e$pf_direction(npr$coefficient) %in% c('positive','negative') &
    e$pf_direction(base$coefficient) %in% c('positive','negative') & sign(npr$coefficient)!=sign(base$coefficient)
  stability$direction_failure<-npr$direction!=npr$expected_direction
  stability$numeric_increment_lost<-base$increment>e$pf_spec()$increment_numeric_zero & npr$increment<=e$pf_spec()$increment_numeric_zero
  stability$gate<-npr$gate;stability$fit_ok<-npr$fit_ok
  # Logistic refit directions are external descriptive diagnostics, never forecast evidence.
  w<-win[win$term!='intercept',];wp<-w[w$kind=='primary',]
  wkey<-function(d)paste(d$tour,d$set,d$term,sep='|');wb<-wp[match(wkey(w),wkey(wp)),]
  ws<-stability[rep(1,nrow(w)),,drop=FALSE]
  for(field in intersect(names(ws),names(w)))ws[[field]]<-w[[field]]
  ws$outcome<-'same_match_win';ws$baseline_coefficient<-wb$coefficient
  ws$increment<-ws$baseline_increment<-NA_real_
  ws$sign_reversal<-e$pf_direction(w$coefficient) %in% c('positive','negative') &
    e$pf_direction(wb$coefficient) %in% c('positive','negative') & sign(w$coefficient)!=sign(wb$coefficient)
  ws$direction_failure<-e$pf_direction(w$coefficient)!=e$pf_expected(w$term)
  ws$numeric_increment_lost<-FALSE;ws$gate<-ifelse(w$unstable,'LOGISTIC_INSTABILITY','NO_LOGISTIC_WARNING')
  stability<-rbind(stability,ws)
  stability$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
  terminal<-bj_decide(npr,win);stability$terminal_decision<-terminal$decision
  stability$decision_role<-ifelse(stability$kind=='primary' & stability$adjustment=='none' & (stability$outcome=='NPR' | (stability$outcome=='same_match_win' & stability$gate=='NO_LOGISTIC_WARNING')),
    'REGISTERED_PRIMARY_GATE','STABILITY_OR_SENSITIVITY_NOT_NEW_THRESHOLD')
  setNames(list(x,coll,npr,win,stability),bj_outputs)
}
bj_lines <- function(x) {
  con<-textConnection('out','w',local=TRUE);on.exit(close(con))
  write.table(x,con,sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double');out
}
bj_publish <- function(r,dir=bj_dir) {
  bj_verify();bj_need(identical(names(r),bj_outputs),'Output scope');lines<-lapply(r,bj_lines)
  paths<-file.path(dir,paste0(bj_outputs,'.csv'))
  if(dir.exists(dir)) {
    bj_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Preserve existing release: unexpected files')
    bj_need(all(vapply(seq_along(paths),function(i)identical(readLines(paths[i],warn=FALSE),lines[[i]]),TRUE)),'Preserve existing release: bytes differ')
    return(invisible(paths))
  }
  stage<-tempfile('.broader-shortlist-',tmpdir=dirname(dir));dir.create(stage)
  on.exit(unlink(stage,recursive=TRUE),add=TRUE)
  for(i in seq_along(paths))writeLines(lines[[i]],file.path(stage,basename(paths[i])),useBytes=TRUE)
  bj_verify();bj_need(file.rename(stage,dir),'Atomic release failed');invisible(paths)
}
revalidate_broader_shortlist <- function(write_outputs=TRUE) {
  r<-bj_build();if(write_outputs)bj_publish(r);r
}
if(sys.nframe()==0L) {r<-revalidate_broader_shortlist();print(unique(r$`stability-and-decision`$terminal_decision))}
