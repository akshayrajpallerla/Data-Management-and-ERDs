--- Problem 1
Create table dep_active
    ( DEPARTMENT_ID NUMBER(4,0), 
        DEPARTMENT_NAME VARCHAR2(30),
        MANAGER_ID    NUMBER(6,0),
        LOCATION_ID NUMBER(4,0),
        AVG_SALARY NUMBER(10,0));
        
Insert into dep_Active (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID,AVG_SALARY) 
select d.DEPARTMENT_ID,d.DEPARTMENT_NAME,d.MANAGER_ID,d.LOCATION_ID, round(avg(e.Salary)) as "AVG_SALARY"
from Departments d 
join Employees e on d.Department_Id=e.Department_Id
group by d.DEPARTMENT_ID,d.DEPARTMENT_NAME,d.MANAGER_ID,d.LOCATION_ID;


--Problem 2
alter table dep_Active add constraint dep_Id_pk primary key (DEPARTMENT_ID);
alter table dep_Active modify LOCATION_ID not null;
alter table dep_Active add constraint m_Id_fk FOREIGN KEY (MANAGER_ID) references EMPLOYEES (EMPLOYEE_ID);

--Problem 3

select r.Region_name as "Region Name", round(Min(e.Salary),3) as "Minimum salary", round(Max(e.Salary),3) as "Maximum salary"
from Regions r
left join countries c on r.region_id = c.region_id 
left join locations l on c.country_id =l.country_id
left  join departments d on l.location_id=d.location_id
left join employees e on d.Department_Id= e.Department_Id 
group by r.Region_name;

--Problem 4

select loc.location_Id as "Location Name", sum(empl.salary) as "Total Salary"
from employees empl 
right join departments depts on depts.department_id = empl.department_id
right join locations loc on loc.location_id = depts.location_id
right join countries cou on cou.country_id = loc.country_id 
right join regions reg on reg.region_id = cou.region_id
where to_char(empl.hire_date,'YYYY') between '1990' and '1999'
group by loc.location_Id;


--Problem 5

select j.job_title as "Job Title", sum(coalesce(empl.Salary,0)) as "Total Salary"
from jobs j left join employees empl  on empl.job_id = j.job_id and to_char(empl.hire_date,'YYYY')
between '1990' and '1999'
group by j.job_title;

--Problem 6

select d.department_id as "Department ID", d.manager_id as "Manager ID", e.last_name as "Manager's Last Name"
from departments d 
left join employees e on e.department_id = d.department_id
where e.department_id in (select employees.department_id 
                            from employees 
                            group by employees.department_id 
                            having count(employees.employee_id) > 1)
and e.employee_id in (select departments.manager_id from departments)
and d.Manager_Id is not NULL
group by d.department_id, d.manager_id, e.last_name;


--- Problem 7

select empl.employee_id, empl.email, emplself.email
from employees empl 
join employees emplself on empl.manager_id = emplself.employee_id
where empl.job_id <> emplself.job_id order by emplself.employee_id desc;

-- Problem 8

select empl.last_name as "Employee's Last Name", empl.salary as "Salary", 
(select job_grades.GRADE_LEVEL from job_grades where empl.salary between job_grades.LOWEST_SAL and job_grades.HIGHEST_SAL) as grade_level
from employees empl 
union
select empl.Last_name, empl.Salary,
(select jg.GRADE_LEVEL from job_grades jg where empl.salary between jg.LOWEST_SAL and jg.HIGHEST_SAL) as grade_level from job_history jh
left join employees empl on empl.Employee_Id= jh.Employee_Id;

--Problem 9

select round(median(empl.salary))as "MedianSal", round(avg(empl.salary)) as "AvgSal", dept.department_name, job.job_title
from employees empl
join jobs job on job.job_id = empl.job_id 
join departments dept on dept.department_id = empl.department_id
where empl.hire_date > (select min(empl2.hire_date) from employees empl2 where empl2.job_id = 'ST_CLERK')
group by dept.department_name, job.job_title
order by dept.department_name, job.job_title;

--Problem 10

select dept.department_id as "Department ID", dept.manager_id as "Manager ID", loc.location_id as "Location ID"
from departments dept 
join locations loc on dept.location_id = loc.location_id
where lower(dept.department_name) like '%a%'
and loc.location_id between 1500 and 1800;

--Problem 11

select empl.last_name, reg.region_name 
from employees empl 
left join departments dept on empl.department_id = dept.department_id
left join locations loc on loc.location_id = loc.location_id
left join countries cou on loc.country_id = cou.country_id
left join regions reg on cou.region_id = reg.region_id;

--Problem 12

select jobgr.grade_level, count(empl.employee_id) as "NoOfDeptManagers"
from departments dept
join employees empl on empl.employee_id = dept.manager_id
right join job_grades jobgr on empl.salary between jobgr.lowest_sal and jobgr.highest_sal
group by jobgr.grade_level
order by jobgr.grade_level;


--Problem 13

select reg.region_name as "Region Name",count(empl.employee_id) as "Number of Employees"
from employees empl 
left join departments dept on empl.department_id = dept.department_id and empl.salary > 5000
left join locations loc on dept.location_id = loc.location_id
left join countries cou on loc.country_id = cou.country_id
right join regions reg on cou.region_id = reg.region_id
group by reg.region_name
order by count(empl.employee_id) desc;


--Problem 14

select empl.employee_id as "ManagerId", empl.salary as "ManagerSalary" 
from employees empl 
where empl.employee_id in (select empl2.manager_id 
                            from employees empl2 
                            group by empl2.manager_id
                            having count(empl2.employee_id) >= 1)
and empl.hire_date < (select min(empl3.hire_date)
                    from employees empl3
                    where empl.employee_id = empl3.manager_id);
    
--Problem 15

select e1.last_name as "Last Name of the Employee", e1.salary as "Employee's Salary", e2.salary - e1.salary as "Diff between Maximum Salary"
from employees e1 
left join employees e2 on e1.job_id = e2.job_id 
where e2.salary = (select max(e3.salary) from employees e3 where e3.job_id = e1.job_id) 
and e2.salary <> e1.salary
and e1.employee_id <> e2.employee_id
union
select e1.last_name, e1.salary, e1.salary
from employees e1 
join employees e2 on e1.job_id = e2.job_id 
where e1.salary = (select max(e3.salary) from employees e3 where e3.job_id = e1.job_id)
and e2.employee_id = e1.employee_id
order by 1;