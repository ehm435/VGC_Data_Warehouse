with stg_moves as (
    select * from {{ ref('stg_vgc_moves') }}
)
select
    move_id,
    meta_id,
    move_name,
    usage_percent
from stg_moves