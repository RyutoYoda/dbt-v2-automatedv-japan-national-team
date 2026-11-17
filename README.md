# Data Vault 2.0 with dbt v2: Samurai Blue training project

This project teaches the Raw Vault and Business Vault patterns from the Japan national football team example. It uses dbt v2 and AutomateDV, with Snowflake as the execution platform because it is supported by both projects.

## What you will learn

- AutomateDV staging, hash keys, hashdiffs, Hubs, Links, and Satellites
- Link Satellites and Effectivity Satellites
- Non-historized Links for match events
- Hub-it-out and Same-as Links for source-specific player IDs and identity resolution
- A business-facing match mart built from the vault
- dbt v2 static analysis, model contracts, and column-level lineage

The source fixtures cover Japan's 2022 FIFA World Cup matches in StatsBomb Open Data. A second, clearly labeled `training_roster_registry` identifier is generated for each source player so the project can demonstrate BKCC and Same-as Link patterns; it is **not** a real JFA identifier or JFA feed. The fixture refresh script only selects the 2022 tournament.

## Requirements

- Python 3.10+
- `uv`
- dbt v2.0.11+
- A Snowflake account and credentials for running models

AutomateDV v0.11.5 is pinned. Its compatibility matrix supports dbt versions `>=1.9.x, <3.0.0`; the package officially lists Snowflake among supported platforms. DuckDB is not in AutomateDV's platform support list, so this training project uses Snowflake rather than implying DuckDB support.

## Setup and run

```bash
uv sync
uv run dbt deps
cp profiles.yml.example ~/.dbt/profiles.yml
```

Set the environment variables referenced by `profiles.yml.example`, then run the commands directly:

```bash
uv run dbt debug
uv run dbt seed --full-refresh
uv run dbt run --static-analysis strict
uv run dbt docs generate
uv run dbt docs serve
```

`dbt debug` checks the connection. `dbt seed` loads the small, checked-in source snapshots. `dbt run` builds the staging views, Raw Vault, Business Vault, and marts. The models are incremental where Data Vault history must be retained. To reset the training schemas, drop the project schemas in your Snowflake development database, then rerun the commands above.

The checked-in seeds are the Japan matches from the 2022 FIFA World Cup. To refresh the snapshots from StatsBomb Open Data, run `python3 scripts/refresh_open_data.py` before `dbt seed`. The project intentionally has no Makefile: each command is shown explicitly so learners can see which dbt operation they are running.

## Model map

| Layer | Examples | Purpose |
|---|---|---|
| Seeds | `statsbomb_matches`, `statsbomb_lineups`, `statsbomb_shots`, `training_player_identity_map` | Small reproducible input snapshots |
| Staging | `v_stg_*` | Normalize source fields and calculate AutomateDV hash keys/hashdiffs |
| Raw Vault | `hub_*`, `link_*`, `sat_*`, `eff_sat_*`, `nhl_*` | Preserve source keys, relationships, history, and match events |
| Business Vault | `sal_player`, `player_tournament_periods` | Resolve identities and derive observed participation periods |
| Marts | `fct_japan_match_results`, `dim_player` | Consumer-friendly examples |

`eff_sat_player_tournament` describes the first-to-last observed lineup window in a tournament. It does not claim to be the official squad appointment or contract period.

## Data source and attribution

Match, lineup, and event samples are derived from [StatsBomb Open Data](https://github.com/hudl/open-data), whose repository terms ask users to credit StatsBomb when publishing analysis or insights. This README provides that attribution. The examples are for learning Data Vault modeling, not an official JFA data product. Data is limited to Japan's 2022 FIFA World Cup tournament; it is not current national-team data.

The reference article is [推し活サイトで学ぶData Vault入門](https://www.yasuhisay.info/entry/2026/11/16/205648). Its concepts are adapted to international football rather than copied as a production data model.

## Notes

- dbt v2 requires a supported adapter. AutomateDV v0.11.5 is pinned to a version whose compatibility range includes dbt v2.
- Snowflake credentials are not stored in this repository. Use a dedicated development database/schema.
- Incremental Raw Vault models preserve history. Do not use `--full-refresh` casually after loading data.
