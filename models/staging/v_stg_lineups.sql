{{ config(materialized='view') }}

select
    l.match_id::varchar as match_id,
    l.team_id::varchar as team_id,
    l.team_name,
    l.player_id::varchar as player_id,
    l.player_name,
    l.jersey_number::number as jersey_number,
    l.position_name,
    l.is_starter::boolean as is_starter,
    l.record_source,
    l.loaded_at::timestamp_ntz as load_datetime,
    md5(upper(trim(l.match_id::varchar))) as match_hk,
    md5(upper(trim(l.team_id::varchar))) as team_hk,
    p.player_source_hk,
    p.player_hk,
    md5(upper(trim(l.match_id::varchar)) || '|' || upper(trim(l.team_id::varchar)) || '|' || upper(trim(l.player_id::varchar))) as player_match_hk,
    md5(coalesce(l.jersey_number::varchar, '') || '|' || coalesce(l.position_name, '') || '|' || coalesce(l.is_starter::varchar, '')) as lineup_hashdiff
from {{ ref('statsbomb_lineups') }} l
left join {{ ref('v_stg_players') }} p
    on l.player_id::varchar = p.player_source_id
