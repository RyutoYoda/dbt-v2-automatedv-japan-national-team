{{ config(materialized='view') }}

select
    match_id::varchar as match_id,
    season_name,
    match_date::date as match_date,
    competition_id::varchar as competition_id,
    competition_name,
    home_team_id::varchar as home_team_id,
    home_team_name,
    home_score::number as home_score,
    away_team_id::varchar as away_team_id,
    away_team_name,
    away_score::number as away_score,
    stage_name,
    stadium_name,
    record_source,
    loaded_at::timestamp_ntz as load_datetime,
    md5(upper(trim(match_id::varchar))) as match_hk,
    md5(upper(trim(competition_id::varchar))) as competition_hk,
    md5(upper(trim(home_team_id::varchar))) as home_team_hk,
    md5(upper(trim(away_team_id::varchar))) as away_team_hk
    ,md5(coalesce(home_score::varchar, '') || '|' || coalesce(away_score::varchar, '') || '|' || coalesce(stage_name, '') || '|' || coalesce(stadium_name, '')) as match_hashdiff
from {{ ref('statsbomb_matches') }}
