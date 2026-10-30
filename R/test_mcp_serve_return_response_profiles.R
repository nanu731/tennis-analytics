source('R/run_mcp_serve_return_response_profiles.R')
checks<-0L
check<-function(x,label){checks<<-checks+1L;if(!isTRUE(x))stop(label,call.=FALSE)}
same<-function(x,y){if(is.numeric(x)&&is.numeric(y))length(x)==length(y)&&identical(is.na(x),is.na(y))&&all(abs(x[!is.na(x)]-y[!is.na(y)])<=1e-12) else isTRUE(all.equal(x,y,check.attributes=FALSE,tolerance=1e-12))}
fails<-function(expr)inherits(tryCatch({force(expr);NULL},error=function(e)e),'error')
i<-profile_load();r<-run_mcp_serve_return_response_profiles(i);u<-r[['unit-contrasts']];m<-r[['match-contrasts']];s<-r[['profile-summary']];d<-r$deletions
check(identical(names(r),profile_outputs),'Exact output scope')
check(nrow(u)==8028&&nrow(m)==4014&&nrow(s)==36&&nrow(r$coverage)==233,'Complete unit/match/aggregate/coverage grids')
check(length(unique(u$match_id))==223&&length(unique(profile_key(u,profile_unit_fields)))==892,'Every inventory match and perspective retained')
check(!anyDuplicated(profile_key(u,c(profile_unit_fields,'direction_pair','return_depth'))),'Unique unit contrasts')
check(all(is.na(u$contrast)==!u$available)&&all(u$available==(u$eligible&u$first_denominator>0&u$second_denominator>0)),'Positive denominator common masks')
check(all(u$disposition[!u$eligible]=='COMPLETION_EXCLUDED')&&all(is.na(u$contrast[!u$eligible])),'Completion exclusions preserved')
check(setequal(unique(u$direction_pair),c('4-5','4-6','5-6'))&&setequal(unique(u$return_depth),7:9),'All prespecified pairs and depths')
check(all(abs(u$contrast[u$available])<=1),'Signed contrast bounds')
# Read only point linkage identities, admission and literal attributes, never outcomes.
pfile<-paste0(linkage_prefix,'point-linkage.csv');header<-names(read.csv(pfile,nrows=0,check.names=FALSE))
keep<-c('match_id','server_slot','context','serve_direction','return_depth','valid_pair','server_player','receiver_player')
classes<-ifelse(header%in%keep,NA_character_,'NULL');p<-read.csv(pfile,colClasses=classes,stringsAsFactors=FALSE,check.names=FALSE);p<-p[p$valid_pair,]
check(nrow(p)==21523,'Frozen valid-pair denominator')
g<-i$cells;keys<-c(profile_unit_fields,'serve_direction','return_depth');counts<-table(profile_key(p,keys));j<-match(profile_key(g,keys),names(counts));want<-as.integer(counts[j]);want[is.na(want)]<-0L
check(identical(g$numerator,want),'Independent point-ledger count reconstruction')
for(side in c('first','second')){
 query<-u;query$serve_direction<-u[[paste0('direction_',side)]];j<-match(profile_key(query,keys),profile_key(g,keys))
 check(all(u[[paste0(side,'numerator')]]==g$numerator[j])&&all(u[[paste0(side,'denominator')]]==g$denominator[j]),paste('Independent side count join',side))
 check(same(u[[paste0(side,'_rate')]],linkage_ratio(g$numerator[j],g$denominator[j])),paste('Independent side proportion',side))
}
check(same(u$contrast,ifelse(u$available,u$first_numerator/u$first_denominator-u$second_numerator/u$second_denominator,NA_real_)),'Independent signed arithmetic')
for(ix in split(seq_len(nrow(u)),profile_key(u,c('match_id',profile_group_fields)))){
 z<-u[ix,];j<-match(profile_key(z[1,],c('match_id',profile_group_fields)),profile_key(m,c('match_id',profile_group_fields)))
 v<-z$contrast[z$available];check(same(m$contrast[j],if(length(v))sum(v)/length(v) else NA_real_)&&m$available_units[j]==length(v),'Independent within-match available-unit mean')
}
for(k in seq_len(nrow(s))){z<-m[profile_key(m,profile_group_fields)==profile_key(s[k,],profile_group_fields),];v<-z$contrast[z$available]
 check(same(s$aggregate_contrast[k],if(length(v))sum(v)/length(v) else NA_real_)&&s$contributing_matches[k]==length(v),'Independent equal-match primary mean')
}
# Verify all deletion rows, including identities appearing in either slot.
mk<-profile_key(m,profile_group_fields)
for(k in seq_len(nrow(d))){row<-d[k,];z<-m[mk==profile_key(row,profile_group_fields),];remove<-if(row$deletion_type=='MATCH')z$match_id==row$deleted_id else z$player_a==row$deleted_id|z$player_b==row$deleted_id
 v<-z$contrast[!remove&z$available];check(row$removed_inventory_matches==sum(remove)&&row$removed_contributing_matches==sum(remove&z$available)&&row$remaining_matches==length(v)&&same(row$remaining_contrast,if(length(v))sum(v)/length(v) else NA_real_)&&same(row$change,row$remaining_contrast-row$baseline_contrast),'Independent frozen both-slot/match deletion')
}
for(t in c('ATP','WTA')){
 z<-unique(m[m$tour==t,c('match_id','player_a','player_b')]);q<-d[d$tour==t,]
 check(setequal(unique(q$deleted_id[q$deletion_type=='MATCH']),z$match_id),'All inventory match deletions')
 check(setequal(unique(q$deleted_id[q$deletion_type=='PLAYER_BOTH_SLOTS']),unique(c(z$player_a,z$player_b))),'All inventory player deletions')
}
check(any(d$removed_contributing_matches==0)&&all(d$change[d$removed_contributing_matches==0&d$disposition=='AVAILABLE']==0),'Zero-impact deletions retained')
check(same(d$change,d$remaining_contrast-d$baseline_contrast),'Deletion change arithmetic')
check(all(d$direction_reversed[d$disposition=='AVAILABLE']==(sign(d$remaining_contrast[d$disposition=='AVAILABLE'])*sign(d$baseline_contrast[d$disposition=='AVAILABLE'])<0)),'Direction reversal signs')
check(profile_reconcile(r),'Full three-depth partition and zero-sum identities')
# Generic data fixtures preserve the same ownership/grid definitions.
fixture<-function(){
 c<-i$contexts[i$contexts$match_id%in%unique(i$contexts$match_id)[1:2],];g<-i$cells[i$cells$match_id%in%c$match_id,]
 c$eligible<-TRUE;c$completion_exclusion<-NA_character_;g$eligible<-TRUE;g$completion_exclusion<-NA_character_
 for(k in seq_len(nrow(c))){mask<-profile_key(g,profile_unit_fields)==profile_key(c[k,],profile_unit_fields);g$numerator[mask]<-0L}
 list(cells=g,contexts=c,coverage=i$coverage)
}
refresh<-function(f){g<-f$cells;c<-f$contexts
 for(ix in split(seq_len(nrow(g)),profile_key(g,c(profile_unit_fields,'serve_direction'))))g$denominator[ix]<-sum(g$numerator[ix])
 g$rate<-linkage_ratio(g$numerator,g$denominator)
 for(d in 4:6){z<-g[g$serve_direction==d&g$return_depth==7,];j<-match(profile_key(c,profile_unit_fields),profile_key(z,profile_unit_fields));c[[paste0('direction_',d)]]<-z$denominator[j]}
 c$valid_pairs<-c$direction_4+c$direction_5+c$direction_6;f$cells<-g;f$contexts<-c;f
}
f<-fixture();ids<-unique(f$contexts$match_id)
# Match one: A contrast 1, B contrast 0, despite very different counts.
put<-function(match,slot,d,counts){mask<-f$cells$match_id==ids[match]&f$cells$server_slot==slot&f$cells$context=='FIRST'&f$cells$serve_direction==d;f$cells$numerator[mask]<<-counts}
put(1,'A',4,c(100,0,0));put(1,'A',5,c(0,100,0));put(1,'B',4,c(1,0,0));put(1,'B',5,c(1,0,0))
# Match two: only A contributes, contrast -1.
put(2,'A',4,c(0,1,0));put(2,'A',5,c(1,0,0));f<-refresh(f);fr<-run_mcp_serve_return_response_profiles(f)
ix<-with(fr[['profile-summary']],tour=='ATP'&context=='FIRST'&direction_pair=='4-5'&return_depth==7)
check(same(fr[['profile-summary']]$aggregate_contrast[ix],-.25),'Two-stage weighting differs from pooled/count/all-unit averaging')
fu<-fr[['unit-contrasts']];check(any(fu$available&fu$contrast==0),'Observed zero contrast not unavailable')
check(all(is.na(fu$contrast[!fu$available]))&&all(is.na(fu$first_rate[fu$first_denominator==0])),'Empty cells undefined')
fd<-fr$deletions;check(any(fd$disposition=='UNEVALUABLE_BASELINE')&&all(is.na(fd$remaining_contrast[fd$disposition!='AVAILABLE'])),'Unevaluable deletion explicit')
check(any(fd$direction_reversed%in%TRUE),'Deletion reversal fixture')
# One contributing match deleted leaves an explicitly empty estimand.
ff<-f;mask<-ff$cells$match_id==ids[2];ff$cells$numerator[mask]<-0L;ff<-refresh(ff);ffr<-run_mcp_serve_return_response_profiles(ff)
check(any(ffr$deletions$disposition=='UNEVALUABLE_NO_REMAINING_MATCHES'),'No remaining contributor fails closed')
# Swap the literal directions: pair 4-5 reverses without attributing favorable depth.
fs<-f;fs$cells$serve_direction<-ifelse(fs$cells$serve_direction==4,5,ifelse(fs$cells$serve_direction==5,4,6));fs<-refresh(fs);fsr<-run_mcp_serve_return_response_profiles(fs)
check(same(fsr[['profile-summary']]$aggregate_contrast[ix],.25),'First-minus-second sign fixture')
# Invalid, incomplete or conflicting count ledgers must stop.
bad<-i;bad$cells<-bad$cells[-1,];check(fails(profile_check(bad)),'Missing depth cell fail closed')
bad<-i;bad$cells<-rbind(bad$cells,bad$cells[1,]);check(fails(profile_check(bad)),'Duplicate depth fail closed')
bad<-i;bad$cells$denominator[1]<-bad$cells$denominator[1]+1;check(fails(profile_check(bad)),'Conflicting denominator fail closed')
bad<-i;bad$cells$numerator[1]<-NA;check(fails(profile_check(bad)),'Missing count fail closed')
bad<-i;bad$cells$receiver_player[1]<-'WRONG_ID';check(fails(profile_check(bad)),'Player conflict fail closed')
bad<-i;bad$cells$serve_direction[1]<-0;check(fails(profile_check(bad)),'Unknown direction not promoted')
bad<-i;bad$cells$rate[1]<-.98765;check(fails(profile_check(bad)),'Conflicting frozen rate fail closed')
# Pin failures use changed in-memory expected pins, never modify historical sources.
old<-profile_input_pins;profile_input_pins[1]<-strrep('0',64);check(fails(profile_verify()),'Source pin failure');profile_input_pins<-old
old<-profile_spec_pin;profile_spec_pin<-strrep('0',64);check(fails(profile_verify()),'Prospective pin failure');profile_spec_pin<-old
# Exact serialization, row/event/within-unit permutation and independent reruns.
set.seed(1);ip<-i;ip$cells<-ip$cells[sample(nrow(ip$cells)),];ip$contexts<-ip$contexts[sample(nrow(ip$contexts)),]
r2<-run_mcp_serve_return_response_profiles(ip)
paths<-paste0(profile_prefix,profile_outputs,'.csv');before<-vapply(paths,mcp_sha,'')
for(k in names(r)){f1<-tempfile();f2<-tempfile();mcp_write(r[[k]],f1);mcp_write(r2[[k]],f2);check(mcp_sha(f1)==mcp_sha(f2),'Permutation byte identity');check(mcp_sha(f1)==mcp_sha(paste0(profile_prefix,k,'.csv')),'Independent frozen-release rerun identity');unlink(c(f1,f2))}
profile_install(r);check(identical(before,vapply(paths,mcp_sha,'')),'Reinstall preserves same bytes')
# Failure installation test uses only newly created temporary paths.
old_prefix<-profile_prefix;profile_prefix<-paste0('data/pilot/.profile-atomic-fixture-',Sys.getpid(),'-');testpaths<-paste0(profile_prefix,profile_outputs,'.csv')
check(fails(profile_install(r,rename=function(a,b){if(grepl('match-contrasts',b,fixed=TRUE))FALSE else file.rename(a,b)}))&&!any(file.exists(testpaths)),'Atomic rollback leaves no partial new release')
profile_install(r);bad<-r;bad[['unit-contrasts']]$contrast[1]<-123
check(fails(profile_install(bad))&&all(file.exists(testpaths)),'Differing existing release refused')
check(all(vapply(seq_along(testpaths),function(k)mcp_sha(testpaths[k])==mcp_sha(paths[k]),TRUE)),'Refusal leaves existing fixture bytes intact');unlink(testpaths);profile_prefix<-old_prefix
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'All five outputs ignored')
for(k in names(r))check(all(r[[k]]$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED')&&all(r[[k]]$source_release=='MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0'),'Sensitivity labels retained')
# Retention ledger remains frozen except new release metadata; original source release explicit.
for(k in setdiff(names(i$coverage),c('release','specification_sha256','claim','chronology','exposure','uncertainty')))check(identical(r$coverage[[k]],i$coverage[[k]]),paste('Frozen coverage column',k))
cat('PASS:',checks,'focused checks; deterministic five-output release.\n')
