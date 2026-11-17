{% set source_model = 'v_stg_lineups' %}
{% set src_pk = 'PLAYER_MATCH_HK' %}
{% set src_hashdiff = 'LINEUP_HASHDIFF' %}
{% set src_payload = ['JERSEY_NUMBER', 'POSITION_NAME', 'IS_STARTER'] %}
{% set src_eff = 'LOAD_DATETIME' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                   src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}
