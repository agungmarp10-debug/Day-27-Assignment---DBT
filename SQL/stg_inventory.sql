with source as (

    select * from {{ source('pagila', 'inventory') }}

)

select
    film_id,
    inventory_id,
    store_id
from source