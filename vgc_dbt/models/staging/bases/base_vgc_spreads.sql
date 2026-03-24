with source as (
    select * from {{ source('vgc_raw', 'vgc_spreads') }}
),

deduplicated as (
    select *
    from source
    qualify row_number() over (
        partition by 
            pokemon_name, nature, ev_hp, ev_atk, 
            ev_def, ev_spa, ev_spd, ev_spe, 
            date, regulation 
        order by ingested_at desc
    ) = 1
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'pokemon_name', 'nature', 'ev_hp', 'ev_atk', 
            'ev_def', 'ev_spa', 'ev_spd', 'ev_spe', 
            'date', 'regulation'
        ]) }} as spread_id,
        
        {{ dbt_utils.generate_surrogate_key(['pokemon_name', 'date', 'regulation']) }} as meta_id,

        cast(pokemon_name as varchar) as pokemon_name,
        cast(nature as varchar) as nature,
        cast(ev_hp as int) as ev_hp,
        cast(ev_atk as int) as ev_atk,
        cast(ev_def as int) as ev_def,
        cast(ev_spa as int) as ev_spa,
        cast(ev_spd as int) as ev_spd,
        cast(ev_spe as int) as ev_spe,
        cast(usage_raw as float) as usage_raw,
        cast(date as varchar) as date_id,
        cast(regulation as varchar) as regulation_id,
        cast(ingested_at as timestamp) as ingested_at

    from deduplicated
)

select * from renamed