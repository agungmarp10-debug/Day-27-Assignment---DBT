with source as (

    select * from {{ source('pagila', 'customer') }}

)

select
    customer_id,
    first_name,
    last_name,
    email,
    address_id,
    store_id,
    activebool as is_active,
    CAST(create_date as TIMESTAMP) as created_at,
    CAST(last_update as TIMESTAMP)
from source