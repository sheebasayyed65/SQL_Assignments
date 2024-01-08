-- Question 1 : Identify the primary keys and foreign keys in maven movies db. Discuss the differences
Select table_name, column_name from information_schema.key_column_usage where constraint_name = 'primary' and table_schema = 'mavenmovies';
-- 1) For actor table, the primary key is actor_id and the foreign key is last_name.
describe actor;
-- 2) For address table, the primary key is address_id and the foreign key is city_id.
describe address;
-- 3) For city table, the primary key is city_id and the foreign key is country_id.
describe city;
-- 4) For film table, the primary key is film_id and the foreign keys are title, language_id, original_language_id.
describe film;
-- 5) For inventory table, the primary key is inventory_id and the foreign keys are film_id, store_id.
describe inventory;
-- 6) For payment table, the primary key is payment_id and the foreign keys are customer_id, staff_id and rental_id.
describe payment;
-- 7) For rental table, the primary key is rental_id and the foreign keys are rental_date, inventory_id, customer_id and staff_id.
describe rental;
-- 8) For staff table, the primary key is staff_id and the foreign keys are address_id and store_id.
describe staff;
-- 9) For store table, the primary key is store_id and the foreign key is address_id.
describe store;
-- 10) For advisor table, the primary key is advisor_id.
describe advisor;
-- 11) For category table, the primary key is category_id.
describe category;
-- 12) For film_category, the primary keys are film_id and category_id.
describe film_category;
-- Difference between primary and foreign key : 
-- A primary key is unique and cannot have a null value. The primary key identifies each record in the table.
-- Whereas a foreign key is used as a reference to the other table where values can match and appropriate values between two tables can be fetched.
-- Foreign key is a link between data in two tables.

-- Question 2 : List all details of actors
select * from actor;

-- Question 3 : List all customer information from DB.
select * from customer;

-- Question 4 : List different countries.
select * from country;
select distinct country from country;

-- Question 5 : Display all active customers.
select * from customer where active = 1;

-- Question 6 : List of all rental IDs for customer with ID 1.
select customer_id, rental_id from rental where customer_id = 1;

-- Question 7 : Display all the films whose rental duration is greater than 5.
select title, rental_duration from film where rental_duration > 5;

-- Question 8 : List the total number of films whose replacement cost is greater than $15 and less than $20.
select count(*) as total_film from film where replacement_cost between 15 and 20;

-- Question 9 : Find the number of films whose rental rate is less than $1.
select count(rental_rate) as total_rental_rate from film;

-- Question 10 : Display the count of unique first names of actors.
select count(distinct first_name) as first_name from actor;

-- Question 11 : Display the first 10 records from the customer table
select * from customer limit 10;

-- Question 12 : Display the first 3 records from the customer table whose first name starts with ‘b’.
select * from customer where first_name like 'b%' limit 3;

-- Question 13 : Display the names of the first 5 movies which are rated as ‘G’.  
select title, rating from film where rating = 'G' limit 5;

-- Question 14 : Find all customers whose first name starts with "a".
select * from customer where first_name like 'a%';

-- Question 15 : Find all customers whose first name ends with "a".
select * from customer where first_name like '%a';

-- Question 16 : Display the list of first 4 cities which start and end with ‘a’ . 
select city from city where city like 'a%a';

-- Question 17 : Find all customers whose first name have "NI" in any position.  
select * from customer where first_name like '%NI%';
 
-- Question 18 : Find all customers whose first name have "r" in the second position 
select * from customer where first_name like '_r%';

-- Question 19 : Find all customers whose first name starts with "a" and are at least 5 characters in length
select * from customer where first_name like 'a%' and length(first_name) >= 5;

-- Question 20 : Find all customers whose first name starts with "a" and ends with "o".
select * from customer where first_name like 'a%o';

-- Question 21 : Get the films with pg and pg-13 rating using IN operator.  
select title, rating from film where rating in ('PG', 'PG-13');   

-- Question 22 : Get the films with length between 50 to 100 using between operator.  
select title, length from film where length between 50 and 100;  
                                                                           
-- Question 23 : Get the top 50 actors using limit operator. 
select * from actor limit 50;

-- Question 24 : Get the distinct film ids from inventory table. 
select distinct film_id from inventory;   

