with stg_teratypes as (
    select * from {{ ref('stg_vgc_teratypes') }}
)

select
    teratype_id,
    meta_id,
    teratype_name,
    usage_percent
from stg_teratypes