{% set source_model = 'v_stg_matches' %}
{% set src_pk = 'MATCH_HK' %}
{% set src_hashdiff = 'MATCH_HASHDIFF' %}
{% set src_payload = ['MATCH_DATE', 'SEASON_NAME', 'COMPETITION_NAME', 'HOME_TEAM_NAME', 'HOME_SCORE', 'AWAY_TEAM_NAME', 'AWAY_SCORE', 'STAGE_NAME', 'STADIUM_NAME'] %}
{% set src_eff = 'MATCH_DATE' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                   src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}
