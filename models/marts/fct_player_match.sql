with current_lineup_attributes as (
    select
        player_match_hk,
        jersey_number,
        position_name,
        is_starter
    from {{ ref('sat_player_match') }}
    qualify row_number() over (
        partition by player_match_hk
        order by load_datetime desc, lineup_hashdiff desc
    ) = 1
)
select
    player.master_player_id as player_id,
    match.match_id,
    team.team_id,
    lineup.position_name,
    lineup.jersey_number,
    lineup.is_starter,
    1 as lineup_record_count
from {{ ref('link_player_match') }} link
join {{ ref('hub_player') }} player
  on link.player_hk = player.player_hk
join {{ ref('hub_match') }} match
  on link.match_hk = match.match_hk
join {{ ref('hub_team') }} team
  on link.team_hk = team.team_hk
join current_lineup_attributes lineup
  on link.player_match_hk = lineup.player_match_hk
