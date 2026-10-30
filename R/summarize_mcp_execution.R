# MCP_EXECUTION_SUMMARIES_1.0.0: frozen sample descriptive counts, no estimation.
source('R/build_mcp_action_states.R')
execution_prefix <- 'data/pilot/mcp-execution-v1-'
execution_outputs <- c('dictionary','execution-summary','breakdowns','coverage-summary')
execution_state_pins <- c(
 'action-states'='bdb2c4030d570aff6d96112ff71471450c7d1a1101368653a764ff2f431b4197',
 'serve-plus1'='6cc4bb3a513ad5e6344f28d8beb9f19ee8d4612d12299f64a5ef511e3f8e7281',
 'coverage-summary'='08768bef445c4b558940b6ad1cb88c470088663802c947074ba2ad46a7bc4e60',
 'field-provenance'='145a7ee0c37b0bf7fab33c81992e3c5c6396e97b02bf5f1f14f6f0695506e5d0')
execution_ratio <- function(n,d)if(d>0)n/d else NA_real_
execution_verify <- function() {
 state_verify()
 for(k in names(execution_state_pins))mcp_need(mcp_sha(paste0(state_prefix,k,'.csv'))==execution_state_pins[[k]],'Frozen observable-state pin failed')
 invisible(TRUE)
}
execution_dictionary <- function() {
 rows<-list();add<-function(domain,statistic,numerator,denominator,unknown_scope,count_only=FALSE) {
  rows[[length(rows)+1L]]<<-data.frame(domain,statistic,numerator_definition=numerator,
   denominator_definition=denominator,unknown_scope,count_only,stringsAsFactors=FALSE)
 }
 add('Serve','observed_attempts','Usable nonvoid SERVE or SERVE_FAULT','Usable physical serve attempts','Withheld observed physical serve attempts',TRUE)
 add('Serve','first_serve_faults','Usable first SERVE_FAULT','Usable physical first-serve attempts','Withheld observed first-serve attempts')
 for(k in c('double_faults','aces','chart_unreturnable'))add('Serve',k,
  paste('Usable terminal',c(double_faults='DOUBLE_FAULT',aces='ACE',chart_unreturnable='UNRETURNABLE')[[k]]),
  'Fully validated service points','Nonvalidated service points')
 for(domain in c('Return','Rally')) {
  add(domain,'observed_attempts','Usable owned STROKE','Usable owned attempts','Withheld observed owned STROKE',TRUE)
  add(domain,'balls_put_in_play','Usable STROKE without FORCED_ERROR or UNFORCED_ERROR','Usable owned attempts','Withheld observed owned STROKE')
  for(k in c('winners','forced_errors','unforced_errors'))add(domain,k,
   paste('Usable terminal',c(winners='WINNER',forced_errors='FORCED_ERROR',unforced_errors='UNFORCED_ERROR')[[k]]),
   'Usable owned attempts','Withheld observed owned STROKE')
 }
 add('Serve +1','observed_attempts','Validated server-owned Rally ordinal-three actions','Validated +1 attempts','Unvalidated prefixes plus unknown opportunities',TRUE)
 add('Serve +1','attempted_errors','Validated +1 FORCED_ERROR or UNFORCED_ERROR','Validated +1 attempts','Unvalidated prefixes plus unknown opportunities')
 do.call(rbind,rows)
}
execution_load <- function() {
 execution_verify()
 read<-function(p)read.csv(p,stringsAsFactors=FALSE,na.strings='NA',check.names=FALSE)
 list(states=read(paste0(state_prefix,'action-states.csv')),
  plus=read(paste0(state_prefix,'serve-plus1.csv')),
  sample=mcp_read(paste0(mcp_prefix,'prototype-sample.csv')))
}
execution_check <- function(input) {
 s<-input$states;b<-input$plus;m<-input$sample
 mcp_need(nrow(s)==38593&&nrow(b)==7333&&nrow(m)==44,'Frozen inventory totals')
 mcp_need(!anyDuplicated(s$action_id)&&!anyDuplicated(b$point_id)&&!anyDuplicated(m$match_id),'Duplicate input identity')
 mcp_need(setequal(s$point_id,b$point_id)&&setequal(b$match_id,m$match_id),'Frozen sample/point linkage')
 j<-match(s$point_id,b$point_id);k<-match(s$match_id,m$match_id)
 mcp_need(all(s$match_id==b$match_id[j])&&all(s$server==b$server[j])&&
  all(s$tour_file==b$tour_file[j])&&all(s$point_validated==b$point_parse_status[j]%in%c('PARSED','PARSED_WITH_EXPLICIT_UNKNOWNS')),'Point authority/ownership linkage')
 mcp_need(all(s$release=='MCP_ACTION_STATES_1.0.0')&&all(b$release=='MCP_ACTION_STATES_1.0.0')&&
  all(s$revision==mcp_revision)&&all(s$tour_file==m$tour_file[k]),'Release authority')
 mcp_need(all(s$owner_domain%in%c('Serve','Return','Rally','ADMIN','UNRESOLVED')),'Unsupported owner')
 physical<-s$post_kind%in%c('SERVE','SERVE_FAULT','STROKE')
 mcp_need(all(s$tennis_action_usable==(s$transition_usable&physical))&&
  !any(s$transition_usable&!s$point_validated),'No prefix promotion or admin credit')
 mcp_need(all(s$owner_domain[s$post_kind%in%c('SERVE','SERVE_FAULT')]=='Serve')&&
  all(s$owner_domain[s$post_kind=='STROKE']%in%c('Return','Rally')),'Unique domain ownership')
 owned<-physical;expected<-ifelse(s$actor_neutral_slot=='A',m$player_a[k],m$player_b[k])
 mcp_need(all(s$actor_neutral_slot[owned]%in%c('A','B'))&&all(s$actor_name[owned]==expected[owned]),'Exact neutral player identity')
 mcp_need(all(s$owner_role[s$owner_domain=='Serve']=='SERVER')&&all(s$owner_role[s$owner_domain=='Return']=='RECEIVER'),'Serve/Return perspective')
 v<-b$validated_attempt;ix<-match(b$plus1_action_id[v],s$action_id)
 independent_plus<-s$action_id[s$tennis_action_usable&s$owner_domain=='Rally'&s$owner_role=='SERVER'&s$pre_in_play_strokes==2]
 mcp_need(setequal(independent_plus,b$plus1_action_id[v]),'Every validated +1 action must be accounted for')
 mcp_need(!anyNA(ix)&&!anyDuplicated(ix)&&all(s$tennis_action_usable[ix]&s$owner_domain[ix]=='Rally'&
  s$owner_role[ix]=='SERVER'&s$pre_in_play_strokes[ix]==2)&&all(s$point_id[ix]==b$point_id[v]),'Validated +1 links')
 mcp_need(all(b$attempted_error[v]==s$post_terminal_status[ix]%in%c('FORCED_ERROR','UNFORCED_ERROR'))&&
  all(is.na(b$attempted_error[!v])),'Independent +1 error agreement')
 mcp_need(all(b$disposition%in%c('VALIDATED_ATTEMPT','KNOWN_ABSENT','UNVALIDATED_OBSERVED_PREFIX','UNKNOWN_OPPORTUNITY'))&&
  all(v==(b$disposition=='VALIDATED_ATTEMPT')),'Opportunity disposition partition')
 mcp_need(all(s$post_terminal_status[s$tennis_action_usable&s$post_kind=='STROKE']%in%c('','WINNER','FORCED_ERROR','UNFORCED_ERROR')),'Unsupported stroke outcome')
 invisible(TRUE)
}
execution_groups <- function(input,players=TRUE) {
 m<-input$sample;m<-m[match(state_match_order,m$match_id),];rows<-list()
 add<-function(scope,tour='ALL',match_id='',player='',slot='',year='',event='',surface='') {
  rows[[length(rows)+1L]]<<-data.frame(scope,tour,match_id,player,slot,year,event,surface,stringsAsFactors=FALSE)
 }
 add('ALL');for(t in c('ATP','WTA'))add('tour',t)
 for(i in seq_len(nrow(m))) {
  if(players)for(slot in c('A','B'))add('match_player',m$tour_file[i],m$match_id[i],m[[paste0('player_',tolower(slot))]][i],slot,m$year[i],m$event_label[i],m$Surface[i])
  else add('match',m$tour_file[i],m$match_id[i],year=m$year[i],event=m$event_label[i],surface=m$Surface[i])
 }
 do.call(rbind,rows)
}
execution_subset <- function(input,g) {
 s<-input$states;b<-input$plus
 if(g$tour!='ALL'){s<-s[s$tour_file==g$tour,];b<-b[b$tour_file==g$tour,]}
 if(nzchar(g$match_id)){s<-s[s$match_id==g$match_id,];b<-b[b$match_id==g$match_id,]}
 all_s<-s;all_b<-b
 if(nzchar(g$player)) {
  # Identify the source server's name using Serve-owned rows, never outcomes.
  identity<-unique(all_s[all_s$owner_domain=='Serve',c('server','actor_name')])
  mcp_need(nrow(identity)==2&&!anyDuplicated(identity$server),'Ambiguous source-player identity')
  names_by_server<-setNames(identity$actor_name,identity$server)
  b<-b[names_by_server[as.character(b$server)]==g$player,]
  s<-s[s$actor_name==g$player,]
 }
 list(s=s,b=b,all_s=all_s,all_b=all_b)
}
execution_rows <- function(input,groups,dictionary) {
 rows<-list()
 for(i in seq_len(nrow(groups))) {
  g<-groups[i,];z<-execution_subset(input,g);s<-z$s;b<-z$b
  for(j in seq_len(nrow(dictionary))) {
   d<-dictionary[j,];domain<-d$domain;stat<-d$statistic
   if(domain=='Serve +1') {
    candidates<-sum(b$disposition!='KNOWN_ABSENT');usable<-sum(b$validated_attempt)
    unknown<-sum(b$disposition%in%c('UNVALIDATED_OBSERVED_PREFIX','UNKNOWN_OPPORTUNITY'))
    denom<-usable;num<-if(stat=='observed_attempts')usable else sum(b$attempted_error,na.rm=TRUE)
   } else {
    physical<-if(domain=='Serve')s$post_kind%in%c('SERVE','SERVE_FAULT') else s$post_kind=='STROKE'
    x<-s[s$owner_domain==domain&physical,]
    if(stat=='first_serve_faults')x<-x[x$post_serve_number==1,]
    candidates<-nrow(x);u<-x[x$tennis_action_usable,];usable<-nrow(u);unknown<-candidates-usable;denom<-usable
    num<-switch(stat,observed_attempts=usable,
     first_serve_faults=sum(u$post_kind=='SERVE_FAULT'),
     double_faults=sum(u$post_terminal_status=='DOUBLE_FAULT'),
     aces=sum(u$post_terminal_status=='ACE'),chart_unreturnable=sum(u$post_terminal_status=='UNRETURNABLE'),
     balls_put_in_play=sum(!u$post_terminal_status%in%c('FORCED_ERROR','UNFORCED_ERROR')),
     winners=sum(u$post_terminal_status=='WINNER'),forced_errors=sum(u$post_terminal_status=='FORCED_ERROR'),
     unforced_errors=sum(u$post_terminal_status=='UNFORCED_ERROR'))
    if(domain=='Serve'&&stat%in%c('double_faults','aces','chart_unreturnable')) {
     candidates<-nrow(b);usable<-sum(b$point_parse_status%in%c('PARSED','PARSED_WITH_EXPLICIT_UNKNOWNS'))
     unknown<-candidates-usable;denom<-usable
    }
   }
   rows[[length(rows)+1L]]<-cbind(g,data.frame(domain,statistic=stat,numerator=num,denominator=denom,
    rate=if(d$count_only)NA_real_ else execution_ratio(num,denom),rate_status=if(d$count_only)'COUNT_ONLY' else if(!denom)'ZERO_OPPORTUNITY' else 'DEFINED',
    observed_candidate_count=candidates,usable_count=usable,unknown_count=unknown,
    usable_proportion=execution_ratio(usable,candidates),unknown_scope=d$unknown_scope,
    known_plus1_absences=if(domain=='Serve +1')sum(b$disposition=='KNOWN_ABSENT') else NA_integer_,stringsAsFactors=FALSE))
  }
 }
 do.call(rbind,rows)
}
execution_breakdowns <- function(input,groups) {
 rows<-list();labels<-c(n='NET',w='WIDE',d='LONG',x='WIDE_AND_LONG','!'='SHANK')
 for(i in seq_len(nrow(groups))) {
  g<-groups[i,];z<-execution_subset(input,g);s<-z$s;b<-z$b
  add<-function(domain,attribute,values,categories,unknown,withheld,opportunities,retained=opportunities,candidates=opportunities+withheld) {
   known<-!values%in%c('UNKNOWN','UNKNOWN_OR_OMITTED','NOT_RECORDED')
   for(category in categories) {
    missing<-category%in%c('UNKNOWN','UNKNOWN_OR_OMITTED','NOT_RECORDED')
    count<-sum(values==category)
    rows[[length(rows)+1L]]<<-cbind(g,data.frame(domain,attribute,category,count,
     denominator=sum(known),rate=if(missing)NA_real_ else execution_ratio(count,sum(known)),
     rate_status=if(missing)'UNKNOWN_ATTRIBUTE' else if(!sum(known))'ZERO_OPPORTUNITY' else 'DEFINED',
     validated_opportunities=opportunities,unknown_attribute_count=unknown,
     withheld_or_unknown_opportunities=withheld,unknown_count=unknown+withheld,
     retention_numerator=retained,retention_denominator=candidates,
     retention_basis=if(domain=='Serve +1')'Validated attempts / attempt-or-unknown opportunities' else 'Usable domain attempts / observed domain attempts',
     usable_proportion=execution_ratio(retained,candidates),stringsAsFactors=FALSE))
   }
  }
  for(domain in c('Return','Rally')) {
   x<-s[s$owner_domain==domain&s$post_kind=='STROKE',];u<-x[x$tennis_action_usable&x$post_terminal_status%in%c('FORCED_ERROR','UNFORCED_ERROR'),]
   values<-unname(labels[u$post_error_code]);values[is.na(values)]<-'UNKNOWN_OR_OMITTED'
   add(domain,'error_subtype',values,c(unname(labels),'UNKNOWN_OR_OMITTED'),sum(values=='UNKNOWN_OR_OMITTED'),sum(!x$tennis_action_usable),nrow(u),sum(x$tennis_action_usable),nrow(x))
  }
  x<-s[match(b$plus1_action_id[b$validated_attempt],s$action_id),,drop=FALSE]
  values<-x$post_shot_type;values[!values%in%unname(action_shots)]<-'UNKNOWN'
  withheld<-sum(b$disposition%in%c('UNVALIDATED_OBSERVED_PREFIX','UNKNOWN_OPPORTUNITY'))
  add('Serve +1','shot_type',values,c(sort(setdiff(unname(action_shots),'UNKNOWN'),method='radix'),'UNKNOWN'),sum(values=='UNKNOWN'),withheld,nrow(x))
  values<-ifelse(x$post_direction_status=='RECORDED',x$post_direction,ifelse(x$post_direction_status=='NOT_RECORDED','NOT_RECORDED','UNKNOWN'))
  add('Serve +1','direction',values,c('1','2','3','NOT_RECORDED','UNKNOWN'),sum(!values%in%c('1','2','3')),withheld,nrow(x))
 }
 do.call(rbind,rows)
}
execution_coverage <- function(input) {
 groups<-rbind(execution_groups(input,FALSE),execution_groups(input,TRUE)[-(1:3),]);rows<-list()
 for(i in seq_len(nrow(groups))) {
  g<-groups[i,];z<-execution_subset(input,g);a<-z$all_s;p<-z$all_b;s<-z$s;b<-z$b
  rows[[i]]<-cbind(g,data.frame(context_points=nrow(p),validated_context_points=sum(p$point_parse_status%in%c('PARSED','PARSED_WITH_EXPLICIT_UNKNOWNS')),
   context_transitions=nrow(a),usable_context_transitions=sum(a$transition_usable),transition_retention=execution_ratio(sum(a$transition_usable),nrow(a)),
   owned_observed_tennis_attempts=sum(s$post_kind%in%c('SERVE','SERVE_FAULT','STROKE')),
   usable_owned_tennis_attempts=sum(s$tennis_action_usable),withheld_owned_tennis_attempts=sum(s$post_kind%in%c('SERVE','SERVE_FAULT','STROKE')&!s$tennis_action_usable),
   context_unassigned_rows=sum(a$owner_domain=='UNRESOLVED'),context_void_lets=sum(a$post_kind=='LET'),context_administrative_rows=sum(a$owner_domain=='ADMIN'),
   service_points=nrow(b),validated_service_points=sum(b$point_parse_status%in%c('PARSED','PARSED_WITH_EXPLICIT_UNKNOWNS')),
   validated_plus1_attempts=sum(b$validated_attempt),plus1_attempted_errors=sum(b$attempted_error,na.rm=TRUE),
   known_plus1_absences=sum(b$disposition=='KNOWN_ABSENT'),unvalidated_plus1_prefixes=sum(b$disposition=='UNVALIDATED_OBSERVED_PREFIX'),
   unknown_plus1_opportunities=sum(b$disposition=='UNKNOWN_OPPORTUNITY'),stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
summarize_mcp_execution <- function(input=execution_load()) {
 dictionary<-execution_dictionary() # fixed definitions, constructed before any aggregation
 execution_check(input);groups<-execution_groups(input)
 r<-list(dictionary=dictionary,'execution-summary'=execution_rows(input,groups,dictionary),
  breakdowns=execution_breakdowns(input,groups),'coverage-summary'=execution_coverage(input))
 for(k in names(r)) {
  r[[k]]$release<-'MCP_EXECUTION_SUMMARIES_1.0.0';r[[k]]$source_release<-'MCP_ACTION_STATES_1.0.0'
  r[[k]]$revision<-mcp_revision;r[[k]]$sample_label<-'FROZEN_44_MATCH_CHART_SAMPLE_ONLY_NOT_POPULATION_OR_RANKING'
  r[[k]]$claim<-'DESCRIPTIVE_EXECUTION_NOT_ATTRIBUTED_SKILL_OR_VALIDATED_FACTOR'
  r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'
 }
 r
}
execution_install <- function(r) {
 mcp_need(identical(names(r),execution_outputs),'Execution output scope')
 paths<-paste0(execution_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing output ignore required')
 stage<-vapply(paths,function(p)tempfile('.mcp-execution-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);execution_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing execution release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Execution installation failed')
 invisible(r)
}
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline summarizer accepts no arguments')
 r<-summarize_mcp_execution();execution_install(r)
 x<-r[['execution-summary']];print(x[x$scope%in%c('ALL','tour'),c('scope','tour','domain','statistic','numerator','denominator','rate','unknown_count','usable_proportion')],row.names=FALSE)
}
