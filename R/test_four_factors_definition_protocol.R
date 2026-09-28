# Phase 2B: read-only document and saved-evidence verification, base R only.
fp_baseline <- '9986c03932af845e3e5bba96ceef79983481d50b'
fp_doc <- 'docs/four-factors-definition-protocol.md'
fp_files <- c(fp_doc,'R/test_four_factors_definition_protocol.R','PROJECT_CONTEXT.md','docs/status.md','docs/data-source-contract.md')
fp_need <- function(ok,label)if(!isTRUE(ok))stop(label,call.=FALSE)
fp_read <- function(p)paste(readLines(p,warn=FALSE),collapse='\n')
fp_has <- function(x,s)grepl(s,x,fixed=TRUE)
fp_git <- function(args) {
  fp_need(args[1]%in%c('show','rev-parse','ls-tree','hash-object','ls-files','check-ignore','merge-base'),'read-only Git required')
  z<-system2('git',vapply(args,shQuote,''),stdout=TRUE)
  fp_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'Git verification failed');z
}
fp_hash <- function(p)strsplit(system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE),' ')[[1]][1]
fp_snapshot <- function(paths)data.frame(path=paths,sha=vapply(paths,fp_hash,''),size=file.info(paths)$size,mtime=as.numeric(file.info(paths)$mtime),row.names=NULL)
fp_section <- function(text,heading) {
  x<-strsplit(text,'\n',fixed=TRUE)[[1]];i<-which(x==heading);fp_need(length(i)==1,paste('unique heading',heading))
  end<-which(seq_along(x)>i&grepl('^## ',x));end<-if(length(end))min(end)-1L else length(x)
  paste(x[i:end],collapse='\n')
}
fp_require <- function(text,tokens)for(t in tokens)fp_need(fp_has(text,t),paste('missing protocol rule:',t))
fp_contract <- function(doc,context,status,contract) {
  for(t in c('Four factors are established','Use 2025 for tuning','OTD is resumed','Mean imputation is selected','Raw coefficients are importance weights'))
    fp_need(!fp_has(doc,t),paste('contradictory authority or finding:',t))
  goal<-fp_section(context,'## Final Four Factors success criteria')
  fp_require(goal,c('User-approved goals','not established findings','Zero correlation is neither realistic nor required',
    'no algebraic duplication','no near-redundancy','manageable multicollinearity','stable incremental information',
    'High same-match correlation alone is insufficient','Serve Creation','Second-Serve Security','Return Pressure','Conversion and Recovery',
    'report three','composite requires separate justification and user approval','rank 10','2024 validation','locked 2025','have not been demonstrated'))
  fp_need(!fp_has(goal,'Four factors are established'),'goals cannot be promoted to findings')
  fp_require(doc,c(fp_baseline,'Audit Four Factors candidate metrics','APPROVED_DESIGN_ONLY','Final factors: NOT_SELECTED','Model fitting: NOT_AUTHORIZED',
    'no alternative candidate set was calculated','245','232','231','37 remain UNVETTED_NONPILOT','hard-court convenience pilots','34.51–42.25','0.9722','infinite',
    'Surface stability: NOT_ASSESSABLE','Independent ATP season stability: NOT_ASSESSABLE','Independent WTA event-versus-season stability: NOT_ASSESSABLE'))
  eq<-fp_section(doc,'## Algebraic equivalence classes')
  rows<-grep('^\\| E[0-9]+ \\|',strsplit(eq,'\n',fixed=TRUE)[[1]],value=TRUE)
  fp_need(length(rows)==10L,'ten complete equivalence classes')
  cells<-lapply(rows,function(z)trimws(strsplit(z,'|',fixed=TRUE)[[1]][-1]))
  fp_need(all(lengths(cells)==7L)&&all(vapply(cells,function(z)all(nzchar(z)),TRUE)),'class fields complete')
  expected<-c('M03, M09','M04, M10','M08, M15','M11, M14','M12, M13','M01','M02','M05','M06','M07')
  fp_need(identical(vapply(cells,`[[`,'',2),expected),'every metric in exactly its algebraic class')
  fp_require(eq,c('dM03 = dM09','dM04 = dM10','dM08 = dM15','dM11 = -dM14','dM12 = dM13',
    'cannot both enter a candidate model or final factor set','Never choose a representative by the largest observed correlation',
    'No representatives are selected in Phase 2B','BENCHMARK_ONLY','SENSITIVITY_ONLY','M06_i = M05_i*(1-M02_i)','M04_i = M07_i*(1-M05_i)',
    'M15_i = M02_i*M03_i + (1-M02_i)*M04_i','future player histories need fresh algebra checks'))
  role<-fp_section(doc,'## Candidate-role and comparison rules')
  fp_require(role,c('M08/M15 remain broad service/return outcome benchmarks, not automatic final factors',
    'Conversion and Recovery must show incremental information after general service and return performance',
    'NOT_IDENTIFIABLE_UNDER_DECOMPOSITION','remove or replace the family'))
  col<-fp_section(doc,'## Prespecified collinearity rules')
  cr<-grep('^\\| (Absolute pairwise correlation|Variance inflation factor|Maximum standardized condition index) \\|',strsplit(col,'\n',fixed=TRUE)[[1]],value=TRUE)
  bounds<-vapply(cr,function(z)trimws(strsplit(z,'|',fixed=TRUE)[[1]][3]),'')
  fp_need(identical(unname(bounds),c('>= 0.95','>= 0.90','>= 0.80','>= 5','>= 10','>= 30')),'fixed ordered diagnostic thresholds')
  fp_require(col,c('NEAR_REDUNDANT','SENSITIVITY_WARNING','PRACTICAL_REVIEW','PRIMARY_CONCERN','UNACCEPTABLE','FAILURE_REVIEW',
    '| Rank deficiency | Any | AUTOMATIC_FAILURE','not universal laws','must not change merely because a favored candidate fails',
    'formally documented protocol revision','ATP and WTA diagnostics are required separately','Acceptability only after pooling does not satisfy',
    'VIF_j = 1/(1-R_j^2)','sqrt(lambda_max/lambda_j)','No VIF regression is executed'))
  assoc<-fp_section(doc,'## Association and incremental-value rules')
  fp_require(assoc,c('Net Point Rating','Primary explanatory outcome','Equal-phase NPR','Sensitivity','Same-match win','Future match win',
    'High univariate correlation alone cannot select a factor','Pearson and rank','standardized multivariable coefficient direction',
    'semi-partial R-squared = R2_full - R2_without_j','partial R-squared = (R2_full - R2_without_j)/(1-R2_without_j)',
    'log loss and Brier score plus calibration','no stable incremental or future value cannot qualify',
    'PENDING_SPECIFICATION','practical margins require domain justification and user approval','identical evaluation matches and resamples'))
  weight<-fp_section(doc,'## Dean Oliver-style weighting method')
  fp_require(weight,c('SPECIFICATION_ONLY: no coefficients or empirical weights are calculated','ordinary multiple linear regression',
    'Raw coefficients are not importance weights','Standardized coefficients are not variance shares',
    'Shapley/LMG','all k! predictor orderings (24 for four factors; six if three','v(S) = R2(C+S) - R2(C)',
    'phi_j sum to R2(C+all factors) - R2(C)','100*phi_j/sum(phi)','summing to 100%',
    'shares are undefined','Shared variance is allocated transparently','uncertainty intervals','selection uncertainty',
    'separately for ATP and WTA','seasons, surfaces','provisional until chronological validation','never tuned using 2025'))
  stable<-fp_section(doc,'## Stability and uncertainty plan')
  fp_require(stable,c('One match is the analytical unit','Naive independent-row p-values are prohibited','Event-only resampling is insufficient',
    'both opponents','player_a','event-aware and player-aware','small-cluster limitations','NOT_ASSESSABLE','UNSTABLE',
    '2024 validation and model selection','Locked 2025 evaluation','surface-adjusted Elo','choose and justify','before fitting'))
  missing<-fp_section(doc,'## Missing-data and denominator plan')
  fp_require(missing,c('structural missingness','genuinely sporadic missingness','eligibility-related missingness','zero opportunities','invalid or quarantined bundles',
    'Structural, eligibility, invalid and quarantined cases cannot be repaired through statistical imputation',
    'Zero opportunities remain undefined','complete-case analysis, mean imputation, mean imputation with justified missingness indicators',
    'predictive mean matching (PMM)','No method is preselected','inside chronological training samples or resamples only',
    'Never impute outcomes; unavailable statistics never become zero','METHOD_DEPENDENT','No eligibility threshold is introduced now',
    'cannot retroactively admit excluded Phase 2A bundles','No PMM or mean implementation occurs'))
  chrono<-fp_section(doc,'## Chronological validation and overfitting controls')
  fp_require(chrono,c('2021–2023','2024','2025','accesses no 2022, 2024 or 2025 data',
    'Pilot findings may shape hypotheses but cannot prove generalization','mathematical, not performance tuning',
    'Freeze the complete pipeline before inspecting 2025 results: eligibility, candidate formulas, deduplication, denominator rules, missing-data handling, scaling, factor selection, weight estimation, Elo settings, calibration, thresholds and sensitivity definitions',
    'A 2025 failure must be reported','coding defect after freezing may be fixed only with disclosure',
    'no use of the locked outcome to redesign','Documented safeguards do not prove overfitting has been avoided','2,377'))
  score<-fp_section(doc,'## Factor-selection scorecard')
  fields<-c('Tennis interpretation','Measurement validity','Availability','Denominator stability','Exact redundancy','Near redundancy','Pairwise collinearity',
    'Multivariable collinearity','NPR association','Match-win association','Incremental NPR information','Incremental match-win information',
    'ATP stability','WTA stability','Season stability','Surface stability','Event sensitivity','Missing-data sensitivity','Uncertainty','Future forecasting value','Decision and reason')
  for(f in fields)fp_need(fp_has(score,paste0('| ',f,' |')),paste('scorecard field',f))
  fp_require(score,c('No arbitrary total score','Earlier failures cannot be compensated','Create no empirical scorecards now'))
  fail<-fp_section(doc,'## Failure and revision rules')
  fp_require(fail,c('FOUR_SUPPORTED','FEWER_THAN_FOUR_SUPPORTED','FAMILY_REPLACED','FAMILY_SPLIT_OR_REDEFINED','BENCHMARK_ONLY','FRAMEWORK_NOT_SUPPORTED',
    'fewer than four defensible distinct mechanisms','persistent rank deficiency','no stable incremental relationship','one event, surface, season, imputation method or denominator choice',
    'simpler baselines','user approval before implementation','not current findings'))
  auth<-fp_section(doc,'## Authority matrix')
  for(row in c('| Q6/Q8/Q9/Q10 | PENDING_USER_APPROVAL |','| OTD | PAUSED_BY_USER_AFTER_PHASE_1S |',
    '| Q3/Q4 | APPROVED_DOCUMENTATION_PREFLIGHT_ONLY |','| Q5/Q7/Q12 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY |',
    '| Final factors, coefficients and weights | NOT_IMPLEMENTED |','| New data, 2022/2024/2025, search/network | NOT_AUTHORIZED |'))fp_need(fp_has(auth,row),'unchanged authority')
  end<-fp_section(doc,'## Final decision and exact next approval')
  fp_require(end,c('PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION','does not authorize acquisition, final factor selection, regression fitting, Elo, forecasting, imputation, 2024 access or 2025 access',
    'offline development-cohort expansion readiness plan','Exact next user approval','no more than 2,000 words'))
  fp_need(!grepl('REVISE_FACTOR_DEFINITION_PROTOCOL|STOP_FACTOR_SELECTION_PATH',end),'exactly one final Phase 2B decision')
  for(z in list(strsplit(status,'## Completed and verified',fixed=TRUE)[[1]][1],fp_section(status,'## Smallest recommended next task'),
                 strsplit(contract,'## 1. Research question',fixed=TRUE)[[1]][1],fp_section(contract,'## 16. Recommended next implementation step'))) {
    fp_require(z,c('PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION','PAUSED_BY_USER_AFTER_PHASE_1S'))
    fp_need(!grepl('GO_TO_FACTOR_DEFINITION_PROTOCOL|REVISE_PHASE_2A',z),'no stale active decision')
  }
  fp_require(status,c('Q6/Q8/Q9/Q10 PENDING_USER_APPROVAL','Phase 2A pins PROJECT_CONTEXT.md','fails closed','no model'))
  fp_require(contract,c('Q1/Q2/Q6/Q8/Q9/Q10/Q11: PENDING_USER_APPROVAL','90%','95%','NOT_TESTED'))
  invisible(TRUE)
}
fp_code_check <- function(code) {
  calls<-character();walk<-function(x){if(missing(x))return();if(is.call(x)){calls<<-c(calls,if(is.symbol(x[[1]]))as.character(x[[1]]) else 'INDIRECT');for(y in as.list(x)[-1])walk(y)}else if(is.expression(x)||is.pairlist(x))for(y in x)walk(y)}
  walk(parse(text=code,keep.source=FALSE))
  forbidden<-c('source','sys.source','eval','evalq','get','do.call','library','require','::',':::','INDIRECT','download.file','url','socketConnection','system','pipe',
    'writeLines','writeBin','write.csv','saveRDS','file.copy','unlink','lm','glm','nls','predict','optim','cor','cor.test','svd','scale','mice','install.packages')
  fp_need(!any(calls%in%forbidden),'no acquisition, fitting, metric calculation, dependency or research write calls')
  fp_need(sum(calls=='system2')==2L&&fp_has(code,"system2('git',vapply(args,shQuote,''),stdout=TRUE)")&&fp_has(code,"system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE)"),'only bounded local Git/hash subprocesses')
  TRUE
}
fp_links <- function() {
  paths<-unique(c(grep('[.]md$',fp_git(c('ls-files')),value=TRUE),list.files('docs',pattern='[.]md$',full.names=TRUE)))
  links<-anchors<-0L
  for(p in paths) {
    x<-readLines(p,warn=FALSE);hits<-unlist(regmatches(x,gregexpr('\\[[^][]*\\]\\([^)]+\\)',x,perl=TRUE)),use.names=FALSE)
    for(h in hits){target<-sub('^.*\\]\\((.*)\\)$','\\1',h);if(grepl('^[A-Za-z]+:',target))next
      bits<-strsplit(target,'#',fixed=TRUE)[[1]];dest<-if(startsWith(target,'#'))p else file.path(dirname(p),URLdecode(bits[1]))
      fp_need(file.exists(dest),paste('missing link',p,target));links<-links+1L
      if(length(bits)>1L&&nzchar(bits[2])){heads<-tolower(sub('^#{1,6} +','',grep('^#{1,6} ',readLines(dest,warn=FALSE),value=TRUE)))
        heads<-gsub(' ','-',gsub('[^[:alnum:] _-]','',gsub('[`*]','',heads)),fixed=TRUE);fp_need(URLdecode(bits[2])%in%heads,paste('missing anchor',p,target));anchors<-anchors+1L}
    }
  };c(markdown=length(paths),links=links,anchors=anchors)
}

fp_output_pins <- function() c(
  'association-summary.csv'='1c8481ff2d7a8ffa0744d60fd756ed6fd35183d26a6e611f816a995fc1bb98b0',
  'candidate-dictionary.csv'='34184649c3e20e9d0ee1224738dbedd59ff5fa49bc9161c66a80e5914ed52125',
  'cell-coverage.csv'='7ea6feb58a428ab45bfabcc2a5c3a87eef0485f92062fa1e1cac4b4cade5d982',
  'denominator-summary.csv'='222b94f1544f58580fc680011323c5d83b7f8a3409a8c74169ddec9f66b31e12',
  'distribution-summary.csv'='61f3c54bbffa28bb29c14ab352672a3009e5b32e63a92ae090b4de3d98900052',
  'eligibility-audit.csv'='f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e',
  'input-provenance.csv'='63ebeaec1a754242be1cf55721efa1b5349bfb53fc3daf38903bee66a5a94924',
  'match-metrics.csv'='08fab6a064cde564a6dc949e41c2ee46fcf7a69a327322fffed62168196d945d',
  'matrix-diagnostics.csv'='220144d8fcaceb0e4c59c333d4ec23c36b2ad7001c3c080fc50f137705460dc5',
  'metric-availability.csv'='7601e8261ea0c6f1dde8faf04fb0d9da880949bf9bf63b4e42374435d6391e2f',
  'missingness-summary.csv'='95e4ed1f8563265db097958e3587c3b004675505730ffd5e549cf99b171660f5',
  'redundancy-map.csv'='7dd57550d3ce1bdd8646d00e9673f340c4000b3dbf12fbd4a4d5e2ec6cce4fd0',
  'sensitivity-summary.csv'='a3f16f79d7bc9def780256f3a9ab9b7ad568e6f93fececfe17427a1f4544423e',
  'summary.csv'='617825c03b3098df820503211bd5c9b200ce88e0c30a05235871c457b14043cf')

# These checks read saved aggregates; they do not reconstruct candidate metrics.
test_four_factors_definition_protocol <- function() {
  checks<-0L
  check<-function(ok,label){fp_need(ok,label);checks<<-checks+1L}
  reject<-function(expr,label)check(inherits(tryCatch({force(expr);NULL},error=function(e)e),'error'),label)
  check(identical(fp_git(c('rev-parse',paste0(fp_baseline,'^{commit}'))),fp_baseline),'exact baseline exists')
  check(identical(fp_git(c('merge-base',fp_baseline,'HEAD')),fp_baseline),'baseline is an ancestor')
  check(identical(fp_git(c('show','-s','--format=%s',fp_baseline)),'Audit Four Factors candidate metrics'),'exact baseline message')
  base_paths<-fp_git(c('ls-tree','-r','--name-only',fp_baseline))
  data_paths<-sort(list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE))
  all_paths<-sort(unique(c(base_paths,list.files(c('docs','R'),recursive=TRUE,full.names=TRUE,all.files=TRUE),data_paths)))
  before<-fp_snapshot(all_paths)
  check(length(data_paths)==162L,'exact saved data membership count')
  check(all(file.exists(fp_files)),'all five authorized deliverables exist')
  check(setequal(setdiff(all_paths,base_paths),c(setdiff(data_paths,base_paths),fp_files[1:2])),'no extra source or research output files')
  protected<-setdiff(base_paths,fp_files)
  for(p in protected)check(identical(fp_git(c('hash-object',p)),fp_git(c('rev-parse',paste0(fp_baseline,':',p)))),paste('baseline bytes:',p))
  check(!length(setdiff(fp_git(c('ls-files')),c(base_paths,fp_files))),'no unrelated tracked additions')

  context<-fp_read('PROJECT_CONTEXT.md');status<-fp_read('docs/status.md');contract<-fp_read('docs/data-source-contract.md');doc<-fp_read(fp_doc)
  baseline_context<-fp_git(c('show',paste0(fp_baseline,':PROJECT_CONTEXT.md')))
  lines<-strsplit(context,'\n',fixed=TRUE)[[1]]
  start<-which(lines=='## Final Four Factors success criteria');end<-which(lines=='## Elo benchmark')
  check(length(start)==1L&&length(end)==1L&&start<end,'exact additive context section boundaries')
  check(identical(lines[-seq.int(start,end-1L)],baseline_context),'all preexisting project context preserved exactly')
  check(isTRUE(fp_contract(doc,context,status,contract)),'complete current-document contract')
  # Removing an entire rule (not just one repeated word) must fail closed.
  mutations<-c('dM03 = dM09','dM04 = dM10','dM08 = dM15','dM11 = -dM14','dM12 = dM13',
    'cannot both enter a candidate model or final factor set','Never choose a representative by the largest observed correlation',
    '>= 0.95','>= 0.90','>= 0.80','>= 5','>= 10','>= 30','AUTOMATIC_FAILURE',
    'High univariate correlation alone cannot select a factor','Primary explanatory outcome','Future match win',
    'M08/M15 remain broad service/return outcome benchmarks, not automatic final factors',
    'Conversion and Recovery must show incremental information after general service and return performance',
    'ATP and WTA diagnostics are required separately','One match is the analytical unit','Naive independent-row p-values are prohibited',
    'Shapley/LMG','SPECIFICATION_ONLY: no coefficients or empirical weights are calculated','v(S) = R2(C+S) - R2(C)',
    '100*phi_j/sum(phi)','all k! predictor orderings (24 for four factors; six if three',
    'Structural, eligibility, invalid and quarantined cases cannot be repaired through statistical imputation',
    'Zero opportunities remain undefined','No method is preselected','inside chronological training samples or resamples only',
    'Never impute outcomes; unavailable statistics never become zero','predictive mean matching (PMM)',
    'Freeze the complete pipeline before inspecting 2025 results: eligibility, candidate formulas, deduplication, denominator rules, missing-data handling, scaling, factor selection, weight estimation, Elo settings, calibration, thresholds and sensitivity definitions',
    'A 2025 failure must be reported','FEWER_THAN_FOUR_SUPPORTED','FAMILY_REPLACED','FAMILY_SPLIT_OR_REDEFINED','FRAMEWORK_NOT_SUPPORTED',
    '| Q6/Q8/Q9/Q10 | PENDING_USER_APPROVAL |','| OTD | PAUSED_BY_USER_AFTER_PHASE_1S |',
    '| New data, 2022/2024/2025, search/network | NOT_AUTHORIZED |','| Final factors, coefficients and weights | NOT_IMPLEMENTED |',
    'No arbitrary total score','Earlier failures cannot be compensated','PENDING_SPECIFICATION')
  for(t in mutations){check(fp_has(doc,t),paste('mutation target exists',t));reject(fp_contract(gsub(t,'REMOVED_RULE',doc,fixed=TRUE),context,status,contract),paste('reject removed rule',t))}
  fields<-c('Tennis interpretation','Measurement validity','Availability','Denominator stability','Exact redundancy','Near redundancy','Pairwise collinearity','Multivariable collinearity','NPR association','Match-win association','Incremental NPR information','Incremental match-win information','ATP stability','WTA stability','Season stability','Surface stability','Event sensitivity','Missing-data sensitivity','Uncertainty','Future forecasting value','Decision and reason')
  for(t in fields)reject(fp_contract(gsub(paste0('| ',t,' |'),'| REMOVED_FIELD |',doc,fixed=TRUE),context,status,contract),paste('reject missing scorecard field',t))
  for(t in c('User-approved goals','not established findings','Zero correlation is neither realistic nor required','no algebraic duplication','no near-redundancy','manageable multicollinearity','stable incremental information','High same-match correlation alone is insufficient','report three','have not been demonstrated'))
    reject(fp_contract(doc,gsub(t,'REMOVED_GOAL',context,fixed=TRUE),status,contract),paste('reject missing durable goal',t))
  for(t in c('Four factors are established','Use 2025 for tuning','OTD is resumed','Mean imputation is selected','Raw coefficients are importance weights'))
    reject(fp_contract(paste(doc,t),context,status,contract),paste('reject affirmative contradiction',t))
  reject(fp_contract(doc,context,sub('PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION','GO_TO_FACTOR_DEFINITION_PROTOCOL',status,fixed=TRUE),contract),'reject stale current status')
  reject(fp_contract(doc,context,status,sub('PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION','GO_TO_FACTOR_DEFINITION_PROTOCOL',contract,fixed=TRUE)),'reject stale current data contract')

  code<-fp_read(fp_files[2]);check(fp_code_check(code),'read-only offline test implementation')
  for(t in c('lm(y~x)','glm(y~x)','cor(x,y)','svd(x)','predict(m,x)','source("other.R")','utils::download.file("x","y")','system("curl x")','write.csv(x,"data/new.csv")','mice(x)','install.packages("x")'))
    reject(fp_code_check(paste(code,t)),paste('reject forbidden code',t))
  pins<-fp_output_pins();outdir<-'data/pilot/four-factors-candidate-metric-feasibility'
  check(identical(sort(list.files(outdir)),sort(names(pins))),'exact 14-file Phase 2A release membership')
  for(p in names(pins))check(identical(fp_hash(file.path(outdir,p)),unname(pins[p])),paste('frozen output SHA-256',p))
  provenance<-read.csv(file.path(outdir,'input-provenance.csv'),stringsAsFactors=FALSE)
  check(nrow(provenance)==86L&&!anyDuplicated(provenance$path),'86 immutable Phase 2A input records')
  pc<-provenance$path=='PROJECT_CONTEXT.md'
  check(sum(pc)==1L&&provenance$sha256[pc]=='085276b9b29088afdcf4d2c0ab623eec23aa5ec00d035d8fc677fe568f860d60','original context SHA-256 is preserved in provenance')
  check(fp_hash('PROJECT_CONTEXT.md')!=provenance$sha256[pc],'expected context version boundary; old entry point cannot pass its pin')
  for(i in which(!pc))check(fp_hash(provenance$path[i])==provenance$sha256[i]&&file.info(provenance$path[i])$size==provenance$bytes[i],paste('unchanged evidence input',provenance$path[i]))
  m<-read.csv(file.path(outdir,'matrix-diagnostics.csv'),stringsAsFactors=FALSE)
  check(nrow(m)==5L&&all(m$columns==15L)&all(m$rank==10L)&&all(is.infinite(m$condition_number)),'saved five rank-10/15 singular matrices')
  check(all(m$effective_condition>34.50&m$effective_condition<42.26),'saved nonzero-subspace condition range')
  cells<-read.csv(file.path(outdir,'cell-coverage.csv'),stringsAsFactors=FALSE)
  check(nrow(cells)==40L&&sum(cells$source_rows)==3832L&&sum(cells$status=='UNVETTED_NONPILOT')==37L,'saved coverage inventory; unvetted stays unvetted')
  red<-read.csv(file.path(outdir,'redundancy-map.csv'),stringsAsFactors=FALSE)
  near<-red[red$group=='tour:ATP'&red$metric_a=='M05'&red$metric_b=='M06'&red$method=='pearson',]
  check(nrow(near)==1L&&abs(near$correlation-0.9722)<0.00005,'saved ATP M05/M06 near redundancy')
  assoc<-read.csv(file.path(outdir,'association-summary.csv'),stringsAsFactors=FALSE)
  decomposition<-assoc[assoc$sample=='pairwise'&assoc$method=='pearson'&assoc$outcome=='NPR'&assoc$metric%in%c('M08','M15')&startsWith(assoc$group,'tour:'),]
  check(nrow(decomposition)==4L&&all(decomposition$correlation>0.98),'saved broad-decomposition associations are evidence, not new estimates')
  # Every local data file remains untracked and ignored, except committed manifests.
  local_data<-setdiff(data_paths,base_paths)
  check(!any(local_data%in%fp_git(c('ls-files'))),'raw and pilot data remain untracked')
  check(setequal(fp_git(c('check-ignore','--no-index',local_data)),local_data),'local raw and pilot data remain ignored')
  for(p in fp_files){x<-readLines(p,warn=FALSE);check(!any(grepl('[ \t]+$',x)),paste('no trailing whitespace',p));b<-readBin(p,'raw',n=file.info(p)$size);check(length(b)>0L&&tail(b,1L)==as.raw(10),paste('terminal newline',p))}
  links1<-fp_links();links2<-fp_links()
  check(identical(links1,links2),'deterministic link and anchor checks')
  check(isTRUE(fp_contract(doc,context,status,contract)),'deterministic contract rerun')
  after_paths<-sort(unique(c(base_paths,list.files(c('docs','R'),recursive=TRUE,full.names=TRUE,all.files=TRUE),list.files('data',recursive=TRUE,full.names=TRUE,all.files=TRUE))))
  check(identical(all_paths,after_paths)&&identical(before,fp_snapshot(after_paths)),'every observed file preserves bytes size mtime and membership')
  message('Phase 2B offline checks passed: ',checks,'; Markdown ',links1['markdown'],', links ',links1['links'],', anchors ',links1['anchors'],'.')
  invisible(list(checks=checks,links=links1))
}
if(sys.nframe()==0L)test_four_factors_definition_protocol()
