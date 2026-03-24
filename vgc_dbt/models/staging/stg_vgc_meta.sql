with base_meta as (
    select * from {{ ref('base_vgc_meta') }}
)
select * from base_meta