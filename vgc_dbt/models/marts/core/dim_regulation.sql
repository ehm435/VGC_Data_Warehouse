with stg_meta as (
    select * from {{ ref('stg_vgc_meta') }}
)
select distinct
    regulation_id
from stg_meta
where regulation_id is not null