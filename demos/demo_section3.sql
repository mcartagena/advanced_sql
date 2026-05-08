-- 1. Subqueries in the SELECT clause
select * from happiness_scores hs 

-- Average happiness score

select avg(hs.happiness_score )
from   happiness_scores hs 

-- Happiness score deviation from the average

select 
	   hs.country, hs."year", hs.happiness_score ,
	   (select avg(happiness_score) from happiness_scores) as avg_hs,
	   hs.happiness_score - (select avg(happiness_score) from happiness_scores) as diff_from_avg
from   happiness_scores hs 

-- 2. Subqueries in the FROM clause

select *
from   happiness_scores hs 

-- Average happiness score for each country

select hs.country, AVG(hs.happiness_score) AS avg_hs_by_country
from   happiness_scores hs 
group by hs.country 


/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */
select hs.country, hs."year" , hs.happiness_score,
       country_hs.avg_hp_by_country
from   happiness_scores hs 
       left join (select country, AVG(happiness_score) as avg_hp_by_country from happiness_scores group by country) as country_hs
       on hs.country = country_hs.country 


-- View one country
select hs.country, hs."year" , hs.happiness_score,
       country_hs.avg_hp_by_country
from   happiness_scores hs 
       left join (select country, AVG(happiness_score) as avg_hp_by_country from happiness_scores group by country) as country_hs
       on hs.country = country_hs.country 
where  hs.country = 'United States'


-- 3. Multiple subqueries

-- Return happiness scores for 2015 - 2024
select hs.country, hs.year, hs.happiness_score from happiness_scores hs

select hsc.country, 2024, hsc.ladder_score from happiness_scores_current hsc 


/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */

select allhs.country, allhs.year, allhs.score
       ,avg_by_country 
       from 
       (select hs.country, hs.year, hs.happiness_score as score from happiness_scores hs
        union all
        select hsc.country, 2024, hsc.ladder_score as score from happiness_scores_current hsc) as allhs
        left join (select ahsc.country, avg(ahsc.happiness_score) as avg_by_country from happiness_scores ahsc group by ahsc.country) as foo
        on allhs.country = foo.country


/* Return years where the happiness score is a whole point
greater than the country's average happiness score */
select * from (
select allhs.country, allhs.year, allhs.score
       ,avg_by_country 
       from 
       (select hs.country, hs.year, hs.happiness_score as score from happiness_scores hs
        union all
        select hsc.country, 2024, hsc.ladder_score as score from happiness_scores_current hsc) as allhs
        left join (select ahsc.country, avg(ahsc.happiness_score) as avg_by_country from happiness_scores ahsc group by ahsc.country) as foo
        on allhs.country = foo.country ) bar
where  bar.score > bar.avg_by_country + 1      

-- 4. Subqueries in the WHERE and HAVING clauses

-- Average happiness score
select avg(hs.happiness_score)
from   happiness_scores hs 

-- Above average happiness scores (WHERE)
select hs.country, hs.happiness_score
from   happiness_scores hs 
where hs.happiness_score > (select avg(happiness_score) from   happiness_scores)


-- Above average happiness scores for each region (HAVING)
select hs.region, avg(hs.happiness_score) as avg_hs
from   happiness_scores hs 
group by hs.region
having avg(hs.happiness_score) > (select avg(happiness_score) from   happiness_scores)
order by hs.region 

-- 5. ANY vs ALL

-- Scores that are greater than ANY 2024 scores
select hs.country , hs.region , hs.happiness_score 
from   happiness_scores hs 
where hs.happiness_score > any (select hsc.ladder_score 
                                from   happiness_scores_current hsc)

select count(*)
from   happiness_scores hs 
where hs.happiness_score > any (select hsc.ladder_score 
                                from   happiness_scores_current hsc)

select count(*)
from   happiness_scores hs 
                                
-- Scores that are greater than ALL 2024 scores
select hs.country , hs.region , hs.happiness_score 
from   happiness_scores hs 
where hs.happiness_score > all (select hsc.ladder_score 
                                from   happiness_scores_current hsc)

-- 6. EXISTS
select * from happiness_scores hs 

select * from inflation_rates ir


/* Return happiness scores of countries
that exist in the inflation rates table */

select *
from happiness_scores hs 
where exists (
	select ir.country_name from inflation_rates ir 
    where  hs.country = ir.country_name)
    
-- Alternative to EXISTS: INNER JOIN

select *
from   happiness_scores hs 
       inner join inflation_rates ir 
       on hs.year = ir.year and hs.country = ir.country_name 
       
-- 7. CTEs: Readability
       
 /* SUBQUERY: Return the happiness scores along with
   the average happiness score for each country */

select hs.country , hs."year", hs.happiness_score,
       hs1.avg_hapiness
from happiness_scores hs
     inner join (select country, AVG(happiness_score) as avg_hapiness from happiness_scores
                  group by country) hs1
	on hs.country = hs1.country
	
/* CTE: Return the happiness scores along with
   the average happiness score for each country */
       
with hs1 as (select country, AVG(happiness_score) as avg_hapiness from happiness_scores
                  group by country)
select hs.country , hs."year", hs.happiness_score,
       hs1.avg_hapiness
from happiness_scores hs left join hs1 
     on hs.country = hs1.country 

-- 8. CTEs: Reusability
        
-- SUBQUERY: Compare the happiness scores within each region in 2023
select hs.region , hs.country , hs.happiness_score,
       hs1.country, hs1.happiness_score 
from (SELECT region, country, happiness_score FROM happiness_scores WHERE year = 2023) hs
     inner join 
     (select region, country, happiness_score from happiness_scores where year = 2023) hs1
     on hs.region = hs1.region 

 
-- CTE: Compare the happiness scores within each region in 2023
with hs as (SELECT region, country, happiness_score FROM happiness_scores WHERE year = 2023)
select hs.region , hs.country , hs.happiness_score,
       hs1.country, hs1.happiness_score 
from   hs inner join hs hs1
       on hs.region = hs1.region 
where  hs.country < hs1.country 
     
-- 9. Multiple CTEs

-- Step 1: Compare 2023 vs 2024 happiness scores side by side
with hs23 as (select * from happiness_scores hs where hs."year" = 2023),
     hs24 as (select * from happiness_scores_current hsc)
select hs23.country , 
       hs23.happiness_score as hs_2023,
       hs24.ladder_score as hs_2024
from   hs23 left join hs24
       on hs23.country = hs24.country 

-- Step 2: Return the countries where the score increased
select *
from (with hs23 as (select * from happiness_scores hs where hs."year" = 2023),
     hs24 as (select * from happiness_scores_current hsc)
select hs23.country , 
       hs23.happiness_score as hs_2023,
       hs24.ladder_score as hs_2024
from   hs23 left join hs24
       on hs23.country = hs24.country) hs_23_24
where hs_2024 > hs_2023 
       
       
-- Alternative: CTEs only

with hs23 as (select * from happiness_scores hs where hs."year" = 2023),
     hs24 as (select * from happiness_scores_current hsc),
     hs_23_24 as (select hs23.country , 
			  	         hs23.happiness_score as hs_2023,
					     hs24.ladder_score as hs_2024
				  from   hs23 left join hs24
					     on hs23.country = hs24.country) 
select *       
from   hs_23_24
where  hs_2024 > hs_2023 

-- 10. Recursive CTEs

-- Create a stock prices table

CREATE TABLE stock_prices (
    date DATE PRIMARY KEY,
    price DECIMAL(10, 2)
);

INSERT INTO stock_prices (date, price) VALUES
	('2024-11-01', 678.27),
	('2024-11-03', 688.83),
	('2024-11-04', 645.40),
	('2024-11-06', 591.01);

-- Example 1: Generating sequences

select * from stock_prices

-- Generate a column of dates
with recursive mydates(dt) as 
		(select '2024-11-01'::date
		 union all
		 select (dt + interval '1 days')::date
		 from mydates
		 where dt < '2024-11-06')
select * from mydates		 

-- Include the original prices
with recursive mydates(dt) as 
		(select '2024-11-01'::date
		 union all
		 select (dt + interval '1 days')::date
		 from mydates
		 where dt < '2024-11-06')
select m.dt, s.price
from 	mydates m 
        left join stock_prices s
        on m.dt = s.date
order by m.dt

-- Example 2: Working with hierachical data

select * from employees

-- Return the reporting chain for each employee
with recursive emp as (
		select e.employee_id, e.employee_name, e.manager_id , e.employee_name::text as hierarchy 
		from employees e
		where e.manager_id is null
		union all
		select e1.employee_id , e1.employee_name , e1.manager_id , concat(emp.hierarchy, ' > ', e1.employee_name )
		from   employees e1 inner join emp
		       on e1.manager_id = emp.employee_id
)
select * from emp

-- 11. Subquery vs CTE vs Temp Table vs View

-- Subquery
SELECT * FROM
(SELECT	year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT	2024, country, ladder_score FROM happiness_scores_current) AS my_subquery;

-- CTE
WITH my_cte AS (SELECT	year, country, happiness_score FROM happiness_scores
				UNION ALL
				SELECT	2024, country, ladder_score FROM happiness_scores_current)                
SELECT * FROM my_cte;

-- Temporary table
CREATE TEMPORARY TABLE my_temp_table AS
SELECT	year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT	2024, country, ladder_score FROM happiness_scores_current;

SELECT * FROM my_temp_table;

-- View
CREATE VIEW my_view AS
SELECT	year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT	2024, country, ladder_score FROM happiness_scores_current;

SELECT * FROM my_view;

