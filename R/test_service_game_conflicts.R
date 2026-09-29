# Focused Phase 2I tests; historical audit/test runners are never invoked.
source('R/diagnose_service_game_conflicts.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop('FAIL: ',label,call.=FALSE);checks<<-checks+1L}
throws<-function(expr)inherits(tryCatch({force(expr);NULL},error=function(e)e),'error')
snapshot<-function()data.frame(path=names(sg_pins),hash=vapply(names(sg_pins),sg_hash,''),
  size=file.info(names(sg_pins))$size,mtime=as.numeric(file.info(names(sg_pins))$mtime))
before<-snapshot();sg_verify()
bad<-sg_pins;bad[1]<-'changed';check(throws(sg_verify(bad)),'pin mismatch blocks processing')
check(throws(sg_verify(setNames('not-a-hash','/nonexistent-phase2i-input'))),'missing input blocks processing')
prior<-new.env(parent=globalenv());sys.source('R/audit_source_defined_cohort.R',envir=prior)
arithmetic<-function(score,S,bo='3')sg_arithmetic(score,S,prior$sa_score,bo)
check(identical(unname(arithmetic('6-4 6-4',20)),c(20,0,20,20,0)),'ordinary game total')
check(identical(unname(arithmetic('7-6(5) 6-4',22)),c(23,1,22,22,0)),'current rule removes one tie-break game')
check(arithmetic('7-6(5) 6-4',23)['discrepancy']==1,'one extra per tie-break')
check(arithmetic('7-6(5) 6-4',24)['discrepancy']==2,'two extras per tie-break')
check(identical(unname(arithmetic('6-7(10) 7-6(8) 6-4',36)),c(36,2,36,34,2)),'tie-break points are not score games')
check(arithmetic('4-6 6-4 6-3',22)['discrepancy']==-7,'signed negative discrepancy')
check(arithmetic('6-0 6-0 6-0',18,'5')['expected']==18,'best-of-five arithmetic')
for(s in c('6-0 RET','4-6 6-4','6-4 4-6 9-7','[10-8]'))
  check(throws(arithmetic(s,20)),'no extension of frozen completion parser')
check(throws(arithmetic('6-0 6-0',NA_real_)),'unknown service count not zero')
check(throws(arithmetic('6-0 6-0',-1)),'negative total invalid')
check(sg_classify(0,0)=='BASELINE_ZERO_TB','zero tie-break equality not convention evidence')
check(sg_classify(0,1)=='BASELINE_WITH_TB','baseline with tie-breaks')
check(sg_classify(2,2)=='ONE_EXTRA_PER_TB','multiple tie-break fit')
check(sg_classify(4,2)=='TWO_EXTRAS_PER_TB','double-extra fit')
check(sg_classify(1,0)=='OTHER_POSITIVE','no-tie-break extra not a tie-break fit')
check(sg_classify(-1,1)=='OTHER_NEGATIVE','negative is unresolved')
check(sg_classify(-7,0,TRUE)=='SAVED_NON_TB_ERROR','exact saved error')
check(throws(sg_classify(-6,0,TRUE)),'saved error does not generalize')
check(sg_labels['ONE_EXTRA_PER_TB']=='ARITHMETICALLY_CONSISTENT_UNVERIFIED','arithmetic cannot promote to supported evidence')
check(!sg_reference()$documented_tb_convention,'no documented provider convention claimed')

x<-sg_rows();r<-sg_summarize(x);d<-r$`discrepancy-summary`;h<-r$`hypothesis-summary`
check(nrow(x)==2818&&sum(x$conflict)==237,'all-237 accounting with full normal denominator')
check(all(x$expected==x$scored_games-x$tiebreaks),'every expected game identity')
check(all(x$discrepancy==x$service_games-x$expected),'every signed discrepancy identity')
check(all(x$service_games[x$pattern=='ONE_EXTRA_PER_TB']==x$scored_games[x$pattern=='ONE_EXTRA_PER_TB']),'all single-extra fits')
check(all(x$service_games[x$pattern=='TWO_EXTRAS_PER_TB']==(x$scored_games+x$tiebreaks)[x$pattern=='TWO_EXTRAS_PER_TB']),'all double-extra fits')
check(all(x$tiebreaks[x$pattern %in% c('ONE_EXTRA_PER_TB','TWO_EXTRAS_PER_TB')]>0),'uninformative zero tie-break cases excluded from hypothesis fits')
check(all(x$event[x$pattern %in% c('ONE_EXTRA_PER_TB','TWO_EXTRAS_PER_TB')] %in% c('Wimbledon','US Open')),'measured event concentration')
check(identical(as.integer(table(factor(x$pattern,levels=sg_patterns))),c(1995L,586L,217L,2L,1L,3L,14L,0L)),'complete pattern partition')
check(identical(as.integer(table(x$discrepancy[x$conflict])),c(1L,1L,2L,2L,1L,1L,1L,6L,175L,36L,10L,1L)),'signed distribution')
check(all(h$evidence_status %in% c('SUPPORTED_BY_SAVED_EVIDENCE','ARITHMETICALLY_CONSISTENT_UNVERIFIED',
  'DEMONSTRATED_SOURCE_ERROR','UNRESOLVED')),'only authorized evidence labels')
check(!any(h$evidence_status=='SUPPORTED_BY_SAVED_EVIDENCE'&h$records>0),'no unsupported positive evidence label')
check(sum(x$evidence_status[x$conflict]=='DEMONSTRATED_SOURCE_ERROR')==1&&sum(x$evidence_status[x$conflict]=='UNRESOLVED')==17,'error versus unresolved split')
for(grouping in unique(d$grouping)) {
  z<-d[d$grouping==grouping,];hh<-h[h$grouping==grouping,]
  check(sum(z$records)==2818&&sum(z$records[z$signed_discrepancy!=0])==237,paste(grouping,'distribution denominator partition'))
  check(sum(hh$records)==2818&&sum(hh$flagged_records)==237,paste(grouping,'hypothesis partition'))
}
# Independent direct filters for every aggregate group's denominators, not selected conflicts.
meta<-unique(d[,c('grouping',sg_dimensions,'normal_denominator','group_conflicts','positive_tb_normal')])
truth<-vapply(seq_len(nrow(meta)),function(i) {
  take<-rep(TRUE,nrow(x))
  for(field in sg_dimensions)if(meta[[field]][i]!='ALL')take<-take & as.character(x[[field]])==meta[[field]][i]
  sum(take)==meta$normal_denominator[i]&&sum(x$conflict[take])==meta$group_conflicts[i]&&
    sum(x$tiebreaks[take]>0)==meta$positive_tb_normal[i]
},TRUE)
check(all(truth),'all group denominators checked against all normal rows')
check(all(d$conflict_rate==d$group_conflicts/d$normal_denominator),'conflict rates use normal denominators')
check(all(d$fraction_of_normal==d$records/d$normal_denominator),'distribution rates use normal denominators')
check(all(d$recorded_service_games_sum-d$current_expected_sum==d$signed_discrepancy_sum),'aggregate arithmetic identity')
check(all(d$signed_discrepancy*d$records==d$signed_discrepancy_sum),'signed-bin sums')
check(all(d$scored_games_sum-d$ordinary_tiebreaks_sum==d$current_expected_sum),'aggregate tie-break identity')
check(length(unique(d$event[d$grouping=='cell']))==10&&nrow(meta[meta$grouping=='cell',])==30,'all authorized cells including zero conflicts')
check(any(d$group_conflicts==0),'zero-conflict groups retained')
check(!any(grepl('player|winner|loser|match_id|source_row|score$|first_server',names(d))) &&
      !any(grepl('player|winner|loser|match_id|source_row|score$|first_server',names(h))),'aggregate schema contains no match identities or player-side expectations')
check(all(h$recommendation=='PRESERVE_CURRENT_EXCLUSION_RULE'),'single terminal recommendation')
check(identical(lapply(r,sg_lines),lapply(sg_summarize(x[nrow(x):1,]),sg_lines)),'aggregate bytes independent of row ordering')
r2<-diagnose_service_game_conflicts(FALSE)
check(identical(lapply(r,sg_lines),lapply(r2,sg_lines)),'independent diagnostic rerun')
local({
  tmp<-tempfile('phase2i-check-',tmpdir=tempdir());dir.create(tmp)
  on.exit(unlink(tmp,recursive=TRUE)) # only test-owned synthetic aggregate fixtures
  a<-file.path(tmp,'a');b<-file.path(tmp,'b');sg_publish(r,a);sg_publish(r2,b)
  hashes<-function(dir)unname(vapply(list.files(dir,full.names=TRUE),sg_hash,''))
  check(identical(hashes(a),hashes(b)),'two byte-identical aggregate files')
  check(length(sg_publish(r,a))==2,'identical existing output accepted')
  changed<-r;changed[[1]]$records[1]<-9999
  check(throws(sg_publish(changed,a)),'changed output refuses overwrite')
  check(identical(hashes(a),hashes(b)),'failed replacement preserves release')
  writeLines('fixture',file.path(a,'unexpected.csv'))
  check(throws(sg_publish(r,a)),'extra file refuses release mutation')
})
check(identical(before,snapshot()),'all pinned inputs including Phase 2H/2F hashes sizes and mtimes unchanged')
paths<-file.path(sg_dir,paste0(sg_outputs,'.csv'))
check(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),paths),'both aggregate outputs ignored')
cat('PASS:',checks,'focused Phase 2I checks\n')
