# Phase 1G: exact allowlist, temporary downloads, no redirects or fallback URLs.
source("R/download_pilot_data.R")

mr_config <- function() {
  codes <- sprintf("LS%03d", c(1:7,42,49))
  base <- "https://www.wtatennis.com/tournaments/806/"
  urls <- c(paste0(base,"montreal/2021"),paste0(base,"montreal/2021/draws"),
    "https://wtafiles.wtatennis.com/pdf/draws/2021/806/MDS.pdf",
    paste0(base,c(rep("montreal",7),rep("toronto",2)),"/2021/scores/",codes))
  ids <- c("overview","draw_html","draw_pdf",codes)
  data.frame(reference_id=ids,publisher="WTA",title=c("Montreal 2021 overview","Montreal 2021 draw","Montreal 2021 singles PDF",paste("2021 event 806",codes)),
    url=urls,local_path=paste0("data/raw/reference/montreal-2021-feasibility/",ids,c(".html",".html",".pdf",rep(".html",9))),
    media_type=c("text/html","text/html","application/pdf",rep("text/html",9)),match_code=c(rep("",3),codes),
    evidentiary_use=c("Displayed event identity and dates","Nine target match identities/results/statuses only","Nine target match identities/results/statuses only",rep("Match identity, whole-match counts, status and duration/date observations",9)),
    rights_limitation="WTA copyrighted; user-authorized local noncommercial educational audit only; no open-data or redistribution grant inferred",
    stringsAsFactors=FALSE)
}

mr_allow_url <- function(url) {
  if(length(url)!=1L||is.na(url)||!url %in% mr_config()$url)stop("URL outside Phase 1G allowlist.")
  invisible(TRUE)
}

mr_match_guard <- function(html,code) {
  codes<-sprintf("LS%03d",c(1:7,42,49));i<-match(code,codes)
  winner<-c("camila-giorgi","karolina-pliskova","camila-giorgi","aryna-sabalenka","karolina-pliskova","camila-giorgi","jessica-pegula","amanda-anisimova","fiona-ferro")
  loser<-c("karolina-pliskova","aryna-sabalenka","jessica-pegula","victoria-azarenka","sara-sorribes-tormo","cori-gauff","ons-jabeur","tereza-martincova","ajla-tomljanovic")
  round<-c("Final","Semifinals","Semifinals",rep("Quarterfinals",4),"Round of 64","Round of 64")
  if(is.na(i))stop("Unknown match code")
  pieces<-strsplit(html,paste0('class="tennis-match js-tennis-match js-match-0806-2021-',code),fixed=TRUE)[[1]]
  if(length(pieces)!=2L)stop("Expected event/year/match card missing or duplicated")
  card<-strsplit(pieces[2],"</table>",fixed=TRUE)[[1]][1]
  capture<-function(p,x){v<-regmatches(x,regexec(p,x,perl=TRUE))[[1]];if(length(v)<2)NA_character_ else v[2]}
  observed_round<-trimws(capture('(?s)<div class="tennis-match__round[^>]*>(.*?)</div>',card))
  slugs<-vapply(c("a","b"),function(side){
    row<-capture(paste0('(?s)(<tr class="match-table__row js-team-',side,'[^>]*>.*?</tr>)'),card)
    capture('href="/players/[0-9]+/([^"/]+)',row)
  },"")
  if(!isTRUE(observed_round==round[i])||!setequal(slugs,c(winner[i],loser[i])))stop("Match player pair or round differs from allowlist expectation")
  event<-capture('(?s)<span class="mc-live-score__tournament-name[^>]*>(.*?)</span>',html)
  if(is.na(event)||!grepl("Montreal, Canada",event,fixed=TRUE))stop("Displayed event differs from Montreal")
  invisible(TRUE)
}

mr_content_check <- function(path,r) {
  if(!file.exists(path)||file.info(path)$size==0)stop("Missing or empty reference.")
  bytes<-readBin(path,"raw",n=file.info(path)$size)
  if(r$media_type=="application/pdf") {
    if(rawToChar(head(bytes,5))!="%PDF-")stop("Not a PDF response.")
  } else {
    html<-rawToChar(bytes)
    if(!grepl("<html",html,ignore.case=TRUE)||!grepl("2021",html,fixed=TRUE)||!grepl("Montreal",html,ignore.case=TRUE))stop("Unexpected event/year HTML or unusable shell.")
    if(!nzchar(r$match_code)&&!grepl(paste0('<link rel="canonical" href="',r$url,'"'),html,fixed=TRUE))stop("Tournament canonical URL mismatch")
    if(nzchar(r$match_code))mr_match_guard(html,r$match_code)
    if(r$reference_id=="draw_html"&&!grepl("js-match-0806-2021-LS001",html,fixed=TRUE))stop("Draw match cards absent.")
  }
  invisible(TRUE)
}

mr_validate <- function(r) {
  if(r$retrieval_class=="unavailable")return(invisible(TRUE))
  if(!file.exists(r$local_path)||file.info(r$local_path)$size!=as.numeric(r$byte_size)||pilot_sha256(r$local_path)!=r$sha256)
    stop("Reference size/hash conflict; refusing overwrite: ",r$reference_id)
  if(r$retrieval_class=="original_response_bytes")mr_content_check(r$local_path,r)
  else if(r$retrieval_class=="browser_service_representation") {
    text<-paste(readLines(r$local_path,warn=FALSE),collapse="\n")
    if(!startsWith(text,"Browser-service representation; not original HTTP response bytes.")||!grepl(r$url,text,fixed=TRUE))stop("Invalid browser representation.")
  } else stop("Unknown retrieval class.")
}

mr_manifest <- function(required=TRUE) {
  path<-"data/manifests/montreal-reference-files.csv"
  if(!file.exists(path)){if(required)stop("No Montreal reference manifest.");return(NULL)}
  m<-read.csv(path,colClasses="character",na.strings=NULL,check.names=FALSE)
  config<-mr_config()
  if(anyDuplicated(m$reference_id)||any(!m$reference_id %in% config$reference_id))stop("Invalid reference IDs.")
  for(i in seq_len(nrow(m))) {
    r<-m[i,];c<-config[match(r$reference_id,config$reference_id),]
    # A service representation has its own path/media label, never an HTML label.
    fields<-setdiff(names(config),c("local_path","media_type"))
    if(!identical(unname(unlist(r[fields])),unname(unlist(c[fields]))))stop("Reference allowlist configuration changed.")
    if(r$retrieval_class!="browser_service_representation"&&(r$local_path!=c$local_path||r$media_type!=c$media_type))stop("Reference path changed.")
    mr_allow_url(r$url);mr_validate(r)
  }
  if(required&&!setequal(m$reference_id,config$reference_id))stop("Incomplete reference attempt manifest.")
  m
}

mr_request <- function(url,path,headers) {
  mr_allow_url(url)
  download.file(url,path,method="curl",mode="wb",quiet=TRUE,
    extra=c("-q","--fail","--no-location","--max-redirs 0","--proto '=https'","--connect-timeout 20","--max-time 60","--dump-header",shQuote(headers)))
}

download_montreal_references <- function() {
  config<-mr_config();m<-mr_manifest(FALSE)
  if(any(file.exists(config$local_path[!config$reference_id %in% m$reference_id])))stop("Unmanifested references exist; preserve and review.")
  dir.create(dirname(config$local_path[1]),recursive=TRUE,showWarnings=FALSE)
  for(i in seq_len(nrow(config))) {
    r<-config[i,]
    if(r$reference_id %in% m$reference_id){message("Preserved recorded state: ",r$reference_id);next}
    r$retrieval_class<-"unavailable";r$original_response_bytes<-FALSE
    r$attempted_at_utc<-format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC")
    r$retrieved_at_utc<-r$accessed_at_utc<-r$reported_crawl_date<-r$byte_size<-r$sha256<-r$http_result<-r$note<-""
    temp<-tempfile();headers<-tempfile()
    result<-tryCatch({
      mr_request(r$url,temp,headers)
      h<-readLines(headers,warn=FALSE);codes<-sub("^HTTP/[^ ]+ ([0-9]+).*","\\1",h[grepl("^HTTP/",h)])
      r$http_result<-if(length(codes))tail(codes,1) else "unavailable"
      if(r$http_result!="200"||any(grepl("^location:",h,ignore.case=TRUE)))stop("HTTP status/redirect rejected.")
      mr_content_check(temp,r)
      if(!file.copy(temp,r$local_path,overwrite=FALSE))stop("Final placement failed.")
      r$retrieval_class<-"original_response_bytes";r$original_response_bytes<-TRUE
      r$retrieved_at_utc<-format(Sys.time(),"%Y-%m-%dT%H:%M:%SZ",tz="UTC")
      r$byte_size<-as.character(file.info(r$local_path)$size);r$sha256<-pilot_sha256(r$local_path)
      TRUE
    },error=function(e)conditionMessage(e))
    if(!isTRUE(result)) {
      r$note<-as.character(result)
      if(file.exists(headers)){h<-readLines(headers,warn=FALSE);codes<-sub("^HTTP/[^ ]+ ([0-9]+).*","\\1",h[grepl("^HTTP/",h)]);if(length(codes))r$http_result<-tail(codes,1)}
    }
    m<-rbind(m,r);pilot_write_csv(m,"data/manifests/montreal-reference-files.csv")
    message(r$reference_id,": ",r$retrieval_class," HTTP ",r$http_result," ",r$note)
  }
  invisible(mr_manifest())
}

if(sys.nframe()==0L)download_montreal_references()
