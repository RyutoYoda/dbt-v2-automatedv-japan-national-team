with current_player_attributes as (
    select
        player_hk,
        player_name,
        training_registry_id
    from {{ ref('sat_player') }}
    qualify row_number() over (
        partition by player_hk
        order by load_datetime desc, player_hashdiff desc
    ) = 1
),
player_source_map as (
    select
        same_as.player_hk,
        source.player_source_id,
        row_number() over (
            partition by same_as.player_hk
            order by source.player_source_id
        ) as source_rank
    from {{ ref('link_same_as_player') }} as same_as
    join {{ ref('hub_player_source') }} as source
      on same_as.player_source_hk = source.player_source_hk
)
select
    player.master_player_id,
    player.player_hk,
    attributes.player_name,
    attributes.training_registry_id,
    source.player_source_id as statsbomb_player_id
from {{ ref('hub_player') }} as player
join current_player_attributes as attributes
  on player.player_hk = attributes.player_hk
left join player_source_map as source
  on player.player_hk = source.player_hk
 and source.source_rank = 1
