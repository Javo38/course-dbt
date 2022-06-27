{{
  config(
    materialized='table'
  )
}}

select
    sp.product_id,
    sp.product_name,
    count(*) as total_purchases
from {{ ref('int_session_products') }} sp
group by sp.product_id, sp.product_name









