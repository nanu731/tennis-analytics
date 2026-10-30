# Descriptive profiles only: no probability model, outcome analysis or attribution.
source('R/build_mcp_serve_return_depth_linkage.R')
profile_prefix <- 'data/pilot/mcp-serve-return-profiles-v1-'
profile_outputs <- c('unit-contrasts','match-contrasts','profile-summary','deletions','coverage')
profile_spec_pin <- '078b0138778df817e648b8b11c0cf498467ef955679382f91848923c5489bcf9'
profile_input_pins <- c(
 'R/build_mcp_serve_return_depth_linkage.R'='3ce60acf3fee8648f32bbd89c12a5fa8dfad16c6714e4f0cf50ab14e8f9165cc',
 'R/test_mcp_serve_return_depth_linkage.R'='15c1592fd17028738abb62733bfbab86109314d1daf5bd9af80f5a38f40f058d',
 'docs/mcp-serve-return-depth-linkage-audit.md'='9a4d1626e7970bc873ea84e00b83f5e68b1819870d01286853e15e03ff42f48e',
 'data/pilot/mcp-serve-return-depth-v1-point-linkage.csv'='43814151cd8668d6e0045a1d52f4dbf8a41955fdede537348f5ed697bbe9cbdf',
 'data/pilot/mcp-serve-return-depth-v1-depth-cells.csv'='2ba0409af5f2b9b8c74ea75b1fdcc6ebfcf44050d477a8aacd56fb2dc1551027',
 'data/pilot/mcp-serve-return-depth-v1-context-support.csv'='75239ef64571d02948c029bd06400c3b6ee7cc7a7582da63494ed0709e08fbf0',
 'data/pilot/mcp-serve-return-depth-v1-repeated-pair-support.csv'='66dafdb862cd290d961fefd54d230861e0a14ec2f58e78bbacf683bbb4148feb',
 'data/pilot/mcp-serve-return-depth-v1-coverage-summary.csv'='2d5c44a47e9f02a4a03019bca99fc30073f7a4f957e319f09e85403c8626fba4',
 'data/pilot/mcp-serve-return-depth-v1-summary.csv'='60bb692b2048b04c614a97c5e580ffa2cff55cf8f08721452fc58b1b40332777')
profile_key <- function(x,fields)do.call(paste,c(x[fields],sep='|'))
profile_unit_fields <- c('match_id','server_slot','context')
profile_group_fields <- c('tour','context','direction_pair','return_depth')
profile_verify <- function(){
 for(p in names(profile_input_pins))mcp_need(file.exists(p)&&mcp_sha(p)==profile_input_pins[[p]],paste('Frozen input pin:',p))
 text<-readLines('docs/mcp-serve-return-response-profile-results.md',warn=FALSE)
 k<-match('## Measured results',text);mcp_need(!is.na(k),'Prospective boundary absent')
 text<-head(text,k-1L);while(length(text)&&tail(text,1)=='')text<-head(text,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(text,f)
 mcp_need(mcp_sha(f)==profile_spec_pin,'Prospective profile specification changed')
 linkage_verify();invisible(TRUE)
}
profile_load <- function(){
 profile_verify()
 read<-function(s)read.csv(paste0(linkage_prefix,s,'.csv'),stringsAsFactors=FALSE,check.names=FALSE)
 i<-list(cells=read('depth-cells'),contexts=read('context-support'),coverage=read('coverage-summary'))
 mcp_need(nrow(i$cells)==8028&&nrow(i$contexts)==892&&length(unique(i$contexts$match_id))==223,'Frozen inventory counts')
 profile_check(i);i
}
profile_check <- function(i){
 g<-i$cells;c<-i$contexts;uk<-profile_key(c,profile_unit_fields);gk<-profile_key(g,profile_unit_fields)
 mcp_need(!anyDuplicated(uk)&&!anyDuplicated(profile_key(g,c(profile_unit_fields,'serve_direction','return_depth'))),'Duplicate unit/depth cell')
 mcp_need(setequal(gk,uk)&&all(table(factor(gk,levels=uk))==9),'Complete three-direction/three-depth grid')
 mcp_need(all(g$serve_direction%in%4:6)&&all(g$return_depth%in%7:9)&&all(c$context%in%c('FIRST','SECOND'))&&all(c$server_slot%in%c('A','B'))&&all(c$tour%in%c('ATP','WTA')),'Literal supported labels')
 mcp_need(!anyNA(g[c('numerator','denominator','eligible')])&&all(is.finite(g$numerator))&&all(is.finite(g$denominator))&&all(g$numerator>=0&g$numerator==floor(g$numerator))&&all(g$denominator>=0&g$denominator==floor(g$denominator)),'Finite nonnegative integer counts')
 j<-match(gk,uk)
 for(f in c('tour','source_date','server_player','receiver_player','eligible','completion_exclusion'))mcp_need(identical(linkage_text(g[[f]]),linkage_text(c[[f]][j])),paste('Context identity conflict:',f))
 mcp_need(all(nzchar(c$server_player)&nzchar(c$receiver_player)&c$server_player!=c$receiver_player),'Exact distinct players')
 mcp_need(!any(g$numerator[!g$eligible]>0),'Completion exclusion preservation')
 ds<-split(seq_len(nrow(g)),profile_key(g,c(profile_unit_fields,'serve_direction')))
 for(ix in ds){z<-g[ix,];mcp_need(setequal(z$return_depth,7:9)&&all(z$denominator==sum(z$numerator)),'Three-depth denominator reconciliation')}
 expected<-linkage_ratio(g$numerator,g$denominator)
 mcp_need(all(is.na(g$rate)==is.na(expected))&&all(abs(g$rate[!is.na(expected)]-expected[!is.na(expected)])<1e-12),'Frozen count/proportion agreement')
 for(d in 4:6){z<-g[g$serve_direction==d&g$return_depth==7,];j<-match(uk,profile_key(z,profile_unit_fields));mcp_need(all(c[[paste0('direction_',d)]]==z$denominator[j]),'Context direction counts')}
 mcp_need(all(c$valid_pairs==c$direction_4+c$direction_5+c$direction_6),'Context pair totals')
 for(ix in split(seq_len(nrow(c)),c$match_id)){
  z<-c[ix,];mcp_need(nrow(z)==4&&setequal(paste(z$server_slot,z$context),c('A FIRST','A SECOND','B FIRST','B SECOND')),'Full neutral match/context grid')
  a<-z[z$server_slot=='A',];b<-z[z$server_slot=='B',]
  mcp_need(length(unique(z$tour))==1&&length(unique(z$source_date))==1&&length(unique(z$eligible))==1&&length(unique(a$server_player))==1&&length(unique(a$receiver_player))==1&&all(b$server_player==a$receiver_player[1])&&all(b$receiver_player==a$server_player[1]),'Both-slot identity agreement')
 }
 invisible(TRUE)
}
profile_units <- function(i){
 c<-i$contexts;c<-c[order(c$tour,c$source_date,c$match_id,c$server_slot,c$context,method='radix'),];g<-i$cells
 keys<-profile_key(g,c(profile_unit_fields,'serve_direction','return_depth'));rows<-list()
 for(pair in list(c(4,5),c(4,6),c(5,6)))for(depth in 7:9){
  z<-c[,c(profile_unit_fields,'tour','source_date','server_player','receiver_player','eligible','completion_exclusion','inventory_points','valid_pairs','retention_inventory')]
  z$direction_pair<-paste(pair,collapse='-');z$return_depth<-depth
  for(side in c('first','second')){
   d<-pair[if(side=='first')1 else 2];query<-z;query$serve_direction<-d
   j<-match(profile_key(query,c(profile_unit_fields,'serve_direction','return_depth')),keys);mcp_need(!anyNA(j),'Missing depth cell')
   z[[paste0('direction_',side)]]<-d
   for(f in c('numerator','denominator','rate','eligible_observed_candidates','qa_valid_eligible_candidates','candidate_retention_eligible'))z[[paste(side,f,sep='_')]]<-g[[f]][j]
  }
  z$available<-z$eligible&z$first_denominator>0&z$second_denominator>0
  z$contrast<-ifelse(z$available,z$first_rate-z$second_rate,NA_real_)
  z$disposition<-ifelse(!z$eligible,'COMPLETION_EXCLUDED',ifelse(z$first_denominator==0&z$second_denominator==0,'BOTH_DIRECTIONS_ABSENT',ifelse(z$first_denominator==0,'FIRST_DIRECTION_ABSENT',ifelse(z$second_denominator==0,'SECOND_DIRECTION_ABSENT','AVAILABLE'))))
  rows[[length(rows)+1L]]<-z
 }
 z<-do.call(rbind,rows);z<-z[order(z$tour,z$source_date,z$match_id,z$context,z$direction_pair,z$return_depth,z$server_slot,method='radix'),];rownames(z)<-NULL;z
}
profile_matches <- function(u){
 fields<-c('match_id',profile_group_fields);rows<-lapply(split(seq_len(nrow(u)),profile_key(u,fields)),function(ix){
  z<-u[ix,];x<-z[z$available,];a<-z[z$server_slot=='A',][1,]
  row<-a[,c(fields,'source_date','eligible','completion_exclusion')];row$player_a<-a$server_player;row$player_b<-a$receiver_player
  row$inventory_units<-nrow(z);row$available_units<-nrow(x);row$available<-nrow(x)>0
  row$first_exposure<-sum(x$first_denominator);row$second_exposure<-sum(x$second_denominator)
  row$contrast<-if(nrow(x))mean(x$contrast) else NA_real_
  row$disposition<-if(!a$eligible)'COMPLETION_EXCLUDED' else if(!nrow(x))'NO_AVAILABLE_UNIT_CONTRAST' else 'AVAILABLE'
  row
 });z<-do.call(rbind,rows);z<-z[order(z$tour,z$source_date,z$match_id,z$context,z$direction_pair,z$return_depth,method='radix'),];rownames(z)<-NULL;z
}
profile_describe <- function(x){if(!length(x))rep(NA_real_,5) else as.numeric(quantile(x,c(0,.25,.5,.75,1),names=FALSE,type=7))}
profile_summary <- function(u,m){
 grid<-expand.grid(tour=c('ATP','WTA'),context=c('FIRST','SECOND'),direction_pair=c('4-5','4-6','5-6'),return_depth=7:9,stringsAsFactors=FALSE);rows<-list()
 for(k in seq_len(nrow(grid))){row<-grid[k,];key<-profile_key(row,profile_group_fields);x<-u[profile_key(u,profile_group_fields)==key,];y<-m[profile_key(m,profile_group_fields)==key,];a<-x[x$available,];b<-y[y$available,]
  row$inventory_units<-nrow(x);row$unavailable_units<-sum(!x$available);row$contributing_units<-nrow(a);row$inventory_matches<-nrow(y);row$contributing_matches<-nrow(b)
  row$contributing_servers<-length(unique(a$server_player));row$contributing_receivers<-length(unique(a$receiver_player));row$contributing_identities<-length(unique(c(a$server_player,a$receiver_player)));row$contributing_ordered_pairs<-length(unique(paste(a$server_player,a$receiver_player,sep='|')))
  row$first_exposure<-sum(a$first_denominator);row$second_exposure<-sum(a$second_denominator);row$first_single_pair_units<-sum(a$first_denominator==1);row$second_single_pair_units<-sum(a$second_denominator==1)
  row$first_zero_direction_units<-sum(x$first_denominator==0);row$second_zero_direction_units<-sum(x$second_denominator==0)
  for(side in c('first','second')){v<-a[[paste0(side,'_denominator')]];q<-profile_describe(v);for(j in seq_along(q))row[[paste(side,c('N_min','N_q25','N_median','N_q75','N_max')[j],sep='_')]]<-q[j]}
  for(level in c('unit','match')){v<-if(level=='unit')a$contrast else b$contrast;q<-profile_describe(v);for(j in seq_along(q))row[[paste(level,c('min','q25','median','q75','max')[j],sep='_')]]<-q[j]}
  row$aggregate_contrast<-if(nrow(b))mean(b$contrast) else NA_real_;row$disposition<-if(nrow(b))'AVAILABLE' else 'NO_CONTRIBUTING_MATCHES'
  rows[[k]]<-row
 };z<-do.call(rbind,rows);z<-z[order(z$tour,z$context,z$direction_pair,z$return_depth,method='radix'),];rownames(z)<-NULL;z
}
profile_deletions <- function(m,s){
 rows<-list()
 for(tour in c('ATP','WTA')){
  universe<-unique(m[m$tour==tour,c('match_id','player_a','player_b')]);universe<-universe[order(universe$match_id,method='radix'),]
  if(!nrow(universe))next # A synthetic fixture may have no inventory in this category.
  players<-sort(unique(c(universe$player_a,universe$player_b)),method='radix')
  deletions<-rbind(data.frame(deletion_type='MATCH',deleted_id=universe$match_id),data.frame(deletion_type='PLAYER_BOTH_SLOTS',deleted_id=players))
  for(k in which(s$tour==tour)){
   base<-s[k,];z<-m[profile_key(m,profile_group_fields)==profile_key(base,profile_group_fields),];x<-z[z$available,]
   for(j in seq_len(nrow(deletions))){d<-deletions[j,];remove<-if(d$deletion_type=='MATCH')z$match_id==d$deleted_id else z$player_a==d$deleted_id|z$player_b==d$deleted_id
    y<-z[!remove&z$available,];row<-base[,profile_group_fields];row$deletion_type<-d$deletion_type;row$deleted_id<-d$deleted_id;row$baseline_contrast<-base$aggregate_contrast;row$baseline_matches<-nrow(x);row$removed_inventory_matches<-sum(remove);row$removed_contributing_matches<-sum(remove&z$available);row$remaining_matches<-nrow(y)
    row$remaining_contrast<-if(nrow(y))mean(y$contrast) else NA_real_;row$change<-row$remaining_contrast-row$baseline_contrast
    row$disposition<-if(!nrow(x))'UNEVALUABLE_BASELINE' else if(!nrow(y))'UNEVALUABLE_NO_REMAINING_MATCHES' else 'AVAILABLE'
    row$direction_reversed<-if(row$disposition=='AVAILABLE')sign(row$remaining_contrast)*sign(row$baseline_contrast)<0 else NA
    row$remaining_zero<-if(row$disposition=='AVAILABLE')row$remaining_contrast==0 else NA
    rows[[length(rows)+1L]]<-row
   }
  }
 };z<-do.call(rbind,rows);if(is.null(z))return(data.frame());rownames(z)<-NULL;z
}
profile_reconcile <- function(r){
 for(name in c('unit-contrasts','match-contrasts','profile-summary','deletions')){
  z<-r[[name]];fields<-switch(name,'unit-contrasts'=c(profile_unit_fields,'direction_pair'),'match-contrasts'=c('match_id','context','direction_pair'),'profile-summary'=c('tour','context','direction_pair'),'deletions'=c('tour','context','direction_pair','deletion_type','deleted_id'))
  for(ix in split(seq_len(nrow(z)),profile_key(z,fields))){a<-z[ix,];mcp_need(nrow(a)==3&&setequal(a$return_depth,7:9),'Complete depth distribution')
   vals<-switch(name,'unit-contrasts'=a$contrast,'match-contrasts'=a$contrast,'profile-summary'=a$aggregate_contrast,'deletions'=a$remaining_contrast)
   mcp_need(all(is.na(vals))||(!anyNA(vals)&&abs(sum(vals))<1e-12),'Three-depth contrast sum')
   if(name=='unit-contrasts')for(side in c('first','second')){v<-a[[paste0(side,'rate')]];mcp_need(all(is.na(v))||(!anyNA(v)&&abs(sum(v)-1)<1e-12),'Direction probability partition')}
  }
 }
 invisible(TRUE)
}
run_mcp_serve_return_response_profiles <- function(i=profile_load()){
 profile_check(i);u<-profile_units(i);m<-profile_matches(u);s<-profile_summary(u,m);d<-profile_deletions(m,s);cov<-i$coverage;cov$source_coverage_release<-cov$release
 r<-list('unit-contrasts'=u,'match-contrasts'=m,'profile-summary'=s,deletions=d,coverage=cov)
 for(k in names(r)){
  r[[k]]$release<-'MCP_SERVE_RETURN_RESPONSE_PROFILES_1.0.0';r[[k]]$source_release<-'MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0';r[[k]]$specification_sha256<-profile_spec_pin
  r[[k]]$claim<-'DESCRIPTIVE_SURVIVAL_CONDITIONED_RETURN_DEPTH_NOT_SERVE_ADVANTAGE';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';rownames(r[[k]])<-NULL
 }
 profile_reconcile(r);r
}
profile_install <- function(r,rename=file.rename){
 mcp_need(identical(names(r),profile_outputs),'Exact five-output scope');paths<-paste0(profile_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Output location must already be ignored')
 stage<-vapply(paths,function(p)tempfile('.mcp-profile-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(j in seq_along(r))mcp_write(r[[j]],stage[j]);profile_verify()
 for(j in seq_along(paths))if(file.exists(paths[j]))mcp_need(mcp_sha(paths[j])==mcp_sha(stage[j]),'Refuse differing profile release')
 created<-character();success<-FALSE;on.exit(if(!success)unlink(created),add=TRUE)
 for(j in seq_along(paths))if(!file.exists(paths[j])){mcp_need(rename(stage[j],paths[j]),'Atomic profile installation failed');created<-c(created,paths[j])}
 success<-TRUE;invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline profile experiment takes no arguments');r<-run_mcp_serve_return_response_profiles();profile_install(r);print(r[['profile-summary']][,c(profile_group_fields,'contributing_matches','aggregate_contrast')],row.names=FALSE)}
