with films as (

    select * from {{ ref('dim_films') }}

),

revenue_summary as (

    select
        film_id,
        sum(amount) as total_revenue
    from {{ ref('fact_payments') }}
    group by film_id

)

select
    f.film_id,
    f.title,
    f.category,
    f.rental_rate,
    f.inventory_count,
    coalesce(f.times_rented, 0) as times_rented,
    coalesce(r.total_revenue, 0) as total_revenue
from films f
left join revenue_summary r
    on f.film_id = r.film_id