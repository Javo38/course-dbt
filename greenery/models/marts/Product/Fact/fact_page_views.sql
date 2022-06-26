{{
  config(
    materialized='table'
  )
}}

SELECT
    e.event_id
    ,e.session_id
    ,e.user_id
    ,e.event_type
    ,e.page_url
    ,e.created_at as event_created_at
    ,e.order_id
    ,e.product_id
    ,u.first_name
    ,u.last_name 
FROM {{ ref('stg_greenery_events') }} e
LEFT JOIN {{ ref('stg_greenery_users') }} u
  ON e.user_id = u.user_id

