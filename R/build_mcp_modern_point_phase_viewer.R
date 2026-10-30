# Local display only: no recomputation of analytical values or new dependencies.
viewer_inputs <- c(
 'match-player-profiles.csv'='6a8a921d3c1d68d060ad3032b4192b56a730ab41a6bd5d3f40f566bd88076fae',
 'coverage.csv'='005df41adc7965f485192b8787ee87171695850b1477bf701f108bde00c1e53d')
viewer_path <- 'data/pilot/mcp-modern-point-phase-viewer-v1.html'
viewer_hash <- function(path) {
 stopifnot(file.exists(path))
 strsplit(system2('shasum',c('-a','256',shQuote(path)),stdout=TRUE),' ')[[1]][1]
}
viewer_string <- function(x) {
 codes <- utf8ToInt(enc2utf8(x))
 # Most exported labels need no escaping; skip the per-character callback.
 if(!any(codes<32L | codes %in% c(34L,92L,60L,62L,38L,8232L,8233L)))return(paste0('"',enc2utf8(x),'"'))
 encoded <- vapply(codes,function(n) {
  if(n==34L)return('\\"')
  if(n==92L)return('\\\\')
  if(n<32L || n %in% c(60L,62L,38L,8232L,8233L))return(sprintf('\\u%04x',n))
  intToUtf8(n)
 },character(1))
 paste0('"',paste0(encoded,collapse=''),'"')
}
viewer_json <- function(x) {
 if(is.null(x))return('null')
 if(is.list(x)) {
  z<-vapply(x,viewer_json,character(1))
  if(!is.null(names(x)))return(paste0('{',paste0(vapply(names(x),viewer_string,character(1)),':',z,collapse=','),'}'))
  return(paste0('[',paste0(z,collapse=','),']'))
 }
 if(length(x)!=1L)return(viewer_json(as.list(x)))
 if(is.na(x))return('null')
 if(is.logical(x))return(if(x)'true' else 'false')
 if(is.numeric(x)) { stopifnot(is.finite(x));return(sprintf('%.17g',x)) }
 viewer_string(as.character(x))
}
viewer_load <- function() {
 paths<-paste0('data/pilot/mcp-modern-point-phase-v1-',names(viewer_inputs))
 stopifnot(identical(vapply(paths,viewer_hash,character(1),USE.NAMES=FALSE),unname(viewer_inputs)))
 p<-read.csv(paths[1],stringsAsFactors=FALSE,check.names=FALSE,na.strings='')
 c<-read.csv(paths[2],stringsAsFactors=FALSE,check.names=FALSE,na.strings='')
 stopifnot(all(p$release=='MCP_MODERN_POINT_PHASE_PROFILES_1.0.0'),all(c$release=='MCP_MODERN_POINT_PHASE_PROFILES_1.0.0'))
 list(profiles=p,coverage=c)
}
viewer_payload <- function(inputs) {
 p<-inputs$profiles
 meta<-c('aggregation_level','category','match_id','player','inventory_matches','eligible_matches','usable_matches','opponents',
  'first_source_date','last_source_date','inventory_points','completion_excluded_points','qa_withheld_points','all_qa_points','qa_retention',
  'inventory_years','inventory_surfaces','inventory_events','source_date_batches')
 values<-c('measure','role','phase','phase_points','wins','losses','win_share','loss_share','phase_share',
  'reached','known_absent','unknown_reach','reach_share','conditional_win_rate','conditional_denominator')
 keys<-paste(p$aggregation_level,p$category,p$player,p$match_id,sep='\r')
 groups<-split(seq_len(nrow(p)),factor(keys,levels=unique(keys)))
 records<-lapply(groups,function(ix) {
  stopifnot(length(ix)==15L)
  list(meta=as.list(p[ix[1],meta]),values=unname(lapply(ix,function(i)as.list(p[i,values]))))
 })
 coverage_fields<-c('aggregation_level','category','match_id','exclusion_reasons','inventory_matches','eligible_matches',
  'inventory_points','included_points','completion_excluded_points','qa_withheld_points','retention')
 c<-inputs$coverage[inputs$coverage$aggregation_level %in% c('MATCH','CATEGORY'),coverage_fields]
 list(release='MCP_MODERN_POINT_PHASE_PROFILES_1.0.0',profiles=unname(records),
  coverage=unname(lapply(seq_len(nrow(c)),function(i)as.list(c[i,]))))
}
viewer_context_inputs <- c('match-player-profiles.csv'='7bb22451e035fa18cb493a44daaf26028662224105b74624d4d6ac3161d0535b',
 'phase-terminal-profiles.csv'='574aca1339fe88353e926f4c2bbf85e7bfe0d0d7aedbbd181f6d4182c7b3682c','coverage.csv'='4d2bc9277c86005c0297c2ad88995caf4b60b20f5a906e5871999bab6e7c8468')
viewer_context_payload <- function() {
 paths<-paste0('data/pilot/mcp-modern-point-context-v1-',names(viewer_context_inputs))
 stopifnot(identical(unname(vapply(paths,viewer_hash,'')),unname(viewer_context_inputs)))
 z<-lapply(paths,function(p)read.csv(p,stringsAsFactors=FALSE,na.strings=''))
 p<-z[[1]];t<-z[[2]];c<-z[[3]]
 key<-function(x)paste(x$aggregation_level,x$category,x$player,x$match_id,sep='\r')
 pk<-key(p);tk<-key(t)
 # Match frozen records once; no rates, aggregation or inference in the display layer.
 pg<-split(seq_len(nrow(p)),pk);tg<-split(seq_len(nrow(t)),tk)
 fields<-c('measure','role','phase','phase_points','wins','losses','win_share','loss_share','phase_share',
 'reached','known_absent','unknown_reach','reach_share','conditional_win_rate','conditional_denominator')
 lapply(seq_len(nrow(c)),function(i) {
  k<-key(c[i,]);v<-p[pg[[k]],];v<-v[v$subset=='BREAK_POINTS',];v<-v[order(v$measure,v$role,match(v$phase,c('Serve','Return','Server Serve +1','Later Rally','Administrative','Unresolved'))),]
  tt<-t[tg[[k]],c('subset','phase','ending_type','actor_perspective','points','wins','losses','subset_denominator','phase_denominator','subset_share','phase_share')]
  list(meta=as.list(c[i,]),bp=unname(lapply(seq_len(nrow(v)),function(j)as.list(v[j,fields]))),
   types=unname(lapply(seq_len(nrow(tt)),function(j)as.list(tt[j,]))))
 })
}
viewer_fonts <- function() {
 root<-path.expand('~/Documents/GitHub/portfolio/src/assets/fonts')
 paths<-file.path(root,c('fraunces-variable.woff2','OFL.txt'))
 stopifnot(identical(vapply(paths,viewer_hash,character(1),USE.NAMES=FALSE),c(
  '94bb7e04bb1a32237a67935c72526e42a3e52ee4aebd50299802b18a93114251',
  'bdf4c22802eaf804f998195871c6b8938aac2ac14b2d78a8bd66a6f1eced833b')))
 encoded<-system2('openssl',c('base64','-A','-in',shQuote(paths[1])),stdout=TRUE)
 stopifnot(length(encoded)==1L,grepl('^[A-Za-z0-9+/=]+$',encoded))
 license<-paste(readLines(paths[2],warn=FALSE),collapse='\n')
 license<-gsub('&','&amp;',license,fixed=TRUE);license<-gsub('<','&lt;',license,fixed=TRUE);license<-gsub('>','&gt;',license,fixed=TRUE)
 list(style=paste0('@font-face{font-family:Fraunces;font-style:normal;font-weight:100 900;font-display:swap;src:url(data:font/woff2;base64,',encoded,') format("woff2")}'),license=license)
}

viewer_template <- function() r"---(<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; connect-src 'none'; img-src 'none'; font-src data:; form-action 'none'; base-uri 'none'">
<title>When do tennis players win and lose their points?</title>
<style>
__FONT_STYLE__
:root{--cream:#f2e9ce;--sand:#d0be9e;--green:#14532d;--rust:#9c3d1e;font:17px/1.5 'Source Serif 4',Georgia,serif;color:var(--green);background:var(--cream)}*{box-sizing:border-box}body{margin:0}main{max-width:1060px;margin:auto;padding:24px 24px 30px}h1,h2,h3{font-family:Fraunces,Georgia,serif;font-weight:600;font-optical-sizing:auto;font-variation-settings:'SOFT' 0,'WONK' 0}h1{font-size:clamp(1.8rem,4.2vw,3rem);letter-spacing:-.025em;line-height:1.12;margin:7px 0 10px;max-width:920px}h2{font-size:1.4rem;margin:0 0 6px}h3{font-size:1.07rem;margin:12px 0 8px}p{margin:6px 0}.eyebrow,.small,.counts,label,summary{font-size:.82rem}.eyebrow{letter-spacing:.05em;text-transform:uppercase;font-family:'IBM Plex Mono',ui-monospace,monospace}.intro{max-width:870px}header{margin-bottom:18px}.controls{border-block:2px solid var(--green);padding:12px 0 8px;display:grid;grid-template-columns:120px 1fr 1fr 170px 1.2fr;gap:12px}.control{min-width:0}label{display:block;font-weight:600;margin-bottom:4px}select,input{font:inherit;width:100%;min-height:44px;padding:7px;border:1px solid var(--green);border-radius:0;background:var(--cream);color:var(--green)}input:focus,select:focus,summary:focus{outline:3px solid var(--green);outline-offset:3px}.selector-note{margin:8px 0 12px}.numeric,.counts,.stat strong,.scale,.match-id{font-family:'IBM Plex Mono',ui-monospace,monospace;font-variant-numeric:tabular-nums;font-feature-settings:'tnum' 1}.section{padding:18px 0;border-top:1px solid var(--green)}.coverage{border-top:0;padding:7px 0 14px}.profile-heading{display:flex;flex-wrap:wrap;gap:8px;justify-content:space-between;align-items:baseline}.profile-heading h2{margin:0}.stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin-top:9px}.stat strong{font-size:1.3rem;display:block}.stat span{font-size:.77rem;display:block}.context{margin-top:8px;font-size:.82rem;overflow-wrap:anywhere}.coverage-note{font-size:.85rem;margin-top:8px}.warning{font-weight:600;color:var(--rust)}.phase{margin:14px 0 18px}.phase-name{font-weight:600;font-size:.9rem;margin-bottom:4px}.bar-line{display:grid;grid-template-columns:3.5rem minmax(0,1fr) 9rem;align-items:center;gap:8px;margin:4px 0;font-size:.8rem}.track{height:13px;background:var(--sand);position:relative}.fill{height:100%;background:var(--green)}.fill.loss{background-color:var(--rust);background-image:repeating-linear-gradient(135deg,transparent 0 4px,var(--cream) 4px 5px)}.bar-value{text-align:right;font-size:.78rem}.scale{display:flex;justify-content:space-between;font-size:.72rem;margin:12px 9.5rem 8px 4rem}.reach-row{display:grid;grid-template-columns:160px minmax(0,1fr) 5rem;gap:8px;align-items:center;margin:12px 0}.reach-row .counts{grid-column:2/-1;font-size:.74rem}.reach-row strong{text-align:right;font-size:.8rem}.roles{display:grid;grid-template-columns:1fr 1fr;gap:24px;align-items:start}.role h3{margin:0 0 10px}.role-row{display:grid;grid-template-columns:1fr auto;gap:5px;border-top:1px solid var(--sand);padding:7px 0;font-size:.85rem}.role-row .counts{grid-column:1/-1;font-size:.72rem}.unavailable{padding:8px 0;font-style:italic}.match-id{font-size:.7rem;overflow-wrap:anywhere}.zero-details{border-top:1px solid var(--sand);margin-top:8px}summary{cursor:pointer;font-weight:600;padding:9px 0}footer{border-top:2px solid var(--green);margin-top:10px;font-size:.85rem}details p{max-width:900px}pre{white-space:pre-wrap;overflow-wrap:anywhere;font:12px/1.4 ui-monospace,monospace}.technical{font-size:.75rem;overflow-wrap:anywhere}.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}@media(max-width:750px){.controls{grid-template-columns:1fr 1fr}.roles{gap:18px}}@media(max-width:650px){main{padding:16px 16px 24px}.roles{grid-template-columns:1fr}.stats{grid-template-columns:1fr 1fr;gap:8px}.stat strong{font-size:.9rem}.section{padding:13px 0}.coverage{padding:4px 0 10px}.bar-line{grid-template-columns:2.8rem minmax(0,1fr) 7.5rem;gap:6px}.bar-value{font-size:.69rem}.scale{margin-left:3.2rem;margin-right:7.8rem;font-size:.65rem}.reach-row{grid-template-columns:115px minmax(0,1fr) 4.5rem;font-size:.83rem}.reach-row .counts{grid-column:1/-1}h1{font-size:1.9rem}.context{font-size:.78rem}}
.definition-trigger{font:inherit;font-weight:600;color:inherit;background:transparent;border:0;padding:4px 0;min-height:44px;text-decoration:underline dotted;text-underline-offset:.22em;cursor:help;text-align:left}.definition-trigger[aria-expanded="true"]{text-decoration-style:solid}.definition-trigger:focus-visible,a:focus-visible,button:focus-visible,[tabindex="-1"]:focus{outline:3px solid var(--green);outline-offset:3px}.definition-panel{position:fixed;z-index:5;max-width:calc(100vw - 24px);width:350px;max-height:calc(100dvh - 24px);overflow:auto;background:var(--cream);border:2px solid var(--green);padding:14px;font-size:.9rem;box-shadow:0 4px 12px #14532d22}.definition-panel[hidden]{display:none}.definition-panel a,.definition-panel button,.definition-return{display:inline-block;min-height:44px;padding:8px 0;margin-right:16px;color:var(--green);font:inherit}.definition-panel button,.definition-return{border:0;background:transparent;text-decoration:underline;cursor:pointer}.guide{padding:10px 0 16px;font-size:.85rem}.definitions h3{scroll-margin-top:24px}.limitations li{margin:6px 0}.definition-panel p{margin-bottom:8px}
</style></head><body><main>
<header><div class="eyebrow">Tennis analytics · local, read-only</div><h1>When do tennis players win and lose their points?</h1><p class="intro">“When” means the stage of a point. Explore <button type="button" class="definition-trigger" id="term-included" aria-describedby="definition-text-included" data-definition="included" aria-expanded="false" aria-controls="definition-panel">included points</button> from recorded matches, 2021–2025. The ending identifies the final recorded action, not the shot that caused the result.</p></header>
<div class="controls" aria-label="Profile controls">
<div class="control"><label for="category">Category</label><select id="category"><option value="ATP">Men’s</option><option value="WTA">Women’s</option></select></div>
<div class="control"><label for="search">Find a player</label><input id="search" type="search" placeholder="Type a player name" autocomplete="off"></div>
<div class="control"><label for="player">Player</label><select id="player"></select></div>
<div class="control"><label for="subset">Point selection</label><button type="button" class="definition-trigger small" id="term-break" aria-describedby="definition-text-break" data-definition="break" aria-expanded="false" aria-controls="definition-panel">Break points explained</button><select id="subset"><option value="ALL_INCLUDED">All included points</option><option value="BREAK_POINTS">Break points</option></select></div>
<div class="control"><label for="match">Match view</label><select id="match"></select></div>
</div><section class="guide" aria-label="Reading guide"><strong>Reading guide</strong><p>Illustrative example, not a player result: with 100 included points, 10 wins and 5 losses ending at <button type="button" class="definition-trigger" id="term-guide-serve" data-definition="serve" aria-describedby="definition-text-serve" aria-expanded="false" aria-controls="definition-panel">Serve</button> would occupy 10% and 5% of the ending chart. Both use all 100 points. A win rate after a stage uses only the points that reached it; reaching several stages counts the same shared point more than once.</p></section><p id="search-status" class="small selector-note" aria-live="polite"></p>
<section id="view" aria-label="Selected player profile" aria-live="polite"></section>
<footer><section class="section limitations" aria-labelledby="important-limitations"><h2 id="important-limitations">Important limitations</h2><ul><li>Missing point details may change the apparent pattern of endings. Missing details occur especially later in rallies.</li><li>These are sampled charted matches, with unequal opponent exposure. Included percentages do not measure a player’s career or complete tournament coverage.</li><li>Consistent match records do not prove the match officially finished. The men’s/women’s labels do not confirm which tennis tour each match belongs to.</li><li>Recorded endings do not establish what caused a point result, player rankings, strengths or clutch ability. Break points describe a selected subset.</li><li>Uncertainty intervals have not been established. All acquired years are exposed, and chart date labels do not verify historical availability.</li></ul></section><details id="definitions" class="definitions"><summary>Definitions</summary><h3 id="definition-included" tabindex="-1">Included points</h3><p id="definition-text-included">Recorded points with enough clear information about the full point to use in these charts.</p><h3 id="definition-break" tabindex="-1">Break points</h3><p id="definition-text-break">Points in a regular game where the receiver would win the game by winning this point, whether the chance is taken or saved. Tiebreak points do not count.</p><h3 id="definition-serve" tabindex="-1">Serve</h3><p id="definition-text-serve">A serve attempt, including faults, lets, aces and double faults. A fault or let need not end the point.</p><h3 id="definition-return" tabindex="-1">Return</h3><p id="definition-text-return">The receiver’s attempt to hit the serve back, including errors.</p><h3 id="definition-plus1" tabindex="-1">Serve +1</h3><p id="definition-text-plus1">The server’s first attempt to hit the ball after the return, including errors.</p><h3 id="definition-rally" tabindex="-1">Later Rally</h3><p id="definition-text-rally">Play after the server’s first attempted shot following the return.</p><h3 id="definition-reach" tabindex="-1">Stage reached</h3><p id="definition-text-reach">The point got as far as a shot attempt at this stage; one point can reach several stages.</p><h3 id="definition-conditional" tabindex="-1">Win rate after reaching a stage</h3><p id="definition-text-conditional">The player’s wins out of the points known to reach this stage, shown separately when serving and receiving.</p><h3 id="definition-ending" tabindex="-1">Ending types</h3><p id="definition-text-ending">Descriptions in the match record of the final shot, error or point award.</p><h3 id="definition-recorded" tabindex="-1">Recorded points</h3><p id="definition-text-recorded">All points in the match records for this player and view, including omitted points and points from excluded match records.</p><h3 id="definition-retention" tabindex="-1">Included percentage</h3><p id="definition-text-retention">The included points as a percentage of all recorded points for this player and view, not their whole career.</p><h3 id="definition-omitted" tabindex="-1">Points omitted because details are unclear</h3><p id="definition-text-omitted">Recorded points left out of the charts because their details are unclear or conflicting.</p><h3 id="definition-excluded" tabindex="-1">Points from excluded match records</h3><p id="definition-text-excluded">Recorded points left out because the match may have ended early or its ending cannot be confirmed from the record.</p><h3 id="definition-matches" tabindex="-1">All recorded matches</h3><p id="definition-text-matches">The player’s points pooled across the matches recorded here, rather than their whole career.</p><h3 id="definition-dates" tabindex="-1">Dates in the match records</h3><p id="definition-text-dates">The dates listed for these matches, without proof of when their details became available.</p><h3 id="definition-categories" tabindex="-1">Men’s and women’s categories</h3><p id="definition-text-categories">The categories used in the match records, without confirming which tennis tour each match belongs to.</p><h3 id="definition-basis" tabindex="-1">Points counted for a percentage</h3><p id="definition-text-basis">The total number of points a percentage is measured out of.</p><h3 id="definition-endshare" tabindex="-1">Ending win and loss percentages</h3><p id="definition-text-endshare">The selected player’s wins or losses ending at a stage, out of all included points in the chosen selection.</p><h3 id="definition-typeshare" tabindex="-1">Ending-type percentages</h3><p id="definition-text-typeshare">Points with a given recorded ending, out of the included points ending at that same stage in the chosen selection.</p><h3 id="definition-faced" tabindex="-1">Break points faced</h3><p id="definition-text-faced">Included break points on the selected player’s serve, when the opponent could win the game by winning the point.</p><h3 id="definition-opportunities" tabindex="-1">Break-point opportunities</h3><p id="definition-text-opportunities">Included break points when the selected player is receiving and could win the game by winning the point.</p><h3 id="definition-notreached" tabindex="-1">Did not reach this stage</h3><p id="definition-text-notreached">The point is known to have ended before this stage.</p><h3 id="definition-unknown" tabindex="-1">Stage reach unclear</h3><p id="definition-text-unknown">The record does not clearly show whether the point reached this stage.</p><h3 id="definition-zero" tabindex="-1">Zero</h3><p id="definition-text-zero">No events of that kind were recorded among the points counted.</p><h3 id="definition-unavailable" tabindex="-1">Unavailable</h3><p id="definition-text-unavailable">No percentage can be shown because no points qualify for it or the needed information is unclear.</p><h3 id="definition-ace" tabindex="-1">Ace</h3><p id="definition-text-ace">A serve recorded as winning the point without the receiver touching the ball.</p><h3 id="definition-doublefault" tabindex="-1">Double fault</h3><p id="definition-text-doublefault">A second-serve fault that loses the point.</p><h3 id="definition-winner" tabindex="-1">Other recorded winner</h3><p id="definition-text-winner">A shot other than an ace that the match record marks as a winner.</p><h3 id="definition-forced" tabindex="-1">Forced error</h3><p id="definition-text-forced">An error the match record describes as a forced response to the opponent’s shot.</p><h3 id="definition-unforced" tabindex="-1">Unforced error</h3><p id="definition-text-unforced">An error the match record describes as a miss not forced by the opponent’s shot.</p><h3 id="definition-administrative" tabindex="-1">No recorded final shot</h3><p id="definition-text-administrative">An ending with no final shot named in the record, such as a point penalty or failed challenge.</p><h3 id="definition-otherending" tabindex="-1">Other recorded ending</h3><p id="definition-text-otherending">An ending marked unreturnable, without a recorded forced- or unforced-error label.</p><h3 id="definition-unknownending" tabindex="-1">Unknown ending type</h3><p id="definition-text-unknownending">The record does not clearly show how the point ended.</p><h3 id="definition-finalplayer" tabindex="-1">Player making the final action</h3><p id="definition-text-finalplayer">The player who made the last recorded shot or error, who may differ from the player who won the point.</p><h3 id="definition-sides" tabindex="-1">Selected player and opponent</h3><p id="definition-text-sides">The selected player is the player you chose above; the opponent is the other player in that match.</p><h3 id="definition-noactor" tabindex="-1">No final-shot player named</h3><p id="definition-text-noactor">This ending gives a point result without naming a player’s final shot.</p><h3 id="definition-unknownactor" tabindex="-1">Final-action player unclear</h3><p id="definition-text-unknownactor">The record does not clearly identify who made the final action.</p><button type="button" id="definition-back" class="definition-return" hidden>Return to term</button></details><details id="methodology"><summary>Methodology</summary><p>Profiles describe included chart-observed points, not all points played. Missing or unsupported later-rally notation accounts for much of the omission and may affect phase proportions. Points from excluded match records and points omitted after notation checks are retained in coverage; they are not assigned success, failure or known absence.</p><p>Break-point context is reconciled pre-point ordinary-game score: every opportunity counts, tiebreaks never count, and unknown/conflicting states stay outside the subset. This annotation never rescues withheld points. The subset selector changes the denominator to included break points; serving/receiving counts distinguish facing a break from having a break opportunity. Point endings partition the selected included subset. Win share = recorded wins at that ending / the selected included subset involving the selected player; loss share uses recorded losses over that same denominator. The phase names the final recorded action by either player, not its causal contribution. First-serve faults and lets do not automatically end points.</p><p>Stage reach = points known to reach the stage / selected included subset points. Stages overlap and describe a shared point, not both players executing the stroke. Role-specific point win rate = selected-player wins among points reaching the stage / the documented role-specific reached-point denominator. Unknown reaches stay outside that denominator; an unknown winner among reached points makes the rate unavailable. Unknown is not absence or a loss; zero-denominator rates remain unavailable.</p><p>Ending types reflect recorded notation and the linked terminal actor, not causal credit. Aces and double faults are separate; collapsed unreturnable notation is Other supported ending, without inferred forced-error attribution. Administrative endings are nonphysical. Type percentages use the displayed phase denominator; absent observations are not errors.</p><p>Serve +1 is the server’s first attempt to hit the ball after the return, including errors. It remains owned exclusively by Rally; its breakdown adds no extra factor credit. Return belongs to Return, and Serve to Serve.</p><p>Unequal exposure and selective retention prevent fair player comparisons, rankings, causal-skill, transferable-skill or independent-factor conclusions. There are no established confidence intervals. Internal chart consistency does not establish official match completion or complete tournament coverage. Historical men’s/women’s labels do not certify governing-tour membership. Names are exact source identities, without alias merging. All acquired years are exposed; source-date labels do not establish historical availability.</p><p>Only the exact men’s-category Dominik Koepfer identity is hidden from selection. All 450 identities, his unavailable profiles and all coverage totals remain embedded. No historical data is removed or recalculated; the separately frozen context extension supplies subset and ending-type displays.</p><p>Typography: Fraunces is embedded from the portfolio’s saved, licensed local asset. Source Serif 4 and IBM Plex Mono are requested by name, with Georgia and system-monospace fallbacks; cached binaries are not embedded because their saved rights were not verified.</p><details><summary>Technical identifiers and font license</summary><p class="technical">Release: MCP_MODERN_POINT_PHASE_PROFILES_1.0.0<br>Context release: MCP_MODERN_POINT_CONTEXT_1.0.0<br>Source revision: 1813a1309b7ed7ebf1c7e884b32bf675d00e4edf<br>UNCERTAINTY_NOT_ESTABLISHED — uncertainty intervals have not been established.<br>HISTORICAL_MENS_WOMENS_CATEGORIES_NOT_CERTIFIED_TOURS — source categories are not certified tour populations.<br>SOURCE_DATE_LABELS_NOT_VERIFIED_AVAILABILITY — source labels do not verify historical availability.<br>All acquired years exposed; 2026 is outside this displayed cohort.</p><pre>__FONT_LICENSE__</pre></details></details>
</footer><aside id="definition-panel" class="definition-panel" role="note" aria-labelledby="definition-title" hidden><strong id="definition-title"></strong><p id="definition-copy"></p><a id="definition-link" href="#definitions">See definitions</a><button type="button" id="definition-close">Close explanation</button></aside></main><script id="frozen-data" type="application/json">__FROZEN_DATA__</script><script id="frozen-context" type="application/json">__CONTEXT_DATA__</script><script>
'use strict';
const DATA=JSON.parse(document.getElementById('frozen-data').textContent);
const CONTEXT=JSON.parse(document.getElementById('frozen-context').textContent);
const contextKey=m=>JSON.stringify([m.aggregation_level,m.category,m.player,m.match_id]);
const contextMap=new Map(CONTEXT.map(g=>[contextKey(g.meta),g]));
const controls=Object.fromEntries(['category','search','player','match','subset','view','search-status'].map(id=>[id,document.getElementById(id)]));
const defaults={ATP:'Adrian Mannarino',WTA:'Ajla Tomljanovic'};
const escapeText=s=>String(s??'Unavailable').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const num=n=>n===null||n===undefined?'Unavailable':n.toLocaleString('en-US');
const pct=n=>n===null||n===undefined?'Unavailable':n>0&&n<0.001?'<0.1%':(100*n).toFixed(1)+'%';
const percent=n=>escapeText(pct(n));
const listText=s=>escapeText(s).replace(/[;|]/g,', ');
const option=(v,t)=>{const o=document.createElement('option');o.value=v;o.textContent=t;return o;};
const readable=id=>id.replaceAll('_',' ').replace(/-/g,' · ');
const hiddenIdentity=(category,player)=>category==='ATP'&&player==='Dominik Koepfer';
const reasonLabels={TERMINAL_OUTCOME_CONFLICT:'Recorded point endings conflict',INCOMPLETE_CHART:'Match record is incomplete',SCORE_REPLAY_CONFLICT_OR_UNAVAILABLE:'The recorded score cannot be confirmed',STATUS_NOTE_CUE_REQUIRES_EXCLUSION:'A note about the match’s status means this record is left out'};
const reasonsText=s=>s?.split(';').map(r=>reasonLabels[r]??'Unresolved exclusion; see technical reason below').join('; ');
// One shared explanation panel adapts the NBA reference without a dependency.
const definitionCopy={
 "included": {
  "label": "Included points",
  "copy": "Recorded points with enough clear information about the full point to use in these charts."
 },
 "break": {
  "label": "Break points",
  "copy": "Points in a regular game where the receiver would win the game by winning this point, whether the chance is taken or saved. Tiebreak points do not count."
 },
 "serve": {
  "label": "Serve",
  "copy": "A serve attempt, including faults, lets, aces and double faults. A fault or let need not end the point."
 },
 "return": {
  "label": "Return",
  "copy": "The receiver’s attempt to hit the serve back, including errors."
 },
 "plus1": {
  "label": "Serve +1",
  "copy": "The server’s first attempt to hit the ball after the return, including errors."
 },
 "rally": {
  "label": "Later Rally",
  "copy": "Play after the server’s first attempted shot following the return."
 },
 "reach": {
  "label": "Stage reached",
  "copy": "The point got as far as a shot attempt at this stage; one point can reach several stages."
 },
 "conditional": {
  "label": "Win rate after reaching a stage",
  "copy": "The player’s wins out of the points known to reach this stage, shown separately when serving and receiving."
 },
 "ending": {
  "label": "Ending types",
  "copy": "Descriptions in the match record of the final shot, error or point award."
 },
 "recorded": {
  "label": "Recorded points",
  "copy": "All points in the match records for this player and view, including omitted points and points from excluded match records."
 },
 "retention": {
  "label": "Included percentage",
  "copy": "The included points as a percentage of all recorded points for this player and view, not their whole career."
 },
 "omitted": {
  "label": "Points omitted because details are unclear",
  "copy": "Recorded points left out of the charts because their details are unclear or conflicting."
 },
 "excluded": {
  "label": "Points from excluded match records",
  "copy": "Recorded points left out because the match may have ended early or its ending cannot be confirmed from the record."
 },
 "matches": {
  "label": "All recorded matches",
  "copy": "The player’s points pooled across the matches recorded here, rather than their whole career."
 },
 "dates": {
  "label": "Dates in the match records",
  "copy": "The dates listed for these matches, without proof of when their details became available."
 },
 "categories": {
  "label": "Men’s and women’s categories",
  "copy": "The categories used in the match records, without confirming which tennis tour each match belongs to."
 },
 "basis": {
  "label": "Points counted for a percentage",
  "copy": "The total number of points a percentage is measured out of."
 },
 "endshare": {
  "label": "Ending win and loss percentages",
  "copy": "The selected player’s wins or losses ending at a stage, out of all included points in the chosen selection."
 },
 "typeshare": {
  "label": "Ending-type percentages",
  "copy": "Points with a given recorded ending, out of the included points ending at that same stage in the chosen selection."
 },
 "faced": {
  "label": "Break points faced",
  "copy": "Included break points on the selected player’s serve, when the opponent could win the game by winning the point."
 },
 "opportunities": {
  "label": "Break-point opportunities",
  "copy": "Included break points when the selected player is receiving and could win the game by winning the point."
 },
 "notreached": {
  "label": "Did not reach this stage",
  "copy": "The point is known to have ended before this stage."
 },
 "unknown": {
  "label": "Stage reach unclear",
  "copy": "The record does not clearly show whether the point reached this stage."
 },
 "zero": {
  "label": "Zero",
  "copy": "No events of that kind were recorded among the points counted."
 },
 "unavailable": {
  "label": "Unavailable",
  "copy": "No percentage can be shown because no points qualify for it or the needed information is unclear."
 },
 "ace": {
  "label": "Ace",
  "copy": "A serve recorded as winning the point without the receiver touching the ball."
 },
 "doublefault": {
  "label": "Double fault",
  "copy": "A second-serve fault that loses the point."
 },
 "winner": {
  "label": "Other recorded winner",
  "copy": "A shot other than an ace that the match record marks as a winner."
 },
 "forced": {
  "label": "Forced error",
  "copy": "An error the match record describes as a forced response to the opponent’s shot."
 },
 "unforced": {
  "label": "Unforced error",
  "copy": "An error the match record describes as a miss not forced by the opponent’s shot."
 },
 "administrative": {
  "label": "No recorded final shot",
  "copy": "An ending with no final shot named in the record, such as a point penalty or failed challenge."
 },
 "otherending": {
  "label": "Other recorded ending",
  "copy": "An ending marked unreturnable, without a recorded forced- or unforced-error label."
 },
 "unknownending": {
  "label": "Unknown ending type",
  "copy": "The record does not clearly show how the point ended."
 },
 "finalplayer": {
  "label": "Player making the final action",
  "copy": "The player who made the last recorded shot or error, who may differ from the player who won the point."
 },
 "sides": {
  "label": "Selected player and opponent",
  "copy": "The selected player is the player you chose above; the opponent is the other player in that match."
 },
 "noactor": {
  "label": "No final-shot player named",
  "copy": "This ending gives a point result without naming a player’s final shot."
 },
 "unknownactor": {
  "label": "Final-action player unclear",
  "copy": "The record does not clearly identify who made the final action."
 }
};
const phaseTerms={'Serve':'serve','Return':'return','Server Serve +1':'plus1','Later Rally':'rally'};
// Wording aliases only; saved labels and identifiers remain unchanged.
const phaseLabels={'Server Serve +1':'Server’s Serve +1','Administrative':'No recorded final shot','Unresolved':'Unknown stage'};
const endingLabels={'Administrative ending':'No recorded final shot','Other annotated winner':'Other recorded winner','Other supported ending':'Other recorded ending','Unknown or unsupported classification':'Unknown ending type'};
const actorLabels={'Selected player winner':'Selected player’s winner','Opponent winner':'Opponent’s winner','Selected player error':'Selected player’s error','Opponent error':'Opponent’s error','Selected player supported ending':'Selected player’s other final action','Opponent supported ending':'Opponent’s other final action','Nonphysical':'No final-shot player named','Unresolved actor':'Final-action player unclear'};
const phaseLabel=phase=>phaseLabels[phase]??phase;
const term=(id,label)=>`<button type="button" class="definition-trigger" id="term-${id}" aria-describedby="definition-text-${id}" data-definition="${id}" aria-expanded="false" aria-controls="definition-panel">${escapeText(label)}</button>`;
const phaseName=phase=>phaseTerms[phase]?term(phaseTerms[phase],phaseLabel(phase)):escapeText(phaseLabel(phase));
const helpPanel=document.getElementById('definition-panel'),helpTitle=document.getElementById('definition-title'),helpCopy=document.getElementById('definition-copy'),helpLink=document.getElementById('definition-link');
let helpAnchor=null,definitionOrigin=null,helpPinned=false,helpDismissed=null,helpTimer;
function placeHelp(){
 if(helpPanel.hidden||!helpAnchor)return;
 const a=helpAnchor.getBoundingClientRect(),p=helpPanel.getBoundingClientRect(),edge=12;
 helpPanel.style.left=Math.max(edge,Math.min(a.left,window.innerWidth-p.width-edge))+'px';
 helpPanel.style.top=(a.bottom+p.height<=window.innerHeight-edge?a.bottom:Math.max(edge,a.top-p.height))+'px';
}
function closeHelp(returnFocus=false,dismiss=false){
 clearTimeout(helpTimer);const anchor=helpAnchor;
 helpPanel.hidden=true;helpPinned=false;
 if(anchor)anchor.setAttribute('aria-expanded','false');
 helpAnchor=null;if(dismiss)helpDismissed=anchor;
 if(returnFocus&&anchor?.isConnected)anchor.focus({preventScroll:true});
}
function openHelp(anchor,pin=false){
 if(!anchor||!definitionCopy[anchor.dataset.definition]||(!pin&&helpDismissed===anchor))return;
 clearTimeout(helpTimer);
 if(helpAnchor!==anchor)closeHelp();
 helpAnchor=anchor;helpPinned=helpPinned||pin;if(pin)helpDismissed=null;
 const def=definitionCopy[anchor.dataset.definition];
 helpTitle.textContent=def.label;helpCopy.textContent=def.copy;helpLink.href='#definition-'+anchor.dataset.definition;
 anchor.setAttribute('aria-expanded','true');helpPanel.hidden=false;placeHelp();
}
function followDefinition(event){
 event.preventDefault();if(!helpAnchor)return;
 const target=document.getElementById('definition-'+helpAnchor.dataset.definition);
 if(!target)return;
 definitionOrigin=helpAnchor;closeHelp(false,true);
 document.getElementById('definitions').open=true;
 document.getElementById('definition-back').hidden=false;
 target.focus({preventScroll:true});target.scrollIntoView({block:'start',behavior:'auto'});
}
function helpTrigger(event){return event.target?.closest?.('[data-definition]');}
function inHelp(node){return !!node&&(helpPanel.contains(node)||helpAnchor?.contains(node));}
document.addEventListener('pointerover',event=>{
 if(event.pointerType!=='mouse')return;
 const anchor=helpTrigger(event);if(anchor&&!(helpPanel.contains(document.activeElement)&&helpAnchor!==anchor))openHelp(anchor);
 if(inHelp(event.target))clearTimeout(helpTimer);
});
document.addEventListener('pointerout',event=>{
 if(event.pointerType!=='mouse')return;
 if(helpDismissed&&event.target===helpDismissed&&!helpDismissed.contains(event.relatedTarget))helpDismissed=null;
 if(!inHelp(event.target)||inHelp(event.relatedTarget))return;
 helpTimer=setTimeout(()=>{if(!helpPinned&&!inHelp(document.activeElement))closeHelp();},200);
});
document.addEventListener('focusin',event=>{const anchor=helpTrigger(event);if(anchor)openHelp(anchor);});
document.addEventListener('focusout',event=>{
 if(helpAnchor&&inHelp(event.target)&&!inHelp(event.relatedTarget))closeHelp();
 if(helpDismissed&&event.target===helpDismissed&&!helpDismissed.contains(event.relatedTarget))helpDismissed=null;
});
document.addEventListener('click',event=>{
 const anchor=helpTrigger(event);if(!anchor)return;
 if(helpAnchor===anchor&&helpPinned)closeHelp(false,true);else openHelp(anchor,true);
});
document.addEventListener('pointerdown',event=>{if(!inHelp(event.target)&&!helpTrigger(event))closeHelp();});
document.addEventListener('keydown',event=>{
 if(event.key==='Escape'&&!helpPanel.hidden){event.preventDefault();closeHelp(inHelp(document.activeElement),true);}
 if(event.key==='Tab'&&!helpPanel.hidden){
  if(event.target===helpAnchor&&!event.shiftKey){event.preventDefault();helpLink.focus();}
  else if(event.target===helpLink&&event.shiftKey){event.preventDefault();helpAnchor.focus();}
 }
});
helpLink.addEventListener('click',followDefinition);
document.getElementById('definition-close').addEventListener('click',()=>closeHelp(true,true));
document.getElementById('definition-back').addEventListener('click',()=>{
 if(definitionOrigin?.isConnected){definitionOrigin.focus({preventScroll:true});definitionOrigin.scrollIntoView({block:'center',behavior:'auto'});}
});
window.addEventListener('resize',placeHelp);window.addEventListener('scroll',placeHelp,{capture:true});
function playerOptions(reset=false){
 const cat=controls.category.value,query=controls.search.value.toLocaleLowerCase(),old=controls.player.value;
 const saved=DATA.profiles.filter(g=>g.meta.category===cat&&g.meta.aggregation_level==='POOLED_PLAYER').map(g=>g.meta.player).sort();
 const names=saved.filter(n=>!hiddenIdentity(cat,n)),shown=names.filter(n=>n.toLocaleLowerCase().includes(query));
 controls.player.replaceChildren(...shown.map(n=>option(n,n)));controls.player.disabled=!shown.length;
 controls['search-status'].textContent=(shown.length?`${shown.length} of ${names.length} selectable names.`:'No matching player name.')+(cat==='ATP'?' One name hidden from selection; 228 saved player names remain.':' 222 saved player names remain.');
 if(shown.length)controls.player.value=reset?defaults[cat]:(shown.includes(old)?old:shown[0]);
 matchOptions();
}
function matchOptions(){
 const groups=DATA.profiles.filter(g=>g.meta.category===controls.category.value&&g.meta.player===controls.player.value);
 controls.match.replaceChildren(option('ALL_MATCHES','All recorded matches'),...groups.filter(g=>g.meta.aggregation_level==='MATCH_PLAYER').map(g=>option(g.meta.match_id,readable(g.meta.match_id))));
 controls.match.disabled=!groups.length;controls.match.value='ALL_MATCHES';render();
}
function endingRow(r){
 const series=(label,n,share,loss)=>`<div class="bar-line"><span>${loss?'▧':'■'} ${label}</span>${share===null?'<span class="unavailable">Unavailable</span>':`<div class="track" aria-hidden="true"><div class="fill${loss?' loss':''}" style="width:${100*share}%"></div></div>`}<span class="bar-value numeric">${num(n)} · ${percent(share)}</span></div>`;
 return `<div class="phase" data-phase="${escapeText(r.phase)}"><div class="phase-name">${phaseName(r.phase)}</div>${series('Wins',r.wins,r.win_share,false)}${series('Losses',r.losses,r.loss_share,true)}</div>`;
}
function render(){
 closeHelp();helpDismissed=null;definitionOrigin=null;document.getElementById('definition-back').hidden=true;
 const group=DATA.profiles.find(g=>g.meta.category===controls.category.value&&g.meta.player===controls.player.value&&g.meta.match_id===controls.match.value&&g.meta.aggregation_level===(controls.match.value==='ALL_MATCHES'?'POOLED_PLAYER':'MATCH_PLAYER'));
 if(!group){controls.view.innerHTML='<div class="unavailable">No matching player selected. Search or choose a player to see their recorded points.</div>';return;}
 const m=group.meta,cg=contextMap.get(contextKey(m)),bp=controls.subset.value==='BREAK_POINTS',v=bp?cg.bp:group.values;
 const denominator=bp?cg.meta.included_break_points:m.all_qa_points;
 const types=cg.types.filter(t=>t.subset===controls.subset.value);
 const draw=r=>endingRow(r);
 const terminalRows=ending=>`<details><summary>${escapeText(phaseLabel(ending.phase))} · ${num(ending.phase_points)} ${bp?'included break points':'included points'} ending here</summary>${types.filter(t=>t.phase===ending.phase).map(t=>`<p class="counts">${escapeText(endingLabels[t.ending_type]??t.ending_type)} · ${escapeText(actorLabels[t.actor_perspective]??t.actor_perspective)}: ${num(t.points)} / ${num(t.phase_denominator)} (${percent(t.phase_share)}) · ${num(t.wins)} selected-player point wins / ${num(t.losses)} point losses</p>`).join('')}${ending.phase_points===0?'<p class="unavailable">No points ended at this stage. Percentages are unavailable.</p>':'<p class="small">Unlisted ending types have a count of zero at this stage; unclear ending counts are shown above.</p>'}</details>`;
 const coverage=DATA.coverage.find(c=>c.category===m.category&&c.match_id===m.match_id&&c.aggregation_level==='MATCH');
 const reasons=coverage?.exclusion_reasons;
 const ending=v.filter(r=>r.measure==='POINT_ENDING'),residual=r=>['Administrative','Unresolved'].includes(r.phase)&&r.phase_points===0;
 const endings=ending.filter(r=>!residual(r)).map(draw).join('');
 const zero=ending.filter(residual);
 const zeroDetails=zero.length?`<details class="zero-details"><summary>Zero-count endings: ${zero.map(r=>escapeText(phaseLabel(r.phase))).join(', ')}</summary>${zero.map(draw).join('')}</details>`:'';
 const reaches=v.filter(r=>r.measure==='REACH'&&r.role==='ALL').map(r=>`<div class="reach-row"><span>${escapeText(phaseLabel(r.phase))}</span>${r.reach_share===null?'<span class="unavailable">Unavailable</span>':`<div class="track" aria-hidden="true"><div class="fill" style="width:${100*r.reach_share}%"></div></div>`}<strong class="numeric">${percent(r.reach_share)}</strong><span class="counts">${num(r.reached)} points reaching this stage / ${num(denominator)} ${bp?'included break points':'included points'} · ${num(r.known_absent)} did not reach this stage · ${num(r.unknown_reach)} reach unclear</span></div>`).join('');
 const roles=['SERVER','RECEIVER'].map(role=>`<section class="role"><h3>When ${role==='SERVER'?'serving':'receiving'}</h3>${v.filter(r=>r.measure==='REACH'&&r.role===role).map(r=>`<div class="role-row"><span>${escapeText(role==='RECEIVER'&&r.phase==='Server Serve +1'?'Opponent’s Serve +1':phaseLabel(r.phase))}</span><strong class="numeric">${percent(r.conditional_win_rate)}</strong><span class="counts">${num(r.wins)} wins / ${num(r.conditional_denominator)} ${bp?'included break points':'included points'} reaching this stage while ${role==='SERVER'?'serving':'receiving'} · ${num(r.unknown_reach)} reach unclear</span></div>`).join('')}</section>`).join('');
 controls.view.innerHTML=`<section class="coverage"><div class="profile-heading"><h2>${escapeText(m.player)}</h2><span class="small">${m.aggregation_level==='POOLED_PLAYER'?'All recorded matches':'Individual match'}</span></div><p class="small">${escapeText(m.first_source_date)} to ${escapeText(m.last_source_date)} · dates in the match records</p><div class="stats"><div class="stat"><strong>${num(m.all_qa_points)} / ${num(m.inventory_points)}</strong><span>Included / recorded points</span></div><div class="stat"><strong>${percent(m.qa_retention)}</strong><span>Included percentage</span></div><div class="stat"><strong>${num(m.qa_withheld_points)}</strong><span>Points omitted because details are unclear</span></div><div class="stat"><strong>${num(m.completion_excluded_points)}</strong><span>Points from excluded match records</span></div></div><div class="context">${num(m.inventory_matches)} recorded matches · ${num(m.eligible_matches)} match records not excluded · ${num(m.usable_matches)} with points shown · ${num(m.opponents)} opponents<br>Years: ${listText(m.inventory_years)} · Surfaces: ${listText(m.inventory_surfaces)}<br>Events: ${listText(m.inventory_events)} · ${num(m.source_date_batches)} recorded dates</div>${m.aggregation_level==='MATCH_PLAYER'?`<p class="match-id">${escapeText(m.match_id)}</p>`:''}<p class="coverage-note">The included percentage does not measure career or complete tournament coverage.</p><p class="small warning">Missing point details may change the apparent pattern of endings.</p>${reasons?`<p class="small">Match record excluded: ${escapeText(reasonsText(reasons))}</p><details><summary>Technical exclusion reason</summary><p class="technical">${escapeText(reasons)}</p></details>`:''}${m.all_qa_points===0?'<p class="unavailable">No usable points for this player/view. Omitted or excluded points remain in the recorded totals; percentages remain unavailable.</p>':''}</section><section class="section"><h2>${bp?'Break points':'All included points'}</h2><p class="counts">${num(denominator)} ${bp?'included break points':'included points'} in this selection / ${num(m.all_qa_points)} all included points. Included break points: ${num(cg.meta.break_points_faced)} faced while serving · ${num(cg.meta.break_opportunities_receiving)} opportunities while receiving. ${num(cg.meta.included_break_points)} included / ${num(cg.meta.inventory_break_points)} known break points in match records · ${num(cg.meta.qa_withheld_break_points)} omitted because details are unclear · ${num(cg.meta.completion_excluded_break_points)} from excluded match records. ${num(cg.meta.included_score_unknown)} included points have unclear scores before the point; ${num(cg.meta.score_unknown_inventory)} unknown across recorded points. ${num(cg.meta.included_ending_unknown)} included points have an unclear ending type.</p><p class="small warning">Break points describe only the included break-point chances, not all points or proven clutch ability.</p>${denominator===0?'<p class="unavailable">No included opportunities in this selection. Rates remain unavailable.</p>':''}<h2>At what stage did points end?</h2><p class="small">Each included point appears once. Selected-player wins and losses use all ${bp?'included break points':'included points'} in this selection as the points counted: ${num(denominator)} points.</p><p class="small">The stage names the final recorded action by either player, not the shot that caused the result. Wins and losses belong to the selected player.</p><p class="small">Serve wins can include the selected player’s aces or an opponent’s double faults.</p><h3>${bp?'Share of included break points.':'Share of all included points.'}</h3><div class="scale" aria-hidden="true"><span>0%</span><span>25%</span><span>50%</span><span>75%</span><span>100%</span></div>${endings}${zeroDetails}</section><section class="section"><h2>How far did points go?</h2><p class="small">One point can reach several stages; these percentages overlap. ${term('reach','Reaches')} describe the shared point. Each percentage uses ${num(denominator)} ${bp?'included break points':'included points'} in this selection.</p><p class="small">Serve +1 is the server’s first shot attempt after the return, including attempted errors.</p>${reaches}</section><section class="section"><h2>How often did the player win after each stage was reached?</h2><p class="small">${term('conditional','Win rate after reaching a stage')} uses only the reached points shown in each row, separately for serving and receiving. This describes the shared point; it does not assign the action to the selected player.</p><div class="roles">${roles}</div></section><section class="section"><h2>How did points end?</h2><p class="small">${term('ending','Ending types')} describe the final action and who made it, relative to the selected player. Each percentage is out of the displayed count of ${bp?'included break points':'included points'} ending at that stage, not all points. Player point wins/losses describe the result, not who caused it.</p>${ending.map(terminalRows).join('')}</section>`;
}
controls.category.addEventListener('change',()=>{controls.search.value='';playerOptions(true);});
controls.search.addEventListener('input',()=>playerOptions());controls.player.addEventListener('change',matchOptions);controls.match.addEventListener('change',render);controls.subset.addEventListener('change',render);playerOptions(true);
</script></body></html>)---"
viewer_build <- function(output=viewer_path, replace=FALSE) {
 stopifnot(system2('git',c('check-ignore','-q',shQuote(output)))==0L)
 data<-viewer_payload(viewer_load())
 fonts<-viewer_fonts()
 page<-sub('__FROZEN_DATA__',viewer_json(data),viewer_template(),fixed=TRUE)
 page<-sub('__CONTEXT_DATA__',viewer_json(unname(viewer_context_payload())),page,fixed=TRUE)
 page<-sub('__FONT_STYLE__',fonts$style,page,fixed=TRUE)
 page<-sub('__FONT_LICENSE__',fonts$license,page,fixed=TRUE)
 tmp<-tempfile('.viewer-stage-',dirname(output));on.exit(if(file.exists(tmp))unlink(tmp),add=TRUE)
 writeLines(page,tmp,useBytes=TRUE)
 if(file.exists(output)) {
  if(viewer_hash(tmp)==viewer_hash(output))return(invisible(output))
  stopifnot(isTRUE(replace))
 }
 stopifnot(file.rename(tmp,output));invisible(output)
}
if(sys.nframe()==0L){viewer_build(replace='--replace' %in% commandArgs(TRUE));cat('Frozen local viewer installed:',viewer_path,'\n')}
