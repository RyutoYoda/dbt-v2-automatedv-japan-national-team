select
    l.player_hk,
    min(m.match_date) as first_observed_match_date,
    max(m.match_date) as last_observed_match_date,
    'FIFA World Cup 2022' as tournament_name
from {{ ref('link_player_match') }} as l
join {{ ref('sat_player_match') }} as sm
  on l.player_match_hk = sm.player_match_hk
join {{ ref('hub_match') }} as hm
  on l.match_hk = hm.match_hk
join {{ ref('sat_match') }} as m
  on hm.match_hk = m.match_hk
group by l.player_hk
