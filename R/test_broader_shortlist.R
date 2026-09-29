# Focused Phase 2J checks; never runs or repins a historical suite.
source('R/revalidate_broader_shortlist.R')
checks<-0L
check<-function(ok,label) {if(!isTRUE(ok))stop(label,call.=FALSE);checks<<-checks+1L}
close_enough<-function(a,b,tol=1e-10)isTRUE(all.equal(unname(a),unname(b),tolerance=tol,check.attributes=FALSE))
fails<-function(expr)inherits(tryCatch(force(expr),error=identity),'error')
before<-vapply(names(bj_pins),bj_hash,'');bj_verify();check(identical(unname(before),unname(bj_pins)),'Input pins')
e<-bj_helpers()
a<-c(ace=8,df=3,svpt=80,'1stIn'=48,'1stWon'=36,'2ndWon'=17,SvGms=12,bpFaced=6,bpSaved=4)
b<-c(ace=4,df=5,svpt=70,'1stIn'=42,'1stWon'=28,'2ndWon'=13,SvGms=12,bpFaced=8,bpSaved=5)
check(close_enough(bj_side(a,b)$value,c(8/80,36/48,3/32,8/12,3/8)),'Five formulas')
check(close_enough(bj_pair(a,b)[c('NPR','equal_phase_NPR')],c(100*(82-68)/150,100*(53/80-41/70))),'NPR formulas')
check(close_enough(bj_pair(a,b),-bj_pair(b,a)),'Metric slot swap')
b0<-b;b0[c('bpFaced','bpSaved')]<-0
check(is.na(bj_pair(a,b0)['M12']),'No opportunity is undefined')
a0<-a;a0['1stIn']<-a0['svpt'];check(is.na(bj_pair(a0,b)['M05']),'Zero second-serve denominator')
a0<-a;a0['1stIn']<-0;check(is.na(bj_pair(a0,b)['M03']),'Zero first-serve denominator')
check(identical(unname(e$pf_spec()$collinearity),c(.8,.9,.95,5,10,30)),'Registered thresholds unchanged')
u<-scale(sin(seq_len(200)));v<-scale(residuals(lm(cos(seq_len(200))~u)))
for(rho in c(.79,.801,.901,.951,.98,.999)) {
  d<-e$pf_collinearity(cbind(x=u,y=rho*u+sqrt(1-rho^2)*v))
  check(close_enough(d$pearson[1,2],rho),'Controlled Pearson correlation')
  check(close_enough(d$vif,rep(1/(1-rho^2),2)),'VIF identity')
  check(close_enough(max(d$ci),sqrt((1+rho)/(1-rho))),'Condition index identity')
  check(d$correlation_class==if(d$max_correlation>=.95)'NEAR_REDUNDANT' else if(d$max_correlation>=.9)'SENSITIVITY_WARNING' else if(d$max_correlation>=.8)'PRACTICAL_REVIEW' else 'BELOW_REVIEW_BOUNDARY','Correlation precedence')
}
check(e$pf_collinearity(cbind(u,u))$gate=='AUTOMATIC_FAILURE','Rank failure')
check(e$pf_collinearity(cbind(u,rep(1,200)))$gate=='AUTOMATIC_FAILURE','Constant failure')
check(e$pf_collinearity(cbind(u,1+1e-12*v))$gate=='AUTOMATIC_FAILURE','Near-constant failure')
check(!e$pf_ols(cbind(1,u,u),as.numeric(v))$ok,'No generalized inverse')
check(fails(e$pf_increment(.4,.5)),'Negative nested increment rejected')
sep<-e$pf_logistic(cbind(intercept=1,x=seq(-2,2,length.out=100)),rep(c(0,1),each=50))
check(sep$unstable&&sep$witness=='COMPLETE_SEPARATION_WITNESS','Separation warning retained')
cat('Building first complete release in memory\n')
r<-bj_build();x<-r[[1]];cc<-r[[2]];npr<-r[[3]];win<-r[[4]];st<-r[[5]]
check(nrow(x)==2580&&!anyDuplicated(x$match_id),'All admitted neutral rows')
check(identical(as.integer(table(x$tour)),c(846L,1734L)),'Tour membership')
check(sum(x$common_complete)==2428&&sum(!x$common_complete)==152,'Common complete filtering')
check(all(x$exclusion_reason[!x$common_complete]=='M12'),'Only M12 undefined')
check(length(unique(x$cell_id))==30,'All authorized cells')
check(all(is.finite(as.matrix(x[c('M01','M03','M05','M11','NPR','equal_phase_NPR')]))),'Other formulas defined')
check(all(npr$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),'No unsupported intervals')
for(tour in c('ATP','WTA')) {
  z<-x[x$tour==tour&x$common_complete,];ids<-unique(c(z$player_a_id,z$player_b_id))
  check(length(ids)==if(tour=='ATP')189 else 266,'Player inventory')
  for(id in ids) {
    kept<-bj_drop(z,'leave_player',id)
    check(!any(kept$player_a_id==id|kept$player_b_id==id)&&nrow(kept)==sum(z$player_a_id!=id&z$player_b_id!=id),'Both player slots removed')
  }
  for(id in unique(z$cell_id))check(setequal(bj_drop(z,'leave_cell',id)$match_id,z$match_id[z$cell_id!=id]),'Complete event deletion')
  for(set in names(bj_sets)) {
    for(fe in c(FALSE,TRUE)) {
      des<-bj_design(z,bj_sets[[set]],fe,e)$design;y<-z$NPR
      fit<-e$pf_ols(des,y);ref<-lm(y~des[,-1,drop=FALSE])
      check(close_enough(fit$beta,coef(ref))&&close_enough(fit$r2,summary(ref)$r.squared),'Independent full OLS')
      rows<-npr[npr$tour==tour&npr$set==set&npr$kind=='primary'&npr$adjustment==if(fe)'event_cell_FE' else 'none',]
      check(all(rows$n==nrow(z)),'Common sample for both alternatives and outcomes')
      for(term in bj_sets[[set]]) {
        reduced<-des[,colnames(des)!=term,drop=FALSE];rr<-lm(y~reduced[,-1,drop=FALSE])
        actual<-rows$increment[rows$term==term&rows$outcome=='NPR']
        check(close_enough(actual,fit$r2-summary(rr)$r.squared),'Independent reduced-model increment with same controls')
      }
      if(!fe) {
        swapped<-z;swapped[c(bj_metrics,'NPR','equal_phase_NPR')]<--swapped[c(bj_metrics,'NPR','equal_phase_NPR')];swapped$win<-1-z$win
        sd<-bj_design(swapped,bj_sets[[set]],FALSE,e)$design
        f2<-e$pf_ols(sd,-y)
        check(close_enough(fit$beta[-1],f2$beta[-1])&&close_enough(fit$beta[1],-f2$beta[1]),'OLS orientation invariance')
        g1<-e$pf_logistic(des,z$win);g2<-e$pf_logistic(sd,1-z$win)
        check(close_enough(plogis(des%*%g1$beta),1-plogis(sd%*%g2$beta),1e-8),'Logistic orientation complement')
      }
    }
    check(length(unique(st$omitted_or_slice[st$tour==tour&st$set==set&st$kind=='leave_player']))==length(ids),'Every player refitted')
    check(length(unique(st$omitted_or_slice[st$tour==tour&st$set==set&st$kind=='leave_cell']))==length(unique(z$cell_id)),'Every cell refitted')
  }
}
lo<-st[st$kind %in% c('leave_cell','leave_player')&st$outcome!='same_match_win',]
check(all(lo$fit_ok)&!any(lo$sign_reversal|lo$direction_failure|lo$numeric_increment_lost),'Measured NPR deletion stability')
check(!any(cc$gate %in% c('FAIL','AUTOMATIC_FAILURE')),'Measured numerical gates')
check(all(win$converged[win$kind=='primary'])&&!any(win$unstable[win$kind=='primary']),'Primary logistic fits usable')
check(length(unique(st$terminal_decision))==1&&unique(st$terminal_decision)=='S02_PAUSED_FOR_PRESPECIFIED_FAILURE','Measured terminal decision')
# Synthetic decisions isolate precedence, independent of empirical fit rankings.
p<-npr[npr$kind=='primary'&npr$adjustment=='none'&npr$outcome=='NPR',]
check(bj_decide(p)$decision=='BOTH_ALTERNATIVES_REMAIN_PROVISIONAL','Positive primary NPR alone not a selection')
q<-p;q$full_r2[q$set=='S08']<-1;check(bj_decide(q)$decision==bj_decide(p)$decision,'R-squared cannot select')
q<-p;q$direction[q$set=='S02'&q$term=='M01']<-'negative';check(bj_decide(q)$decision=='S02_PAUSED_FOR_PRESPECIFIED_FAILURE','S02 direction failure')
q<-p;q$gate[q$set=='S08']<-'AUTOMATIC_FAILURE';check(bj_decide(q)$decision=='S08_PAUSED_FOR_PRESPECIFIED_FAILURE','S08 rank failure')
q<-p;q$direction[q$term=='M05']<-'positive';check(bj_decide(q)$decision=='SHARED_FACTOR_FAMILY_REVISION_REQUIRED','Shared failure precedence')
q<-p;q$fit_ok<-FALSE;check(bj_decide(q)$decision=='SHARED_FACTOR_FAMILY_REVISION_REQUIRED','Both uncomputable')
check(bj_decide(p,win)$decision=='S02_PAUSED_FOR_PRESPECIFIED_FAILURE','External registered winning direction')
w<-win;w$unstable[w$tour=='ATP'&w$set=='S02']<-TRUE
check(bj_decide(p,w)$decision=='BOTH_ALTERNATIVES_REMAIN_PROVISIONAL','Unstable logistic signs cannot force a pause')
cat('Building independent second release for byte comparison\n')
r2<-bj_build();dir1<-tempfile('phase2j-');dir2<-tempfile('phase2j-')
bj_publish(r,dir1);bj_publish(r2,dir2)
p1<-file.path(dir1,paste0(bj_outputs,'.csv'));p2<-file.path(dir2,paste0(bj_outputs,'.csv'))
check(identical(unname(vapply(p1,bj_hash,'')),unname(vapply(p2,bj_hash,''))),'Byte-identical independent reruns')
check(all(file.info(p1)$size>0),'Five nonempty outputs')
bj_publish(r,dir1);bad<-r;bad[[1]]$win[1]<-1-bad[[1]]$win[1]
check(fails(bj_publish(bad,dir1)),'Existing differing release preserved')
check(identical(vapply(names(bj_pins),bj_hash,''),before),'All pinned history unchanged')
saveRDS(r,'/private/tmp/phase2j-tested.rds')
cat(sprintf('PASS: %d focused checks; independent full reruns byte-identical.\n',checks))
