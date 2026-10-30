# MCP_ACTION_STATES_1.0.0: deterministic observable accounting, no estimation.
source('R/parse_mcp_actions.R')
state_prefix <- 'data/pilot/mcp-action-states-v1-'
state_outputs <- c('action-states','serve-plus1','coverage-summary','field-provenance')
state_match_order <- mcp_read(paste0(mcp_prefix,'prototype-sample.csv'))$match_id
state_parser_pins <- c(
 actions='d7ef1c44bf60f0d3f38883f5093b0b5fc56e5d3ae67da0a5116911cfaa4bf119',
 'point-reconciliation'='82f65bf6d9598ef11ed238e4c565a6307cbd132a06298196d1e7b7dfe0ebbbd3',
 'match-reconciliation'='4eefd1275242517aa4e318bf4a549a1a012f40b3de03ddde124aaf73dd9b7d22',
 'reason-summary'='b1db24d0156409778975f6373d407f5d4b4fc9e0b5df069d308ba9925b0fe5be',
 'decoded-examples'='976c80a03da9ba14cf81e38ccb6dc582f0b5b8508dc2c1ee51e946cb366d031f',
 summary='42a2045fe9da3aa93825e9795c53d9bed712c65a73f59018464be85cd17934ad')
state_pre_fields <- c('pre_boundary','pre_next_domain','pre_next_actor_role',
 'pre_serve_number','pre_in_play_strokes','pre_incoming_domain',
 'pre_incoming_shot_type','pre_incoming_direction','pre_incoming_direction_status',
 'pre_incoming_return_depth','pre_incoming_depth_status')
state_role <- function(actor,server) {
 if(is.na(actor))'UNKNOWN' else if(actor==server)'SERVER' else 'RECEIVER'
}
state_initial <- function()list(boundary='AWAITING_SERVE',domain='Serve',actor='SERVER',
 serve=1L,strokes=0L,incoming_domain='NOT_APPLICABLE',incoming_type='NOT_YET_OBSERVED',
 direction='',direction_status='NOT_APPLICABLE',depth='',depth_status='NOT_APPLICABLE',
 incoming_id='',serve_origin='POINT_START',previous_id='',absorbed=FALSE,winner='')
state_pre <- function(s)list(pre_boundary=s$boundary,pre_next_domain=s$domain,
 pre_next_actor_role=s$actor,pre_serve_number=s$serve,pre_in_play_strokes=s$strokes,
 pre_incoming_domain=s$incoming_domain,pre_incoming_shot_type=s$incoming_type,
 pre_incoming_direction=s$direction,pre_incoming_direction_status=s$direction_status,
 pre_incoming_return_depth=s$depth,pre_incoming_depth_status=s$depth_status,
 prior_action_id=s$previous_id,incoming_source_action_id=s$incoming_id,
 serve_number_source_action_id=s$serve_origin)
state_advance <- function(s,a,server) {
 # This function reads this action only, never the point winner or next action.
 role<-state_role(a$actor,server);reason<-'';supported<-TRUE
 before<-s$boundary;after<-s;winner<-''
 if(s$absorbed){supported<-FALSE;reason<-'ACTION_AFTER_TERMINAL'}
 else if(a$kind%in%c('UNSUPPORTED_SUFFIX','MISSING_SEQUENCE','OUTCOME_ONLY')) {
  supported<-FALSE;reason<-if(a$kind=='OUTCOME_ONLY')'MISSING_ACTION_OBSERVATION' else 'UNSUPPORTED_OR_MISSING_BOUNDARY'
 } else if(a$kind%in%c('LET','FIRST_SERVE_FORFEIT','SERVE','SERVE_FAULT')) {
  supported<-s$domain=='Serve'&&role=='SERVER'&&a$serve_number==s$serve
  if(!supported)reason<-'SERVE_BOUNDARY_MISMATCH'
 } else if(a$kind=='STROKE') {
  supported<-s$domain%in%c('Return','Rally')&&role==s$actor&&
   !is.na(a$in_play_shot)&&a$in_play_shot==s$strokes+1L&&a$serve_number==s$serve
  if(!supported)reason<-'STROKE_BOUNDARY_MISMATCH'
 } else if(!a$kind%in%c('INCORRECT_CHALLENGE','POINT_PENALTY')) {
  supported<-FALSE;reason<-'UNSUPPORTED_EVENT_KIND'
 }
 if(s$absorbed)return(list(state=s,supported=FALSE,reason=reason,winner=s$winner))
 if(!supported) {
  after<-state_initial();after$boundary<-'UNKNOWN';after$domain<-after$actor<-'UNKNOWN'
  after$serve<-after$strokes<-NA_integer_;after$incoming_type<-'UNKNOWN'
  after$direction_status<-after$depth_status<-'UNKNOWN_BOUNDARY';after$serve_origin<-''
 } else if(a$kind=='LET') {
  # A void serve changes no tennis state or opportunity ordinal.
 } else if(a$kind=='FIRST_SERVE_FORFEIT') {
  after$serve<-2L;after$serve_origin<-a$action_id
 } else if(a$kind=='SERVE_FAULT'&&a$serve_number==1L) {
  after$serve<-2L;after$serve_origin<-a$action_id
 } else if(a$kind%in%c('SERVE','STROKE')) {
  after$strokes<-s$strokes+1L;after$incoming_domain<-a$domain
  after$incoming_type<-if(a$kind=='SERVE')'SERVE' else a$shot_type
  after$direction<-a$direction;after$direction_status<-a$direction_status
  after$depth<-a$return_depth;after$depth_status<-a$depth_status
  after$incoming_id<-a$action_id
  after$domain<-if(a$kind=='SERVE')'Return' else 'Rally'
  after$boundary<-if(a$kind=='SERVE')'AWAITING_RETURN' else 'AWAITING_RALLY_STROKE'
  after$actor<-if(role=='SERVER')'RECEIVER' else 'SERVER'
 }
 if(supported) {
  if(a$kind=='SERVE_FAULT'&&a$serve_number==2L)winner<-'RECEIVER'
  else if(a$terminal%in%c('ACE','UNRETURNABLE','WINNER'))winner<-role
  else if(a$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR','DOUBLE_FAULT'))winner<-if(role=='SERVER')'RECEIVER' else 'SERVER'
  else if(a$kind=='INCORRECT_CHALLENGE')winner<-if(role=='SERVER')'RECEIVER' else 'SERVER'
  else if(a$kind=='POINT_PENALTY')winner<-if(role=='SERVER')'RECEIVER' else 'SERVER'
  if(nzchar(winner)){after$absorbed<-TRUE;after$boundary<-'TERMINAL';after$domain<-after$actor<-'NONE';after$winner<-winner}
 }
 after$previous_id<-a$action_id
 list(state=after,supported=supported,reason=reason,winner=winner)
}
state_point <- function(a,server) {
 a<-a[order(a$action_index),,drop=FALSE];s<-state_initial();rows<-vector('list',nrow(a))
 for(i in seq_len(nrow(a))) {
  z<-a[i,];pre<-state_pre(s);next_state<-state_advance(s,z,server)
  rows[[i]]<-as.data.frame(c(list(action_id=z$action_id),pre,list(
   post_kind=z$kind,post_actor_role=state_role(z$actor,server),
   post_serve_number=z$serve_number,post_shot_type=if(z$kind%in%c('SERVE','SERVE_FAULT','LET'))'SERVE' else z$shot_type,
   post_direction=z$direction,post_direction_status=z$direction_status,
   post_return_depth=z$return_depth,post_depth_status=z$depth_status,
   post_terminal_status=z$terminal,post_error_code=z$error_code,
   post_boundary=next_state$state$boundary,post_terminal_winner_role=next_state$winner,
   post_observation=z$observation,post_explicit_unknowns=z$unknowns,
   local_boundary_supported=next_state$supported,local_boundary_reason=next_state$reason)),stringsAsFactors=FALSE)
  s<-next_state$state
 }
 do.call(rbind,rows)
}
state_verify <- function() {
 action_verify()
 for(k in names(state_parser_pins))mcp_need(mcp_sha(paste0(action_prefix,k,'.csv'))==state_parser_pins[[k]],'Frozen parser 1.1.0 output changed')
 invisible(TRUE)
}
state_load <- function() {
 state_verify()
 a<-read.csv(paste0(action_prefix,'actions.csv'),stringsAsFactors=FALSE,na.strings='',check.names=FALSE)
 p<-read.csv(paste0(action_prefix,'point-reconciliation.csv'),stringsAsFactors=FALSE,na.strings='',check.names=FALSE)
 # Empty notation fields are literal empty strings, not invented zeros.
 for(d in c('a','p')){x<-get(d);for(k in names(x)[vapply(x,is.character,FALSE)])x[[k]][is.na(x[[k]])]<-'';assign(d,x)}
 m<-mcp_read(paste0(action_prefix,'match-reconciliation.csv'))
 list(actions=a,points=p,matches=m)
}
state_check_input <- function(input) {
 a<-input$actions;p<-input$points;m<-input$matches
 mcp_need(nrow(p)==7333L&&nrow(a)==38593L&&nrow(m)==44L,'Frozen row totals')
 keys<-paste(p$match_id,p$Pt,sep='|');ak<-paste(a$match_id,a$Pt,sep='|')
 mcp_need(!anyDuplicated(keys)&&!anyDuplicated(a$action_id),'Duplicate point/action identity')
 mcp_need(setequal(p$match_id,m$match_id)&&all(ak%in%keys),'Exact frozen joins')
 mcp_need(setequal(m$match_id,state_match_order),'Frozen sample identities')
 for(ii in split(seq_len(nrow(a)),ak))mcp_need(identical(sort(a$action_index[ii]),seq_along(ii)),'Noncontiguous action order')
 j<-match(ak,keys)
 mcp_need(all(a$server==p$server[j])&&all(a$receiver==3L-a$server)&&all(a$server%in%1:2),'Player perspective linkage')
 mcp_need(all(a$revision==mcp_revision)&&all(a$release=='MCP_STAGE2_1.1.0')&&all(p$score_status=='PASS'),'Parser authority/score status')
 mcp_need(all(as.integer(table(p$match_id)[m$match_id])==as.integer(m$observed_points)),'Independent frozen match counts')
 invisible(TRUE)
}
state_plus1 <- function(a,p) {
 keys<-paste(p$match_id,p$Pt,sep='|');ak<-paste(a$match_id,a$Pt,sep='|')
 groups<-split(seq_len(nrow(a)),factor(ak,levels=keys));rows<-vector('list',nrow(p))
 for(i in seq_len(nrow(p))) {
  z<-a[groups[[i]],,drop=FALSE];q<-p[i,]
  attempts<-z$kind=='STROKE'&z$domain=='Rally'&!is.na(z$in_play_shot)&z$in_play_shot==3L&z$actor==q$server
  mcp_need(sum(attempts)<=1L,'Duplicate +1 contribution')
  has<-any(attempts);valid<-q$tennis_sequence_validated&&has
  err<-if(valid)any(z$terminal[attempts]%in%c('FORCED_ERROR','UNFORCED_ERROR')) else NA
  terminal<-tail(z$terminal[nzchar(z$terminal)],1L)
  absent<-!has&&q$parse_status%in%c('PARSED','PARSED_WITH_EXPLICIT_UNKNOWNS','ADMINISTRATIVE_POINT')&&length(terminal)==1L
  classification<-if(valid)'VALIDATED_ATTEMPT' else if(absent)'KNOWN_ABSENT' else if(has)'UNVALIDATED_OBSERVED_PREFIX' else 'UNKNOWN_OPPORTUNITY'
  rows[[i]]<-data.frame(point_id=keys[i],match_id=q$match_id,Pt=q$Pt,tour_file=q$tour_file,
   year=q$year,surface=q$surface,server=q$server,perspective='SOURCE_SERVER',
   source_point_file=q$point_file,source_row=q$source_row,raw_first=q$raw_first,raw_second=q$raw_second,
   disposition=classification,observed_prefix=has,validated_attempt=valid,attempted_error=err,
   plus1_action_id=if(has)z$action_id[attempts] else '',
   absence_reason=if(absent)q$plus1_absence_reason else '',
   parser_opportunity_observation=q$plus1_observation,point_parse_status=q$parse_status,
   missing_observation=q$parse_status=='OUTCOME_ONLY_MISSING_ACTIONS',
   unsupported_point=q$parse_status=='UNSUPPORTED_OR_UNRESOLVED',
   authority_conflict=grepl('SERVE_NET_CORD_AUTHORITY_CONFLICT',q$issues,fixed=TRUE),
   point_exclusion_reasons=q$issues,stringsAsFactors=FALSE)
 }
 out<-do.call(rbind,rows)
 mcp_need(identical(out$validated_attempt,p$plus1_validated),'Independent +1 validation differs')
 mcp_need(identical(out$observed_prefix,p$plus1_observation=='KNOWN_PRESENT'),'Independent observed +1 differs')
 mcp_need(identical(out$disposition=='KNOWN_ABSENT',p$plus1_observation=='KNOWN_ABSENT'),'Independent absent +1 differs')
 mcp_need(identical(out$disposition=='UNKNOWN_OPPORTUNITY',p$plus1_observation=='UNKNOWN'),'Independent unknown +1 differs')
 mcp_need(identical(out$attempted_error[out$validated_attempt],p$plus1_error[p$plus1_validated]),'Independent +1 errors differ')
 out
}
state_coverage <- function(a,p,plus) {
 rows<-list();keys<-paste(p$match_id,p$Pt,sep='|')
 add<-function(level,label,ai,pi) {
  x<-a[ai,,drop=FALSE];z<-p[pi,,drop=FALSE];b<-plus[pi,,drop=FALSE]
  rows[[length(rows)+1L]]<<-data.frame(level=level,context=label,
   points=nrow(z),validated_points=sum(z$tennis_sequence_validated),
   point_retention=if(nrow(z))mean(z$tennis_sequence_validated) else NA_real_,
   transitions=nrow(x),usable_transitions=sum(x$transition_usable),
   transition_retention=if(nrow(x))mean(x$transition_usable) else NA_real_,
   usable_tennis_actions=sum(x$tennis_action_usable),
   missing_pre_direction=sum(x$transition_usable&!x$pre_incoming_direction_status%in%c('RECORDED','NOT_APPLICABLE')),
   missing_pre_type=sum(x$transition_usable&x$pre_incoming_shot_type=='UNKNOWN'),
   validated_plus1=sum(b$validated_attempt),plus1_errors=sum(b$attempted_error,na.rm=TRUE),
   known_absences=sum(b$disposition=='KNOWN_ABSENT'),unknown_opportunities=sum(b$disposition=='UNKNOWN_OPPORTUNITY'),
   unvalidated_prefixes=sum(b$disposition=='UNVALIDATED_OBSERVED_PREFIX'),
   server_won_validated_points=sum(z$tennis_sequence_validated&z$recorded_winner==z$server),
   server_won_withheld_points=sum(!z$tennis_sequence_validated&z$recorded_winner==z$server),
   receiver_won_validated_points=sum(z$tennis_sequence_validated&z$recorded_winner!=z$server),
   receiver_won_withheld_points=sum(!z$tennis_sequence_validated&z$recorded_winner!=z$server),stringsAsFactors=FALSE)
 }
 add('ALL','ALL',seq_len(nrow(a)),seq_len(nrow(p)))
 pgroups<-list(tour=p$tour_file,match=paste(p$tour_file,p$match_id,sep='|'),
  surface=paste(p$tour_file,p$surface,sep='|'),point_status=paste(p$tour_file,p$parse_status,sep='|'))
 for(level in names(pgroups))for(label in sort(unique(pgroups[[level]]),method='radix')){
  pi<-which(pgroups[[level]]==label);ai<-which(a$point_id%in%keys[pi]);add(level,label,ai,pi)
 }
 agroups<-list(owner=paste(a$tour_file,a$owner_domain,sep='|'),
  serve_number=paste(a$tour_file,a$pre_serve_number,sep='|'),
  incoming_context=paste(a$tour_file,a$pre_next_domain,a$pre_incoming_shot_type,
   a$pre_incoming_direction_status,a$pre_incoming_depth_status,sep='|'))
 for(level in names(agroups))for(label in sort(unique(agroups[[level]]),method='radix')){
  ai<-which(agroups[[level]]==label);pi<-which(keys%in%a$point_id[ai]);add(level,label,ai,pi)
 }
 do.call(rbind,rows)
}
state_provenance <- function(outputs) {
 post_sources<-c(post_kind='actions.kind',post_actor_role='actions.actor relative to source server',
  post_serve_number='actions.serve_number',post_shot_type='actions.shot_type; SERVE label for serve/fault/let events',
  post_direction='actions.direction',post_direction_status='actions.direction_status',
  post_return_depth='actions.return_depth',post_depth_status='actions.depth_status',
  post_terminal_status='actions.terminal',post_error_code='actions.error_code',
  post_boundary='Strictly preceding observable state plus current action; terminal state remains absorbing',
  post_terminal_winner_role='Documented current terminal and actor relative to server; absorbed winner retained only on unusable later audit rows',
  post_observation='actions.observation',post_explicit_unknowns='actions.unknowns')
 rows<-list()
 for(output in names(outputs))for(field in names(outputs[[output]])) {
  pre<-field%in%state_pre_fields&&output=='action-states'
  phase<-if(pre)'PRE_ACTION_PREDICTOR' else if(grepl('^post_',field))'POST_ACTION_OBSERVATION' else if(field%in%c('prior_action_id','incoming_source_action_id','serve_number_source_action_id'))'PRIOR_PROVENANCE_NOT_PREDICTOR' else if(field%in%c('match_id','point_id','Pt','action_id','action_index','server','perspective','owner_domain','owner_role','actor_name','actor_neutral_slot','tour_file','sample_year','surface','point_file','source_point_file','source_row','sequence_field','char_start','char_end','raw_token','raw_first','raw_second','raw_notes'))'IDENTITY_OR_RAW_AUDIT_NOT_PREDICTOR' else 'RETROSPECTIVE_QA_OR_COVERAGE_NOT_PREDICTOR'
  source<-if(pre)'Strictly preceding actions; POINT_START initializes serve 1; incoming_source_action_id and serve_number_source_action_id identify exact dependencies' else if(field%in%names(post_sources))unname(post_sources[[field]]) else if(output=='coverage-summary')'Aggregate frozen quality/membership; recorded point outcome only for disclosed counts, never selection' else 'Frozen parser 1.1.0 action/point fields and source location; explicit derivation in builder'
  rows[[length(rows)+1L]]<-data.frame(output=output,field=field,information_class=phase,
   source=source,missing_policy='Missing/unknown stays explicit or undefined; no imputation; no spatial/quality inference',stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
build_mcp_action_states <- function(input=state_load()) {
 state_check_input(input);a<-input$actions;p<-input$points;m<-input$matches
 m<-m[match(state_match_order,m$match_id),,drop=FALSE]
 # Normalize independently of input permutations, following the frozen match/point IDs.
 p<-p[order(match(p$match_id,m$match_id),p$Pt),];rownames(p)<-NULL
 keys<-paste(p$match_id,p$Pt,sep='|');ak<-paste(a$match_id,a$Pt,sep='|')
 a<-a[order(match(ak,keys),a$action_index),];rownames(a)<-NULL
 ak<-paste(a$match_id,a$Pt,sep='|');groups<-split(seq_len(nrow(a)),factor(ak,levels=keys))
 states<-lapply(seq_along(groups),function(i)state_point(a[groups[[i]],,drop=FALSE],p$server[i]))
 s<-do.call(rbind,states);rownames(s)<-NULL;mcp_need(identical(s$action_id,a$action_id),'State ordering mismatch')
 j<-match(ak,keys)
 id<-a[,c('match_id','Pt','action_id','action_index','server','actor_name','actor_neutral_slot','tour_file','sample_year','surface','point_file','source_row','sequence_field','char_start','char_end','raw_token','raw_first','raw_second','raw_notes')]
 id$point_id<-ak;id$perspective<-'SOURCE_SERVER';id$owner_domain<-a$domain
 id$owner_role<-vapply(seq_len(nrow(a)),function(i)state_role(a$actor[i],a$server[i]),'')
 x<-cbind(id,s[,setdiff(names(s),'action_id')]);x$point_parse_status<-p$parse_status[j]
 x$point_validated<-p$tennis_sequence_validated[j];x$point_exclusion_reasons<-p$issues[j]
 x$authority_conflict<-grepl('SERVE_NET_CORD_AUTHORITY_CONFLICT',x$point_exclusion_reasons,fixed=TRUE)
 x$missing_observation<-a$observation=='MISSING_OBSERVATION';x$unsupported_observation<-a$observation=='UNSUPPORTED_SUFFIX'
 x$transition_usable<-x$point_validated&p$score_status[j]=='PASS'&x$local_boundary_supported
 x$tennis_action_usable<-x$transition_usable&a$kind%in%c('SERVE','SERVE_FAULT','STROKE')&!a$is_void
 x$transition_withheld_reason<-ifelse(x$transition_usable,'',ifelse(!x$point_validated,paste0('POINT_NOT_VALIDATED:',p$parse_status[j],ifelse(nzchar(p$issues[j]),paste0(':',p$issues[j]),'')),x$local_boundary_reason))
 plus<-state_plus1(a,p);cov<-state_coverage(x,p,plus)
 # Labels are provenance, never inputs to a predictor.
 r<-list('action-states'=x,'serve-plus1'=plus,'coverage-summary'=cov)
 for(k in names(r)){r[[k]]$release<-'MCP_ACTION_STATES_1.0.0';r[[k]]$source_release<-'MCP_STAGE2_1.1.0';r[[k]]$revision<-mcp_revision;r[[k]]$claim<-'OBSERVABLE_ACCOUNTING_NOT_ACTION_VALUE_OR_FACTOR_VALIDATION';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r[['field-provenance']]<-state_provenance(r)
 r
}
state_install <- function(r) {
 mcp_need(identical(names(r),state_outputs),'State output scope')
 paths<-paste0(state_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Output locations must already be ignored')
 stage<-vapply(paths,function(p)tempfile('.mcp-states-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);state_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Preserve differing installed state release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'State installation failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline builder takes no arguments');r<-build_mcp_action_states();state_install(r);print(r[['coverage-summary']][r[['coverage-summary']]$level%in%c('ALL','tour'),1:18],row.names=FALSE)}
