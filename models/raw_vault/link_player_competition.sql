{% set source_model = 'v_stg_player_competition' %}
{% set src_pk = 'PLAYER_COMPETITION_HK' %}
{% set src_fk = ['PLAYER_HK', 'COMPETITION_HK'] %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
