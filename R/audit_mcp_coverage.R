# Stage 1 MCP coverage audit: no factor estimation, weights, ratings or scoring.
mcp_revision <- '1813a1309b7ed7ebf1c7e884b32bf675d00e4edf'
mcp_manifest <- 'data/manifests/mcp-source-files.csv'
mcp_prefix <- 'data/pilot/mcp-stage1-'
mcp_outputs <- c('match-inventory','coverage','field-availability','prototype-sample','audit-summary')
mcp_need <- function(x,msg)if(!isTRUE(x))stop(msg,call.=FALSE)
mcp_sha <- function(p)substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
mcp_blob <- function(p)system2('git',c('hash-object','--',shQuote(p)),stdout=TRUE)
mcp_write <- function(x,p)write.table(x,p,sep=',',row.names=FALSE,quote=TRUE,na='',eol='\n',qmethod='double')
mcp_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE,fileEncoding='UTF-8')
mcp_rights <- function(p) {
 s<-paste(readLines(p,warn=FALSE),collapse='\n')
 mcp_need(grepl('creativecommons.org/licenses/by-nc-sa/4.0/',s,fixed=TRUE)&&grepl('The Tennis Abstract Match Charting Project',s,fixed=TRUE),'Unresolved MCP research-use basis')
 invisible(TRUE)
}
mcp_verify_file <- function(p,bytes,blob,sha='') {
 mcp_need(file.exists(p)&&file.info(p)$size==as.numeric(bytes),'Source size mismatch')
 mcp_need(identical(mcp_blob(p),blob),'Source Git blob mismatch')
 if(nzchar(sha))mcp_need(identical(mcp_sha(p),sha),'Source SHA-256 mismatch')
 invisible(TRUE)
}
mcp_acquire <- function() {
 m<-mcp_read(mcp_manifest);mcp_need(all(m$revision==mcp_revision),'Revision mismatch')
 mcp_rights(m$local_path[m$source_path=='README.md'])
 for(j in seq_len(nrow(m))) {
  f<-m$local_path[j];url<-paste0('https://raw.githubusercontent.com/JeffSackmann/tennis_MatchChartingProject/',mcp_revision,'/',URLencode(m$source_path[j],reserved=TRUE))
  mcp_need(url==m$raw_url[j],'Endpoint mismatch')
  if(file.exists(f))mcp_verify_file(f,m$bytes[j],m$git_blob[j],m$sha256[j]) else {
   tmp<-tempfile('.mcp-source-',tmpdir=dirname(f));on.exit(unlink(tmp),add=TRUE)
   response<-system2('curl',c('--fail','--silent','--show-error','--max-time','180','--max-redirs','0','-w','%{http_code}',shQuote(url),'-o',shQuote(tmp)),stdout=TRUE)
   mcp_need(identical(response,'200'),'Request failed or redirected')
   mcp_verify_file(tmp,m$bytes[j],m$git_blob[j]);mcp_need(file.rename(tmp,f),'Atomic source installation failed')
  }
  if(!nzchar(m$sha256[j])){m$sha256[j]<-mcp_sha(f);m$retrieved_utc[j]<-format(Sys.time(),tz='UTC',usetz=TRUE)}
  m$status[j]<-'VERIFIED'
 }
 tmp<-tempfile('.mcp-manifest-',tmpdir=dirname(mcp_manifest));mcp_write(m,tmp);mcp_need(file.rename(tmp,mcp_manifest),'Manifest installation failed');invisible(m)
}
mcp_source_pins <-
c(README.md = "2c2a5961a2761eea35b4143e9cab1d23200f49d72fc0ced56bb09f5a326e8444",
data_dictionary.txt = "e60154eb0289e4e0e11221e62c60dcfc94e9d6e4d4a889aa065a7c17bf42b238",
`MatchChart 0.3.2.xlsm` = "46e2349eee512296a86170449f6e463a6be91be9261a0c7b6b5d5a25c006729f",
`charting-m-matches.csv` = "d8dce1ad8d12c04efa01da587441b54ece8e8100530660528312244f632efe80",
`charting-w-matches.csv` = "fba52fd6f6fa50190f79a38f366d8841b49bf76d5c4a598deb3e8d78a9796294",
`charting-m-points-to-2009.csv` = "12613c7fc4d7acc6d4577ec33554a4308497a5e18669560688f1a2e00704fc72",
`charting-m-points-2010s.csv` = "2719cdc136b64698f24b360cf4f60302e11add24971c2fdd585e1b729178db8c",
`charting-m-points-2020s.csv` = "2cd43f73e0530a47ea4c02b99dae40177ca6d58a8ccf9189358eb05dffb4be9a",
`charting-w-points-to-2009.csv` = "8fd823230d18d48375c826b7e6260c893a2ecc5918632deb77d819605a5f19ec",
`charting-w-points-2010s.csv` = "2ed2c789966ac60122411867a671df25748e0cab4c841ff5bb7572a7786650a1",
`charting-w-points-2020s.csv` = "611dd93c196de0033f73f83b46df5f827dadcf3a18cde624aa85633de3596f2b"
)
mcp_verify <- function() {
 m<-mcp_read(mcp_manifest)
 mcp_need(identical(mcp_sha(mcp_manifest),'189efcee4ea4a315ae177149e48e3b71a7d6f40301e6f64c264c6b575c967a18'),'Manifest changed')
 mcp_need(identical(mcp_sha('data/raw/reference/mcp-stage1-source-tree.json'),'8c6164fcf5ead9d25c62b177706987d7851185ec321dcf66e5aebbe16ebd1454'),'Tree evidence changed')
 mcp_need(setequal(m$source_path,names(mcp_source_pins))&&all(m$revision==mcp_revision)&all(m$status=='VERIFIED'),'Source scope mismatch')
 for(j in seq_len(nrow(m)))mcp_verify_file(m$local_path[j],m$bytes[j],m$git_blob[j],mcp_source_pins[[m$source_path[j]]])
 mcp_rights(m$local_path[m$source_path=='README.md']);invisible(m)
}
mcp_date_valid <- function(x) {
 d<-suppressWarnings(as.Date(x,'%Y%m%d'));!is.na(d)&grepl('^[0-9]{8}$',x)&format(d,'%Y%m%d')==x
}
mcp_lexical <- function(first,second) {
 # Availability scan only, not the Stage 2 action parser or a performance metric.
 a<-ifelse(nzchar(second),second,first);serve<-'^c*[4560]\\+?'
 shot<-'[fbrsvzopuy lmhijktq]';shot<-gsub(' ','',shot,fixed=TRUE)
 ret<-paste0(serve,'(',shot,')');plus<-paste0(ret,'[0123789+;=-]*(',shot,')')
 data.frame(raw_sequence_present=nzchar(a),outcome_only_or_penalty=a %in% c('P','Q','R','S'),
  unknown_code=grepl('[q0]',a),serve_direction_recorded=grepl('^c*[456]',a),
  return_prefix_present=grepl(ret,a),return_direction_recorded=grepl(paste0(ret,'[+;=-]*[123]'),a),
  return_depth_recorded=grepl(paste0(ret,'[+;=-]*[0123]?[789]'),a),
  plus1_prefix_present=grepl(plus,a),plus1_direction_recorded=grepl(paste0(plus,'[+;=-]*[123]'),a),
  plus1_terminal_winner_candidate=grepl(paste0(plus,'[+;=0123-]*\\*$'),a),
  plus1_terminal_error_candidate=grepl(paste0(plus,'[+;=0123nwdxe!-]*[@#]$'),a),
  serve_terminal_candidate=grepl(paste0(serve,'[*#]$'),a),
  return_terminal_candidate=grepl(paste0(ret,'[+;=0123789nwdxe!-]*[*@#]$'),a),stringsAsFactors=FALSE)
}
mcp_terminal <- function(z,best) {
 # Deliberately withhold tiebreak/nonstandard endings rather than invent format rules.
 if(!best %in% c('3','5')||!nrow(z))return('UNRESOLVED')
 q<-z[nrow(z),];sc<-strsplit(q$Pts,'-',fixed=TRUE)[[1]]
 if(length(sc)!=2||!q$Svr %in% c('1','2')||!q$PtWinner %in% c('1','2'))return('UNRESOLVED')
 winner<-as.integer(q$PtWinner);side<-if(q$Svr==q$PtWinner)1L else 2L
 other<-3-side;won_game<-(sc[side]=='AD'&&sc[other]=='40')||(sc[side]=='40'&&sc[other] %in% c('0','15','30'))
 g<-suppressWarnings(as.integer(c(q$Gm1,q$Gm2)));sets<-suppressWarnings(as.integer(c(q$Set1,q$Set2)))
 if(anyNA(c(g,sets))||!won_game)return('UNRESOLVED')
 g[winner]<-g[winner]+1L
 if(g[winner]>=6&&g[winner]-g[3-winner]>=2&&sets[winner]==as.integer(best)%/%2&&sets[3-winner]<ceiling(as.integer(best)/2))'ORDINARY_TERMINAL_SCORE_PATTERN' else 'UNRESOLVED'
}
mcp_metadata <- function(m,tour) {
 mcp_need(identical(names(m),c('match_id','Player 1','Player 2','Pl 1 hand','Pl 2 hand','Date','Tournament','Round','Time','Court','Surface','Umpire','Best of','Final TB?','Charted by')),'Metadata schema changed')
 names(m)[names(m)=='Player 1']<-'player1';names(m)[names(m)=='Player 2']<-'player2'
 m$tour_file<-tour;m$source_row<-seq_len(nrow(m));m$record_origin<-'METADATA'
 m$year<-ifelse(mcp_date_valid(m$Date),substr(m$Date,1,4),'UNKNOWN')
 m$date_valid<-mcp_date_valid(m$Date);m$id_date_agrees<-substr(m$match_id,1,8)==m$Date
 m$duplicate_id<-duplicated(m$match_id)|duplicated(m$match_id,fromLast=TRUE)
 m$surface_valid<-m$Surface %in% c('Hard','Clay','Grass','Carpet')
 m$identity_valid<-nzchar(m$player1)&nzchar(m$player2)&m$player1!=m$player2&!grepl(' / | & ',paste(m$player1,m$player2))
 event<-trimws(gsub('_',' ',m$Tournament,fixed=TRUE));round<-trimws(m$Round)
 md<-round %in% c('R128','R64','R32','R16','QF','SF','F','RR','BR')
 low<-grepl('(^| )(CH|ITF|W[0-9]+|125|F[0-9]+)( |$)|Junior|NCAA',event,ignore.case=TRUE)
 team<-grepl('Cup|EXH|Classic|Six Kings|Club|Championships',event,ignore.case=TRUE)
 major<-event %in% c('Australian Open','Roland Garros','Wimbledon','US Open')
 m$scope<-ifelse(!md,'NOT_MAIN_DRAW_ROUND_OR_UNKNOWN',ifelse(low,'LOWER_LEVEL_OR_JUNIOR_LABEL',ifelse(major,'MAJOR_MAIN_DRAW_LABEL_SUPPORTED',ifelse(team,'TEAM_EXHIBITION_OR_OTHER_REVIEW','OTHER_MAIN_DRAW_TOUR_LEVEL_UNVERIFIED'))))
 m$event_label<-event
 m$metadata_ok<-m$date_valid&m$id_date_agrees&m$surface_valid&m$identity_valid&!m$duplicate_id&m[['Best of']] %in% c('3','5')
 m$player_a<-vapply(seq_len(nrow(m)),function(j)sort(c(m$player1[j],m$player2[j]),method='radix')[1],'')
 m$player_b<-ifelse(m$player_a==m$player1,m$player2,m$player1)
 m
}
mcp_point_summary <- function(d,file,m) {
 required<-c('match_id','Pt','Set1','Set2','Gm1','Gm2','Pts','Gm#','TbSet','Svr','1st','2nd','Notes','PtWinner')
 mcp_need(identical(names(d),required),'Point schema changed')
 d$point_number<-suppressWarnings(as.integer(d$Pt));key<-paste(d$match_id,d$Pt,sep='|')
 dup<-duplicated(key)|duplicated(key,fromLast=TRUE);lex<-mcp_lexical(d[['1st']],d[['2nd']])
 notes<-grepl('(^|[^a-z])(retired|retirement|ret|walkover|w/o|abandoned|unfinished|incomplete)([^a-z]|$)',tolower(d$Notes))
 groups<-split(seq_len(nrow(d)),d$match_id);rows<-vector('list',length(groups));j<-0L
 for(id in names(groups)) {
  ii<-groups[[id]];z<-d[ii,];z<-z[order(z$point_number,na.last=TRUE),];n<-nrow(z);mm<-m[m$match_id==id,]
  contiguous<-!anyNA(z$point_number)&&identical(z$point_number,seq_len(n))
  start<-all(z[1,c('Set1','Set2','Gm1','Gm2')]=='0')&&z$Pts[1]=='0-0'
  terminal<-if(nrow(mm)==1)mcp_terminal(z,mm[['Best of']]) else 'UNRESOLVED'
  j<-j+1L;rows[[j]]<-data.frame(match_id=id,point_file=file,points=n,duplicate_point_rows=sum(dup[ii]),point_sequence_contiguous=contiguous,starts_at_zero=start,
   bad_point_owner=sum(!z$Svr %in% c('1','2')|!z$PtWinner %in% c('1','2')),status_note_cues=sum(notes[ii]),terminal_evidence=terminal,
   first_serve_nonblank=sum(nzchar(z[['1st']])),second_serve_nonblank=sum(nzchar(z[['2nd']])),as.list(colSums(lex[ii,,drop=FALSE])),stringsAsFactors=FALSE)
 }
 out<-do.call(rbind,rows)
 fields<-data.frame(point_file=file,field=names(d)[names(d)!='point_number'],rows=nrow(d),nonblank=vapply(d[names(d)!='point_number'],function(x)sum(!is.na(x)&nzchar(x)),0L),stringsAsFactors=FALSE)
 list(matches=out,fields=fields,summary=data.frame(point_file=file,rows=nrow(d),unique_matches=length(groups),orphan_point_rows=sum(!d$match_id %in% m$match_id),duplicate_point_rows=sum(dup),duplicate_entire_rows=sum(duplicated(d)),as.list(colSums(lex)),stringsAsFactors=FALSE))
}
mcp_sample <- function(x) {
 # A proposed parser-validation sample, not a fitted or analytical cohort.
 use<-x$metadata_ok&x$scope=='MAJOR_MAIN_DRAW_LABEL_SUPPORTED'&x$point_files==1&x$duplicate_point_rows==0&x$point_sequence_contiguous&x$starts_at_zero&x$bad_point_owner==0&x$status_note_cues==0&x$terminal_evidence=='ORDINARY_TERMINAL_SCORE_PATTERN'
 use[is.na(use)]<-FALSE;y<-x[use,]
 y$era<-ifelse(y$year<'2010','PRE_2010',ifelse(y$year<'2020','2010S',ifelse(y$year<='2025','2020_2025','2026_EXPOSED_AUDIT')))
 # Hash only metadata/date/neutral names; never performance, winner or a fitted value.
 hash<-function(s){f<-tempfile();writeBin(charToRaw(enc2utf8(s)),f);h<-mcp_sha(f);unlink(f);h}
 y$sampling_key<-paste(y$tour_file,y$Date,y$event_label,y$Round,y$player_a,y$player_b,sep='|')
 y$sampling_hash<-vapply(y$sampling_key,hash,'')
 y<-y[order(y$tour_file,y$Surface,y$era,y$sampling_hash,method='radix'),]
 keep<-unlist(lapply(split(seq_len(nrow(y)),paste(y$tour_file,y$Surface,y$era)),head,2L),use.names=FALSE)
 y<-y[keep,c('match_id','tour_file','year','event_label','Round','Surface','Date','player_a','player_b','era','sampling_hash')]
 y$purpose<-'PROPOSED_PARSER_VALIDATION_NOT_FACTOR_ESTIMATION';rownames(y)<-NULL;y
}
mcp_build <- function() {
 manifest<-mcp_verify();inventories<-list();fields<-list();files<-list();orphan<-list()
 for(g in c('m','w')) {
  tour<-if(g=='m')'ATP' else 'WTA';m<-mcp_metadata(mcp_read(paste0('data/raw/reference/mcp-stage1-charting-',g,'-matches.csv')),tour)
  ps<-list()
  for(file in paste0('charting-',g,'-points-',c('to-2009','2010s','2020s'),'.csv')) {
   p<-manifest$local_path[match(file,manifest$source_path)];z<-mcp_point_summary(mcp_read(p),file,m)
   ps[[file]]<-z$matches;fields[[file]]<-z$fields;files[[file]]<-z$summary
  }
  ps<-do.call(rbind,ps);counts<-table(ps$match_id);m$point_files<-as.integer(counts[match(m$match_id,names(counts))]);m$point_files[is.na(m$point_files)]<-0L
  j<-match(m$match_id,ps$match_id);m<-cbind(m,ps[j,setdiff(names(ps),'match_id'),drop=FALSE]);rownames(m)<-NULL
  m$linkage<-'UNIQUE_MATCH_LINK';m$linkage[m$point_files==0]<-'NO_POINT_RECORD';m$linkage[m$point_files>1]<-'MULTIPLE_POINT_FILES';m$linkage[m$duplicate_id]<-'DUPLICATE_METADATA_ID'
  # Single-file requirement prevents silently assigning cross-shard duplicated records.
  m$completion<-'UNRESOLVED';pass<-m$metadata_ok&m$point_files==1&m$duplicate_point_rows==0&m$point_sequence_contiguous&m$starts_at_zero&m$bad_point_owner==0&m$status_note_cues==0&m$terminal_evidence=='ORDINARY_TERMINAL_SCORE_PATTERN';pass[is.na(pass)]<-FALSE;m$completion[pass]<-'SOURCE_TERMINAL_PATTERN_ONLY_NOT_OFFICIAL_COMPLETION'
  inventories[[g]]<-m
  q<-ps[!ps$match_id %in% m$match_id,];q$tour_file<-rep(tour,nrow(q));orphan[[g]]<-q
 }
 x<-do.call(rbind,inventories);rownames(x)<-NULL
 groups<-list(overall=rep('ALL',nrow(x)),tour=x$tour_file,year=paste(x$tour_file,x$year,sep='|'),event=paste(x$tour_file,x$event_label,sep='|'),surface=paste(x$tour_file,x$Surface,sep='|'),cell=paste(x$tour_file,x$year,x$event_label,x$Surface,sep='|'))
 coverage<-list()
 for(level in names(groups))for(key in sort(unique(groups[[level]]),method='radix')) {
  z<-x[groups[[level]]==key,];coverage[[length(coverage)+1L]]<-data.frame(level=level,group=key,metadata_rows=nrow(z),unique_match_ids=length(unique(z$match_id)),unique_player_names=length(unique(c(z$player1,z$player2))),metadata_ok=sum(z$metadata_ok),major_main_draw=sum(z$scope=='MAJOR_MAIN_DRAW_LABEL_SUPPORTED'),other_main_draw_unverified=sum(z$scope=='OTHER_MAIN_DRAW_TOUR_LEVEL_UNVERIFIED'),linked_unique=sum(z$linkage=='UNIQUE_MATCH_LINK'),terminal_pattern=sum(z$completion=='SOURCE_TERMINAL_PATTERN_ONLY_NOT_OFFICIAL_COMPLETION'),stringsAsFactors=FALSE)
 }
 coverage<-do.call(rbind,coverage);sample<-mcp_sample(x);summary<-do.call(rbind,files)
 # Point-only IDs are retained explicitly in the inventory, with missing metadata.
 for(q in orphan)if(nrow(q)){a<-x[rep(1,nrow(q)),];a[]<-lapply(a,function(v)rep(NA,nrow(q)));for(k in intersect(names(a),names(q)))a[[k]]<-q[[k]];a$record_origin<-'POINTS_ONLY';a$linkage<-'ORPHAN_POINT_MATCH';a$metadata_ok<-FALSE;a$scope<-'METADATA_MISSING';a$completion<-'UNRESOLVED';x<-rbind(x,a)}
 r<-setNames(list(x,coverage,do.call(rbind,fields),sample,summary),mcp_outputs)
 for(k in names(r)){r[[k]]$revision<-mcp_revision;r[[k]]$release<-'MCP_STAGE1_1.0.0';r[[k]]$claim<-'SOURCE_DEFINED_COVERAGE;PROPOSED_ACTION_DOMAINS_NOT_VALIDATED_FACTORS';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
mcp_install <- function(r) {
 paths<-paste0(mcp_prefix,names(r),'.csv');mcp_need(identical(names(r),mcp_outputs),'Output scope mismatch')
 got<-system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE);mcp_need(setequal(got,paths),'Output locations must already be ignored')
 stage<-vapply(paths,function(p)tempfile('.mcp-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(j in seq_along(r))mcp_write(r[[j]],stage[j]);mcp_verify()
 for(j in seq_along(paths))if(file.exists(paths[j]))mcp_need(mcp_sha(paths[j])==mcp_sha(stage[j]),'Existing output differs; preserve release')
 # Per-file atomic rename; audit-summary installed last. Readers verify all outputs.
 for(j in seq_along(paths))if(!file.exists(paths[j]))mcp_need(file.rename(stage[j],paths[j]),'Output install failed')
 invisible(r)
}
audit_mcp_coverage <- function(write_outputs=TRUE){r<-mcp_build();if(write_outputs)mcp_install(r);r}
if(sys.nframe()==0L){
 mcp_need(length(commandArgs(trailingOnly=TRUE))==0L,'Offline audit takes no arguments')
 r<-audit_mcp_coverage()
 print(r[[2]][r[[2]]$level=='tour',c('group','metadata_rows','major_main_draw','linked_unique','terminal_pattern')])
 print(r[[5]][,c('point_file','rows','unique_matches','orphan_point_rows','duplicate_point_rows','plus1_prefix_present')])
}
