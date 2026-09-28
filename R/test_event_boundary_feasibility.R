# Phase 1R adversarial, offline evidence/specification checks. No live transport.
source("R/audit_event_boundary_feasibility.R")

test_event_boundary_feasibility <- function() {
  count<-0L
  check<-function(ok,label) {ebf_need(ok,label);count<<-count+1L;message("PASS: ",label)}
  reject<-function(expr,label) check(inherits(tryCatch(force(expr),error=identity),"error"),label)
  # Guard the whole run, including inherited readers. Definitions of acquisition
  # helpers may exist, but none may execute a real transport.
  transport_calls<-0L;reads<-character()
  block<-function(...) {transport_calls<<-transport_calls+1L;stop("Live transport forbidden")}
  env<-environment(ebf_load);saved<-list()
  for(name in c("download.file","url","socketConnection","annual_2021_request","mr_request","msa_curl")) {
    saved[name]<-list(if(exists(name,envir=env,inherits=FALSE)) get(name,envir=env) else NULL)
    assign(name,block,envir=env)
  }
  original_system2<-base::system2
  old_system2<-if(exists("system2",envir=env,inherits=FALSE)) get("system2",envir=env) else NULL
  assign("system2",function(command,...) {
    ebf_need(basename(command)%in%c("git","shasum","sha256sum","pdftotext"),"offline subprocess allowlist")
    original_system2(command,...)
  },envir=env)
  record_read<-function(path) {
    if(!is.character(path) || length(path)!=1L || !nzchar(path)) return(invisible(NULL))
    ebf_need(!grepl("2022|2024|2025",path),"prohibited season path attempted")
    reads<<-c(reads,path)
  }
  assign("ebf_test_record_read",record_read,envir=.GlobalEnv)
  trace("readBin",where=baseenv(),tracer=quote(ebf_test_record_read(con)),print=FALSE)
  trace("readLines",where=baseenv(),tracer=quote(ebf_test_record_read(con)),print=FALSE)
  trace("read.table",where=asNamespace("utils"),tracer=quote(if(!missing(file)) ebf_test_record_read(file)),print=FALSE)
  trace("download.file",where=asNamespace("utils"),tracer=quote(stop("Live transport forbidden")),print=FALSE)
  trace("url",where=baseenv(),tracer=quote(stop("Live transport forbidden")),print=FALSE)
  trace("socketConnection",where=baseenv(),tracer=quote(stop("Live transport forbidden")),print=FALSE)
  on.exit({
    for(n in c("readBin","readLines","url","socketConnection")) untrace(n,where=baseenv())
    for(n in c("read.table","download.file")) untrace(n,where=asNamespace("utils"))
    rm("ebf_test_record_read",envir=.GlobalEnv)
    for(n in names(saved)) if(is.null(saved[[n]])) rm(list=n,envir=env) else assign(n,saved[[n]],envir=env)
    if(is.null(old_system2)) rm("system2",envir=env) else assign("system2",old_system2,envir=env)
  },add=TRUE)
  input<-ebf_load(); result<-audit_event_boundary_feasibility()
  s<-result$summary;c<-result$`event-cells`;p<-result$`event-pairs`;d<-result$`player-event-dependencies`
  check(nrow(c)==40L && all(s$expected_cells==10L) && all(s$unambiguous==10L) &&
    all(s$missing==0L) && all(s$ambiguous==0L),"four derived unambiguous ten-family mappings")
  check(identical(as.integer(s$source_rows),c(910L,998L,926L,998L)),"all 3,832 candidate source rows retained")
  annual_reads<-unique(reads[grepl("_matches_.*[.]csv$",reads)])
  check(setequal(annual_reads,c(annual_2021_config()$local_path,pilot_config()$local_path)),"exactly four saved annual paths read")
  for(year in c(2022L,2024L,2025L)) {
    before<-length(reads)
    reject(ebf_annual(paste0("data/raw/atp_matches_",year,".csv"),year),paste("reject unapproved path before I/O",year))
    check(length(reads)==before,paste("no forbidden path opened",year))
  }
  reject(ebf_annual(input$records[[1]]$local_path,2023L),"mismatched declared season blocked before CSV parsing")
  original_reader<-annual_2021_csv
  assign("annual_2021_csv",function(path) {x<-input$data[[1]];x$tourney_id[1]<-"2025-synthetic";x},envir=env)
  reject(ebf_annual(input$records[[1]]$local_path,2021L),"synthetic foreign-season row rejected")
  assign("annual_2021_csv",original_reader,envir=env)
  check(!any(grepl("2022|2024|2025",reads)),"read trace contains no prohibited-season data/response/document path")
  before<-ebf_cells(input)
  bad<-input; x<-bad$data[["ATP|2023"]]
  bad$data[["ATP|2023"]]<-x[x$tourney_id!="2023-0404",]
  missing<-ebf_cells(bad)
  check(nrow(missing$cells)==40L && sum(missing$cells$mapping_state=="missing")==1L &&
    missing$cells$source_rows[missing$cells$cell_id=="ATP|2023|Indian Wells"]==0L,"missing family retained explicitly")
  mp<-ebf_pairs(missing$cells,missing$appearances)$pairs
  check(nrow(mp)==180L && !any(mp$source_label_adjacent[mp$tour=="ATP"&mp$season==2023]),"missing family cannot silently compress adjacency")
  bad<-input;extra<-x[x$tourney_id=="2023-0404",];extra$tourney_id<-"2023-9999"
  bad$data[["ATP|2023"]]<-rbind(x,extra);amb<-ebf_cells(bad)
  ai<-amb$cells$cell_id=="ATP|2023|Indian Wells"
  check(nrow(amb$cells)==40L && amb$cells$mapping_state[ai]=="ambiguous" &&
    amb$cells$candidate_records[ai]==2L && amb$cells$source_rows[ai]==190L,"ambiguous metadata variants preserved without selecting favorable candidate")
  check(!any(ebf_pairs(amb$cells,amb$appearances)$pairs$source_label_adjacent[
    p$tour=="ATP"&p$season==2023]),"ambiguous mapping blocks consecutive-chain claim")
  perm<-input
  for(group in names(perm$data)) {
    z<-perm$data[[group]];z<-z[rev(seq_len(nrow(z))),];z$match_num<-as.character(seq_len(nrow(z))+900000L)
    perm$data[[group]]<-z
  }
  after<-ebf_cells(perm)
  check(identical(before$cells,after$cells) && identical(before$candidates,after$candidates),"row permutation and match-number renumbering cannot change event evidence")
  fields<-setdiff(names(before$appearances),"source_match_locator")
  check(identical(before$appearances[fields],after$appearances[fields]),"renumbering cannot change exact-ID membership or scoped status evidence")
  check(identical(ebf_pairs(before$cells,before$appearances)$pairs,
    ebf_pairs(after$cells,after$appearances)$pairs),"permutation cannot invent pair order or release")
  renamed<-before$appearances;renamed$source_spelling<-"same synthetic name for everyone"
  check(identical(ebf_pairs(before$cells,before$appearances)$pairs,ebf_pairs(before$cells,renamed)$pairs),"names do not determine exact-ID dependency links")
  fc<-c[c$tour=="ATP"&c$season==2023,][1:2,]
  fa<-data.frame(cell_id=fc$cell_id,tour="ATP",season=2023,player_id=c("001","1"),
    source_spelling=c("Same Name","Same Name"),source_match_locator=c("fixture1","fixture2"),
    status_screen="UNVETTED_NONPILOT",status_scope="none",status_locator="fixture")
  fp<-ebf_pairs(fc,fa)$pairs
  check(fp$disjoint_player_sets && fp$shared_player_ids==0L &&
    fp$direct_player_order=="NO_DIRECT_PLAYER_ORDER_NEEDED","disjoint exact IDs never get arbitrary direct-player order")
  fa$player_id[2]<-"001";fa$source_spelling[2]<-"Different Spelling"
  check(ebf_pairs(fc,fa)$pairs$shared_player_ids==1L,"same exact ID links despite different preserved spelling")
  fc$source_date_label[2]<-fc$source_date_label[1]
  fp<-ebf_pairs(fc,fa)$pairs
  check(!fp$source_label_adjacent && fp$adjacency_reason=="TIED_LABELS_UNORDERED","equal labels remain unordered")
  check(all(is.na(c$preplay_cutoff)) && all(is.na(c$completion_upper_bound)) && all(is.na(c$availability_upper_bound)) &&
    !any(c$cutoff_verified|c$completion_verified|c$availability_verified),"source labels and printed ranges never become actual bounds")
  gate<-function(...) ebf_release("synthetic_prior","synthetic_next",...)
  good<-list(completion_upper=1,availability_upper=2,cutoff_lower=3,
    completion_verified=TRUE,availability_verified=TRUE,cutoff_verified=TRUE,timezone_resolved=TRUE)
  check(do.call(gate,good)$supported && !do.call(gate,good)$operational_authorization,"verified synthetic strict inequality passes only necessary evidence predicate")
  for(field in c("completion_upper","availability_upper","cutoff_lower")) {
    z<-good;z[[field]]<-NA_real_;check(!do.call(gate,z)$supported,paste("unknown blocks",field))
  }
  for(field in c("completion_verified","availability_verified","cutoff_verified","timezone_resolved")) {
    z<-good;z[[field]]<-FALSE;check(!do.call(gate,z)$supported,paste("unverified semantics block",field))
  }
  z<-good;z$availability_upper<-3
  check(do.call(gate,z)$reason=="EQUAL_BOUND_BLOCKED","equal availability/cutoff blocked")
  z$availability_upper<-4
  check(do.call(gate,z)$reason=="OVERLAP_OR_LATE_BOUND_BLOCKED","overlapping availability interval blocked")
  z<-good;z$completion_upper<-4
  check(!do.call(gate,z)$supported,"late completion cannot be hidden by earlier publication claim")
  for(lag in c(0,7,28,365)) check(!gate(lag_days=lag)$supported,paste("arbitrary lag does not create evidence",lag))
  check(!do.call(ebf_release,c(list(prior="same",next_event="same"),good))$supported,"same-event results forbidden even with fabricated favorable bounds")
  for(sc in c("player_relative_ordinal_only","source_label_hypothetical","assumed_lag"))
    check(!do.call(gate,c(good,list(scenario=sc)))$supported,paste("hypothetical scenario cannot grant readiness",sc))
  a<-before$appearances
  check(all(a$status_screen[a$status_evidence%in%c("retirement","walkover")]=="PRIMARY_EXCLUDED"),"adopted pilot RET/WO primary exclusion")
  check(all(a$status_screen[a$status_scope=="none"]=="UNVETTED_NONPILOT"),"unvetted nonpilot score syntax never admitted")
  check(sum(a$status_screen=="QUARANTINED")==2L &&
    all(a$cell_id[a$status_screen=="QUARANTINED"]=="WTA|2023|Indian Wells"),"quarantine remains one event-scoped result with two player appearances")
  check(identical(sort(unique(a$cell_id[a$status_scope!="none"])),
    sort(c("WTA|2021|Canada","ATP|2023|Indian Wells","WTA|2023|Indian Wells"))),"pilot status policies never generalized")
  check(ebf_pilot("ATP",2021L,"2021-806")=="none" && ebf_pilot("WTA",2023L,"2023-806")=="none" &&
    ebf_pilot("WTA",2021L,"2021-609")=="none","tour/year/event scope guard")
  check(sum(s$all_pairs)==180L && sum(s$label_adjacent_pairs)==36L && nrow(d)==2381L &&
    sum(d$prior_result_needed_if_history_includes_prior_event)==2377L && sum(d$blocked)==2377L &&
    !any(d$verified_release_supported),"complete dependency accounting including four excluded-only memberships")
  check(all(result$scenarios$expected_cells==40L) && all(result$scenarios$adjacent_player_pair_universe==2381L) &&
    !any(result$scenarios$ready) && !any(result$scenarios$asserted_verified_releases),"scenarios retain universe and cannot manufacture strict readiness")
  q<-result$decisions
  check(identical(q$decision[q$approval=="APPROVED_SPECIFICATION_FEASIBILITY_ONLY"],c("Q5","Q7","Q12")) &&
    all(q$approval[!q$decision%in%c("Q5","Q7","Q12")]=="PENDING_USER_APPROVAL") &&
    !any(q$operational_implementation_authorized),"Q approval scope and pending decisions exact")
  check(nrow(result$`strategy-comparison`)==6L && !any(result$`strategy-comparison`$selected|result$`strategy-comparison`$implemented),"six strategies unselected and unimplemented")
  check(ebf_conclusion(result)=="REVISE_AND_TARGET_EVIDENCE","conclusion follows missing boundaries rather than favorable assumptions")
  # Verify the report is exactly the current generated evidence summary.
  check(identical(readLines("docs/event-boundary-feasibility.md",warn=FALSE),ebf_report(result)),"report matches derived tables and specification")
  outputs<-c(file.path(ebf_dir(),paste0(names(result),".csv")),"docs/event-boundary-feasibility.md")
  snapshot<-function(paths) data.frame(path=paths,bytes=file.info(paths)$size,
    sha256=vapply(paths,pilot_sha256,""),mtime=as.numeric(file.info(paths)$mtime),row.names=NULL)
  prior<-snapshot(outputs);input_before<-snapshot(names(ebf_pins()))
  original_pins<-ebf_pins
  assign("ebf_pins",function() {z<-original_pins();z[1]<-paste(rep("0",64),collapse="");z},envir=env)
  reject(audit_event_boundary_feasibility(),"changed input fingerprint blocks before writing")
  assign("ebf_pins",original_pins,envir=env)
  check(identical(prior,snapshot(outputs)),"failed input validation preserves previous audit outputs")
  rerun<-audit_event_boundary_feasibility()
  check(identical(result,rerun) && identical(prior,snapshot(outputs)),"deterministic rerun preserves all output bytes and timestamps")
  check(identical(input_before,snapshot(names(ebf_pins()))),"all 37 pinned input files immutable")
  check(setequal(list.files(ebf_dir()),paste0(names(result),".csv")),"only ten declared evidence tables produced")
  tracked<-system2("git",c("ls-files","--",shQuote(ebf_dir())),stdout=TRUE)
  ignored<-system2("git",c("check-ignore","--",shQuote(outputs[-length(outputs)])),stdout=TRUE)
  check(length(tracked)==0L && setequal(ignored,outputs[-length(outputs)]),"restricted audit tables ignored and outside Git")
  check(!any(c$model_authorized) && all(c$event_admission=="NOT_EVALUATED") && !any(d$operational_history),"no modeling or operational history admission")
  check(transport_calls==0L,"no network-capable function called during audit/tests")
  check(!any(grepl("2022|2024|2025",reads)),"entire run read trace excludes prohibited seasons")
  message(count," Phase 1R checks passed.")
  invisible(list(checks=count,reads=sort(unique(reads)),transport_calls=transport_calls))
}
if(sys.nframe()==0L) test_event_boundary_feasibility()
