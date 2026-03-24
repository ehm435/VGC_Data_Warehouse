{% macro is_valid_string(column_name) %}
    
    {{ column_name }} is not null 
    and trim(cast({{ column_name }} as varchar)) != '' 
    and lower(cast({{ column_name }} as varchar)) != 'nan'

{% endmacro %}