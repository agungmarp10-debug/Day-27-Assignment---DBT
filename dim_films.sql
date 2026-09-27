with films as (
    select * from {{ ref('stg_films') }}
), inventory as (
    select * from {{ ref('stg_inventory') }}
), rentals as (
    select * from {{ ref('stg_rentals') }}
), film_categories as (
    select * from {{ source('pagila', 'film_category') }}
), categories as (
    select * from {{ source('pagila', 'category') }}
), rating_descriptions as (
    select * from {{ ref('rating_descriptions') }}
), category_summary as (

    select
        fc.film_id,
        string_agg(c.name, ', ') as category
    from film_categories fc
    join categories c
        on fc.category_id = c.category_id
    group by fc.film_id

), inventory_summary as (
    select
        film_id,
        count(inventory_id) as inventory_count
    from inventory
    group by film_id
), rental_summary as (
    select
        i.film_id,
        count(rental_id) as times_rented
    from rentals r
    join inventory i
        on r.inventory_id = i.inventory_id
    group by i.film_id
) 
select
    f.film_id,
    f.title,
    cs.category,
    f.rating,
    rd.description as rating_description,
    f.rental_rate,
    coalesce(i.inventory_count, 0) as inventory_count,
    coalesce(rs.times_rented, 0) as times_rented,
    coalesce(i.inventory_count, 0) > 0 as is_available
from films f
LEFT JOIN category_summary cs
    on f.film_id = cs.film_id
LEFT JOIN rating_descriptions rd
    on f.rating = rd.rating
LEFT JOIN inventory_summary i
    on f.film_id = i.film_id
LEFT JOIN rental_summary rs 
    on f.film_id = rs.film_id
