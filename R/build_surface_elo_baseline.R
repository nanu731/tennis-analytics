# Phase 2P 1.0.0: fixed synchronous Elo; probability/coverage audit only.
se_version <- '1.0.0'
se_pins <- c(
`AGENTS.override.md`='7581dec4eac3697a29e4d85aab6afaf1021dfae87c7419da5b9879462279d28b',
`PROJECT_CONTEXT.md`='010a6d29201d0d0223af6bbb119ad85dd7ad27ef9170fe5598c9a0b2cbe753b9',
`docs/surface-elo-common-evaluation-decision.md`='d67c753d7431b2dec98ffb91bdb73d257201f032303655f6f99dd565177f78bd',
`docs/source-label-event-batching-decision.md`='7303d4a3784f18318275ad1133191257c15a5caec75f0a5d03caa01fe2196c5c',
`docs/event-batch-membership-audit.md`='9ffc26c83c91a295a4f79352ae326eeb7a56700976b398560175650b24c07a4a',
`docs/s08-batched-history-aggregation.md`='1ac223d78c40705877db3e2810b2c507631d39043ac23d178aaee5586d4c75c2',
`docs/source-defined-cohort-audit.md`='5aa928d4f270357739b384337a71e79bc79f52461cbd7740a00c839e5698f38b',
`R/build_event_batch_membership.R`='e42d4aa6879550c71f665c5b2dd2dd8c0499a89d8223d1e4f5537cc325030146',
`data/pilot/event-batch-membership/target-batches.csv`='2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0',
`data/pilot/event-batch-membership/candidate-history-membership.csv`='3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156',
`data/pilot/event-batch-membership/summary.csv`='04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246',
`data/pilot/s08-batched-histories/slot-history-aggregates.csv`='9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087',
`data/pilot/s08-batched-histories/target-s08-features.csv`='b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00',
`data/pilot/s08-batched-histories/summary.csv`='7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4',
`data/pilot/source-defined-cohort-admission/cohort-membership.csv`='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
`data/pilot/source-defined-cohort-admission/row-dispositions.csv`='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6'
)
se_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
se_hash <- function(p)if(!file.exists(p))'MISSING' else strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
se_verify <- function(pins=se_pins)se_need(all(vapply(names(pins),se_hash,'')==pins),'Missing/changed Phase 2P frozen input')
se_read <- function(p)read.csv(p,colClasses='character',na.strings=NULL,check.names=FALSE)
se_sort <- function(x,fields) {x<-x[do.call(order,c(unname(x[fields]),list(method='radix'))),,drop=FALSE];rownames(x)<-NULL;x}
se_convention <- 'SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY'
se_chronology <- 'NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE'
se_dir <- 'data/pilot/surface-elo-baseline'
se_outputs <- c('target-elo-probabilities','rating-update-ledger','summary')
se_ignored <- function(dir=se_dir) {
 p<-file.path(dir,paste0(se_outputs,'.csv'))
 got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(p)),stdout=TRUE,stderr=TRUE))
 se_need(setequal(p,got),'STOP: output location must already be ignored')
}
se_helpers <- function() {
 # Reuse pinned pure definitions only, never historical runners or authority checks.
 se_verify();e<-new.env(parent=baseenv())
 allowed<-c('ebm_need','ebm_sort','ebm_label_valid','ebm_prepare','ebm_membership','ebm_convention','ebm_chronology')
 for(expr in parse('R/build_event_batch_membership.R'))if(is.call(expr)&&identical(expr[[1]],as.name('<-'))&&is.symbol(expr[[2]])&&as.character(expr[[2]]) %in% allowed)eval(expr,e)
 se_need(all(vapply(allowed,exists,TRUE,envir=e,inherits=FALSE)),'Pure helper set incomplete');e
}
se_load <- function() {
 se_ignored();se_verify()
 list(x=se_read('data/pilot/event-batch-membership/target-batches.csv'),
 h=se_read('data/pilot/event-batch-membership/candidate-history-membership.csv'),
 m=se_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv'),
 d=se_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv'),
 f=se_read('data/pilot/s08-batched-histories/target-s08-features.csv'))
}
se_prepare <- function(x,h,m,d,f,expected_n=NULL) {
 e<-se_helpers();canonical<-e$ebm_prepare(m,d,expected_n)
 x<-se_sort(x,c('tour','source_tourney_date','cell_id','match_id'))
 se_need(identical(x[names(canonical)],canonical),'Frozen target metadata mismatch')
 h<-se_sort(h,c('tour','target_source_date','target_cell','target_match_id','target_slot','prior_source_date','prior_match_id'))
 se_need(identical(h,e$ebm_membership(canonical)),'Frozen membership ledger mismatch')
 se_need(all(x$surface %in% c('Hard','Clay','Grass')),'Unsupported surface')
 for(cell in unique(x$cell_id))se_need(length(unique(x$surface[x$cell_id==cell]))==1,'Conflicting event surface')
 se_need(!anyDuplicated(f$match_id)&&setequal(f$match_id,x$match_id),'S08 target universe mismatch')
 f<-f[match(x$match_id,f$match_id),]
 for(field in c('tour','season','cell_id','surface','batch_key','source_tourney_date','player_a_id','player_b_id'))se_need(identical(f[[field]],x[[field]]),paste('S08 metadata mismatch:',field))
 for(slot in c('a','b')) {
  rates<-sapply(paste0(slot,'_',c('M03','M05','M11','M12')),function(v)suppressWarnings(as.numeric(f[[v]])))
  reasons<-sapply(paste0(slot,'_',c('M03','M05','M11','M12'),'_reason'),function(v)f[[v]]=='DEFINED')
  se_need(identical(unname(is.finite(rates)),unname(reasons)),'S08 completeness/reason conflict')
  x[[paste0(slot,'_s08_complete')]]<-rowSums(is.finite(rates))==4
 }
 both<-x$a_s08_complete&x$b_s08_complete
 se_need(all(as.character(both)==f$all_s08_differences_defined),'S08 complete-vector flag mismatch')
 x$s08_stratum<-ifelse(both,'BOTH_COMPLETE',ifelse(x$a_s08_complete|x$b_s08_complete,'ONE_COMPLETE','NEITHER_COMPLETE'))
 m<-m[match(x$match_id,m$match_id),];d<-d[match(x$match_id,d$match_id),]
 se_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS'),'Excluded outcome encountered')
 se_need(all(m$a_original_side %in% c('winner','loser'))&&identical(m$a_original_side,d$a_original_side),'Invalid result orientation')
 se_need(identical(m$winner_id,d$winner_id)&&identical(m$loser_id,d$loser_id)&&
 all(x$player_a_id==ifelse(m$a_original_side=='winner',m$winner_id,m$loser_id))&&
 all(x$player_b_id==ifelse(m$a_original_side=='winner',m$loser_id,m$winner_id)),'Result/player linkage mismatch')
 list(x=x,y=as.integer(m$a_original_side=='winner'),h=h)
}
se_probability <- function(a,b)1/(1+10^((b-a)/400))
se_pre_batch <- function(z,g,s,ng,ns) {
 get<-function(v,k,default) {out<-unname(v[k]);out[is.na(out)]<-default;out}
 for(slot in c('a','b')) {
  id<-z[[paste0('player_',slot,'_id')]];sk<-paste(id,z$surface,sep='|')
  z[[paste0(slot,'_overall')]]<-get(g,id,1500)
  z[[paste0(slot,'_surface')]]<-get(s,sk,1500)
  z[[paste0(slot,'_blend')]]<-.5*z[[paste0(slot,'_overall')]]+.5*z[[paste0(slot,'_surface')]]
  z[[paste0(slot,'_overall_prior_matches')]]<-get(ng,id,0)
  z[[paste0(slot,'_surface_prior_matches')]]<-get(ns,sk,0)
  z[[paste0(slot,'_overall_cold')]]<-z[[paste0(slot,'_overall_prior_matches')]]==0
  z[[paste0(slot,'_surface_cold')]]<-z[[paste0(slot,'_surface_prior_matches')]]==0
 }
 z$p_a_primary<-se_probability(z$a_blend,z$b_blend);z$p_b_primary<-1-z$p_a_primary
 z$p_a_overall<-se_probability(z$a_overall,z$b_overall);z$p_b_overall<-1-z$p_a_overall
 se_need(all(is.finite(as.matrix(z[c('p_a_primary','p_b_primary','p_a_overall','p_b_overall')]))),'Nonfinite target probability')
 z
}
se_match_deltas <- function(z,y) {
 # Called only after every probability in this batch has been frozen.
 dg<-32*(y-z$p_a_overall);ds<-32*(y-se_probability(z$a_surface,z$b_surface))
 rows<-lapply(c('a','b'),function(slot)data.frame(match_id=z$match_id,player_id=z[[paste0('player_',slot,'_id')]],surface=z$surface,
  delta_g=if(slot=='a')dg else -dg,delta_s=if(slot=='a')ds else -ds,stringsAsFactors=FALSE))
 se_sort(do.call(rbind,rows),c('match_id','player_id'))
}
se_replay <- function(x,y) {
 se_need(length(y)==nrow(x)&&all(y %in% c(0,1)),'Invalid neutral outcomes')
 context<-c('match_id','tour','season','batch_key','source_tourney_date','cell_id','event','surface','round','player_a_id','player_b_id','a_s08_complete','b_s08_complete','s08_stratum')
 probs<-list();updates<-list()
 for(tour in sort(unique(x$tour),method='radix')) {
  g<-s<-ng<-ns<-numeric()
  for(label in sort(unique(x$source_tourney_date[x$tour==tour]),method='radix')) {
   ii<-which(x$tour==tour&x$source_tourney_date==label);ii<-ii[order(x$match_id[ii],method='radix')]
   z<-se_pre_batch(x[ii,context],g,s,ng,ns);probs[[length(probs)+1L]]<-z
   delta<-se_match_deltas(z,y[ii])
   for(component in c('OVERALL','SURFACE')) {
    keys<-if(component=='OVERALL')delta$player_id else paste(delta$player_id,delta$surface,sep='|')
    for(key in sort(unique(keys),method='radix')) {
     rows<-delta[keys==key,];id<-rows$player_id[1];surface<-if(component=='OVERALL')'ALL' else rows$surface[1]
     before<-if(component=='OVERALL')g[key] else s[key];count<-if(component=='OVERALL')ng[key] else ns[key]
     if(is.na(before))before<-1500;if(is.na(count))count<-0
     change<-sum(if(component=='OVERALL')rows$delta_g else rows$delta_s);after<-unname(before+change)
     updates[[length(updates)+1L]]<-data.frame(tour=tour,season=substr(label,1,4),batch_key=paste(tour,label,sep='|'),source_tourney_date=label,
      player_id=id,component=component,surface=surface,before=unname(before),prior_matches=unname(count),batch_matches=nrow(rows),
      accumulated_delta=change,after=after,after_matches=unname(count+nrow(rows)),contributing_match_ids=paste(rows$match_id,collapse=';'),stringsAsFactors=FALSE)
     if(component=='OVERALL') {g[key]<-after;ng[key]<-count+nrow(rows)} else {s[key]<-after;ns[key]<-count+nrow(rows)}
    }
   }
  }
 }
 p<-se_sort(do.call(rbind,probs),c('tour','source_tourney_date','cell_id','match_id'))
 u<-se_sort(do.call(rbind,updates),c('tour','source_tourney_date','component','surface','player_id'))
 for(name in c('p','u')) {z<-get(name);z$version<-se_version;z$convention<-se_convention;z$verified_chronology_decision<-se_chronology;assign(name,z)}
 list(p=p,u=u)
}
se_summary <- function(p,u) {
 groups<-list(list(level='overall',tour='ALL',group='ALL',ii=seq_len(nrow(p))))
 for(tour in sort(unique(p$tour),method='radix')) {
  it<-which(p$tour==tour);groups[[length(groups)+1L]]<-list(level='tour',tour=tour,group=tour,ii=it)
  for(field in c('season','batch_key','cell_id','surface'))for(v in sort(unique(p[[field]][it]),method='radix'))groups[[length(groups)+1L]]<-list(level=field,tour=tour,group=v,ii=it[p[[field]][it]==v])
 }
 blank<-list(record_type='',level='',tour='',group='',stratum='',component='',surface='',targets=NA_integer_,primary_available=NA_integer_,overall_available=NA_integer_,
  overall_cold_slots=NA_integer_,surface_cold_slots=NA_integer_,both_overall_cold=NA_integer_,one_overall_cold=NA_integer_,neither_overall_cold=NA_integer_,both_surface_cold=NA_integer_,one_surface_cold=NA_integer_,neither_surface_cold=NA_integer_,
  min_primary=NA_real_,max_primary=NA_real_,min_overall=NA_real_,max_overall=NA_real_,boundary_probabilities=NA_integer_,update_rows=NA_integer_,match_contributions=NA_integer_,delta_sum=NA_real_,max_abs_delta=NA_real_,min_before=NA_real_,max_before=NA_real_,min_after=NA_real_,max_after=NA_real_)
 out<-list();range_safe<-function(z,fn)if(length(z))fn(z) else NA_real_
 for(group in groups)for(stratum in c('ALL','BOTH_COMPLETE','ONE_COMPLETE','NEITHER_COMPLETE')) {
  z<-p[group$ii,];if(stratum!='ALL')z<-z[z$s08_stratum==stratum,]
  row<-blank;row$record_type<-'COVERAGE';row$level<-group$level;row$tour<-group$tour;row$group<-group$group;row$stratum<-stratum
  row$targets<-nrow(z);row$primary_available<-sum(is.finite(z$p_a_primary));row$overall_available<-sum(is.finite(z$p_a_overall))
  for(kind in c('overall','surface')) {
   n<-z[[paste0('a_',kind,'_cold')]]+z[[paste0('b_',kind,'_cold')]]
   row[[paste0(kind,'_cold_slots')]]<-sum(n)
   for(k in 0:2)row[[paste0(c('neither','one','both')[k+1],'_',kind,'_cold')]]<-sum(n==k)
  }
  for(kind in c('primary','overall')) {row[[paste0('min_',kind)]]<-range_safe(z[[paste0('p_a_',kind)]],min);row[[paste0('max_',kind)]]<-range_safe(z[[paste0('p_a_',kind)]],max)}
  row$boundary_probabilities<-sum(z$p_a_primary %in% c(0,1))+sum(z$p_a_overall %in% c(0,1));out[[length(out)+1L]]<-as.data.frame(row,stringsAsFactors=FALSE)
 }
 for(tour in sort(unique(u$tour),method='radix'))for(batch in c('ALL',sort(unique(u$batch_key[u$tour==tour]),method='radix')))for(component in c('OVERALL','SURFACE')) {
  z<-u[u$tour==tour&u$component==component,];if(batch!='ALL')z<-z[z$batch_key==batch,]
  for(surface in sort(unique(z$surface),method='radix')) {
   zz<-z[z$surface==surface,];row<-blank;row$record_type<-'UPDATE';row$level<-if(batch=='ALL')'tour' else 'batch_key';row$tour<-tour;row$group<-if(batch=='ALL')tour else batch;row$component<-component;row$surface<-surface
   row$update_rows<-nrow(zz);row$match_contributions<-sum(zz$batch_matches);row$delta_sum<-sum(zz$accumulated_delta);row$max_abs_delta<-max(abs(zz$accumulated_delta));row$min_before<-min(zz$before);row$max_before<-max(zz$before);row$min_after<-min(zz$after);row$max_after<-max(zz$after)
   out[[length(out)+1L]]<-as.data.frame(row,stringsAsFactors=FALSE)
  }
 }
 out<-do.call(rbind,out);out$convention<-se_convention;out$verified_chronology_decision<-se_chronology
 se_sort(out,c('record_type','level','tour','group','stratum','component','surface'))
}
se_build <- function(x,h,m,d,f,expected_n=NULL) {
 i<-se_prepare(x,h,m,d,f,expected_n);r<-se_replay(i$x,i$y)
 for(slot in c('a','b'))se_need(all(r$p[[paste0(slot,'_overall_prior_matches')]]==as.integer(i$x[[paste0(slot,'_history_matches')]])),'Rating history differs from Phase 2M')
 se_need(sum(r$u$batch_matches[r$u$component=='OVERALL'])==2*nrow(x)&&sum(r$u$batch_matches[r$u$component=='SURFACE'])==2*nrow(x),'Update accounting failed')
 setNames(list(r$p,r$u,se_summary(r$p,r$u)),se_outputs)
}
se_install <- function(r,dir=se_dir,before_install=function(stage)NULL) {
 se_ignored(dir);se_verify();se_need(identical(names(r),se_outputs),'Output scope mismatch')
 stage<-tempfile('.surface-elo-stage-',tmpdir=dirname(dir));se_need(dir.create(stage),'Cannot stage outputs');on.exit(unlink(stage,recursive=TRUE),add=TRUE)
 for(i in seq_along(r))write.table(r[[i]],file.path(stage,paste0(names(r)[i],'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
 paths<-file.path(stage,paste0(se_outputs,'.csv'));hashes<-vapply(paths,se_hash,'');before_install(stage)
 se_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(paths))&&all(file.info(paths)$size>0),'Incomplete staging')
 se_need(identical(vapply(paths,se_hash,''),hashes),'Staged bytes changed');se_verify()
 if(dir.exists(dir)) {
  se_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths)),'Existing output scope differs; preserve release')
  se_need(identical(unname(vapply(file.path(dir,basename(paths)),se_hash,'')),unname(hashes)),'Existing bytes differ; preserve release')
 } else se_need(file.rename(stage,dir),'Atomic installation failed')
 invisible(r)
}
build_surface_elo_baseline <- function(write_outputs=TRUE) {i<-se_load();r<-do.call(se_build,c(i,list(expected_n=2580L)));if(write_outputs)se_install(r);r}
if(sys.nframe()==0L) {r<-build_surface_elo_baseline();print(r[[3]][r[[3]]$record_type=='COVERAGE'&r[[3]]$level=='tour',c('tour','stratum','targets','primary_available','overall_cold_slots','surface_cold_slots')],row.names=FALSE)}
