# Descriptive modern cohort; reuse scientific helpers without changing history.
source('R/build_mcp_point_phase_profiles.R')
modern_prefix <- 'data/pilot/mcp-modern-point-phase-v1-'
modern_release <- 'MCP_MODERN_POINT_PHASE_PROFILES_1.0.0'
modern_specification_pin <- '4adf874d8643b12e1b60b044cc79147e34795dfa6b5e5fe01d80c233631b6732'
modern_outputs <- c('selection-dispositions.csv','period-inventory.csv','player-exposure.csv',
 'actions.csv','action-states.csv','serve-plus1.csv','match-completion.csv',
 'point-dispositions.csv','match-player-profiles.csv','coverage.csv','parser-failures.csv',
 'point-ending-prototype.svg','opportunity-prototype.svg')
modern_pins <- c(
 'R/build_mcp_point_phase_profiles.R'='52a10ebbd47e396ded8023afa023861f0eb7fdea76935e0c1e4509a2b6d4a1df',
 'R/freeze_mcp_broader_return_protocol.R'='97b8588509e9da65ca99d5a4f1c94579e154d3ccd21da903e2eeb2e341dcaf3b',
 'docs/where-players-win-points-plan.md'='e17273f4a5930dd21bd56ad96c83ae8aae14994923c36107953fd5c335fa5fca')
modern_verify <- function() {
 repeat_verify()
 for(f in names(modern_pins))mcp_need(mcp_sha(f)==modern_pins[[f]],paste('Frozen phase authority changed:',f))
 invisible(TRUE)
}
modern_spec <- function() {
 x<-readLines('docs/modern-point-phase-profiles.md',warn=FALSE)
 k<-match('## Measured release',x);mcp_need(!is.na(k),'Missing frozen specification boundary')
 x<-head(x,k-1L);while(length(x)&&tail(x,1)=='')x<-head(x,-1L)
 f<-tempfile();on.exit(unlink(f));writeLines(x,f);pin<-mcp_sha(f)
 mcp_need(pin==modern_specification_pin,'Prospective modern specification changed; stop');pin
}
modern_select <- function(x) {
 d<-repeat_context(x)
 year<-suppressWarnings(as.integer(substr(d$Date,1,4)))
 in_period<-!is.na(year)&year>=2021L&year<=2025L
 d$period_disposition<-ifelse(is.na(year),'DATE_PERIOD_UNKNOWN',ifelse(in_period,'IN_SELECTED_PERIOD','OUTSIDE_SELECTED_PERIOD'))
 d$sample_selected<-in_period&d$context_eligible
 d$selected_by<-ifelse(d$sample_selected,'ALL_CONTEXT_ELIGIBLE_2021_2025','')
 d$disposition<-ifelse(d$sample_selected,'SELECTED_CONTEXT_CHART',ifelse(!in_period,d$period_disposition,'CONTEXT_EXCLUDED'))
 d<-d[order(d$tour_file,d$source_row,d$match_id,method='radix'),];rownames(d)<-NULL
 s<-d[d$sample_selected,];s<-s[order(s$tour_file,s$Date,s$match_id,method='radix'),];rownames(s)<-NULL
 mcp_need(nrow(s)>0&&!anyDuplicated(s$match_id),'Selected match identity collision or empty cohort')
 mcp_need(all(s$player_a!=s$player_b)&all((s$player_a==s$player1&s$player_b==s$player2)|(s$player_a==s$player2&s$player_b==s$player1)),
          'Unresolved literal player/neutral-slot identity collision')
 list(dispositions=d,sample=s)
}
modern_exposure <- function(x) {
 d<-repeat_context(x);year<-suppressWarnings(as.integer(substr(d$Date,1,4)))
 rows<-list();players<-list()
 for(start in c(2021L,2016L))for(category in c('ATP','WTA')) {
  take<-!is.na(year)&year>=start&year<=2025L&d$context_eligible&d$tour_file==category
  z<-d[take,];mcp_need(nrow(z)>0,'Empty candidate metadata period')
  p<-do.call(rbind,lapply(sort(unique(c(z$player1,z$player2)),method='radix'),function(player) {
   m<-z[z$player1==player|z$player2==player,]
   data.frame(period_start=start,period_end=2025L,category,player,matches=nrow(m),
    batches=length(unique(m$Date)),events=length(unique(m$event_label)),years=length(unique(substr(m$Date,1,4))),
    surfaces=length(unique(m$Surface)),opponents=length(unique(ifelse(m$player1==player,m$player2,m$player1))),
    first_source_date=min(m$Date),last_source_date=max(m$Date),stringsAsFactors=FALSE)
  }))
  players[[length(players)+1L]]<-p
  rows[[length(rows)+1L]]<-data.frame(period_start=start,period_end=2025L,category,charts=nrow(z),points=sum(z$points),
   identities=nrow(p),recurring=sum(p$batches>=2L),single_batch=sum(p$batches==1L),
   median_matches=median(p$matches),max_matches=max(p$matches),multi_event=sum(p$events>=2L),
   multi_year=sum(p$years>=2L),date_batches=length(unique(z$Date)),stringsAsFactors=FALSE)
 }
 p<-do.call(rbind,players);p$display_selected<-FALSE
 display<-vapply(c('ATP','WTA'),function(category)sort(p$player[p$period_start==2021L&p$category==category&p$batches>=2L],method='radix')[1L],'')
 mcp_need(!anyNA(display),'Missing recurring display identity')
 p$display_selected<-p$period_start==2021L & p$player==display[p$category]
 p<-p[order(p$period_start,p$category,p$player,method='radix'),];rownames(p)<-NULL
 list(period=do.call(rbind,rows),players=p,display=display)
}
modern_metadata <- function(x,pin) {
 if('release'%in%names(x))x$component_release<-x$release
 # Empty reason tables retain their schema without inventing a row.
 x$release<-rep(modern_release,nrow(x));x$revision<-rep(mcp_revision,nrow(x));x$specification_sha256<-rep(pin,nrow(x))
 x$period<-rep('2021_2025',nrow(x));x$phase_definition_release<-rep('MCP_POINT_PHASE_PROFILES_1.0.0',nrow(x))
 x$claim<-rep('DESCRIPTIVE_OBSERVED_PHASES_NOT_RANKING_SKILL_CAUSAL_OR_FACTORS',nrow(x))
 x$category_basis<-rep('HISTORICAL_MENS_WOMENS_CATEGORIES_NOT_CERTIFIED_TOURS',nrow(x))
 x$chronology<-rep('SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY',nrow(x))
 x$exposure<-rep('ALL_ACQUIRED_YEARS_EXPOSED_2026_OUTSIDE_THIS_COHORT',nrow(x))
 x$uncertainty<-rep('UNCERTAINTY_NOT_ESTABLISHED',nrow(x));rownames(x)<-NULL;x
}
modern_parse <- function(input) {
 # Single-chart calls can have no failures: vectorize metadata only, not parsing.
 f<-action_build;b<-body(f)
 k<-which(vapply(as.list(b),function(x)grepl('for (k in names(r))',paste(deparse(x),collapse=' '),fixed=TRUE),FALSE))
 mcp_need(length(k)==1L,'Frozen parser metadata loop changed')
 b[[k]]<-quote(for(k in names(r)) {
  r[[k]]$revision<-rep(mcp_revision,nrow(r[[k]]));r[[k]]$release<-rep('MCP_STAGE2_1.1.0',nrow(r[[k]]))
  r[[k]]$claim<-rep('SAMPLE_PARSER_AUDIT_NOT_FACTOR_VALIDATION_OR_ANALYTICAL_ADMISSION',nrow(r[[k]]))
  r[[k]]$exposure<-rep('ALL_ACQUIRED_YEARS_EXPOSED',nrow(r[[k]]))
  r[[k]]$uncertainty<-rep('UNCERTAINTY_NOT_ESTABLISHED',nrow(r[[k]]));rownames(r[[k]])<-NULL
 })
 body(f)<-b;f(input)
}
modern_plus1 <- function(a,p) {
 # An unresolved point may contain two source sequences. Pick neither candidate.
 # Retain both IDs explicitly; the frozen parser's whole-point QA still withholds it.
 keys<-paste(p$match_id,p$Pt,sep='|');ak<-paste(a$match_id,a$Pt,sep='|');j<-match(ak,keys)
 take<-a$kind=='STROKE'&a$domain=='Rally'&!is.na(a$in_play_shot)&a$in_play_shot==3L&a$actor==p$server[j]
 candidates<-split(a$action_id[take],factor(ak[take],levels=keys));duplicate<-lengths(candidates)>1L
 mcp_need(!any(p$tennis_sequence_validated[duplicate]),'Duplicate +1 candidates in a validated point; stop')
 rows<-list()
 if(any(!duplicate))rows[[length(rows)+1L]]<-state_plus1(a,p[!duplicate,,drop=FALSE])
 if(any(duplicate)) {
  unresolved<-p[duplicate,,drop=FALSE]
  # The export stub asserts unknown unique linkage, not absence of raw candidates.
  # Keep the original parser observation below, beside every competing action ID.
  unresolved$plus1_observation<-'UNKNOWN'
  rows[[length(rows)+1L]]<-state_plus1(a[FALSE,,drop=FALSE],unresolved)
 }
 b<-do.call(rbind,rows);b<-b[match(keys,b$point_id),];rownames(b)<-NULL
 b$candidate_plus1_action_ids<-vapply(candidates,paste,collapse=';',FUN.VALUE='')
 b$parser_opportunity_observation<-p$plus1_observation
 b$plus1_conflict_reason<-ifelse(duplicate,'DUPLICATE_UNVALIDATED_PLUS1_CANDIDATES','')
 mcp_need(all(b$disposition[duplicate]=='UNKNOWN_OPPORTUNITY' & !b$observed_prefix[duplicate] & !b$validated_attempt[duplicate]),
          'Ambiguous +1 candidate must earn no observation/absence credit')
 b
}
modern_states <- function(parser,sample) {
 env<-new.env(parent=environment(build_mcp_action_states));env$state_plus1<-modern_plus1
 build<-build_mcp_action_states;environment(build)<-env
 parent<-new.env(parent=environment(repeat_states));parent$build_mcp_action_states<-build
 f<-repeat_states;environment(f)<-parent;f(parser,sample)
}
modern_failures <- function(parser,b,category) {
 failure<-parser[['reason-summary']][,c('tour_file','severity','reason','points','matches'),drop=FALSE]
 if(any(nzchar(b$plus1_conflict_reason)))failure<-rbind(failure,
  data.frame(tour_file=category,severity='FAILURE',reason='DUPLICATE_UNVALIDATED_PLUS1_CANDIDATES',
   points=sum(nzchar(b$plus1_conflict_reason)),matches=1L))
 failure
}

modern_completion <- function(sample,metadata,completion) {
 evidence<-metadata[,c('match_id','point_sequence_contiguous','starts_at_zero','bad_point_owner','status_note_cues','terminal_evidence')]
 for(f in c('point_sequence_contiguous','starts_at_zero'))evidence[[f]]<-as.logical(evidence[[f]])
 for(f in c('bad_point_owner','status_note_cues'))evidence[[f]]<-suppressWarnings(as.numeric(evidence[[f]]))
 fields<-c('match_id','tour_file','Date','player_a','player_b','event_label','Surface','points','selected_by')
 e<-broader_eligibility(list(sample=sample[,fields],evidence=evidence,completion=completion[,c('match_id','expected_points','observed_points','point_total_agrees','chart_score_complete','score_conflict_points','terminal_conflicts')]))
 for(f in setdiff(names(completion),names(e)))e[[f]]<-completion[[f]][match(e$match_id,completion$match_id)]
 e
}
modern_check_inventory <- function(input) {
 e<-input$eligibility;p<-input$points
 mcp_need(nrow(e)>0&&!anyDuplicated(e$match_id)&&sum(e$points)==nrow(p)&&
  setequal(e$match_id,p$match_id)&&all(as.integer(table(p$match_id)[e$match_id])==e$points)&&
  all(mcp_date_valid(gsub('-','',e$source_date,fixed=TRUE))), 'Modern exact inventory/date accounting')
}
modern_point_builder <- function() {
 # Only inventory/release assertions are rebound; scientific checks stay intact.
 check<-plus_protocol_check
 gate<-which(vapply(as.list(body(check)),function(x)grepl('Frozen inventory/date accounting',paste(deparse(x),collapse=' '),fixed=TRUE),FALSE))
 mcp_need(length(gate)==1L,'Original inventory assertion changed')
 body(check)[[gate]]<-quote(modern_check_inventory(input))
 text<-paste(deparse(body(check)),collapse='\n')
 mcp_need(grepl('nrow(b) == 43310',text,fixed=TRUE),'Original point inventory assertion changed')
 text<-gsub('nrow(b) == 43310','nrow(b) == nrow(p)',text,fixed=TRUE)
 body(check)<-parse(text=gsub('"MCP_EXPANDED_RECURRING_1.0.0"','modern_release',text,fixed=TRUE))[[1L]]
 env<-new.env(parent=environment(phase_points));env$plus_protocol_check<-check
 f<-phase_points;environment(f)<-env;f
}
modern_profile_group <- function(g,level) {
 z<-phase_profile_group(g,level)
 z$inventory_years<-paste(sort(unique(substr(g$source_date,1,4)),method='radix'),collapse=';')
 z$inventory_surfaces<-paste(sort(unique(g$surface),method='radix'),collapse=';')
 z$inventory_events<-paste(sort(unique(g$event),method='radix'),collapse=';')
 z$source_date_batches<-length(unique(g$source_date))
 z$eligible_source_date_batches<-length(unique(g$source_date[g$completion_eligible]))
 z$included_source_date_batches<-length(unique(g$source_date[g$included]))
 z
}
modern_profiles <- function(p) {
 env<-new.env(parent=environment(phase_profiles));env$phase_profile_group<-modern_profile_group
 f<-phase_profiles;environment(f)<-env;f(p)
}
modern_coverage <- function(p,e) {
 c<-phase_coverage(p,e,character());c$group<-c$match_id
 for(category in c('ATP','WTA')) {
  template<-c[c$aggregation_level=='CATEGORY'&c$category==category,][1,,drop=FALSE]
  add<-function(z,level,label) {
   if(nrow(z)){row<-phase_coverage(z,e,character());row<-row[row$aggregation_level=='CATEGORY',,drop=FALSE]} else {
    row<-template;for(n in names(row)[vapply(row,is.numeric,FALSE)])row[[n]]<-0
    row$retention<-NA_real_;row$source_date<-'';row$exclusion_reasons<-'';row$demonstration<-FALSE
   }
   row$aggregation_level<-level;row$match_id<-'ALL_MATCHES';row$group<-label;row$category<-category
   c<<-rbind(c,row)
  }
  z<-p[p$category==category,]
  for(year in 2021:2025) {
   add(z[substr(z$source_date,1,4)==year,],'YEAR',as.character(year))
   for(event in c('Australian Open','Roland Garros','Wimbledon','US Open'))
    add(z[substr(z$source_date,1,4)==year&z$event==event,],'EVENT_YEAR',paste(year,event,sep='|'))
  }
  for(surface in c('Hard','Clay','Grass','Carpet'))add(z[z$surface==surface,],'SURFACE',surface)
 }
 c<-c[order(c$aggregation_level,c$category,c$group,method='radix'),];rownames(c)<-NULL;c
}
modern_plot_data <- function(profiles,coverage,display) {
 x<-profiles[profiles$aggregation_level=='POOLED_PLAYER'&profiles$player==display[profiles$category],]
 category<-ifelse(x$category=='ATP',"Historical men's category","Historical women's category")
 x$chart<-paste0(category,' — 2021–2025\n',x$inventory_matches,' charts / ',x$eligible_matches,
  ' completion eligible; ',x$opponents,' opponents\nQA ',x$all_qa_points,'/',x$inventory_points,
  ' (',sprintf('%.1f',100*x$qa_retention),'%), excluded ',x$completion_excluded_points,', withheld ',x$qa_withheld_points)
 x$perspective<-x$player;x$slot<-'Pooled player'
 x$phase<-factor(x$phase,levels=phase_levels);x
}
modern_plots <- function(profiles,coverage,display) {
 env<-new.env(parent=environment(phase_plots));env$phase_plot_data<-modern_plot_data
 f<-phase_plots;environment(f)<-env
 plots<-f(list('match-player-profiles'=profiles,coverage=coverage,demo_ids=display))
 plots$ending<-plots$ending+ggplot2::labs(title='Where observed players won and lost points',
  subtitle='Pooled 2021–2025 profiles; wins/losses divided by all QA-valid player points',
  caption='Exclusive point endings, not action credit. Server +1 is Rally-owned. Undefined denominators remain unavailable.\nExact-identity recurring displays selected before outcomes; unequal exposure prevents rankings or fair comparisons.')
 plots$opportunity<-plots$opportunity+ggplot2::labs(title='Which phases observed player points reached',
  subtitle='Pooled 2021–2025 exposure and role-specific conditional wins; overlapping reaches',
  caption='Shared point reach does not mean both players executed the stroke. Unknown is not absence or a loss.\nConditional rates use reached points in the indicated role. Selective QA; UNCERTAINTY_NOT_ESTABLISHED.')
 plots
}
modern_append <- function(x,path,first) {
 write.table(x,path,sep=',',row.names=FALSE,col.names=first,append=!first,quote=TRUE,na='',eol='\n',qmethod='double')
}
modern_build <- function(stage,inventory=repeat_inventory(),reverse_points=FALSE,progress=TRUE) {
 modern_verify();pin<-modern_spec();selection<-modern_select(inventory);sample<-selection$sample
 exposure<-modern_exposure(inventory);display<-exposure$display
 mcp_need(nrow(sample)==1261L&&sum(sample$points)==243127L,'Frozen metadata cohort differs; stop before parsing')
 mcp_write(modern_metadata(selection$dispositions,pin),stage['selection-dispositions.csv'])
 mcp_write(modern_metadata(exposure$period,pin),stage['period-inventory.csv'])
 mcp_write(modern_metadata(exposure$players,pin),stage['player-exposure.csv'])
 if(progress)cat('Frozen period: 2021–2025; 1261 charts / 243127 point rows; displays:',paste(display,collapse=' / '),'\n')
 loaded<-repeat_points(sample);indices<-split(seq_len(nrow(loaded$points)),factor(loaded$points$match_id,levels=sample$match_id))
 points<-vector('list',nrow(sample));matches<-vector('list',nrow(sample));failures<-vector('list',nrow(sample));peak<-0
 point_build<-modern_point_builder()
 # Eight bundled-R workers, at most eight charts resident in each result chunk.
 # Workers never write shared files; the parent writes in frozen cohort order.
 process<-function(k) {
  ss<-sample[k,,drop=FALSE];raw<-loaded$points[indices[[k]],,drop=FALSE]
  if(reverse_points)raw<-raw[rev(seq_len(nrow(raw))),,drop=FALSE]
  input<-list(sample=ss,metadata=loaded$metadata[k,,drop=FALSE],points=raw)
  parser<-modern_parse(input);states<-modern_states(parser,ss)
  e<-modern_completion(ss,input$metadata,parser[['match-reconciliation']])
  a<-modern_metadata(parser$actions,pin);s<-modern_metadata(states[['action-states']],pin);b<-modern_metadata(states[['serve-plus1']],pin)
  minimal<-list(eligibility=e,points=parser[['point-reconciliation']],actions=a,states=s,plus=b)
  pp<-point_build(minimal);pp$event<-ss$event_label
  failure<-modern_failures(parser,b,ss$tour_file)
  list(e=e,a=a,s=s,b=b,p=pp,failure=failure,peak=as.numeric(object.size(minimal)))
 }
 mcp_need(.Platform$OS.type=='unix','Bounded bundled-R fork processing unavailable; report resource blocker')
 batches<-split(seq_len(nrow(sample)),ceiling(seq_len(nrow(sample))/8L))
 for(batch in batches) {
  parsed<-parallel::mclapply(batch,process,mc.cores=8L,mc.preschedule=TRUE,mc.set.seed=FALSE)
  bad<-vapply(parsed,inherits,FALSE,'try-error')
  if(any(bad))stop(paste('Chart processing failed; no truncated release:',paste(parsed[bad],collapse=';')),call.=FALSE)
  for(j in seq_along(batch)) {
   k<-batch[j];z<-parsed[[j]];points[[k]]<-z$p;matches[[k]]<-z$e;failures[[k]]<-z$failure
   modern_append(z$a,stage['actions.csv'],k==1L);modern_append(z$s,stage['action-states.csv'],k==1L);modern_append(z$b,stage['serve-plus1.csv'],k==1L)
   peak<-max(peak,z$peak)
  }
  if(progress && (max(batch)%%200L==0L || max(batch)==nrow(sample)))cat('Charts processed:',max(batch),'/',nrow(sample),'\n')
 }

 p<-do.call(rbind,points);p<-p[order(p$category,p$match_id,p$Pt,method='radix'),];rownames(p)<-NULL
 e<-do.call(rbind,matches);rownames(e)<-NULL
 profiles<-modern_profiles(p);coverage<-modern_coverage(p,e)
 failure<-do.call(rbind,failures);failure<-failure[order(failure$tour_file,failure$severity,failure$reason,method='radix'),]
 if(nrow(failure))failure<-aggregate(cbind(points,matches)~tour_file+severity+reason,failure,sum)
 # No chart appears twice, so match counts can be summed within each failure reason.
 result<-list('match-completion.csv'=e,'point-dispositions.csv'=p,'match-player-profiles.csv'=profiles,'coverage.csv'=coverage,'parser-failures.csv'=failure)
 for(n in names(result))mcp_write(modern_metadata(result[[n]],pin),stage[n])
 plots<-modern_plots(profiles,coverage,display)
 phase_svg(plots$ending,stage['point-ending-prototype.svg'],14,6)
 phase_svg(plots$opportunity,stage['opportunity-prototype.svg'],16,9)
 modern_verify()
 list(coverage=coverage,display=display,peak_chart_input_bytes=peak,charts=nrow(e),points=nrow(p),profiles=nrow(profiles),specification_sha256=pin)
}
modern_install <- function(stage) {
 paths<-setNames(paste0(modern_prefix,modern_outputs),modern_outputs)
 mcp_need(identical(names(stage),modern_outputs)&&all(file.exists(stage)),'Complete staged release required')
 mcp_need(setequal(system2('git',c('check-ignore','--',shQuote(paths)),stdout=TRUE),unname(paths)),'Existing ignored output location required')
 modern_verify()
 for(k in names(paths))if(file.exists(paths[k]))mcp_need(mcp_sha(paths[k])==mcp_sha(stage[k]),'Refuse differing installed modern release')
 for(k in names(paths))if(!file.exists(paths[k]))mcp_need(file.rename(stage[k],paths[k]),'Atomic per-file installation failed')
 invisible(paths)
}
modern_stage <- function()setNames(vapply(modern_outputs,function(n)tempfile('.mcp-modern-',tmpdir='data/pilot'),''),modern_outputs)
if(sys.nframe()==0L) {
 mcp_need(!length(commandArgs(trailingOnly=TRUE)),'Offline modern descriptive builder takes no arguments')
 stage<-modern_stage()
 r<-tryCatch(modern_build(stage),error=function(e){unlink(stage);stop(e)})
 modern_install(stage);unlink(stage)
 print(r$coverage[r$coverage$aggregation_level=='CATEGORY',c('category','inventory_matches','eligible_matches','inventory_points','included_points','completion_excluded_points','qa_withheld_points','retention')],row.names=FALSE)
 cat('Peak single-chart parser/state input bytes:',r$peak_chart_input_bytes,'\n')
}
