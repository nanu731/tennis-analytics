# Phase 2AN: descriptive Net Point Rating weights for full S08 and reduced M03/M11/M12; base R only.
# Same-match explanatory shares of R-squared: not forecast importance, not causal effects.
# Development 2021-2023 is the headline fit; 2024 is a separate out-of-time check. No 2025 input is read.
an_version <- '2AN-1.0.0'
an_dir <- 'data/pilot/2an-factor-weights'
an_outputs <- c('weights','stability','diagnostics','dropped-rows')
an_sets <- list(full=c('M03','M05','M11','M12'),reduced=c('M03','M11','M12'))
an_outcomes <- c('NPR','equal_phase_NPR')
an_tours <- c('ATP','WTA')
an_pins <- c(
 'R/revalidate_broader_shortlist.R'='685d6a3ac26d5fd3e5ea8230fb716722d40c4ea6a9a26b2ddff3865cf86e642e',
 'R/analyze_exploratory_four_factors_pilots.R'='49061142662178a0366330d1c5064b8d8716f8bf96923050d9d429b2bdbdc6d9',
 'docs/four-factors-definition-protocol.md'='5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c',
 'docs/broader-shortlist-revalidation.md'='e2b80a74d6048bdcbfdad34e5f83fcd9213a7b76eaef2b0b83d4502ecd03f61b',
 'docs/dependence-aware-uncertainty-feasibility.md'='7d4a12a596859eb78079484a147754acb5ff6b47d6b8744fd18c93a9c91ce73b',
 'data/pilot/source-defined-cohort-admission/cohort-membership.csv'='398c24bb7da753b04c6457d0e814d030dffff4def4d68aa6297084be759c9c10',
 'data/pilot/source-defined-cohort-admission/row-dispositions.csv'='24ac0b7ef3433c0ec271a70847150cca3f7356c394c18af507337024cd1c99d6',
 'data/pilot/2024-source-admission-v2/membership.csv'='81c3f1079dd5af0dd0bc7cc4d8d055ab2d685c055e509073e8248e29cdf2ae83',
 'data/pilot/2024-source-admission-v2/row-dispositions.csv'='ed80d3f9a5c8c7b4dbf41b1fb49d1567fd9e275a9f5e6330dcb340971bd508a2')
an_labels <- c(uncertainty='UNCERTAINTY_NOT_ESTABLISHED',interpretation='SAME_MATCH_EXPLANATORY_SHARES_NOT_FORECAST_IMPORTANCE_NOT_CAUSAL',
 m05_interpretation_gate='M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED',factor_status='SELECTION_UNRESOLVED;S02_PAUSED;S08_PROVISIONAL;NO_FINAL_FACTORS_OR_WEIGHTS_SELECTED')
an_need <- function(ok,why)if(!isTRUE(ok))stop(why,call.=FALSE)
an_hash <- function(p)if(!file.exists(p))'MISSING' else substr(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),1,64)
an_verify <- function(pins=an_pins)an_need(all(vapply(names(pins),an_hash,'')==pins),'STOP: frozen input/authority mismatch')
an_import <- function(path,allow,e){found<-character();for(x in parse(path))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow){eval(x,e);found<-c(found,as.character(x[[2]]))};an_need(setequal(found,allow),'Helper allowlist mismatch')}
an_helpers <- function(){
 an_verify();e<-new.env(parent=globalenv())
 an_import('R/revalidate_broader_shortlist.R',c('bj_metrics','bj_need','bj_hash','bj_read','bj_pins','bj_verify','bj_helpers','bj_side','bj_pair','bj_samples'),e)
 h<-e$bj_helpers() # Frozen Phase 2F pure numerics: standardization/collinearity, OLS, increments, directions.
 for(k in c('pf_spec','pf_collinearity','pf_ols','pf_expected','pf_direction'))e[[k]]<-h[[k]];e
}
# Phase 2J same-match reconstruction (bj_samples loop) applied to any frozen membership/disposition pair.
an_rows <- function(m,d,e){
 out<-data.frame(match_id=m$match_id,tour=m$audit_tour,season=m$audit_season,event=m$event,surface=m$surface,cell_id=m$cell_id,
  player_a_id=m$player_a_id,player_b_id=m$player_b_id,count_origin=m$count_origin,win=as.integer(m$a_original_side=='winner'),stringsAsFactors=FALSE)
 fields<-c('ace','df','svpt','1stIn','1stWon','2ndWon','SvGms','bpFaced','bpSaved');rows<-vector('list',nrow(d))
 for(i in seq_len(nrow(d))){
  w<-setNames(as.numeric(d[i,paste0('effective_w_',fields)]),fields);l<-setNames(as.numeric(d[i,paste0('effective_l_',fields)]),fields)
  a<-if(out$win[i])w else l;b<-if(out$win[i])l else w;v<-e$bj_pair(a,b);swap<-e$bj_pair(b,a)
  an_need(identical(is.na(v),is.na(swap))&&all(abs(v+swap)<1e-10,na.rm=TRUE),'Player-slot antisymmetry failed')
  sides<-list(a=e$bj_side(a,b),b=e$bj_side(b,a));z<-as.list(v)
  for(side in names(sides))for(metric in e$bj_metrics){z[[paste(side,metric,'num',sep='_')]]<-unname(sides[[side]]$num[metric]);z[[paste(side,metric,'den',sep='_')]]<-unname(sides[[side]]$den[metric])}
  rows[[i]]<-as.data.frame(z)
 }
 out<-cbind(out,do.call(rbind,rows));out$common_complete<-complete.cases(out[c(e$bj_metrics,'NPR','equal_phase_NPR')])
 out$exclusion_reason<-vapply(seq_len(nrow(out)),function(i)paste(e$bj_metrics[!is.finite(as.numeric(out[i,e$bj_metrics]))],collapse=';'),'')
 an_need(all(is.na(out$M12)==(out$a_M12_den==0|out$b_M12_den==0)),'M12 opportunity mask');out
}
an_samples_2024 <- function(e){
 d<-e$bj_read('data/pilot/2024-source-admission-v2/row-dispositions.csv');m<-e$bj_read('data/pilot/2024-source-admission-v2/membership.csv')
 an_need(nrow(m)==1901&&!anyDuplicated(m$match_id)&&setequal(m$match_id,d$match_id[d$membership=='INCLUDED'])&&all(m$audit_season=='2024'),'Frozen 2024 membership mismatch')
 d<-d[match(m$match_id,d$match_id),]
 an_need(all(d$membership=='INCLUDED'&d$game_reconciliation=='PASS'&d$quarantined=='FALSE'&d$completion_status=='source_reported_normal'),'Excluded 2024 row entered analysis')
 an_need(identical(m$a_original_side,d$a_original_side)&&identical(m$winner_id,d$winner_id)&&identical(m$loser_id,d$loser_id),'2024 result ownership mismatch')
 an_rows(m,d,e)
}
an_load <- function(e){
 an_verify();dev<-e$bj_samples();val<-an_samples_2024(e) # bj_samples verifies all Phase 2J pins and pilot reproduction.
 an_need(nrow(dev)==2580&&all(dev$season %in% c('2021','2023')),'Development cohort mismatch')
 dev$split<-'development';val$split<-'validation_2024';rbind(dev,val)
}
an_permutations <- function(v)if(length(v)<=1)list(v) else do.call(c,lapply(seq_along(v),function(i)lapply(an_permutations(v[-i]),function(p)c(v[i],p))))
# LMG/Shapley: average gain in ordinary R-squared when each term enters, over all k! orderings.
an_lmg <- function(terms,value){
 orders<-an_permutations(terms)
 vapply(terms,function(j)mean(vapply(orders,function(o){pre<-o[seq_len(match(j,o)-1)];value(c(pre,j))-value(pre)},0.0)),0.0)
}
an_fit <- function(z,terms,outcome,e){
 dg<-e$pf_collinearity(as.matrix(z[terms]));Z<-dg$z;y<-z[[outcome]] # Centered, unit-SD within the fitted sample, as Phase 2J.
 key<-function(s)paste(terms[terms %in% s],collapse='+');cache<-list()
 value<-function(s){k<-key(s);if(!nzchar(k))return(0);if(is.null(cache[[k]])){f<-e$pf_ols(cbind(intercept=1,Z[,terms[terms %in% s],drop=FALSE]),y);cache[[k]]<<-if(f$ok)f$r2 else NA_real_};cache[[k]]}
 full<-e$pf_ols(cbind(intercept=1,Z),y);ok<-isTRUE(full$ok)&&is.finite(full$r2)
 phi<-if(ok)an_lmg(terms,value) else setNames(rep(NA_real_,length(terms)),terms);ok<-ok&&all(is.finite(phi))
 r2<-if(ok)full$r2 else NA_real_
 semi<-vapply(terms,function(j)if(ok)r2-value(setdiff(terms,j)) else NA_real_,0.0)
 share<-if(ok&&r2>0)100*phi/sum(phi) else rep(NA_real_,length(terms))
 beta<-if(ok)unname(full$beta[terms]) else rep(NA_real_,length(terms))
 data.frame(term=terms,coefficient=beta,expected_direction=e$pf_expected(terms),direction=e$pf_direction(beta),lmg_r2=unname(phi),share_pct=unname(share),
  share_rank=if(ok)rank(-phi,ties.method='min') else NA_integer_,semi_partial_r2=unname(semi),full_r2=r2,adjusted_r2=if(ok)full$adjusted else NA_real_,
  fit_ok=ok,rank=dg$rank,max_vif=max(dg$vif),max_correlation=dg$max_correlation,max_condition=max(dg$ci),gate=dg$gate,stringsAsFactors=FALSE)
}
an_contexts <- function(z){
 out<-list();add<-function(kind,id,d)out[[length(out)+1L]]<<-list(kind=kind,id=id,data=d)
 add('primary','ALL',z)
 for(field in c('season','surface'))for(id in sort(unique(z[[field]]),method='radix'))add(field,id,z[z[[field]]==id,,drop=FALSE])
 for(id in sort(unique(z$event),method='radix'))add('leave_event',id,z[z$event!=id,,drop=FALSE])
 for(id in sort(unique(c(z$player_a_id,z$player_b_id)),method='radix'))add('leave_player',id,z[z$player_a_id!=id&z$player_b_id!=id,,drop=FALSE])
 out
}
an_weights <- function(x,e){
 rows<-list()
 for(tour in an_tours)for(split in c('development','validation_2024')){
  z<-x[x$tour==tour&x$split==split&x$common_complete,,drop=FALSE]
  for(ctx in an_contexts(z))for(set in names(an_sets))for(outcome in an_outcomes){
   d<-ctx$data;f<-an_fit(d,an_sets[[set]],outcome,e)
   rows[[length(rows)+1L]]<-cbind(data.frame(tour=tour,split=split,kind=ctx$kind,slice=ctx$id,set=set,outcome=outcome,n=nrow(d),
    players=length(unique(c(d$player_a_id,d$player_b_id))),events=length(unique(d$event)),stringsAsFactors=FALSE),f)
  }
 }
 r<-do.call(rbind,rows);rownames(r)<-NULL;r
}
# Development coefficients and scaling applied unchanged to 2024 rows: out-of-time same-match R-squared.
an_out_of_time <- function(x,e){
 rows<-list()
 for(tour in an_tours)for(set in names(an_sets))for(outcome in an_outcomes){
  terms<-an_sets[[set]];dv<-x[x$tour==tour&x$split=='development'&x$common_complete,];vl<-x[x$tour==tour&x$split=='validation_2024'&x$common_complete,]
  dg<-e$pf_collinearity(as.matrix(dv[terms]));f<-e$pf_ols(cbind(intercept=1,dg$z),dv[[outcome]])
  Z<-sweep(sweep(as.matrix(vl[terms]),2,dg$mean,'-'),2,dg$sd,'/');pred<-as.vector(cbind(1,Z)%*%f$beta);y<-vl[[outcome]]
  rows[[length(rows)+1L]]<-data.frame(record_type='OUT_OF_TIME',tour=tour,set=set,outcome=outcome,development_n=nrow(dv),validation_n=nrow(vl),
   development_r2=f$r2,heldout_2024_r2=1-sum((y-pred)^2)/sum((y-mean(y))^2),stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
an_term_stability <- function(w,e){
 rows<-list();zero<-e$pf_spec()$increment_numeric_zero
 for(tour in an_tours)for(set in names(an_sets))for(outcome in an_outcomes)for(term in an_sets[[set]]){
  s<-w[w$tour==tour&w$set==set&w$outcome==outcome&w$term==term,]
  base<-function(split)s[s$split==split&s$kind=='primary',]
  r<-list(record_type='TERM_STABILITY',tour=tour,set=set,outcome=outcome,term=term,expected_direction=e$pf_expected(term))
  for(split in c('development','validation_2024')){b<-base(split);tag<-if(split=='development')'dev' else 'v2024'
   r[[paste0(tag,'_coefficient')]]<-b$coefficient;r[[paste0(tag,'_share_pct')]]<-b$share_pct;r[[paste0(tag,'_share_rank')]]<-b$share_rank;r[[paste0(tag,'_semi_partial_r2')]]<-b$semi_partial_r2
   for(kind in c('season','surface','leave_event','leave_player')){q<-s[s$split==split&s$kind==kind,];p<-paste(tag,kind,sep='_')
    r[[paste0(p,'_contexts')]]<-nrow(q);r[[paste0(p,'_min_share_pct')]]<-if(nrow(q))min(q$share_pct) else NA_real_;r[[paste0(p,'_max_share_pct')]]<-if(nrow(q))max(q$share_pct) else NA_real_
    r[[paste0(p,'_direction_failures')]]<-sum(q$direction!=q$expected_direction);r[[paste0(p,'_increment_lost')]]<-sum(is.na(q$semi_partial_r2)|q$semi_partial_r2<=zero)
    r[[paste0(p,'_rank_changes')]]<-sum(q$share_rank!=b$share_rank,na.rm=TRUE);r[[paste0(p,'_fit_or_gate_failures')]]<-sum(!q$fit_ok|q$gate %in% c('FAIL','AUTOMATIC_FAILURE'))}}
  r$all_contexts<-nrow(s);r$any_direction_failure<-any(s$direction!=s$expected_direction);r$any_increment_lost<-any(is.na(s$semi_partial_r2)|s$semi_partial_r2<=zero)
  r$any_fit_or_gate_failure<-any(!s$fit_ok|s$gate %in% c('FAIL','AUTOMATIC_FAILURE'))
  r$stable<-!r$any_direction_failure&&!r$any_increment_lost&&!r$any_fit_or_gate_failure;rows[[length(rows)+1L]]<-r
 }
 do.call(rbind,lapply(rows,as.data.frame,stringsAsFactors=FALSE))
}
# Strictest reading of the registered rule: any expected-direction failure, lost numerical increment or failed gate in any assessed
# development/2024 context makes that factor unstable. No materiality margin is introduced.
an_verdict <- function(ts){
 f<-ts[ts$set=='full'&ts$outcome=='NPR',];stable<-lapply(an_tours,function(t)f$term[f$tour==t&f$stable]);names(stable)<-an_tours
 both<-intersect(stable$ATP,stable$WTA);both<-an_sets$full[an_sets$full %in% both]
 label<-switch(as.character(length(both)),'4'='FOUR_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR','3'='THREE_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR','FEWER_THAN_THREE_STABLE_FACTORS_ON_NPR')
 data.frame(record_type='FACTOR_VERDICT',set='full',outcome='NPR',label=label,stable_both_tours=paste(both,collapse=';'),stable_atp=paste(stable$ATP,collapse=';'),stable_wta=paste(stable$WTA,collapse=';'),
  unstable_terms=paste(setdiff(an_sets$full,both),collapse=';'),rule='ALL_CONTEXTS_EXPECTED_DIRECTION_POSITIVE_INCREMENT_NO_GATE_FAILURE',stringsAsFactors=FALSE)
}
an_components <- function(z){
 # Bipartite event-player graph; connected components are the only joint blocks preserving both dependencies.
 nodes<-c(paste0('E:',unique(z$event)),paste0('P:',unique(c(z$player_a_id,z$player_b_id))));parent<-setNames(nodes,nodes)
 find<-function(v){while(parent[[v]]!=v)v<-parent[[v]];v};join<-function(a,b){ra<-find(a);rb<-find(b);if(ra!=rb)parent[[rb]]<<-ra}
 for(i in seq_len(nrow(z))){join(paste0('E:',z$event[i]),paste0('P:',z$player_a_id[i]));join(paste0('E:',z$event[i]),paste0('P:',z$player_b_id[i]))}
 roots<-vapply(nodes,find,'');size<-table(roots[paste0('E:',z$event)])
 list(components=length(unique(roots)),largest_match_share=max(size)/nrow(z))
}
an_diagnostics <- function(x,w,e){
 rows<-list()
 for(tour in an_tours)for(split in c('development','validation_2024')){
  z<-x[x$tour==tour&x$split==split&x$common_complete,];g<-an_components(z)
  rows[[length(rows)+1L]]<-data.frame(record_type='UNCERTAINTY_FEASIBILITY',tour=tour,split=split,n=nrow(z),events=length(unique(z$event)),players=length(unique(c(z$player_a_id,z$player_b_id))),
   joint_components=g$components,largest_component_match_share=g$largest_match_share,
   decision=if(g$components<2)'JOINT_EVENT_PLAYER_BLOCKS_DEGENERATE' else 'NO_VALIDATED_DEPENDENCE_AWARE_PROCEDURE',uncertainty='UNCERTAINTY_NOT_ESTABLISHED',stringsAsFactors=FALSE)
  for(set in names(an_sets)){dg<-e$pf_collinearity(as.matrix(z[an_sets[[set]]]));terms<-an_sets[[set]]
   for(j in seq_along(terms))rows[[length(rows)+1L]]<-data.frame(record_type='VIF',tour=tour,split=split,n=nrow(z),set=set,term=terms[j],value=unname(dg$vif[j]),gate=dg$gate,stringsAsFactors=FALSE)
   rows[[length(rows)+1L]]<-data.frame(record_type='CONDITION',tour=tour,split=split,n=nrow(z),set=set,value=max(dg$ci),gate=dg$gate,stringsAsFactors=FALSE)
   pr<-combn(seq_along(terms),2);for(k in seq_len(ncol(pr))){a<-pr[1,k];b<-pr[2,k]
    rows[[length(rows)+1L]]<-data.frame(record_type='CORRELATION',tour=tour,split=split,n=nrow(z),set=set,term=terms[a],partner=terms[b],pearson=dg$pearson[a,b],spearman=dg$spearman[a,b],gate=dg$gate,stringsAsFactors=FALSE)}}
 }
 k<-w[w$term=='M03'&w$outcome=='NPR',] # M03 is in both sets: one row per fitted context
 k$contexts<-1L;k$review_or_worse<-as.integer(k$gate!='NO_NUMERICAL_GATE_FAILURE');k$failures<-as.integer(k$gate %in% c('FAIL','AUTOMATIC_FAILURE'))
 agg<-aggregate(cbind(contexts,review_or_worse,failures)~tour+split+set+kind,data=k,sum)
 mx<-aggregate(cbind(max_vif,max_correlation,max_condition)~tour+split+set+kind,data=k,max)
 agg<-merge(agg,mx);agg$record_type<-'CONTEXT_GATES';rows[[length(rows)+1L]]<-agg
 an_bind(rows)
}
an_dropped <- function(x){
 rows<-list()
 for(tour in an_tours)for(split in c('development','validation_2024')){z<-x[x$tour==tour&x$split==split,]
  reason<-ifelse(z$common_complete,'COMPLETE',ifelse(z$exclusion_reason=='M12'&is.finite(z$NPR)&is.finite(z$equal_phase_NPR),
   paste0('M12_ZERO_BREAK_POINT_OPPORTUNITIES:',ifelse(z$a_M12_den==0&z$b_M12_den==0,'BOTH_SLOTS',ifelse(z$a_M12_den==0,'SLOT_A_OPPONENT','SLOT_B_OPPONENT'))),paste0('OTHER_UNDEFINED:',z$exclusion_reason)))
  for(r in sort(unique(reason),method='radix'))rows[[length(rows)+1L]]<-data.frame(tour=tour,split=split,admitted=nrow(z),reason=r,rows=sum(reason==r),
   seasons=paste(sort(unique(z$season[reason==r])),collapse=';'),imputed=0L,stringsAsFactors=FALSE)}
 an_bind(rows)
}
an_bind <- function(rows){fields<-unique(unlist(lapply(rows,names)));r<-do.call(rbind,lapply(rows,function(z){for(k in setdiff(fields,names(z)))z[[k]]<-NA;z[fields]}));rownames(r)<-NULL;r}
an_build <- function(x,e){
 an_verify();an_need(all(x$split %in% c('development','validation_2024'))&&!any(grepl('2025',x$season)),'Only development and 2024 rows are authorized')
 w<-an_weights(x,e);ts<-an_term_stability(w,e)
 out<-setNames(list(w,an_bind(list(an_out_of_time(x,e),ts,an_verdict(ts))),an_diagnostics(x,w,e),an_dropped(x)),an_outputs)
 for(k in names(out)){out[[k]]$version<-an_version;for(l in names(an_labels))out[[k]][[l]]<-an_labels[[l]]}
 an_verify();out
}
an_install <- function(r,dir=an_dir,before_install=function(stage)NULL){
 paths<-file.path(dir,paste0(an_outputs,'.csv'));got<-suppressWarnings(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE,stderr=TRUE))
 an_need(setequal(got,paths),'Output location must already be ignored');an_need(identical(names(r),an_outputs),'Output scope mismatch');an_verify()
 stage<-tempfile('.2an-stage-',tmpdir=dirname(dir));an_need(dir.create(stage),'Cannot stage output');on.exit(unlink(stage,recursive=TRUE),add=TRUE)
 for(k in names(r))write.table(r[[k]],file.path(stage,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\n',qmethod='double')
 staged<-file.path(stage,paste0(an_outputs,'.csv'));hashes<-vapply(staged,an_hash,'');before_install(stage)
 an_need(setequal(list.files(stage,all.files=TRUE,no..=TRUE),basename(staged))&&identical(vapply(staged,an_hash,''),hashes),'Staged bytes changed')
 if(dir.exists(dir)){an_need(setequal(list.files(dir,all.files=TRUE,no..=TRUE),basename(paths))&&identical(unname(vapply(paths,an_hash,'')),unname(hashes)),'Existing release differs; preserve it')}
 else an_need(file.rename(stage,dir),'Atomic output installation failed')
 invisible(r)
}
run_2an_factor_weights <- function(write_outputs=TRUE){e<-an_helpers();r<-an_build(an_load(e),e);if(write_outputs)an_install(r);r}
if(sys.nframe()==0L){r<-run_2an_factor_weights();print(r$stability[r$stability$record_type=='FACTOR_VERDICT',c('label','stable_both_tours','unstable_terms')],row.names=FALSE)}
