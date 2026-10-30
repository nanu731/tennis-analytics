# Descriptive point accounting only. Reuse frozen verification; execute no runner.
source('R/build_mcp_serve_plus1_protocol.R')
phase_prefix <- 'data/pilot/mcp-point-phase-v1-'
phase_outputs <- c('point-dispositions.csv','match-player-profiles.csv','coverage.csv',
                   'point-ending-prototype.svg','opportunity-prototype.svg')
phase_levels <- c('Serve','Return','Server Serve +1','Later Rally','Administrative','Unresolved')
phase_reaches <- c('Return','Server Serve +1','Later Rally')
phase_specification <- function() {
 lines <- readLines('docs/where-players-win-points-plan.md',warn=FALSE)
 boundary <- match('## Measured prototype',lines)
 mcp_need(!is.na(boundary),'Missing prospective specification boundary')
 lines <- head(lines,boundary-1L)
 while(length(lines)&&tail(lines,1)=='') lines <- head(lines,-1L)
 f <- tempfile(); on.exit(unlink(f)); writeLines(lines,f); mcp_sha(f)
}
phase_demo_ids <- function(e) {
 ids <- vapply(c('ATP','WTA'),function(category) {
  candidates <- e$match_id[e$tour_file==category & e$eligible]
  mcp_need(length(candidates)>0,'No eligible demonstration chart')
  sort(candidates,method='radix')[1L]
 },'')
 ids
}
phase_load <- function() {
 plus_protocol_verify()
 # Freeze demonstration selection from identity and eligibility BEFORE outcomes.
 e <- read.csv(paste0(expand_prefix,'match-eligibility.csv'),stringsAsFactors=FALSE)
 ids <- phase_demo_ids(e)
 input <- plus_protocol_load(); input$demo_ids <- ids; input
}
phase_terminal <- function(t,plus_id,unique_terminal=rep(TRUE,nrow(t))) {
 n <- nrow(t); phase <- rep('Unresolved',n); reason <- rep('UNSUPPORTED_TERMINAL_BOUNDARY',n)
 good <- unique_terminal & t$transition_usable & t$local_boundary_supported &
         !t$authority_conflict & t$post_boundary=='TERMINAL'
 good[is.na(good)] <- FALSE
 physical <- good & t$tennis_action_usable
 put <- function(mask,label) {mask[is.na(mask)]<-FALSE; phase[mask]<<-label; reason[mask]<<-'SUPPORTED_TERMINAL_EVENT'}
 put(physical & t$owner_domain=='Serve' & t$owner_role=='SERVER' &
       t$post_kind %in% c('SERVE','SERVE_FAULT'),'Serve')
 put(physical & t$owner_domain=='Return' & t$owner_role=='RECEIVER' &
       t$post_kind=='STROKE' & t$pre_in_play_strokes==1L,'Return')
 rally <- physical & t$owner_domain=='Rally' & t$post_kind=='STROKE'
 put(rally & t$owner_role=='SERVER' & t$pre_in_play_strokes==2L &
       !is.na(plus_id) & nzchar(plus_id) & t$action_id==plus_id,'Server Serve +1')
 put(rally & t$pre_in_play_strokes>=3L,'Later Rally')
 put(good & t$owner_domain=='ADMIN' & t$post_kind %in%
       c('INCORRECT_CHALLENGE','POINT_PENALTY'),'Administrative')
 reason[!unique_terminal] <- 'MISSING_OR_MULTIPLE_TERMINAL_EVENTS'
 data.frame(terminal_phase=phase,terminal_reason=reason,stringsAsFactors=FALSE)
}
phase_reach <- function(included,observed,known_absent) {
 out <- rep('UNKNOWN',length(included))
 out[included & known_absent & !observed] <- 'KNOWN_ABSENT'
 out[included & observed] <- 'KNOWN_REACHED'
 out
}
phase_points <- function(input) {
 plus_protocol_check(input)
 e<-input$eligibility; p<-input$points; s<-input$states; a<-input$actions; b<-input$plus
 pk<-paste(p$match_id,p$Pt,sep='|'); mi<-match(p$match_id,e$match_id)
 mcp_need(!anyDuplicated(pk)&&!anyNA(mi),'Unique exact inventory point/match joins')
 identity<-unique(s[s$owner_domain=='Serve',c('match_id','server','actor_neutral_slot')])
 ik<-paste(identity$match_id,identity$server,sep='|')
 mcp_need(!anyDuplicated(ik)&&all(identity$actor_neutral_slot%in%c('A','B')),
          'Ambiguous reconciled source server identity')
 mcp_need(all(vapply(split(identity$actor_neutral_slot,identity$match_id),
                  function(z)setequal(z,c('A','B')),FALSE)),'Non-bijective source player mapping')
 server<-match(paste(p$match_id,p$server,sep='|'),ik)
 receiver<-match(paste(p$match_id,p$receiver,sep='|'),ik)
 winner<-match(paste(p$match_id,p$recorded_winner,sep='|'),ik)
 mcp_need(!anyNA(server)&&!anyNA(receiver)&&all(p$receiver!=p$server),
          'Missing server/receiver identity authority')
 valid<-p$tennis_sequence_validated & p$score_status=='PASS'
 mcp_need(all(p$terminal_agrees[valid]) &&
          all(p$recorded_winner[valid]==p$inferred_winner[valid]),'Frozen winner reconciliation failed')
 pi<-match(s$point_id,pk); ai<-match(s$action_id,a$action_id); bi<-match(pk,b$point_id)
 mcp_need(!anyNA(pi)&&!anyNA(ai)&&!anyNA(bi),'Missing frozen point/action/+1 join')
 mcp_need(all(s$point_validated==p$tennis_sequence_validated[pi])&&
          all(s$score_reconciliation_status==p$score_status[pi]),'Frozen QA authority conflict')
 terminal <- which(nzchar(s$post_terminal_status) & !a$is_void[ai])
 # Keep even withheld-point audit labels independent of input row order.
 terminal <- terminal[order(s$point_id[terminal],s$action_id[terminal],method='radix')]
 counts <- tabulate(pi[terminal],nrow(p)); ti<-terminal[match(pk,s$point_id[terminal])]
 t<-s[ti,,drop=FALSE]
 c<-phase_terminal(t,b$plus1_action_id[bi],counts==1L)
 resolved <- valid & c$terminal_phase!='Unresolved'
 expected <- ifelse(p$recorded_winner==p$server,'SERVER','RECEIVER')
 mcp_need(all(t$post_terminal_status[resolved]==p$terminal[resolved])&&
          all(t$post_terminal_winner_role[resolved]==expected[resolved]),
          'Terminal event/recorded winner conflict')
 physical <- s$tennis_action_usable & s$post_kind=='STROKE'
 ret <- physical & s$owner_domain=='Return'
 plus <- physical & s$owner_domain=='Rally' & s$owner_role=='SERVER' & s$pre_in_play_strokes==2L
 later <- physical & s$owner_domain=='Rally' & s$pre_in_play_strokes>=3L
 plus[is.na(plus)]<-FALSE;later[is.na(later)]<-FALSE
 mcp_need(setequal(s$action_id[plus],b$plus1_action_id[b$usable_attempt]),
          'Independent error-inclusive +1 reconciliation')
 rcount<-tabulate(pi[ret],nrow(p)); pcount<-tabulate(pi[plus],nrow(p)); lcount<-tabulate(pi[later],nrow(p))
 mcp_need(all(rcount<=1)&&all(pcount<=1),'Duplicate Return/+1 actions')
 bad<-!s$local_boundary_supported | s$authority_conflict;bad[is.na(bad)]<-TRUE
 complete<-valid & counts==1L & c$terminal_phase!='Unresolved' & tabulate(pi[bad],nrow(p))==0L
 included<-e$eligible[mi] & valid
 x<-data.frame(point_id=pk,match_id=p$match_id,Pt=p$Pt,category=e$tour_file[mi],
  source_date=e$source_date[mi],surface=e$Surface[mi],player_a=e$player_a[mi],player_b=e$player_b[mi],
  point_file=p$point_file,source_row=p$source_row,raw_first=p$raw_first,raw_second=p$raw_second,
  source_server=p$server,source_receiver=p$receiver,recorded_winner=p$recorded_winner,
  server_slot=identity$actor_neutral_slot[server],receiver_slot=identity$actor_neutral_slot[receiver],
  winner_slot=ifelse(is.na(winner),'UNKNOWN',identity$actor_neutral_slot[winner]),
  completion_eligible=e$eligible[mi],completion_exclusion=e$exclusion_reasons[mi],
  qa_valid=valid,included=included,parse_status=p$parse_status,score_status=p$score_status,
  qa_reasons=paste(p$issues,p$score_reasons,sep='|'),explicit_unknowns=p$explicit_unknowns,
  disposition=ifelse(!e$eligible[mi],'COMPLETION_EXCLUDED',ifelse(valid,'INCLUDED','QA_WITHHELD')),
  raw_terminal=p$terminal,terminal_action_id=ifelse(is.na(ti),'',s$action_id[ti]),
  terminal_owner=ifelse(is.na(ti),'UNKNOWN',s$owner_domain[ti]),
  terminal_phase=ifelse(included,c$terminal_phase,'Unresolved'),
  terminal_reason=ifelse(included,c$terminal_reason,ifelse(!e$eligible[mi],'COMPLETION_EXCLUDED','WHOLE_POINT_QA_WITHHELD')),
  return_reach=phase_reach(included,rcount>0,p$return_observation=='KNOWN_ABSENT'),
  plus1_reach=phase_reach(included,pcount>0,b$disposition[bi]=='KNOWN_ABSENT'),
  later_rally_reach=phase_reach(included,lcount>0,complete & lcount==0),
  return_action_id=s$action_id[which(ret)[match(pk,s$point_id[ret])]],
  plus1_action_id=b$plus1_action_id[bi],later_rally_attempts=ifelse(included,lcount,NA_integer_),
  plus1_attempted_error=ifelse(included & pcount>0,b$attempted_error[bi],NA),stringsAsFactors=FALSE)
 x$return_action_id[is.na(x$return_action_id)]<-''
 x$reach_reason<-ifelse(!included,'EXCLUDED_OR_WHOLE_POINT_QA_WITHHELD',
                       ifelse(complete,'SUPPORTED_FULL_SEQUENCE','INCOMPLETE_SUPPORTED_BOUNDARY'))
 mcp_need(all(x$server_slot!=x$receiver_slot)&&all(x$terminal_phase[x$included]%in%phase_levels),
          'Point perspective/terminal partition failed')
 x<-x[order(x$category,x$match_id,x$Pt,method='radix'),];rownames(x)<-NULL;x
}
phase_perspectives <- function(p) {
 a<-p;b<-p;a$slot<-'A';b$slot<-'B'
 a$player<-a$player_a;b$player<-b$player_b;a$opponent<-a$player_b;b$opponent<-b$player_a
 x<-rbind(a,b);x$role<-ifelse(x$slot==x$server_slot,'SERVER','RECEIVER')
 x$won<-ifelse(x$winner_slot=='UNKNOWN',NA,x$slot==x$winner_slot)
 x[order(x$category,x$match_id,x$slot,x$Pt,method='radix'),]
}
phase_profile_group <- function(g,level) {
 u<-g[g$included,];n<-nrow(u);rows<-list()
 base<-data.frame(aggregation_level=level,category=g$category[1],
  match_id=if(level=='MATCH_PLAYER')g$match_id[1] else 'ALL_MATCHES',player=g$player[1],
  slot=if(level=='MATCH_PLAYER')g$slot[1] else 'NOT_APPLICABLE',
  inventory_matches=length(unique(g$match_id)),eligible_matches=length(unique(g$match_id[g$completion_eligible])),
  usable_matches=length(unique(u$match_id)),opponents=length(unique(g$opponent)),
  first_source_date=min(g$source_date),last_source_date=max(g$source_date),
  inventory_points=nrow(g),completion_excluded_points=sum(!g$completion_eligible),
  qa_withheld_points=sum(g$completion_eligible & !g$qa_valid),all_qa_points=n,
  qa_retention=execution_ratio(n,nrow(g)),stringsAsFactors=FALSE)
 for(phase in phase_levels) {
  z<-u[u$terminal_phase==phase,];unknown<-sum(is.na(z$won))
  rows[[length(rows)+1L]]<-cbind(base,data.frame(measure='POINT_ENDING',role='ALL',phase,
   role_qa_points=n,phase_points=nrow(z),wins=sum(z$won,na.rm=TRUE),losses=sum(!z$won,na.rm=TRUE),
   unknown_winners=unknown,win_share=if(unknown)NA_real_ else execution_ratio(sum(z$won),n),
   loss_share=if(unknown)NA_real_ else execution_ratio(sum(!z$won),n),
   phase_share=execution_ratio(nrow(z),n),reached=NA_integer_,known_absent=NA_integer_,unknown_reach=NA_integer_,
   reach_share=NA_real_,conditional_win_rate=NA_real_,conditional_denominator=NA_integer_,stringsAsFactors=FALSE))
 }
 fields<-c('Return'='return_reach','Server Serve +1'='plus1_reach','Later Rally'='later_rally_reach')
 for(role in c('ALL','SERVER','RECEIVER'))for(phase in phase_reaches) {
  v<-if(role=='ALL')u else u[u$role==role,];reach<-v[[fields[[phase]]]]
  z<-v[reach=='KNOWN_REACHED',];unknown<-sum(is.na(z$won))
  rows[[length(rows)+1L]]<-cbind(base,data.frame(measure='REACH',role,phase,role_qa_points=nrow(v),
   phase_points=NA_integer_,wins=sum(z$won,na.rm=TRUE),losses=sum(!z$won,na.rm=TRUE),unknown_winners=unknown,
   win_share=NA_real_,loss_share=NA_real_,phase_share=NA_real_,reached=nrow(z),
   known_absent=sum(reach=='KNOWN_ABSENT'),unknown_reach=sum(reach=='UNKNOWN'),
   reach_share=execution_ratio(nrow(z),n),conditional_win_rate=if(unknown)NA_real_ else execution_ratio(sum(z$won),nrow(z)),
   conditional_denominator=nrow(z),stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
phase_profiles <- function(p) {
 x<-phase_perspectives(p);rows<-list()
 for(level in c('MATCH_PLAYER','POOLED_PLAYER')) {
  key<-if(level=='MATCH_PLAYER')paste(x$category,x$match_id,x$slot,sep='|') else paste(x$category,x$player,sep='|')
  groups<-split(seq_len(nrow(x)),key)
  for(ii in groups) rows[[length(rows)+1L]]<-phase_profile_group(x[ii,],level)
 }
 y<-do.call(rbind,rows);rownames(y)<-NULL
 y[order(y$aggregation_level,y$category,y$match_id,y$player,y$measure,y$role,match(y$phase,phase_levels),method='radix'),]
}
phase_coverage <- function(p,e,demo) {
 rows<-list()
 make<-function(z,level,id) {
  u<-z[z$included,];ids<-unique(z$match_id);ee<-e[e$match_id%in%ids,]
  r<-data.frame(aggregation_level=level,category=z$category[1],match_id=id,
   demonstration=level=='MATCH' && id%in%demo,inventory_matches=nrow(ee),eligible_matches=sum(ee$eligible),
   excluded_matches=sum(!ee$eligible),source_date=if(level=='MATCH')ee$source_date[1] else '',
   exclusion_reasons=if(level=='MATCH')ee$exclusion_reasons[1] else '',
   inventory_points=nrow(z),included_points=nrow(u),completion_excluded_points=sum(!z$completion_eligible),
   qa_withheld_points=sum(z$completion_eligible & !z$qa_valid),qa_valid_inventory_points=sum(z$qa_valid),
   retention=execution_ratio(nrow(u),nrow(z)),unknown_winner_points=sum(u$winner_slot=='UNKNOWN'),
   explicit_unknown_included_points=sum(nzchar(u$explicit_unknowns)),stringsAsFactors=FALSE)
  for(k in seq_along(phase_levels))r[[paste0('ending_',c('serve','return','server_plus1','later_rally','administrative','unresolved')[k])]]<-sum(u$terminal_phase==phase_levels[k])
  for(f in c('return_reach','plus1_reach','later_rally_reach'))for(state in c('KNOWN_REACHED','KNOWN_ABSENT','UNKNOWN'))
   r[[paste(f,tolower(state),sep='_')]]<-sum(u[[f]]==state)
  r$plus1_attempted_errors<-sum(u$plus1_attempted_error,na.rm=TRUE)
  r
 }
 for(ii in split(seq_len(nrow(p)),p$match_id))rows[[length(rows)+1L]]<-make(p[ii,],'MATCH',p$match_id[ii[1]])
 for(ii in split(seq_len(nrow(p)),p$category))rows[[length(rows)+1L]]<-make(p[ii,],'CATEGORY','ALL_MATCHES')
 y<-do.call(rbind,rows);rownames(y)<-NULL;y[order(y$aggregation_level,y$category,y$match_id,method='radix'),]
}
phase_plot_data <- function(profiles,coverage,demo) {
 x<-profiles[profiles$aggregation_level=='MATCH_PLAYER' & profiles$match_id%in%demo,]
 cv<-coverage[coverage$aggregation_level=='MATCH',];j<-match(x$match_id,cv$match_id)
 category<-ifelse(x$category=='ATP',"Historical men's sample","Historical women's sample")
 x$chart<-paste0(category,'\n',x$match_id,'\nQA ',cv$included_points[j],'/',cv$inventory_points[j],
                 ' (',sprintf('%.1f',100*cv$retention[j]),'%), excluded ',cv$completion_excluded_points[j],
                 ', withheld ',cv$qa_withheld_points[j])
 x$perspective<-paste(x$slot,x$player,sep=': ')
 x$phase<-factor(x$phase,levels=phase_levels);x
}
phase_plots <- function(r) {
 mcp_need(requireNamespace('ggplot2',quietly=TRUE),'Existing ggplot2 required; do not install dependencies')
 x<-phase_plot_data(r[['match-player-profiles']],r$coverage,r$demo_ids)
 theme<-ggplot2::theme_minimal(base_size=11)+ggplot2::theme(
  axis.text.x=ggplot2::element_text(angle=20,hjust=1),strip.text=ggplot2::element_text(size=9),
  plot.title=ggplot2::element_text(face='bold'),plot.caption=ggplot2::element_text(hjust=0,size=9),
  panel.grid.minor=ggplot2::element_blank(),legend.position='bottom')
 z<-x[x$measure=='POINT_ENDING',];w<-z;l<-z;w$series<-'Wins';l$series<-'Losses'
 w$value<-100*w$win_share;l$value<- -100*l$loss_share
 end<-rbind(w,l);end$display<-ifelse(is.na(end$value),0,end$value)
 z$label<-ifelse(is.na(z$phase_share),'Unavailable',paste0('W ',z$wins,' / L ',z$losses))
 ending<-ggplot2::ggplot(end,ggplot2::aes(x=phase,y=display,fill=series))+
  ggplot2::geom_hline(yintercept=0,colour='grey40')+ggplot2::geom_col(width=.7)+
  ggplot2::geom_text(data=z,ggplot2::aes(x=phase,label=label),y=91,inherit.aes=FALSE,size=2.7)+
  ggplot2::facet_wrap(ggplot2::vars(chart,perspective),ncol=2)+
  ggplot2::scale_fill_manual(values=c(Wins='#287B75',Losses='#B75149'))+
  ggplot2::scale_y_continuous(limits=c(-100,100))+
  ggplot2::labs(title='Where points ended: descriptive prototype',subtitle='Wins and losses / all QA-valid points involving each player',
   x=NULL,y='Percent of QA-valid player points (losses shown below zero)',fill=NULL,
   caption='Exclusive terminal categories; server +1 remains Rally-owned. No QA points: unavailable; zero endings with a denominator: 0.\nNeutral-ID demonstrations; no ranking, causal credit, certified tour population or factor qualification.')+theme
 q<-x[x$measure=='REACH',];reach<-q[q$role=='ALL',];reach$panel<-'Point reach / all QA-valid points';reach$value<-100*reach$reach_share
 reach$label<-paste0(reach$reached,' reached\n',reach$known_absent,' absent; ',reach$unknown_reach,' unknown\n/',reach$all_qa_points,' points')
 conditional<-q[q$role!='ALL',];conditional$panel<-ifelse(conditional$role=='SERVER','Conditional wins while serving','Conditional wins while receiving')
 conditional$value<-100*conditional$conditional_win_rate
 conditional$label<-paste0(conditional$wins,'/',conditional$reached,' wins\nUnknown reach ',conditional$unknown_reach)
 reach<-rbind(reach,conditional);reach$display<-ifelse(is.na(reach$value),0,reach$value)
 reach$label[is.na(reach$value)]<-paste0('Unavailable; ',reach$label[is.na(reach$value)])
 reach$row<-paste0(ifelse(reach$category=='ATP','Men: ','Women: '),reach$perspective,'\nQA ',reach$all_qa_points,'/',reach$inventory_points,' (',sprintf('%.1f',100*reach$qa_retention),'%)')
 reach$phase<-factor(reach$phase,levels=phase_reaches)
 reach$panel<-factor(reach$panel,levels=c('Point reach / all QA-valid points','Conditional wins while serving','Conditional wins while receiving'))
 opportunity<-ggplot2::ggplot(reach,ggplot2::aes(x=phase,y=display,fill=phase))+
  ggplot2::geom_col(width=.65)+ggplot2::geom_text(ggplot2::aes(label=label),y=104,size=2.3)+
  ggplot2::facet_grid(row~panel,switch='y')+ggplot2::scale_y_continuous(limits=c(0,120),breaks=c(0,25,50,75,100))+
  ggplot2::scale_fill_manual(values=c('Return'='#416A91','Server Serve +1'='#AD873E','Later Rally'='#735A86'))+
  ggplot2::labs(title='Which phases points reached',subtitle='Overlapping point exposure; conditional win rates keep server and receiver roles separate',
   x=NULL,y='Percent',fill=NULL,caption='Reach applies to the shared point, not both players executing the stroke. Unknown is not absent or a loss.\nCounts pooled before division; QA-selected observed charts only. UNCERTAINTY_NOT_ESTABLISHED.\nSame neutral-ID charts as the point-ending prototype; no ranking or causal credit.')+theme+
  ggplot2::theme(strip.text.y.left=ggplot2::element_text(angle=0,hjust=0,size=8),strip.placement='outside')
 list(ending=ending,opportunity=opportunity)
}
phase_normalize_svg <- function(path) {
 s<-paste(readLines(path,warn=FALSE),collapse='\n')
 ids<-unique(regmatches(s,gregexpr('id="[^"]+"',s))[[1]])
 old<-sub('"$','',sub('^id="','',ids));new<-paste0('phase-id-',seq_along(old))
 # Canonical XML IDs remove device-specific counters without changing geometry.
 for(i in seq_along(old)) {
  s<-gsub(paste0('id="',old[i],'"'),paste0('id="',new[i],'"'),s,fixed=TRUE)
  s<-gsub(paste0('#',old[i],'"'),paste0('#',new[i],'"'),s,fixed=TRUE)
  s<-gsub(paste0('#',old[i],')'),paste0('#',new[i],')'),s,fixed=TRUE)
 }
 writeLines(s,path,useBytes=TRUE)
}
phase_svg <- function(plot,path,width,height) {
 mcp_need(requireNamespace('svglite',quietly=TRUE),'Existing svglite required; do not install dependencies')
 svglite::svglite(path,width=width,height=height,bg='white')
 tryCatch(print(plot),finally=grDevices::dev.off());phase_normalize_svg(path)
}
phase_metadata <- function(x,pin) {
 x$release<-'MCP_POINT_PHASE_PROFILES_1.0.0';x$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0'
 x$revision<-mcp_revision;x$specification_sha256<-pin
 x$claim<-'DESCRIPTIVE_OBSERVED_POINT_PHASES_NOT_SKILL_CAUSAL_OR_FACTORS'
 x$category_basis<-'HISTORICAL_MENS_WOMENS_FILE_CATEGORIES_NOT_CERTIFIED_TOURS'
 x$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';x$official_completion<-'NOT_VERIFIED_FROM_SAVED_EVIDENCE'
 x$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';x$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';x
}
build_mcp_point_phase_profiles <- function(input=phase_load()) {
 pin<-phase_specification();demo<-phase_demo_ids(input$eligibility)
 if(!is.null(input$demo_ids))mcp_need(identical(demo,input$demo_ids),'Neutral demonstration selection changed')
 p<-phase_points(input)
 r<-list('point-dispositions'=p,'match-player-profiles'=phase_profiles(p),coverage=phase_coverage(p,input$eligibility,demo))
 for(k in names(r)) {rownames(r[[k]])<-NULL;r[[k]]<-phase_metadata(r[[k]],pin)}
 r$demo_ids<-demo;r
}
phase_write_release <- function(r,paths) {
 mcp_need(length(paths)==5L,'Exact five output paths required')
 for(k in seq_len(3L))mcp_write(r[[k]],paths[k])
 plots<-phase_plots(r);phase_svg(plots$ending,paths[4],14,9);phase_svg(plots$opportunity,paths[5],16,16)
 invisible(paths)
}
phase_install <- function(r) {
 paths<-paste0(phase_prefix,phase_outputs)
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored flat location required')
 stage<-vapply(paths,function(p)tempfile('.point-phase-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 phase_write_release(r,stage);plus_protocol_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing installed point-phase release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file installation failed')
 invisible(paths)
}
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline descriptive builder takes no arguments')
 r<-build_mcp_point_phase_profiles();phase_install(r)
 print(r$coverage[r$coverage$aggregation_level=='CATEGORY',1:27],row.names=FALSE)
 cat('Demo IDs:',paste(r$demo_ids,collapse=', '),'\n')
}
