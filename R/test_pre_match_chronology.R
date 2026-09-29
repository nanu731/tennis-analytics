# Phase 2K focused tests: saved evidence only; no empirical model or old suite execution.
source('R/audit_pre_match_chronology.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
expected_files<-c('R/audit_pre_match_chronology.R','R/test_pre_match_chronology.R','docs/pre-match-chronology-audit.md','docs/status.md','docs/data-source-contract.md')
pk_verify();check(TRUE,'Saved fingerprints')
pins<-pk_pins;pins[1]<-paste(rep('0',64),collapse='');check(fails(pk_verify(pins)),'Pin mismatch fails closed without changing a file')
check(fails(pk_ignored('R/nonignored-chronology-fixture')),'Nonignored destination blocks')
pk_ignored();check(TRUE,'All three output paths ignored before writing')
B<-function(lo,hi=lo,role)pk_bound(lo,hi,'VERIFIED','UTC_RECONCILED',role)
completed<-B(1,2,'completion');available<-B(2,3,'availability');cutoff<-B(4,5,'cutoff');start<-B(6,7,'start')
check(pk_release(completed,available,cutoff,start)$supported,'Strict verified conservative bounds')
check(!pk_release(completed,B(4,4,'availability'),cutoff,start)$supported,'Equality fails')
check(!pk_release(completed,B(3,5,'availability'),cutoff,start)$supported,'Overlapping availability fails')
check(!pk_release(B(2,4,'completion'),available,cutoff,start)$supported,'Equal completion bound fails')
check(!pk_release(completed,available,cutoff,B(5,6,'start'))$supported,'Cutoff must be strictly pre-play')
check(!pk_release(completed,available,cutoff,start,conflict=TRUE)$supported,'Conflict fails')
check(!pk_release(completed,available,cutoff,B(5,6,'start'),preplay_attested=TRUE)$supported,'Attestation cannot override conflicting start bound')
check(!pk_release(B(3,4,'completion'),B(1,2,'availability'),B(5,6,'cutoff'),B(7,8,'start'))$supported,'Historical availability before completion conflict')
for(role in c('completion','availability','cutoff','start')) {
  vals<-list(completion=completed,availability=available,cutoff=cutoff,target_start=start)
  name<-if(role=='start')'target_start' else role
  for(state in c('UNKNOWN','AMBIGUOUS','CONFLICTING','SOURCE_LABEL','PUBLISHED_LITERAL')) {
    z<-vals;z[[name]]$state<-state
    check(!do.call(pk_release,z)$supported,paste(role,state,'fails'))
  }
  z<-vals;z[[name]]$clock<-'UNKNOWN';check(!do.call(pk_release,z)$supported,'Unknown timezone fails')
  z<-vals;z[[name]]$lower<-NA_real_;check(!do.call(pk_release,z)$supported,'Missing bound fails')
  z<-vals;z[[name]]$upper<-z[[name]]$lower-1;check(!do.call(pk_release,z)$supported,'Reversed bound fails')
}
check(!pk_release(pk_bound(),pk_bound(),pk_bound(),pk_bound(),precedence=TRUE)$supported,'Bracket edge cannot supply timing or availability')
check(!pk_release(pk_bound(),available,cutoff,start,precedence=TRUE)$supported,'Partial precedence cannot authenticate unknown completion bound')
check(!pk_release(completed,pk_bound(),cutoff,start,precedence=TRUE)$supported,'Precedence never replaces availability')
check(pk_release(completed,available,cutoff,pk_bound(),preplay_attested=TRUE)$supported,'Independently attested pre-play boundary need not have exact start time')
for(role in c('tourney_date','event_window','round','match_num','row_order','filename','page_order','retrieval_time','duration')) {
  bad<-B(2,3,role);check(!pk_release(completed,bad,cutoff,start)$supported,'Wrong semantic role rejected')
}
ids<-c('one','two')
check(pk_decide(c(TRUE,TRUE),TRUE,ids,ids)=='MATCH_SEQUENTIAL_SUPPORTED_BY_SAVED_EVIDENCE','Sequential decision precedence')
check(pk_decide(FALSE,TRUE,ids,ids)=='EVENT_ENTRY_ONLY_SUPPORTED_BY_SAVED_EVIDENCE','Event-only decision')
check(pk_decide(FALSE,FALSE,ids,ids)=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Neither decision')
check(pk_decide(TRUE,TRUE,ids,'one')=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Cannot shrink cohort for pass')
check(pk_decide(TRUE,TRUE,ids,c('one','one'))=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Duplicate cohort fails')
check(pk_decide(logical(),logical(),ids,ids)=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','No vacuous requirement pass')
check(pk_decide(TRUE,TRUE,character(),character())=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Empty cohort fails')
check(pk_decide(NA,NA,ids,ids)=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Unknown gate fails')
cat('Reading frozen evidence and building first audit\n')
input<-pk_inputs();r<-audit_pre_match_chronology(FALSE);x<-r[[1]];d<-r[[2]];s<-r[[3]]
check(nrow(x)==2580&&!anyDuplicated(x$match_id)&&identical(x$match_id,input$m$match_id),'Frozen membership exactly once')
check(identical(x$player_a_id,input$m$player_a_id)&&identical(x$player_b_id,input$m$player_b_id),'Neutral player slots unchanged')
check(length(unique(x$cell_id))==30,'All expected cells retained')
check(all(x$completion_status=='source_reported_normal'),'Completion disposition retained separately')
check(sum(nzchar(x$published_match_start))==7,'Seven admitted literals not actual dates')
check(nrow(input$pages)==9&&sum(!sub('^sackmann:','',input$pages$source_audit_id) %in% x$match_id)==2,'Two excluded retirement pages remain outside membership')
check(sum(x$player_chain_evidence=='SAVED_MONTREAL_PLAYER_CHAINS_ACCOUNTED')==49,'49 local chains retained')
check(all(x$actual_start_status=='UNKNOWN'&x$completion_time_status=='UNKNOWN'&x$result_availability_status=='UNKNOWN'),'No fabricated timing')
check(all(!x$match_sequential_supported&!x$event_entry_supported),'Measured readiness fails')
check(sum(nzchar(x$chronology_conflicts))==49,'All Montreal event conflicts retained')
check(sum(grepl('LS007_QF',x$chronology_conflicts))==1,'LS007 conflict retained')
check(sum(grepl('SCHEDULED_METADATA',x$chronology_conflicts))==7,'Scheduled/finished conflicts retained')
check(all(x$source_order_role=='LOCATOR_ONLY_NOT_CHRONOLOGY'),'Source fields cannot order matches')
# Perturb all prohibited chronology substitutes, without changing frozen on-disk inputs.
z<-input;z$d$tourney_date<-'20991231';z$d$match_num<-rev(z$d$match_num);z$d$minutes<-'0'
z$m$round<-rev(z$m$round);z$m$audit_source_row<-rev(z$m$audit_source_row);z$m$audit_file<-'invented-order-label'
z$pages$published_start_date<-'1900-01-01';z$pages$published_end_date<-'2999-12-31';z$pages$retrieved_at_utc<-'1900-01-01T00:00:00Z'
z$boundary$observed_value<-'19000101';zz<-pk_matches(z)
for(field in c('actual_start_status','completion_time_status','result_availability_status','cutoff_status','match_sequential_supported','event_entry_supported'))
  check(identical(x[[field]],zz[[field]]),'Labels never promoted to chronology')
check(!anyDuplicated(d$dependency_id),'Unique dependency rows')
check(sum(d$kind=='MATCH_CUTOFF')==2580&&sum(d$kind=='EVENT_CUTOFF')==30,'Every cutoff accounted for')
check(sum(d$kind=='EVENT_RELEASE_PAIR')==235,'Every same-tour unordered event pair including cross-season')
for(tour in c('ATP','WTA')) {
  z<-x[x$audit_tour==tour,];players<-table(c(z$player_a_id,z$player_b_id))
  pairs<-d[d$kind=='SHARED_PLAYER_MATCH_PAIR'&d$tour==tour,]
  check(nrow(pairs)==sum(players*(players-1)/2),'Exhaustive shared-player pair accounting')
  check(!anyDuplicated(paste(pairs$player_id,pairs$match_a,pairs$match_b)),'No duplicate player-pair membership')
  a<-match(pairs$match_a,z$match_id);b<-match(pairs$match_b,z$match_id)
  check(!anyNA(c(a,b))&&all(a!=b),'Only admitted distinct endpoints')
  check(all((pairs$player_id==z$player_a_id[a]|pairs$player_id==z$player_b_id[a])&(pairs$player_id==z$player_a_id[b]|pairs$player_id==z$player_b_id[b])),'Every pair shares the exact player in either slot')
}
edges<-d[d$kind=='SAVED_BRACKET_EDGE',]
check(nrow(edges)==54&&sum(edges$eligible_endpoints)==45,'All saved edges, nine excluded endpoints')
check(sum(edges$status=='EXCLUDED_ENDPOINT_AUDIT_ONLY')==9,'Excluded edges do not become updates')
check(sum(d$kind=='SHARED_PLAYER_MATCH_PAIR'&d$evidence_relation!='UNORDERED')==45,'Direct edge evidence attached without timestamps')
check(!any(d$a_to_b_release_supported|d$b_to_a_release_supported),'No supported temporal release')
check(s$value[s$section=='decision']=='NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE','Measured terminal result')
check(setequal(s$cell_id[s$section=='matches_cell_id'],x$cell_id),'All cells summarized, including blocked cells')
# Reordering the observed input rows cannot create a supported dependency direction.
z<-input;z$m<-z$m[nrow(z$m):1,];z$d<-z$d[nrow(z$d):1,]
reordered<-pk_dependencies(pk_matches(z),z)
check(identical(d,reordered),'Source row order irrelevant to dependency inventory')
cat('Independent rerun and byte comparison\n')
r2<-audit_pre_match_chronology(FALSE);t1<-tempfile('chronology-test-');t2<-tempfile('chronology-test-')
pk_publish(r,t1);pk_publish(r2,t2)
hashes<-function(dir)vapply(file.path(dir,paste0(pk_outputs,'.csv')),pk_hash,'')
check(identical(unname(hashes(t1)),unname(hashes(t2))),'Byte-identical complete reruns')
pk_publish(r,t1);bad<-r;bad[[1]]$match_id[1]<-'changed';check(fails(pk_publish(bad,t1)),'Different existing release preserved')
pk_verify();check(TRUE,'Historical pins still identical')
# Scope checks work both before staging and after committing this phase.
changed<-system2('git',c('diff','--name-only','23ebd592b30f7c107ef8d2ffd64850c9cb311c97'),stdout=TRUE)
untracked<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
check(all(c(changed,untracked) %in% expected_files),'No unintended tracked or nonignored files')
check(all(file.exists(expected_files)),'All five intended tracked files exist')
check(setequal(changed,expected_files),'Exact five-file tracked scope including staged additions')
for(p in c('R/audit_source_defined_cohort.R','R/test_source_defined_cohort.R','docs/source-defined-cohort-audit.md',
 'R/diagnose_service_game_conflicts.R','R/test_service_game_conflicts.R','docs/service-game-convention-diagnostic.md',
 'R/revalidate_broader_shortlist.R','R/test_broader_shortlist.R','docs/broader-shortlist-revalidation.md'))check(pk_hash(p)==pk_pins[[p]],'Phase H-J code/test/report preserved')
saveRDS(r,'/private/tmp/phase2k-tested.rds')
cat(sprintf('PASS: %d focused checks; independent complete reruns byte-identical.\n',checks))
