{{
    config(
        materialized = 'view'
    ) 
 }}


select 
    product_id
    ,name
    ,price
    ,inventory
from {{ source('src_greenery', 'products') }}

<<<<<<< HEAD
=======



>>>>>>> e711ee9bafeeb013b984f696507346d145bd4bbb
