select
    shot.event_hk as shot_event_key,
    player.master_player_id as player_id,
    match.match_id,
    team.team_id,
    shot.period,
    shot.minute,
    shot.second,
    shot.event_timestamp,
    shot.shot_type,
    shot.shot_outcome,
    shot.shot_xg,
    case when lower(shot.shot_outcome) = 'goal' then 1 else 0 end as goal_count,
    1 as shot_count
from {{ ref('nhl_shot_event') }} shot
left join {{ ref('link_same_as_player') }} same_as
  on shot.player_source_hk = same_as.player_source_hk
left join {{ ref('hub_player') }} player
  on same_as.player_hk = player.player_hk
join {{ ref('hub_match') }} match
  on shot.match_hk = match.match_hk
join {{ ref('hub_team') }} team
  on shot.team_hk = team.team_hk
