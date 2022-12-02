-- Lab | SQL Join (Part II)
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions
-- 1 Write a query to display for each store its store ID, city, and country.
-- 2 Write a query to display how much business, in dollars, each store brought in.
-- 3 Which film categories are longest?
-- 4 Display the most frequently rented movies in descending order.
-- 5 List the top five genres in gross revenue in descending order.
-- 6 Is "Academy Dinosaur" available for rent from Store 1?
-- 7 Get all pairs of actors that worked together.
-- 8 Get all pairs of customers that have rented the same film more than 3 times.
-- 9 For each film, list actor that has acted in more films.

USE sakilla;
-- 1 Write a query to display for each store its store ID, city, and country.
SELECT *
FROM store;
SELECT *
FROM city;
SELECT *
FROM country;

SELECT store.store_id, city.city, country.country
FROM store
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
GROUP BY store.store_id; select store.store_id, city.city, country.country
FROM store
JOIN address USING(address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
GROUP BY store.store_id;

-- option 2

SELECT store_id, city, country 
FROM store s
JOIN address a 
ON (s.address_id=a.address_id)
JOIN city c 
ON (a.city_id=c.city_id)
JOIN country cntry ON (c.country_id=cntry.country_id);

-- 2 Write a query to display how much business, in dollars, each store brought in.

SELECT address, SUM(amount) AS 'total business' FROM payment p JOIN(		
	SELECT address, rental_id FROM rental r JOIN( 
		SELECT address, inventory_id FROM inventory i
			JOIN (
				SELECT s.store_id AS store_id, a.address FROM store s 
				JOIN address a ON a.address_id = s.address_id) b
				ON i.store_id = b.store_id
				) c ON c.inventory_id = r.inventory_id)
                d ON d.rental_id = p.rental_id GROUP BY address;

-- 3 Which film categories are longest?
SELECT *
FROM film;

SELECT category.name, MAX(length)
FROM film 
JOIN film_category 
USING (film_id) 
JOIN category 
USING (category_id)
GROUP BY category.name
HAVING MAX(length) = (SELECT MAX(length) FROM film)
ORDER BY MAX(length) DESC;

-- optional

SELECT category.name, AVG(film.length) AS avg_length
FROM category
JOIN film_category USING(category_id)
JOIN film USING(film_id)
GROUP BY category.category_id
ORDER BY avg_length DESC
LIMIT 1;

-- 4 Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.title) AS rentals FROM film f 
JOIN 
	(SELECT r.rental_id, i.film_id FROM rental r 
    JOIN 
    inventory i ON i.inventory_id = r.inventory_id) a
    ON a.film_id = f.film_id GROUP BY f.title ORDER BY rentals DESC;

-- 5 List the top five genres in gross revenue in descending order.

SELECT cat.name as category, SUM(d.revenue) AS revenue FROM category cat 
JOIN
    (SELECT catf.category_id, c.revenue FROM film_category catf 
	JOIN 
		(SELECT i.film_id, b.revenue FROM inventory i 
		JOIN 
			(SELECT r.inventory_id, a.revenue FROM rental r 
			JOIN 
				(SELECT p.rental_id, p.amount AS revenue FROM payment p) a 
				ON a.rental_id = r.rental_id) b
			ON b.inventory_id = i.inventory_id) c
		ON c.film_id = catf.film_id) d 
	ON d.category_id = cat.category_id GROUP BY cat.name
  ORDER BY revenue DESC
  LIMIT 5;

-- 6 Is "Academy Dinosaur" available for rent from Store 1?
SELECT *
FROM film f 
INNER JOIN inventory i 
ON i.film_id = f.film_id
WHERE i.store_id = 1 
AND f.title = "Academy Dinosaur";
 
-- 7 Get all pairs of actors that worked together.
SELECT *
FROM film_actor;

SELECT *
FROM actor;

SELECT COUNT(fa.actor_id), a.first_name, a.last_name
FROM film_actor fa
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id;