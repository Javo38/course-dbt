
/* 
What is our user repeat rate?

Repeat Rate = Users who purchased 2 or more times / users who purchased
*/

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