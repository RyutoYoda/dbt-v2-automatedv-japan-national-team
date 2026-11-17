{{ config(materialized='view') }}

select
    cast(l.match_id as string) as match_id,
    cast(l.team_id as string) as team_id,
    l.team_name,
    cast(l.player_id as string) as player_id,
    l.player_name,
    cast(l.jersey_number as int) as jersey_number,
    l.position_name,
    cast(l.is_starter as boolean) as is_starter,
    l.record_source,
    cast(l.loaded_at as timestamp) as load_datetime,
    md5(upper(trim(cast(l.match_id as string)))) as match_hk,
    md5(upper(trim(cast(l.team_id as string)))) as team_hk,
    p.player_source_hk,
    p.player_hk,
    md5(upper(trim(cast(l.match_id as string))) || '|' || upper(trim(cast(l.team_id as string))) || '|' || upper(trim(cast(l.player_id as string)))) as player_match_hk,
    md5(coalesce(cast(l.jersey_number as string), '') || '|' || coalesce(l.position_name, '') || '|' || coalesce(cast(l.is_starter as string), '')) as lineup_hashdiff
from {{ ref('statsbomb_lineups') }} l
left join {{ ref('v_stg_players') }} p
    on cast(l.player_id as string) = p.player_source_id
