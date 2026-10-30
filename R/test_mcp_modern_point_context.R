source('R/build_mcp_modern_point_context.R')
checks<-0L
check<-function(ok,label){checks<<-checks+length(ok);if(anyNA(ok)||!all(ok))stop(label)}
fixture<-function(scores,winners,server=rep('1',length(scores)))data.frame(Pt=as.character(seq_along(scores)),
 Set1='0',Set2='0',Gm1='0',Gm2='0',Svr=server,Pts=scores,PtWinner=as.character(winners),`Gm#`='1',check.names=FALSE)
scores<-c('0-0','0-15','0-30','0-40','15-40','30-40','40-40','40-AD','40-40','AD-40','40-40','40-AD')
d<-fixture(scores,c(2,2,2,1,1,1,2,1,1,2,2,2));z<-ctx_replay(d,'3','1')
check(z$replay_status=='PASS','Independent deuce/advantage score agreement')
check(identical(which(z$break_point),c(4L,5L,6L,8L,12L)),'All repeated opportunities, not conversions')
for(j in seq_len(nrow(d))){v<-d;v$PtWinner[j:nrow(d)]<-as.character(3L-as.integer(v$PtWinner[j:nrow(d)]));q<-ctx_replay(v,'3','1');check(identical(z[j,3:9],q[j,3:9]),'Current/later outcomes cannot enter prepoint context')}
v<-d;v$Pts[3]<-'bogus';q<-ctx_replay(v,'3','1');check(all(is.na(q$break_point[3:nrow(q)])),'Conflict prefix fails closed')
check(all(is.na(ctx_replay(d,'9','X')$break_point)),'Unsupported format unknown')
# Twelve hold games then a tiebreak, with independently specified game/server labels.
rows<-list()
for(g in 0:11){sv<-1+g%%2;rows[[length(rows)+1]]<-data.frame(Pt=as.character(g*4+1:4),Set1='0',Set2='0',
 Gm1=as.character(ceiling(g/2)),Gm2=as.character(floor(g/2)),Svr=as.character(sv),Pts=c('0-0','15-0','30-0','40-0'),PtWinner=as.character(sv),`Gm#`=as.character(g+1),check.names=FALSE)}
tb<-data.frame(Pt=c('49','50'),Set1='0',Set2='0',Gm1='6',Gm2='6',Svr=c('1','2'),Pts=c('0-0','0-1'),PtWinner='1',`Gm#`='13',check.names=FALSE)
q<-ctx_replay(rbind(do.call(rbind,rows),tb),'3','1');check(all(q$replay_status=='PASS'),'Independent tiebreak replay');check(all(q$tiebreak[49:50])&&!any(q$break_point[49:50]),'Tiebreaks excluded')
check(!any(ctx_source_bp(c('0-40','0-99'),c(TRUE,TRUE))),'Numeric tie scores not break points')
raw<-c('ACE','DOUBLE_FAULT','WINNER','FORCED_ERROR','UNFORCED_ERROR','POINT_PENALTY','UNRETURNABLE','BOGUS')
t<-ctx_terminal(raw,raw,rep('A',8));check(identical(t$ending_type,ctx_types),'Exclusive recorded type mapping')
check(t$terminal_actor_slot[6]=='NONPHYSICAL','Administration nonphysical')
check(ctx_terminal('WINNER','ACE','B')$ending_status=='UNKNOWN','Terminal authority disagreement unknown')
check(ctx_perspective('Forced error','A','A')=='Selected player error','Selected error actor')
check(ctx_perspective('Ace','A','B')=='Opponent winner','Opponent winner actor')
check(ctx_perspective('Other supported ending','A','A')=='Selected player supported ending','No forced error invented')
frozen_only<-'--verify-frozen'%in%commandArgs(TRUE)
if(frozen_only)ctx_verify()
r<-if(frozen_only)setNames(lapply(paste0(ctx_prefix,ctx_outputs,'.csv'),function(p)read.csv(p,stringsAsFactors=FALSE,na.strings='')),ctx_outputs) else ctx_build();if(!frozen_only)ctx_install(r);p<-r[['point-dispositions']];pp<-r[['match-player-profiles']];tt<-r[['phase-terminal-profiles']];cv<-r$coverage
check(nrow(p)==243127&&!anyDuplicated(p$point_id),'Every inventory point once')
check(sum(p$included)==174460&&sum(!p$completion_eligible)==6260&&sum(p$completion_eligible&!p$qa_valid)==62407,'Frozen eligibility unchanged')
known<-!is.na(p$break_point);check(p$break_point[known]==p$source_break_point[known]&p$break_point[known]==p$replay_break_point[known],'Independent source/replay BP agreement')
check(!any(p$break_point[p$tiebreak%in%TRUE],na.rm=TRUE),'All observed tiebreaks excluded')
check(p$ending_status[!p$included]=='WITHHELD','No context rescue')
check(p$ending_type%in%ctx_types,'Exactly one ending classification')
physical<-p$included&p$ending_type%in%c('Ace','Double fault','Other annotated winner','Forced error','Unforced error')
check(p$terminal_actor_slot[physical]%in%c('A','B'),'Explicit terminal actors')
win<-p$included&p$ending_type%in%c('Ace','Other annotated winner');err<-p$included&p$ending_type%in%c('Double fault','Forced error','Unforced error')
check(p$terminal_actor_slot[win]==p$winner_slot[win],'Winner actor independent outcome reconciliation')
check(p$terminal_actor_slot[err]!=p$winner_slot[err],'Error actor independent outcome reconciliation')
check(pp$wins+pp$losses==ifelse(pp$measure=='POINT_ENDING',pp$phase_points,pp$reached),'Win/loss partitions')
check(abs(pp$subset_inventory_fraction-pp$subset_points/pp$inventory_points)<1e-14,'Subset inventory fraction label within CSV precision')
check(cv$break_points_faced+cv$break_opportunities_receiving==cv$included_break_points,'Role partition')
for(ii in split(seq_len(nrow(pp)),paste(pp$aggregation_level,pp$category,pp$match_id,pp$player,pp$subset,sep='|'))){z<-pp[ii,];e<-z[z$measure=='POINT_ENDING',];check(sum(e$phase_points)==z$subset_points[1],'Subset phase accounting');if(z$subset_points[1]==0)check(all(is.na(e$phase_share)),'Zero opportunity undefined')}
check(abs(tt$subset_share-tt$points/tt$subset_denominator)<1e-14,'Pooled subset denominators')
check(abs(tt$phase_share-tt$points/tt$phase_denominator)<1e-14,'Within-phase denominators')
# Slot swap changes perspective, never count or BP context.
for(type in ctx_types[1:5])check(ctx_perspective(type,'A','A')==ctx_perspective(type,'B','B'),'Neutral relabeling invariance')
for(cat in c('ATP','WTA'))for(sub in c('ALL_INCLUDED','BREAK_POINTS')) {
 z<-pp[pp$category==cat&pp$subset==sub&pp$measure=='POINT_ENDING',]
 check(sum(z$phase_points[z$aggregation_level=='MATCH_PLAYER'])==sum(z$phase_points[z$aggregation_level=='POOLED_PLAYER']),'Pool counts, not percentages')
}
# Independent comparison with historical all-point values, keyed without relying on row order.
old<-read.csv(paste0(modern_prefix,'match-player-profiles.csv'),stringsAsFactors=FALSE,na.strings='')
key<-function(z)paste(z$aggregation_level,z$category,z$match_id,z$player,z$measure,z$role,z$phase,sep='|')
a<-pp[pp$subset=='ALL_INCLUDED',];j<-match(key(a),key(old));check(!anyNA(j),'Every original all-point profile retained')
for(f in c('phase_points','wins','losses','win_share','loss_share','phase_share','reached','known_absent','unknown_reach','reach_share','conditional_win_rate','conditional_denominator')) {
 u<-a[[f]];v<-old[[f]][j];check((is.na(u)==is.na(v)) & (is.na(u)|abs(u-v)<1e-14),paste('Original all-point field within CSV precision',f))
}
# Reconstruct match and pooled endings directly from the point ledger, independent of profile helper.
for(level in c('MATCH_PLAYER','POOLED_PLAYER')) {
 x<-rbind(transform(p,player=player_a,slot='A'),transform(p,player=player_b,slot='B'))
 k<-if(level=='MATCH_PLAYER')paste(x$category,x$match_id,x$player,sep='|') else paste(x$category,x$player,sep='|')
 groups<-split(seq_len(nrow(x)),k)
 e<-pp[pp$aggregation_level==level & pp$measure=='POINT_ENDING',]
 ek<-if(level=='MATCH_PLAYER')paste(e$category,e$match_id,e$player,sep='|') else paste(e$category,e$player,sep='|')
 for(ii in split(seq_len(nrow(e)),ek)) {
  z<-e[ii,];u<-x[groups[[ek[ii[1]]]],];u<-u[u$included,]
  for(sub in c('ALL_INCLUDED','BREAK_POINTS')) {
   v<-if(sub=='ALL_INCLUDED')u else u[!is.na(u$break_point)&u$break_point,];w<-z[z$subset==sub,]
   for(i in seq_len(nrow(w))) {
    vphase<-v[v$terminal_phase==w$phase[i],]
    check(w$phase_points[i]==nrow(vphase)&&w$wins[i]==sum(vphase$slot==vphase$winner_slot)&&w$losses[i]==sum(vphase$slot!=vphase$winner_slot),'Independent phase/slot reconstruction')
   }
  }
 }
}
# Every phase/type/actor cell reconciles to the independently checked profile partition.
fields<-c('aggregation_level','category','match_id','player','subset','phase')
group_key<-function(z)do.call(paste,c(z[fields],sep='|'))
e<-pp[pp$measure=='POINT_ENDING',]
ag<-aggregate(tt[c('points','wins','losses')],tt[fields],sum)
j<-match(group_key(e),group_key(ag))
for(pair in list(c('points','phase_points'),c('wins','wins'),c('losses','losses'))){n<-ag[[pair[1]]][j];n[is.na(n)]<-0;check(n==e[[pair[2]]],'Exclusive type/actor/phase reconciliation')}
check(tt$wins+tt$losses==tt$points,'Terminal cell win/loss partition')
shares<-aggregate(tt$phase_share,tt[fields],sum);check(abs(shares$x-1)<1e-14,'Complete phase-type distribution')
# Actual player-slot relabeling and point permutations preserve selected-player profiles.
mini<-head(p[p$included,],40)
reach_fields<-c('point_id','return_reach','plus1_reach','later_rally_reach','included','completion_eligible','qa_valid','terminal_phase');columns<-names(read.csv(paste0(modern_prefix,'point-dispositions.csv'),nrows=0));old_reach<-read.csv(paste0(modern_prefix,'point-dispositions.csv'),colClasses=ifelse(columns%in%reach_fields,'character','NULL'),na.strings=NULL)
for(f in c('included','completion_eligible','qa_valid','terminal_phase'))check(as.character(p[[f]])==old_reach[[f]][match(p$point_id,old_reach$point_id)],paste('Exact per-point historical boundary',f))
for(f in c('return_reach','plus1_reach','later_rally_reach'))mini[[f]]<-old_reach[[f]][match(mini$point_id,old_reach$point_id)]
swapped<-mini
swapped$player_a<-mini$player_b;swapped$player_b<-mini$player_a
flip<-function(x)ifelse(x=='A','B',ifelse(x=='B','A',x))
for(f in c('server_slot','receiver_slot','winner_slot','terminal_actor_slot'))swapped[[f]]<-flip(mini[[f]])
canonical<-function(z){fields<-setdiff(names(z),'slot');z<-z[,fields];z<-z[do.call(order,c(z[intersect(c('aggregation_level','category','match_id','player','subset','measure','role','phase','ending_type','actor_perspective'),names(z))],list(method='radix'))),];rownames(z)<-NULL;z}
a<-ctx_tables(mini);b<-ctx_tables(swapped);c<-ctx_tables(mini[rev(seq_len(nrow(mini))),])
for(f in names(a)){check(identical(canonical(a[[f]]),canonical(b[[f]])),'Full neutral-slot swap invariance');check(identical(canonical(a[[f]]),canonical(c[[f]])),'Point permutation invariance')}
# Known BP inventory is partitioned into included, completion excluded and QA withheld.
check(cv$inventory_break_points==cv$included_break_points+cv$completion_excluded_break_points+cv$qa_withheld_break_points,'BP retention partition')
if(!frozen_only)ctx_install(r)
# Independent build; original outputs refuse any differing bytes before installation.
if(!frozen_only || '--rerun'%in%commandArgs(TRUE)){s<-ctx_build();tmp<-paste0(tempfile('context-rerun-',tmpdir='data/pilot'),'-');ctx_install(s,tmp)
for(k in ctx_outputs){path<-paste0(tmp,k,'.csv');check(mcp_sha(path)==mcp_sha(paste0(ctx_prefix,k,'.csv')),'Independent byte-identical rerun');unlink(path)}
}
check(all(vapply(paste0(ctx_prefix,ctx_outputs,'.csv'),function(p)system2('git',c('check-ignore','-q',shQuote(p)))==0L,FALSE)),'Ignored outputs')
cat('Focused context tests:',checks,'PASS\n')
