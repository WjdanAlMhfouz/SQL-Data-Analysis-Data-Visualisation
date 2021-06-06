
 -- How many film available in each category?

 SELECT c.name category,
       count(c.name) AS number_of_film
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY category
ORDER BY number_of_film DESC


-- How many film rented per year in Saudi Arabia?\

SELECT to_char(date(r.rental_date),'YYYY-MM') as year_month,
       co.country,
       count(*) number_of_rent
FROM rental r, (address a
                JOIN city ci ON ci.city_id = a.city_id
                JOIN country co ON co.country_id = ci.country_id)
WHERE co.country LIKE 'Saudi Arabia'
GROUP BY 1,
         2


-- What are the number of film kids allowed to attend?\

SELECT c.name category, f.rating,COUNT(*),
       NTILE(5) OVER (ORDER BY f.rating) Quartile
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE f.rating = 'G'
  AND c.name IN ('Animation',
                 'Children',
                 'Comedy',
                 'Family',
                 'Music')
GROUP BY 1,
         2

-- What is the total amount of rental/paid per country?\
SELECT sum(cast(p.amount AS int)) amount, t1.country
FROM
  (SELECT co.country country
   FROM address a
   JOIN city ci ON ci.city_id = a.city_id
   JOIN country co ON co.country_id = ci.country_id) t1,
     customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY t1.country
ORDER BY amount DESC
LIMIT 10;
