source('R/summarize_mcp_execution.R')
checks<-0L
check<-function(x,msg){checks<<-checks+1L;if(!isTRUE(x))stop(msg,call.=FALSE)}
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/summarize_mcp_execution.R','R/test_mcp_execution.R','docs/mcp-execution-summary-audit.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
oldfiles<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
oldfiles<-setdiff(oldfiles,allowed);oldfiles<-oldfiles[!grepl('/mcp-execution-v1-',oldfiles)]
old<-setNames(vapply(oldfiles,mcp_sha,''),oldfiles)
input<-execution_load();r<-summarize_mcp_execution(input);s<-input$states;b<-input$plus;m<-input$sample
e<-r[['execution-summary']];d<-r$dictionary;h<-r$breakdowns;c<-r[['coverage-summary']]
check(nrow(d)==17&&!anyDuplicated(paste(d$domain,d$statistic)),'Prospective dictionary has unique statistics')
check(nrow(e)==91*17&&sum(c$scope=='match')==44&&sum(c$scope=='match_player')==88,'All matches and neutral players represented')
check(all(is.na(e$rate[e$rate_status!='DEFINED']))&&all(e$rate[e$rate_status=='DEFINED']>=0&e$rate[e$rate_status=='DEFINED']<=1),'Undefined and finite execution rates')
check(all(e$numerator<=e$denominator)&&all(e$unknown_count==e$observed_candidate_count-e$usable_count),'Known denominators exclude unknown cases')
check(is.na(execution_ratio(0,0))&&execution_ratio(2,5)==0.4,'Zero opportunities undefined')
# Independent reconstruction directly from pinned parser action/point ledgers,
# not summarizer selectors, including all 88 player perspectives.
a<-read.csv(paste0(action_prefix,'actions.csv'),stringsAsFactors=FALSE,na.strings='NA')
p<-read.csv(paste0(action_prefix,'point-reconciliation.csv'),stringsAsFactors=FALSE,na.strings='NA')
for(k in names(a)[vapply(a,is.character,FALSE)])a[[k]][is.na(a[[k]])]<-''
pk<-paste(p$match_id,p$Pt,sep='|');good<-p$tennis_sequence_validated&p$score_status=='PASS'
agood<-good[match(paste(a$match_id,a$Pt,sep='|'),pk)]
groupkeys<-unique(e[,c('scope','tour','match_id','player','slot')])
for(i in seq_len(nrow(groupkeys))) {
 g<-groupkeys[i,];ai<-rep(TRUE,nrow(a));pi<-rep(TRUE,nrow(p))
 if(g$tour!='ALL'){ai<-ai&a$tour_file==g$tour;pi<-pi&p$tour_file==g$tour}
 if(nzchar(g$match_id)){ai<-ai&a$match_id==g$match_id;pi<-pi&p$match_id==g$match_id}
 if(nzchar(g$player)) {
  serveractors<-unique(a[ai&a$domain=='Serve',c('server','actor_name')]);server<-serveractors$server[serveractors$actor_name==g$player]
  ai<-ai&a$actor_name==g$player;pi<-pi&p$server==server
 }
 x<-a[ai,];valid<-agood[ai];q<-e[e$scope==g$scope&e$tour==g$tour&e$match_id==g$match_id&e$player==g$player,]
 for(j in seq_len(nrow(q))) {
  z<-q[j,];physical<-if(z$domain=='Serve')x$kind%in%c('SERVE','SERVE_FAULT') else x$kind=='STROKE'
  sel<-x$domain==z$domain&physical
  if(z$statistic=='first_serve_faults')sel<-sel&x$serve_number==1
  sel[is.na(sel)]<-FALSE;y<-x[sel&valid,]
  den<-nrow(y);unknown<-sum(sel&!valid)
  num<-switch(z$statistic,observed_attempts=nrow(y),first_serve_faults=sum(y$kind=='SERVE_FAULT'),
   double_faults=sum(y$terminal=='DOUBLE_FAULT'),aces=sum(y$terminal=='ACE'),chart_unreturnable=sum(y$terminal=='UNRETURNABLE'),
   balls_put_in_play=sum(!y$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR')),winners=sum(y$terminal=='WINNER'),
   forced_errors=sum(y$terminal=='FORCED_ERROR'),unforced_errors=sum(y$terminal=='UNFORCED_ERROR'),attempted_errors=0)
  if(z$domain=='Serve'&&z$statistic%in%c('double_faults','aces','chart_unreturnable')){den<-sum(pi&good);unknown<-sum(pi&!good)}
  if(z$domain=='Serve +1') {
   xx<-a[ai&a$is_plus1&agood,];den<-nrow(xx)
   num<-if(z$statistic=='observed_attempts')den else sum(xx$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR'))
   unknown<-sum(pi&!good)
  }
  check(z$numerator==num&&z$denominator==den&&z$unknown_count==unknown,paste('Independent parser reconstruction',g$scope,g$match_id,g$slot,z$domain,z$statistic))
 }
}
for(tour in c('ALL','ATP','WTA')) {
 x<-e[e$scope==(if(tour=='ALL')'ALL' else 'tour')&e$tour==tour,]
 v<-function(domain,stat)x$numerator[x$domain==domain&x$statistic==stat]
 for(domain in c('Return','Rally'))check(v(domain,'observed_attempts')==v(domain,'balls_put_in_play')+v(domain,'forced_errors')+v(domain,'unforced_errors'),paste('Disjoint stroke execution partition',tour,domain))
 check(v('Serve +1','observed_attempts')<=v('Rally','observed_attempts'),'Plus1 is Rally subset')
 for(domain in c('Serve','Return','Rally','Serve +1')) {
  for(stat in d$statistic[d$domain==domain]) {
   parent<-x[x$domain==domain&x$statistic==stat,]
   children<-e[e$scope=='match_player'&(tour=='ALL'|e$tour==tour)&e$domain==domain&e$statistic==stat,]
   check(parent$numerator==sum(children$numerator)&&parent$denominator==sum(children$denominator)&&parent$unknown_count==sum(children$unknown_count),'Counts pool before division across match/player rows')
  }
 }
}
all<-c[c$scope=='ALL',]
check(all$context_points==7333&&all$context_transitions==38593&&all$usable_context_transitions==31136&&all$usable_owned_tennis_attempts==30886,'Frozen coverage accounting')
check(all$validated_plus1_attempts==3986&&all$plus1_attempted_errors==724&&all$known_plus1_absences==2251&&all$unvalidated_plus1_prefixes==983&&all$unknown_plus1_opportunities==113,'Exact independent +1 reconciliation')
check(sum(c$context_points[c$scope=='match'])==7333&&sum(c$context_points[c$scope=='tour'])==7333,'All points retained in disjoint coverage tables')
check(round(min(c$transition_retention[c$scope=='match'])*100,2)==8.60&&max(c$transition_retention[c$scope=='match'])==1,'Full retention range preserved')
check(sum(s$tennis_action_usable&s$owner_domain%in%c('ADMIN','UNRESOLVED'))==0&&sum(s$tennis_action_usable&s$post_kind=='LET')==0,'No administrative, void or unsupported action credit')
check(sum(s$tennis_action_usable)==sum(e$numerator[e$scope=='ALL'&e$domain%in%c('Serve','Return','Rally')&e$statistic=='observed_attempts']),'Each action credited exactly once')
for(i in seq_len(nrow(groupkeys))) {
 g<-groupkeys[i,];z<-h[h$scope==g$scope&h$tour==g$tour&h$match_id==g$match_id&h$player==g$player,]
 for(attribute in unique(z$attribute))for(domain in unique(z$domain[z$attribute==attribute])) {
  y<-z[z$attribute==attribute&z$domain==domain,]
  check(sum(y$count)==y$validated_opportunities[1]&&length(unique(y$denominator))==1,'Complete known/unknown attribute partition')
  check(sum(y$count[y$rate_status=='DEFINED'])==y$denominator[1],'Recorded-only attribute denominator')
 }
}
check(all(is.na(h$rate[h$rate_status!='DEFINED'])),'Unknown attributes never assigned rates')
# Empty player-domain opportunities remain represented, never imputed.
zero<-input;zero$states<-zero$states[FALSE,];zero$plus<-zero$plus[FALSE,]
zr<-execution_rows(zero,execution_groups(input)[1,,drop=FALSE],d)
check(nrow(zr)==17&&all(zr$numerator==0&zr$denominator==0&zr$unknown_count==0)&&all(is.na(zr$rate))&&all(is.na(zr$usable_proportion)),'All zero-opportunity rows preserved with undefined rates')
empty<-input;empty$plus$validated_attempt<-FALSE
empty$plus$disposition<-'UNKNOWN_OPPORTUNITY';empty$plus$attempted_error<-NA
check(fails(execution_check(empty)),'Invalid opportunity authority fails closed')
bad<-input;bad$states$action_id[2]<-bad$states$action_id[1];check(fails(execution_check(bad)),'Duplicate actions fail closed')
bad<-input;bad$states$actor_name[1]<-'WRONG';check(fails(execution_check(bad)),'Player identity conflict fails closed')
bad<-input;bad$plus$attempted_error[which(bad$plus$validated_attempt)[1]]<-!bad$plus$attempted_error[which(bad$plus$validated_attempt)[1]];check(fails(execution_check(bad)),'Plus1 disagreement fails closed')
permuted<-input;for(k in names(permuted))permuted[[k]]<-permuted[[k]][nrow(permuted[[k]]):1,]
z<-summarize_mcp_execution(permuted);check(identical(r,z),'Row/match/point permutations invariant')
# QA was frozen upstream. Audit-only raw point strings / Notes cannot select rows.
altered<-input;altered$states$raw_notes<-'AUDIT_ONLY';altered$states$raw_first<-'ALTERED_AUDIT_TEXT'
altered$plus$raw_first<-'ALTERED_AUDIT_TEXT';check(identical(r,summarize_mcp_execution(altered)),'Raw future notation and Notes unused')
check(!any(c('winner','recorded_winner','probability','rating','rank')%in%names(e)),'No point-win estimate, rating or ranking')
execution_install(r);paths<-paste0(execution_prefix,execution_outputs,'.csv');pins<-vapply(paths,mcp_sha,'')
for(k in names(z)){f<-tempfile();mcp_write(z[[k]],f);check(mcp_sha(f)==pins[[paste0(execution_prefix,k,'.csv')]],paste('Byte-identical independent rerun',k));unlink(f)}
execution_install(z);check(identical(pins,vapply(paths,mcp_sha,'')),'Idempotent installation')
bad<-r;bad[['execution-summary']]$numerator[1]<-0;check(fails(execution_install(bad)),'Differing installed release rejected');check(identical(pins,vapply(paths,mcp_sha,'')),'Rejected installation preserves outputs')
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'All outputs ignored')
check(setequal(list.files('data/pilot',pattern='^mcp-execution-v1-',full.names=TRUE),paths),'Exact ignored output scope')
check(!length(list.files('data/pilot',pattern='^[.]mcp-execution-',all.files=TRUE)),'No staging residue')
old<-old[!names(old)%in%allowed];check(identical(old,setNames(vapply(names(old),mcp_sha,''),names(old))),'Historical artifacts unchanged')
changed<-c(system2('git',c('diff','HEAD','--name-only'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE))
check(all(changed%in%allowed),'Exact six-file scope')
cat(sprintf('PASS: %d focused checks; %d historical files preserved; four byte-identical outputs.\n',checks,length(old)))
