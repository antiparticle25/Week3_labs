use sakila;

# store, city country
-- 1. Write a query to display for each store its store ID, city, and country.

select s.store_id, ci.city, co.country
from store as s
join address as a
on s.address_id = a.address_id
join city as ci
on a.city_id=ci.city_id
join country as co
on co.country_id = ci.country_id;


-- 2. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount) as Money_per_store
from store as s
join customer as c
on s.store_id = c.store_id
join payment as p
on c.customer_id=p.customer_id
group by s.store_id;


-- 3. What is the average running time of films by category?

select c.name, avg(f.length) as avg_film_length
from category as c
join film_category as fc
on c.category_id = fc.category_id
join film as f
on fc.film_id=f.film_id
group by c.name;

-- 4. Which film categories are longest?

select c.name, avg(f.length) as avg_film_length
from category as c
join film_category as fc
on c.category_id = fc.category_id
join film as f
on fc.film_id=f.film_id
group by c.name
order by avg_film_length desc
limit 5;


-- 5. Display the most frequently rented movies in descending order.

select f.title, count(r.rental_id) as rentals
from rental as r
join inventory as i
on r.inventory_id=i.inventory_id
join film as f
on f.film_id=i.film_id
group by f.title
order by rentals desc
limit 10;

-- -- 6. List the top five genres in gross revenue in descending order.

#payment, 

select c.name, sum(p.amount) as rev
from payment as p
join rental as r
on p.rental_id=r.rental_id
join inventory as i
on i.inventory_id = r.inventory_id
join film as f
on f.film_id = i.film_id
join film_category as fc
on f.film_id=fc.film_id
join category as c
on c.category_id = fc.category_id
group by c.name
order by rev desc
limit 5;

-- 7. Is "Academy Dinosaur" available for rent from Store 1?
#film, store, 

select f.title, s.store_id
from store as s
join inventory as i
on s.store_id = i.store_id
join film as f
on f.film_id = i.film_id
where f.title = "Academy Dinosaur" and s.store_id = "1";