with customers as (

    select * from {{ ref('stg_customers') }}

),
rentals as (

    select * from {{ ref('stg_rentals') }}

), payments as(
    select * from {{ ref('stg_payments') }}

), rental_summary as (
    select
        customer_id,
        count(rental_id) AS total_rentals,
        min(rented_at) AS first_rented_at,
        max(rented_at) AS last_rented_at
    from rentals
    group by customer_id
), payment_summary as (
    select 
        customer_id,
        sum(amount) AS lifetime_payment_total
    from payments
    group by customer_id
) 
select
        c.customer_id,
        {{ full_name('c.first_name', 'c.last_name') }} AS customer_name,
        coalesce(r.total_rentals, 0) as total_rentals,
        r.first_rented_at,
        r.last_rented_at,
        coalesce(p.lifetime_payment_total, 0) as lifetime_payment_total
    from customers c
    left join rental_summary r 
        on c.customer_id = r.customer_id    
    left join payment_summary p 
        on c.customer_id = p.customer_id

