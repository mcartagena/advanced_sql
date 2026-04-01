-- Connect to database


-- ASSIGNMENT 1: Basic Joins
-- Looking at the orders and products tables, which products exist in one table, but not the other?

-- View the orders and products tables

select *
from   orders;

select * 
from   products;

select count(distinct product_id)
from   orders

select count(distinct product_id)
from   products

-- Join the tables using various join types & note the number of rows in the output

select count(*) 
from   orders o
       left join products p 
       on o.product_id = p.product_id  -- 8549
       
select count(*)
from   orders o
       right join products p 
       on o.product_id = p.product_id  -- 8552
        
-- View the products that exist in one table, but not the other

-- all orders with products not in table products
select o.order_id, o.product_id,
       p.product_id 
from   orders o
       left join products p 
       on o.product_id = p.product_id
where  p.product_id is null   -- 0

-- all products not in table orders
select o.order_id, o.product_id,
       p.product_id 
from   orders o
       right join products p 
       on o.product_id = p.product_id
where  o.product_id is null   -- 3

-- Pick a final JOIN type to join products and orders

select p.product_id, p.product_name, 
       o.product_id as product_id_in_orders     
from   products p
       left join orders o 
       on p.product_id = o.product_id
where  o.product_id is null 

-- ASSIGNMENT 2: Self Joins
-- Which products are within 25 cents of each other in terms of unit price?

-- View the products table


-- Join the products table with itself so each candy is paired with a different candy

        
-- Calculate the price difference, do a self join, and then return only price differences under 25 cents


