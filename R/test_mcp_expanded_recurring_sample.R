source('R/build_mcp_expanded_recurring_sample.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
same<-function(a,b)isTRUE(all.equal(a,b,tolerance=1e-12,check.attributes=FALSE))
exported<-function(x){f<-tempfile();on.exit(unlink(f));mcp_write(x,f);read.csv(f,stringsAsFactors=FALSE,check.names=FALSE)}
fails<-function(expr)inherits(tryCatch({force(expr);NULL},error=identity),'error')
args<-commandArgs(trailingOnly=TRUE)
r<-if(length(args))readRDS(args[1]) else build_mcp_expanded_sample(progress=TRUE)
expand_verify();saved_pin<-expand_pins[1];expand_pins[1]<-paste(rep('0',64),collapse='');check(fails(expand_verify()),'Changed input pin fails closed');expand_pins[1]<-saved_pin;original<-expand_original();x<-repeat_inventory();s<-r$sample;p<-r[['player-selection']];d<-r[['selection-dispositions']];e<-r[['match-eligibility']]
check(identical(names(r),expand_outputs),'Exact nineteen-file release')
check(nrow(s)==223&&sum(s$tour_file=='ATP')==106&&sum(s$tour_file=='WTA')==117,'Measured sample accounting')
check(nrow(d)==11830&&sum(d$context_eligible)==3377,'Every selection candidate retained')
check(sum(p$selected)==40&&identical(paste(p$tour[p$selected],p$player[p$selected]),paste(original$players$tour[original$players$selected],original$players$player[original$players$selected])),'Same forty selected identities')
check(!anyDuplicated(s$match_id)&&all(original$sample$match_id%in%s$match_id),'Deduplicate matches, preserve original inventory')
check(all(s$context_eligible)&&all(s$inventory_origin==ifelse(s$match_id%in%original$sample$match_id,'ORIGINAL_FIVE_MATCH_SAMPLE','ADDED_TEN_MATCH_SAMPLE')),'Origin and context before completion')
check(fails(expand_select(cbind(x,PtWinner=1),original)),'Outcome-bearing selection input rejected')
for(i in which(p$selected)){
 check(repeat_hash(p$tour[i],p$player[i])==p$selection_hash[i],'Exact UTF-8 category/name hash')
 q<-d[d$context_eligible&d$tour_file==p$tour[i]&(d$player1==p$player[i]|d$player2==p$player[i]),]
 cut<-sort(q$Date)[min(10,nrow(q))];wanted<-q$match_id[q$Date<=cut]
 got<-s$match_id[s$tour_file==p$tour[i]&vapply(strsplit(s$selected_by,';',fixed=TRUE),function(v)p$player[i]%in%v,FALSE)]
 check(setequal(wanted,got)&&p$chosen_matches[i]==length(wanted)&&p$cutoff_source_date[i]==cut,'Independent earliest-ten and all boundary ties')
 check(p$eligible_batches[i]>=2&&length(unique(q$Date))==p$eligible_batches[i],'Date recurrence independent of observations')
}
set.seed(91);perm<-expand_select(x[sample(nrow(x)),],original)
for(k in names(perm))check(identical(perm[[k]],r[[k]][,names(perm[[k]]),drop=FALSE]),'Metadata permutation invariance')
# Explicit tenth-boundary tie and fewer-than-ten fixtures reuse context authority.
f<-x[rep(which(d$context_eligible)[1],11),];f$tour_file<-'ATP';f$Date<-c(sprintf('200001%02d',1:10),'20000110');f$player1<-'p';f$player2<-paste0('o',1:11);f$player_a<-'p';f$player_b<-f$player2;f$Round<-'R32';f$event_label<-'Australian Open';f[['Best of']]<-'5';f$duplicate_id<-'FALSE';f$source_row<-1:11;f$match_id<-paste0(f$Date,'-M-Australian_Open-R32-p-',f$player2)
fix<-repeat_select(f,hash=function(t,p)'constant',cap=1,matches=10L)
check(nrow(fix$sample)==11,'Tenth-date tie cannot be truncated')
check(nrow(repeat_select(f[1:4,],hash=function(t,p)'constant',cap=1,matches=10L)$sample)==4,'All available when fewer than ten')
check(!any(repeat_select(f[10:11,],hash=function(t,p)'constant')$sample$sample_selected),'Same-date-only appearances not recurrence')
input<-repeat_points(s);a<-r$actions;pt<-r[['point-reconciliation']];st<-r[['action-states']];pl<-r[['serve-plus1']];m<-r[['match-reconciliation']]
check(nrow(pt)==43310&&nrow(input$points)==43310&&all(m$point_total_agrees),'All linked source points retained')
check(!anyDuplicated(a$action_id)&&!anyDuplicated(paste(pt$match_id,pt$Pt))&&identical(st$action_id,a$action_id),'Unique ordered action/state/point linkage')
for(i in seq_len(nrow(s))){ii<-pt$match_id==s$match_id[i];raw<-input$points[input$points$match_id==s$match_id[i],]
 check(sum(ii)==s$points[i]&&identical(as.character(pt$Pt[ii]),as.character(raw$Pt)),'Independent point totals and order')
 check(identical(pt$raw_first[ii],raw[['1st']])&&identical(pt$raw_second[ii],raw[['2nd']])&&identical(pt$raw_notes[ii],raw$Notes),'Raw notation and notes unchanged')
}
mi<-match(a$match_id,s$match_id);known<-!is.na(a$actor)
check(all(a$actor_name[known]==ifelse(a$actor[known]==1,s$player1[mi[known]],s$player2[mi[known]])),'Exact source ownership')
check(all(a$actor_neutral_slot[known]==ifelse(a$actor_name[known]==s$player_a[mi[known]],'A','B')),'Neutral ownership')
check(all(a$actor[a$domain=='Serve'&known]==a$server[a$domain=='Serve'&known])&&all(a$actor[a$domain=='Return'&known]==3-a$server[a$domain=='Return'&known]),'Serve/Return action ownership')
check(all(pt$terminal_agrees[pt$tennis_sequence_validated]),'Terminal reconciliation binding')
check(identical(st$raw_token,a$raw_token)&&identical(st$char_start,a$char_start)&&identical(st$char_end,a$char_end),'Raw token spans unchanged')
check(!any(st$tennis_action_usable&(!st$point_validated|st$score_reconciliation_status!='PASS')),'No supported-prefix promotion')
check(all(pl$usable_attempt==(pl$validated_attempt&pl$score_reconciliation_status=='PASS'))&&sum(pl$validated_attempt)==sum(pt$plus1_validated),'Independent +1 validation')
# Original parser/state and completion releases remain observationally identical.
for(n in c('actions','point-reconciliation','match-reconciliation','action-states','serve-plus1')){
 old<-read.csv(paste0(repeat_prefix,n,'.csv'),stringsAsFactors=FALSE,check.names=FALSE)
 new<-r[[n]][r[[n]]$match_id%in%original$sample$match_id,]
 fields<-setdiff(names(old),c('release','claim','exposure','chronology','uncertainty','selected_by'))
 check(same(exported(new[,fields]),old[,fields]),paste('Original frozen component equality:',n))
}
old<-original$eligibility;j<-match(old$match_id,e$match_id)
fields<-setdiff(names(old),c('release','claim','exposure','chronology','uncertainty','selected_by','option'));check(all(fields%in%names(e)),'All original scientific completion fields remain')
ee<-exported(e[j,fields]);for(field in fields)check(same(ee[[field]],old[[field]]),paste('Original completion equality:',field))
check(all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE'),'No official completion claim')
# Missing saved status must fail closed without selection replacement.
missing<-input$metadata;missing$status_note_cues[1]<-NA
me<-expand_eligibility(s,missing,m,list(eligibility=old[0,]))
check(!me$eligible[match(s$match_id[1],me$match_id)]&&grepl('STATUS_EVIDENCE_UNAVAILABLE',me$exclusion_reasons[match(s$match_id[1],me$match_id)]),'Unavailable completion evidence excluded')
c<-r[['opportunity-counts']];h<-r[['history-support']];keys<-function(z)paste(z$match_id,z$slot,z$domain,z$context,sep='|')
check(nrow(c)==20*nrow(s)&&nrow(h)==nrow(c)&&!anyDuplicated(keys(c)),'Every slot/domain/context inventoried')
# Count reconstruction from parser serve numbers, source actors and frozen QA flags.
physical<-a$kind%in%c('SERVE','SERVE_FAULT','STROKE');ctx<-ifelse(a$domain=='Rally','ALL',ifelse(is.na(a$serve_number),'UNKNOWN',ifelse(a$serve_number==1,'FIRST',ifelse(a$serve_number==2,'SECOND','UNSUPPORTED'))))
ret<-a$domain=='Return'&a$kind=='STROKE';rv<-ifelse(st$pre_serve_number==1,'FIRST',ifelse(st$pre_serve_number==2,'SECOND','UNKNOWN'));rv[is.na(rv)]<-'UNKNOWN'
boundary_bad<-st$pre_boundary%in%c('UNKNOWN','TERMINAL')|st$pre_next_domain!='Return';boundary_bad[is.na(boundary_bad)]<-TRUE;rv[boundary_bad]<-'UNSUPPORTED';ctx[ret]<-rv[ret]
k<-match(paste(a$match_id,a$actor_neutral_slot,a$domain,ctx,sep='|'),keys(c))
expected_observed<-tabulate(k[physical],nrow(c));expected_usable<-tabulate(k[physical&st$tennis_action_usable],nrow(c))
# +1 mapping independently uses original player1/player2 source IDs.
pmi<-match(pl$match_id,s$match_id);server_name<-ifelse(pl$server==1,s$player1[pmi],s$player2[pmi]);slot<-ifelse(server_name==s$player_a[pmi],'A','B')
pk<-match(paste(pl$match_id,slot,'Serve +1','ALL',sep='|'),keys(c))
expected_observed<-expected_observed+tabulate(pk[pl$observed_prefix],nrow(c));expected_usable<-expected_usable+tabulate(pk[pl$usable_attempt],nrow(c))
check(identical(c$observed_attempts,expected_observed)&&identical(c$usable_attempts,expected_usable),'Every physical/support numerator independently reconstructed')
check(all(c$withheld_attempts==expected_observed-expected_usable),'Withheld attempts retain exposure')
check(identical(c$known_absences,tabulate(pk[pl$disposition=='KNOWN_ABSENT'],nrow(c)))&&identical(c$unknown_opportunities,tabulate(pk[pl$disposition=='UNKNOWN_OPPORTUNITY'],nrow(c))),'Known absence distinct from unknown +1')
check(all(is.na(c$retention[c$observed_attempts==0]))&&!any(st$tennis_action_usable[a$is_void]),'Zero denominators undefined; voids unusable')
oldret<-read.csv(paste0(repeat_prefix,'return-contexts.csv'),stringsAsFactors=FALSE)
oldserve<-read.csv('data/pilot/mcp-first-serve-fault-transfer-v1-observation-counts.csv',stringsAsFactors=FALSE)
for(pair in list(list('Return',oldret),list('Serve',oldserve))){oldc<-pair[[2]];j<-match(paste(oldc$match_id,oldc$slot,pair[[1]],oldc$context,sep='|'),keys(c));check(!anyNA(j)&&all(c$observed_attempts[j]==oldc$observed_attempts&c$usable_attempts[j]==oldc$usable_attempts),'Frozen original Serve/Return denominator equality')}
for(i in seq_len(nrow(h))){z<-h[i,];q<-c[c$tour==z$tour&c$player==z$player&c$domain==z$domain&c$context==z$context&c$source_date<z$source_date,];q<-q[e$eligible[match(q$match_id,e$match_id)],];u<-q[q$usable_attempts>0,]
 check(z$prior_matches==nrow(q)&&z$prior_usable_matches==nrow(u)&&z$prior_attempts==sum(q$usable_attempts)&&z$prior_batches==length(unique(u$source_date)),'Every strict earlier eligible history reconstructed')
 check(z$prior_attempts==z$prior_old_attempts+z$prior_added_attempts,'Original/added contribution partition')
 check(z$supported==(z$eligible&&!z$seed&&z$context%in%c('FIRST','SECOND','ALL')&&z$usable_attempts>0&&z$prior_attempts>0),'Support mask has no performance selection')
 check(is.na(z$source_gap_days)==(nrow(u)==0)&&(!nrow(u)||z$source_gap_days==as.numeric(as.Date(z$source_date)-as.Date(max(u$source_date)))),'Source-gap accounting, no inferred timing')
}
set.seed(7);hc<-expand_history(c[sample(nrow(c)),],e);hc<-hc[match(keys(h),keys(hc)),]
check(same(hc[,names(hc)],h[,names(hc)]),'History row permutation invariance')
# Same/later-batch changes cannot alter prior exposure; earlier changes are a positive control.
i<-which(h$supported&h$domain=='Serve'&h$context=='FIRST')[1];z<-h[i,];changed<-c
mask<-changed$tour==z$tour&changed$source_date>=z$source_date;changed$usable_attempts[mask]<-changed$usable_attempts[mask]+17L;changed$observed_attempts[mask]<-changed$observed_attempts[mask]+17L
ch<-expand_history(changed,e);check(ch$prior_attempts[i]==z$prior_attempts,'Same/later counts cannot enter current history')
prior<-which(c$tour==z$tour&c$player==z$player&c$domain==z$domain&c$context==z$context&c$source_date<z$source_date&e$eligible[match(c$match_id,e$match_id)])[1]
changed<-c;changed$usable_attempts[prior]<-changed$usable_attempts[prior]+1L;changed$observed_attempts[prior]<-changed$observed_attempts[prior]+1L;ch<-expand_history(changed,e)
check(ch$prior_attempts[i]==z$prior_attempts+1,'Eligible earlier count positive control')
check(all(h$prior_attempts[h$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS']==0),'Explicit cold starts')
for(t in c('ATP','WTA'))for(v in unique(paste(h$domain,h$context))){z<-h[h$tour==t&paste(h$domain,h$context)==v,];cv<-r[['coverage-summary']];cv<-cv[cv$tour==t&paste(cv$domain,cv$context)==v,]
 check(cv$supported_targets==sum(z$supported)&&cv$supported_players==length(unique(z$player[z$supported]))&&cv$eligible_usable_attempts==sum(z$usable_attempts[z$eligible]),'Category/view support accounting')
}
check(!any(grepl('estimate|probability|loss|coefficient|fault_rate|error_rate',names(h))),'No transfer estimation/scoring')
for(k in names(r))check(all(r[[k]]$claim=='EXPANDED_SUPPORT_INVENTORY_NOT_FACTOR_VALIDATION'&r[[k]]$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),'Explicit support-only labels')
if(length(args)>=2){r2<-readRDS(args[2]);check(identical(names(r2),names(r)),'Independent release scope');for(k in names(r)){f1<-tempfile();f2<-tempfile();mcp_write(r[[k]],f1);mcp_write(r2[[k]],f2);check(mcp_sha(f1)==mcp_sha(f2),paste('Byte-identical independent rerun:',k));unlink(c(f1,f2))}}
paths<-paste0(expand_prefix,names(r),'.csv');check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Every output already ignored')
expand_install(r);for(k in names(r)){f<-tempfile();mcp_write(r[[k]],f);check(mcp_sha(f)==mcp_sha(paste0(expand_prefix,k,'.csv')),'Installed bytes');unlink(f)}
bad<-r;bad$sample$points[1]<-bad$sample$points[1]+1L;before<-vapply(paths,mcp_sha,'');check(fails(expand_install(bad)),'Differing release cannot overwrite');check(identical(before,vapply(paths,mcp_sha,'')),'Failed installation leaves all output bytes intact')
if(file.exists('/tmp/expanded-mcp-baseline.rds')){pins<-readRDS('/tmp/expanded-mcp-baseline.rds');for(f in names(pins))check(mcp_sha(f)==pins[[f]],paste('Historical preservation:',f))}
cat(checks,'focused checks passed\n')
