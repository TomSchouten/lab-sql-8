USE bank;

--     Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM   sakila.address a
JOIN   sakila.store s USING(address_id)
JOIN   sakila.city c USING(city_id)
JOIN   sakila.country co USING(country_id);

--     Write a query to display how much business, in dollars, each store brought in.
SELECT   s.store_id, CONCAT('$',SUM(pay.amount)) AS 'total_revenue'
FROM     sakila.address a
JOIN     sakila.store s USING(address_id)
JOIN     sakila.customer c USING(store_id)
JOIN     sakila.payment pay USING(customer_id)
GROUP BY store_id;

--     Which film categories are longest?
--     Here i look at the avarage minutes per catagory. But we can also look at the maximum duration of a movie in a perticular catagory. 
SELECT   c.name, ROUND(AVG(fi.length),2) AS 'avarage_length'
FROM     sakila.film_category f
JOIN     sakila.category c USING(category_id)
JOIN     sakila.film fi USING(film_id)
GROUP BY c.name
ORDER BY fi.length DESC;

--     Here i look at the longest film per catagory.
SELECT   c.name, MAX(fi.length) AS 'longest_movie_duration'
FROM     sakila.film_category f
JOIN     sakila.category c USING(category_id)
JOIN     sakila.film fi USING(film_id)
GROUP BY c.name
ORDER BY MAX(fi.length) DESC;

--     Display the most frequently rented movies in descending order.
SELECT   f.title, COUNT(r.rental_id) AS 'amount_of_times_rented'
FROM     sakila.film f
JOIN     sakila.inventory i USING(film_id)
JOIN     sakila.rental r USING(inventory_id)
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

--     List the top five genres in gross revenue in descending order.
SELECT   f.title, CONCAT('$',ROUND(SUM(f.rental_rate * f.rental_duration),2)) AS 'gross_revenue'
FROM     sakila.film f
JOIN     sakila.film_category fc USING(film_id)
JOIN     sakila.category c USING(category_id)
GROUP BY c.name
ORDER BY ROUND(SUM(rental_rate*rental_duration),2) DESC
LIMIT    5;

--     Is "Academy Dinosaur" available for rent from Store 1?
SELECT   f.title AS 'movie_title', 
         COUNT(i.film_id) AS 'copies_in_store', 
		 i.store_id AS 'store'
FROM     sakila.film f
JOIN     sakila.inventory i USING(film_id)
JOIN     sakila.rental r USING(inventory_id)
WHERE    i.store_id ='1' AND 
	     f.title = 'ACADEMY DINOSAUR' AND
         r.return_date IS NOT NULL
GROUP BY i.store_id;

--     Get all pairs of actors that worked together.
-- I dont understand left/right join, this worked unintentionally
SELECT     CONCAT(a.first_name,'_', a.last_name) AS actor,
		   fa.film_id, f.title
FROM 	   sakila.actor a
Right JOIN sakila.film_actor fa USING(actor_id)
JOIN       sakila.film f USING(film_id);

--     Get all pairs of customers that have rented the same film more than 3 times.
-- I know this querry is not right, so i come back to it later

SELECT     CONCAT(c.first_name,'_', c.last_name) AS customer,
		   COUNT(DISTINCT r.rental_id) AS times_rented, f.title
FROM 	   sakila.customer c
JOIN       sakila.rental r USING(customer_id)
JOIN       sakila.inventory i USING(inventory_id)
JOIN       sakila.film f USING(film_id)
WHERE      film_id = film_id 
GROUP BY   c.customer_id
ORDER BY   f.title;

--     For each film, list actor that has acted in more films.
SELECT   f.title as film_name, 
         a.first_name AS actor_name, 
		 COUNT(fa.actor_id) as times_acted
FROM     sakila.actor a
JOIN     sakila.film_actor fa USING(actor_id)
JOIN     sakila.film f USING(film_id)
GROUP BY film_name
ORDER BY times_acted DESC;