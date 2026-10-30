source('R/build_mcp_repeated_player_sample.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
args<-commandArgs(trailingOnly=TRUE)
oldpaths<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
allowed<-c('PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md','R/build_mcp_repeated_player_sample.R','R/test_mcp_repeated_player_sample.R','docs/mcp-repeated-player-sample-audit.md')
oldpaths<-setdiff(oldpaths,allowed);oldpaths<-oldpaths[!startsWith(oldpaths,repeat_prefix)]
oldpins<-setNames(vapply(oldpaths,mcp_sha,''),oldpaths)
repeat_verify()
r<-if(length(args))readRDS(args[1]) else build_mcp_repeated_sample(progress=TRUE)
x<-repeat_inventory();p<-r[['player-selection']];s<-r$sample;d<-r[['selection-dispositions']]
check(nrow(s)==159&&sum(s$tour_file=='ATP')==75&&sum(s$tour_file=='WTA')==84,'Frozen measured sample accounting')
check(sum(p$selected)==40&&all(table(p$tour[p$selected])==20),'Twenty selected recurring players per tour')
check(nrow(d)==11830&&sum(d$context_eligible)==3377,'All context selection dispositions retained')
check(!anyDuplicated(s$match_id)&&all(s$context_eligible),'Deduplication never removes an opponent')
check(all(s$Round%in%c('R128','R64','R32','R16','QF','SF','F')|trimws(s$Round)%in%c('R128','R64','R32','R16','QF','SF','F')),'Supported main-draw rounds')
check(all(s$event_label%in%c('Australian Open','Roland Garros','Wimbledon','US Open')),'Major context evidence, not file gender alone')
check(all(s[['Best of']]==ifelse(s$tour_file=='ATP','5','3')),'Supported format/context pairing')
check(!any(grepl('error|winner|score|terminal|retention|success|completion|notes',repeat_selection_fields,ignore.case=TRUE)),'Selection field allowlist cannot see outcomes or parser success')
check(fails(repeat_select(cbind(x,PtWinner='1'))),'Extra outcome fields rejected before selection')
check(repeat_hash('ATP','A')!=repeat_hash('WTA','A'),'Tour-qualified SHA input')
# Independently check SHA byte input, using command-line SHA on exact UTF-8 bytes.
for(i in which(p$selected)) {
 key<-paste('MCP_REPEATED_PLAYER_V1',p$tour[i],p$player[i],sep='|');f<-tempfile();writeBin(charToRaw(enc2utf8(key)),f)
 check(mcp_sha(f)==p$selection_hash[i]&&key==p$hash_input[i],'Exact hash input without newline');unlink(f)
 eligible<-d[d$context_eligible&d$tour_file==p$tour[i]&(d$player1==p$player[i]|d$player2==p$player[i]),]
 check(nrow(eligible)==p$eligible_matches[i]&&length(unique(eligible$Date))==p$eligible_batches[i]&&p$eligible_batches[i]>=2,'Recurring across distinct batches')
 cut<-sort(eligible$Date,method='radix')[min(5,nrow(eligible))]
 wanted<-eligible$match_id[eligible$Date<=cut]
 included<-s$match_id[vapply(strsplit(s$selected_by,';',fixed=TRUE),function(v)p$player[i]%in%v,FALSE)&s$tour_file==p$tour[i]]
 check(setequal(wanted,included)&&p$chosen_matches[i]==length(wanted)&&p$cutoff_source_date[i]==cut,'Earliest five plus every boundary tie')
}
for(t in c('ATP','WTA')) {
 eligible<-p[p$tour==t&p$recurring,];eligible<-eligible[order(eligible$selection_hash,eligible$player,method='radix'),]
 check(setequal(head(eligible$player,20),p$player[p$tour==t&p$selected]),'No post-parser player replacement')
}
hash_lookup<-setNames(p$selection_hash,paste(p$tour,p$player,sep='|'))
memo<-function(tour,player)unname(hash_lookup[[paste(tour,player,sep='|')]])
set.seed(23);perm<-repeat_select(x[sample(nrow(x)),],hash=memo)
for(k in c('selection-dispositions','player-selection','sample'))check(identical(perm[[k]][,names(repeat_select(x,hash=memo)[[k]]),drop=FALSE],repeat_select(x,hash=memo)[[k]]),'Metadata permutation invariance')
# Minimal context fixtures: boundary tie inclusion; same-day-only appearances do not recur.
fixture<-x[rep(which(d$context_eligible)[1],6),];fixture$tour_file<-'ATP';fixture$Date<-c('20000101','20000102','20000103','20000104','20000105','20000105')
fixture$player1<-'p';fixture$player2<-paste0('o',1:6);fixture$player_a<-'p';fixture$player_b<-fixture$player2
fixture$Round<-'R32';fixture$event_label<-'Australian Open';fixture[['Best of']]<-'5';fixture$duplicate_id<-'FALSE';fixture$source_row<-1:6
fixture$match_id<-paste0(fixture$Date,'-M-Australian_Open-R32-p-',fixture$player2)
tie<-repeat_select(fixture,hash=function(t,p)'constant',cap=1)
check(nrow(tie$sample)==6&&tie[['player-selection']]$chosen_matches[tie[['player-selection']]$selected]==6,'Fifth match date ties included without an outcome tiebreak')
q<-fixture[5:6,];same_date<-repeat_select(q,hash=function(t,p)'constant')
check(!any(same_date[['player-selection']]$recurring)&&nrow(same_date$sample)==0,'Same-date-only appearances do not establish usable recurrence')
bad<-fixture;bad$event_label[1]<-'Unverified Open';bad$Round[2]<-'Q1';bad$match_id[3]<-sub('-M-','-W-',bad$match_id[3],fixed=TRUE)
bad[['Best of']][4]<-'3';bad$duplicate_point_rows[5]<-2;bad$Date[6]<-'20000230'
reasons<-repeat_context(bad)$selection_exclusion_reasons
for(term in c('TOUR_EVENT_CONTEXT_UNVERIFIED','MAIN_DRAW_CONTEXT_UNSUPPORTED','SOURCE_ID_CONTEXT_CONFLICT','MAJOR_TOUR_FORMAT_CONTEXT_UNSUPPORTED','DUPLICATE_POINT_KEYS','INVALID_OR_CONFLICTING_DATE'))check(any(grepl(term,reasons,fixed=TRUE)),paste('Explicit exclusion',term))
# Raw point rows and unchanged parser output reconcile independently.
input<-repeat_points(s);a<-r$actions;pt<-r[['point-reconciliation']];m<-r[['match-reconciliation']]
check(nrow(input$points)==31218&&nrow(pt)==31218&&all(m$point_total_agrees),'All linked source points retained')
check(!anyDuplicated(a$action_id)&&!anyDuplicated(paste(pt$match_id,pt$Pt)),'Unique action and point identities')
for(i in seq_len(nrow(s))) {
 ids<-pt$match_id==s$match_id[i];raw<-input$points[input$points$match_id==s$match_id[i],]
 check(sum(ids)==s$points[i]&&identical(as.character(pt$Pt[ids]),as.character(raw$Pt)),'Match point linkage and order')
 check(identical(pt$raw_first[ids],raw[['1st']])&&identical(pt$raw_second[ids],raw[['2nd']])&&identical(pt$raw_notes[ids],raw$Notes),'Raw sequence and note preservation')
}
mi<-match(a$match_id,s$match_id);expected<-ifelse(a$actor==1,s$player1[mi],s$player2[mi]);known<-!is.na(a$actor)
check(all(a$actor_name[known]==expected[known]),'Exact source-player action ownership')
neutral<-ifelse(a$actor_name==s$player_a[mi],'A','B')
check(all(a$actor_neutral_slot[known]==neutral[known]),'Outcome-neutral slot/name linkage')
check(all(a$actor[a$domain=='Serve'&known]==a$server[a$domain=='Serve'&known]),'Serve belongs to server')
check(all(a$actor[a$domain=='Return'&known]==3L-a$server[a$domain=='Return'&known]),'Return belongs to receiver')
check(all(pt$terminal_agrees[pt$tennis_sequence_validated]),'Recorded terminal outcome reconciliation remains binding')
st<-r[['action-states']];pl<-r[['serve-plus1']]
check(identical(st$action_id,a$action_id),'Ordered state/action transitions')
check(!any(st$tennis_action_usable&!st$point_validated),'No supported-prefix promotion of unresolved points')
check(!any(st$tennis_action_usable&st$score_reconciliation_status!='PASS'),'Score conflicts withhold existing transition gate')
check(all(nzchar(st$audit_withheld_reasons[!st$transition_usable])),'Every withheld transition has an explicit audit reason')
check(identical(st$raw_token,a$raw_token)&&identical(st$char_start,a$char_start)&&identical(st$char_end,a$char_end),'Raw notation and spans preserved')
check(sum(pl$validated_attempt)==sum(pt$plus1_validated)&&sum(pl$observed_prefix)==sum(pt$plus1_observation=='KNOWN_PRESENT'),'Independent +1 attempt reconciliation')
check(all(pl$usable_attempt==(pl$validated_attempt&pl$score_reconciliation_status=='PASS')),'Parser validation is not analytical score admission')
check(identical(st$unsupported_observation,a$observation=='UNSUPPORTED_SUFFIX')&&
 all(st$authority_conflict==grepl('SERVE_NET_CORD_AUTHORITY_CONFLICT',pt$issues[match(st$point_id,paste(pt$match_id,pt$Pt,sep='|'))],fixed=TRUE)),'Unsupported notation and authority conflicts remain visible')
# Independently reconstruct Return opportunity contexts from parser serve ownership.
ret<-r[['return-contexts']];h<-r[['history-support']]
check(nrow(ret)==8*nrow(s)&&nrow(h)==4*nrow(s),'All match/player/context cells including unknowns and zeros')
check(!anyDuplicated(paste(ret$match_id,ret$slot,ret$context))&&!anyDuplicated(paste(h$match_id,h$slot,h$context)),'No duplicate context/history contributions')
usable_return<-a$domain=='Return'&a$kind=='STROKE'&st$tennis_action_usable
raw_keys<-paste(a$match_id[usable_return],a$actor_neutral_slot[usable_return],ifelse(a$serve_number[usable_return]==1,'FIRST','SECOND'),sep='|')
reference_counts<-tabulate(match(raw_keys,paste(ret$match_id,ret$slot,ret$context,sep='|')),nrow(ret))
for(i in seq_len(nrow(ret))) {
 z<-ret[i,]
 if(z$context%in%c('FIRST','SECOND')) {
  check(reference_counts[i]==z$usable_attempts,'Independent usable Return denominator')
 }
 check(z$observed_attempts==z$usable_attempts+z$withheld_attempts,'Unknown exposure not credited')
 check(is.na(z$retention)==(z$observed_attempts==0),'Zero opportunities remain undefined')
}
for(i in seq_len(nrow(h))) {
 z<-h[i,];mask<-h$tour==z$tour&h$player==z$player&h$context==z$context&as.Date(h$source_date)<as.Date(z$source_date)
 check(z$prior_matches==sum(mask)&&z$prior_attempts==sum(h$usable_attempts[mask]),'Independent strict prior membership/attempt pooling')
 dates<-h$source_date[mask&h$usable_attempts>0]
 check(if(length(dates))z$source_gap_days==as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else is.na(z$source_gap_days),'Source-label gap accounting')
}
cuts<-character()
for(tour in c('ATP','WTA')) {
 dates<-unique(h$batch_key[h$tour==tour]);cuts<-c(cuts,dates[c(1L,ceiling(length(dates)/2),length(dates))])
 # Explicit same-date multi-match batch, in addition to early/middle/late cutoffs.
 sizes<-table(s$Date[s$tour_file==tour]);ties<-names(sizes)[sizes>1]
 if(length(ties))cuts<-c(cuts,paste(tour,ties[1],sep='|'))
}
for(cut in unique(cuts)) {
 z<-h[h$batch_key==cut,];alt<-ret
 mask<-alt$tour==z$tour[1]&alt$source_date>=z$source_date[1];alt$usable_attempts[mask]<-alt$usable_attempts[mask]+5
 hh<-repeat_history(alt);sel<-hh$batch_key==cut
 check(same(h[h$batch_key==cut,c('prior_matches','prior_attempts','prior_batches','source_gap_days')],hh[sel,c('prior_matches','prior_attempts','prior_batches','source_gap_days')]),'Current/later exposure cannot affect prior support')
}
check(!any(grepl('estimate|probability|brier|loss|error_rate',names(h),ignore.case=TRUE)),'No estimation or scoring hidden in support ledger')
# Frozen local information-boundary checks; no historical suite is invoked.
point<-action_point('4f27b1n@','',1);b<-point$actions;b$action_id<-as.character(seq_len(nrow(b)));b$action_index<-seq_len(nrow(b))
before<-state_point(b,1);changed<-b;changed$terminal[nrow(b)]<-'WINNER'
after<-state_point(changed,1)
check(identical(before[,state_pre_fields],after[,state_pre_fields]),'Current terminal does not enter pre-action information')
check(!any(before$local_boundary_supported[before$pre_boundary=='TERMINAL']),'Terminal absorption')
# A second separately built release may be supplied to avoid redundant parsing.
# --rerun performs that full independent build here, using the same source pins.
if(length(args)>1L) {
 rerun<-if(args[2]=='--rerun')build_mcp_repeated_sample(progress=TRUE) else readRDS(args[2])
 for(k in repeat_outputs){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(rerun[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte rerun',k));unlink(c(f,g))}
}
repeat_install(r)
check(length(system2('git',c('check-ignore','--',shQuote(paste0(repeat_prefix,repeat_outputs,'.csv'))),stdout=TRUE))==length(repeat_outputs),'All outputs ignored in existing location')
check(identical(oldpins,setNames(vapply(oldpaths,mcp_sha,''),oldpaths)),'All historical artifacts preserved')
cat(sprintf('PASS: %d focused checks; %d historical artifacts unchanged.\n',checks,length(oldpaths)))
