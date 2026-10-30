source('R/audit_mcp_opportunity_context.R')
checks<-0L;check<-function(x,msg){checks<<-checks+1L;if(!isTRUE(x))stop(msg,call.=FALSE)}
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/audit_mcp_opportunity_context.R','R/test_mcp_opportunity_context.R','docs/mcp-opportunity-context-audit.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
oldfiles<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
oldfiles<-setdiff(oldfiles,allowed);oldfiles<-oldfiles[!grepl('/mcp-opportunity-context-v1-',oldfiles)]
oldpins<-vapply(oldfiles,mcp_sha,'')
input<-context_load();r<-audit_mcp_opportunity_context(input);x<-r[['context-summary']];s<-input$states
check(nrow(r$dictionary)==5&&nrow(x)==15379&&nrow(r[['coverage-summary']])==135,'Exact aggregate scope')
check(length(unique(x$match_id[nzchar(x$match_id)]))==44&&length(unique(paste(x$match_id[x$scope=='match_player'],x$slot[x$scope=='match_player'])))==88,'All match/player perspectives retained')
check(all(x$observed_attempts==x$usable_attempts+x$unknown_execution_count),'Withheld execution never counted as success or failure')
check(all(x$in_play+x$errors==x$usable_attempts)&&all(x$errors==x$forced_errors+x$unforced_errors)&&all(x$winners<=x$in_play),'Exact algebraic dependencies')
check(all(x$error_denominator==x$usable_attempts)&&all(is.na(x$error_rate[x$usable_attempts==0])),'Compatible zero-opportunity denominators')
check(all(is.na(x$retention[x$observed_attempts==0]))&&all(x$retention[x$observed_attempts>0]>=0&x$retention[x$observed_attempts>0]<=1),'Undefined/bounded retention')
check(!any(x$usable_attempts[x$context_status=='UNSUPPORTED']),'Unsupported boundaries withheld')
# Context classification is structurally incapable of reading current/post fields.
pre<-s[,context_pre_fields];check(fails(context_classify(cbind(pre,current_error=s$post_terminal_status),'Rally')),'Extra current information rejected')
check(!any(grepl('error|winner|terminal|post_|raw_',context_pre_fields)),'Allowlist excludes current/later outcomes')
f<-pre[1,,drop=FALSE];f$pre_boundary<-'AWAITING_RETURN';f$pre_next_domain<-'Return';f$pre_serve_number<-1
check(context_classify(f,'Return')$serve_number=='FIRST','First serve fixture')
f$pre_serve_number<-2;check(context_classify(f,'Return')$serve_number=='SECOND','Second serve fixture')
f$pre_serve_number<-NA;check(context_classify(f,'Return')$serve_number=='UNKNOWN','Missing serve fixture stays unknown')
f$pre_boundary<-'TERMINAL';check(context_classify(f,'Return')$serve_number=='UNSUPPORTED','Terminal boundary cannot create opportunity')
f$pre_boundary<-'AWAITING_RALLY_STROKE';f$pre_next_domain<-'Rally';f$pre_in_play_strokes<-2;f$pre_next_actor_role<-'SERVER'
f$pre_incoming_domain<-'Return';f$pre_incoming_shot_type<-'UNKNOWN';f$pre_incoming_direction_status<-'SOURCE_UNKNOWN';f$pre_incoming_depth_status<-'AMBIGUOUS_SOURCE_ZERO'
z<-context_classify(f,'Rally');check(z$role_phase=='SERVER_PLUS1'&&z$preceding_type=='SERVER_PLUS1|UNKNOWN'&&z$preceding_direction=='SERVER_PLUS1|UNKNOWN'&&z$preceding_return_depth=='SERVER_PLUS1|UNKNOWN','Explicit unknown attributes, no spatial inference')
f$pre_in_play_strokes<-3;f$pre_next_actor_role<-'RECEIVER';f$pre_incoming_domain<-'Rally'
check(context_classify(f,'Rally')$role_phase=='RECEIVER_LATER'&&context_classify(f,'Rally')$preceding_return_depth=='RECEIVER_LATER|NOT_APPLICABLE','Later receiver/depth applicability')
f$pre_in_play_strokes<-4;f$pre_next_actor_role<-'SERVER';check(context_classify(f,'Rally')$role_phase=='SERVER_LATER','Later server fixture')
# Independent sequential reconstruction from frozen parser actions, not state helpers.
a<-read.csv(paste0(action_prefix,'actions.csv'),stringsAsFactors=FALSE,na.strings='NA')
for(k in names(a)[vapply(a,is.character,FALSE)])a[[k]][is.na(a[[k]])]<-''
a<-a[order(a$match_id,a$Pt,a$action_index),];ref<-list()
for(ids in split(seq_len(nrow(a)),paste(a$match_id,a$Pt,sep='|'))) {
 q<-a[ids,];pending<-'Serve';actor<-q$server[1];serve<-1L;ordinal<-0L;last<-NULL;broken<-FALSE
 for(i in seq_len(nrow(q))) {
  z<-q[i,];domain<-z$domain
  if(z$kind=='STROKE'&&domain%in%c('Return','Rally')) {
   unsupported<-broken||pending!=domain
   servekey<-if(unsupported)'UNSUPPORTED' else if(serve==1)'FIRST' else 'SECOND'
   phase<-if(unsupported)'UNSUPPORTED' else if(ordinal==2&&actor==z$server)'SERVER_PLUS1' else if(actor==z$server)'SERVER_LATER' else 'RECEIVER_LATER'
   type<-direction<-depth<-'UNSUPPORTED'
   if(!unsupported) {
    type<-if(is.null(last)||!last$shot_type%in%unname(action_shots))'UNKNOWN' else last$shot_type
    direction<-if(last$direction_status=='RECORDED')last$direction else if(last$direction_status=='NOT_RECORDED')'NOT_RECORDED' else 'UNKNOWN'
    depth<-if(last$domain=='Rally')'NOT_APPLICABLE' else if(last$depth_status=='RECORDED')last$return_depth else if(last$depth_status=='NOT_RECORDED')'NOT_RECORDED' else 'UNKNOWN'
   }
   ref[[length(ref)+1L]]<-data.frame(action_id=z$action_id,serve_number=servekey,role_phase=phase,
    preceding_type=paste(phase,type,sep='|'),preceding_direction=paste(phase,direction,sep='|'),preceding_return_depth=paste(phase,depth,sep='|'))
  }
  if(broken)next
  if(z$kind%in%c('LET','FIRST_SERVE_FORFEIT','SERVE','SERVE_FAULT')) {
   if(pending!='Serve'||z$actor!=actor||z$serve_number!=serve){broken<-TRUE;next}
   if(z$kind=='FIRST_SERVE_FORFEIT'||(z$kind=='SERVE_FAULT'&&serve==1))serve<-2L
  }
  if(z$kind=='STROKE'&&(pending!=domain||z$actor!=actor||z$in_play_shot!=ordinal+1||z$serve_number!=serve)){broken<-TRUE;next}
  if(z$kind%in%c('SERVE','STROKE')){ordinal<-ordinal+1L;pending<-if(ordinal==1)'Return' else 'Rally';actor<-3L-z$actor;last<-z}
  if(nzchar(z$terminal)){broken<-TRUE;next}
  if(z$kind%in%c('UNSUPPORTED_SUFFIX','MISSING_SEQUENCE','OUTCOME_ONLY'))broken<-TRUE
 }
}
ref<-do.call(rbind,ref);keys<-list()
for(domain in c('Return','Rally')) {
 z<-s[s$post_kind=='STROKE'&s$owner_domain==domain,];k<-context_classify(z[,context_pre_fields],domain)
 for(view in names(k))check(identical(k[[view]],ref[[view]][match(z$action_id,ref$action_id)]),paste('Independent prior-action reconstruction',domain,view))
 keys[[domain]]<-setNames(ref[,names(k),drop=FALSE],names(k))
}
# Reconstruct every observed/usable/error numerator through independent action keys.
groups<-unique(x[,c('scope','tour','match_id','player')])
for(i in seq_len(nrow(groups))) {
 g<-groups[i,];sel<-rep(TRUE,nrow(s))
 if(g$tour!='ALL')sel<-sel&s$tour_file==g$tour
 if(nzchar(g$match_id))sel<-sel&s$match_id==g$match_id
 if(nzchar(g$player))sel<-sel&s$actor_name==g$player
 z<-s[sel&s$post_kind=='STROKE'&s$owner_domain%in%c('Return','Rally'),];ri<-match(z$action_id,ref$action_id)
 summary<-x[x$scope==g$scope&x$tour==g$tour&x$match_id==g$match_id&x$player==g$player,]
 for(view in unique(summary$view)) {
  parent<-summary[summary$view==view,];mask<-z$owner_domain==parent$domain[1]
  kk<-ref[[view]][ri];cat_levels<-parent$context
  obs<-tabulate(match(kk[mask],cat_levels),length(cat_levels));use<-tabulate(match(kk[mask&z$tennis_action_usable],cat_levels),length(cat_levels))
  err<-tabulate(match(kk[mask&z$tennis_action_usable&z$post_terminal_status%in%c('FORCED_ERROR','UNFORCED_ERROR')],cat_levels),length(cat_levels))
  check(identical(as.integer(parent$observed_attempts),obs)&&identical(as.integer(parent$usable_attempts),use)&&identical(as.integer(parent$errors),err),paste('Independent full context counts',g$scope,g$match_id,view))
  check(abs(sum(parent$observed_composition)-1)<1e-12&&abs(sum(parent$usable_composition)-1)<1e-12,'Context composition partitions domain')
  totals<-input$execution[input$execution$scope==g$scope&input$execution$tour==g$tour&input$execution$match_id==g$match_id&input$execution$player==g$player&input$execution$domain==parent$domain[1]&input$execution$statistic=='observed_attempts',]
  check(sum(parent$usable_attempts)==totals$numerator&&sum(parent$observed_attempts)==totals$observed_candidate_count,'Frozen execution release reconciles each view')
 }
}
for(tour in c('ATP','WTA')) {
 parent<-x[x$scope=='tour'&x$tour==tour,];children<-x[x$scope=='match_player'&x$tour==tour,]
 sumchildren<-aggregate(children[,c('observed_attempts','usable_attempts','errors')],children[,c('view','context')],sum)
 ix<-match(paste(parent$view,parent$context),paste(sumchildren$view,sumchildren$context))
 check(all(parent[,c('observed_attempts','usable_attempts','errors')]==sumchildren[ix,c('observed_attempts','usable_attempts','errors')]),'Compatible counts pool across players, not percentages')
}
c<-r[['coverage-summary']];check(c$context_points[c$scope=='ALL']==7333&&sum(c$context_points[c$scope=='match'])==7333,'All points/withheld/unassigned retained')
check(all(r[['measurement-checks']]$measured[grepl('minus|outside',r[['measurement-checks']]$check)]==0),'Overlap and +1 residuals exactly zero')
# Mutation tests separate context keys from current observations and retrospective QA.
after<-input;after$states$post_terminal_status[after$states$post_kind=='STROKE'&after$states$tennis_action_usable]<-'WINNER'
for(domain in c('Return','Rally'))check(identical(context_classify(input$states[,context_pre_fields],domain),context_classify(after$states[,context_pre_fields],domain)),paste('Current winners/errors cannot change context',domain))
after$states$raw_notes<-'CHANGED';after$states$post_shot_type<-'CHANGED';after$states$post_direction<-'CHANGED'
check(identical(context_classify(s[,context_pre_fields],'Rally'),context_classify(after$states[,context_pre_fields],'Rally')),'Current stroke/Notes absent from context')
# Future/current raw action perturbation passed through the verified pure state helper.
fixture<-function(raw){a<-action_point(raw,'',1)$actions;a$action_index<-seq_len(nrow(a));a$action_id<-paste0('FIX',seq_len(nrow(a)));state_point(a,1)}
u<-fixture('4b27f1*');v<-fixture('4b27f1n@')
check(identical(context_classify(u[,context_pre_fields],'Rally'),context_classify(v[,context_pre_fields],'Rally')),'Current terminal perturbation has no context leakage')
v<-fixture('4b27f1Z');check(identical(context_classify(u[1:3,context_pre_fields],'Rally'),context_classify(v[1:3,context_pre_fields],'Rally')),'Later unsupported suffix cannot alter prior context')
v<-fixture('4f39f1*');check(!identical(context_classify(u[3,context_pre_fields],'Rally'),context_classify(v[3,context_pre_fields],'Rally')),'Earlier incoming stroke positive control')
permuted<-input;for(k in names(permuted))permuted[[k]]<-permuted[[k]][nrow(permuted[[k]]):1,]
z<-audit_mcp_opportunity_context(permuted);check(identical(r,z),'Row/match/action order invariant')
context_install(r);paths<-paste0(context_prefix,context_outputs,'.csv');pins<-vapply(paths,mcp_sha,'')
for(k in names(z)){f<-tempfile();mcp_write(z[[k]],f);check(mcp_sha(f)==pins[[paste0(context_prefix,k,'.csv')]],paste('Byte-identical rerun',k));unlink(f)}
context_install(z);bad<-r;bad[['context-summary']]$errors[1]<-999
check(fails(context_install(bad)),'Differing installed release rejected');check(identical(pins,vapply(paths,mcp_sha,'')),'Rejection preserves outputs')
check(setequal(list.files('data/pilot',pattern='^mcp-opportunity-context-v1-',full.names=TRUE),paths),'Four exact ignored outputs')
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Git ignore coverage')
check(!length(list.files('data/pilot',pattern='^[.]mcp-context-',all.files=TRUE)),'No staging residue')
check(identical(oldpins,vapply(oldfiles,mcp_sha,'')),'Historical artifacts unchanged')
changed<-c(system2('git',c('diff','HEAD','--name-only'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE))
check(all(changed%in%allowed),'Exact tracked scope')
cat(sprintf('PASS: %d focused checks; %d historical files preserved; four byte-identical outputs.\n',checks,length(oldfiles)))
