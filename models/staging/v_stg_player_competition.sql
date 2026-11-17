{{ config(materialized='view') }}

select
    md5(l.player_hk || '|' || m.competition_hk) as player_competition_hk,
    l.player_hk,
    m.competition_hk,
    min(m.match_date) as start_date,
    max(m.match_date) as end_date,
    min(m.match_date) as effectivity_date,
    max(l.load_datetime) as load_datetime,
    max(l.record_source) as record_source
from {{ ref('v_stg_lineups') }} l
join {{ ref('v_stg_matches') }} m
  on l.match_id = m.match_id
group by l.player_hk, m.competition_hk
