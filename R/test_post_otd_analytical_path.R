# Phase 1T documentation/evidence checks only. No acquisition modules are sourced.
# Run from the repository root using the existing base-R runtime.
pap_baseline <- "54075fe56d940a7d87356acfa37f4b8f2d07d0ed"
pap_files <- c("docs/post-otd-analytical-path.md", "R/test_post_otd_analytical_path.R",
               "docs/status.md", "docs/data-source-contract.md")
pap_read <- function(path) paste(readLines(path, warn=FALSE), collapse="\n")
pap_need <- function(ok, label) if (!isTRUE(ok)) stop(label, call.=FALSE)
pap_has <- function(text, token) grepl(token, text, fixed=TRUE)
pap_git <- function(args) {
  # All callers use fixed read-only subcommands; no remote or mutation operation.
  pap_need(args[1] %in% c("rev-parse", "show", "diff", "ls-files", "check-ignore", "merge-base"),
           "read-only local Git command required")
  out <- system2("git", vapply(args, shQuote, ""), stdout=TRUE)
  status <- attr(out, "status")
  pap_need(is.null(status) || status == 0L, "local Git check failed")
  out
}
pap_section <- function(x, heading) {
  lines <- strsplit(x, "\n", fixed=TRUE)[[1]]
  start <- which(lines == heading)
  pap_need(length(start)==1L, paste("one section required:", heading))
  next_heading <- which(seq_along(lines)>start & grepl("^## ", lines))
  end <- if(length(next_heading)) min(next_heading)-1L else length(lines)
  paste(lines[start:end], collapse="\n")
}
pap_contract <- function(doc, status, contract, context) {
  required <- c(pap_baseline, "Review Open Tennis Data documentation feasibility",
    "26 ahead / zero behind", "REVISE_PHASE_2A", "Phase 2A implementation authorization: **PENDING_USER_APPROVAL**",
    "PAUSED_BY_USER_AFTER_PHASE_1S", "No OTD clarification draft.",
    "No recipient discovery or verification.", "No maintainer or upstream contact.",
    "No reuse of the three unused Phase 1S request slots.", "No substitute provider or URL.",
    "No acquisition loop.", "new explicit user authorization and exact scope",
    "retention duration or disposition remains a separate unresolved decision",
    "not a finding that OTD is prohibited or permanently unusable",
    "explanatory and exploratory, not a pre-match forecast",
    "Final factors and weights still require out-of-time validation",
    "Match-sequential forecasting remains the intended primary target",
    "2,377 conditional dependencies, zero verified release support",
    "37** remain UNVETTED_NONPILOT", "Numeric score syntax alone cannot establish completion",
    "no 2024 model selection", "no access to 2025 data or results",
    "Normally completed matches only", "Preserve but exclude retirements",
    "partial retirement statistics and walkovers", "Preserve Indian Wells quarantine and all source conflicts",
    "90% event / 95% tour-season", "No imputation may bypass eligibility, quarantine, undefined denominators or coverage",
    "never using future matches, validation/test outcomes or the full dataset",
    "Surface stability is NOT_ASSESSABLE; independent season stability is NOT_ASSESSABLE",
    "No empirical relationship, factor, coefficient, weight or diagnostic result is calculated in Phase 1T",
    "No statistical result or guaranteed feasibility is asserted now",
    "Exact next user approval required", "response-only ChatGPT Handoff of no more than 2,000 words")
  for(t in required) pap_need(pap_has(doc,t), paste("missing contract:",t))
  approval <- c("PENDING_USER_APPROVAL", "PENDING_USER_APPROVAL",
    "APPROVED_DOCUMENTATION_PREFLIGHT_ONLY", "APPROVED_DOCUMENTATION_PREFLIGHT_ONLY",
    "APPROVED_SPECIFICATION_FEASIBILITY_ONLY", "PENDING_USER_APPROVAL",
    "APPROVED_SPECIFICATION_FEASIBILITY_ONLY", "PENDING_USER_APPROVAL", "PENDING_USER_APPROVAL",
    "PENDING_USER_APPROVAL", "PENDING_USER_APPROVAL", "APPROVED_SPECIFICATION_FEASIBILITY_ONLY")
  rows <- grep("^\\| Q[0-9]+ \\|", strsplit(doc,"\n",fixed=TRUE)[[1]], value=TRUE)
  pap_need(length(rows)==12L,"exactly twelve Q authority rows")
  for(i in seq_along(approval)) pap_need(startsWith(rows[i],paste0("| Q",i," | ",approval[i]," |")),
                                        paste("unauthorized Q decision",i))
  for(q in c(6,8,9,10)) {
    lines <- strsplit(doc,"\n",fixed=TRUE)[[1]]
    a <- grep(paste0("^### Q",q,":"),lines)
    b <- which(seq_along(lines)>a & grepl("^##",lines)); b <- if(length(b))min(b)-1L else length(lines)
    part <- paste(lines[a:b],collapse="\n")
    for(t in c("PENDING_USER_APPROVAL","Recommended choice", "scientific benefit", "Limitation",
               "Missing evidence", "Would authorize", "Would not authorize", "Exact approval question"))
      pap_need(pap_has(part,t),paste("Q detail",q,t))
  }
  for(t in c("retain sequential primary", "sensitivity analysis", "select no arbitrary one-event, one-week or longer lag",
    "not a K choice", "Future K comparisons must occur within development and 2024 validation, then freeze before 2025",
    "defer inactivity adjustment until reliable activity dates", "No release schedule or tournament-entry batching is implemented")) {
    pap_need(pap_has(doc,t),paste("Q recommendation boundary",t))
  }
  for(t in c("NOT_IMPLEMENTED", "NOT_EVALUATED", "FALSE", "BLOCKED_PENDING_RIGHTS_REVIEW"))
    pap_need(pap_has(pap_section(doc,"## Two analytical lanes"),t),paste("lane gate",t))
  for(t in c("imputation, choosing mean or PMM", "final four-factor selection", "published weights",
    "forecast fitting", "rolling histories", "Elo", "2024 tuning", "2025 inspection",
    "out-of-sample performance claims", "documented safeguards prove absence of overfitting"))
    pap_need(pap_has(doc,t),paste("Phase 2A exclusion",t))
  for(t in c("complete cases/no imputation", "mean plus justified missingness indicators", "PMM multiple imputation",
    "chronological training samples/resamples only", "Never impute outcomes or unavailable-to-zero",
    "Freeze factors, transforms, weights, Elo and imputation choices before 2025"))
    pap_need(pap_has(doc,t),paste("missing-data safeguard",t))
  for(t in c("Avoiding overfitting is a requirement to demonstrate through chronological out-of-sample validation",
    "Fit every imputation procedure inside the chronological training sample or resample only",
    "Never impute match outcomes or convert unavailable statistics to zero",
    "Do not preselect mean imputation or PMM")) pap_need(pap_has(context,t),paste("standing context",t))
  # Scan only current directives: historical phase reports/records must not be rewritten.
  active_status <- paste(strsplit(status,"## Completed and verified",fixed=TRUE)[[1]][1],
                         pap_section(status,"## Smallest recommended next task"))
  active_contract <- paste(strsplit(contract,"## 1. Research question",fixed=TRUE)[[1]][1],
                           pap_section(contract,"## 16. Recommended next implementation step"))
  for(x in list(active_status,active_contract)) {
    pap_need(!grepl("GO_TO_PHASE_2A|STOP_ANALYTICAL_PATH",x), "conflicting current decision")
    for(t in c("PAUSED_BY_USER_AFTER_PHASE_1S","REVISE_PHASE_2A","37", "PENDING_USER_APPROVAL",
      "Q3/Q4", "APPROVED_DOCUMENTATION_PREFLIGHT_ONLY", "Q5/Q7/Q12", "APPROVED_SPECIFICATION_FEASIBILITY_ONLY"))
      pap_need(pap_has(x,t),paste("current source of truth",t))
  }
  for(x in list(doc,active_status,active_contract)) {
    # Reject positive reactivation proposals; mandatory negative pause clauses above also apply.
    pap_need(!grepl("(?i)(recommend|next task is|next task:|authorize|pursue)[^.\n]*(an offline clarification draft|an OTD clarification|further OTD access|the remaining (three |3 )?(OTD )?(slots|requests))",x,perl=TRUE),
             "residual active OTD recommendation")
  }
  # Table parsing makes missing denominators/rules visible instead of testing only family names.
  m <- grep("^\\| M[0-9][0-9] ", strsplit(doc,"\n",fixed=TRUE)[[1]],value=TRUE)
  pap_need(length(m)==15L,"exactly fifteen proposed diagnostic metrics")
  cells <- lapply(m,function(row)trimws(strsplit(row,"|",fixed=TRUE)[[1]][-1]))
  pap_need(all(lengths(cells)==11L),"complete eleven-column metric records")
  num <- c("A_i","I_i","F_i","Q_i","D_i","D_i","Q_i","S_j-F_j-Q_j","I_j-F_j",
           "S_j-I_j-Q_j","B_j","B_j-V_j","V_i","B_i","F_i+Q_i")
  den <- c("S_i","S_i","I_i","S_i-I_i","S_i-I_i","S_i","S_i-I_i-D_i","S_j","I_j",
           "S_j-I_j","G_j","B_j","B_i","G_i","S_i")
  for(i in seq_along(cells)) {
    z<-cells[[i]]
    pap_need(startsWith(z[1],sprintf("M%02d ",i)) && all(nzchar(z)),"metric ID/required fields")
    pap_need(z[2]==num[i] && z[3]==den[i],paste("exact formula",i))
    pap_need(z[7]=="U1",paste("undefined denominator rule",i))
    pap_need(z[6]==if(i%in%c(11,14))"[0,Inf)" else "[0,1]",paste("metric range",i))
    fields <- trimws(strsplit(z[4],",",fixed=TRUE)[[1]])
    dictionary <- c(A="ace",D="df",S="svpt",I="1stIn",F="1stWon",Q="2ndWon",G="SvGms",B="bpFaced",V="bpSaved")
    symbols <- unique(unlist(regmatches(paste(z[2:3],collapse=" "),gregexpr("[ADSIFQGBV]_[ij]",paste(z[2:3],collapse=" ")))))
    expected <- paste0(dictionary[substr(symbols,1,1)],substr(symbols,2,3))
    pap_need(setequal(fields,expected),paste("source fields cover formula",i))
    pap_need(z[10]%in%c("Serve Creation","Second-Serve Security","Return Pressure","Conversion and Recovery"),"hypothesis family")
  }
  for(t in c("zero, return NA with zero_opportunities", "return NA with missing_input", "return NA with invalid_bundle",
    "Negative denominators are invalid", "S-I includes double faults", "Q+D <= S-I", "A <= F+Q",
    "100*(W_i-W_j)/T = 200*W_i/T-100", "100*((F_i+Q_i)/S_i+(S_j-F_j-Q_j)/S_j-1)",
    "Two player rows from one match are dependent", "high correlation or R-squared", "not independent validation")) {
    pap_need(pap_has(doc,t),paste("metric/outcome safeguard",t))
  }
  invisible(TRUE)
}
pap_links <- function() {
  paths <- unique(c(grep("[.]md$",pap_git("ls-files"),value=TRUE),list.files("docs",pattern="[.]md$",recursive=TRUE,full.names=TRUE)))
  links<-0L;anchors<-0L
  for(p in paths) {
    x<-readLines(p,warn=FALSE)
    hits<-unlist(regmatches(x,gregexpr("\\[[^][]*\\]\\([^)]+\\)",x,perl=TRUE)),use.names=FALSE)
    for(h in hits) {
      target<-sub("^.*\\]\\((.*)\\)$","\\1",h)
      if(grepl("^[A-Za-z]+:",target))next # Never open external links.
      bits<-strsplit(target,"#",fixed=TRUE)[[1]]
      dest<-if(startsWith(target,"#"))p else file.path(dirname(p),URLdecode(bits[1]))
      pap_need(file.exists(dest),paste("missing local link",p,target));links<-links+1L
      if(length(bits)>1L && nzchar(bits[2])) {
        headings<-tolower(sub("^#{1,6} +","",grep("^#{1,6} ",readLines(dest,warn=FALSE),value=TRUE)))
        headings<-gsub(" ","-",gsub("[^[:alnum:] _-]","",gsub("[`*]","",headings)),fixed=TRUE)
        pap_need(URLdecode(bits[2])%in%headings,paste("missing anchor",p,target));anchors<-anchors+1L
      }
    }
  }
  c(markdown=length(paths),links=links,anchors=anchors)
}
pap_code_check <- function(code) {
  expr <- parse(text=code,keep.source=FALSE)
  calls <- character()
  walk <- function(x) {
    if(missing(x))return(invisible(NULL))
    if(is.call(x)) {
      if(is.symbol(x[[1]]))calls<<-c(calls,as.character(x[[1]]))
      else calls<<-c(calls,"INDIRECT_CALL")
      for(y in as.list(x)[-1])walk(y)
    } else if(is.expression(x) || is.pairlist(x)) for(y in x)walk(y)
  }
  walk(expr)
  forbidden <- c("source","sys.source","eval","evalq","get","do.call","library","require","::",":::",
                 "download.file","url","socketConnection","socketSelect","system","shell","pipe",
                 "writeLines","writeBin","saveRDS","file.copy","unlink","lm","glm","predict","cor","INDIRECT_CALL")
  pap_need(!any(calls%in%forbidden),"Phase 1T script contains transport/dynamic execution/mutation")
  # The only external process call is the fixed local Git wrapper above.
  pap_need(sum(calls=="system2")==1L && pap_has(code,'system2("git", vapply(args, shQuote, ""), stdout=TRUE)'),
           "only read-only local Git subprocess permitted")
  invisible(TRUE)
}
test_post_otd_analytical_path <- function() {
  count<-0L
  check<-function(ok,label) {pap_need(ok,label);count<<-count+1L;message("PASS: ",label)}
  reject<-function(expr,label)check(inherits(tryCatch(force(expr),error=identity),"error"),label)
  doc<-pap_read(pap_files[1]);status<-pap_read(pap_files[3]);contract<-pap_read(pap_files[4]);context<-pap_read("PROJECT_CONTEXT.md")
  baseline<-pap_git(c("show","-s","--format=%H%n%s",pap_baseline))
  check(identical(baseline,c(pap_baseline,"Review Open Tennis Data documentation feasibility")),"exact baseline hash and message")
  pap_git(c("merge-base","--is-ancestor",pap_baseline,"HEAD"));check(TRUE,"baseline remains local ancestor")
  check(pap_contract(doc,status,contract,context),"current authority, analytical lanes and complete proposed metric contract")
  code<-pap_read(pap_files[2]);check(pap_code_check(code),"new script has no transport/acquisition/analysis/output code")
  reject(pap_code_check(paste(code,'\nutils::download.file("https://example.invalid", "x")')),"reject network-capable code")
  reject(pap_code_check(paste(code,'\nsystem2("curl", "example.invalid")')),"reject added transport subprocess")
  reject(pap_code_check(paste(code,'\nsource("R/review_otd_documentation.R")')),"reject sourcing acquisition modules")
  mutations <- c("REVISE_PHASE_2A", "PAUSED_BY_USER_AFTER_PHASE_1S", "No OTD clarification draft.",
    "No recipient discovery or verification.", "No maintainer or upstream contact.",
    "No reuse of the three unused Phase 1S request slots.", "No substitute provider or URL.", "No acquisition loop.",
    "new explicit user authorization and exact scope", "retention duration or disposition remains a separate unresolved decision",
    "not a finding that OTD is prohibited or permanently unusable", "explanatory and exploratory, not a pre-match forecast",
    "Final factors and weights still require out-of-time validation", "Match-sequential forecasting remains the intended primary target",
    "2,377 conditional dependencies, zero verified release support", "37** remain UNVETTED_NONPILOT",
    "no 2024 model selection", "no access to 2025 data or results", "Normally completed matches only",
    "Preserve but exclude retirements", "partial retirement statistics and walkovers", "Preserve Indian Wells quarantine and all source conflicts",
    "90% event / 95% tour-season", "No empirical relationship, factor, coefficient, weight or diagnostic result is calculated in Phase 1T",
    "imputation, choosing mean or PMM", "final four-factor selection", "forecast fitting", "rolling histories",
    "chronological training samples/resamples only", "zero, return NA with zero_opportunities", "return NA with missing_input",
    "return NA with invalid_bundle", "Surface stability is NOT_ASSESSABLE; independent season stability is NOT_ASSESSABLE")
  for(t in mutations)reject(pap_contract(gsub(t,"REMOVED_BOUNDARY",doc,fixed=TRUE),status,contract,context),paste("reject weakened",t))
  approval_rows<-grep("^\\| Q[0-9]+ \\|",strsplit(doc,"\n",fixed=TRUE)[[1]],value=TRUE)
  for(row in approval_rows)reject(pap_contract(sub(row,sub(" \\| [A-Z_]+ \\|"," | APPROVED_ALL |",row),doc,fixed=TRUE),status,contract,context),paste("reject changed",strsplit(row,"|",fixed=TRUE)[[1]][2]))
  metrics<-grep("^\\| M[0-9][0-9] ",strsplit(doc,"\n",fixed=TRUE)[[1]],value=TRUE)
  for(row in metrics)reject(pap_contract(sub(row,sub("| U1 |","| ZERO |",row,fixed=TRUE),doc,fixed=TRUE),status,contract,context),"reject missing metric undefined-value rule")
  reject(pap_contract(sub("| A_i | S_i |","| A_i | I_i |",doc,fixed=TRUE),status,contract,context),"reject wrong ace denominator")
  reject(pap_contract(sub("[0,Inf)","[0,1]",doc,fixed=TRUE),status,contract,context),"reject probability range for chances/game")
  reject(pap_contract(paste(doc,"Recommend an offline clarification draft for OTD."),status,contract,context),"reject reactivated OTD draft")
  reject(pap_contract(doc,sub("## Smallest recommended next task","## Smallest recommended next task\n\nRecommend further OTD access.",status,fixed=TRUE),contract,context),"reject stale current status recommendation")
  reject(pap_contract(doc,status,sub("REVISE_PHASE_2A","GO_TO_PHASE_2A",contract,fixed=TRUE),context),"reject current source-of-truth disagreement")
  reject(pap_contract(doc,status,contract,sub("Do not preselect mean imputation or PMM","Mean is selected",context,fixed=TRUE)),"reject changed standing guidance")
  protected<-c("AGENTS.md","PROJECT_CONTEXT.md","docs/tennis-chronology-path-decision-brief.md",
    "docs/event-boundary-feasibility.md","docs/otd-documentation-preflight.md")
  for(p in protected) {
    check(length(pap_git(c("diff","--name-only",pap_baseline,"--",p)))==0L,paste("unchanged baseline bytes",p))
  }
  check(length(pap_git(c("ls-files","--","data/raw","data/pilot")))==0L,"restricted raw/pilot files outside Git")
  raw<-list.files(c("data/raw","data/pilot"),recursive=TRUE,full.names=TRUE,all.files=TRUE)
  check(setequal(pap_git(c("check-ignore","--",raw)),raw),"all retained raw/pilot files remain ignored")
  for(p in pap_files)check(!any(grepl("[ \t]+$",readLines(p,warn=FALSE))),paste("no trailing whitespace",p))
  links1<-pap_links();links2<-pap_links()
  check(identical(links1,links2),"deterministic complete local link/anchor checks")
  check(identical(pap_contract(doc,status,contract,context),pap_contract(doc,status,contract,context)),"deterministic document-contract rerun")
  message(count," Phase 1T checks passed; ",paste(names(links1),links1,collapse=", "),". No network or metric calculation.")
  invisible(list(checks=count,links=links1))
}
if(sys.nframe()==0L)test_post_otd_analytical_path()
