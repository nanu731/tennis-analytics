# Focused sample parser tests; never execute the population coverage runner.
source('R/parse_mcp_actions.R')
checks<-0L
check<-function(x,msg){checks<<-checks+1L;if(!isTRUE(x))stop(msg,call.=FALSE)}
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/parse_mcp_actions.R','R/test_mcp_actions.R','docs/mcp-notation-resolution.md','data/manifests/mcp-notation-evidence.csv','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
oldfiles<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
oldfiles<-setdiff(oldfiles,allowed);oldfiles<-oldfiles[!grepl('/mcp-stage2-v2-',oldfiles)]
oldpins<-vapply(oldfiles,mcp_sha,'');action_verify();check(length(action_stage1_pins)==5L,'All Stage 1 output pins')
# Independent normative expectations are transcribed from the pinned Instructions.
p<-'data/raw/reference/mcp-stage1-MatchChart_0.3.2.xlsm'
ss<-xml2::read_xml(unz(p,'xl/sharedStrings.xml'));txt<-vapply(xml2::xml_find_all(ss,'//*[local-name()="si"]'),function(z)paste(xml2::xml_text(xml2::xml_find_all(z,'.//*[local-name()="t"]')),collapse=''),'')
for(term in c('6f#','4+b27v1*','cc4e','5f2f1f1v2n@','6b29C','rally-ending error','point penalty','time violation','Stop volleys'))check(any(grepl(term,txt,fixed=TRUE)),paste('Pinned notation authority',term))
check(mcp_sha('data/raw/reference/mcp-notation-MatchChart_0.3.2.xlsm')==mcp_sha(p),'Official current workbook is identical to pinned authority')
x<-xml2::read_xml(unz(p,'xl/worksheets/sheet1.xml'))
formula<-xml2::xml_text(xml2::xml_find_first(x,'//*[local-name()="c"][@r="AN18"]/*[local-name()="f"]'))
check(grepl('RIGHT(AC18,1)="C"',formula,fixed=TRUE)&&grepl('MOD(AM18,2)=0',formula,fixed=TRUE),'Challenge winner parity explicitly specified by pinned workbook')
comment<-jsonlite::fromJSON('data/raw/reference/mcp-notation-issue5-comments.json')
check(comment$user$login=='JeffSackmann'&&comment$id==265687286&&grepl('only used within the rally',comment$body,fixed=TRUE),'Attributed maintainer conflict evidence')
fixture<-data.frame(first=c('6*','6#','6f#','6f2d@','6f37*','4+b27v1*','4b28o2n@','5f2f1f1v2n@','4f27b1f3*','4f27b1#','4n','6n','cc4e','4+w','V','4z^2*','4f;1b+3u-1o=2*','4d;','4n'),
 second=c('','','','','','','','','','','5d','4f27b1*','4f1*','5#','4f1*','','','5b3w@','4b3n;@'),
 winner=c(1,1,1,1,2,1,2,2,2,2,2,1,2,1,2,2,1,1,1),
 plus=c(FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE),stringsAsFactors=FALSE)
for(j in setdiff(seq_len(nrow(fixture)),18L)) {
 f<-fixture[j,];a<-action_point(f$first,f$second,1L)
 check(!length(a$issues)&&a$normal,paste('Documented grammar',j))
 check(a$winner==f$winner,paste('Independent terminal owner',j))
 check(a$plus1_validated==f$plus,paste('Plus-one opportunity',j))
 b<-action_point(f$first,f$second,2L)
 check(identical(b$actions$actor,3L-a$actions$actor)&&b$winner==3L-a$winner&&b$status==a$status,paste('Player relabeling',j))
 for(field in c('1st','2nd')){raw<-if(field=='1st')f$first else f$second;z<-a$actions[a$actions$sequence_field==field,];check(paste(z$raw_token,collapse='')==raw,paste('Full byte-span retention',j,field))}
}
a<-action_point('cc4e','4f1*',1L);check(sum(a$actions$kind=='LET')==2&&all(a$actions$is_void[a$actions$kind=='LET']),'Repeated lets are void events')
a<-action_point('4+b27v1*','',1L);check(a$actions$approach[1]&&a$actions$domain[3]=='Rally'&&a$actions$shot_type[3]=='forehand_volley','Serve-and-volley ownership')
a<-action_point('4b28o2n@','',1L);check(a$actions$is_plus1[3]&&a$actions$terminal[3]=='UNFORCED_ERROR'&&a$actions$shot_type[3]=='overhead','Attempted overhead +1 error is counted')
a<-action_point('V','4f1*',1L);check(a$actions$domain[1]=='ADMIN'&&sum(a$actions$kind=='SERVE')==1,'First-serve forfeit is not a physical first serve')
for(code in names(action_shots)) {
 a<-action_point(paste0('4f27',code,'1*'),'',1L)
 check(!length(a$issues)&&a$actions$shot_code[3]==code&&a$actions$domain[3]=='Rally',paste('Shot-type ownership',code))
}
for(code in c('n','w','d','x','g','e','!')) {
 a<-action_point(paste0('6',code),paste0('4',code),1L)
 check(!length(a$issues)&&a$terminal=='DOUBLE_FAULT'&&a$winner==2L,paste('Fault family',code))
}
for(code in c('R','S','P','Q')) {
 a<-action_point(code,'',1L)
 check(!length(a$issues)&&a$winner==if(code%in%c('R','P'))2L else 1L,paste('Special outcome',code))
 check(a$plus_state==if(code%in%c('R','S'))'UNKNOWN' else 'KNOWN_ABSENT',paste('Missing versus administrative absence',code))
}
a<-action_point('0b00q0n@','',1L);check(a$status=='PARSED_WITH_EXPLICIT_UNKNOWNS'&&a$actions$direction_status[1]=='SOURCE_UNKNOWN'&&a$actions$shot_type[3]=='UNKNOWN','Unknown fields stay explicit')
a<-action_point('4f0b1*','',1L);check(a$actions$depth_status[2]=='AMBIGUOUS_SOURCE_ZERO'&&a$actions$return_depth[2]=='','Single return zero is not guessed')
unsupported<-c('6f2Z','4f1b38*','4f237b1*','6f2@','4f^2*','4v^^2*','4f-=1*','4f1n*','4f1n@b2*','4f1b2','4n ','4b1+f1*','4b27f!2n#','4f27h^1*','4^f1*','6b29Cz1*','')
for(raw in unsupported){a<-action_point(raw,'',1L);check(length(a$issues)>0&&!a$plus1_validated,paste('Unsupported withheld',raw));check(paste(a$actions$raw_token,collapse='')==raw,paste('Unsupported raw retained',raw))}
for(raw in c('6C','6b29C','4b28f3f3b3b3b3b2C'))for(sv in 1:2) {
 a<-action_point(raw,'',sv);n<-sum(a$actions$kind=='STROKE');w<-if(n%%2==0)sv else 3L-sv
 check(a$normal&&a$winner==w&&tail(a$actions$actor,1)==3L-w,'Supported incorrect-challenge ownership and winner')
 check(tail(a$actions$domain,1)=='ADMIN'&&!tail(a$actions$is_plus1,1),'Challenge is not a stroke or an invented +1 attempt')
 check(paste(a$actions$raw_token,collapse='')==raw,'Challenge spans retained')
 check(a$plus_state==if(n>=2)'KNOWN_PRESENT' else 'KNOWN_ABSENT','Challenge opportunity presence/absence')
}
a<-action_point('5f38b18f19f17f39b29C','',1L);check(!a$normal&&'INVALID_RALLY_DIGITS'%in%a$issues,'Challenge does not rescue undocumented depth')
for(raw in c('4d;','4;d','4;n','4;')) {
 a<-action_point(raw,'5b3w@',1L)
 check('SERVE_NET_CORD_AUTHORITY_CONFLICT'%in%a$issues&&!a$normal,'Conflicting serve annotation withheld without repair')
 check(paste(a$actions$raw_token[a$actions$sequence_field=='1st'],collapse='')==raw,'Conflict raw spans retained')
}
a<-action_point('6n','',1L);check('MISSING_SECOND_SERVE'%in%a$issues&&a$plus_state=='UNKNOWN','Missing second serve not double fault')
a<-action_point('6*','4f1*',1L);check('SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT'%in%a$issues,'Conflicting serve columns')
check(fails(action_point('6*','',3L)),'Invalid server fails')
# Independent score fixtures: twelve love games, then a separate tiebreak fixture.
score_fixture<-function(tiebreak=FALSE) {
 rows<-list();pn<-0L;gn<-0L
 winners<-if(tiebreak)c(rep(1L,6),rep(c(1L,2L),6)) else rep(1L,12)
 sets<-c(0L,0L);games<-c(0L,0L)
 for(g in seq_along(winners)) {
  sv<-if(g%%2L==1L)1L else 2L;w<-winners[g]
  for(k in 0:3){pn<-pn+1L;sc<-c('0','15','30','40')[k+1L];rows[[pn]]<-data.frame(Pt=as.character(pn),Set1=as.character(sets[1]),Set2=as.character(sets[2]),Gm1=as.character(games[1]),Gm2=as.character(games[2]),Pts=if(sv==w)paste(sc,'0',sep='-') else paste('0',sc,sep='-'),Svr=as.character(sv),PtWinner=as.character(w),check.names=FALSE);rows[[pn]][['Gm#']]<-as.character(g)}
  games[w]<-games[w]+1L
  if(g==6L||(!tiebreak&&g==12L)){sets[1]<-sets[1]+1L;games<-c(0L,0L)}
 }
 if(tiebreak)for(k in 0:6){pn<-pn+1L;sv<-c(1L,2L,2L,1L,1L,2L,2L)[k+1L];rows[[pn]]<-data.frame(Pt=as.character(pn),Set1='1',Set2='0',Gm1='6',Gm2='6',Pts=if(sv==1L)paste(k,'0',sep='-') else paste('0',k,sep='-'),Svr=as.character(sv),PtWinner='1',check.names=FALSE);rows[[pn]][['Gm#']]<-'19'}
 do.call(rbind,rows)
}
d<-score_fixture();sc<-action_score_replay(d,'3','1');check(sc$complete&&all(sc$points$score_status=='PASS')&&identical(sc$sets,c(2L,0L))&&sc$games==12,'Independent ordinary score replay')
d<-score_fixture(TRUE);sc<-action_score_replay(d,'3','1');check(sc$complete&&sc$tiebreaks==1&&sc$games==19,'Tiebreak score and service rotation')
for(format in c('0','A','T','W','V','S')){sc<-action_score_replay(score_fixture(),'3',format);check(sc$complete,paste('Ordinary straight-set fixture',format))}
check(all(action_score_replay(d,'3','N')$points$score_status=='UNSUPPORTED_FORMAT'),'Unsupported format explicit')
e<-d;e$Svr[1]<-'2';check(action_score_replay(e,'3','1')$points$score_status[1]=='CONFLICT','Server mismatch independent')
e<-d;e$PtWinner[1]<-'2';check(any(action_score_replay(e,'3','1')$points$score_status=='CONFLICT'),'Recorded outcome perturbation detected by score replay')
e<-rbind(d,d[1,]);check(grepl('POINT_AFTER_MATCH_TERMINAL',tail(action_score_replay(e,'3','1')$points$score_reasons,1),fixed=TRUE),'Points after termination detected')
cat('Notation, ownership and score fixtures passed; auditing frozen sample.\n')
input<-action_load_sample();r<-action_build(input);action_install(r)
a<-r$actions;p<-r[['point-reconciliation']];mr<-r[['match-reconciliation']];sm<-r$summary
check(nrow(p)==7333&&!anyDuplicated(paste(p$match_id,p$Pt))&&length(unique(p$match_id))==44,'Exact frozen sample and point totals')
check(sum(p$tour_file=='ATP')==4092&&sum(p$tour_file=='WTA')==3241,'Tour point totals')
check(!anyDuplicated(a$action_id)&&all(a$domain%in%c('Serve','Return','Rally','ADMIN','UNRESOLVED')),'Unique ownership ledger')
check(all(mr$point_total_agrees)&&all(mr$chart_score_complete)&&all(p$score_status=='PASS'),'Every match and point independently reconciles scores')
check(all(p$terminal_agrees[!is.na(p$inferred_winner)])&&sum(p$parse_status=='TERMINAL_OUTCOME_CONFLICT')==0,'Decoded terminal outcomes agree where inferable')
check(all(a$actor[a$domain%in%c('Serve','Return','Rally')]%in%c(1L,2L)),'Owned actions have known source players')
check(all(a$actor[a$domain=='Serve']==a$server[a$domain=='Serve'])&&all(a$actor[a$domain=='Return']==a$receiver[a$domain=='Return']),'Server/receiver ownership')
check(all(a$domain[a$is_plus1]=='Rally')&&all(a$actor[a$is_plus1]==a$server[a$is_plus1]),'All +1 attempts belong to server/Rally')
check(all(p$plus1_attempts<=1L)&&all(p$plus1_observation%in%c('KNOWN_PRESENT','KNOWN_ABSENT','UNKNOWN')),'Opportunity trichotomy and uniqueness')
check(sum(p$plus1_observation=='KNOWN_PRESENT')+sum(p$plus1_observation=='KNOWN_ABSENT')+sum(p$plus1_observation=='UNKNOWN')==nrow(p),'All service points in +1 accounting')
check(all(!p$plus1_validated[p$parse_status%in%c('UNSUPPORTED_OR_UNRESOLVED','OUTCOME_ONLY_MISSING_ACTIONS')]),'Unsupported/missing points not validated')
# Independent character-count reconstruction on supported tennis sequences includes error attempts.
ii<-which(p$tennis_sequence_validated);raw<-ifelse(nzchar(p$raw_second[ii]),p$raw_second[ii],p$raw_first[ii]);letters<-vapply(regmatches(raw,gregexpr('[fbrsvzopuylmhijktq]',raw)),length,0L)
check(all(p$return_actions[ii]==as.integer(letters>=1))&&all(p$rally_actions[ii]==pmax(letters-1L,0L)),'Independent stroke-letter totals include errors')
check(all(p$plus1_validated[ii]==(letters>=2L)),'Independent +1 reconstruction does not use rallyCount')
check(sum(p$plus1_error&p$plus1_validated)>0L,'Attempted +1 errors retained')
check(sum(sm$points[sm$tour_file%in%c('ATP','WTA')])==sm$points[1]&&sum(sm$action_rows[sm$tour_file%in%c('ATP','WTA')])==nrow(a),'Summary accounting')
check(all(sm$parsed+sm$parsed_explicit_unknown+sm$outcome_only+sm$administrative+sm$unsupported_or_unresolved+sm$terminal_conflicts==sm$points),'Every point has one disposition')
baseline<-read.csv('data/pilot/mcp-stage2-point-reconciliation.csv',stringsAsFactors=FALSE)
check(identical(paste(p$match_id,p$Pt),paste(baseline$match_id,baseline$Pt)),'Original point IDs and ordering unchanged')
check(identical(p$raw_first,baseline$raw_first)&&identical(p$raw_second,baseline$raw_second)&&identical(p$raw_notes,baseline$raw_notes),'All original sequence and Notes values unchanged')
gain<-p$tennis_sequence_validated&!baseline$tennis_sequence_validated
loss<-!p$tennis_sequence_validated&baseline$tennis_sequence_validated
check(sum(gain)==2&&all(p$terminal[gain]=='INCORRECT_CHALLENGE'),'Only supported challenge cases gain validation')
check(sum(loss)==9&&all(p$issues[loss]=='SERVE_NET_CORD_AUTHORITY_CONFLICT'),'Only authority conflicts lose validation')
check(sum(grepl('SERVE_NET_CORD_AUTHORITY_CONFLICT',p$issues,fixed=TRUE))==15,'All fifteen observed serve annotation conflicts recorded')
check(all(p$issues[grepl('INVALID_RALLY_DIGITS',baseline$issues,fixed=TRUE)]!='')&&sum(grepl('INVALID_RALLY_DIGITS',p$issues,fixed=TRUE))==946,'No undocumented rally-depth interpretation')
check(all(p$score_status==baseline$score_status)&&all(p$recorded_winner==baseline$recorded_winner)&&all(p$server==baseline$server),'Independent source outcomes and score/server results unchanged')
check(sum(p$plus1_validated)==3986&&sum(p$plus1_error&p$plus1_validated)==724&&sum(p$plus1_observation=='KNOWN_ABSENT')==2251&&sum(p$plus1_observation=='UNKNOWN')==113,'Measured +1 deltas and unknown accounting')
# Every raw sequence is recoverable from its ordered token spans, even on failures.
seqkeys<-paste(a$match_id,a$Pt,a$sequence_field,sep='|');combined<-vapply(split(seq_len(nrow(a)),seqkeys),function(ii)paste(a$raw_token[ii],collapse=''),'')
check(all(combined[paste(p$match_id,p$Pt,'1st',sep='|')]==p$raw_first),'All first-sequence bytes retained')
second<-nzchar(p$raw_second);check(all(combined[paste(p$match_id[second],p$Pt[second],'2nd',sep='|')]==p$raw_second[second]),'All second-sequence bytes retained')
# A small full-match permutation check exercises normalization without parsing outside the sample.
one<-input;id<-input$sample$match_id[1];one$sample<-one$sample[1,,drop=FALSE];one$metadata<-one$metadata[1,,drop=FALSE];one$points<-one$points[one$points$match_id==id,]
r1<-action_build(one);one$points<-one$points[nrow(one$points):1,];r2<-action_build(one)
check(identical(r1,r2),'Point-row permutation invariance')
paths<-paste0(action_prefix,action_outputs,'.csv');pins<-vapply(paths,mcp_sha,'')
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Ignored outputs')
check(setequal(list.files('data/pilot',pattern='^mcp-stage2-v2-',full.names=TRUE),paths),'Exactly six new output files')
cat('Sample reconciliation passed; checking independent rerun and release preservation.\n')
r2<-action_build(action_load_sample())
for(j in seq_along(r2)){f<-tempfile();mcp_write(r2[[j]],f);check(mcp_sha(f)==pins[j],paste('Byte-identical independent output',names(r2)[j]));unlink(f)}
action_install(r2);check(identical(pins,vapply(paths,mcp_sha,'')),'Idempotent install')
bad<-r2;bad$actions$raw_token[1]<-'DO_NOT_INSTALL';check(fails(action_install(bad)),'Differing existing release refused');check(identical(pins,vapply(paths,mcp_sha,'')),'Rejected installation preserves bundle')
check(!length(list.files('data/pilot',pattern='^\\.mcp-actions-',all.files=TRUE)),'No staging residue')
check(identical(oldpins,vapply(oldfiles,mcp_sha,'')),'Historical artifacts unchanged')
changed<-system2('git',c('diff','HEAD','--name-only'),stdout=TRUE);untracked<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
check(all(c(changed,untracked)%in%allowed),'Tracked scope')
cat(sprintf('PASS: %d focused checks; %d preserved historical files; six independent byte-identical outputs.\n',checks,length(oldfiles)))
