select
    p.master_player_id,
    p.player_hk,
    p.player_name,
    p.training_registry_id,
    p.player_source_id as statsbomb_player_id
from {{ ref('v_stg_players') }} p
