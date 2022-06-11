{{
    config(
        materialized = 'view'
    ) 
 }}


select 
    promo_id
    ,discount
    ,status
from {{ source('src_greenery', 'promos') }}



