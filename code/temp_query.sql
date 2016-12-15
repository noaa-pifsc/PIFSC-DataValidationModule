CREATE OR REPLACE VIEW DVM_PTA_ERRORS_V
AS
SELECT
  DVM_PTA_ERRORS.PTA_ERROR_ID,
  DVM_PTA_ERRORS.CREATE_DATE,
  TO_CHAR(DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,
  DVM_PTA_ERRORS.LAST_EVAL_DATE,
  TO_CHAR(DVM_PTA_ERRORS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_LAST_EVAL_DATE,
  DVM_ERRORS.ERROR_ID,
  DVM_ERRORS.ERROR_DESCRIPTION,
  DVM_ERRORS.ERROR_NOTES,
  DVM_ERRORS.ERROR_TYPE_ID,
  DVM_ERROR_TYPES.ERR_TYPE_NAME,
  DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE,
  DVM_ERROR_TYPES.QC_OBJECT_ID,
  DVM_QC_OBJECTS.OBJECT_NAME,
  DVM_QC_OBJECTS.QC_OBJ_ACTIVE_YN,
  DVM_QC_OBJECTS.QC_SORT_ORDER,
  DVM_ERROR_TYPES.ERR_TYPE_DESC,
  DVM_ERROR_TYPES.IND_FIELD_NAME,
  DVM_ERROR_TYPES.ERR_SEVERITY_ID,
  DVM_ERR_SEVERITY.ERR_SEVERITY_CODE,
  DVM_ERR_SEVERITY.ERR_SEVERITY_NAME,
  DVM_ERR_SEVERITY.ERR_SEVERITY_DESC,
  DVM_ERROR_TYPES.DATA_STREAM_ID,
  DVM_DATA_STREAMS.DATA_STREAM_CODE,
  DVM_DATA_STREAMS.DATA_STREAM_NAME,
  DVM_DATA_STREAMS.DATA_STREAM_DESC,
  DVM_ERROR_TYPES.ERR_TYPE_ACTIVE_YN,
  DVM_ERRORS.ERR_RES_TYPE_ID,
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_CODE,
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_NAME,
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_DESC

FROM
  DVM_ERRORS
INNER JOIN DVM_PTA_ERRORS
ON
  DVM_PTA_ERRORS.PTA_ERROR_ID = DVM_ERRORS.PTA_ERROR_ID
INNER JOIN DVM_ERROR_TYPES
ON
  DVM_ERROR_TYPES.ERROR_TYPE_ID = DVM_ERRORS.ERROR_TYPE_ID
INNER JOIN DVM_DATA_STREAMS
ON
  DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
INNER JOIN DVM_ERR_SEVERITY
ON
  DVM_ERR_SEVERITY.ERR_SEVERITY_ID = DVM_ERROR_TYPES.ERR_SEVERITY_ID
INNER JOIN DVM_QC_OBJECTS
ON
  DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
LEFT JOIN DVM_ERR_RES_TYPES
ON
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_ID = DVM_ERRORS.ERR_RES_TYPE_ID

  ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_QC_OBJECTS.QC_SORT_ORDER, DVM_QC_OBJECTS.OBJECT_NAME  
  ;
  
  COMMENT ON TABLE DVM_PTA_ERRORS_V IS 'PTA Errors (View)

This View returns all unresolved Errors associated with a given PTA Error record that were identified during the last evaluation of the associated PTA Error Types.  A PTA Error record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each error identified as well as general information about the given Error''s Error Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.';



COMMENT ON COLUMN DVM_PTA_ERRORS_V.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERROR_DESCRIPTION IS 'The description of the given XML Data File error';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERROR_NOTES IS 'Manually entered notes for the corresponding data error';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERROR_ID IS 'Primary Key for the SPT_ERRORS table';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERROR_TYPE_ID IS 'The Error Type for the given error';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.FORMATTED_CREATE_DATE IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.FORMATTED_LAST_EVAL_DATE IS 'The formatted date/time on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.LAST_EVAL_DATE IS 'The date on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.PTA_ERROR_ID IS 'Foreign key reference to the Errors (PTA) intersection table';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_RES_TYPE_ID IS 'Primary Key for the SPT_ERR_RES_TYPES table';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_RES_TYPE_CODE IS 'The Error Resolution Type code';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_RES_TYPE_NAME IS 'The Error Resolution Type name';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.ERR_RES_TYPE_DESC IS 'The Error Resolution Type description';


--view to retrieve all validation rules
--this query retrieves all validation rules for QC objects sorted by the QC_SORT_ORDER:
CREATE OR REPLACE VIEW DVM_QC_CRITERIA_V AS

  SELECT
  DVM_QC_OBJECTS.QC_OBJECT_ID,
  DVM_QC_OBJECTS.OBJECT_NAME,
  DVM_QC_OBJECTS.QC_OBJ_ACTIVE_YN,
  DVM_QC_OBJECTS.QC_SORT_ORDER,
  DVM_ERROR_TYPES.ERROR_TYPE_ID,
  DVM_ERROR_TYPES.ERR_TYPE_NAME,
  DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE,
  DVM_ERROR_TYPES.ERR_TYPE_DESC,
  DVM_ERROR_TYPES.IND_FIELD_NAME,
  DVM_ERROR_TYPES.ERR_SEVERITY_ID,
  DVM_ERR_SEVERITY.ERR_SEVERITY_CODE,
  DVM_ERR_SEVERITY.ERR_SEVERITY_NAME,
  DVM_ERR_SEVERITY.ERR_SEVERITY_DESC,
  DVM_ERROR_TYPES.DATA_STREAM_ID,
  DVM_DATA_STREAMS.DATA_STREAM_CODE,
  DVM_DATA_STREAMS.DATA_STREAM_NAME,
  DVM_DATA_STREAMS.DATA_STREAM_DESC,
  DVM_ERROR_TYPES.ERR_TYPE_ACTIVE_YN
FROM
  DVM_ERROR_TYPES
INNER JOIN DVM_ERR_SEVERITY
ON
  DVM_ERR_SEVERITY.ERR_SEVERITY_ID = DVM_ERROR_TYPES.ERR_SEVERITY_ID
INNER JOIN DVM_DATA_STREAMS
ON
  DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
INNER JOIN DVM_QC_OBJECTS
ON
  DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
ORDER BY

DVM_QC_OBJECTS.QC_SORT_ORDER;

COMMENT ON TABLE DVM_QC_CRITERIA_V IS 'QC Criteria (View)

This View returns all QC Criteria (Error Types) defined in the database and their associated QC Object, Error Severity, and Error Category.  This query is used to define all PTA Error Types when a data stream is first entered into the database';

COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERROR_TYPE_ID IS 'The Error Type for the given error';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_QC_CRITERIA_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';


--query for all PTA error types associated with a given PTA Error Type record (corresponds to the parent table for a given data stream)
CREATE OR REPLACE VIEW DVM_PTA_ERROR_TYPES_V
AS
SELECT
  DVM_PTA_ERRORS.PTA_ERROR_ID,
  DVM_PTA_ERRORS.CREATE_DATE,
  TO_CHAR(DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,
  DVM_PTA_ERR_TYP_ASSOC.PTA_ERR_TYP_ASSOC_ID,
  DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID,
  DVM_ERROR_TYPES.ERR_TYPE_NAME,
  DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE,
  DVM_QC_OBJECTS.QC_OBJECT_ID,
  DVM_QC_OBJECTS.OBJECT_NAME,
  DVM_QC_OBJECTS.QC_OBJ_ACTIVE_YN,
  DVM_QC_OBJECTS.QC_SORT_ORDER,
  DVM_ERROR_TYPES.ERR_TYPE_DESC,
  DVM_ERROR_TYPES.IND_FIELD_NAME,
  DVM_ERROR_TYPES.ERR_SEVERITY_ID,
  DVM_ERR_SEVERITY.ERR_SEVERITY_CODE,
  DVM_ERR_SEVERITY.ERR_SEVERITY_NAME,
  DVM_ERR_SEVERITY.ERR_SEVERITY_DESC,
  DVM_ERROR_TYPES.DATA_STREAM_ID,
  DVM_DATA_STREAMS.DATA_STREAM_CODE,
  DVM_DATA_STREAMS.DATA_STREAM_NAME,
  DVM_DATA_STREAMS.DATA_STREAM_DESC,
  DVM_ERROR_TYPES.ERR_TYPE_ACTIVE_YN
FROM
  DVM_PTA_ERRORS
INNER JOIN DVM_PTA_ERR_TYP_ASSOC
ON
  DVM_PTA_ERRORS.PTA_ERROR_ID =
  DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID
INNER JOIN DVM_ERROR_TYPES
ON
  DVM_ERROR_TYPES.ERROR_TYPE_ID = DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID
INNER JOIN DVM_QC_OBJECTS
ON
  DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
INNER JOIN DVM_ERR_SEVERITY
ON
  DVM_ERR_SEVERITY.ERR_SEVERITY_ID = DVM_ERROR_TYPES.ERR_SEVERITY_ID
INNER JOIN DVM_DATA_STREAMS
ON
  DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_QC_OBJECTS.QC_SORT_ORDER, DVM_QC_OBJECTS.OBJECT_NAME
;

COMMENT ON TABLE DVM_PTA_ERROR_TYPES_V IS 'PTA Error Types (View)

This View returns all Error Types associated with a given PTA Error Type record.  The PTA Error Type record is defined the first time the given data stream is first entered into the database, all active Error Types at this point in time are saved and associated with a new PTA Error Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Error Types that were associated with the a data stream when the given parent record is first entered into the database.  ';

COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERROR_TYPE_ID IS 'The Error Type for the given error';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.FORMATTED_CREATE_DATE IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.PTA_ERROR_ID IS 'Primary Key for the SPT_PTA_ERRORS table';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.PTA_ERR_TYP_ASSOC_ID IS 'Primary Key for the SPT_PTA_ERR_TYP_ASSOC table';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_PTA_ERROR_TYPES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
