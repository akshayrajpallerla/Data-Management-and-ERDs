--Solution 1

select min(salary), max(salary) from employees
where department_id in ('60','90','110');

--Solution 2

select job_id, 
case when job_id like 'IT%' then add_months(hire_date,9)
    when job_id like 'AC%' then add_months(hire_date,12)
    when job_id like 'MK%' then add_months(hire_date,12)
    else add_months(hire_date,6)
    end as "Probation period"
from employees;

--Solution 3

select job_id, 
case when job_id like '%IT%' then salary*0.1
    when job_id like '%AD%' then salary*0.05
    when job_id like '%ST%' then salary*0.2
    when job_id like '%SA%' then salary*0.3
    when job_id like '%MK%' then salary*0.15
    else NULL
    end as "Bonus"
from employees;

--Solution 4

select last_name, department_id, NVL(commission_pct,round(salary/100000,2)) as "commission percentage"
from employees
where salary>6000
order by department_id desc;

--Solution 5

select count(*) as "number of employees", job_id
from employees
group by job_id
having median(salary)>7000;

--Solution 6

select avg(salary), variance(salary)
from employees
where hire_date>TO_DATE('31-DEC-1990','DD-Mon-YYYY');

--Solution 7

select min(max(salary)) , max(max(salary))
from employees
where commission_pct is null
group by department_id;

--Solution 8

select count(*), avg(salary)
from employees
group by to_char(hire_date,'fmD');

--Solution 9

select max(sysdate-hire_date)-min(sysdate-hire_date) as "number of days" from employees
group by manager_id
order by "number of days" desc;

--Solution 10

select department_id as "Department ID", count(distinct job_id) as "count of job types", avg(salary) as "average salary" 
from employees
where job_id is not null and department_id is not null
group by department_id
having median(salary)<8000 and count( distinct job_id)>=3;

--Solution 11

select count(employee_id) as "Number of employees", round(avg(salary),2) as "Average"
from employees
where to_char(hire_date,'DD-Mon-YYYY')<TO_DATE('&value','DD-Mon-YYYY')
group by department_id
order by "Average";

--Solution 12

select case when salary < 7000 then 'Group1'
            when salary between 7000 and 10000 then 'Group2'
            when salary > 10000 then 'Group3'
            end as "Groups", count(employee_id) as "Total number of employees"           
from employees
group by 
case when salary < 7000 then 'Group1'
            when salary between 7000 and 10000 then 'Group2'
            when salary > 10000 then 'Group3'
            end
order by "Total number of employees";

--Solution 13

select  distinct(trunc((months_between(end_date,start_date))/12)) as "Years" , count(employee_id) as "Number of employees"
from job_history
group by trunc((months_between(end_date,start_date))/12)
order by "Years";

--Solution 14

select count(*) as "Total employees",
       count(case when to_char(hire_date,'Q')=1 then 1 end) as "Number of employees in Q1",
       count(case when to_char(hire_date,'Q')=2 then 1 end) as "Number of employees in Q2",
       count(case when to_char(hire_date,'Q')=3 then 1 end) as "Number of employees in Q3",
       count(case when to_char(hire_date,'Q')=4 then 1 end) as "Number of employees in Q4"
from employees  
where job_id like '%S%';

--Solution 15

select  to_char(hire_date,'MONTH') as "Month", count(employee_id)
from employees
group by to_char(hire_date,'MONTH')
order by to_date("Month",'MM');

--Solution 16

select count(distinct employee_id) "Total employees", avg(salary) as "Average", 
sum( case when lower(job_id)=lower('&&input_your_jobid') 
then 
(case when salary>=&input_salary then 1 else 0 end)
else 0
end  )
 as "Required count"
from employees 
where lower(job_id)=lower('&&input_your_jobid') 
group by department_id;
undefine input_your_jobid;

--Solution 16

select count(distinct employee_id) "Total employees", avg(salary) as "Average", 
sum(case when salary>=&input_salary then 1 else 0 end) as "Required count"
from employees
where lower(job_id)=lower('&input_your_jobid')
group by department_id;
