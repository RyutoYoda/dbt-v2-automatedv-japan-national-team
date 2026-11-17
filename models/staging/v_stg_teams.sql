{{ config(materialized='view') }}

select distinct home_team_id as team_id, home_team_name as team_name,
       load_datetime, record_source,
       md5(upper(trim(home_team_id::varchar))) as team_hk
from {{ ref('v_stg_matches') }}
union
select distinct away_team_id, away_team_name, load_datetime, record_source,
       md5(upper(trim(away_team_id::varchar)))
from {{ ref('v_stg_matches') }}
union
select distinct team_id, team_name, load_datetime, record_source, team_hk
from {{ ref('v_stg_lineups') }}
