source('R/freeze_mcp_broader_return_protocol.R')
checks<-0L;check<-function(ok,msg){checks<<-checks+1L;if(!isTRUE(ok))stop(msg,call.=FALSE)}
fails<-function(x)inherits(tryCatch({force(x);NULL},error=identity),'error')
old<-unique(c(system2('git','ls-files',stdout=TRUE),list.files('data/raw',recursive=TRUE,full.names=TRUE),list.files('data/pilot',recursive=TRUE,full.names=TRUE)))
allowed<-c('R/freeze_mcp_broader_return_protocol.R','R/test_mcp_broader_return_protocol.R','docs/mcp-broader-return-transfer-protocol.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
old<-setdiff(old,allowed);old<-old[!startsWith(old,broader_prefix)];pins<-setNames(vapply(old,mcp_sha,''),old)
input<-broader_load();r<-freeze_mcp_broader_protocol(input);e<-r[['match-eligibility']];h<-r[['context-support']]
check(nrow(e)==159&&nrow(h)==1272,'All 159 matches, 318 slots and four contexts remain')
check(!anyDuplicated(e$match_id)&&!anyDuplicated(paste(h$match_id,h$slot,h$context)),'Unique inventory/context identities')
check(identical(as.integer(table(e$tour_file[e$eligible])),c(73L,83L)),'Measured completion eligibility')
expected_excluded<-c('20180126-M-Australian_Open-SF-Hyeon_Chung-Roger_Federer','20240701-M-Wimbledon-R128-Alex_Michelsen-Lloyd_Harris','20190703-W-Wimbledon-R64-Margarita_Gasparyan-Elina_Svitolina')
check(setequal(e$match_id[!e$eligible],expected_excluded),'Two incomplete charts and terminal-conflict match excluded')
check(sum(e$exclusion_reasons=='INCOMPLETE_CHART')==2&&sum(e$exclusion_reasons=='TERMINAL_OUTCOME_CONFLICT')==1,'Exact measured reasons')
check(all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE'),'Internal completion never becomes official verification')
check(all(e$eligible==(e$chart_score_complete&e$terminal_conflicts==0&e$score_conflict_points==0&e$status_note_cues==0&e$point_total_agrees&e$starts_at_zero&e$point_sequence_contiguous&e$bad_point_owner==0)),'Independent completion conjunction')
for(tour in c('ATP','WTA')){
 z<-e[e$tour_file==tour,];check(all(z$seed==(z$eligible&z$source_date==min(z$source_date[z$eligible]))),'Earliest eligible whole batch seeds')
}
# Failure fixtures modify only evidence; no inferred medical/status diagnosis.
good<-e$match_id[e$eligible][1]
for(field in c('chart_score_complete','terminal_conflicts','score_conflict_points','point_total_agrees')){
 q<-input;j<-match(good,q$completion$match_id);q$completion[[field]][j]<-NA
 out<-broader_eligibility(q);check(!out$eligible[out$match_id==good]&&nzchar(out$exclusion_reasons[out$match_id==good]),paste('Missing evidence fails closed',field))
}
for(field in c('status_note_cues','starts_at_zero','point_sequence_contiguous','bad_point_owner')){
 q<-input;j<-match(good,q$evidence$match_id);q$evidence[[field]][j]<-NA
 out<-broader_eligibility(q);check(!out$eligible[out$match_id==good],paste('Missing status/coverage evidence',field))
}
q<-input;j<-match(good,q$evidence$match_id);q$evidence$status_note_cues[j]<-1
out<-broader_eligibility(q);check(!out$eligible[out$match_id==good]&&out$exclusion_reasons[out$match_id==good]=='STATUS_NOTE_CUE_REQUIRES_EXCLUSION','Saved retirement/walkover/status cue overrides completed chart')
q$completion$terminal_conflicts[match(good,q$completion$match_id)]<-1
out<-broader_eligibility(q);check(out$exclusion_reasons[out$match_id==good]=='STATUS_NOTE_CUE_REQUIRES_EXCLUSION;TERMINAL_OUTCOME_CONFLICT','Simultaneous reasons preserved')
q<-input;q$completion<-q$completion[-1,];check(fails(broader_eligibility(q)),'Missing completion join stops release')
q<-input;q$sample<-rbind(q$sample,q$sample[1,]);check(fails(broader_eligibility(q)),'Duplicate sample stops release')
q<-input;q$sample$Date[1]<-20000230;check(fails(broader_eligibility(q)),'Invalid source date stops release')
q<-input;q$evidence$status_note_cues[match(good,q$evidence$match_id)]<--1;check(fails(broader_eligibility(q)),'Malformed evidence count stops release')
check(fails(broader_support(cbind(input$counts,errors=0),e)),'Error numerators forbidden in this availability audit')
q<-input$counts;q$player[1]<-'conflicting identity';check(fails(broader_support(q,e)),'Exact receiver linkage')
q<-input$counts;q$usable_attempts[1]<-q$observed_attempts[1]+1;check(fails(broader_support(q,e)),'Invalid denominator partition')
# Independent reconstruction from frozen availability, without helper history logic.
c<-input$counts;eligible_ids<-e$match_id[e$eligible]
for(i in seq_len(nrow(h))){z<-h[i,];p<-c[c$match_id%in%eligible_ids&c$tour==z$tour&c$context==z$context&as.Date(c$source_date)<as.Date(z$source_date),]
 own<-p[p$player==z$player,];dates<-own$source_date[own$usable_attempts>0]
 check(z$prior_matches==nrow(own)&&z$prior_attempts==sum(own$usable_attempts)&&z$reference_attempts==sum(p$usable_attempts),'Independent eligible personal/reference exposure')
 check(!any(p$match_id%in%expected_excluded)&&!any(p$source_date>=z$source_date),'No excluded/simultaneous/later contribution')
 expected<-z$eligible&&!z$seed&&z$context%in%c('FIRST','SECOND')&&z$usable_attempts>0&&sum(own$usable_attempts)>0&&sum(p$usable_attempts)>0
 check(z$paired_support==expected,'Identical comparison support mask')
 check(if(length(dates))z$days_since_last_source_date==as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else is.na(z$days_since_last_source_date),'Source-label gap')
}
# All source rows/context order and same-date ordering are irrelevant.
set.seed(31);q<-lapply(input,function(x)x[sample(nrow(x)),,drop=FALSE]);rr<-freeze_mcp_broader_protocol(q)
for(k in names(r))check(identical(r[[k]],rr[[k]]),paste('Permutation invariance',k))
# Simultaneous fixture uses an existing eligible multi-match source batch.
key<-paste(e$tour_file,e$source_date);multi<-names(which(table(key[e$eligible])>1))[1];ids<-e$match_id[key==multi&e$eligible]
check(length(ids)>=2,'Actual simultaneous eligible batch retained')
cols<-c('prior_matches','prior_attempts','reference_attempts','days_since_last_source_date')
for(tour in c('ATP','WTA')){
 dates<-sort(unique(e$source_date[e$tour_file==tour&e$eligible]));cuts<-unique(c(dates[1],dates[ceiling(length(dates)/2)],dates[length(dates)],e$source_date[match(ids[1],e$match_id)]))
 for(cut in cuts){q<-input$counts;mask<-q$tour==tour&q$source_date>=cut&q$context%in%c('FIRST','SECOND');q$usable_attempts[mask]<-q$usable_attempts[mask]+7L;q$observed_attempts[mask]<-q$observed_attempts[mask]+7L
  alt<-broader_support(q,e);ix<-h$tour==tour&h$source_date==cut
  check(identical(h[ix,cols],alt[ix,cols]),'Current/later exposure cannot change priors')
 }
}
q<-input$counts;mask<-q$match_id%in%expected_excluded&q$context%in%c('FIRST','SECOND');q$usable_attempts[mask]<-q$usable_attempts[mask]+1000L;q$observed_attempts[mask]<-q$observed_attempts[mask]+1000L
alt<-broader_support(q,e);check(identical(h[,cols],alt[,cols]),'Excluded exposure cannot contaminate any history/reference')
# Positive control: an eligible earliest prior count changes a linked later pool.
z<-h[h$paired_support,][1,];ix<-which(c$match_id%in%eligible_ids&c$tour==z$tour&c$player==z$player&c$context==z$context&c$source_date<z$source_date)[1]
q<-c;q$usable_attempts[ix]<-q$usable_attempts[ix]+1;q$observed_attempts[ix]<-q$observed_attempts[ix]+1;alt<-broader_support(q,e);ix<-which(h$match_id==z$match_id&h$slot==z$slot&h$context==z$context)
check(alt$prior_attempts[ix]==h$prior_attempts[ix]+1,'Eligible earlier exposure positive control')
# Zero target denominator and cold-start precedence remain explicit.
q<-c;j<-which(c$match_id==z$match_id&c$slot==z$slot&c$context==z$context);q$withheld_attempts[j]<-q$observed_attempts[j];q$usable_attempts[j]<-0
alt<-broader_support(q,e);check(alt$support_disposition[ix]=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS','Zero target opportunity abstains')
check(all(h$support_disposition[!h$eligible]=='COMPLETION_EXCLUDED')&&all(h$support_disposition[h$seed&h$context%in%c('FIRST','SECOND')]=='SEED_NOT_EVALUATED'),'Completion and seed precedence')
check(!any(grepl('estimate|loss|error_rate|prediction',names(h))),'No estimates or performance fields exported')
# Fresh saved inputs, deterministic bytes, and immutable installation.
rr<-freeze_mcp_broader_protocol();for(k in names(r)){f<-tempfile();g<-tempfile();mcp_write(r[[k]],f);mcp_write(rr[[k]],g);check(mcp_sha(f)==mcp_sha(g),paste('Independent byte rerun',k));unlink(c(f,g))}
broader_install(r);check(length(system2('git',c('check-ignore','--',shQuote(paste0(broader_prefix,broader_outputs,'.csv'))),stdout=TRUE))==3L,'Three outputs ignored')
check(identical(pins,setNames(vapply(old,mcp_sha,''),old)),'Historical files unchanged')
cat(sprintf('PASS: %d focused checks; %d historical artifacts preserved.\n',checks,length(old)))
