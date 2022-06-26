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
  u.created_at as user_created_at,
  o.created_at as order_created_at,
  o.order_total,
  o.order_id
FROM {{ ref('stg_greenery_users') }} u
LEFT JOIN {{ ref('stg_greenery_orders') }} o
  ON u.user_id = o.user_id


