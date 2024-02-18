use sakila;

--  First Normal Form :

-- Q1. Identify a table in the sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.
Select * from film;
-- In film table there are two values given in the same row of special_features which violates the 1NF. so, we need to create another table 
-- to normalize the film table to represent the relationship between film and special features.

CREATE TABLE special_features_film (
    film_id smallint unsigned,
    special_feature set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    PRIMARY KEY (film_id, special_feature),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);
-- Now we can insert values in different rows to achieve 1NF. 
INSERT INTO special_features_film (film_id, special_feature) VALUES
(1, 'Commentaries'),
(1, 'Trailers'),
(1, 'Deleted Scenes');

-- Second Normal Form (2NF)
-- Choose a table in Sakila database and describe how you would determine whether it is in 2NF. if it violates 2NF, explain the steps to normalize it  

select * from film;
describe film;
 -- 1. Identify Issue: Check if there are attributes (like language_id and original_language_id) in the table that depend on only part of the primary key (film_id).
-- 2.  Create New Table: If found, create a new table (e.g., film_languages) with the partially dependent attributes (language_id and original_language_id) along with the part of the primary key they depend on (film_id).
-- 3. Maintain Relationship: In the new table, use foreign keys to maintain a relationship with the original table (film) based on the common key (film_id).
-- 4. Normalization Complete: This separation ensures that non-prime attributes are fully dependent on the entire primary key in the original table, adhering to Second Normal Form (2NF).

CREATE TABLE film_languages (
    film_id smallint unsigned PRIMARY KEY,
    language_id tinyint unsigned,
    original_language_id tinyint unsigned,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (language_id) REFERENCES language(language_id),
    FOREIGN KEY (original_language_id) REFERENCES language(language_id)
);

-- 5. Move Attributes: Move language_id and original_language_id to a new table (film_language).
-- 6. Include Key: Include film_id in the new table to maintain the relationship.
-- 7. Ensure Dependency: This normalization ensures that attributes depend fully on the entire primary key in the original film table, meeting 2NF.

-- Third normal form (3NF) 
-- Q3.  Identify a table in the sakila database that violates 3NF. Describe the transitive dependencies present and outline the steps
--      to normalize the tables to 3NF.  


-- Let's consider the film table in the Sakila database and check if it violates the Third Normal Form (3NF). 
describe film;
-- Let's assume that replacement_cost depends on length (film duration), and both length and replacement_cost depend on the film_id. This represents a transitive dependency.

-- 1. Identify Transitive Dependency: replacement_cost depends on length.
-- #  length and replacement_cost both depend on film_id
 -- # This creates a transitive dependency: film_id -> length -> replacement_cost.

 -- 2. Normalize to 3NF: Create a new table (film_details) with columns related to the transitive dependency.
 -- #  Move the dependent columns (length, replacement_cost) to the new table.
 -- # Include the determinant (film_id) in both the original and new tables.

-- New table for transitive dependency
CREATE TABLE film_details (
    film_id smallint unsigned PRIMARY KEY,
    length smallint unsigned,
    replacement_cost DECIMAL(5,2),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);
-- By creating the film_details table and moving the columns with the transitive dependency, we ensure that the replacement_cost is now directly dependent on the primary key (film_id), meeting the requirements of the Third Normal Form (3NF).

--  Normalization Process 
-- Q4.Take a specific table in sakila and guide through the process of normalizing it fromn the initial unnormalized from up to at least 2NF. 

-- Initial Unnormalized Form:
-- Consider the provided `film` table with potential redundancy.

-- First Normal Form (1NF):
-- The table is already in 1NF as each column contains atomic values.

-- Second Normal Form (2NF):
-- Identify potential partial dependencies, e.g., `rental_rate` depends only on `film_id`.

-- Steps to Normalize to 2NF:
-- 1. Create a new table (`film_detail`) for attributes partially dependent on the primary key:
CREATE TABLE film_detail (
    film_id smallint unsigned PRIMARY KEY,
    rental_rate DECIMAL(4,2),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- 2. Modify the original table by removing the attributes moved to the new table:
ALTER TABLE film
DROP COLUMN rental_rate;

-- Resulting Normalized Tables:

-- Original Table (`film`):
describe film;

-- New Table (`film_detail`):
CREATE TABLE film_details_new (
    film_id smallint unsigned PRIMARY KEY,
    rental_rate DECIMAL(4,2),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- CTE Basics:
-- Q5. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables. 

WITH ActorFilmCounts AS (
    SELECT
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM
        actor a
    JOIN
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY
        a.actor_id, actor_name
)

SELECT
    actor_id,
    actor_name,
    film_count
FROM
    ActorFilmCounts;
    
-- Recursive CTE:
-- Q6. Use a recursive CTE to generate a hierarchical list of categories and their subcategories from the category table in sakila. 

WITH RECURSIVE CategoryHierarchy AS (
  SELECT
    category_id,
    name,
    parent_id,
    1 AS level
  FROM
    category
  WHERE
    parent_id IS NULL -- Select the top-level categories

  UNION ALL

  SELECT
    c.category_id,
    c.name,
    c.parent_id,
    ch.level + 1
  FROM
    category c
  JOIN
    CategoryHierarchy ch ON c.parent_id = ch.category_id
)

SELECT
  category_id,
  name,
  parent_id,
  level
FROM
  CategoryHierarchy
ORDER BY
  level, category_id;

-- CTE with joins:
-- Q7. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate. 
select * from language;

WITH FilmLanguageInfo AS (
  SELECT
    f.title AS film_title,
    l.name AS language_name,
    f.rental_rate
  FROM
    film f
    JOIN language l ON f.language_id = l.language_id
)

SELECT
  film_title,
  language_name,
  rental_rate
FROM
  FilmLanguageInfo;

-- CTE for aggregations:
-- Q8. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables. 
 
WITH CustomerRevenue AS (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(p.amount), 0) AS total_revenue
  FROM
    customer c
    LEFT JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY
    c.customer_id, c.first_name, c.last_name
)

SELECT
  customer_id,
  first_name,
  last_name,
  total_revenue
FROM
  CustomerRevenue
ORDER BY
  total_revenue DESC;

-- CTE with window function :
-- Q9. Utilize a CTE with a window function to rank film based on their rental duration from the film table. 

WITH FilmRanking AS (
  SELECT
    film_id,
    title,
    rental_duration,
    RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
  FROM
    film
)

SELECT
  film_id,
  title,
  rental_duration,
  duration_rank
FROM
  FilmRanking
ORDER BY
  duration_rank;
  
  -- CTE and Filtering:
  -- Q10. create a CTE to list customers who have made more than two rentals, and then join the CTE with the customer table to retrieve additional
  -- customer details. 
  
WITH CustomerRentals AS (
  SELECT
    customer_id,
    COUNT(rental_id) AS rental_count
  FROM
    rental
  GROUP BY
    customer_id
  HAVING
    COUNT(rental_id) > 2
)

SELECT
  c.*,
  cr.rental_count
FROM
  customer c
JOIN
  CustomerRentals cr ON c.customer_id = cr.customer_id;

-- CTE for Date calculations:
-- Q11. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table. 
select * from rental;
WITH MonthlyRentals AS (
   SELECT
     monthname(rental_date) as month,
      COUNT(rental_id) AS rental_count
   FROM
      rental
   GROUP BY
     month)
 
SELECT
 month,
   rental_count
FROM
   MonthlyRentals;

-- CTE for pivot operation:
-- Q12. Use a CTE to pivot the data from the payment table to display the total payment made by each customer in separate columns for different 
-- payment methods. 
select * from payment;
WITH PaymentPivot AS (
  SELECT
    customer_id,
    SUM(CASE WHEN payment_type = 'Cash' THEN amount ELSE 0 END) AS cash_total,
    SUM(CASE WHEN payment_type = 'Credit Card' THEN amount ELSE 0 END) AS credit_card_total,
    SUM(CASE WHEN payment_type = 'Debit Card' THEN amount ELSE 0 END) AS debit_card_total,
    SUM(CASE WHEN payment_type = 'Check' THEN amount ELSE 0 END) AS check_total
  FROM
    payment
  GROUP BY
    customer_id
)

SELECT
  customer_id,
  cash_total,
  credit_card_total,
  debit_card_total,
  check_total
FROM
  PaymentPivot;

-- CTE and self-join:
-- Q13. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together using the film_actor table. 

WITH ActorPairs AS (
  SELECT
    fa1.actor_id AS actor1_id,
    fa1.film_id AS film_id,
    fa2.actor_id AS actor2_id
  FROM
    film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
                       AND fa1.actor_id < fa2.actor_id
)

SELECT
  ap.actor1_id,
  ap.actor2_id,
  GROUP_CONCAT(DISTINCT f.title ORDER BY f.title ASC) AS films_together
FROM
  ActorPairs ap
  JOIN film f ON ap.film_id = f.film_id
GROUP BY
  ap.actor1_id, ap.actor2_id;

-- CTE for recursive search :
-- Implement a recursive CTE to find all employee in the staff table who report to a specific manager, considering the reports_to column. 
select * from staff;