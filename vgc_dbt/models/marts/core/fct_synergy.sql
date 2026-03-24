with stg_teammates as (
    select * from {{ ref('stg_vgc_teammates') }}
)
select
    teammate_id,
    meta_id,
    pokemon_name as pokemon_a,
    teammate_name as pokemon_b,
    date_id,
    regulation_id,
    synergy_percent
from stg_teammates