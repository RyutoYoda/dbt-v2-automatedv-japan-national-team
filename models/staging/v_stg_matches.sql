{{ config(materialized='view') }}

select
    cast(match_id as string) as match_id,
    season_name,
    cast(match_date as date) as match_date,
    cast(competition_id as string) as competition_id,
    competition_name,
    cast(home_team_id as string) as home_team_id,
    home_team_name,
    cast(home_score as int) as home_score,
    cast(away_team_id as string) as away_team_id,
    away_team_name,
    cast(away_score as int) as away_score,
    stage_name,
    stadium_name,
    record_source,
    cast(loaded_at as timestamp) as load_datetime,
    md5(upper(trim(cast(match_id as string)))) as match_hk,
    md5(upper(trim(cast(competition_id as string)))) as competition_hk,
    md5(upper(trim(cast(home_team_id as string)))) as home_team_hk,
    md5(upper(trim(cast(away_team_id as string)))) as away_team_hk,
    md5(coalesce(cast(home_score as string), '') || '|' || coalesce(cast(away_score as string), '') || '|' || coalesce(stage_name, '') || '|' || coalesce(stadium_name, '')) as match_hashdiff
from {{ ref('statsbomb_matches') }}
