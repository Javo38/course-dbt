{{
    config(
        materialized = 'view'
    ) 
 }}


select 
    order_id
    ,product_id
    ,quantity
from {{ source('src_greenery', 'order_items') }}

