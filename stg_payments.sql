with source as (

    select * from {{ source('pagila', 'payment') }}

)

select
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    CAST(payment_date as TIMESTAMP) as paid_at
from source