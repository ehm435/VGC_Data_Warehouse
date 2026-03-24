with viable_pokemon as (
    select pokemon_name, date_id, regulation_id
    from {{ ref('fct_usage') }}
    where usage_percent >= 2.0
),

bidirectional_edges as (
    -- Creating bidirectional graph
    select 
        s1.date_id,
        s1.regulation_id,
        -- Alphabetic order
        least(s1.pokemon_a, s1.pokemon_b) as node_1,
        greatest(s1.pokemon_a, s1.pokemon_b) as node_2,
        avg(s1.synergy_percent) as edge_weight
        
    from {{ ref('fct_synergy') }} s1
    inner join viable_pokemon vp1 on s1.pokemon_a = vp1.pokemon_name
    inner join viable_pokemon vp2 on s1.pokemon_b = vp2.pokemon_name
    where s1.pokemon_a != s1.pokemon_b
    group by 1, 2, 3, 4
),

triangle_cores as (
    select
        e1.date_id,
        e1.regulation_id,
        e1.node_1 as slot_1,
        e1.node_2 as slot_2,
        e2.node_2 as slot_3,
        
        (e1.edge_weight + e2.edge_weight + e3.edge_weight) as total_core_synergy
        
    from bidirectional_edges e1

    -- B -> C
    inner join bidirectional_edges e2 
        on e1.date_id = e2.date_id 
        and e1.node_2 = e2.node_1 
    -- A -> C
    inner join bidirectional_edges e3 
        on e1.date_id = e3.date_id 
        and e1.node_1 = e3.node_1 
        and e2.node_2 = e3.node_2
)

select
    date_id,
    regulation_id,
    slot_1 || ' + ' || slot_2 || ' + ' || slot_3 as core_team,
    cast(total_core_synergy as decimal(10,2)) as synergy_score
from triangle_cores
order by date_id desc, synergy_score desc