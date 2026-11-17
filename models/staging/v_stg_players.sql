{{ config(materialized='view') }}

select
    statsbomb_player_id::varchar as player_source_id,
    training_registry_id,
    master_player_id,
    player_name,
    record_source,
    loaded_at::timestamp_ntz as load_datetime,
    md5(upper(trim(statsbomb_player_id::varchar))) as player_source_hk,
    md5(upper(trim(master_player_id))) as player_hk,
    md5(md5(upper(trim(master_player_id))) || '|' || md5(upper(trim(statsbomb_player_id::varchar)))) as same_as_player_hk,
    md5(coalesce(player_name, '') || '|' || coalesce(training_registry_id, '')) as player_hashdiff
from {{ ref('training_player_identity_map') }}
