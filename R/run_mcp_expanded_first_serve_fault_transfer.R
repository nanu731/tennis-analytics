# Expanded sample; reuse frozen physical-count, estimation and scoring helpers.
source('R/run_mcp_first_serve_fault_transfer.R')
expanded_serve_prefix <- 'data/pilot/mcp-expanded-first-serve-fault-transfer-v1-'
expanded_serve_outputs <- serve_outputs
expanded_serve_definition_pin <- '1061aaa69a291619e5ccbf2df7c2cf8591415d7c760fedc77aecdcc7894b695b'
expanded_serve_pins <- c(
 'R/run_mcp_first_serve_fault_transfer.R'='99d265e7a8b2130ae0109f65564fc4556b9b97f42bbcfe1e9050daf829a5aa22',
 'R/run_mcp_return_transfer.R'='4585e162b044e1a6e3b064fbd455692fa7540f67ec4767ffb68924dad91d5909',
 'R/build_mcp_expanded_recurring_sample.R'='bd45c0ae59fb6fbe69615e4d597cf48734e7385cf2841629e1b0f5c448715b56',
 'docs/mcp-expanded-recurring-player-audit.md'='966fe53d55e312964abbb8dd7ae7aee147317a6edeb18b4aec0f17793c1107ba',
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
 'data/pilot/mcp-expanded-recurring-v1-state-coverage.csv'='1257dc9a3d632b4b453ff1afb5a05846cdb54d11a630d3a4655e1dacf15b3621',
 'data/pilot/mcp-first-serve-fault-transfer-v1-coverage-summary.csv'='ffd825d536fff14a05a7cff2e8cc58aab2b9ec5f1dfab8d593a7be62b71b85bc',
 'data/pilot/mcp-first-serve-fault-transfer-v1-observation-counts.csv'='a59622e2bbbc87206e29db74d8d3833b8d2dd0b9ec6a0e40431e1fe39c999a45',
 'data/pilot/mcp-first-serve-fault-transfer-v1-paired-scores.csv'='79678e136b046fbaf07c441b99acfbf636ade48f3b8e3195ee445c5c08edb886',
 'data/pilot/mcp-first-serve-fault-transfer-v1-stability.csv'='0991a3e734aab0ffe82047903b32d6d58779a93f55d4ca41b5eee739747553d7',
 'data/pilot/mcp-first-serve-fault-transfer-v1-summary.csv'='02315119e2d488cb9cbb0d57864522b4e68e0a571572b2abfd43303cd6652af7',
 'data/pilot/mcp-first-serve-fault-transfer-v1-target-estimates.csv'='87e31fa13bfa248a28657f50b2efd12f494f6bc1a662c4d8a67b1cbbfbb0c6cf')
expanded_serve_verify <- function() {
 serve_verify() # Includes saved rights, provenance and original formula authority.
 for(f in names(expanded_serve_pins))mcp_need(mcp_sha(f)==expanded_serve_pins[[f]],paste('Frozen expanded input changed:',f))
 lines<-readLines('docs/mcp-expanded-first-serve-fault-transfer-results.md',warn=FALSE)
 cut<-match('## Measured coverage and denominators',lines);if(!is.na(cut))lines<-head(lines,cut-1L)
 while(length(lines)&&tail(lines,1)=='')lines<-head(lines,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(lines,f)
 mcp_need(mcp_sha(f)==expanded_serve_definition_pin,'Prospective expanded specification changed')
 invisible(TRUE)
}
expanded_serve_load <- function() {
 expanded_serve_verify()
 prefix<-'data/pilot/mcp-expanded-recurring-v1-'
 read<-function(name)read.csv(paste0(prefix,name,'.csv'),stringsAsFactors=FALSE)
 list(eligibility=read('match-eligibility'),states=read('action-states'),actions=read('actions'),opportunities=read('opportunity-counts'),support=read('history-support'))
}
expanded_serve_check <- function(input) {
 e<-input$eligibility;s<-input$states;a<-input$actions
 mcp_need(nrow(e)==223&&!anyDuplicated(e$match_id)&&all(mcp_date_valid(gsub('-','',e$source_date,fixed=TRUE))),'Frozen inventory/date accounting')
 mcp_need(all(e$eligible%in%c(TRUE,FALSE))&&all(e$official_completion=='NOT_VERIFIED_FROM_SAVED_EVIDENCE'),'Frozen completion authority')
 mcp_need(!anyDuplicated(s$action_id)&&!anyDuplicated(a$action_id)&&setequal(s$action_id,a$action_id)&&setequal(s$match_id,e$match_id),'Action/match identity conflict')
 j<-match(s$action_id,a$action_id);k<-match(s$match_id,e$match_id)
 for(pair in list(c('post_kind','kind'),c('post_serve_number','serve_number'),c('owner_domain','domain'),c('actor_name','actor_name'),c('actor_neutral_slot','actor_neutral_slot'),c('match_id','match_id'),c('raw_token','raw_token')))
  mcp_need(identical(s[[pair[1]]],a[[pair[2]]][j]),paste('Frozen parser/state authority:',pair[1]))
 mcp_need(all(s$tour_file==e$tour_file[k])&&all(s$revision==mcp_revision),'Category/provenance conflict')
 physical<-s$post_kind%in%c('SERVE','SERVE_FAULT')
 mcp_need(all(s$owner_domain[physical]=='Serve'&s$owner_role[physical]=='SERVER')&&all(s$actor_neutral_slot[physical]%in%c('A','B')),'Unique server-owned physical attempts')
 expected<-ifelse(s$actor_neutral_slot=='A',e$player_a[k],e$player_b[k])
 mcp_need(all(s$actor_name[physical]==expected[physical]),'Neutral server identity')
 mcp_need(all(s$tennis_action_usable[physical]==(s$transition_usable[physical]&!a$is_void[j[physical]]))&&
  !any(s$tennis_action_usable[physical]&(!s$point_validated[physical]|s$score_reconciliation_status[physical]!='PASS'|!s$local_boundary_supported[physical])),'Frozen usability gate conflict')
 mcp_need(!any(s$tennis_action_usable[s$post_kind%in%c('LET','FIRST_SERVE_FORFEIT','OUTCOME_ONLY','UNSUPPORTED_SUFFIX','POINT_PENALTY')]),'Void/admin/missing observations cannot gain attempt credit')
 invisible(TRUE)
}

# Bind only the inventory validator locally; keep the historical counter unchanged.
expanded_serve_counts <- local({
 serve_check <- expanded_serve_check
 counter <- serve_counts;environment(counter)<-environment();counter
})
expanded_serve_support <- function(input,counts) {
 key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
 p<-input$opportunities[input$opportunities$domain=='Serve',];h<-input$support[input$support$domain=='Serve'&input$support$context=='FIRST',]
 mcp_need(nrow(p)==nrow(counts)&&!anyDuplicated(key(p))&&setequal(key(p),key(counts)),'Expanded Serve denominator inventory')
 j<-match(key(counts),key(p))
 for(f in c('tour','player','source_date','observed_attempts','usable_attempts','withheld_attempts'))mcp_need(identical(counts[[f]],p[[f]][j]),paste('Expanded audit denominator mismatch:',f))
 x<-counts[counts$context=='FIRST',];mcp_need(nrow(h)==nrow(x)&&!anyDuplicated(key(h))&&setequal(key(h),key(x)),'Expanded FIRST slot accounting')
 h<-h[match(key(x),key(h)),]
 for(i in seq_len(nrow(x))){z<-x[i,];prior<-x[x$eligible&x$tour==z$tour&x$player==z$player&x$source_date<z$source_date,]
  n<-sum(prior$usable_attempts);reason<-if(!z$eligible)'COMPLETION_EXCLUDED' else if(z$seed)'SEED_NOT_EVALUATED' else if(!z$usable_attempts)'NO_USABLE_TARGET_CONTEXT_ATTEMPTS' else if(!n)'NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS' else 'PRIOR_SUPPORT_AVAILABLE'
  mcp_need(h$eligible[i]==z$eligible&&h$seed[i]==z$seed&&h$prior_attempts[i]==n&&h$prior_usable_matches[i]==sum(prior$usable_attempts>0)&&h$supported[i]==(reason=='PRIOR_SUPPORT_AVAILABLE'),'Pre-score eligibility/prior/target reconciliation')
  mcp_need(h$support_disposition[i]==reason,'Pre-score failure disposition mismatch')
 }
 mcp_need(identical(as.integer(table(x$tour)),c(212L,234L))&&identical(as.integer(table(h$tour[h$supported])),c(120L,135L)),'Expected Serve-specific inventory/support')
 invisible(TRUE)
}
run_mcp_expanded_serve_transfer <- function(input=expanded_serve_load()) {
 counts<-expanded_serve_counts(input)
 expanded_serve_support(input,counts) # No errors, rates or comparative losses used.
 x<-serve_estimates(counts);cov<-serve_coverage(input,counts)
 h<-input$support[input$support$domain=='Serve'&input$support$context=='FIRST',];key<-function(z)paste(z$match_id,z$slot,z$context,sep='|')
 mcp_need(identical(x$paired_mask,h$supported[match(key(x),key(h))]),'Identical pre-score/personal/reference target mask')
 scores<-do.call(rbind,lapply(c('ATP','WTA'),function(tour)cbind(data.frame(tour,context='FIRST'),transfer_score(x[x$tour==tour,]))))
 r<-list('observation-counts'=counts,'target-estimates'=x,'paired-scores'=scores,stability=transfer_stability(x[x$eligible,]),'coverage-summary'=cov,summary=serve_summary(x,cov))
 for(k in names(r)){rownames(r[[k]])<-NULL;r[[k]]$release<-'MCP_EXPANDED_FIRST_SERVE_FAULT_TRANSFER_1.0.0';r[[k]]$revision<-mcp_revision;r[[k]]$sample_release<-'MCP_EXPANDED_RECURRING_1.0.0';r[[k]]$measurement<-'PHYSICAL_FIRST_SERVE_FAULT_FREQUENCY';r[[k]]$option<-'ALL_DATE_EXPANDING';r[[k]]$claim<-'OVERLAPPING_EXPLORATORY_OBSERVED_QA_USABLE_SERVE_ATTEMPTS_INTERNAL_CHART_COMPLETION_ONLY';r[[k]]$chronology<-'SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY';r[[k]]$exposure<-'ALL_ACQUIRED_YEARS_INCLUDING_2026_EXPOSED';r[[k]]$uncertainty<-'UNCERTAINTY_NOT_ESTABLISHED'}
 r
}
expanded_serve_install <- function(r) {
 mcp_need(identical(names(r),expanded_serve_outputs),'Exact expanded Serve output scope');paths<-paste0(expanded_serve_prefix,names(r),'.csv')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'Existing ignored location required')
 stage<-vapply(paths,function(p)tempfile('.expanded-serve-',tmpdir=dirname(p)),'');on.exit(unlink(stage),add=TRUE)
 for(i in seq_along(r))mcp_write(r[[i]],stage[i]);expanded_serve_verify()
 for(i in seq_along(paths))if(file.exists(paths[i]))mcp_need(mcp_sha(paths[i])==mcp_sha(stage[i]),'Refuse differing expanded Serve release')
 for(i in seq_along(paths))if(!file.exists(paths[i]))mcp_need(file.rename(stage[i],paths[i]),'Atomic per-file installation failed')
 invisible(r)
}
if(sys.nframe()==0L){mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline experiment takes no arguments');r<-run_mcp_expanded_serve_transfer();expanded_serve_install(r)
 print(r$summary,row.names=FALSE);print(r[['paired-scores']][,c('tour','paired_cells','scored_matches','difference_brier','difference_log_loss','difference_brier_opportunity_weighted','difference_log_loss_opportunity_weighted')],row.names=FALSE)}
