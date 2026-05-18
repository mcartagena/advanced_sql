-- ASSIGNMENT 1: Window function basics

-- View the orders table
select * from orders


-- View the columns of interest
select o.customer_id , 
       o.order_id , 
       o.order_date , 
       o.transaction_id
from orders o
order by o.customer_id , o.transaction_id 


-- For each customer, add a column for transaction number
select o.customer_id , 
       o.order_id , 
       o.order_date , 
       o.transaction_id,
       row_number() over(partition by o.customer_id order by o.transaction_id) as trans_num
from orders o
order by o.customer_id , o.transaction_id 