/*
Lab | SQL Subqueries
In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

Instructions
1. How many copies of the film Hunchback Impossible exist in the inventory system?
2. List all films whose length is longer than the average of all the films.
3. Use subqueries to display all actors who appear in the film Alone Trip.
4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
8. Customers who spent more than the average payments.
*/
use sakila;
-- 1 -- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(film_id) as n_copies FROM inventory where film_id = (SELECT film_id FROM film where title = 'Hunchback Impossible');

-- 2 -- List all films whose length is longer than the average of all the films.
SELECT * from film where length > (select avg(length) from film);

-- 3 -- Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor;
select actor_id, first_name, last_name from film_actor fa join actor a using (actor_id) where film_id = (SELECT film_id FROM film where title = 'Alone Trip');

-- 4 -- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film_category fc join film f using(film_id) where category_id = (select category_id from category where name = 'Family');

-- 5 -- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select first_name, last_name, email  from customer where address_id in (select address_id from address where city_id in (select city_id from city where country_id in (select country_id from country where country = 'Canada')));

select first_name, last_name, email 
from customer cu join address a using(address_id) join city ci using(city_id) join country co using(country_id) 
where country = 'Canada';

-- 6 -- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from actor;
select actor_id, count(actor_id) as films_appeared from film_actor group by actor_id order by films_appeared desc limit 1;
select * from actor where actor_id = (select actor_id from film_actor group by actor_id order by count(actor_id) desc limit 1);
select title from film_actor fa join film f using(film_id) where actor_id = (select actor_id from film_actor group by actor_id order by count(actor_id) desc limit 1);

-- 7 -- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT customer_id from payment group by customer_id order by sum(amount) desc limit 1;
select * from payment;
select inventory_id from rental where customer_id = (SELECT customer_id from payment group by customer_id order by sum(amount) desc limit 1);

SELECT title from inventory i join film using(film_id) where inventory_id in (select inventory_id from rental where customer_id = (SELECT customer_id from payment group by customer_id order by sum(amount) desc limit 1));

-- 8 -- Customers who spent more than the average payments.
select * from customer;
select * from payment;
select customer_id, sum(amount) as total from payment group by customer_id;
select avg(summed) from (select sum(amount) as summed from payment group by customer_id) sub1;
select customer_id from (select customer_id, sum(amount) as total from payment group by customer_id) sub1 where total > (select avg(summed) from (select sum(amount) as summed from payment group by customer_id) sub2);
select * from customer where customer_id in (select customer_id from (select customer_id, sum(amount) as total from payment group by customer_id) sub1 where total > (select avg(summed) from (select sum(amount) as summed from payment group by customer_id) sub2));
