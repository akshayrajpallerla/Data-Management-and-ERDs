--Solution1
select department_name from departments 
where manager_id is null and location_id<=1700;


--Solution2
select last_name,phone_number from employees
where (last_name like 'K%' or last_name like 'M%') and (phone_number like '%4');


--Solution3
select last_name from employees
where last_name like '%o%' and salary>=4000;


--Solution4
select first_name||' '||last_name as "Full Name", 
email||'@gmail.com' as "Email ID", 
department_id||q'('s)'||manager_id as "Manager Info" from employees;


--Solution5
select last_name as "New Employee", hire_date as "Hire Date", round(MONTHS_BETWEEN(SYSDATE,hire_date))||' months approximately' as "Tenure" from employees 
where months_between('01-Jan-2001',hire_date)<20;


--Solution6
select * from employees
where hire_date > (LAST_DAY(hire_date)-7);


--Solution7
select first_name, last_name,
NVL(commission_pct, salary/20000) as "new_commission_pct"  from employees;


--Solution8
select last_name, substr(phone_number,1,instr(phone_number,'.')-1) as "country code",
substr(phone_number,instr(phone_number,'.')+1) from employees as "local phone number"
where length(replace(phone_number,'.',''))>10;


--Solution9
select to_char(sysdate, 'DD-MM-YYYY HH:MM:SS AM') from dual;


--Solution10
select start_date, end_date,
trunc ((months_between(end_date,start_date))/12) as "Years",
trunc(mod(months_between(end_date,start_date),12)) as "Months",
trunc(end_date-add_months(start_date,trunc(months_between(end_date,start_date)))) as "Days"
from job_history;


--Solution11
select rpad(substr(last_name,1,10),round(salary/1000),'*') as "EMPLOYEES AND THEIR SALARIES" , salary 
from employees order by salary desc;


--Solution12
select * from jobs where min_salary >= 4000 and max_salary<=20000 and job_id like 'A%\_M%' escape '\';


--Solution13
select first_name, last_name
from employees
where upper(last_name) not like upper('%&&value%') and upper(first_name) like upper('%&&value%&&value%');
undefine value;


--Solution14
select last_name, first_name,
case when manager_id is null then 0 else (round(months_between(sysdate,hire_date))*salary)/1000 end as "Bonus"
from employees order by case when manager_id is null then 0 else (round(months_between(sysdate,hire_date))*salary)/1000 end;


--Solution15
select employee_id,hire_date ,
case when trim(to_char(add_months(hire_date, 12*25),'Day'))='Friday'
then add_months(hire_date, 12*25) else next_day(add_months(hire_date, 12*25),'Friday') end as "ELIGIBILITY DATE"
from employees;


--Solution16
select last_name,job_id from employees where trim(to_char(hire_date,'Day'))='Saturday'


--Solution17
select distinct manager_id,department_id, job_id from employees 
where salary < &value
order by manager_id desc, job_id;
undefine value;


--Solution18
select last_name from employees where email like '____l%' or email like '____L%' order by substr(email,3,1);


--Solution19
select last_name from employees where mod(salary,3000)=0;


--Solution20, one method

select last_name, translate(lower(last_name),'sae','AES') as "new last name" from employees
order by translate(lower(last_name),'sae','AES') desc;

--Solution20, another method

SELECT last_name,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(last_name, 'S', '1'), 's', '1'), 'A', '2'), 'a', '2'), 'E', '3'), 'e', '3'), '1', 'A'), '2', 'E'), '3', 'S') as "new last name" from employees
order by translate(lower(last_name),'sae','AES') desc;
