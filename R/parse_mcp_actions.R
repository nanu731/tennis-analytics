# MCP_STAGE2_1.1.0: evidence-supported challenge handling; no source repair.
source('R/audit_mcp_coverage.R')
action_prefix <- 'data/pilot/mcp-stage2-v2-'
action_outputs <- c('actions','point-reconciliation','match-reconciliation',
                    'reason-summary','decoded-examples','summary')
action_evidence_manifest_pin <- '8ddb4f71b0b44a1dc0f6717a10e31e26ec4670a4ee36700ec17a0818e5a41efa'
action_stage2_pins <- c(
 'actions'='958843a35eea2045823e26a3638426ca4006e08cefaa6211aea75af7382fb711',
 'point-reconciliation'='7f14c2f636a316f2cf6850b1d4c4f970d65b8538c26a7ec0fce78d3fe80625ac',
 'match-reconciliation'='3156b29c912c5e0b8faa16ca6bf6dd3b519a2c75764d2b907c54bc34206d1ce2',
 'reason-summary'='21382417b2e847dc169961c823c5e2bc0e95533a49dd4f4667d1abeb421567fb',
 'decoded-examples'='6d414aa76c76b930af0593c0bdd9883769df7e319e449c60dbc73ed6b9eaac19',
 'summary'='75f1aa452c24a85109c01af5ac24d88a3322533c5c4dbc72f1fc805ae7cf4b16')
action_stage1_pins <- c(
 'match-inventory'='aa06330bf214a18fbcb35117eee51a01adb592efaab0b4cbc36e59dad603ef04',
 'coverage'='9607b52b628b970cfd1b630ce56a0bd10c3e4648100ecca06894dce279190873',
 'field-availability'='eeb948809ad4876ee760449cc1cd4db0d24478fde9b3646bfd4385a9630853e1',
 'prototype-sample'='dffb33696c7b758be526fb180ed2f79ed527ea2b4ac4f962e89e139d6d08aa88',
 'audit-summary'='08200cce71656b4527e035c3427648eadb758dc7b9ab63a5870b35b90e670245')
action_verify <- function() {
 m <- mcp_verify()
 evidence <- mcp_read('data/manifests/mcp-notation-evidence.csv')
 mcp_need(mcp_sha('data/manifests/mcp-notation-evidence.csv')==action_evidence_manifest_pin,'Notation evidence manifest changed')
 for(j in seq_len(nrow(evidence))) {
  mcp_need(mcp_sha(evidence$path[j])==evidence$sha256[j]&&file.info(evidence$path[j])$size==as.numeric(evidence$bytes[j]),'Notation evidence changed')
 }
 for(k in names(action_stage2_pins))
  mcp_need(mcp_sha(paste0('data/pilot/mcp-stage2-',k,'.csv'))==action_stage2_pins[[k]],'Stage 2 original release changed')
 for(k in names(action_stage1_pins))
  mcp_need(mcp_sha(paste0(mcp_prefix,k,'.csv'))==action_stage1_pins[[k]],'Stage 1 release changed')
 s <- mcp_read(paste0(mcp_prefix,'prototype-sample.csv'))
 mcp_need(nrow(s)==44L&&!anyDuplicated(s$match_id),'Frozen sample mismatch')
 invisible(m)
}
action_shots <- c(f='forehand_groundstroke',b='backhand_groundstroke',
 r='forehand_slice',s='backhand_slice',v='forehand_volley',z='backhand_volley',
 o='overhead',p='backhand_overhead',u='forehand_drop',y='backhand_drop',
 l='forehand_lob',m='backhand_lob',h='forehand_half_volley',i='backhand_half_volley',
 j='forehand_swing_volley',k='backhand_swing_volley',t='trick',q='UNKNOWN')
action_row <- function(...) {
 a <- list(sequence_field='',serve_number=NA_integer_,char_start=NA_integer_,
 char_end=NA_integer_,raw_token='',kind='',domain='UNRESOLVED',actor=NA_integer_,
 in_play_shot=NA_integer_,shot_code='',shot_type='',direction='',
 direction_status='NOT_RECORDED',return_depth='',depth_status='NOT_RECORDED',
 approach=FALSE,position='NOT_RECORDED',net_cord=FALSE,drop_volley=FALSE,
 is_void=FALSE,is_plus1=FALSE,terminal='',error_code='',unknowns='',
 observation='OBSERVED_ACTION')
 v <- list(...);a[names(v)] <- v
 as.data.frame(a,stringsAsFactors=FALSE)
}
action_sequence <- function(raw,field,number,server) {
 # Tokenize left to right; an unsupported suffix is retained as one explicit row.
 chars <- strsplit(raw,'',fixed=TRUE)[[1]];n <- length(chars);i <- 1L
 rows <- list();issues <- character();unknown <- character();kind <- 'UNRESOLVED'
 terminal_winner <- NA_integer_;terminal <- '';shot <- 1L
 add <- function(a){a$sequence_field<-field;a$serve_number<-number;rows[[length(rows)+1L]]<<-a}
 fail <- function(reason,start=i){
  issues<<-unique(c(issues,reason))
  if(start<=n)add(action_row(char_start=start,char_end=n,
   raw_token=substr(raw,start,n),kind='UNSUPPORTED_SUFFIX',observation='UNSUPPORTED_SUFFIX'))
  i<<-n+1L
 }
 finish <- function(){
  if(!length(rows))add(action_row(kind='MISSING_SEQUENCE',observation='MISSING_OBSERVATION'))
  out<-do.call(rbind,rows);out$unknowns<-ifelse(nzchar(out$unknowns),out$unknowns,'')
  list(actions=out,issues=issues,unknowns=unique(unknown),kind=kind,
       terminal=terminal,winner=terminal_winner)
 }
 if(!n){issues<-'MISSING_SEQUENCE';return(finish())}
 if(raw %in% c('R','S','P','Q')) {
  kind<-if(raw %in% c('R','S'))'OUTCOME_ONLY' else 'POINT_PENALTY'
  terminal<-kind;terminal_winner<-if(raw %in% c('S','Q'))server else 3L-server
  add(action_row(char_start=1L,char_end=1L,raw_token=raw,kind=kind,
   domain=if(kind=='POINT_PENALTY')'ADMIN' else 'UNRESOLVED',
   actor=if(raw=='P')server else if(raw=='Q')3L-server else NA_integer_,
   terminal=kind,observation=if(kind=='OUTCOME_ONLY')'MISSING_OBSERVATION' else 'ADMINISTRATIVE'))
  return(finish())
 }
 # Leading lets are recorded void serves; they do not increment the rally ordinal.
 while(i<=n&&chars[i]=='c') {
  add(action_row(char_start=i,char_end=i,raw_token='c',kind='LET',domain='Serve',
    actor=server,is_void=TRUE,observation='OBSERVED_VOID_LET'));i<-i+1L
 }
 if(i>n){issues<-'LETS_WITHOUT_SERVE';return(finish())}
 if(chars[i]=='V') {
  start<-i;i<-i+1L;kind<-'FIRST_SERVE_FORFEIT'
  add(action_row(char_start=start,char_end=start,raw_token='V',kind=kind,
    domain='ADMIN',actor=server,observation='ADMINISTRATIVE'))
  if(number!=1L)issues<-c(issues,'FORFEIT_NOT_FIRST_SERVE')
  if(i<=n)fail('TRAILING_FORFEIT_NOTATION')
  return(finish())
 }
 if(!chars[i]%in%c('0','4','5','6')){fail('UNSUPPORTED_SERVE_START');return(finish())}
 start<-i;direction<-chars[i];i<-i+1L;flags<-character()
 while(i<=n&&chars[i]%in%c('+',';')){flags<-c(flags,chars[i]);i<-i+1L}
 if(anyDuplicated(flags))issues<-c(issues,'DUPLICATE_SERVE_MODIFIER')
 a<-action_row(char_start=start,kind='SERVE',domain='Serve',actor=server,
  in_play_shot=1L,direction=if(direction=='0')'' else direction,
  direction_status=if(direction=='0')'SOURCE_UNKNOWN' else 'RECORDED',
  approach='+'%in%flags,net_cord=';'%in%flags)
 if(direction=='0'){a$unknowns<-'UNKNOWN_SERVE_DIRECTION';unknown<-c(unknown,a$unknowns)}
 if(i<=n&&chars[i]%in%c('n','w','d','x','g','e','!')) {
  a$kind<-'SERVE_FAULT';a$in_play_shot<-NA_integer_;a$error_code<-chars[i]
  if(chars[i]=='e'){a$unknowns<-paste(c(a$unknowns,'UNKNOWN_FAULT_TYPE')[nzchar(c(a$unknowns,'UNKNOWN_FAULT_TYPE'))],collapse=';');unknown<-c(unknown,'UNKNOWN_FAULT_TYPE')}
  i<-i+1L;kind<-'FAULT'
  # The instructions permit a net-cord annotation on any shot, including a fault.
  if(i<=n&&chars[i]==';'){if(a$net_cord)issues<-c(issues,'DUPLICATE_SERVE_MODIFIER');a$net_cord<-TRUE;i<-i+1L}
 } else if(i<=n&&chars[i]%in%c('*','#')) {
  terminal<-if(chars[i]=='*')'ACE' else 'UNRETURNABLE';a$terminal<-terminal
  terminal_winner<-server;kind<-'TERMINAL';i<-i+1L
 } else kind<-'IN_PLAY'
 a$char_end<-i-1L;a$raw_token<-substr(raw,start,i-1L);add(a)
 # E04 (maintainer, 2016) restricts semicolons to rallies, unlike the broader
 # pinned Instructions A196. Preserve the annotation but withhold this conflict.
 if(a$net_cord)issues<-c(issues,'SERVE_NET_CORD_AUTHORITY_CONFLICT')
 if(kind %in% c('FAULT','TERMINAL')) {
  if(i<=n)fail('TRAILING_SERVE_TERMINAL_OR_FAULT')
  return(finish())
 }
 while(i<=n) {
  if(chars[i]=='C') {
   # Pinned Instructions A213:A216 and sheet1 AN18: the last hitter wins
   # after the opponent incorrectly stops play. C is administrative, not a stroke.
   last_actor<-if(shot%%2L==1L)server else 3L-server
   add(action_row(char_start=i,char_end=i,raw_token='C',kind='INCORRECT_CHALLENGE',
    domain='ADMIN',actor=3L-last_actor,terminal='INCORRECT_CHALLENGE',observation='ADMINISTRATIVE'))
   terminal<-'INCORRECT_CHALLENGE';terminal_winner<-last_actor
   i<-i+1L;if(i<=n)fail('TRAILING_CHALLENGE_NOTATION');break
  }
  if(!chars[i]%in%names(action_shots)){fail('UNSUPPORTED_SHOT_CODE');break}
  start<-i;code<-chars[i];i<-i+1L;shot<-shot+1L
  flags<-character()
  while(i<=n&&chars[i]%in%c('+','-','=',';','^')){flags<-c(flags,chars[i]);i<-i+1L}
  if(anyDuplicated(flags))issues<-c(issues,'DUPLICATE_SHOT_MODIFIER')
  if(all(c('-','=')%in%flags))issues<-c(issues,'CONFLICTING_POSITION_MODIFIERS')
  if('^'%in%flags&&!code%in%c('v','z'))issues<-c(issues,'DROP_VOLLEY_MODIFIER_ON_OTHER_SHOT')
  digits<-character()
  while(i<=n&&grepl('^[0-9]$',chars[i])){digits<-c(digits,chars[i]);i<-i+1L}
  dir<-depth<-'';ds<-dep<-'NOT_RECORDED';u<-character()
  if(shot==2L) {
   if(length(digits)==1L) {
    if(digits%in%c('1','2','3')){dir<-digits;ds<-'RECORDED'}
    else if(digits%in%c('7','8','9')){depth<-digits;dep<-'RECORDED'}
    else if(digits=='0'){ds<-dep<-'AMBIGUOUS_SOURCE_ZERO';u<-c(u,'AMBIGUOUS_RETURN_ZERO')}
    else issues<-c(issues,'INVALID_RETURN_DIGITS')
   } else if(length(digits)==2L&&digits[1]%in%c('0','1','2','3')&&digits[2]%in%c('0','7','8','9')) {
    dir<-if(digits[1]=='0')'' else digits[1];ds<-if(digits[1]=='0')'SOURCE_UNKNOWN' else 'RECORDED'
    depth<-if(digits[2]=='0')'' else digits[2];dep<-if(digits[2]=='0')'SOURCE_UNKNOWN' else 'RECORDED'
    if(any(digits=='0'))u<-c(u,'UNKNOWN_RETURN_DIRECTION_OR_DEPTH')
   } else if(length(digits)>0L)issues<-c(issues,'INVALID_RETURN_DIGITS')
  } else {
   if(length(digits)==1L&&digits%in%c('0','1','2','3')) {
    dir<-if(digits=='0')'' else digits;ds<-if(digits=='0')'SOURCE_UNKNOWN' else 'RECORDED'
    if(digits=='0')u<-c(u,'UNKNOWN_SHOT_DIRECTION')
   } else if(length(digits)>0L)issues<-c(issues,'INVALID_RALLY_DIGITS')
  }
  if(i<=n&&chars[i]==';'){flags<-c(flags,';');i<-i+1L}
  error<-'';if(i<=n&&chars[i]%in%c('n','w','d','x','e','!')){error<-chars[i];i<-i+1L}
  if(i<=n&&chars[i]==';'){flags<-c(flags,';');i<-i+1L}
  if(anyDuplicated(flags))issues<-c(issues,'DUPLICATE_SHOT_MODIFIER')
  end<-'';if(i<=n&&chars[i]%in%c('*','#','@')){end<-chars[i];i<-i+1L}
  actor<-if(shot%%2L==1L)server else 3L-server
  if(code=='q')u<-c(u,'UNKNOWN_SHOT_TYPE')
  if(error=='e')u<-c(u,'UNKNOWN_ERROR_TYPE')
  a<-action_row(char_start=start,char_end=i-1L,raw_token=substr(raw,start,i-1L),
   kind='STROKE',domain=if(shot==2L)'Return' else 'Rally',actor=actor,
   in_play_shot=shot,shot_code=code,shot_type=unname(action_shots[code]),
   direction=dir,direction_status=ds,return_depth=depth,depth_status=dep,
   approach='+'%in%flags,position=if('-'%in%flags)'NET_ANNOTATION' else if('=' %in%flags)'BASELINE_ANNOTATION' else 'NOT_RECORDED',
   net_cord=';'%in%flags,drop_volley='^'%in%flags,is_plus1=shot==3L,
   error_code=error,unknowns=paste(u,collapse=';'))
  unknown<-c(unknown,u)
  if(end=='*') {
   if(nzchar(error))issues<-c(issues,'ERROR_CODE_WITH_WINNER')
   terminal<-'WINNER';terminal_winner<-actor
  } else if(end%in%c('#','@')) {
   if(end=='@'&&!nzchar(error))issues<-c(issues,'UNFORCED_ERROR_WITHOUT_ERROR_TYPE')
   terminal<-if(end=='#')'FORCED_ERROR' else 'UNFORCED_ERROR';terminal_winner<-3L-actor
  } else if(nzchar(error))issues<-c(issues,'ERROR_WITHOUT_TERMINAL_MARKER')
  if(nzchar(end))a$terminal<-terminal
  add(a)
  if(nzchar(end)){if(i<=n)fail('TRAILING_POINT_TERMINAL');break}
 }
 if(!nzchar(terminal))issues<-c(issues,'MISSING_POINT_TERMINAL')
 finish()
}
action_point <- function(first,second,server) {
 mcp_need(length(server)==1L&&server%in%c(1L,2L),'Invalid point server')
 a<-action_sequence(first,'1st',1L,server);parts<-list(a);issues<-a$issues
 if(nzchar(second)) {
  b<-action_sequence(second,'2nd',2L,server);parts[[2]]<-b;issues<-c(issues,b$issues)
  if(!a$kind%in%c('FAULT','FIRST_SERVE_FORFEIT'))issues<-c(issues,'SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT')
  if(b$kind %in%c('OUTCOME_ONLY','POINT_PENALTY','FIRST_SERVE_FORFEIT'))issues<-c(issues,'SPECIAL_CODE_IN_SECOND_FIELD')
  if(b$kind=='FAULT'){terminal<-'DOUBLE_FAULT';winner<-3L-server} else {terminal<-b$terminal;winner<-b$winner}
 } else {
  if(a$kind%in%c('FAULT','FIRST_SERVE_FORFEIT'))issues<-c(issues,'MISSING_SECOND_SERVE')
  terminal<-a$terminal;winner<-a$winner
 }
 rows<-do.call(rbind,lapply(parts,`[[`,'actions'));rownames(rows)<-NULL
 if(terminal=='DOUBLE_FAULT')rows$terminal[rows$kind=='SERVE_FAULT'&rows$serve_number==2L]<-'DOUBLE_FAULT'
 issues<-unique(issues);unknown<-unique(unlist(lapply(parts,`[[`,'unknowns')))
 observed_return<-any(rows$domain=='Return');observed_plus<-any(rows$is_plus1)
 trustworthy<-!length(issues)
 normal<-trustworthy&&!a$kind%in%c('OUTCOME_ONLY','POINT_PENALTY')&&!is.na(winner)
 return_state<-if(observed_return)'KNOWN_PRESENT' else if(trustworthy&&terminal%in%c('ACE','UNRETURNABLE','DOUBLE_FAULT','POINT_PENALTY'))'KNOWN_ABSENT' else 'UNKNOWN'
 plus_state<-if(observed_plus)'KNOWN_PRESENT' else if(trustworthy&&nzchar(terminal)&&terminal!='OUTCOME_ONLY')'KNOWN_ABSENT' else 'UNKNOWN'
 absent<-if(plus_state!='KNOWN_ABSENT')'' else if(observed_return)paste0('RETURN_',terminal) else terminal
 status<-if(length(issues))'UNSUPPORTED_OR_UNRESOLVED' else if(a$kind=='OUTCOME_ONLY')'OUTCOME_ONLY_MISSING_ACTIONS' else if(a$kind=='POINT_PENALTY')'ADMINISTRATIVE_POINT' else if(length(unknown))'PARSED_WITH_EXPLICIT_UNKNOWNS' else 'PARSED'
 list(actions=rows,issues=issues,unknowns=unknown,status=status,winner=winner,
 terminal=terminal,normal=normal,return_state=return_state,plus_state=plus_state,
 absent=absent,plus1_validated=normal&&observed_plus)
}

# Independent score replay: uses recorded point winners, not parsed stroke tokens.
action_score_replay <- function(d,best,format_code) {
 n<-nrow(d);supported<-best%in%c('3','5')&&format_code%in%c('0','1','A','T','W','V','S')
 out<-data.frame(score_status=rep(if(supported)'PASS' else 'UNSUPPORTED_FORMAT',n),
  score_reasons=rep(if(supported)'' else 'UNSUPPORTED_MATCH_FORMAT',n),stringsAsFactors=FALSE)
 if(!supported)return(list(points=out,complete=FALSE,sets=c(NA,NA),games=NA_integer_,tiebreaks=NA_integer_))
 sets<-games<-gp<-c(0L,0L);server<-1L;game_no<-1L;tb<-FALSE;tbfirst<-NA_integer_;tbpoints<-c(0L,0L);tbtotal<-0L;tbtarget<-7L;done<-FALSE;completed_games<-0L;tiebreaks<-0L
 for(j in seq_len(n)) {
  reason<-character();sv<-server;rc<-3L-sv
  if(tb)score<-paste(tbpoints[sv],tbpoints[rc],sep='-') else {
   if(min(gp)>=3L){a<-if(gp[sv]>gp[rc])'AD' else '40';b<-if(gp[rc]>gp[sv])'AD' else '40'}
   else {labels<-c('0','15','30','40');a<-labels[gp[sv]+1L];b<-labels[gp[rc]+1L]}
   score<-paste(a,b,sep='-')
  }
  if(done)reason<-c(reason,'POINT_AFTER_MATCH_TERMINAL')
  if(!identical(c(d$Set1[j],d$Set2[j]),as.character(sets)))reason<-c(reason,'SET_STATE_MISMATCH')
  if(!identical(c(d$Gm1[j],d$Gm2[j]),as.character(games)))reason<-c(reason,'GAME_STATE_MISMATCH')
  if(d$Svr[j]!=as.character(server))reason<-c(reason,'SERVER_SEQUENCE_MISMATCH')
  if(d$Pts[j]!=score)reason<-c(reason,'POINT_SCORE_MISMATCH')
  if(as.integer(d$Pt[j])!=j)reason<-c(reason,'POINT_NUMBER_MISMATCH')
  source_game<-suppressWarnings(as.integer(sub(' .*','',d[['Gm#']][j])))
  if(is.na(source_game)||source_game!=game_no)reason<-c(reason,'GAME_NUMBER_MISMATCH')
  if(length(reason)){out$score_status[j]<-'CONFLICT';out$score_reasons[j]<-paste(reason,collapse=';')}
  winner<-suppressWarnings(as.integer(d$PtWinner[j]));if(!winner%in%c(1L,2L)){out$score_status[j]<-'CONFLICT';out$score_reasons[j]<-paste(c(reason,'INVALID_RECORDED_WINNER'),collapse=';');break}
  game_done<-FALSE;set_done<-FALSE
  if(tb) {
   tbpoints[winner]<-tbpoints[winner]+1L;tbtotal<-tbtotal+1L
   if(tbpoints[winner]>=tbtarget&&tbpoints[winner]-tbpoints[3L-winner]>=2L) {
    games[winner]<-games[winner]+1L;game_done<-set_done<-TRUE
    server<-3L-tbfirst;tb<-FALSE;tiebreaks<-tiebreaks+1L
   } else server<-if((floor((tbtotal+1L)/2L)%%2L)==0L)tbfirst else 3L-tbfirst
  } else {
   gp[winner]<-gp[winner]+1L
   if(gp[winner]>=4L&&gp[winner]-gp[3L-winner]>=2L){games[winner]<-games[winner]+1L;gp<-c(0L,0L);server<-3L-server;game_done<-TRUE;set_done<-games[winner]>=6L&&games[winner]-games[3L-winner]>=2L}
  }
  if(game_done){completed_games<-completed_games+1L;game_no<-game_no+1L}
  if(set_done){sets[winner]<-sets[winner]+1L;games<-gp<-c(0L,0L);done<-sets[winner]==ceiling(as.integer(best)/2L)}
  if(!done&&!tb) {
   final<-sum(sets)+1L==as.integer(best)
   trigger<-if(format_code=='W')8L else if(final&&format_code=='T')12L else 6L
   allowed<-format_code!='V'&&!(final&&format_code=='0')
   super<-final&&format_code=='S'
   if(allowed&&((all(games==trigger))||(super&&all(games==0L)))) {
    tb<-TRUE;tbfirst<-server;tbpoints<-c(0L,0L);tbtotal<-0L
    tbtarget<-if(final&&format_code%in%c('A','S'))10L else 7L
   }
  }
 }
 list(points=out,complete=done&&all(out$score_status=='PASS'),sets=sets,
      games=completed_games,tiebreaks=tiebreaks)
}
action_load_sample <- function() {
 action_verify();s<-mcp_read(paste0(mcp_prefix,'prototype-sample.csv'))
 inventory<-mcp_read(paste0(mcp_prefix,'match-inventory.csv'));mm<-inventory[match(s$match_id,inventory$match_id),]
 mcp_need(identical(mm$match_id,s$match_id)&&all(mm$metadata_ok=='TRUE'),'Sample inventory linkage')
 parts<-list()
 for(file in unique(mm$point_file)) {
  d<-mcp_read(paste0('data/raw/reference/mcp-stage1-',file));take<-d$match_id%in%s$match_id
  z<-d[take,];z$source_row<-which(take);z$point_file<-file;parts[[file]]<-z
 }
 d<-do.call(rbind,parts);d<-d[order(match(d$match_id,s$match_id),as.integer(d$Pt)),];rownames(d)<-NULL
 mcp_need(!anyDuplicated(paste(d$match_id,d$Pt,sep='|')),'Duplicate sample point key')
 mcp_need(identical(as.integer(table(d$match_id)[s$match_id]),as.integer(mm$points)),'Independent sample point totals differ')
 list(sample=s,metadata=mm,points=d)
}
action_build <- function(input=action_load_sample()) {
 mm<-input$metadata[match(input$sample$match_id,input$metadata$match_id),]
 d<-input$points;d<-d[order(match(d$match_id,mm$match_id),as.integer(d$Pt)),];rownames(d)<-NULL
 rows<-vector('list',nrow(d));points<-vector('list',nrow(d));reasons<-list()
 for(j in seq_len(nrow(d))) {
  z<-d[j,];m<-mm[match(z$match_id,mm$match_id),];server<-as.integer(z$Svr)
  p<-action_point(z[['1st']],z[['2nd']],server);a<-p$actions;a$action_index<-seq_len(nrow(a))
  a$match_id<-z$match_id;a$Pt<-z$Pt;a$point_file<-z$point_file;a$source_row<-z$source_row
  a$action_id<-paste(z$match_id,z$Pt,a$action_index,sep='|')
  a$server<-server;a$receiver<-3L-server;a$actor_name<-ifelse(is.na(a$actor),'',ifelse(a$actor==1L,m$player1,m$player2))
  a$actor_neutral_slot<-ifelse(is.na(a$actor),'',ifelse(a$actor_name==m$player_a,'A','B'))
  a$raw_first<-z[['1st']];a$raw_second<-z[['2nd']];a$raw_notes<-z$Notes
  a$tour_file<-m$tour_file;a$sample_year<-m$year;a$surface<-m$Surface
  agree<-!is.na(p$winner)&&as.character(p$winner)==z$PtWinner
  issue<-p$issues;if(!is.na(p$winner)&&!agree)issue<-c(issue,'TERMINAL_OUTCOME_CONFLICT')
  status<-if('TERMINAL_OUTCOME_CONFLICT'%in%issue)'TERMINAL_OUTCOME_CONFLICT' else p$status
  a$point_parse_status<-status;rows[[j]]<-a
  pt<-data.frame(match_id=z$match_id,Pt=z$Pt,point_file=z$point_file,source_row=z$source_row,
   tour_file=m$tour_file,year=m$year,surface=m$Surface,server=server,receiver=3L-server,
   raw_first=z[['1st']],raw_second=z[['2nd']],raw_notes=z$Notes,recorded_winner=z$PtWinner,
   inferred_winner=p$winner,terminal=p$terminal,terminal_agrees=agree,parse_status=status,
   issues=paste(unique(issue),collapse=';'),explicit_unknowns=paste(p$unknowns,collapse=';'),
   tennis_sequence_validated=p$normal&&agree,return_observation=p$return_state,
   plus1_observation=p$plus_state,plus1_absence_reason=p$absent,
   plus1_validated=p$plus1_validated&&agree,actions=nrow(a),
   serve_attempts=sum(a$kind%in%c('SERVE','SERVE_FAULT')),lets=sum(a$kind=='LET'),
   first_fault=any(a$kind=='SERVE_FAULT'&a$serve_number==1L),double_fault=p$terminal=='DOUBLE_FAULT',
   first_serve_forfeit=any(a$kind=='FIRST_SERVE_FORFEIT'),
   return_actions=sum(a$domain=='Return'),rally_actions=sum(a$domain=='Rally'),
   plus1_attempts=sum(a$is_plus1),plus1_error=any(a$is_plus1&a$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR')),
   stringsAsFactors=FALSE)
  points[[j]]<-pt
  for(reason in unique(issue))reasons[[length(reasons)+1L]]<-data.frame(match_id=z$match_id,Pt=z$Pt,tour_file=m$tour_file,severity='FAILURE',reason=reason)
  for(reason in p$unknowns)reasons[[length(reasons)+1L]]<-data.frame(match_id=z$match_id,Pt=z$Pt,tour_file=m$tour_file,severity='EXPLICIT_UNKNOWN',reason=reason)
  if(p$status=='OUTCOME_ONLY_MISSING_ACTIONS')reasons[[length(reasons)+1L]]<-data.frame(match_id=z$match_id,Pt=z$Pt,tour_file=m$tour_file,severity='MISSING_OBSERVATION',reason='OUTCOME_ONLY_UNCHARTED_POINT')
 }
 a<-do.call(rbind,rows);pt<-do.call(rbind,points);matches<-list()
 pt$score_status<-rep('NOT_REPLAYED',nrow(pt));pt$score_reasons<-rep('',nrow(pt))
 for(j in seq_len(nrow(mm))) {
  m<-mm[j,];ii<-which(pt$match_id==m$match_id);dd<-d[d$match_id==m$match_id,];score<-action_score_replay(dd,m[['Best of']],m[['Final TB?']])
  pt$score_status[ii]<-score$points$score_status;pt$score_reasons[ii]<-score$points$score_reasons
  z<-pt[ii,];matches[[j]]<-data.frame(match_id=m$match_id,tour_file=m$tour_file,year=m$year,event=m$event_label,surface=m$Surface,
   expected_points=as.integer(m$points),observed_points=nrow(z),point_total_agrees=nrow(z)==as.integer(m$points),
   validated_tennis_points=sum(z$tennis_sequence_validated),outcome_only=sum(z$parse_status=='OUTCOME_ONLY_MISSING_ACTIONS'),
   unsupported_or_unresolved=sum(z$parse_status=='UNSUPPORTED_OR_UNRESOLVED'),terminal_conflicts=sum(z$parse_status=='TERMINAL_OUTCOME_CONFLICT'),
   terminal_agreements=sum(z$terminal_agrees),terminal_unresolved=sum(is.na(z$inferred_winner)),
   score_conflict_points=sum(z$score_status!='PASS'),chart_score_complete=score$complete,
   reconstructed_sets_1=score$sets[1],reconstructed_sets_2=score$sets[2],completed_games=score$games,tiebreaks=score$tiebreaks,
   plus1_validated=sum(z$plus1_validated),plus1_errors=sum(z$plus1_error&z$plus1_validated),
   plus1_known_absent=sum(z$plus1_observation=='KNOWN_ABSENT'),plus1_unknown=sum(z$plus1_observation=='UNKNOWN'),
   stringsAsFactors=FALSE)
  for(k in seq_len(nrow(z)))if(nzchar(z$score_reasons[k]))for(reason in strsplit(z$score_reasons[k],';',fixed=TRUE)[[1]])reasons[[length(reasons)+1L]]<-data.frame(match_id=m$match_id,Pt=z$Pt[k],tour_file=m$tour_file,severity='SCORE_RECONCILIATION',reason=reason)
 }
 mr<-do.call(rbind,matches);rr<-if(length(reasons))do.call(rbind,reasons) else data.frame(match_id=character(),Pt=character(),tour_file=character(),severity=character(),reason=character())
 counts<-list();for(key in sort(unique(paste(rr$tour_file,rr$severity,rr$reason,sep='|')),method='radix')){ii<-paste(rr$tour_file,rr$severity,rr$reason,sep='|')==key;z<-rr[ii,];counts[[length(counts)+1L]]<-data.frame(tour_file=z$tour_file[1],severity=z$severity[1],reason=z$reason[1],points=nrow(z),matches=length(unique(z$match_id)))}
 rc<-if(length(counts))do.call(rbind,counts) else data.frame(tour_file=character(),severity=character(),reason=character(),points=integer(),matches=integer())
 # Deterministic examples are selected by notation categories, never performance.
 categories<-list(first_fault=pt$first_fault,double_fault=pt$double_fault,let=pt$lets>0,
  ace=pt$terminal=='ACE',unreturned=pt$terminal=='UNRETURNABLE',return_winner=pt$terminal=='WINNER'&pt$plus1_absence_reason=='RETURN_WINNER',
  return_error=grepl('^RETURN_.*ERROR$',pt$plus1_absence_reason),plus1_error=pt$plus1_error,
  volley=a$match_id[a$shot_code%in%c('v','z')],overhead=a$match_id[a$shot_code%in%c('o','p')],
  serve_volley=a$match_id[a$domain=='Serve'&a$approach],outcome_only=pt$parse_status=='OUTCOME_ONLY_MISSING_ACTIONS',
  unsupported=pt$parse_status=='UNSUPPORTED_OR_UNRESOLVED',explicit_unknown=nzchar(pt$explicit_unknowns))
 examples<-list()
 for(cat in names(categories)) {
  v<-categories[[cat]]
  if(is.logical(v))ii<-which(v) else {
   token<-switch(cat,volley=a$shot_code%in%c('v','z'),overhead=a$shot_code%in%c('o','p'),serve_volley=a$domain=='Serve'&a$approach)
   keys<-paste(a$match_id[token],a$Pt[token],sep='|');ii<-which(paste(pt$match_id,pt$Pt,sep='|')%in%keys)
  }
  if(length(ii)){k<-ii[1];b<-a[a$match_id==pt$match_id[k]&a$Pt==pt$Pt[k],];label<-paste(paste0(b$domain,':P',ifelse(is.na(b$actor),'?',b$actor),':',b$raw_token,ifelse(b$is_plus1,'[+1]',''),ifelse(b$is_void,'[void]','')),collapse=' > ')
   examples[[length(examples)+1L]]<-data.frame(category=cat,match_id=pt$match_id[k],Pt=pt$Pt[k],raw_first=pt$raw_first[k],raw_second=pt$raw_second[k],decoded=label,status=pt$parse_status[k])}
 }
 ex<-do.call(rbind,examples);summary<-list()
 for(tour in c('ALL','ATP','WTA')) {
  z<-if(tour=='ALL')pt else pt[pt$tour_file==tour,];b<-if(tour=='ALL')a else a[a$tour_file==tour,]
  summary[[tour]]<-data.frame(tour_file=tour,matches=length(unique(z$match_id)),points=nrow(z),
   parsed=sum(z$parse_status=='PARSED'),parsed_explicit_unknown=sum(z$parse_status=='PARSED_WITH_EXPLICIT_UNKNOWNS'),
   outcome_only=sum(z$parse_status=='OUTCOME_ONLY_MISSING_ACTIONS'),administrative=sum(z$parse_status=='ADMINISTRATIVE_POINT'),
   unsupported_or_unresolved=sum(z$parse_status=='UNSUPPORTED_OR_UNRESOLVED'),terminal_conflicts=sum(z$parse_status=='TERMINAL_OUTCOME_CONFLICT'),
   terminal_agreements=sum(z$terminal_agrees),terminal_unresolved=sum(is.na(z$inferred_winner)),score_conflict_points=sum(z$score_status!='PASS'),
   action_rows=nrow(b),serve_attempts=sum(b$kind%in%c('SERVE','SERVE_FAULT')),void_lets=sum(b$kind=='LET'),return_actions=sum(b$domain=='Return'),rally_actions=sum(b$domain=='Rally'),
   first_faults=sum(z$first_fault),double_faults=sum(z$double_fault),first_forfeits=sum(z$first_serve_forfeit),
   plus1_observed=sum(z$plus1_observation=='KNOWN_PRESENT'),plus1_validated=sum(z$plus1_validated),plus1_validated_errors=sum(z$plus1_error&z$plus1_validated),
   plus1_known_absent=sum(z$plus1_observation=='KNOWN_ABSENT'),plus1_unknown=sum(z$plus1_observation=='UNKNOWN'),stringsAsFactors=FALSE)
 }
 r<-setNames(list(a,pt,mr,rc,ex,do.call(rbind,summary)),action_outputs)
 for(k in names(r)){r[[k]]$revision<-mcp_revision;r[[k]]$release<-'MCP_STAGE2_1.1.0';r[[k]]$claim<-'SAMPLE_PARSER_AUDIT_NOT_FACTOR_VALIDATION_OR_ANALYTICAL_ADMISSION';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';rownames(r[[k]])<-NULL}
 r
}
action_install <- function(r) {
 mcp_need(identical(names(r),action_outputs),'Action output scope')
 paths<-paste0(action_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Output locations must already be ignored')
 stage<-vapply(paths,function(p)tempfile('.mcp-actions-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(j in seq_along(r))mcp_write(r[[j]],stage[j]);action_verify()
 for(j in seq_along(paths))if(file.exists(paths[j]))mcp_need(mcp_sha(paths[j])==mcp_sha(stage[j]),'Preserve differing existing action release')
 for(j in seq_along(paths))if(!file.exists(paths[j]))mcp_need(file.rename(stage[j],paths[j]),'Action installation failed')
 invisible(r)
}
parse_mcp_actions <- function(write_outputs=TRUE){r<-action_build();if(write_outputs)action_install(r);r}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline sample parser takes no arguments');r<-parse_mcp_actions();print(r$summary[,1:13]);print(r[['reason-summary']][,1:5])}
