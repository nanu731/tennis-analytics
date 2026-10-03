# Phase 2AB admission release 2.0.0. Offline base R; no acquisition functions imported.
ab_output <- 'data/pilot/2024-source-admission-v2'
ab_version <- '2AB-2.0.0'
ab_pins <- c(
 'R/acquire_audit_2024_source.R'='6100d7be2ac2c9b3cf584791ba89f53389a908a9b5581675100ec6c661027804',
 'R/test_2024_source_admission.R'='dec8bbad182faf2367b493df39425ffe039ee6349ed7ebaf50279dce6991571c',
 'data/manifests/validation-2024-source-files.csv'='0b9cc7331a00577b190cdeb894ca4d7caad3ce533d7006d2d45a4450b2ab3a72',
 'docs/2024-source-admission-audit.md'='87434c3c3b2ff47e1a17ccee359961d82bcf8d46ef97bf2f0cc5abfb34ab4f4a',
 'data/pilot/2024-source-admission/provenance.csv'='829c64115dea539019e9dcc50499319891aca4ad6e99af10545c0bfdf7519867',
 'data/pilot/2024-source-admission/row-dispositions.csv'='34057fb28520cbfb02b01d2581fac818f7cee63ede6c45b5de8d2e5bd72c18a3',
 'data/pilot/2024-source-admission/membership.csv'='f7fd0163a49dc9e85f5d7b45736ac36bfe62c475cdd13bc5b381f11d2e9dcd52',
 'data/pilot/2024-source-admission/cell-summary.csv'='14e9ea5f88e29e9a133f66e991732ec19f8c8a0ab0c9d825b041516ca1dab8f5',
 'data/pilot/2024-source-admission/field-availability.csv'='e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1',
 'data/pilot/2024-source-admission/summary.csv'='01a5ab211a491dbb075318010bca5246277545d936aae07824aaf7f8793d571c',
 'docs/2024-wta-pm-context-decision.md'='0ed5d69cd2d3a7752c85b9d05239762919db833dba267762a6e117a8818d3bd3')
ab_need <- function(ok,why) if(!isTRUE(ok)) stop(why,call.=FALSE)
ab_hash <- function(p) {
 if(!file.exists(p)||dir.exists(p))return('MISSING')
 h<-system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE)
 ab_need(length(h)==1&&grepl('^[0-9a-f]{64} ',h),'HASH_FAILURE');substr(h,1,64)
}
ab_verify_pins <- function(pins=ab_pins) {
 ab_need(identical(unname(vapply(names(pins),ab_hash,'')),unname(pins)),'PHASE_2Z_OR_DECISION_PIN_FAILURE')
 invisible(TRUE)
}
ab_load <- function() {
 ab_verify_pins()
 e<-new.env(parent=globalenv())
 allow<-c('z_revision','z_manifest','z_manifest_pin','z_output','z_outputs','z_pins',
 'z_need','z_hash','z_read','z_write','z_config','z_allow','z_rights','z_load','z_schema',
 'z_verify','z_ignored','z_manifest_check','z_audit_rows','z_decision','z_build','z_install')
 found<-character()
 for(x in parse('R/acquire_audit_2024_source.R'))
  if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.symbol(x[[2]])&&as.character(x[[2]]) %in% allow) {
   eval(x,e);found<-c(found,as.character(x[[2]]))
  }
 ab_need(setequal(found,allow),'HELPER_ALLOWLIST_FAILURE')
 e
}
ab_scope <- function(d) {
 keep<-d$audit_tour=='WTA' & d$audit_season=='2024' &
   d$event %in% c('Canada','Cincinnati') & d$tourney_level=='PM'
 keep[is.na(keep)]<-FALSE
 keep
}
ab_without_level <- function(x) vapply(strsplit(x,';',fixed=TRUE),
 function(v)paste(v[v!='level_conflict' & nzchar(v)],collapse=';'),'')
ab_apply <- function(d) {
 # This exception changes a reason, never a source value or another gate.
 k<-ab_scope(d)
 d$context_reasons[k]<-ab_without_level(d$context_reasons[k])
 d$exclusion_reasons[k]<-ab_without_level(d$exclusion_reasons[k])
 d$panel_disposition[k]<-ifelse(nzchar(d$context_reasons[k]),'EXCLUDED','PASS')
 d$membership[k]<-ifelse(nzchar(d$exclusion_reasons[k]),'EXCLUDED','INCLUDED')
 d
}
ab_chars <- function(d) {
 d[]<-lapply(d,function(x){x<-as.character(x);x[is.na(x)]<-'';x})
 rownames(d)<-NULL;d
}
ab_delta <- function(before,after,cells,members) {
 a<-ab_chars(before);b<-ab_chars(after);k<-ab_scope(a)
 ab_need(identical(names(a),names(b))&&nrow(a)==5765&&nrow(b)==5765,'ROW_ACCOUNTING_DISCREPANCY')
 ab_need(sum(k)==110&&all(table(a$event[k])==55),'EXACT_CONTEXT_DISCREPANCY')
 changed<-c('context_reasons','exclusion_reasons','panel_disposition','membership')
 ab_need(identical(a[,setdiff(names(a),changed)],b[,setdiff(names(b),changed)]),'SOURCE_OR_OTHER_FIELD_CHANGED')
 ab_need(identical(a[!k,],b[!k,]),'OUTSIDE_CONTEXT_CHANGED')
 ab_need(all(a$context_reasons[k]=='level_conflict')&&all(b$context_reasons[k]=='')&&
 all(b$panel_disposition[k]=='PASS'),'CONTEXT_REASON_DISCREPANCY')
 ab_need(identical(b$exclusion_reasons[k],ab_without_level(a$exclusion_reasons[k])),'INDEPENDENT_REASON_CHANGED')
 ab_need(all(a$membership[k]=='EXCLUDED')&&sum(b$membership[k]=='INCLUDED')==105&&
 sum(b$membership[k]=='EXCLUDED')==5,'MEMBERSHIP_DELTA_DISCREPANCY')
 ret<-k & b$membership=='EXCLUDED'
 ab_need(all(b$event[ret]=='Canada')&&all(b$completion_status[ret]=='retirement')&&
 all(grepl('status_retirement',b$exclusion_reasons[ret],fixed=TRUE)),'RETIREMENT_DISCREPANCY')
 for(tour in c('ATP','WTA')) {
  q<-b[b$audit_tour==tour&b$membership!='OUTSIDE_PANEL',]
  want<-if(tour=='ATP')c(944,54) else c(957,41)
  ab_need(nrow(q)==998&&all(c(sum(q$membership=='INCLUDED'),sum(q$membership=='EXCLUDED'))==want),'TOUR_TOTAL_DISCREPANCY')
 }
 cc<-cells[cells$round=='ALL',]
 ab_need(nrow(cc)==20&&!anyDuplicated(cc$cell_id)&&all(cc$admitted_source_records>0),'CELL_DISCREPANCY')
 ab_need(nrow(members)==1901&&!anyDuplicated(members$match_id)&&
 identical(as.character(members$match_id),b$match_id[b$membership=='INCLUDED']),'MEMBERSHIP_JOIN_DISCREPANCY')
 invisible(c(level_conflicts_removed=sum(a$context_reasons!=b$context_reasons),
 newly_admitted=sum(a$membership!=b$membership),independent_exclusions_retained=sum(ret)))
}
ab_build <- function(e=ab_load()) {
 ab_verify_pins()
 paths<-file.path(ab_output,paste0(e$z_outputs,'.csv'))
 ab_need(e$z_ignored(paths),'OUTPUT_NOT_IGNORED')
 helpers<-e$z_load()
 # First reproduce the entire frozen release from verified saved raw sources.
 old<-e$z_build(helpers)
 ab_need(all(old$provenance$state=='VERIFIED'),'SOURCE_VERIFICATION_FAILED')
 temp<-tempfile('ab-verify-');on.exit(unlink(temp),add=TRUE)
 for(k in e$z_outputs) {
  e$z_write(old[[k]],temp)
  ab_need(ab_hash(temp)==ab_pins[[paste0('data/pilot/2024-source-admission/',k,'.csv')]],paste0('FROZEN_REPRODUCTION_FAILED:',k))
 }
 original<-e$z_audit_rows
 on.exit(e$z_audit_rows<-original,add=TRUE)
 e$z_audit_rows<-function(raw,e,history=NULL)ab_apply(original(raw,e,history))
 result<-e$z_build(helpers)
 ab_need(all(result$provenance$state=='VERIFIED'),'SOURCE_VERIFICATION_FAILED')
 delta<-ab_delta(old[['row-dispositions']],result[['row-dispositions']],
 result[['cell-summary']],result$membership)
 ab_need(identical(old[['field-availability']],result[['field-availability']]),'COUNT_AVAILABILITY_CHANGED')
 ab_need(result$summary$value[result$summary$measure=='terminal_decision']=='2024_SOURCE_COHORT_READY_FOR_HISTORY_BUILD','TERMINAL_DISCREPANCY')
 # Keep inherited row audit_version: it identifies the unchanged admission engine.
 result$provenance$release_version<-ab_version
 result$provenance$parent_release<-'2Z-1.0.0'
 result$provenance$revision_evidence<-paste(names(ab_pins),ab_pins,sep='=',collapse=';')
 for(k in c('release_version',names(delta))) {
  row<-result$summary[1,,drop=FALSE];row$group<-'ALL';row$measure<-k
  row$value<-if(k=='release_version')ab_version else as.character(delta[[k]])
  row$detail<-'Exact WTA 2024 Canada/Cincinnati PM exception; independent rules unchanged'
  result$summary<-rbind(result$summary,row)
 }
 ab_verify_pins();result
}
ab_install <- function(result,dest=ab_output,hook=function(stage){},e=ab_load()) {
 # Production destination only; tests use the inherited atomic helper in temporary storage.
 ab_need(identical(dest,ab_output)&&e$z_ignored(file.path(dest,paste0(e$z_outputs,'.csv'))),'OUTPUT_LOCATION_FAILURE')
 ab_verify_pins()
 e$z_install(result,dest,hook)
 ab_verify_pins();invisible(result)
}
ab_main <- function() {
 e<-ab_load();result<-ab_build(e);ab_install(result,e=e)
 print(result$summary[,1:4]);invisible(result)
}
if(sys.nframe()==0L) {
 ab_need(length(commandArgs(trailingOnly=TRUE))==0L,'OFFLINE_RUN_ACCEPTS_NO_ARGUMENTS')
 ab_main()
}
