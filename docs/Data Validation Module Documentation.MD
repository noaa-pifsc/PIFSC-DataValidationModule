
# Data Validation Module Documentation
## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in the database based on flexible data validation criteria that can be developed and implemented in Oracle Views by a data manager/developer without requiring application development skills.  A series of QC Views can be developed to identify problematic values in the database and implemented in the framework to allow each criteria to be evaluated on the given data stream.  A given parent record (e.g. SPT_VESSEL_TRIPS) of a given data stream (e.g. RPL) and all associated child records (e.g. SPT_VESSEL_TRIP_EVTS, SPT_SET_CATCH, etc.) will be validated as a group based on the QC Views defined.  Each validation issue that is identified will be saved as a separate issue record (DVM_ISSUES) that includes detailed information about the type of issue and a descriptive issue message with contextual information that will allow a given issue to be quickly identified, these issue records are associated with the parent issue record (DVM_PTA_ISSUES).  The issue records can be queried and exported easily in a single unified report for resolution by data management staff.

## Resources:
- DVM Version Control Information:
  - URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git
  - Database: 0.8 (Git tag: DVM_db_v0.8)
- [Database Table/View Comments](./DVM_table_view_comments.xlsx)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
- [Database Diagram](./Data%20Validation%20Module%20DB%20Diagram.pdf)
- [Database Naming Conventions](./DVM%20DB%20Naming%20Conventions.MD)
- [How to Define Criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- [PL/SQL Naming Conventions](./DVM%20-%20PL%20SQL%20Coding%20Conventions.MD)
- [DVM Package Error Handling Cases](./DVM_PKG_error_handling_cases.xlsx)

## Terms Used:
- Parent record - The parent record for all child records in a given data stream.  Each parent record has a foreign key reference (PTA_ISS_ID) to the associated parent issue record.  
  - For example the SPT_VESSEL_TRIPS table contains the parent records for the RPL data stream and SPT_UL_TRANSACTIONS table contains the parent records for the UL data stream.
- Parent Issue Record (DVM_PTA_ISSUES) - The parent record that all Validation Issue records are associated with when the DVM is processed.  
- QC Objects (DVM_QC_OBJECTS) - These QC views are used to identify Validation Issues based on the associated Validation Rules
- Validation Rules (DVM_ISS_TYPES) - These records represent the individual QC criteria that are defined for a given data stream.  Each is associated with a QC object that is executed to identify the corresponding Validation Issues.  Validation Rules can be deactivated so they are no longer evaluated on new parent records but they will continue being evaluated on existing parent records that have previously been evaluated with the corresponding Validation Rules.  
- Validation Rule Set (DVM_RULE_SETS) - These records define the different sets of validation rules that have been used to evaluate parent records over time.  They are associated with specific Validation Rules that were active for the given data stream during a given period.  Each Validation Rule Set has a date range defined for it to track when it was created (indicates when it was first used) and an inactive date (to indicate when it was deactivated).  Only one validation rule set for each data stream can be active at a given time.  
- Validation Issue record (DVM_ISSUES) - These records represent individual instances of data validation issues identified by the DVM and are associated with Parent Issue records.

## <a name="database_setup"></a>Database Setup:
- Install version 0.2 (git tag: db_vers_ctrl_db_v0.2) of the DB Version Control Module (VCM) Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_version_control folder)
  - This module utilizes v0.13 of the VCM (git tag: db_vers_ctrl_v0.13)
- Install version 0.2 (git tag: db_log_db_v0.2) of the DB Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_log folder)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
- ****Note**: If this is an upgrade between version 0.4 and 0.5 and it has previously been used to validate records the database instance must be migrated using a [specific approach](./version_0.5_upgrade_SOP.MD).  If the DVM has not been previously used to validate data then disregard this note.

## Features:
- Point in time architecture (PTA): The module will associate the given parent record with the active Validation Rule Set(s) that were active at the time that the given parent record was first validated by the module for the specified data stream(s).  This will allow the data to be re-validated with the same criteria over time so new criteria will not be evaluated on older data which can potentially cause problems.
- Data Validation Issues can be accepted based on manual annotations and an Issue Resolution Type.  This allows data issues that cannot be resolved or false positives to be marked as valid with the annotation as an explanation.

## Implementation
- Current Implementation
	- Standalone PL/SQL Package (DVM_PKG) that can be executed to validate any parent record that has been configured and enabled in the DVM.  The behavior of the module depends on the state of the given parent record.  The first time a Parent Record is evaluated for a given data stream it will save the active Validation Criteria for future validation module processing and all Validation Issue records will be associated with the Parent Issue Record.  All subsequent times a Parent Record is evaluated for a given data stream it will re-use the saved validation criteria and remove all obsolete Validation Issues (indicates that the underlying cause of the validation has been resolved) for the given data stream and add all newly identified Validation Issues (indicates that there are new Validation Issues).
	- QC Queries are implemented for groups of tables that comprise a data stream and the resultant Validation Issue records are associated with the given parent issue record for a given data stream.  
  - User Defined Exceptions were implemented for error handling in the DVM: [Error Handling Cases](./DVM_PKG_error_handling_cases.xlsx)
- How to define data validation criteria
	- See external document [here](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- Issue Records
	- Each individual data Validation Issue identified by the DVM is represented by a separate Issue record that includes a description of the issue that contains all relevant database values associated with the given data record(s) at the time of evaluation.  The Issue Type is specified as well as the severity of the issue (e.g. warning vs. error).    
- Issue Resolution
	- When an issue record represents a legitimate value or legitimate set of values a data manager has the ability to enter a manual annotation on the corresponding DVM_ISSUES record itself and set the ISS_NOTES value to an explanation of the reason the issue should be considered a false positive (e.g. fishing in IATTC area) or is otherwise exempted (e.g. there is no way to determine the field value).  Also, the ISS_RES_TYPE_ID value can be set to the PK of an existing Issue Resolution Types (DVM_ISS_RES_TYPES) record that corresponds to the resolution type (e.g. No Data Available, Manually Reviewed and Accepted, and No Resolution Can be Reached Yet) to allow the resolution types to be grouped.
	- **Note: A general interface can be developed to review and resolve/annotate data validation issues, an example implementation can be reviewed in the Centralized Cruise Database (git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git)
- Issue Report Queries (all Views have comments on all columns and the object itself):
	- DVM_PTA_ISSUES_V – (PTA Issues (View)) This View returns all validation issues associated with a given PTA Issue record that were identified during the last evaluation of the associated PTA Issue Types.  A PTA Issue record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each issue identified as well as general information about the given Issue's Issue Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.
	- DVM_PTA_ISS_TYPES_V – PTA Issue Types (View) This View retrieves all Validation Rule Sets and corresponding Validation Rules for a given Parent Issue Record and corresponding data stream(s).  The associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Issue Types that were associated with the data stream when the given parent record is first evaluated using the DVM.  
- Issue Rule Query (all Views have comments on all columns and the object itself)
	- DVM_CRITERIA_V – (QC Criteria (View)) This View returns all QC Criteria (Issue Types) defined in the database and their associated QC Object, Issue Severity, and Issue Category.  This query is used to define all PTA Issue Types when a data stream is first validated in the database
- DVM QC Queries (all Views have comments on all columns and the object itself):
	- DVM_QC_MSG_MISS_FIELDS_V - This query returns all issue types (DVM_ISS_TYPES) that have a ISS_TYPE_COMMENT_TEMPLATE or APP_LINK_TEMPLATE value that is missing one or more field references in the corresponding QC View object (based on the data dictionary). The [APP_ID] and [APP_SESSION] are special reserved placeholders that are intended to be used by a given APEX application and replaced at runtime by the APEX application variables so they are not identified in this QC query.  This View should be used to identify if there are any field references that will not be populated by the DVM.  MISSING_ISS_TEMPL_FIELDS and MISSING_APP_LINK_FIELDS will contain a comma-delimited list of field references that are not in the corresponding QC View object for the issue description templates and application link templates respectively.

## Algorithm Used:
- Actual QC validation process is performed by the DVM_PKG.VALIDATE_PARENT_RECORD procedure.  
	- **Note: This process is executed by running a PL/SQL block of code (see [Ex 1](#ex1))
- The specified data stream code(s) are validated
- The specified parent record is retrieved
- The parent issue record is retrieved (if this is the first time the DVM is executed, if not a new parent issue record is inserted)
  - If a specified data stream has not been evaluated before the module associates the Parent Record with the current active Validation Rule Set for the specified data stream code so they can be re-evaluated in the future, if the active Validation Rules for the specified data stream code are not the same as the active Validation Rule Set's then the existing Validation Rule Set(s) are deactivated and new Validation Rule Set(s) are inserted with the active Validation Rules and associated with the parent record.  
  - If a specified data stream has been evaluated for the specified Parent Record before those Validation Rules will be reused.  
- The validation criteria associated with each Validation Rule Set for the specified data stream code(s) are evaluated for the specified Parent Record to identify pending Validation Issues
- Each pending Validation Issue is checked against the list of existing Validation Issues associated with the specified Parent Record for the specified data stream code(s).  All of the pending Validation Issues that do not match the existing Validation Issues are loaded into the database and associated with the Parent Record.  The existing Validation Issues that do not match the pending Validation Issues are removed from the database.  

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
