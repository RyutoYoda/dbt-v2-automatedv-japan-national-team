with current_team_attributes as (
    select
        team_hk,
        team_name
    from {{ ref('sat_team') }}
    qualify row_number() over (
        partition by team_hk
        order by load_datetime desc, team_hashdiff desc
    ) = 1
)
select
    team.team_id,
    team.team_hk,
    attributes.team_name
from {{ ref('hub_team') }} as team
join current_team_attributes as attributes
  on team.team_hk = attributes.team_hk
