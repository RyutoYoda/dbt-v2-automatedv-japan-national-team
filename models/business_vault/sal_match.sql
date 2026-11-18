with current_match_attributes as (
    select *
    from {{ ref('sat_match') }}
    qualify row_number() over (
        partition by match_hk
        order by load_datetime desc, match_hashdiff desc
    ) = 1
)
select
    match.match_id,
    match.match_hk,
    attributes.match_date,
    attributes.season_name,
    attributes.competition_name,
    attributes.home_team_name,
    attributes.home_score,
    attributes.away_team_name,
    attributes.away_score,
    attributes.stage_name,
    attributes.stadium_name
from {{ ref('hub_match') }} as match
join current_match_attributes as attributes
  on match.match_hk = attributes.match_hk
