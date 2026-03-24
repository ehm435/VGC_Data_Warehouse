with stg_meta as (
    select * from {{ ref('stg_vgc_meta') }}
)
select distinct
    pokemon_name
from stg_meta
where pokemon_name is not null