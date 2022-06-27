{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id,
  u.email,
  u.first_name,
  u.last_name,
  u.created_at,
  e.event_id,
  e.event_type,
  e.product_id,
  p.name as product_name 
FROM {{ ref('stg_greenery_users') }} u
LEFT JOIN {{ ref('stg_greenery_events') }} e
  ON u.user_id = e.user_id
LEFT JOIN {{ ref('stg_greenery_products') }} p
    on e.product_id = p.product_id
