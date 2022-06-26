{{
    config(
        materialized = 'view'
    ) 
 }}


select 
    event_id
    ,session_id
    ,user_id
    ,event_type
    ,page_url
    ,created_at
    ,order_id
    ,product_id
<<<<<<< HEAD
from {{ source('src_greenery', 'events') }}

=======
from {{ source('src_greenery', 'events') }}
>>>>>>> e711ee9bafeeb013b984f696507346d145bd4bbb
