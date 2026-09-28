# Phase 2E release 1.0.0: eligibility/count reconstruction only; inert when sourced.
pe_baseline <- 'f3861494dc72b432479a0ac748e5204b25514690'
pe_dir <- 'data/pilot/current-context-pilot-revalidation'
pe_names <- c('input-provenance','pilot-comparison','exclusion-comparison','bundle-comparison','rights-scope','decisions','summary')
pe_need <- function(ok,why) if(!isTRUE(ok))stop(paste('CURRENT_CONTEXT_PILOTS_BLOCKED:',why),call.=FALSE)
pe_trace <- new.env(parent=emptyenv());pe_trace$reads<-character();pe_trace$calls<-character();pe_trace$parsed<-character()
pe_pins <- function()
c(.gitignore = "90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217",
AGENTS.md = "67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`data/pilot/anomaly/anomaly-coverage.csv` = "72e1a325e434645b9d440be30f759a84e99360857cc55832b434dca16ccd8e39",
`data/pilot/anomaly/anomaly-disposition.csv` = "3f5d084b1116954de31f2b1e3f4ba4c6880236a791cc2e4c5449d6e060a9c8eb",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
`data/pilot/anomaly/anomaly-validation-checks.csv` = "9593116997633f55c2fbd14e9d076aadd657c46cc773d481c5145575e4f3b583",
`data/pilot/atp_indian_wells_2023.csv` = "31b43453ed46a709fd51bd50b372ec2c605258d5a9814db13c963377def2ac6a",
`data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv` = "c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
`data/pilot/development-2021/montreal-inventory/html-draw.csv` = "611de6706379a6272f75fdbfd1a6a6a59f780cb22f195f7e63b892ee91b24302",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/development-2021/montreal-reference-feasibility/coverage-scenarios.csv` = "180f6ba53e30677c3702ed3cd11274b4348075caa8411c97d83af071812516b4",
`data/pilot/development-2021/montreal-reference-feasibility/feasibility-dispositions.csv` = "0c879ab4d6fea166c8ee29784d6f73cccc9688c950457d99170ab809eb9f178c",
`data/pilot/development-2021/montreal-reference-feasibility/field-comparisons.csv` = "d687758bf17c808f85cf7d6e613a80d0629f9a9dacfdca0d618c561132d0ad5b",
`data/pilot/development-2021/montreal-reference-feasibility/official-stat-observations.csv` = "f498a9da20d037771622276332472c3d53bac1e6060141576a8e78b89391f008",
`data/pilot/development-2021/montreal-reference-feasibility/pdf-target-evidence.csv` = "7631d244260c8464e54b31c1a5cc74b7689652eb9154918d8826b4ed27a5ba54",
`data/pilot/development-2021/montreal-reference-feasibility/reference-checks.csv` = "e4999f73eb8768118a7f66ec929c145404447834723579c79c430b3658a43140",
`data/pilot/development-2021/montreal-reference-feasibility/reference-match-inventory.csv` = "77bd218219f554b056296d642d243eb4d796cb6f65681122959ffa806cce4ffe",
`data/pilot/development-2021/montreal-reference-feasibility/status-evidence.csv` = "3b9e6478ac9e1496d5ccdd67d0f15bbe8560cb3bbbfa8a0637fb78eb06c58023",
`data/pilot/development-2021/montreal-reference-feasibility/structural-checks.csv` = "f1d7ab46958d1e5448e7a5ee0249bbadd22518cf563a3bd9844b5aa9a0bfc133",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
`data/pilot/inventory/atp-pdf-observations.csv` = "260b281c7992e79b47dafc21a236c24fe5fa33e5b38b2cdd581c630b2a0e91cd",
`data/pilot/inventory/conflicts.csv` = "1a5234946b836f4f2c1b6ca26f1222b3a5ae4fd7d880c2db475ff597696f61f6",
`data/pilot/inventory/identity-review.csv` = "57b29e77bd6a31e525eb6b2289275313ab45999732774cf8c1cc9e3bb1fbb3d9",
`data/pilot/inventory/inventory-summary.csv` = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
`data/pilot/inventory/match-reconciliation.csv` = "e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
`data/pilot/inventory/normalization-decisions.csv` = "e8e63e2947ff0f36781013d0f06308c1e4b64206f6f2764932bb7f5532360225",
`data/pilot/inventory/official-matches.csv` = "3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
`data/pilot/inventory/official-only.csv` = "3d170c1cc2c66e7a957cf8b32f743d2631463c0b3a2d90888bf917c8ad32e544",
`data/pilot/inventory/reference-comparison.csv` = "e8fa870adcf0818c32b6f2df13a724f90a000c1bf3d3e12340c4041198b70e4e",
`data/pilot/inventory/reference-conflicts.csv` = "8a7df76185b3f591c2fc2067941b6a2a0e8108b9ebe6fc5f41c3d8ceeb4d0f7a",
`data/pilot/inventory/round-summary.csv` = "f4d34ec90b25ee96473ebedcd43e0589ca2b92dfb6d6c6386923d90d020f9466",
`data/pilot/inventory/source-matches.csv` = "c5beb37d7453558cec3501ed1f28db27c3c634d953d99cb3e5c4763a7595145f",
`data/pilot/inventory/source-only.csv` = "a0297e28dbfdea9291ec165c821b17fe9fdbb512360550412010addfeee6777d",
`data/pilot/inventory/status-summary.csv` = "64c7b7975bd58f03a74cc343528890bcd7c1372750f1ba0c1d4401ccd851b352",
`data/pilot/package-b-evidence-route-proposal/cell-evidence-gaps.csv` = "830dbd35fd603c7da5a1012c4f7e73220e21402b9dda9985e3eda843affeb2a2",
`data/pilot/package-b-evidence-route-proposal/decisions.csv` = "70828d4b104f11cf1b3e02455e9c25f8b74ea32e14a5e202f2193a0111c977d7",
`data/pilot/package-b-evidence-route-proposal/input-provenance.csv` = "6a7b33b7d5e52645850b982ae5abb3e96d2cfb925131c5c8367906e26ae52efd",
`data/pilot/package-b-evidence-route-proposal/route-assessment.csv` = "b91b3cec9602d2307653fb0e1c8f6b3ee68d4a31badc29f112da92212139470c",
`data/pilot/package-b-evidence-route-proposal/staged-execution-plan.csv` = "ff908155b5ac119f5cdc5319ae5f104811788bc2cf1f302ce7bd923f0d71f61a",
`data/pilot/package-b-evidence-route-proposal/summary.csv` = "358fdbb1d60c6c168e1ac93afb19763d94f703af02efa9859fd70db6a063118d",
`data/pilot/wta_indian_wells_2023.csv` = "03afd50a16de2d955f8e45760bc2e9667362288f2c791ccacb5c1047908b149f",
`data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html` = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
`data/raw/reference/indian-wells-2023-anomaly/wta-draws.html` = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
`data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html` = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
`data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf` = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
`data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt` = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
`data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt` = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
`data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf` = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
`data/raw/reference/montreal-2021-feasibility/draw_html.html` = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
`data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf` = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
`data/raw/reference/montreal-2021-feasibility/LS001.html` = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
`data/raw/reference/montreal-2021-feasibility/LS002.html` = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
`data/raw/reference/montreal-2021-feasibility/LS003.html` = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
`data/raw/reference/montreal-2021-feasibility/LS004.html` = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
`data/raw/reference/montreal-2021-feasibility/LS005.html` = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
`data/raw/reference/montreal-2021-feasibility/LS006.html` = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
`data/raw/reference/montreal-2021-feasibility/LS007.html` = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
`data/raw/reference/montreal-2021-feasibility/LS042.html` = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
`data/raw/reference/montreal-2021-feasibility/LS049.html` = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
`data/raw/reference/montreal-2021-feasibility/overview.html` = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv` = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv` = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json` = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv` = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/data-source-contract.md` = "329d1160cceac55969dc53aedae57f57233978d5ae60718e1b300091d7175212",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/indian-wells-inventory-reconciliation.md` = "8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e",
`docs/package-b-evidence-route-proposal.md` = "0cd8cc94043b37764456b46ed0a56cc941006ae88ae136dbd0f310ef12e3d3e8",
`docs/post-otd-analytical-path.md` = "14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
`docs/wta-2021-montreal-chronology-stage-a.md` = "842f603c0a1075ca58395f89a805b981a6f07fdda3f043de95ee169d0c62db12",
`docs/wta-2021-montreal-completed-match-coverage.md` = "168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8",
`docs/wta-2021-montreal-inventory-reconciliation.md` = "6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4",
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
PROJECT_CONTEXT.md = "865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1",
`R/audit_2021_annual_data.R` = "4e376a0e1e2ee822515d2d227f457bed095cc4dca61a6285a29ec07311a423bd",
`R/audit_montreal_completed_match_coverage.R` = "f5e1b57c38a72cf13a7e2a3ce988ce1067b4ac2d53e389423aa8efe40cf84749",
`R/audit_montreal_reference_feasibility.R` = "d0935e2e0d1a72bd32252883f2d601dcc09cddbc906ca149b26512a36648d9f1",
`R/audit_pilot_data.R` = "82bed285763b478614c4c296f92eeb554a6ef104134080e054c7c7b720f6e608",
`R/audit_wta_anomaly.R` = "90b0c3d40fbe4a69e30de51b6a089ace535c26e62d32aeec6e1a9aa9429687a4",
`R/download_2021_annual_data.R` = "43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068",
`R/download_anomaly_references.R` = "596943db417128ff17498353864d8336b788b87add8e1fb2fcde24070d751c2d",
`R/download_inventory_references.R` = "077e4fe176a977f1d64f75b5f86d1e468e26baa5f7e27485adfee0655adc084b",
`R/download_montreal_references.R` = "a48984a9a9b87275ed561109e20d3e0331ce5aef6fc440044d53417291ff2287",
`R/download_pilot_data.R` = "5facb085d14f1c5007c97cd7008d77173cc9e7b74a96eca1c7bc49696ccb4299",
`R/implement_montreal_recovery.R` = "224d0dbcab70b184f0fc8ac67b924b2e15f77cbe698664a7594d4d11606c8e6d",
`R/reconcile_indian_wells_inventory.R` = "84ae65145e3505e578a7287af2bf25d08f8e8f25d2bc35be7fb0b10ecd9fdb93",
`R/reconcile_montreal_inventory.R` = "52dd718b67a95aa01bc015daa66f8a5a739cc6ccd121c5229046ce68b3053e24",
`R/review_wta_2021_montreal.R` = "5b180b4a30521ed126fc75363065c5b376fac6dc7994bb73823dcac4064b07ef"
)
pe_fields <-
function ()
c("ace", "df", "svpt", "1stIn", "1stWon", "2ndWon", "SvGms", "bpFaced", "bpSaved")
pe_pair_validity <-
function (a, b)
{
    need <- pe_fields()
    pe_need(identical(names(a), need) && identical(names(b), need), "nine named counts each side")
    v <- c(a, b)
    bad <- any(!is.na(v) & (!is.finite(v) | v < 0 | v != floor(v)))
    for (x in list(a, b)) {
        A <- x["ace"]
        D <- x["df"]
        S <- x["svpt"]
        I <- x["1stIn"]
        F <- x["1stWon"]
        Q <- x["2ndWon"]
        G <- x["SvGms"]
        B <- x["bpFaced"]
        V <- x["bpSaved"]
        failures <- c(I > S, F > I, Q > S - I, D > S - I, Q + D > S - I, V > B, B > S, A > F + Q, G > S, S == 0)
        bad <- bad || any(failures, na.rm = TRUE)
    }
    list(invalid = bad, missing = anyNA(v))
}
pe_match_index <-
function (raw_ids, linked_ids)
{
    pe_need(!anyNA(c(raw_ids, linked_ids)) && !anyDuplicated(raw_ids) && !anyDuplicated(linked_ids) && setequal(raw_ids,
        linked_ids), "duplicate, ambiguous or missing match mapping")
    match(raw_ids, linked_ids)
}
pe_orientation <-
function (winner_id, loser_id)
{
    pe_need(!anyNA(c(winner_id, loser_id)) && all(grepl("^[0-9]+$", c(winner_id, loser_id))) && all(winner_id !=
        loser_id), "missing, ambiguous or identical source player IDs")
    vapply(seq_along(winner_id), function(k) order(c(winner_id[k], loser_id[k]), method = "radix")[1] == 1, TRUE)
}
pe_adapter <-
function (input)
{
    e <- pe_legacy()
    b <- input$base
    res <- list()
    raws <- list()
    bundles <- list()
    for (cell in c("ATP|2023|Indian Wells", "WTA|2023|Indian Wells", "WTA|2021|Canada")) {
        bits <- strsplit(cell, "|", fixed = TRUE)[[1]]
        tour <- bits[1]
        year <- as.integer(bits[2])
        fam <- bits[3]
        id <- if (year == 2021)
            "2021-806"
        else if (tour == "ATP")
            "2023-0404"
        else "2023-609"
        raw <- b$data[[paste(tour, year, sep = "|")]]
        raw <- raw[raw$tourney_id == id, , drop = FALSE]
        ids <- paste(tour, raw$tourney_id, raw$match_num, sep = ":")
        origin <- rep("original_source", nrow(raw))
        if (year == 2023) {
            links <- input$iw$`match-reconciliation`
            links <- links[links$tour == tour, , drop = FALSE]
            k <- pe_match_index(ids, links$source_id)
            links <- links[k, , drop = FALSE]
            o <- input$iw$`official-matches`
            o <- o[!o$bye & o$tour == tour, , drop = FALSE]
            o <- o[pe_match_index(links$official_id, o$official_id), , drop = FALSE]
            pe_need(all(o$winner_id == raw$winner_id & o$loser_id == raw$loser_id & o$round == raw$round), "official/source pair, winner or round mismatch")
            source <- input$iw$`source-matches`
            source <- source[source$tour == tour, , drop = FALSE]
            source <- source[pe_match_index(ids, source$source_id), , drop = FALSE]
            status <- ifelse(o$status == "completed", "normally_completed", o$status)
            quarantine <- source$statistical_bundle_quarantined & status == "normally_completed"
            evidence <- paste(links$reference_id, links$reference_locator, links$resolution_state, sep = ";")
            conflict <- nzchar(links$conflicts) | quarantine
            detail <- paste(links$conflicts, source$reason_codes, sep = ";")
            official_id <- links$official_id
            policy <- ifelse(links$resolution_state == "not_required", "corroborated_inventory", links$resolution_state)
        }
        else {
            d <- input$m$dispositions
            k <- pe_match_index(paste0("sackmann:", ids), d$source_audit_id)
            d <- d[k, , drop = FALSE]
            pe_need(all(d$status_resolved & !d$unresolved & d$winner_agreement & d$score_agreement), "Montreal unresolved status/linkage")
            pe_need(all(d$source_winner == raw$winner_id & d$round == raw$round & d$source_score == raw$score),
                "Montreal source link mismatch")
            pe_need(!anyNA(d$source_statistical_quarantine) && all(d$source_statistical_quarantine == "none_adopted_for_this_event"),
                "Montreal quarantine flag changed")
            status <- d$classification
            quarantine <- rep(FALSE, nrow(d))
            origin <- d$count_origin
            evidence <- paste(d$html_locator, d$pdf_locator, sep = ";")
            official_id <- d$official_code
            policy <- d$status_policy
            conflict <- !is.na(d$applicable_resolution)
            detail <- paste(d$source_status, d$html_status, d$pdf_status, d$applicable_resolution, sep = ";")
        }
        pe_need(all(status %in% c("normally_completed", "retirement", "walkover")), "unknown/conflicting status blocks all pilots")
        expected <- if (year == 2021)
            c(49L, 5L, 1L)
        else if (tour == "ATP")
            c(91L, 4L, 0L)
        else c(92L, 2L, 1L)
        pe_need(identical(as.integer(table(factor(status, levels = c("normally_completed", "retirement", "walkover")))),
            expected), "pilot status accounting changed")
        pe_need(identical(ids[quarantine], if (tour == "WTA" && year == 2023)
            "WTA:2023-609:268"
        else character()), "quarantine rule changed")
        oriented <- pe_orientation(raw$winner_id, raw$loser_id)
        counts <- raw
        if (year == 2021) {
            f <- input$mi$overlay$field_decisions
            targets <- e$mro_targets()
            targets <- targets[targets$recovery, ]
            pe_need(nrow(f) == 126 && !anyDuplicated(paste(f$source_audit_id, f$source_field)) && setequal(f$source_audit_id,
                targets$audit_id), "Montreal recovery scope changed")
            for (j in which(origin == "approved_recovery_overlay")) {
                ff <- f[f$source_audit_id == paste0("sackmann:", ids[j]), , drop = FALSE]
                fields <- c(paste0("w_", pe_fields()), paste0("l_", pe_fields()))
                pe_need(nrow(ff) == 18 && setequal(ff$source_field, fields) && all(is.na(raw[j, fields])) && status[j] ==
                  "normally_completed", "recovery missing, partial or outside completed scope")
                pe_need(all(ff$source_winner_id == raw$winner_id[j] & ff$source_loser_id == raw$loser_id[j]) &&
                  all(ff$policy_version == "1.0.0") && all(ff$structural_validation_state == "passed_51_of_51_applicable_checks"),
                  "recovery mapping/proof differs")
                counts[j, fields] <- as.list(ff$value[match(fields, ff$source_field)])
            }
            pe_need(sum(origin == "approved_recovery_overlay") == 7 && sum(status == "normally_completed" & origin ==
                "original_source") == 42, "42+7 recovery accounting")
        }
        valid <- logical(nrow(raw))
        reason <- character(nrow(raw))
        aa <- bb <- vector("list", nrow(raw))
        for (j in seq_len(nrow(raw))) {
            w <- setNames(as.numeric(counts[j, paste0("w_", pe_fields())]), pe_fields())
            l <- setNames(as.numeric(counts[j, paste0("l_", pe_fields())]), pe_fields())
            aa[[j]] <- if (oriented[j])
                w
            else l
            bb[[j]] <- if (oriented[j])
                l
            else w
            vv <- pe_pair_validity(w, l)
            ck <- e$pilot_audit_event(counts[j, , drop = FALSE], tour)$checks
            complete_checks <- all(ck$evaluated_rows == 1 & ck$flagged_rows == 0 & ck$not_evaluable_rows == 0)
            reason[j] <- if (status[j] != "normally_completed")
                paste0("excluded_", status[j])
            else if (quarantine[j])
                "quarantined_bundle"
            else if (vv$invalid || any(ck$flagged_rows > 0))
                "invalid_bundle"
            else if (vv$missing)
                "missing_input"
            else if (!complete_checks)
                "invalid_bundle"
            else "included"
            valid[j] <- reason[j] == "included"
        }
        pe_need(!any(status == "normally_completed" & !quarantine & !valid), "required pilot statistical bundle no longer validates")
        src <- b$records[[paste(tour, year, sep = "|")]]
        res[[cell]] <- data.frame(cell_id = cell, tour = tour, season = year, event = fam, surface = raw$surface,
            match_id = ids, source_tournament_id = raw$tourney_id, source_match_number = raw$match_num, round = raw$round,
            source_score = raw$score, source_winner_id = raw$winner_id, source_loser_id = raw$loser_id, source_winner_name = raw$winner_name,
            source_loser_name = raw$loser_name, player_a_id = ifelse(oriented, raw$winner_id, raw$loser_id), player_b_id = ifelse(oriented,
                raw$loser_id, raw$winner_id), player_a_name = ifelse(oriented, raw$winner_name, raw$loser_name),
            player_b_name = ifelse(oriented, raw$loser_name, raw$winner_name), a_original_side = ifelse(oriented,
                "winner", "loser"), b_original_side = ifelse(oriented, "loser", "winner"), official_id = official_id,
            status = status, completed_denominator = status == "normally_completed", quarantined = quarantine,
            valid_bundle = valid, exclusion_reason = reason, count_origin = origin, source_path = src$local_path,
            source_sha256 = src$sha256, status_evidence = evidence, status_policy = policy, conflict_preserved = conflict,
            conflict_detail = detail, source_missing_fields = rowSums(is.na(raw[c(paste0("w_", pe_fields()), paste0("l_",
                pe_fields()))])), scope = "audit_only_noncanonical", stringsAsFactors = FALSE)
        for (j in seq_len(nrow(raw))) bundles[[ids[j]]] <- list(a = aa[[j]], b = bb[[j]])
        raws[[cell]] <- raw
    }
    d <- do.call(rbind, res)
    d <- d[order(d$match_id, method = "radix"), ]
    rownames(d) <- NULL
    pe_need(nrow(d) == 245 && !anyDuplicated(d$match_id) && sum(d$valid_bundle) == 231, "complete pilot adapter accounting")
    list(eligibility = d, bundles = bundles, raw = raws)
}

pe_hash <- function(p) {
  pe_need(is.character(p)&&length(p)==1L&&!is.na(p)&&p%in%c(names(pe_pins()),names(pe_historical_pins())),'unapproved hash-only path')
  z<-system2('shasum',c('-a','256',shQuote(p)),stdout=TRUE)
  pe_need(is.null(attr(z,'status'))&&length(z)==1L,'SHA-256 failed')
  substr(z,1,64)
}
pe_allow <- function(p) {
  pe_need(is.character(p)&&length(p)==1L&&!is.na(p)&&p%in%names(pe_pins()),'unapproved input path')
  pe_need(!grepl('2022|2024|2025',p)&&file.exists(p)&&
    identical(normalizePath(p),file.path(normalizePath('.'),p)),'missing, redirected or forbidden input')
  pe_need(identical(pe_hash(p),unname(pe_pins()[p])),paste('changed input',p));TRUE
}
pe_guard <- function(p) {pe_allow(p);pe_trace$reads<-unique(c(pe_trace$reads,p));invisible(TRUE)}
pe_read <- function(p) {pe_guard(p);readLines(p,warn=FALSE)}
pe_csv <- function(p) read.csv(text=paste(pe_read(p),collapse='\n'),stringsAsFactors=FALSE,check.names=FALSE)
pe_verify <- function() {
  p<-names(pe_pins());for(f in p)pe_allow(f)
  data.frame(path=p,role=ifelse(grepl('^R/',p),'immutable_count_inventory_helper',
    ifelse(grepl('^data/raw/',p),'saved_source_or_reference',ifelse(grepl('manifest',p),'saved_manifest',
    ifelse(grepl('overlay',p),'approved_recovery_overlay',ifelse(grepl('^data/pilot/',p),'frozen_comparison','current_or_adopted_authority'))))),
    sha256=unname(pe_pins()),byte_size=file.info(p)$size,stringsAsFactors=FALSE)
}
pe_annual_map <- function() setNames(c('2023-0404','2023-609','2021-806'),paste0(
  'data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/',
  c('atp_matches_2023.csv','wta_matches_2023.csv','wta_matches_2021.csv')))
pe_scoped_csv <- function(p,empty=FALSE,sparse=FALSE) {
  pe_need(p%in%names(pe_annual_map()),'unapproved annual parse')
  lines<-pe_read(p);target<-pe_annual_map()[[p]]
  # Annual files are pinned single-line records with unquoted tournament IDs.
  # Select literal record prefixes BEFORE CSV parsing; other events stay opaque.
  pe_need(startsWith(lines[1],'tourney_id,'),'annual header changed')
  ix<-which(startsWith(lines[-1],paste0(target,',')))
  x<-read.csv(text=paste(c(lines[1],lines[ix+1L]),collapse='\n'),colClasses='character',
    na.strings=if(empty)NULL else '',check.names=FALSE,fill=FALSE,comment.char='',row.names=NULL)
  pe_need(length(ix)>0L&&all(x$tourney_id==target)&&all(x$surface=='Hard')&&!anyDuplicated(x$match_num),'pilot row scope')
  pe_trace$parsed<-unique(c(pe_trace$parsed,paste(p,target,sep=':')))
  if(sparse) {
    # Empty placeholders preserve original physical row locators for the immutable
    # recovery builder. No other event record is parsed, inspected or synthesized.
    out<-x[rep(NA_integer_,length(lines)-1L),,drop=FALSE];out[]<-'';out[ix,]<-x
    rownames(out)<-seq_len(nrow(out));return(out)
  }
  rownames(x)<-ix;list(raw=x,index=ix)
}
pe_process <- function(command,args=character(),...) {
  permitted<-c('git','shasum','sha256sum','pdftotext',unname(Sys.which(c('git','shasum','sha256sum','pdftotext'))),
    path.expand('~/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/poppler/bin/pdftotext'))
  pe_need(is.character(command)&&length(command)==1L&&!is.na(command)&&nzchar(command)&&command%in%permitted,'unapproved executable')
  a<-gsub("^['\"]|['\"]$",'',args);name<-basename(command)
  hash<-name%in%c('shasum','sha256sum')&&length(a)%in%c(1L,3L)&&tail(a,1)%in%names(pe_pins())&&
    (name=='sha256sum'||identical(head(a,2),c('-a','256')))
  pdf<-name=='pdftotext'&&sum(a%in%names(pe_pins()))==1L&&
    all(a%in%c('-f','-l','1','-layout','-bbox-layout','-',names(pe_pins())))&&grepl('[.]pdf$',a[a%in%names(pe_pins())])
  git<-name=='git'&&length(a)%in%c(2L,3L)&&a[1]=='hash-object'&&tail(a,1)%in%names(pe_pins())&&
    (length(a)==2L||a[2]=='--no-filters')
  pe_need(isTRUE(hash)||isTRUE(pdf)||isTRUE(git),'unapproved subprocess')
  for(p in a[a%in%names(pe_pins())])pe_guard(p)
  pe_trace$calls<-c(pe_trace$calls,name)
  z<-base::system2(command,args,...);pe_need(is.null(attr(z,'status'))||attr(z,'status')==0L,'local subprocess failure');z
}
pe_legacy <- function() {
  e<-new.env(parent=globalenv())
  e$source<-function(file,...){pe_guard(file);sys.source(file,envir=e)}
  e$readLines<-function(con,...){pe_guard(con);base::readLines(con,...)}
  e$readBin<-function(con,...){pe_guard(con);base::readBin(con,...)}
  e$readRDS<-function(file,...){pe_guard(file);base::readRDS(file,...)}
  e$read.csv<-function(file,...) {
    if(missing(file))return(utils::read.csv(...))
    pe_guard(file)
    if(file%in%names(pe_annual_map()))return(pe_scoped_csv(file,empty=TRUE,sparse=TRUE))
    utils::read.csv(file,...)
  }
  e$system2<-pe_process
  e$write.csv<-function(x,file,...) {pe_need(inherits(file,'textConnection'),'disk write forbidden');utils::write.csv(x,file,...)}
  e$source('R/audit_montreal_completed_match_coverage.R')
  e$pilot_read_csv<-function(path) {
    if(path%in%names(pe_annual_map()))return(pe_scoped_csv(path)$raw)
    e$read.csv(path,colClasses='character',check.names=FALSE,na.strings='',fill=FALSE,comment.char='')
  }
  e$pilot_validate_file<-function(path,record) {
    pe_guard(path);pe_need(pe_hash(path)==record$sha256&&file.info(path)$size==as.numeric(record$byte_size)&&
      length(pe_read(path))-1L==as.integer(record$row_count),'manifest byte/hash/physical-row mismatch')
    list(sha256=pe_hash(path),byte_size=file.info(path)$size,row_count=as.integer(record$row_count))
  }
  e$annual_2021_manifest<-function(required=TRUE) {
    p<-'data/manifests/development-source-files.csv'
    m<-e$read.csv(p,colClasses='character',check.names=FALSE,na.strings='')
    m<-m[m$tour=='WTA',,drop=FALSE];pe_need(nrow(m)==1L,'one WTA source manifest record')
    e$pilot_validate_file(m$local_path,m)
    api<-e$annual_2021_metadata(m$metadata_local_path,m)
    pe_need(api$sha==m$source_git_blob&&api$size==m$byte_size,'WTA metadata mismatch');m
  }
  e$montreal_load<-function() {
    m<-e$annual_2021_manifest();s<-pe_scoped_csv(m$local_path)
    list(selected=s,provenance=data.frame(tour=m$tour,year="2021",path=m$local_path,size=m$byte_size,rows=m$row_count,sha256=m$sha256,blob=m$source_git_blob))
  }
  e$pilot_write_csv<-function(x,path) {
    pe_guard(path);z<-character();con<-textConnection('z','w',local=TRUE)
    write.csv(x,con,row.names=FALSE,na='');close(con)
    pe_need(identical(readLines(path,warn=FALSE),z),paste('frozen audit mismatch',path));invisible(path)
  }
  deny<-function(...)stop('CURRENT_CONTEXT_PILOTS_BLOCKED: forbidden acquisition or empirical operation',call.=FALSE)
  for(n in c(grep('^download_|_request$|^test_|^write_|^fc_',ls(e),value=TRUE),
    'annual_2021_csv','annual_candidates','annual_2021_validate','montreal_suffixes','download.file','url','socketConnection',
    'system','pipe','lm','glm','cor','cov','predict','optim','mice','writeLines','saveRDS'))assign(n,deny,e)
  e
}
pe_load <- function() {
  before<-pe_verify();e<-pe_legacy()
  iw<-e$reconcile_indian_wells_inventory();mi<-e$mmc_load();m<-e$mmc_derive(mi)
  pe_need(all(iw$`inventory-summary`$inventory_gate=='PASS')&&mi$inventory$state=='COMPLETE'&&all(mi$inventory$criteria$passed),'inventory/status prerequisite')
  b<-list(data=list(),records=list())
  for(p in names(pe_annual_map())) {
    tour<-if(grepl('/atp_',p))'ATP' else 'WTA';year<-if(grepl('2021',basename(p)))'2021' else '2023';k<-paste(tour,year,sep='|')
    b$data[[k]]<-pe_scoped_csv(p)$raw
    manifest<-if(year=='2021')e$annual_2021_manifest() else e$pilot_read_manifest(e$pilot_config())
    b$records[[k]]<-manifest[manifest$tour==tour,,drop=FALSE]
  }
  pe_need(identical(before,pe_verify()),'inputs changed during reconstruction')
  list(base=b,iw=iw,mi=mi,m=m,provenance=before)
}

pe_cells <- function() c('ATP|2023|Indian Wells','WTA|2023|Indian Wells','WTA|2021|Canada')
pe_fingerprint <- function(ids) {
  pe_need(is.character(ids)&&!anyNA(ids)&&!anyDuplicated(ids)&&!any(grepl('[\r\n]',ids)),'unknown or duplicate set member')
  z<-system2('shasum',c('-a','256'),input=c(as.character(length(ids)),sort(ids,method='radix')),stdout=TRUE)
  pe_need(is.null(attr(z,'status'))&&length(z)==1L,'set digest failed');substr(z,1,64)
}
pe_set <- function(actual,frozen,label) {
  a<-pe_fingerprint(actual);b<-pe_fingerprint(frozen)
  pe_need(setequal(actual,frozen)&&identical(a,b),paste('exact membership differs',label))
  data.frame(category=label,reconstructed_count=length(actual),frozen_count=length(frozen),
    reconstructed_fingerprint=a,frozen_fingerprint=b,agreement='EXACT',discrepancy='none',stringsAsFactors=FALSE)
}
pe_next <- function() paste('Approve one bounded exploratory empirical pilot analysis limited to ATP Indian Wells 2023,',
  'WTA Indian Wells 2023 and WTA Montreal 2021, reproducing and extending descriptive candidate-metric diagnostics',
  'under current context with explicit same-match coupling and convenience-sample limitations; no forecasts,',
  'new cells, acquisition or Package B expansion. Require a response-only ChatGPT handoff of no more than 2,000 words.')
pe_rights <- function() {
  license<-paste(pe_read('DATA_LICENSE.md'),collapse='\n')
  policy<-paste(pe_read('docs/wta-2021-montreal-recovery-policy.md'),collapse='\n')
  contract<-paste(pe_read('docs/data-source-contract.md'),collapse='\n')
  stopdoc<-paste(pe_read('docs/wta-2021-montreal-chronology-stage-a.md'),collapse='\n')
  pe_need(grepl('not a new grant',license,fixed=TRUE)&&grepl('local',policy,fixed=TRUE)&&
    grepl('Phase 2E',contract,fixed=TRUE)&&grepl('PROHIBITED',stopdoc,fixed=TRUE),'saved scoped-use authority incomplete')
  data.frame(cell_id=pe_cells(),scope_state='SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD',
    saved_basis=c('DATA_LICENSE.md; pilot-source-files.csv; inventory-reference-files.csv; current Phase 2E authority',
      'DATA_LICENSE.md; pilot-source-files.csv; anomaly-reference-files.csv; inventory-reference-files.csv; current Phase 2E authority',
      'DATA_LICENSE.md; development-source-files.csv; montreal-reference-files.csv; recovery policy 1.0.0; current Phase 2E authority'),
    local_scope='Previously approved saved evidence; eligibility and count revalidation only',
    provider_grant='NO_NEW_LEGAL_CONCLUSION',publication='BLOCKED_PENDING_RIGHTS_REVIEW',
    retained_uncertainty='Prior WTA programmatic-access prohibition and retention ambiguity remain; no renewed access or expansion authorized',
    stringsAsFactors=FALSE)
}
pe_decide <- function(status,rights) {
  allowed<-c('SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD','RIGHTS_SCOPE_UNRESOLVED','RIGHTS_SCOPE_CONFLICT')
  pe_need(length(status)==3L&&!anyNA(status)&&all(status%in%c('PASS','FAIL','UNKNOWN')),'three explicit pilot states required')
  pe_need(length(rights)==3L&&!anyNA(rights)&&all(rights%in%allowed),'three explicit rights states required')
  if(any(status=='FAIL')||any(rights=='RIGHTS_SCOPE_CONFLICT'))return('CURRENT_CONTEXT_PILOTS_BLOCKED')
  if(any(status=='UNKNOWN')||any(rights=='RIGHTS_SCOPE_UNRESOLVED'))return('CURRENT_CONTEXT_PILOTS_INCONCLUSIVE')
  'CURRENT_CONTEXT_PILOTS_REVALIDATED'
}
pe_build <- function(input=pe_load()) {
  a<-pe_adapter(input)$eligibility
  frozen<-pe_csv('data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv')
  pe_need(setequal(unique(a$cell_id),pe_cells())&&setequal(unique(frozen$cell_id),pe_cells()),'exact three-pilot scope')
  k<-pe_match_index(a$match_id,frozen$match_id);frozen<-frozen[k,,drop=FALSE]
  # Identity, source orientation, policies and original conflicts must agree too.
  for(n in names(a))pe_need(identical(as.character(a[[n]]),as.character(frozen[[n]])),paste('frozen eligibility field',n))
  iwold<-pe_csv('data/pilot/inventory/official-matches.csv')
  mold<-pe_csv('data/pilot/development-2021/montreal-inventory/html-draw.csv')
  comparisons<-exclusions<-bundles<-list()
  for(cell in pe_cells()) {
    d<-a[a$cell_id==cell,,drop=FALSE];f<-frozen[frozen$cell_id==cell,,drop=FALSE]
    iw<-grepl('2023',cell);tour<-d$tour[1]
    off<-if(iw)input$iw$`official-matches`[input$iw$`official-matches`$tour==tour,,drop=FALSE] else input$mi$inventory$html
    old<-if(iw)iwold[iwold$tour==tour,,drop=FALSE] else mold
    oid<-if(iw)'official_id' else 'record_id'
    sets<-list(inventory=d$match_id,completed=d$match_id[d$completed_denominator],excluded=d$match_id[!d$valid_bundle],
      accepted=d$match_id[d$valid_bundle],retirements=d$match_id[d$status=='retirement'],walkovers=d$match_id[d$status=='walkover'],
      byes=off[[oid]][off$bye],quarantined=d$match_id[d$quarantined],
      recovered=d$match_id[d$valid_bundle&d$count_origin=='approved_recovery_overlay'],
      original=d$match_id[d$valid_bundle&d$count_origin=='original_source'],
      unresolved_statuses=d$match_id[!d$status%in%c('normally_completed','retirement','walkover')],
      invalid_bundles=d$match_id[d$exclusion_reason%in%c('invalid_bundle','missing_input')])
    fs<-list(inventory=f$match_id,completed=f$match_id[f$completed_denominator],excluded=f$match_id[!f$valid_bundle],
      accepted=f$match_id[f$valid_bundle],retirements=f$match_id[f$status=='retirement'],walkovers=f$match_id[f$status=='walkover'],
      byes=old[[oid]][old$bye],quarantined=f$match_id[f$quarantined],
      recovered=f$match_id[f$valid_bundle&f$count_origin=='approved_recovery_overlay'],original=f$match_id[f$valid_bundle&f$count_origin=='original_source'],
      unresolved_statuses=f$match_id[!f$status%in%c('normally_completed','retirement','walkover')],
      invalid_bundles=f$match_id[f$exclusion_reason%in%c('invalid_bundle','missing_input')])
    detail<-do.call(rbind,lapply(names(sets),function(n)cbind(cell_id=cell,pe_set(sets[[n]],fs[[n]],n))))
    pc<-data.frame(cell_id=cell,status='PASS',main_draw_singles='VERIFIED_SAVED_INVENTORIES',stringsAsFactors=FALSE)
    for(n in names(sets)) {
      row<-detail[detail$category==n,,drop=FALSE]
      pc[[paste0(n,'_count')]]<-row$reconstructed_count;pc[[paste0(n,'_frozen_count')]]<-row$frozen_count
      pc[[paste0(n,'_fingerprint')]]<-row$reconstructed_fingerprint;pc[[paste0(n,'_frozen_fingerprint')]]<-row$frozen_fingerprint
    }
    pc$non_bye_count<-nrow(d);pc$bracket_blocks_including_byes<-nrow(off);pc$agreement<-'EXACT';pc$discrepancy<-'none'
    # Successful independent inventory gates prove these empty failure categories;
    # an unknown gate aborts before zero can be assigned.
    extra<-do.call(rbind,lapply(c('missing_links','duplicate_links','unresolved_conflicts'),function(n)cbind(cell_id=cell,pe_set(character(),character(),n))))
    pc$preserved_conflict_records<-sum(d$conflict_preserved)
    comparisons[[cell]]<-pc
    exclusions[[cell]]<-rbind(detail[detail$category%in%c('retirements','walkovers','byes','unresolved_statuses','invalid_bundles','quarantined'),],extra)
    bundles[[cell]]<-detail[detail$category%in%c('original','recovered','invalid_bundles','quarantined','accepted'),]
  }
  rights<-pe_rights();p<-do.call(rbind,comparisons);rownames(p)<-NULL
  terminal<-pe_decide(p$status,rights$scope_state)
  if(terminal!='CURRENT_CONTEXT_PILOTS_REVALIDATED')stop(paste0(terminal,': required scoped-use comparison prevents publication'),call.=FALSE)
  oldstop<-pe_csv('data/pilot/package-b-evidence-route-proposal/decisions.csv')
  pe_need(oldstop$value[oldstop$id=='TERMINAL_DECISION']=='STOP_PACKAGE_B_AND_PIVOT_TO_EXISTING_EVIDENCE','Package B stop changed')
  decisions<-data.frame(id=c('TERMINAL_DECISION',pe_cells(),'PACKAGE_B','OTD','FORBIDDEN_SEASONS','METRIC_MODEL_AUTHORITY','Q6','Q8','Q9','Q10','PUBLICATION','NEXT_APPROVAL'),
    value=c(terminal,p$status,'STOPPED','PAUSED_BY_USER_AFTER_PHASE_1S','2022/2024/2025_NOT_ACCESSED','NONE',
      rep('PENDING_USER_APPROVAL',4),'BLOCKED_PENDING_RIGHTS_REVIEW',pe_next()),stringsAsFactors=FALSE)
  summary<-data.frame(measure=c('release_version','terminal_decision','pilots','inventory_non_bye','normally_completed','valid_bundles',
    'retirements','walkovers','quarantined','original_valid','recovered_valid','byes','unresolved_discrepancies'),
    value=c('1.0.0',terminal,nrow(p),sum(p$inventory_count),sum(p$completed_count),sum(p$accepted_count),sum(p$retirements_count),
      sum(p$walkovers_count),sum(p$quarantined_count),sum(p$original_count),sum(p$recovered_count),sum(p$byes_count),0),stringsAsFactors=FALSE)
  result<-setNames(list(pe_verify(),p,do.call(rbind,exclusions),do.call(rbind,bundles),rights,decisions,summary),pe_names)
  for(n in names(result))rownames(result[[n]])<-NULL
  result
}
pe_render <- function(result) lapply(result,function(x) {
  z<-character();con<-textConnection('z','w',local=TRUE);write.csv(x,con,row.names=FALSE,na='NA');close(con)
  charToRaw(paste0(paste(z,collapse='\n'),'\n'))
})
pe_publish <- function(result,current=pe_build()) {
  pe_need(identical(result,current),'release differs from current complete reconstruction')
  before<-pe_preserve();pe_verify();bytes<-pe_render(result);paths<-file.path(pe_dir,paste0(pe_names,'.csv'))
  tracked<-system2('git',c('ls-files','--','data/raw','data/pilot'),stdout=TRUE)
  ignored<-system2('git',c('check-ignore','--',vapply(paths,shQuote,'')),stdout=TRUE)
  pe_need(is.null(attr(tracked,'status'))&&!length(tracked)&&identical(ignored,paths),'ignored untracked output boundary')
  if(dir.exists(pe_dir)) {
    pe_need(setequal(list.files(pe_dir,all.files=TRUE,no..=TRUE),basename(paths)),'partial or foreign existing release')
    for(i in seq_along(paths))pe_need(identical(readBin(paths[i],'raw',n=file.info(paths[i])$size),bytes[[i]]),'existing release differs; preserve for review')
    return(invisible(paths))
  }
  stage<-tempfile('.phase2e-stage-',tmpdir=dirname(pe_dir));pe_need(dir.create(stage),'cannot stage complete release')
  on.exit(unlink(stage,recursive=TRUE),add=TRUE) # Only this invocation's staging directory.
  for(i in seq_along(paths)) {
    p<-file.path(stage,basename(paths[i]));writeBin(bytes[[i]],p)
    pe_need(identical(readBin(p,'raw',n=file.info(p)$size),bytes[[i]]),'staged bytes differ')
  }
  pe_verify();pe_need(identical(before,pe_preserve()),'historical file changed during release');pe_need(!dir.exists(pe_dir)&&file.rename(stage,pe_dir),'atomic directory installation failed')
  invisible(paths)
}

pe_historical_pins <- function()
c(.gitignore = "90c4042d9b90ac51d92f358e00fb93ff82840feaa749b1f22ee3e724ff25c217",
AGENTS.md = "67341e4f3a1f10b9171bae7dd99318661047e0b4b7957c413931dc4a7d9eac1d",
DATA_LICENSE.md = "f9865f740b60f8dcb82c9ed0c7e6ad95980a9df9807871b8c6573a0c45348880",
LICENSE = "4d86cfe44cf70c29d2c976a2c274bfa26cb951adbe2bf496ad203c35dbf03319",
PROJECT_CONTEXT.md = "865448a774322725f6d545e2ad9da589c86a3c305169bfb90bf4bf5f24c941e1",
`R/acquire_montreal_chronology_stage_a.R` = "1b33b09a92cfecb38cb84ec3578b28617e62ffef6140ee3a117a35103d4d2e6d",
`R/audit_2021_annual_data.R` = "4e376a0e1e2ee822515d2d227f457bed095cc4dca61a6285a29ec07311a423bd",
`R/audit_event_boundary_feasibility.R` = "4c22ad4be1e4e92e55fc8169859a9884730ab6f692b65c60512f17e4128d4da9",
`R/audit_four_factors_candidate_metrics.R` = "a25f4d2c0dfb4b17fc0a48ef1e389a79dcfef58f128f1f03b9e32a89e70494f5",
`R/audit_montreal_chronology_evidence.R` = "70721881800b2be310ce0a80c994203eb404ff44aae8afb509bd612f72ef2bae",
`R/audit_montreal_completed_match_coverage.R` = "f5e1b57c38a72cf13a7e2a3ce988ce1067b4ac2d53e389423aa8efe40cf84749",
`R/audit_montreal_reference_feasibility.R` = "d0935e2e0d1a72bd32252883f2d601dcc09cddbc906ca149b26512a36648d9f1",
`R/audit_pilot_data.R` = "82bed285763b478614c4c296f92eeb554a6ef104134080e054c7c7b720f6e608",
`R/audit_wta_anomaly.R` = "90b0c3d40fbe4a69e30de51b6a089ace535c26e62d32aeec6e1a9aa9429687a4",
`R/download_2021_annual_data.R` = "43f5db5fe738da29110f8ec655dc460b828c12d310299db7aae37d21605e6068",
`R/download_anomaly_references.R` = "596943db417128ff17498353864d8336b788b87add8e1fb2fcde24070d751c2d",
`R/download_inventory_references.R` = "077e4fe176a977f1d64f75b5f86d1e468e26baa5f7e27485adfee0655adc084b",
`R/download_montreal_references.R` = "a48984a9a9b87275ed561109e20d3e0331ce5aef6fc440044d53417291ff2287",
`R/download_pilot_data.R` = "5facb085d14f1c5007c97cd7008d77173cc9e7b74a96eca1c7bc49696ccb4299",
`R/implement_montreal_recovery.R` = "224d0dbcab70b184f0fc8ac67b924b2e15f77cbe698664a7594d4d11606c8e6d",
`R/plan_development_cohort_expansion.R` = "561b37cb007a1c6b452b1911f86bcf4d3eef082cfcac57ef7ff05f9f2dd97210",
`R/plan_package_b_evidence_route.R` = "2a97465f0fedcdfa52ec0c9903dc5cd25c7c7eef5bb29414d611ab2206232948",
`R/reconcile_indian_wells_inventory.R` = "84ae65145e3505e578a7287af2bf25d08f8e8f25d2bc35be7fb0b10ecd9fdb93",
`R/reconcile_montreal_inventory.R` = "52dd718b67a95aa01bc015daa66f8a5a739cc6ccd121c5229046ce68b3053e24",
`R/review_otd_documentation.R` = "77474a35741afc8d27e146c8eaac42bdfabb44c19213e8d72f9b999d98c1bc78",
`R/review_wta_2021_montreal.R` = "5b180b4a30521ed126fc75363065c5b376fac6dc7994bb73823dcac4064b07ef",
`R/test_development_cohort_expansion_readiness.R` = "f384985371cf2599e60597cbed4c905fa8895b35ff981bdd8352b51f811393be",
`R/test_event_boundary_feasibility.R` = "0f410913ef642ceb679b84bf474751e2e3a4f241deb08c5f050ebce494739989",
`R/test_four_factors_candidate_metrics.R` = "ad1a5570f42eda5e5d522adabc70700b210f1a49635bbf4dbfc7d92c60c2c14c",
`R/test_four_factors_definition_protocol.R` = "e21a3c111d07e044e0d736991e3dc854b6d4e2c89d3994337190eb14e564af14",
`R/test_montreal_chronology_acquisition_plan.R` = "59ebe0463105cecc7191141409bd6ffb2edbd006f0e7cf4e53020a6d149414aa",
`R/test_montreal_chronology_evidence.R` = "2f78a6f5e74c200b9339c8e2635facca4e285563a0439a3b63bc28de83b92888",
`R/test_montreal_chronology_policy.R` = "8a856ee34a03470e73a311b975e87b6e1d50c3a5090d57475c9e463aaba09eb3",
`R/test_montreal_chronology_stage_a.R` = "8caed2e08b45375272545847caf753beb1bd3b9668eda165c609832a167c9821",
`R/test_montreal_completed_match_coverage.R` = "ab6d680ae81c2e409161deed81822734eab79841402dca70e5f25ebb71067d7e",
`R/test_montreal_inventory.R` = "ddea19214b8b16733e6969139559da458feb0a928ffecfe2c10137a630108cbb",
`R/test_montreal_recovery.R` = "a247d4da067422a484d38155095fff35facc8a6bcfd93bd4ce2d440389638f70",
`R/test_otd_documentation.R` = "b6d4dd4195021f6b7b85b39f8d59c2710e625ab052e424fe3eb1ee429de8b443",
`R/test_package_b_evidence_route.R` = "51cf6359211b5198a0c51c72f80cc5936d9384e1dd6376a79f416bb617673d74",
`R/test_post_otd_analytical_path.R` = "1bceb436a51a3be3308b3a076b3b9bcbed6ee6b3ddd0a55216b4b85f78e39280",
`R/test_tennis_chronology_path_decision_brief.R` = "6918ad0177bf61ccb62c6b42219be39e28fdfc59ce5fbe98c8b611d32d556793",
README.md = "ff2973a538ef106f93888fd9f99a63901fa5e92f27e04f8c276bc056a948256f",
`data/manifests/anomaly-reference-files.csv` = "fa76a285b53491fef04317a7fb5d5774b6d75e6ead137d46c44cba2e9feb73bd",
`data/manifests/development-source-files.csv` = "2ae8fc51c698062b598b541d26e519a4f1e26d244ff8b42177ecfd4a5b2f8da4",
`data/manifests/inventory-reference-files.csv` = "b7f7658677941b684deb0294264741226472c381e3faaf7ee839634bcfd8f721",
`data/manifests/montreal-reference-files.csv` = "783dceca248f9f6bbbd512787dac797a0e8b80e8ba3b86e2b8aaa854c2ad3bbe",
`data/manifests/pilot-source-files.csv` = "2d114f4205b3f2927e70513bd650bc20128e60f1fbd4b450d57b14167b1fbe7b",
`docs/2021-annual-source-audit.md` = "22ffb45943267d77b81bb69f67b65cd3650a4d7f4f83ae0658e2fd89c6cab9e5",
`docs/atp-inventory-reference-precedence-policy.md` = "167e4ed41e73de539bba232dce9db7e4c415f034cccc059b887d7dc6beef1f4d",
`docs/development-cohort-expansion-readiness.md` = "dd219cdac7b993f94f80e98f71f64cd0ab16dae675af039d1d5c382b35d1ea10",
`docs/event-boundary-feasibility.md` = "19685452eb8af4d587ebb7c816f56748544c3037bae797dc81fe7344ce7f8b9b",
`docs/four-factors-candidate-metric-feasibility.md` = "413c4d67fb24f6e84faffe98008a65fa85cc5a5c13be60c9cd6e0d61af22eb59",
`docs/four-factors-definition-protocol.md` = "5ddbb8a57b2e125828a908422e2c1d83fd3786576ff20766676c9a6b8cec523c",
`docs/indian-wells-inventory-reconciliation.md` = "8649c8417bebe05194274fee6fbbd12eb12c17d891ac3519a1374cdb9b2a199e",
`docs/otd-documentation-preflight.md` = "1f5d361425f614a0e78de9b108ed9a252b9af6db93946f051733e38468fb2054",
`docs/package-b-evidence-route-proposal.md` = "0cd8cc94043b37764456b46ed0a56cc941006ae88ae136dbd0f310ef12e3d3e8",
`docs/pilot-acquisition-audit.md` = "5ddf6cc62da5dc506af99021c768502fb8740d5d6367a56067e50b1d14c15275",
`docs/post-otd-analytical-path.md` = "14d3504105fab30caf60667ebd6f99e75effd3906ef665484e42b951c8e277a7",
`docs/tennis-chronology-path-decision-brief.md` = "5eb5d3940ba444110679ba57e320d2b75f139f67e5528ef1917e9172912ed93e",
`docs/wta-2021-montreal-admission-review.md` = "93837e74f5ac13891933f730d323d142a56589c0c795566d571237ea5b0cb441",
`docs/wta-2021-montreal-chronology-acquisition-plan.md` = "42ae79f33005893711523ebb2606fb2154f6c5ba5f2e7c30e099956838c13904",
`docs/wta-2021-montreal-chronology-policy.md` = "cfbbe87732d813e4e31f1b2bd2478bb92d2329150fee8c951700ed97c31c421c",
`docs/wta-2021-montreal-chronology-stage-a.md` = "842f603c0a1075ca58395f89a805b981a6f07fdda3f043de95ee169d0c62db12",
`docs/wta-2021-montreal-completed-match-coverage.md` = "168da38f74946ee663d67727b449876dc00fe296e4621205c26a9e55fa5499e8",
`docs/wta-2021-montreal-inventory-reconciliation.md` = "6e117faa11751209b4c1c9d4791ef4cf04e0a07fd26e1d2de0833da599d0e1f4",
`docs/wta-2021-montreal-inventory-status-policy.md` = "279cbba8ff5114b4ca52db2c0452fd318009c14d126f7be80fd443ee339ce87c",
`docs/wta-2021-montreal-recovery-policy.md` = "11690d185365cec46733dc44be982fc211f16ef967d06483dca0e4427f4d8e5b",
`docs/wta-2021-montreal-recovery-verification.md` = "d15fd1dd7e43bc6e0740e1f9395b8c5c5d8d1bca204318df48c4f0ad2281f151",
`docs/wta-2021-montreal-reference-feasibility.md` = "b795e744ffd14b3f7f0734b30701e32031846b08e04b23a229718361cfe8fe77",
`docs/wta-anomaly-and-quarantine-policy.md` = "1fdc790a08a89d971d4ef30b6e731af811b9c288fccb06e342f5a2d1d6fa6b5b",
`tennis-analytics-public-data-research.pdf` = "1c18296ff08f22a0284100788104640267275f8ff33fa7840014fb29c96224ad",
`data/pilot/anomaly/anomaly-coverage.csv` = "72e1a325e434645b9d440be30f759a84e99360857cc55832b434dca16ccd8e39",
`data/pilot/anomaly/anomaly-disposition.csv` = "3f5d084b1116954de31f2b1e3f4ba4c6880236a791cc2e4c5449d6e060a9c8eb",
`data/pilot/anomaly/anomaly-source-comparison.csv` = "5fb5681378aa8ac0e5bc3a81a794a948bf78a289b3bedcfed70626f5a6454b0a",
`data/pilot/anomaly/anomaly-validation-checks.csv` = "9593116997633f55c2fbd14e9d076aadd657c46cc773d481c5145575e4f3b583",
`data/pilot/anomaly/wta-draw-page1.png` = "3d42d3dce092ff9721bd9945bab71a1f5ed0ac77071c11290b9c16cb4753303e",
`data/pilot/atp_indian_wells_2023.csv` = "31b43453ed46a709fd51bd50b372ec2c605258d5a9814db13c963377def2ac6a",
`data/pilot/availability.csv` = "6557caa0c7188d24c2679fb97a7c73ef32c11884f0293a11c2dc4dfbe62a8d15",
`data/pilot/candidates.csv` = "ff9cb8262872f492a7061b43cae2ea23b4d3141fdc74b57f9a42441330d37c71",
`data/pilot/checks.csv` = "a902e755bc29e55f3506c6a2e2a0bd4da143f2aa777ac0adad3b83dbc63e24e0",
`data/pilot/coverage.csv` = "909f940f4e9bb937f97b8934968ade1ede306f66962e2536df2b5dce73097de0",
`data/pilot/development-2021/audit-checks.csv` = "c74483a5e316a6b5285339fe8f37daae713575cb33ea59f0cd2c119bc8bf35d1",
`data/pilot/development-2021/event-candidates.csv` = "d5d66ebe2c3c82708776a997549233d8f3898ee6d89aaced5ec7e8821fb2adcb",
`data/pilot/development-2021/event-cell-summary.csv` = "27f41af18cd215d575a11a24b8d749aac2f35e6621333b05105b5589ae78d3d8",
`data/pilot/development-2021/file-provenance-checks.csv` = "25833899b99a85c8d33485eb85d3754d2fb3cc9e4d975149a57952ccc6399765",
`data/pilot/development-2021/montreal-chronology-acquisition/attempt-1.rds` = "6e916914d611f8979c4f50c1cdc753004c11451d0d60b402f34033316525afa8",
`data/pilot/development-2021/montreal-chronology-acquisition/attempt-1.rds.sha256` = "cfe40b43ff86656b695516fd7c7fb0c364f66d2406279d748c0f98b85ee63a5f",
`data/pilot/development-2021/montreal-chronology-acquisition/response-1.rds` = "29169021bda2c231389e2eb5c382d1b31b3f30f25b09497abd2b376d046ee653",
`data/pilot/development-2021/montreal-chronology-acquisition/response-1.rds.sha256` = "cb43d2813d89b11114b14bda6afbee3550c88e86d89b216b1f011f7892c6f9a8",
`data/pilot/development-2021/montreal-chronology-acquisition/review-1.rds` = "0f12e94450eeb59dfa057531e8b817173171e233b6692cf1bf410a201c757d43",
`data/pilot/development-2021/montreal-chronology-acquisition/review-1.rds.sha256` = "5cc9ddf4801bc2be8cf8b62a7105ec58f23e35b7321afc90de2b041ad200f686",
`data/pilot/development-2021/montreal-chronology-acquisition/stage-a-manifest.csv` = "2265cb488c4e165a4b2ad288defd75adfe559d1972659f6a0e0f03a92165efd9",
`data/pilot/development-2021/montreal-chronology-evidence/conflicts.csv` = "8e938ad910ece05452105b67a82e027a5149b3baddad8af0e16e2db34afadd6f",
`data/pilot/development-2021/montreal-chronology-evidence/decisions.csv` = "cf9a4c1566f65acc24ce3ca8a1187bac7b3bcd47ab20fa48bf84804daca1d20e",
`data/pilot/development-2021/montreal-chronology-evidence/dispositions.csv` = "d2f137712fa2a775698c3109801629c106b03d2d6d88d76c670f7ff8e9ea94ad",
`data/pilot/development-2021/montreal-chronology-evidence/edges.csv` = "56b87368170b93da809a4fd47f8694eec462d5cc08d93c4e72a5d5e576c908f0",
`data/pilot/development-2021/montreal-chronology-evidence/event-observations.csv` = "775d542da9631493885d3e28814e56ed84d1fe337dbc1d60542ef4dbf9781812",
`data/pilot/development-2021/montreal-chronology-evidence/match-page-observations.csv` = "b3ebf221967bf54fb3b7f818065e55109b2d63faffed83d8f4a79ba6e3126640",
`data/pilot/development-2021/montreal-chronology-evidence/observations.csv` = "782f2867a2b1bc3005220448a7f9f17aeca27a75b0ba8019f3eecfef4dc82771",
`data/pilot/development-2021/montreal-chronology-evidence/options.csv` = "07f802ed255dfb918b5feb49074ca94bd53c3f3a52f79a1f106a94edcde02205",
`data/pilot/development-2021/montreal-chronology-evidence/players.csv` = "6f0e3136b2917ce94b0483fb7a4f2c5e9013d23e74ca185cea3299b3d34428bf",
`data/pilot/development-2021/montreal-chronology-evidence/summary.csv` = "4ebee91ecb18c06078b242b527422972724e682edc9f9e8861c7019de606678f",
`data/pilot/development-2021/montreal-completed-match-coverage/count-links.csv` = "35b1d84c77615af55e9c9e5b6500754720cfd97ff0f65ff4c0dc33a9e405172b",
`data/pilot/development-2021/montreal-completed-match-coverage/dispositions.csv` = "c8988ba3e27ab8a494f20cfa008ca6209bfdf7886412963e268136e6f503ada1",
`data/pilot/development-2021/montreal-completed-match-coverage/structural-checks.csv` = "2362fbea966688f221b602d5da16f47d725314215d2ec4f14c27eaa12ae2d788",
`data/pilot/development-2021/montreal-completed-match-coverage/summary.csv` = "288355b44a1a77c52a9674366b247962728c4736bb3026b1af53593adb32170b",
`data/pilot/development-2021/montreal-inventory/code-sequence.csv` = "3769366c8d3f23bafd3d6eb011c11c8be733ff0aea80a1de42699c57048e8df6",
`data/pilot/development-2021/montreal-inventory/criteria.csv` = "aa1d1b3805cc26a197d0d45436950fe88e1a8bc3b34ca60fabc7eb612fb0fa16",
`data/pilot/development-2021/montreal-inventory/html-draw.csv` = "611de6706379a6272f75fdbfd1a6a6a59f780cb22f195f7e63b892ee91b24302",
`data/pilot/development-2021/montreal-inventory/identity-decisions.csv` = "48a75d3a1021540671a06e18dbbe859b8f87a718480dab11c6fe6c35b906bc5f",
`data/pilot/development-2021/montreal-inventory/inventory-status-resolutions.csv` = "ac132b3dc41c005dec89ea129b6fce1150d6ba315bb4b3540793a3ba779221a0",
`data/pilot/development-2021/montreal-inventory/official-only.csv` = "c1a28e32fcf57307c9e14c01dbd769055e680009daa55f57f55f4f1185303fc7",
`data/pilot/development-2021/montreal-inventory/pdf-draw.csv` = "9c162cf73db7f3f0932ecf20aae3462000c655bd66a294fb1a70c370cd1a9c8c",
`data/pilot/development-2021/montreal-inventory/pdf-entrant-positions.csv` = "b04a559ea25c1a8a3c1ee731fac1e0d8ffcfb8e355416a71e0a3ff9ae29ee469",
`data/pilot/development-2021/montreal-inventory/provenance.csv` = "41170583116a2e625874cd71ecff2719b93b26239d0d991ad2988367602eec90",
`data/pilot/development-2021/montreal-inventory/reconciliation-links.csv` = "78be7c62d539103a77770c06f4ea019c70a63fc4e95a406cab693892247f4f1c",
`data/pilot/development-2021/montreal-inventory/reference-comparisons.csv` = "6e1e8ccf45a1596541e856831f4731f881698ee1803503deb7f8815c5ec3212a",
`data/pilot/development-2021/montreal-inventory/source-inventory.csv` = "e8c9ed1d8a54c915bf26844a1ec8ab2a25c649e1356b32ead3165b8ebe54e513",
`data/pilot/development-2021/montreal-inventory/summary.csv` = "ae274408a0df303573d4f0273464e009fda670b4d95fc5e9cc3a252d141ddf56",
`data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds` = "2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5",
`data/pilot/development-2021/montreal-reference-feasibility/coverage-scenarios.csv` = "180f6ba53e30677c3702ed3cd11274b4348075caa8411c97d83af071812516b4",
`data/pilot/development-2021/montreal-reference-feasibility/feasibility-dispositions.csv` = "0c879ab4d6fea166c8ee29784d6f73cccc9688c950457d99170ab809eb9f178c",
`data/pilot/development-2021/montreal-reference-feasibility/field-comparisons.csv` = "d687758bf17c808f85cf7d6e613a80d0629f9a9dacfdca0d618c561132d0ad5b",
`data/pilot/development-2021/montreal-reference-feasibility/official-stat-observations.csv` = "f498a9da20d037771622276332472c3d53bac1e6060141576a8e78b89391f008",
`data/pilot/development-2021/montreal-reference-feasibility/pdf-target-evidence.csv` = "7631d244260c8464e54b31c1a5cc74b7689652eb9154918d8826b4ed27a5ba54",
`data/pilot/development-2021/montreal-reference-feasibility/reference-checks.csv` = "e4999f73eb8768118a7f66ec929c145404447834723579c79c430b3658a43140",
`data/pilot/development-2021/montreal-reference-feasibility/reference-match-inventory.csv` = "77bd218219f554b056296d642d243eb4d796cb6f65681122959ffa806cce4ffe",
`data/pilot/development-2021/montreal-reference-feasibility/status-evidence.csv` = "3b9e6478ac9e1496d5ccdd67d0f15bbe8560cb3bbbfa8a0637fb78eb06c58023",
`data/pilot/development-2021/montreal-reference-feasibility/structural-checks.csv` = "f1d7ab46958d1e5448e7a5ee0249bbadd22518cf563a3bd9844b5aa9a0bfc133",
`data/pilot/development-2021/montreal-review/affected-player-history.csv` = "a096ba9e8b598c81b9f18d328f365f74bf476f8fa9e011787d76f62c5c6ffdd3",
`data/pilot/development-2021/montreal-review/anomaly-dispositions.csv` = "73963c688ca1eefd88f888676e2c08819f87fc48e744025c249aed7bf6732a97",
`data/pilot/development-2021/montreal-review/denominator-sensitivity.csv` = "a95f9c0f25ab722b2a66f952ab215975cff7010cb5be4f673c09b12bd3093189",
`data/pilot/development-2021/montreal-review/match-bundle-inventory.csv` = "93661f84350b7396a2849f2e975f43d45f5db3be4c78360bd51c3bd51a1c1860",
`data/pilot/development-2021/montreal-review/review-checks.csv` = "701a752146b245a83a31b5c53c1a6fc8eb45ae225866d5a6ee9b67fa273d52c7",
`data/pilot/development-2021/montreal-review/round-coverage.csv` = "11dfecd91562ce96101564219f9d5b14a9d19eee739f5c75a07a8f16477e1cc2",
`data/pilot/development-2021/montreal-review/score-suffix-review.csv` = "341f5b7bd53c8cfdc06de348089125881bb4418dedaa5c52e74bb4eba0006008",
`data/pilot/development-2021/montreal-review/source-progression.csv` = "87beb81ecea72031e47f788abbd2323a5a39a1b3f3b326d27c18e4808ddf4fd9",
`data/pilot/development-2021/required-field-summary.csv` = "0e26a06d58a3d87e73fcd60fda19c01df1dbdf01f797657ff53c56d2d424804d",
`data/pilot/development-2021/schema-comparison.csv` = "f42ad6acf1978cb163ab4767cb142c9cec25a6ca9c73c0bbc6cb33291ebf16d2",
`data/pilot/development-2021/score-review.csv` = "7df72dc063b36f9b45d34593ffd66448f24b2bf369ee5fae40272085b4c514b1",
`data/pilot/development-2021/score-status-summary.csv` = "f07dc5610c2db2b06ee3afcb4c01df4b62dbe76fb4468b5f255abf8835931b0d",
`data/pilot/development-2021/value-vocabulary.csv` = "27d8a82467cb2991bb0a1e3c1e871b8400fcdacbdf34c3a3c49fc78607355a19",
`data/pilot/development-cohort-expansion-readiness/cell-prerequisites.csv` = "34a869ffde2e817af2f1717eae3f2ec0119959c5c6f6aa1c4680def79dd3b819",
`data/pilot/development-cohort-expansion-readiness/cell-readiness.csv` = "66ed229e23335514fa8d1abcacde62bbc033fc53cf954004d84833f5630c0d4f",
`data/pilot/development-cohort-expansion-readiness/current-context-requirements.csv` = "28a724f58dacea1f3131e21ea7d50a021a27093858637e9e30448dfa7842e425",
`data/pilot/development-cohort-expansion-readiness/decisions.csv` = "f3736b931504d99ceabcd80e82e8b148bbf6fb0fcd2deb2e62d79e080599e91c",
`data/pilot/development-cohort-expansion-readiness/input-provenance.csv` = "3e9cd0c56fb298a53e2f2cd29eea64c61f75466c7381d3af7bf54488e7e56c93",
`data/pilot/development-cohort-expansion-readiness/package-comparison.csv` = "dbc5d6438c96ab5204a117dd8b5c425025975d3e2cc88c8df6642edb4a9044fb",
`data/pilot/development-cohort-expansion-readiness/summary.csv` = "bea133007f852c9232375f39a085893b5219bff685e86e5089d02154dc0b013b",
`data/pilot/event-boundary-feasibility/decisions.csv` = "ee77cff85d24d2cb2211cd3607957b46115b7f229903dc665b2dbeaf9e2962ba",
`data/pilot/event-boundary-feasibility/event-boundary-evidence.csv` = "1a05809feba86664627c707a6b0b14b678bc06418b48c68473cc479ef0a74c61",
`data/pilot/event-boundary-feasibility/event-cells.csv` = "76358755c89aeacf79ae452ad606eca755d52cab2bc3954c3ef0f58e64c12ae8",
`data/pilot/event-boundary-feasibility/event-pairs.csv` = "5771c03ceb5e5d8cb4b082a5c8f475e9f0ccb7f42864e6bb2da5a4d98c68314e",
`data/pilot/event-boundary-feasibility/input-provenance.csv` = "66944e572d4dc7ab4224a0ea5b758a6d75a31d3958256a1c86b0ebd2a5a03ff3",
`data/pilot/event-boundary-feasibility/player-event-dependencies.csv` = "8db61b852fa5d7465b5c3cd082f3dcad859ccdc2b6ef187b547c84f8ea6f5955",
`data/pilot/event-boundary-feasibility/scenarios.csv` = "c5359cb7f103cd6f63f71cc17a8b8e65355bf1551941ad9d84197aed1e9c2575",
`data/pilot/event-boundary-feasibility/source-candidates.csv` = "9229340b953dec55196a97c95ec0e807982ca1aaa434fb3533125a1d777062bd",
`data/pilot/event-boundary-feasibility/strategy-comparison.csv` = "f54de048d8c65d3f812585741177670c0259726f18879f01d5e7bdee23bc369c",
`data/pilot/event-boundary-feasibility/summary.csv` = "db8ecd40a52bf6803cfcf004bfcffda8a3d3df67094a2aca4173f49e26d33718",
`data/pilot/event.csv` = "968bfd42521ab8a40d30bf8ea4819f03b46fdd81ff85b699ab3ca31c5680c818",
`data/pilot/four-factors-candidate-metric-feasibility/association-summary.csv` = "1c8481ff2d7a8ffa0744d60fd756ed6fd35183d26a6e611f816a995fc1bb98b0",
`data/pilot/four-factors-candidate-metric-feasibility/candidate-dictionary.csv` = "34184649c3e20e9d0ee1224738dbedd59ff5fa49bc9161c66a80e5914ed52125",
`data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv` = "7ea6feb58a428ab45bfabcc2a5c3a87eef0485f92062fa1e1cac4b4cade5d982",
`data/pilot/four-factors-candidate-metric-feasibility/denominator-summary.csv` = "222b94f1544f58580fc680011323c5d83b7f8a3409a8c74169ddec9f66b31e12",
`data/pilot/four-factors-candidate-metric-feasibility/distribution-summary.csv` = "61f3c54bbffa28bb29c14ab352672a3009e5b32e63a92ae090b4de3d98900052",
`data/pilot/four-factors-candidate-metric-feasibility/eligibility-audit.csv` = "f22238692376c1a479a951835cb476049a37dcc24fa5c29fdf6e48a6133f3c6e",
`data/pilot/four-factors-candidate-metric-feasibility/input-provenance.csv` = "63ebeaec1a754242be1cf55721efa1b5349bfb53fc3daf38903bee66a5a94924",
`data/pilot/four-factors-candidate-metric-feasibility/match-metrics.csv` = "08fab6a064cde564a6dc949e41c2ee46fcf7a69a327322fffed62168196d945d",
`data/pilot/four-factors-candidate-metric-feasibility/matrix-diagnostics.csv` = "220144d8fcaceb0e4c59c333d4ec23c36b2ad7001c3c080fc50f137705460dc5",
`data/pilot/four-factors-candidate-metric-feasibility/metric-availability.csv` = "7601e8261ea0c6f1dde8faf04fb0d9da880949bf9bf63b4e42374435d6391e2f",
`data/pilot/four-factors-candidate-metric-feasibility/missingness-summary.csv` = "95e4ed1f8563265db097958e3587c3b004675505730ffd5e549cf99b171660f5",
`data/pilot/four-factors-candidate-metric-feasibility/redundancy-map.csv` = "7dd57550d3ce1bdd8646d00e9673f340c4000b3dbf12fbd4a4d5e2ec6cce4fd0",
`data/pilot/four-factors-candidate-metric-feasibility/sensitivity-summary.csv` = "a3f16f79d7bc9def780256f3a9ab9b7ad568e6f93fececfe17427a1f4544423e",
`data/pilot/four-factors-candidate-metric-feasibility/summary.csv` = "617825c03b3098df820503211bd5c9b200ce88e0c30a05235871c457b14043cf",
`data/pilot/identities.csv` = "ca4a10a2482d08cb74a19014f9d755e1a735decd58170cb9ac498a3d4ebf8680",
`data/pilot/inventory/atp-page-1.png` = "4122e2c6bf3fd394a1e18d160d963d2dbaa2bfceb649777b7f9e17e8cfefe151",
`data/pilot/inventory/atp-page-2.png` = "8e9a33cbd0adbb40dc5de0b4cd8f3bd62dc405f522e4e24b77999f48b38c5011",
`data/pilot/inventory/atp-pdf-observations.csv` = "260b281c7992e79b47dafc21a236c24fe5fa33e5b38b2cdd581c630b2a0e91cd",
`data/pilot/inventory/conflicts.csv` = "1a5234946b836f4f2c1b6ca26f1222b3a5ae4fd7d880c2db475ff597696f61f6",
`data/pilot/inventory/identity-review.csv` = "57b29e77bd6a31e525eb6b2289275313ab45999732774cf8c1cc9e3bb1fbb3d9",
`data/pilot/inventory/inventory-summary.csv` = "f2110245764d2b24c12eee2b27877d73bbc3ed13f983c604e025c9db233e0be6",
`data/pilot/inventory/match-reconciliation.csv` = "e80e3c47228ffef3bdbd14cb7efb8f2345b6df10f0dc46b94ae90556c8416ac3",
`data/pilot/inventory/normalization-decisions.csv` = "e8e63e2947ff0f36781013d0f06308c1e4b64206f6f2764932bb7f5532360225",
`data/pilot/inventory/official-matches.csv` = "3fe2ff0e0c8e424f6c93247344ed5ffb269c1e1d6a40046273635a3f07553a1c",
`data/pilot/inventory/official-only.csv` = "3d170c1cc2c66e7a957cf8b32f743d2631463c0b3a2d90888bf917c8ad32e544",
`data/pilot/inventory/reference-comparison.csv` = "e8fa870adcf0818c32b6f2df13a724f90a000c1bf3d3e12340c4041198b70e4e",
`data/pilot/inventory/reference-conflicts.csv` = "8a7df76185b3f591c2fc2067941b6a2a0e8108b9ebe6fc5f41c3d8ceeb4d0f7a",
`data/pilot/inventory/round-summary.csv` = "f4d34ec90b25ee96473ebedcd43e0589ca2b92dfb6d6c6386923d90d020f9466",
`data/pilot/inventory/source-matches.csv` = "c5beb37d7453558cec3501ed1f28db27c3c634d953d99cb3e5c4763a7595145f",
`data/pilot/inventory/source-only.csv` = "a0297e28dbfdea9291ec165c821b17fe9fdbb512360550412010addfeee6777d",
`data/pilot/inventory/status-summary.csv` = "64c7b7975bd58f03a74cc343528890bcd7c1372750f1ba0c1d4401ccd851b352",
`data/pilot/inventory/wta-page-1.png` = "2b220bd7aed99c5a04840012a8b30483eef548663b89db1334e2dcea3b0bdd71",
`data/pilot/inventory/wta-page-2.png` = "32231a4a5e4e32a1923e87196ee2a0f4ae0a10b99d57cf78f78fd45ed9078970",
`data/pilot/otd-documentation/attempt-1.rds` = "ac1f2208f5efbed8d0b62bc6801d8db9842c25554ceb19728aec6b0e26f0930d",
`data/pilot/otd-documentation/attempt-1.rds.sha256` = "a16934d60c54978971f4424e58be70df5cfc19fb71d1a94a119dc72f824b163b",
`data/pilot/otd-documentation/manifest.csv` = "156973b5af3abc7864e28eab1e88318c369b988d3ab4f6c602ab796658354aee",
`data/pilot/otd-documentation/manifest.csv.sha256` = "a29628e170552899573442aea803cfc21df5de5d0bfc8a0e19e6219b1c13b1ac",
`data/pilot/otd-documentation/response-1.rds` = "bc15b4f2494d31f347ae29df012c38fb2bf6a27396ec799f82a1a3d6e125026d",
`data/pilot/otd-documentation/response-1.rds.sha256` = "e60f3d69de55cb082854bd294bea2e73e2a4810f3f941d96d2383cda4445c607",
`data/pilot/otd-documentation/review-1.rds` = "c741444b2cffca17c5d60446ba8d747e33ea1e252df5fa9df61d2b0bca80bef3",
`data/pilot/otd-documentation/review-1.rds.sha256` = "6db1fc95e1e059cda4a5acef4353113d53fc50d4fd365d62d41a223105e93807",
`data/pilot/package-b-evidence-route-proposal/cell-evidence-gaps.csv` = "830dbd35fd603c7da5a1012c4f7e73220e21402b9dda9985e3eda843affeb2a2",
`data/pilot/package-b-evidence-route-proposal/decisions.csv` = "70828d4b104f11cf1b3e02455e9c25f8b74ea32e14a5e202f2193a0111c977d7",
`data/pilot/package-b-evidence-route-proposal/input-provenance.csv` = "6a7b33b7d5e52645850b982ae5abb3e96d2cfb925131c5c8367906e26ae52efd",
`data/pilot/package-b-evidence-route-proposal/route-assessment.csv` = "b91b3cec9602d2307653fb0e1c8f6b3ee68d4a31badc29f112da92212139470c",
`data/pilot/package-b-evidence-route-proposal/staged-execution-plan.csv` = "ff908155b5ac119f5cdc5319ae5f104811788bc2cf1f302ce7bd923f0d71f61a",
`data/pilot/package-b-evidence-route-proposal/summary.csv` = "358fdbb1d60c6c168e1ac93afb19763d94f703af02efa9859fd70db6a063118d",
`data/pilot/rounds.csv` = "f32cdb94b64e95d0aa63ce7bbf4166cd352879aa313502ca6c843bc0ec6d8b04",
`data/pilot/rows.csv` = "fce15646c8383093f14f361424510abbfbf0ba0f41065e5aa41453947bd56b5c",
`data/pilot/statuses.csv` = "6a36fd87568819f69ea472bb04c9b3915853d413e6c8c61b858b2ad86b2bef69",
`data/pilot/wta_indian_wells_2023.csv` = "03afd50a16de2d955f8e45760bc2e9667362288f2c791ccacb5c1047908b149f",
`data/raw/.DS_Store` = "c48ea71611f2bcd9c21742eb62bd03b4063eb27fb2bc01a6b9bd27f45fcb0cac",
`data/raw/reference/indian-wells-2023-anomaly/tennis-abstract.html` = "d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf",
`data/raw/reference/indian-wells-2023-anomaly/wta-draws.html` = "9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a",
`data/raw/reference/indian-wells-2023-anomaly/wta-match-LS033.html` = "de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196",
`data/raw/reference/indian-wells-2023-anomaly/wta-MDS.pdf` = "573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960",
`data/raw/reference/indian-wells-2023-inventory/atp_draw_browser.txt` = "aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513",
`data/raw/reference/indian-wells-2023-inventory/atp_results_browser.txt` = "1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f",
`data/raw/reference/indian-wells-2023-inventory/atp-mds.pdf` = "0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5",
`data/raw/reference/montreal-2021-chronology/wta-stage-a-terms.html` = "f0185c0ec14067732a3797e3604ef686edf739241371ca91d41fb741cf558918",
`data/raw/reference/montreal-2021-feasibility/draw_html.html` = "58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d",
`data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf` = "3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c",
`data/raw/reference/montreal-2021-feasibility/LS001.html` = "673b2b89f39931723aeeba444805baeb8f1d1958a4468f0e2615af4a70029c6b",
`data/raw/reference/montreal-2021-feasibility/LS002.html` = "2f5d04a3fa7318ab5568d42b27913e416a30ec4f9108cd228dd192ff6d982731",
`data/raw/reference/montreal-2021-feasibility/LS003.html` = "cc1e8c95c9d0faf6f356c51f0df70b63df5194c3bdecd1ab30405915dafb7dc4",
`data/raw/reference/montreal-2021-feasibility/LS004.html` = "4bd57b03f3704a0a931621b8bc7e392a02b16e900b557b55d9e04e1b755b2c71",
`data/raw/reference/montreal-2021-feasibility/LS005.html` = "4dadbe412c9e265c8e646e82c347e423d97b5c8191c749df88f78829d4c2c212",
`data/raw/reference/montreal-2021-feasibility/LS006.html` = "8b182361666663bc167eee5996a32cfa8292000900b75c4af4e966df272e59e1",
`data/raw/reference/montreal-2021-feasibility/LS007.html` = "ef74eae35355c08156c57dd8bbcb203669078b1df7bcd16bbd82a3cbb7550a5c",
`data/raw/reference/montreal-2021-feasibility/LS042.html` = "42c6c106cc94dbceea6abd0877faf7f09a43f7203da0a677e9b6630e88cd9a04",
`data/raw/reference/montreal-2021-feasibility/LS049.html` = "37181542ef2e700c6d278791b1e44214d702dcfc3eced344813ee67ddac8f09f",
`data/raw/reference/montreal-2021-feasibility/overview.html` = "d6f2c7b0c1f5e51a4711a6cb3b0aea9ad71d2d327172a345c2eb470883b72a08",
`data/raw/reference/otd-documentation/response-1.body` = "51e17ec16942ccd9f2512da9bb0ee32389579632094859a7efc6322f2f80cc0f",
`data/raw/reference/otd-documentation/response-1.headers` = "3851615d6390eefe24d80018601602619175a7010fa6627b2b038fcf4fe33e63",
`data/raw/sackmann/.DS_Store` = "34c0710c3eb41078e4def3824febe392b2cd803b364c79e1e8b6cf0c5653ddef",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.csv` = "b9b1d31a4b0b9273b8f338cbb1347c5a847ad2361334ec760a286f5990fba347",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2021.metadata.json` = "1b51d087b873bb723c9d36d9f5c1d0a7a1157ba8e41a00cfbe8edb2ea1723a71",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp_matches_2023.csv` = "9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv` = "3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.metadata.json` = "0fa5e566a01976cda8df0bf379c4a7e36187bf02c2205ad20201d60b21a5f64f",
`data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2023.csv` = "b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18"
)
pe_preserve <- function() {
  pins<-pe_historical_pins()
  for(p in names(pins)) {
    pe_need(file.exists(p)&&normalizePath(p)==file.path(normalizePath("."),p),paste("historical file missing or redirected",p))
    pe_need(identical(pe_hash(p),unname(pins[p])),paste("historical file changed",p))
  }
  data.frame(path=names(pins),sha256=unname(pins),byte_size=file.info(names(pins))$size,
    mtime=as.numeric(file.info(names(pins))$mtime),row.names=NULL)
}
revalidate_current_context_pilots <- function() {
  before<-pe_preserve();result<-pe_build();pe_need(identical(before,pe_preserve()),'historical preservation');pe_publish(result);message(result$decisions$value[1]);invisible(result)
}
if(sys.nframe()==0L)revalidate_current_context_pilots()
