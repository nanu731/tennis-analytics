# Fixed exploratory three-class distribution transfer; no balance/NPR scoring.
source('R/build_mcp_serve_plus1_protocol.R')
source('R/run_mcp_return_transfer.R')
direct_prefix <- 'data/pilot/mcp-direct-serve-transfer-v1-'
direct_outputs <- c('point-dispositions','observation-counts','target-estimates','paired-scores','stability','coverage-summary','summary')
direct_classes <- c('ACE','DOUBLE_FAULT','OTHER')
direct_definition_pin <- '70117be68f7aa4fb44e2b2ce390f0dad95c8eca6d7d55d83b8d191af620255d8'
direct_decision_pin <- '79f67353697d70fd5a467428237732ccd9ae60bc2d8838d58d17eaf71a916bef'
direct_verify <- function() {
 plus_protocol_verify()
 mcp_need(mcp_sha('docs/annotated-error-measurement-family-decision.md')==direct_decision_pin,'Approved direct Serve decision changed')
 lines<-readLines('docs/mcp-direct-serve-transfer-results.md',warn=FALSE)
 cut<-match('## Measured coverage and denominators',lines);mcp_need(!is.na(cut),'Prospective boundary missing')
 lines<-head(lines,cut-1L);while(length(lines)&&tail(lines,1)=='')lines<-head(lines,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(lines,f)
 mcp_need(mcp_sha(f)==direct_definition_pin,'Prospective specification changed')
 invisible(TRUE)
}
direct_load <- function(){direct_verify();plus_protocol_load()}
direct_points <- function(input) {
 plus_protocol_check(input)
 e<-input$eligibility;s<-input$states;a<-input$actions;p<-input$points
 p$point_id<-paste(p$match_id,p$Pt,sep='|');mcp_need(!anyDuplicated(p$point_id),'Duplicate point denominator')
 servers<-unique(s[s$owner_domain=='Serve',c('match_id','server','actor_neutral_slot')])
 sk<-paste(servers$match_id,servers$server,sep='|');mcp_need(!anyDuplicated(sk),'Ambiguous server identity')
 j<-match(paste(p$match_id,p$server,sep='|'),sk);mi<-match(p$match_id,e$match_id)
 mcp_need(!anyNA(j)&&!anyNA(mi),'Unlinked service point')
 p$slot<-servers$actor_neutral_slot[j];p$player<-ifelse(p$slot=='A',e$player_a[mi],e$player_b[mi])
 p$tour<-e$tour_file[mi];p$source_date<-e$source_date[mi];p$eligible<-e$eligible[mi]
 p$completion_exclusion<-e$exclusion_reasons[mi]
 ai<-match(s$action_id,a$action_id);pi<-match(s$point_id,p$point_id)
 mcp_need(all(s$point_validated==p$tennis_sequence_validated[pi])&&all(s$score_reconciliation_status==p$score_status[pi]),'Point/state QA authority mismatch')
 valid<-p$tennis_sequence_validated&p$score_status=='PASS'
 mcp_need(all(p$terminal_agrees[valid])&&all(p$recorded_winner[valid]==p$inferred_winner[valid]),'Validated terminal/recorded authority conflict')
 ti<-which(s$point_validated&s$score_reconciliation_status=='PASS'&nzchar(s$post_terminal_status)&!a$is_void[ai])
 tk<-s$point_id[ti];mcp_need(!anyDuplicated(tk)&&setequal(tk,p$point_id[valid]),'Exactly one supported terminal per validated point')
 t<-s[ti,];mcp_need(all(t$transition_usable&t$local_boundary_supported&t$post_boundary=='TERMINAL'&!t$authority_conflict),'Unsupported terminal boundary')
 v<-match(t$point_id,p$point_id)
 expected<-ifelse(p$recorded_winner[v]==p$server[v],'SERVER','RECEIVER')
 mcp_need(all(t$post_terminal_status==p$terminal[v])&&all(t$post_terminal_winner_role==expected),'Terminal/server winner reconciliation')
 k<-match(p$point_id,tk);term<-t$post_terminal_status[k]
 p$validated_terminal<-ifelse(valid,term,'');p$terminal_domain<-ifelse(valid,t$owner_domain[k],'UNKNOWN')
 special<-valid&term%in%c('ACE','DOUBLE_FAULT');special[is.na(special)]<-FALSE
 ts<-t[match(p$point_id[special],t$point_id),]
 mcp_need(all(ts$owner_domain=='Serve'&ts$owner_role=='SERVER'&ts$tennis_action_usable),'Direct terminals require usable server-owned Serve action')
 mcp_need(all(ts$post_kind[ts$post_terminal_status=='ACE']=='SERVE')&&all(ts$post_kind[ts$post_terminal_status=='DOUBLE_FAULT']=='SERVE_FAULT'&ts$post_serve_number[ts$post_terminal_status=='DOUBLE_FAULT']==2),'Direct terminal kind/serve number conflict')
 p$point_class<-ifelse(valid,ifelse(term%in%c('ACE','DOUBLE_FAULT'),term,'OTHER'),'UNRESOLVED')
 p$qa_validated<-valid;p$included<-p$eligible&valid
 p$disposition<-ifelse(!p$eligible,'COMPLETION_EXCLUDED',ifelse(valid,'VALIDATED_SERVICE_POINT','WITHHELD_POINT_QA'))
 p$withheld_reasons<-ifelse(valid,'',paste(p$parse_status,p$issues,p$score_reasons,sep='|'))
 p<-p[order(p$tour,p$source_date,p$match_id,p$Pt,method='radix'),];rownames(p)<-NULL;p
}
direct_counts <- function(p,e) {
 rows<-list();seeds<-tapply(e$source_date[e$eligible],e$tour_file[e$eligible],min)
 for(i in seq_len(nrow(e)))for(slot in c('A','B')) {
  z<-p[p$match_id==e$match_id[i]&p$slot==slot,];use<-z[z$included,]
  cc<-vapply(direct_classes,function(k)sum(use$point_class==k),0L)
  rows[[length(rows)+1L]]<-data.frame(tour=e$tour_file[i],match_id=e$match_id[i],slot,player=if(slot=='A')e$player_a[i] else e$player_b[i],player_a=e$player_a[i],player_b=e$player_b[i],source_date=e$source_date[i],batch_key=paste(e$tour_file[i],e$source_date[i],sep='|'),event=e$event_label[i],surface=e$Surface[i],eligible=e$eligible[i],completion_exclusion=e$exclusion_reasons[i],seed=e$eligible[i]&&e$source_date[i]==seeds[e$tour_file[i]],inventory_points=nrow(z),qa_validated_points=sum(z$qa_validated),completion_excluded_points=sum(!z$eligible),withheld_points=sum(z$eligible&!z$qa_validated),N=nrow(use),ACE=cc[1],DOUBLE_FAULT=cc[2],OTHER=cc[3],explicit_unknown_points=sum(nzchar(z$explicit_unknowns)),retention=execution_ratio(nrow(use),nrow(z)),balance=execution_ratio(cc[1]-cc[2],nrow(use)),stringsAsFactors=FALSE)
 }
 x<-do.call(rbind,rows);rownames(x)<-NULL
 mcp_need(nrow(x)==2*nrow(e)&&!anyDuplicated(paste(x$match_id,x$slot))&&all(rowSums(x[,direct_classes])==x$N)&&all(x$inventory_points==x$N+x$withheld_points+x$completion_excluded_points),'Complete unique class/denominator partition')
 x[order(x$tour,x$source_date,x$match_id,x$slot,method='radix'),]
}
direct_prob <- function(counts){n<-sum(counts);if(n>0)counts/n else rep(NA_real_,3)}
direct_loss <- function(counts,prob,kind) {
 mcp_need(length(counts)==3&&length(prob)==3&&all(is.finite(counts)&counts>=0&counts==floor(counts))&&sum(counts)>0&&all(is.finite(prob)&prob>=0&prob<=1)&&abs(sum(prob)-1)<1e-12,'Invalid multiclass loss input')
 if(kind=='brier')return(sum(counts*(1-2*prob+sum(prob^2)))/sum(counts))
 mcp_need(kind=='log_loss','Unsupported loss')
 if(any(counts>0&prob==0))return(Inf)
 -sum(counts[counts>0]*log(prob[counts>0]))/sum(counts)
}
direct_estimates <- function(counts,score=TRUE) {
 mcp_need(!anyDuplicated(paste(counts$match_id,counts$slot))&&all(counts$slot%in%c('A','B'))&&all(counts$tour%in%c('ATP','WTA'))&&all(mcp_date_valid(gsub('-','',counts$source_date,fixed=TRUE))),'Invalid target identity/category/date')
 mcp_need(all(is.finite(as.matrix(counts[,direct_classes]))&as.matrix(counts[,direct_classes])>=0&as.matrix(counts[,direct_classes])==floor(as.matrix(counts[,direct_classes])))&&all(rowSums(counts[,direct_classes])==counts$N)&&all(counts$N[!counts$eligible]==0),'Invalid frozen class counts/denominator')
 counts<-counts[order(counts$tour,counts$source_date,counts$match_id,counts$slot,method='radix'),]
 rows<-list()
 for(i in seq_len(nrow(counts))) {
  z<-counts[i,];prior<-counts[counts$eligible&counts$tour==z$tour&counts$source_date<z$source_date,];own<-prior[prior$player==z$player,]
  pc<-colSums(own[,direct_classes,drop=FALSE]);rc<-colSums(prior[,direct_classes,drop=FALSE]);n<-sum(pc);rn<-sum(rc)
  reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(z$seed)'SEED_NOT_EVALUATED' else if(!z$N)'NO_VALIDATED_TARGET_POINTS' else if(!n)'NO_PRIOR_PLAYER_POINTS' else if(!rn)'NO_PRIOR_REFERENCE_POINTS' else 'PAIRED_SUPPORTED'
  flags<-c(if(!z$eligible)'COMPLETION_EXCLUDED',if(z$seed)'SEED_NOT_EVALUATED',if(!z$N)'NO_VALIDATED_TARGET_POINTS',if(!n)'NO_PRIOR_PLAYER_POINTS',if(!rn)'NO_PRIOR_REFERENCE_POINTS')
  q<-if(z$eligible)direct_prob(pc) else rep(NA_real_,3);rq<-if(z$eligible)direct_prob(rc) else rep(NA_real_,3)
  dates<-own$source_date[own$N>0];supported<-reason=='PAIRED_SUPPORTED'
  row<-cbind(z,data.frame(prior_matches=nrow(own),prior_usable_matches=sum(own$N>0),prior_N=n,reference_N=rn,reference_matches=length(unique(prior$match_id)),prior_last_date=if(length(dates))max(dates) else '',days_since_last_source_date=if(length(dates))as.numeric(as.Date(z$source_date)-as.Date(max(dates))) else NA_real_,disposition=reason,abstention_flags=paste(flags,collapse='|'),paired_mask=supported,stringsAsFactors=FALSE))
  for(k in seq_along(direct_classes)){cl<-direct_classes[k];row[[paste0('prior_',cl)]]<-pc[k];row[[paste0('reference_',cl)]]<-rc[k];row[[paste0('personal_p_',cl)]]<-q[k];row[[paste0('reference_p_',cl)]]<-rq[k]}
  row$personal_expected_balance<-q[1]-q[2];row$reference_expected_balance<-rq[1]-rq[2]
  if(score)for(model in c('personal','reference'))for(kind in c('brier','log_loss'))row[[paste(model,kind,sep='_')]]<-if(supported)direct_loss(as.numeric(z[,direct_classes]),if(model=='personal')q else rq,kind) else NA_real_
  row$personal_endpoint_failures<-if(supported)sum(as.numeric(z[,direct_classes])[q==0]) else 0
  row$reference_endpoint_failures<-if(supported)sum(as.numeric(z[,direct_classes])[rq==0]) else 0
  rows[[i]]<-row
 }
 x<-do.call(rbind,rows);rownames(x)<-NULL;x
}
direct_score <- function(x) {
 x<-x[x$paired_mask,];out<-data.frame(paired_slots=nrow(x),scored_matches=length(unique(x$match_id)),target_points=sum(x$N),personal_infinite_slots=sum(is.infinite(x$personal_log_loss)),reference_infinite_slots=sum(is.infinite(x$reference_log_loss)),personal_endpoint_failures=sum(x$personal_endpoint_failures),reference_endpoint_failures=sum(x$reference_endpoint_failures))
 for(kind in c('brier','log_loss'))for(model in c('personal','reference')) {
  v<-x[[paste(model,kind,sep='_')]]
  out[[paste(model,kind,sep='_')]]<-if(nrow(x))mean(vapply(split(v,x$match_id),mean,0.0)) else NA_real_
  out[[paste(model,kind,'opportunity_weighted',sep='_')]]<-if(nrow(x))sum(v*x$N)/sum(x$N) else NA_real_
 }
 for(kind in c('brier','log_loss'))for(suffix in c('','_opportunity_weighted')){d<-out[[paste0('personal_',kind,suffix)]]-out[[paste0('reference_',kind,suffix)]];out[[paste0('difference_',kind,suffix)]]<-if(is.nan(d))NA_real_ else d}
 out$comparison_status<-if(!nrow(x))'UNEVALUABLE' else if(is.na(out$difference_log_loss))'INDETERMINATE_LOG_COMPARISON' else 'DESCRIPTIVE_ONLY';out
}
direct_stability <- function(x) {
 rows<-list()
 for(tour in c('ATP','WTA')) {
  z<-x[x$tour==tour&x$eligible&!x$seed,];base<-direct_score(z)
  for(type in c('MATCH','PLAYER')) {
   ids<-sort(unique(if(type=='MATCH')z$match_id else c(z$player_a,z$player_b)),method='radix')
   for(id in ids){remove<-if(type=='MATCH')z$match_id==id else z$player_a==id|z$player_b==id
    out<-direct_score(z[!remove,]);out$deleted_evaluation_matches<-length(unique(z$match_id[remove]));out$deleted_paired_slots<-sum(z$paired_mask[remove]);out$change_brier_difference<-out$difference_brier-base$difference_brier;out$change_log_difference<-out$difference_log_loss-base$difference_log_loss
    rows[[length(rows)+1L]]<-cbind(data.frame(tour,deletion_type=type,deleted_id=id,stringsAsFactors=FALSE),out)
   }
  }
 }
 do.call(rbind,rows)
}
direct_coverage <- function(p,e) {
 rows<-lapply(seq_len(nrow(e)),function(i){z<-p[p$match_id==e$match_id[i],];u<-z[z$included,]
  data.frame(tour=e$tour_file[i],match_id=e$match_id[i],source_date=e$source_date[i],eligible=e$eligible[i],exclusion_reasons=e$exclusion_reasons[i],inventory_points=nrow(z),included_points=nrow(u),withheld_points=sum(z$eligible&!z$qa_validated),completion_excluded_points=sum(!z$eligible),retention=execution_ratio(nrow(u),nrow(z)),ACE=sum(u$point_class=='ACE'),DOUBLE_FAULT=sum(u$point_class=='DOUBLE_FAULT'),OTHER=sum(u$point_class=='OTHER'),OTHER_UNRETURNABLE=sum(u$validated_terminal=='UNRETURNABLE'),OTHER_RETURN=sum(u$terminal_domain=='Return'),OTHER_RALLY=sum(u$terminal_domain=='Rally'),OTHER_ADMIN=sum(u$terminal_domain=='ADMIN'),explicit_unknown_points=sum(nzchar(z$explicit_unknowns)),stringsAsFactors=FALSE)})
 x<-do.call(rbind,rows);x[order(x$tour,x$source_date,x$match_id,method='radix'),]
}
direct_summary <- function(x,cov) {
 do.call(rbind,lapply(c('ATP','WTA'),function(tour){z<-x[x$tour==tour,];use<-z[z$paired_mask,];v<-cov[cov$tour==tour,];m<-tapply(z$paired_mask[z$eligible&!z$seed],z$match_id[z$eligible&!z$seed],sum)
  data.frame(tour,inventory_matches=nrow(v),inventory_slots=nrow(z),inventory_points=sum(v$inventory_points),eligible_matches=sum(v$eligible),source_batches=length(unique(z$source_date)),eligible_batches=length(unique(z$source_date[z$eligible])),seed_matches=length(unique(z$match_id[z$seed])),completion_excluded_slots=sum(!z$eligible),included_points=sum(z$N),withheld_points=sum(v$withheld_points),completion_excluded_points=sum(v$completion_excluded_points),ACE=sum(z$ACE),DOUBLE_FAULT=sum(z$DOUBLE_FAULT),OTHER=sum(z$OTHER),retention=sum(z$N)/sum(v$inventory_points),paired_slots=nrow(use),scored_matches=length(unique(use$match_id)),distinct_supported_players=length(unique(use$player)),cold_start_slots=sum(z$disposition=='NO_PRIOR_PLAYER_POINTS'),zero_target_slots=sum(z$disposition=='NO_VALIDATED_TARGET_POINTS'),zero_reference_slots=sum(z$disposition=='NO_PRIOR_REFERENCE_POINTS'),both_supported_matches=sum(m==2),one_supported_matches=sum(m==1),neither_supported_matches=sum(m==0),min_prior_N=min(use$prior_N),median_prior_N=median(use$prior_N),max_prior_N=max(use$prior_N),min_prior_matches=min(use$prior_usable_matches),median_prior_matches=median(use$prior_usable_matches),max_prior_matches=max(use$prior_usable_matches),min_gap_days=min(use$days_since_last_source_date),median_gap_days=median(use$days_since_last_source_date),max_gap_days=max(use$days_since_last_source_date),stringsAsFactors=FALSE)
 }))
}
run_mcp_direct_serve_transfer <- function(input=direct_load()) {
 direct_verify();p<-direct_points(input);c<-direct_counts(p,input$eligibility)
 # Reconcile denominators and support before entering comparative scoring.
 pre<-direct_estimates(c,score=FALSE);mcp_need(nrow(pre)==446&&nrow(p)==43310&&all(rowSums(c[,direct_classes])==c$N),'Pre-score support/accounting')
 x<-direct_estimates(c);mcp_need(identical(pre$paired_mask,x$paired_mask),'Comparison mask changed after scoring')
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)cbind(data.frame(tour),direct_score(x[x$tour==tour,]))))
 cov<-direct_coverage(p,input$eligibility)
 r<-list('point-dispositions'=p,'observation-counts'=c,'target-estimates'=x,'paired-scores'=scores,stability=direct_stability(x),'coverage-summary'=cov,summary=direct_summary(x,cov))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_DIRECT_SERVE_TRANSFER_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$specification_sha256<-direct_definition_pin;r[[k]]$option<-'ALL_DATE_EXPANDING';r[[k]]$claim<-'EXPLORATORY_OBSERVED_QA_VALIDATED_SERVICE_POINT_DISTRIBUTION_NOT_SKILL_OR_FACTOR';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
direct_install <- function(r) {
 mcp_need(identical(names(r),direct_outputs),'Exact direct Serve output scope');paths<-paste0(direct_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.direct-serve-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);direct_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing direct Serve release')
 created<-character();success<-FALSE;on.exit(if(!success)unlink(created),add=TRUE)
 for(i in seq_along(paths))if(!file.exists(paths[i])){mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file installation failed');created<-c(created,paths[i])}
 success<-TRUE;invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline runner takes no arguments');r<-run_mcp_direct_serve_transfer();direct_install(r);print(r$summary[,1:24],row.names=FALSE);print(r[['paired-scores']],row.names=FALSE)}
