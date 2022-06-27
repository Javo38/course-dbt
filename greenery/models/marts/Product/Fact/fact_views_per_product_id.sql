{{
  config(
    materialized='table'
  )
}}

select
    s.product_id,
    sum(s.type_page_view) as total_views
from {{ ref('fact_session') }} s
where s.product_id is not null 
group by s.product_id









