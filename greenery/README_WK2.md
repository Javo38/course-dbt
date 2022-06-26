

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

