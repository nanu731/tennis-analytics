# MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0: observed linkage/support only.
source('R/build_mcp_serve_plus1_protocol.R')
linkage_prefix <- 'data/pilot/mcp-serve-return-depth-v1-'
linkage_outputs <- c('point-linkage','depth-cells','context-support','repeated-pair-support','coverage-summary','summary')
linkage_definition_pin <- '53582fe2508e84f53126cab608b95e12394f99ae397d592bd617efc7944aa52c'
linkage_decision_pin <- 'c25a4fd06913b46d0058afcc086700aca5cea16bc36e223a358141cd1e0e8210'
linkage_dispositions <- c('COMPLETION_EXCLUDED','WITHHELD_AUTHORITY_CONFLICT','WITHHELD_UNSUPPORTED_NOTATION','WITHHELD_POINT_QA','UNKNOWN_RESPONSE_OBSERVATION','STRUCTURAL_ABSENCE','RETURN_ERROR','UNSUPPORTED_ATTRIBUTES','UNKNOWN_ATTRIBUTES','OMITTED_ATTRIBUTES','VALID_PAIR')
linkage_text <- function(x){x<-as.character(x);x[is.na(x)]<-'';x}
linkage_ratio <- function(n,d)ifelse(d>0,n/d,NA_real_)
linkage_context <- function(x)ifelse(is.na(x),'UNKNOWN',ifelse(x==1,'FIRST',ifelse(x==2,'SECOND','UNSUPPORTED')))
linkage_verify <- function() {
 plus_protocol_verify() # Reuses saved rights, revision, raw bytes and QA pins.
 mcp_need(mcp_sha('docs/serve-creation-construct-decision.md')==linkage_decision_pin,'Construct authority changed')
 text<-readLines('docs/mcp-serve-return-depth-linkage-audit.md',warn=FALSE)
 k<-match('## Measured support and decision',text);mcp_need(!is.na(k),'Prospective boundary absent')
 text<-head(text,k-1L);while(length(text)&&tail(text,1)=='')text<-head(text,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(text,f)
 mcp_need(mcp_sha(f)==linkage_definition_pin,'Prospective linkage specification changed')
 workbook<-'data/raw/reference/mcp-stage1-MatchChart_0.3.2.xlsm'
 mcp_need(mcp_sha(workbook)=='46e2349eee512296a86170449f6e463a6be91be9261a0c7b6b5d5a25c006729f','Notation workbook changed')
 ss<-xml2::read_xml(unz(workbook,'xl/sharedStrings.xml'))
 texts<-vapply(xml2::xml_find_all(ss,'//*[local-name()="si"]'),function(z)paste(xml2::xml_text(xml2::xml_find_all(z,'.//*[local-name()="t"]')),collapse=''),'')
 mcp_need(any(grepl('4 = out wide, 5 = body, and 6 = down the T',texts,fixed=TRUE))&&any(grepl('7 = within the service boxes. 8 = behind the service line',texts,fixed=TRUE))&&any(grepl('9 = closer to the baseline than the service line',texts,fixed=TRUE)),'Pinned attribute definitions absent')
 invisible(TRUE)
}
linkage_load <- function(){linkage_verify();i<-plus_protocol_load();plus_protocol_check(i);i}
linkage_points <- function(i) {
 e<-i$eligibility;s<-i$states;a<-i$actions;p<-i$points;b<-i$plus
 p$point_id<-paste(p$match_id,p$Pt,sep='|');mi<-match(p$match_id,e$match_id)
 mcp_need(!anyDuplicated(p$point_id)&&!anyDuplicated(s$action_id)&&!anyDuplicated(a$action_id)&&!anyNA(mi),'Unique point/action/match identity')
 sj<-match(s$action_id,a$action_id);pi<-match(s$point_id,p$point_id)
 mcp_need(!anyNA(sj)&&!anyNA(pi)&&setequal(s$action_id,a$action_id),'Exact state/action/point linkage')
 for(pair in list(c('post_kind','kind'),c('owner_domain','domain'),c('post_direction','direction'),c('post_direction_status','direction_status'),c('post_return_depth','return_depth'),c('post_depth_status','depth_status')))
  mcp_need(identical(linkage_text(s[[pair[1]]]),linkage_text(a[[pair[2]]][sj])),paste('Attribute authority conflict:',pair[1]))
 mcp_need(all(s$point_validated==p$tennis_sequence_validated[pi])&&all(s$score_reconciliation_status==p$score_status[pi]),'Frozen point/state QA conflict')
 mcp_need(!anyDuplicated(paste(s$point_id,s$action_index)),'Duplicate action ordinal')
 s<-s[order(s$match_id,s$Pt,s$action_index,method='radix'),];a<-a[match(s$action_id,a$action_id),]
 # Neutral player identity is frozen in the source-to-slot mapping, not winner order.
 ids<-unique(s[s$owner_domain=='Serve',c('match_id','server','actor_neutral_slot')])
 key<-paste(ids$match_id,ids$server,sep='|');j<-match(paste(p$match_id,p$server,sep='|'),key)
 mcp_need(!anyDuplicated(key)&&!anyNA(j)&&all(ids$actor_neutral_slot%in%c('A','B')),'Unambiguous source-server identity')
 p$server_slot<-ids$actor_neutral_slot[j];p$receiver_slot<-ifelse(p$server_slot=='A','B','A')
 p$server_player<-ifelse(p$server_slot=='A',e$player_a[mi],e$player_b[mi]);p$receiver_player<-ifelse(p$server_slot=='A',e$player_b[mi],e$player_a[mi])
 p$tour<-e$tour_file[mi];p$source_date<-e$source_date[mi];p$event<-e$event_label[mi];p$eligible<-e$eligible[mi];p$completion_exclusion<-e$exclusion_reasons[mi]
 ri<-which(s$owner_domain=='Return'&s$post_kind=='STROKE');si<-which(s$owner_domain=='Serve'&s$post_kind=='SERVE')
 # Earliest observed Return, never a later Rally action; unresolved duplicates stay withheld.
 ri<-ri[!duplicated(s$point_id[ri])];si<-si[!duplicated(s$point_id[si])]
 r<-ri[match(p$point_id,s$point_id[ri])];v<-si[match(p$point_id,s$point_id[si])]
 incoming<-match(s$incoming_source_action_id[r],s$action_id)
 v[!is.na(incoming)]<-incoming[!is.na(incoming)]
 has_return<-!is.na(r);has_serve<-!is.na(v)
 physical_serve<-which(s$owner_domain=='Serve'&s$post_kind%in%c('SERVE','SERVE_FAULT'))
 last<-physical_serve[!duplicated(s$point_id[physical_serve],fromLast=TRUE)]
 number_source<-v;number_source[!has_serve]<-last[match(p$point_id[!has_serve],s$point_id[last])]
 p$serve_number<-s$post_serve_number[number_source];p$serve_number_action_id<-linkage_text(s$action_id[number_source]);p$context<-linkage_context(p$serve_number)
 p$serve_action_id<-linkage_text(s$action_id[v]);p$return_action_id<-linkage_text(s$action_id[r])
 for(side in c('serve','return')){
  k<-if(side=='serve')v else r
  for(f in c('raw_token','sequence_field','char_start','char_end'))p[[paste(side,f,sep='_')]]<-s[[f]][k]
 }
 p$serve_direction<-linkage_text(s$post_direction[v]);p$serve_direction_status<-ifelse(has_serve,s$post_direction_status[v],'NOT_APPLICABLE')
 p$return_depth<-linkage_text(s$post_return_depth[r]);p$return_depth_status<-ifelse(has_return,s$post_depth_status[r],'NOT_APPLICABLE')
 p$return_terminal<-linkage_text(s$post_terminal_status[r]);p$return_error_observed<-has_return&p$return_terminal%in%c('FORCED_ERROR','UNFORCED_ERROR')
 p$observed_pair_candidate<-has_return&!p$return_error_observed
 p$qa_validated<-p$tennis_sequence_validated&p$score_status=='PASS'
 mcp_need(all(p$terminal_agrees[p$qa_validated]),'Validated terminal conflict')
 p$withheld_point_qa<-!p$qa_validated
 flags<-function(mask)tabulate(match(s$point_id[mask],p$point_id),nrow(p))>0
 p$authority_conflict<-flags(s$authority_conflict)|p$parse_status=='TERMINAL_OUTCOME_CONFLICT'
 p$unsupported_notation<-flags(s$unsupported_observation)|p$parse_status=='UNSUPPORTED_OR_UNRESOLVED'
 p$missing_observation<-flags(s$missing_observation)
 p$observed_link_ok<-FALSE
 k<-which(has_return&has_serve)
 p$observed_link_ok[k]<-s$post_kind[v[k]]=='SERVE'&s$owner_domain[v[k]]=='Serve'&s$owner_role[v[k]]=='SERVER'&s$actor_name[v[k]]==p$server_player[k]&s$actor_name[r[k]]==p$receiver_player[k]&s$owner_role[r[k]]=='RECEIVER'&s$point_id[v[k]]==p$point_id[k]&s$action_id[v[k]]==s$incoming_source_action_id[r[k]]&s$action_index[v[k]]<s$action_index[r[k]]&s$pre_in_play_strokes[r[k]]==1&s$pre_incoming_domain[r[k]]=='Serve'&s$tennis_action_usable[v[k]]&s$tennis_action_usable[r[k]]&s$post_serve_number[v[k]]==s$pre_serve_number[r[k]]&s$post_serve_number[v[k]]==s$post_serve_number[r[k]]
 # A validated observed Return must reconcile; no invented alternative linkage.
 mcp_need(all(p$observed_link_ok[p$qa_validated&has_return]),'Validated Return boundary/player linkage failed')
 valid_ids<-p$point_id[p$qa_validated]
 mcp_need(!anyDuplicated(s$point_id[s$point_id%in%valid_ids&s$owner_domain=='Return'&s$post_kind=='STROKE'])&&!anyDuplicated(s$point_id[s$point_id%in%valid_ids&s$owner_domain=='Serve'&s$post_kind=='SERVE']),'Duplicate validated pair member')
 p$structural_absence<-p$qa_validated&!has_return&p$return_observation=='KNOWN_ABSENT'
 p$unknown_response_observation<-p$qa_validated&!has_return&!p$structural_absence
 candidate<-p$observed_pair_candidate
 p$omitted_attributes<-candidate&(p$serve_direction_status=='NOT_RECORDED'|p$return_depth_status=='NOT_RECORDED')
 p$unknown_attributes<-candidate&(p$serve_direction=='0'|p$return_depth=='0'|grepl('UNKNOWN',p$serve_direction_status)|grepl('UNKNOWN',p$return_depth_status)|p$context=='UNKNOWN')
 p$unsupported_attributes<-candidate&((p$serve_direction_status=='RECORDED'&!p$serve_direction%in%c('4','5','6'))|(p$return_depth_status=='RECORDED'&!p$return_depth%in%c('7','8','9'))|p$context=='UNSUPPORTED')
 complete_attributes<-p$context%in%c('FIRST','SECOND')&p$serve_direction_status=='RECORDED'&p$serve_direction%in%c('4','5','6')&p$return_depth_status=='RECORDED'&p$return_depth%in%c('7','8','9')
 p$valid_pair<-p$eligible&p$qa_validated&candidate&p$observed_link_ok&complete_attributes
 p$disposition<-ifelse(!p$eligible,'COMPLETION_EXCLUDED',ifelse(!p$qa_validated,ifelse(p$authority_conflict,'WITHHELD_AUTHORITY_CONFLICT',ifelse(p$unsupported_notation,'WITHHELD_UNSUPPORTED_NOTATION','WITHHELD_POINT_QA')),ifelse(p$unknown_response_observation,'UNKNOWN_RESPONSE_OBSERVATION',ifelse(p$structural_absence,'STRUCTURAL_ABSENCE',ifelse(p$return_error_observed,'RETURN_ERROR',ifelse(p$unsupported_attributes,'UNSUPPORTED_ATTRIBUTES',ifelse(p$unknown_attributes,'UNKNOWN_ATTRIBUTES',ifelse(p$omitted_attributes,'OMITTED_ATTRIBUTES','VALID_PAIR'))))))))
 mcp_need(all((p$disposition=='VALID_PAIR')==p$valid_pair),'Exhaustive point dispositions')
 bj<-match(p$point_id,b$point_id);mcp_need(!anyNA(bj),'Missing frozen +1 ledger row')
 p$plus1_disposition<-b$disposition[bj];p$plus1_action_id<-b$plus1_action_id[bj]
 p$return_winner_pair<-p$valid_pair&p$return_terminal=='WINNER'
 mcp_need(all(p$plus1_disposition[p$return_winner_pair]=='KNOWN_ABSENT'),'Return winner +1 absence conflict')
 p$withheld_reasons<-paste(p$issues,p$score_reasons,sep='|')
 p<-p[order(p$tour,p$source_date,p$match_id,p$Pt,method='radix'),];rownames(p)<-NULL;p
}
linkage_cells <- function(p,e) {
 g<-expand.grid(match_id=e$match_id,server_slot=c('A','B'),context=c('FIRST','SECOND'),serve_direction=c('4','5','6'),return_depth=c('7','8','9'),stringsAsFactors=FALSE)
 j<-match(g$match_id,e$match_id);g$tour<-e$tour_file[j];g$source_date<-e$source_date[j];g$server_player<-ifelse(g$server_slot=='A',e$player_a[j],e$player_b[j]);g$receiver_player<-ifelse(g$server_slot=='A',e$player_b[j],e$player_a[j]);g$eligible<-e$eligible[j];g$completion_exclusion<-e$exclusion_reasons[j]
 key<-function(z)paste(z$match_id,z$server_slot,z$context,z$serve_direction,z$return_depth,sep='|')
 z<-p[p$valid_pair,];ix<-match(key(z),key(g));mcp_need(!anyNA(ix),'Unlinked depth cell')
 g$numerator<-tabulate(ix,nrow(g));g$return_winners<-tabulate(ix[z$return_winner_pair],nrow(g))
 all_ix<-match(key(p),key(g));observed<-p$observed_pair_candidate&p$serve_direction_status=='RECORDED'&p$return_depth_status=='RECORDED'
 g$inventory_observed_candidates<-tabulate(all_ix[observed],nrow(g));g$eligible_observed_candidates<-tabulate(all_ix[observed&p$eligible],nrow(g))
 g$qa_valid_eligible_candidates<-tabulate(all_ix[observed&p$eligible&p$qa_validated],nrow(g));g$withheld_eligible_candidates<-g$eligible_observed_candidates-g$qa_valid_eligible_candidates
 g$candidate_retention_eligible<-linkage_ratio(g$numerator,g$eligible_observed_candidates)
 dk<-paste(g$match_id,g$server_slot,g$context,g$serve_direction,sep='|');g$denominator<-as.numeric(tapply(g$numerator,dk,sum)[dk]);g$rate<-linkage_ratio(g$numerator,g$denominator)
 g$cell_disposition<-ifelse(!g$eligible,'COMPLETION_EXCLUDED',ifelse(g$denominator==0,'EMPTY_DIRECTION',ifelse(g$numerator==0,'ZERO_OBSERVED_DEPTH_COUNT','OBSERVED_DEPTH_COUNT')))
 g[order(g$tour,g$source_date,g$match_id,g$server_slot,g$context,g$serve_direction,g$return_depth,method='radix'),]
}
linkage_context_support <- function(p,e,cells) {
 g<-expand.grid(match_id=e$match_id,server_slot=c('A','B'),context=c('FIRST','SECOND'),stringsAsFactors=FALSE)
 j<-match(g$match_id,e$match_id);g$tour<-e$tour_file[j];g$source_date<-e$source_date[j];g$server_player<-ifelse(g$server_slot=='A',e$player_a[j],e$player_b[j]);g$receiver_player<-ifelse(g$server_slot=='A',e$player_b[j],e$player_a[j]);g$eligible<-e$eligible[j];g$completion_exclusion<-e$exclusion_reasons[j]
 key<-function(z)paste(z$match_id,z$server_slot,z$context,sep='|');ix<-match(key(p),key(g))
 for(f in c('inventory_points','valid_pairs','observed_pair_candidates','omitted_attributes','unknown_attributes','unsupported_attributes','withheld_point_qa','authority_conflict','unsupported_notation','return_error_observed','structural_absence'))g[[f]]<-tabulate(ix[if(f=='inventory_points')rep(TRUE,nrow(p)) else p[[if(f=='valid_pairs')'valid_pair' else f]]],nrow(g))
 for(d in c('4','5','6')){
  g[[paste0('direction_',d)]]<-tabulate(ix[p$valid_pair&p$serve_direction==d],nrow(g))
  observed<-p$eligible&p$observed_pair_candidate&p$serve_direction_status=='RECORDED'&p$serve_direction==d
  g[[paste0('observed_direction_',d,'_candidates')]]<-tabulate(ix[observed],nrow(g));g[[paste0('qa_direction_',d,'_candidates')]]<-tabulate(ix[observed&p$qa_validated],nrow(g))
  g[[paste0('direction_',d,'_retention_observed')]]<-linkage_ratio(g[[paste0('direction_',d)]],g[[paste0('observed_direction_',d,'_candidates')]])
  g[[paste0('direction_',d,'_retention_qa')]]<-linkage_ratio(g[[paste0('direction_',d)]],g[[paste0('qa_direction_',d,'_candidates')]])
 }
 ds<-as.matrix(g[,paste0('direction_',c('4','5','6'))]);g$directions_observed<-rowSums(ds>0);g$single_pair_direction_cells<-rowSums(ds==1);g$empty_direction_cells<-rowSums(ds==0)
 g$multiple_directions<-g$directions_observed>=2;g$retention_inventory<-linkage_ratio(g$valid_pairs,g$inventory_points)
 g$support_disposition<-ifelse(!g$eligible,'COMPLETION_EXCLUDED',ifelse(g$valid_pairs==0,'EMPTY_CONTEXT',ifelse(g$multiple_directions,'MULTIPLE_DIRECTIONS_OBSERVED','ONE_DIRECTION_ONLY')))
 g[order(g$tour,g$source_date,g$match_id,g$server_slot,g$context,method='radix'),]
}
linkage_repeated <- function(c) {
 key<-paste(c$tour,c$server_player,c$receiver_player,c$context,sep='|');rows<-list()
 for(k in sort(unique(key),method='radix')){
  z<-c[key==k,];use<-z[z$valid_pairs>0,];eligible<-z[z$eligible,]
  rows[[length(rows)+1L]]<-data.frame(tour=z$tour[1],server_player=z$server_player[1],receiver_player=z$receiver_player[1],context=z$context[1],inventory_matches=nrow(z),eligible_matches=nrow(eligible),pair_supported_matches=nrow(use),pair_supported_batches=length(unique(use$source_date)),valid_pairs=sum(z$valid_pairs),multiple_direction_matches=sum(z$multiple_directions),repeated_across_matches=nrow(use)>=2,repeated_across_batches=length(unique(use$source_date))>=2,targets_with_strictly_earlier_pair_support=if(nrow(use))sum(vapply(use$source_date,function(d)any(use$source_date<d),TRUE)) else 0L,same_date_only_recurrence=nrow(use)>=2&&length(unique(use$source_date))==1,stringsAsFactors=FALSE)
 }
 do.call(rbind,rows)
}
linkage_coverage <- function(p,e) {
 rows<-list();units<-c(paste0('MATCH|',e$match_id),paste0('CATEGORY|',c('ATP','WTA')),paste0('CATEGORY_CONTEXT|',rep(c('ATP','WTA'),each=4),'|',rep(c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),2)))
 for(unit in units){v<-strsplit(unit,'|',fixed=TRUE)[[1]];z<-if(v[1]=='MATCH')p[p$match_id==v[2],] else if(v[1]=='CATEGORY')p[p$tour==v[2],] else p[p$tour==v[2]&p$context==v[3],]
  tour<-if(v[1]=='MATCH')e$tour_file[match(v[2],e$match_id)] else v[2]
  row<-data.frame(level=v[1],tour,match_id=if(v[1]=='MATCH')v[2] else '',context=if(length(v)==3)v[3] else 'ALL',inventory_points=nrow(z),eligible_points=sum(z$eligible),qa_valid_eligible_points=sum(z$eligible&z$qa_validated),eligible_pair_candidates=sum(z$eligible&z$observed_pair_candidate),qa_valid_eligible_pair_candidates=sum(z$eligible&z$qa_validated&z$observed_pair_candidate),valid_pairs=sum(z$valid_pair),return_winner_pairs=sum(z$return_winner_pair),valid_pairs_with_known_absent_plus1=sum(z$valid_pair&z$plus1_disposition=='KNOWN_ABSENT'),stringsAsFactors=FALSE)
  for(f in c('authority_conflict','unsupported_notation','missing_observation','withheld_point_qa','omitted_attributes','unknown_attributes','unsupported_attributes'))row[[paste0('flag_',f)]]<-sum(z[[f]])
  for(d in linkage_dispositions)row[[d]]<-sum(z$disposition==d)
  row$retention_inventory<-linkage_ratio(row$valid_pairs,row$inventory_points);row$retention_eligible_points<-linkage_ratio(row$valid_pairs,row$eligible_points);row$retention_eligible_candidates<-linkage_ratio(row$valid_pairs,row$eligible_pair_candidates);row$retention_qa_candidates<-linkage_ratio(row$valid_pairs,row$qa_valid_eligible_pair_candidates)
  rows[[length(rows)+1L]]<-row
 };do.call(rbind,rows)
}
build_mcp_serve_return_depth_linkage <- function(i=linkage_load()) {
 p<-linkage_points(i);e<-i$eligibility;e<-e[order(e$tour_file,e$source_date,e$match_id,method='radix'),];rownames(e)<-NULL;cells<-linkage_cells(p,e);c<-linkage_context_support(p,e,cells);rpt<-linkage_repeated(c);cov<-linkage_coverage(p,e)
 summary<-cov[cov$level=='CATEGORY',];summary$inventory_matches<-as.integer(table(factor(e$tour_file,levels=c('ATP','WTA'))));summary$eligible_matches<-as.integer(table(factor(e$tour_file[e$eligible],levels=c('ATP','WTA'))))
 for(tour in c('ATP','WTA')){
  k<-which(summary$tour==tour);z<-c[c$tour==tour,];r<-rpt[rpt$tour==tour,]
  for(f in c('multiple_directions','single_pair_direction_cells','empty_direction_cells'))summary[[f]][k]<-sum(z[[f]])
  summary$pair_supported_contexts[k]<-sum(z$valid_pairs>0);summary$empty_eligible_contexts[k]<-sum(z$eligible&z$valid_pairs==0);summary$one_direction_contexts[k]<-sum(z$eligible&z$directions_observed==1)
  summary$repeated_pair_contexts[k]<-sum(r$repeated_across_matches);summary$repeated_batch_pair_contexts[k]<-sum(r$repeated_across_batches);summary$prior_pair_supported_targets[k]<-sum(r$targets_with_strictly_earlier_pair_support)
 }
 decision<-if(all(summary$multiple_directions>0))'BOUNDED_RESPONSE_PROFILE_EXPERIMENT_SUPPORTED' else 'STOP_RESPONSE_PROFILE_HYPOTHESIS_FOR_MISSING_SUPPORT'
 summary$decision<-decision
 r<-list('point-linkage'=p,'depth-cells'=cells,'context-support'=c,'repeated-pair-support'=rpt,'coverage-summary'=cov,summary=summary)
 for(k in names(r)){r[[k]]$release<-'MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$specification_sha256<-linkage_definition_pin;r[[k]]$claim<-'OBSERVED_RESPONSE_LINKAGE_SUPPORT_NOT_ADVANTAGE_OR_FACTOR';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED';rownames(r[[k]])<-NULL}
 r
}
linkage_install <- function(r,rename=file.rename) {
 mcp_need(identical(names(r),linkage_outputs),'Exact linkage output scope');paths<-paste0(linkage_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Output location must already be ignored')
 stage<-vapply(paths,function(p)tempfile('.mcp-linkage-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(j in seq_along(r))mcp_write(r[[j]],stage[j]);linkage_verify()
 for(j in seq_along(paths))if(file.exists(paths[j]))mcp_need(mcp_sha(paths[j])==mcp_sha(stage[j]),'Refuse differing linkage release')
 created<-character();success<-FALSE;on.exit(if(!success)unlink(created),add=TRUE)
 for(j in seq_along(paths))if(!file.exists(paths[j])){mcp_need(rename(stage[j],paths[j]),'Atomic linkage installation failed');created<-c(created,paths[j])}
 success<-TRUE;invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline linkage audit takes no arguments');r<-build_mcp_serve_return_depth_linkage();linkage_install(r);print(r$summary[,c('tour','inventory_points','valid_pairs','multiple_directions','repeated_pair_contexts','decision')],row.names=FALSE)}
