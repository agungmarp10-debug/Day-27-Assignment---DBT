with source as (

    select * from {{ source('pagila', 'film') }}

)

select
    film_id,
    title,
    description,
    rental_rate,
    replacement_cost,
    length as length_minutes,
    rating::text as rating,   -- Pagila stores this as an enum; cast to text
    CAST(last_update as TIMESTAMP) as updated_at
from source