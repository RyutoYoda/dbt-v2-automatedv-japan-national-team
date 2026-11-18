{% set source_model = 'v_stg_teams' %}
{% set src_pk = 'TEAM_HK' %}
{% set src_hashdiff = 'TEAM_HASHDIFF' %}
{% set src_payload = ['TEAM_NAME'] %}
{% set src_eff = 'LOAD_DATETIME' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                   src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}
