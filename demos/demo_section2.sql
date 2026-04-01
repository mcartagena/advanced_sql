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

