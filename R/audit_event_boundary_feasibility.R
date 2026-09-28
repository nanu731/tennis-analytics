# Phase 1R: saved-evidence inventory and specification tests, never histories.
# Run from the repository root. No requests, dependencies, models or acquisition.
source("R/audit_2021_annual_data.R")
source("R/audit_wta_anomaly.R")

ebf_need <- function(ok, reason) {
  if (!isTRUE(ok)) stop("Event-boundary audit withheld: ", reason, call.=FALSE)
}
ebf_dir <- function() "data/pilot/event-boundary-feasibility"
ebf_sorted <- function(x, fields=names(x)) {
  if (nrow(x)) x <- x[do.call(order, c(x[fields], list(na.last=TRUE))), , drop=FALSE]
  rownames(x) <- NULL; x
}
# Pins bind the prior audits to exactly the reviewed saved inputs. Those audits
# are also reconstructed by their separate existing regression suites.
ebf_pins <- function() c(
  "data/manifests/anomaly-reference-files.csv" = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
  "data/manifests/development-source-files.csv" = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
  "data/manifests/inventory-reference-files.csv" = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
  "data/manifests/montreal-reference-files.csv" = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
  "data/manifests/pilot-source-files.csv" = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
  "data/pilot/development-2021/montreal-chronology-evidence/edges.csv" = "56b87368170b93da809a4fd47f8694eec462d5cc08d93c4e72a5d5e576c908f0",
  "data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv" = "775d542da9631493885d3e28814e56ed84d1fe337dbc1d60542ef4dbf9781812",
  "data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv" = "b3ebf221967bf54fb3b7f818065e55109b2d63faffed83d8f4a79ba6e3126640",
  "data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv" = "c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
  "data/pilot/inventory/inventory-summary.csv" = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
  "data/pilot/inventory/match-reconciliation.csv" = "e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
  "data/pilot/inventory/official-matches.csv" = "3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
  "data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html" = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
  "data/raw/reference/indian-wells-2023-anomaly/wta-draws.html" = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
  "data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html" = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
  "data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf" = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
  "data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt" = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
  "data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt" = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
  "data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf" = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
  "data/raw/reference/montreal-2021-feasibility/draw_html.html" = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
  "data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf" = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
  "data/raw/reference/montreal-2021-feasibility/LS001.html" = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
  "data/raw/reference/montreal-2021-feasibility/LS002.html" = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
  "data/raw/reference/montreal-2021-feasibility/LS003.html" = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
  "data/raw/reference/montreal-2021-feasibility/LS004.html" = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
  "data/raw/reference/montreal-2021-feasibility/LS005.html" = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
  "data/raw/reference/montreal-2021-feasibility/LS006.html" = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
  "data/raw/reference/montreal-2021-feasibility/LS007.html" = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
  "data/raw/reference/montreal-2021-feasibility/LS042.html" = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
  "data/raw/reference/montreal-2021-feasibility/LS049.html" = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
  "data/raw/reference/montreal-2021-feasibility/overview.html" = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.csv" = "b9b1d31a4b0b9273b8f338cbb1347c5a847ad2361334ec760a286f5990fba347",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.metadata.json" = "1b51d087b873bb723c9d36d9f5c1d0a7a1157ba8e41a00cfbe8edb2ea1723a71",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv" = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv" = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json" = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
  "data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv" = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18"
)

ebf_allow_input <- function(path) {
  ebf_need(length(path)==1L && !is.na(path) && path %in% names(ebf_pins()),
    "input is outside the exact saved-evidence allowlist")
  invisible(TRUE)
}
ebf_csv <- function(path) {
  ebf_allow_input(path)
  read.csv(path, colClasses="character", na.strings="", check.names=FALSE)
}
ebf_annual <- function(path, year) {
  allowed <- c(annual_2021_config()$local_path, pilot_config()$local_path)
  ebf_allow_input(path)
  ebf_need(year %in% c(2021L,2023L) && path %in% allowed &&
    endsWith(path, paste0("_matches_",year,".csv")), "annual season/path mismatch")
  x <- annual_2021_csv(path); annual_require_columns(x)
  ebf_need(all(startsWith(x$tourney_id,paste0(year,"-"))) &&
    all(substr(x$tourney_date,1,4)==as.character(year)), "annual contains another season")
  x
}
ebf_key <- function(tour, x) {
  if(!nrow(x)) return(character())
  paste(tour,x$tourney_id,x$round,x$winner_id,x$loser_id,sep="|")
}
ebf_pilot <- function(tour, year, id) {
  if (tour=="WTA" && year==2021L && id=="2021-806") "montreal_2021"
  else if (year==2023L && ((tour=="ATP" && id=="2023-0404") ||
    (tour=="WTA" && id=="2023-609"))) "indian_wells_2023" else "none"
}
ebf_load <- function() {
  pins <- ebf_pins()
  for (p in names(pins)) {
    ebf_allow_input(p)
    ebf_need(file.exists(p) && pilot_sha256(p)==pins[[p]],paste("missing/changed evidence",p))
  }
  manifests <- list(annual_2021_manifest(),pilot_read_manifest(pilot_config()))
  ebf_need(all(vapply(manifests,nrow,1L)==2L),"two complete annual manifests required")
  data <- list(); records <- list()
  for (k in seq_along(manifests)) for (i in 1:2) {
    r <- manifests[[k]][i,,drop=FALSE]; year <- c(2021L,2023L)[k]
    ebf_allow_input(r$local_path); annual_2021_validate(r$local_path,r)
    key <- paste(r$tour,year,sep="|")
    data[[key]] <- ebf_annual(r$local_path,year); records[[key]] <- r
  }
  official <- ebf_csv("data/pilot/inventory/official-matches.csv")
  links <- ebf_csv("data/pilot/inventory/match-reconciliation.csv")
  inventory <- ebf_csv("data/pilot/inventory/inventory-summary.csv")
  ebf_need(nrow(inventory)==2L && all(inventory$inventory_gate=="PASS"),"Indian Wells inventory evidence")
  status <- list()
  for (tour in c("ATP","WTA")) {
    x <- data[[paste(tour,2023,sep="|")]]
    z <- links[links$tour==tour,,drop=FALSE]
    i <- match(z$source_id,paste(tour,x$tourney_id,x$match_num,sep=":"))
    j <- match(paste(tour,z$official_id),paste(official$tour,official$official_id))
    ebf_need(nrow(z)==95L && !anyNA(c(i,j)) && !anyDuplicated(i),"pilot status linkage")
    status[[tour]] <- data.frame(key=ebf_key(tour,x[i,]),status=official$status[j],
      quarantined=tour=="WTA" & x$match_num[i]=="268",scope="indian_wells_2023",
      locator=paste(official$reference_id[j],official$reference_locator[j],sep="; "))
  }
  montreal <- ebf_csv("data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv")
  x <- data[["WTA|2021"]]
  i <- match(montreal$source_audit_id,paste("sackmann","WTA",x$tourney_id,x$match_num,sep=":"))
  ebf_need(nrow(montreal)==55L && !anyNA(i) && !anyDuplicated(i) &&
    all(montreal$status_resolved=="TRUE"),"Montreal status linkage")
  status$montreal <- data.frame(key=ebf_key("WTA",x[i,]),
    status=ifelse(montreal$classification=="normally_completed","completed",montreal$classification),
    quarantined=montreal$source_statistical_quarantine=="TRUE",scope="montreal_2021",
    locator=paste(montreal$html_locator,montreal$pdf_locator,sep="; "))
  status <- do.call(rbind,status); rownames(status)<-NULL
  ebf_need(!anyDuplicated(status$key),"duplicate event-scoped status key")
  list(data=data,records=records,status=status,
    provenance=data.frame(path=names(pins),sha256=unname(pins),bytes=file.info(names(pins))$size,
      role=ifelse(grepl("/raw/",names(pins)),"immutable_saved_source",
        ifelse(grepl("/manifests/",names(pins)),"pinned_manifest","pinned_prior_audit")),
      historical_availability_proven=FALSE))
}

# Pure specification predicate. Finite values represent evidence-backed UTC
# interval endpoints, not dates parsed from source labels. No production caller
# constructs such endpoints in this milestone. A lag never supplies evidence.
ebf_release <- function(prior, next_event, completion_upper=NA_real_,
  availability_upper=NA_real_, cutoff_lower=NA_real_, completion_verified=FALSE,
  availability_verified=FALSE, cutoff_verified=FALSE, timezone_resolved=FALSE,
  scenario="strict_verified", lag_days=0) {
  reason <- if (identical(prior,next_event)) "SAME_EVENT_FORBIDDEN"
    else if (scenario!="strict_verified") "HYPOTHETICAL_NOT_READINESS"
    else if (!isTRUE(completion_verified) || !is.finite(completion_upper)) "COMPLETION_BOUND_UNKNOWN"
    else if (!isTRUE(availability_verified) || !is.finite(availability_upper)) "AVAILABILITY_BOUND_UNKNOWN"
    else if (!isTRUE(cutoff_verified) || !is.finite(cutoff_lower)) "PREPLAY_CUTOFF_UNKNOWN"
    else if (!isTRUE(timezone_resolved)) "TIMEZONE_OR_INTERVAL_UNRESOLVED"
    else if (max(completion_upper,availability_upper)==cutoff_lower) "EQUAL_BOUND_BLOCKED"
    else if (max(completion_upper,availability_upper)>cutoff_lower) "OVERLAP_OR_LATE_BOUND_BLOCKED"
    else "VERIFIED_STRICT_PRIOR_BOUND"
  list(supported=identical(reason,"VERIFIED_STRICT_PRIOR_BOUND"),reason=reason,
    lag_is_evidence=FALSE,operational_authorization=FALSE)
}

ebf_cells <- function(input) {
  cells <- list(); appearances <- list(); candidates <- list()
  for (group in names(input$data)) {
    tour <- strsplit(group,"|",fixed=TRUE)[[1]][1]
    year <- as.integer(strsplit(group,"|",fixed=TRUE)[[1]][2])
    x <- input$data[[group]]; found <- annual_candidates(x,tour,year)
    cand <- found$candidates; cand$season<-rep(year,nrow(cand)); candidates[[group]]<-cand
    for (family in names(annual_aliases())) {
      c <- found$cells[found$cells$event_family_annotation==family,,drop=FALSE]
      z <- cand[cand$event_family_annotation==family,,drop=FALSE]
      id <- paste(tour,year,family,sep="|")
      # Keep every metadata variant. Missing cells are explicit; ambiguity never
      # receives an authoritative identity or a chronology shortcut.
      selected <- rep(FALSE,nrow(x))
      for (n in seq_len(nrow(z))) {
        take<-rep(TRUE,nrow(x))
        for (f in c("tourney_id","tourney_name","tourney_date","surface","tourney_level","draw_size"))
          take<-take & if(is.na(z[[f]][n])) is.na(x[[f]]) else !is.na(x[[f]]) & x[[f]]==z[[f]][n]
        selected<-selected|take
      }
      rows<-x[selected,,drop=FALSE]
      pilot<-if(nrow(z)==1L && c$state=="found_candidate") ebf_pilot(tour,year,z$tourney_id) else "none"
      key<-ebf_key(tour,rows); si<-match(key,input$status$key)
      checked<-!is.na(si) & pilot!="none"
      s<-rep("UNVETTED_NONPILOT",nrow(rows)); q<-rep(FALSE,nrow(rows)); loc<-rep("NO_OFFICIAL_STATUS_EVIDENCE",nrow(rows))
      s[checked]<-input$status$status[si[checked]];q[checked]<-input$status$quarantined[si[checked]]
      loc[checked]<-input$status$locator[si[checked]]
      if (pilot!="none") ebf_need(all(checked),"incomplete pilot status coverage")
      eligibility<-ifelse(q,"QUARANTINED",ifelse(s%in%c("retirement","walkover"),"PRIMARY_EXCLUDED",
        ifelse(s=="completed","STATUS_ONLY_CANDIDATE","UNVETTED_NONPILOT")))
      for (side in c("winner","loser")) {
        a<-data.frame(cell_id=rep(id,nrow(rows)),tour=rep(tour,nrow(rows)),season=rep(year,nrow(rows)),
          player_id=rows[[paste0(side,"_id")]],source_spelling=rows[[paste0(side,"_name")]],
          result_key=key,source_match_locator=paste(rows$tourney_id,rows$match_num,sep=":"),
          source_status_marker=annual_status(rows$score)$marker,status_evidence=s,status_screen=eligibility,
          status_scope=rep(pilot,nrow(rows)),status_locator=loc,operational_history=rep(FALSE,nrow(rows)))
        appearances[[length(appearances)+1L]]<-a
      }
      cells[[id]]<-data.frame(cell_id=id,tour=tour,season=year,event_family=family,
        source_tournament_id=annual_values(z$tourney_id),source_name=annual_values(z$tourney_name),
        source_date_label=annual_values(z$tourney_date),surface=annual_values(z$surface),raw_level=annual_values(z$tourney_level),
        candidate_records=nrow(z),source_rows=nrow(rows),mapping_state=c$state,
        identity_state=if(pilot=="none") "SOURCE_CANDIDATE_NOT_OFFICIALLY_VALIDATED" else "EVENT_SCOPED_INVENTORY_LINKED",
        inventory_state=if(pilot=="none") "NOT_TESTED" else "PASS_SAVED_PILOT_AUDIT",
        pilot_scope=pilot,missing_player_id_slots=sum(is.na(c(rows$winner_id,rows$loser_id))),
        preplay_cutoff=NA_character_,completion_upper_bound=NA_character_,availability_upper_bound=NA_character_,
        cutoff_verified=FALSE,completion_verified=FALSE,availability_verified=FALSE,
        boundary_precision="UNKNOWN",timezone="UNKNOWN",source_label_precision="day_label_not_actual_time",
        cutoff_reason="NO_INDEPENDENT_PREPLAY_BOUND",completion_reason="NO_VERIFIED_COMPLETION_UPPER_BOUND",
        availability_reason="NO_HISTORICAL_AVAILABILITY_UPPER_BOUND",release_to_next=FALSE,
        model_authorized=FALSE,event_admission="NOT_EVALUATED",
        source_path=input$records[[group]]$local_path,
        source_locator=paste("exact metadata candidates; family aliases",family,
          "IDs",annual_values(z$tourney_id),"tourney_date",annual_values(z$tourney_date)))
    }
  }
  list(cells=ebf_sorted(do.call(rbind,cells),"cell_id"),
    appearances=ebf_sorted(do.call(rbind,appearances),c("cell_id","player_id","result_key")),
    candidates=ebf_sorted(do.call(rbind,candidates),c("tour","season","event_family_annotation","tourney_id","tourney_date")))
}

ebf_pairs <- function(cells, appearances) {
  pairs<-list(); dependencies<-list()
  for (group in unique(paste(cells$tour,cells$season))) {
    g<-cells[paste(cells$tour,cells$season)==group,,drop=FALSE]
    # Lexical cell order is output serialization only, not a claimed event order.
    g<-ebf_sorted(g,"cell_id"); complete<-all(g$mapping_state=="found_candidate")
    labels<-sort(unique(g$source_date_label)); combos<-combn(seq_len(nrow(g)),2)
    for (i in seq_len(ncol(combos))) {
      left<-g[combos[1,i],];right<-g[combos[2,i],]
      a<-appearances[appearances$cell_id==left$cell_id,,drop=FALSE]
      b<-appearances[appearances$cell_id==right$cell_id,,drop=FALSE]
      shared<-sort(intersect(a$player_id[!is.na(a$player_id)],b$player_id[!is.na(b$player_id)]))
      ranks<-match(c(left$source_date_label,right$source_date_label),labels)
      adjacent<-complete && all(annual_valid_date(c(left$source_date_label,right$source_date_label))) && abs(diff(ranks))==1L
      prior<-next_cell<-""; required<-known<-unvetted<-excluded<-0L
      if (adjacent) {
        if (ranks[1]<ranks[2]) {prior<-left$cell_id;next_cell<-right$cell_id;p<-a;n<-b}
        else {prior<-right$cell_id;next_cell<-left$cell_id;p<-b;n<-a}
        for (player in shared) {
          pp<-p[p$player_id==player,,drop=FALSE]; nn<-n[n$player_id==player,,drop=FALSE]
          eligible<-sum(pp$status_screen=="STATUS_ONLY_CANDIDATE")
          unknown<-sum(pp$status_screen=="UNVETTED_NONPILOT")
          blocked<-sum(pp$status_screen%in%c("QUARANTINED","PRIMARY_EXCLUDED"))
          candidate<-eligible+unknown>0L
          required<-required+candidate; known<-known+eligible;unvetted<-unvetted+unknown;excluded<-excluded+blocked
          dependencies[[length(dependencies)+1L]]<-data.frame(tour=left$tour,season=left$season,
            prior_label_cell=prior,next_label_cell=next_cell,player_id=player,
            prior_spellings=annual_values(pp$source_spelling),next_spellings=annual_values(nn$source_spelling),
            prior_source_locators=annual_values(pp$source_match_locator),next_source_locators=annual_values(nn$source_match_locator),
            prior_status_scopes=annual_values(pp$status_scope),prior_status_only_results=eligible,
            prior_unvetted_results=unknown,prior_excluded_or_quarantined_results=blocked,
            prior_status_locators=annual_values(pp$status_locator),
            prior_result_needed_if_history_includes_prior_event=candidate,
            verified_release_supported=FALSE,blocked=candidate,
            reason=if(candidate) "PREPLAY_COMPLETION_AVAILABILITY_UNKNOWN" else "ONLY_PRIMARY_EXCLUDED_PRIOR_RESULTS",
            direction_basis="SOURCE_LABEL_ADJACENCY_NOT_PLAY_ORDER",operational_history=FALSE)
        }
      }
      pairs[[length(pairs)+1L]]<-data.frame(tour=left$tour,season=left$season,
        cell_left=left$cell_id,cell_right=right$cell_id,shared_player_ids=length(shared),
        disjoint_player_sets=length(shared)==0L,source_label_adjacent=adjacent,
        prior_label_cell=prior,next_label_cell=next_cell,
        adjacency_reason=if(!complete) "MISSING_OR_AMBIGUOUS_CELL_IN_GROUP" else if(diff(ranks)==0L) "TIED_LABELS_UNORDERED" else "SOURCE_LABELS_ONLY",
        direct_player_order=if(!length(shared)) "NO_DIRECT_PLAYER_ORDER_NEEDED" else "ACTUAL_ORDER_UNKNOWN",
        event_overlap="UNRESOLVED_NOT_PROVEN_OVERLAPPING",conditional_dependency_ids=required,
        prior_status_only_result_appearances=known,prior_unvetted_result_appearances=unvetted,
        prior_excluded_result_appearances=excluded,verified_supported_dependency_ids=0L,
        blocked_dependency_ids=required,release_supported=FALSE)
    }
  }
  dependencies<-if(length(dependencies)) do.call(rbind,dependencies) else data.frame(player_id=character())
  list(pairs=ebf_sorted(do.call(rbind,pairs),c("tour","season","cell_left","cell_right")),
    dependencies=if(nrow(dependencies)) ebf_sorted(dependencies,c("tour","season","prior_label_cell","next_label_cell","player_id")) else dependencies)
}

ebf_evidence <- function(cells) {
  rows<-list()
  add<-function(cell,field,value,role,precision,tz,reason,path,locator) {
    rows[[length(rows)+1L]]<<-data.frame(cell_id=cell,field=field,observed_value=value,
      evidence_role=role,precision=precision,timezone=tz,bound_supported=FALSE,reason=reason,
      source_path=path,locator=locator,sha256=unname(ebf_pins()[path]))
  }
  for (i in seq_len(nrow(cells))) {
    c<-cells[i,]
    add(c$cell_id,"source_date_label",c$source_date_label,"SOURCE_LABEL","day_label","UNKNOWN",
      "LABEL_NOT_ACTUAL_TIME",c$source_path,c$source_locator)
    for(field in c("preplay_cutoff","completion_upper_bound","availability_upper_bound"))
      add(c$cell_id,field,"UNKNOWN","MISSING_EVIDENCE","unknown","UNKNOWN",
        switch(field,preplay_cutoff=c$cutoff_reason,completion_upper_bound=c$completion_reason,
          availability_upper_bound=c$availability_reason),c$source_path,"annual header has no actual play/completion/publication timestamp")
    path<-if(c$pilot_scope=="montreal_2021") "data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv"
      else if(c$pilot_scope=="indian_wells_2023") "data/pilot/inventory/inventory-summary.csv" else c$source_path
    add(c$cell_id,"inventory_state",c$inventory_state,if(c$pilot_scope=="none") "SOURCE_CANDIDATE_ONLY" else "PINNED_PRIOR_AUDIT",
      "not_temporal","NOT_APPLICABLE","INVENTORY_NOT_BOUNDARY_PROOF",path,
      if(c$pilot_scope=="none") c$source_locator else paste("exact tour/event",c$tour,c$source_tournament_id))
  }
  m<-ebf_csv("data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv")
  for(i in seq_len(nrow(m))) add("WTA|2021|Canada",m$field[i],m$value[i],"PUBLISHED_LITERAL_NOT_ACTUAL_BOUND",
    m$precision[i],m$timezone_state[i],"PUBLISHED_WINDOW_SEMANTICS_UNVERIFIED",m$source_path[i],m$locator[i])
  m<-ebf_csv("data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv")
  for(i in seq_len(nrow(m))) add("WTA|2021|Canada","published_match_date_interval",
    paste(m$published_start_date[i],m$published_end_date[i],sep="/"),"PUBLISHED_LITERAL_NOT_ACTUAL_BOUND",
    m$precision[i],m$timezone_state[i],"FINISHED_CARD_SCHEDULED_METADATA_NOT_TIMING",m$source_path[i],m$metadata_locator[i])
  pdfs<-c(ATP="data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf",
    WTA="data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf")
  for(tour in names(pdfs)) {
    p<-pdfs[[tour]];ebf_allow_input(p);lines<-anomaly_pdf_text(p)
    hits<-grep("March .*2023|March 2023|Mar 2023|RELEASED",lines)
    ebf_need(length(hits)>0L,"saved Indian Wells printed timing observations missing")
    for(i in hits) add(paste(tour,2023,"Indian Wells",sep="|"),"printed_draw_timing_text",trimws(lines[i]),
      "PUBLISHED_LITERAL_NOT_ACTUAL_BOUND",if(grepl("[0-9]:[0-9]",lines[i])) "printed_minute" else "date_range_or_label",
      "UNKNOWN","PRINTED_TEXT_NOT_VERIFIED_PUBLICATION_OR_COMPLETION",p,paste("pdftotext layout line",i))
  }
  ebf_sorted(do.call(rbind,rows),c("cell_id","field","source_path","locator"))
}

ebf_decisions <- function() data.frame(decision=paste0("Q",1:12),
  approval=ifelse(1:12%in%c(5,7,12),"APPROVED_SPECIFICATION_FEASIBILITY_ONLY","PENDING_USER_APPROVAL"),
  operational_implementation_authorized=FALSE)

ebf_strategies <- function() {
  x<-data.frame(strategy=c("evidence_triggered","next_verified_boundary","one_event_lag","one_week_lag","longer_lag","permanent_unknown_exclusion"),
    evidence_required=c("Verified event completion AND historical availability upper bounds plus target pre-play cutoff",
      "Same prior bounds plus verified next boundary before target play",
      "Verified boundaries and prior availability; intervening event identity/order must be supported",
      "Verified availability/completion origin, actual calendar and timezone, target cutoff",
      "Verified origin, specified lag, calendar/timezone and target cutoff; length unselected",
      "Missing evidence suffices to withhold; independently verified bounds still needed for retained results"),
    saved_support=c(rep("NO_VERIFIED_RELEASE_BOUNDS",5),"CAN_SPECIFY_WITHHOLDING_ONLY_ZERO_RELEASES"),
    leakage_risk=c("None from temporal inclusion if upper bounds and pre-play cutoff are valid; remaining gates separate",
      "Safe only when the boundary is verified; a next source label is not proof",
      "Unknown availability remains unknown; an ordinal gap can still leak",
      "Seven days cannot establish historical publication; scheduled dates can mislead",
      "Longer delay reduces assumed exposure but proves nothing without bounds",
      "No unknown result is included; missing history and selection bias remain"),
    discarded_information=c("Same-event updates and results not proved available",
      "Also results known after the last release boundary but before cutoff",
      "Most recent event even if actually complete and available",
      "At least the chosen recent week if independently timed",
      "More recent evidence; amount unselected and unquantifiable here",
      "Every result with unknown availability; all current event releases withheld"),
    consecutive_players=c("Prior event used only when supported before next cutoff",
      "May delay a just-completed event until a later verified boundary",
      "Immediately prior event withheld even for consecutive entrants",
      "Recent entrants lose recent results; exact affected set unknown",
      "Potentially several prior events lost; affected set unknown",
      "All currently unsupported dependencies withheld"),
    elo_effect=c("Only eligible prior results could update; within-event order/update rule unresolved",
      "Stale event-entry ratings until next release; update order unresolved",
      "Extra stale ratings; lag and event-update semantics unselected",
      "Calendar-dependent stale ratings; no update algorithm implemented",
      "Greater staleness; no lag or update algorithm selected",
      "No current updates; meaningful warm-up not established"),
    last_k_effect=c("Released events still need within-event inclusion/tie policy; K unset",
      "Batch release changes sample; partial-event last-K selection unresolved",
      "Drops recent event; K, minimum sample and batch tie handling unresolved",
      "Recent-calendar exclusions alter available last-K; K unset",
      "Can severely reduce sample; K and retained population unresolved",
      "No usable current event-release history; never shrink denominator to hide this"),
    calendar_inactivity=rep("Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days",6),
    comparison_fairness=rep("Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity",6),
    selected=FALSE,implemented=FALSE)
  x
}

ebf_derive <- function(input) {
  base<-ebf_cells(input); links<-ebf_pairs(base$cells,base$appearances)
  c<-base$cells;p<-links$pairs;d<-links$dependencies
  c$adjacent_shared_player_dependency<-vapply(c$cell_id,function(id)
    any(p$source_label_adjacent & p$shared_player_ids>0L & (p$cell_left==id|p$cell_right==id)),TRUE)
  c$next_target_state<-vapply(c$cell_id,function(id) if(any(p$prior_label_cell==id))
    "SOURCE_LABEL_NEXT_ONLY" else "NO_NEXT_SUPPORTED_IN_SAVED_SEASON","")
  c$overlap_state<-"UNRESOLVED_NOT_PROVEN_OVERLAPPING"
  c$release_reason<-paste(c$cutoff_reason,c$completion_reason,c$availability_reason,sep=";")
  # Apply the specification predicate to the absent saved bounds; this does not
  # construct a history or activate a release rule.
  for(i in seq_len(nrow(p))) {
    gate<-ebf_release(p$prior_label_cell[i],p$next_label_cell[i])
    p$release_supported[i]<-p$source_label_adjacent[i] && gate$supported
  }
  summary<-do.call(rbind,lapply(unique(paste(c$tour,c$season)),function(group) {
    z<-c[paste(c$tour,c$season)==group,,drop=FALSE];q<-p[paste(p$tour,p$season)==group,,drop=FALSE]
    dep<-d[paste(d$tour,d$season)==group,,drop=FALSE]
    data.frame(tour=z$tour[1],season=z$season[1],expected_cells=nrow(z),unambiguous=sum(z$mapping_state=="found_candidate"),
      missing=sum(z$mapping_state=="missing"),ambiguous=sum(z$mapping_state=="ambiguous"),
      source_rows=sum(z$source_rows),pilot_inventory_cells=sum(z$pilot_scope!="none"),
      all_pairs=nrow(q),disjoint_pairs=sum(q$disjoint_player_sets),label_adjacent_pairs=sum(q$source_label_adjacent),
      adjacent_pairs_with_shared_ids=sum(q$source_label_adjacent&q$shared_player_ids>0L),
      adjacent_player_pair_memberships=nrow(dep),distinct_adjacent_player_ids=length(unique(dep$player_id)),
      conditional_dependency_memberships=sum(q$conditional_dependency_ids),
      supported_dependency_memberships=sum(q$verified_supported_dependency_ids),blocked_dependency_memberships=sum(q$blocked_dependency_ids),
      verified_cutoffs=sum(z$cutoff_verified),verified_completion_bounds=sum(z$completion_verified),
      verified_availability_bounds=sum(z$availability_verified),strict_releasable_cells=sum(z$release_to_next))
  }))
  edges<-ebf_csv("data/pilot/development-2021/montreal-chronology-evidence/edges.csv")
  scenarios<-data.frame(scenario=c("strict_verified","player_relative_ordinal_only","source_label_hypothetical","assumed_lag"),
    expected_cells=nrow(c),adjacent_player_pair_universe=nrow(d),
    asserted_verified_releases=0L,readiness_permitted=c(TRUE,FALSE,FALSE,FALSE),ready=FALSE,
    directly_supported_ordinal_edges=c(0L,nrow(edges),0L,0L),
    normally_completed_ordinal_edges=c(0L,sum(edges$both_endpoints_normally_completed=="TRUE"),0L,0L),
    hypothetical_label_pair_candidates=c(0L,0L,sum(p$source_label_adjacent),sum(p$source_label_adjacent)),
    hypothetical_dependency_candidates=c(0L,0L,sum(p$conditional_dependency_ids),sum(p$conditional_dependency_ids)),
    interpretation=c("No release satisfies verified strict bounds; full universe retained",
      "Montreal player-relative within-event precedence only; no cross-event timing or availability proof",
      "Source-label adjacency exposes potential dependencies only; zero evidence-supported releases",
      "Event/week/longer lag unselected; no numerical delay fabricated; all candidates retained but unsupported"))
  list(`event-cells`=c,`source-candidates`=base$candidates,`event-boundary-evidence`=ebf_evidence(c),
    `event-pairs`=p,`player-event-dependencies`=d,`strategy-comparison`=ebf_strategies(),
    scenarios=scenarios,summary=ebf_sorted(summary,c("tour","season")),decisions=ebf_decisions(),
    `input-provenance`=input$provenance)
}

ebf_conclusion <- function(result) {
  c<-result$`event-cells`
  if(sum(c$source_rows)<=nrow(c)) return("STOP_EVENT_ENTRY_PATH")
  if(all(c$mapping_state=="found_candidate") && all(c$cutoff_verified) &&
    all(c$completion_verified) && all(c$availability_verified) &&
    all(result$`event-pairs`$release_supported[result$`event-pairs`$source_label_adjacent]))
    return("GO_TO_OFFLINE_CANDIDATE_DESIGN")
  "REVISE_AND_TARGET_EVIDENCE"
}

ebf_report <- function(result) {
  s<-result$summary;p<-result$`event-pairs`;d<-result$`player-event-dependencies`;c<-result$`event-cells`
  lines<-c(
    '# Phase 1R: event-boundary feasibility', '',
    'Generated from saved evidence by `R/audit_event_boundary_feasibility.R`. Base R; no acquisition or analytical histories. The narrative specifies a candidate, not an adopted forecasting protocol.', '',
    paste0('**Recommendation: ',ebf_conclusion(result),'**. Event-entry freezing reduces the required timing resolution, but no saved event cell has a verified pre-play cutoff, completion upper bound or historical result-availability upper bound. Match-sequential forecasting remains the intended primary target.'), '',
    '## Authority and unchanged gates', '',
    'The Phase 1R user prompt approves Q5, Q7 and Q12 for specification and feasibility only. Q1–Q4, Q6 and Q8–Q11 remain PENDING_USER_APPROVAL. No primary/fallback/sensitivity role, lag, K, last-K implementation, inactivity adjustment, provider contact or alternative-source review is selected or authorized. The Phase 1Q brief and its pending-decision table remain the historical proposal; this report records the subsequent limited approvals.', '',
    pilot_markdown_table(result$decisions), '',
    'Operational chronology: NOT_IMPLEMENTED; event-entry batching: NOT_IMPLEMENTED; canonical analytical population: NOT_IMPLEMENTED; event admission: NOT_EVALUATED; modeling authorization: FALSE; publication: BLOCKED_PENDING_RIGHTS_REVIEW. Existing Montreal and Indian Wells policies, exclusions, quarantine and unresolved conflicts remain intact. Q7 is a specification gate, not operational adoption.', '',
    '## Verified input scope and mapping', '',
    'Exactly four saved annual CSVs are parsed: ATP/WTA 2021 and ATP/WTA 2023, at archive commit `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Their respective annual row counts are 2,733, 2,597, 2,986 and 2,810. SHA-256, byte size, Git blob and recorded row counts are rechecked. Two saved 2021 API metadata responses and both annual manifests are validated. No 2022, 2024 or 2025 data, response or source document is opened; historical mentions in required project documents do not constitute new data access.', '',
    'The existing bounded literal event aliases derive the mapping anew. Each tour-season yields one unambiguous candidate for each of Australian Open, Roland-Garros, Wimbledon, US Open, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati. Canada retains Montreal/Toronto as edition-city concepts; this audit does not infer a city absent from the source identity. Source surfaces and raw levels are retained, without inferring official classifications.', '',
    pilot_markdown_table(s[c('tour','season','expected_cells','unambiguous','missing','ambiguous','source_rows','pilot_inventory_cells')]), '',
    paste0('Total: **',sum(s$expected_cells),' candidate cells and ',format(sum(s$source_rows),big.mark=','),' source rows**, with no missing or ambiguous family in the current saved files. Missing/ambiguous mutation fixtures remain explicit in the full expected universe. These are source candidates, not 40 officially complete or admitted events.'), '',
    'The ignored matrix preserves exact tournament IDs, names, labels, surfaces, levels, row counts, mapping/inventory states, boundary fields and separate reason codes. A separate candidate table preserves every metadata variant if a family becomes ambiguous. No field is filled from a conventional tournament duration or a later event label.', '',
    '## Evidence strength and unresolved boundaries', '',
    'Three cells have stronger event-scoped inventory evidence: ATP and WTA Indian Wells 2023 and WTA Montreal 2021. The other 37 have source identities only and inventory NOT_TESTED. This audit fingerprints the prior saved inventory/status outputs and their raw references; the existing offline regression suites separately reconstruct those audits. It does not regrant analytical eligibility or independently authenticate a publisher’s claims.', '',
    'Montreal supplies 49 normally completed, five retired and one walkover result; Indian Wells supplies ATP 91 completed/four retired and WTA 92 completed/two retired/one walkover. The WTA Indian Wells statistical quarantine remains excluded. Those statuses support a status-only screen, not an operational history. Nonpilot rows remain UNVETTED_NONPILOT, including rows with numeric score syntax; explicit source RET/WO markers remain separate observations.', '',
    'The boundary-evidence table distinguishes SOURCE_LABEL, PINNED_PRIOR_AUDIT, PUBLISHED_LITERAL_NOT_ACTUAL_BOUND and MISSING_EVIDENCE. Every affirmative observation has a saved path, SHA-256 and locator. All 40 cutoffs and both kinds of release bound remain unknown. Reason codes are NO_INDEPENDENT_PREPLAY_BOUND, NO_VERIFIED_COMPLETION_UPPER_BOUND and NO_HISTORICAL_AVAILABILITY_UPPER_BOUND; unknown precision/timezone is retained.', '',
    'Montreal’s source label is 20210809; its saved overview says August 9–15, while the PDF header says August 7–15. That discrepancy is preserved, with no assumed qualifying explanation. Nine match pages publish date-only intervals, without established actual-play/completion semantics or timezone, alongside finished-card/scheduled-metadata conflicts. Fifty-four corroborated same-player bracket edges include 45 normally-completed-to-normally-completed edges; none establishes an event release time.', '',
    'Indian Wells’ source labels are 20230306. The saved ATP PDF prints March 6–19, 2023, and the WTA PDF prints March 8–19, 2023. The WTA PDF has a RELEASED footer dated 17 Mar 2023 7:49 PM, without a verified timezone or historical publication guarantee; its incomplete final branches cannot establish availability of all final results. Printed release text is preserved rather than promoted to an authenticated full-event bound. The existing WTA match-date/supplementary URL discrepancy also remains unresolved.', '',
    'The annuals are later archive snapshots, and the official captures were retrieved in 2026. Neither the archive revision nor those access timestamps proves that the values used were available in 2021/2023. No retrieval timestamp is repurposed as historical publication time. No saved literal here establishes the earliest relevant main-draw play or a reliable conservative upper bound for all completed results.', '',
    '## Exact-ID dependency inventory', '',
    'Within each tour-season, all 45 unordered candidate event pairs are retained. Output row order is lexical serialization only. A distinct subset consists of nine adjacent source-label pairs; label ties remain unordered, and any missing/ambiguous family prevents an asserted consecutive-label chain. No rows are dropped to improve feasibility. The unusual 2021 Indian Wells October position is derived from the saved labels.', '',
    pilot_markdown_table(s[c('tour','season','all_pairs','disjoint_pairs','label_adjacent_pairs','adjacent_player_pair_memberships','distinct_adjacent_player_ids','conditional_dependency_memberships','supported_dependency_memberships','blocked_dependency_memberships')]), '',
    paste0('All ',sum(s$all_pairs),' real pairs share at least one exact source player ID; therefore the disjoint-set claim is exercised by synthetic fixtures, not observed in this panel. The ',sum(s$label_adjacent_pairs),' adjacent-label pairs contain **',format(nrow(d),big.mark=','),' player-pair memberships**. A player can occur in several pairs; this is not a count of unique people across seasons or tours.'), '',
    paste0('Four memberships have only already-excluded prior pilot results. The remaining **',format(sum(s$conditional_dependency_memberships),big.mark=','),' conditional dependencies are all blocked**: zero have verified completion/availability before a verified next cutoff. Across the complete membership inventory there are ',sum(d$prior_status_only_results),' status-only candidate prior-result appearances, ',format(sum(d$prior_unvetted_results),big.mark=','),' unvetted appearances and ',sum(d$prior_excluded_or_quarantined_results),' excluded/quarantined appearances. These are appearances, not deduplicated matches or features.'), '',
    '“Required” is conditional on a future history including that prior event; no history window or K is selected. Each ignored membership preserves the exact ID, source spellings on both sides, source match locators, scoped status provenance and its blocker. Names never create a link. Player IDs are not joined across tours. Match numbers identify source records only and never supply order.', '',
    'Disjoint events need no arbitrary ordering for direct player-local updates. That limited statement does not establish commutativity for globally fitted transformations, schedule/opponent adjustments or every Elo variant. Shared-player auditing is a necessary direct-dependency inventory, not a complete future model dependency graph. Even with verified event boundaries, within-prior-event Elo update order and last-K ties would still require design/evidence.', '',
    '## Candidate protocol: specification only', '',
    'Process ATP and WTA separately. For each event e, choose a common cutoff C_e demonstrably before its earliest relevant main-draw play. Freeze player ratings, factor histories, opponent adjustments, fitted transformations and all other features at that cutoff. No earlier-round result or statistic from e may enter a later-round prediction in e. This yields an event-entry forecasting estimand and intentionally discards in-event learning; adopting its research role requires Q6.', '',
    'For prior event j, retain separately supported completion and historical availability upper bounds. The effective A_j is at least their maximum. Require A_j < C_e. Conservative interval handling compares the latest plausible prior completion/availability against the earliest justified cutoff, with reconciled timezone and precision. Equality, overlap, unknown semantics or unknown bounds fail closed. A common cutoff also needs evidence that it is genuinely pre-play; an arbitrary numerical value is insufficient.', '',
    'The pure test predicate illustrates that necessary condition; it neither computes times from source labels nor builds a release schedule. Retirements, partial retirement statistics and walkovers remain excluded from primary statistics and Elo updates; the Indian Wells quarantine remains. Nonpilot status candidates require separate verification. Eligible status, inventory, chronology, coverage, history scope, authorization and rights are separate gates.', '',
    'All compared models must use the same information cutoff and compatible status/population rules. Symmetric withholding is necessary for fairness, but does not make stale or nearly empty histories scientifically useful. An event-entry result cannot be reported as superiority to ordinary sequential surface Elo without the separately specified comparison.', '',
    '## Unselected boundary strategies', '')
  strategies<-result$`strategy-comparison`
  labels<-c('Evidence-triggered release','Next verified event boundary','One-event lag','One-week lag','Longer conservative lag','Permanent exclusion of unknown availability')
  for(i in seq_len(nrow(strategies))) {
    z<-strategies[i,]
    lines<-c(lines,paste0('### ',i,'. ',labels[i]),'',
      paste0('Requires: ',z$evidence_required,'. Saved support: ',z$saved_support,'.'),'',
      paste0('Leakage: ',z$leakage_risk,'. Information discarded: ',z$discarded_information,
        '. Consecutive-event players: ',z$consecutive_players,'.'),'',
      paste0('Elo: ',z$elo_effect,'. Last-K: ',z$last_k_effect,'.'),'',
      paste0('Elapsed time/inactivity: ',z$calendar_inactivity,'. Comparison fairness: ',z$comparison_fairness,'.'),'',
      'Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.','')
  }
  lines<-c(lines,'## Separate scenario accounting','',
    pilot_markdown_table(result$scenarios), '',
    'Only strict verified bounds can support readiness. Ordinal edges remain within Montreal; they do not support any cross-event release. Label-based and lag scenarios retain all 40 cells and all 2,381 adjacent memberships. Their 36 pairs and 2,377 conditional dependencies are hypothetical candidates, not “passes.” No one-week, one-event or longer delay is used to manufacture numerical coverage. Permanent exclusion can avoid including unknown results, but zero current releases is not a ready research dataset.', '',
    '## Decision criteria and next user decision', '',
    'GO requires unambiguous mapping and independently justified cutoffs/completion/availability for the retained cells and dependencies of the proposed design. Passing that test would authorize nothing beyond recommending another offline design step. STOP is warranted if event freezing offers no material reduction or its changed estimand is rejected. REVISE applies when freezing reduces timing granularity but named evidence remains absent. The predicate compares event-cell versus source-row units only as a design burden indicator, never as a claim that within-event rating mathematics is solved.', '',
    paste0('Current result: **',ebf_conclusion(result),'**. Forty event-boundary units could reduce the timing burden compared with ',format(sum(s$source_rows),big.mark=','),' match rows, but zero independent cutoffs or release bounds exist here. The strict gate fails for every conditional dependency. The research-role decision is unresolved, so no favorable fallback interpretation is imposed.'), '',
    'Smallest recommended next milestone, not authorized: a bounded four-document OTD documentation preflight exactly as proposed in Phase 1Q, focused first on research-access/retention rights, historical result-availability semantics and whether a pinned development-only extract could ever meet these requirements. Stop at rights or semantic failure; acquire no match payload, install nothing and expand no source inventory. Published match-day fields alone would not answer the availability question.', '',
    'Exact next user decision: approve or decline Q3/Q4 for that specifically bounded four-document review. If declined, pause chronology acquisition rather than substitute an assumed lag. Q6 must separately decide primary/fallback/sensitivity role before any event-entry adoption; Q8–Q10 must separately settle release strategy, history/K and inactivity design before implementation. All remain pending now. Provider contact needs separate Q1/Q2 authorization. No new dependency, directory structure beyond this task’s one ignored directory, data source, statistical method replacement or licensing assumption is approved by the finding.', '',
    '## Reproduction, outputs and safeguards', '',
    'Run from the repository root with existing R and local Git/SHA/PDF tools:', '',
    '```sh','Rscript R/audit_event_boundary_feasibility.R','Rscript R/test_event_boundary_feasibility.R','```','',
    'The audit pins 37 existing input files and fails before writing on changed/missing bytes. It writes only this report and ten CSVs under ignored `data/pilot/event-boundary-feasibility/`: event-cells, source-candidates, event-boundary-evidence, event-pairs, player-event-dependencies, strategy-comparison, scenarios, summary, decisions and input-provenance. Those tables inventory evidence; none is a canonical match, feature, operational history, rating, factor or forecasting table. No restricted row-level material is committed.', '',
    'Tests exercise exact input scope, missing/ambiguous mappings, row permutation and match-number renumbering, exact-ID versus name matching, disjoint/tied-label cases, scoped statuses, same-event exclusion, unknown/equal/overlapping bounds, timezone uncertainty, hypothetical/lag isolation, decision authority, output scope and ignored status. Runtime guards block live transport and unauthorized subprocesses. Unchanged reruns must preserve output bytes and modification times. Current validation totals and regression outcomes are recorded in status.md; they are software/evidence checks, not statistical validation.', '',
    'Only the new auditor, test and report plus status.md and data-source-contract.md change. Prior policies, reports, raw bytes, manifests and generated evidence remain preserved. The portfolio repository is not modified. No network request, contact, new source retrieval, other-season data access, operational chronology, batching, model, publication or push is part of Phase 1R. Future response-only ChatGPT handoffs remain at most 2,000 words.')
  lines
}
audit_event_boundary_feasibility <- function(write=TRUE) {
  result<-ebf_derive(ebf_load())
  if(write) {
    if(!dir.exists(ebf_dir())) dir.create(ebf_dir(),recursive=FALSE)
    for(name in names(result)) {
      path<-file.path(ebf_dir(),paste0(name,".csv"))
      ignored<-system2("git",c("check-ignore","--",shQuote(path)),stdout=TRUE,stderr=TRUE)
      ebf_need(identical(ignored,path),"audit output must remain ignored")
      pilot_write_csv(result[[name]],path)
    }
  }
  if(write) {
    report<-ebf_report(result);path<-"docs/event-boundary-feasibility.md"
    if(!file.exists(path) || !identical(readLines(path,warn=FALSE),report)) writeLines(report,path,useBytes=TRUE)
  }
  result
}
if(sys.nframe()==0L) {
  result<-audit_event_boundary_feasibility();print(result$summary)
  cat(ebf_conclusion(result),": no operational authorization follows.\n",sep="")
}
