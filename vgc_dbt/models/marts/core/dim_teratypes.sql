with stg_teratypes as (
    select * from {{ ref('stg_vgc_teratypes') }}
)

select distinct
    teratype_name
from stg_teratypes
where teratype_name is not null