DROP VIEW SPTT.DVM_DATA_STREAMS_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_DATA_STREAMS_V
(DATA_STREAM_ID, DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_DESC, DATA_STREAM_PAR_TABLE,
 DATA_STREAM_PK_FIELD)
BEQUEATH DEFINER
AS

SELECT DVM_DATA_STREAMS.DATA_STREAM_ID,
       DVM_DATA_STREAMS.DATA_STREAM_CODE,
       DVM_DATA_STREAMS.DATA_STREAM_NAME,
       DVM_DATA_STREAMS.DATA_STREAM_DESC,
       DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE,
       PK_INFO.COLUMN_NAME DATA_STREAM_PK_FIELD
  FROM dvm_data_streams
       LEFT JOIN
       (SELECT A.TABLE_NAME, A.COLUMN_NAME
          FROM user_cons_columns A
               INNER JOIN user_CONSTRAINTS C
                  ON     A.TABLE_NAME = C.TABLE_NAME
                     AND A.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                     --retrieve only primary key constraints
                     AND C.CONSTRAINT_TYPE IN ('P')) PK_INFO
          ON PK_INFO.TABLE_NAME = DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE;

COMMENT ON TABLE SPTT.DVM_DATA_STREAMS_V IS 'Data Streams (View)

This query returns all data streams that are implemented in the data validation module.  Examples of data streams are RPL, eTunaLog, UL, FOT, LFSC.  This is used to filter error records based on the given context of the processing/validation.  This view also returns the PK field name for each of the data streams based on the value of DATA_STREAM_PAR_TABLE using the current schema''s data dictionary';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';


DROP VIEW SPTT.DVM_ERRORS_HIST_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_ERRORS_HIST_V
(PTA_ERROR_ID, ERROR_TYPE_ID, IND_FIELD_NAME, ERR_TYPE_ACTIVE_YN, DATA_STREAM_CODE,
 ERROR_ID, ERR_SEVERITY_CODE, CHANGE_TYPE, CHANGE_DATE, OS_USER,
 ERR_RES_TYPE_ID, ERR_RES_TYPE_CODE, ERROR_NOTES, ERROR_DESCRIPTION)
BEQUEATH DEFINER
AS

WITH D
        AS (  -- DVM_ERRORS_HIST_V.sql
              -- HYW(11/30/2017): re-construct the deleted DVM_ERRORS from DVM_ERRORS_HIST (bc the errors were deleted after annotation)
              --                  error_description added in trigger on 11/30/2017, so only shown after 12/1/2017
              -- HYW(12/4/2017): simplified the script as PTA_ERROR_ID, and ERROR_TYPE_ID updated in HIST tbl
              SELECT H_TYPE_OF_CHANGE CHANGE_TYPE,
                     --  H_DATE_OF_CHANGE                                                                                            CHANGE_DATE,
                     TO_CHAR (H_DATE_OF_CHANGE, 'YYYY-MM-DD') CHANGE_DATE,
                     H_OS_USER OS_USER,
                     ERROR_ID,
                     PTA_ERROR_ID,
                     ERROR_TYPE_ID,
                     MIN (
                        (CASE
                            WHEN     H_CHANGED_COLUMN = 'err_res_type_id'
                                 AND H_TYPE_OF_CHANGE = 'DELETE'
                            THEN
                               TO_NUMBER (H_OLD_DATA, '99999999')
                            WHEN     H_CHANGED_COLUMN = 'ERR_RES_TYPE_ID'
                                 AND H_TYPE_OF_CHANGE = 'UPDATE'
                            THEN
                               TO_NUMBER (H_NEW_DATA, '99999999')
                         END))
                        err_res_type_id,
                     MIN (
                        (CASE
                            WHEN     H_CHANGED_COLUMN = 'error_notes'
                                 AND H_TYPE_OF_CHANGE = 'DELETE'
                            THEN
                               SUBSTR (H_OLD_DATA, 1, LENGTH (H_OLD_DATA))
                            WHEN     H_CHANGED_COLUMN = 'ERROR_NOTES'
                                 AND H_TYPE_OF_CHANGE = 'UPDATE'
                            THEN
                               SUBSTR (H_NEW_DATA, 1, LENGTH (H_NEW_DATA))
                         END))
                        error_notes,
                     MIN (
                        (CASE
                            WHEN     H_CHANGED_COLUMN = 'error_description'
                                 AND H_TYPE_OF_CHANGE = 'DELETE'
                            THEN
                               SUBSTR (H_OLD_DATA, 1, LENGTH (H_OLD_DATA))
                            WHEN     H_CHANGED_COLUMN = 'ERROR_DESCRIPTION'
                                 AND H_TYPE_OF_CHANGE = 'UPDATE'
                            THEN
                               SUBSTR (H_NEW_DATA, 1, LENGTH (H_NEW_DATA))
                         END))
                        error_description
                FROM DVM_ERRORS_HIST
            --  where H_TYPE_OF_CHANGE in ('DELETE', 'UPDATE')
            GROUP BY H_TYPE_OF_CHANGE,
                     TO_CHAR (H_DATE_OF_CHANGE, 'YYYY-MM-DD'),
                     H_OS_USER,
                     ERROR_ID,
                     PTA_ERROR_ID,
                     ERROR_TYPE_ID)
  --
  SELECT D.PTA_ERROR_ID,
         D.ERROR_TYPE_ID,
         T.IND_FIELD_NAME,
         T.ERR_TYPE_ACTIVE_YN,
         T.DATA_STREAM_CODE,
         D.ERROR_ID,
         T.ERR_SEVERITY_CODE,
         D.CHANGE_TYPE,
         D.CHANGE_DATE,
         D.OS_USER,
         D.ERR_RES_TYPE_ID,
         R.ERR_RES_TYPE_CODE,
         D.ERROR_NOTES,
         D.ERROR_DESCRIPTION
    FROM D
         LEFT JOIN DVM_QC_CRITERIA_V T ON D.ERROR_TYPE_ID = T.ERROR_TYPE_ID
         LEFT JOIN DVM_ERR_RES_TYPES R ON D.ERR_RES_TYPE_ID = R.ERR_RES_TYPE_ID
ORDER BY PTA_ERROR_ID,
         IND_FIELD_NAME,
         ERROR_ID,
         CHANGE_DATE;


DROP VIEW SPTT.DVM_ERRORS_HIST_V_OLD;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_ERRORS_HIST_V_OLD
(PTA_ERROR_ID, DATA_STREAM_CODE, ERROR_TYPE_ID, ERR_TYPE_ACTIVE_YN, IND_FIELD_NAME,
 ERROR_ID, ERR_SEVERITY_CODE, CHANGE_TYPE, CHANGE_DATE, OS_USER,
 ERR_RES_TYPE_ID, ERR_RES_TYPE_CODE, ERROR_NOTES, ERROR_DESCRIPTION)
BEQUEATH DEFINER
AS

WITH D
        AS (  -- DVM_ERRORS_HIST_V.sql
              -- HYW(11/30/2017): re-construct the deleted DVM_ERRORS from DVM_ERRORS_HIST (bc the errors were deleted after annotation)
              --                  error_description only shown after 12/1/2017 as added it was added in trigger on 11/30/2017
              SELECT H_TYPE_OF_CHANGE CHANGE_TYPE,
                     --  H_DATE_OF_CHANGE                                                                                            CHANGE_DATE,
                     TO_CHAR (H_DATE_OF_CHANGE, 'YYYY-MM-DD') CHANGE_DATE,
                     H_OS_USER OS_USER,
                     ERROR_ID,
                     MIN (
                        (CASE
                            WHEN H_CHANGED_COLUMN = 'pta_error_id'
                            THEN
                               TO_NUMBER (H_OLD_DATA, '99999999')
                         END))
                        pta_error_id,
                     MIN (
                        (CASE
                            WHEN H_CHANGED_COLUMN = 'error_type_id'
                            THEN
                               TO_NUMBER (H_OLD_DATA, '99999999')
                         END))
                        error_type_id,
                     MIN (
                        (CASE
                            WHEN H_CHANGED_COLUMN = 'err_res_type_id'
                            THEN
                               TO_NUMBER (H_OLD_DATA, '99999999')
                         END))
                        err_res_type_id,
                     MIN (
                        (CASE
                            WHEN H_CHANGED_COLUMN = 'error_notes'
                            THEN
                               SUBSTR (H_OLD_DATA, 1, LENGTH (H_OLD_DATA))
                         END))
                        error_notes,
                     MIN (
                        (CASE
                            WHEN H_CHANGED_COLUMN = 'error_description'
                            THEN
                               SUBSTR (H_OLD_DATA, 1, LENGTH (H_OLD_DATA))
                         END))
                        error_description
                FROM DVM_ERRORS_HIST
               WHERE H_TYPE_OF_CHANGE IN ('DELETE', 'UPDATE')
            --group by H_TYPE_OF_CHANGE, H_DATE_OF_CHANGE, ERROR_ID
            GROUP BY H_TYPE_OF_CHANGE,
                     TO_CHAR (H_DATE_OF_CHANGE, 'YYYY-MM-DD'),
                     H_OS_USER,
                     ERROR_ID)
  --
  SELECT D.PTA_ERROR_ID,
         T.DATA_STREAM_CODE,
         D.ERROR_TYPE_ID,
         T.ERR_TYPE_ACTIVE_YN,
         T.IND_FIELD_NAME,
         D.ERROR_ID,
         T.ERR_SEVERITY_CODE,
         D.CHANGE_TYPE,
         D.CHANGE_DATE,
         D.OS_USER,
         D.ERR_RES_TYPE_ID,
         R.ERR_RES_TYPE_CODE,
         D.ERROR_NOTES,
         D.ERROR_DESCRIPTION
    FROM D
         LEFT JOIN DVM_QC_CRITERIA_V T ON D.ERROR_TYPE_ID = T.ERROR_TYPE_ID
         LEFT JOIN DVM_ERR_RES_TYPES R ON D.ERR_RES_TYPE_ID = R.ERR_RES_TYPE_ID
ORDER BY PTA_ERROR_ID,
         IND_FIELD_NAME,
         ERROR_ID,
         CHANGE_DATE;


DROP VIEW SPTT.DVM_PTA_ERRORS_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_PTA_ERRORS_V
(PTA_ERROR_ID, CREATE_DATE, FORMATTED_CREATE_DATE, LAST_EVAL_DATE, FORMATTED_LAST_EVAL_DATE,
 ERROR_ID, ERROR_DESCRIPTION, ERROR_NOTES, ERROR_TYPE_ID, ERR_TYPE_NAME,
 ERR_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER,
 ERR_TYPE_DESC, IND_FIELD_NAME, ERR_SEVERITY_ID, ERR_SEVERITY_CODE, ERR_SEVERITY_NAME,
 ERR_SEVERITY_DESC, DATA_STREAM_ID, DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_DESC,
 ERR_TYPE_ACTIVE_YN, ERR_RES_TYPE_ID, ERR_RES_TYPE_CODE, ERR_RES_TYPE_NAME, ERR_RES_TYPE_DESC)
BEQUEATH DEFINER
AS

  SELECT DVM_PTA_ERRORS.PTA_ERROR_ID,
         DVM_PTA_ERRORS.CREATE_DATE,
         TO_CHAR (DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI')
            FORMATTED_CREATE_DATE,
         DVM_PTA_ERRORS.LAST_EVAL_DATE,
         TO_CHAR (DVM_PTA_ERRORS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI')
            FORMATTED_LAST_EVAL_DATE,
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
    FROM DVM_ERRORS
         INNER JOIN DVM_PTA_ERRORS
            ON DVM_PTA_ERRORS.PTA_ERROR_ID = DVM_ERRORS.PTA_ERROR_ID
         INNER JOIN DVM_ERROR_TYPES
            ON DVM_ERROR_TYPES.ERROR_TYPE_ID = DVM_ERRORS.ERROR_TYPE_ID
         INNER JOIN DVM_DATA_STREAMS
            ON DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
         INNER JOIN DVM_ERR_SEVERITY
            ON DVM_ERR_SEVERITY.ERR_SEVERITY_ID =
                  DVM_ERROR_TYPES.ERR_SEVERITY_ID
         INNER JOIN DVM_QC_OBJECTS
            ON DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
         LEFT JOIN DVM_ERR_RES_TYPES
            ON DVM_ERR_RES_TYPES.ERR_RES_TYPE_ID = DVM_ERRORS.ERR_RES_TYPE_ID
ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID,
         DVM_QC_OBJECTS.QC_SORT_ORDER,
         DVM_QC_OBJECTS.OBJECT_NAME;

COMMENT ON TABLE SPTT.DVM_PTA_ERRORS_V IS 'PTA Errors (View)

This View returns all unresolved Errors associated with a given PTA Error record that were identified during the last evaluation of the associated PTA Error Types.  A PTA Error record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each error identified as well as general information about the given Error''s Error Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.PTA_ERROR_ID IS 'Foreign key reference to the Errors (PTA) intersection table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.FORMATTED_CREATE_DATE IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.LAST_EVAL_DATE IS 'The date on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.FORMATTED_LAST_EVAL_DATE IS 'The formatted date/time on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated (MM/DD/YYYY HH24:MI)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERROR_ID IS 'Primary Key for the SPT_ERRORS table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERROR_DESCRIPTION IS 'The description of the given XML Data File error';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERROR_NOTES IS 'Manually entered notes for the corresponding data error';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERROR_TYPE_ID IS 'The Error Type for the given error';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_RES_TYPE_ID IS 'Primary Key for the SPT_ERR_RES_TYPES table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_RES_TYPE_CODE IS 'The Error Resolution Type code';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_RES_TYPE_NAME IS 'The Error Resolution Type name';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_V.ERR_RES_TYPE_DESC IS 'The Error Resolution Type description';


DROP VIEW SPTT.DVM_PTA_ERROR_TYPES_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_PTA_ERROR_TYPES_V
(PTA_ERROR_ID, CREATE_DATE, FORMATTED_CREATE_DATE, PTA_ERR_TYP_ASSOC_ID, ERROR_TYPE_ID,
 ERR_TYPE_NAME, ERR_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, OBJECT_NAME, QC_OBJ_ACTIVE_YN,
 QC_SORT_ORDER, ERR_TYPE_DESC, IND_FIELD_NAME, ERR_SEVERITY_ID, ERR_SEVERITY_CODE,
 ERR_SEVERITY_NAME, ERR_SEVERITY_DESC, DATA_STREAM_ID, DATA_STREAM_CODE, DATA_STREAM_NAME,
 DATA_STREAM_DESC, ERR_TYPE_ACTIVE_YN)
BEQUEATH DEFINER
AS

  SELECT DVM_PTA_ERRORS.PTA_ERROR_ID,
         DVM_PTA_ERRORS.CREATE_DATE,
         TO_CHAR (DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI')
            FORMATTED_CREATE_DATE,
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
    FROM DVM_PTA_ERRORS
         INNER JOIN DVM_PTA_ERR_TYP_ASSOC
            ON DVM_PTA_ERRORS.PTA_ERROR_ID = DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID
         INNER JOIN DVM_ERROR_TYPES
            ON DVM_ERROR_TYPES.ERROR_TYPE_ID =
                  DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID
         INNER JOIN DVM_QC_OBJECTS
            ON DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
         INNER JOIN DVM_ERR_SEVERITY
            ON DVM_ERR_SEVERITY.ERR_SEVERITY_ID =
                  DVM_ERROR_TYPES.ERR_SEVERITY_ID
         INNER JOIN DVM_DATA_STREAMS
            ON DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID,
         DVM_QC_OBJECTS.QC_SORT_ORDER,
         DVM_QC_OBJECTS.OBJECT_NAME;

COMMENT ON TABLE SPTT.DVM_PTA_ERROR_TYPES_V IS 'PTA Error Types (View)

This View returns all Error Types associated with a given PTA Error Type record.  The PTA Error Type record is defined the first time the given data stream is first entered into the database, all active Error Types at this point in time are saved and associated with a new PTA Error Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Error Types that were associated with the a data stream when the given parent record is first entered into the database.  ';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.PTA_ERROR_ID IS 'Primary Key for the SPT_PTA_ERRORS table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.FORMATTED_CREATE_DATE IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.PTA_ERR_TYP_ASSOC_ID IS 'Primary Key for the SPT_PTA_ERR_TYP_ASSOC table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERROR_TYPE_ID IS 'The Error Type for the given error';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_PTA_ERROR_TYPES_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';


DROP VIEW SPTT.DVM_QC_CRITERIA_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_QC_CRITERIA_V
(QC_OBJECT_ID, OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER, ERROR_TYPE_ID,
 ERR_TYPE_NAME, ERR_TYPE_COMMENT_TEMPLATE, ERR_TYPE_DESC, IND_FIELD_NAME, ERR_SEVERITY_ID,
 ERR_SEVERITY_CODE, ERR_SEVERITY_NAME, ERR_SEVERITY_DESC, DATA_STREAM_ID, DATA_STREAM_CODE,
 DATA_STREAM_NAME, DATA_STREAM_DESC, DATA_STREAM_PK_FIELD, ERR_TYPE_ACTIVE_YN)
BEQUEATH DEFINER
AS

  SELECT DVM_QC_OBJECTS.QC_OBJECT_ID,
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
         DVM_DATA_STREAMS_V.DATA_STREAM_CODE,
         DVM_DATA_STREAMS_V.DATA_STREAM_NAME,
         DVM_DATA_STREAMS_V.DATA_STREAM_DESC,
         DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD,
         DVM_ERROR_TYPES.ERR_TYPE_ACTIVE_YN
    FROM DVM_ERROR_TYPES
         INNER JOIN DVM_ERR_SEVERITY
            ON DVM_ERR_SEVERITY.ERR_SEVERITY_ID =
                  DVM_ERROR_TYPES.ERR_SEVERITY_ID
         INNER JOIN DVM_DATA_STREAMS_V
            ON DVM_DATA_STREAMS_V.DATA_STREAM_ID =
                  DVM_ERROR_TYPES.DATA_STREAM_ID
         INNER JOIN DVM_QC_OBJECTS
            ON DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
ORDER BY DVM_QC_OBJECTS.QC_SORT_ORDER;

COMMENT ON TABLE SPTT.DVM_QC_CRITERIA_V IS 'QC Criteria (View)

This View returns all QC Criteria (Error Types) defined in the database and their associated QC Object, Error Severity, and Error Category.  This query is used to define all PTA Error Types when a data stream is first entered into the database';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERROR_TYPE_ID IS 'The Error Type for the given error';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';

COMMENT ON COLUMN SPTT.DVM_QC_CRITERIA_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';


DROP VIEW SPTT.DVM_QC_MSG_MISS_FIELDS_V;

/* Formatted on 6/22/2022 3:37:57 PM (QP5 v5.277) */
CREATE OR REPLACE FORCE VIEW SPTT.DVM_QC_MSG_MISS_FIELDS_V
(DATA_STREAM_CODE, DATA_STREAM_DESC, DATA_STREAM_ID, DATA_STREAM_NAME, DATA_STREAM_PK_FIELD,
 ERROR_TYPE_ID, ERR_SEVERITY_CODE, ERR_SEVERITY_DESC, ERR_SEVERITY_ID, ERR_SEVERITY_NAME,
 ERR_TYPE_ACTIVE_YN, ERR_TYPE_COMMENT_TEMPLATE, ERR_TYPE_DESC, ERR_TYPE_NAME, IND_FIELD_NAME,
 OBJECT_NAME, QC_OBJECT_ID, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER, MISSING_VIEW_FIELDS)
BEQUEATH DEFINER
AS

SELECT DATA_STREAM_CODE,
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
       DVM_PKG.QC_MISSING_QUERY_FIELDS (ERR_TYPE_COMMENT_TEMPLATE,
                                        OBJECT_NAME)
          MISSING_VIEW_FIELDS
  FROM DVM_QC_CRITERIA_V
 WHERE DVM_PKG.QC_MISSING_QUERY_FIELDS (ERR_TYPE_COMMENT_TEMPLATE,
                                        OBJECT_NAME)
          IS NOT NULL;

COMMENT ON TABLE SPTT.DVM_QC_MSG_MISS_FIELDS_V IS 'Data Validation Module Missing Template Field References QC (View)

This query returns all error types (DVM_ERROR_TYPES) that have a ERR_TYPE_COMMENT_TEMPLATE value that is missing one or more field references in the corresponding QC View object (based on the data dictionary).  This View should be used to identify if there are any field references that will not be populated by the Data Validation Module.  MISSING_VIEW_FIELDS will contain a comma-delimited list of field references that are not in the corresponding QC View object';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERROR_TYPE_ID IS 'The Error Type for the given error';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';

COMMENT ON COLUMN SPTT.DVM_QC_MSG_MISS_FIELDS_V.MISSING_VIEW_FIELDS IS 'The comma-delimited list of field names that is not found in the corresponding QC View object for the given error type comment template value';


GRANT SELECT ON SPTT.DVM_DATA_STREAMS_V TO DDY;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST_V TO DDY;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST_V_OLD TO DDY;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS_V TO DDY;

GRANT SELECT ON SPTT.DVM_PTA_ERROR_TYPES_V TO DDY;

GRANT SELECT ON SPTT.DVM_QC_CRITERIA_V TO DDY;

GRANT SELECT ON SPTT.DVM_QC_MSG_MISS_FIELDS_V TO DDY;

GRANT SELECT ON SPTT.DVM_DATA_STREAMS_V TO HWANG;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST_V TO HWANG;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST_V_OLD TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS_V TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERROR_TYPES_V TO HWANG;

GRANT SELECT ON SPTT.DVM_QC_CRITERIA_V TO HWANG;

GRANT SELECT ON SPTT.DVM_QC_MSG_MISS_FIELDS_V TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS_V TO MIWANE;
