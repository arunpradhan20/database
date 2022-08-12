/*
Author: Arun Pradhan
Description: This script will grant the DML privileges on all the tables of schema to user/role.
             for Best Practice grant the privileges to role and assign role to users  
*/

set serveroutput on
DECLARE
  v_owner VARCHAR2(30) := 'SCHEMA_NAME';
  v_user  VARCHAR2(30) := 'GRANTEE_NAME';
        
  CURSOR c1_table IS
  SELECT table_name
  FROM   dba_tables
  WHERE  owner = v_owner;

  stmt VARCHAR2(200);
BEGIN
  FOR c1 IN c1_table LOOP
    stmt := 'grant select, insert, update, delete, alter on '||v_owner||'.' || c1.table_name || ' to '||v_user;
    dbms_output.put_line('Granting privileges to '||v_user||' on: ' || c1.table_name);
    EXECUTE IMMEDIATE stmt;
  END LOOP;
END;
/