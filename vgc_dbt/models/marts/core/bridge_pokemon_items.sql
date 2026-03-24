with stg_items as (
    select * from {{ ref('stg_vgc_items') }}
)
select
    item_id,
    meta_id,
    item_name,
    usage_percent
from stg_items