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

<<<<<<< HEAD
=======


>>>>>>> e711ee9bafeeb013b984f696507346d145bd4bbb
