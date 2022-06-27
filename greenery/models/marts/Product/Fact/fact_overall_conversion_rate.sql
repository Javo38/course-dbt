{{
  config(
    materialized='table'
  )
}}

select
    sum(type_checkout)::float / count(distinct session_id) as overall_coversion_rate
from {{ ref('fact_session') }}


