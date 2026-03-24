with items as (
    select * from {{ ref('base_vgc_items') }}
),
enriched as (
    select
        item_id,
        meta_id,
        pokemon_name,
        item_name,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        
        cast((usage_raw * 100) as decimal(10, 4)) as usage_percent
    from items
    where usage_raw > 0
    and {{ is_valid_string('item_name') }}
)
select * from enriched