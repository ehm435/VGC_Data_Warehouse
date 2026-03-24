with teammates as (
    select * from {{ ref('base_vgc_teammates') }}
),
enriched as (
    select
        teammate_id,
        meta_id,
        pokemon_name,
        teammate_name,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        
        cast((usage_raw * 100) as decimal(10, 4)) as synergy_percent
    from teammates
    where usage_raw > 0
    and {{ is_valid_string('teammate_name') }}
)
select * from enriched