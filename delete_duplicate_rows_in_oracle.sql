--How to Delete Duplicate Records in Oracle

--Create table and Insert Data including duplicates
create table t_demo_dups (store_name varchar2(30), store_type varchar2(30), headoffice varchar2(30) ); 

INSERT INTO t_demo_dups values ('Marshalla','Department Store','MA');
INSERT INTO t_demo_dups values ('Marshalla','Department Store','MA');
INSERT INTO t_demo_dups values ('Marshalla','Department Store','MA');
INSERT INTO t_demo_dups values ('Safewey','Grocery Store','CA');
INSERT INTO t_demo_dups values ('Safewey','Grocery Store','CA');
INSERT INTO t_demo_dups values ('Lusky','Grocery Store','CA');
INSERT INTO t_demo_dups values ('Lusky','Grocery Store','CA');
INSERT INTO t_demo_dups values ('NordStore','Clothing','CA');
INSERT INTO t_demo_dups values ('Lusky','Grocery Store','CA');
INSERT INTO t_demo_dups values ('Lusky','Grocery Store','CA');
INSERT INTO t_demo_dups values ('DJ''s','WHOLESALE','CA');
INSERT INTO t_demo_dups values ('DJ''s','WHOLESALE','CA');
INSERT INTO t_demo_dups values ('DJ''s','WHOLESALE','CA');
INSERT INTO t_demo_dups values ('DJ''s','WHOLESALE','CA');
INSERT INTO t_demo_dups values ('Old Nawy','Clothing','CA');
INSERT INTO t_demo_dups values ('Old Nawy','Clothing','CA');

--Count the number of rows in tables
SELECT count(1) FROM t_demo_dups;

--Check the distinct values or do the coutn
SELECT distinct store_name,store_type,headoffice FROM t_demo_dups;

--Delete the duplicate data using rowid and min function, alternatively you can use MAX function as well. 
--Inner query will group all the duplicate rows into groups. The outer delete stmt will delete all but one with min rowid for each group of duplicates.

DELETE FROM t_demo_dups
WHERE rowid NOT IN
    (SELECT min(rowid) FROM t_demo_dups 
        GROUP BY store_name,store_type,headoffice); 

--Check the data and compare using distinct as well
SELECT * FROM t_demo_dups;