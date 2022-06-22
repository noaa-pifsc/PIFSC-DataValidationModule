/************************************************************************************
 Filename   : upgrade_dev_0.1_to_1.4.sql
 Author     :
 Purpose    : Automated upgrade script for the Data Validation Module database, this is intended for use on the development environment to upgrade DVM version 0.1 to 1.4
 Description: The release included: data model deployment on a blank schema
 Usage: Using Windows X open a command line window and change the directory to the SQL directory in the working copy of the repository and execute the script using the "@" syntax.  When prompted enter the server credentials in the format defined in the corresponding code comments
************************************************************************************/
SET FEEDBACK ON
SET TRIMSPOOL ON
SET VERIFY OFF
SET SQLBLANKLINES ON
SET AUTOCOMMIT OFF
SET EXITCOMMIT OFF
SET ECHO ON

WHENEVER SQLERROR EXIT 1
WHENEVER OSERROR  EXIT 1

SET DEFINE ON
-- Provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name
-- Provide credentials in the form: USER/PASSWORD@HOSTNAME/SID when specifying hostname and SID values
DEFINE apps_credentials=&1
CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'DVM_upgrade_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;


PROMPT running DDL scripts
@@"upgrades/DVM_DDL_DML_upgrade_v0.2.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.3.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.4.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.5.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.6.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.7.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.8.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.9.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.10.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.11.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.12.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v0.13.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v1.0.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v1.1.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v1.2.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v1.3.sql"
@@"upgrades/DVM_DDL_DML_upgrade_v1.4.sql"


DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
