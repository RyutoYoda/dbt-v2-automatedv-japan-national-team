select
    p.master_player_id as player_id,
    p.player_name,
    p.statsbomb_player_id,
    p.training_registry_id,
    tp.first_observed_match_date,
    tp.last_observed_match_date,
    tp.tournament_name
from {{ ref('sal_player') }} p
left join {{ ref('player_tournament_periods') }} tp
  on p.player_hk = tp.player_hk
