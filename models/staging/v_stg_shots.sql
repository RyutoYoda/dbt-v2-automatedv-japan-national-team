{{ config(materialized='view') }}

select
    event_id,
    cast(match_id as string) as match_id,
    cast(team_id as string) as team_id,
    cast(player_id as string) as player_id,
    cast(period as int) as period,
    cast(minute as int) as minute,
    cast(second as int) as second,
    timestamp as event_timestamp,
    shot_type,
    shot_outcome,
    cast(shot_xg as double) as shot_xg,
    record_source,
    cast(loaded_at as timestamp) as load_datetime,
    md5(upper(trim(cast(match_id as string)))) as match_hk,
    md5(upper(trim(cast(team_id as string)))) as team_hk,
    md5(upper(trim(cast(player_id as string)))) as player_source_hk,
    md5(upper(trim(event_id))) as event_hk
from {{ ref('statsbomb_shots') }}
