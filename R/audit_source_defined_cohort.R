# Phase 2H, admission audit 1.0.0. Offline; sourcing this file has no side effects.
# Authority: Phase 2H user approval of the decision at 6d3bef480f0f233b1c95e551a09aa7ca2bb67aa7.
# Raw values stay character-valued. This is an audit population, not forecast authorization.
sa_version <- '1.0.0'
sa_revision <- '83733587353df8a41f2fd4f516147d5aa83f5a8d'
sa_dir <- 'data/pilot/source-defined-cohort-admission'
sa_files <- c('input-provenance','row-dispositions','cohort-membership','cell-coverage',
              'field-availability','summary')
sa_fields <- as.vector(outer(c('w_','l_'), c('ace','df','svpt','1stIn','1stWon',
                                         '2ndWon','SvGms','bpFaced','bpSaved'), paste0))
sa_read <- function(path) read.csv(path, colClasses='character', na.strings=NULL,
                                  check.names=FALSE, stringsAsFactors=FALSE)
sa_hash <- function(path) {
  if (!file.exists(path) || dir.exists(path)) return('MISSING')
  strsplit(system2('shasum', c('-a','256',shQuote(path)), stdout=TRUE), ' ')[[1]][1]
}
sa_need <- function(ok, reason) if (!isTRUE(ok)) stop(reason, call.=FALSE)
sa_join <- function(x) {
  x<-unlist(strsplit(as.character(x),';',fixed=TRUE),use.names=FALSE)
  paste(sort(unique(as.character(x[!is.na(x)&nzchar(x)])),method='radix'),collapse=';')
}
# Literal independent pins copied from the frozen Phase 2F provenance; no historical runner.
sa_pins <-  c(DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
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
sa_inputs <- function() {
  names <- c('atp_matches_2023.csv','wta_matches_2023.csv','wta_matches_2021.csv')
  data.frame(file=names, tour=c('ATP','WTA','WTA'), season=c('2023','2023','2021'),
    path=paste0('data/raw/sackmann/',sa_revision,'/',names),
    manifest=c(rep('data/manifests/pilot-source-files.csv',2),
               'data/manifests/development-source-files.csv'),stringsAsFactors=FALSE)
}
sa_panel <- function() {
  families <- c('Australian Open','Roland-Garros','Wimbledon','US Open','Indian Wells',
                'Miami','Madrid','Rome','Canada','Cincinnati')
  inputs <- sa_inputs()
  do.call(rbind,lapply(seq_len(nrow(inputs)),function(i) {
    atp <- inputs$tour[i]=='ATP'; yr <- inputs$season[i]
    suffix <- if(atp) c('580','520','540','560','0404','0403','1536','0416','0421','0422') else
      c('580','520','540','560','609','902','1038','709','806','1017')
    labels <- if(atp) c('Australian Open','Roland Garros','Wimbledon','Us Open',
      'Indian Wells Masters','Miami Masters','Madrid Masters','Rome Masters','Canada Masters',
      'Cincinnati Masters') else c('Australian Open','Roland Garros','Wimbledon','Us Open',
      'Indian Wells','Miami','Madrid','Rome','Montreal','Cincinnati')
    data.frame(file=inputs$file[i],tour=inputs$tour[i],season=yr,event=families,
      cell_id=paste(inputs$tour[i],yr,families,sep='|'),tourney_id=paste(yr,suffix,sep='-'),
      label=labels,surface=c('Hard','Clay','Grass','Hard','Hard','Hard','Clay','Clay','Hard','Hard'),
      level=if(atp)c(rep('G',4),rep('M',6)) else if(yr=='2021')
        c(rep('G',4),'P','P','P','PM','P','P') else c(rep('G',4),rep('PM',4),'P','P'),
      best_of=if(atp)c(rep('5',4),rep('3',6)) else '3',stringsAsFactors=FALSE)
  }))
}
sa_dependencies <- function(input) {
  p<-names(sa_pins)
  shared<-p[p %in% c('DATA_LICENSE.md','PROJECT_CONTEXT.md','AGENTS.override.md',
    'docs/occam-candidate-and-data-decision.md',
    'data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv')]
  specific<-if(input$season=='2021') p[grepl('montreal|wta_matches_2021.metadata',p)] else
    p[grepl('indian-wells|inventory-reference|atp-inventory-reference|anomaly-reference|wta-anomaly',p)]
  unique(c(shared,specific,input$manifest,input$path))
}
sa_preflight <- function(input, hashes) {
  dep<-sa_dependencies(input); bad<-dep[hashes[dep]!=sa_pins[dep] | is.na(hashes[dep])]
  reasons<-if(length(bad))paste0('missing_or_changed:',bad) else character()
  if(length(reasons)) return(list(ok=FALSE,reasons=sa_join(reasons),manifest=NULL))
  m<-sa_read(input$manifest);m<-m[m$local_path==input$path,,drop=FALSE]
  expected_source<-paste0(tolower(input$tour),'/',input$file)
  good<-nrow(m)==1 && m$tour==input$tour && m$pinned_commit==sa_revision &&
    m$source_path==expected_source && m$sha256==sa_pins[input$path] &&
    m$byte_size==as.character(file.info(input$path)$size) &&
    m$source_url==paste0('https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/',
                       sa_revision,'/',expected_source) &&
    m$license_id=='CC-BY-NC-SA-4.0' && m$original_creator=='Jeff Sackmann / Tennis Abstract' &&
    grepl('noncommercial',m$use_notes,fixed=TRUE) && nzchar(m$retrieved_at_utc)
  if(!isTRUE(good)) reasons<-c(reasons,'saved_use_or_manifest_mismatch')
  blob<-system2('git',c('hash-object','--',shQuote(input$path)),stdout=TRUE)
  if(nrow(m)!=1 || !identical(blob,m$source_git_blob)) reasons<-c(reasons,'git_blob_mismatch')
  list(ok=!length(reasons),reasons=sa_join(reasons),manifest=m)
}
# Conservative ordinary-set grammar; extended sets/match tie-breaks remain unsupported.
# A source result must end when its winner FIRST reaches two or three won sets.
sa_score <- function(score,best_of) {
  result<-function(status,reason='',games=NA_real_) list(status=status,reason=reason,games=games)
  if(is.na(score)||!nzchar(trimws(score))) return(result('ambiguous','missing_score'))
  s<-toupper(trimws(score))
  markers<-c(retirement='RET',walkover='W/O|WALKOVER|WALK OVER|^WO$',
             default='DEF',abandoned='ABD|ABN|ABAND|CANC',unfinished='SUSP|UNFIN')
  found<-names(markers)[vapply(markers,function(p)grepl(p,s),TRUE)]
  if(length(found)) return(result(if(length(found)==1)found else 'ambiguous',
                                sa_join(paste0('status_',found))))
  if(!best_of %in% c('3','5')) return(result('ambiguous','unsupported_match_format'))
  token_pattern<-'^[0-9]+-[0-9]+(\\([0-9]+\\))?$'
  tokens<-strsplit(s,' +')[[1]]
  if(!all(grepl(token_pattern,tokens))) return(result('ambiguous','unknown_score_syntax'))
  pairs<-do.call(rbind,lapply(strsplit(gsub('\\([0-9]+\\)','',tokens),'-'),as.numeric))
  a<-pairs[,1]; b<-pairs[,2]; hi<-pmax(a,b); lo<-pmin(a,b)
  if(any(hi>7)) return(result('ambiguous','unsupported_extended_set'))
  regular<-(hi==6 & lo<=4)|(hi==7 & lo %in% c(5,6))
  annotations_ok<-!grepl('(',tokens,fixed=TRUE)|(hi==7 & lo==6)
  need<-as.numeric(best_of)%/%2+1
  won<-a>b; lost<-b>a
  if(!all(regular & annotations_ok)||length(a)>as.numeric(best_of)||sum(won)!=need||
     sum(lost)>=need||any(head(cumsum(won),-1)>=need)||any(head(cumsum(lost),-1)>=need))
    return(result('unfinished','incomplete_or_inconsistent_score'))
  result('source_reported_normal','',sum(pairs)-sum(hi==7 & lo==6))
}
sa_counts <- function(row, parsed) {
  values<-unlist(row[sa_fields],use.names=TRUE)
  missing<-is.na(values)|values %in% c('','NA'); integer<-!missing & grepl('^[0-9]+$',values)
  num<-suppressWarnings(as.numeric(values)); names(num)<-names(values)
  integer<-integer & is.finite(num) & num<=2^53
  reasons<-c(if(any(missing))paste0('missing_count:',names(values)[missing]),
             if(any(!missing & !integer))paste0('invalid_integer:',names(values)[!missing & !integer]))
  # Evaluate every available bound, even if another field or the other side is missing.
  for(side in c('w','l')) {
    x<-num[paste0(side,'_',c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpFaced','bpSaved'))]
    names(x)<-c('A','D','S','I','F','Q','G','B','V')
    bounds<-c(first_in=x['I']<=x['S'], first_won=x['F']<=x['I'],second_won=x['Q']<=x['S']-x['I'],
      df=x['D']<=x['S']-x['I'],second_won_df=x['Q']+x['D']<=x['S']-x['I'],
      saved=x['V']<=x['B'],faced=x['B']<=x['S'],aces=x['A']<=x['F']+x['Q'],
      positive_service=x['S']>0,games_points=x['G']<=x['S'])
    if(any(!bounds,na.rm=TRUE)) reasons<-c(reasons,paste0('count_bound:',side,'_',sub('\\..*$','',names(bounds)[which(!bounds)])))
  }
  game_state<-'NOT_EVALUABLE'
  if(is.finite(parsed$games) && all(integer[match(c('w_SvGms','l_SvGms'),names(values))])) {
    game_state<-if(sum(num[c('w_SvGms','l_SvGms')])==parsed$games)'PASS' else 'FAIL'
    if(game_state=='FAIL') reasons<-c(reasons,'service_games_score_conflict')
  } else reasons<-c(reasons,'game_reconciliation_not_evaluable')
  list(valid=!length(reasons),reasons=sa_join(reasons),raw_complete=!any(missing),
       missing=sum(missing),game_state=game_state)
}
sa_identity <- function(d) {
  n<-nrow(d); reasons<-rep('',n)
  add<-function(idx,reason) {for(i in which(idx)) reasons[i]<<-sa_join(c(strsplit(reasons[i],';',fixed=TRUE)[[1]],reason))}
  add(!grepl('^[0-9]+$',d$winner_id)|!grepl('^[0-9]+$',d$loser_id)|
        !nzchar(trimws(d$winner_name))|!nzchar(trimws(d$loser_name)),'identity_missing_or_malformed')
  add(d$winner_id==d$loser_id,'identity_same_player')
  # Exact source names are retained; aliases are not silently invented.
  people<-rbind(data.frame(tour=d$audit_tour,id=d$winner_id,name=d$winner_name,hand=d$winner_hand),
                data.frame(tour=d$audit_tour,id=d$loser_id,name=d$loser_name,hand=d$loser_hand))
  key<-paste(people$tour,people$id,sep=':')
  conflicts<-names(which(vapply(split(seq_len(nrow(people)),key),function(k)
    length(unique(people$name[k][nzchar(people$name[k])]))>1 ||
    length(unique(people$hand[k][people$hand[k] %in% c('L','R')]))>1,TRUE)))
  add(paste(d$audit_tour,d$winner_id,sep=':') %in% conflicts |
        paste(d$audit_tour,d$loser_id,sep=':') %in% conflicts,'identity_conflicting_id')
  namekey<-paste(people$tour,people$name,sep=':')
  collisions<-names(which(vapply(split(people$id,namekey),function(x)length(unique(x))>1,TRUE)))
  add(paste(d$audit_tour,d$winner_name,sep=':') %in% collisions |
        paste(d$audit_tour,d$loser_name,sep=':') %in% collisions,'identity_name_collision')
  reasons
}
sa_duplicates <- function(d) {
  both<-function(x) duplicated(x)|duplicated(x,fromLast=TRUE)
  pair<-vapply(seq_len(nrow(d)),function(i)paste(sort(c(d$winner_id[i],d$loser_id[i]),method='radix'),collapse=':'),'')
  key<-paste(d$audit_tour,d$tourney_id,d$match_num,sep=':')
  encounter<-paste(d$audit_tour,d$tourney_id,d$round,d$tourney_date,pair,sep=':')
  dk<-both(key);de<-both(encounter)
  vapply(seq_len(nrow(d)),function(i)sa_join(c(if(dk[i])'duplicate_source_key',
    if(de[i])'duplicate_encounter')), '')
}
sa_pilot_path <- 'data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv'
sa_overlay_path <- 'data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds'
sa_dispositions <- function(d,pilot,overlay) {
  panel<-sa_panel()
  mapping<-match(paste(d$audit_file,d$tourney_id),paste(panel$file,panel$tourney_id))
  missing<-is.na(mapping)
  mapping[missing]<-match(paste(d$audit_file[missing],d$tourney_name[missing]),paste(panel$file,panel$label))
  sa_need(!anyNA(mapping),'Internal error: off-panel row sent to admission checks')
  p<-panel[mapping,]
  reasons<-vector('list',nrow(d)); identity<-sa_identity(d); duplicate<-sa_duplicates(d)
  derived<-vector('list',nrow(d))
  for(i in seq_len(nrow(d))) {
    row<-d[i,,drop=FALSE]; id<-paste(row$audit_tour,row$tourney_id,row$match_num,sep=':')
    pp<-p[i,]; why<-character()
    context<-character()
    if(row$tourney_id!=pp$tourney_id) context<-c(context,'unresolved_source_edition')
    if(length(unique(d$tourney_id[p$cell_id==pp$cell_id]))!=1) context<-c(context,'multiple_source_editions')
    if(row$tourney_name!=pp$label) context<-c(context,'event_label_conflict')
    if(row$surface!=pp$surface) context<-c(context,'surface_conflict')
    if(row$tourney_level!=pp$level) context<-c(context,'level_conflict')
    if(row$best_of!=pp$best_of) context<-c(context,'match_format_conflict')
    date<-suppressWarnings(as.Date(row$tourney_date,format='%Y%m%d'))
    if(is.na(date)||!grepl('^[0-9]{8}$',row$tourney_date)||
       format(date,'%Y%m%d')!=row$tourney_date||substr(row$tourney_date,1,4)!=row$audit_season)
      context<-c(context,'event_date_or_season_conflict')
    if(!row$round %in% c('R128','R64','R32','R16','QF','SF','F')) context<-c(context,'non_main_draw_or_unknown_round')
    if(!grepl('^[0-9]+$',row$match_num)) context<-c(context,'source_match_id_invalid')
    cellrows<-d$audit_file==row$audit_file & d$tourney_id==row$tourney_id
    if(length(unique(d$tourney_date[cellrows]))!=1) context<-c(context,'edition_date_conflict')
    parsed<-sa_score(row$score,row$best_of); status<-parsed$status
    old<-pilot[pilot$match_id==id,,drop=FALSE]; effective<-row
    origin<-'original_source'; policy<-''; conflict<-''; official<-''; quarantined<-FALSE
    if(nrow(old)) {
      # Pin plus full linkage binds every reused historical decision to its original row.
      linked<-nrow(old)==1 && old$source_winner_id==row$winner_id && old$source_loser_id==row$loser_id &&
        old$source_winner_name==row$winner_name && old$source_loser_name==row$loser_name &&
        old$round==row$round && old$source_score==row$score && old$source_path==row$audit_source_path
      if(!linked) why<-c(why,'pilot_link_conflict') else {
        policy<-old$status_policy; conflict<-old$conflict_detail; official<-old$official_id
        quarantined<-old$quarantined=='TRUE'
        if(old$status %in% c('retirement','walkover')) status<-old$status
        if(old$status=='normally_completed' && parsed$status!='source_reported_normal')
          why<-c(why,'pilot_completion_parser_conflict')
        if(quarantined) why<-c(why,'pilot_bundle_quarantine','cross_source_conflict')
        if(old$count_origin=='approved_recovery_overlay') {
          f<-overlay[overlay$source_audit_id==paste0('sackmann:',id),,drop=FALSE]
          good<-nrow(f)==18 && !anyDuplicated(f$source_field) && setequal(f$source_field,sa_fields) &&
            all(unlist(row[sa_fields])=='') && all(f$source_winner_id==row$winner_id) &&
            all(f$source_loser_id==row$loser_id) && all(f$source_score==row$score) &&
            all(f$policy_version=='1.0.0') && all(f$structural_validation_state=='passed_51_of_51_applicable_checks') &&
            status=='source_reported_normal'
          if(!good) why<-c(why,'pilot_overlay_conflict') else {
            effective[sa_fields]<-as.list(as.character(f$value[match(sa_fields,f$source_field)]))
            origin<-'approved_recovery_overlay'
          }
        }
      }
    }
    counts<-sa_counts(effective,parsed)
    raw_complete<-all(!unlist(row[sa_fields]) %in% c('','NA'))
    if(status!='source_reported_normal') why<-c(why,paste0('excluded_status:',status))
    why<-sa_join(c(why,context,identity[i],duplicate[i],parsed$reason,counts$reasons))
    a_winner<-order(c(row$winner_id,row$loser_id),method='radix')[1]==1
    out<-data.frame(audit_version=sa_version,cell_id=pp$cell_id,event=pp$event,match_id=id,
      panel_disposition=if(!length(context))'PASS' else 'EXCLUDED',context_reasons=sa_join(context),
      score_status=parsed$status,score_reason=parsed$reason,completion_status=status,
      identity_disposition=if(!nzchar(identity[i]))'PASS' else 'EXCLUDED',identity_reasons=identity[i],
      duplicate_reasons=duplicate[i],statistics_disposition=if(counts$valid && !quarantined)'PASS' else 'EXCLUDED',
      count_reasons=counts$reasons,game_reconciliation=counts$game_state,
      raw_count_complete=raw_complete,count_origin=origin,quarantined=quarantined,
      pilot_policy=policy,pilot_conflict_detail=conflict,pilot_official_id=official,
      membership=if(!nzchar(why))'INCLUDED' else 'EXCLUDED',exclusion_reasons=why,
      player_a_id=if(a_winner)row$winner_id else row$loser_id,
      player_b_id=if(a_winner)row$loser_id else row$winner_id,
      a_original_side=if(a_winner)'winner' else 'loser', stringsAsFactors=FALSE)
    # Effective counts are separate audit columns; original w_/l_ fields never change.
    for(field in sa_fields) out[[paste0('effective_',field)]]<-effective[[field]]
    derived[[i]]<-out
  }
  cbind(d,do.call(rbind,derived))
}
sa_coverage <- function(rows,files) {
  panel<-sa_panel(); out<-fields<-list()
  for(i in seq_len(nrow(panel))) {
    p<-panel[i,]; file<-files[files$file==p$file,,drop=FALSE]
    z<-rows[!is.na(rows$cell_id)&rows$cell_id==p$cell_id,,drop=FALSE]
    if(file$state=='BLOCKED') z<-z[FALSE,,drop=FALSE]
    rounds<-c('ALL',sort(unique(z$round),method='radix'))
    for(round in rounds) {
      x<-if(round=='ALL')z else z[z$round==round,,drop=FALSE]
      blocked<-file$state=='BLOCKED'; n<-if(blocked)NA_integer_ else nrow(x)
      included<-if(blocked)NA_integer_ else sum(x$membership=='INCLUDED')
      complete<-if(blocked)NA_integer_ else sum(x$raw_count_complete=='TRUE')
      known<-round=='ALL' && p$cell_id %in% c('ATP|2023|Indian Wells','WTA|2023|Indian Wells','WTA|2021|Canada')
      denom<-if(known)if(p$season=='2021')55L else 95L else NA_integer_
      # Saved official match inventory denominators exclude byes, retain RET/WO.
      out[[length(out)+1]]<-data.frame(tour=p$tour,season=p$season,event=p$event,
        surface=p$surface,round=round,cell_id=p$cell_id,
        state=if(blocked)'FILE_BLOCKED' else if(!n)'ABSENT_SOURCE_CELL' else 'OBSERVED',
        observed_source_rows=n,source_reported_normal=if(blocked)NA else sum(x$completion_status=='source_reported_normal'),
        admitted_source_records=included,excluded_source_records=n-included,
        raw_complete_count_bundles=complete,source_record_retention=if(!is.na(n)&&n>0)included/n else NA_real_,
        raw_count_availability=if(!is.na(n)&&n>0)complete/n else NA_real_,
        saved_official_inventory_denominator=denom,
        official_inventory_recall=if(known && !blocked)as.character(n/denom) else 'UNKNOWN',
        official_recall_basis=if(known)'PINNED_PILOT_RECONCILIATION' else 'NO_SAVED_DENOMINATOR',
        official_gate='NOT_TESTED_BY_SOURCE_RECORD_RETENTION',stringsAsFactors=FALSE)
      for(field in sa_fields) {
        values<-x[[field]]; present<-sum(!is.na(values)&!values %in% c('','NA'))
        integer<-sum(grepl('^[0-9]+$',values)&is.finite(suppressWarnings(as.numeric(values))))
        fields[[length(fields)+1]]<-data.frame(tour=p$tour,season=p$season,event=p$event,
          surface=p$surface,round=round,field=field,observed_source_rows=n,
          present=if(blocked)NA_integer_ else present,nonnegative_integer=if(blocked)NA_integer_ else integer,
          source_count_availability=if(!is.na(n)&&n>0)present/n else NA_real_,
          fraction_basis='OBSERVED_SOURCE_ROWS_NOT_OFFICIAL_COVERAGE',stringsAsFactors=FALSE)
      }
    }
  }
  list(coverage=do.call(rbind,out),fields=do.call(rbind,fields))
}
sa_empty <- function(raw_names) {
  derived<-c('audit_file','audit_tour','audit_season','audit_source_path','audit_source_row',
    'audit_version','cell_id','event','match_id','panel_disposition','context_reasons',
    'score_status','score_reason','completion_status','identity_disposition','identity_reasons',
    'duplicate_reasons','statistics_disposition','count_reasons','game_reconciliation',
    'raw_count_complete','count_origin','quarantined','pilot_policy','pilot_conflict_detail',
    'pilot_official_id','membership','exclusion_reasons','player_a_id','player_b_id','a_original_side',
    paste0('effective_',sa_fields))
  as.data.frame(setNames(rep(list(character()),length(c(raw_names,derived))),c(raw_names,derived)),
                stringsAsFactors=FALSE)
}
sa_build <- function() {
  inputs<-sa_inputs(); hashes<-setNames(vapply(names(sa_pins),sa_hash,''),names(sa_pins))
  provenance<-data.frame(path=names(sa_pins),expected_sha256=unname(sa_pins),
    observed_sha256=unname(hashes),state=ifelse(hashes==sa_pins,'VERIFIED','BLOCKED'),
    reason=ifelse(hashes==sa_pins,'','missing_or_changed'),stringsAsFactors=FALSE)
  provenance$audit_version<-sa_version
  provenance$archive_revision<-'';provenance$manifest<-'';provenance$source_url<-''
  provenance$saved_use_basis<-'';provenance$dependencies<-'';provenance$source_git_blob<-''
  files<-list(); raw<-list()
  required<-c('tourney_id','tourney_name','surface','tourney_level','tourney_date','round','best_of',
              'match_num','score','winner_id','winner_name','winner_hand','loser_id','loser_name','loser_hand',sa_fields)
  raw_names<-required
  for(i in seq_len(nrow(inputs))) {
    input<-inputs[i,,drop=FALSE]; pf<-sa_preflight(input,hashes); d<-NULL
    if(pf$ok) {
      d<-tryCatch(sa_read(input$path),error=function(e)NULL)
      reason<-if(is.null(d))'unreadable_csv' else if(anyDuplicated(names(d))||!all(required %in% names(d)))
        'required_schema_mismatch' else if(nrow(d)!=as.integer(pf$manifest$row_count))'manifest_row_count_mismatch' else ''
      if(nzchar(reason)) {pf$ok<-FALSE;pf$reasons<-reason}
    }
    files[[i]]<-data.frame(file=input$file,tour=input$tour,season=input$season,
      state=if(pf$ok)'VERIFIED' else 'BLOCKED',reason=pf$reasons,
      rows=if(pf$ok)nrow(d) else NA_integer_,stringsAsFactors=FALSE)
    k<-match(input$path,provenance$path);provenance$state[k]<-files[[i]]$state;provenance$reason[k]<-pf$reasons
    provenance$archive_revision[k]<-sa_revision;provenance$manifest[k]<-input$manifest
    provenance$dependencies[k]<-paste(sa_dependencies(input),collapse=';')
    provenance$saved_use_basis[k]<-if(pf$ok)'VERIFIED_SAVED_LOCAL_NONCOMMERCIAL_BASIS_AND_PHASE_2H_USER_APPROVAL_NO_NEW_PROVIDER_GRANT' else 'UNVERIFIED_FILE_BLOCKED'
    if(!is.null(pf$manifest)&&nrow(pf$manifest)==1) {
      provenance$source_url[k]<-pf$manifest$source_url
      provenance$source_git_blob[k]<-pf$manifest$source_git_blob
    }
    if(pf$ok) {
      raw_names<-names(d);d$audit_file<-input$file;d$audit_tour<-input$tour
      d$audit_season<-input$season;d$audit_source_path<-input$path;d$audit_source_row<-seq_len(nrow(d))
      raw[[i]]<-d
    }
  }
  files<-do.call(rbind,files); rows<-sa_empty(raw_names)
  if(length(raw)) {
    allraw<-do.call(rbind,raw);panel<-sa_panel()
    inpanel<-paste(allraw$audit_file,allraw$tourney_id) %in% paste(panel$file,panel$tourney_id) |
      paste(allraw$audit_file,allraw$tourney_name) %in% paste(panel$file,panel$label)
    pilot<-sa_read(sa_pilot_path)
    overlay<-if(hashes[sa_overlay_path]==sa_pins[sa_overlay_path])readRDS(sa_overlay_path)$field_decisions else data.frame()
    if(any(inpanel)) rows<-sa_dispositions(allraw[inpanel,,drop=FALSE],pilot,overlay)
    outside<-allraw[!inpanel,,drop=FALSE]
    if(nrow(outside)) {
      # Off-panel rows receive only a scope disposition, not tennis/statistical analysis.
      for(field in setdiff(names(rows),names(outside))) outside[[field]]<-''
      outside$audit_version<-sa_version;outside$panel_disposition<-'OUTSIDE_PANEL'
      outside$membership<-'OUTSIDE_PANEL';outside$exclusion_reasons<-'outside_authorized_panel'
      outside$score_status<-outside$completion_status<-outside$identity_disposition<-
        outside$statistics_disposition<-outside$game_reconciliation<-'NOT_ASSESSED_OUTSIDE_PANEL'
      rows<-rbind(rows,outside[,names(rows),drop=FALSE])
    }
    rows<-rows[order(rows$audit_file,as.integer(rows$audit_source_row),method='radix'),,drop=FALSE]
  }
  coverage<-sa_coverage(rows,files)
  members<-rows[rows$membership=='INCLUDED',,drop=FALSE]
  # A/B keys use source-ID lexical order; winner is retained solely as outcome/linkage.
  membership_fields<-c('audit_version','audit_file','audit_source_path','audit_source_row','audit_tour','audit_season',
    'cell_id','event','surface','round','match_id','player_a_id','player_b_id','a_original_side','count_origin',
    'winner_id','loser_id','pilot_policy','pilot_conflict_detail')
  members<-members[,membership_fields,drop=FALSE]
  summaries<-list()
  add<-function(group,measure,count,detail='') summaries[[length(summaries)+1]]<<-
    data.frame(group=group,measure=measure,value=as.character(count),detail=detail,stringsAsFactors=FALSE)
  for(i in seq_len(nrow(files))) {
    f<-files[i,];z<-rows[rows$audit_file==f$file,,drop=FALSE];panelrows<-z[z$membership!='OUTSIDE_PANEL',,drop=FALSE]
    add(f$file,'input_state',f$state,f$reason);add(f$file,'input_rows',f$rows)
    add(f$file,'outside_panel',sum(z$membership=='OUTSIDE_PANEL'))
    add(f$file,'observed_panel_rows',if(f$state=='BLOCKED')NA else nrow(panelrows))
    add(f$file,'admitted_source_records',if(f$state=='BLOCKED')NA else sum(panelrows$membership=='INCLUDED'))
    for(status in sort(unique(panelrows$completion_status),method='radix'))
      add(f$file,paste0('completion:',status),sum(panelrows$completion_status==status))
    for(reason in sort(unique(as.character(unlist(strsplit(panelrows$exclusion_reasons,';',fixed=TRUE)))),method='radix'))
      if(nzchar(reason)) add(f$file,paste0('exclusion:',reason),sum(vapply(strsplit(panelrows$exclusion_reasons,';',fixed=TRUE),function(x)reason %in% x,TRUE)))
  }
  add('ALL','audit_version',sa_version);add('ALL','publication','BLOCKED_PENDING_RIGHTS_REVIEW')
  add('ALL','modeling','NOT_AUTHORIZED');add('ALL','official_recall_without_saved_denominator','UNKNOWN')
  result<-setNames(list(provenance,rows,members,coverage$coverage,coverage$fields,do.call(rbind,summaries)),sa_files)
  attr(result,'input_hashes')<-hashes
  result
}
sa_lines <- function(x) {
  con<-textConnection('lines','w',local=TRUE);on.exit(close(con))
  write.table(x,con,sep=',',row.names=FALSE,col.names=TRUE,quote=TRUE,na='NA',eol='\n',qmethod='double')
  lines
}
sa_publish <- function(result,dir=sa_dir) {
  sa_need(identical(names(result),sa_files),'unexpected output scope')
  sa_need(identical(attr(result,'input_hashes'),setNames(vapply(names(sa_pins),sa_hash,''),names(sa_pins))),
          'Inputs changed since audit; publication refused')
  lines<-lapply(result,sa_lines);paths<-file.path(dir,paste0(sa_files,'.csv'))
  if(dir.exists(dir)) {
    sa_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),
            'Existing release has a different file scope; preserve and review')
    sa_need(all(vapply(seq_along(paths),function(i)identical(readLines(paths[i],warn=FALSE),lines[[i]]),TRUE)),
            'Existing release differs; preserve and review')
    return(invisible(paths))
  }
  sa_need(dir.exists(dirname(dir)),'output parent missing')
  stage<-tempfile('.source-admission-',tmpdir=dirname(dir));dir.create(stage)
  on.exit(unlink(stage,recursive=TRUE),add=TRUE) # only this invocation\'s unpublished staging directory
  for(i in seq_along(paths)) writeLines(lines[[i]],file.path(stage,basename(paths[i])),useBytes=TRUE)
  sa_need(identical(attr(result,'input_hashes'),setNames(vapply(names(sa_pins),sa_hash,''),names(sa_pins))),
          'Inputs changed during audit; no release published')
  sa_need(file.rename(stage,dir),'Atomic release failed; no existing release replaced')
  invisible(paths)
}
audit_source_defined_cohort <- function(write_outputs=TRUE) {
  result<-sa_build();if(write_outputs)sa_publish(result);result
}
if(sys.nframe()==0L) {
  result<-audit_source_defined_cohort();print(result$summary,row.names=FALSE)
}
