# Versioned descriptive extension; historical runners are only sourced, not executed.
source('R/build_mcp_modern_point_phase_profiles.R')
ctx_prefix <- 'data/pilot/mcp-modern-point-context-v1-'
ctx_outputs <- c('point-dispositions','match-player-profiles','phase-terminal-profiles','coverage')
ctx_types <- c('Ace','Double fault','Other annotated winner','Forced error','Unforced error',
 'Administrative ending','Other supported ending','Unknown or unsupported classification')
ctx_pins <- c('selection-dispositions.csv'='c50ff33f8fccdfa8583fd72f18ce52c1778e6f4f0de160f4d80141bc65233b19','point-dispositions.csv'='150cf5359a231e7ee4aaa0be70c1a9cd6962fded577f838d60d82a0907670f1f',
 'actions.csv'='f7848bc4f2fb84251d0088b7d6e1f1b71ee9eb0bf0ce478731863e3b55f024b5',
 'match-completion.csv'='960723784f764a6ab0b753ac54af32d5080c5a256f41dfd93f7f3297baf9ebf4')
ctx_spec <- function() {
 z<-readLines('docs/modern-point-context-extension.md',warn=FALSE)
 z<-head(z,match('## Measured extension',z)-1L);while(tail(z,1)=='')z<-head(z,-1)
 f<-tempfile();on.exit(unlink(f));writeLines(z,f);mcp_sha(f)
}
ctx_verify <- function() {
 stopifnot(ctx_spec()=='9d6066b62effcf224219c7bb07cfe8fc83bad2660439c13d382df1fb36d62c7f')
 modern_verify();paths<-paste0(modern_prefix,names(ctx_pins))
 stopifnot(identical(unname(vapply(paths,mcp_sha,'')),unname(ctx_pins)))
 invisible(TRUE)
}
ctx_source_bp <- function(score,tb) {
 out<-rep(NA,length(score));good<-!is.na(tb)&!is.na(score)
 ordinary<-good&!tb&score%in%c('0-0','0-15','0-30','0-40','15-0','15-15','15-30','15-40',
 '30-0','30-15','30-30','30-40','40-0','40-15','40-30','40-40','AD-40','40-AD')
 out[ordinary]<-score[ordinary]%in%c('0-40','15-40','30-40','40-AD')
 out[good&tb&grepl('^[0-9]+-[0-9]+$',score)]<-FALSE;out
}
ctx_replay <- function(d,best,format_code) {
 # Capture before the existing replay reads current PtWinner. No transition rule is changed.
 f<-action_score_replay;b<-body(f);loop<-which(vapply(as.list(b),function(x)is.call(x)&&identical(x[[1]],as.name('for')),FALSE))
 stopifnot(length(loop)==1L);steps<-as.list(b[[loop]][[4]])
 at<-which(vapply(steps,function(x)is.call(x)&&identical(x[[1]],as.name('<-'))&&identical(x[[2]],as.name('winner')),FALSE))
 stopifnot(length(at)==1L)
 capture<-quote(snapshots[[j]] <<- list(server=server,tiebreak=tb,expected_score=score,
  replay_break_point=if(tb)FALSE else gp[rc]+1L>=4L && gp[rc]+1L-gp[sv]>=2L))
 b[[loop]][[4]]<-as.call(append(steps,list(capture),after=at-1L));body(f)<-b
 env<-new.env(parent=environment(f));env$snapshots<-vector('list',nrow(d));environment(f)<-env
 independent<-action_score_replay(d,best,format_code);result<-f(d,best,format_code)
 stopifnot(identical(result,independent))
 out<-data.frame(replay_status=independent$points$score_status,replay_reason=independent$points$score_reasons,
  replay_server=NA_integer_,tiebreak=NA,expected_score=NA_character_,replay_break_point=NA)
 for(i in seq_len(nrow(d)))if(!is.null(env$snapshots[[i]]))out[i,3:6]<-env$snapshots[[i]]
 source<-ctx_source_bp(d$Pts,out$tiebreak)
 prefix<-cumprod(out$replay_status=='PASS')==1L
 valid<-prefix & !is.na(source)&!is.na(out$replay_break_point)&source==out$replay_break_point
 valid[is.na(valid)]<-FALSE
 out$source_break_point<-source;out$break_point<-ifelse(valid,source,NA)
 out$context_status<-ifelse(valid,'KNOWN',ifelse(out$replay_status!='PASS','UNSUPPORTED_OR_CONFLICT','UNRESOLVED_PREFIX_OR_STATE'))
 out
}
ctx_terminal_actions <- function(ids,path=paste0(modern_prefix,'actions.csv')) {
 # Stream the large frozen action ledger; retain terminal IDs only, without re-parsing notation.
 con<-file(path,'r');on.exit(close(con));header<-readLines(con,n=1);parts<-list()
 repeat {
  lines<-readLines(con,n=20000,warn=FALSE);if(!length(lines))break
  z<-read.csv(text=paste(c(header,lines),collapse='\n'),colClasses='character',check.names=FALSE,na.strings=NULL)
  z<-z[z$action_id%in%ids,c('action_id','actor_neutral_slot','terminal','raw_token','domain')]
  if(nrow(z))parts[[length(parts)+1L]]<-z
 }
 x<-do.call(rbind,parts);stopifnot(!anyDuplicated(x$action_id));x
}
ctx_terminal <- function(raw,linked,actor) {
 mapping<-c(ACE='Ace',DOUBLE_FAULT='Double fault',WINNER='Other annotated winner',
 FORCED_ERROR='Forced error',UNFORCED_ERROR='Unforced error',OUTCOME_ONLY='Administrative ending',
 POINT_PENALTY='Administrative ending',INCORRECT_CHALLENGE='Administrative ending',UNRETURNABLE='Other supported ending')
 type<-unname(mapping[raw]);type[is.na(type)]<-tail(ctx_types,1)
 valid<-!is.na(linked)&linked==raw
 # Outcome-only endings may have no stroke; they stay explicitly nonphysical.
 valid[raw=='OUTCOME_ONLY']<-TRUE
 type[!valid]<-tail(ctx_types,1)
 physical<-type%in%c('Ace','Double fault','Other annotated winner','Forced error','Unforced error','Other supported ending')
 actor[!physical]<-ifelse(type[!physical]=='Administrative ending','NONPHYSICAL','UNRESOLVED')
 actor[is.na(actor)|!nzchar(actor)]<-'UNRESOLVED'
 data.frame(ending_type=type,terminal_actor_slot=actor,ending_status=ifelse(type==tail(ctx_types,1),'UNKNOWN','SUPPORTED'))
}
ctx_perspective <- function(type,actor,slot) {
 physical<-actor%in%c('A','B');side<-ifelse(actor==slot,'Selected player','Opponent')
 event<-ifelse(type%in%c('Ace','Other annotated winner'),'winner',ifelse(type%in%c('Double fault','Forced error','Unforced error'),'error','supported ending'))
 ifelse(!physical,ifelse(actor=='NONPHYSICAL','Nonphysical','Unresolved actor'),paste(side,event))
}
ctx_tables <- function(p) {
 slim<-p[,c('point_id','match_id','Pt','category','source_date','player_a','player_b','server_slot','winner_slot',
 'completion_eligible','qa_valid','included','terminal_phase','return_reach','plus1_reach','later_rally_reach',
 'break_point','context_status','ending_type','ending_status','terminal_actor_slot')]
 x<-phase_perspectives(slim);x$actor_perspective<-ctx_perspective(x$ending_type,x$terminal_actor_slot,x$slot)
 profiles<-types<-coverage<-list()
 for(level in c('MATCH_PLAYER','POOLED_PLAYER')) {
  key<-if(level=='MATCH_PLAYER')paste(x$category,x$match_id,x$slot,sep='|') else paste(x$category,x$player,sep='|')
  for(ii in split(seq_len(nrow(x)),key)) {
   g<-x[ii,];u<-g[g$included,];base<-data.frame(aggregation_level=level,category=g$category[1],
    match_id=if(level=='MATCH_PLAYER')g$match_id[1] else 'ALL_MATCHES',player=g$player[1])
   cv<-cbind(base,data.frame(inventory_points=nrow(g),included_points=nrow(u),
    inventory_break_points=sum(g$break_point,na.rm=TRUE),
    completion_excluded_break_points=sum(!g$completion_eligible & g$break_point,na.rm=TRUE),
    qa_withheld_break_points=sum(g$completion_eligible & !g$qa_valid & g$break_point,na.rm=TRUE),
    score_known_inventory=sum(g$context_status=='KNOWN'),score_unknown_inventory=sum(g$context_status!='KNOWN'),
    included_score_unknown=sum(u$context_status!='KNOWN'),included_break_points=sum(u$break_point,na.rm=TRUE),
    break_points_faced=sum(u$break_point & u$role=='SERVER',na.rm=TRUE),
    break_opportunities_receiving=sum(u$break_point & u$role=='RECEIVER',na.rm=TRUE),
    included_ending_unknown=sum(u$ending_status!='SUPPORTED')))
   coverage[[length(coverage)+1L]]<-cv
   for(subset in c('ALL_INCLUDED','BREAK_POINTS')) {
    h<-g;h$included<-g$included & if(subset=='ALL_INCLUDED')TRUE else !is.na(g$break_point)&g$break_point
    pp<-phase_profile_group(h,level);names(pp)[names(pp)=='all_qa_points']<-'subset_points';names(pp)[names(pp)=='qa_retention']<-'subset_inventory_fraction';names(pp)[names(pp)=='usable_matches']<-'subset_usable_matches';pp$subset<-subset;profiles[[length(profiles)+1L]]<-pp
    v<-h[h$included,];denom<-nrow(v)
    if(nrow(v)) {
     k<-paste(v$terminal_phase,v$ending_type,v$actor_perspective,sep='|')
     groups<-split(seq_len(nrow(v)),k);first<-v[vapply(groups,function(jj)jj[1],1L),]
     counts<-lengths(groups);phase_n<-as.integer(table(v$terminal_phase)[first$terminal_phase])
     types[[length(types)+1L]]<-cbind(base[rep(1L,length(groups)),],data.frame(subset,
      phase=first$terminal_phase,ending_type=first$ending_type,actor_perspective=first$actor_perspective,
      points=counts,wins=vapply(groups,function(jj)sum(v$won[jj]),0L),
      losses=vapply(groups,function(jj)sum(!v$won[jj]),0L),subset_denominator=denom,
      phase_denominator=phase_n,subset_share=counts/denom,phase_share=counts/phase_n))
    }
   }
  }
 }
 list('match-player-profiles'=do.call(rbind,profiles),'phase-terminal-profiles'=do.call(rbind,types),coverage=do.call(rbind,coverage))
}
ctx_build <- function() {
 ctx_verify();message('Pinned sources and frozen ledgers verified');spec<-ctx_spec();p<-read.csv(paste0(modern_prefix,'point-dispositions.csv'),stringsAsFactors=FALSE,na.strings=NULL)
 sample<-mcp_read(paste0(modern_prefix,'selection-dispositions.csv'));sample<-sample[sample$sample_selected=='TRUE',];sample$points<-as.numeric(sample$points);input<-repeat_points(sample)
 d<-input$points;meta<-input$metadata;parts<-list();message('Linked source prepoint fields loaded')
 for(ii in split(seq_len(nrow(d)),d$match_id)) {
  z<-d[ii,];m<-meta[match(z$match_id[1],meta$match_id),]
  q<-ctx_replay(z,m[['Best of']],m[['Final TB?']]);q$point_id<-paste(z$match_id,z$Pt,sep='|')
  q$source_prepoint_score<-z$Pts;q$source_prepoint_server<-z$Svr
  parts[[length(parts)+1L]]<-q
 }
 q<-do.call(rbind,parts);stopifnot(!anyDuplicated(q$point_id),setequal(q$point_id,p$point_id))
 q<-q[match(p$point_id,q$point_id),];stopifnot(all(q$replay_status==p$score_status))
 message('Independent replay reconciled');a<-ctx_terminal_actions(unique(p$terminal_action_id));a<-a[match(p$terminal_action_id,a$action_id),]
 t<-ctx_terminal(p$raw_terminal,a$terminal,a$actor_neutral_slot)
 p<-cbind(p,q[,setdiff(names(q),'point_id')],t)
 # Withheld records have no included ending classification credit.
 p$ending_type[!p$included]<-tail(ctx_types,1);p$ending_status[!p$included]<-'WITHHELD'
 p$terminal_actor_slot[!p$included]<-'UNRESOLVED'
 message('Terminal action identities linked');tables<-ctx_tables(p);message('Profiles and coverage built')
 fields<-c('point_id','match_id','Pt','category','source_date','player_a','player_b','server_slot','receiver_slot','winner_slot',
 'completion_eligible','qa_valid','included','disposition','raw_first','raw_second','raw_terminal','terminal_action_id','terminal_phase',
 'source_prepoint_score','source_prepoint_server','replay_status','replay_reason','replay_server','tiebreak','expected_score',
 'source_break_point','replay_break_point','break_point','context_status','ending_type','ending_status','terminal_actor_slot')
 r<-c(list('point-dispositions'=p[,fields]),tables)
 for(k in names(r)) {
  z<-r[[k]];z<-z[do.call(order,c(z[intersect(c('aggregation_level','category','match_id','player','subset','point_id','measure','role','phase','ending_type','actor_perspective'),names(z))],list(method='radix'))),]
  rownames(z)<-NULL;z$release<-'MCP_MODERN_POINT_CONTEXT_1.0.0';z$revision<-mcp_revision;z$specification_sha256<-spec
  z$claim<-'RECORDED_CONTEXT_AND_OUTCOMES_NOT_CAUSAL_ATTRIBUTION';z$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';r[[k]]<-z
 }
 r
}
ctx_install <- function(r,prefix=ctx_prefix) {
 paths<-paste0(prefix,names(r),'.csv');stopifnot(all(vapply(paths,function(p)system2('git',c('check-ignore','-q',shQuote(p)))==0L,FALSE)))
 stage<-vapply(paths,function(p)tempfile('.context-stage-',dirname(p)),'');on.exit(unlink(stage))
 for(i in seq_along(r))mcp_write(r[[i]],stage[i])
 for(i in seq_along(paths))if(file.exists(paths[i]))stopifnot(mcp_sha(paths[i])==mcp_sha(stage[i]))
 for(i in seq_along(paths))if(!file.exists(paths[i]))stopifnot(file.rename(stage[i],paths[i]))
 invisible(paths)
}
if(sys.nframe()==0L){r<-ctx_build();ctx_install(r);print(with(r[['point-dispositions']],table(category,included,context_status)));print(with(subset(r[['point-dispositions']],included),table(category,break_point)));print(with(subset(r[['point-dispositions']],included),table(category,ending_type)))}
