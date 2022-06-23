/************************************************************************************
 Filename   : deploy_SPTT_v1.0_to_DVM_0.1.sql
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
SELECT 'SPTT_DVM_deploy_upgrade_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT install required dependencies
@@"../../database-version-control-module/SQL/upgrades/DB_version_control_DDL_DML_upgrade_v0.1.sql"
@@"../../database-version-control-module/SQL/upgrades/DB_version_control_DDL_DML_upgrade_v0.2.sql"

@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.1.sql"
@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.2.sql"
@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.3.sql"


PROMPT running DDL scripts
@@"../docs/SPTT Upgrade/scripts/SPTT Validation Tables DDL.sql"
@@"../docs/SPTT Upgrade/scripts/SPTT Validation Views Packages DDL.sql"

PROMPT upgrade the SPTT DVM to the standalone DVM version 0.1
@@"../docs/SPTT Upgrade/scripts/SPTT_v1.0_to_DVM_v0.1.sql"

PROMPT load DB Upgrade record for the initial version of the standalone DVM (version 0.1)
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '0.1', TO_DATE('20-SEP-17', 'DD-MON-YY'), 'Initial implementation of the DB Version Control Module, created all necessary folders and files to define version 0.1 of the DVM');


DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
