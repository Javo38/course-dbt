{{
  config(
    materialized='table'
  )
}}

SELECT
  p.product_id
  ,p.name
  ,p.price
  ,oi.quantity as number_of_orders
 
FROM {{ ref('stg_greenery_products') }} p
LEFT JOIN {{ ref('stg_greenery_order_items') }} oi
  ON p.product_id = oi.product_id
  