# Focused display/data checks; DOM fixtures are not browser verification.
source('R/build_mcp_modern_point_phase_viewer.R')
checks<-0L
check<-function(ok,label){checks<<-checks+length(ok);if(!all(ok))stop(label)}
x<-viewer_load();payload<-viewer_payload(x)
check(length(payload$profiles)==2972,'All frozen match/player and pooled views')
check(nrow(x$profiles)==44580,'Exact frozen profile rows')
check(length(payload$coverage)==1263,'All match and category coverage records')
keys<-vapply(payload$profiles,function(g)paste(g$meta$aggregation_level,g$meta$category,g$meta$player,g$meta$match_id,sep='\r'),character(1))
check(!anyDuplicated(keys),'Unique profile keys')
p<-x$profiles
for(g in payload$profiles){
 m<-g$meta;z<-p[p$category==m$category&p$player==m$player&p$match_id==m$match_id&p$aggregation_level==m$aggregation_level,]
 for(n in names(m))check(identical(m[[n]],z[[n]][1]),paste('Metadata',n))
 for(i in seq_along(g$values))for(n in names(g$values[[i]]))check(identical(g$values[[i]][[n]],z[[n]][i]),paste('Frozen value',n))
 check(m$all_qa_points+m$completion_excluded_points+m$qa_withheld_points==m$inventory_points,'Coverage partition')
 e<-z[z$measure=='POINT_ENDING',];check(sum(e$phase_points)==m$all_qa_points,'Ending partition')
 check(all(e$wins+e$losses==e$phase_points),'Wins/losses partition')
 if(m$all_qa_points==0)check(all(is.na(e$phase_share)),'Unavailable is not zero')
}
check(viewer_json(list(text='</script><script>alert("x")</script>&\n',missing=NA_real_,zero=0))=='{"text":"\\u003c/script\\u003e\\u003cscript\\u003ealert(\\"x\\")\\u003c/script\\u003e\\u0026\\u000a","missing":null,"zero":0}','Safe serialization and distinct null/zero')
check(viewer_json('é')=='"é"','UTF-8 identity preservation')
check(viewer_string('')=='""','Empty string remains a string')
check(viewer_string('Player é 😀')=='"Player é 😀"','Safe Unicode labels preserve their bytes')
for(code in c(1:31,34,92,60,62,38,8232,8233)) {
 escaped<-if(code==34)'\\"' else if(code==92)'\\\\' else sprintf('\\u%04x',code)
 check(viewer_string(paste0('a',intToUtf8(code),'z'))==paste0('"a',escaped,'z"'),'Every unsafe character bypasses the fast path')
}
viewer_build(replace=TRUE)
before<-viewer_hash(viewer_path)
viewer_build();check(viewer_hash(viewer_path)==before,'Byte-identical independent generation')
# Node executes the display script against a minimal DOM fixture; no browser/UI automation.
node<-Sys.which('node')
if(!nzchar(node))node<-'/Users/narayanlekhi/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node'
check(file.exists(node),'Installed Node only')
js<-r"---(
const fs=require('fs'),vm=require('vm'),assert=require('assert'),crypto=require('crypto');let checks=0;
function check(ok,label){checks++;assert.ok(ok,label)}
const html=fs.readFileSync(process.argv[2],'utf8');
const encoded=html.match(/<script id="frozen-data" type="application\/json">([\s\S]*?)<\/script>/)[1];
check(crypto.createHash('sha256').update(encoded).digest('hex')==='123263579bec1b88d2bfab604ea7977cb5ef323add6ca89f5db10b4dc913de34','Byte-identical original payload');
const data=JSON.parse(encoded),script=html.match(/<\/script><script>([\s\S]*?)<\/script>/)[1];
check(!encoded.includes('<'),'No embedded closing tags');
check(!/<(?:img|link|iframe|form)\b/i.test(html),'No external resource elements or forms');
check(!/\b(?:fetch|XMLHttpRequest|WebSocket|sendBeacon|eval)\s*\(/.test(script),'No external request or dynamic evaluation API');
check(html.includes("connect-src 'none'"),'Network blocked by CSP');
function csv(s){let rows=[],row=[],val='',quoted=false;for(let i=0;i<s.length;i++){let c=s[i];if(c==='"'){if(quoted&&s[i+1]==='"'){val+='"';i++}else quoted=!quoted;}else if(!quoted&&(c===','||c==='\n')){row.push(val);val='';if(c==='\n'){rows.push(row);row=[]}}else if(c!=='\r'||quoted)val+=c;}if(val||row.length){row.push(val);rows.push(row)}let head=rows.shift();return rows.map(r=>Object.fromEntries(head.map((h,i)=>[h,r[i]])));}
const raw=csv(fs.readFileSync('data/pilot/mcp-modern-point-phase-v1-match-player-profiles.csv','utf8'));
const key=r=>JSON.stringify([r.aggregation_level,r.category,r.player,r.match_id]);
let lookup=new Map;for(const r of raw){const k=key(r);if(!lookup.has(k))lookup.set(k,[]);lookup.get(k).push(r)}
const numeric=new Set(['inventory_matches','eligible_matches','usable_matches','opponents','inventory_points','completion_excluded_points','qa_withheld_points','all_qa_points','qa_retention','source_date_batches','phase_points','wins','losses','win_share','loss_share','phase_share','reached','known_absent','unknown_reach','reach_share','conditional_win_rate','conditional_denominator']);
function equals(v,s,n){if(s==='')return v===null;return numeric.has(n)?v===Number(s):v===s}
for(const g of data.profiles){const rows=lookup.get(key(g.meta));check(rows?.length===15,'Exact source group');for(const [n,v] of Object.entries(g.meta))check(equals(v,rows[0][n],n),'JSON metadata fidelity '+n);for(let i=0;i<15;i++)for(const [n,v] of Object.entries(g.values[i]))check(equals(v,rows[i][n],n),'JSON value fidelity '+n)}
const coverage=csv(fs.readFileSync('data/pilot/mcp-modern-point-phase-v1-coverage.csv','utf8'));
for(const c of data.coverage){const row=coverage.find(r=>r.aggregation_level===c.aggregation_level&&r.category===c.category&&r.match_id===c.match_id);check(!!row,'Frozen coverage lookup');for(const [n,v] of Object.entries(c))check(row[n]===''?v===null:(typeof v==='number'?v===Number(row[n]):v===row[n]),'Coverage field fidelity '+n)}
// Minimal event/focus fixtures deliberately do not simulate layout or a browser.
class Element{
 constructor(){this.value='';this.textContent='';this.innerHTML='';this.handlers={};this.children=[];this.disabled=false;this.hidden=false;this.open=false;this.dataset={};this.attributes={};this.style={};this.isConnected=true;this.parentElement=null;this.rect={left:40,top:50,bottom:94,width:350,height:160};}
 replaceChildren(...children){this.children=children;this.value=children[0]?.value??''}
 addEventListener(n,fn){this.handlers[n]=fn}
 setAttribute(n,v){this.attributes[n]=v}getAttribute(n){return this.attributes[n]}
 closest(selector){return selector==='[data-definition]'&&this.dataset.definition?this:null}
 contains(node){for(let n=node;n;n=n.parentElement)if(n===this)return true;return false}
 getBoundingClientRect(){return this.rect}
 focus(){const old=doc.activeElement;doc.activeElement=this;if(old!==this){doc.handlers.focusout?.({target:old,relatedTarget:this});doc.handlers.focusin?.({target:this,relatedTarget:old});}}
 scrollIntoView(options){this.scrollOptions=options}
}
const ids=['category','search','player','match','subset','view','search-status','frozen-data','frozen-context','definition-panel','definition-title','definition-copy','definition-link','definition-close','definition-back','definitions',...['included','break','serve','return','plus1','rally','reach','conditional','ending'].map(n=>'definition-'+n)];const els=Object.fromEntries(ids.map(id=>[id,new Element]));els.category.value='ATP';els['frozen-data'].textContent=encoded;els.subset.value='ALL_INCLUDED';const contextEncoded=html.match(/<script id="frozen-context" type="application\/json">([\s\S]*?)<\/script>/)[1];els['frozen-context'].textContent=contextEncoded;check(crypto.createHash('sha256').update(contextEncoded).digest('hex')==='f43021f0244b2f1145b48aca803abe6296bd68122a23dcd4ced0164e27c352dd','Byte-identical context payload');
const doc={activeElement:null,handlers:{},getElementById:id=>els[id],createElement:()=>new Element,addEventListener(n,fn){this.handlers[n]=fn}};
const win={innerWidth:1060,innerHeight:800,handlers:{},addEventListener(n,fn){this.handlers[n]=fn}};
els['definition-panel'].hidden=true;for(const id of ['definition-title','definition-copy','definition-link','definition-close'])els[id].parentElement=els['definition-panel'];
let nextTimer=0,timers=new Map;const later=fn=>{timers.set(++nextTimer,fn);return nextTimer};const cancel=id=>timers.delete(id);const flush=()=>{const jobs=[...timers.values()];timers.clear();jobs.forEach(fn=>fn())};
const context=vm.createContext({document:doc,window:win,console,setTimeout:later,clearTimeout:cancel});vm.runInContext(script,context);
const act=(id,event,value)=>{els[id].value=value;els[id].handlers[event]()};
check(els.player.value==='Adrian Mannarino','Neutral mens default');
check(els.match.value==='ALL_MATCHES','Pooled default');
check(els.view.innerHTML.includes('2,827')&&els.view.innerHTML.includes('941'),'Frozen default coverage rendered');
for(const category of ['ATP','WTA']){act('category','change',category);check(els.player.value===(category==='ATP'?'Adrian Mannarino':'Ajla Tomljanovic'),'Category resets neutral default');const names=els.player.children.map(o=>o.value);check(names.length===(category==='ATP'?227:222),'Only exact approved identity hidden');for(const name of names){act('player','change',name);check(els.match.value==='ALL_MATCHES','Player resets pooled');const views=els.match.children.map(o=>o.value);for(const id of views){act('match','change',id);check(els.view.innerHTML.includes('Included / recorded points'),'Every view renders coverage');check(!els.view.innerHTML.includes('NaN')&&!els.view.innerHTML.includes('undefined'),'No invalid numbers');const g=data.profiles.find(g=>g.meta.category===category&&g.meta.player===name&&g.meta.match_id===id);if(g.meta.all_qa_points===0){check(els.view.innerHTML.includes('No usable points'),'Unavailable state retains identity');check(!els.view.innerHTML.includes('class="fill"'),'No fake zero bars')}}}}
act('category','change','ATP');act('search','input','Mannarino');check(els.player.value==='Adrian Mannarino','Search exact identity');act('match','change',els.match.children[1].value);act('category','change','WTA');check(els.search.value===''&&els.player.value==='Ajla Tomljanovic'&&els.match.value==='ALL_MATCHES','Category resets search/player/match');
act('search','input','<script>');check(els.player.disabled&&els.view.innerHTML.includes('No matching player'),'Empty search explicit');
act('category','change','ATP');
const group=data.profiles.find(g=>g.meta.player==='Adrian Mannarino'&&g.meta.aggregation_level==='POOLED_PLAYER');
vm.runInContext(`const fixture=DATA.profiles.find(g=>g.meta.player==='Adrian Mannarino'&&g.meta.aggregation_level==='POOLED_PLAYER');const cf=contextMap.get(contextKey(fixture.meta));contextMap.delete(contextKey(cf.meta));fixture.meta.player='<script>alert(1)</script>';cf.meta.player=fixture.meta.player;contextMap.set(contextKey(cf.meta),cf);controls.player.value=fixture.meta.player;render()`,context);
check(!els.view.innerHTML.includes('<script>')&&els.view.innerHTML.includes('&lt;script&gt;'),'Escaped source identity at display boundary');
for(const id of ['category','search','player','match'])check(html.includes(`for="${id}"`),'Labeled native keyboard control');
check(html.includes('outline:3px solid')&&html.includes('@media(max-width:650px)'),'Focus/mobile rules present, not visually verified');

vm.runInContext("contextMap.delete(contextKey(cf.meta));fixture.meta.player='Adrian Mannarino';cf.meta.player='Adrian Mannarino';contextMap.set(contextKey(cf.meta),cf)",context);
// Formatting, series scaling, identity scope and zero-residual display are pure display fixtures.
const evaluate=expression=>vm.runInContext(expression,context);
check(evaluate('pct(null)')==='Unavailable','Null percentage');
check(evaluate('pct(0)')==='0.0%','True zero');
check(evaluate('pct(0.00001)')==='<0.1%','Small positive');
check(evaluate('pct(0.001)')==='0.1%','Boundary formatting');
check(evaluate('pct(1)')==='100.0%','Common scale endpoint');
check(evaluate("listText('2021;2022;2023')")==='2021, 2022, 2023','Readable lists, no field mutation');
check(evaluate("hiddenIdentity('ATP','Dominik Koepfer')")===true,'Exact category/name hide');
check(evaluate("hiddenIdentity('WTA','Dominik Koepfer')")===false,'Other category unaffected');
check(evaluate("hiddenIdentity('ATP','Dominik Koepfer ')")===false,'No fuzzy identity hiding');
check(data.profiles.filter(g=>g.meta.aggregation_level==='POOLED_PLAYER').length===450,'All saved identities retained');
check(data.profiles.some(g=>g.meta.category==='ATP'&&g.meta.player==='Dominik Koepfer'&&g.meta.aggregation_level==='POOLED_PLAYER'&&g.meta.completion_excluded_points===407),'Koepfer coverage unchanged');
act('category','change','ATP');check(!els.player.children.some(o=>o.value==='Dominik Koepfer'),'Hidden identity absent only from selector');
check(els['search-status'].textContent.includes('227')&&els['search-status'].textContent.includes('228'),'Honest selector counts');
act('search','input','Koepfer');check(els.player.disabled,'Hidden identity not found by search');
act('category','change','WTA');check(els.player.children.length===222,'No women hidden');
check(els.match.children[0].textContent==='All recorded matches','Plain pooled label');
check(els.view.innerHTML.includes('Opponent’s Serve +1'),'Receiving role label');
check(els.view.innerHTML.includes('Server’s Serve +1'),'Plain serving label with unchanged phase ID');
check(els.view.innerHTML.includes('points reaching this stage')&&!els.view.innerHTML.includes('frozen denominator'),'Plain denominator label');
check(els.view.innerHTML.includes('One point can reach several stages; these percentages overlap.')&&els.view.innerHTML.includes('describe the shared point'),'Reach interpretation');
check(els.view.innerHTML.includes('Missing point details may change the apparent pattern of endings.'),'Visible retention warning');
check(!els.view.innerHTML.includes('class="diverging"'),'No diverging tracks');
let row=evaluate("endingRow({phase:'Serve',wins:1,losses:3,win_share:0.01,loss_share:0.03})");
check(row.includes('width:1%')&&row.includes('width:3%'),'Shares scaled only by 100, not within-phase');
check(row.includes('■ Wins')&&row.includes('▧ Losses'),'Noncolor series cues');
check(evaluate("endingRow({phase:'Serve',wins:0,losses:0,win_share:0,loss_share:0})").includes('width:0%'),'Observed zero retains bar');
check(!evaluate("endingRow({phase:'Serve',wins:0,losses:0,win_share:null,loss_share:null})").includes('style="width:'),'Null has no bar');
check(evaluate("endingRow({phase:'Serve',wins:1,losses:0,win_share:0.00001,loss_share:0})").includes('&lt;0.1%'),'Safe small-positive HTML');
act('category','change','ATP');check(els.view.innerHTML.includes('Zero-count endings: No recorded final shot, Unknown stage'),'Zero residuals in labeled details');
const nonzero=data.profiles.find(g=>g.values.some(r=>r.measure==='POINT_ENDING'&&r.phase==='Administrative'&&r.phase_points>0));
act('category','change',nonzero.meta.category);act('search','input','');act('player','change',nonzero.meta.player);act('match','change',nonzero.meta.match_id);
const section=els.view.innerHTML.split('class="zero-details"')[0];
check(section.includes('data-phase="Administrative"'),'Nonzero residual remains visible');
const heading='When do tennis players win and lose their points?';
check(html.includes('<h1>'+heading+'</h1>'),'Exact project question');
check(html.includes('“When” means the stage of a point.')&&html.includes('The ending identifies the final recorded action, not the shot that caused the result.'),'Stage meaning and recorded-action boundary');
check(html.includes('--cream:#f2e9ce')&&html.includes('--green:#14532d')&&html.includes('--rust:#9c3d1e')&&html.includes('--sand:#d0be9e'),'Portfolio palette');
check(html.includes('repeating-linear-gradient')&&html.includes('.roles{display:grid;grid-template-columns:1fr 1fr'),'Loss hatch and paired desktop rates');
check(html.includes('font-src data:')&&!html.includes('__FONT_'),'Only embedded font permitted; placeholders filled');
const embeddedFont=html.match(/base64,([A-Za-z0-9+/=]+)\) format/)[1];
check(crypto.createHash('sha256').update(Buffer.from(embeddedFont,'base64')).digest('hex')==='94bb7e04bb1a32237a67935c72526e42a3e52ee4aebd50299802b18a93114251','Exact saved Fraunces bytes');
check(html.includes('Copyright 2018 The Fraunces Project Authors')&&html.includes('SIL OPEN FONT LICENSE Version 1.1'),'Embedded copyright/license notice');
check(html.includes('cached binaries are not embedded because their saved rights were not verified'),'Font limitations disclosed');

// Exercise both frozen subsets for every saved selectable view.
const extension=JSON.parse(contextEncoded),extensionKeys=new Map(extension.map(g=>[key(g.meta),g]));
for(const n of ['included_points','inventory_break_points','completion_excluded_break_points','qa_withheld_break_points','score_known_inventory','score_unknown_inventory','included_score_unknown','included_break_points','break_points_faced','break_opportunities_receiving','included_ending_unknown','points','subset_denominator','phase_denominator','subset_share'])numeric.add(n);
const prefix='data/pilot/mcp-modern-point-context-v1-';
const extCoverage=new Map(csv(fs.readFileSync(prefix+'coverage.csv','utf8')).map(r=>[key(r),r]));
const extProfiles=new Map,extTypes=new Map;
for(const r of csv(fs.readFileSync(prefix+'match-player-profiles.csv','utf8')).filter(r=>r.subset==='BREAK_POINTS')){const k=key(r);if(!extProfiles.has(k))extProfiles.set(k,[]);extProfiles.get(k).push(r)}
for(const r of csv(fs.readFileSync(prefix+'phase-terminal-profiles.csv','utf8'))){const k=key(r);if(!extTypes.has(k))extTypes.set(k,[]);extTypes.get(k).push(r)}
for(const g of extension){const k=key(g.meta),c=extCoverage.get(k),p=extProfiles.get(k),t=extTypes.get(k)||[];check(!!c&&p.length===15,'Complete extension key');for(const [n,v] of Object.entries(g.meta))check(equals(v,c[n],n),'Context metadata fidelity '+n);for(const v of g.bp){const r=p.find(r=>r.measure===v.measure&&r.role===v.role&&r.phase===v.phase);for(const [n,value] of Object.entries(v))check(equals(value,r[n],n),'BP value fidelity '+n)}check(t.length===g.types.length,'Every terminal cell embedded');for(let i=0;i<t.length;i++)for(const [n,v] of Object.entries(g.types[i]))check(equals(v,t[i][n],n),'Terminal type fidelity '+n)}
check(!contextEncoded.includes('<'),'Safe context serialization');
check(html.includes('Context release: MCP_MODERN_POINT_CONTEXT_1.0.0'),'Visible extension provenance');
check(extension.length===2972,'Every original profile has extension coverage');
for(const cat of ['ATP','WTA']){act('category','change',cat);for(const name of els.player.children.map(o=>o.value)){act('player','change',name);for(const id of els.match.children.map(o=>o.value)){act('match','change',id);const level=id==='ALL_MATCHES'?'POOLED_PLAYER':'MATCH_PLAYER';const cg=extensionKeys.get(key({aggregation_level:level,category:cat,player:name,match_id:id}));for(const sub of ['ALL_INCLUDED','BREAK_POINTS']){act('subset','change',sub);for(const title of ['At what stage did points end?','How far did points go?','How often did the player win after each stage was reached?','How did points end?'])check(els.view.innerHTML.includes('<h2>'+title+'</h2>'),'Four questions in every selection');check(els.view.innerHTML.includes('faced while serving')&&els.view.innerHTML.includes('opportunities while receiving'),'Both role exposures visible');check(els.view.innerHTML.includes('unclear scores before the point')&&els.view.innerHTML.includes('unclear ending type'),'Unknowns beside results');check(!els.view.innerHTML.includes('NaN')&&!els.view.innerHTML.includes('undefined'),'Subset has no invalid values');if(sub==='BREAK_POINTS'){check(els.view.innerHTML.includes('Share of included break points.'),'Subset-specific denominator');if(cg.meta.included_break_points===0)check(els.view.innerHTML.includes('No included opportunities'),'Zero BP remains unavailable');}check(els.match.value===id&&els.player.value===name,'Subset preserves selection');}}}}
act('subset','change','BREAK_POINTS');act('category','change','ATP');check(els.subset.value==='BREAK_POINTS'&&els.player.value==='Adrian Mannarino'&&els.match.value==='ALL_MATCHES','Category reset preserves selected subset');
act('player','change',els.player.children[1].value);check(els.subset.value==='BREAK_POINTS'&&els.match.value==='ALL_MATCHES','Player reset preserves selected subset');
check(html.includes('collapsed unreturnable notation is Other supported ending')&&html.includes('not all points or proven clutch ability'),'Recorded-annotation claims only');
act('subset','change','ALL_INCLUDED');

// Presentation rules use saved values; no rescaling or new denominator.
const staticIds=[...html.split('<script id="frozen-data"')[0].matchAll(/\bid="([^"]+)"/g)].map(m=>m[1]);check(new Set(staticIds).size===staticIds.length,'Unique static IDs: Return glossary entry is distinct from back control');
for(const heading of ['At what stage did points end?','How far did points go?','How often did the player win after each stage was reached?','How did points end?'])check(els.view.innerHTML.includes('<h2>'+heading+'</h2>'),'Question-led section '+heading);
check(els.view.innerHTML.includes('Each included point appears once.')&&els.view.innerHTML.includes('selected player'),'Ending count rule');
check(els.view.innerHTML.includes('not who caused it')&&els.view.innerHTML.includes('Each percentage is out of the displayed count'),'Type/actor denominator');
check(html.indexOf('id="important-limitations"')<html.indexOf('id="definitions"')&&html.indexOf('id="definitions"')<html.indexOf('id="methodology"'),'Limitations then definitions then methodology');
check(!/<details id="(?:definitions|methodology)"[^>]*\bopen\b/.test(html),'Both references initially collapsed');
check(html.includes('Illustrative example, not a player result:')&&html.includes('Both use all 100 points.'),'Reading guide explicitly illustrative');
check(!els.view.innerHTML.includes('QA-withheld')&&!els.view.innerHTML.includes('completion-excluded')&&!els['search-status'].textContent.includes('identities'),'Visible labels use plain language');
for(const id of ['included','break','serve','return','plus1','rally','reach','conditional','ending']){check(html.includes('id="definition-'+id+'" tabindex="-1"'),'Focusable glossary target '+id);check(html.includes('id="definition-text-'+id+'"'),'Fixed term description '+id);check(evaluate('!!definitionCopy['+JSON.stringify(id)+']'),'Explanation dictionary '+id);check(html.match(new RegExp('<p id="definition-text-'+id+'">([^<]*)</p>'))[1]===evaluate('definitionCopy['+JSON.stringify(id)+'].copy'),'Popup and glossary agree '+id)}
const selected=()=>JSON.stringify(['category','search','player','match','subset'].map(id=>els[id].value));
const beforeHelp=selected(),button=new Element;button.dataset.definition='plus1';button.rect={left:350,top:540,bottom:584,width:80,height:44};
let prevented=0;const event=(target,extra={})=>({target,preventDefault(){prevented++},...extra});
doc.handlers.pointerover(event(button,{pointerType:'mouse'}));check(!els['definition-panel'].hidden&&button.getAttribute('aria-expanded')==='true','Mouse hover opens explanation');
check(els['definition-copy'].textContent.includes('including errors')&&els['definition-link'].href==='#definition-plus1','Correct copy and target');
doc.handlers.pointerout(event(button,{pointerType:'mouse',relatedTarget:els['definition-link']}));flush();check(!els['definition-panel'].hidden,'Pointer transit to panel stays open');
doc.handlers.pointerout(event(els['definition-link'],{pointerType:'mouse',relatedTarget:null}));flush();check(els['definition-panel'].hidden,'Unpinned hover closes after grace period');
button.focus();check(!els['definition-panel'].hidden,'Keyboard focus opens explanation');
doc.handlers.keydown(event(button,{key:'Tab',shiftKey:false}));check(doc.activeElement===els['definition-link'],'Tab enters help link from focused term');
doc.handlers.keydown(event(els['definition-link'],{key:'Tab',shiftKey:true}));check(doc.activeElement===button&&!els['definition-panel'].hidden,'Shift-Tab returns to open term');doc.handlers.keydown(event(button,{key:'Tab',shiftKey:false}));
doc.handlers.keydown(event(els['definition-link'],{key:'Escape'}));check(els['definition-panel'].hidden&&doc.activeElement===button&&button.getAttribute('aria-expanded')==='false','Escape closes and returns focus');
check(prevented===4,'Tab, Shift-Tab and Escape handled');
button.focus();check(els['definition-panel'].hidden,'Dismissed help does not immediately reopen');
const outside=new Element;outside.focus();button.focus();check(!els['definition-panel'].hidden,'Help can reopen after leaving term');
doc.handlers.click(event(button));check(!els['definition-panel'].hidden,'Tap/click pins explanation');
doc.handlers.pointerout(event(button,{pointerType:'mouse',relatedTarget:null}));flush();check(!els['definition-panel'].hidden,'Pinned help survives pointer exit');
doc.handlers.click(event(button));check(els['definition-panel'].hidden,'Second tap dismisses');
doc.handlers.click(event(button));check(!els['definition-panel'].hidden,'Next tap reopens');
doc.handlers.pointerdown(event(outside));check(els['definition-panel'].hidden,'Outside pointer closes');
doc.handlers.click(event(button));win.innerWidth=375;win.innerHeight=600;win.handlers.resize();
check(parseFloat(els['definition-panel'].style.left)>=12&&parseFloat(els['definition-panel'].style.left)+350<=363,'Synthetic narrow viewport horizontal bounds');
check(els['definition-panel'].style.top==='380px','Synthetic panel placed above low trigger');
button.rect={left:20,top:20,bottom:64,width:80,height:44};win.handlers.scroll();check(els['definition-panel'].style.top==='64px','Scroll recomputes anchor position');
check(html.includes('max-width:calc(100vw - 24px)')&&html.includes('max-height:calc(100dvh - 24px)')&&html.includes('overflow:auto'),'Narrow-screen CSS constraints, unverified layout');
els['definition-link'].handlers.click(event(els['definition-link']));check(els.definitions.open&&els['definition-panel'].hidden&&doc.activeElement===els['definition-plus1'],'See definitions opens and focuses correct entry');
check(els['definition-plus1'].scrollOptions.block==='start'&&!els['definition-back'].hidden,'Glossary target scrolling and return control');
els['definition-back'].handlers.click();check(doc.activeElement===button,'Return from glossary restores term focus');
els['definition-close'].handlers.click();check(els['definition-panel'].hidden&&doc.activeElement===button,'Close button restores term focus');
check(selected()===beforeHelp,'Help, glossary, resize and dismissal preserve all selections');
win.innerWidth=1060;win.innerHeight=800;
for(const sub of ['ALL_INCLUDED','BREAK_POINTS']){act('subset','change',sub);const g=data.profiles.find(g=>g.meta.category===els.category.value&&g.meta.player===els.player.value&&g.meta.match_id===els.match.value);const cg=extensionKeys.get(key(g.meta)),values=sub==='ALL_INCLUDED'?g.values:cg.bp;for(const r of values.filter(r=>r.measure==='REACH'&&r.role!=='ALL')){check(els.view.innerHTML.includes(numString(r.wins)+' wins / '+numString(r.conditional_denominator)+' '+(sub==='BREAK_POINTS'?'included break points':'included points')+' reaching this stage while '+(r.role==='SERVER'?'serving':'receiving')),'Exact role denominator displayed')}for(const t of cg.types.filter(t=>t.subset===sub)){check(els.view.innerHTML.includes(numString(t.points)+' / '+numString(t.phase_denominator)),'Frozen type denominator displayed')}}
function numString(n){return n===null?'Unavailable':n.toLocaleString('en-US')}


// Council wording is tested against the same frozen facts, not treated as evidence.
const currentSource=fs.readFileSync('R/build_mcp_modern_point_phase_viewer.R','utf8'),digest=s=>crypto.createHash('sha256').update(s).digest('hex');
check(digest(currentSource.match(/<style>([\s\S]*?)<\/style>/)[1])==='02627c11a016ee94ec40e4f50703ae898908b10723eeb7166edbf3d01740df7a','Layout/style byte preservation');
check(digest(currentSource.slice(currentSource.indexOf('const helpPanel='),currentSource.indexOf('function playerOptions')))==='a3c2e3598e36f70c354bfbec8ded9af4a5636801f8ae397853c149d0f2668a90','Definition interaction implementation unchanged');
check(digest(currentSource.slice(currentSource.indexOf('controls.category.addEventListener'),currentSource.indexOf('</script></body>')))==='43be81e198a55d3d038d810e8372d1e910e51c2ba0f22719ebe5deb2710dcf99','Selector handlers unchanged');
const allDefinitions=evaluate('definitionCopy');check(Object.keys(allDefinitions).length===37,'All reviewed glossary terms');
for(const [id,def]of Object.entries(allDefinitions)){
 const entry=html.match(new RegExp('<h3 id="definition-'+id+'" tabindex="-1">([^<]*)</h3><p id="definition-text-'+id+'">([^<]*)</p>'));
 check(!!entry&&entry[1]===def.label&&entry[2]===def.copy,'Every label, popup copy and glossary agree '+id);
 check(!/\b(?:frozen|QA|payload|notation|structural absence|source identity|denominator|eligible charts|inclusion checks)\b/i.test(def.label+' '+def.copy),'No construction jargon in definition '+id);
 check((def.copy.match(/[.!?](?=\s|$)/g)||[]).length<=2,'At most two sentences '+id);
}
check(allDefinitions.included.copy.includes('full point')&&!allDefinitions.included.copy.includes('checks'),'Clear point meaning; process kept out');
check(allDefinitions.break.copy.includes('regular game')&&allDefinitions.break.copy.includes('Tiebreak points do not count'),'Break meaning excludes tiebreak');
check(allDefinitions.zero.copy.includes('No events')&&allDefinitions.notreached.copy.includes('ended before')&&allDefinitions.unknown.copy.includes('does not clearly show')&&allDefinitions.unavailable.copy.includes('No percentage'),'Zero, absence, missing evidence and unavailable rate distinct');
check(allDefinitions.forced.copy.includes('match record describes')&&allDefinitions.unforced.copy.includes('match record describes'),'Error labels remain recorded descriptions');
check(allDefinitions.administrative.copy.includes('no final shot named')&&!allDefinitions.administrative.copy.includes('no physical action occurred'),'Administrative label does not deny prior play');
check(html.includes('Unknown reaches stay outside that denominator; an unknown winner among reached points makes the rate unavailable.'),'Method wording matches unchanged conditional formula');
check(!html.includes('An unknown reach can make a rate unavailable.'),'Misleading former definition removed');
check(evaluate("phaseLabel('Server Serve +1')")==='Server’s Serve +1'&&evaluate("phaseLabel('Unresolved')")==='Unknown stage','Plain stage aliases');
for(const [raw,label]of Object.entries(evaluate('endingLabels')))check(evaluate('endingLabels['+JSON.stringify(raw)+']')===label,'Ending alias '+raw);
check(evaluate("actorLabels['Nonphysical']")==='No final-shot player named'&&evaluate("actorLabels['Unresolved actor']")==='Final-action player unclear','Actor absence versus unknown aliases');
check(encoded.includes('Server Serve +1')&&contextEncoded.includes('Other supported ending')&&contextEncoded.includes('Nonphysical'),'Scientific IDs remain original behind display aliases');

console.log('Node frozen-field and display-fixture checks:',checks,'PASS');
)---"
script<-tempfile('viewer-check-',fileext='.js')
writeLines(js,script,useBytes=TRUE)
result<-system2(node,c(shQuote(script),shQuote(viewer_path)),stdout=TRUE,stderr=TRUE)
cat(paste(result,collapse='\n'),'\n');check(is.null(attr(result,'status')),'Node display checks');unlink(script)
check(system2('git',c('check-ignore','-q',viewer_path))==0L,'Viewer remains ignored')
cat('R pin, fidelity, accounting and deterministic checks:',checks,'PASS\n')
