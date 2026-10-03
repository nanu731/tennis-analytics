# Focused Phase 2T checks. Historical runners and fitting functions are not sourced.
source('R/diagnose_m05_direction.R')
ncheck<-0L
check<-function(x,label){if(!isTRUE(x))stop(label,call.=FALSE);ncheck<<-ncheck+1L}
fails<-function(expr,label)check(inherits(tryCatch(force(expr),error=identity),'error'),label)
md_verify();check(length(md_pins)==15,'15 pins')
bad<-md_pins;bad[1]<-'bad';fails(md_verify(bad),'changed pin fails')
fails(md_verify(c('absent-phase2t-input'='bad')),'missing input fails')
md_ignored();fails(md_ignored('R/not-ignored-output'),'nonignored output fails')
x<-md_load();i<-do.call(md_prepare,x);r<-md_build(i)
check(nrow(i$p)==2580&&i$contributions==56999&&i$empty==805,'full frozen universe')
check(nrow(r[[1]])==18&&nrow(r[[2]])==1278&&!anyDuplicated(r[[2]]$match_id),'fold target accounting')
check(identical(as.integer(table(r[[2]]$tour)),c(211L,1067L)),'tour accounting')
check(all(r[[1]]$coefficient[r[[1]]$tour=='ATP']<0)&&all(r[[1]]$coefficient[r[[1]]$tour=='WTA']>0),'directions')
check(md_near(md_components(c(2,3),c(40,50),c(25,30))[,2],c(15,20)),'own opportunity formula')
fails(md_components(3,10,9),'invalid bundle fails')
check(is.na(md_cor(c(1,1),c(0,1)))&&is.na(md_cor(1,0)),'undefined associations')
check(md_near(md_cor(c(3,1,2),c(1,0,1),'spearman'),cor(c(3,1,2),c(1,0,1),method='spearman')),'rank association')
for(j in seq_len(nrow(i$f))){
 f<-i$f[j,];z<-r[[2]][r[[2]]$batch_key==f$batch_key,];tr<-i$p[match(strsplit(i$r$training_match_ids[j],';',fixed=TRUE)[[1]],i$p$match_id),]
 check(all(tr$source_tourney_date<f$source_tourney_date)&&all(tr$tour==f$tour),'strict training cutoff')
 for(k in md_metrics)check(md_near(sd(tr[[k]]),f[[paste0('sd_',k)]]),'frozen sample SD')
 check(md_near(z$M05_contribution,z$dM05/sd(tr$dM05)*f$beta_dM05),'frozen M05 contribution')
 check(md_near(z$reconstructed_eta,z$eta_s08)&&md_near(z$M05_contribution+z$other_frozen_contribution,z$eta_s08),'all coefficient reconstruction')
 swapped<-z;swapped[md_metrics]<--swapped[md_metrics];swapped<-md_contributions(swapped,f)
 check(md_near(swapped$M05_contribution,-z$M05_contribution)&&md_near(plogis(swapped$reconstructed_eta),1-z$p_s08),'slot swap')
 for(sample in c('TRAINING','TARGET'))for(level in c('ALL','season','surface','event')){
  g<-r[[3]][r[[3]]$fold==f$batch_key&r[[3]]$sample==sample&r[[3]]$level==level,]
  levels<-if(level=='ALL')'ALL' else unique(i$p[[level]][i$p$tour==f$tour])
  check(setequal(g$group,levels)&&sum(g$n)==if(sample=='TRAINING')nrow(tr) else nrow(z),'complete groups including absent cells')
 }
 check(md_near(r[[1]]$training_M05_y_pearson[j],cor(tr$dM05,tr$y)),'independent marginal association')
}
for(j in seq_len(nrow(r[[2]]))){z<-r[[2]][j,];check(md_near(z$dM05,z$a_df/z$a_opportunities-z$b_df/z$b_opportunities),'target own formula')}
for(v in c('min_opportunities','min_depth'))for(t in c('ATP','WTA')){
 z<-r[[2]][r[[2]]$tour==t,];q<-r[[4]][r[[4]]$record_type=='EXACT_VALUE_CUMULATIVE'&r[[4]]$scope=='TOUR'&r[[4]]$tour==t&r[[4]]$variable==v,]
 check(setequal(q$value,unique(z[[v]]))&&sum(q$n)==nrow(z)&&tail(q$cumulative_n,1)==nrow(z),'all observed opportunity/depth values')
 check(all(diff(q$cumulative_match_share)>=0)&&md_near(tail(q$cumulative_absolute_contribution_share,1),1),'cumulative accounting')
 for(k in seq_len(nrow(q)))check(md_near(q$cumulative_absolute_contribution_share[k],sum(abs(z$M05_contribution[z[[v]]<=q$value[k]]))/sum(abs(z$M05_contribution))),'independent cumulative contribution')
}
# Corrupted components, linkage, scaling and coefficients must fail closed.
y<-x;y$s$M05_num[which(y$s$M05_num!='NA')[1]]<-'9999';fails(do.call(md_prepare,y),'wrong pooled numerator')
y<-x;y$s$M05_den[which(y$s$M05_den!='NA')[1]]<-'9999';fails(do.call(md_prepare,y),'wrong denominator')
y<-x;y$h<-rbind(y$h,y$h[y$h$membership_status=='ELIGIBLE_EARLIER_BATCH',][1,]);fails(do.call(md_prepare,y),'duplicate history')
y<-x;ii<-which(y$h$membership_status=='ELIGIBLE_EARLIER_BATCH')[1];y$h$prior_player_slot[ii]<-if(y$h$prior_player_slot[ii]=='a')'b' else 'a';fails(do.call(md_prepare,y),'wrong prior owner')
y<-i;y$f$sd_dM05[1]<-y$f$sd_dM05[1]*2;fails(md_build(y),'changed scaling')
y<-i;y$f$beta_dM05[1]<-y$f$beta_dM05[1]+1;fails(md_build(y),'changed coefficient')
y<-x;y$p<-y$p[-1,];fails(do.call(md_prepare,y),'missing target')
# Reverse every input table: no source-row ordering enters arithmetic or summaries.
y<-lapply(x,function(z)z[nrow(z):1,,drop=FALSE]);rr<-md_build(do.call(md_prepare,y));check(identical(r,rr),'input permutation invariance')
# Static call walk: diagnostic has no estimation, sampling or model selection calls.
walk<-function(e){if(is.call(e))c(as.character(e[[1]])[1],unlist(lapply(as.list(e)[-1],walk))) else if(is.expression(e)||is.pairlist(e))unlist(lapply(as.list(e),walk)) else character()}
calls<-walk(parse('R/diagnose_m05_direction.R'))
check(!any(calls %in% c('glm','glm.fit','lm','lm.fit','optim','optimize','nlm','nls','sample','sample.int','boot','step','stepAIC')),'no forbidden calls')
# Stage tests use only disposable ignored directories; failed installs preserve release.
tmp<-tempfile('m05-test-',tmpdir='data/pilot')
tryCatch({
 fails(md_install(r,tmp,function(stage)stop('simulated interruption')),'interrupted install fails')
 check(!dir.exists(tmp),'no partial installation')
 fails(md_install(r,tmp,function(stage)cat('bad',file=file.path(stage,'summary.csv'),append=TRUE)),'staged corruption fails')
 check(!dir.exists(tmp),'corruption leaves no release')
 md_install(r,tmp);h1<-vapply(file.path(tmp,paste0(md_outputs,'.csv')),md_hash,'');md_install(rr,tmp)
 check(identical(h1,vapply(file.path(tmp,paste0(md_outputs,'.csv')),md_hash,'')),'byte-identical repeat')
 badr<-r;badr[[1]]$coefficient[1]<-0;fails(md_install(badr,tmp),'conflicting release preserved')
 check(identical(h1,vapply(file.path(tmp,paste0(md_outputs,'.csv')),md_hash,'')),'release immutable')
},finally=unlink(tmp,recursive=TRUE))
md_install(r);md_verify();check(TRUE,'historical input pins preserved')
allowed<-c('R/diagnose_m05_direction.R','R/test_m05_direction.R','docs/m05-direction-diagnostic.md','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
check(all(file.exists(allowed)),'six intended files exist')
changed<-unique(c(system2('git',c('diff','--name-only'),stdout=TRUE),system2('git',c('diff','--cached','--name-only'),stdout=TRUE),system2('git',c('ls-files','--others','--exclude-standard'),stdout=TRUE)))
check(all(changed %in% allowed),'no accidental tracked scope')
check(setequal(list.files(md_dir),paste0(md_outputs,'.csv')),'four output scope');md_ignored()
cat(ncheck,'Phase 2T focused checks passed\n')
