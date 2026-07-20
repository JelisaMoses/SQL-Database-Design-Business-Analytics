/*
========================================================
University Database Project

Author: Jelisa Moses

Description:
Designed and implemented a relational university database
using SQL. Demonstrates relational database design,
primary and foreign keys, JOINs, GROUP BY, HAVING,
subqueries, Common Table Expressions (CTEs),
window functions, and aggregate analysis.

========================================================
*/

CREATE DATABASE UniversityDB;
GO

USE UniversityDB;
GO

CREATE TABLE department (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50),
    budget DECIMAL(10,2)
);


CREATE TABLE instructor (
    ID INT PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    Salary INT,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE Student (
    ID INT PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    tot_cred INT,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
)

CREATE TABLE course(
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    dept_name VARCHAR(50),
    credits INT,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
)

CREATE TABLE section(
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    building VARCHAR(50),
    room_number VARCHAR(10),
    time_slot_id VARCHAR(10),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

CREATE TABLE teaches (
    ID INT,
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES instructor(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)       
);

CREATE TABLE takes(
    ID INT,
    course_id VARCHAR(10),
    sec_id VARCHAR(10),
    semester VARCHAR(10),
    year INT,
    grade VARCHAR(2),
    PRIMARY KEY(ID, course_id, sec_id, semester, year),
    FOREIGN KEY(ID) REFERENCES student(ID),
    FOREIGN KEY(course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);

CREATE TABLE prereq(
    course_id VARCHAR(10),
    prereq_id VARCHAR(10),
    PRIMARY KEY(course_id, prereq_id),
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(prereq_id) REFERENCES course(course_id)
);


INSERT INTO department VALUES
('Comp. Sci.', 'Taylor', 100000),
('Biology', 'Watson', 90000),
('Physics', 'Newton', 85000);


INSERT INTO instructor VALUES
(10101,'Srinivasan','Comp. Sci.',65000),
(12121,'Wu','Biology',90000),
(15151,'Mozart','Physics',40000);

INSERT INTO student VALUES
(128,'Zhang','Comp. Sci.',102),
(12345,'Shankar','Comp. Sci.',32),
(19991,'Brandt','Biology',80);

INSERT INTO course VALUES
('CS101','Intro to Computer Science','Comp. Sci.',4),
('CS190','Game Design','Comp. Sci.',4),
('BIO101','Intro to Biology','Biology',4);

INSERT INTO section VALUES
('CS101','1','Fall',2017,'Taylor','101','1'),
('CS101','2','Spring',2018,'Taylor','102','2'),
('BIO101','1','Fall',2017,'Watson','201','3');

INSERT INTO teaches VALUES
(10101,'CS101','1','Fall',2017),
(10101,'CS101','2','Spring',2018);

INSERT INTO takes VALUES
(128,'CS101','1','Fall',2017,'A'),
(12345,'CS101','1','Fall',2017,'B');

INSERT INTO prereq VALUES
('CS190','CS101');

SELECT * FROM department;
SELECT * FROM instructor;
SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM section;
SELECT * FROM teaches;
SELECT * FROM takes;
SELECT * FROM prereq;


-- # find course that are  in fall 2017 or in spring 2018
(Select course_id 
From section WHERE semester = 'Fall' and year = 2017)
UNION
(select course_id from section where semester = 'spring' and year = 2018);

-- Find course that ran in fall 2017 and spring 2018

(select course_id from section where semester = 'Fall'and year = 2017)
INTERSECT
(select course_id from section where semester = 'spring' and year = 2018);

--  find courses that ran in fall 2017 but not in spring 2018 
(select course_id from section where semester = 'Fall' and year = 2017)
EXCEPT
(select course_id from section where semester = 'spring' and year = 2018);

--  find courses that ran in spring 2018 but not in fall 2017 
(select course_id from section where semester = 'spring' and year = 2018)
EXCEPT
(select course_id from section where semester = 'Fall' and year = 2017);

-- find courses that ran in spring 2018 and in fall 2017. if a course ran both semesters, show duplicates (intersect all not support)
(select course_id from section where semester = 'fall' and year = 2017)
INTERSECT
(select course_id from section where semester = 'spring' and year = 2017);

-- find computer science courses that ran in fall 2017 or in spring 2018
(Select course_id  From section WHERE semester = 'Fall' and year = 2017 and course_id = 'CS101')
UNION
(select course_id from section where semester = 'spring' and year = 2018 and course_id = 'CS101');

-- Find non computer science courses that ran in fall 2017 or in spring 2018
(Select course_id  From section WHERE semester = 'Fall' and year = 2017 and course_id != 'CS101')
UNION
(select course_id from section where semester = 'spring' and year = 2018 and course_id != 'CS101');

-- or 

(Select course_id  From section WHERE semester = 'Fall' and year = 2017 and course_id not LIKE'CS%')
UNION
(select course_id from section where semester = 'spring' and year = 2018 and course_id not LIKE  'CS%');




-- write a query to display outout of 10 + 0
select 10 + 0

-- what do you think the result of the query below
select 10 + null as OUTPUT;  -- null

-- write a query to find names where salary is greater than null value
Select name from instructor
where salary > null;

-- aggregate function example
-- Find the average salary of instructor in the computer science department
SELECT AVG(salary) 
from instructor
where dept_name = 'Comp. Sci.';

-- find the total number of instructors who teach a course in the spring 2018 semester
select COUNT(distinct ID)
from teaches 
where semester = 'spring' and year = 2018 ;

-- find the number of tuples in the course section 
Select count (*)
from section;

-- find the average salary of instructor in each department 

select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name;

-- find the name and avg salary of all department whose average salary is greater than 4200 
select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name
having avg(salary) > 4200;

-- Find course offered in fall 2017 and in spring 2018(subquery)
select distinct course_id 
from section 
where semester ='Fall' and year = 2017 and 
        course_id in (select course_id 
        from section 
        where semester = 'Spring' and year = 2018);

-- find courses offered in fall 2017 but not in spring 2018

SELECT distinct course_id
from section
where semester='Fall' and year = 2017 and 
        course_id NOT in (SELECT course_id
        from section
        where semester='Spring'and year=2018);

-- Name all instructors whose name is neither "mozart" nor "Einstein"

select distinct name
from instructor
where name not in('Mozart','Einstein')

-- Find the total number of (distinct) students who have taken course sections taught by the instructor with ID 10101
SELECT count(distinct ID)
from takes
where(course_id, sec_id, semester, year) in 
                        (select course_id, sec_id, semester,year
                        from teaches
                        where teaches.ID=10101);


-- Fix Option 1: Use EXISTS (BEST)
SELECT COUNT(DISTINCT ID)
FROM takes t
WHERE EXISTS (
    SELECT 1
    FROM teaches te
    WHERE te.ID = 10101
      AND te.course_id = t.course_id
      AND te.sec_id = t.sec_id
      AND te.semester = t.semester
      AND te.year = t.year
);

-- Fix Option 2: Use JOIN
SELECT COUNT(DISTINCT t.ID)
FROM takes t
JOIN teaches te
  ON t.course_id = te.course_id
 AND t.sec_id = te.sec_id
 AND t.semester = te.semester
 AND t.year = te.year
WHERE te.ID = 10101;

-- Find names of instructors with salary greater than that of some (at least one) instructor in the Biology department.
-- "some" clause
SELECT DISTINCT T.name
FROM instructor as T,instructor as S
Where T.salary>S.salary and S.dept_name='Biology';

-- same query using>some clause
select name
from instructor
where salary> some(select salary
from instructor
where dept_name ='Biology')

-- Find the names of all instructors whose salary is greater than the salary of all instructors in the biologyv department 
-- "all" clause
Select name
from instructor
where salary > all(select salary
from instructor
where dept_name = 'Biology');

-- use the 'exist' clause
-- yet another way of specifying the query "Find all course taught in both the fall 2017 semester and in the spring 2018 semester"
SELECT course_id
from section as S
where semester ='Fall' and year = 2017 AND
    EXISTS(select *
        from section as T
        WHERE semester = 'spring' and year = 2018
        and S.course_id = T.course_id);

--Use of “not exists” Clause
-- Find all students who have taken all courses offered in the Biology department.  

select distinct S.ID, S.name
from student as S
where not exists ( (select course_id
from course
where dept_name = 'Biology')
except
(select T.course_id
from takes as T
where S.ID = T.ID));

--Test for Absence of Duplicate Tuples
select T.course_id
from course as T
where unique (select R.course_id
            from section as R
            where T.course_id = R.course_id
            and R.year = 2017);

-- Subqueries in the Form Clause
--  Find the average instructors’ salaries of those departments where the average salary is greater than $42,000.”

Select dept_name, avg_salary
from ( select dept_name, avg (salary) as avg_salary
            from instructor
            group by dept_name)
            where avg_salary > 42000; --(MSS does not suppose this query )


--Another way to write above query

select dept_name, avg_salary
from ( select dept_name, avg (salary)
from instructor
group by dept_name)
as dept_avg (dept_name, avg_salary)
where avg_salary > 42000;

-- With Clause
-- Find all departments with the maximum budget

with max_budget (value) as
(select max(budget)
from department)
select department.name
from department, max_budget
where department.budget = max_budget.value;

-- Complex Queries using With Clause
-- Find all departments where the total salary is greater than the average of the total salary at all departments

with dept_total (dept_name, value) as
(select dept_name, sum(salary)
from instructor
group by dept_name),
dept_total_avg(value) as
(select avg(value)
from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value > dept_total_avg.value;

-- Scalar Subquery
--List all departments along with the number of instructors in each department

select dept_name,
(select count(*)
from instructor
where department.dept_name = instructor.dept_name)
as num_instructors
from department;


-- Deletion
--  Delete all instructors
delete from instructor
-- Delete all instructors from the Finance department
        delete from instructor
        where dept_name= 'Finance';

-- Delete all tuples in the instructor relation for those instructors associated with a department located in the Watson building.

delete from instructor
where dept_name in (select dept name
                    from department
                    where building = 'Watson');


-- Delete all instructors with a salary between 20000 and 30000
Delete from instructor
where salary between 20000 and 30000;


-- Add a new course ids610 with only department name IDS 610 to the course 
INSERT into course(course_id, dept_name)
VALUES('IDS610', 'IDS');

-- Updates
-- Give a 5% salary raise to all instructors
  update instructor
  set salary = salary * 1.05
-- Give a 5% salary raise to those instructors who earn less than 70000
    update instructor
    set salary = salary * 1.05
    where salary < 70000;
-- Give a 5% salary raise to instructors whose salary is less than average
    update instructor
    set salary = salary * 1.05
    where salary < Avg(salary);

    
