# Phase 2Z focused tests: local fixtures only; no network function is invoked.
source('R/acquire_audit_2024_source.R')
n<-0L
ok<-function(x,label) {n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern='') {r<-tryCatch({force(expr);NULL},error=identity);ok(inherits(r,'error')&&grepl(pattern,conditionMessage(r),fixed=TRUE),paste('failure',pattern))}
e<-z_load();c<-z_config();p<-e$sa_panel()
ok(nrow(p)==20&&!anyDuplicated(p$cell_id),'twenty panel cells')
ok(all(substr(p$tourney_id,1,4)=='2024'),'2024 label binding')
for(u in c(c$source_url,c$metadata_url))ok(isTRUE(z_allow(u)),'allowlisted')
for(u in c(sub('2024','2025',c$source_url),paste0(c$source_url,'?x=1'),sub(z_revision,'main',c$metadata_url),dirname(c$source_url),NA_character_))fail(z_allow(u),'ENDPOINT_NOT_ALLOWLISTED')
bad<-z_pins;bad[1]<-strrep('0',64);fail(z_rights(bad),'PIN_FAILURE')
# One independent valid two-set row: twelve service games, no tie-breaks.
fixture<-as.data.frame(setNames(rep(list(''),length(z_schema)),z_schema),stringsAsFactors=FALSE)
fixture[1,c('tourney_id','tourney_name','surface','tourney_level','tourney_date','match_num','winner_id','winner_name','winner_hand','loser_id','loser_name','loser_hand','score','best_of','round')]<-
 list('2024-0404','Indian Wells Masters','Hard','M','20240304','1','200','Player B','R','100','Player A','L','6-0 6-0','3','R64')
for(side in c('w','l'))for(k in c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpSaved','bpFaced'))fixture[[paste0(side,'_',k)]]<-as.character(c(ace=1,df=1,svpt=40,`1stIn`=25,`1stWon`=18,`2ndWon`=8,SvGms=6,bpSaved=2,bpFaced=3)[k])
annotate<-function(x){x$audit_file<-c$file[1];x$audit_tour<-'ATP';x$audit_season<-'2024';x$audit_source_path<-c$local_path[1];x$audit_source_row<-seq_len(nrow(x));x}
d<-annotate(fixture)
r<-z_audit_rows(list(d),e);ok(r$membership=='INCLUDED'&&r$player_a_id=='100'&&r$a_original_side=='loser','neutral valid fixture')
ok(all(r[paste0('effective_',e$sa_fields)]==d[e$sa_fields]),'unchanged effective counts')
for(sc in c('RET','W/O','DEF','ABD','UNFIN','6-4','6-4 4-6 8-6','6-4 6-4 6-4',''))ok(e$sa_score(sc,'3')$status!='source_reported_normal','completion rejection')
ok(e$sa_score('7-6(4) 6-4','3')$games==22,'tie-break service arithmetic')
a<-d;a$score<-'RET';a$w_df<-'99';a$loser_id<-a$winner_id
r<-z_audit_rows(list(a),e);ok(all(vapply(c('excluded_status:retirement','count_bound:w_df','identity_same_player'),function(x)grepl(x,r$exclusion_reasons,fixed=TRUE),TRUE)),'simultaneous reasons')
a<-d;a$w_SvGms<-'7';ok(grepl('service_games_score_conflict',z_audit_rows(list(a),e)$exclusion_reasons),'game conflict')
a<-d;a$w_df<-'';ok(z_audit_rows(list(a),e)$membership=='EXCLUDED','missing counts')
a<-d;a$tourney_id<-'2024-9999';ok(grepl('unresolved_source_edition',z_audit_rows(list(a),e)$context_reasons),'unknown edition recognized label')
a<-d;a$tourney_name<-'Other';a$tourney_id<-'2024-9999';ok(z_audit_rows(list(a),e)$membership=='OUTSIDE_PANEL','outside inventory')
a<-d;a$surface<-'Clay';a$tourney_date<-'20240230';a$round<-'Q1';r<-z_audit_rows(list(a),e);ok(all(vapply(c('surface_conflict','event_date_or_season_conflict','non_main_draw_or_unknown_round'),function(x)grepl(x,r$context_reasons),TRUE)),'context failures')
a<-rbind(d,d);a$audit_source_row<-1:2;r<-z_audit_rows(list(a),e);ok(all(r$membership=='EXCLUDED')&&all(grepl('duplicate_source_key',r$duplicate_reasons)),'all duplicate copies')
h<-d;h$winner_name<-'Conflicting Name';ok(grepl('identity_conflicting_id',z_audit_rows(list(d),e,h)$identity_reasons),'saved identity conflict')
a<-d;a$winner_id<-'100';a$loser_id<-'200';a$winner_name<-'Player A';a$loser_name<-'Player B';a$winner_hand<-'L';a$loser_hand<-'R';ok(z_audit_rows(list(a),e)$player_a_id=='100','slot neutrality to outcome')
# Metadata and byte verification are tested with locally generated JSON, never requests.
tmp<-tempfile('phase2z-test-');dir.create(tmp);on.exit_cleanup<-function()unlink(tmp,recursive=TRUE)
raw<-file.path(tmp,'fixture.csv');meta<-file.path(tmp,'fixture.json')
write.table(fixture,raw,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE,na='')
metadata<-function(raw,config=c[1,]) {
 vals<-list(name=config$file,path=config$source_path,type='file',download_url=config$source_url,url=config$metadata_url,sha=e$annual_2021_blob(raw),size=as.character(file.info(raw)$size))
 text<-c('{',vapply(names(vals),function(k)paste0('  "',k,'": ',if(k=='size')vals[[k]] else paste0('"',vals[[k]],'"'),if(k!='size')',' else ''),''),'}')
 writeLines(text,meta)
}
metadata(raw);v<-z_verify(raw,meta,c[1,],e);ok(v$row_count==1,'fixture parsing and metadata pass')
fail(z_verify(paste0(raw,'missing'),meta,c[1,],e),'MISSING_FILE')
b<-c[1,];b$pinned_commit<-'main';fail(z_verify(raw,meta,b,e),'REVISION_FAILURE')
a<-v;a$sha256<-strrep('0',64);fail(z_verify(raw,meta,c[1,],e,a),'MANIFEST_HASH_OR_BYTE_FAILURE')
write('x',raw,append=TRUE);fail(z_verify(raw,meta,c[1,],e),'BYTE_SIZE_OR_GIT_BLOB_FAILURE')
writeLines('bad,header\n1,2',raw);metadata(raw);fail(z_verify(raw,meta,c[1,],e),'SCHEMA_FAILURE')
write.table(fixture,raw,sep=',',row.names=FALSE,col.names=TRUE,quote=FALSE);metadata(raw)
s<-readLines(meta);writeLines(sub('atp/atp_matches_2024','atp/other',s,fixed=TRUE),meta);fail(z_verify(raw,meta,c[1,],e),'metadata mismatch')
files<-c;files$state<-'VERIFIED';files$reason<-''
r<-z_audit_rows(list(d),e);cc<-e$sa_coverage(r,files)
ok(nrow(cc$coverage[cc$coverage$round=='ALL',])==20,'absent-cell accounting')
ok(sum(cc$coverage$state=='ABSENT_SOURCE_CELL')==19,'nineteen absent cells')
ok(all(cc$coverage$official_inventory_recall=='UNKNOWN'),'no official recall')
allcells<-cc$coverage[cc$coverage$round=='ALL',];ok(z_decision(files,allcells,r)=='2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED','partial precedence')
files$state[1]<-'BLOCKED';ok(z_decision(files,allcells,r)=='2024_SOURCE_ACQUISITION_BLOCKED','blocked precedence')
files$state<-'VERIFIED';allcells$observed_source_rows<-allcells$admitted_source_records<-1
ok(z_decision(files,allcells,r)=='2024_SOURCE_COHORT_READY_FOR_HISTORY_BUILD','ready conditions')
r$identity_reasons<-'conflict';ok(z_decision(files,allcells,r)=='2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED','identity partial precedence')
# Manifest-last transaction: a fault cannot expose an accepted partial release.
src<-file.path(tmp,'stage');dest<-file.path(tmp,'installed');commit<-file.path(tmp,'manifest.csv');writeLines('bytes',src)
fail(z_atomic_files(src,dest,commit,data.frame(x=1),hook=function(i)if(i==2)stop('injected')),'injected')
ok(file.exists(dest)&&!file.exists(commit),'partial transaction uncommitted')
fail(z_atomic_files(src,dest,commit,data.frame(x=1)),'EXISTING_RELEASE')
ok(z_ignored(c(c$local_path,c$metadata_local_path,paste0(z_output,'/',z_outputs,'.csv'))),'all ten files ignored')
# Optional installed evidence is read offline; never call z_request/z_acquire here.
if(file.exists(z_manifest)&&all(z_read(z_manifest)$state=='VERIFIED')) {
 a<-z_build(e);b<-z_build(e)
 ok(identical(a,b),'offline deterministic tables')
 dest<-file.path(tmp,'audit');z_install(a,dest);hash<-vapply(file.path(dest,paste0(z_outputs,'.csv')),z_hash,'');z_install(b,dest)
 ok(identical(hash,vapply(file.path(dest,paste0(z_outputs,'.csv')),z_hash,'')),'byte-identical offline installation')
 corrupt<-file.path(tmp,'corrupt');fail(z_install(a,corrupt,function(s)writeLines('bad',file.path(s,'membership.csv'))),'STAGE_CHANGED');ok(!dir.exists(corrupt),'no partial audit release')
 rr<-a[['row-dispositions']];mm<-a$membership;cells<-a[['cell-summary']]
 ok(!anyDuplicated(paste(rr$audit_file,rr$audit_source_row)),'one disposition per source row')
 ok(nrow(rr)==sum(as.integer(z_read(z_manifest)$row_count)),'annual accounting')
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
# Provenance failures and installed summary completeness, without acquisition.
m<-z_read(z_manifest);ok(z_hash(z_manifest)==z_manifest_pin,'frozen manifest pin')
for(k in c('source_url','metadata_url','pinned_commit','license_id','original_creator','local_path')) {
 bad<-m;bad[[k]][1]<-'changed';fail(z_manifest_check(bad),'MANIFEST_CONFIG_FAILURE')
}
bad<-m;bad$retrieved_at_utc[1]<-'';fail(z_manifest_check(bad),'PROVENANCE_TIME_FAILURE')
bad<-m;bad$sha256[1]<-'';fail(z_manifest_check(bad),'PROVENANCE_HASH_FAILURE')
bad<-m;bad$state<-'BLOCKED';bad$reason<-'fixture missing files'
x<-z_build(e,bad);ok(nrow(x$membership)==0&&all(x[['cell-summary']]$state=='FILE_BLOCKED'),'both-file blocked outputs')
bad<-m;bad$sha256[1]<-strrep('0',64);x<-z_build(e,bad)
ok(x$provenance$state[1]=='BLOCKED'&&!any(x$membership$audit_tour=='ATP'),'affected file fails before admission')
a<-z_build(e);rr<-a[['row-dispositions']];ff<-a[['field-availability']]
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
 z<-rr[rr$audit_file==m$file[i],z_schema,drop=FALSE];rownames(raw)<-rownames(z)<-NULL
 ok(identical(raw,z),'all source values unchanged')
}
base<-'a3735df1c6c3e3203cfdafa2fc81f6c05efb0a34'
allowed<-c('R/acquire_audit_2024_source.R','R/test_2024_source_admission.R','data/manifests/validation-2024-source-files.csv','docs/2024-source-admission-audit.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
changed<-system2('git',c('diff','--name-only',base),stdout=TRUE)
ok(setequal(changed,allowed),'exact seven-file tracked scope')
for(p in c(names(z_pins),z_config()$local_path,z_config()$metadata_local_path))ok(file.exists(p),'saved inputs exist')
# No metadata body outside the expected scalar schema may clear the byte gate.
writeLines('<html>404 Not Found</html>',meta);fail(e$annual_2021_metadata(meta,c[1,]),'not a JSON object')
q<-d;q$audit_file<-c$file[2];q$audit_tour<-'WTA';q$audit_source_path<-c$local_path[2]
q$tourney_id<-'2024-806';q$tourney_name<-'Toronto';q$tourney_level<-'PM'
x<-z_audit_rows(list(q),e);ok(x$membership=='EXCLUDED'&&grepl('level_conflict',x$context_reasons),'frozen Canada level cannot adapt')
q$tourney_id<-'2024-999';q$tourney_name<-'Montreal';x<-z_audit_rows(list(q),e)
ok(x$membership=='EXCLUDED'&&x$event=='Canada','known alternate city remains conflicted candidate')
src2<-file.path(tmp,'raw-stage');dest2<-file.path(tmp,'raw-final');m2<-file.path(tmp,'raw-manifest')
writeLines('good',src2);fail(z_atomic_files(src2,dest2,m2,data.frame(x=1),function(i)writeLines('corrupt',src2)),'RAW_STAGE_CHANGED')
ok(!file.exists(dest2)&&!file.exists(m2),'raw corruption cannot commit')
on.exit_cleanup()
cat(n,'focused Phase 2Z checks passed; no network calls in tests\n')
