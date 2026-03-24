with stg_spreads as (
    select * from {{ ref('stg_vgc_spreads') }}
)
select
    spread_id,
    meta_id,
    nature,
    ev_hp,
    ev_atk,
    ev_def,
    ev_spa,
    ev_spd,
    ev_spe,
    usage_percent
from stg_spreads