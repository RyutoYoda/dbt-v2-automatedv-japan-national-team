{% set source_model = 'v_stg_player_competition' %}
{% set src_pk = 'PLAYER_COMPETITION_HK' %}
{% set src_dfk = 'PLAYER_HK' %}
{% set src_sfk = 'COMPETITION_HK' %}
{% set src_start_date = 'START_DATE' %}
{% set src_end_date = 'END_DATE' %}
{% set src_eff = 'START_DATE' %}
{% set src_ldts = 'LOAD_DATETIME' %}
{% set src_source = 'RECORD_SOURCE' %}

{{ automate_dv.eff_sat(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                       src_start_date=src_start_date, src_end_date=src_end_date,
                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                       source_model=source_model) }}
