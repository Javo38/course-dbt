{{
  config(
    materialized='table'
  )
}}

select
  oi.order_id,
  oi.product_id,
  e.session_id,
  p.name as product_name
from {{ ref('stg_greenery_order_items') }} oi
inner join (
  select distinct session_id, order_id from 
  {{ ref('stg_greenery_events') }}
  ) e
on oi.order_id = e.order_id
left join {{ ref('stg_greenery_products') }} p
on oi.product_id = p.product_id
order by oi.order_id

