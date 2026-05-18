-- 1. Window function basics

-- Return all row numbers
select hs.country, hs.year, hs.happiness_score, 
	   row_number() over() as row_num
from   happiness_scores hs 
order by hs.country, hs."year" 

-- Return all row numbers within each window
select hs.country, hs.year, hs.happiness_score, 
	   row_number() over(partition by hs.country ) as row_num
from   happiness_scores hs 
order by hs.country, hs."year" 

-- Return all row numbers within each window
-- where the rows are ordered by happiness score
select hs.country, hs.year, hs.happiness_score, 
	   row_number() over(partition by hs.country 
	   order by hs.happiness_score ) as row_num
from   happiness_scores hs 
order by hs.country, row_num  


-- Return all row numbers within each window
-- where the rows are ordered by happiness score descending
select hs.country, hs.year, hs.happiness_score, 
	   row_number() over(partition by hs.country 
	   order by hs.happiness_score desc) as row_num
from   happiness_scores hs 
order by hs.country, row_num  

