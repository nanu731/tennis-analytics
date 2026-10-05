# Phase 2AN focused checks: LMG/Shapley arithmetic, reuse of Phase 2J reconstruction, split isolation, stability, verdict and release.
source('R/run_2an_factor_weights.R')
n<-0L
ok<-function(z,label){n<<-n+1L;if(!isTRUE(z))stop('CHECK FAILED: ',label,call.=FALSE)}
fail<-function(expr,pattern){z<-tryCatch({force(expr);NULL},error=identity);ok(inherits(z,'error')&&grepl(pattern,conditionMessage(z),fixed=TRUE),pattern)}
eq<-function(a,b,tol=1e-10)isTRUE(all.equal(a,b,tolerance=tol,check.attributes=FALSE))
e<-an_helpers()
# Pins and scope guards.
for(p in names(an_pins))ok(an_hash(p)==an_pins[[p]],paste('pin',p));bad<-an_pins;bad[1]<-'bad';fail(an_verify(bad),'mismatch')
src<-paste(readLines('R/run_2an_factor_weights.R'),collapse='\n');ok(!grepl('2025-|final-test|feature-elo|locked-evaluation',src),'runner names no 2025 input')
ok(length(an_permutations(c('a','b','c','d')))==24&&!anyDuplicated(vapply(an_permutations(letters[1:4]),paste,'',collapse=''))&&length(an_permutations(1:3))==6,'all k! orderings')
# LMG against an independent subset-weight Shapley formula computed with lm().
r2<-function(d,terms,y)if(!length(terms))0 else summary(lm(reformulate(terms,y),d))$r.squared
shapley<-function(d,terms,y){k<-length(terms);vapply(terms,function(j){o<-setdiff(terms,j);tot<-0
 for(m in 0:length(o))for(S in if(m)combn(o,m,simplify=FALSE) else list(character())){w<-factorial(m)*factorial(k-m-1)/factorial(k);tot<-tot+w*(r2(d,c(S,j),y)-r2(d,S,y))};tot},0.0)}
set.seed(42);X<-matrix(rnorm(1200),300,4);X[,2]<-X[,2]+.6*X[,1];d<-as.data.frame(X);names(d)<-an_sets$full;d$NPR<-as.vector(X%*%c(3,-1,2,1.5))+rnorm(300,sd=2)
f<-an_fit(d,an_sets$full,'NPR',e)
ok(eq(sum(f$lmg_r2),f$full_r2[1],1e-12)&&eq(sum(f$share_pct),100,1e-12),'LMG sums to R-squared; shares to 100')
ok(eq(f$lmg_r2,shapley(d,an_sets$full,'NPR'),1e-12),'ordering average equals subset Shapley formula')
ok(eq(f$coefficient,unname(coef(lm(NPR~.,data.frame(scale(d[an_sets$full]),NPR=d$NPR)))[-1]),1e-12),'NPR points per training-sample SD')
ok(eq(f$semi_partial_r2,vapply(an_sets$full,function(j)f$full_r2[1]-r2(d,setdiff(an_sets$full,j),'NPR'),0.0),1e-12),'semi-partial increments')
g<-an_fit(d,rev(an_sets$full),'NPR',e);ok(eq(g$lmg_r2[match(f$term,g$term)],f$lmg_r2,1e-12),'term order invariance')
h<-d;h$M03<-10*h$M03+5;h$M11<-h$M11/7-3;g<-an_fit(h,an_sets$full,'NPR',e);ok(eq(g$lmg_r2,f$lmg_r2,1e-12)&&eq(g$coefficient,f$coefficient,1e-10),'affine predictor invariance')
h<-d;h[an_sets$full]<--h[an_sets$full];h$NPR<--h$NPR;g<-an_fit(h,an_sets$full,'NPR',e);ok(eq(g$lmg_r2,f$lmg_r2,1e-12)&&eq(g$coefficient,f$coefficient,1e-10),'global slot swap invariance')
Q<-qr.Q(qr(scale(matrix(rnorm(800),200,4),scale=FALSE)));o<-as.data.frame(Q);names(o)<-an_sets$full;o$NPR<-as.vector(Q%*%c(4,1,2,3))+rnorm(200,sd=.05)
g<-an_fit(o,an_sets$full,'NPR',e);ok(eq(g$lmg_r2,vapply(an_sets$full,function(j)cor(o[[j]],o$NPR)^2,0.0),1e-10),'orthogonal predictors receive their own r-squared')
r3<-an_fit(d,an_sets$reduced,'NPR',e);ok(nrow(r3)==3&&eq(r3$lmg_r2,shapley(d,an_sets$reduced,'NPR'),1e-12),'reduced set uses 3! orderings')
h<-d;h$M12<-h$M03;g<-an_fit(h,an_sets$full,'NPR',e);ok(!any(g$fit_ok)&&all(is.na(g$share_pct))&&g$gate[1]=='AUTOMATIC_FAILURE','rank failure yields no fabricated shares')
# Real samples: Phase 2J reconstruction reused exactly; development and 2024 kept apart; no imputation.
x<-an_load(e);dev<-x[x$split=='development',];val<-x[x$split=='validation_2024',]
dm<-e$bj_read('data/pilot/source-defined-cohort-admission/cohort-membership.csv');dd<-e$bj_read('data/pilot/source-defined-cohort-admission/row-dispositions.csv');dd<-dd[match(dm$match_id,dd$match_id),]
b<-dev[setdiff(names(dev),'split')];a<-an_rows(dm,dd,e);ok(identical(names(a),names(b))&&isTRUE(all.equal(a,b,check.attributes=FALSE,tolerance=0)),'2024 row builder reproduces frozen Phase 2J development samples exactly')
ok(nrow(dev)==2580&&all(table(dev$tour[dev$common_complete])==c(773,1655))&&nrow(val)==1901&&all(table(val$tour)==c(944,957)),'cohort counts')
ok(all(x$common_complete==(is.finite(x$M12)&is.finite(x$M03)&is.finite(x$M05)&is.finite(x$M11)&is.finite(x$NPR)&is.finite(x$equal_phase_NPR)))&&all(is.na(x$M12)==(x$a_M12_den==0|x$b_M12_den==0)),'complete cases only; zero opportunities undefined')
ok(eq(val$M03,val$a_M03_num/val$a_M03_den-val$b_M03_num/val$b_M03_den,1e-12)&&eq(val$M05,val$a_M05_num/val$a_M05_den-val$b_M05_num/val$b_M05_den,1e-12),'2024 differences from pooled same-match counts')
r<-an_build(x,e);w<-r$weights;st<-r$stability;dg<-r$diagnostics;dr<-r[['dropped-rows']]
ok(identical(names(r),an_outputs)&&all(vapply(r,function(z)all(z$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'&z$version=='2AN-1.0.0'&grepl('NOT_CAUSAL',z$interpretation)),TRUE)),'labels on every output')
for(t in an_tours)for(s in c('development','validation_2024')){z<-x[x$tour==t&x$split==s,];q<-dr[dr$tour==t&dr$split==s,]
 ok(sum(q$rows)==nrow(z)&&q$rows[q$reason=='COMPLETE']==sum(z$common_complete)&&all(q$imputed==0),paste('dropped-row accounting',t,s))}
# Headline development fit uses development rows only and reproduces committed Phase 2J S08 values.
for(t in an_tours){p<-w[w$tour==t&w$split=='development'&w$kind=='primary'&w$set=='full'&w$outcome=='NPR',];z<-dev[dev$tour==t&dev$common_complete,]
 ok(p$n[1]==nrow(z)&&isTRUE(all.equal(p[c('coefficient','lmg_r2','full_r2')],an_fit(z,an_sets$full,'NPR',e)[c('coefficient','lmg_r2','full_r2')],tolerance=0,check.attributes=FALSE)),paste('development-only headline',t))
 ok(eq(p$lmg_r2,shapley(z,an_sets$full,'NPR'),1e-10),paste('headline Shapley independent',t))}
j<-list(ATP=c(4.802600,-0.978541,5.414708,3.989444,.873445,.064056,.006606,.089385,.086590),WTA=c(6.595559,-1.448609,6.294356,4.653717,.895899,.069265,.009638,.071449,.064309))
for(t in an_tours){p<-w[w$tour==t&w$split=='development'&w$kind=='primary'&w$set=='full'&w$outcome=='NPR',];ok(all(abs(c(p$coefficient,p$full_r2[1],p$semi_partial_r2)-j[[t]])<=1e-6),paste('Phase 2J S08 reproduction',t))}
oot<-st[st$record_type=='OUT_OF_TIME',];vv<-x;i<-vv$split=='validation_2024';set.seed(3);vv$NPR[i]<-sample(vv$NPR[i]);o2<-an_out_of_time(vv,e)
ok(identical(oot$development_r2[oot$outcome=='NPR'],o2$development_r2[o2$outcome=='NPR'])&&any(abs(oot$heldout_2024_r2[oot$outcome=='NPR']-o2$heldout_2024_r2[o2$outcome=='NPR'])>1e-3),'2024 outcomes never enter development fit; positive control on held-out R-squared')
for(k in seq_len(nrow(oot))){t<-oot$tour[k];terms<-an_sets[[oot$set[k]]];a<-dev[dev$tour==t&dev$common_complete,];b<-val[val$tour==t&val$common_complete,];m<-lm(reformulate(terms,oot$outcome[k]),a)
 y<-b[[oot$outcome[k]]];ok(eq(oot$heldout_2024_r2[k],1-sum((y-predict(m,b))^2)/sum((y-mean(y))^2),1e-10),'held-out R-squared independent, not truncated')}
# Every context: correct deletion rows, recomputed standardization, LMG identity.
fits<-w[!duplicated(w[c('tour','split','kind','slice','set','outcome')]),]
for(k in which(fits$kind %in% c('leave_player','leave_event','season','surface'))){q<-fits[k,];z<-x[x$tour==q$tour&x$split==q$split&x$common_complete,]
 keep<-switch(q$kind,leave_player=z$player_a_id!=q$slice&z$player_b_id!=q$slice,leave_event=z$event!=q$slice,season=z$season==q$slice,surface=z$surface==q$slice);ok(sum(keep)==q$n,'context rows (player removed from either slot)')}
agg<-aggregate(cbind(lmg_r2,share_pct)~tour+split+kind+slice+set+outcome,w[w$fit_ok,],sum);g<-merge(agg,fits[c('tour','split','kind','slice','set','outcome','full_r2')])
ok(all(abs(g$lmg_r2-g$full_r2)<1e-12)&&all(abs(g$share_pct-100)<1e-10),'every context LMG sums to R-squared')
set.seed(8);for(k in sample(which(fits$kind=='leave_player'),10)){q<-fits[k,];z<-x[x$tour==q$tour&x$split==q$split&x$common_complete&x$player_a_id!=q$slice&x$player_b_id!=q$slice,]
 ok(isTRUE(all.equal(w[w$tour==q$tour&w$split==q$split&w$kind==q$kind&w$slice==q$slice&w$set==q$set&w$outcome==q$outcome,'coefficient'],an_fit(z,an_sets[[q$set]],q$outcome,e)$coefficient,tolerance=0)),'deletion refit rescales on retained rows')}
ok(nrow(fits)==sum(vapply(an_tours,function(t)sum(vapply(c('development','validation_2024'),function(s){z<-x[x$tour==t&x$split==s&x$common_complete,];1+length(unique(z$season))+length(unique(z$surface))+length(unique(z$event))+length(unique(c(z$player_a_id,z$player_b_id)))},0)),0))*4,'every planned context fitted')
# Stability summary and verdict.
ts<-st[st$record_type=='TERM_STABILITY',];zero<-e$pf_spec()$increment_numeric_zero
for(k in seq_len(nrow(ts))){q<-ts[k,];s<-w[w$tour==q$tour&w$set==q$set&w$outcome==q$outcome&w$term==q$term,]
 ok(q$all_contexts==nrow(s)&&identical(as.logical(q$stable),!any(s$direction!=s$expected_direction)&&!any(is.na(s$semi_partial_r2)|s$semi_partial_r2<=zero)&&!any(!s$fit_ok|s$gate %in% c('FAIL','AUTOMATIC_FAILURE'))),'stability recomputed')}
mk<-function(atp,wta)data.frame(tour=rep(an_tours,each=4),set='full',outcome='NPR',term=rep(an_sets$full,2),stable=c(an_sets$full %in% atp,an_sets$full %in% wta))
ok(an_verdict(mk(an_sets$full,an_sets$full))$label=='FOUR_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR','verdict four')
v<-an_verdict(mk(an_sets$reduced,an_sets$full));ok(v$label=='THREE_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR'&&v$stable_both_tours=='M03;M11;M12'&&v$unstable_terms=='M05','verdict three in one tour')
ok(an_verdict(mk(c('M05','M11','M12'),an_sets$reduced))$label=='FEWER_THAN_THREE_STABLE_FACTORS_ON_NPR','verdict uses factors stable in both tours')
ok(an_verdict(mk(character(),character()))$label=='FEWER_THAN_THREE_STABLE_FACTORS_ON_NPR','verdict none')
ok(identical(st$label[st$record_type=='FACTOR_VERDICT'],an_verdict(ts)$label),'installed verdict follows rule')
# Uncertainty feasibility: joint event-player components.
z<-data.frame(event=c('E1','E1','E2'),player_a_id=c('P1','P2','P3'),player_b_id=c('P2','P1','P4'));ok(an_components(z)$components==2,'disjoint blocks counted')
z$player_b_id[3]<-'P1';ok(an_components(z)$components==1,'shared player joins events')
u<-dg[dg$record_type=='UNCERTAINTY_FEASIBILITY',];ok(nrow(u)==4&&all(u$uncertainty=='UNCERTAINTY_NOT_ESTABLISHED'),'feasibility recorded, no interval emitted')
ok(!any(grepl('interval|p_value|ci_low|ci_high',names(w)))&&!any(grepl('interval|p_value',names(st))),'no interval or p-value columns')
# Atomic install and an independent byte-identical rebuild.
tmp<-tempfile('an-test-');dir.create(tmp);rel<-file.path('data/pilot',basename(tempfile('.2an-test-')))
fail(an_install(r,file.path(tmp,'not-ignored')),'already be ignored')
fail(an_install(r,rel,function(stage)stop('interrupted')),'interrupted');ok(!dir.exists(rel),'no partial installation')
fail(an_install(r,rel,function(stage)cat('x',file=file.path(stage,'weights.csv'),append=TRUE)),'Staged bytes changed');ok(!dir.exists(rel),'corrupt stage not installed')
an_install(r,rel);hashes<-vapply(file.path(rel,paste0(an_outputs,'.csv')),an_hash,'');an_install(r,rel);ok(identical(hashes,vapply(file.path(rel,paste0(an_outputs,'.csv')),an_hash,'')),'identical reinstall retained')
q<-r;q$weights$share_pct[1]<-0;fail(an_install(q,rel),'Existing release differs');ok(identical(hashes,vapply(file.path(rel,paste0(an_outputs,'.csv')),an_hash,'')),'existing release preserved');unlink(rel,recursive=TRUE)
script<-file.path(tmp,'rerun.R');writeLines(c("source('R/run_2an_factor_weights.R')","r<-run_2an_factor_weights(FALSE)",sprintf("for(k in names(r))write.table(r[[k]],file.path(%s,paste0(k,'.csv')),sep=',',row.names=FALSE,quote=TRUE,na='NA',eol='\\n',qmethod='double')",deparse(tmp))),script)
ok(system2(file.path(R.home('bin'),'Rscript'),shQuote(script))==0,'independent process')
ok(identical(unname(hashes),unname(vapply(file.path(tmp,paste0(an_outputs,'.csv')),an_hash,''))),'four independent byte-identical files')
unlink(tmp,recursive=TRUE);an_verify();ok(TRUE,'inputs unchanged')
cat(n,'Phase 2AN checks passed\n')
