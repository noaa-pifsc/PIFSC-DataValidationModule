CREATE OR REPLACE VIEW DVM_QC_MSG_MISS_FIELDS_V AS 
select DATA_STREAM_CODE,
DATA_STREAM_DESC,
DATA_STREAM_ID,
DATA_STREAM_NAME,
DATA_STREAM_PK_FIELD,
ERROR_TYPE_ID,
ERR_SEVERITY_CODE,
ERR_SEVERITY_DESC,
ERR_SEVERITY_ID,
ERR_SEVERITY_NAME,
ERR_TYPE_ACTIVE_YN,
ERR_TYPE_COMMENT_TEMPLATE,
ERR_TYPE_DESC,
ERR_TYPE_NAME,
IND_FIELD_NAME,
OBJECT_NAME,
QC_OBJECT_ID,
QC_OBJ_ACTIVE_YN,
QC_SORT_ORDER,
DVM_PKG.QC_MISSING_QUERY_FIELDS(ERR_TYPE_COMMENT_TEMPLATE, OBJECT_NAME) MISSING_VIEW_FIELDS

from DVM_QC_CRITERIA_V WHERE DVM_PKG.QC_MISSING_QUERY_FIELDS(ERR_TYPE_COMMENT_TEMPLATE, OBJECT_NAME) IS NOT NULL;


COMMENT ON TABLE DVM_QC_MSG_MISS_FIELDS_V IS 'Data Validation Module Missing Template Field References QC (View)

This query returns all error types (DVM_ERROR_TYPES) that have a ERR_TYPE_COMMENT_TEMPLATE value that is missing one or more field references in the corresponding QC View object (based on the data dictionary).  This View should be used to identify if there are any field references that will not be populated by the Data Validation Module.  MISSING_VIEW_FIELDS will contain a comma-delimited list of field references that are not in the corresponding QC View object';

COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERROR_TYPE_ID IS 'The Error Type for the given error';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_QC_MSG_MISS_FIELDS_V.MISSING_VIEW_FIELDS IS 'The comma-delimited list of field names that is not found in the corresponding QC View object for the given error type comment template value';
