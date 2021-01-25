use sakila;

-- In this lab, you will be using the Sakila database of movie rentals.

-- 1. List number of films per category.

select c.name, count(f.film_id) as FilmsPerCat
from category as c
join film_category as f
on c.category_id=f.category_id
group by c.name
order by FilmsPerCat desc;


-- 2. Display the first and last names, as well as the address, of each staff member.

select c.first_name, c.last_name, f.address
from staff as c
join address as f
on c.address_id=f.address_id;


-- 3. Display the total amount rung up by each staff member in August of 2005.

select c.staff_id, c.first_name, c.last_name, sum(f.amount)
from staff as c
join payment as f
on c.staff_id=f.staff_id
where date_format(convert(f.payment_date,date),"%Y-%M") = "2005-August"
group by staff_id;


-- 4. List each film and the number of actors who are listed for that film.

select f.title, count(a.actor_id) as NrOfActor
from film as f
join film_actor as a
on f.film_id=a.film_id
group by f.title;


-- 5. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

select c.customer_id,  c.last_name, sum(p.amount) as Sum_customer
from customer as c
join payment as p
on c.customer_id=p.payment_id
group by customer_id
order by c.last_name;
