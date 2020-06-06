--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 0.5 updates:
--------------------------------------------------------



CREATE TABLE DVM_RULE_SETS
(
  RULE_SET_ID NUMBER NOT NULL,
 	RULE_SET_ACTIVE_YN CHAR(1) NOT NULL,
  RULE_SET_CREATE_DATE DATE,
	RULE_SET_INACTIVE_DATE DATE,
  DATA_STREAM_ID NUMBER NOT NULL,
  CONSTRAINT DVM_RULE_SETS_PK PRIMARY KEY
  (
    RULE_SET_ID
  )
  ENABLE
);

COMMENT ON COLUMN DVM_RULE_SETS.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';

COMMENT ON COLUMN DVM_RULE_SETS.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_RULE_SETS.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_RULE_SETS.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';

COMMENT ON COLUMN DVM_RULE_SETS.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';

COMMENT ON TABLE DVM_RULE_SETS IS 'DVM Rule Sets

This table defines the different rule sets that were active over time.  As the active DVM validation criteria changes over time new rule set records will be added to define the time period that the corresponding error types were active.';


CREATE INDEX DVM_RULE_SETS_I1 ON DVM_RULE_SETS (DATA_STREAM_ID);

ALTER TABLE DVM_RULE_SETS
ADD CONSTRAINT DVM_RULE_SETS_FK1 FOREIGN KEY
(
  DATA_STREAM_ID
)
REFERENCES DVM_DATA_STREAMS
(
  DATA_STREAM_ID
)
ENABLE;


CREATE SEQUENCE DVM_RULE_SETS_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER
DVM_RULE_SETS_AUTO_BRI
before insert on DVM_RULE_SETS
for each row
begin
  select DVM_RULE_SETS_SEQ.nextval into :new.RULE_SET_ID from dual;
end;
/

CREATE TABLE DVM_ISS_TYP_ASSOC
(
  ISS_TYP_ASSOC_ID NUMBER NOT NULL
, RULE_SET_ID NUMBER NOT NULL
, ERROR_TYPE_ID NUMBER NOT NULL
, CONSTRAINT DVM_ISS_TYP_ASSOC_PK PRIMARY KEY
  (
    ISS_TYP_ASSOC_ID
  )
  ENABLE
);

CREATE INDEX DVM_ISS_TYP_ASSOC_I1 ON DVM_ISS_TYP_ASSOC (RULE_SET_ID ASC);


CREATE INDEX DVM_ISS_TYP_ASSOC_I2 ON DVM_ISS_TYP_ASSOC (ERROR_TYPE_ID ASC);

CREATE UNIQUE INDEX DVM_ISS_TYP_ASSOC_U1 ON DVM_ISS_TYP_ASSOC (RULE_SET_ID ASC, ERROR_TYPE_ID ASC);


ALTER TABLE DVM_ISS_TYP_ASSOC
ADD CONSTRAINT DVM_ISS_TYP_ASSOC_FK1 FOREIGN KEY
(
  RULE_SET_ID
)
REFERENCES DVM_RULE_SETS
(
  RULE_SET_ID
)
ENABLE;

ALTER TABLE DVM_ISS_TYP_ASSOC
ADD CONSTRAINT DVM_ISS_TYP_ASSOC_FK2 FOREIGN KEY
(
  ERROR_TYPE_ID
)
REFERENCES DVM_ERROR_TYPES
(
  ERROR_TYPE_ID
)
ENABLE;

CREATE SEQUENCE DVM_ISS_TYP_ASSOC_SEQ INCREMENT BY 1 START WITH 1;


create or replace TRIGGER DVM_ISS_TYP_ASSOC_AUTO_BRI
before insert on DVM_ISS_TYP_ASSOC
for each row
begin
  select DVM_ISS_TYP_ASSOC_SEQ.nextval into :new.ISS_TYP_ASSOC_ID from dual;
end;
/



COMMENT ON TABLE DVM_ISS_TYP_ASSOC IS 'Rule Set Error Type Associations (PTA)

This intersection table defines which error types are/were active for a given rule set.  These associations represent the Error Types that are defined at the time that a given table record is evaluated using the DVM so that the specific rules can be applied for subsequent validation assessments over time.';

COMMENT ON COLUMN DVM_ISS_TYP_ASSOC.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';

COMMENT ON COLUMN DVM_ISS_TYP_ASSOC.RULE_SET_ID IS 'Foreign key reference to the Rule Set (PTA) table.  This indicates a given Data Error Type rule was active at the time a given data table record was validated using the DVM';

COMMENT ON COLUMN DVM_ISS_TYP_ASSOC.ERROR_TYPE_ID IS 'Foreign key reference to the Data Error Types table that indicates a given Data Error Type was active for a given data table (depends on related Error Data Category) at the time it was added to the database';


CREATE TABLE DVM_PTA_RULE_SETS
(
  PTA_RULE_SET_ID NUMBER NOT NULL
, RULE_SET_ID NUMBER NOT NULL
, PTA_ERROR_ID NUMBER NOT NULL
, FIRST_EVAL_DATE DATE
, LAST_EVAL_DATE DATE
, CONSTRAINT DVM_PTA_RULE_SETS_PK PRIMARY KEY
  (
    PTA_RULE_SET_ID
  )
  ENABLE
);

COMMENT ON COLUMN DVM_PTA_RULE_SETS.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS.RULE_SET_ID IS 'Foreign key reference to the associated validation rule set (DVM_RULE_SETS)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS.PTA_ERROR_ID IS 'Foreign key reference to the PTA Error record associated validation rule set (DVM_PTA_ERRORS)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent error record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent error record';

COMMENT ON TABLE DVM_PTA_RULE_SETS IS 'DVM PTA Rule Sets

This table defines the relationship between validation rule sets (DVM_RULE_SETS) and the individual PTA parent error record (DVM_PTA_ERRORS) that is associated with a given parent record.  This table is used to track which rule sets were used to evaluate which parent records.';


CREATE INDEX DVM_PTA_RULE_SETS_I1 ON DVM_PTA_RULE_SETS (RULE_SET_ID ASC);
CREATE INDEX DVM_PTA_RULE_SETS_I2 ON DVM_PTA_RULE_SETS (PTA_ERROR_ID ASC);


ALTER TABLE DVM_PTA_RULE_SETS
ADD CONSTRAINT DVM_PTA_RULE_SETS_FK1 FOREIGN KEY
(
  RULE_SET_ID
)
REFERENCES DVM_RULE_SETS
(
  RULE_SET_ID
)
ENABLE;

ALTER TABLE DVM_PTA_RULE_SETS
ADD CONSTRAINT DVM_PTA_RULE_SETS_FK2 FOREIGN KEY
(
  PTA_ERROR_ID
)
REFERENCES DVM_PTA_ERRORS
(
  PTA_ERROR_ID
)
ENABLE;


ALTER TABLE DVM_PTA_RULE_SETS
ADD CONSTRAINT DVM_PTA_RULE_SETS_U1 UNIQUE
(
  RULE_SET_ID
, PTA_ERROR_ID
)
ENABLE;


CREATE SEQUENCE DVM_PTA_RULE_SETS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
DVM_PTA_RULE_SETS_AUTO_BRI
before insert on DVM_PTA_RULE_SETS
for each row
begin
  select DVM_PTA_RULE_SETS_SEQ.nextval into :new.PTA_RULE_SET_ID from dual;
end;
/



/*
ALTER TABLE DVM_PTA_ERRORS
ADD (RULE_SET_ID NUMBER);

CREATE INDEX DVM_PTA_ERRORS_I1 ON DVM_PTA_ERRORS (RULE_SET_ID);

ALTER TABLE DVM_PTA_ERRORS
ADD CONSTRAINT DVM_PTA_ERRORS_FK1 FOREIGN KEY
(
  RULE_SET_ID
)
REFERENCES DVM_PTA_RULE_SETS
(
  RULE_SET_ID
)
ENABLE;

COMMENT ON COLUMN DVM_PTA_ERRORS.RULE_SET_ID IS 'The DVM rule set that was active when this intersection record was created in the database so this rule set can be used each time the module is executed';
*/






CREATE OR REPLACE View
DVM_PTA_RULE_SETS_V
AS
select
DVM_RULE_SETS.RULE_SET_ID,
DVM_RULE_SETS.RULE_SET_ACTIVE_YN,
DVM_RULE_SETS.RULE_SET_CREATE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_CREATE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS.RULE_SET_INACTIVE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_INACTIVE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_INACTIVE_DATE,

DVM_PTA_RULE_SETS.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS.PTA_ERROR_ID,

DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_LAST_EVAL_DATE,

DVM_DATA_STREAMS.DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE

FROM
DVM_RULE_SETS INNER JOIN
DVM_PTA_RULE_SETS ON
DVM_RULE_SETS.RULE_SET_ID = DVM_PTA_RULE_SETS.RULE_SET_ID
INNER join
DVM_DATA_STREAMS
ON
DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_RULE_SETS.DATA_STREAM_ID
order by
DVM_DATA_STREAMS.DATA_STREAM_CODE,
DVM_RULE_SETS.RULE_SET_ID,
DVM_PTA_RULE_SETS.PTA_RULE_SET_ID;


COMMENT ON TABLE DVM_PTA_RULE_SETS_V IS 'DVM PTA Rule Sets (View)

This view returns all of the rule sets and associated data streams as well as all PTA rule sets to provide information about which parent error records have been evaluated with which rule sets';


COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.PTA_ERROR_ID IS 'Foreign key reference to the PTA Error record associated validation rule set (DVM_PTA_ERRORS)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent error record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent error record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent error record';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent error record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN DVM_PTA_RULE_SETS_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';



  CREATE OR REPLACE VIEW DVM_CRITERIA_V AS
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
  DVM_ERROR_TYPES.APP_LINK_TEMPLATE,
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
FROM
  DVM_ERROR_TYPES
INNER JOIN DVM_ERR_SEVERITY
ON
  DVM_ERR_SEVERITY.ERR_SEVERITY_ID = DVM_ERROR_TYPES.ERR_SEVERITY_ID
INNER JOIN DVM_DATA_STREAMS_V
ON
  DVM_DATA_STREAMS_V.DATA_STREAM_ID = DVM_ERROR_TYPES.DATA_STREAM_ID
INNER JOIN DVM_QC_OBJECTS
ON
  DVM_QC_OBJECTS.QC_OBJECT_ID = DVM_ERROR_TYPES.QC_OBJECT_ID
ORDER BY

DVM_QC_OBJECTS.QC_SORT_ORDER, OBJECT_NAME, ERR_SEVERITY_CODE, ERR_TYPE_NAME;

   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_OBJECT_ID" IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERROR_TYPE_ID" IS 'The Error Type for the given error';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_TYPE_DESC" IS 'The description for the given QC validation error type';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_SEVERITY_ID" IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."APP_LINK_TEMPLATE" IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';



   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_SEVERITY_CODE" IS 'The code for the given error severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_SEVERITY_NAME" IS 'The name for the given error severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_SEVERITY_DESC" IS 'The description for the given error severity';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
   COMMENT ON COLUMN "DVM_CRITERIA_V"."ERR_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given error type criteria is active';
   COMMENT ON TABLE "DVM_CRITERIA_V"  IS 'Data Validation QC Criteria (View)

This View returns all QC Criteria (Error Types) defined in the database and their associated QC Object, Error Severity, and Error Category.  This query is used to define all PTA Error Types when a data stream is first entered into the database';





CREATE OR REPLACE View
DVM_RULE_SETS_V
AS
select
DVM_RULE_SETS.RULE_SET_ID,
DVM_RULE_SETS.RULE_SET_ACTIVE_YN,

DVM_RULE_SETS.RULE_SET_CREATE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_CREATE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_CREATE_DATE,
DVM_RULE_SETS.RULE_SET_INACTIVE_DATE,
TO_CHAR(DVM_RULE_SETS.RULE_SET_INACTIVE_DATE, 'MM/DD/YYYY HH24:MI:SS') FORMAT_RULE_SET_INACTIVE_DATE,
DVM_RULE_SETS.DATA_STREAM_ID RULE_DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE RULE_DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME RULE_DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC RULE_DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE RULE_DATA_STREAM_PAR_TABLE,

dvm_iss_typ_assoc.ISS_TYP_ASSOC_ID,

DVM_CRITERIA_V.QC_OBJECT_ID,
DVM_CRITERIA_V.OBJECT_NAME,
DVM_CRITERIA_V.QC_OBJ_ACTIVE_YN,
DVM_CRITERIA_V.QC_SORT_ORDER,
DVM_CRITERIA_V.ERROR_TYPE_ID,
DVM_CRITERIA_V.ERR_TYPE_NAME,
DVM_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE,
DVM_CRITERIA_V.ERR_TYPE_DESC,
DVM_CRITERIA_V.IND_FIELD_NAME,
DVM_CRITERIA_V.APP_LINK_TEMPLATE,
DVM_CRITERIA_V.ERR_SEVERITY_ID,
DVM_CRITERIA_V.ERR_SEVERITY_CODE,
DVM_CRITERIA_V.ERR_SEVERITY_NAME,
DVM_CRITERIA_V.ERR_SEVERITY_DESC,
DVM_CRITERIA_V.DATA_STREAM_ID,
DVM_CRITERIA_V.DATA_STREAM_CODE,
DVM_CRITERIA_V.DATA_STREAM_NAME,
DVM_CRITERIA_V.DATA_STREAM_DESC,
DVM_CRITERIA_V.DATA_STREAM_PK_FIELD,
DVM_CRITERIA_V.ERR_TYPE_ACTIVE_YN
from

DVM_RULE_SETS
INNER JOIN
DVM_DATA_STREAMS
ON
DVM_DATA_STREAMS.DATA_STREAM_ID = DVM_RULE_SETS.DATA_STREAM_ID


inner join
dvm_iss_typ_assoc on
DVM_RULE_SETS.rule_set_id = dvm_iss_typ_assoc.rule_set_id
inner join
DVM_CRITERIA_V

 on
DVM_CRITERIA_V.error_type_id = dvm_iss_typ_assoc.error_type_id
order by
DVM_RULE_SETS.RULE_SET_CREATE_DATE, DVM_CRITERIA_V.QC_SORT_ORDER, DVM_CRITERIA_V.ERR_SEVERITY_CODE, DVM_CRITERIA_V.ERR_TYPE_NAME
;


COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_RULE_SETS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_RULE_SETS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERROR_TYPE_ID IS 'The issue type for the given error';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_RULE_SETS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN DVM_RULE_SETS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent table name for the given issue type (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_RULE_SETS_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';

COMMENT ON TABLE DVM_RULE_SETS_V IS 'Data Validation Rule Sets (View)

This View returns all Data Validation Rule Sets and associated validation criteria';






  CREATE OR REPLACE VIEW DVM_PTA_ISSUE_TYPES_V AS
  SELECT
  DVM_PTA_ERRORS.PTA_ERROR_ID,
  DVM_PTA_ERRORS.CREATE_DATE,
  TO_CHAR(DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,

	DVM_PTA_RULE_SETS.PTA_RULE_SET_ID,
	DVM_PTA_RULE_SETS.FIRST_EVAL_DATE,
	TO_CHAR(DVM_PTA_RULE_SETS.FIRST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_FIRST_EVAL_DATE,
	DVM_PTA_RULE_SETS.LAST_EVAL_DATE,
	TO_CHAR(DVM_PTA_RULE_SETS.LAST_EVAL_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_LAST_EVAL_DATE,




	DVM_RULE_SETS_V.RULE_SET_ID,
	DVM_RULE_SETS_V.RULE_SET_ACTIVE_YN,
	DVM_RULE_SETS_V.RULE_SET_CREATE_DATE,
	DVM_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
	DVM_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
	DVM_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_ID,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_CODE,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_NAME,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_DESC,
	DVM_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
	DVM_RULE_SETS_V.ISS_TYP_ASSOC_ID,
	DVM_RULE_SETS_V.QC_OBJECT_ID,
	DVM_RULE_SETS_V.OBJECT_NAME,
	DVM_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
	DVM_RULE_SETS_V.QC_SORT_ORDER,
	DVM_RULE_SETS_V.ERROR_TYPE_ID,
	DVM_RULE_SETS_V.ERR_TYPE_NAME,
	DVM_RULE_SETS_V.ERR_TYPE_COMMENT_TEMPLATE,
	DVM_RULE_SETS_V.ERR_TYPE_DESC,
	DVM_RULE_SETS_V.IND_FIELD_NAME,
	DVM_RULE_SETS_V.APP_LINK_TEMPLATE,
	DVM_RULE_SETS_V.ERR_SEVERITY_ID,
	DVM_RULE_SETS_V.ERR_SEVERITY_CODE,
	DVM_RULE_SETS_V.ERR_SEVERITY_NAME,
	DVM_RULE_SETS_V.ERR_SEVERITY_DESC,
	DVM_RULE_SETS_V.DATA_STREAM_ID,
	DVM_RULE_SETS_V.DATA_STREAM_CODE,
	DVM_RULE_SETS_V.DATA_STREAM_NAME,
	DVM_RULE_SETS_V.DATA_STREAM_DESC,
	DVM_RULE_SETS_V.DATA_STREAM_PK_FIELD,
	DVM_RULE_SETS_V.ERR_TYPE_ACTIVE_YN

FROM
  DVM_PTA_ERRORS
INNER JOIN DVM_PTA_RULE_SETS ON
DVM_PTA_ERRORS.PTA_ERROR_ID = DVM_PTA_RULE_SETS.PTA_ERROR_ID
INNER JOIN DVM_RULE_SETS_V
ON
DVM_PTA_RULE_SETS.RULE_SET_ID =
DVM_RULE_SETS_V.RULE_SET_ID
ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_RULE_SETS_V.QC_SORT_ORDER, DVM_RULE_SETS_V.OBJECT_NAME, DVM_RULE_SETS_V.ERR_SEVERITY_CODE, DVM_RULE_SETS_V.ERR_TYPE_NAME;

   COMMENT ON COLUMN "DVM_PTA_ISSUE_TYPES_V"."PTA_ERROR_ID" IS 'Primary Key for the SPT_PTA_ERRORS table';
   COMMENT ON COLUMN "DVM_PTA_ISSUE_TYPES_V"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ISSUE_TYPES_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';

COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_SET_ID IS 'Primary key for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERROR_TYPE_ID IS 'The issue type for the given error';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.DATA_STREAM_PK_FIELD IS 'The Data stream''s parent table name for the given issue type (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';




COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent error record';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent error record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent error record';
COMMENT ON COLUMN DVM_PTA_ISSUE_TYPES_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent error record (MM/DD/YYYY HH24:MI format)';



   COMMENT ON TABLE "DVM_PTA_ISSUE_TYPES_V"  IS 'PTA Error Types (View)

This View returns all Error Types associated with a given PTA Error Type record.  The PTA Error Type record is defined the first time the given data stream is first entered into the database, all active Error Types at this point in time are saved and associated with a new PTA Error Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Error Types that were associated with the a data stream when the given parent record is first entered into the database.  ';







  CREATE OR REPLACE VIEW DVM_PTA_ERRORS_V
AS
  SELECT
  DVM_PTA_ERRORS.PTA_ERROR_ID,
  DVM_PTA_ERRORS.CREATE_DATE,
  TO_CHAR(DVM_PTA_ERRORS.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMATTED_CREATE_DATE,

	DVM_ERRORS.ERROR_ID,
  DVM_ERRORS.ERROR_DESCRIPTION,
  DVM_ERRORS.ERROR_NOTES,
  DVM_ERRORS.ERR_RES_TYPE_ID,
	DVM_ERR_RES_TYPES.ERR_RES_TYPE_CODE,
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_NAME,
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_DESC,
  DVM_ERRORS.APP_LINK_URL,
  DVM_ERRORS.ERROR_TYPE_ID,


	DVM_CRITERIA_V.QC_OBJECT_ID,
	DVM_CRITERIA_V.OBJECT_NAME,
	DVM_CRITERIA_V.QC_OBJ_ACTIVE_YN,
	DVM_CRITERIA_V.QC_SORT_ORDER,
	DVM_CRITERIA_V.ERR_TYPE_NAME,
	DVM_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE,
	DVM_CRITERIA_V.ERR_TYPE_DESC,
	DVM_CRITERIA_V.IND_FIELD_NAME,
	DVM_CRITERIA_V.APP_LINK_TEMPLATE,
	DVM_CRITERIA_V.ERR_SEVERITY_ID,
	DVM_CRITERIA_V.ERR_SEVERITY_CODE,
	DVM_CRITERIA_V.ERR_SEVERITY_NAME,
	DVM_CRITERIA_V.ERR_SEVERITY_DESC,
	DVM_CRITERIA_V.DATA_STREAM_ID,
	DVM_CRITERIA_V.DATA_STREAM_CODE,
	DVM_CRITERIA_V.DATA_STREAM_NAME,
	DVM_CRITERIA_V.DATA_STREAM_DESC,
	DVM_CRITERIA_V.DATA_STREAM_PK_FIELD,
	DVM_CRITERIA_V.ERR_TYPE_ACTIVE_YN




FROM
  DVM_ERRORS
INNER JOIN DVM_PTA_ERRORS
ON
  DVM_PTA_ERRORS.PTA_ERROR_ID = DVM_ERRORS.PTA_ERROR_ID
INNER JOIN DVM_CRITERIA_V
ON
	DVM_CRITERIA_V.ERROR_TYPE_ID = DVM_ERRORS.ERROR_TYPE_ID
LEFT JOIN DVM_ERR_RES_TYPES
ON
  DVM_ERR_RES_TYPES.ERR_RES_TYPE_ID = DVM_ERRORS.ERR_RES_TYPE_ID




  ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_CRITERIA_V.QC_SORT_ORDER, DVM_CRITERIA_V.OBJECT_NAME, DVM_CRITERIA_V.ERR_SEVERITY_CODE, DVM_CRITERIA_V.ERR_TYPE_NAME;

   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."PTA_ERROR_ID" IS 'Foreign key reference to the Errors (PTA) intersection table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERROR_ID" IS 'Primary Key for the SPT_ERRORS table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERROR_DESCRIPTION" IS 'The description of the given XML Data File error';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERROR_NOTES" IS 'Manually entered notes for the corresponding data error';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERROR_TYPE_ID" IS 'The Error Type for the given error';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."QC_OBJECT_ID" IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_TYPE_DESC" IS 'The description for the given QC validation error type';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_SEVERITY_ID" IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_SEVERITY_CODE" IS 'The code for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_SEVERITY_NAME" IS 'The name for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_SEVERITY_DESC" IS 'The description for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given error type criteria is active';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_RES_TYPE_ID" IS 'Primary Key for the SPT_ERR_RES_TYPES table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_RES_TYPE_CODE" IS 'The Error Resolution Type code';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_RES_TYPE_NAME" IS 'The Error Resolution Type name';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."ERR_RES_TYPE_DESC" IS 'The Error Resolution Type description';

   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."APP_LINK_TEMPLATE" IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';


	COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';

   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."APP_LINK_URL" IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ERROR_TYPES record''s APP_LINK_TEMPLATE value';




   COMMENT ON TABLE "DVM_PTA_ERRORS_V"  IS 'PTA Errors (View)

This View returns all unresolved Errors associated with a given PTA Error record that were identified during the last evaluation of the associated PTA Error Types.  A PTA Error record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each error identified as well as general information about the given Error''s Error Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.';









/*******************************************************/
--execute the SQL to migrate the error type assoc records
/*******************************************************/
