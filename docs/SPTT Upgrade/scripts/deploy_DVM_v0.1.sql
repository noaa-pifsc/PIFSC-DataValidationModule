/************************************************************************************
 Filename   : deploy_DVM_v0.1.sql
 Author     :
 Purpose    : Automated deployment script for version 1.0 of the SPTT Data Validation Module database and upgrades it to the standalone DVM version 0.1 and installs the supporting DB modules
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


PROMPT install required dependencies
@@"../../database-version-control-module/SQL/upgrades/DB_version_control_DDL_DML_upgrade_v0.1.sql"
@@"../../database-version-control-module/SQL/upgrades/DB_version_control_DDL_DML_upgrade_v0.2.sql"

@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.1.sql"
@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.2.sql"
@@"../../database-logging-module/SQL/upgrades/DB_log_DDL_DML_upgrade_v0.3.sql"


PROMPT running DDL scripts
@@"upgrades/DVM_DDL_DML_upgrade_v0.1.sql"


DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
