

## Part I

/* 
What is our user repeat rate?
Repeat Rate = Users who purchased 2 or more times / users who purchased
*/

I define de int_user_repeat_rate.sql:
```

{{
    config(
        materialized = 'table'
    ) 
 }}

with usuarios_n_ordenes_distintas as ( 
    select 
        user_id
        ,count(distinct order_id) as ordenes_distintas 
    from {{ ref('stg_greenery_orders') }}
    group by user_id
),
usuarios_clasifica as (
    select user_id
        ,case when ordenes_distintas >= 2 then 1 else 0 end as dos_o_mas_compras
    from usuarios_n_ordenes_distintas
)

select 
    sum(dos_o_mas_compras) as dos_o_mas_compras
    ,count(distinct user_id) as usuarios_distintos
    ,sum(dos_o_mas_compras)::float / count(distinct user_id) as user_repeat_rate 

from usuarios_clasifica
```

Then in the browser I run
```
select * from dbt.dbt_javier_r.int_user_repeat_rate;
```

Result
```
dos_o_mas_compras    usuarios_distintos    user_repeat_rate
99                   124                   0.7983870967741935
```


/* 
What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question.
 */

```
I believe products and promos would be a good indicators of a user who will purchase again. Undestanding why they purchased twice or more, is important to create a strategy.

In the other hand, those who purchased once and never purchase again, maybe we need extra data like client satisfaction of something like that.


```

/* Explain the marts models you added. Why did you organize the models in the way you did? */

fact_orders.sql

```
I'd like to track the realtion beteween users, promos and orders, and to see if there is any high correlation
```

dim_products
```
Just to have in one table all products universe and how many orders at the same time
```


dim_users
```
I'd like to see in one table users, events and product, and to see the impact that one event has on users and their decision to order
```


user_order_facts
```
Just to se which users are the most valuable based on their order history
```


fact_page_views
```
Just to have in one view wich event has more impact on users
```



/* Use the dbt docs to visualize your model DAGs to ensure the model layers make sense */

After I ran the commands I got:

![alt text](/greenery/img/Graph1.png)




## Part II


I added a not_null test on my dim_users model
```
version: 2

models:
  - name: dim_users
    columns:
      - name: user_id
        tests:
          - not_null


```

and it passed successfully.



/* Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
 */


The way that I ensure everyday data is by using freshness test on my src_greenery.yml

```

    freshness: 
      warn_after: {count: 24, period: hour}
      error_after: {count: 48, period: hour}
```

