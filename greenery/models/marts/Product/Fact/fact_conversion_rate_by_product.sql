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

