source('R/build_mcp_point_phase_profiles.R')
checks<-0L
check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
allowed<-c('R/build_mcp_point_phase_profiles.R','R/test_mcp_point_phase_profiles.R',
 'docs/where-players-win-points-plan.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
old<-setdiff(old,allowed);old<-old[!startsWith(old,phase_prefix)]
oldpins<-setNames(vapply(old,mcp_sha,''),old)
# Isolated boundary fixtures, including nonphysical endings and attempted errors.
t<-data.frame(action_id='a',transition_usable=TRUE,local_boundary_supported=TRUE,
 authority_conflict=FALSE,post_boundary='TERMINAL',tennis_action_usable=TRUE,
 owner_domain='Serve',owner_role='SERVER',post_kind='SERVE',pre_in_play_strokes=0L)
check(phase_terminal(t,'')$terminal_phase=='Serve','Physical terminal Serve')
t$post_kind<-'SERVE_FAULT';check(phase_terminal(t,'')$terminal_phase=='Serve','Terminal double-fault event')
for(kind in c('LET','FIRST_SERVE_FORFEIT')) {
 t$post_kind<-kind;check(phase_terminal(t,'')$terminal_phase=='Unresolved','Nonphysical/intermediate event is not a Serve ending')
}
t$post_kind<-'SERVE_FAULT';t$post_boundary<-'AWAITING_SERVE'
check(phase_terminal(t,'')$terminal_phase=='Unresolved','First fault without terminal boundary')
t$post_boundary<-'TERMINAL';t$post_kind<-'STROKE';t$owner_domain<-'Return';t$owner_role<-'RECEIVER';t$pre_in_play_strokes<-1L
check(phase_terminal(t,'')$terminal_phase=='Return','Receiver first response includes terminal errors')
t$owner_domain<-'Rally';t$owner_role<-'SERVER';t$pre_in_play_strokes<-2L
check(phase_terminal(t,'a')$terminal_phase=='Server Serve +1','Error-inclusive first server post-return attempt')
check(phase_terminal(t,'wrong')$terminal_phase=='Unresolved','Missing +1 linkage is not a proxy')
t$owner_role<-'RECEIVER';t$pre_in_play_strokes<-3L
check(phase_terminal(t,'')$terminal_phase=='Later Rally','Receiver later-rally terminal')
t$owner_role<-'SERVER';t$pre_in_play_strokes<-4L
check(phase_terminal(t,'')$terminal_phase=='Later Rally','Server later-rally terminal')
t$owner_domain<-'ADMIN';t$post_kind<-'INCORRECT_CHALLENGE';t$tennis_action_usable<-FALSE
check(phase_terminal(t,'')$terminal_phase=='Administrative','Administrative event does not require physical stroke')
check(phase_terminal(t,'',FALSE)$terminal_phase=='Unresolved','Missing/multiple terminals preserve residual')
t$authority_conflict<-TRUE
check(phase_terminal(t,'')$terminal_phase=='Unresolved','Authority conflict cannot qualify phase')
check(identical(phase_reach(c(TRUE,TRUE,TRUE,FALSE),c(TRUE,FALSE,FALSE,TRUE),c(FALSE,TRUE,FALSE,FALSE)),
                c('KNOWN_REACHED','KNOWN_ABSENT','UNKNOWN','UNKNOWN')),'Unknown and withheld prefix are not absence or success')
check(identical(phase_reach(TRUE,TRUE,TRUE),'KNOWN_REACHED'),'Observed attempt takes precedence over absence')
check(is.na(execution_ratio(0,0)),'Zero denominator undefined')
# Load pinned release; demonstration IDs have already been frozen from eligibility.
i<-phase_load();p<-phase_points(i);e<-i$eligibility;a<-i$actions;s<-i$states;b<-i$plus
check(nrow(p)==43310L&&!anyDuplicated(p$point_id)&&setequal(p$match_id,e$match_id),'All inventoried points and 223 matches once')
check(identical(phase_demo_ids(e),i$demo_ids),'Pre-outcome neutral demonstration selection')
for(category in c('ATP','WTA'))check(i$demo_ids[category]==sort(e$match_id[e$tour_file==category&e$eligible],method='radix')[1L], 'Exact first eligible neutral ID')
check(all(p$included==(p$completion_eligible & p$qa_valid)),'Frozen completion and whole-point QA gates')
check(all(p$return_reach[!p$included]=='UNKNOWN' & p$plus1_reach[!p$included]=='UNKNOWN' & p$later_rally_reach[!p$included]=='UNKNOWN'),'No withheld or excluded reach credit')
check(all(p$winner_slot[p$included]%in%c('A','B')),'All included winners have reconciled identity')
# Independent parser-event reconstruction, using source actor and shot ordinal.
ap<-paste(a$match_id,a$Pt,sep='|');j<-match(ap,p$point_id)
term<-nzchar(a$terminal)&!a$is_void& p$included[j]
tk<-ap[term];check(!anyDuplicated(tk)&&setequal(tk,p$point_id[p$included]),'Independent unique raw terminal event per included point')
at<-a[term,];idx<-match(tk,p$point_id)
expected<-rep('Unresolved',nrow(at))
expected[at$domain=='Serve'&at$kind%in%c('SERVE','SERVE_FAULT')]<-'Serve'
expected[at$domain=='Return'&at$kind=='STROKE'&at$actor==p$source_receiver[idx]&at$in_play_shot==2L]<-'Return'
expected[at$domain=='Rally'&at$kind=='STROKE'&at$is_plus1]<-'Server Serve +1'
late<-at$domain=='Rally'&at$kind=='STROKE'&!at$is_plus1&at$in_play_shot>=4L;late[is.na(late)]<-FALSE
expected[late]<-'Later Rally'
expected[at$domain=='ADMIN'&at$kind%in%c('INCORRECT_CHALLENGE','POINT_PENALTY')]<-'Administrative'
check(identical(expected,p$terminal_phase[idx]),'Independent terminal categories from parser events, not rallyCount')
check(all(at$terminal==p$raw_terminal[idx]),'Raw terminal label preservation')
winning_actor<-at$terminal%in%c('ACE','UNRETURNABLE','WINNER')
losing_actor<-at$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR','DOUBLE_FAULT') | at$kind%in%c('INCORRECT_CHALLENGE','POINT_PENALTY')
check(all(at$actor[winning_actor]==p$recorded_winner[idx[winning_actor]]),'Independent terminal winner events')
check(all(at$actor[losing_actor]!=p$recorded_winner[idx[losing_actor]]),'Independent terminal error/administrative loser events')
physical<-a$kind=='STROKE' & p$included[j]
for(f in c('return_reach','plus1_reach','later_rally_reach')) {
 mask<-if(f=='return_reach')physical&a$domain=='Return' else if(f=='plus1_reach')physical&a$is_plus1 else physical&a$domain=='Rally'&!a$is_plus1&a$in_play_shot>=4L
 mask[is.na(mask)]<-FALSE
 counts<-tabulate(j[mask],nrow(p))
 check(identical(counts>0,p[[f]]=='KNOWN_REACHED'),paste('Independent physical reach:',f))
}
bi<-match(p$point_id,b$point_id)
check(all(p$plus1_reach[p$included&b$disposition[bi]=='KNOWN_ABSENT']=='KNOWN_ABSENT'),'Frozen +1 absence retained')
check(all(p$return_reach[p$included&p$raw_terminal=='UNRETURNABLE']=='KNOWN_ABSENT'),'Collapsed UNRETURNABLE does not invent a Return')
plus_end<-p$included&p$terminal_phase=='Server Serve +1'
check(all(p$terminal_owner[plus_end]=='Rally'&p$terminal_action_id[plus_end]==p$plus1_action_id[plus_end]),'+1 presentation adds no owner credit')
check(any(p$plus1_attempted_error%in%TRUE),'Actual +1 attempted errors counted')
q<-phase_perspectives(p)
check(nrow(q)==2*nrow(p)&&!anyDuplicated(paste(q$point_id,q$slot)),'Exact two neutral player perspectives')
check(all(table(q$point_id)==2L),'Both players retained, including excluded/withheld points')
check(all(q$won[q$included & q$slot=='A']==!q$won[q$included & q$slot=='B']),'Neutral winner complements')
r<-build_mcp_point_phase_profiles(i);x<-r[['match-player-profiles']];cv<-r$coverage
check(nrow(cv)==225L&&sum(cv$aggregation_level=='MATCH')==223L,'Complete match/category coverage')
check(all(cv$inventory_points==cv$included_points+cv$completion_excluded_points+cv$qa_withheld_points),'Full inventory denominator partition')
check(all(rowSums(cv[,grep('^ending_',names(cv)),drop=FALSE])==cv$included_points),'Exclusive six-category ending sum includes residual')
for(f in c('return_reach','plus1_reach','later_rally_reach'))check(all(rowSums(cv[,startsWith(names(cv),paste0(f,'_')),drop=FALSE])==cv$included_points),'All reached/absent/unknown coverage sums')
check(all(x$inventory_points==x$all_qa_points+x$completion_excluded_points+x$qa_withheld_points),'Player coverage denominator partition')
ending<-x[x$measure=='POINT_ENDING',];reach<-x[x$measure=='REACH',]
check(all(ending$phase_points==ending$wins+ending$losses+ending$unknown_winners),'Phase winner residual accounting')
check(all(reach$role_qa_points==reach$reached+reach$known_absent+reach$unknown_reach),'Role reach residual accounting')
check(all(reach$conditional_denominator==reach$reached),'Conditional denominator is reached, not all points')
check(all(is.na(reach$conditional_win_rate[reach$reached==0])),'Zero opportunities never become zero-win rates')
# Independent count pooling for every match and pooled player, including all opponents.
for(level in c('MATCH_PLAYER','POOLED_PLAYER')) {
 z<-x[x$aggregation_level==level,];key<-paste(z$category,z$match_id,z$player,sep='|')
 for(ii in split(seq_len(nrow(z)),key)) {
  zz<-z[ii,];g<-q[q$category==zz$category[1]&q$player==zz$player[1],]
  if(level=='MATCH_PLAYER')g<-g[g$match_id==zz$match_id[1],]
  u<-g[g$included,];ee<-zz[zz$measure=='POINT_ENDING',]
  check(all(zz$all_qa_points==nrow(u)),paste('Independent all-QA denominator',level))
  check(sum(ee$phase_points)==nrow(u),'Complete point partition per player')
  check(all(ee$phase_points==as.integer(table(factor(u$terminal_phase,levels=ee$phase)))),'Independent terminal count reconstruction')
  check(same(ee$phase_share,if(nrow(u))ee$phase_points/nrow(u) else rep(NA_real_,6)),'Counts pooled before division')
  for(role in c('SERVER','RECEIVER'))for(k in seq_along(phase_reaches)) {
   rr<-zz[zz$measure=='REACH'&zz$role==role&zz$phase==phase_reaches[k],]
   v<-u[u$role==role,];f<-c('return_reach','plus1_reach','later_rally_reach')[k]
   reached<-v[[f]]=='KNOWN_REACHED'
   check(rr$reached==sum(reached)&&rr$wins==sum(v$won[reached]),'Independent role-conditioned counts')
  }
 }
}
# Explicit zero-coverage and unknown-winner fixture, without changing frozen eligibility.
g<-q[1,,drop=FALSE];g$included<-FALSE;g$completion_eligible<-FALSE
zz<-phase_profile_group(g,'MATCH_PLAYER')
check(all(is.na(zz$phase_share[zz$measure=='POINT_ENDING']))&&all(is.na(zz$reach_share[zz$measure=='REACH'])),'No QA point denominator stays unavailable')
g$included<-TRUE;g$completion_eligible<-TRUE;g$qa_valid<-TRUE;g$won<-NA;g$terminal_phase<-'Unresolved'
g$return_reach<-g$plus1_reach<-g$later_rally_reach<-'KNOWN_REACHED'
zz<-phase_profile_group(g,'MATCH_PLAYER')
check(zz$unknown_winners[zz$measure=='POINT_ENDING'&zz$phase=='Unresolved']==1,'Unknown terminal winner explicitly retained')
check(all(is.na(zz$conditional_win_rate[zz$measure=='REACH'])),'Unknown winner cannot shrink conditional denominator')
# Input permutations preserve values and neutral demonstration selection.
set.seed(310);perm<-i
for(k in c('eligibility','states','actions','plus','points'))perm[[k]]<-perm[[k]][sample.int(nrow(perm[[k]])),]
p2<-phase_points(perm)
check(identical(p,p2),'Point/action/eligibility row permutations preserve dispositions')
check(identical(phase_demo_ids(perm$eligibility),r$demo_ids),'Demonstration invariant to input order')
check(same(phase_profiles(p2),r[['match-player-profiles']][,setdiff(names(r[['match-player-profiles']]),c('release','sample_release','revision','specification_sha256','claim','category_basis','chronology','official_completion','exposure','uncertainty'))]),'Permutation invariant profiles')
swap<-i;swap$eligibility$player_a<-i$eligibility$player_b;swap$eligibility$player_b<-i$eligibility$player_a
for(k in c('actions','states'))swap[[k]]$actor_neutral_slot<-ifelse(i[[k]]$actor_neutral_slot=='A','B',ifelse(i[[k]]$actor_neutral_slot=='B','A',i[[k]]$actor_neutral_slot))
ps<-phase_points(swap)
check(identical(ps$terminal_phase,p$terminal_phase)&&identical(ps$return_reach,p$return_reach)&&identical(ps$plus1_reach,p$plus1_reach)&&identical(ps$later_rally_reach,p$later_rally_reach),'Slot swap preserves phase/reach ownership')
check(all(ps$winner_slot[p$included]!=p$winner_slot[p$included])&&all(ps$server_slot!=p$server_slot),'Neutral winner/server slots swap exactly')
qs<-phase_perspectives(ps);q0<-q[order(q$category,q$match_id,q$player,q$Pt),];qs<-qs[order(qs$category,qs$match_id,qs$player,qs$Pt),]
check(identical(q0$player,qs$player)&&identical(q0$won,qs$won)&&identical(q0$role,qs$role),'Named-player wins and role unaffected by neutral relabeling')
bad<-i;bad$points$recorded_winner[which(bad$points$tennis_sequence_validated)[1]]<-3L
check(fails(phase_points(bad)),'Source winner conflict stops rather than guessing')
check(fails(plus_protocol_verify_wrong<-{bad<-i;bad$states$actor_name[1]<-'invented';phase_points(bad)}),'Identity conflict stops')
# Two independently reconstructed releases must have identical bytes, including SVGs.
paths1<-vapply(phase_outputs,function(k)tempfile(fileext=paste0('-',k)),'')
paths2<-vapply(phase_outputs,function(k)tempfile(fileext=paste0('-',k)),'')
phase_write_release(r,paths1)
r2<-list('point-dispositions'=phase_metadata(p2,phase_specification()),
 'match-player-profiles'=phase_metadata(phase_profiles(p2),phase_specification()),
 coverage=phase_metadata(phase_coverage(p2,perm$eligibility,r$demo_ids),phase_specification()),demo_ids=r$demo_ids)
phase_write_release(r2,paths2)
for(k in seq_along(paths1))check(mcp_sha(paths1[k])==mcp_sha(paths2[k]),paste('Independent rerun bytes:',phase_outputs[k]))
phase_install(r)
installed<-paste0(phase_prefix,phase_outputs)
for(k in seq_along(installed))check(mcp_sha(installed[k])==mcp_sha(paths1[k]),'Installed release equals independently reconstructed bytes')
check(setequal(system2('git',c('check-ignore','--',shQuote(installed)),stdout=TRUE),installed),'Exactly five ignored outputs')
check(setequal(list.files('data/pilot',pattern='^mcp-point-phase-v1-',full.names=TRUE),installed),'Exact flat release scope')
changed<-r;changed$coverage$inventory_points[1]<-changed$coverage$inventory_points[1]+1L
pins<-vapply(installed,mcp_sha,'');check(fails(phase_install(changed)),'Refuse differing installed release before mutation')
check(identical(vapply(installed,mcp_sha,''),pins),'Failed differing install leaves all five files unchanged')
for(f in names(oldpins))check(mcp_sha(f)==oldpins[[f]],paste('Historical preservation:',f))
unlink(c(paths1,paths2))
cat('PASS:',checks,'focused and release-integrity checks.\n')
print(cv[cv$aggregation_level=='CATEGORY',c('category','inventory_matches','eligible_matches','inventory_points','included_points','completion_excluded_points','qa_withheld_points','retention','ending_serve','ending_return','ending_server_plus1','ending_later_rally','ending_administrative','ending_unresolved')],row.names=FALSE)
