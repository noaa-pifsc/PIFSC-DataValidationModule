




# Data Validation Module Documentation
## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in a given Oracle database based on flexible data validation criteria that can be developed and implemented in Oracle Views by a data manager/developer without requiring application development skills.  A series of data QC Views can be developed to identify problematic values in the database and implemented in the framework to allow each validation rule to be evaluated on the given Data Stream.  A given Parent Record (e.g. CCD_CRUISES) defined for a given Data Stream (e.g. CCD for the Centralized Cruise Database) and all associated child records (e.g. CCD_CRUISE_LEGS, CCD_CRUISE_SPP_ESA, etc.) will be validated as a group based on the data QC Views defined.  Each data issue that is identified will be saved as a separate Validation Issue record (DVM_ISSUES) that includes detailed information about the type of issue and an associated issue description that provides contextual information that will allow a given Validation Issue to be quickly identified, these issue records are associated with the Parent Issue record (DVM_PTA_ISSUES).  The Validation Issue records can be easily queried and provided to data management staff for inspection and resolution.  Standard DVM Reports are available to provide information about the Validation Rules that were utilized over time.

## Resources:
- DVM Version Control Information:
  - URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git
  - Database: 1.0 (Git tag: DVM_db_v1.0)
- [Database Table/View Comments](./DVM_table_view_comments.xlsx)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
- [Database Diagram](./Data%20Validation%20Module%20DB%20Diagram.pdf)
- [Database Naming Conventions](./DVM%20DB%20Naming%20Conventions.MD)
- [How to Define Criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- [PL/SQL Naming Conventions](./DVM%20-%20PL%20SQL%20Coding%20Conventions.MD)
- [Business Rules](./DVM%20-%20Business%20Rule%20Documentation.MD)

## Terms Used:
- Data QC Views - These QC views are defined to identify problematic data issues in the data being managed in a given database.
- Data Stream - Each data stream represents a collection of data tables that are related to each other and represent a data collection.  Multiple data streams (e.g. fish, coral, oceanography) can belong to a single data set (e.g. Coral Reef Ecosystem)   
- DVM Configuration QC Views - These QC views are defined to ensure the DVM configuration is valid before the module is processed.
- Parent Issue Record (DVM_PTA_ISSUES) - The parent record that all Validation Issue records are associated with when the DVM is processed.  
- Parent Record - The parent record for all child records in a given data stream.  Each parent record has a foreign key reference (PTA_ISS_ID) to the associated parent issue record.  
  - For example the CCD_CRUISES table contains the parent records for the CCD data stream
- Data QC Views (DVM_QC_OBJECTS) - These records define the different data QC views that are used to identify Validation Issues based on the associated Validation Rules
- Validation Issue record (DVM_ISSUES) - These records represent individual instances of data validation issues identified by the DVM and are associated with Parent Issue records.
- Validation Rule Set (DVM_RULE_SETS) - These records define the different sets of validation rules that have been used to evaluate Parent Records over time.  They are associated with specific Validation Rules that were active for the given data stream during a given period.  Each Validation Rule Set has a date range defined for it to track when it was created (indicates when it was first used) and an inactive date (to indicate when it was deactivated).  Only one Validation Rule Set for each data stream can be active at a given time.  
- Validation Rules (DVM_ISS_TYPES) - These records represent the individual data QC criteria that are defined for a given Data Stream.  Each is associated with a data QC view that is executed to identify the corresponding Validation Issues.  Validation Rules can be deactivated so they are no longer evaluated on new Parent Records but they will continue being evaluated on existing Parent Records that have previously been evaluated with the corresponding Validation Rules.  

## <a name="database_setup"></a>Database Setup:
- Install version 0.2 (git tag: db_vers_ctrl_db_v0.2) of the DB Version Control Module (VCM) Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_version_control folder)
  - This module utilizes v0.13 of the VCM (git tag: db_vers_ctrl_v0.13)
- Install version 0.2 (git tag: db_log_db_v0.2) of the DB Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_log folder)
- [Installing or Upgrading the DVM Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
- ****Note**: If this is an upgrade between version 0.4 and 0.5 and it has previously been used to validate records the database instance must be migrated using a [specific approach](./version_0.5_upgrade_SOP.MD).  If the DVM has not been previously used to validate data then disregard this note.

## Features:
- Point in time architecture (PTA): The module will associate the given parent record with the active Validation Rule Set(s) that were active at the time that the given parent record was first validated by the module for the specified Data Stream(s).  This will allow the given Parent Record to be re-validated with the same Validation Rules over time so new Validation Rules will not be evaluated on older data which can potentially cause problems.
- Standard Validation Criteria Reports
  - The DVM_RULE_SETS_RPT_V view provides the specific data quality control criteria that was used to validate each Data Stream over time.  This standard report can be included with the data set metadata.
  - The DVM_PTA_RULE_SETS_RPT_V view provides the specific data quality control criteria that was used to validate each Parent Record if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
  - The DVM_DS_PTA_RULE_SETS_HIST_V view provides the DVM Validation Rule Set evaluation history for each Parent Record if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
  - The DVM_PTA_RULE_SETS_HIST_RPT_V view provides information about each time the DVM was evaluated for which specific Validation Rules on a given Parent Record for each Data Stream if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
 - [DVM Configuration QC Views](#DVM_config_QC)
- DVM Testing
 - Refer to the DVM Testing Documentation (docs/test cases/DVM_PKG/Centralized Cruise Database DVM Testing Documentation.docx) in the Centralized Cruise Database (CCD) Git repository (git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git).  The git tag for the current DVM version (e.g. DVM_db_v1.0) is also defined on the version of the CCD repository that contains the corresponding DVM test cases.  


## Implementation
- Current Implementation
	- Standalone PL/SQL Package (DVM_PKG) that can be executed to validate any parent record that has been configured and enabled in the DVM.  The behavior of the module depends on the state of the given Parent Record.  The first time a Parent Record is evaluated for a given Data Stream it will save the active Validation Rules for future DVM processing and all Validation Issue records will be associated with the Parent Issue Record.  All subsequent times a Parent Record is evaluated for a given Data Stream it will re-use the saved Validation Rules and remove all obsolete Validation Issues (indicates that the underlying cause of the validation has been resolved) for the given Data Stream and add all newly identified Validation Issues (indicates that there are new Validation Issues identified).
	- Data QC Queries are implemented for groups of tables that comprise a Data Stream and the resultant Validation Issue records are associated with the given Parent Issue record for a given Data Stream.  
  - User Defined Exceptions were implemented for error handling in the DVM: [DVM Business Rules](./DVM%20-%20Business%20Rules.xlsx) (where the "Scope" column is "DVM Processing Errors")
- [How to define data validation criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- Validation Issue Records
	- Each individual data Validation Issue identified by the DVM is represented by a separate Validation Issue record that includes a description of the issue that contains all relevant database values associated with the given relevant data record(s) at the time of evaluation.  An optional custom application link can be associated with the individual validation issues to allow users to load a specific web application page to inspect/resolve the validation issue.  The Issue Type information is included as well as the severity of the issue (e.g. warning vs. error).    
- Issue Resolution
	- When a Validation Issue record represents a legitimate value or legitimate set of values a data manager has the ability to annotate the Validation Issue by defining an Issue Resolution Type (e.g. No Data Available, Manually Reviewed and Accepted, No Resolution Can be Reached Yet, etc.).  The data manager can also define a note for the Validation Issue to describe the reason for marking the Validation Issue as a false positive (e.g. fishing in IATTC area) or as otherwise exempted (e.g. there is no way to determine the field value)
	- **Note: A general interface can be developed to review and resolve/annotate data validation issues, an example implementation can be reviewed in the Centralized Cruise Database (CCD) (git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git)
- Issue Report Queries (all Views have comments on all columns and the object itself):
	- DVM_PTA_ISSUES_V – (PTA Issues (View)) This View returns all validation issues associated with a given PTA Issue record that were identified during the last evaluation of the associated PTA Issue Types.  A PTA Issue record can be referenced by any data table that represents the parent record for a given data stream (e.g. CCD_CRUISES for CCD data).  The query returns detailed information about the specifics of each issue identified as well as general information about the given Issue's Issue Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.
	- DVM_PTA_ISS_TYPES_V – PTA Issue Types (View) This View retrieves all Validation Rule Sets and corresponding Validation Rules for a given Parent Issue Record and corresponding data stream(s).  The associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Issue Types that were associated with the data stream when the given parent record is first evaluated using the DVM.  
- Validation Rule Query (all Views have comments on all columns and the object itself)
	- DVM_CRITERIA_V – (Data QC Criteria (View)) This View returns all data QC Criteria (Issue Types) defined in the database and their associated data QC Object, Issue Severity, and Issue Category.  This query is used to define all PTA Issue Types when a data stream is first validated in the database
- <a name="DVM_config_QC"><a/>DVM Configuration QC Views (all Views have comments on all columns and the object itself):
  - These Configuration QC Views (objects that begin with "DVM_STD_QC") are used to identify DVM configuration errors that will prevent the DVM from being executed successfully (e.g. data QC view is invalid).  These configuration QC queries are intended to be executed after the DVM configuration has been changed or if there are problems encountered during DVM execution.  
  - The DVM_STD_QC_ALL_RPT_V combines the results of all of the standard DVM Configuration QC views for convenience.  
  - The list of DVM configuration errors can be found in the [DVM Business Rules List](./DVM%20-%20Business%20Rules.xlsx) where the "Scope" column values are "DVM Configuration QC"


## Algorithm Used:
- The actual data QC validation process is performed by the DVM_PKG.VALIDATE_PARENT_RECORD procedure.  
	- **Note: This process is executed by running a PL/SQL block of code (see [Ex 1](#ex1))
- The specified Data Stream code(s) are validated
- The specified Parent Record is retrieved
- The Parent Issue Record is retrieved (if this is the first time the DVM is executed, if not a new Parent Issue record is inserted)
  - If a specified Data Stream has not been evaluated before the module associates the Parent Record with the current active Validation Rule Set for the specified Data Stream so they can be re-evaluated in the future, if the active Validation Rules for the specified Data Stream are not the same as the active Validation Rule Set's then the existing Validation Rule Set(s) are deactivated and new Validation Rule Set(s) are inserted with the active Validation Rules and associated with the Parent Record.  
  - If a specified Data Stream has been evaluated for the specified Parent Record before those Validation Rules will be reused.  
- The Validation Rules associated with each Validation Rule Set for the specified Data Stream(s) are evaluated for the specified Parent Record to identify pending Validation Issues
- Each pending Validation Issue is checked against the list of existing Validation Issues associated with the specified Parent Record for the specified Data Stream(s).  All of the pending Validation Issues that do not match the existing Validation Issues are loaded into the database and associated with the Parent Record.  The existing Validation Issues that do not match the pending Validation Issues are removed from the database.  

## Core tables
- **Note: all tables have comments on all columns as well as the object itself
- [Database Table/View Comments](./DVM_table_view_comments.xlsx)


## <a name="ex1"><a/>Ex 1:
```
--Main package procedure that validates a parent record based on the given data stream code(s) defined by P_DATA_STREAM_CODES, and uniquely identified by P_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
--Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):

set serveroutput on;
--sample usage for DVM:
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'RPL';
	P_DATA_STREAM_CODE(2) := 'XML';
	P_PK_ID := :pkid;

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');

		--commit the transaction
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;
END;

```
