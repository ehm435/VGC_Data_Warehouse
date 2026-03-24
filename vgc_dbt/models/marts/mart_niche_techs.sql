with meta_pokemon as (
    select 
        meta_id, 
        pokemon_name, 
        date_id, 
        regulation_id, 
        usage_percent as global_usage
    from {{ ref('fct_usage') }}
    where usage_percent >= 5.0
),

niche_items as (
    select 
        meta_id, 
        'Item' as tech_category,
        item_name as tech_name,
        usage_percent as tech_usage
    from {{ ref('bridge_pokemon_items') }}
    where usage_percent between 2.0 and 15.0
),

niche_moves as (
    select 
        meta_id, 
        'Move' as tech_category,
        move_name as tech_name,
        usage_percent as tech_usage
    from {{ ref('bridge_pokemon_moves') }}
    where usage_percent between 2.0 and 15.0
),

niche_teratypes as (
    select 
        meta_id, 
        'Tera Type' as tech_category,
        teratype_name as tech_name,
        usage_percent as tech_usage
    from {{ ref('bridge_pokemon_teratypes') }}
    where usage_percent between 2.0 and 15.0
),

all_niche_techs as (
    select * from niche_items
    union all
    select * from niche_moves
    union all
    select * from niche_teratypes
)

select 
    p.date_id,
    p.regulation_id,
    p.pokemon_name,
    cast(p.global_usage as decimal(10,2)) as pokemon_global_usage_percent,
    
    t.tech_category,
    t.tech_name,
    cast(t.tech_usage as decimal(10,2)) as tech_usage_percent

from meta_pokemon p
inner join all_niche_techs t on p.meta_id = t.meta_id

order by p.date_id desc, p.global_usage desc, t.tech_category, t.tech_usage desc