

/* how many users do we have */

```
select count(distinct user_id) 
from dbt.dbt_javier_r.stg_greenery_users;
```
```
count
130
```

/* On average, how many orders do we receive per hour? */


select avg(q.conteo) as prom_ordenes_por_hora
from 
  ( 
  select 
    extract(day from created_at) || '-' || extract(hour from created_at) as dia_hora
    ,count(*) as conteo
  from dbt.dbt_javier_r.stg_greenery_orders
  group by 1
  ) as q
;


prom_ordenes_por_hora
7.5208333333333333



/* On average, how long does an order take from being placed to being delivered? */


select avg(q.dias_transcurridos)
from ( 
select 
  created_at
  ,delivered_at
  ,delivered_at - created_at as dias_transcurridos
from dbt.dbt_javier_r.stg_greenery_orders
where delivered_at is not null
) q;



avg
3 days 21:24:11.803279



/* How many users have only made one purchase? Two purchases? Three+ purchases?
Note: you should consider a purchase to be a single order. In other words, 
if a user places one order for 3 products, they are considered to have made 1 purchase. */



select q2.conteo_final, count(*) as conteo
from
( 
  select 
    case when q.ordenes < 3 then q.ordenes 
    else 3 
    end as conteo_final
  from ( 
    select 
      user_id
      ,count(distinct order_id) as ordenes
    from dbt.dbt_javier_r.stg_greenery_orders
    group by user_id
  ) as q
) as q2
group by q2.conteo_final
order by q2.conteo_final
;

conteo_final     conteo
1                25
2                28
3               71



/* On average, how many unique sessions do we have per hour? */

select avg(q2.num_sesiones_unicas) as prom_ses_unicas
from ( 
  select q.dia_hora, count(distinct session_id) as num_sesiones_unicas
  from ( 
    select 
      session_id
      ,extract(day from created_at) || '-' || extract(hour from created_at) as dia_hora
    from dbt.dbt_javier_r.stg_greenery_events
    ) as q
  group by q.dia_hora
) as q2
;


prom_ses_unicas
16.3275862068965517
