with spreads as (
    select * from {{ ref('base_vgc_spreads') }}
),
enriched as (
    select
        spread_id,
        meta_id,
        pokemon_name,
        nature,
        ev_hp,
        ev_atk,
        ev_def,
        ev_spa,
        ev_spd,
        ev_spe,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        
        cast((usage_raw * 100) as decimal(10, 4)) as usage_percent
    from spreads
    where usage_raw > 0
)
select * from enriched