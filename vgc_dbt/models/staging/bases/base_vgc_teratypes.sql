with source as (
    select * from {{ source('vgc_raw', 'vgc_teratypes') }}
),

deduplicated as (
    select *
    from source
    qualify row_number() over (
        partition by pokemon_name, teratype_name, date, regulation 
        order by ingested_at desc
    ) = 1
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['pokemon_name', 'teratype_name', 'date', 'regulation']) }} as teratype_id,
        {{ dbt_utils.generate_surrogate_key(['pokemon_name', 'date', 'regulation']) }} as meta_id,

        cast(pokemon_name as varchar) as pokemon_name,
        cast(teratype_name as varchar) as teratype_name,
        cast(usage_raw as float) as usage_raw,
        cast(date as varchar) as date_id,
        cast(regulation as varchar) as regulation_id,
        cast(ingested_at as timestamp) as ingested_at

    from deduplicated
)

select * from renamed