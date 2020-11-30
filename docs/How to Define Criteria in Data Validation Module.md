# How to Define Criteria in Data Validation Module
## Overview:
This document defines the comprehensive procedure for defining QC Validation Rules in the Data Validation Module (DVM).    
## Resources:
- [DVM Documentation](./Data%20Validation%20Module%20Documentation.md)
- [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md)
## Procedure:
- Define Data QC View (See [Example Multiple Criteria Data QC View](#examples) below)
	- Step 1: Define the Data Validation Criteria using spreadsheet template (ex: [QC Validation Criteria](./QC%20Validation%20Criteria%20Template.xlsx))
		- **Note: All important columns used when implementing the Validation Rules in the Data Validation Module are in columns "A" through "K" and the column headers are referenced throughout this document.
		- Each row in the spreadsheet represents a separate Data Validation Rule
		- Define the "Data Stream Code" value based on the data stream/import method being used.  There may be cases where a separate set of additional data validation rules are needed depending on the method used to enter the data (e.g. data import process vs. web application data entry) and this flexibility has been implemented using the Data Stream (DVM_DATA_STREAMS) table.  This field is used to specify the data stream when the DVM_PKG package is executed.  
			- Each new data stream type defined in the spreadsheet will require a corresponding record in the DVM_DATA_STREAMS table (Excel formula to generate the DML is in column "L") .     
		- Define the "Data Stream Name" that will be used to refer to the given data stream
		- Define the "Data Stream Parent Table" with the table name that will be associated with the DVM validation issues for the given data stream (e.g. CCD_CRUISES).  
		- Define the "Issue Severity Type" value based on the severity type of given data validation issue (e.g. ERROR, WARN, etc.)
		- Define the "QC View Name" value based on the Data QC View that will be used to evaluate the corresponding validation rule.  This view name can be defined after the query is developed or beforehand  
		- Define the "QC Object Sort Order" numeric value based on which relative order the Data QC Views should be evaluated in, this can be left blank if the order is not important  
		- Define the "QC View Field Name" with a unique field name within a given Data QC View.  This will be the View field name that will indicate if the given data validation condition has been identified in the result set data from the given Data QC View, it is recommended that you utilize the "_YN" suffix to indicate this is an indicator field for the DVM.  
			- This field name is defined as an indicator field in the corresponding Data QC View.
		- Define the purpose of the given data validation criteria in "QC Issue Type Name" column (e.g. what condition you are identifying in the data as problematic).  
		- Define the description of the validation issue in the "Issue Type Description" column.  
		- Update the spreadsheet to populate the "QC Validation Issue Message Template" column with the template text for the given issue type.  This is the template for the specific Validation Issue description that exists for the specific Validation Rule condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding Data QC View field name in the result set that will have its placeholder replaced by the corresponding result set field value.   
			- All of the placeholders in the issue type comment template must be included in the result set of the corresponding Data QC View otherwise the missing fields will not have the corresponding placeholders replaced
			- An example Validation Rule Issue Description template value can be found [here](#issue_template_example).  In this example the CRUISE_NAME field must be included in the field list of the result set for the issue type comment template to be generated correctly.  Each data validation issue identified during the data validation process will be inserted as a separate DVM_ISSUES record with an ISS_DESC value defined as the issue type comment template with all placeholders replaced with the runtime values of the Data QC View results.  This is how the context of how to identify the location of the given Validation Issue is communicated to data management staff.
				- It is not recommended to include any primary key values or timestamp fields in the Issue Description template since these will not be consistent across database instances and if their values change before the DVM is processed again those Validation Issue records will be replaced and any associated annotations will be lost.
		- Update the spreadsheet to populate the "Application Link Formula" column with the template for the custom application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the Data QC View result set that will have its placeholder replaced by the corresponding result set field value
			- example: f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)
		- Logically group the data validation criteria into similar categories (e.g. Cruise, Cruise Legs, Cruise Leg Overlap) and attempt to implement each category with as few Data QC Views as possible.  These different groups of Validation Rules will be compiled into separate Data QC Views.  
		- Export the generated DML for the DVM configuration records to a SQL script file that can be easily executed to define the DVM criteria
			- Copy the DML generated in the "Data Stream DML" column for each data stream to create the Data Stream records
			- Copy the DML generated in the "QC View DML" column for each unique "QC View Name" to create the Data QC View records
			- Copy the DML generated in the "Issue Type DML" column for each validation issue type to create the Validation Rule records

	- Step 2: Develop the Data QC View
		- Multiple Validation Rules can be implemented in a single Data QC View for efficiency purposes based on the type of Validation Rule that is being evaluated.  (e.g. a general Cruise QC query could check for both invalid cruise names and missing primary survey categories).
		- Best practice: develop foundational Oracle Views for each main database table entity in the given Data Stream.  These foundational Views should join all reference tables to allow the given main entity to be queried easily including all reference record values (e.g. CCD_CRUISE_V).  The Data QC Views should be developed directly from the foundational Oracle Views (e.g. CCD_QC_CRUISE_V).
		- Business Rules:
			- Data QC Views must contain the Parent Table primary key field (more detail is available in DVM-DB-001 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
				- For example the foundational views are as follows: Cruise (CCD_CRUISE_V) and Cruise Leg (CCD_CRUISE_LEGS_V).  When developing a Data QC View for the Cruise Legs both foundational views should be used and the fields that help to identify the given cruise leg including its parent record (Cruise) values should be included in the result set.  
			- The Parent Table's Primary Key Must be Included in the Result Set of the Given Data QC View (More information is available in DVM-DB-002 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
			- Each Data QC View indicator field defined in the QC validation rule spreadsheet must be included in the Data QC View with the corresponding column alias name (More detail is available in DVM-DB-003 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
				- **Note: If a given indicator field defined in the spreadsheet does not have a corresponding column alias in the corresponding Data QC View the DVM will fail.  
			- Each Data QC View calculated indicator field returned in the result set that indicates a validation issue are required to be implemented on the WHERE clause (based on [indicator field expression example in yellow](#example_mult_QC_criteria)) (More detail is available in DVM-DB-004 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
				- If there is only one data Validation Rule that is implemented in a given Data QC View then the ON/WHERE clause will identify all records that satisfy the given data validation criteria and have a static formula for the given indicator field since it will be true for all returned rows (see [Example Single Criteria QC Query](#example_single_QC_criteria) below)
			- Each non-indicator field that is included in the Data QC View should have a purpose in describing/providing context for the given Validation Issue (More detail is available in DVM-DB-005 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
			- QC objects and associated Issue Types can be enabled/disabled, but this will not affect Parent Records that have already been Validated (More detail is available in DVM-DB-006 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
	- Step 3: Register the Data QC View into the Data Validation Module by entering records into the database
		- Execute the DDL to define the Data QC Views
		- Define View/Field comments for the Data QC Views
			- Best practice: use [Excel formulas](./DB_DDL_helper_template.xlsx) to generate the DDL necessary to define comments on the different columns of a given Data QC View object.  Many of the View fields' comments can be pulled directly from the underlying base table's field comments using the VLOOKUP function.  
				- **Note: use the "View Comments" worksheet to generate the View field comments.   
		- Execute the DML generated by the [QC Validation Criteria Template](./QC%20Validation%20Criteria%20Template.xlsx) to define the DVM configuration.
			- **Note: it is recommended to save the generated DML so the DVM configuration can easily be deployed in a given database instance
	- Step 4: Verify that all of the Validation Rule records' Issue Description and Application Link templates' defined field placeholders have corresponding fields in the given Data QC View.
	  - Invalid template placeholders can be identified using the DVM_QC_MSG_MISS_FIELDS_V View object or by using the [DVM configuration QC Views](#DVM_config_QC)
  - Step 5 (once per parent table): Configure parent table in Data Validation Module
	  - Create the required Parent Issue foreign key column in the Parent Table by executing the [provided script](../SQL/scripts/configure_parent_table.sql) and defining the bind variables according to the included code comments and then executing/saving the resultant DDL
    - Business Rules:
	    - Parent Tables must have a single numeric primary key column (More detail is available in DVM-DB-007 in the [DVM Business Rules](./DVM%20-%20Business%20Rule%20Documentation.md))
  - <a name="DVM_config_QC"></a>Step 6: Verify the DVM Configuration is Valid
	  - Query the Combined DVM Configuration QC view (DVM_STD_QC_ALL_RPT_V), any rows returned indicate DVM configuration errors that will prevent the DVM from being processed on a given Parent Record.  Each row will contain information about what is causing the configuration error and how to resolve it.
  - Step 7: Develop and verify repeatable, automated DVM test cases
    - This process has been developed using the Centralized Cruise Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git) starting in version 0.23 (Git tag: cen_cruise_db_v0.23).  Refer to the tagged versions of the CCD that match the version of the DVM (e.g. DVM_db_v1.0) for the corresponding automated test cases.
	    - For more information review the Centralized Cruise Database DVM Testing Documentation.docx document in the docs/test_cases/DVM_PKG directory

## <a name="examples"></a>Examples Section:
- <a name="example_mult_QC_criteria"></a>Example Multiple Criteria Data QC View:

```
CREATE OR REPLACE View
CCD_QC_CRUISE_V
AS
SELECT
CRUISE_ID,
CRUISE_NAME,
FORMAT_CRUISE_START_DATE,
FORMAT_CRUISE_END_DATE,
STD_SVY_NAME_OTH,
STD_SVY_NAME,
NUM_LEGS,
CRUISE_DAS,
CRUISE_LEN_DAYS,
REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) CRUISE_NAME_FY,
SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3) CRUISE_FISC_YEAR_TRUNC,
CASE WHEN UPPER(CRUISE_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_CRUISE_NAME_COPY_YN,
CASE WHEN STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL THEN 'Y' ELSE 'N' END MISS_STD_SVY_NAME_YN,
CASE WHEN CRUISE_DAS <= 240 AND CRUISE_DAS > 120 THEN 'Y' ELSE 'N' END WARN_CRUISE_DAS_YN,
CASE WHEN CRUISE_DAS > 240 THEN 'Y' ELSE 'N' END ERR_CRUISE_DAS_YN,
CASE WHEN CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160 THEN 'Y' ELSE 'N' END WARN_CRUISE_DATE_RNG_YN,
CASE WHEN CRUISE_LEN_DAYS > 280 THEN 'Y' ELSE 'N' END ERR_CRUISE_DATE_RNG_YN,
CASE WHEN NUM_PRIM_SVY_CATS IS NULL THEN 'Y' ELSE 'N' END MISS_PRIM_SVY_CAT_YN,
CASE WHEN NOT REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_YN,
--if the CRUISE_FISC_YEAR is not null, and the CRUISE_NAME is valid, then check if the last two digits of the fiscal year don't match the extracted fiscal year
CASE WHEN (CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3)) THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_FY_YN

FROM CCD_CRUISE_DELIM_V
WHERE
UPPER(CRUISE_NAME) LIKE '% (COPY)%'
OR (STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL)
OR (CRUISE_DAS <= 240 AND CRUISE_DAS > 120)
OR (CRUISE_DAS > 240)
OR (CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160)
OR (CRUISE_LEN_DAYS > 280)
OR (NUM_PRIM_SVY_CATS IS NULL)
OR (NOT REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i'))
OR (CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3))
ORDER BY CRUISE_NAME, CRUISE_START_DATE;
```
- <a name="example_single_QC_criteria"></a>Example Single Field Data QC View:

```
CREATE OR REPLACE View
CCD_QC_LEG_ALIAS_V
AS
SELECT
CCD_CRUISE_LEGS_V.CRUISE_LEG_ID,
CRUISE_ID,
CRUISE_NAME,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_ALIAS_NAME,
LEG_ALIAS_DESC,
CASE WHEN UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_ALIAS_COPY_YN

FROM CCD_CRUISE_LEGS_V
INNER JOIN
CCD_LEG_ALIASES
ON CCD_CRUISE_LEGS_V.CRUISE_LEG_ID = CCD_LEG_ALIASES.CRUISE_LEG_ID

WHERE
UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%'
ORDER BY LEG_NAME;
```
- <a name="issue_template_example"></a>ISS_TYPE_COMMENT_TEMPLATE example:
	 - The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has an invalid Cruise Name based on the required naming convention: {SN}-{YR}-{##} where {SN} is a valid abbreviation for a NOAA ship name, {YR} is a two digit year with a leading zero, and {##} is a sequential number with a leading zero
