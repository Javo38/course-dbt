

## Part I

/* 
1. What is our overall conversion rate?

2. What is our conversion rate by product?

NOTE: conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product

*/

I defined the model fact_session.sql:
```
{{
  config(
    materialized='table'
  )
}}

{% set event_types = ["add_to_cart", "checkout", "page_view", "package_shipped"] %}

select
    e.event_id,
    e.session_id,
    e.user_id,
    e.created_at,
    e.order_id,
    e.product_id,
    {% for event_type in event_types %}
        (case when e.event_type = '{{event_type}}' then 1 else 0 end) type_{{event_type}}
    {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_greenery_events') }} e
```

Then a 2nd model called fact_overall_conversion_rate.sql
```
{{
  config(
    materialized='table'
  )
}}

select
    sum(type_checkout)::float / count(distinct session_id) as overall_coversion_rate
from {{ ref('fact_session') }}

```

Result
```
0.6245674740484429
```


For the conversion rate by product:

```
{{
  config(
    materialized='table'
  )
}}

with junta_vistas_y_compras as ( 
    select 
        v.product_id,
        v.total_views,
        p.total_purchases,
        p.product_name
    from {{ ref('fact_views_per_product_id') }} v
    left join {{ ref('fact_purchases_per_product_id') }} p
    on v.product_id = p.product_id
),
acomoda as (
  select 
    product_name,
    total_purchases,
    total_views
  from junta_vistas_y_compras
)

select 
    product_name,
    total_purchases::float / total_views as conv_rate_by_product
from acomoda
order by 2 desc
```


Which gives the result:

|product_name|conv_rate_by_product|
|---|---|
|String of pearls|0.6|
|Arrow Head|0.546875|
|Cactus|0.545454545454545|
|ZZ Plant|0.523076923076923|
|Bamboo|0.521739130434782|
|Monstera|0.510204081632653|
|Calathea Makoyana|0.50943396226415|
|Rubber Plant|0.5|
|Aloe Vera|0.492307692307692|
|Devil's Ivy|0.488888888888888|
|Majesty Palm|0.478260869565217|
|Jade Plant|0.478260869565217|
|Philodendron|0.476190476190476|
|Spider Plant|0.47457627118644|
|Fiddle Leaf Fig|0.47457627118644|
|Dragon Tree|0.46774193548387|
|Pilea Peperomioides|0.466666666666666|
|Money Tree|0.464285714285714|
|Orchid|0.453333333333333|
|Bird of Paradise|0.45|
|Ficus|0.426470588235294|
|Pink Anthurium|0.418918918918918|
|Boston Fern|0.412698412698412|
|Birds Nest Fern|0.4125|
|Peace Lily|0.402985074626865|
|Snake Plant|0.397260273972602|
|Ponytail Palm|0.394366197183098|
|Alocasia Polly|0.388888888888888|
|Angel Wings Begonia|0.387096774193548|
|Pothos|0.328125|


## Part II

my macro (I'm really sure if it's ok)

```
{% macro agg_event_type(event_type) %}
    
    {% set event_types = ["add_to_cart", "checkout", "page_view", "package_shipped"] %}

    {% for event_type in event_types %}
        (case when e.event_type = '{{event_type}}' then 1 else 0 end) type_{{event_type}}
    {% if not loop.last %},{% endif %}
    {% endfor %}

{% endmacro %}
```


## Part III

this is how I added:
```
models:
  greenery:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
  
  post-hook:
    - "grant select on {{this}} to reporting"

on-run-end:
  - "grant usage on schema {{schema}} to reporting"
```


## Part IV

I added dbt-utils for my macro fact_session, but at the end I couldn't use it. some errors showed. 

Other packages I added: codegen, dbt_date, dbt_expectations


## Part V

