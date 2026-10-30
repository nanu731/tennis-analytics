# Selection is context-only and is frozen before point sequences are loaded.
source('R/audit_mcp_opportunity_context.R')
repeat_prefix <- 'data/pilot/mcp-repeated-player-v1-'
repeat_parser_pin <- '3bbd2b28b79619a2dfb94a95be5a40ce00ab02816542cfa9428f2237460f060d'
repeat_state_pin <- 'fc8ac83ed88675267f7bc588626c8e52ed1e7787325a771c5f2560824a514d98'
repeat_outputs <- c('selection-dispositions','player-selection','sample',
 'actions','point-reconciliation','match-reconciliation','reason-summary','decoded-examples','parser-summary',
 'action-states','serve-plus1','state-coverage','field-provenance',
 'return-contexts','history-support','coverage','evaluation-options')
repeat_selection_fields <- c('match_id','player1','player2','Date','Round','Surface','Best of',
 'tour_file','source_row','record_origin','year','event_label','player_a','player_b',
 'duplicate_id','point_files','point_file','points','duplicate_point_rows')
repeat_hash <- function(tour,player) {
 f<-tempfile();on.exit(unlink(f));writeBin(charToRaw(enc2utf8(paste('MCP_REPEATED_PLAYER_V1',tour,player,sep='|'))),f);mcp_sha(f)
}
repeat_verify <- function() {
 context_verify()
 mcp_need(mcp_sha('R/parse_mcp_actions.R')==repeat_parser_pin,'Frozen parser implementation changed')
 mcp_need(mcp_sha('R/build_mcp_action_states.R')==repeat_state_pin,'Frozen state implementation changed')
 invisible(TRUE)
}
repeat_context <- function(x) {
 mcp_need(identical(names(x),repeat_selection_fields),'Context-only selection allowlist required')
 reasons<-rep('',nrow(x));add<-function(mask,why){mask[is.na(mask)]<-TRUE;reasons[mask]<<-ifelse(nzchar(reasons[mask]),paste(reasons[mask],why,sep=';'),why)}
 add(!x$tour_file%in%c('ATP','WTA'),'UNSUPPORTED_TOUR_FILE_CONTEXT')
 add(!x$event_label%in%c('Australian Open','Roland Garros','Wimbledon','US Open'),'TOUR_EVENT_CONTEXT_UNVERIFIED')
 round<-trimws(x$Round)
 add(!round%in%c('R128','R64','R32','R16','QF','SF','F'),'MAIN_DRAW_CONTEXT_UNSUPPORTED')
 add(!mcp_date_valid(x$Date)|substr(x$match_id,1,8)!=x$Date,'INVALID_OR_CONFLICTING_DATE')
 expected<-paste0(x$Date,'-',ifelse(x$tour_file=='ATP','M','W'),'-',gsub(' ','_',x$event_label,fixed=TRUE),'-',round,'-')
 add(!startsWith(x$match_id,expected),'SOURCE_ID_CONTEXT_CONFLICT')
 add(x[['Best of']]!=ifelse(x$tour_file=='ATP','5','3'),'MAJOR_TOUR_FORMAT_CONTEXT_UNSUPPORTED')
 add(!nzchar(x$player1)|!nzchar(x$player2)|x$player1==x$player2|grepl(' / | & ',paste(x$player1,x$player2)),'SINGLES_IDENTITY_AMBIGUOUS')
 add(x$duplicate_id=='TRUE'|duplicated(x$match_id)|duplicated(x$match_id,fromLast=TRUE),'DUPLICATE_METADATA_ID')
 add(!x$Surface%in%c('Hard','Clay','Grass','Carpet'),'SURFACE_CONTEXT_UNSUPPORTED')
 add(x$record_origin!='METADATA','METADATA_IDENTITY_MISSING')
 add(x$point_files!=1|is.na(x$point_file)|!nzchar(x$point_file)|is.na(x$points)|as.numeric(x$points)<=0,'POINT_LINKAGE_MISSING_OR_AMBIGUOUS')
 add(x$duplicate_point_rows!=0,'DUPLICATE_POINT_KEYS')
 expected_file<-paste0('charting-',ifelse(x$tour_file=='ATP','m','w'),'-points-')
 add(!startsWith(x$point_file,expected_file),'POINT_FILE_CONTEXT_CONFLICT')
 x$selection_exclusion_reasons<-reasons;x$context_eligible<-!nzchar(reasons)
 x$context_authority<-'EXACT_MAJOR_EVENT_MAIN_DRAW_ROUND_SOURCE_ID_AND_FORMAT;NOT_INDEPENDENT_CERTIFICATION'
 x
}
repeat_select <- function(x,hash=repeat_hash,cap=20L,matches=5L) {
 d<-repeat_context(x);eligible<-d[d$context_eligible,];players<-list()
 for(tour in c('ATP','WTA')) {
  z<-eligible[eligible$tour_file==tour,]
  for(player in sort(unique(c(z$player1,z$player2)),method='radix')) {
   p<-z[z$player1==player|z$player2==player,];dates<-sort(unique(p$Date),method='radix')
   players[[length(players)+1L]]<-data.frame(tour,player,eligible_matches=nrow(p),eligible_batches=length(dates),
    recurring=length(dates)>=2L,hash_input=paste('MCP_REPEATED_PLAYER_V1',tour,player,sep='|'),selection_hash=hash(tour,player),stringsAsFactors=FALSE)
  }
 }
 p<-do.call(rbind,players);p<-p[order(p$tour,p$selection_hash,p$player,method='radix'),];rownames(p)<-NULL
 p$selected<-FALSE;p$hash_rank<-NA_integer_;p$cutoff_source_date<-'';p$chosen_matches<-0L
 selected_ids<-character();selected_by<-list()
 for(tour in c('ATP','WTA')) {
  ii<-which(p$tour==tour&p$recurring);p$hash_rank[ii]<-seq_along(ii);ii<-head(ii,cap);p$selected[ii]<-TRUE
  for(i in ii) {
   z<-eligible[eligible$tour_file==tour&(eligible$player1==p$player[i]|eligible$player2==p$player[i]),]
   z<-z[order(z$Date,z$match_id,method='radix'),];cut<-z$Date[min(matches,nrow(z))]
   chosen<-z$match_id[z$Date<=cut];p$cutoff_source_date[i]<-cut;p$chosen_matches[i]<-length(chosen)
   selected_ids<-c(selected_ids,chosen)
   for(id in chosen)selected_by[[id]]<-c(selected_by[[id]],p$player[i])
  }
 }
 p$disposition<-ifelse(p$selected,'SELECTED_RECURRING_PLAYER',ifelse(p$recurring,'RECURRING_NOT_WITHIN_HASH_CAP','NOT_RECURRING_ACROSS_BATCHES'))
 d$sample_selected<-d$match_id%in%selected_ids;d$selected_by<-vapply(d$match_id,function(id)
  if(is.null(selected_by[[id]]))'' else paste(sort(selected_by[[id]],method='radix'),collapse=';'),'')
 d<-d[order(d$tour_file,d$source_row,d$match_id,method='radix'),];rownames(d)<-NULL
 s<-d[d$sample_selected,];s<-s[order(s$tour_file,s$Date,s$match_id,method='radix'),];rownames(s)<-NULL
 mcp_need(!anyDuplicated(s$match_id)&&all(s$context_eligible),'Selected identities must be unique and eligible')
 list('selection-dispositions'=d,'player-selection'=p,sample=s)
}
repeat_inventory <- function() {
 repeat_verify();x<-mcp_read(paste0(mcp_prefix,'match-inventory.csv'))
 x<-x[,repeat_selection_fields,drop=FALSE]
 for(k in c('source_row','point_files','points','duplicate_point_rows'))x[[k]]<-as.numeric(x[[k]])
 x
}
repeat_points <- function(sample) {
 parts<-list()
 for(file in sort(unique(sample$point_file),method='radix')) {
  raw<-mcp_read(paste0('data/raw/reference/mcp-stage1-',file));take<-raw$match_id%in%sample$match_id
  z<-raw[take,];z$source_row<-which(take);z$point_file<-file;parts[[file]]<-z
 }
 d<-do.call(rbind,parts);d<-d[order(match(d$match_id,sample$match_id),as.integer(d$Pt)),];rownames(d)<-NULL
 mcp_need(!anyDuplicated(paste(d$match_id,d$Pt,sep='|')),'Selected point linkage conflict')
 mcp_need(identical(as.integer(table(d$match_id)[sample$match_id]),as.integer(sample$points)),'Selected point totals mismatch')
 mcp_need(all(d$Svr%in%c('1','2')),'Invalid selected source server; no invented ownership')
 # Format and source authority are loaded only after sample IDs have been frozen.
 inventory<-mcp_read(paste0(mcp_prefix,'match-inventory.csv'));m<-inventory[match(sample$match_id,inventory$match_id),]
 list(sample=sample,metadata=m,points=d)
}
repeat_check_state_input <- function(input) {
 a<-input$actions;p<-input$points;m<-input$matches
 keys<-paste(p$match_id,p$Pt,sep='|');ak<-paste(a$match_id,a$Pt,sep='|')
 mcp_need(!anyDuplicated(keys)&&!anyDuplicated(a$action_id)&&setequal(p$match_id,m$match_id)&&all(ak%in%keys),'State point/action identities')
 mcp_need(all(a$server%in%1:2)&all(a$receiver==3L-a$server),'State ownership')
 for(ii in split(seq_len(nrow(a)),ak))mcp_need(identical(sort(a$action_index[ii]),seq_along(ii)),'Action order')
 j<-match(ak,keys);mcp_need(all(a$server==p$server[j]),'Server linkage')
 mcp_need(all(a$revision==mcp_revision)&all(a$release=='MCP_STAGE2_1.1.0'),'Frozen parser authority')
 mcp_need(all(as.integer(table(p$match_id)[m$match_id])==m$observed_points),'State match accounting')
}
repeat_states <- function(parser,sample) {
 # Rebind inventory-specific checks/order in an isolated environment only.
 # The committed observable-state builder and every scientific helper are unchanged.
 env<-new.env(parent=environment(build_mcp_action_states))
 env$state_match_order<-sample$match_id;env$state_check_input<-repeat_check_state_input
 build<-build_mcp_action_states;environment(build)<-env
 points<-parser[['point-reconciliation']]
 # Match the historical CSV loader's integer Pt type, without changing any ID.
 mcp_need(identical(as.character(as.integer(points$Pt)),as.character(points$Pt)),'Point index cannot be typed without changing source labels')
 points$Pt<-as.integer(points$Pt)
 r<-build(list(actions=parser$actions,points=points,matches=parser[['match-reconciliation']]))
 # Expose score withholding, which the old 44-match adapter never encountered.
 # Preserve every original state/ledger field and its gate without reinterpretation.
 p<-parser[['point-reconciliation']];key<-paste(p$match_id,p$Pt,sep='|')
 ix<-match(r[['action-states']]$point_id,key)
 r[['action-states']]$score_reconciliation_status<-p$score_status[ix]
 r[['action-states']]$score_reconciliation_reasons<-p$score_reasons[ix]
 r[['action-states']]$audit_withheld_reasons<-r[['action-states']]$transition_withheld_reason
 fail<-p$score_status[ix]!='PASS'
 r[['action-states']]$audit_withheld_reasons[fail]<-paste0(r[['action-states']]$audit_withheld_reasons[fail],';SCORE_RECONCILIATION:',p$score_reasons[ix][fail])
 ix<-match(r[['serve-plus1']]$point_id,key)
 r[['serve-plus1']]$score_reconciliation_status<-p$score_status[ix]
 r[['serve-plus1']]$usable_attempt<-r[['serve-plus1']]$validated_attempt&p$score_status[ix]=='PASS'
 extra<-data.frame(output=c(rep('action-states',3),rep('serve-plus1',2)),
  field=c('score_reconciliation_status','score_reconciliation_reasons','audit_withheld_reasons','score_reconciliation_status','usable_attempt'),
  information_class='RETROSPECTIVE_QA_OR_COVERAGE_NOT_PREDICTOR',
  source=c('Frozen point-reconciliation.score_status','Frozen point-reconciliation.score_reasons',
   'Original transition_withheld_reason plus frozen score reconciliation reasons',
   'Frozen point-reconciliation.score_status','Original validated_attempt AND frozen score_status == PASS; does not redefine parser validation'),
  missing_policy='Unknown/conflicting evidence stays explicit; no repair',stringsAsFactors=FALSE)
 r[['field-provenance']]<-rbind(r[['field-provenance']],extra)
 r
}
repeat_returns <- function(states,sample,players) {
 s<-states[['action-states']];s<-s[s$owner_domain=='Return'&s$post_kind=='STROKE',]
 keys<-context_classify(s[,context_pre_fields,drop=FALSE],'Return')$serve_number
 rows<-list()
 for(i in seq_len(nrow(sample)))for(slot in c('A','B'))for(context in c('FIRST','SECOND','UNKNOWN','UNSUPPORTED')) {
  m<-sample[i,];player<-m[[paste0('player_',tolower(slot))]]
  sel<-s$match_id==m$match_id&s$actor_neutral_slot==slot&keys==context
  z<-s[sel,];u<-z$tennis_action_usable
  rows[[length(rows)+1L]]<-data.frame(tour=m$tour_file,match_id=m$match_id,source_date=format(as.Date(m$Date,'%Y%m%d'),'%Y-%m-%d'),
   batch_key=paste(m$tour_file,m$Date,sep='|'),player,slot,player_a=m$player_a,player_b=m$player_b,event=m$event_label,surface=m$Surface,context,
   selected_player=any(players$selected&players$tour==m$tour_file&players$player==player),
   observed_attempts=nrow(z),usable_attempts=sum(u),withheld_attempts=sum(!u),
   retention=if(nrow(z))sum(u)/nrow(z) else NA_real_,stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
repeat_history <- function(x) {
 x<-x[x$context%in%c('FIRST','SECOND'),];rows<-list()
 for(i in seq_len(nrow(x))) {
  z<-x[i,];prior<-x[x$tour==z$tour&x$player==z$player&x$context==z$context&x$source_date<z$source_date,]
  available<-prior[prior$usable_attempts>0,];dates<-available$source_date
  rows[[i]]<-cbind(z,data.frame(prior_matches=nrow(prior),prior_usable_matches=nrow(available),prior_attempts=sum(prior$usable_attempts),
   prior_batches=length(unique(prior$source_date)),last_prior_source_date=if(nrow(available))max(dates) else '',
   source_gap_days=if(nrow(available))as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else NA_real_,
   support=if(!z$usable_attempts)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(!sum(prior$usable_attempts))'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else 'OBSERVED_CONTEXT_HISTORY_AVAILABLE',stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
repeat_coverage <- function(sample,players,returns,history,states) {
 rows<-list();s<-states[['action-states']]
 groups<-list()
 for(tour in c('ATP','WTA')) {
  groups[[length(groups)+1L]]<-data.frame(scope='tour',tour,player='',match_id='')
  for(player in sort(unique(returns$player[returns$tour==tour]),method='radix'))groups[[length(groups)+1L]]<-data.frame(scope='player',tour,player,match_id='')
  for(id in sample$match_id[sample$tour_file==tour])groups[[length(groups)+1L]]<-data.frame(scope='match',tour,player='',match_id=id)
 }
 groups<-do.call(rbind,groups)
 for(i in seq_len(nrow(groups))) {
  g<-groups[i,];mask<-returns$tour==g$tour
  if(nzchar(g$player))mask<-mask&returns$player==g$player
  if(nzchar(g$match_id))mask<-mask&returns$match_id==g$match_id
  r<-returns[mask,];h<-history[history$tour==g$tour,]
  if(nzchar(g$player))h<-h[h$player==g$player,]
  if(nzchar(g$match_id))h<-h[h$match_id==g$match_id,]
  a<-s[s$tour_file==g$tour&s$match_id%in%r$match_id,]
  if(nzchar(g$player))a<-a[a$actor_name==g$player,]
  supported<-h[h$support=='OBSERVED_CONTEXT_HISTORY_AVAILABLE',]
  rows[[i]]<-cbind(g,data.frame(matches=length(unique(r$match_id)),players=length(unique(r$player)),batches=length(unique(r$source_date)),
   selected_players=length(unique(r$player[r$selected_player])),opponent_only_players=length(unique(r$player[!r$selected_player])),
   observed_return_attempts=sum(r$observed_attempts),usable_return_attempts=sum(r$usable_attempts),withheld_return_attempts=sum(r$withheld_attempts),
   return_retention=if(sum(r$observed_attempts))sum(r$usable_attempts)/sum(r$observed_attempts) else NA_real_,
   transitions=nrow(a),usable_transitions=sum(a$transition_usable),transition_retention=if(nrow(a))mean(a$transition_usable) else NA_real_,
   context_targets=nrow(h),supported_context_targets=nrow(supported),supported_players=length(unique(supported$player)),
   cold_start_context_targets=sum(h$support=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),zero_target_context_targets=sum(h$support=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),
   max_prior_matches=if(nrow(h))max(h$prior_matches) else 0,min_prior_attempts=if(nrow(supported))min(supported$prior_attempts) else NA_real_,
   max_prior_attempts=if(nrow(supported))max(supported$prior_attempts) else NA_real_,
   min_source_gap_days=if(nrow(supported))min(supported$source_gap_days) else NA_real_,max_source_gap_days=if(nrow(supported))max(supported$source_gap_days) else NA_real_,stringsAsFactors=FALSE))
 }
 do.call(rbind,rows)
}
repeat_options <- function(history) {
 rows<-list()
 for(tour in c('ATP','WTA')) {
  all<-history[history$tour==tour,];dates<-sort(unique(all$source_date),method='radix')
  # Two context-only proposals: earliest seed; first half of dates seeded.
  for(option in c('ALL_DATE_EXPANDING','AFTER_HALF_BATCHES_EXPANDING')) {
   cut<-if(option=='ALL_DATE_EXPANDING')dates[1] else dates[max(1L,floor(length(dates)/2))]
   z<-all[all$source_date>cut,];supported<-z[z$support=='OBSERVED_CONTEXT_HISTORY_AVAILABLE',]
   rows[[length(rows)+1L]]<-data.frame(tour,option,seed_end_source_date=cut,
    seed_matches=length(unique(all$match_id[all$source_date<=cut])),evaluation_matches=length(unique(z$match_id)),
    evaluation_batches=length(unique(z$source_date)),context_targets=nrow(z),supported_context_targets=nrow(supported),
    supported_players=length(unique(supported$player)),supported_selected_players=length(unique(supported$player[supported$selected_player])),
    no_prior_context_targets=sum(z$support=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),no_target_context_targets=sum(z$support=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),
    first_evaluation_date=if(nrow(z))min(z$source_date) else '',last_evaluation_date=if(nrow(z))max(z$source_date) else '',
    period_decision='UNSELECTED_PENDING_USER_APPROVAL',adequacy='NOT_ESTABLISHED_NO_THRESHOLD_SELECTED',stringsAsFactors=FALSE)
  }
 }
 do.call(rbind,rows)
}
build_mcp_repeated_sample <- function(inventory=repeat_inventory(),progress=FALSE) {
 selection<-repeat_select(inventory)
 mcp_need(nrow(selection$sample)>0,'No recurring context-supported linked sample; stop before parsing')
 if(progress)cat('Selection frozen:',nrow(selection$sample),'matches;',sum(selection[['player-selection']]$selected),'selected players\n')
 input<-repeat_points(selection$sample)
 if(progress)cat('Pinned points loaded:',nrow(input$points),'\n')
 parser<-action_build(input)
 if(progress)cat('Unchanged parser complete\n')
 states<-repeat_states(parser,selection$sample)
 if(progress)cat('Unchanged state rules complete\n')
 returns<-repeat_returns(states,selection$sample,selection[['player-selection']]);history<-repeat_history(returns)
 names(parser)[names(parser)=='summary']<-'parser-summary';names(states)[names(states)=='coverage-summary']<-'state-coverage'
 r<-c(selection,parser,states,list('return-contexts'=returns,'history-support'=history,
  coverage=repeat_coverage(selection$sample,selection[['player-selection']],returns,history,states),
  'evaluation-options'=repeat_options(history)))
 for(k in names(r)) {
  r[[k]]$component_release<-if('release'%in%names(r[[k]]))r[[k]]$release else 'CONTEXT_ONLY_SELECTION_OR_EXPOSURE'
  r[[k]]$release<-'MCP_REPEATED_PLAYER_1.0.0';r[[k]]$revision<-mcp_revision
  r[[k]]$claim<-'SOURCE_SUPPORTED_MAJOR_CONTEXT_SAMPLE_NOT_REPRESENTATIVE_OR_ADEQUATE'
  r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY'
  r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';rownames(r[[k]])<-NULL
 }
 mcp_need(identical(names(r),repeat_outputs),'Exact broader sample output scope');r
}
repeat_install <- function(r) {
 paths<-paste0(repeat_prefix,names(r),'.csv');mcp_need(identical(names(r),repeat_outputs),'Output scope')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored locations required')
 stage<-vapply(paths,function(p)tempfile('.mcp-repeat-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);repeat_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing repeated-player release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic file installation failed')
 invisible(r)
}
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline sample builder takes no arguments')
 r<-build_mcp_repeated_sample(progress=TRUE);repeat_install(r)
 print(r$coverage[r$coverage$scope=='tour',],row.names=FALSE)
 print(r[['evaluation-options']],row.names=FALSE)
}
