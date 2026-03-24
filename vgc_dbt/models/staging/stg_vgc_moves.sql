with moves as (
    select * from {{ ref('base_vgc_moves') }}
),

enriched as (
    select
        move_id,
        meta_id,
        pokemon_name,
        move_name,
        usage_raw,
        date_id,
        regulation_id,
        ingested_at,
        cast((usage_raw * 100) as decimal(10, 4)) as usage_percent

    from moves
    -- Filtramos el "ruido" (movimientos con peso 0 en alto ELO)
    where usage_raw > 0
    and {{ is_valid_string('move_name') }}
)

select * from enriched