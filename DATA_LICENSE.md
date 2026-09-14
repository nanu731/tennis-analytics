# Data licensing and attribution

## Code, source data, and research outputs

The repository's [MIT license](LICENSE) applies to original repository code unless stated otherwise. It does not replace licenses governing third-party tennis data or automatically apply to research outputs derived from that data.

The user has approved this pilot as noncommercial research intended for an educational sports-analytics portfolio. This records intended use; it is not a new grant of rights from a provider. No website publication or player-level data release is part of this milestone.

## Pilot source

Original creator: **Jeff Sackmann / Tennis Abstract**.

- [Original ATP repository](https://github.com/JeffSackmann/tennis_atp)
- [Original WTA repository](https://github.com/JeffSackmann/tennis_wta)
- [Tennis Abstract](https://www.tennisabstract.com/)
- [Aneeshers archival mirror at the approved revision](https://github.com/Aneeshers/tennis-sackmann-archive/tree/83733587353df8a41f2fd4f516147d5aa83f5a8d)

Pinned archive commit: `83733587353df8a41f2fd4f516147d5aa83f5a8d`.

The original pilot acquired only `atp/atp_matches_2023.csv` and `wta/wta_matches_2023.csv`. Phase 1E separately authorized and acquired `atp/atp_matches_2021.csv` and `wta/wta_matches_2021.csv` at the same revision, with their pinned API metadata, for local noncommercial educational research. The archive's [README](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/README.md) describes preservation of Jeff Sackmann's ATP/WTA snapshots and states that the mirror adds no rights. This is the archive's provenance statement, not independent proof of the entire upstream chain.

The [pinned archive license](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/LICENSE), [preserved ATP README](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp/UPSTREAM_README.md), and [preserved WTA README](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta/UPSTREAM_README.md) identify **CC BY-NC-SA 4.0**. They describe credit to the creator, links to original sources, notice of changes, noncommercial use, and share-alike requirements for covered adaptations. See the [license deed](https://creativecommons.org/licenses/by-nc-sa/4.0/) and [legal code](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode). The full legal code was not independently reviewed in this pilot; these links are authoritative references, not a claim of a completed legal review.

## Local data and tracked evidence

The unedited annual source files live under `data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/`. Indian Wells subsets and local audit tables live under `data/pilot/`. Both directories are excluded from Git. Their source-specific terms remain applicable even though the files are local.

The tracked [manifest](data/manifests/pilot-source-files.csv) contains acquisition metadata and checksums, not match rows. The tracked [audit report](docs/pilot-acquisition-audit.md) contains aggregate availability/count findings and minimal source match references needed to explain an anomaly. It is not a public player-statistics dataset.

Phase 1E uses a separate [development manifest](data/manifests/development-source-files.csv) and [2021 source audit](docs/2021-annual-source-audit.md). It profiles unchanged annual bytes and annotates source event candidates without creating canonical matches or redistributing full match tables. Saved API JSON and generated audit CSVs remain ignored. Existing licensing evidence was reused, not fetched or legally re-reviewed; historical 2021 rows come from the documented 2026 archive snapshot.

Maintain creator attribution, source revision, license links, and transformation descriptions with these tracked records. To the extent that incorporated or adapted source material is covered by CC BY-NC-SA 4.0, retain those obligations; do not relabel it as MIT. This notice does not declare every aggregate legally exempt from the source terms or grant permission for every future output.

Raw bytes were not changed. Local transformations select Indian Wells rows, parse counts for validation, identify score markers, and summarize audit results. The subsets preserve source columns and values; they retain winner/loser orientation and are not canonical predictive tables. No source error was corrected.

Suggested attribution for future permitted uses: “Source: Jeff Sackmann / Tennis Abstract, ATP and WTA tennis data, via the Aneeshers archival mirror at commit 83733587353df8a41f2fd4f516147d5aa83f5a8d; CC BY-NC-SA 4.0. Indian Wells selection and data-quality audit by this project.” Include the relevant source and license links and specify any subsequent transformations.

## Before publication

Review intended portfolio-use compatibility and the licensing treatment of player-level derived data, ratings, exports, and other research outputs before publishing them. Commercial use, raw redistribution, and broader third-party source adoption are not authorized by this notice. Recheck applicable terms when scope or source version changes.

This document reports source terms and project handling; it is not legal advice. Source documentation was checked on 2026-09-14. See the [source contract](docs/data-source-contract.md) for remaining provenance and methodological limits.
