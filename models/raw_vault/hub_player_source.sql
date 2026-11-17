{% set source_model = 'v_stg_players' %}
{% set src_pk = 'PLAYER_SOURCE_HK' %}
{% set src_nk = 'PLAYER_SOURCE_ID' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
