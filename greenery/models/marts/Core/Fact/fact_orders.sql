
{{
  config(
    materialized='table'
  )
}}

SELECT
  o.order_id,
  o.created_at,
  o.order_total,
  o.status,
  o.promo_id,
  pc.promo_id AS promo_code_name,
  pc.discount AS promo_code_discount,
  o.user_id,
  u.first_name AS user_first_name,
  o.tracking_id
FROM {{ ref('stg_greenery_orders') }} o
LEFT JOIN {{ ref('stg_greenery_promos') }} pc
  ON o.promo_id = pc.promo_id
LEFT JOIN {{ ref('stg_greenery_users') }} u
  ON o.user_id = u.user_id

