ALTER TABLE SPTT.APX_ERR_CONSTR_MSG
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.APX_ERR_CONSTR_MSG CASCADE CONSTRAINTS;

CREATE TABLE SPTT.APX_ERR_CONSTR_MSG
(
  CONSTR_MSG_ID    NUMBER                       NOT NULL,
  CONSTRAINT_NAME  VARCHAR2(30 BYTE)            NOT NULL,
  ERR_MESSAGE      VARCHAR2(2000 BYTE)          NOT NULL
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.APX_ERR_CONSTR_MSG IS 'APEX Custom Database Constraint Error Messages

This table contains the different database constraint error messages that will serve to provide an informative message to the end user while not exposing sensitive information that could potentially be used to launch attacks on the underlying application/database servers.  This was originally developed in response to the SI-11 security control';

COMMENT ON COLUMN SPTT.APX_ERR_CONSTR_MSG.CONSTR_MSG_ID IS 'Primary Key for the APX_ERR_CONSTR_MSG table';

COMMENT ON COLUMN SPTT.APX_ERR_CONSTR_MSG.CONSTRAINT_NAME IS 'The database constraint name the given custom error message is defined for.';

COMMENT ON COLUMN SPTT.APX_ERR_CONSTR_MSG.ERR_MESSAGE IS 'The user-defined error message that will be shown to the application users when the given CONSTRAINT_NAME is violated';


ALTER TABLE SPTT.DVM_DATA_STREAMS
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_DATA_STREAMS CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_DATA_STREAMS
(
  DATA_STREAM_ID         NUMBER                 NOT NULL,
  DATA_STREAM_CODE       VARCHAR2(20 BYTE)      NOT NULL,
  DATA_STREAM_NAME       VARCHAR2(100 BYTE)     NOT NULL,
  DATA_STREAM_DESC       VARCHAR2(1000 BYTE),
  CREATE_DATE            DATE,
  CREATED_BY             VARCHAR2(30 BYTE),
  LAST_MOD_DATE          DATE,
  LAST_MOD_BY            VARCHAR2(30 BYTE),
  DATA_STREAM_PAR_TABLE  VARCHAR2(30 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_DATA_STREAMS IS 'Data Streams

This is a reference table that defines all data streams that are implemented in the data validation module.  This reference table is referenced by the DVM_ERROR_TYPES to define the data stream that the given error type is associated with.  Examples of data streams are RPL, eTunaLog, UL, FOT, LFSC.  This is used to filter these records based on the given context of the processing/validation';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.DATA_STREAM_CODE IS 'The code for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.DATA_STREAM_NAME IS 'The name for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.DATA_STREAM_DESC IS 'The description for the given data stream';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';


DROP TABLE SPTT.DVM_DATA_STREAMS_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_DATA_STREAMS_HIST
(
  H_SEQNUM              NUMBER(10),
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE),
  H_DATE_OF_CHANGE      DATE,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE),
  H_OS_USER             VARCHAR2(30 BYTE),
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  DATA_STREAM_ID        NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_DATA_STREAMS_HIST.DATA_STREAM_ID IS 'Primary key column of the data table';


ALTER TABLE SPTT.DVM_ERRORS
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_ERRORS CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERRORS
(
  ERROR_ID           NUMBER                     NOT NULL,
  PTA_ERROR_ID       NUMBER                     NOT NULL,
  CREATE_DATE        DATE,
  CREATED_BY         VARCHAR2(30 BYTE),
  LAST_MOD_DATE      DATE,
  LAST_MOD_BY        VARCHAR2(30 BYTE),
  ERROR_TYPE_ID      NUMBER                     NOT NULL,
  ERROR_NOTES        VARCHAR2(500 BYTE),
  ERR_RES_TYPE_ID    NUMBER,
  ERROR_DESCRIPTION  CLOB                       NOT NULL
)
LOB (ERROR_DESCRIPTION) STORE AS (
  TABLESPACE  SPTT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_ERRORS IS 'Data Errors

This is an error table that represents any specific data error instances that a given data table/entity contains (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These records will be used to communicate errors to the data entry and data management staff';

COMMENT ON COLUMN SPTT.DVM_ERRORS.ERROR_ID IS 'Primary Key for the SPT_ERRORS table';

COMMENT ON COLUMN SPTT.DVM_ERRORS.PTA_ERROR_ID IS 'The PTA Error record the error corresponds to, this indicates which parent record for the given data stream the errors are associated with';

COMMENT ON COLUMN SPTT.DVM_ERRORS.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_ERRORS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_ERRORS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_ERRORS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

COMMENT ON COLUMN SPTT.DVM_ERRORS.ERROR_TYPE_ID IS 'The Error Type for the given error';

COMMENT ON COLUMN SPTT.DVM_ERRORS.ERROR_NOTES IS 'Manually entered notes for the corresponding data error';

COMMENT ON COLUMN SPTT.DVM_ERRORS.ERR_RES_TYPE_ID IS 'Foreign key reference to the Error Resolution Types reference table.  A non-null value indicates that the given error is inactive and has been resolved/will be resolved';

COMMENT ON COLUMN SPTT.DVM_ERRORS.ERROR_DESCRIPTION IS 'The description of the given XML Data File error';


ALTER TABLE SPTT.DVM_ERRORS_EXCLUDE
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_ERRORS_EXCLUDE CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERRORS_EXCLUDE
(
  ERROR_ID  NUMBER                              NOT NULL,
  COMMENTS  VARCHAR2(4000 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_ERRORS_EXCLUDE IS 'Store error ids excluded from validation reports';


DROP TABLE SPTT.DVM_ERRORS_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERRORS_HIST
(
  H_SEQNUM              NUMBER(10)              NOT NULL,
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE)       NOT NULL,
  H_DATE_OF_CHANGE      DATE                    NOT NULL,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE)       NOT NULL,
  H_OS_USER             VARCHAR2(30 BYTE)       NOT NULL,
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  ERROR_ID              NUMBER                  NOT NULL,
  PTA_ERROR_ID          NUMBER,
  ERROR_TYPE_ID         NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_ERRORS_HIST.ERROR_ID IS 'Primary key column of the data table';


ALTER TABLE SPTT.DVM_ERROR_TYPES
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_ERROR_TYPES CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERROR_TYPES
(
  ERROR_TYPE_ID              NUMBER             NOT NULL,
  ERR_TYPE_NAME              VARCHAR2(500 BYTE) NOT NULL,
  QC_OBJECT_ID               NUMBER,
  ERR_TYPE_DESC              VARCHAR2(1000 BYTE),
  CREATE_DATE                DATE,
  CREATED_BY                 VARCHAR2(30 BYTE),
  LAST_MOD_DATE              DATE,
  LAST_MOD_BY                VARCHAR2(30 BYTE),
  IND_FIELD_NAME             VARCHAR2(30 BYTE)  NOT NULL,
  ERR_SEVERITY_ID            NUMBER,
  DATA_STREAM_ID             NUMBER,
  ERR_TYPE_ACTIVE_YN         CHAR(1 BYTE)       DEFAULT 'Y'                   NOT NULL,
  ERR_TYPE_COMMENT_TEMPLATE  CLOB
)
LOB (ERR_TYPE_COMMENT_TEMPLATE) STORE AS (
  TABLESPACE  SPTT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_ERROR_TYPES IS 'Data Error Types

This is a reference table that defines the different QC Data Error Types that indicate how to identify QC errors and report them to end-users for resolution.  Each Data Error will have a corresponding Data Error Type.';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERROR_TYPE_ID IS 'Primary Key for the SPT_ERROR_TYPES table';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERR_TYPE_DESC IS 'The description for the given QC validation error type';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.DATA_STREAM_ID IS 'The Category for the given error type criteria.  This is used to filter error criteria based on the given context of the validation (e.g. eTunaLog XML data import, tracking QC, etc.)';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';


DROP TABLE SPTT.DVM_ERROR_TYPES_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERROR_TYPES_HIST
(
  H_SEQNUM              NUMBER(10),
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE),
  H_DATE_OF_CHANGE      DATE,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE),
  H_OS_USER             VARCHAR2(30 BYTE),
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  ERROR_TYPE_ID         NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_ERROR_TYPES_HIST.ERROR_TYPE_ID IS 'Primary key column of the data table';


ALTER TABLE SPTT.DVM_ERR_RES_TYPES
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_ERR_RES_TYPES CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERR_RES_TYPES
(
  ERR_RES_TYPE_ID    NUMBER                     NOT NULL,
  ERR_RES_TYPE_CODE  VARCHAR2(20 BYTE)          NOT NULL,
  ERR_RES_TYPE_NAME  VARCHAR2(200 BYTE)         NOT NULL,
  ERR_RES_TYPE_DESC  VARCHAR2(1000 BYTE),
  CREATE_DATE        DATE,
  CREATED_BY         VARCHAR2(30 BYTE),
  LAST_MOD_DATE      DATE,
  LAST_MOD_BY        VARCHAR2(30 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_ERR_RES_TYPES IS 'Error Resolution Types

This is a reference table that defines all error resolutions types that will be used to define the status of a given QC data validation issue.  When an error is marked as resolved it will have an annotation to explain the resolution of the error.  The types of error resolutions include no data available, manually reviewed and accepted, no resolution can be reached yet.  Certain error resolutions types will cause an error to be filtered out from the standard error reports.';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.ERR_RES_TYPE_ID IS 'Primary Key for the SPT_ERR_RES_TYPES table';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.ERR_RES_TYPE_CODE IS 'The Error Resolution Type code';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.ERR_RES_TYPE_NAME IS 'The Error Resolution Type name';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.ERR_RES_TYPE_DESC IS 'The Error Resolution Type description';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


DROP TABLE SPTT.DVM_ERR_RES_TYPES_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERR_RES_TYPES_HIST
(
  H_SEQNUM              NUMBER(10),
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE),
  H_DATE_OF_CHANGE      DATE,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE),
  H_OS_USER             VARCHAR2(30 BYTE),
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  ERR_RES_TYPE_ID       NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_ERR_RES_TYPES_HIST.ERR_RES_TYPE_ID IS 'Primary key column of the data table';


ALTER TABLE SPTT.DVM_ERR_SEVERITY
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_ERR_SEVERITY CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERR_SEVERITY
(
  ERR_SEVERITY_ID    NUMBER                     NOT NULL,
  ERR_SEVERITY_CODE  VARCHAR2(20 BYTE)          NOT NULL,
  ERR_SEVERITY_NAME  VARCHAR2(100 BYTE)         NOT NULL,
  ERR_SEVERITY_DESC  VARCHAR2(1000 BYTE),
  CREATE_DATE        DATE,
  CREATED_BY         VARCHAR2(30 BYTE),
  LAST_MOD_DATE      DATE,
  LAST_MOD_BY        VARCHAR2(30 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_ERR_SEVERITY IS 'Error Severity

This is a reference table that defines all error severities for error type criteria.  This indicates the status of the given error type criteria (e.g. warnings, data errors, violations of law, etc.)';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.ERR_SEVERITY_ID IS 'Primary Key for the SPT_ERR_SEVERITY table';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.ERR_SEVERITY_CODE IS 'The code for the given error severity';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.ERR_SEVERITY_NAME IS 'The name for the given error severity';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.ERR_SEVERITY_DESC IS 'The description for the given error severity';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


DROP TABLE SPTT.DVM_ERR_SEVERITY_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_ERR_SEVERITY_HIST
(
  H_SEQNUM              NUMBER(10),
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE),
  H_DATE_OF_CHANGE      DATE,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE),
  H_OS_USER             VARCHAR2(30 BYTE),
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  ERR_SEVERITY_ID       NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_ERR_SEVERITY_HIST.ERR_SEVERITY_ID IS 'Primary key column of the data table';


ALTER TABLE SPTT.DVM_PTA_ERRORS
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_PTA_ERRORS CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_PTA_ERRORS
(
  PTA_ERROR_ID    NUMBER                        NOT NULL,
  CREATE_DATE     DATE                          NOT NULL,
  LAST_EVAL_DATE  DATE                          NOT NULL
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_PTA_ERRORS IS 'Error Types/Errors (PTA)

This table represents a generalized intersection table that allows multiple Error and Error Type Association records to reference this consolidated table that allows multiple Errors and Error Types to be associated with the given parent table record (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_CANN_TRANSACTIONS, etc.).';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS.PTA_ERROR_ID IS 'Primary Key for the SPT_PTA_ERRORS table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS.CREATE_DATE IS 'The date on which this record was created in the database (indicates when the given associated data stream parent record was first evaluated)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS.LAST_EVAL_DATE IS 'The date on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';


DROP TABLE SPTT.DVM_PTA_ERRORS_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_PTA_ERRORS_HIST
(
  H_SEQNUM              NUMBER(10)              NOT NULL,
  PTA_ERROR_ID          NUMBER                  NOT NULL,
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE)       NOT NULL,
  H_DATE_OF_CHANGE      DATE                    NOT NULL,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE)       NOT NULL,
  H_OS_USER             VARCHAR2(30 BYTE)       NOT NULL,
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.PTA_ERROR_ID IS 'Primary key column of the data table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_PTA_ERRORS_HIST.H_NEW_DATA IS 'The updated column data';


ALTER TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC
(
  PTA_ERR_TYP_ASSOC_ID  NUMBER                  NOT NULL,
  PTA_ERROR_ID          NUMBER                  NOT NULL,
  ERROR_TYPE_ID         NUMBER                  NOT NULL,
  CREATE_DATE           DATE,
  EFFECTIVE_DATE        DATE,
  END_DATE              DATE,
  ERR_ASSOC_NOTES       VARCHAR2(500 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC IS 'Error Type Associations (PTA)

This intersection table allows multiple Error Types to be associated with a given table (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These associations represent the Error Types that are defined at the time that a given table record is created so that the specific rules can be applied for subsequent validation assessments over time.  ';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.PTA_ERR_TYP_ASSOC_ID IS 'Primary Key for the SPT_PTA_ERR_TYP_ASSOC table';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID IS 'Foreign key reference to the Error Types/Errors (PTA) table.  This indicates a given Data Error Type rule was active at the time a given data table record was added to the database (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_CANN_TRANSACTIONS, etc.)';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID IS 'Foreign key reference to the Data Error Types table that indicates a given Data Error Type was active for a given data table (depends on related Error Data Category) at the time it was added to the database';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.EFFECTIVE_DATE IS 'The effective date for the given set of enabled Error Type Definitions';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.END_DATE IS 'The end date for the given set of enabled Error Type Definitions';

COMMENT ON COLUMN SPTT.DVM_PTA_ERR_TYP_ASSOC.ERR_ASSOC_NOTES IS 'Notes';


ALTER TABLE SPTT.DVM_QC_OBJECTS
 DROP PRIMARY KEY CASCADE;

DROP TABLE SPTT.DVM_QC_OBJECTS CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_QC_OBJECTS
(
  QC_OBJECT_ID      NUMBER                      NOT NULL,
  OBJECT_NAME       VARCHAR2(30 BYTE)           NOT NULL,
  QC_OBJ_ACTIVE_YN  CHAR(1 BYTE)                DEFAULT 'Y'                   NOT NULL,
  QC_SORT_ORDER     NUMBER,
  CREATE_DATE       DATE,
  CREATED_BY        VARCHAR2(30 BYTE),
  LAST_MOD_DATE     DATE,
  LAST_MOD_BY       VARCHAR2(30 BYTE)
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON TABLE SPTT.DVM_QC_OBJECTS IS 'Data QC Objects

This is a reference table that defines all of the QC validation views that are executed on the data model after a given data stream is loaded into the database (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES).';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.QC_OBJECT_ID IS 'Primary Key for the SPT_QC_OBJECTS table';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.CREATE_DATE IS 'The date on which this record was created in the database';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


DROP TABLE SPTT.DVM_QC_OBJECTS_HIST CASCADE CONSTRAINTS;

CREATE TABLE SPTT.DVM_QC_OBJECTS_HIST
(
  H_SEQNUM              NUMBER(10),
  H_TYPE_OF_CHANGE      VARCHAR2(10 BYTE),
  H_DATE_OF_CHANGE      DATE,
  H_USER_MAKING_CHANGE  VARCHAR2(30 BYTE),
  H_OS_USER             VARCHAR2(30 BYTE),
  H_CHANGED_COLUMN      VARCHAR2(30 BYTE),
  H_OLD_DATA            VARCHAR2(4000 BYTE),
  H_NEW_DATA            VARCHAR2(4000 BYTE),
  QC_OBJECT_ID          NUMBER
)
TABLESPACE SPTT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_OLD_DATA IS 'The data that has been updated';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.H_NEW_DATA IS 'The updated column data';

COMMENT ON COLUMN SPTT.DVM_QC_OBJECTS_HIST.QC_OBJECT_ID IS 'Primary key column of the data table';


CREATE UNIQUE INDEX SPTT.APX_ERR_CONSTR_MSG_PK ON SPTT.APX_ERR_CONSTR_MSG
(CONSTR_MSG_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.APX_ERR_CONSTR_MSG_U1 ON SPTT.APX_ERR_CONSTR_MSG
(CONSTRAINT_NAME)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_DATA_STREAMS_PK ON SPTT.DVM_DATA_STREAMS
(DATA_STREAM_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_DATA_STREAMS_U1 ON SPTT.DVM_DATA_STREAMS
(DATA_STREAM_CODE)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_DATA_STREAMS_U2 ON SPTT.DVM_DATA_STREAMS
(DATA_STREAM_NAME)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERRORS_EXCLUDE_PK ON SPTT.DVM_ERRORS_EXCLUDE
(ERROR_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERRORS_I1 ON SPTT.DVM_ERRORS
(PTA_ERROR_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERRORS_I2 ON SPTT.DVM_ERRORS
(ERROR_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERRORS_I3 ON SPTT.DVM_ERRORS
(ERR_RES_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERRORS_PK ON SPTT.DVM_ERRORS
(ERROR_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERROR_TYPES_I1 ON SPTT.DVM_ERROR_TYPES
(QC_OBJECT_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERROR_TYPES_I2 ON SPTT.DVM_ERROR_TYPES
(ERR_SEVERITY_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_ERROR_TYPES_I3 ON SPTT.DVM_ERROR_TYPES
(DATA_STREAM_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERROR_TYPES_PK ON SPTT.DVM_ERROR_TYPES
(ERROR_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERROR_TYPES_U1 ON SPTT.DVM_ERROR_TYPES
(IND_FIELD_NAME, DATA_STREAM_ID, QC_OBJECT_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_RES_TYPES_PK ON SPTT.DVM_ERR_RES_TYPES
(ERR_RES_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_RES_TYPES_U1 ON SPTT.DVM_ERR_RES_TYPES
(ERR_RES_TYPE_CODE)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_RES_TYPES_U2 ON SPTT.DVM_ERR_RES_TYPES
(ERR_RES_TYPE_NAME)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_SEVERITY_PK ON SPTT.DVM_ERR_SEVERITY
(ERR_SEVERITY_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_SEVERITY_U1 ON SPTT.DVM_ERR_SEVERITY
(ERR_SEVERITY_CODE)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_ERR_SEVERITY_U2 ON SPTT.DVM_ERR_SEVERITY
(ERR_SEVERITY_NAME)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_PTA_ERRORS_PK ON SPTT.DVM_PTA_ERRORS
(PTA_ERROR_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_I1 ON SPTT.DVM_PTA_ERR_TYP_ASSOC
(PTA_ERROR_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_I2 ON SPTT.DVM_PTA_ERR_TYP_ASSOC
(ERROR_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_PK ON SPTT.DVM_PTA_ERR_TYP_ASSOC
(PTA_ERR_TYP_ASSOC_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_U1 ON SPTT.DVM_PTA_ERR_TYP_ASSOC
(PTA_ERROR_ID, ERROR_TYPE_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE UNIQUE INDEX SPTT.DVM_QC_OBJECTS_PK ON SPTT.DVM_QC_OBJECTS
(QC_OBJECT_ID)
LOGGING
TABLESPACE SPTT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE OR REPLACE TRIGGER SPTT.APX_ERR_CONSTR_MSG_AUTO_BRI 
before insert ON SPTT.APX_ERR_CONSTR_MSG
for each row
begin
  select APX_ERR_CONSTR_MSG_SEQ.nextval into :new.CONSTR_MSG_ID from dual;
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_DATA_STREAMS_AUTO_BRI
before insert ON SPTT.DVM_DATA_STREAMS
for each row
begin
select DVM_DATA_STREAMS_SEQ.nextval into :new.DATA_STREAM_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_DATA_STREAMS_AUTO_BRU BEFORE
UPDATE
ON SPTT.DVM_DATA_STREAMS FOR EACH ROW
BEGIN
:NEW.LAST_MOD_DATE := SYSDATE;
:NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERRORS_AUTO_BRI
before insert ON SPTT.DVM_ERRORS
for each row
begin
select DVM_ERRORS_SEQ.nextval into :new.ERROR_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERRORS_AUTO_BRU BEFORE
UPDATE
ON SPTT.DVM_ERRORS FOR EACH ROW
BEGIN
:NEW.LAST_MOD_DATE := SYSDATE;
:NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERROR_TYPES_AUTO_BRI
before insert ON SPTT.DVM_ERROR_TYPES
for each row
begin
select DVM_ERROR_TYPES_SEQ.nextval into :new.ERROR_TYPE_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERROR_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON SPTT.DVM_ERROR_TYPES FOR EACH ROW
BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERR_RES_TYPES_AUTO_BRI
before insert ON SPTT.DVM_ERR_RES_TYPES
for each row
begin
select DVM_ERR_RES_TYPES_SEQ.nextval into :new.ERR_RES_TYPE_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERR_RES_TYPES_AUTO_BRU BEFORE
UPDATE
ON SPTT.DVM_ERR_RES_TYPES FOR EACH ROW
BEGIN
:NEW.LAST_MOD_DATE := SYSDATE;
:NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERR_SEVERITY_AUTO_BRI
before insert ON SPTT.DVM_ERR_SEVERITY
for each row
begin
select DVM_ERR_SEVERITY_SEQ.nextval into :new.ERR_SEVERITY_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_ERR_SEVERITY_AUTO_BRU BEFORE
UPDATE
ON SPTT.DVM_ERR_SEVERITY FOR EACH ROW
BEGIN
:NEW.LAST_MOD_DATE := SYSDATE;
:NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_PTA_ERRORS_AUTO_BRI
before insert ON SPTT.DVM_PTA_ERRORS
for each row
begin
select DVM_PTA_ERRORS_SEQ.nextval into :new.PTA_ERROR_ID from dual;
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_PTA_ERR_TYP_ASSOC_AUTO_BRI
before insert ON SPTT.DVM_PTA_ERR_TYP_ASSOC
for each row
begin
select DVM_PTA_ERR_TYP_ASSOC_SEQ.nextval into :new.PTA_ERR_TYP_ASSOC_ID from dual;
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_QC_OBJECTS_AUTO_BRI
before insert ON SPTT.DVM_QC_OBJECTS
for each row
begin
select DVM_QC_OBJECTS_SEQ.nextval into :new.QC_OBJECT_ID from dual;
:NEW.CREATE_DATE := SYSDATE;
:NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/


CREATE OR REPLACE TRIGGER SPTT.DVM_QC_OBJECTS_AUTO_BRU BEFORE
UPDATE
ON SPTT.DVM_QC_OBJECTS FOR EACH ROW
BEGIN
:NEW.LAST_MOD_DATE := SYSDATE;
:NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_DATA_STREAMS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_DATA_STREAMS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_DATA_STREAMS_hist (
      h_seqnum, DATA_STREAM_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_DATA_STREAMS_hist_seq.NEXTVAL, :old.DATA_STREAM_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_DATA_STREAMS_hist (
      h_seqnum, DATA_STREAM_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_DATA_STREAMS_hist_seq.NEXTVAL, :new.DATA_STREAM_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'data_stream_par_table', :old.data_stream_par_table);
    insert_data('DELETE', 'data_stream_code', :old.data_stream_code);
    insert_data('DELETE', 'data_stream_name', :old.data_stream_name);
    insert_data('DELETE', 'data_stream_desc', :old.data_stream_desc);
  ELSE
    NULL;
    check_update('DATA_STREAM_PAR_TABLE', :old.data_stream_par_table, :new.data_stream_par_table);
    check_update('DATA_STREAM_CODE', :old.data_stream_code, :new.data_stream_code);
    check_update('DATA_STREAM_NAME', :old.data_stream_name, :new.data_stream_name);
    check_update('DATA_STREAM_DESC', :old.data_stream_desc, :new.data_stream_desc);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_ERRORS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_ERRORS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_ERRORS_hist (
      h_seqnum, ERROR_ID, PTA_ERROR_ID, ERROR_TYPE_ID, 
      h_type_of_change, h_user_making_change, h_os_user, 
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ERRORS_hist_seq.NEXTVAL, :old.ERROR_ID, :old.PTA_ERROR_ID, :old.ERROR_TYPE_ID, 
      p_type_of_change, user, os_user, SYSDATE, 
      p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
      OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
      OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;

BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_ERRORS_hist (
      h_seqnum, ERROR_ID, PTA_ERROR_ID, ERROR_TYPE_ID, 
      h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ERRORS_hist_seq.NEXTVAL, :new.ERROR_ID, :new.PTA_ERROR_ID, :new.ERROR_TYPE_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    -- HYW(12/4/2017): redunctant data, already in columns
--    insert_data('DELETE', 'pta_error_id', :old.pta_error_id);
--    insert_data('DELETE', 'error_type_id', :old.error_type_id);
    insert_data('DELETE', 'error_notes', :old.error_notes);
    insert_data('DELETE', 'err_res_type_id', :old.err_res_type_id);
    --HYW(11/30/2017): add ERROR_DESCRIPTION into HIST table when DELETE
    insert_data('DELETE', 'error_description', substr(:old.error_description,1,4000));
  ELSE
    NULL;
    -- HYW(12/4/2017): redunctant data, already in columns
--    check_update('PTA_ERROR_ID', :old.pta_error_id, :new.pta_error_id);
--    check_update('ERROR_TYPE_ID', :old.error_type_id, :new.error_type_id);
    check_update('ERROR_NOTES', :old.error_notes, :new.error_notes);
    check_update('ERR_RES_TYPE_ID', :old.err_res_type_id, :new.err_res_type_id);
    --HYW(11/30/2017): check updates of ERROR_DESCRIPTION too
    check_update('ERROR_DESCRIPTION', substr(:old.error_description,1,4000), substr(:new.error_description,1,4000));
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_ERROR_TYPES_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_ERROR_TYPES
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_ERROR_TYPES_hist (
      h_seqnum, ERROR_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ERROR_TYPES_hist_seq.NEXTVAL, :old.ERROR_TYPE_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_ERROR_TYPES_hist (
      h_seqnum, ERROR_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ERROR_TYPES_hist_seq.NEXTVAL, :new.ERROR_TYPE_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'err_type_name', :old.err_type_name);
    insert_data('DELETE', 'qc_object_id', :old.qc_object_id);
    insert_data('DELETE', 'err_type_desc', :old.err_type_desc);
    insert_data('DELETE', 'ind_field_name', :old.ind_field_name);
    insert_data('DELETE', 'err_severity_id', :old.err_severity_id);
    insert_data('DELETE', 'data_stream_id', :old.data_stream_id);
    insert_data('DELETE', 'err_type_active_yn', :old.err_type_active_yn);
  ELSE
    NULL;
    check_update('ERR_TYPE_NAME', :old.err_type_name, :new.err_type_name);
    check_update('QC_OBJECT_ID', :old.qc_object_id, :new.qc_object_id);
    check_update('ERR_TYPE_DESC', :old.err_type_desc, :new.err_type_desc);
    check_update('IND_FIELD_NAME', :old.ind_field_name, :new.ind_field_name);
    check_update('ERR_SEVERITY_ID', :old.err_severity_id, :new.err_severity_id);
    check_update('DATA_STREAM_ID', :old.data_stream_id, :new.data_stream_id);
    check_update('ERR_TYPE_ACTIVE_YN', :old.err_type_active_yn, :new.err_type_active_yn);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_ERR_RES_TYPES_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_ERR_RES_TYPES
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_ERR_RES_TYPES_hist (
      h_seqnum, ERR_RES_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ERR_RES_TYPES_hist_seq.NEXTVAL, :old.ERR_RES_TYPE_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_ERR_RES_TYPES_hist (
      h_seqnum, ERR_RES_TYPE_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ERR_RES_TYPES_hist_seq.NEXTVAL, :new.ERR_RES_TYPE_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'err_res_type_code', :old.err_res_type_code);
    insert_data('DELETE', 'err_res_type_name', :old.err_res_type_name);
    insert_data('DELETE', 'err_res_type_desc', :old.err_res_type_desc);
  ELSE
    NULL;
    check_update('ERR_RES_TYPE_CODE', :old.err_res_type_code, :new.err_res_type_code);
    check_update('ERR_RES_TYPE_NAME', :old.err_res_type_name, :new.err_res_type_name);
    check_update('ERR_RES_TYPE_DESC', :old.err_res_type_desc, :new.err_res_type_desc);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_ERR_SEVERITY_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_ERR_SEVERITY
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_ERR_SEVERITY_hist (
      h_seqnum, ERR_SEVERITY_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ERR_SEVERITY_hist_seq.NEXTVAL, :old.ERR_SEVERITY_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_ERR_SEVERITY_hist (
      h_seqnum, ERR_SEVERITY_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ERR_SEVERITY_hist_seq.NEXTVAL, :new.ERR_SEVERITY_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'err_severity_code', :old.err_severity_code);
    insert_data('DELETE', 'err_severity_name', :old.err_severity_name);
    insert_data('DELETE', 'err_severity_desc', :old.err_severity_desc);
  ELSE
    NULL;
    check_update('ERR_SEVERITY_CODE', :old.err_severity_code, :new.err_severity_code);
    check_update('ERR_SEVERITY_NAME', :old.err_severity_name, :new.err_severity_name);
    check_update('ERR_SEVERITY_DESC', :old.err_severity_desc, :new.err_severity_desc);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_PTA_ERRORS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_PTA_ERRORS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_PTA_ERRORS_hist (
      h_seqnum, PTA_ERROR_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_PTA_ERRORS_hist_seq.NEXTVAL, :old.PTA_ERROR_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_PTA_ERRORS_hist (
      h_seqnum, PTA_ERROR_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_PTA_ERRORS_hist_seq.NEXTVAL, :new.PTA_ERROR_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'last_eval_date', TO_CHAR(:old.last_eval_date, 'SYYYY-MM-DD HH24:MI:SS'));
  ELSE
    NULL;
    check_update('LAST_EVAL_DATE', TO_CHAR(:old.last_eval_date, 'SYYYY-MM-DD HH24:MI:SS'), TO_CHAR(:new.last_eval_date, 'SYYYY-MM-DD HH24:MI:SS'));
  END IF;
END;
/


CREATE OR REPLACE TRIGGER SPTT."TRG_DVM_QC_OBJECTS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON SPTT.DVM_QC_OBJECTS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO DVM_QC_OBJECTS_hist (
      h_seqnum, QC_OBJECT_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_QC_OBJECTS_hist_seq.NEXTVAL, :old.QC_OBJECT_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO DVM_QC_OBJECTS_hist (
      h_seqnum, QC_OBJECT_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_QC_OBJECTS_hist_seq.NEXTVAL, :new.QC_OBJECT_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'object_name', :old.object_name);
    insert_data('DELETE', 'qc_obj_active_yn', :old.qc_obj_active_yn);
    insert_data('DELETE', 'qc_sort_order', :old.qc_sort_order);
  ELSE
    NULL;
    check_update('OBJECT_NAME', :old.object_name, :new.object_name);
    check_update('QC_OBJ_ACTIVE_YN', :old.qc_obj_active_yn, :new.qc_obj_active_yn);
    check_update('QC_SORT_ORDER', :old.qc_sort_order, :new.qc_sort_order);
  END IF;
END;
/


CREATE OR REPLACE SYNONYM SPTT.DAT_STRM FOR SPTT.DVM_DATA_STREAMS;


CREATE OR REPLACE SYNONYM SPTT.ERRS FOR SPTT.DVM_ERRORS;


CREATE OR REPLACE SYNONYM SPTT.ERR_RES FOR SPTT.DVM_ERR_RES_TYPES;


CREATE OR REPLACE SYNONYM SPTT.ERR_SEV FOR SPTT.DVM_ERR_SEVERITY;


CREATE OR REPLACE SYNONYM SPTT.ERR_TYP FOR SPTT.DVM_ERROR_TYPES;


CREATE OR REPLACE SYNONYM SPTT.PTA_ERR FOR SPTT.DVM_PTA_ERRORS;


CREATE OR REPLACE SYNONYM SPTT.PTA_ER_ASC FOR SPTT.DVM_PTA_ERR_TYP_ASSOC;


CREATE OR REPLACE SYNONYM SPTT.QC_OBJ FOR SPTT.DVM_QC_OBJECTS;


ALTER TABLE SPTT.APX_ERR_CONSTR_MSG ADD (
  CONSTRAINT APX_ERR_CONSTR_MSG_PK
  PRIMARY KEY
  (CONSTR_MSG_ID)
  USING INDEX SPTT.APX_ERR_CONSTR_MSG_PK
  ENABLE VALIDATE,
  CONSTRAINT APX_ERR_CONSTR_MSG_U1
  UNIQUE (CONSTRAINT_NAME)
  USING INDEX SPTT.APX_ERR_CONSTR_MSG_U1
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_DATA_STREAMS ADD (
  CONSTRAINT DVM_DATA_STREAMS_PK
  PRIMARY KEY
  (DATA_STREAM_ID)
  USING INDEX SPTT.DVM_DATA_STREAMS_PK
  ENABLE VALIDATE,
  CONSTRAINT DVM_DATA_STREAMS_U1
  UNIQUE (DATA_STREAM_CODE)
  USING INDEX SPTT.DVM_DATA_STREAMS_U1
  ENABLE VALIDATE,
  CONSTRAINT DVM_DATA_STREAMS_U2
  UNIQUE (DATA_STREAM_NAME)
  USING INDEX SPTT.DVM_DATA_STREAMS_U2
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERRORS ADD (
  CONSTRAINT DVM_ERRORS_PK
  PRIMARY KEY
  (ERROR_ID)
  USING INDEX SPTT.DVM_ERRORS_PK
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERRORS_EXCLUDE ADD (
  CONSTRAINT DVM_ERRORS_EXCLUDE_PK
  PRIMARY KEY
  (ERROR_ID)
  USING INDEX SPTT.DVM_ERRORS_EXCLUDE_PK
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERROR_TYPES ADD (
  CONSTRAINT DVM_ERROR_TYPES_PK
  PRIMARY KEY
  (ERROR_TYPE_ID)
  USING INDEX SPTT.DVM_ERROR_TYPES_PK
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERROR_TYPES_U1
  UNIQUE (IND_FIELD_NAME, DATA_STREAM_ID, QC_OBJECT_ID)
  USING INDEX SPTT.DVM_ERROR_TYPES_U1
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERR_RES_TYPES ADD (
  CONSTRAINT DVM_ERR_RES_TYPES_PK
  PRIMARY KEY
  (ERR_RES_TYPE_ID)
  USING INDEX SPTT.DVM_ERR_RES_TYPES_PK
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERR_RES_TYPES_U1
  UNIQUE (ERR_RES_TYPE_CODE)
  USING INDEX SPTT.DVM_ERR_RES_TYPES_U1
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERR_RES_TYPES_U2
  UNIQUE (ERR_RES_TYPE_NAME)
  USING INDEX SPTT.DVM_ERR_RES_TYPES_U2
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERR_SEVERITY ADD (
  CONSTRAINT DVM_ERR_SEVERITY_PK
  PRIMARY KEY
  (ERR_SEVERITY_ID)
  USING INDEX SPTT.DVM_ERR_SEVERITY_PK
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERR_SEVERITY_U1
  UNIQUE (ERR_SEVERITY_CODE)
  USING INDEX SPTT.DVM_ERR_SEVERITY_U1
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERR_SEVERITY_U2
  UNIQUE (ERR_SEVERITY_NAME)
  USING INDEX SPTT.DVM_ERR_SEVERITY_U2
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_PTA_ERRORS ADD (
  CONSTRAINT DVM_PTA_ERRORS_PK
  PRIMARY KEY
  (PTA_ERROR_ID)
  USING INDEX SPTT.DVM_PTA_ERRORS_PK
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC ADD (
  CONSTRAINT DVM_PTA_ERR_TYP_ASSOC_PK
  PRIMARY KEY
  (PTA_ERR_TYP_ASSOC_ID)
  USING INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_PK
  ENABLE VALIDATE,
  CONSTRAINT DVM_PTA_ERR_TYP_ASSOC_U1
  UNIQUE (PTA_ERROR_ID, ERROR_TYPE_ID)
  USING INDEX SPTT.DVM_PTA_ERR_TYP_ASSOC_U1
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_QC_OBJECTS ADD (
  CONSTRAINT DVM_QC_OBJECTS_PK
  PRIMARY KEY
  (QC_OBJECT_ID)
  USING INDEX SPTT.DVM_QC_OBJECTS_PK
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERRORS ADD (
  CONSTRAINT DVM_ERRORS_FK1 
  FOREIGN KEY (PTA_ERROR_ID) 
  REFERENCES SPTT.DVM_PTA_ERRORS (PTA_ERROR_ID)
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERRORS_FK2 
  FOREIGN KEY (ERROR_TYPE_ID) 
  REFERENCES SPTT.DVM_ERROR_TYPES (ERROR_TYPE_ID)
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERRORS_FK3 
  FOREIGN KEY (ERR_RES_TYPE_ID) 
  REFERENCES SPTT.DVM_ERR_RES_TYPES (ERR_RES_TYPE_ID)
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERRORS_EXCLUDE ADD (
  CONSTRAINT DVM_ERRORS_EXCLUDE_FK 
  FOREIGN KEY (ERROR_ID) 
  REFERENCES SPTT.DVM_ERRORS (ERROR_ID)
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_ERROR_TYPES ADD (
  CONSTRAINT DVM_ERROR_TYPES_FK1 
  FOREIGN KEY (QC_OBJECT_ID) 
  REFERENCES SPTT.DVM_QC_OBJECTS (QC_OBJECT_ID)
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERROR_TYPES_FK2 
  FOREIGN KEY (ERR_SEVERITY_ID) 
  REFERENCES SPTT.DVM_ERR_SEVERITY (ERR_SEVERITY_ID)
  ENABLE VALIDATE,
  CONSTRAINT DVM_ERROR_TYPES_FK3 
  FOREIGN KEY (DATA_STREAM_ID) 
  REFERENCES SPTT.DVM_DATA_STREAMS (DATA_STREAM_ID)
  ENABLE VALIDATE);

ALTER TABLE SPTT.DVM_PTA_ERR_TYP_ASSOC ADD (
  CONSTRAINT DVM_PTA_ERR_TYP_ASSOC_FK1 
  FOREIGN KEY (PTA_ERROR_ID) 
  REFERENCES SPTT.DVM_PTA_ERRORS (PTA_ERROR_ID)
  ENABLE VALIDATE,
  CONSTRAINT DVM_PTA_ERR_TYP_ASSOC_FK2 
  FOREIGN KEY (ERROR_TYPE_ID) 
  REFERENCES SPTT.DVM_ERROR_TYPES (ERROR_TYPE_ID)
  ENABLE VALIDATE);

GRANT SELECT ON SPTT.APX_ERR_CONSTR_MSG TO DDY;

GRANT SELECT ON SPTT.DVM_DATA_STREAMS TO DDY;

GRANT SELECT ON SPTT.DVM_DATA_STREAMS_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_ERRORS TO DDY;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_ERROR_TYPES TO DDY;

GRANT SELECT ON SPTT.DVM_ERROR_TYPES_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_ERR_RES_TYPES TO DDY;

GRANT SELECT ON SPTT.DVM_ERR_RES_TYPES_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_ERR_SEVERITY TO DDY;

GRANT SELECT ON SPTT.DVM_ERR_SEVERITY_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS TO DDY;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS_HIST TO DDY;

GRANT SELECT ON SPTT.DVM_PTA_ERR_TYP_ASSOC TO DDY;

GRANT SELECT ON SPTT.DVM_QC_OBJECTS TO DDY;

GRANT SELECT ON SPTT.DVM_QC_OBJECTS_HIST TO DDY;

GRANT SELECT ON SPTT.APX_ERR_CONSTR_MSG TO HWANG;

GRANT SELECT ON SPTT.DVM_DATA_STREAMS TO HWANG;

GRANT SELECT ON SPTT.DVM_DATA_STREAMS_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_ERRORS TO HWANG;

GRANT SELECT ON SPTT.DVM_ERRORS_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_ERROR_TYPES TO HWANG;

GRANT SELECT ON SPTT.DVM_ERROR_TYPES_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_ERR_RES_TYPES TO HWANG;

GRANT SELECT ON SPTT.DVM_ERR_RES_TYPES_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_ERR_SEVERITY TO HWANG;

GRANT SELECT ON SPTT.DVM_ERR_SEVERITY_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERRORS_HIST TO HWANG;

GRANT SELECT ON SPTT.DVM_PTA_ERR_TYP_ASSOC TO HWANG;

GRANT SELECT ON SPTT.DVM_QC_OBJECTS TO HWANG;

GRANT SELECT ON SPTT.DVM_QC_OBJECTS_HIST TO HWANG;
