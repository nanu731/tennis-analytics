# Phase 2M 1.0.0: candidate membership only; no factor or rating history aggregation.
ebm_version <- "1.0.0"
ebm_convention <- "SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY"
ebm_chronology <- "NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE"
ebm_dir <- "data/pilot/event-batch-membership"
ebm_outputs <- c("target-batches", "candidate-history-membership", "summary")
ebm_pins <- c(AGENTS.override.md = "7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b",
PROJECT_CONTEXT.md = "2f7e0007300ec31c0a82f1ef196177a238ff401249183119aaea0a8fdb28ef96",
`docs/source-label-event-batching-decision.md` = "7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c",
`docs/source-defined-cohort-audit.md` = "5aa928d4f270357739b384337a71e79bc79f52461cbd7740a00c839e5698f38b",
`R/audit_source_defined_cohort.R` = "73b79972d2d4bb0c8d651df1d080ed92bf9b0357987af65dbd53e839db5f7bb6",
`R/test_source_defined_cohort.R` = "cf36933bccbd30457f9042804be78fcdbc54c8c925ca9e1bc742d24f3b7361eb",
`docs/pre-match-chronology-audit.md` = "7719227f24ed244d621f586c6329ad919e4b2a373897db9e8a24b00dc25d8a79",
`docs/broader-shortlist-revalidation.md` = "e2b80a74d6048bdcbfdad34e5f83fcd9213a7b76eaef2b0b83d4502ecd03f61b",
`data/pilot/source-defined-cohort-admission/cell-coverage.csv` = "b50f5126e6e29ca6ee214e87fec660a8e96d7dc7d088df56b898cfb075abb91c",
`data/pilot/source-defined-cohort-admission/cohort-membership.csv` = "398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10",
`data/pilot/source-defined-cohort-admission/field-availability.csv` = "260fa9bdfb7c486749f639d9358b5732bd42008236523cc49f5086fc5a1b4468",
`data/pilot/source-defined-cohort-admission/input-provenance.csv` = "ed39e3e7907271786b3b97f3dada42c1b5384e4f03a45e5fab2e48fb0b2325f5",
`data/pilot/source-defined-cohort-admission/row-dispositions.csv` = "24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6",
`data/pilot/source-defined-cohort-admission/summary.csv` = "b2e9953f1eeb0a9f28ae092fb1720b089bb15ce96ff5de6275be69068670d950"
)
ebm_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
ebm_hash <- function(p)if(!file.exists(p))'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
ebm_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
ebm_verify <- function(pins=ebm_pins) {
  bad<-names(pins)[vapply(names(pins),ebm_hash,'')!=pins]
  ebm_need(!length(bad),paste('Missing/changed frozen input:',paste(bad,collapse=';')))
}
ebm_ignored <- function(dir=ebm_dir) {
  paths<-file.path(dir,paste0(ebm_outputs,'.csv'))
  out<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
  ebm_need(setequal(out,paths),'STOP: output location must already be ignored')
}
ebm_sort <- function(x,fields) {x<-x[do.call(order,c(unname(x[fields]),list(method='radix'))),,drop=FALSE];rownames(x)<-NULL;x}
ebm_label_valid <- function(x) {
  # Calendar parsing validates the label only; no clock time or elapsed interval is made.
  ok<-!is.na(x)&grepl('^[0-9]{8}$',x)
  parsed<-as.Date(rep(NA_character_,length(x)))
  parsed[ok]<-as.Date(x[ok],format='%Y%m%d')
  ok&!is.na(parsed)&format(parsed,'%Y%m%d')==x
}
ebm_prepare <- function(m,d,expected_n=NULL) {
  required_m<-c('match_id','audit_tour','audit_season','cell_id','event','surface','round','player_a_id','player_b_id','audit_source_path','audit_source_row','count_origin')
  required_d<-c(required_m,'tourney_date','membership')
  ebm_need(all(required_m %in% names(m))&&all(required_d %in% names(d)),'Required frozen schema missing')
  ebm_need(nrow(m)>0&&!anyNA(m$match_id)&&all(nzchar(m$match_id))&&!anyDuplicated(m$match_id),'Missing/duplicate targets')
  if(!is.null(expected_n))ebm_need(nrow(m)==expected_n,'Frozen target count changed')
  included<-d[d$membership=='INCLUDED',,drop=FALSE]
  ebm_need(!anyDuplicated(included$match_id)&&setequal(m$match_id,included$match_id),'Frozen membership/exclusion mismatch')
  dd<-included[match(m$match_id,included$match_id),]
  for(field in required_m)ebm_need(identical(m[[field]],dd[[field]]),paste('Frozen linkage mismatch:',field))
  ebm_need(all(m$audit_tour %in% c('ATP','WTA')),'Tour unsupported')
  ebm_need(all(paste(m$audit_tour,m$audit_season) %in% c('ATP 2023','WTA 2021','WTA 2023')),'Unauthorized season')
  ebm_need(!anyNA(m[c('player_a_id','player_b_id')])&&all(nzchar(m$player_a_id)&nzchar(m$player_b_id)&m$player_a_id!=m$player_b_id),'Invalid frozen player slots')
  # Check every saved row in target cells, including excluded rows, for conflicting labels.
  panel<-d[d$cell_id %in% m$cell_id,,drop=FALSE]
  ebm_need(all(ebm_label_valid(panel$tourney_date)),'Missing/invalid source label; no repair permitted')
  ebm_need(all(substr(panel$tourney_date,1,4)==panel$audit_season),'Source label/season conflict')
  for(cell in unique(m$cell_id)) {
    z<-panel[panel$cell_id==cell,]
    ebm_need(length(unique(z$tourney_date))==1L&&length(unique(z$audit_tour))==1L,'Conflicting labels/tour within event cell')
  }
  # Whitelist output fields: results, scores, counts and winner orientation never enter selection.
  x<-m[required_m];names(x)[names(x)=='audit_tour']<-'tour';names(x)[names(x)=='audit_season']<-'season'
  x$source_tourney_date<-dd$tourney_date;x$batch_key<-paste(x$tour,x$source_tourney_date,sep='|')
  x$convention<-ebm_convention;x$verified_chronology_decision<-ebm_chronology
  ebm_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
}
ebm_membership <- function(x) {
  rows<-vector('list',2*nrow(x));k<-0L
  for(i in seq_len(nrow(x)))for(slot in c('a','b')) {
    player<-x[[paste0('player_',slot,'_id')]][i]
    prior<-which(x$tour==x$tour[i]&x$source_tourney_date<x$source_tourney_date[i]&
      (x$player_a_id==player|x$player_b_id==player))
    n<-length(prior);k<-k+1L
    rows[[k]]<-data.frame(target_match_id=x$match_id[i],target_slot=slot,player_id=player,tour=x$tour[i],
      target_batch_key=x$batch_key[i],target_source_date=x$source_tourney_date[i],target_cell=x$cell_id[i],
      target_event=x$event[i],target_surface=x$surface[i],
      prior_match_id=if(n)x$match_id[prior] else '',prior_batch_key=if(n)x$batch_key[prior] else '',
      prior_source_date=if(n)x$source_tourney_date[prior] else '',prior_cell=if(n)x$cell_id[prior] else '',
      prior_player_slot=if(n)ifelse(x$player_a_id[prior]==player,'a','b') else '',
      membership_status=if(n)'ELIGIBLE_EARLIER_BATCH' else 'EMPTY_HISTORY',
      empty_reason=if(n)'' else 'NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT',
      empty_detail=if(n)'' else if(x$source_tourney_date[i]==min(x$source_tourney_date[x$tour==x$tour[i]]))'TOUR_FIRST_OBSERVED_BATCH' else 'PLAYER_FIRST_OBSERVED_BATCH',
      convention=ebm_convention,verified_chronology_decision=ebm_chronology,stringsAsFactors=FALSE)
  }
  ebm_sort(do.call(rbind,rows),c('tour','target_source_date','target_cell','target_match_id','target_slot','prior_source_date','prior_match_id'))
}
ebm_summarize <- function(x,h) {
  # Counts describe membership cardinalities, not metric aggregation or initialization.
  slots<-do.call(rbind,lapply(c('a','b'),function(slot)data.frame(target_match_id=x$match_id,tour=x$tour,season=x$season,
    batch=x$batch_key,event=x$cell_id,surface=x$surface,slot=slot,links=x[[paste0(slot,'_history_matches')]],stringsAsFactors=FALSE)))
  groups<-list(list(level='overall',tour='ALL',value='ALL',rows=seq_len(nrow(slots))))
  for(tour in c('ATP','WTA')) {
    it<-which(slots$tour==tour);if(!length(it))next
    groups[[length(groups)+1]]<-list(level='tour',tour=tour,value=tour,rows=it)
    for(field in c('season','batch','event','surface'))for(v in sort(unique(slots[[field]][it]),method='radix'))
      groups[[length(groups)+1]]<-list(level=field,tour=tour,value=v,rows=it[slots[[field]][it]==v])
  }
  out<-list()
  for(g in groups)for(slot in c('ALL','a','b')) {
    z<-slots[g$rows,];if(slot!='ALL')z<-z[z$slot==slot,,drop=FALSE]
    ids<-unique(z$target_match_id);target<-x[match(ids,x$match_id),]
    out[[length(out)+1]]<-data.frame(level=g$level,tour=g$tour,group=g$value,player_slot=slot,
      target_matches=length(ids),target_player_slots=nrow(z),candidate_memberships=sum(z$links),
      empty_player_slots=sum(z$links==0),nonempty_player_slots=sum(z$links>0),
      targets_with_either_slot_empty=if(slot=='ALL')sum(target$a_history_matches==0|target$b_history_matches==0) else NA_integer_,
      targets_with_both_slots_empty=if(slot=='ALL')sum(target$a_history_matches==0&target$b_history_matches==0) else NA_integer_,
      min_memberships=if(nrow(z))min(z$links) else NA_integer_,max_memberships=if(nrow(z))max(z$links) else NA_integer_,
      batches=length(unique(target$batch_key)),event_cells=length(unique(target$cell_id)),
      convention=ebm_convention,verified_chronology_decision=ebm_chronology,stringsAsFactors=FALSE)
  }
  ebm_sort(do.call(rbind,out),c('level','tour','group','player_slot'))
}
ebm_build <- function(m,d,expected_n=NULL) {
  x<-ebm_prepare(m,d,expected_n);h<-ebm_membership(x)
  for(slot in c('a','b')) {
    included<-h[h$target_slot==slot&h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
    count<-table(factor(included$target_match_id,levels=x$match_id))
    x[[paste0(slot,'_history_matches')]]<-as.integer(count)
    empty<-h[h$target_slot==slot&h$membership_status=='EMPTY_HISTORY',]
    idx<-match(x$match_id,empty$target_match_id)
    x[[paste0(slot,'_empty_reason')]]<-ifelse(is.na(idx),'',empty$empty_reason[idx])
    x[[paste0(slot,'_empty_detail')]]<-ifelse(is.na(idx),'',empty$empty_detail[idx])
  }
  ebm_need(sum(x$a_history_matches+x$b_history_matches)==sum(h$membership_status=='ELIGIBLE_EARLIER_BATCH'),'Membership accounting')
  setNames(list(x,h,ebm_summarize(x,h)),ebm_outputs)
}
ebm_load <- function() {
  ebm_ignored();ebm_verify()
  list(m=ebm_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
    d=ebm_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))
}
ebm_install <- function(r,dir=ebm_dir,before_install=function(stage)NULL) {
  ebm_ignored(dir);ebm_verify();ebm_need(identical(names(r),ebm_outputs),'Output scope mismatch')
  stage<-tempfile('.event-batch-stage-',tmpdir=dirname(dir));ebm_need(dir.create(stage),'Cannot stage output')
  on.exit(unlink(stage,recursive=TRUE),add=TRUE)
  for(i in seq_along(r))write.table(r[[i]],file.path(stage,paste0(names(r)[i],'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NOT_APPLICABLE',eol='\n',qmethod='double')
  paths<-file.path(stage,paste0(ebm_outputs,'.csv'));expected_hashes<-vapply(paths,ebm_hash,'');before_install(stage)
  ebm_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0),'Incomplete staged release')
  ebm_need(identical(vapply(paths,ebm_hash,''),expected_hashes),'Staged bytes changed before installation')
  ebm_verify()
  if(dir.exists(dir)) {
    ebm_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing output directory scope differs; preserve it')
    ebm_need(identical(unname(vapply(file.path(dir,basename(paths)),ebm_hash,'')),unname(vapply(paths,ebm_hash,''))),'Existing output bytes differ; preserve them')
  } else ebm_need(file.rename(stage,dir),'Atomic installation failed')
  invisible(r)
}
build_event_batch_membership <- function(write_outputs=TRUE) {
  input<-ebm_load();r<-ebm_build(input$m,input$d,2580L)
  ebm_need(length(unique(r[[1]]$cell_id))==30L,'Frozen cell universe changed')
  if(write_outputs)ebm_install(r);r
}
if(sys.nframe()==0L) {r<-build_event_batch_membership();print(r[[3]][r[[3]]$level=='tour'&r[[3]]$player_slot=='ALL',1:11])}
