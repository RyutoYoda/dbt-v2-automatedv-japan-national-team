# Data Vault 2.0 with dbt v2: Samurai Blue training project

This project teaches the Raw Vault and Business Vault patterns from the Japan national football team example. It uses dbt v2 and AutomateDV on Databricks Free Edition, so learners can run the project without a paid warehouse account.

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
- A Databricks Free Edition workspace with a SQL warehouse

AutomateDV v0.11.5 is pinned. Its documented dbt compatibility range includes dbt v2, and Databricks is an officially supported platform. dbt v2 also supports the Databricks adapter.

## Setup and run

```bash
uv sync
uv run dbt deps
cp profiles.yml.example ~/.dbt/profiles.yml
```

Set these values from your Databricks workspace and SQL warehouse settings. `DATABRICKS_HOST` is the workspace host without `https://`; `DATABRICKS_HTTP_PATH` is the SQL warehouse HTTP path; `DATABRICKS_CATALOG` is the Unity Catalog catalog to use. `DATABRICKS_SCHEMA` is optional and defaults to `DBT_VAULT_TRAINING`. OAuth handles sign-in; do not put access tokens in this repository.

```bash
export DATABRICKS_HOST="<workspace-host>"
export DATABRICKS_HTTP_PATH="<sql-warehouse-http-path>"
export DATABRICKS_CATALOG="<catalog-name>"
```

Then run the commands directly:

```bash
uv run dbt debug
uv run dbt seed --full-refresh
uv run dbt run --static-analysis strict
uv run dbt docs generate
uv run dbt docs serve
```

`dbt debug` checks the connection. `dbt seed` loads the small, checked-in source snapshots. `dbt run` builds the staging views, Raw Vault, Business Vault, and marts. The models are incremental where Data Vault history must be retained. The schema macro prefixes every layer with your `DATABRICKS_SCHEMA`, keeping this project in its own namespace in the selected catalog.

Model and seed descriptions are maintained in YAML under `models/descriptions.yml` and `seeds/descriptions.yml`. Project-level `persist_docs` settings write the relation and column descriptions as Unity Catalog comments whenever dbt builds the resources.

The checked-in seeds are the Japan matches from the 2022 FIFA World Cup. To refresh the snapshots from StatsBomb Open Data, run `python3 scripts/refresh_open_data.py` before `dbt seed`. The project intentionally has no Makefile: each command is shown explicitly so learners can see which dbt operation they are running.

## Model map

| Layer | Examples | Purpose |
|---|---|---|
| Seeds | `statsbomb_matches`, `statsbomb_lineups`, `statsbomb_shots`, `training_player_identity_map` | Small reproducible input snapshots |
| Staging | `v_stg_*` | Normalize source fields and calculate AutomateDV hash keys/hashdiffs |
| Raw Vault | `hub_*`, `link_*`, `sat_*`, `eff_sat_*`, `nhl_*` | Preserve source keys, relationships, history, and match events |
| Business Vault | `sal_player`, `player_tournament_periods` | Resolve identities and derive observed participation periods |
| Marts | `fct_japan_match_results`, `dim_player` | Consumer-friendly examples |

`eff_sat_player_competition` records each player's first and last observed lineup dates in the 2022 tournament. It does not claim to be the official squad appointment or contract period.

## Data source and attribution

Match, lineup, and event samples are derived from [StatsBomb Open Data](https://github.com/hudl/open-data), whose repository terms ask users to credit StatsBomb when publishing analysis or insights. This README provides that attribution. The examples are for learning Data Vault modeling, not an official JFA data product. Data is limited to Japan's 2022 FIFA World Cup tournament; it is not current national-team data.

The reference article is [推し活サイトで学ぶData Vault入門](https://www.yasuhisay.info/entry/2026/11/16/205648). Its concepts are adapted to international football rather than copied as a production data model.

## Notes

- dbt v2 requires a supported adapter. Databricks is supported by both dbt v2 and AutomateDV.
- Databricks Free Edition has compute quotas and is for non-commercial use. A SQL warehouse is limited to 2X-Small; see [Free Edition limitations](https://docs.databricks.com/aws/en/getting-started/free-edition-limitations).
- Authentication is handled through OAuth. No Databricks token or other credential belongs in this repository.
- Incremental Raw Vault models preserve history. Do not use `--full-refresh` casually after loading data.
