# Phase 2Z 1.0.0. Base R; source has no side effects. Network requires --acquire.
z_revision <- '83733587353df8a41f2fd4f516147d5aa83f5a8d'
z_manifest <- 'data/manifests/validation-2024-source-files.csv'
z_manifest_pin <- '0b9cc7331a00577b190cdeb894ca4d7caad3ce533d7006d2d45a4450b2ab3a72'
z_output <- 'data/pilot/2024-source-admission'
z_outputs <- c('provenance','row-dispositions','membership','cell-summary','field-availability','summary')
z_pins <- c(
 'DATA_LICENSE.md'='f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880',
 'data/manifests/pilot-source-files.csv'='2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b',
 'R/audit_source_defined_cohort.R'='73b79972d2d4bb0c8d651df1d080ed92bf9b0357987af65dbd53e839db5f7bb6',
 'R/download_2021_annual_data.R'='43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068',
 'docs/2024-validation-protocol.md'='165e3841efd757224d031b3e165452c44db9cfaffdbb797ff067a5b14b5e844b',
 'data/pilot/source-defined-cohort-admission/cohort-membership.csv'='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
 'data/pilot/source-defined-cohort-admission/row-dispositions.csv'='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6')
z_need <- function(ok,why) if(!isTRUE(ok)) stop(why,call.=FALSE)
z_hash <- function(p) {
 if(!file.exists(p)||dir.exists(p))return('MISSING')
 x<-system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE)
 z_need(length(x)==1&&grepl('^[0-9a-f]{64} ',x),'HASH_FAILURE');substr(x,1,64)
}
z_read <- function(p) read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
z_write <- function(x,p) write.csv(x,p,row.names=FALSE,na='',eol='\n')
z_config <- function() {
 file<-c('atp_matches_2024.csv','wta_matches_2024.csv');path<-paste(c('atp','wta'),file,sep='/')
 raw<-paste0('https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/',z_revision,'/',path)
 data.frame(tour=c('ATP','WTA'),season='2024',file=file,pinned_commit=z_revision,source_path=path,
 source_url=raw,metadata_url=paste0('https://api.github.com/repos/Aneeshers/tennis-sackmann-archive/contents/',path,'?ref=',z_revision),
 local_path=paste0('data/raw/sackmann/',z_revision,'/',file),
 metadata_local_path=paste0('data/raw/sackmann/',z_revision,'/',sub('.csv$','.metadata.json',file)),
 original_creator='Jeff Sackmann / Tennis Abstract',license_id='CC-BY-NC-SA-4.0',
 license_url=paste0('https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/',z_revision,'/LICENSE'),
 intended_use='User-authorized local noncommercial educational research; attribution and NC-SA obligations; no publication',
 stringsAsFactors=FALSE)
}
z_allow <- function(url) {c<-z_config();z_need(length(url)==1&&!is.na(url)&&url %in% c(c$source_url,c$metadata_url),'ENDPOINT_NOT_ALLOWLISTED');invisible(TRUE)}
z_rights <- function(pins=z_pins) {
 h<-vapply(names(pins),z_hash,'');z_need(identical(unname(h),unname(pins)),'SAVED_EVIDENCE_PIN_FAILURE')
 s<-paste(readLines('DATA_LICENSE.md'),collapse='\n');m<-z_read('data/manifests/pilot-source-files.csv')
 z_need(all(vapply(c('CC BY-NC-SA 4.0','noncommercial','Jeff Sackmann',z_revision),function(x)grepl(x,s,fixed=TRUE),TRUE))&&
 all(m$license_id=='CC-BY-NC-SA-4.0')&&all(m$pinned_commit==z_revision)&&all(grepl('noncommercial',m$use_notes)), 'SAVED_USE_BASIS_FAILURE')
 invisible(h)
}
z_load <- function() {
 z_rights();e<-new.env(parent=baseenv())
 # Statistical helpers used only by inherited coverage/date logic are base/recommended R.
 e$read.csv<-utils::read.csv;e$head<-utils::head;e$tail<-utils::tail
 e$count.fields<-utils::count.fields;e$setNames<-stats::setNames
 import<-function(file,names) {
  found<-character()
  for(expr in parse(file))if(is.call(expr)&&identical(expr[[1]],as.name('<-'))&&is.symbol(expr[[2]])&&as.character(expr[[2]]) %in% names){eval(expr,e);found<-c(found,as.character(expr[[2]]))}
  z_need(setequal(found,names),'PURE_HELPER_ALLOWLIST_MISMATCH')
 }
 import('R/audit_source_defined_cohort.R',c('sa_fields','sa_join','sa_need','sa_score','sa_counts','sa_identity','sa_duplicates','sa_panel','sa_dispositions','sa_coverage','sa_empty'))
 import('R/download_2021_annual_data.R',c('annual_2021_metadata','annual_2021_csv','annual_2021_blob'))
 e$sa_version<-'2Z-1.0.0'
 e$sa_inputs<-function() {c<-z_config();data.frame(file=c$file,tour=c$tour,season='2024')}
 original_panel<-e$sa_panel
 e$sa_panel<-function() {p<-original_panel();p$label[p$tour=='WTA'&p$event=='Canada']<-'Toronto';p}
 # Canada edition city uses the already adopted Montreal/Toronto family; no alias expansion.
 e
}
z_request <- function(url,dest) {
 z_allow(url)
 args<-c('--disable','--request','GET','--no-location','--max-redirs','0','--retry','0',
 '--proto','=https','--connect-timeout','20','--max-time','60','--silent','--show-error',
 '--output',dest,'--write-out','%{http_code}|%{url_effective}|%{redirect_url}',url)
 x<-system2('/usr/bin/curl',vapply(args,shQuote,''),stdout=TRUE,stderr=TRUE)
 status<-attr(x,'status');if(is.null(status))status<-0L
 z_need(status==0&&identical(x,paste0('200|',url,'|')),'HTTP_OR_REDIRECT_FAILURE')
 format(Sys.time(),'%Y-%m-%dT%H:%M:%SZ',tz='UTC')
}
z_schema <- c('tourney_id','tourney_name','surface','draw_size','tourney_level','tourney_date','match_num',
 'winner_id','winner_seed','winner_entry','winner_name','winner_hand','winner_ht','winner_ioc','winner_age',
 'loser_id','loser_seed','loser_entry','loser_name','loser_hand','loser_ht','loser_ioc','loser_age',
 'score','best_of','round','minutes','w_ace','w_df','w_svpt','w_1stIn','w_1stWon','w_2ndWon','w_SvGms','w_bpSaved','w_bpFaced',
 'l_ace','l_df','l_svpt','l_1stIn','l_1stWon','l_2ndWon','l_SvGms','l_bpSaved','l_bpFaced','winner_rank','winner_rank_points','loser_rank','loser_rank_points')
z_verify <- function(raw,meta,r,e,expected=NULL) {
 z_need(r$pinned_commit==z_revision,'REVISION_FAILURE');z_allow(r$source_url);z_allow(r$metadata_url)
 z_need(file.exists(raw)&&file.exists(meta),'MISSING_FILE')
 a<-e$annual_2021_metadata(meta,r)
 z_need(file.info(raw)$size==as.numeric(a$size)&&e$annual_2021_blob(raw)==a$sha,'BYTE_SIZE_OR_GIT_BLOB_FAILURE')
 hash<-z_hash(raw);mh<-z_hash(meta)
 if(!is.null(expected))z_need(hash==expected$sha256&&mh==expected$metadata_sha256&&
 a$sha==expected$source_git_blob&&a$size==expected$byte_size&&file.info(meta)$size==as.numeric(expected$metadata_byte_size),'MANIFEST_HASH_OR_BYTE_FAILURE')
 # Header gate precedes match-row parsing; schemas cannot adapt to the new data.
 hdr<-strsplit(readLines(raw,n=1,warn=FALSE),',',fixed=TRUE)[[1]]
 z_need(identical(hdr,z_schema),'SCHEMA_FAILURE')
 d<-e$annual_2021_csv(raw);d[is.na(d)]<-''
 z_need(identical(names(d),z_schema)&&nrow(d)>0,'SCHEMA_FAILURE')
 if(!is.null(expected))z_need(nrow(d)==as.integer(expected$row_count),'MANIFEST_ROW_FAILURE')
 list(data=d,sha256=hash,metadata_sha256=mh,source_git_blob=a$sha,byte_size=a$size,
 metadata_byte_size=file.info(meta)$size,row_count=nrow(d))
}
z_ignored <- function(paths) {
 all(vapply(paths,function(p) {x<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(p)),stdout=TRUE));identical(x,p)},TRUE))
}
z_atomic_files <- function(sources,dests,manifest,m,hook=function(i){},replace_manifest_hash=NULL,expected_hashes=vapply(sources,z_hash,'')) {
 expected_hashes<-as.character(expected_hashes)
 # Immutable per-file rename plus manifest-last commit marker: readers never accept
 # a partial transaction. Existing raw directory cannot be replaced (older releases).
 z_need(length(sources)==length(dests)&&!any(file.exists(dests)),'EXISTING_RELEASE_REQUIRES_REVIEW')
 if(file.exists(manifest))z_need(!is.null(replace_manifest_hash)&&z_hash(manifest)==replace_manifest_hash,'MANIFEST_EXISTS')
 for(i in seq_along(sources)) {
  z_need(dir.exists(dirname(dests[i])),'MISSING_PARENT');hook(i)
  z_need(z_hash(sources[i])==expected_hashes[i],'RAW_STAGE_CHANGED')
  z_need(file.rename(sources[i],dests[i]),'ATOMIC_FILE_RENAME_FAILED')
 }
 z_need(identical(unname(vapply(dests,z_hash,'')),unname(expected_hashes)),'INSTALLED_RAW_CHANGED')
 tmp<-tempfile('.manifest-',tmpdir=dirname(manifest));z_write(m,tmp);hook(length(sources)+1L)
 z_need(file.rename(tmp,manifest),'MANIFEST_COMMIT_FAILED')
 invisible(m)
}
z_acquire <- function(e,request=z_request,recover_local_error=FALSE) {
 c<-z_config();prior<-NULL;prior_hash<-NULL
 if(file.exists(z_manifest)) {
  z_need(recover_local_error,'MANIFEST_EXISTS_USE_OFFLINE');prior<-z_read(z_manifest);z_manifest_check(prior)
  z_need(all(prior$state=='BLOCKED')&&all(prior$reason=='could not find function "count.fields"'),'RECOVERY_NOT_A_LOCAL_IMPLEMENTATION_FAILURE')
  prior_hash<-z_hash(z_manifest)
 }
 z_need(z_ignored(c(c$local_path,c$metadata_local_path,paste0(z_output,'/',z_outputs,'.csv'))),'OUTPUT_NOT_IGNORED')
 z_need(!any(file.exists(c(c$local_path,c$metadata_local_path))),'UNMANIFESTED_RAW_STOP')
 records<-list();sources<-dests<-expected_hashes<-character()
 for(i in 1:2) {
  r<-c[i,,drop=FALSE]
  for(k in c('metadata_retrieved_at_utc','retrieved_at_utc','metadata_sha256','metadata_byte_size','source_git_blob','byte_size','sha256','row_count'))r[[k]]<-''
  r$state<-'BLOCKED';r$reason<-''
  # Same-filesystem staging makes each installation rename atomic.
  meta<-tempfile('.2024-meta-',tmpdir=dirname(r$local_path));raw<-tempfile('.2024-raw-',tmpdir=dirname(r$local_path))
  err<-tryCatch({
   z_rights();r$metadata_retrieved_at_utc<-request(r$metadata_url,meta)
   e$annual_2021_metadata(meta,r) # Stop before requesting raw when metadata fails.
   r$retrieved_at_utc<-request(r$source_url,raw)
   v<-z_verify(raw,meta,r,e)
   for(k in setdiff(names(v),'data'))r[[k]]<-as.character(v[[k]])
   r$state<-'VERIFIED';NULL
  },error=identity)
  if(!is.null(err)){r$reason<-conditionMessage(err);unlink(c(raw,meta))} else {
   sources<-c(sources,raw,meta);dests<-c(dests,r$local_path,r$metadata_local_path)
   expected_hashes<-c(expected_hashes,r$sha256,r$metadata_sha256)
  }
  records[[i]]<-r
 }
 m<-do.call(rbind,records)
 if(!is.null(prior))for(k in c('state','reason','metadata_retrieved_at_utc','retrieved_at_utc'))m[[paste0('initial_attempt_',k)]]<-prior[[k]]
 z_atomic_files(sources,dests,z_manifest,m,replace_manifest_hash=prior_hash,expected_hashes=expected_hashes)
 m
}
z_manifest_check <- function(m) {
 c<-z_config();z_need(nrow(m)==2&&identical(m$tour,c$tour),'MANIFEST_TOURS_FAILURE')
 z_need(all(names(c) %in% names(m)),'MANIFEST_SCHEMA_FAILURE')
 for(k in names(c))z_need(identical(m[[k]],c[[k]]),paste0('MANIFEST_CONFIG_FAILURE:',k))
 z_need(all(m$state %in% c('VERIFIED','BLOCKED')),'MANIFEST_STATE_FAILURE')
 for(i in which(m$state=='VERIFIED')) {
  for(k in c('retrieved_at_utc','metadata_retrieved_at_utc'))z_need(grepl('^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$',m[[k]][i]),'PROVENANCE_TIME_FAILURE')
  for(k in c('sha256','metadata_sha256'))z_need(grepl('^[0-9a-f]{64}$',m[[k]][i]),'PROVENANCE_HASH_FAILURE')
  z_need(grepl('^[0-9a-f]{40}$',m$source_git_blob[i])&&all(as.numeric(m[i,c('row_count','byte_size','metadata_byte_size')])>0),'PROVENANCE_SIZE_BLOB_FAILURE')
 }
}
z_audit_rows <- function(raw,e,history=NULL) {
 p<-e$sa_panel();empty<-e$sa_empty(z_schema)
 if(!length(raw))return(empty)
 allraw<-do.call(rbind,raw)
 inside<-paste(allraw$audit_file,allraw$tourney_id) %in% paste(p$file,p$tourney_id)|
  paste(allraw$audit_file,allraw$tourney_name) %in% paste(p$file,p$label)
 # Recognize the other already-known Canada edition label as a conflict candidate.
 inside<-inside|(allraw$audit_tour=='WTA'&allraw$tourney_name=='Montreal')
 d<-allraw[inside,,drop=FALSE];rows<-empty
 if(nrow(d)) {
  # ID mapping recognizes either Canada city, but the expected 2024 label remains Toronto.
  admission<-new.env(parent=e)
  admission$sa_panel<-function() {q<-e$sa_panel();a<-q[q$tour=='WTA'&q$event=='Canada',];a$label<-'Montreal';rbind(q,a)}
  fun<-e$sa_dispositions;environment(fun)<-admission
  rows<-fun(d,data.frame(match_id=character()),data.frame())
  for(i in which(d$audit_tour=='WTA'&d$tourney_name=='Montreal')) {
   rows$context_reasons[i]<-e$sa_join(c(rows$context_reasons[i],'event_label_conflict'))
   rows$exclusion_reasons[i]<-e$sa_join(c(rows$exclusion_reasons[i],'event_label_conflict'))
   rows$panel_disposition[i]<-'EXCLUDED';rows$membership[i]<-'EXCLUDED'
  }
  if(!is.null(history)&&nrow(history)) {
   cols<-c('audit_tour','winner_id','winner_name','winner_hand','loser_id','loser_name','loser_hand')
   why<-tail(e$sa_identity(rbind(history[,cols],d[,cols])),nrow(d))
   for(i in seq_len(nrow(rows)))if(nzchar(why[i])) {
    rows$identity_reasons[i]<-e$sa_join(c(rows$identity_reasons[i],why[i]))
    rows$identity_disposition[i]<-'EXCLUDED';rows$membership[i]<-'EXCLUDED'
    rows$exclusion_reasons[i]<-e$sa_join(c(rows$exclusion_reasons[i],why[i]))
   }
  }
 }
 outside<-allraw[!inside,,drop=FALSE]
 if(nrow(outside)) {
  for(k in setdiff(names(rows),names(outside)))outside[[k]]<-''
  outside$audit_version<-'2Z-1.0.0';outside$panel_disposition<-outside$membership<-'OUTSIDE_PANEL'
  outside$exclusion_reasons<-'outside_authorized_panel'
  for(k in c('score_status','completion_status','identity_disposition','statistics_disposition','game_reconciliation'))outside[[k]]<-'NOT_ASSESSED_OUTSIDE_PANEL'
  rows<-rbind(rows,outside[,names(rows)])
 }
 rows[order(rows$audit_file,as.integer(rows$audit_source_row),method='radix'),,drop=FALSE]
}
z_decision <- function(files,cells,rows) {
 if(any(files$state!='VERIFIED'))return('2024_SOURCE_ACQUISITION_BLOCKED')
 conflict<-nrow(rows)&&any(nzchar(rows$identity_reasons)|nzchar(rows$context_reasons)|nzchar(rows$duplicate_reasons))
 if(any(cells$observed_source_rows==0|cells$admitted_source_records==0)||conflict)
  '2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED' else '2024_SOURCE_COHORT_READY_FOR_HISTORY_BUILD'
}
z_build <- function(e,m=z_read(z_manifest)) {
 z_manifest_check(m);raw<-list();f<-m
 rights<-tryCatch({z_rights();NULL},error=identity)
 for(i in 1:2) {
  if(!is.null(rights)){f$state[i]<-'BLOCKED';f$reason[i]<-conditionMessage(rights);next}
  if(m$state[i]!='VERIFIED')next
  v<-tryCatch(z_verify(m$local_path[i],m$metadata_local_path[i],m[i,],e,m[i,]),error=identity)
  if(inherits(v,'error')){f$state[i]<-'BLOCKED';f$reason[i]<-conditionMessage(v);next}
  d<-v$data;d$audit_file<-m$file[i];d$audit_tour<-m$tour[i];d$audit_season<-'2024'
  d$audit_source_path<-m$local_path[i];d$audit_source_row<-seq_len(nrow(d));raw[[i]]<-d
 }
 history<-NULL
 if(is.null(rights)) {
  h<-z_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv')
  ids<-z_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv')$match_id
  history<-h[h$match_id %in% ids,,drop=FALSE]
 }
 rows<-z_audit_rows(raw,e,history);coverage<-e$sa_coverage(rows,f)
 cells<-coverage$coverage;cells$state[cells$state=='OBSERVED'&cells$admitted_source_records==0]<-'WHOLLY_BLOCKED_CELL'
 decision<-z_decision(f,cells[cells$round=='ALL',],rows)
 members<-rows[rows$membership=='INCLUDED',c('audit_version','audit_file','audit_source_path','audit_source_row','audit_tour','audit_season','cell_id','event','surface','round','match_id','player_a_id','player_b_id','a_original_side','count_origin','winner_id','loser_id','tourney_date'),drop=FALSE]
 out<-list();add<-function(group,measure,value,detail='')out[[length(out)+1]]<<-data.frame(group=group,measure=measure,value=as.character(value),detail=detail)
 for(i in 1:2) {
  rr<-rows[rows$audit_file==f$file[i],,drop=FALSE];pp<-rr[rr$membership!='OUTSIDE_PANEL',,drop=FALSE];ok<-f$state[i]=='VERIFIED'
  for(k in c('annual_rows','panel_rows','admitted','excluded','outside_panel','raw_complete_counts')) {
   value<-switch(k,annual_rows=nrow(rr),panel_rows=nrow(pp),admitted=sum(pp$membership=='INCLUDED'),excluded=sum(pp$membership=='EXCLUDED'),outside_panel=sum(rr$membership=='OUTSIDE_PANEL'),raw_complete_counts=sum(pp$raw_count_complete=='TRUE'))
   add(f$tour[i],k,if(ok)value else NA)
  }
  add(f$tour[i],'file_state',f$state[i],f$reason[i])
  for(s in sort(unique(pp$completion_status)))add(f$tour[i],paste0('completion:',s),sum(pp$completion_status==s))
  for(s in sort(unique(unlist(strsplit(pp$exclusion_reasons,';',fixed=TRUE)))))if(nzchar(s))
   add(f$tour[i],paste0('exclusion:',s),sum(vapply(strsplit(pp$exclusion_reasons,';',fixed=TRUE),function(x)s %in% x,TRUE)))
 }
 add('ALL','terminal_decision',decision);add('ALL','official_recall','UNKNOWN');add('ALL','histories_ratings_fitting_scoring','NOT_AUTHORIZED')
 provenance<-f;provenance$rights_evidence<-paste(names(z_pins),z_pins,sep='=',collapse=';')
 result<-setNames(list(provenance,rows,members,cells,coverage$fields,do.call(rbind,out)),z_outputs)
 for(k in names(result)){
  result[[k]]$convention<-rep('SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY',nrow(result[[k]]))
  result[[k]]$verified_chronology_decision<-rep('NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE',nrow(result[[k]]))
  result[[k]]$uncertainty<-rep('UNCERTAINTY_NOT_ESTABLISHED',nrow(result[[k]]))
 }
 result
}
z_install <- function(result,dest=z_output,hook=function(stage){}) {
 z_need(identical(names(result),z_outputs),'OUTPUT_SCOPE_FAILURE')
 stage<-tempfile('.2024-audit-',tmpdir=dirname(dest));dir.create(stage)
 on.exit(if(dir.exists(stage))unlink(stage,recursive=TRUE),add=TRUE)
 for(k in names(result))z_write(result[[k]],file.path(stage,paste0(k,'.csv')))
 h<-vapply(file.path(stage,paste0(z_outputs,'.csv')),z_hash,'');hook(stage)
 z_need(setequal(list.files(stage),paste0(z_outputs,'.csv'))&&identical(h,vapply(file.path(stage,paste0(z_outputs,'.csv')),z_hash,'')),'STAGE_CHANGED')
 if(dir.exists(dest)) {
  z_need(setequal(list.files(dest),paste0(z_outputs,'.csv')),'EXISTING_OUTPUT_SCOPE')
  z_need(identical(unname(h),unname(vapply(file.path(dest,paste0(z_outputs,'.csv')),z_hash,''))),'EXISTING_OUTPUT_CONFLICT')
 } else z_need(file.rename(stage,dest),'ATOMIC_AUDIT_INSTALL_FAILURE')
 invisible(result)
}
z_main <- function(acquire=FALSE) {
 e<-z_load()
 if(!identical(acquire,FALSE))z_acquire(e,recover_local_error=identical(acquire,'recover'))
 z_need(z_hash(z_manifest)==z_manifest_pin,'FROZEN_MANIFEST_PIN_FAILURE')
 result<-z_build(e);z_install(result)
 print(result$summary[,1:4]);invisible(result)
}
if(sys.nframe()==0L) {args<-commandArgs(trailingOnly=TRUE);z_main(if(identical(args,'--recover-local-error'))'recover' else identical(args,'--acquire'))}
