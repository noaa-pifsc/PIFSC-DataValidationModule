
# Data Validation Module Documentation
## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in the database based on flexible data validation criteria that can be developed and implemented in Oracle Views by a data manager/developer without requiring application development skills.  A series of QC Views can be developed to identify problematic values in the database and implemented in the framework to allow each criteria to be evaluated on the given data stream.  A given parent record (e.g. SPT_VESSEL_TRIPS) of a given data stream (e.g. RPL) and all associated child records (e.g. SPT_VESSEL_TRIP_EVTS, SPT_SET_CATCH, etc.) will be validated as a group based on the QC Views defined.  Each validation issue that is identified will be saved as a separate issue record (DVM_ERRORS) that includes detailed information about the type of issue and a descriptive issue message with contextual information that will allow a given issue to be quickly identified, these issue records are associated with the parent issue record (DVM_PTA_ERRORS).  The issue records can be queried and exported easily in a single unified report for resolution by data management staff.

## Resources:
- DVM Version Control Information:
  - URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git
  - Database: 0.4 (Git tag: DVM_db_v0.4)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
- [Database Diagram](./Data%20Validation%20Module%20DB%20Diagram.pdf)
- [Database Naming Conventions](./DVM%20DB%20Naming%20Conventions.MD)
- [How to Define Criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- <mark>PL/SQL Naming Conventions
## Terms Used:
- Parent record - The parent record for all child records in a given data stream.  Each parent record has a foreign key reference (PTA_ERROR_ID) to the associated parent issue record.  
  - For example the SPT_VESSEL_TRIPS table contains the parent records for the RPL data stream and SPT_UL_TRANSACTIONS table contains the parent records for the UL data stream.
- Parent issue record (DVM_PTA_ERRORS) - The parent record that all issue type and issue records are associated with when the data validation module is processed.  
- Issue record (DVM_ERRORS) - These records represent individual instances of data validation issues identified by the data validation module and are associated with parent issue records.
## <a name="database_setup"></a>Database Setup:
- Install version 0.1 (git tag: db_log_db_v0.1) of the DB Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_log folder)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.MD)
## Features:
- Point in time architecture (PTA): The module will save all issue criteria that were active at the time that the data was first validated by the module.  This will allow the data to be re-validated with the same criteria that were active when it was entered which was implemented so new criteria would not be evaluated on older data which can potentially cause some problems.
- Data validation issues can be accepted based on manual annotations and an Issue Resolution Type.  This allows data issues that cannot be resolved or false positives to be marked as valid with the annotation as an explanation.
## Implementation
- Current Implementation
	- Standalone PL/SQL Package (DVM_PKG) that can be executed to validate any parent record that has been configured and enabled in the data validation module.  The behavior of the module depends on the state of the given parent record.  The first time a parent record is evaluated it will save the active validation criteria for future validation module processing and all issue records will be associated with the parent issue record.  All subsequent times a parent record is evaluated it will re-use the saved validation criteria and remove all obsolete errors and add all newly identified errors
	- QC Queries are implemented for groups of tables that comprise a data stream and the resultant Issue records are associated with the given parent issue record for a given data stream.  
- How to define data validation criteria
	- See external document [here](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.MD)
- Issue Records
	- Each individual data issue identified by the Data Validation Module is represented by a separate Issue record (DVM_ERRORS) that includes a description of the issue that contains all relevant database values associated with the given data record(s) at the time of evaluation.  The Issue Type is specified as well as the severity of the issue (e.g. warning vs. fatal issue).  
	- The ability to re-run validation has been implemented preliminarily.  The framework purges all existing Issue records and re-uses the existing DVM_ERRORS and DVM_ERROR_TYPES records when evaluating the associated Issue Types that existed when the parent record was first evaluated (defined by DVM_PTA_ERR_TYP_ASSOC records).   
- Issue Resolution
	- When an issue record represents a legitimate value or legitimate set of values a data manager has the ability to enter a manual annotation on the corresponding DVM_ERRORS record itself and set the ERROR_NOTES value to an explanation of the reason the issue should be considered a false positive (e.g. fishing in IATTC area) or is otherwise exempted (e.g. there is no way to determine the field value).  Also, the ERR_RES_TYPE_ID value can be set to the PK of an existing Issue Resolution Types (DVM_ERR_RES_TYPES) record that corresponds to the resolution type (currently: No Data Available, Manually Reviewed and Accepted, and No Resolution Can be Reached Yet) to allow the resolution types to be grouped.
	- **Note: there is currently no interface that has been developed to enter accept and annotate data validation issues.  This can be developed potentially as part of a larger data management system.
- Issue Report Queries (all Views have comments on all columns and the object itself):
	- DVM_PTA_ERRORS_V – (PTA Errors (View)) This View returns all unresolved Errors associated with a given PTA Issue record that were identified during the last evaluation of the associated PTA Issue Types.  A PTA Issue record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each issue identified as well as general information about the given Issue's Issue Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.
	- DVM_PTA_ERROR_TYPES_V – (PTA Issue Types (View)) This View returns all Issue Types associated with a given PTA Issue Type record.  The PTA Issue Type record is defined the first time the given data stream is first entered into the database, all active Issue Types at this point in time are saved and associated with a new PTA Issue Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Issue Types that were associated with a data stream when the given parent record is first entered into the database.  
- Issue Rule Query
	- DVM_QC_CRITERIA_V – (QC Criteria (View)) This View returns all QC Criteria (Issue Types) defined in the database and their associated QC Object, Issue Severity, and Issue Category.  This query is used to define all PTA Issue Types when a data stream is first validated in the database
- DVM QC Queries:
	- DVM_QC_MSG_MISS_FIELDS_V - This query returns all issue types (DVM_ERROR_TYPES) that have a ERR_TYPE_COMMENT_TEMPLATE or APP_LINK_TEMPLATE value that is missing one or more field references in the corresponding QC View object (based on the data dictionary). The [APP_ID] and [APP_SESSION] are special reserved placeholders that are intended to be used by a given APEX application and replaced at runtime by the APEX application variables so they are not identified in this QC query.  This View should be used to identify if there are any field references that will not be populated by the Data Validation Module.  MISSING_ERR_DESC_FIELDS and MISSING_APP_LINK_FIELDS will contain a comma-delimited list of field references that are not in the corresponding QC View object for the issue description templates and application link templates respectively.
## Algorithm Used:
- Actual QC validation process is performed by the DVM_PKG. VALIDATE_PARENT_RECORD package procedure defined in the PL/SQL definition file: docs\Data Validation Module\code \ DVM_PKG.sql.  
	- **Note: This process is executed by running a PL/SQL block of code (see [Ex 1](#ex1))
- The data stream code supplied to the VALIDATE_PARENT_RECORD() procedure is queried to determine the given data stream's parent table so that the necessary database queries can be generated.  
- The given parent table is queried to check if the given parent record identified by the p_PK_ID primary key value exists, if it doesn't the module does nothing otherwise the process continues.
- The given parent table's parent issue record is queried to check if it exists.  If so, the validation criteria that was active when the parent record was first evaluated is loaded for evaluation.  If not, a new parent issue record is added to the database and associated with the parent record and the currently active validation criteria is loaded and saved in the database for future validation processing.  
- All criteria is retrieved and stored in a PL/SQL package variable for the data validation module evaluation
- Each QC View object that is defined for the validation criteria is evaluated for the given parent record and each corresponding QC validation check is checked to see if the given issue condition was found.  Each issue condition that is found (indicated by an indicator field value of 'Y' defined by DVM_ERROR_TYPES.IND_FIELD_NAME on the given QC View) will have a new pending issue added to a PL/SQL package variable with an issue description (DVM_ERRORS.ERROR_DESCRIPTION) generated based on the values returned by the given row of the QC View object query and the placeholders defined in the given issue type's ERR_TYPE_COMMENT_TEMPLATE value.  The Application Link URL (DVM_ERRORS.APP_LINK_URL) is generated using the same method as the issue description based on the placeholders defined in the issue type's APP_LINK_TEMPLATE.  
	- *Note: The [APP_ID] and [APP_SESSION] are special reserved placeholders that are intended to be used by a given APEX application and replaced at runtime by the APEX application variables so these will be left unchanged.
	- *Note: The [APP_ID] and [APP_SESSION] placeholders are not reported as unmatched placeholders in the QC query (DVM_QC_MSG_MISS_FIELDS_V) used to determine if there are any unmatched placeholders defined for QC views.
- Pending/Existing issue processing
	- If the parent record has been evaluated before all existing issue records that match pending errors (based on issue description and issue type) are left unmodified.  All existing issue records that do not match pending errors will be deleted as those issue conditions no longer exist on the parent record and associated child records.  All pending errors that do not match an existing issue record are inserted into the database as they represent new issue conditions.
	- If the parent record has not been evaluated before then it will be evaluated using all of the active data validation criteria at the time it is evaluated, these specific validation criteria are saved so they can be re-evaluated at any time in the future on the given parent record.  All issue conditions will be inserted into the database and associated with the given parent issue record.
## Core tables (all tables have comments on all columns and the object itself):
- DVM_QC_OBJECTS – (Data QC Objects) This is a reference table that defines all of the QC validation views that are executed on the data model after a given data stream is loaded into the database (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES).
	- DVM_ERROR_TYPES – (Data Issue Types) This is a reference table that defines the different QC Data Issue Types that indicate how to identify QC errors and report them to end-users for resolution.  Each Data Issue will have a corresponding Data Issue Type.
		- DVM_DATA_STREAMS - (Data Streams) This is a reference table that defines all data streams that are implemented in the SPTT data set.  This reference table is referenced by the DVM_ERROR_TYPES to define the data stream that the given issue type is associated with.  This reference table is also referenced by the SPT_APP_XML_POST_PROC to define the data stream that a given post processing procedure is executed for.  Examples of data streams are RPL, eTunaLog, UL, FOT, LFSC.  This is used to filter these records based on the given context of the processing/validation
		- DVM_ERR_SEVERITY – (Issue Severity) This is a reference table that defines all issue severities for issue type criteria.  This indicates the status of the given issue type criteria (e.g. warnings, data errors, violations of law, etc.)
		- DVM_ERRORS – (Data Errors) This is an issue table that represents any specific data issue instances that a given data table/entity contains (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These records will be used to communicate errors to the data entry and data management staff
			- DVM_ERR_RES_TYPES - (Issue Resolution Types) This is a reference table that defines all issue resolutions types that will be used to define the status of a given QC data validation issue.  When an issue is marked as resolved it will have an annotation to explain the resolution of the issue.  The types of issue resolutions include no data available, manually reviewed and accepted, no resolution can be reached yet.  Certain issue resolutions types will cause an issue to be filtered out from the standard issue reports.)
- Parent Table – This is the given parent  table that is enabled in the data validation module (e.g. SPT_VESSEL_TRIPS, SPT_CANN_TRANSACTIONS, etc.).
	- DVM_PTA_ERRORS – (Errors (PTA)) This table represents a generalized intersection table that allows multiple Issue records to reference this consolidated table that allows multiple Errors to be associated with the given table record (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, etc.).
		- DVM_PTA_ERR_TYP_ASSOC – (Issue Type Associations (PTA)) This intersection table allows multiple Issue Types to be associated with a given table (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, etc.).  These associations represent the Issue Types that are defined at the time that a given table record is created so that the specific rules can be applied for subsequent validation assessments over time.
## Legend
<mark>Completed</mark>
## Future plans for additional/modified functionality:
- Develop import process to allow the QC template spreadsheet to be imported directly into the DVM_QC_OBJECTS and DVM_ERROR_TYPES tables to remove the requirement to manually enter this data which can be time-consuming and potentially issue-prone (possibly just import into temp table and use merge queries to insert/update records into the corresponding tables as necessary).
- <mark>Update algorithm to associate the issue records directly with the parent record (e.g. SPT_VESSEL_TRIPS vs. SPT_APP_XML_FILES since only the RPL data entered via XML import module will have an associated SPT_APP_XML_FILES record).  When this change is made there would be no distinction between parent issue records and parent records.  
- <mark>Enhance the validation module to maintain existing issue records that are identical to the new issue records and retain any annotations made to these records so as not to lose the manual work completed by data management staff.  This is done by comparing the ERROR_DESCRIPTION and ERROR_TYPE_ID values between existing and pending issue records to determine if existing records should be deleted and/or new records should be added
- <mark>Implement the Data Validation Module as a stand-alone PL/SQL package that can be used directly in the database and executed via APEX, PHP, etc.  The logic in the evaluate_QC_criteria() and re_run_validation() methods would need to be implemented in stored procedures in a package.  
	- <mark>Query update - query for the primary key field name based on the DATA_STREAM_PAR_TABLE field in the DVM_DATA_STREAMS table so that it can be used as an argument in the data validation package.
	- Include a stored procedure that can batch re-evaluate records
- Implement URL generating capabilities into the framework to allow the QC Views to generate their own URLs for application pages that will allow the given issue to be resolved easily (e.g. APEX edit trip event link, PHP DM page link).  We would need to add to the fields in the DVM_ERRORS table and define a designated IND_FIELD to pull this information from (e.g. DATA_URL).  Could implement in foundational views as well and just pull directly into QC query as the link could be valuable in other contexts
- There is a slow query that needs to be fixed when time permits (SPT_QC_EVT_DIST_ISSUE_V).  The execution slows down considerably as the database is populated.
- Develop simple generalized interface to allow errors to be annotated in web interface
	- Could be part of a more generalized application that could be used throughout the Center
- <mark>Look into combining and generalizing the SPT_PTA_ERRORS and SPT_PTA_ERROR_TYPES tables (e.g. SPT_PTA_VALIDATIONS) since they seem to be redundant.  Could use a single key that two different tables reference.   This would simplify the logic and reduce the requirements for implementing framework on other data streams.
- Generalize objects and use less-specific names for the different database entities.  (e.g. should not refer to things as errors since some are warnings, maybe use the term "data issue" instead).  All object names should be changed accordingly as well.
## <a name="ex1"><a/>Ex 1:

	```
	--sample usage for data validation module:
	DECLARE
	    P_DATA_STREAM_CODE SPTT_DATA_VALIDATOR.DVM_PKG.VARCHAR_ARRAY_NUM;

	    P_PK_ID NUMBER;
	BEGIN

	    -- Modify the code to initialize the variable
	    P_DATA_STREAM_CODE(1) := 'RPL';
	    P_DATA_STREAM_CODE(2) := 'XML';
	    P_PK_ID := :vtid;

	    DVM_PKG.VALIDATE_PARENT_RECORD(
	    P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	    P_PK_ID => P_PK_ID);

	    --rollback;
	END;```

**Note: The P_DATA_STREAM_CODE variable can handle multiple data stream codes if necessary.  P_PK_ID is the numeric primary key value of the given parent record that will be validated.
