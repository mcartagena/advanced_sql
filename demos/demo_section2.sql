-- 1. Basic joins

select * from happiness_scores hs 

select * from country_stats cs 

select hs."year", hs.country, hs.happiness_score, 
       cs.continent 
from   happiness_scores hs 
       inner join country_stats cs 
       on hs.country = cs.country 
       
-- 2. Join types

-- LEFT JOIN includes all the rows from hs and the rows that convine with cs
select hs."year", hs.country, hs.happiness_score, 
       cs.country , cs.continent 
from   happiness_scores hs 
       left join country_stats cs 
       on hs.country = cs.country  
where  cs.country is null       

-- RIGHT JOIN includes all the rows from cs and the rows that convine with hs
select hs."year", hs.country, hs.happiness_score, 
       cs.country , cs.continent 
from   happiness_scores hs 
       right join country_stats cs 
       on hs.country = cs.country  
where  hs.country is null    

-- OUTTER JOIN includes all the rows from cs and the rows that convine with hs
select hs."year", hs.country, hs.happiness_score, 
       cs.country , cs.continent 
from   happiness_scores hs 
       full outer join country_stats cs 
       on hs.country = cs.country  
--where  cs.country is null    
where  hs.country is null    


-- all the countries that exist in hs but not in cs
SELECT	DISTINCT hs.country
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	cs.country IS NULL;

-- all the countries that exist in cs but not in hs
SELECT	DISTINCT cs.country
FROM	happiness_scores hs
		RIGHT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	hs.country IS NULL;

-- 3. Joining on multiple columns

select * from happiness_scores hs 

select * from inflation_rates ir 

select  hs."year", hs.country, hs.happiness_score, 
        ir.inflation_rate 
from    happiness_scores hs 
        inner join inflation_rates ir 
        on hs.country = ir.country_name and hs."year" = ir."year" 

-- 4. Joining multiple tables

select * from happiness_scores hs 

select * from inflation_rates ir 

select * from country_stats cs 

select hs."year", hs.country, hs.happiness_score, 
       cs.continent, ir.inflation_rate 
from   happiness_scores hs 
       left join country_stats cs 
       	on hs.country = cs.country
       left join inflation_rates ir 
       	on hs."year" = ir."year" and hs.country = ir.country_name 

-- 5. Self joins
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
	(1, 'Ava', 85000, NULL),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2);

select * from employees

-- Employees with the same salary

select e1.employee_id, e1.employee_name, e1.salary,
       e2.employee_id, e2.employee_name, e2.salary
from   employees e1
       inner join employees e2
       on e1.salary = e2.salary
where  e1.employee_id > e2.employee_id
order by e1.employee_name

-- Employees that have a greater salary
select e1.employee_id, e1.employee_name, e1.salary,
       e2.employee_id, e2.employee_name, e2.salary
from   employees e1
       inner join employees e2
       on e1.salary > e2.salary
 order by e1.employee_id

-- Employees and their managers
select e1.employee_id, e1.employee_name, e1.manager_id,
       case when e1.manager_id is null then 'manager'
       else e2.employee_name end as manager
from   employees e1
       left join employees e2
       on e1.manager_id = e2.employee_id

select * from employees

-- 6. Cross joins
CREATE TABLE tops (
    id INT,
    item VARCHAR(50)
);

CREATE TABLE sizes (
    id INT,
    size VARCHAR(50)
);

CREATE TABLE outerwear (
    id INT,
    item VARCHAR(50)
);

INSERT INTO tops (id, item) VALUES
	(1, 'T-Shirt'),
	(2, 'Hoodie');

INSERT INTO sizes (id, size) VALUES
	(101, 'Small'),
	(102, 'Medium'),
	(103, 'Large');

INSERT INTO outerwear (id, item) VALUES
	(2, 'Hoodie'),
	(3, 'Jacket'),
	(4, 'Coat');

-- View the tables
SELECT * FROM tops;
SELECT * FROM sizes;
SELECT * FROM outerwear;

-- Cross join the tables
select *
from   tops 
       cross join sizes

-- From the self join assignment:
-- Which products are within 25 cents of each other in terms of unit price?
select p1.product_name , p1.unit_price , p2.product_name , p2.unit_price , 
	   (p1.unit_price - p2.unit_price) as price_diff
from   products p1
       inner join products p2
       on abs(p1.unit_price - p2.unit_price) < 0.25       
where  p1.product_id <> p2.product_id 
       and p1.product_name < p2.product_name 	
order by price_diff desc

-- Rewritten with a CROSS JOIN
select p1.product_name , p1.unit_price , p2.product_name , p2.unit_price , 
	   (p1.unit_price - p2.unit_price) as price_diff
from   products p1
       cross join products p2      
where  p1.product_id <> p2.product_id 
       and abs(p1.unit_price - p2.unit_price) < 0.25 
       and p1.product_name < p2.product_name 	
order by price_diff desc

-- 7. Union vs union all
SELECT * FROM tops;
SELECT * FROM outerwear;

-- Union
select * 
from   tops
union
select *
from outerwear

-- Union all
select * 
from   tops
union all
select *
from outerwear





       	
