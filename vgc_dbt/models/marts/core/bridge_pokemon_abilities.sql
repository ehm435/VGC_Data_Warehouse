with stg_abilities as (
    select * from {{ ref('stg_vgc_abilities') }}
)
select
    ability_id,
    meta_id,
    ability_name,
    usage_percent
from stg_abilities