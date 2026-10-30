# MCP_OPPORTUNITY_CONTEXT_1.0.0: pre-action contexts, descriptive sample only.
source('R/summarize_mcp_execution.R')
context_prefix<-'data/pilot/mcp-opportunity-context-v1-'
context_outputs<-c('dictionary','context-summary','coverage-summary','measurement-checks')
context_execution_pins<-c(dictionary='ff422c58cf3ccc393ac0d258c3ccfb2d59aed5e5acc4ee756594bd6035f8d664',
 'execution-summary'='74ddb27e2b7d9c460566d8825e325e20ffe3360e290ae72ce3764ebc1726514f',
 breakdowns='17cf5a0de712ec1ca06b8108842d21bcbf9593510317f449132fcb3274d1948e',
 'coverage-summary'='97c4ac9fb0c639775f17af1efd8d6a94ab6dce74504654c59f51610ffaf4200c')
context_pre_fields<-c('pre_boundary','pre_next_domain','pre_next_actor_role','pre_serve_number',
 'pre_in_play_strokes','pre_incoming_domain','pre_incoming_shot_type','pre_incoming_direction',
 'pre_incoming_direction_status','pre_incoming_return_depth','pre_incoming_depth_status')
context_roles<-c('SERVER_PLUS1','SERVER_LATER','RECEIVER_LATER','UNKNOWN','UNSUPPORTED')
context_verify<-function() {
 execution_verify()
 for(k in names(context_execution_pins))mcp_need(mcp_sha(paste0(execution_prefix,k,'.csv'))==context_execution_pins[[k]],'Frozen execution release changed')
 invisible(TRUE)
}
context_dictionary<-function()data.frame(
 domain=c('Return',rep('Rally',4)),view=c('serve_number','role_phase','preceding_type','preceding_direction','preceding_return_depth'),
 inputs=c('pre_boundary;pre_next_domain;pre_serve_number','pre_boundary;pre_next_domain;pre_next_actor_role;pre_in_play_strokes',
 'role_phase;pre_incoming_shot_type','role_phase;pre_incoming_direction;pre_incoming_direction_status',
 'role_phase;pre_incoming_domain;pre_incoming_return_depth;pre_incoming_depth_status'),
 denominator='Usable observed domain STROKE attempts in this context; zero remains undefined',
 unknown_execution='Withheld observed domain attempts; unobserved suffix length not inferred',
 stringsAsFactors=FALSE)
context_categories<-function(view) {
 values<-switch(view,serve_number=c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),role_phase=context_roles,
  preceding_type=c(sort(setdiff(unname(action_shots),'UNKNOWN'),method='radix'),'UNKNOWN','UNSUPPORTED'),
  preceding_direction=c('1','2','3','NOT_RECORDED','UNKNOWN','UNSUPPORTED'),
  preceding_return_depth=c('7','8','9','NOT_RECORDED','UNKNOWN','UNSUPPORTED','NOT_APPLICABLE'))
 if(view%in%c('serve_number','role_phase'))values else as.vector(outer(context_roles,values,paste,sep='|'))
}
context_classify<-function(pre,domain) {
 # Intentionally accepts only a pre-action frame; no post outcome or raw token.
 mcp_need(identical(names(pre),context_pre_fields),'Explicit pre-action allowlist required')
 n<-nrow(pre);bad<-pre$pre_boundary%in%c('UNKNOWN','TERMINAL')|pre$pre_next_domain!=domain
 bad[is.na(bad)]<-TRUE
 if(domain=='Return') {
  value<-ifelse(pre$pre_serve_number==1,'FIRST',ifelse(pre$pre_serve_number==2,'SECOND','UNKNOWN'))
  value[is.na(value)]<-'UNKNOWN';value[bad]<-'UNSUPPORTED';return(list(serve_number=value))
 }
 role<-rep('UNKNOWN',n);k<-pre$pre_in_play_strokes;actor<-pre$pre_next_actor_role
 role[which(actor=='SERVER'&k==2)]<-'SERVER_PLUS1'
 role[which(actor=='SERVER'&k>=3)]<-'SERVER_LATER'
 role[which(actor=='RECEIVER'&k>=3)]<-'RECEIVER_LATER'
 role[bad]<-'UNSUPPORTED'
 type<-pre$pre_incoming_shot_type;type[!type%in%unname(action_shots)]<-'UNKNOWN'
 direction<-ifelse(pre$pre_incoming_direction_status=='RECORDED'&pre$pre_incoming_direction%in%c('1','2','3'),pre$pre_incoming_direction,
  ifelse(pre$pre_incoming_direction_status=='NOT_RECORDED','NOT_RECORDED','UNKNOWN'))
 depth<-ifelse(pre$pre_incoming_domain=='Rally','NOT_APPLICABLE',
  ifelse(pre$pre_incoming_depth_status=='RECORDED'&pre$pre_incoming_return_depth%in%c('7','8','9'),pre$pre_incoming_return_depth,
   ifelse(pre$pre_incoming_depth_status=='NOT_RECORDED','NOT_RECORDED','UNKNOWN')))
 type[bad]<-'UNSUPPORTED';direction[bad]<-'UNSUPPORTED';depth[bad]<-'UNSUPPORTED'
 list(role_phase=role,preceding_type=paste(role,type,sep='|'),
  preceding_direction=paste(role,direction,sep='|'),preceding_return_depth=paste(role,depth,sep='|'))
}
context_load<-function() {
 context_verify();x<-execution_load()
 x$execution<-read.csv(paste0(execution_prefix,'execution-summary.csv'),stringsAsFactors=FALSE,na.strings='NA')
 x
}
context_summary<-function(input,dictionary) {
 rows<-list();groups<-execution_groups(input)
 for(i in seq_len(nrow(groups))) {
  g<-groups[i,];s<-execution_subset(input,g)$s
  for(domain in c('Return','Rally')) {
   x<-s[s$owner_domain==domain&s$post_kind=='STROKE',];u<-x$tennis_action_usable
   keys<-context_classify(x[,context_pre_fields,drop=FALSE],domain)
   for(view in names(keys))for(category in context_categories(view)) {
    sel<-keys[[view]]==category;known<-sel&u;attempts<-sum(known);observed<-sum(sel)
    forced<-sum(known&x$post_terminal_status=='FORCED_ERROR');unforced<-sum(known&x$post_terminal_status=='UNFORCED_ERROR')
    rows[[length(rows)+1L]]<-cbind(g,data.frame(domain,view,context=category,observed_attempts=observed,
     usable_attempts=attempts,unknown_execution_count=observed-attempts,
     forced_errors=forced,unforced_errors=unforced,errors=forced+unforced,
     in_play=sum(known&!x$post_terminal_status%in%c('FORCED_ERROR','UNFORCED_ERROR')),
     winners=sum(known&x$post_terminal_status=='WINNER'),error_denominator=attempts,
     error_rate=execution_ratio(forced+unforced,attempts),forced_error_rate=execution_ratio(forced,attempts),
     unforced_error_rate=execution_ratio(unforced,attempts),retention=execution_ratio(attempts,observed),
     observed_composition=execution_ratio(observed,nrow(x)),usable_composition=execution_ratio(attempts,sum(u)),
     context_status=if(grepl('UNSUPPORTED',category,fixed=TRUE))'UNSUPPORTED' else if(grepl('UNKNOWN|NOT_RECORDED',category))'UNKNOWN_OR_NOT_RECORDED' else 'RECORDED_OR_NOT_APPLICABLE',
     rate_status=if(!attempts)'ZERO_OPPORTUNITY' else 'DESCRIPTIVE_ONLY',stringsAsFactors=FALSE))
   }
  }
 }
 do.call(rbind,rows)
}
context_measurements<-function(summary,input) {
 rows<-list();add<-function(tour,domain,view,check,measured,detail) {
  rows[[length(rows)+1L]]<<-data.frame(tour,domain,view,check,measured,detail,stringsAsFactors=FALSE)
 }
 for(tour in c('ATP','WTA'))for(view in unique(summary$view)) {
  x<-summary[summary$scope=='tour'&summary$tour==tour&summary$view==view,]
  z<-summary[summary$scope=='match_player'&summary$tour==tour&summary$view==view,]
  domain<-unique(x$domain);players<-length(unique(paste(z$match_id,z$slot,sep='|')))
  add(tour,domain,view,'nonempty_observed_contexts',sum(x$observed_attempts>0),'Zero vs nonzero support is accounting, not an effect threshold')
  add(tour,domain,view,'nonempty_usable_contexts',sum(x$usable_attempts>0),'Frozen QA unchanged')
  add(tour,domain,view,'usable_unknown_context_attempts',sum(x$usable_attempts[x$context_status=='UNKNOWN_OR_NOT_RECORDED']),'Known execution does not establish known context')
  add(tour,domain,view,'observed_unsupported_context_attempts',sum(x$observed_attempts[x$context_status=='UNSUPPORTED']),'No unsupported boundary receives execution credit')
  common<-sum(vapply(split(z,z$context),function(q)all(q$usable_attempts>0)&&all(q$context_status=='RECORDED_OR_NOT_APPLICABLE'),FALSE))
  add(tour,domain,view,'recorded_contexts_present_in_every_match_player',common,paste(players,'match/player perspectives; no claim of exchangeability'))
  add(tour,domain,view,'in_play_plus_errors_minus_attempts',sum(x$in_play+x$errors-x$usable_attempts),'Must be zero; exact algebraic partition')
  add(tour,domain,view,'forced_plus_unforced_minus_errors',sum(x$forced_errors+x$unforced_errors-x$errors),'Must be zero; error categories partition errors')
  add(tour,domain,view,'winners_outside_in_play',sum(pmax(x$winners-x$in_play,0)),'Must be zero; winners nested in in-play')
 }
 for(tour in c('ATP','WTA')) {
  x<-summary[summary$scope=='tour'&summary$tour==tour&summary$view=='role_phase',]
  b<-input$plus[input$plus$tour_file==tour,]
  add(tour,'Rally','role_phase','plus1_attempts_minus_frozen_ledger',sum(x$usable_attempts[x$context=='SERVER_PLUS1'])-sum(b$validated_attempt),'Must be zero; +1 is nested in Rally')
  add(tour,'Rally','role_phase','plus1_errors_minus_frozen_ledger',sum(x$errors[x$context=='SERVER_PLUS1'])-sum(b$attempted_error,na.rm=TRUE),'Must be zero; no fourth factor-total credit')
 }
 do.call(rbind,rows)
}
audit_mcp_opportunity_context<-function(input=context_load()) {
 dictionary<-context_dictionary();execution_check(input)
 x<-context_summary(input,dictionary)
 r<-list(dictionary=dictionary,'context-summary'=x,'coverage-summary'=execution_coverage(input),
  'measurement-checks'=context_measurements(x,input))
 for(k in names(r)) {
  r[[k]]$release<-'MCP_OPPORTUNITY_CONTEXT_1.0.0';r[[k]]$source_release<-'MCP_ACTION_STATES_1.0.0;MCP_EXECUTION_SUMMARIES_1.0.0'
  r[[k]]$revision<-mcp_revision;r[[k]]$sample_label<-'FROZEN_44_MATCH_SAMPLE_ONLY'
  r[[k]]$claim<-'DESCRIPTIVE_CONTEXT_NOT_DIFFICULTY_OR_CAUSAL_SKILL';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_EXPOSED'
  r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
 }
 r
}
context_install<-function(r) {
 mcp_need(identical(names(r),context_outputs),'Context output scope')
 paths<-paste0(context_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored output location required')
 stage<-vapply(paths,function(p)tempfile('.mcp-context-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);context_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing context release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Context installation failed')
 invisible(r)
}
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline context audit takes no arguments')
 r<-audit_mcp_opportunity_context();context_install(r);x<-r[['context-summary']]
 print(x[x$scope=='tour'&x$view%in%c('serve_number','role_phase'),c('tour','view','context','observed_attempts','usable_attempts','errors','error_rate','retention')],row.names=FALSE)
}
