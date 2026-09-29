# Phase 2N 1.0.0: cumulative counts under source-label batching, never model fitting.
s08_version <- '1.0.0'
s08_pins <- c(
`R/build_event_batch_membership.R` = 'e42d4aa6879550c71f665c5b2dd2dd8c0499a89d8223d1e4f5537cc325030146',
`R/test_event_batch_membership.R` = '94cead42d03c7c5f584a7803f27a8950e4148cc19977d717349d51f8c0846e51',
`docs/event-batch-membership-audit.md` = '9ffc26c83c91a295a4f79352ae326eeb7a56700976b398560175650b24c07a4a',
`docs/source-label-event-batching-decision.md` = '7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c',
`docs/post-otd-analytical-path.md` = '14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7',
`R/revalidate_broader_shortlist.R` = '685d6a3ac26d5fd3e5ea8230fb716722d40c4ea6a9a26b2ddff3865cf86e642e',
`data/pilot/event-batch-membership/target-batches.csv` = '2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
`data/pilot/event-batch-membership/candidate-history-membership.csv` = '3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
`data/pilot/event-batch-membership/summary.csv` = '04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246'
)
s08_need <- function(ok, why) if (!isTRUE(ok)) stop(why, call.=FALSE)
s08_hash <- function(p) if (!file.exists(p)) 'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
s08_verify <- function(pins=s08_pins) {
  s08_need(all(vapply(names(pins),s08_hash,'')==pins),'Missing/changed Phase 2N frozen input')
}
s08_verify()
# Source definitions only: no historical runner, suite or output is executed.
source('R/build_event_batch_membership.R')
s08_metrics <- c('M03','M05','M11','M12')
s08_dir <- 'data/pilot/s08-batched-histories'
s08_outputs <- c('slot-history-aggregates','target-s08-features','summary')
s08_ignored <- function(dir=s08_dir) {
  paths<-file.path(dir,paste0(s08_outputs,'.csv'))
  got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
  s08_need(setequal(got,paths),'STOP: output location must already be ignored')
}
s08_load <- function() {
  s08_ignored();s08_verify();ebm_verify()
  list(x=ebm_read('data/pilot/event-batch-membership/target-batches.csv'),
       h=ebm_read('data/pilot/event-batch-membership/candidate-history-membership.csv'),
       m=ebm_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
       d=ebm_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'))
}
s08_validate_membership <- function(x,h,m,d,expected_n=NULL) {
  canonical<-ebm_prepare(m,d,expected_n)
  x<-ebm_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
  s08_need(identical(x[names(canonical)],canonical),'Frozen target metadata differs')
  expected<-ebm_membership(canonical)
  h<-ebm_sort(h,c('tour','target_source_date','target_cell','target_match_id','target_slot','prior_source_date','prior_match_id'))
  s08_need(identical(h,expected),'Phase 2M membership/empty ledger differs; no repair allowed')
  for(slot in c('a','b')) {
    links<-h[h$target_slot==slot&h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
    n<-as.integer(table(factor(links$target_match_id,levels=x$match_id)))
    s08_need(identical(as.integer(x[[paste0(slot,'_history_matches')]]),n),'Membership cardinality differs')
  }
  list(x=x,h=h)
}
s08_components <- function(own,opp) {
  # Numerators/denominators only. M11 is an intensity, not a bounded probability.
  c(M03_num=unname(own['1stWon']),M03_den=unname(own['1stIn']),
    M05_num=unname(own['df']),M05_den=unname(own['svpt']-own['1stIn']),
    M11_num=unname(opp['bpFaced']),M11_den=unname(opp['SvGms']),
    M12_num=unname(opp['bpFaced']-opp['bpSaved']),M12_den=unname(opp['bpFaced']))
}
s08_counts <- function(m,d) {
  d<-d[match(m$match_id,d$match_id),]
  s08_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS'),'Excluded counts encountered')
  s08_need(all(m$a_original_side %in% c('winner','loser'))&&identical(m$a_original_side,d$a_original_side),'Frozen orientation conflict')
  s08_need(all(m$player_a_id==ifelse(m$a_original_side=='winner',d$winner_id,d$loser_id))&&
    all(m$player_b_id==ifelse(m$a_original_side=='winner',d$loser_id,d$winner_id)),'Player/count orientation conflict')
  fields<-c('df','svpt','1stIn','1stWon','SvGms','bpFaced','bpSaved')
  rows<-vector('list',2*nrow(m));k<-0L
  for(i in seq_len(nrow(m))) {
    w<-setNames(as.numeric(d[i,paste0('effective_w_',fields)]),fields)
    l<-setNames(as.numeric(d[i,paste0('effective_l_',fields)]),fields)
    for(v in list(w,l)) {
      s08_need(all(is.finite(v)&v>=0&v==floor(v)),'Invalid/missing effective count')
      s08_need(v['1stWon']<=v['1stIn']&&v['1stIn']<=v['svpt']&&v['df']<=v['svpt']-v['1stIn']&&v['bpSaved']<=v['bpFaced'],'Invalid effective count relation')
    }
    sides<-if(m$a_original_side[i]=='winner')list(a=w,b=l) else list(a=l,b=w)
    for(slot in c('a','b')) {
      k<-k+1L;opp<-if(slot=='a')'b' else 'a'
      rows[[k]]<-data.frame(match_id=m$match_id[i],slot=slot,player_id=m[[paste0('player_',slot,'_id')]][i],
        as.list(s08_components(sides[[slot]],sides[[opp]])),check.names=FALSE,stringsAsFactors=FALSE)
    }
  }
  do.call(rbind,rows)
}
s08_pool <- function(z) {
  out<-as.list(if(nrow(z))colSums(z) else setNames(rep(NA_real_,ncol(z)),names(z)))
  for(metric in s08_metrics) {
    den<-out[[paste0(metric,'_den')]]
    reason<-if(!nrow(z))'EMPTY_HISTORY' else if(den==0)'ZERO_POOLED_DENOMINATOR' else 'DEFINED'
    out[[paste0(metric,'_rate')]]<-if(reason=='DEFINED')out[[paste0(metric,'_num')]]/den else NA_real_
    out[[paste0(metric,'_reason')]]<-reason
  }
  out
}
s08_summarize <- function(slots,targets) {
  context<-c('match_id','tour','season','batch_key','cell_id','event','surface')
  long<-list()
  for(metric in s08_metrics) {
    z<-slots[context];z$slot<-slots$slot;z$metric<-metric;z$value<-slots[[paste0(metric,'_rate')]]
    z$reason<-slots[[paste0(metric,'_reason')]];z$history_matches<-slots$history_matches
    q<-targets[context];q$slot<-'difference';q$metric<-metric;q$value<-targets[[paste0('d',metric)]]
    q$reason<-targets[[paste0('d',metric,'_reason')]];q$history_matches<-NA_integer_
    long[[length(long)+1L]]<-rbind(z,q)
  }
  long<-do.call(rbind,long);groups<-list(list(level='overall',tour='ALL',group='ALL',rows=seq_len(nrow(long))))
  for(tour in c('ATP','WTA')) {
    it<-which(long$tour==tour);if(!length(it))next
    groups[[length(groups)+1L]]<-list(level='tour',tour=tour,group=tour,rows=it)
    for(field in c('season','batch_key','cell_id','surface'))for(v in sort(unique(long[[field]][it]),method='radix'))
      groups[[length(groups)+1L]]<-list(level=field,tour=tour,group=v,rows=it[long[[field]][it]==v])
  }
  range_value<-function(v,fn)if(any(is.finite(v)))fn(v[is.finite(v)]) else NA_real_
  out<-list()
  for(g in groups)for(metric in s08_metrics)for(slot in c('ALL','a','b','difference')) {
    z<-long[g$rows,];z<-z[z$metric==metric&if(slot=='ALL')z$slot %in% c('a','b') else z$slot==slot,]
    out[[length(out)+1L]]<-data.frame(level=g$level,tour=g$tour,group=g$group,metric=metric,slot=slot,
      n=nrow(z),defined=sum(is.finite(z$value)),undefined=sum(!is.finite(z$value)),
      empty_history=sum(grepl('EMPTY_HISTORY',z$reason)),zero_denominator=sum(grepl('ZERO_POOLED_DENOMINATOR',z$reason)),
      min_value=range_value(z$value,min),max_value=range_value(z$value,max),
      rates_above_one=if(slot=='difference')NA_integer_ else sum(z$value>1,na.rm=TRUE),
      min_history_matches=range_value(z$history_matches,min),median_history_matches=range_value(z$history_matches,median),max_history_matches=range_value(z$history_matches,max),
      convention=ebm_convention,verified_chronology_decision=ebm_chronology,stringsAsFactors=FALSE)
  }
  ebm_sort(do.call(rbind,out),c('level','tour','group','metric','slot'))
}
s08_build <- function(x,h,m,d,expected_n=NULL) {
  checked<-s08_validate_membership(x,h,m,d,expected_n);x<-checked$x;h<-checked$h
  counts<-s08_counts(m,d);key<-paste(counts$match_id,counts$slot,sep='|');s08_need(!anyDuplicated(key),'Duplicate count side')
  links<-h[h$membership_status=='ELIGIBLE_EARLIER_BATCH',]
  idx<-match(paste(links$prior_match_id,links$prior_player_slot,sep='|'),key)
  s08_need(!anyNA(idx)&&all(counts$player_id[idx]==links$player_id),'Count contributor linkage failed')
  parts<-counts[idx,grep('_(num|den)$',names(counts)),drop=FALSE]
  groups<-split(seq_len(nrow(links)),paste(links$target_match_id,links$target_slot,sep='|'))
  context<-c('match_id','tour','season','batch_key','source_tourney_date','cell_id','event','surface','round')
  rows<-vector('list',2*nrow(x));k<-0L
  for(i in seq_len(nrow(x)))for(slot in c('a','b')) {
    k<-k+1L;ii<-groups[[paste(x$match_id[i],slot,sep='|')]]
    z<-x[i,context];z$slot<-slot;z$player_id<-x[[paste0('player_',slot,'_id')]][i];z$history_matches<-length(ii)
    z$empty_reason<-x[[paste0(slot,'_empty_reason')]][i];z$empty_detail<-x[[paste0(slot,'_empty_detail')]][i]
    z$first_history_source_label<-if(length(ii))min(links$prior_source_date[ii]) else ''
    z$last_history_source_label<-if(length(ii))max(links$prior_source_date[ii]) else ''
    z<-cbind(z,as.data.frame(s08_pool(parts[ii,,drop=FALSE]),stringsAsFactors=FALSE))
    z$M05_interpretation<-'LOWER_IS_BETTER';z$convention<-ebm_convention;z$verified_chronology_decision<-ebm_chronology
    rows[[k]]<-z
  }
  slots<-ebm_sort(do.call(rbind,rows),c('tour','source_tourney_date','cell_id','match_id','slot'))
  targets<-x[c(context,'player_a_id','player_b_id')]
  for(metric in s08_metrics) {
    for(slot in c('a','b')) {
      z<-slots[slots$slot==slot,];j<-match(targets$match_id,z$match_id)
      targets[[paste0(slot,'_',metric)]]<-z[[paste0(metric,'_rate')]][j]
      targets[[paste0(slot,'_',metric,'_reason')]]<-z[[paste0(metric,'_reason')]][j]
    }
    targets[[paste0('d',metric)]]<-targets[[paste0('a_',metric)]]-targets[[paste0('b_',metric)]]
    ar<-targets[[paste0('a_',metric,'_reason')]];br<-targets[[paste0('b_',metric,'_reason')]]
    targets[[paste0('d',metric,'_reason')]]<-mapply(function(a,b) {
      reasons<-c(if(a!='DEFINED')paste0('a:',a),if(b!='DEFINED')paste0('b:',b))
      if(length(reasons))paste(reasons,collapse=';') else 'DEFINED'
    },ar,br,USE.NAMES=FALSE)
  }
  targets$all_s08_differences_defined<-complete.cases(targets[paste0('d',s08_metrics)])
  targets$M05_interpretation<-'LOWER_IS_BETTER;dM05=A_MINUS_B_UNREVERSED'
  targets$convention<-ebm_convention;targets$verified_chronology_decision<-ebm_chronology
  setNames(list(slots,targets,s08_summarize(slots,targets)),s08_outputs)
}
s08_install <- function(r,dir=s08_dir,before_install=function(stage)NULL) {
  s08_ignored(dir);s08_verify();ebm_verify();s08_need(identical(names(r),s08_outputs),'Output scope mismatch')
  stage<-tempfile('.s08-stage-',tmpdir=dirname(dir));s08_need(dir.create(stage),'Cannot stage output')
  on.exit(unlink(stage,recursive=TRUE),add=TRUE)
  for(i in seq_along(r))write.table(r[[i]],file.path(stage,paste0(names(r)[i],'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
  paths<-file.path(stage,paste0(s08_outputs,'.csv'));hashes<-vapply(paths,s08_hash,'');before_install(stage)
  s08_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0),'Incomplete staging')
  s08_need(identical(vapply(paths,s08_hash,''),hashes),'Staged bytes changed')
  s08_verify();ebm_verify()
  if(dir.exists(dir)) {
    s08_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing scope differs; preserve release')
    s08_need(identical(unname(vapply(file.path(dir,basename(paths)),s08_hash,'')),unname(hashes)),'Existing bytes differ; preserve release')
  } else s08_need(file.rename(stage,dir),'Atomic installation failed')
  invisible(r)
}
aggregate_s08_batch_histories <- function(write_outputs=TRUE) {
  i<-s08_load();r<-do.call(s08_build,c(i,list(expected_n=2580L)))
  if(write_outputs)s08_install(r);r
}
if(sys.nframe()==0L) {
  r<-aggregate_s08_batch_histories();print(r[[3]][r[[3]]$level=='tour'&r[[3]]$slot %in% c('ALL','difference'),1:10],row.names=FALSE)
}
