create table stats (
	dt date,
	loc text,
	score int
);

insert into stats (dt, loc, score) values
('2022-01-05'::date,'IND',40),
('2022-01-09'::date,'IND',20),
('2022-01-14'::date,'IND',33),
('2022-02-22'::date,'SA',18),
('2022-02-27'::date,'SA',72),
('2022-03-02'::date,'SA',26),
('2022-05-24'::date,'ENG',84),
('2022-05-29'::date,'ENG',92),
('2022-06-03'::date,'ENG',1),
('2022-06-07'::date,'ENG',110),
('2022-07-05'::date,'IND',14),
('2022-07-09'::date,'IND',120),
('2022-07-14'::date,'IND',37),
('2022-07-30'::date,'IND',66),
('2022-08-03'::date,'IND',52);

select * from stats;

-- Total runs scored in previous 5 matches
SELECT 
    dt, 
    loc, 
    score,
    SUM(score) OVER (
        ORDER BY dt 
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS prev_5_matches_total
FROM stats
ORDER BY dt;

-- my query
select score from stats
order by dt desc
limit 5;

-- Difference in runs scored from the previous match of the same location
SELECT 
    dt, 
    loc, 
    score,
    score - LAG(score) OVER (
        PARTITION BY loc 
        ORDER BY dt
    ) AS diff_from_prev_loc_match
FROM stats
ORDER BY loc, dt;

-- my query
select s.score - s1.score from stats s
  inner join(select score, loc from stats) as s1
  on s.loc = s1.loc;


-- Total runs scored every month (Display 0 is no match is played)
WITH month_series AS (
    -- Generates a list of the first day of every month for 2022
    SELECT generate_series(
        '2022-01-01'::date, 
        '2022-12-01'::date, 
        '1 month'::interval
    )::date AS month_date
)
SELECT 
    TO_CHAR(ms.month_date, 'Month') AS month_name,
    COALESCE(SUM(s.score), 0) AS total_runs
FROM month_series ms
LEFT JOIN stats s ON DATE_TRUNC('month', s.dt) = ms.month_date
GROUP BY ms.month_date
ORDER BY ms.month_date;

-- my query
select month(dt), sum(score) from stats
group by month(dt)
order by month(dt);

-- suggestions to my query
SELECT 
    EXTRACT(MONTH FROM dt) AS match_month, 
    SUM(score) 
FROM stats
GROUP BY match_month
ORDER BY match_month;

-- Total runs scored in last 45 days
SELECT SUM(score) AS total_runs_last_45_days
FROM stats
WHERE dt >= CURRENT_DATE - INTERVAL '45 days';

-- for the current database with data around 2022
SELECT SUM(score) AS total_runs
FROM stats
WHERE dt >= (SELECT MAX(dt) FROM stats) - INTERVAL '45 days';

-- suggestions to my query
SELECT SUM(score) 
FROM stats
WHERE dt > (CURRENT_DATE - 45);

SELECT SUM(score) 
FROM stats
WHERE dt > (CURRENT_DATE - INTERVAL '45 days')

-- This looks back 45 days from the last match in your table
SELECT SUM(score) 
FROM stats
WHERE dt > ('2022-08-03'::date - 45);

-- my query
select sum(score) from stats
where dt > (date - 45);

-- The greater salary of employees

-- select employees
select * from employees

-- select the greater salary of employees
select e.employee_id , e.employee_name, e.salary 
from   employees e 
where  e.salary = (select max(salary) from employees)

-- select the second greater salary of employees

select emp.employee_id , emp.employee_name, emp.salary 
from   employees emp
where salary = (select max(e.salary)
                from   employees e 
                where  e.salary < (select max(salary) from employees))

-- my query
select e.employee_id, e.employee_name, e.salary 
from   employees e
order by e.salary desc
limit 1

select employee_id, employee_name, salary
from (select e.employee_id, e.employee_name, e.salary 
      from   employees e
      order by e.salary desc
      limit 2
     ) as sq
order by salary desc
limit 1




