select
    match_id,
    match_date,
    season_name,
    competition_name,
    home_team_name,
    home_score,
    away_team_name,
    away_score,
    case when home_team_name = 'Japan' then home_score > away_score
         when away_team_name = 'Japan' then away_score > home_score end as japan_won,
    stage_name,
    stadium_name
from {{ ref('v_stg_matches') }}
