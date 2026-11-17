{% set source_model = 'v_stg_shots' %}
{% set src_pk = 'EVENT_HK' %}
{% set src_fk = ['MATCH_HK', 'TEAM_HK', 'PLAYER_SOURCE_HK'] %}
{% set src_payload = ['PERIOD', 'MINUTE', 'SECOND', 'EVENT_TIMESTAMP', 'SHOT_TYPE', 'SHOT_OUTCOME', 'SHOT_XG'] %}
{% set src_eff = 'EVENT_TIMESTAMP' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.t_link(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                      src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                      source_model=source_model) }}
