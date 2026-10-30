source('R/build_mcp_modern_point_phase_profiles.R')
checks<-0L
check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
paths<-setNames(paste0(modern_prefix,modern_outputs),modern_outputs)
check(all(file.exists(paths)),'Complete 13-file installed release required')
modern_verify();check(TRUE,'Saved rights, raw/source, notation/state and phase pins')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
allowed<-c('R/build_mcp_modern_point_phase_profiles.R','R/test_mcp_modern_point_phase_profiles.R','docs/modern-point-phase-profiles.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-setdiff(old,allowed);old<-old[!startsWith(old,modern_prefix)];oldpins<-setNames(vapply(old,mcp_sha,''),old)
i<-repeat_inventory();selection<-modern_select(i);sample<-selection$sample;exposure<-modern_exposure(i)
check(nrow(sample)==1261L&&sum(sample$points)==243127L,'Frozen metadata count and point support')
check(all(sample$Date>='20210101'&sample$Date<='20251231')&&all(sample$context_eligible),'Exact selected period/context')
check(!anyDuplicated(sample$match_id),'Unique selected source identities')
check(identical(unname(exposure$display),c('Adrian Mannarino','Ajla Tomljanovic')),'Neutral recurring displays chosen before phase results')
check(all(exposure$players$batches[exposure$players$display_selected]>=2),'Display recurrence is two source batches')
check(identical(modern_select(i)$sample,selection$sample),'Metadata-only selection reproducible')
extra<-i;extra$point_winner<-'injected'
check(fails(modern_select(extra)),'Outcome/phase fields cannot enter context selection allowlist')
collision<-i;take<-match(sample$match_id[1],i$match_id);collision$player_a[take]<-'invented'
check(fails(modern_select(collision)),'Unresolved neutral identity collision stops')
set.seed(619);perm<-i[sample.int(nrow(i)),]
check(identical(modern_select(perm)$dispositions,selection$dispositions)&&identical(modern_select(perm)$sample,sample),'Selection invariant to metadata row order')
check(identical(modern_exposure(perm),exposure),'Player/window metadata invariant to row order')
# Frozen point definition fixtures; no scientific helper is altered.
t<-data.frame(action_id='x',transition_usable=TRUE,local_boundary_supported=TRUE,authority_conflict=FALSE,
 post_boundary='TERMINAL',tennis_action_usable=TRUE,owner_domain='Rally',owner_role='SERVER',post_kind='STROKE',pre_in_play_strokes=2L)
check(phase_terminal(t,'x')$terminal_phase=='Server Serve +1','Error-inclusive +1 remains Rally')
check(phase_terminal(t,'wrong')$terminal_phase=='Unresolved','No invented +1 boundary')
t$owner_role<-'RECEIVER';t$pre_in_play_strokes<-3L
check(phase_terminal(t,'')$terminal_phase=='Later Rally','Later receiver stroke boundary')
t$owner_domain<-'ADMIN';t$post_kind<-'INCORRECT_CHALLENGE';t$tennis_action_usable<-FALSE
check(phase_terminal(t,'')$terminal_phase=='Administrative','Supported nonphysical terminal')
check(identical(phase_reach(c(TRUE,TRUE,FALSE),c(FALSE,TRUE,TRUE),c(FALSE,FALSE,FALSE)),c('UNKNOWN','KNOWN_REACHED','UNKNOWN')),'Unknown/withheld not absent or reached')
check(is.na(execution_ratio(0,0)),'Zero denominator undefined')
 empty<-modern_metadata(data.frame(reason=character()),modern_spec())
 check(nrow(empty)==0L&&all(c('reason','revision','release')%in%names(empty)),'Empty parser-reason exports invent no row')
 aa<-data.frame(match_id='fixture',Pt=1L,kind='STROKE',domain='Rally',in_play_shot=3L,
  actor=1L,action_id=c('candidate-1','candidate-2'),terminal='WINNER')
 pp<-data.frame(match_id='fixture',Pt=1L,tour_file='ATP',year=2024L,surface='Grass',server=1L,
  point_file='fixture',source_row=1L,raw_first='raw',raw_second='raw',tennis_sequence_validated=FALSE,
  parse_status='UNSUPPORTED_OR_UNRESOLVED',plus1_absence_reason='',plus1_observation='KNOWN_PRESENT',
  plus1_validated=FALSE,plus1_error=FALSE,issues='SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT')
 bb<-modern_plus1(aa,pp)
 check(bb$disposition=='UNKNOWN_OPPORTUNITY'&&!bb$observed_prefix&&!bb$validated_attempt&&
  bb$candidate_plus1_action_ids=='candidate-1;candidate-2'&&bb$parser_opportunity_observation=='KNOWN_PRESENT',
  'Duplicate unresolved candidates kept explicitly without picking an action or absence')
 rr<-list('reason-summary'=data.frame(tour_file='ATP',severity='FAILURE',reason='existing',points=1L,matches=1L,release='frozen'))
 ff<-modern_failures(rr,bb,'ATP')
 check(ncol(ff)==5L&&nrow(ff)==2L&&ff$reason[2]=='DUPLICATE_UNVALIDATED_PLUS1_CANDIDATES',
  'Conflict aggregate accepts frozen parser metadata without a column mismatch')
 pp$tennis_sequence_validated<-TRUE
 check(fails(modern_plus1(aa,pp)),'Validated duplicate +1 still fails closed')
p<-read.csv(paths['point-dispositions.csv'],stringsAsFactors=FALSE)
e<-read.csv(paths['match-completion.csv'],stringsAsFactors=FALSE,check.names=FALSE)
x<-read.csv(paths['match-player-profiles.csv'],stringsAsFactors=FALSE)
cov<-read.csv(paths['coverage.csv'],stringsAsFactors=FALSE)
check(nrow(p)==243127L&&!anyDuplicated(p$point_id)&&setequal(p$match_id,sample$match_id),'Every selected point once')
check(nrow(e)==1261L&&setequal(e$match_id,sample$match_id),'All selected completion dispositions retained')
check(all(p$included==(p$completion_eligible&p$qa_valid)),'Unchanged whole-point completion/QA intersection')
check(all(p$return_reach[!p$included]=='UNKNOWN'&p$plus1_reach[!p$included]=='UNKNOWN'&p$later_rally_reach[!p$included]=='UNKNOWN'),'Withheld prefixes earn no reach credit')
check(all(p$winner_slot[p$included]%in%c('A','B')),'Included winner identity reconciles')
check(all(p$server_slot!=p$receiver_slot),'Neutral server/receiver bijection')
# Reconstruct completion gates independently from exported source evidence.
fields<-c('match_id','tour_file','Date','player_a','player_b','event_label','Surface','points','selected_by')
ee<-broader_eligibility(list(sample=e[,fields],evidence=e[,c('match_id','point_sequence_contiguous','starts_at_zero','bad_point_owner','status_note_cues','terminal_evidence')],
 completion=e[,c('match_id','expected_points','observed_points','point_total_agrees','chart_score_complete','score_conflict_points','terminal_conflicts')]))
j<-match(e$match_id,ee$match_id)
check(identical(e$eligible,ee$eligible[j])&&identical(e$exclusion_reasons,ee$exclusion_reasons[j]),'Every frozen completion reason independently reconstructs')
check(all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE'),'No official-completion claim')
# Streaming avoids loading the full action/state corpus together.
stream<-function(path,visit) {
 header<-names(read.csv(path,nrows=0,check.names=FALSE));con<-file(path,'r');on.exit(close(con));readLines(con,n=1L)
 repeat {
  z<-tryCatch(read.csv(con,header=FALSE,col.names=header,nrows=20000L,colClasses='character',na.strings=NULL,check.names=FALSE),
   error=function(e){if(grepl('no lines available',conditionMessage(e),fixed=TRUE))NULL else stop(e)})
  if(is.null(z)||!nrow(z))break
  visit(z)
 }
}
terminal_count<-integer(nrow(p));terminal_phase<-rep('',nrow(p));return_count<-integer(nrow(p));plus_count<-integer(nrow(p));later_count<-integer(nrow(p));plus_errors<-integer(nrow(p));candidate_count<-integer(nrow(p));action_rows<-0L
stream(paths['actions.csv'],function(a) {
 action_rows<<-action_rows+nrow(a);key<-paste(a$match_id,a$Pt,sep='|');j<-match(key,p$point_id)
 check(!anyNA(j),'Streamed parser exact point linkage')
 check(all(a$actor_neutral_slot[a$kind%in%c('SERVE','SERVE_FAULT','STROKE')]%in%c('A','B')),'Physical owner has neutral identity')
 take<-nzchar(a$terminal)&a$is_void=='FALSE'&p$included[j]
 jj<-j[take];at<-a[take,];phase<-rep('Unresolved',nrow(at))
 phase[at$domain=='Serve'&at$kind%in%c('SERVE','SERVE_FAULT')]<-'Serve'
 phase[at$domain=='Return'&at$kind=='STROKE'&at$actor==p$source_receiver[jj]&as.integer(at$in_play_shot)==2L]<-'Return'
 phase[at$domain=='Rally'&at$kind=='STROKE'&at$is_plus1=='TRUE']<-'Server Serve +1'
 late<-at$domain=='Rally'&at$kind=='STROKE'&at$is_plus1=='FALSE'&as.integer(at$in_play_shot)>=4L;late[is.na(late)]<-FALSE
 phase[late]<-'Later Rally';phase[at$domain=='ADMIN'&at$kind%in%c('INCORRECT_CHALLENGE','POINT_PENALTY')]<-'Administrative'
 check(all(phase==p$terminal_phase[jj]),'Independent parser-event terminal boundary')
 check(all(at$terminal==p$raw_terminal[jj]),'Raw terminal preservation')
 winning<-at$terminal%in%c('ACE','UNRETURNABLE','WINNER');losing<-at$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR','DOUBLE_FAULT')|at$kind%in%c('INCORRECT_CHALLENGE','POINT_PENALTY')
 check(all(at$actor[winning]==p$recorded_winner[jj[winning]])&&all(at$actor[losing]!=p$recorded_winner[jj[losing]]),'Independent terminal winner/loser reconciliation')
 terminal_count<<-terminal_count+tabulate(jj,nrow(p));terminal_phase[jj]<<-phase
 physical<-a$kind=='STROKE'&p$included[j]
 ret<-physical&a$domain=='Return';pl<-physical&a$is_plus1=='TRUE';later<-physical&a$domain=='Rally'&a$is_plus1=='FALSE'&as.integer(a$in_play_shot)>=4L;later[is.na(later)]<-FALSE
 return_count<<-return_count+tabulate(j[ret],nrow(p));plus_count<<-plus_count+tabulate(j[pl],nrow(p));later_count<<-later_count+tabulate(j[later],nrow(p))
 plus_errors<<-plus_errors+tabulate(j[pl&a$terminal%in%c('FORCED_ERROR','UNFORCED_ERROR')],nrow(p))
 candidate<-a$kind=='STROKE'&a$domain=='Rally'&as.integer(a$in_play_shot)==3L&as.integer(a$actor)==p$source_server[j];candidate[is.na(candidate)]<-FALSE
 candidate_count<<-candidate_count+tabulate(j[candidate],nrow(p))
})
check(all(terminal_count[p$included]==1L)&&all(terminal_count[!p$included]==0L),'Independent unique included terminal partition')
check(identical(return_count>0,p$return_reach=='KNOWN_REACHED')&&identical(plus_count>0,p$plus1_reach=='KNOWN_REACHED')&&identical(later_count>0,p$later_rally_reach=='KNOWN_REACHED'),'Independent overlapping physical reaches')
check(all(return_count<=1L&plus_count<=1L),'No duplicate Return/+1 credit')
check(all(plus_errors[p$plus1_reach=='KNOWN_REACHED']==as.integer(p$plus1_attempted_error[p$plus1_reach=='KNOWN_REACHED'])),'Independent attempted +1 errors')
state_rows<-0L
stream(paths['action-states.csv'],function(s) {
 state_rows<<-state_rows+nrow(s);j<-match(s$point_id,p$point_id)
 check(!anyNA(j),'Every state linked to inventoried point')
 check(all(s$point_validated==(ifelse(p$qa_valid[j],'TRUE','FALSE')) | s$score_reconciliation_status!='PASS'),'Whole-point state QA or explicit score withholding')
 check(all(s$revision==mcp_revision&s$release==modern_release),'State revision/component release authority')
})
check(state_rows==action_rows,'Exact parser/state action accounting')
stream(paths['serve-plus1.csv'],function(b) {
 j<-match(b$point_id,p$point_id);check(!anyNA(j),'Every +1 point linked')
 usable<-b$usable_attempt=='TRUE'&p$completion_eligible[j]
 check(all((p$plus1_reach[j]=='KNOWN_REACHED')==usable),'Frozen +1 attempt mask independent reconciliation')
 check(all(p$plus1_reach[j[p$included[j]&b$disposition=='KNOWN_ABSENT']]=='KNOWN_ABSENT'),'Known +1 absence preserved')
 duplicate<-candidate_count[j]>1L
 check(all(nzchar(b$plus1_conflict_reason)==duplicate),'All duplicate-candidate conflicts explicitly retained')
 check(all(b$disposition[duplicate]=='UNKNOWN_OPPORTUNITY'&!p$included[j[duplicate]]&b$observed_prefix[duplicate]=='FALSE'),
  'Conflicted +1 linkage earns no included reach or known-absence credit')
 ids<-strsplit(b$candidate_plus1_action_ids,';',fixed=TRUE)
 check(all(lengths(ids)==candidate_count[j]),'Every competing +1 source action ID preserved')
})
for(f in c('return_reach','plus1_reach','later_rally_reach'))check(all(rowSums(cov[,startsWith(names(cov),paste0(f,'_')),drop=FALSE])==cov$included_points),'Coverage reach/absent/unknown sums')
check(sum(cov$aggregation_level=='MATCH')==1261L&&sum(cov$aggregation_level=='EVENT_YEAR')==40L,'All selected charts and expected event-years')
check(all(cov$inventory_points==cov$included_points+cov$completion_excluded_points+cov$qa_withheld_points),'Coverage full-inventory partition')
check(all(rowSums(cov[,startsWith(names(cov),'ending_'),drop=FALSE])==cov$included_points),'Six endings exhaust QA denominator, including residual')
q<-phase_perspectives(p)
check(nrow(q)==2*nrow(p)&&!anyDuplicated(paste(q$point_id,q$slot)),'Two neutral player perspectives for every inventory point')
for(level in c('MATCH_PLAYER','POOLED_PLAYER')) {
 z<-x[x$aggregation_level==level,];key<-paste(z$category,z$match_id,z$player,sep='|')
 qkey<-paste(q$category,if(level=='MATCH_PLAYER')q$match_id else 'ALL_MATCHES',q$player,sep='|')
 groups<-split(seq_len(nrow(q)),qkey)
 for(ii in split(seq_len(nrow(z)),key)) {
  zz<-z[ii,];g<-q[groups[[key[ii[1]]]],]
  u<-g[g$included,];end<-zz[zz$measure=='POINT_ENDING',]
  check(all(zz$all_qa_points==nrow(u))&&sum(end$phase_points)==nrow(u),'Independent per-player denominator and partition')
  check(all(end$phase_points==as.integer(table(factor(u$terminal_phase,levels=end$phase)))),'Independent pooled ending counts')
  wins<-as.integer(table(factor(u$terminal_phase[u$won],levels=end$phase)))
  losses<-as.integer(table(factor(u$terminal_phase[!u$won],levels=end$phase)))
  check(all(end$wins==wins&end$losses==losses&end$phase_points==wins+losses),'Independent pooled ending wins/losses')
  check(same(end$phase_share,if(nrow(u))end$phase_points/nrow(u) else rep(NA_real_,6)),'Pooled counts before division')
  check(all(zz$source_date_batches==length(unique(g$source_date)))&&all(zz$opponents==length(unique(g$opponent))),'Unequal date/opponent exposure retained')
  for(role in c('SERVER','RECEIVER'))for(k in seq_along(phase_reaches)) {
   rr<-zz[zz$measure=='REACH'&zz$role==role&zz$phase==phase_reaches[k],];v<-u[u$role==role,]
   f<-c('return_reach','plus1_reach','later_rally_reach')[k];reach<-v[[f]]=='KNOWN_REACHED'
   check(rr$reached==sum(reach)&&rr$wins==sum(v$won[reach]),'Independent conditional role counts')
   check(same(rr$conditional_win_rate,execution_ratio(sum(v$won[reach]),sum(reach))),'Conditional reached denominator/undefined zero')
  }
 }
}
# Relabel neutral slots; preserve named-player values and terminal/reach boundaries.
swap<-p;swap$player_a<-p$player_b;swap$player_b<-p$player_a
for(n in c('server_slot','receiver_slot','winner_slot'))swap[[n]]<-ifelse(p[[n]]=='A','B',ifelse(p[[n]]=='B','A',p[[n]]))
qs<-phase_perspectives(swap);q0<-q[order(q$category,q$match_id,q$player,q$Pt),];qs<-qs[order(qs$category,qs$match_id,qs$player,qs$Pt),]
check(identical(q0$won,qs$won)&&identical(q0$role,qs$role),'Neutral swaps preserve named-player win/role')
original<-modern_profiles(p);swapped<-modern_profiles(swap)
 check(same(original[,setdiff(names(original),'slot')],swapped[,setdiff(names(swapped),'slot')]),'All named-player profiles invariant to neutral slot swap')
 check(any(original$slot!=swapped$slot),'Neutral slot labels change explicitly')
 fixture<-q[1,,drop=FALSE];fixture$included<-FALSE;fixture$completion_eligible<-FALSE
 zz<-modern_profile_group(fixture,'MATCH_PLAYER')
 check(all(is.na(zz$phase_share[zz$measure=='POINT_ENDING']))&&all(is.na(zz$conditional_win_rate[zz$measure=='REACH'])),'Unavailable zero-coverage profiles remain visible')
# Historical overlap must retain the same point classifications and QA.
oldp<-read.csv(paste0(phase_prefix,'point-dispositions.csv'),stringsAsFactors=FALSE)
j<-match(oldp$point_id,p$point_id);take<-!is.na(j)
check(any(take),'Historical overlap exists')
for(n in c('included','qa_valid','completion_eligible','terminal_phase','return_reach','plus1_reach','later_rally_reach'))check(identical(oldp[[n]][take],p[[n]][j[take]]),'Unchanged historical overlapping definition/eligibility')
# Independent complete rerun with metadata and point-order perturbations.
local({
 stage<-modern_stage();on.exit(unlink(stage))
 rerun<-modern_build(stage,inventory=perm,reverse_points=TRUE,progress=TRUE)
 for(n in modern_outputs)check(mcp_sha(paths[n])==mcp_sha(stage[n]),paste('Byte-identical independent rerun:',n))
 modern_install(stage)
})
installed<-vapply(paths,mcp_sha,'')
missing<-paths;missing[1]<-'data/pilot/.modern-missing-fixture'
check(fails(modern_install(missing)),'Incomplete staging fails before installation')
local({
 wrong<-tempfile('.modern-install-fixture-',tmpdir='data/pilot');on.exit(unlink(wrong));writeLines('wrong',wrong)
 candidate<-paths;candidate[1]<-wrong
 check(fails(modern_install(candidate)),'Differing staged output refuses overwrite before installation')
})
check(identical(installed,vapply(paths,mcp_sha,'')),'Failed installations preserve every installed byte')
check(setequal(list.files('data/pilot',pattern='^mcp-modern-point-phase-v1-',full.names=TRUE),unname(paths)),'Exact 13-file ignored scope')
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),unname(paths)),'All outputs ignored')
for(f in names(oldpins))check(mcp_sha(f)==oldpins[[f]],paste('Historical bytes:',f))
cat('PASS:',checks,'focused and release-integrity checks; streamed',action_rows,'actions/states.\n')
print(cov[cov$aggregation_level=='CATEGORY',c('category','inventory_matches','eligible_matches','inventory_points','included_points','completion_excluded_points','qa_withheld_points','retention')],row.names=FALSE)
