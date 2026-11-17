{% set source_model = 'v_stg_lineups' %}
{% set src_pk = 'PLAYER_MATCH_HK' %}
{% set src_fk = ['PLAYER_HK', 'MATCH_HK', 'TEAM_HK'] %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
