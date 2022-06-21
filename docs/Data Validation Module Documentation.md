# Data Validation Module Documentation

## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in a given Oracle database based on flexible data validation criteria.  The module provides a documented, repeatable method for evaluating data quality control (QC) criteria on a given data set.  This module formally addresses the assurance phase of the data life cycle and addresses the transparency objective defined in the NOAA Data Strategy.  Flexible data QC validation criteria can be implemented in Oracle Views by a data manager/database developer and configured in the DVM for a given Data Stream without requiring application development skills.  A given Parent Record and all associated child records will be validated as a group based on the data QC Views defined for a given Data Stream.  Each data issue that is identified will be saved as a separate Validation Issue record that includes detailed information about the type of issue and an associated issue description that provides contextual information that will allow a given Validation Issue to be quickly identified, these issue records are associated with the Parent Record so they can be easily queried and provided to data staff for inspection and resolution.  Standard DVM Reports are available to provide information about the Validation Rules that were utilized over time as well as the DVM processing history for a given Parent record.

## Resources:
- DVM Version Control Information:
  - URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git
  - Database: 1.4 (Git tag: DVM_db_v1.4)
- [Database Table/View Comments](./DVM_table_view_comments.xlsx)
- [Installing or Upgrading the Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.md)
- [Database Diagram](./Data%20Validation%20Module%20DB%20Diagram.pdf)
- [Database Naming Conventions](./DVM%20DB%20Naming%20Conventions.md)
- [How to Define Criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.md)
- [PL/SQL Naming Conventions](./DVM%20-%20PL%20SQL%20Coding%20Conventions.md)
- [Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md)

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
- Manual Installation
  - Install version 0.2 (git tag: db_vers_ctrl_db_v0.2) or higher of the DB Version Control Module (VCM) Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBVersionControlModule.git)
  - Install version 0.3 (git tag: db_log_db_v0.3) or higher of the DB Logging Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git)
  - [Installing or Upgrading the DVM Database](./DVM%20-%20Installing%20or%20Upgrading%20the%20Database.md)
  - ****Note**: If this is an upgrade between version 0.4 and 0.5 and it has previously been used to validate records the database instance must be migrated using a [specific approach](./version_0.5_upgrade_SOP.md).  If the DVM has not been previously used to validate data then disregard this note.
- Automated Installation
  - For new installations a DB Module Packager (DMP) project (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git) is available with two separate use cases that include the VCM, DB Logging Module, and DVM to streamline the installation process starting in version 0.3 (Git tag: db_module_packager_v0.3).  Refer to the documentation for more information.

## Database Features:
-   DB Version Control Module (VCM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBVersionControlModule.git
    -   Database Version: 0.2 (git tag: db_vers_ctrl_db_v0.2)
    -   SOP Version: 1.0 (git tag: db_vers_ctrl_v1.0)
-   DB Logging Module (DLM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git
    -   Version: 0.3 (git tag: db_log_db_v0.3)
-   Data history tracking package
    -   Version Control Information:
        -   URL: svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs
            -   Files: dsc_cre_hist_objs_pkg.pks (package specs) and dsc_cre_hist_objs_pkg.pkb (package body)
        -   Database: N/A (last update on 4/21/2009)
    -   Description: This was developed by the PIFSC Systems Design Team (SDT) to track data changes to a given table over time to facilitate accountability, troubleshooting, etc.  Certain data tables have had this functionality enabled.  The DSC_CRE_HIST_OBJS_PKG package is defined in the DSC schema, the CRE_HIST_TRG() and CRE_HIST_SEQ() procedures were executed using the data schema.  

## Git Features:
-   [Git Hooks](https://picgitlab.nmfs.local/centralized-data-tools/git-hooks) Version Control Information:
    -   URL: git@picgitlab.nmfs.local:centralized-data-tools/git-hooks.git
    -   Version: 0.1 (git tag: git_hooks_v0.1)

## DVM Features:
- Point in time architecture (PTA): The module will associate the given parent record with the active Validation Rule Set(s) that were active at the time that the given parent record was first validated by the module for the specified Data Stream(s).  This will allow the given Parent Record to be re-validated with the same Validation Rules over time so new Validation Rules will not be evaluated on older data which can potentially cause problems.
- Standard Validation Criteria Reports
  - The DVM_RULE_SETS_RPT_V view provides the specific data quality control criteria that was used to validate each Data Stream over time.  This standard report can be included with the data set metadata.
  - The DVM_PTA_RULE_SETS_RPT_V view provides the specific data quality control criteria that was used to validate each Parent Record if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
  - The DVM_DS_PTA_RULE_SETS_HIST_V view provides the DVM Validation Rule Set evaluation history for each Parent Record if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
  - The DVM_PTA_RULE_SETS_HIST_RPT_V view provides information about each time the DVM was evaluated for which specific Validation Rules on a given Parent Record for each Data Stream if that level of detail is desired.  This standard report can be combined with data set-specific information to generate a standard validation rule report that can be included with the data set metadata or as an internal report.
 - [DVM Configuration QC Views](#DVM_config_QC)
- DVM Automated Test Cases
  - This process has been developed using the Centralized Cruise Database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-cruise-database.git) starting in version 0.23 (Git tag: cen_cruise_db_v0.23). Refer to the tagged versions of the CCD that match the version of the DVM (e.g. DVM_db_v1.0) for the corresponding automated test cases.
    - For more information review the Centralized Cruise Database DVM Testing Documentation.docx document in the docs/test_cases/DVM_PKG directory  
- Data Stream Specific Processing
  - The main DVM package procedure can be implemented directly in a PL/SQL block for a given data stream (based on the defined data stream code argument(s)) or it can also be wrapped in data set-specific packages/procedures to simplify the PL/SQL code required to implement the DVM on a given data stream's parent record.  
   - A data set-specific procedure can be defined for each data stream (e.g. benthic, fish, oceanography, etc.) to specify the data streams argument(s) and allow the user to specify the parent table's primary key.  These data set-specific "wrapped" procedures can be used directly in PL/SQL blocks, applications, or in other PL/SQL packages/procedures to provide additional functionality.  
   - An example is available in the CCD in the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP package procedure that executes the DVM on a given cruise record.  The procedure accepts a P_CRUISE_ID parameter and specifies the data stream code parameter within the  CCD_DVM_PKG package so the user only specifies a single argument
   - Data set-specific DVM procedures can be overloaded to allow primary key  (example from cruise DB overlapping cruise dates)
     - An example is available in the CCD in the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP package procedure that accepts a P_CRUISE_NAME parameter and specifies the data stream code parameter within the  CCD_DVM_PKG package so the user only specifies a single argument
   - Special business rule logic can be implemented using the DVM_PKG.  An example from the CCD checks has a data QC view that identifies overlapping dates between parent records.  Custom logic can be implemented to identify the overlapping record(s) and automatically validate those as well to ensure the associated validation issues are up to date.  
     - An example is available in the CCD in the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP package procedure that accepts a P_CRUISE_ID parameter.  
       - An example of an overloaded procedure is the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP package procedure that accepts a P_CRUISE_NAME parameter.
       - This type of special case processing can be implemented in data management applications to automatically validate a parent record and all potentially overlapping parent records after inserting, updating, or deleting a given parent record.  An example is implemented in the CCD's Cruise Data Management Application's (CRDMA) View/Edit Cruise page.   
   - Procedures can be defined to execute the DVM on multiple parent records by implementing PL/SQL logic, this can be used to validate all of the desired records before the data is available for analysis, reporting, archival, etc.  Batch Processing procedures can be developed to validate all parent records or a subset of the parent records
    - An example of a batch processing procedure can be found in the CCD in the CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP package procedure, custom filters can be implemented for batch processing subsets of parent records.

## Implementation
- Current Implementation
  - Standalone PL/SQL Package (DVM_PKG) that can be executed to validate any parent record that has been configured and enabled in the DVM.  The behavior of the module depends on the state of the given Parent Record.  The first time a Parent Record is evaluated for a given Data Stream it will save the active Validation Rules for future DVM processing and all Validation Issue records will be associated with the Parent Issue Record.  All subsequent times a Parent Record is evaluated for a given Data Stream it will re-use the saved Validation Rules and remove all obsolete Validation Issues (indicates that the underlying cause of the validation has been resolved) for the given Data Stream and add all newly identified Validation Issues (indicates that there are new Validation Issues identified).
  - Data QC Queries are implemented for groups of tables that comprise a Data Stream and the resultant Validation Issue records are associated with the given Parent Issue record for a given Data Stream.  
  - User Defined Exceptions were implemented for error handling in the DVM: [DVM Business Rules](./DVM%20-%20Business%20Rules.xlsx) (where the "Scope" column is "DVM Processing Errors")
- [How to define data validation criteria](./How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.md)
- Validation Issue Records
  - Each individual data Validation Issue identified by the DVM is represented by a separate Validation Issue record that includes a description of the issue that contains all relevant database values associated with the given relevant data record(s) at the time of evaluation.  An optional custom application link can be associated with the individual validation issues to allow users to load a specific web application page to inspect/resolve the validation issue.  The Issue Type information is included as well as the severity of the issue (e.g. warning vs. error).    
- Issue Resolution
  - When a Validation Issue record represents a legitimate value or legitimate set of values a data manager has the ability to annotate the Validation Issue by defining an Issue Resolution Type (e.g. No Data Available, Manually Reviewed and Accepted, No Resolution Can be Reached Yet, etc.).  The data manager can also define a note for the Validation Issue to describe the reason for marking the Validation Issue as a false positive (e.g. fishing in IATTC area) or as otherwise exempted (e.g. there is no way to determine the field value)
  - **Note: A general interface can be developed to review and resolve/annotate data validation issues, an example implementation can be reviewed in the Centralized Cruise Database (CCD) (git@picgitlab.nmfs.local:centralized-data-tools/centralized-cruise-database.git)
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
- The data QC validation process is performed by executing the DVM_PKG.VALIDATE_PARENT_RECORD_SP (see [Ex 1](#ex1)) or DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP (see [Ex 2](#ex2)) depending on the use case.  
  - The DVM_PKG.VALIDATE_PARENT_RECORD_SP will raise user defined exceptions (see [DVM Business Rules](./DVM%20-%20Business%20Rules.xlsx) for "Scope" values of "DVM Processing Errors")
  - The DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP utilizes return code and exception message parameters to indicate if the DVM was processed successfully and if there was an error the exception message parameter contains the exception message.  This additional procedure was provided to account for additional use cases (e.g. batch processing).
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


## <a name="ex1"><a/>Ex 1 (User-Defined Exception Version):
```
    --Main package procedure that validates a parent record based on the given data stream code(s) defined by P_DATA_STREAM_CODES, and uniquely identified by the specified primary key (P_PK_ID).  This is the main procedure that is called by external programs to validate the specified parent record.  If the procedure is successful it will not commit the changes to the DVM data to allow for flexibility as part of a larger transaction or to allow the user to explicitly commit the changes made by the DVM.  If the procedure is unsuccessful it will rollback the transaction to the state of the beginning of the procedure.
    --Any exceptions encountered during the execution of the procedure will cause the procedure to fail and log/print the error.

    set serveroutput on;

    --Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
    DECLARE
      P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
      P_PK_ID NUMBER;
    BEGIN
      -- Modify the code to initialize the variable
      P_DATA_STREAM_CODE(1) := 'RPL';
      P_DATA_STREAM_CODE(2) := 'XML';
      P_PK_ID := :pkid;

      DVM_PKG.VALIDATE_PARENT_RECORD_SP(
      P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
      P_PK_ID => P_PK_ID
      );


      DBMS_output.put_line('The parent record was evaluated successfully');

      --commit the transaction
      COMMIT;


      EXCEPTION
        WHEN OTHERS THEN
          DBMS_output.put_line(SQLERRM);

          DBMS_output.put_line('The parent record was NOT evaluated successfully');
    END;

```

## <a name="ex2"><a/>Ex 2 (Return Code Version):

```
--DVM execution procedure for a given parent record (based on P_DATA_STREAM_CODES and P_PK_ID) that provides a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully or not instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
/*
  set serveroutput on;

  --Example usage (for return code version) using the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
  DECLARE
    P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
    P_PK_ID NUMBER;
    V_SP_RET_CODE PLS_INTEGER;
    V_EXC_MSG VARCHAR2 (4000);

  BEGIN
    -- Modify the code to initialize the variable
    P_DATA_STREAM_CODE(1) := 'RPL';
    P_DATA_STREAM_CODE(2) := 'XML';
    P_PK_ID := :pkid;

    DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
    P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
    P_PK_ID => P_PK_ID,
    P_SP_RET_CODE => V_SP_RET_CODE,
    P_EXC_MSG => V_EXC_MSG
    );

    --check the return code:
    IF (V_SP_RET_CODE = 1) THEN

      DBMS_output.put_line('The parent record was evaluated successfully');

      --commit the transaction
      COMMIT;
    ELSE
      --output the error message:
      DBMS_output.put_line(V_EXC_MSG);

      DBMS_output.put_line('The parent record was NOT evaluated successfully');

    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        DBMS_output.put_line(SQLERRM);

        DBMS_output.put_line('The parent record was NOT evaluated successfully');
  END;

```
