with date_spine as (
    -- La macro genera una fila por cada mes ininterrumpidamente
    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('2014-01-01' as date)",
        end_date="cast('2030-12-31' as date)"
    ) }}
),

enriched_calendar as (
    select
        strftime(date_month, '%Y-%m') as date_id,
        
        cast(extract(year from date_month) as int) as year,
        cast(extract(month from date_month) as int) as month,
        cast(extract(quarter from date_month) as int) as quarter,
        
        case extract(month from date_month)
            when 1 then 'Enero'   when 2 then 'Febrero' when 3 then 'Marzo'
            when 4 then 'Abril'   when 5 then 'Mayo'    when 6 then 'Junio'
            when 7 then 'Julio'   when 8 then 'Agosto'  when 9 then 'Septiembre'
            when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
        end as month_name

    from date_spine
)

select * from enriched_calendar