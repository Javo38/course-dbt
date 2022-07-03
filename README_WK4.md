

## Part I

dbt snapshot


orders_snapshots.sql
```
{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols='status'
    )
  }}

  SELECT * FROM {{ source('src_greenery', 'orders') }}

{% endsnapshot %}
```

## Part II

add to cart rate
```
select q1.count_add_cart_event::float / q2.count_type_page_view as add_to_cart_vs_page_view_rate
from ( 
  select count( distinct session_id) count_add_cart_event
  from dbt.dbt_javier_r.fact_session
  where type_add_to_cart = 1
) q1,
( 
  select count( distinct session_id) count_type_page_view
  from dbt.dbt_javier_r.fact_session
  where type_page_view = 1
) q2

;


```

Results
```
0.8079584775086506
```


checkout rate

```
select q1.count_type_checkout::float / q2.count_add_cart_event as checkout_vs_add_to_cart_ratio
from ( 
  select count( distinct session_id) count_type_checkout
  from dbt.dbt_javier_r.fact_session
  where type_checkout = 1
) q1,
( 

  select count( distinct session_id) count_add_cart_event
  from dbt.dbt_javier_r.fact_session
  where type_add_to_cart = 1
) q2

;

```

Result
```
0.7730192719486081
```

So, the biggest drop begins when deciding if checkout or not. That make sense.


 Exposure on your product analytics model 
```
version: 2

exposures:  
  - name: Product Funnel Dashboard
    description: >
      Models that are critical to our product funnel dashboard
    type: dashboard
    maturity: high
    owner:
      name: Javier R
      email: javier.rojas@kueski.com
    depends_on:
      - ref('fact_session')
```
