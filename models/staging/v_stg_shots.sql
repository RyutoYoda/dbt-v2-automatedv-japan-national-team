{{ config(materialized='view') }}

select
    event_id,
    match_id::varchar as match_id,
    team_id::varchar as team_id,
    player_id::varchar as player_id,
    period::number as period,
    minute::number as minute,
    second::number as second,
    timestamp as event_timestamp,
    shot_type,
    shot_outcome,
    shot_xg::float as shot_xg,
    record_source,
    loaded_at::timestamp_ntz as load_datetime,
    md5(upper(trim(match_id::varchar))) as match_hk,
    md5(upper(trim(team_id::varchar))) as team_hk,
    md5(upper(trim(player_id::varchar))) as player_source_hk,
    md5(upper(trim(event_id))) as event_hk
from {{ ref('statsbomb_shots') }}
