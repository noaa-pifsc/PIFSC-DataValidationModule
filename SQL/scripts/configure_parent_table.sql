--define the bind parameters to specify the table name, unique key name, and foreign key name to generate the DDL necessary to update a given parent table and enable it in the data validation module (allows validation issue records to be associated with the parent table)
--:table_name is the name of the table that will be configured for the data validation module
--:uk_name is the name of the unique key constraint
--:fk_name is the name of the foreign key constraint on the parent table that references the parent issue table


--SQL code to generate the SQL necessary to configure a given data table as a parent record so it can be used in the data validation module.  Copy and paste the code into SQL Developer/Plus and execute on the target database instance to generate the necessary SQL.  Copy and paste the query results to execute on the target database instance:
SELECT 'ALTER TABLE '||:table_name||' ADD (PTA_ISS_ID NUMBER );'||CHR(10)||'ALTER TABLE '||:table_name||' ADD CONSTRAINT '||:uk_name||' UNIQUE (PTA_ISS_ID) ENABLE; '||CHR(10)||'ALTER TABLE '||:table_name||' ADD CONSTRAINT '||:fk_name||' FOREIGN KEY (PTA_ISS_ID) REFERENCES DVM_PTA_ISSUES (PTA_ISS_ID) ENABLE; '||CHR(10)||'COMMENT ON COLUMN '||:table_name||'.PTA_ISS_ID IS ''Foreign key reference to the DVM Issues (PTA) intersection table'';' FROM DUAL;
