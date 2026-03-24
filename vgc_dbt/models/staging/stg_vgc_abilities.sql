with abilities as (
    select * from {{ ref('base_vgc_abilities') }}
),
enriched as (
    select
        ability_id,
        meta_id,
        pokemon_name,
        ability_name,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        
        cast((usage_raw * 100) as decimal(10, 4)) as usage_percent
    from abilities
    where usage_raw > 0
    and {{ is_valid_string('ability_name') }}
)
select * from enriched