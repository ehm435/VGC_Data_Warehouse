with stg_meta as (
    select * from {{ ref('stg_vgc_meta') }}
)
select
    meta_id,
    pokemon_name,
    date_id,
    regulation_id,
    usage_raw,
    raw_count,
    cast((usage_raw * 100) as decimal(10, 4)) as usage_percent
from stg_meta