use sakila;

-- Lab | SQL Self and cross join
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions

-- 1. Get all pairs of actors that worked together.

select a.actor_id as ActorID, b.actor_id as PartnerID, a.film_id as Film
from sakila.film_actor as a
join sakila.film_actor as b
on a.actor_id <> b.actor_id
and a.film_id = b.film_id
order by ActorID;

-- 2. Get all pairs of customers that have rented the same film more than 3 times.

select count(a.film_id) as Same_film_pair, a.film_id, b.customer_id, c. customer_id
from sakila.inventory as a
join sakila.rental as b
using(inventory_id)
join sakila.rental as c
on b.inventory_id = c.inventory_id
and b.customer_id <> c.customer_id
group by  b.customer_id, c. customer_id
order by Same_film_pair desc;

-- having count(a.film_id) > 3;
select a.film_id, b.customer_id, c.customer_id, count(film_id) over (partition by b.customer_id, c.customer_id) as c
from sakila.inventory as a
join sakila.rental as b
using(inventory_id)
join sakila.rental as c
on b.inventory_id = c.inventory_id
and b.customer_id <> c.customer_id
order by c desc;

-- 3. Get all possible pairs of actors and films.

select * from (select distinct actor_id from actor) as sub1
cross join (select distinct title from film) as sub2
order by actor_id;



# Anna's and Caro's solution - question 2

select count(f1.title) as n_movies,
	c1.customer_id as customer_1, c1.first_name, c1.last_name,
	c2.customer_id as customer_2, c2.first_name, c2.last_name
from sakila.customer as c1
	join sakila.rental as r1 on c1.customer_id = r1.customer_id
	join sakila.inventory as i1 on r1.inventory_id=i1.inventory_id
	join sakila.film as f1 on i1.film_id=f1.film_id
    #going the path backwards to find customer with the same rented movies
    join sakila.inventory as i2 on i2.film_id=f1.film_id
    join sakila.rental as r2 on i2.inventory_id =r2.inventory_id
    join sakila.customer as c2 on r2.customer_id=c2.customer_id
#using greater than to drop duplicates
where c1.customer_id>c2.customer_id
group by c1.customer_id, c1.first_name, c1.last_name, c2.customer_id, c2.first_name, c2.last_name
Having n_movies>3
order by n_movies desc;
