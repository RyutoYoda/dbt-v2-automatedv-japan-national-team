{% set source_model = 'v_stg_players' %}
{% set src_pk = 'SAME_AS_PLAYER_HK' %}
{% set src_fk = ['PLAYER_HK', 'PLAYER_SOURCE_HK'] %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
