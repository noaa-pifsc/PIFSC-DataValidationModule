Database Version Control Module Repository: git@pichub.pifsc.gov:application-development/centralized-tools.git in the DB_version_control folder

This directory contains all DDL and DML commands to define the database structure and data (relevant reference data or application data but not any actual data that is being managed in the database) for the application(s) contained in the code repository.  

Defining Versions:
Each database version is defined as [MAJOR].[MINOR] where [MAJOR] is the major version of the database and [MINOR] is the minor version of the database, both the major and minor version values are integers starting from zero that are incremented by one without a leading zero.  The exception to the rule is that the first version of a database should be 0.1.  Otherwise when each major version is incremented the minor version should be reset to 0 for that major version (e.g. version 3.0).  The major and minor versions are up to the discretion of the developers.  

Database Upgrade Logs:
A simple modular database structure is implemented to track database upgrades over time in a given database instance so that all database upgrades applied are clearly identified.  Each upgrade applied to a given database adds a record into the database upgrade table to indicate that the upgrade has been applied (the template for database upgrade log entries can be found in DB_version_control_templates.txt under the "Database Upgrade Templates" section).  Based on the current version of a given database instance and a desired version the database upgrades can be easily applied to upgrade the instance.

Upgrade files:
The "upgrades" folder contains each individual database upgrade file that is necessary to apply a given database upgrade.  The naming convention is [DATABASE NAME]_DDL_DML_upgrade_v[MAJOR].[MINOR].sql.  For example [DATABASE NAME]_DDL_DML_upgrade_v0.1.sql is the first minor version of a given database.  Each upgrade must be able to be executed on a blank schema in order (major/minor version) from first to last to define the database to a given version.  Executing a given [DATABASE NAME]_DDL_DML_upgrade_v[MAJOR].[MINOR].sql version on a database of the previous version will upgrade the database version to the given [MAJOR].[MINOR] version (e.g. executing [DATABASE NAME]_DDL_DML_upgrade_v1.14.sql will upgrade an instance of the v1.13 database to v1.14).  Each upgrade file will contain a SQL statement to define and describe the upgrade in the Database Version Control Module.  The template for the headings used in the upgrade files can be found in DB_version_control_templates.txt under the "Database Upgrade Templates" section.

Combined file:
The database root directory contains a combined DDL/DML file ([DATABASE NAME]_combined_DDL_DML.sql where [DATABASE NAME] is the name of the database with underscores instead of spaces) that will deploy the given database version on a blank database instance.  The combined DDL/DML file will be updated each time a new database upgrade has been developed to append the DDL/DML from the upgrade file to the end of the combined DDL/DML file so that the combined file contains all of the DDL/DML necessary to generate the necessary objects and reference/application data for a new database deployment.  The template for the headings used in the combined file can be found in DB_version_control_templates.txt under the "Database Upgrade Templates" section.

Code Commit and Database Upgrade Templates:
The database root directory contains a DB_version_control_templates.txt file that provides some standard templates for code commit messages and database upgrade files.  These can be modified to be project-specific so they can be easily copied and pasted into commit messages and database upgrade files.  Each line in the template file that starts with "**" is informational and will not be actually added to the commit message.  The first section (Code Commit Templates) contains templates for code commits and the second section (Database Upgrade Templates) contains templates for database upgrade files.  Placeholders (indicated by brackets) will be replaced with actual content as indicated in the informational content.  

Code Commits:
When application/database code is committed to a version control system clearly document each version of the database and associated application(s) to clearly identify which database version is required for a given application/module version.  Each code commit clearly identifies what version of the database is defined or used.  The template for code commits can be found in DB_version_control_templates.txt under the "Code Commit Templates" section.

Not every application update will necessitate a corresponding database update but each code commit should have its comments reference the version of the database it uses so that the database and application code versions on any master branch commit are in sync.



Database version control structure for a shared database for multiple applications/modules in one repository that use the same database (e.g. PIFSC Data Set Database):

root folder (directory) - also known as "database root directory"
|
|
|
-----shared_SQL (directory)
     |
     |
     |
     -----[DATABASE NAME]_combined_DDL_DML.sql
     |
     |
     |
     -----README.txt (this file)
     |
     |
     |
     -----DB_version_control_templates.txt
     |
     |
     |
     -----upgrades (directory)
          |
          |
          |
          -----[DATABASE NAME]_DDL_DML_upgrade_v[MAJOR].[MINOR].sql (multiple files)

     
Database version control structure for repositories that have a dedicated database model that is not shared between multiple applications/modules (e.g. Database Version Control Module):

Module folder (directory)
|
|
|
-----SQL (directory) - also known as "database root directory"
     |
     |
     |
     -----[DATABASE NAME]_combined_DDL_DML.sql
     |
     |
     |
     -----README.txt (this file)
     |
     |
     |
     -----DB_version_control_templates.txt
     |
     |
     |
     -----upgrades (directory)
          |
          |
          |
          -----[DATABASE NAME]_DDL_DML_upgrade_v[MAJOR].[MINOR].sql (multiple files)