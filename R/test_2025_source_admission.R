# Phase 2AH focused tests: local fixtures only; no network function is invoked.
source('R/acquire_audit_2025_source.R')
n<-0L
ok<-function(x,label) {n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern='') {r<-tryCatch({force(expr);NULL},error=identity);ok(inherits(r,'error')&&grepl(pattern,conditionMessage(r),fixed=TRUE),paste('failure',pattern))}
e<-ah_load();c<-ah_config();p<-e$sa_panel()
ok(nrow(p)==20&&!anyDuplicated(p$cell_id),'twenty panel cells')
ok(all(substr(p$tourney_id,1,4)=='2025'),'2025 label binding')
for(u in c(c$source_url,c$metadata_url))ok(isTRUE(ah_allow(u)),'allowlisted')
for(u in c(sub('2025','2024',c$source_url),paste0(c$source_url,'?x=1'),sub(ah_revision,'main',c$metadata_url),dirname(c$source_url),NA_character_))fail(ah_allow(u),'ENDPOINT_NOT_ALLOWLISTED')
bad<-ah_pins;bad[1]<-strrep('0',64);fail(ah_rights(bad),'PIN_FAILURE')
# One independent valid two-set row: twelve service games, no tie-breaks.
fixture<-as.data.frame(setNames(rep(list(''),length(ah_schema)),ah_schema),stringsAsFactors=FALSE)
fixture[1,c('tourney_id','tourney_name','surface','tourney_level','tourney_date','match_num','winner_id','winner_name','winner_hand','loser_id','loser_name','loser_hand','score','best_of','round')]<-
 list('2025-0404','Indian Wells Masters','Hard','M','20250304','1','200','Player B','R','100','Player A','L','6-0 6-0','3','R64')
for(side in c('w','l'))for(k in c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpSaved','bpFaced'))fixture[[paste0(side,'_',k)]]<-as.character(c(ace=1,df=1,svpt=40,`1stIn`=25,`1stWon`=18,`2ndWon`=8,SvGms=6,bpSaved=2,bpFaced=3)[k])
annotate<-function(x){x$audit_file<-c$file[1];x$audit_tour<-'ATP';x$audit_season<-'2025';x$audit_source_path<-c$local_path[1];x$audit_source_row<-seq_len(nrow(x));x}
d<-annotate(fixture)
r<-ah_audit_rows(list(d),e);ok(r$membership=='INCLUDED'&&r$player_a_id=='100'&&r$a_original_side=='loser','neutral valid fixture')
ok(all(r[paste0('effective_',e$sa_fields)]==d[e$sa_fields]),'unchanged effective counts')
for(sc in c('RET','W/O','DEF','ABD','UNFIN','6-4','6-4 4-6 8-6','6-4 6-4 6-4',''))ok(e$sa_score(sc,'3')$status!='source_reported_normal','completion rejection')
ok(e$sa_score('7-6(4) 6-4','3')$games==22,'tie-break service arithmetic')
a<-d;a$score<-'RET';a$w_df<-'99';a$loser_id<-a$winner_id
r<-ah_audit_rows(list(a),e);ok(all(vapply(c('excluded_status:retirement','count_bound:w_df','identity_same_player'),function(x)grepl(x,r$exclusion_reasons,fixed=TRUE),TRUE)),'simultaneous reasons')
a<-d;a$w_SvGms<-'7';ok(grepl('service_games_score_conflict',ah_audit_rows(list(a),e)$exclusion_reasons),'game conflict')
a<-d;a$w_df<-'';ok(ah_audit_rows(list(a),e)$membership=='EXCLUDED','missing counts')
a<-d;a$tourney_id<-'2025-9999';ok(grepl('unresolved_source_edition',ah_audit_rows(list(a),e)$context_reasons),'unknown edition recognized label')
a<-d;a$tourney_name<-'Other';a$tourney_id<-'2025-9999';ok(ah_audit_rows(list(a),e)$membership=='OUTSIDE_PANEL','outside inventory')
a<-d;a$surface<-'Clay';a$tourney_date<-'20250230';a$round<-'Q1';r<-ah_audit_rows(list(a),e);ok(all(vapply(c('surface_conflict','event_date_or_season_conflict','non_main_draw_or_unknown_round'),function(x)grepl(x,r$context_reasons),TRUE)),'context failures')
a<-rbind(d,d);a$audit_source_row<-1:2;r<-ah_audit_rows(list(a),e);ok(all(r$membership=='EXCLUDED')&&all(grepl('duplicate_source_key',r$duplicate_reasons)),'all duplicate copies')
h<-d;h$winner_name<-'Conflicting Name';ok(grepl('identity_conflicting_id',ah_audit_rows(list(d),e,h)$identity_reasons),'saved identity conflict')
a<-d;a$winner_id<-'100';a$loser_id<-'200';a$winner_name<-'Player A';a$loser_name<-'Player B';a$winner_hand<-'L';a$loser_hand<-'R';ok(ah_audit_rows(list(a),e)$player_a_id=='100','slot neutrality to outcome')
# Metadata and byte verification are tested with locally generated JSON, never requests.
tmp<-tempfile('phase2ah-test-');dir.create(tmp);on.exit_cleanup<-function()unlink(tmp,recursive=TRUE)
raw<-file.path(tmp,'fixture.csv');meta<-file.path(tmp,'fixture.json')
write.table(fixture,raw,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE,na='')
metadata<-function(raw,config=c[1,]) {
 vals<-list(name=config$file,path=config$source_path,type='file',download_url=config$source_url,url=config$metadata_url,sha=e$annual_2021_blob(raw),size=as.character(file.info(raw)$size))
 text<-c('{',vapply(names(vals),function(k)paste0('  "',k,'": ',if(k=='size')vals[[k]] else paste0('"',vals[[k]],'"'),if(k!='size')',' else ''),''),'}')
 writeLines(text,meta)
}
metadata(raw);v<-ah_verify(raw,meta,c[1,],e);ok(v$row_count==1,'fixture parsing and metadata pass')
fail(ah_verify(paste0(raw,'missing'),meta,c[1,],e),'MISSING_FILE')
b<-c[1,];b$pinned_commit<-'main';fail(ah_verify(raw,meta,b,e),'REVISION_FAILURE')
a<-v;a$sha256<-strrep('0',64);fail(ah_verify(raw,meta,c[1,],e,a),'MANIFEST_HASH_OR_BYTE_FAILURE')
write('x',raw,append=TRUE);fail(ah_verify(raw,meta,c[1,],e),'BYTE_SIZE_OR_GIT_BLOB_FAILURE')
writeLines('bad,header\n1,2',raw);metadata(raw);fail(ah_verify(raw,meta,c[1,],e),'SCHEMA_FAILURE')
write.table(fixture,raw,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE);metadata(raw)
s<-readLines(meta);writeLines(sub('atp/atp_matches_2025','atp/other',s,fixed=TRUE),meta);fail(ah_verify(raw,meta,c[1,],e),'metadata mismatch')
files<-c;files$state<-'VERIFIED';files$reason<-''
r<-ah_audit_rows(list(d),e);cc<-e$sa_coverage(r,files)
ok(nrow(cc$coverage[cc$coverage$round=='ALL',])==20,'absent-cell accounting')
ok(sum(cc$coverage$state=='ABSENT_SOURCE_CELL')==19,'nineteen absent cells')
ok(all(cc$coverage$official_inventory_recall=='UNKNOWN'),'no official recall')
allcells<-cc$coverage[cc$coverage$round=='ALL',];ok(ah_decision(files,allcells,r)=='2025_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED','partial precedence')
files$state[1]<-'BLOCKED';ok(ah_decision(files,allcells,r)=='2025_SOURCE_ACQUISITION_BLOCKED','blocked precedence')
files$state<-'VERIFIED';allcells$observed_source_rows<-allcells$admitted_source_records<-1
ok(ah_decision(files,allcells,r)=='2025_SOURCE_COHORT_READY_FOR_HISTORY_BUILD','ready conditions')
r$identity_reasons<-'conflict';ok(ah_decision(files,allcells,r)=='2025_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED','identity partial precedence')
# Manifest-last transaction: a fault cannot expose an accepted partial release.
src<-file.path(tmp,'stage');dest<-file.path(tmp,'installed');commit<-file.path(tmp,'manifest.csv');writeLines('bytes',src)
fail(ah_atomic_files(src,dest,commit,data.frame(x=1),hook=function(i)if(i==2)stop('injected')),'injected')
ok(file.exists(dest)&&!file.exists(commit),'partial transaction uncommitted')
fail(ah_atomic_files(src,dest,commit,data.frame(x=1)),'EXISTING_RELEASE')
ok(ah_ignored(c(c$local_path,c$metadata_local_path,paste0(ah_output,'/',ah_outputs,'.csv'))),'all ten files ignored')
# Optional installed evidence is read offline; never call ah_request/ah_acquire here.
if(file.exists(ah_manifest)&&all(ah_read(ah_manifest)$state=='VERIFIED')) {
 a<-ah_build(e);b<-ah_build(e)
 ok(identical(a,b),'offline deterministic tables')
 dest<-file.path(tmp,'audit');ah_install(a,dest);hash<-vapply(file.path(dest,paste0(ah_outputs,'.csv')),ah_hash,'');ah_install(b,dest)
 ok(identical(hash,vapply(file.path(dest,paste0(ah_outputs,'.csv')),ah_hash,'')),'byte-identical offline installation')
 corrupt<-file.path(tmp,'corrupt');fail(ah_install(a,corrupt,function(s)writeLines('bad',file.path(s,'membership.csv'))),'STAGE_CHANGED');ok(!dir.exists(corrupt),'no partial audit release')
 rr<-a[['row-dispositions']];mm<-a$membership;cells<-a[['cell-summary']]
 ok(!anyDuplicated(paste(rr$audit_file,rr$audit_source_row)),'one disposition per source row')
 ok(nrow(rr)==sum(as.integer(ah_read(ah_manifest)$row_count)),'annual accounting')
 ok(setequal(mm$match_id,rr$match_id[rr$membership=='INCLUDED']),'exact membership')
 ok(!any(mm$count_origin!='original_source')&&!any(rr$quarantined=='TRUE'),'no pilot override transfer')
 ok(nrow(cells[cells$round=='ALL',])==20,'installed twenty cells')
 for(t in c('ATP','WTA')) {
  z<-rr[rr$audit_tour==t&rr$membership!='OUTSIDE_PANEL',];cs<-cells[cells$tour==t&cells$round=='ALL',]
  ok(nrow(z)==sum(as.integer(cs$observed_source_rows)),'panel count reconciliation')
  ok(sum(z$membership=='INCLUDED')==sum(as.integer(cs$admitted_source_records)),'admission reconciliation')
 }
 for(i in seq_len(nrow(mm)))ok(identical(sort(c(mm$winner_id[i],mm$loser_id[i]),method='radix'),c(mm$player_a_id[i],mm$player_b_id[i])),'all-row neutral orientation')
 for(k in e$sa_fields)ok(identical(rr[[k]][rr$membership!='OUTSIDE_PANEL'],rr[[paste0('effective_',k)]][rr$membership!='OUTSIDE_PANEL']),'original counts retained')
}
# Installed provenance and summaries are optional before first access.
if(file.exists(ah_manifest)) {
m<-ah_read(ah_manifest)
for(k in c('source_url','metadata_url','pinned_commit','license_id','original_creator','local_path')) {
 bad<-m;bad[[k]][1]<-'changed';fail(ah_manifest_check(bad),'MANIFEST_CONFIG_FAILURE')
}
bad<-m;bad$retrieved_at_utc[1]<-'';fail(ah_manifest_check(bad),'PROVENANCE_TIME_FAILURE')
bad<-m;bad$sha256[1]<-'';fail(ah_manifest_check(bad),'PROVENANCE_HASH_FAILURE')
bad<-m;bad$state<-'BLOCKED';bad$reason<-'fixture missing files'
x<-ah_build(e,bad);ok(nrow(x$membership)==0&&all(x[['cell-summary']]$state=='FILE_BLOCKED'),'both-file blocked outputs')
bad<-m;bad$sha256[1]<-strrep('0',64);x<-ah_build(e,bad)
ok(x$provenance$state[1]=='BLOCKED'&&!any(x$membership$audit_tour=='ATP'),'affected file fails before admission')
a<-ah_build(e);rr<-a[['row-dispositions']];ff<-a[['field-availability']]
for(i in seq_len(nrow(ff))) {
 q<-ff[i,];z<-rr[rr$audit_tour==q$tour&rr$event==q$event&rr$membership!='OUTSIDE_PANEL',,drop=FALSE]
 if(q$round!='ALL')z<-z[z$round==q$round,,drop=FALSE]
 ok(q$observed_source_rows==nrow(z)&&q$present==sum(!z[[q$field]] %in% c('','NA')),'all field denominators and presence')
}
for(i in seq_len(nrow(a$summary))) {
 q<-a$summary[i,]
 if(startsWith(q$measure,'exclusion:')) {
  reason<-substring(q$measure,11);z<-rr[rr$audit_tour==q$group,]
  ok(as.integer(q$value)==sum(vapply(strsplit(z$exclusion_reasons,';',fixed=TRUE),function(v)reason %in% v,TRUE)),'all reason summaries')
 }
}
# All raw row columns round-trip exactly; no old override enters the new cohort.
for(i in 1:2) {
 raw<-e$annual_2021_csv(m$local_path[i]);raw[is.na(raw)]<-''
 z<-rr[rr$audit_file==m$file[i],ah_schema,drop=FALSE];rownames(raw)<-rownames(z)<-NULL
 ok(identical(raw,z),'all source values unchanged')
}
}
# No metadata body outside the expected scalar schema may clear the byte gate.
writeLines('<html>404 Not Found</html>',meta);fail(e$annual_2021_metadata(meta,c[1,]),'not a JSON object')
q<-d;q$audit_file<-c$file[2];q$audit_tour<-'WTA';q$audit_source_path<-c$local_path[2]
q$tourney_id<-'2025-806';q$tourney_name<-'Montreal';q$tourney_level<-'PM'
x<-ah_audit_rows(list(q),e);ok(x$membership=='EXCLUDED'&&grepl('level_conflict',x$context_reasons),'frozen Canada level cannot adapt')
q$tourney_id<-'2025-999';q$tourney_name<-'Toronto';x<-ah_audit_rows(list(q),e)
ok(x$membership=='EXCLUDED'&&x$event=='Canada','known alternate city remains conflicted candidate')
src2<-file.path(tmp,'raw-stage');dest2<-file.path(tmp,'raw-final');m2<-file.path(tmp,'raw-manifest')
writeLines('good',src2);fail(ah_atomic_files(src2,dest2,m2,data.frame(x=1),function(i)writeLines('corrupt',src2)),'RAW_STAGE_CHANGED')
ok(!file.exists(dest2)&&!file.exists(m2),'raw corruption cannot commit')
# Every required component rejects missing, negative and fractional values.
for(k in e$sa_fields)for(value in c('', '-1', '0.5')) {
 q<-d;q[[k]]<-value;x<-ah_audit_rows(list(q),e)
 ok(x$membership=='EXCLUDED'&&nzchar(x$count_reasons),'invalid component fixture')
}
# Every expected registry cell is tested before access; no PM exception transfers.
for(i in seq_len(nrow(p))) {
 q<-d;q$audit_file<-p$file[i];q$audit_tour<-p$tour[i];q$audit_source_path<-c$local_path[match(p$tour[i],c$tour)]
 q$tourney_id<-p$tourney_id[i];q$tourney_name<-p$label[i];q$tourney_level<-p$level[i];q$surface<-p$surface[i];q$best_of<-p$best_of[i]
 q$score<-if(q$best_of=='5')'6-0 6-0 6-0' else '6-0 6-0'
 q$w_SvGms<-q$l_SvGms<-if(q$best_of=='5')'9' else '6'
 x<-ah_audit_rows(list(q),e);ok(x$membership=='INCLUDED'&&x$cell_id==p$cell_id[i],'frozen family fixture')
 if(p$tour[i]=='WTA'&&p$event[i] %in% c('Canada','Cincinnati')) {
  q$tourney_level<-'PM';x<-ah_audit_rows(list(q),e)
  ok(x$membership=='EXCLUDED'&&x$tourney_level=='PM'&&grepl('level_conflict',x$exclusion_reasons),'no year transfer of PM')
  q$score<-'RET';x<-ah_audit_rows(list(q),e);ok(grepl('level_conflict',x$exclusion_reasons)&&grepl('excluded_status:retirement',x$exclusion_reasons),'independent PM/retirement exclusions')
 }
}
# Inherited quarantine logic remains restrictive, but no old record can link by year.
pilot<-data.frame(match_id='ATP:2025-0404:1',source_winner_id=d$winner_id,source_loser_id=d$loser_id,
 source_winner_name=d$winner_name,source_loser_name=d$loser_name,round=d$round,source_score=d$score,source_path=d$audit_source_path,
 status_policy='fixture',conflict_detail='fixture',official_id='fixture',quarantined='TRUE',status='normally_completed',count_origin='original_source')
x<-e$sa_dispositions(d,pilot,data.frame());ok(x$membership=='EXCLUDED'&&x$quarantined,'quarantine helper excludes')
# Source permutation preserves dispositions by source row; full neutral side swaps.
a<-d;b<-d;b$match_num<-'2';b$audit_source_row<-2;b$winner_id<-'300';b$winner_name<-'Player C'
x<-ah_audit_rows(list(rbind(a,b)),e);y<-ah_audit_rows(list(rbind(b,a)),e);rownames(x)<-rownames(y)<-NULL
ok(identical(x,y),'source permutation invariance')
b<-d
for(k in sub('^winner_','',grep('^winner_',names(d),value=TRUE))) {b[[paste0('winner_',k)]]<-d[[paste0('loser_',k)]];b[[paste0('loser_',k)]]<-d[[paste0('winner_',k)]]}
for(k in sub('^w_','',grep('^w_',names(d),value=TRUE))) {b[[paste0('w_',k)]]<-d[[paste0('l_',k)]];b[[paste0('l_',k)]]<-d[[paste0('w_',k)]]}
x<-ah_audit_rows(list(d),e);y<-ah_audit_rows(list(b),e)
ok(x$membership==y$membership&&x$player_a_id==y$player_a_id&&x$player_b_id==y$player_b_id&&x$a_original_side!=y$a_original_side,'full outcome-neutral swap')
# Local fake acquisition tests exercise the complete transaction without requests.
saved_manifest<-ah_manifest;saved_config<-ah_config;saved_output<-ah_output;saved_ignored<-ah_ignored
saved_freeze<-ah_freeze;saved_rights<-ah_rights
ah_manifest<-file.path(tmp,'fixture-manifest.csv');ah_output<-file.path(tmp,'fixture-output')
ah_ignored<-function(paths)TRUE
ah_config<-function() {v<-saved_config();v$local_path<-file.path(tmp,v$file);v$metadata_local_path<-file.path(tmp,basename(v$metadata_local_path));v}
ah_freeze<-function()c(pre_request_code_sha256=strrep('a',64),pre_request_test_sha256=strrep('b',64),admission_frozen_at_utc='2026-01-01T00:00:00Z')
calls<-character()
fake_request<-function(url,dest) {
 ah_allow(url);calls<<-c(calls,url);v<-ah_config();i<-match(url,c(v$source_url,v$metadata_url));row<-v[if(i>2)i-2 else i,]
 if(i<=2)write.table(fixture,dest,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE) else {
  local<-file.path(tmp,'fake-bytes');write.table(fixture,local,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE)
  metadata(local,row);file.copy(meta,dest,overwrite=FALSE)
 }
 '2026-01-01T00:00:01Z'
}
frozen_rights<-ah_freeze
ah_freeze<-function(){stop('RIGHTS_BLOCKED')};fail(ah_acquire(e,fake_request),'RIGHTS_BLOCKED');ok(length(calls)==0,'rights before any request')
ah_freeze<-frozen_rights
m<-ah_acquire(e,fake_request);ok(length(calls)==4&&setequal(calls,ah_endpoints)&&all(m$state=='VERIFIED'),'four endpoint fake acquisition')
ah_manifest_check(m)
for(i in 1:2)ok(ah_verify(m$local_path[i],m$metadata_local_path[i],m[i,],e,m[i,])$row_count==1,'installed fixture bytes')
fail(ah_acquire(e,fake_request),'MANIFEST_EXISTS_USE_OFFLINE');ok(length(calls)==4,'no retry of existing release')
result<-ah_build(e,m);dest<-file.path(tmp,'fixture-audit')
ah_install(result,dest);before<-vapply(file.path(dest,paste0(ah_outputs,'.csv')),ah_hash,'')
ah_install(ah_build(e,m),dest);ok(identical(before,vapply(file.path(dest,paste0(ah_outputs,'.csv')),ah_hash,'')),'fixture deterministic bytes')
bad<-result;bad$summary$value[1]<-'changed';fail(ah_install(bad,dest),'EXISTING_OUTPUT_CONFLICT')
fail(ah_install(result,paste0(dest,'interrupted'),function(stage)stop('INTERRUPTED')),'INTERRUPTED')
ok(!dir.exists(paste0(dest,'interrupted')),'audit interruption atomic')
fail(ah_install(result,paste0(dest,'corrupt'),function(stage)cat('bad',file=file.path(stage,'membership.csv'))),'STAGE_CHANGED')
ok(!dir.exists(paste0(dest,'corrupt')),'audit corruption atomic')

# Other isolated fixture destinations: affected metadata failure never requests raw.
ah_manifest<-file.path(tmp,'blocked-manifest.csv');ah_config<-function(){v<-saved_config();v$local_path<-paste0(file.path(tmp,v$file),'.blocked');v$metadata_local_path<-paste0(file.path(tmp,basename(v$metadata_local_path)),'.blocked');v}
calls<-character();bad_request<-function(url,dest){calls<<-c(calls,url);stop('HTTP_OR_REDIRECT_FAILURE')}
m<-ah_acquire(e,bad_request);ok(length(calls)==2&&all(calls %in% ah_config()$metadata_url)&&all(m$state=='BLOCKED'),'missing or redirect metadata blocks affected raw request')
ah_manifest<-saved_manifest;ah_config<-saved_config;ah_output<-saved_output;ah_ignored<-saved_ignored;ah_freeze<-saved_freeze;ah_rights<-saved_rights
# Exact frozen helper hashes are checked without running historical suites.
for(path in names(ah_pins))ok(ah_hash(path)==ah_pins[[path]],paste('historical pin',path))
if(file.exists(ah_manifest)) {
 r<-ah_build(e);destinations<-file.path(tmp,c('independent-one','independent-two'))
 for(dest in destinations) {
  script<-paste0("source('R/acquire_audit_2025_source.R');ah_install(ah_build(ah_load()),",deparse(dest),")")
  status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)),stdout=FALSE,stderr=FALSE)
  ok(status==0,'independent offline process')
 }
 for(k in ah_outputs)ok(ah_hash(file.path(destinations[1],paste0(k,'.csv')))==ah_hash(file.path(destinations[2],paste0(k,'.csv'))),'independent bytes identical')
 if(dir.exists(ah_output)) {
  ok(setequal(list.files(ah_output),paste0(ah_outputs,'.csv')),'exact six installed outputs')
  for(k in ah_outputs)ok(ah_hash(file.path(ah_output,paste0(k,'.csv')))==ah_hash(file.path(destinations[1],paste0(k,'.csv'))),'installed output bytes')
 }
 expected<-c('R/acquire_audit_2025_source.R','R/test_2025_source_admission.R','data/manifests/final-test-2025-source-files.csv','docs/2025-source-admission-audit.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
 changed<-system2('git',c('diff','--name-only','1b3372de8f3c5fa806ac0923d81038b2b5ae6876'),stdout=TRUE)
 untracked<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
 added<-expected[file.exists(expected)&!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)]
 ok(all(unique(c(changed,untracked,added)) %in% expected),'no extra tracked changes')
}
on.exit_cleanup()
cat(n,'focused Phase 2AH checks passed; no network calls in tests\n')
