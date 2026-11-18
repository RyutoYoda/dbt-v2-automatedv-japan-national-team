select
    match_id,
    match_date,
    season_name,
    competition_name,
    case
        when home_team_name = 'Japan' then away_team_name
        when away_team_name = 'Japan' then home_team_name
    end as opponent_team_name,
    stage_name,
    stadium_name
from {{ ref('sal_match') }}
