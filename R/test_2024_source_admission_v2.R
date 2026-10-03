# Focused Phase 2AB offline checks. No historical suite or network runner executes.
source('R/release_2024_source_admission_v2.R')
n<-0L
ok<-function(x,label){n<<-n+1L;if(!isTRUE(x))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern){x<-tryCatch({force(expr);NULL},error=identity);ok(inherits(x,'error')&&grepl(pattern,conditionMessage(x),fixed=TRUE),paste('fails closed',pattern))}
e<-ab_load();helpers<-e$z_load()
for(p in names(ab_pins))ok(ab_hash(p)==ab_pins[[p]],paste('pin',p))
bad<-ab_pins;bad[1]<-strrep('0',64);fail(ab_verify_pins(bad),'PIN_FAILURE')
m<-e$z_read(e$z_manifest);bad<-m[1,];bad$sha256<-strrep('0',64)
fail(e$z_verify(m$local_path[1],m$metadata_local_path[1],m[1,],helpers,bad),'MANIFEST_HASH_OR_BYTE_FAILURE')
fail(e$z_verify('missing-local-fixture',m$metadata_local_path[1],m[1,],helpers,m[1,]),'MISSING_FILE')
ok(!any(c('z_request','z_acquire','z_main','z_atomic_files') %in% ls(e)),'no network or historical runner imported')
old<-e$z_read('data/pilot/2024-source-admission/row-dispositions.csv')
r<-ab_build(e);d<-r[['row-dispositions']];scope<-ab_scope(d)
ok(nrow(d)==5765&&sum(scope)==110,'exact annual and exception accounting')
ok(all(table(d$event[scope])==55),'55 per approved family')
ok(all(d$tourney_level[scope]=='PM'),'literal PM retained')
for(k in e$z_schema)ok(identical(as.character(d[[k]]),old[[k]]),paste('raw field',k))
for(t in c('ATP','WTA')) {
 m<-e$z_read(e$z_config()$local_path[e$z_config()$tour==t]);q<-d[d$audit_tour==t,]
 ok(all(as.matrix(m[as.integer(q$audit_source_row),])==as.matrix(q[,e$z_schema])),paste(t,'exact source-row join'))
}
ok(identical(ab_chars(d[!scope,]),ab_chars(old[!scope,])),'all nonexception fields and dispositions unchanged')
ok(sum(d$membership[scope]=='INCLUDED')==105&&sum(d$membership[scope]=='EXCLUDED')==5,'105 admissions five exclusions')
ret<-scope&d$membership=='EXCLUDED'
ok(all(d$event[ret]=='Canada')&&all(d$completion_status[ret]=='retirement'),'Toronto retirements remain')
ok(identical(d$exclusion_reasons[ret],ab_without_level(old$exclusion_reasons[ret])),'every simultaneous retirement reason retained')
ok(nrow(r$membership)==1901&&!anyDuplicated(r$membership$match_id),'exact membership identifiers')
ok(all(r[['cell-summary']]$official_inventory_recall=='UNKNOWN'),'official recall unknown')
cells<-r[['cell-summary']];cells<-cells[cells$round=='ALL',]
ok(nrow(cells)==20&&all(cells$admitted_source_records>0),'twenty cells admitted')
for(t in c('ATP','WTA')) {q<-cells[cells$tour==t,];want<-if(t=='ATP')c(944,54) else c(957,41);ok(all(c(sum(q$admitted_source_records),sum(q$excluded_source_records))==want),paste(t,'totals'))}
ok(identical(as.character(r$membership$match_id),as.character(d$match_id[d$membership=='INCLUDED'])),'membership exact ledger join')
# Four-key negative fixtures: no broad PM substitution, including missing keys.
f<-old[which(ab_scope(old)&old$exclusion_reasons=='level_conflict')[1],]
for(k in c('audit_tour','audit_season','event','tourney_level'))for(v in c('OTHER','',NA_character_)) {
 q<-f;q[[k]]<-v;ok(identical(q,ab_apply(q)),paste('outside rule',k,v))
}
q<-f;q$tourney_level<-'P';ok(identical(q,ab_apply(q)),'P unchanged')
q<-f;q$audit_tour<-'ATP';q$audit_season<-'2023';ok(identical(q,ab_apply(q)),'other tour/year unchanged')
for(reason in c('identity_conflicting_id','duplicate_source_key','service_games_score_conflict','count_missing:w_df','status_retirement','event_label_conflict')) {
 q<-f;q$exclusion_reasons<-paste('level_conflict',reason,sep=';');q$context_reasons<-paste('level_conflict','surface_conflict',sep=';')
 a<-ab_apply(q);ok(a$exclusion_reasons==reason&&a$membership=='EXCLUDED'&&a$panel_disposition=='EXCLUDED'&&a$context_reasons=='surface_conflict',paste('independent gate',reason))
}
# Outcome changes cannot affect the mapping; inherited neutral slots are checked too.
rawcols<-c(e$z_schema,'audit_file','audit_tour','audit_season','audit_source_path','audit_source_row')
a<-f[,rawcols];b<-a
for(k in sub('^winner_','',grep('^winner_',names(a),value=TRUE))) {b[[paste0('winner_',k)]]<-a[[paste0('loser_',k)]];b[[paste0('loser_',k)]]<-a[[paste0('winner_',k)]]}
for(k in sub('^w_','',grep('^w_',names(a),value=TRUE))) {b[[paste0('w_',k)]]<-a[[paste0('l_',k)]];b[[paste0('l_',k)]]<-a[[paste0('w_',k)]]}
aa<-ab_apply(e$z_audit_rows(list(a),helpers));bb<-ab_apply(e$z_audit_rows(list(b),helpers))
ok(aa$membership==bb$membership&&aa$player_a_id==bb$player_a_id&&aa$player_b_id==bb$player_b_id&&aa$a_original_side!=bb$a_original_side,'outcome-neutral mapping and lexical slots')
ok(identical(ab_apply(old[nrow(old):1,])[,names(d)],ab_apply(old)[nrow(old):1,]),'row permutation')
# Discrepancies stop before any installation.
q<-d;q$membership[which(ret)[1]]<-'INCLUDED';fail(ab_delta(old,q,r[['cell-summary']],r$membership),'MEMBERSHIP_DELTA_DISCREPANCY')
q<-d;q$tourney_level[which(scope)[1]]<-'P';fail(ab_delta(old,q,r[['cell-summary']],r$membership),'SOURCE_OR_OTHER_FIELD_CHANGED')
q<-d;q$membership[which(!scope)[1]]<-'EXCLUDED';fail(ab_delta(old,q,r[['cell-summary']],r$membership),'OUTSIDE_CONTEXT_CHANGED')
# Independent fresh R processes reconstruct all six tables; directory rename is atomic.
tmp<-tempfile('ab-tests-');dir.create(tmp)
run<-function(){
 on.exit(unlink(tmp,recursive=TRUE),add=TRUE)
 dirs<-file.path(tmp,c('first','second'))
 for(dest in dirs) {
  script<-paste0("source('R/release_2024_source_admission_v2.R');e<-ab_load();e$z_install(ab_build(e),",deparse(dest),")")
  status<-system2(file.path(R.home('bin'),'Rscript'),c('-e',shQuote(script)),stdout=FALSE,stderr=FALSE)
  ok(status==0,'independent process succeeded')
 }
 files<-paste0(e$z_outputs,'.csv')
 for(k in files)ok(ab_hash(file.path(dirs[1],k))==ab_hash(file.path(dirs[2],k)),paste('byte-identical',k))
 ok(setequal(list.files(dirs[1]),files),'exact six outputs')
 dest<-file.path(tmp,'atomic')
 fail(e$z_install(r,dest,function(stage)stop('INTERRUPTION')),'INTERRUPTION')
 ok(!dir.exists(dest),'no partial destination on interruption')
 fail(e$z_install(r,dest,function(stage)cat('corrupt',file=file.path(stage,'summary.csv'))),'STAGE_CHANGED')
 ok(!dir.exists(dest),'no corrupt stage installed')
 e$z_install(r,dest);before<-vapply(file.path(dest,files),ab_hash,'')
 e$z_install(r,dest);ok(identical(before,vapply(file.path(dest,files),ab_hash,'')),'identical installation idempotent')
 bad<-r;bad$summary$value[1]<-'bad';fail(e$z_install(bad,dest),'EXISTING_OUTPUT_CONFLICT')
 ok(identical(before,vapply(file.path(dest,files),ab_hash,'')),'existing release never overwritten')
 ok(!any(grepl('^\\.2024-audit-',list.files(tmp,all.files=TRUE))),'temporary stages cleaned')
}
run()
fail(ab_install(r,dest='data/pilot/wrong'),'OUTPUT_LOCATION_FAILURE')
ok(e$z_ignored(file.path(ab_output,paste0(e$z_outputs,'.csv'))),'all production outputs ignored')
if(dir.exists(ab_output)) {
 ok(setequal(list.files(ab_output),paste0(e$z_outputs,'.csv')),'installed output scope')
 for(k in e$z_outputs)ok(identical(ab_chars(e$z_read(file.path(ab_output,paste0(k,'.csv')))),ab_chars(r[[k]])),paste('installed contents',k))
}
for(p in names(ab_pins))ok(ab_hash(p)==ab_pins[[p]],paste('historical preservation',p))
expected<-c('R/release_2024_source_admission_v2.R','R/test_2024_source_admission_v2.R','docs/2024-source-admission-v2.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
changed<-system2('git',c('diff','--name-only','6212fd583202970bc93141a84ed04db20d27e00a'),stdout=TRUE)
untracked<-system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)
# New source/report files can still be ignored before deliberate git add -f.
added<-expected[!vapply(expected,function(p)length(system2('git',c('ls-files','--',p),stdout=TRUE))>0,TRUE)&file.exists(expected)]
ok(setequal(unique(c(changed,untracked,added)),expected),'exact six-file tracked scope')
cat(n,'Phase 2AB focused checks passed\n')
