{{ config(materialized='view') }}

select distinct
       home_team_id as team_id,
       home_team_name as team_name,
       load_datetime,
       record_source,
       md5(upper(trim(cast(home_team_id as string)))) as team_hk,
       md5(coalesce(home_team_name, '')) as team_hashdiff
from {{ ref('v_stg_matches') }}
union
select distinct
       away_team_id as team_id,
       away_team_name as team_name,
       load_datetime,
       record_source,
       md5(upper(trim(cast(away_team_id as string)))) as team_hk,
       md5(coalesce(away_team_name, '')) as team_hashdiff
from {{ ref('v_stg_matches') }}
union
select distinct
       team_id,
       team_name,
       load_datetime,
       record_source,
       team_hk,
       md5(coalesce(team_name, '')) as team_hashdiff
from {{ ref('v_stg_lineups') }}
