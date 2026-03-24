with teratypes as (
    select * from {{ ref('base_vgc_teratypes') }}
),

enriched as (
    select
        teratype_id,
        meta_id,
        pokemon_name,
        teratype_name,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        
        cast((usage_raw * 100) as decimal(10, 4)) as usage_percent

    from teratypes
    where usage_raw > 0
    and {{ is_valid_string('teratype_name') }}
)

select * from enriched