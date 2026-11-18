select
    team_id,
    team_name
from {{ ref('sal_team') }}
