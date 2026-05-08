-- Connect to database


-- ASSIGNMENT 1: Subqueries in the SELECT clause

-- View the products table

select * from products p 

-- View the average unit price

select avg(p.unit_price)
from   products p 

-- Return the product id, product name, unit price, average unit price,
-- and the difference between each unit price and the average unit price

select 
	   p.product_id , p.product_name , p.unit_price,
	   (select avg(unit_price) from products) as avg_price,
	   p.unit_price - (select avg(unit_price) from products) as diff_unit_avg_price
from   products p 

-- Order the results from most to least expensive

select 
	   p.product_id , p.product_name , p.unit_price,
	   (select avg(unit_price) from products) as avg_price,
	   p.unit_price - (select avg(unit_price) from products) as diff_unit_avg_price
from   products p 
order by p.unit_price desc

-- ASSIGNMENT 2: Subqueries in the FROM clause

-- Return the factories, product names from the factory
-- and number of products produced by each factory

-- All factories and products
select * from products p

select p.factory, p.product_name, count(1) from products p
group by p.factory, p.product_name 

-- All factories and their total number of products
select p.factory, count(1) from products p
group by p.factory 

-- Final query with subqueries
select p.factory, p.product_name, f."number" 
from   products p
       left join (select p.factory, count(1) as number from products p
                  group by p.factory) as f
       on p.factory = f.factory 
order by p.factory, p.product_name

-- ASSIGNMENT 3: Subqueries in the WHERE clause

-- View all products from Wicked Choccy's
select * from products p 
where p.factory = 'Wicked Choccy''s'

-- Return products where the unit price is less than
-- the unit price of all products from Wicked Choccy's

select * from products p1
where p1.unit_price < (select min(p.unit_price ) from products p 
where p.factory = 'Wicked Choccy''s')

-- solution from the course
select * from products p1
where p1.unit_price < 
      all (select min(p.unit_price ) from products p 
            where p.factory = 'Wicked Choccy''s')

-- ASSIGNMENT 4: CTEs

-- View the orders and products tables
select * from orders o             

select * from products p 

-- Calculate the amount spent on each product, within each order

select o.order_id,
       sum(o.units * p.unit_price ) as total_amount_spent
from   orders o 
       inner join(select product_id, unit_price from products) p
       on o.product_id = p.product_id 
group by o.order_id 


-- Return all orders over $200

select o.order_id,
       sum(o.units * p.unit_price ) as total_amount_spent
from   orders o 
       inner join(select product_id, unit_price from products) p
       on o.product_id = p.product_id 
group by o.order_id 
having sum(o.units * p.unit_price ) > 200

-- CTE
with p as (select product_id, unit_price from products)
select o.order_id,
       sum(o.units * p.unit_price ) as total_amount_spent
from   orders o 
       inner join p
       on o.product_id = p.product_id 
group by o.order_id 
having sum(o.units * p.unit_price ) > 200



-- Return the number of orders over $200

select count(*)
from (select o.order_id,
       sum(o.units * p.unit_price ) as total_amount_spent
from   orders o 
       inner join(select product_id, unit_price from products) p
       on o.product_id = p.product_id 
group by o.order_id 
having sum(o.units * p.unit_price ) > 200) total_orders


-- CTE
with p as (select product_id, unit_price from products)
select count(*)
from (select o.order_id,
       sum(o.units * p.unit_price ) as total_amount_spent
from   orders o 
       inner join p
       on o.product_id = p.product_id 
group by o.order_id 
having sum(o.units * p.unit_price ) > 200) total_orders

-- ASSIGNMENT 5: Multiple CTEs

-- Copy over Assignment 2 (Subqueries in the FROM clause) solution
select p.factory, p.product_name, f."number" 
from   products p
       left join (select p.factory, count(1) as number from products p
                  group by p.factory) as f
       on p.factory = f.factory 
order by p.factory, p.product_name

-- Rewrite the Assignment 2 subquery solution using CTEs instead
with f as (select p.factory, count(1) as number from products p
                  group by p.factory),
     pxf as (select p.factory, p.product_name, f."number" 
             from   products p
                    left join f
                    on p.factory = f.factory )       
select * 
from   pxf
order by pxf.factory, pxf.product_name 




            