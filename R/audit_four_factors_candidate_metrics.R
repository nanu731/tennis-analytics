# Phase 2A: offline descriptive audit only. No forecast, imputation or fitted model.
fc_baseline <- "baf27f397d18481e374b0e7ce528ffe5dc5a74eb"
fc_dir <- function() "data/pilot/four-factors-candidate-metric-feasibility"
fc_report_path <- "docs/four-factors-candidate-metric-feasibility.md"
fc_need <- function(ok, reason) if(!isTRUE(ok)) stop("Phase 2A BLOCKED: ",reason,call.=FALSE)
fc_pins <- function() c(
  "data/manifests/anomaly-reference-files.csv"="fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
  "data/manifests/development-source-files.csv"="2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
  "data/manifests/inventory-reference-files.csv"="b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
  "data/manifests/montreal-reference-files.csv"="783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
  "data/manifests/pilot-source-files.csv"="2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
  "data/pilot/anomaly/anomaly-coverage.csv"="72e1a325e434645b9d440be30f759a84e99360857cc55832b434dca16ccd8e39",
  "data/pilot/anomaly/anomaly-disposition.csv"="3f5d084b1116954de31f2b1e3f4ba4c6880236a791cc2e4c5449d6e060a9c8eb",
  "data/pilot/anomaly/anomaly-source-comparison.csv"="5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
  "data/pilot/anomaly/anomaly-validation-checks.csv"="9593116997633f55c2fbd14e9d076aadd657c46cc773d481c5145575e4f3b583",
  "data/pilot/atp_indian_wells_2023.csv"="31b43453ed46a709fd51bd50b372ec2c605258d5a9814db13c963377def2ac6a",
  "data/pilot/development-2021/event-candidates.csv"="d5d66ebe2c3c82708776a997549233d8f3898ee6d89aaced5ec7e8821fb2adcb",
  "data/pilot/development-2021/montreal-chronology-evidence/edges.csv"="56b87368170b93da809a4fd47f8694eec462d5cc08d93c4e72a5d5e576c908f0",
  "data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv"="775d542da9631493885d3e28814e56ed84d1fe337dbc1d60542ef4dbf9781812",
  "data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv"="b3ebf221967bf54fb3b7f818065e55109b2d63faffed83d8f4a79ba6e3126640",
  "data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv"="c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
  "data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds"="2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
  "data/pilot/development-2021/montreal-reference-feasibility/coverage-scenarios.csv"="180f6ba53e30677c3702ed3cd11274b4348075caa8411c97d83af071812516b4",
  "data/pilot/development-2021/montreal-reference-feasibility/feasibility-dispositions.csv"="0c879ab4d6fea166c8ee29784d6f73cccc9688c950457d99170ab809eb9f178c",
  "data/pilot/development-2021/montreal-reference-feasibility/field-comparisons.csv"="d687758bf17c808f85cf7d6e613a80d0629f9a9dacfdca0d618c561132d0ad5b",
  "data/pilot/development-2021/montreal-reference-feasibility/official-stat-observations.csv"="f498a9da20d037771622276332472c3d53bac1e6060141576a8e78b89391f008",
  "data/pilot/development-2021/montreal-reference-feasibility/pdf-target-evidence.csv"="7631d244260c8464e54b31c1a5cc74b7689652eb9154918d8826b4ed27a5ba54",
  "data/pilot/development-2021/montreal-reference-feasibility/reference-checks.csv"="e4999f73eb8768118a7f66ec929c145404447834723579c79c430b3658a43140",
  "data/pilot/development-2021/montreal-reference-feasibility/reference-match-inventory.csv"="77bd218219f554b056296d642d243eb4d796cb6f65681122959ffa806cce4ffe",
  "data/pilot/development-2021/montreal-reference-feasibility/status-evidence.csv"="3b9e6478ac9e1496d5ccdd67d0f15bbe8560cb3bbbfa8a0637fb78eb06c58023",
  "data/pilot/development-2021/montreal-reference-feasibility/structural-checks.csv"="f1d7ab46958d1e5448e7a5ee0249bbadd22518cf563a3bd9844b5aa9a0bfc133",
  "data/pilot/inventory/atp-pdf-observations.csv"="260b281c7992e79b47dafc21a236c24fe5fa33e5b38b2cdd581c630b2a0e91cd",
  "data/pilot/inventory/conflicts.csv"="1a5234946b836f4f2c1b6ca26f1222b3a5ae4fd7d880c2db475ff597696f61f6",
  "data/pilot/inventory/identity-review.csv"="57b29e77bd6a31e525eb6b2289275313ab45999732774cf8c1cc9e3bb1fbb3d9",
  "data/pilot/inventory/inventory-summary.csv"="f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
  "data/pilot/inventory/match-reconciliation.csv"="e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
  "data/pilot/inventory/normalization-decisions.csv"="e8e63e2947ff0f36781013d0f06308c1e4b64206f6f2764932bb7f5532360225",
  "data/pilot/inventory/official-matches.csv"="3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
  "data/pilot/inventory/official-only.csv"="3d170c1cc2c66e7a957cf8b32f743d2631463c0b3a2d90888bf917c8ad32e544",
  "data/pilot/inventory/reference-comparison.csv"="e8fa870adcf0818c32b6f2df13a724f90a000c1bf3d3e12340c4041198b70e4e",
  "data/pilot/inventory/reference-conflicts.csv"="8a7df76185b3f591c2fc2067941b6a2a0e8108b9ebe6fc5f41c3d8ceeb4d0f7a",
  "data/pilot/inventory/round-summary.csv"="f4d34ec90b25ee96473ebedcd43e0589ca2b92dfb6d6c6386923d90d020f9466",
  "data/pilot/inventory/source-matches.csv"="c5beb37d7453558cec3501ed1f28db27c3c634d953d99cb3e5c4763a7595145f",
  "data/pilot/inventory/source-only.csv"="a0297e28dbfdea9291ec165c821b17fe9fdbb512360550412010addfeee6777d",
  "data/pilot/inventory/status-summary.csv"="64c7b7975bd58f03a74cc343528890bcd7c1372750f1ba0c1d4401ccd851b352",
  "data/pilot/wta_indian_wells_2023.csv"="03afd50a16de2d955f8e45760bc2e9667362288f2c791ccacb5c1047908b149f",
  "data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html"="d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
  "data/raw/reference/indian-wells-2023-anomaly/wta-draws.html"="9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
  "data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html"="de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
  "data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf"="573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
  "data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt"="aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
  "data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt"="1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
  "data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf"="0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
  "data/raw/reference/montreal-2021-feasibility/draw_html.html"="58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
  "data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf"="3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
  "data/raw/reference/montreal-2021-feasibility/LS001.html"="673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
  "data/raw/reference/montreal-2021-feasibility/LS002.html"="2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
  "data/raw/reference/montreal-2021-feasibility/LS003.html"="cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
  "data/raw/reference/montreal-2021-feasibility/LS004.html"="4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
  "data/raw/reference/montreal-2021-feasibility/LS005.html"="4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
  "data/raw/reference/montreal-2021-feasibility/LS006.html"="8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
  "data/raw/reference/montreal-2021-feasibility/LS007.html"="ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
  "data/raw/reference/montreal-2021-feasibility/LS042.html"="42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
  "data/raw/reference/montreal-2021-feasibility/LS049.html"="37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
  "data/raw/reference/montreal-2021-feasibility/overview.html"="d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.csv"="b9b1d31a4b0b9273b8f338cbb1347c5a847ad2361334ec760a286f5990fba347",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.metadata.json"="1b51d087b873bb723c9d36d9f5c1d0a7a1157ba8e41a00cfbe8edb2ea1723a71",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv"="9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv"="3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json"="0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv"="b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18",
  "docs/atp-inventory-reference-precedence-policy.md"="167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
  "docs/post-otd-analytical-path.md"="14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
  "docs/wta-2021-montreal-inventory-status-policy.md"="279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
  "docs/wta-2021-montreal-recovery-policy.md"="11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
  "docs/wta-anomaly-and-quarantine-policy.md"="1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
  "PROJECT_CONTEXT.md"="085276b9b29088afdcf4d2c0ab623eec23aa5ec00d035d8fc677fe568f860d60",
  "R/audit_2021_annual_data.R"="4e376a0e1e2ee822515d2d227f457bed095cc4dca61a6285a29ec07311a423bd",
  "R/audit_event_boundary_feasibility.R"="4c22ad4be1e4e92e55fc8169859a9884730ab6f692b65c60512f17e4128d4da9",
  "R/audit_montreal_completed_match_coverage.R"="f5e1b57c38a72cf13a7e2a3ce988ce1067b4ac2d53e389423aa8efe40cf84749",
  "R/audit_montreal_reference_feasibility.R"="d0935e2e0d1a72bd32252883f2d601dcc09cddbc906ca149b26512a36648d9f1",
  "R/audit_pilot_data.R"="82bed285763b478614c4c296f92eeb554a6ef104134080e054c7c7b720f6e608",
  "R/audit_wta_anomaly.R"="90b0c3d40fbe4a69e30de51b6a089ace535c26e62d32aeec6e1a9aa9429687a4",
  "R/download_2021_annual_data.R"="43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068",
  "R/download_anomaly_references.R"="596943db417128ff17498353864d8336b788b87add8e1fb2fcde24070d751c2d",
  "R/download_inventory_references.R"="077e4fe176a977f1d64f75b5f86d1e468e26baa5f7e27485adfee0655adc084b",
  "R/download_montreal_references.R"="a48984a9a9b87275ed561109e20d3e0331ce5aef6fc440044d53417291ff2287",
  "R/download_pilot_data.R"="5facb085d14f1c5007c97cd7008d77173cc9e7b74a96eca1c7bc49696ccb4299",
  "R/implement_montreal_recovery.R"="224d0dbcab70b184f0fc8ac67b924b2e15f77cbe698664a7594d4d11606c8e6d",
  "R/reconcile_indian_wells_inventory.R"="84ae65145e3505e578a7287af2bf25d08f8e8f25d2bc35be7fb0b10ecd9fdb93",
  "R/reconcile_montreal_inventory.R"="52dd718b67a95aa01bc015daa66f8a5a739cc6ccd121c5229046ce68b3053e24",
  "R/review_wta_2021_montreal.R"="5b180b4a30521ed126fc75363065c5b376fac6dc7994bb73823dcac4064b07ef"
)
fc_hash <- function(path) strsplit(system2('shasum',c('-a','256',shQuote(path)),stdout=TRUE),' ')[[1]][1]
fc_allow <- function(path) {
  fc_need(is.character(path)&&length(path)==1L&&!is.na(path)&&path%in%names(fc_pins()),'unapproved input path')
  fc_need(!grepl('2022|2024|2025',path),'prohibited season path')
  fc_need(file.exists(path)&&normalizePath(path)==file.path(normalizePath('.'),path),'missing or redirected input')
  invisible(TRUE)
}
fc_snapshot <- function(paths=names(fc_pins())) data.frame(path=paths,
  sha256=vapply(paths,fc_hash,''),bytes=file.info(paths)$size,mtime=as.numeric(file.info(paths)$mtime),row.names=NULL)
fc_verify <- function() {
  pins<-fc_pins(); for(p in names(pins))fc_allow(p)
  z<-fc_snapshot();fc_need(identical(unname(z$sha256),unname(pins)),'input hash mismatch')
  z
}
fc_csv_lines <- function(x) {
  old<-options(digits=15,scipen=999,OutDec='.');on.exit(options(old))
  # Round only serialized diagnostics, never the calculations themselves.
  for(n in names(x))if(is.double(x[[n]]))x[[n]]<-signif(x[[n]],12)
  z<-character();con<-textConnection('z','w',local=TRUE)
  write.csv(x,con,row.names=FALSE,na='NA');close(con);z
}
fc_legacy <- function() {
  e<-new.env(parent=globalenv());e$reads<-character()
  guard<-function(p) {
    if(!is.character(p))return(invisible(NULL))
    fc_allow(p);e$reads<-unique(c(e$reads,p));invisible(TRUE)
  }
  e$source<-function(file,...) {guard(file);sys.source(file,envir=e)}
  e$system2<-function(command,args=character(),...) {
    fc_need(basename(command)%in%c('git','shasum','sha256sum','pdftotext'),'nonlocal subprocess forbidden')
    if(basename(command)=='git')fc_need(args[1]%in%c('hash-object','ls-files','check-ignore'),'read-only Git required')
    base::system2(command,args,...)
  }
  e$readLines<-function(con=stdin(),...) {guard(con);base::readLines(con,...)}
  e$readBin<-function(con,...) {guard(con);base::readBin(con,...)}
  e$readRDS<-function(file,...) {guard(file);base::readRDS(file,...)}
  e$read.csv<-function(file,...){
    if(missing(file))return(utils::read.csv(...)) # Legacy parsing of already-read CSV text.
    guard(file);utils::read.csv(file,...)
  }
  e$source('R/audit_event_boundary_feasibility.R')
  e$source('R/audit_montreal_completed_match_coverage.R')
  # Reconstruction must agree with saved audits. It may never refresh old outputs.
  e$pilot_write_csv<-function(x,path) {
    guard(path);z<-character();con<-textConnection('z','w',local=TRUE)
    write.csv(x,con,row.names=FALSE,na='');close(con)
    fc_need(identical(base::readLines(path,warn=FALSE),z),paste('historical reconstruction differs',path))
    invisible(path)
  }
  for(n in c('annual_2021_request','mr_request','download.file','url','socketConnection'))
    assign(n,function(...)stop('Network/acquisition forbidden'),envir=e)
  e
}
fc_load <- function() {
  before<-fc_verify();e<-fc_legacy()
  b<-e$ebf_load();iw<-e$reconcile_indian_wells_inventory();mi<-e$mmc_load();m<-e$mmc_derive(mi)
  fc_need(all(iw$`inventory-summary`$inventory_gate=='PASS')&&mi$inventory$state=='COMPLETE'&&
    all(mi$inventory$criteria$passed),'required inventory/status reconstruction failed')
  fc_need(identical(before,fc_snapshot()),'input changed during reconstruction')
  list(base=b,iw=iw,mi=mi,m=m,provenance=before,reads=e$reads)
}
fc_fields <- function() c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpFaced','bpSaved')
fc_dictionary <- function() {
  p<-'docs/post-otd-analytical-path.md';fc_allow(p)
  fc_need(fc_hash(p)==fc_pins()[[p]],'formula contract changed')
  rows<-grep('^\\| M[0-9][0-9] ',readLines(p),value=TRUE)
  x<-as.data.frame(do.call(rbind,lapply(rows,function(r)trimws(strsplit(r,'|',fixed=TRUE)[[1]][-1]))),stringsAsFactors=FALSE)
  names(x)<-c('metric','numerator','denominator','source_fields','interpretation','range','undefined_rule','coupling','overlap','family','failure_reason')
  x$id<-sprintf('M%02d',seq_len(nrow(x)));fc_need(nrow(x)==15&&all(x$undefined_rule=='U1'),'complete catalogue required')
  x$expected_direction<-ifelse(x$id%in%c('M05','M06','M14'),'negative','positive')
  x$direction_caveat<-ifelse(x$id=='M02','hypothesis_only_first_in_quality_tradeoff','same_match_hypothesis_not_verified_effect')
  x
}
fc_pair_validity <- function(a,b) {
  need<-fc_fields();fc_need(identical(names(a),need)&&identical(names(b),need),'nine named counts each side')
  v<-c(a,b);bad<-any(!is.na(v)&(!is.finite(v)|v<0|v!=floor(v)))
  for(x in list(a,b)) {
    A<-x['ace'];D<-x['df'];S<-x['svpt'];I<-x['1stIn'];F<-x['1stWon'];Q<-x['2ndWon'];G<-x['SvGms'];B<-x['bpFaced'];V<-x['bpSaved']
    failures<-c(I>S,F>I,Q>S-I,D>S-I,Q+D>S-I,V>B,B>S,A>F+Q,G>S,S==0)
    bad<-bad||any(failures,na.rm=TRUE)
  }
  list(invalid=bad,missing=anyNA(v))
}
fc_ratio <- function(num,den,missing=FALSE,invalid=FALSE,upper=1) {
  reason<-if(invalid) 'invalid_bundle' else if(missing||anyNA(c(num,den))) 'missing_input'
    else if(!all(is.finite(c(num,den)))||den<0||num<0||(den>0&&num/den>upper)) 'invalid_bundle'
    else if(den==0&&num!=0) 'invalid_bundle' else if(den==0) 'zero_opportunities' else 'defined'
  list(value=if(reason=='defined')as.numeric(num/den) else NA_real_,reason=reason)
}
fc_side <- function(a,b,external_invalid=FALSE) {
  v<-fc_pair_validity(a,b)
  A<-a['ace'];D<-a['df'];S<-a['svpt'];I<-a['1stIn'];F<-a['1stWon'];Q<-a['2ndWon'];G<-a['SvGms'];B<-a['bpFaced'];V<-a['bpSaved']
  s<-b['svpt'];i<-b['1stIn'];f<-b['1stWon'];q<-b['2ndWon'];g<-b['SvGms'];bb<-b['bpFaced'];vv<-b['bpSaved']
  num<-unname(c(A,I,F,Q,D,D,Q,s-f-q,i-f,s-i-q,bb,bb-vv,V,B,F+Q))
  den<-unname(c(S,S,I,S-I,S-I,S,S-I-D,s,i,s-i,g,bb,B,G,S))
  out<-data.frame(id=sprintf('M%02d',1:15),numerator=num,denominator=den,value=NA_real_,reason='')
  for(k in 1:15) {
    z<-fc_ratio(num[k],den[k],v$missing,external_invalid||v$invalid,if(k%in%c(11,14))Inf else 1)
    out$value[k]<-z$value;out$reason[k]<-z$reason
  }
  out
}
fc_outcomes <- function(a,b,invalid=FALSE) {
  v<-fc_pair_validity(a,b)
  if(invalid||v$invalid||v$missing)return(c(NPR=NA_real_,equal_phase_NPR=NA_real_))
  sw<-a['1stWon']+a['2ndWon'];ow<-b['1stWon']+b['2ndWon'];S<-a['svpt'];s<-b['svpt']
  wa<-sw+s-ow;wb<-ow+S-sw
  fc_need(isTRUE(wa+wb==S+s),'paired point-universe reconciliation')
  c(NPR=unname(100*(wa-wb)/(S+s)),equal_phase_NPR=unname(100*(sw/S-ow/s)))
}
fc_match_index <- function(raw_ids,linked_ids) {
  fc_need(!anyNA(c(raw_ids,linked_ids))&&!anyDuplicated(raw_ids)&&!anyDuplicated(linked_ids)&&
    setequal(raw_ids,linked_ids),'duplicate, ambiguous or missing match mapping')
  match(raw_ids,linked_ids)
}
fc_orientation <- function(winner_id,loser_id) {
  fc_need(!anyNA(c(winner_id,loser_id))&&all(grepl('^[0-9]+$',c(winner_id,loser_id)))&&
    all(winner_id!=loser_id),'missing, ambiguous or identical source player IDs')
  # Lexical byte ordering of digit strings is stable and independent of result.
  vapply(seq_along(winner_id),function(k)order(c(winner_id[k],loser_id[k]),method='radix')[1]==1,TRUE)
}
fc_adapter <- function(input) {
  e<-fc_legacy();b<-input$base;res<-list();raws<-list();bundles<-list()
  for(cell in c('ATP|2023|Indian Wells','WTA|2023|Indian Wells','WTA|2021|Canada')) {
    bits<-strsplit(cell,'|',fixed=TRUE)[[1]];tour<-bits[1];year<-as.integer(bits[2]);fam<-bits[3]
    id<-if(year==2021)'2021-806' else if(tour=='ATP')'2023-0404' else '2023-609'
    raw<-b$data[[paste(tour,year,sep='|')]];raw<-raw[raw$tourney_id==id,,drop=FALSE]
    ids<-paste(tour,raw$tourney_id,raw$match_num,sep=':');origin<-rep('original_source',nrow(raw))
    if(year==2023) {
      links<-input$iw$`match-reconciliation`;links<-links[links$tour==tour,,drop=FALSE]
      k<-fc_match_index(ids,links$source_id);links<-links[k,,drop=FALSE]
      o<-input$iw$`official-matches`;o<-o[!o$bye&o$tour==tour,,drop=FALSE]
      o<-o[fc_match_index(links$official_id,o$official_id),,drop=FALSE]
      fc_need(all(o$winner_id==raw$winner_id&o$loser_id==raw$loser_id&o$round==raw$round),'official/source pair, winner or round mismatch')
      source<-input$iw$`source-matches`;source<-source[source$tour==tour,,drop=FALSE]
      source<-source[fc_match_index(ids,source$source_id),,drop=FALSE]
      status<-ifelse(o$status=='completed','normally_completed',o$status)
      quarantine<-source$statistical_bundle_quarantined & status=='normally_completed'
      evidence<-paste(links$reference_id,links$reference_locator,links$resolution_state,sep=';')
      conflict<-nzchar(links$conflicts)|quarantine;detail<-paste(links$conflicts,source$reason_codes,sep=';')
      official_id<-links$official_id
      policy<-ifelse(links$resolution_state=='not_required','corroborated_inventory',links$resolution_state)
    } else {
      d<-input$m$dispositions;k<-fc_match_index(paste0('sackmann:',ids),d$source_audit_id);d<-d[k,,drop=FALSE]
      fc_need(all(d$status_resolved&!d$unresolved&d$winner_agreement&d$score_agreement),'Montreal unresolved status/linkage')
      fc_need(all(d$source_winner==raw$winner_id&d$round==raw$round&d$source_score==raw$score),'Montreal source link mismatch')
      fc_need(!anyNA(d$source_statistical_quarantine)&&all(d$source_statistical_quarantine=='none_adopted_for_this_event'),'Montreal quarantine flag changed')
      status<-d$classification;quarantine<-rep(FALSE,nrow(d))
      origin<-d$count_origin;evidence<-paste(d$html_locator,d$pdf_locator,sep=';');official_id<-d$official_code
      policy<-d$status_policy;conflict<-!is.na(d$applicable_resolution);detail<-paste(d$source_status,d$html_status,d$pdf_status,d$applicable_resolution,sep=';')
    }
    fc_need(all(status%in%c('normally_completed','retirement','walkover')),'unknown/conflicting status blocks all pilots')
    expected<-if(year==2021)c(49L,5L,1L) else if(tour=='ATP')c(91L,4L,0L) else c(92L,2L,1L)
    fc_need(identical(as.integer(table(factor(status,levels=c('normally_completed','retirement','walkover')))),expected),'pilot status accounting changed')
    fc_need(identical(ids[quarantine],if(tour=='WTA'&&year==2023)'WTA:2023-609:268' else character()),'quarantine rule changed')
    oriented<-fc_orientation(raw$winner_id,raw$loser_id)
    counts<-raw
    if(year==2021) {
      f<-input$mi$overlay$field_decisions;targets<-e$mro_targets();targets<-targets[targets$recovery,]
      fc_need(nrow(f)==126&&!anyDuplicated(paste(f$source_audit_id,f$source_field))&&setequal(f$source_audit_id,targets$audit_id),'Montreal recovery scope changed')
      for(j in which(origin=='approved_recovery_overlay')) {
        ff<-f[f$source_audit_id==paste0('sackmann:',ids[j]),,drop=FALSE]
        fields<-c(paste0('w_',fc_fields()),paste0('l_',fc_fields()))
        fc_need(nrow(ff)==18&&setequal(ff$source_field,fields)&&all(is.na(raw[j,fields]))&&status[j]=='normally_completed','recovery missing, partial or outside completed scope')
        fc_need(all(ff$source_winner_id==raw$winner_id[j]&ff$source_loser_id==raw$loser_id[j])&&
          all(ff$policy_version=='1.0.0')&&all(ff$structural_validation_state=='passed_51_of_51_applicable_checks'),'recovery mapping/proof differs')
        counts[j,fields]<-as.list(ff$value[match(fields,ff$source_field)])
      }
      fc_need(sum(origin=='approved_recovery_overlay')==7&&sum(status=='normally_completed'&origin=='original_source')==42,'42+7 recovery accounting')
    }
    valid<-logical(nrow(raw));reason<-character(nrow(raw));aa<-bb<-vector('list',nrow(raw))
    for(j in seq_len(nrow(raw))) {
      w<-setNames(as.numeric(counts[j,paste0('w_',fc_fields())]),fc_fields());l<-setNames(as.numeric(counts[j,paste0('l_',fc_fields())]),fc_fields())
      aa[[j]]<-if(oriented[j])w else l;bb[[j]]<-if(oriented[j])l else w
      vv<-fc_pair_validity(w,l)
      ck<-e$pilot_audit_event(counts[j,,drop=FALSE],tour)$checks
      complete_checks<-all(ck$evaluated_rows==1&ck$flagged_rows==0&ck$not_evaluable_rows==0)
      reason[j]<-if(status[j]!='normally_completed')paste0('excluded_',status[j]) else if(quarantine[j])'quarantined_bundle' else
        if(vv$invalid||any(ck$flagged_rows>0))'invalid_bundle' else if(vv$missing)'missing_input' else if(!complete_checks)'invalid_bundle' else 'included'
      valid[j]<-reason[j]=='included'
    }
    fc_need(!any(status=='normally_completed'&!quarantine&!valid),'required pilot statistical bundle no longer validates')
    src<-b$records[[paste(tour,year,sep='|')]]
    res[[cell]]<-data.frame(cell_id=cell,tour=tour,season=year,event=fam,surface=raw$surface,match_id=ids,
      source_tournament_id=raw$tourney_id,source_match_number=raw$match_num,round=raw$round,source_score=raw$score,
      source_winner_id=raw$winner_id,source_loser_id=raw$loser_id,source_winner_name=raw$winner_name,source_loser_name=raw$loser_name,
      player_a_id=ifelse(oriented,raw$winner_id,raw$loser_id),player_b_id=ifelse(oriented,raw$loser_id,raw$winner_id),
      player_a_name=ifelse(oriented,raw$winner_name,raw$loser_name),player_b_name=ifelse(oriented,raw$loser_name,raw$winner_name),
      a_original_side=ifelse(oriented,'winner','loser'),b_original_side=ifelse(oriented,'loser','winner'),
      official_id=official_id,status=status,completed_denominator=status=='normally_completed',quarantined=quarantine,
      valid_bundle=valid,exclusion_reason=reason,count_origin=origin,source_path=src$local_path,source_sha256=src$sha256,
      status_evidence=evidence,status_policy=policy,conflict_preserved=conflict,conflict_detail=detail,
      source_missing_fields=rowSums(is.na(raw[c(paste0('w_',fc_fields()),paste0('l_',fc_fields()))])),
      scope='audit_only_noncanonical',stringsAsFactors=FALSE)
    for(j in seq_len(nrow(raw)))bundles[[ids[j]]]<-list(a=aa[[j]],b=bb[[j]])
    raws[[cell]]<-raw
  }
  d<-do.call(rbind,res);d<-d[order(d$match_id,method='radix'),];rownames(d)<-NULL
  fc_need(nrow(d)==245&&!anyDuplicated(d$match_id)&&sum(d$valid_bundle)==231,'complete pilot adapter accounting')
  list(eligibility=d,bundles=bundles,raw=raws)
}
fc_metrics <- function(adapter) {
  d<-adapter$eligibility;out<-d[c('cell_id','tour','season','event','surface','match_id','player_a_id','player_b_id','a_original_side','b_original_side','status','count_origin','completed_denominator','valid_bundle','quarantined')]
  ids<-sprintf('M%02d',1:15)
  for(side in c('a','b'))for(id in ids) {
    for(field in c('value','numerator','denominator'))out[[paste(side,id,field,sep='_')]]<-NA_real_
    out[[paste(side,id,'reason',sep='_')]]<-NA_character_
  }
  out$NPR<-out$equal_phase_NPR<-out$same_match_win<-NA_real_
  for(i in seq_len(nrow(d))) {
    pair<-adapter$bundles[[d$match_id[i]]]
    if(d$valid_bundle[i]) {
      a<-fc_side(pair$a,pair$b);b<-fc_side(pair$b,pair$a)
      for(side in c('a','b'))for(k in 1:15)for(field in c('value','numerator','denominator','reason'))
        out[[paste(side,ids[k],field,sep='_')]][i]<-get(side)[[field]][k]
      o<-fc_outcomes(pair$a,pair$b);out$NPR[i]<-o[1];out$equal_phase_NPR[i]<-o[2]
      out$same_match_win[i]<-as.integer(d$a_original_side[i]=='winner')
    } else for(side in c('a','b'))for(id in ids)out[[paste(side,id,'reason',sep='_')]][i]<-
      if(d$quarantined[i])'invalid_bundle' else d$exclusion_reason[i]
  }
  for(id in ids) {
    out[[paste0('diff_',id)]]<-out[[paste0('a_',id,'_value')]]-out[[paste0('b_',id,'_value')]]
    for(side in c('a','b')) {
      den<-out[[paste(side,id,'denominator',sep='_')]];flag<-rep(FALSE,nrow(out))
      for(cell in unique(out$cell_id)){ix<-which(out$cell_id==cell&is.finite(den)&den>0);if(length(ix))flag[ix]<-den[ix]==min(den[ix])}
      out[[paste(side,id,'sample_minimum_positive_denominator',sep='_')]]<-flag
    }
  }
  out
}
fc_groups <- function(x) {
  groups<-list()
  for(t in sort(unique(x$tour)))groups[[paste0('tour:',t)]]<-which(x$tour==t)
  for(c in sort(unique(x$cell_id)))groups[[paste0('cell:',c)]]<-which(x$cell_id==c)
  groups
}
fc_cor <- function(x,y,method='pearson') {
  ok<-is.finite(x)&is.finite(y);n<-sum(ok)
  # Algebraically equal rational rates can differ at floating-point precision.
  # Keep their ranks tied; retain full-precision metric values and Pearson inputs.
  if(method=='spearman'){x<-round(x,12);y<-round(y,12)}
  reason<-if(n<3)'insufficient_pairs' else if(length(unique(x[ok]))<2||length(unique(y[ok]))<2)'constant_variable' else 'defined'
  list(n=n,value=if(reason=='defined')unname(cor(x[ok],y[ok],method=method)) else NA_real_,reason=reason)
}
fc_associations <- function(x,dict) {
  fc_need(!anyDuplicated(x$match_id),'association inputs must have one row per match')
  rows<-list();groups<-fc_groups(x);diffs<-paste0('diff_',dict$id)
  for(g in names(groups)) {
    z<-x[groups[[g]],,drop=FALSE];common<-z$valid_bundle&complete.cases(z[c(diffs,'NPR','equal_phase_NPR','same_match_win')])
    for(sample in c('pairwise','common_complete'))for(id in dict$id)for(y in c('NPR','equal_phase_NPR','same_match_win'))for(method in c('pearson','spearman')) {
      take<-if(sample=='common_complete')common else z$valid_bundle
      co<-fc_cor(z[[paste0('diff_',id)]][take],z[[y]][take],method)
      expected<-dict$expected_direction[match(id,dict$id)]
      rows[[length(rows)+1L]]<-data.frame(group=g,tour=z$tour[1],metric=id,outcome=y,method=method,sample=sample,
        available_matches=sum(z$valid_bundle),common_complete_matches=sum(common),pair_count=co$n,correlation=co$value,reason=co$reason,
        expected_direction=expected,direction_agrees=if(is.na(co$value)||co$value==0)NA else (co$value>0)==(expected=='positive'),
        interpretation='descriptive_same_match_not_forecasting_no_p_values')
    }
  };do.call(rbind,rows)
}
fc_matrix <- function(x) {
  x<-as.matrix(x);p<-ncol(x);ok<-if(p)complete.cases(x)&apply(x,1,function(v)all(is.finite(v))) else rep(FALSE,nrow(x))
  z<-x[ok,,drop=FALSE];n<-nrow(z)
  if(n<3||p==0)return(data.frame(common_complete_n=n,columns=p,constant_columns='',near_constant_columns='',rank=NA_integer_,condition_number=NA_real_,effective_condition=NA_real_,state='insufficient_sample'))
  s<-apply(z,2,sd);mu<-colMeans(z);constant<-s==0;near<-!constant&s<=sqrt(.Machine$double.eps)*pmax(1,abs(mu))
  zz<-z[,!constant,drop=FALSE]
  if(!ncol(zz))return(data.frame(common_complete_n=n,columns=p,constant_columns=paste(colnames(z),collapse=';'),near_constant_columns='',rank=0L,condition_number=NA_real_,effective_condition=NA_real_,state='constant_matrix'))
  zz<-scale(zz);sing<-svd(zz,nu=0,nv=0)$d;tol<-max(dim(zz))*.Machine$double.eps*max(sing);r<-sum(sing>tol)
  cond<-if(r<ncol(zz))Inf else max(sing)/min(sing)
  data.frame(common_complete_n=n,columns=p,constant_columns=paste(colnames(z)[constant],collapse=';'),near_constant_columns=paste(colnames(z)[near],collapse=';'),
    rank=r,condition_number=cond,effective_condition=if(r)max(sing)/min(sing[sing>tol]) else NA_real_,
    state=if(r<ncol(zz))'rank_deficient' else 'full_column_rank')
}
fc_redundancy <- function(x,dict) {
  rows<-list();mat<-list();groups<-fc_groups(x)
  exact<-c('M03|M09'='equal','M04|M10'='equal','M08|M15'='equal','M11|M14'='negative','M12|M13'='equal')
  for(g in names(groups)) {
    z<-x[groups[[g]],,drop=FALSE];z<-z[z$valid_bundle,,drop=FALSE]
    m<-fc_matrix(z[paste0('diff_',dict$id)]);m$group<-g
    m$exact_dependencies<-'dM03=dM09;dM04=dM10;dM08=dM15;dM11=-dM14;dM12=dM13'
    m$method<-'center_scale;SVD;tolerance=max(n,p)*machine_epsilon*largest_singular_value;no_fit'
    mat[[g]]<-m
    for(i in 1:14)for(j in (i+1):15) {
      a<-dict$id[i];b<-dict$id[j];key<-paste(a,b,sep='|');rel<-if(key%in%names(exact))exact[[key]] else 'none_proven'
      av<-z[[paste0('diff_',a)]];bv<-z[[paste0('diff_',b)]];ok<-is.finite(av)&is.finite(bv)
      for(method in c('pearson','spearman')) {
        cc<-fc_cor(av,bv,method)
        rows[[length(rows)+1L]]<-data.frame(group=g,metric_a=a,metric_b=b,method=method,pair_count=cc$n,correlation=cc$value,
          exact_difference_relation=rel,max_identity_residual=if(rel=='none_proven'||!any(ok))NA_real_ else max(abs(av[ok]-if(rel=='equal')bv[ok] else -bv[ok])),
          near_duplicate_diagnostic=if(is.na(cc$value))NA else abs(cc$value)>=0.95,
          same_denominator=identical(dict$denominator[i],dict$denominator[j]),same_numerator=identical(dict$numerator[i],dict$numerator[j]),
          shared_source_fields=paste(intersect(strsplit(dict$source_fields[i],', ',fixed=TRUE)[[1]],strsplit(dict$source_fields[j],', ',fixed=TRUE)[[1]]),collapse=';'),
          interpretation='all_pairs_reported;abs_r_0.95_descriptive_flag_not_selection')
      }
    }
  }
  list(redundancy=do.call(rbind,rows),matrix=do.call(rbind,mat))
}
fc_summaries <- function(input,adapter,x,dict) {
  e<-fc_legacy();cells<-e$ebf_cells(input$base)$cells
  coverage<-cells[c('cell_id','tour','season','event_family','surface','source_rows','mapping_state','source_path')]
  counts<-c('inventory_rows','completed_denominator','retirements','walkovers','quarantine','conflicts_preserved','conflict_exclusions','valid_bundles','original_valid_bundles','recovery_bundles')
  for(n in counts)coverage[[n]]<-NA_integer_
  coverage$status<-'UNVETTED_NONPILOT';coverage$event_90pct<-'NOT_EVALUATED';coverage$tour_season_95pct<-'NOT_TESTED';coverage$event_admission<-'NOT_EVALUATED'
  d<-adapter$eligibility
  for(i in seq_len(nrow(coverage))) {
    z<-d[d$cell_id==coverage$cell_id[i],,drop=FALSE]
    if(nrow(z)) {
      coverage$status[i]<-'RECONCILED_PILOT_AUDIT_ONLY'
      coverage[i,counts]<-as.list(c(nrow(z),sum(z$completed_denominator),sum(z$status=='retirement'),sum(z$status=='walkover'),sum(z$quarantined),sum(z$conflict_preserved),0L,sum(z$valid_bundle),sum(z$valid_bundle&z$count_origin=='original_source'),sum(z$valid_bundle&z$count_origin=='approved_recovery_overlay')))
      coverage$event_90pct[i]<-if(sum(z$valid_bundle)>=ceiling(.9*sum(z$completed_denominator)))'PASS_NUMERICAL_ONLY' else 'FAIL'
    }
  }
  missing<-list()
  for(i in seq_len(nrow(coverage))) {
    c<-cells[i,];raw<-input$base$data[[paste(c$tour,c$season,sep='|')]];raw<-raw[raw$tourney_id==c$source_tournament_id,,drop=FALSE]
    for(f in c(paste0('w_',fc_fields()),paste0('l_',fc_fields()))) {
      v<-raw[[f]];present<-!is.na(v)&nzchar(v)
      missing[[length(missing)+1L]]<-data.frame(group=paste0('cell:',c$cell_id),tour=c$tour,season=c$season,event=c$event_family,surface=c$surface,
        kind='source_field',field=f,slot=sub('_.*','',f),count_origin='original_source',population=coverage$status[i],rows=nrow(raw),
        defined=sum(present),missing_input=sum(!present),zero_opportunities=NA_integer_,invalid_bundle=NA_integer_,
        eligibility_excluded=NA_integer_,recovery_supported=0L,missingness_class=if(any(!present))'raw_missing_cause_not_assumed' else 'none_observed')
    }
  }
  availability<-denom<-dist<-list();groups<-fc_groups(x)
  stats<-function(v) {
    v<-v[is.finite(v)]
    if(!length(v))return(c(n=0,min=NA,q1=NA,median=NA,mean=NA,q3=NA,max=NA,sd=NA))
    c(n=length(v),min=min(v),q1=unname(quantile(v,.25)),median=median(v),mean=mean(v),q3=unname(quantile(v,.75)),max=max(v),sd=if(length(v)>1)sd(v) else NA_real_)
  }
  for(g in names(groups)) {
    zz<-x[groups[[g]],,drop=FALSE]
    for(origin in c('ALL',sort(unique(zz$count_origin)))) {
      z<-if(origin=='ALL')zz else zz[zz$count_origin==origin,,drop=FALSE]
      season<-if(length(unique(z$season))==1)as.character(z$season[1]) else 'MULTIPLE'
      event<-if(length(unique(z$event))==1)z$event[1] else 'MULTIPLE'
      for(id in dict$id)for(side in c('a','b')) {
        reason<-z[[paste(side,id,'reason',sep='_')]];v<-z[[paste(side,id,'value',sep='_')]];de<-z[[paste(side,id,'denominator',sep='_')]]
        rec<-data.frame(group=g,tour=z$tour[1],season=season,event=event,surface='Hard',count_origin=origin,metric=id,slot=side,
          inventory_rows=nrow(z),completed_denominator=sum(z$completed_denominator),retirements=sum(z$status=='retirement'),walkovers=sum(z$status=='walkover'),
          quarantine=sum(z$quarantined),conflict_exclusions=0L,valid_bundles=sum(z$valid_bundle),defined=sum(is.finite(v)),
          zero_opportunities=sum(reason=='zero_opportunities'),missing_input=sum(reason=='missing_input'),invalid_bundle=sum(reason=='invalid_bundle'),
          eligibility_excluded=sum(!z$completed_denominator),recovery_supported=sum(is.finite(v)&z$count_origin=='approved_recovery_overlay'))
        availability[[length(availability)+1L]]<-rec
        missing[[length(missing)+1L]]<-data.frame(group=g,tour=z$tour[1],season=season,event=event,surface='Hard',kind='candidate_value',field=id,slot=side,count_origin=origin,
          population='pilot_inventory_preserved',rows=nrow(z),defined=rec$defined,missing_input=rec$missing_input,zero_opportunities=rec$zero_opportunities,
          invalid_bundle=rec$invalid_bundle,eligibility_excluded=rec$eligibility_excluded,recovery_supported=rec$recovery_supported,
          missingness_class='zero_opportunity_structural;input_missing_cause_unknown;quarantine_invalid;RET_WO_eligibility')
        ds<-as.data.frame(as.list(stats(de[is.finite(de)&de>0])))
        ds$group<-g;ds$tour<-z$tour[1];ds$metric<-id;ds$slot<-side;ds$count_origin<-origin
        ds$zero_opportunities<-rec$zero_opportunities
        ds$sample_minimum_positive_count<-if(any(de>0,na.rm=TRUE))sum(de==min(de[de>0&is.finite(de)]),na.rm=TRUE) else 0L
        ds$rule<-'observed_minimum_positive_and_quantiles_only;no_eligibility_threshold'
        denom[[length(denom)+1L]]<-ds
      }
      for(id in dict$id)for(slot in c('a','b','difference')) {
        v<-z[[if(slot=='difference')paste0('diff_',id) else paste(slot,id,'value',sep='_')]]
        ss<-as.data.frame(as.list(stats(v)));ss$group<-g;ss$tour<-z$tour[1];ss$metric<-id;ss$slot<-slot;ss$count_origin<-origin
        ss$out_of_range<-if(slot=='difference')NA_integer_ else sum(v<0|v>if(id%in%c('M11','M14'))Inf else 1,na.rm=TRUE)
        dist[[length(dist)+1L]]<-ss
      }
    }
  }
  list(coverage=coverage,availability=do.call(rbind,availability),missingness=do.call(rbind,missing),denominator=do.call(rbind,denom),distribution=do.call(rbind,dist))
}
fc_sensitivity <- function(x,dict) {
  out<-list();groups<-fc_groups(x)
  for(g in names(groups)) {
    z<-x[groups[[g]],,drop=FALSE];z<-z[z$valid_bundle,,drop=FALSE]
    for(id in dict$id)for(y in c('NPR','equal_phase_NPR','same_match_win'))for(method in c('pearson','spearman')) {
      a<-z[[paste0('diff_',id)]];b<-z[[y]];base<-fc_cor(a,b,method)
      den<-pmin(z[[paste0('a_',id,'_denominator')]],z[[paste0('b_',id,'_denominator')]])
      pos<-den[is.finite(den)&den>0];tail_cut<-if(length(pos))unname(quantile(pos,.25,type=1)) else NA_real_
      scenarios<-list(exclude_recovery=z$count_origin!='approved_recovery_overlay',
        exclude_lower_denominator_quartile=is.finite(den)&den>tail_cut)
      for(cell in sort(unique(z$cell_id)))scenarios[[paste0('exclude_event:',cell)]]<-z$cell_id!=cell
      add<-function(scenario,co,minval=NA_real_,maxval=NA_real_,maxdelta=NA_real_,removed=NA_integer_) {
        out[[length(out)+1L]]<<-data.frame(group=g,tour=z$tour[1],metric=id,outcome=y,method=method,scenario=scenario,
          baseline_n=base$n,baseline_correlation=base$value,pair_count=co$n,correlation=co$value,reason=co$reason,
          min_leave_one=minval,max_leave_one=maxval,max_abs_change=maxdelta,removed_matches=removed,
          denominator_tail_cut=if(scenario=='exclude_lower_denominator_quartile')tail_cut else NA_real_)
      }
      for(s in names(scenarios)) {keep<-scenarios[[s]];keep[is.na(keep)]<-FALSE;cc<-fc_cor(a[keep],b[keep],method)
        add(s,cc,maxdelta=abs(cc$value-base$value),removed=sum(!keep))}
      ok<-which(is.finite(a)&is.finite(b));vals<-vapply(ok,function(i)fc_cor(a[-i],b[-i],method)$value,0.0);valid<-vals[is.finite(vals)]
      add('leave_one_match_range',base,if(length(valid))min(valid) else NA_real_,if(length(valid))max(valid) else NA_real_,
        if(length(valid)&&is.finite(base$value))max(abs(valid-base$value)) else NA_real_,1L)
    }
  };do.call(rbind,out)
}
fc_build <- function(input) {
  dict<-fc_dictionary();adapter<-fc_adapter(input);metrics<-fc_metrics(adapter)
  sums<-fc_summaries(input,adapter,metrics,dict);assoc<-fc_associations(metrics,dict);red<-fc_redundancy(metrics,dict);sens<-fc_sensitivity(metrics,dict)
  provenance<-input$provenance;provenance$mtime<-NULL
  provenance$role<-ifelse(startsWith(provenance$path,'data/raw/'),'saved_raw',ifelse(startsWith(provenance$path,'R/'),'pinned_reconstruction_code','pinned_contract_or_evidence'))
  summary<-data.frame(item=c('state','decision','inventory_rows','normally_completed','retirements','walkovers','quarantined_completed','valid_bundles','recovered_bundles',
    'unvetted_cells','surface_stability','independent_ATP_season_stability','independent_WTA_event_versus_season_stability','tour_season_95pct','canonical_population','forecasting','OTD','Q6_Q8_Q9_Q10'),
    value=c('COMPLETE','GO_TO_FACTOR_DEFINITION_PROTOCOL',nrow(metrics),sum(metrics$completed_denominator),sum(metrics$status=='retirement'),sum(metrics$status=='walkover'),sum(metrics$quarantined),sum(metrics$valid_bundle),sum(metrics$valid_bundle&metrics$count_origin=='approved_recovery_overlay'),
      sum(sums$coverage$status=='UNVETTED_NONPILOT'),rep('NOT_ASSESSABLE',3),'NOT_TESTED','NOT_IMPLEMENTED','BLOCKED','PAUSED_BY_USER_AFTER_PHASE_1S','PENDING_USER_APPROVAL'))
  result<-list('input-provenance'=provenance,'cell-coverage'=sums$coverage,'eligibility-audit'=adapter$eligibility,'candidate-dictionary'=dict,
    'match-metrics'=metrics,'metric-availability'=sums$availability,'missingness-summary'=sums$missingness,'denominator-summary'=sums$denominator,
    'distribution-summary'=sums$distribution,'association-summary'=assoc,'redundancy-map'=red$redundancy,'matrix-diagnostics'=red$matrix,'sensitivity-summary'=sens,'summary'=summary)
  # This decision authorizes nothing: computability plus explicit failures supports protocol design, not four factors.
  fc_need(all(abs(red$redundancy$max_identity_residual)<=1e-12,na.rm=TRUE),'algebraic identity implementation failure')
  for(n in names(result)){rownames(result[[n]])<-NULL}
  result
}
fc_table <- function(x) {
  for(n in names(x)) {
    if(is.numeric(x[[n]]))x[[n]]<-ifelse(is.na(x[[n]]),'NA',formatC(x[[n]],digits=4,format='fg',flag='#'))
    x[[n]]<-gsub('|',' / ',as.character(x[[n]]),fixed=TRUE)
  }
  unname(c(paste0('| ',paste(names(x),collapse=' | '),' |'),paste0('| ',paste(rep('---',ncol(x)),collapse=' | '),' |'),
    apply(x,1,function(r)paste0('| ',paste(r,collapse=' | '),' |'))))
}
fc_report <- function(r) {
  cov<-r$`cell-coverage`;cov<-cov[cov$status!='UNVETTED_NONPILOT',]
  a<-r$`association-summary`;sel<-a$sample=='pairwise'&a$outcome=='NPR'&a$method=='pearson'&startsWith(a$group,'tour:')
  av<-r$`metric-availability`;av<-av[av$count_origin=='ALL'&startsWith(av$group,'cell:'),]
  avsum<-aggregate(cbind(defined,zero_opportunities,missing_input,invalid_bundle)~group+metric,av,sum)
  den<-r$`denominator-summary`;den<-den[den$count_origin=='ALL'&startsWith(den$group,'tour:'),]
  dis<-r$`distribution-summary`;dis<-dis[dis$count_origin=='ALL'&dis$slot=='difference'&startsWith(dis$group,'tour:'),]
  near<-r$`redundancy-map`;near<-near[startsWith(near$group,'tour:')&near$method=='pearson'&near$near_duplicate_diagnostic&near$exact_difference_relation=='none_proven',]
  se<-r$`sensitivity-summary`;se<-se[startsWith(se$group,'tour:')&se$outcome=='NPR'&se$method=='pearson',]
  ses<-aggregate(max_abs_change~group+scenario,se,function(v)max(v,na.rm=TRUE))
  cmp<-a[a$sample=='pairwise'&startsWith(a$group,'tour:'),]
  sensitivity_outcomes<-list()
  for(g in unique(cmp$group))for(id in unique(cmp$metric)) {
    z<-cmp[cmp$group==g&cmp$metric==id,]
    get<-function(o,m)z$correlation[z$outcome==o&z$method==m]
    sensitivity_outcomes[[length(sensitivity_outcomes)+1L]]<-data.frame(group=g,metric=id,
      NPR_Pearson=get('NPR','pearson'),equal_phase_Pearson=get('equal_phase_NPR','pearson'),NPR_Spearman=get('NPR','spearman'),
      same_match_win_Pearson=get('same_match_win','pearson'),same_match_win_Spearman=get('same_match_win','spearman'))
  }
  c('# Phase 2A: Four Factors candidate-metric feasibility','',
    '**Development-only descriptive audit. Decision: GO_TO_FACTOR_DEFINITION_PROTOCOL.** This supports designing a later protocol, not selecting four factors, fitting regressions, clearing forecasting chronology or claiming generalization.','',
    '## Scope and provenance','',
    paste0('Started clean at `',fc_baseline,'`, `Define analytical path after pausing OTD`. The user approved the revised Phase 2A scope. Exactly ',nrow(r$`input-provenance`),' immutable input/code/contract files are fingerprint-checked; the complete local provenance table records paths, SHA-256, sizes and roles.'),
    'Four annuals only: ATP/WTA 2021 and 2023 at archive 83733587353df8a41f2fd4f516147d5aa83f5a8d. Saved annual/reference manifests retain source URLs, access dates, licensing and original hashes. No external state was refreshed. Prior event inventories and Montreal policy layers are reconstructed from pinned evidence, not accepted from old summary labels alone. The separate overlay is reconstructed and compared with its existing release.',
    'The audit uses ATP/WTA Indian Wells 2023 and WTA Montreal 2021, main-draw singles, hard courts. All 40 source candidate cells remain in the inventory; 37 remain UNVETTED_NONPILOT with missing completed denominators and source-field availability only. Source numeric scores never establish their eligibility.','',
    '## Eligibility and coverage','',fc_table(cov[c('cell_id','source_rows','inventory_rows','completed_denominator','retirements','walkovers','quarantine','valid_bundles','original_valid_bundles','recovery_bundles','event_90pct')]),'',
    'The 245 inventory records remain auditable: 232 completed, 11 RET and two WO. One completed WTA Indian Wells bundle remains wholly quarantined, leaving 231 valid bundles. No statistics or derived win indicator from the quarantined record enter diagnostics. Its verified raw result remains in the inventory and completed denominator. Montreal preserves 42 original and seven separately supported bundles, with all 126 original source fields still missing. No recovery is imputation or raw-source repair.',
    'Unresolved conflicts would stop the entire audit. Adopted ATP PDF dissent, Montreal status omissions/scheduled metadata and WTA quarantine reasons remain preserved. No conflict is silently voted away. The 90% event numerical floor is unchanged; 95% tour-season coverage is NOT_TESTED and event admission remains NOT_EVALUATED. Local orientation orders stable source IDs, preserves original winner/loser sides and is not a global canonical identity table.','',
    '## Methods fixed before diagnostics','',
    'M01–M15 follow the unchanged [Phase 1T formula catalogue](post-otd-analytical-path.md#candidate-catalogue). U1 distinguishes zero_opportunities, missing_input and invalid_bundle; known invalidity takes precedence over missingness. Incomplete whole bundles are withheld. RET/WO use separate eligibility exclusion reasons. Lower-is-better metrics retain their original sign. No value is imputed.',
    'Primary associations use one A-minus-B row per match. Pearson (point-biserial for binary same-match win) and Spearman correlations report exact pair counts plus a common-complete sensitivity. Correlations require at least three finite pairs and nonconstant variables. For Spearman only, inputs are rounded to 12 decimal places before average-tie ranking so floating-point noise cannot split algebraically equal rates; metric values and Pearson inputs retain full precision. Repeated players remain dependent; no p-values, significance tests, causal effects or forecast scores are estimated.',
    'Small denominators are described by their observed positive minimum and quantiles, never an eligibility threshold. A fixed descriptive sensitivity removes values at or below the within-group lower quartile (type 1) of the smaller A/B denominator. Absolute correlation at least 0.95 labels possible near duplication only; every pair is reported and no candidate is selected by that label. Numerical near-constant tolerance is sqrt(machine epsilon) times max(1, absolute mean). SVD rank uses max(n,p) times machine epsilon times the largest singular value. These are computational/diagnostic conventions, not tuned factor choices.','',
    '## Metric availability and missingness','',
    'Counts below are defined player-side values, so the maximum is twice the valid match count. Association sample sizes below remain match counts. All unavailable completed statistical values outside the quarantine are zero-opportunity ratios, not missing-count imputations.',
    fc_table(avsum),'',
    'Raw field and metric missingness are reported separately by cell/tour, season, event, surface, side and count origin. Original Montreal omissions remain visible even after separate recovery supports a metric. Missing source-field causes in the 37 unvetted cells are not invented. Missingness classes distinguish opportunity-related structural NA, unknown-cause raw missingness, invalid quarantine and eligibility exclusions.','',
    '## Denominator and distribution findings','',
    fc_table(den[c('group','metric','slot','min','q1','median','max','zero_opportunities','sample_minimum_positive_count')]),'',
    'Second-serve denominators include double faults; M07 alone explicitly conditions them out. No double subtraction occurs in M04. Break-point zero opportunities mean undefined performance, not poor performance. M11/M14 are opportunities per game and can exceed one. All selected bundles pass nonnegative-integer, count-bound and applicable service-game/score/tie-break checks; paired point reconciliation is algebraic and does not independently prove source accuracy.',
    'A-minus-B distributions follow (full side-specific and origin-specific tables remain local):','',fc_table(dis[c('group','metric','n','min','q1','median','mean','q3','max','sd')]),'',
    '## Associations and mathematical coupling','',fc_table(a[sel,c('group','metric','pair_count','common_complete_matches','correlation','expected_direction','direction_agrees')]),'',
    'The following complete tour-level comparison shows NPR versus equal-phase NPR, Pearson versus Spearman, and the external same-match win check. None measures future forecasting.','',fc_table(do.call(rbind,sensitivity_outcomes)),'',
    'Equal-phase NPR equals 100*dM15 and 100*dM08 exactly: perfect association there is an identity. Ordinary NPR also shares service/return point counts but weights the phases by opportunities. A high correlation with either outcome is not evidence of independent factor validity. Source-ID orientation is reproducible but arbitrary; these signed associations must not be interpreted as player-level causal effects.','',
    '## Redundancy and matrix diagnostics','',
    'Exactly: dM03=dM09, dM04=dM10, dM08=dM15, dM11=-dM14, dM12=dM13. Opponent complements therefore collapse several proposed serve/return and conversion/recovery measures into identical differences. M06=M05*(1-M02), M04=M07*(1-M05), and M15=M02*M03+(1-M02)*M04 where defined are additional nonlinear within-side identities. They do not imply corresponding linear identities between differences.',
    fc_table(r$`matrix-diagnostics`[c('group','common_complete_n','columns','constant_columns','near_constant_columns','rank','condition_number','effective_condition','state')]),'',
    'Infinite condition numbers denote rank deficiency; effective condition describes only the nonzero singular subspace. No regression or factor weights were fitted. Pair counts for every metric pair are retained in redundancy-map.csv. Additional abs(Pearson r)>=0.95 pairs without a proved exact difference identity:','',
    if(nrow(near))fc_table(near[c('group','metric_a','metric_b','pair_count','correlation')]) else 'None under the fixed descriptive flag.', '',
    '## Sensitivity findings','',
    'Maximum absolute NPR Pearson-correlation changes across the full candidate set are summarized below; all candidates, outcomes and both methods remain in the local sensitivity table. No favorable sensitivity was selected. Leave-one-match results store correlation ranges and maximum changes without exposing match identities in this report. Dropping the sole event from an event-specific group is explicitly insufficient, not zero effect.','',fc_table(ses),'',
    'Recovery exclusion removes seven Montreal matches while preserving source provenance. It also removes the later-round source gap, so any difference is confounded with round/player selection, not a causal recovery effect. Leave-event comparisons in WTA confound event with season. Denominator-tail removal changes the analyzed population and is diagnostic only.','',
    '## Interpretation and limits','',
    'All 15 formulas are computable and auditable where their denominators exist. Serve Creation and Second-Serve Security contain distinguishable measured quantities (serve frequency, aces, double faults and conditional point success); this does not establish distinct latent mechanisms or future utility. Return success differences repeat opponent serve success differences exactly. Conversion and Recovery does not yield two independent difference measures: conversion and saving are identical; pressure exposure also duplicates opponent break-chance generation with opposite sign. Non-perfect correlations with general service success do not establish incremental clutch skill. The nine counts cannot supply expected conversion/saving residuals or point-level leverage.',
    'ATP/WTA comparisons above are observable descriptions of these hard-court pilot samples only. WTA combines two events/seasons and ATP one. Sampling, opponents, repeated players, round coverage, statistical-source dependence and mathematical coupling prevent broad inference. Uncertainty intervals and opponent adjustment are not estimated.',
    'Surface stability: NOT_ASSESSABLE. Independent ATP season stability: NOT_ASSESSABLE. Independent WTA event-versus-season stability: NOT_ASSESSABLE. Clay/grass generalization, out-of-time factor stability, forecast calibration, superiority to Elo, canonical panel coverage and causal/clutch interpretation are not established.',
    'Four distinct factors are not demonstrated. The successful audit and explicit redundancies support designing a later factor-definition protocol that can reject or replace candidates rather than force four. The decision is not that these are the final four factors.','',
    '## Decision and exact next user decision','',
    '**GO_TO_FACTOR_DEFINITION_PROTOCOL** means documentation/design next, not model implementation. Exact next approval question: "Do you approve an offline factor-definition protocol, using the Phase 2A findings to specify nonredundant candidate comparisons, opportunity/missingness rules, uncertainty and later chronological validation, while selecting no final factors, fitting no coefficients, acquiring no data and leaving forecasting blocked?"',
    'The protocol must distinguish conditional point outcomes from serve creation/pressure mechanisms and specify how Conversion and Recovery could fail. No new formula replacement, sample threshold, history window, dependency or method is approved by this audit.',
    'OTD remains PAUSED_BY_USER_AFTER_PHASE_1S. Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL; Q1/Q2/Q11 remain pending; Q3/Q4 are completed documentation-only approvals and Q5/Q7/Q12 completed specification/feasibility only. Match-sequential forecasting remains primary; all 2,377 previously identified conditional dependencies still lack verified release support.',
    'Later missing-data comparisons remain complete cases/no imputation, mean, justified mean-plus-indicator and PMM multiple imputation, fitted only inside chronological training/resamples. No outcomes are imputed. Freeze all selection/settings before 2025; documented safeguards are not proof of avoiding overfitting. No 2022/2024/2025 data, network, source acquisition, Elo, histories, forecasts, portfolio edit, publication or push occurred.','',
    '## Outputs and reproduction','',fc_table(data.frame(output=paste0(names(r),'.csv'),rows=vapply(r,nrow,1L))), '',
    'All CSVs are local and ignored under data/pilot/four-factors-candidate-metric-feasibility/. Eligibility and match-metric rows are restricted and never committed. CSV diagnostics use 12 significant digits, decimal point, explicit NA, stable order and no timestamps; calculations retain double precision. Existing identical outputs retain bytes and modification times. Changed existing outputs are refused pending review, never partially replaced. Input/mapping failures stop before publication of a new audit.',
    '```sh','Rscript R/audit_four_factors_candidate_metrics.R','Rscript R/test_four_factors_candidate_metrics.R','```','',
    'See [current status](status.md), [source contract](data-source-contract.md), [standing research guidance](../PROJECT_CONTEXT.md) and [tests](../R/test_four_factors_candidate_metrics.R). Verification results are recorded in status. This private audit report grants no public derivative-data permission. Future response-only ChatGPT handoffs remain no more than 2,000 words.')
}
fc_publish <- function(result,dir=fc_dir(),report=fc_report_path) {
  fc_need(identical(dir,fc_dir())&&identical(report,fc_report_path),'output path outside approved scope')
  paths<-c(file.path(dir,paste0(names(result),'.csv')),report)
  lines<-c(lapply(result,fc_csv_lines),list(fc_report(result)))
  # Preflight the whole release before any write. Refuse replacement, including partial old releases.
  exists<-file.exists(paths)
  fc_need(!any(exists)||all(exists),'partial existing release; preserve and review')
  if(all(exists)) {
    fc_need(all(vapply(seq_along(paths),function(i)identical(readLines(paths[i],warn=FALSE),lines[[i]]),TRUE)), 'existing release differs; preserve and review')
    return(invisible(paths))
  }
  tracked<-system2('git',c('ls-files','--','data/raw','data/pilot'),stdout=TRUE)
  fc_need(!length(tracked),'restricted evidence tracked')
  fc_need(identical(system2('git',c('check-ignore','--',paths[1]),stdout=TRUE),paths[1]),'output must be ignored')
  # Stage the full release outside the research tree. Existing files are never replaced.
  stage<-tempfile('phase2a-release-');dir.create(stage)
  on.exit(unlink(stage,recursive=TRUE),add=TRUE)
  staged<-file.path(stage,as.character(seq_along(paths)))
  for(i in seq_along(paths))writeLines(lines[[i]],staged[i],useBytes=TRUE)
  fc_need(!any(file.exists(paths)),'release appeared during staging; preserve and review')
  made<-character();success<-FALSE
  on.exit(if(!success&&length(made))unlink(made),add=TRUE)
  dir.create(dir,showWarnings=FALSE)
  for(i in seq_along(paths)) {
    fc_need(!file.exists(paths[i]),'release appeared during installation')
    # Record only paths absent at entry, so cleanup cannot delete earlier work.
    made<-c(made,paths[i])
    fc_need(file.copy(staged[i],paths[i],overwrite=FALSE),'release installation failed')
  }
  success<-TRUE
  invisible(paths)
}
audit_four_factors_candidate_metrics <- function(write_outputs=TRUE) {
  input<-fc_load();result<-fc_build(input)
  fc_need(identical(input$provenance,fc_snapshot()),'evidence changed before output commit')
  if(write_outputs)fc_publish(result)
  invisible(result)
}
if(sys.nframe()==0L) {
  tryCatch({r<-audit_four_factors_candidate_metrics();print(r$summary,row.names=FALSE)},error=function(e) {
    message('# Phase 2A blocked report\n\n',conditionMessage(e),'\nNo current successful audit; prior files preserved. No acquisition authorized.')
    quit(status=1L)
  })
}
