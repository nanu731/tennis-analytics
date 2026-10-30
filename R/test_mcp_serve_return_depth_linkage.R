source('R/build_mcp_serve_return_depth_linkage.R')
checks<-0L
check<-function(x,label){checks<<-checks+1L;if(!isTRUE(x))stop(label,call.=FALSE)}
same<-function(x,y)isTRUE(all.equal(x,y,check.attributes=FALSE,tolerance=1e-12))
fails<-function(expr)inherits(tryCatch({force(expr);NULL},error=function(e)e),'error')
i<-linkage_load();r<-build_mcp_serve_return_depth_linkage(i);p<-r[['point-linkage']];g<-r[['depth-cells']];c<-r[['context-support']];rp<-r[['repeated-pair-support']];e<-i$eligibility;a<-i$actions
check(identical(names(r),linkage_outputs),'Exact six-output scope')
check(nrow(p)==43310&&!anyDuplicated(p$point_id)&&nrow(e)==223,'All point and match inventory')
check(nrow(g)==223*2*2*3*3&&nrow(c)==223*2*2,'Explicit full grids')
check(setequal(unique(g$match_id),e$match_id)&&setequal(unique(c$match_id),e$match_id),'Excluded and empty matches retained')
check(all(r$summary$inventory_points==c(26318,16992))&&sum(e$eligible)==220,'Frozen category/completion accounting')
check(all(p$disposition%in%linkage_dispositions)&&sum(table(p$disposition))==43310,'Exhaustive exclusive dispositions')
check(!any(p$valid_pair&(!p$eligible|!p$qa_validated|!p$observed_link_ok)),'QA, completion and linkage admission')
check(all(p$disposition[!p$eligible]=='COMPLETION_EXCLUDED')&&all(!p$valid_pair[!p$eligible]),'Completion exclusions dominate')
# Reconstruct pair membership from the independent frozen parser action ledger.
ap<-paste(a$match_id,a$Pt,sep='|');ret<-a[a$domain=='Return'&a$kind=='STROKE',];ret<-ret[order(ret$action_index),];ret<-ret[!duplicated(paste(ret$match_id,ret$Pt,sep='|')),]
serve<-a[a$domain=='Serve'&a$kind=='SERVE',];serve<-serve[order(serve$action_index),];serve<-serve[!duplicated(paste(serve$match_id,serve$Pt,sep='|')),]
ri<-match(p$point_id,paste(ret$match_id,ret$Pt,sep='|'));si<-match(p$point_id,paste(serve$match_id,serve$Pt,sep='|'))
err<-!is.na(ri)&ret$terminal[ri]%in%c('FORCED_ERROR','UNFORCED_ERROR')
expected<-p$eligible&p$qa_validated&!is.na(ri)&!err&!is.na(si)&ret$serve_number[ri]%in%c(1,2)&linkage_text(serve$direction[si])%in%c('4','5','6')&serve$direction_status[si]=='RECORDED'&linkage_text(ret$return_depth[ri])%in%c('7','8','9')&ret$depth_status[ri]=='RECORDED'
expected[is.na(expected)]<-FALSE
check(identical(p$valid_pair,expected),'Independent raw-action pair membership')
j<-which(p$valid_pair)
check(all(p$serve_action_id[j]==serve$action_id[si[j]])&&all(p$return_action_id[j]==ret$action_id[ri[j]]),'Independent original action IDs')
check(all(ret$actor[ri[j]]==ret$receiver[ri[j]])&&all(serve$actor[si[j]]==serve$server[si[j]])&&all(ret$server[ri[j]]==serve$server[si[j]]),'Exact receiver/server ownership')
check(all(ret$in_play_shot[ri[j]]==2&serve$in_play_shot[si[j]]==1)&&all(ret$action_index[ri[j]]>serve$action_index[si[j]]),'First physical response, no later Rally substitution')
check(all(p$serve_direction[j]==linkage_text(serve$direction[si[j]]))&&all(p$return_depth[j]==linkage_text(ret$return_depth[ri[j]])),'Literal attributes independently reconstructed')
check(all(p$serve_raw_token[j]==serve$raw_token[si[j]])&&all(p$return_raw_token[j]==ret$raw_token[ri[j]])&&all(p$serve_char_start[j]==serve$char_start[si[j]])&&all(p$return_char_end[j]==ret$char_end[ri[j]]),'Raw notation/spans retained')
check(all(p$context[j]==ifelse(ret$serve_number[ri[j]]==1,'FIRST','SECOND')),'Recorded serve-number context')
check(all(p$plus1_disposition[p$return_winner_pair]=='KNOWN_ABSENT')&&sum(p$return_winner_pair)>0,'Return winners retained with known absent +1')
check(!any(p$valid_pair&p$return_error_observed)&&all(p$disposition[p$eligible&p$qa_validated&p$return_error_observed]=='RETURN_ERROR'),'Return errors separate and Return-owned')
check(!any(p$valid_pair&p$structural_absence)&&all(p$disposition[p$eligible&p$structural_absence]=='STRUCTURAL_ABSENCE'),'Structural absence not a pair')
check(!any(p$valid_pair&p$unknown_response_observation)&&all(p$disposition[p$eligible&p$unknown_response_observation]=='UNKNOWN_RESPONSE_OBSERVATION'),'Unknown response never invented absence')
# Independent keyed counts: no denominator can include withheld candidates.
k<-function(z)paste(z$match_id,z$server_slot,z$context,z$serve_direction,z$return_depth,sep='|')
counts<-table(k(p[p$valid_pair,]));ix<-match(k(g),names(counts));want<-as.integer(counts[ix]);want[is.na(want)]<-0L
check(identical(g$numerator,want)&&sum(g$numerator)==sum(p$valid_pair),'Independent complete depth count grid')
for(f in c('inventory_observed_candidates','eligible_observed_candidates','qa_valid_eligible_candidates')){
 mask<-p$observed_pair_candidate&p$serve_direction_status=='RECORDED'&p$return_depth_status=='RECORDED'
 if(f!='inventory_observed_candidates')mask<-mask&p$eligible
 if(f=='qa_valid_eligible_candidates')mask<-mask&p$qa_validated
 counts<-table(k(p[mask,]));ix<-match(k(g),names(counts));want<-as.integer(counts[ix]);want[is.na(want)]<-0L
 check(identical(g[[f]],want),paste('Dimension-specific observed candidate denominator',f))
}
check(same(g$candidate_retention_eligible,linkage_ratio(g$numerator,g$eligible_observed_candidates))&&all(g$withheld_eligible_candidates==g$eligible_observed_candidates-g$qa_valid_eligible_candidates),'Depth-cell retention is distinct from profile proportions')
for(t in unique(paste(g$match_id,g$server_slot,g$context,g$serve_direction,sep='|'))){z<-g[paste(g$match_id,g$server_slot,g$context,g$serve_direction,sep='|')==t,];check(all(z$denominator==sum(z$numerator))&&same(z$rate,if(sum(z$numerator)>0)z$numerator/sum(z$numerator) else rep(NA_real_,3)),'Compatible denominator and undefined empty rates')}
for(row in seq_len(nrow(c))){z<-c[row,];q<-p[p$match_id==z$match_id&p$server_slot==z$server_slot&p$context==z$context,];ds<-vapply(c('4','5','6'),function(d)sum(q$valid_pair&q$serve_direction==d),0L)
 check(z$inventory_points==nrow(q)&&z$valid_pairs==sum(q$valid_pair)&&all(as.numeric(z[,paste0('direction_',c('4','5','6'))])==ds),'Independent context exposure')
 for(d in c('4','5','6')){observed<-q$eligible&q$observed_pair_candidate&q$serve_direction_status=='RECORDED'&q$serve_direction==d
 check(z[[paste0('observed_direction_',d,'_candidates')]]==sum(observed)&&z[[paste0('qa_direction_',d,'_candidates')]]==sum(observed&q$qa_validated)&&same(z[[paste0('direction_',d,'_retention_observed')]],linkage_ratio(sum(q$valid_pair&q$serve_direction==d),sum(observed))),'Direction-specific retention includes missing/withheld depth')}
 check(z$multiple_directions==(sum(ds>0)>=2)&&z$single_pair_direction_cells==sum(ds==1)&&z$empty_direction_cells==sum(ds==0),'Algebraic multi-direction and sparse cells')
}
for(row in seq_len(nrow(rp))){z<-rp[row,];q<-c[c$tour==z$tour&c$server_player==z$server_player&c$receiver_player==z$receiver_player&c$context==z$context,];use<-q[q$valid_pairs>0,]
 check(z$inventory_matches==nrow(q)&&z$pair_supported_matches==nrow(use)&&z$valid_pairs==sum(use$valid_pairs),'Exact ordered-pair cross-match support')
 n<-if(nrow(use))sum(vapply(use$source_date,function(d)any(use$source_date<d),TRUE)) else 0
 check(z$targets_with_strictly_earlier_pair_support==n&&z$pair_supported_batches==length(unique(use$source_date)),'Strictly earlier repeated-pair dates; no same-date support')
}
for(row in seq_len(nrow(r[['coverage-summary']]))){z<-r[['coverage-summary']][row,];q<-if(z$level=='MATCH')p[p$match_id==z$match_id,] else if(z$level=='CATEGORY')p[p$tour==z$tour,] else p[p$tour==z$tour&p$context==z$context,]
 check(z$inventory_points==nrow(q)&&z$valid_pairs==sum(q$valid_pair)&&all(as.numeric(z[,linkage_dispositions])==vapply(linkage_dispositions,function(d)sum(q$disposition==d),0L)),'Every coverage denominator/disposition')
 check(sum(as.numeric(z[,linkage_dispositions]))==z$inventory_points&&same(z$retention_qa_candidates,linkage_ratio(sum(q$valid_pair),sum(q$eligible&q$qa_validated&q$observed_pair_candidate))),'Coverage partition and named retention')
}
# Focused missingness fixtures reuse a real pair, maintaining parser/state agreement.
target<-p[p$valid_pair,][1,];sk<-which(i$states$action_id==target$serve_action_id);rk<-which(i$states$action_id==target$return_action_id);ak<-match(i$states$action_id[c(sk,rk)],i$actions$action_id)
for(type in c('OMITTED','UNKNOWN','UNSUPPORTED')){
 q<-i
 if(type=='OMITTED'){q$states$post_return_depth[rk]<-NA;q$states$post_depth_status[rk]<-'NOT_RECORDED';q$actions$return_depth[ak[2]]<-NA;q$actions$depth_status[ak[2]]<-'NOT_RECORDED'}
 if(type=='UNKNOWN'){q$states$post_return_depth[rk]<-0;q$states$post_depth_status[rk]<-'SOURCE_UNKNOWN';q$actions$return_depth[ak[2]]<-0;q$actions$depth_status[ak[2]]<-'SOURCE_UNKNOWN'}
 if(type=='UNSUPPORTED'){q$states$post_return_depth[rk]<-4;q$states$post_depth_status[rk]<-'RECORDED';q$actions$return_depth[ak[2]]<-4;q$actions$depth_status[ak[2]]<-'RECORDED'}
 alt<-linkage_points(q);z<-alt[alt$point_id==target$point_id,]
 check(z$disposition==paste0(type,'_ATTRIBUTES')&&!z$valid_pair,paste('Explicit depth fixture',type))
}
q<-i;q$states$post_direction[sk]<-0;q$states$post_direction_status[sk]<-'SOURCE_UNKNOWN';q$actions$direction[ak[1]]<-0;q$actions$direction_status[ak[1]]<-'SOURCE_UNKNOWN';alt<-linkage_points(q)
check(alt$disposition[alt$point_id==target$point_id]=='UNKNOWN_ATTRIBUTES','Unknown delivery direction not inferred')
q<-i;q$states$post_return_depth[rk]<-4;check(fails(linkage_points(q)),'State/parser attribute mismatch stops')
q<-i;q$states$incoming_source_action_id[rk]<-q$states$action_id[rk];check(fails(linkage_points(q)),'Wrong incoming action stops')
q<-i;q$states$actor_name[rk]<-'NOT_THE_RECEIVER';check(fails(linkage_points(q)),'Wrong receiver identity stops')
q<-i;q$points<-rbind(q$points,q$points[1,]);check(fails(linkage_points(q)),'Duplicate point stops')
# Unsupported later suffixes retain the complete point withholding gate.
check(all(!p$valid_pair[p$withheld_point_qa])&&any(p$observed_pair_candidate&p$withheld_point_qa),'No supported-prefix QA promotion')
# Permutations preserve every output byte; semantic neutral-slot relabeling preserves identities.
set.seed(2109);q<-i
for(f in c('eligibility','states','actions','plus','points'))q[[f]]<-q[[f]][sample(nrow(q[[f]])),]
rr<-build_mcp_serve_return_depth_linkage(q)
for(f in names(r)){x<-tempfile();y<-tempfile();mcp_write(r[[f]],x);mcp_write(rr[[f]],y);check(mcp_sha(x)==mcp_sha(y),paste('Permutation byte invariance',f));unlink(c(x,y))}
q<-i;q$eligibility$player_a<-i$eligibility$player_b;q$eligibility$player_b<-i$eligibility$player_a
flip<-function(x)ifelse(x=='A','B',ifelse(x=='B','A',x))
q$states$actor_neutral_slot<-flip(q$states$actor_neutral_slot);q$actions$actor_neutral_slot<-flip(q$actions$actor_neutral_slot)
alt<-linkage_points(q);check(identical(p$point_id,alt$point_id)&&identical(p$server_player,alt$server_player)&&identical(p$receiver_player,alt$receiver_player)&&identical(p$valid_pair,alt$valid_pair)&&all(alt$server_slot==flip(p$server_slot)),'Neutral slot swap preserves real player ownership')
# Outcome labels do not choose pairs or support; frozen QA flags remain authority.
q<-i;q$points$recorded_winner<-rev(q$points$recorded_winner);q$points$inferred_winner<-rev(q$points$inferred_winner)
alt<-linkage_points(q);check(identical(p$valid_pair,alt$valid_pair)&&identical(p$disposition,alt$disposition)&&identical(p$server_player,alt$server_player),'No winner-label-based sample or linkage selection')
fixture<-c[rep(1,3),];fixture$source_date<-c('2000-01-01','2000-01-01','2000-01-02');fixture$valid_pairs<-c(1,1,1);fixture$eligible<-TRUE;fixture$multiple_directions<-FALSE
rrp<-linkage_repeated(fixture);check(rrp$targets_with_strictly_earlier_pair_support==1&&rrp$pair_supported_batches==2,'Same-date recurrence cannot supply earlier support')
fixture<-fixture[1:2,];rrp<-linkage_repeated(fixture);check(rrp$same_date_only_recurrence&&rrp$targets_with_strictly_earlier_pair_support==0,'Explicit same-date-only repeated pair')
# Historical source verification, prospective tampering and atomic installation failures.
saved<-linkage_definition_pin;linkage_definition_pin<-'BAD';check(fails(linkage_verify()),'Changed prospective specification stops');linkage_definition_pin<-saved
saved<-linkage_decision_pin;linkage_decision_pin<-'BAD';check(fails(linkage_verify()),'Changed construct authority stops');linkage_decision_pin<-saved
for(f in names(r))check(all(r[[f]]$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED')&&all(r[[f]]$claim=='OBSERVED_RESPONSE_LINKAGE_SUPPORT_NOT_ADVANTAGE_OR_FACTOR'),'Boundary labels')
linkage_install(r);paths<-paste0(linkage_prefix,names(r),'.csv');pins<-setNames(vapply(paths,mcp_sha,'',USE.NAMES=FALSE),names(r))
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'All six outputs ignored')
rr<-build_mcp_serve_return_depth_linkage(linkage_load())
for(f in names(rr)){x<-tempfile();mcp_write(rr[[f]],x);check(mcp_sha(x)==pins[[f]],paste('Independent deterministic rerun',f));unlink(x)}
linkage_install(rr);check(identical(unname(pins),vapply(paths,mcp_sha,'',USE.NAMES=FALSE)),'Idempotent installation')
bad<-r;bad[['point-linkage']]$serve_direction[1]<-'DO_NOT_INSTALL';check(fails(linkage_install(bad)),'Refuse differing installed release');check(identical(unname(pins),vapply(paths,mcp_sha,'',USE.NAMES=FALSE)),'Rejected install preserves bundle')
saved_prefix<-linkage_prefix;linkage_prefix<-paste0(tempfile('.mcp-linkage-fixture-',tmpdir='data/pilot/'),'-');calls<-0L
rename_fail<-function(from,to){calls<<-calls+1L;if(calls==2)FALSE else file.rename(from,to)}
check(fails(linkage_install(r,rename_fail)),'Mid-install failure')
check(!any(file.exists(paste0(linkage_prefix,names(r),'.csv'))),'Rollback newly created files only');linkage_prefix<-saved_prefix
check(all(r$summary$decision==if(all(r$summary$multiple_directions>0))'BOUNDED_RESPONSE_PROFILE_EXPERIMENT_SUPPORTED' else 'STOP_RESPONSE_PROFILE_HYPOTHESIS_FOR_MISSING_SUPPORT'),'Structural support decision, no adequacy threshold')
cat('PASS:',checks,'focused linkage checks.\n')
print(r$summary[,c('tour','valid_pairs','multiple_directions','repeated_pair_contexts','decision')],row.names=FALSE)
