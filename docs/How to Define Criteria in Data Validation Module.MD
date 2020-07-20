ISS_ISS_
# How to Define Criteria in Data Validation Module
## Overview:
This document defines the comprehensive procedure for defining QC validation criteria in the Data Validation Module (DVM).    
## Resources:
- [DVM Documentation](./Data%20Validation%20Module%20Documentation.MD)
## Procedure:
- Define QC query (See [Example Multiple Criteria QC Query](#examples) below)
	- Step 1: Define the Data Validation Criteria using spreadsheet template (ex: [QC Validation Criteria](./QC%20Validation%20Criteria%20Template.xlsx))
		- **Note: All important columns used when implementing the QC criteria in the Data Validation Module are "I" through "O" and the column headers are referenced throughout this document.
		- Define the "Data Stream Code" value based on the data stream/import method being used.  There may be cases where a separate set of additional data validation criteria is needed depending on the method used to enter the data (e.g. XML import module vs. APEX RPL data entry) and this flexibility has been implemented in this foreign key field.    This field is used to filter data validation criteria when executed on a given data stream.  Typically each data stream will have its own Validation Scope defined for the global QC queries that will be implemented on all existing data within a given data stream (e.g. RPL, UL, FOT, Tracking, etc.).
			- Since the XML Import Module and Data Validation Module were developed together the data validation criteria for the RPL data set was split between the two Validation Scopes: RPL and XML to allow the XML data validation criteria to be excluded if the data was not imported using the XML import module.  
			- Each new data stream type defined in the spreadsheet will require a corresponding record in the DVM_DATA_STREAMS table.     
		- Define the "Data Stream Name" that will be used to refer to the given data stream
		- Define the "Data Stream Parent Table" with the table name that will be associated with the DVM validation issues for the given data stream.  
		- Define the "Issue Severity Type" value based on the severity type of given data validation issue (e.g. ERROR, WARN, etc.)
		- Define the "QC View Name" value based on the QC View that will be used to evaluate the corresponding validation issue.  This view name can be defined after the query is developed or beforehand  
		- Define the "QC Object Sort Order" numeric value based on which relative order the QC Views should be evaluated in, this can be left blank if the order is not important  
		- Define the "QC View Field Name" with a unique name within a given parent QC Object.  This will be the View field name that will indicate if the given data validation condition has been identified in the result set data from the given QC Object, it is recommended that you utilize the "_YN" suffix to indicate this is an indicator field for the DVM.  
			- This is defined as an indicator field in the corresponding QC View object.
		- Define the purpose of the given data validation criteria in "QC Issue Type Name" column (e.g. what condition you are identifying in the data as problematic).  
		- Define the description of the validation issue in the "Issue Type Description" column.  
		- Update the spreadsheet to populate the "QC Validation Issue Message Template" column with the template text for the given issue type.  This is the template for the specific issue description that exists for the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This value can be NULL only in special cases when QC_OBJECT_ID is NULL.  
			- All of the placeholders in the issue type comment template must be included in the result set of the corresponding QC Object otherwise the missing fields will not have the corresponding placeholders replaced
			- Example Issue Type comment template value can be found [here](#issue_template_example).  In this example the RPL_ORIG_OB_FISH_WT_CHR field must be included in the field list of the result set for the issue type comment template to be generated correctly.  Each data validation issue identified during the data validation process will be inserted as a separate DVM_ISSUES record with an ISS_DESC value defined as the issue type comment template with all placeholders replaced with the runtime values of the QC query results.  This is how the context of how to identify the location of the validation issue is communicated to data management staff.
		- Update the spreadsheet to populate the "Application Link Formula" column with the template for the custom application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value
			- example: f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)
		- Logically group the data validation criteria into similar categories (e.g. Vessel Trips, Trip Events, Set Catch) and attempt to implement each category with as few QC Views as possible.  These different groups of validation criteria will be compiled into separate QC Views.  
		- Export the generated DML for the DVM configuration records to a SQL script file that can be easily executed to define the DVM criteria
			- Copy the DML generated in the "Data Stream DML" column for each data stream to create the data stream records
			- Copy the DML generated in the "QC View DML" column for each unique "QC View Name" to create the QC object records
			- Copy the DML generated in the "Issue Type DML" column for each validation issue type to create the validation issue type records

	- Step 2: Develop the QC Query
		- Multiple data validation criteria can be implemented in a single QC query for efficiency purposes based on the type of data validation issue that is being evaluated.  (e.g. a general trip event QC query could check for both blank activity code and a blank school association code).
		- Best practice: develop foundational Oracle Views for each main database table entity in the given data stream.  These foundational Views should join all reference tables to allow the given main entity to be queried easily including all reference record values (e.g. SPT_TRIP_EVT_V).  The QC Views should be developed directly from the foundational Oracle Views (e.g. SPT_QC_TRIP_EVT_V).
		- Business Rules:
			- The parent table always needs to be included in the QC View to provide context for the given data validation issue so it can be easily identified and resolved (e.g. identifying the set catch record without providing information about the fishing trip or trip event is not very useful to a data manager).  
				- For example the foundational views are as follows: Vessel Trip (SPT_RPL_PTA_HEADER_V), Trip Event (SPT_TRIP_EVT_V), and Set Catch (SPT_CATCH_V).  When developing a QC query for the Set Catch all three Views should be used and the fields that help to identify the given catch record including its parent record values should be included in the result set.  
			- The parent table's primary key must be included in the result set of the given QC Object (e.g. for RPL fishing trips the VESS_TRIP_ID field must be included in the result set).  This field will be used to filter out which parent record is being validated on a given execution and the absence of this field will cause the module to break.
			- Each indicator field defined in the spreadsheet must be included in the result set with the corresponding column alias name (e.g. INV_DB_DEP_ARR_DTM) by the QC View that indicates the presence/absence of a given data validation issue.  The QC query result of each indicator field is a calculation that evaluates to ‘Y’ when the condition is true (indicates a data validation issue) or ‘N’ when the condition is false (does not indicate a data validation issue).  These indicator fields are the mechanism used by the data validation framework to identify instances of various issue types in the QC View results.
				- **Note: If a given indicator field defined in the spreadsheet does not have a corresponding column alias in the corresponding QC View the validation issues will not be identified correctly.  
				- **Note: In special cases when OBJECT_ID is NULL this is the constant name that is used to refer to the a global issue type (e.g. the generic DB_ERROR)
			- Each calculated indicator field returned in the result set that indicates a validation issue (based on [indicator field expression example in yellow](#example_mult_QC_criteria)) should also be implemented on the WHERE clause of the query as well with OR operators between each indicator field expression (show in blue) so that the only rows that satisfy at least one of the validation criteria are returned by the query so that each individual data validation issue can be logged separately.  
				- If there is only one data validation criteria that is implemented in a given QC query then the ON/WHERE clause will identify all records that satisfy the given data validation criteria and have a static formula for the given indicator field since it will be true for all returned rows (see [Example Single Criteria QC Query](#example_single_QC_criteria) below)
			- Each non-indicator field that is included in the result set should have a purpose in describing/providing context to the given validation issue (e.g. Departure Date, Vessel Name, etc.).  These fields will be used in the ISS_TYPE_COMMENT_TEMPLATE to generate a custom issue message and the APP_LINK_TEMPLATE to generate a custom application URL based on the context of the record value(s).  
			- QC objects and associated Issue Types can be enabled/disabled by updating the QC_OBJ_ACTIVE_YN and ISS_TYPE_ACTIVE_YN field values respectively.  Note that for existing records that already have PTA issue types defined will ignore these field values, they will only affect new records.
		- (if you haven't already or if the view name has changed) Update spreadsheet to populate the "QC View Name" column with the corresponding QC Oracle View name developed to identify the given data validation issue type.  
			- This field value will be used to assign the primary key value of the corresponding DVM_QC_OBJECTS record
	- Step 3: Register the QC Object into the Data Validation Module by entering records into the database
		- Execute the DDL to define the QC View Objects
		- Define View/Field comments for the QC object
			- Best practice: use Excel formulas to generate the DDL necessary to define comments on the different columns of a given View object.  Many of the View fields' comments can be pulled directly from the underlying base table's field comments using the VLOOKUP function.  Example can be found here on the "View Comments" worksheet.   
		- Add the DVM_QC_OBJECTS record to the database
			- OBJECT_NAME is the name of the corresponding QC View
			- QC_SORT_ORDER is the relative order that the QC Views will be executed in for a given data stream when the data validation criteria is evaluated
			- QC_OBJ_ACTIVE_YN should be 'Y' if the given QC Object is enabled and 'N' if the object should be excluded from being evaluated on new records.
		- Add the DVM_ISS_TYPES records to the database for each indicator field in the query that has been implemented
			- Use the values in the spreadsheet to populate the values of the records in the SPT_ISS_TYPES records in the fields indicated in the column headers in parentheses.
			- ISS_TYPE_ACTIVE_YN should be 'Y' if the given Issue Type is enabled and 'N' if the Issue Type should be excluded from being evaluated on new records.
			- ISS_TYPE_DESC can be populated with a description of the Issue Type but this is optional
	- Step 4: Verify that all of the validation issue type records' issue type comment template's and application link template's defined field references have corresponding field values in the given QC View object.  
		- This can be done using the DVM_QC_MSG_MISS_FIELDS_V View object, all rows returned will contain a comma-delimited list of missing QC View field references in the MISSING_VIEW_FIELDS field
- Configure parent table in Data Validation Module
	- Create the required Parent Issue table column in the parent table (defined in DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE for the given data stream) by modifying the provided scripts by defining the :table_name, :uk_name, :fk_name bind variables based on the data model on the target database instance.  
	- **Note: code and detailed information can be found here: [configure_parent_table.sql](../SQL/scripts/configure_parent_table.sql) 
## <a name="examples"></a>Examples Section:
- <a name="example_mult_QC_criteria"></a>Example Multiple Criteria QC Query:
```
CREATE OR REPLACE VIEW
SPT_QC_TRIP_OB_FISH_V
AS SELECT
SPT_TRIP_OB_FISH_V.TRIP_DISP_NAME,
SPT_TRIP_OB_FISH_V.RPL_ORIG_OB_FISH_WT_NUM,
SPT_TRIP_OB_FISH_V.RPL_ORIG_OB_FISH_WT_CHR,
SPT_TRIP_OB_FISH_V.OB_FISH_WT_MT,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_VESS_NAME,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_REG_NUM,
SPT_RPL_PTA_HEADER_V.PTA_VESS_NAME,
SPT_RPL_PTA_HEADER_V.FORMATTED_ARRIVAL_DTM,
SPT_RPL_PTA_HEADER_V.FORMATTED_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.VESS_REG_NUM,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID,
SPT_RPL_PTA_HEADER_V.WT_UOM_CONV_FACTOR_FROM,
SPT_TRIP_OB_FISH_V.OB_FISH_ID,
(RPL_ORIG_OB_FISH_WT_NUM * WT_UOM_CONV_FACTOR_FROM) CONV_ORIG_OB_FISH_WT_NUM,
(CASE WHEN RPL_ORIG_OB_FISH_WT_CHR IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM >= 0 AND RPL_ORIG_OB_FISH_WT_NUM <> CONVERT_STR_TO_NUMBER_FN(RPL_ORIG_OB_FISH_WT_CHR) THEN 'Y' ELSE 'N' END) MIS_OB_FISH_WT,
(CASE WHEN RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND OB_FISH_WT_MT IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM >= 0 AND OB_FISH_WT_MT >= 0 AND OB_FISH_WT_MT <> ROUND(RPL_ORIG_OB_FISH_WT_NUM * WT_UOM_CONV_FACTOR_FROM, 5) THEN 'Y' ELSE 'N' END) MIS_CONV_OB_FISH_WT,
(CASE WHEN OB_FISH_WT_MT IS NOT NULL AND OB_FISH_WT_MT < 0 THEN 'Y' ELSE 'N' END) INV_DB_OB_FISH_WT_MT,
(CASE WHEN RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM < 0 THEN 'Y' ELSE 'N' END) INV_DB_OB_FISH_WT_NUM,
(CASE WHEN RPL_ORIG_OB_FISH_WT_CHR IS NULL THEN 'Y' ELSE 'N' END) BLANK_RPL_OB_FISH_WT_CHR,
(CASE WHEN RPL_ORIG_OB_FISH_WT_NUM IS NULL THEN 'Y' ELSE 'N' END) BLANK_DB_OB_FISH_WT_NUM,
(CASE WHEN OB_FISH_WT_MT IS NULL THEN 'Y' ELSE 'N' END) BLANK_DB_OB_FISH_WT_MT
FROM
SPT_TRIP_OB_FISH_V
INNER JOIN SPT_RPL_PTA_HEADER_V
ON SPT_TRIP_OB_FISH_V.VESS_TRIP_ID = SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID
WHERE   
(RPL_ORIG_OB_FISH_WT_CHR IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM >= 0 AND RPL_ORIG_OB_FISH_WT_NUM <> CONVERT_STR_TO_NUMBER_FN(RPL_ORIG_OB_FISH_WT_CHR))
OR (RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND OB_FISH_WT_MT IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM >= 0 AND OB_FISH_WT_MT >= 0 AND OB_FISH_WT_MT <> ROUND(RPL_ORIG_OB_FISH_WT_NUM * WT_UOM_CONV_FACTOR_FROM, 5))
OR (OB_FISH_WT_MT IS NOT NULL AND OB_FISH_WT_MT < 0)
OR (RPL_ORIG_OB_FISH_WT_NUM IS NOT NULL AND RPL_ORIG_OB_FISH_WT_NUM < 0)
OR (RPL_ORIG_OB_FISH_WT_CHR IS NULL)
OR (RPL_ORIG_OB_FISH_WT_NUM IS NULL)
OR (OB_FISH_WT_MT IS NULL)
ORDER BY SPT_RPL_PTA_HEADER_V.FORMATTED_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID,
SPT_TRIP_OB_FISH_V.TRIP_DISP_NAME;
```
- <a name="example_single_QC_criteria"></a>Example Single Field QC Query:
```
CREATE OR REPLACE VIEW SPT_QC_DUP_TRIP_CATCH_V AS
SELECT
SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_NUM,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.FORMATTED_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_VESS_NAME,
SPT_RPL_PTA_HEADER_V.PTA_VESS_NAME,
SPT_RPL_PTA_HEADER_V.VESS_REG_NUM,
SPT_RPL_PTA_HEADER_V.FORMATTED_ARRIVAL_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_REG_NUM,
SPT_TRIP_EVT_V.VESS_TRIP_EVT_ID,
SPT_TRIP_EVT_V.RPL_ORIG_EVT_DATE,
SPT_TRIP_EVT_V.RPL_ORIG_ACT_CODE,
UPPER(SPT_CATCH_V.SPP_FAO_CODE) SPP_FAO_CODE,
UPPER(SPT_CATCH_V.RPL_ORIG_CATCH_SPP) RPL_ORIG_CATCH_SPP,
SPT_CATCH_V.RET_CATCH_YN,
SPT_CATCH_V.SIZE_CLASS_LABEL,
COUNT(*) NUM_DUP_SPP_RET_DISC,
'Y' INV_DB_DUP_SET_CATCH_SPP,
FORMATTED_TRIP_EVT_START_DTM,
FORMATTED_TRIP_EVT_END_DTM,
ACT_CODE,
ACT_NAME
FROM SPT_RPL_PTA_HEADER_V
INNER JOIN SPT_TRIP_EVT_V
ON SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID = SPT_TRIP_EVT_V.VESS_TRIP_ID
INNER JOIN SPT_CATCH_V
ON SPT_CATCH_V.CATCH_TRIP_EVT_ID = VESS_TRIP_EVT_ID
INNER JOIN (SELECT UPPER(SPP_FAO_CODE) SPP_FAO_CODE, CATCH_TRIP_EVT_ID, RET_CATCH_YN, CATCH_SIZE_CLASS_ID FROM SPT_CATCH_V WHERE CATCH_WT_MT > 0 group by CATCH_SIZE_CLASS_ID, UPPER(SPP_FAO_CODE), CATCH_TRIP_EVT_ID, RET_CATCH_YN having count(*) > 1) DUP_EVT_CATCH_SPP
ON
DUP_EVT_CATCH_SPP.SPP_FAO_CODE = UPPER(SPT_CATCH_V.SPP_FAO_CODE) AND DUP_EVT_CATCH_SPP.CATCH_TRIP_EVT_ID = SPT_CATCH_V.CATCH_TRIP_EVT_ID AND DUP_EVT_CATCH_SPP.RET_CATCH_YN = SPT_CATCH_V.RET_CATCH_YN
AND (DUP_EVT_CATCH_SPP.CATCH_SIZE_CLASS_ID = SPT_CATCH_V.CATCH_SIZE_CLASS_ID OR (DUP_EVT_CATCH_SPP.CATCH_SIZE_CLASS_ID IS NULL AND SPT_CATCH_V.CATCH_SIZE_CLASS_ID IS NULL))
GROUP BY
SPT_RPL_PTA_HEADER_V.VESS_TRIP_ID,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_NUM,
SPT_RPL_PTA_HEADER_V.VESS_TRIP_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.FORMATTED_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_DEPART_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_VESS_NAME,
SPT_RPL_PTA_HEADER_V.PTA_VESS_NAME,
SPT_RPL_PTA_HEADER_V.VESS_REG_NUM,
SPT_RPL_PTA_HEADER_V.FORMATTED_ARRIVAL_DTM,
SPT_RPL_PTA_HEADER_V.RPL_ORIG_REG_NUM,
SPT_TRIP_EVT_V.VESS_TRIP_EVT_ID,
SPT_TRIP_EVT_V.RPL_ORIG_EVT_DATE,
SPT_TRIP_EVT_V.RPL_ORIG_ACT_CODE,
UPPER(SPT_CATCH_V.SPP_FAO_CODE),
SPT_CATCH_V.RET_CATCH_YN,
UPPER(RPL_ORIG_CATCH_SPP),
SPT_CATCH_V.SIZE_CLASS_LABEL,
FORMATTED_TRIP_EVT_START_DTM,
FORMATTED_TRIP_EVT_END_DTM,
ACT_CODE,
ACT_NAME;
```
- <a name="issue_template_example"></a>ISS_TYPE_COMMENT_TEMPLATE example:
	 - The Fish Onboard Weight for "[TRIP_DISP_NAME]" reported on the RPL ([RPL_ORIG_OB_FISH_WT_CHR]) is different than the unconverted fish onboard weight stored in the database ([RPL_ORIG_OB_FISH_WT_NUM]) for the Vessel (RPL: [RPL_ORIG_VESS_NAME], Reg Num: [RPL_ORIG_REG_NUM]) (History: [PTA_VESS_NAME], Reg Num: [VESS_REG_NUM]) trip (VESS_TRIP_ID: [VESS_TRIP_ID]) that departed on [FORMATTED_DEPART_DTM] and arrived [FORMATTED_ARRIVAL_DTM]
