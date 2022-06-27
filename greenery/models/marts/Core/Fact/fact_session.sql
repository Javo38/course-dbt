{{
  config(
    materialized='table'
  )
}}

{% set event_types = ["add_to_cart", "checkout", "page_view", "package_shipped"] %}

select
    e.event_id,
    e.session_id,
    e.user_id,
    e.created_at,
    e.order_id,
    e.product_id,
    {% for event_type in event_types %}
        (case when e.event_type = '{{event_type}}' then 1 else 0 end) type_{{event_type}}
    {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_greenery_events') }} e


