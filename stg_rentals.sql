with source as (

    select * from {{ source('pagila', 'rental') }}

)

select
    rental_id,
    CAST(rental_date as TIMESTAMP) as rented_at,
    CAST(return_date as TIMESTAMP) as returned_at,
    inventory_id,
    customer_id,
    staff_id
from source