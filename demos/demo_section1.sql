-- 1. View the students table

select * from students;

-- 2. The big 6

select grade_level, AVG(gpa) as avg_gpa
  from students
 where school_lunch = 'Yes'
group by grade_level
having   AVG(gpa) < 3.3
order by grade_level;

-- 3. Common keyboards

-- DISTINCT

select distinct grade_level 
from students; 

-- COUNT

select count(distinct grade_level)
from students; 

-- MAX and MIN

select max(gpa) - min(gpa) as gpa_range
from students; 

-- AND

select *
from students
where grade_level < 12 and school_lunch = 'Yes'; 

-- IN

select *
from students
where grade_level in (9, 10, 11);

-- IS NULL

select *
from students
-- where email is null;
where email is not null;


-- LIKE

select *
from students
where email like '%.edu'

-- ORDER BY

select *
from students
-- order by gpa; -- by default asc
order by gpa desc;

-- LIMIT

select *
from students
limit 5;

-- CASE statements

select student_name, grade_level,
	   case when grade_level = 9 then 'Freshman'
	        when grade_level = 10 then 'Sophomore'
	        when grade_level = 11 then 'Junior'
	        else 'Senior' end as student_class
from students;



