with base_fct as (
    select 
        meta_id, 
        pokemon_name, 
        date_id, 
        regulation_id, 
        usage_percent as global_usage
    from {{ ref('fct_usage') }}

    where usage_percent >= 0.5
),

top_item as (
    select meta_id, item_name
    from {{ ref('bridge_pokemon_items') }}
    qualify row_number() over (partition by meta_id order by usage_percent desc) = 1
),

top_ability as (
    select meta_id, ability_name
    from {{ ref('bridge_pokemon_abilities') }}
    qualify row_number() over (partition by meta_id order by usage_percent desc) = 1
),

top_teratype as (
    select meta_id, teratype_name
    from {{ ref('bridge_pokemon_teratypes') }}
    qualify row_number() over (partition by meta_id order by usage_percent desc) = 1
),

top_spread as (
    select meta_id, nature, ev_hp, ev_atk, ev_def, ev_spa, ev_spd, ev_spe
    from {{ ref('bridge_pokemon_spreads') }}
    qualify row_number() over (partition by meta_id order by usage_percent desc) = 1
),

ranked_moves as (
    select 
        meta_id, 
        move_name,
        row_number() over (partition by meta_id order by usage_percent desc) as rn
    from {{ ref('bridge_pokemon_moves') }}
),

top_4_moves as (
    select 
        meta_id, 
        string_agg(move_name, ', ' order by rn) as optimal_moves
    from ranked_moves
    where rn <= 4
    group by meta_id
)

select
    f.date_id,
    f.regulation_id,
    f.pokemon_name,
    cast(f.global_usage as decimal(10, 2)) as global_usage_percent,
    
    i.item_name as optimal_item,
    a.ability_name as optimal_ability,
    t.teratype_name as optimal_teratype,
    m.optimal_moves,
    
    s.nature as optimal_nature,
    s.ev_hp, 
    s.ev_atk, 
    s.ev_def, 
    s.ev_spa, 
    s.ev_spd, 
    s.ev_spe

from base_fct f
left join top_item i on f.meta_id = i.meta_id
left join top_ability a on f.meta_id = a.meta_id
left join top_teratype t on f.meta_id = t.meta_id
left join top_spread s on f.meta_id = s.meta_id
left join top_4_moves m on f.meta_id = m.meta_id
order by f.date_id desc, f.global_usage desc