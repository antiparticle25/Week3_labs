-- Lab | SQL Rolling calculations
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions
-- 1. Get number of monthly active customers.
-- 2. Active users in the previous month.
-- 3. Percentage change in the number of active customers.
-- 4. Retained customers every month.

USE sakila;

SELECT * FROM sakila.customer AS c
JOIN sakila.rental AS r
on r.customer_id = c.customer_id
WHERE c.active = 0;


#1 Get number of monthly active customers.

-- Step 1: Get the account_id, date, year, month and month_number for
-- every transaction.

use sakila;
drop view if exists sakila_activity; 
create or replace view sakila_activity as
select customer_id, convert(rental_date, date) as Activity_date,
date_format(convert(rental_date,date), '%M') as Activity_Month,
date_format(convert(rental_date,date), '%m') as Activity_Month_number,
date_format(convert(rental_date,date), '%Y') as Activity_year
from sakila.rental;

-- Checking results
select * from sakila.sakila_activity;


-- Step 2:
-- Computing the total number of active users by Year and Month with group by
-- and sorting according to year and month NUMBER.
select Activity_year, Activity_Month, count(customer_id) as Active_users from sakila.sakila_activity
group by Activity_year, Activity_Month
order by Activity_year asc, Activity_Month_number asc;

-- Step 3:
-- Storing the results on a view for later use.
drop view sakila.monthly_sakila_activity; 
create view sakila.monthly_sakila_activity as
select Activity_year, Activity_Month, Activity_Month_number, count(customer_id) as Active_users 
from sakila.sakila_activity
group by Activity_year, Activity_Month
order by Activity_year asc, Activity_Month_number asc;

-- Sanity check
select * from sakila.monthly_sakila_activity;



#2 Active users in the previous month.


/*
-- Final step:
Compute the difference of `active_users` between one month and the previous one
for each year
using the lag function with lag = 1 (as we want the lag from one previous record)
*/

select 
   Activity_year, 
   Activity_month,
   Active_users, 
   lag(Active_users,1) over (order by Activity_year, Activity_Month_number) as Last_month
from sakila.monthly_sakila_activity;

-- Refining: Getting the difference of monthly active_users month to month.
with cte_sakilaview as (select 
   Activity_year, 
   Activity_month,
   Active_users, 
   lag(Active_users,1) over (order by Activity_year, Activity_Month_number) as Last_month
from sakila.monthly_sakila_activity)
select Activity_year, Activity_month, Active_users, Last_month, (Active_users - Last_month) as Difference from cte_sakilaview;


# 3.Percentage change in the number of active customers

with cte_sakilaview as (select 
   Activity_year, 
   Activity_month,
   Active_users, 
   lag(Active_users,1) over (order by Activity_year, Activity_Month_number) as Last_month
from sakila.monthly_sakila_activity)
select Activity_year, Activity_month, Active_users, Last_month, (Active_users - Last_month) as Difference, round((Active_users - Last_month)/Active_users*100,2) as DifferencePerc from cte_sakilaview;




