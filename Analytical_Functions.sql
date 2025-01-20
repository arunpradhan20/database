---------------------------------------------------------------------------------------
--Analytical Functions                                                               --
--Covers                                                                             --
--  --Aggregate Function                                                             --
--  --over()                                                                         --
--  --partition by                                                                   --
--  --Window Clause                                                                  --
--  --Functions:                                                                     --
--      row_number()                                                                 --
--      rank()                                                                       --
--      dense_rank()                                                                 --
--      LEAD(<expression>,<offset>,<default>) over(<analytic clause>)                --
--      LAG(<expression>,<offset>,<default>) over(<analytic clause>)                 --
--      FIRST_VALUE                                                                  --
--      LAST_VALUE                                                                   --
---------------------------------------------------------------------------------------        

--Create table and Insert data using Emp_Dept_TableCreation files     
--Examine the Tables 
SELECT * from dept;
SELECT * from emp;

--Query using aggregate function
--This will give you aggregated result only
SELECT count(*) FROM emp;
SELECT min(hiredate) FROM emp;
SELECT max(sal) FROM emp;
SELECT sum(sal) FROM emp;
SELECT deptno,avg(sal) FROM emp group by deptno;
SELECT deptno,sum(sal) FROM emp group by deptno;

--Starting with Analytical Functions
--Using count with Analytical function will give you all the rows and count on each row
--"Over()" is mandatory field for Analytical Functions

--Since we did not give any arguement inside over() it assumes the scope is all.
SELECT deptno, count(*) over() dept_count FROM emp;

--Now if we specify (Partition By deptno) within over() then it will give count for each department
--Partition By is used to Group rows in Analytical Function(same as group by in aggregate functions)
SELECT deptno, count(*) over(partition by deptno) dept_count FROM emp;

--Same thing can be done joining the dept table to get more information
SELECT e.deptno,ename,job,
       count(*) over( partition by d.deptno) dept_count 
FROM emp e,dept d
WHERE e.deptno=d.deptno;

--Get the Max Salary for Each Dept
SELECT e.deptno,ename,job,loc, sal,
      max(sal) over( partition by d.deptno) Dept_MaxSalary 
FROM emp e,dept d
WHERE e.deptno=d.deptno
order by deptno,sal;

--Get the Max, Min and Average Salary for each Job Types
SELECT e.deptno,ename,job,loc,hiredate, sal Employee_Salary,
round(avg(sal) over( partition by JOB),2) Avg_Salary,
      min(sal) over( partition by JOB) JOB_MinSalary,
      max(sal) over( partition by JOB) JOB_MaxSalary
FROM emp e,dept d
WHERE e.deptno=d.deptno
order by job,sal;

--Order by can be used inside over() as well
SELECT e.deptno,ename,job,loc,hiredate, sal Employee_Salary,
round(avg(sal) over( partition by JOB ORDER BY sal),2) Avg_Salary,
      min(sal) over( partition by JOB ) JOB_MinSalary,
      max(sal) over( partition by JOB) JOB_MaxSalary
FROM emp e,dept d
WHERE e.deptno=d.deptno
order by job;


SELECT e.deptno,ename,job,loc,hiredate, sal Employee_Salary,
      sum(sal) over( partition by d.deptno ORDER BY sal) Dept_Salary_RunningTotal,
      sum(sal) over( partition by d.deptno) Dept_TotalSalary
FROM emp e,dept d
WHERE e.deptno=d.deptno;

--ROW_NUMBER 
--It is used to give serial number to a set of records.
--ORDER by is needed for this
SELECT ename,job,sal, deptno,
       row_number() over (order by sal desc ) rownumber 
FROM emp;

--ROW_NUMBER to get serial for each dept
SELECT ename,hiredate,deptno,
       row_number() over (partition by deptno order by hiredate) rownumber 
FROM emp;

--RANK
--Rank also gives the serial number but gives the same number incase of duplicate rows.
SELECT ename,hiredate,deptno,sal,
       rank() over (order by sal desc) Rank 
FROM emp;

--DENSE_RANK()
--DENSE_RANK also give serial number but it it will not skip the numbers while assigning to duplicate
--Check the difference between ROWNUMBER,RANK and DENSE_RANK(see rownumber 2 and 10)
SELECT ename,deptno,sal,
       row_number() over (order by sal desc) ROWNUMBER,
       rank() over (order by sal desc) RANK,
       dense_rank() over (order by sal desc) DENSE_RANK 
FROM emp;


--Lead And Lag
--LEAD(<expression>,<offset>,<default>) over(<analytic clause>)
--Lead allows to apply computation on the next row.

SELECT ename,sal,
        lead(sal,1,0) over(partition by deptno order by sal desc) next_low_sal
FROM emp
 where deptno=10;

--Lag points to previous rows
SELECT ename,sal,
        lag(sal,1,0) over(partition by deptno order by sal desc) prev_high_sal
FROM emp
 where deptno=10;
 
 
 --FIRST_VALUE and LAST_VALUE
SELECT ename,sal,hiredate,
       FIRST_VALUE(hiredate) over(order by hiredate) FirstValue,
       hiredate-FIRST_VALUE(hiredate) over(order by hiredate) no_of_days
FROM emp
where deptno=10;

SELECT ename,sal,hiredate,
       LAST_VALUE(hiredate) over(order by hiredate) LastValue
FROM emp
where deptno=10;

--WINDOW Clause
--[ROW or RANGE] BETWEEN <start_expr> AND <end_expr>
--<start_expr> UNBOUNDED PRECEDING |CURRENT ROW -- <sql_expr> PRECEDING or FOLLOWING.
--<end_expr> UNBOUNDED FOLLOWING |CURRENT ROW or <sql_expr> PRECEDING or FOLLOWING



SELECT DISTINCT deptno, LAST_VALUE(sal)
 OVER (PARTITION BY deptno ORDER BY sal ASC
       RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS "HIGHEST"
FROM emp
WHERE deptno in (10,20)
ORDER BY deptno;

SELECT ename,hiredate,sal,
        max(sal) over(order by hiredate,ename 
         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) max_before_sal
FROM emp;