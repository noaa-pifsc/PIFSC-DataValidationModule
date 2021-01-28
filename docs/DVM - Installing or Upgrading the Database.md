# Data Validation Module - Installing or Upgrading the Database
## Resources:
- [Data Validation Module Documentation](./Data%20Validation%20Module%20Documentation.md)

## Procedure:
- New installation: If you are installing this module on a database instance for the first time run the [SQL/DVM_combined_DDL_DML.sql](../SQL/DVM_combined_DDL_DML.sql) script.
- Upgrading an existing installation: You must first determine which version of the PIFSC Data Set Database is currently installed by querying the DB_UPGRADE_LOGS_V view with the UPGRADE_APP_NAME = 'Data Validation Module'.  The highest UPGRADE_VERSION value is the currently installed database version (e.g. 0.3).  The scripts (DVM_DB_DDL_DML_update_v[MAJOR].[MINOR].sql where [MAJOR] is the major version number and [MINOR] is the minor version number) in the [SQL/upgrades](../SQL/upgrades) folder will be run in order to upgrade the database to the desired version.  For instance if the current version of the database is 0.3 and the desired database version is 0.5 the DVM_DB_DDL_DML_update_v0.4.sql and DVM_DB_DDL_DML_update_v0.5.sql files will be executed on the database instance in that order to perform the upgrade.  
- **Note: This database utilizes the [Database Version Control Module (VCM)](https://github.com/PIFSC-NMFS-NOAA/Database-Version-Control-Module), the [VCM SOP](https://github.com/PIFSC-NMFS-NOAA/Database-Version-Control-Module/blob/master/docs/DB%20Version%20Control%20Module%20SOP.MD) contains detailed information for the general database version control policies
