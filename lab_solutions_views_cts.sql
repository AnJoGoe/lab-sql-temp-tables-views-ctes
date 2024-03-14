-- ==========================================================
-- Challenge - Creating a Customer Summary Report
-- ==========================================================

USE sakila;



-- Display all available tables 
SHOW TABLES;


-- ==========================================================
-- ==========================================================


-- Step 1: Create a View
	-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

select *
from customer c;

create view customer_rental_summary AS
select 
	c.customer_id,
		concat(c.first_name, ' ', c.last_name) AS customer_name,
        c.email AS email_adress,
        count(r.rental_id) AS rental_count
from customer c
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
group by c.customer_id;

select * from customer_rental_summary;


-- ==========================================================
-- ==========================================================


-- Step 2: Create a Temporary Table
	-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

select * from payment p;

create temporary table if not exists customer_total_paid_temp as
select
	crs.customer_id,
    sum(p.amount) as total_paid
from customer_rental_summary crs
join payment p 
	on crs.customer_id = p.customer_id
group by crs.customer_id;

select * from customer_total_paid_temp;


-- ==========================================================
-- ==========================================================


-- Step 3: Create a CTE and the Customer Summary Report
	-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

	-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

-- --> join customer_rental_summary and customer_total_paid_temp
-- required
	-- customer name
	-- email
	-- rental count
	-- total amount paid

-- use cte
	-- customer name
	-- email
	-- rental_count
	-- total_paid
    -- average_oayment_per_rental --> from: total_paid and rental_count

with customer_summary as (
select
	crs.customer_name,
    crs.email_adress,
    crs.rental_count,
    ctp.total_paid,
    (ctp.total_paid / crs.rental_count) as average_payment_per_rental
from customer_rental_summary crs
join customer_total_paid_temp ctp
on crs.customer_id = ctp.customer_id
)
select
	customer_name,
    email_adress,
    rental_count,
    total_paid,
    average_payment_per_rental
from
	customer_summary;


