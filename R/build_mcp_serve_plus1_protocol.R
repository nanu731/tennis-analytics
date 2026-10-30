# Opportunity/denominator audit only; no error numerators, estimates or losses.
source('R/build_mcp_expanded_recurring_sample.R')
plus_protocol_prefix <- 'data/pilot/mcp-serve-plus1-protocol-v1-'
plus_protocol_outputs <- c('point-opportunity-dispositions','context-counts','context-support','match-coverage','summary')
plus_protocol_definition_pin <- 'cb10aafc9cf22c9fd2cc43c469bbb48b37f5dfbcba2b3574d1f47272e89d29a7'
plus_protocol_pins <- c(
 'R/build_mcp_expanded_recurring_sample.R'='bd45c0ae59fb6fbe69615e4d597cf48734e7385cf2841629e1b0f5c448715b56',
 'R/build_mcp_action_states.R'='fc8ac83ed88675267f7bc588626c8e52ed1e7787325a771c5f2560824a514d98',
 'R/audit_mcp_opportunity_context.R'='fc9a9cbaa561130f1f3da1f795f9514f266d4ff713972f4614ad1f0cf207c4b6',
 'R/freeze_mcp_broader_return_protocol.R'='97b8588509e9da65ca99d5a4f1c94579e154d3ccd21da903e2eeb2e341dcaf3b',
 'R/run_mcp_return_transfer.R'='4585e162b044e1a6e3b064fbd455692fa7540f67ec4767ffb68924dad91d5909',
 'docs/mcp-execution-summary-audit.md'='e0f3f2120b69691776983504d044b71974aab472dfb2de6b3543d23416cc6e5b',
 'docs/mcp-broader-return-transfer-protocol.md'='1d98da4b869c1c34f2022c08df99346e6739ce2df02c9477f7a28d61533dd312',
 'data/pilot/mcp-expanded-recurring-v1-action-states.csv'='0929f89c4526e99d11718af44de427b1153f0d48b433be840c7eb02e80d66767',
 'data/pilot/mcp-expanded-recurring-v1-actions.csv'='7e5cb021dceb2d9e5ec5c68c322c892310b8371e168ad390961b81b359d76e82',
 'data/pilot/mcp-expanded-recurring-v1-coverage-summary.csv'='362e2031d594ce2b794e3d766f4cbc08c3d4ce298d36054dc2bc2186bd00ee9f',
 'data/pilot/mcp-expanded-recurring-v1-decoded-examples.csv'='fd540e991300d83d91bb2f5f5c20b2cd185c869064c7c6674f2b153314d2ca84',
 'data/pilot/mcp-expanded-recurring-v1-field-provenance.csv'='b1e6946f0abd5fbcebe30564bc74708b69e4afee1f1889f3c9adf55b6b0e9192',
 'data/pilot/mcp-expanded-recurring-v1-history-support.csv'='8bde4cf8c523b80ab774672aa3e3222bd083f504effdaa19d827215bcf1e0da9',
 'data/pilot/mcp-expanded-recurring-v1-incremental-support.csv'='65cb52dcf2f1dfea70d22d5626b63cc6187eaeec7c7d3b24fbc0415c0e89a33f',
 'data/pilot/mcp-expanded-recurring-v1-match-eligibility.csv'='b03de471ff11dcef11cc0831d26c317795a64fa2446b25d7af4c8fca10039c2b',
 'data/pilot/mcp-expanded-recurring-v1-match-reconciliation.csv'='f24180feb5a44a69d5788c17ed24cd92a29a3278ed03cfb37b50de8cd69e0fc7',
 'data/pilot/mcp-expanded-recurring-v1-opportunity-counts.csv'='98af6e7360a8736528922ec98f2cc236fd3bf7153bfa80c6bd88cafe7aa1e056',
 'data/pilot/mcp-expanded-recurring-v1-parser-summary.csv'='e67f7d78a44ba98987c6156cb5caab70bba4c635b0bdc59f787d737f23882085',
 'data/pilot/mcp-expanded-recurring-v1-player-selection.csv'='b16fecf118ae2632071c96cef810cd5a03a79f9e014a11236fc2a9c81c24257d',
 'data/pilot/mcp-expanded-recurring-v1-player-support.csv'='af8c4db362d73192200a7aa2169a42e498c3d5f5f500df52ac3c36167558a35d',
 'data/pilot/mcp-expanded-recurring-v1-point-reconciliation.csv'='644aa4e87f72030ceb5489579c4219dde762985e64b122a9c59b80485e60be8c',
 'data/pilot/mcp-expanded-recurring-v1-reason-summary.csv'='cee05b11302c43844b49ab074144faf6fc0dae2a8062348b735d80d657070e78',
 'data/pilot/mcp-expanded-recurring-v1-sample.csv'='0e12854b612db6a380cdb10e183d61c8bef5142ad0b64676c3e2ab70d646ec9e',
 'data/pilot/mcp-expanded-recurring-v1-selection-dispositions.csv'='81b65c5a58533d8d3cc748b84cac477f4330ed01dd79c5db78444ea5924afb29',
 'data/pilot/mcp-expanded-recurring-v1-serve-plus1.csv'='a7fee5b7de2cc4a7fa9bfba6fc6a5a1089f71e0edc1b9f1d219b2f675ec8521e',
 'data/pilot/mcp-expanded-recurring-v1-state-coverage.csv'='1257dc9a3d632b4b453ff1afb5a05846cdb54d11a630d3a4655e1dacf15b3621')

plus_protocol_verify <- function() {
 expand_verify() # Saved rights, source revision, provenance and frozen rules.
 for(f in names(plus_protocol_pins))mcp_need(mcp_sha(f)==plus_protocol_pins[[f]],paste('Frozen +1 authority changed:',f))
 lines<-readLines('docs/mcp-serve-plus1-transfer-protocol.md',warn=FALSE)
 cut<-match('## Measured exposure and support',lines);if(!is.na(cut))lines<-head(lines,cut-1L)
 while(length(lines)&&tail(lines,1)=='')lines<-head(lines,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(lines,f)
 mcp_need(mcp_sha(f)==plus_protocol_definition_pin,'Frozen +1 specification changed')
 invisible(TRUE)
}
plus_protocol_load <- function() {
 plus_protocol_verify();read<-function(k)read.csv(paste0(expand_prefix,k,'.csv'),stringsAsFactors=FALSE)
 list(eligibility=read('match-eligibility'),states=read('action-states'),actions=read('actions'),plus=read('serve-plus1'),points=read('point-reconciliation'),opportunities=read('opportunity-counts'),players=read('player-selection'))
}
plus_protocol_check <- function(input) {
 e<-input$eligibility;s<-input$states;a<-input$actions;b<-input$plus;p<-input$points
 mcp_need(nrow(e)==223&&!anyDuplicated(e$match_id)&&sum(e$points)==43310&&all(mcp_date_valid(gsub('-','',e$source_date,fixed=TRUE))),'Frozen inventory/date accounting')
 mcp_need(all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE')&&all(e$eligible%in%c(TRUE,FALSE)),'Frozen completion authority')
 mcp_need(nrow(b)==43310&&!anyDuplicated(b$point_id)&&!anyDuplicated(s$action_id)&&!anyDuplicated(a$action_id)&&setequal(s$action_id,a$action_id)&&setequal(s$point_id,b$point_id)&&setequal(b$match_id,e$match_id),'Unique point/action inventory')
 j<-match(s$action_id,a$action_id);k<-match(s$match_id,e$match_id)
 for(pair in list(c('post_kind','kind'),c('post_serve_number','serve_number'),c('owner_domain','domain'),c('actor_name','actor_name'),c('actor_neutral_slot','actor_neutral_slot'),c('match_id','match_id'),c('raw_token','raw_token'),c('post_terminal_status','terminal'),c('post_explicit_unknowns','unknowns')))
  mcp_need(identical(s[[pair[1]]],a[[pair[2]]][j]),paste('Parser/state authority conflict:',pair[1]))
 mcp_need(identical(s$point_id,paste(a$match_id[j],a$Pt[j],sep='|')),'Derived parser/state point identity')
 mcp_need(all(s$revision==mcp_revision)&all(b$revision==mcp_revision)&all(s$release=='MCP_EXPANDED_RECURRING_1.0.0')&all(b$release=='MCP_EXPANDED_RECURRING_1.0.0'),'Frozen release/provenance')
 mcp_need(all(s$tour_file==e$tour_file[k]),'Category identity conflict')
 physical<-s$post_kind%in%c('SERVE','SERVE_FAULT','STROKE');expected<-ifelse(s$actor_neutral_slot=='A',e$player_a[k],e$player_b[k])
 mcp_need(all(s$actor_neutral_slot[physical]%in%c('A','B'))&&all(s$actor_name[physical]==expected[physical]),'Neutral action ownership')
 mcp_need(all(s$tennis_action_usable==(s$transition_usable&physical&!a$is_void[j])),'Frozen physical usability gate')
 pk<-paste(p$match_id,p$Pt,sep='|');mcp_need(!anyDuplicated(pk)&&setequal(pk,b$point_id),'Frozen point reconciliation identity')
 pi<-match(b$point_id,pk);mi<-match(b$match_id,e$match_id)
 mcp_need(all(b$server==p$server[pi])&&all(b$tour_file==e$tour_file[mi])&&all(b$raw_first==p$raw_first[pi])&&all(b$raw_second==p$raw_second[pi]),'Point server/raw authority')
 mcp_need(all(b$disposition%in%c('VALIDATED_ATTEMPT','KNOWN_ABSENT','UNVALIDATED_OBSERVED_PREFIX','UNKNOWN_OPPORTUNITY'))&&all(b$validated_attempt==(b$disposition=='VALIDATED_ATTEMPT'))&&all(b$observed_prefix==nzchar(b$plus1_action_id))&&all(b$usable_attempt==(b$validated_attempt&b$score_reconciliation_status=='PASS')),'Frozen +1 dispositions and score QA')
 ii<-match(b$plus1_action_id[b$observed_prefix],s$action_id)
 mcp_need(!anyNA(ii)&&!anyDuplicated(ii)&&all(s$post_kind[ii]=='STROKE'&s$owner_domain[ii]=='Rally'&s$owner_role[ii]=='SERVER')&&all(s$point_id[ii]==b$point_id[b$observed_prefix]),'Exact +1 Rally/player/point linkage')
 v<-b$usable_attempt;iv<-match(b$plus1_action_id[v],s$action_id)
 independent<-s$action_id[s$tennis_action_usable&s$owner_domain=='Rally'&s$owner_role=='SERVER'&s$pre_in_play_strokes==2]
 mcp_need(setequal(independent,b$plus1_action_id[v])&&all(s$tennis_action_usable[iv]),'Independent +1 attempt reconciliation')
 mcp_need(all(b$attempted_error[b$validated_attempt]==s$post_terminal_status[match(b$plus1_action_id[b$validated_attempt],s$action_id)]%in%c('FORCED_ERROR','UNFORCED_ERROR'))&&all(is.na(b$attempted_error[!b$validated_attempt])),'Frozen error annotation agreement')
 invisible(TRUE)
}
plus_protocol_context <- function(pre) {
 role<-context_classify(pre,'Rally')$role_phase
 out<-ifelse(pre$pre_serve_number==1,'FIRST',ifelse(pre$pre_serve_number==2,'SECOND','UNKNOWN'));out[is.na(out)]<-'UNKNOWN'
 out[role=='UNKNOWN']<-'UNKNOWN';out[!role%in%c('SERVER_PLUS1','UNKNOWN')]<-'UNSUPPORTED';out
}
plus_protocol_points <- function(input) {
 plus_protocol_check(input);b<-input$plus;s<-input$states;e<-input$eligibility
 # Server-to-neutral mapping is frozen identity evidence, never a winning slot.
 servers<-unique(s[s$owner_domain=='Serve',c('match_id','server','actor_neutral_slot')]);sk<-paste(servers$match_id,servers$server)
 mcp_need(!anyDuplicated(sk)&&all(servers$actor_neutral_slot%in%c('A','B')),'Ambiguous server-to-neutral identity')
 j<-match(paste(b$match_id,b$server),sk);mi<-match(b$match_id,e$match_id);mcp_need(!anyNA(j),'Missing server-to-neutral identity')
 b$slot<-servers$actor_neutral_slot[j];b$player<-ifelse(b$slot=='A',e$player_a[mi],e$player_b[mi]);b$tour<-e$tour_file[mi];b$source_date<-e$source_date[mi];b$eligible<-e$eligible[mi];b$exclusion_reasons<-e$exclusion_reasons[mi]
 b$context<-ifelse(b$disposition=='KNOWN_ABSENT','NOT_APPLICABLE','UNKNOWN');b$context_source_action_id<-'';b$pre_serve_number<-NA_integer_;b$context_reason<-ifelse(b$disposition=='KNOWN_ABSENT','NO_PLUS1_ACTION','NO_OBSERVED_PLUS1_BOUNDARY')
 has<-b$observed_prefix;j<-match(b$plus1_action_id[has],s$action_id);pre<-s[j,context_pre_fields,drop=FALSE]
 b$context[has]<-plus_protocol_context(pre);b$pre_serve_number[has]<-pre$pre_serve_number;b$context_source_action_id[has]<-s$serve_number_source_action_id[j]
 b$context_reason[has]<-ifelse(b$context[has]%in%c('FIRST','SECOND'),'SUPPORTED_PRE_ACTION_CONTEXT',ifelse(b$context[has]=='UNKNOWN','UNKNOWN_PRE_ACTION_CONTEXT','UNSUPPORTED_PRE_ACTION_BOUNDARY'))
 b$binary_label_observed<-FALSE;b$unknown_error_subtype<-FALSE
 b$binary_label_observed[has]<-s$post_terminal_status[j]%in%c('','WINNER','FORCED_ERROR','UNFORCED_ERROR')
 b$unknown_error_subtype[has]<-grepl('UNKNOWN_ERROR_TYPE',s$post_explicit_unknowns[j],fixed=TRUE)
 b$denominator_member<-b$usable_attempt&b$context%in%c('FIRST','SECOND')&b$binary_label_observed
 b$measurement_disposition<-ifelse(b$disposition=='KNOWN_ABSENT','KNOWN_ABSENT_NO_ATTEMPT',ifelse(b$disposition=='UNKNOWN_OPPORTUNITY','UNKNOWN_OPPORTUNITY',ifelse(!b$usable_attempt,ifelse(b$validated_attempt,'VALIDATED_ATTEMPT_WITHHELD_BY_SCORE_QA','WITHHELD_OBSERVED_PREFIX'),ifelse(!b$binary_label_observed,'UNKNOWN_BINARY_LABEL',ifelse(!b$context%in%c('FIRST','SECOND'),'UNKNOWN_OR_UNSUPPORTED_CONTEXT','VALIDATED_CONTEXT_ATTEMPT')))))
 # Error values/outcomes are deliberately absent from this support-only release.
 keep<-c('point_id','match_id','Pt','tour','source_date','player','slot','source_point_file','source_row','raw_first','raw_second','plus1_action_id','disposition','observed_prefix','validated_attempt','usable_attempt','absence_reason','point_parse_status','missing_observation','unsupported_point','authority_conflict','point_exclusion_reasons','eligible','exclusion_reasons','context','context_source_action_id','pre_serve_number','context_reason','binary_label_observed','unknown_error_subtype','denominator_member','measurement_disposition')
 b<-b[,keep];b<-b[order(b$tour,b$source_date,b$match_id,b$Pt,method='radix'),];rownames(b)<-NULL;b
}
plus_protocol_counts <- function(input,b) {
 e<-input$eligibility;players<-input$players
 g<-expand.grid(match_id=e$match_id,slot=c('A','B'),context=c('FIRST','SECOND','UNKNOWN','UNSUPPORTED'),stringsAsFactors=FALSE);j<-match(g$match_id,e$match_id)
 x<-data.frame(tour=e$tour_file[j],match_id=g$match_id,source_date=e$source_date[j],player=ifelse(g$slot=='A',e$player_a[j],e$player_b[j]),slot=g$slot,player_a=e$player_a[j],player_b=e$player_b[j],event=e$event_label[j],surface=e$Surface[j],context=g$context,stringsAsFactors=FALSE)
 x$selected_player<-paste(x$tour,x$player)%in%paste(players$tour[players$selected],players$player[players$selected])
 key<-function(z)paste(z$match_id,z$slot,z$context,sep='|');k<-match(key(b),key(x));tally<-function(mask)tabulate(k[mask],nrow(x))
 mcp_need(!anyNA(k[b$observed_prefix|b$disposition=='UNKNOWN_OPPORTUNITY']),'Attempt/unknown-context join')
 x$observed_attempts<-tally(b$observed_prefix);x$qa_usable_attempts<-tally(b$usable_attempt);x$usable_attempts<-tally(b$denominator_member);x$withheld_attempts<-x$observed_attempts-x$usable_attempts
 x$unvalidated_observed_prefixes<-tally(b$disposition=='UNVALIDATED_OBSERVED_PREFIX');x$unknown_opportunities<-tally(b$disposition=='UNKNOWN_OPPORTUNITY')
 x$unknown_binary_labels<-tally(b$usable_attempt&!b$binary_label_observed);x$unknown_error_subtype_attempts<-tally(b$denominator_member&b$unknown_error_subtype)
 x$retention<-ifelse(x$observed_attempts>0,x$usable_attempts/x$observed_attempts,NA_real_)
 x$rate_status<-ifelse(x$usable_attempts>0,'NOT_CALCULATED_SUPPORT_ONLY','UNDEFINED_ZERO_DENOMINATOR')
 x<-x[order(x$tour,x$source_date,x$match_id,x$slot,x$context,method='radix'),];rownames(x)<-NULL;x
}
plus_protocol_coverage <- function(input,b,c) {
 e<-input$eligibility;rows<-list()
 for(i in seq_len(nrow(e))){z<-e[i,];p<-b[b$match_id==z$match_id,];v<-c[c$match_id==z$match_id,]
  rows[[i]]<-data.frame(tour=z$tour_file,match_id=z$match_id,source_date=z$source_date,player_a=z$player_a,player_b=z$player_b,event=z$event_label,surface=z$Surface,points=nrow(p),eligible=z$eligible,seed=z$seed,exclusion_reasons=z$exclusion_reasons,observed_attempts=sum(p$observed_prefix),validated_attempts=sum(p$validated_attempt),qa_usable_attempts=sum(p$usable_attempt),context_usable_attempts=sum(p$denominator_member),withheld_observed_attempts=sum(p$observed_prefix)-sum(p$denominator_member),known_absences=sum(p$disposition=='KNOWN_ABSENT'),unknown_opportunities=sum(p$disposition=='UNKNOWN_OPPORTUNITY'),unvalidated_prefixes=sum(p$disposition=='UNVALIDATED_OBSERVED_PREFIX'),unknown_binary_labels=sum(p$usable_attempt&!p$binary_label_observed),unknown_context_attempts=sum(p$observed_prefix&p$context=='UNKNOWN'),unsupported_context_attempts=sum(p$observed_prefix&p$context=='UNSUPPORTED'),retention=execution_ratio(sum(p$denominator_member),sum(p$observed_prefix)),stringsAsFactors=FALSE)
  mcp_need(nrow(p)==z$points&&sum(v$observed_attempts)==sum(p$observed_prefix),'Match/point accounting')
  old<-input$opportunities[input$opportunities$match_id==z$match_id&input$opportunities$domain=='Serve +1',]
  mcp_need(sum(old$observed_attempts)==sum(p$observed_prefix)&&sum(old$usable_attempts)==sum(p$usable_attempt)&&sum(old$known_absences)==sum(p$disposition=='KNOWN_ABSENT')&&sum(old$unknown_opportunities)==sum(p$disposition=='UNKNOWN_OPPORTUNITY'),'Frozen all-context +1 totals')
 }
 y<-do.call(rbind,rows);y<-y[order(y$tour,y$source_date,y$match_id,method='radix'),];rownames(y)<-NULL;y
}
plus_protocol_summary <- function(input,b,h,coverage) {
 rows<-list();rng<-function(x,f)if(length(x))f(x) else NA_real_
 for(tour in c('ATP','WTA'))for(context in c('ALL','FIRST','SECOND','UNKNOWN','UNSUPPORTED')) {
  e<-input$eligibility[input$eligibility$tour_file==tour,];v<-h[h$tour==tour,];p<-b[b$tour==tour,];cv<-coverage[coverage$tour==tour,]
  if(context!='ALL'){v<-v[v$context==context,];p<-p[p$context==context,]}
  a<-v[v$eligible,];s<-v[v$paired_support,];pa<-p[p$eligible,]
  row<-data.frame(tour,context,inventory_matches=nrow(e),eligible_matches=sum(e$eligible),excluded_matches=sum(!e$eligible),inventory_batches=length(unique(e$source_date)),eligible_batches=length(unique(e$source_date[e$eligible])),inventory_context_targets=nrow(v),supported_context_targets=nrow(s),supported_matches=length(unique(s$match_id)),supported_players=length(unique(s$player)),supported_slots=nrow(unique(s[,c('match_id','slot')])),cold_starts=sum(v$support_disposition=='NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS'),no_target_attempts=sum(v$support_disposition=='NO_USABLE_TARGET_CONTEXT_ATTEMPTS'),no_reference_attempts=sum(v$support_disposition=='NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS'),seed_context_targets=sum(v$support_disposition=='SEED_NOT_EVALUATED'),excluded_context_targets=sum(v$support_disposition=='COMPLETION_EXCLUDED'),unknown_context_targets=sum(v$support_disposition=='UNKNOWN_OR_UNSUPPORTED_CONTEXT'),inventory_observed_attempts=sum(v$observed_attempts),inventory_usable_attempts=sum(v$usable_attempts),eligible_observed_attempts=sum(a$observed_attempts),eligible_usable_attempts=sum(a$usable_attempts),eligible_withheld_attempts=sum(a$withheld_attempts),eligible_retention=execution_ratio(sum(a$usable_attempts),sum(a$observed_attempts)),eligible_known_absences=sum(pa$disposition=='KNOWN_ABSENT'),eligible_unknown_opportunities=sum(pa$disposition=='UNKNOWN_OPPORTUNITY'),eligible_unvalidated_prefixes=sum(pa$disposition=='UNVALIDATED_OBSERVED_PREFIX'),eligible_unknown_binary_labels=sum(pa$usable_attempt&!pa$binary_label_observed),eligible_unknown_error_subtype_attempts=sum(pa$denominator_member&pa$unknown_error_subtype),supported_target_attempts=sum(s$usable_attempts),stringsAsFactors=FALSE)
  for(f in c('prior_attempts','prior_usable_matches','prior_batches','days_since_last_source_date','usable_attempts'))for(fun in c('min','median','max'))row[[paste(fun,f,sep='_')]]<-rng(s[[f]],get(fun))
  mt<-tapply(a$usable_attempts,a$match_id,sum);mo<-tapply(a$observed_attempts,a$match_id,sum);ret<-mt[mo>0]/mo[mo>0]
  row$min_match_retention<-rng(ret,min);row$max_match_retention<-rng(ret,max)
  rows[[length(rows)+1L]]<-row
 }
 do.call(rbind,rows)
}
build_mcp_plus1_protocol_support <- function(input=plus_protocol_load()) {
 b<-plus_protocol_points(input);c<-plus_protocol_counts(input,b)
 h<-broader_support(c[,broader_count_fields,drop=FALSE],input$eligibility) # Unchanged same-category/context readiness.
 key<-function(z)paste(z$match_id,z$slot,z$context,sep='|');j<-match(key(h),key(c))
 for(f in setdiff(names(c),names(h)))h[[f]]<-c[[f]][j]
 h$prior_batches<-vapply(seq_len(nrow(h)),function(i){z<-h[i,];p<-c[c$tour==z$tour&c$player==z$player&c$context==z$context&c$source_date<z$source_date&c$usable_attempts>0,];p<-p[p$match_id%in%input$eligibility$match_id[input$eligibility$eligible],];length(unique(p$source_date))},0L)
 cov<-plus_protocol_coverage(input,b,c)
 r<-list('point-opportunity-dispositions'=b,'context-counts'=c,'context-support'=h,'match-coverage'=cov,summary=plus_protocol_summary(input,b,h,cov))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_SERVE_PLUS1_TRANSFER_PROTOCOL_1.0.0';r[[k]]$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$owner_domain<-'Rally';r[[k]]$option<-'ALL_DATE_EXPANDING_PROPOSED_PENDING_EXECUTION_APPROVAL';r[[k]]$claim<-'EXPOSURE_AND_SUPPORT_ONLY_NO_TRANSFER_SCORING';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
plus_protocol_install <- function(r) {
 mcp_need(identical(names(r),plus_protocol_outputs),'Exact +1 output scope');paths<-paste0(plus_protocol_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.plus-protocol-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);plus_protocol_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing +1 release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file installation failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline support audit takes no arguments');r<-build_mcp_plus1_protocol_support();plus_protocol_install(r);print(r$summary[,c('tour','context','supported_context_targets','supported_matches','supported_players','cold_starts','no_target_attempts','eligible_observed_attempts','eligible_usable_attempts','eligible_retention','median_prior_usable_matches')],row.names=FALSE)}
