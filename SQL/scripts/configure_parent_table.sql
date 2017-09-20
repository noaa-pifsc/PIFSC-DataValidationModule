--define the bind parameters to specify the table name, unique key name, and foreign key name to genrate the DDL necessary to update a given parent table and enable it in the data validation module (allows validation error records to be associated with the parent table)
--:table_name is the name of the table that will be configured for the data validation module
--:uk_name is the name of the unique key constraint
--:fk_name is the name of the foreign key constraint on the parent table that references the parent error table


--SQL code to generate the SQL necessary to configure a given data table as a parent record so it can be used in the data validation module.  Copy and paste the code into SQL Developer/Plus and execute on the target database instance to generate the necessary SQL.  Copy and paste the query results to execute on the target database instance:
SELECT 
'ALTER TABLE '||:table_name||' 
ADD (PTA_ERROR_ID NUMBER );


ALTER TABLE '||:table_name||'
ADD CONSTRAINT '||:uk_name||' UNIQUE 
(
  PTA_ERROR_ID 
)
ENABLE;


ALTER TABLE '||:table_name||'
ADD CONSTRAINT '||:fk_name||' FOREIGN KEY
(
  PTA_ERROR_ID 
)
REFERENCES DVM_PTA_ERRORS
(
  PTA_ERROR_ID 
)
ENABLE;

COMMENT ON COLUMN '||:table_name||'.PTA_ERROR_ID IS ''Foreign key reference to the Errors (PTA) intersection table'';' FROM DUAL;