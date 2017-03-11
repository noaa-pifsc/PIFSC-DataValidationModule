--------------------------------------------------------
--  File created - Friday-March-10-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table DVM_DATA_STREAMS
--------------------------------------------------------

  CREATE TABLE "DVM_DATA_STREAMS" 
   (	"DATA_STREAM_ID" NUMBER, 
	"DATA_STREAM_CODE" VARCHAR2(20), 
	"DATA_STREAM_NAME" VARCHAR2(100), 
	"DATA_STREAM_DESC" VARCHAR2(1000), 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30), 
	"DATA_STREAM_PAR_TABLE" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "DVM_DATA_STREAMS"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON COLUMN "DVM_DATA_STREAMS"."DATA_STREAM_PAR_TABLE" IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
   COMMENT ON TABLE "DVM_DATA_STREAMS"  IS 'Data Streams

This is a reference table that defines all data streams that are implemented in the data validation module.  This reference table is referenced by the DVM_ERROR_TYPES to define the data stream that the given error type is associated with.  Examples of data streams are RPL, eTunaLog, UL, FOT, LFSC.  This is used to filter these records based on the given context of the processing/validation';
--------------------------------------------------------
--  DDL for Table DVM_ERRORS
--------------------------------------------------------

  CREATE TABLE "DVM_ERRORS" 
   (	"ERROR_ID" NUMBER, 
	"PTA_ERROR_ID" NUMBER, 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30), 
	"ERROR_TYPE_ID" NUMBER, 
	"ERROR_NOTES" VARCHAR2(500), 
	"ERR_RES_TYPE_ID" NUMBER, 
	"ERROR_DESCRIPTION" CLOB
   ) ;

   COMMENT ON COLUMN "DVM_ERRORS"."ERROR_ID" IS 'Primary Key for the SPT_ERRORS table';
   COMMENT ON COLUMN "DVM_ERRORS"."PTA_ERROR_ID" IS 'The PTA Error record the error corresponds to, this indicates which parent record for the given data stream the errors are associated with';
   COMMENT ON COLUMN "DVM_ERRORS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_ERRORS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_ERRORS"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_ERRORS"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON COLUMN "DVM_ERRORS"."ERROR_TYPE_ID" IS 'The Error Type for the given error';
   COMMENT ON COLUMN "DVM_ERRORS"."ERROR_NOTES" IS 'Manually entered notes for the corresponding data error';
   COMMENT ON COLUMN "DVM_ERRORS"."ERR_RES_TYPE_ID" IS 'Foreign key reference to the Error Resolution Types reference table.  A non-null value indicates that the given error is inactive and has been resolved/will be resolved';
   COMMENT ON COLUMN "DVM_ERRORS"."ERROR_DESCRIPTION" IS 'The description of the given XML Data File error';
   COMMENT ON TABLE "DVM_ERRORS"  IS 'Data Errors

This is an error table that represents any specific data error instances that a given data table/entity contains (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These records will be used to communicate errors to the data entry and data management staff';
--------------------------------------------------------
--  DDL for Table DVM_ERR_RES_TYPES
--------------------------------------------------------

  CREATE TABLE "DVM_ERR_RES_TYPES" 
   (	"ERR_RES_TYPE_ID" NUMBER, 
	"ERR_RES_TYPE_CODE" VARCHAR2(20), 
	"ERR_RES_TYPE_NAME" VARCHAR2(200), 
	"ERR_RES_TYPE_DESC" VARCHAR2(1000), 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."ERR_RES_TYPE_ID" IS 'Primary Key for the SPT_ERR_RES_TYPES table';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."ERR_RES_TYPE_CODE" IS 'The Error Resolution Type code';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."ERR_RES_TYPE_NAME" IS 'The Error Resolution Type name';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."ERR_RES_TYPE_DESC" IS 'The Error Resolution Type description';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON TABLE "DVM_ERR_RES_TYPES"  IS 'Error Resolution Types

This is a reference table that defines all error resolutions types that will be used to define the status of a given QC data validation issue.  When an error is marked as resolved it will have an annotation to explain the resolution of the error.  The types of error resolutions include no data available, manually reviewed and accepted, no resolution can be reached yet.  Certain error resolutions types will cause an error to be filtered out from the standard error reports.';
--------------------------------------------------------
--  DDL for Table DVM_ERROR_TYPES
--------------------------------------------------------

  CREATE TABLE "DVM_ERROR_TYPES" 
   (	"ERROR_TYPE_ID" NUMBER, 
	"ERR_TYPE_NAME" VARCHAR2(500), 
	"QC_OBJECT_ID" NUMBER, 
	"ERR_TYPE_DESC" VARCHAR2(1000), 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30), 
	"IND_FIELD_NAME" VARCHAR2(30), 
	"ERR_SEVERITY_ID" NUMBER, 
	"DATA_STREAM_ID" NUMBER, 
	"ERR_TYPE_ACTIVE_YN" CHAR(1) DEFAULT 'Y', 
	"ERR_TYPE_COMMENT_TEMPLATE" CLOB
   ) ;

   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERROR_TYPE_ID" IS 'Primary Key for the SPT_ERROR_TYPES table';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERR_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."QC_OBJECT_ID" IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERR_TYPE_DESC" IS 'The description for the given QC validation error type';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERR_SEVERITY_ID" IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."DATA_STREAM_ID" IS 'The Category for the given error type criteria.  This is used to filter error criteria based on the given context of the validation (e.g. eTunaLog XML data import, tracking QC, etc.)';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERR_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given error type criteria is active';
   COMMENT ON COLUMN "DVM_ERROR_TYPES"."ERR_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON TABLE "DVM_ERROR_TYPES"  IS 'Data Error Types

This is a reference table that defines the different QC Data Error Types that indicate how to identify QC errors and report them to end-users for resolution.  Each Data Error will have a corresponding Data Error Type.';
--------------------------------------------------------
--  DDL for Table DVM_ERR_SEVERITY
--------------------------------------------------------

  CREATE TABLE "DVM_ERR_SEVERITY" 
   (	"ERR_SEVERITY_ID" NUMBER, 
	"ERR_SEVERITY_CODE" VARCHAR2(20), 
	"ERR_SEVERITY_NAME" VARCHAR2(100), 
	"ERR_SEVERITY_DESC" VARCHAR2(1000), 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."ERR_SEVERITY_ID" IS 'Primary Key for the SPT_ERR_SEVERITY table';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."ERR_SEVERITY_CODE" IS 'The code for the given error severity';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."ERR_SEVERITY_NAME" IS 'The name for the given error severity';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."ERR_SEVERITY_DESC" IS 'The description for the given error severity';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON TABLE "DVM_ERR_SEVERITY"  IS 'Error Severity

This is a reference table that defines all error severities for error type criteria.  This indicates the status of the given error type criteria (e.g. warnings, data errors, violations of law, etc.)';
--------------------------------------------------------
--  DDL for Table DVM_PTA_ERRORS
--------------------------------------------------------

  CREATE TABLE "DVM_PTA_ERRORS" 
   (	"PTA_ERROR_ID" NUMBER, 
	"CREATE_DATE" DATE, 
	"LAST_EVAL_DATE" DATE
   ) ;

   COMMENT ON COLUMN "DVM_PTA_ERRORS"."PTA_ERROR_ID" IS 'Primary Key for the SPT_PTA_ERRORS table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS"."CREATE_DATE" IS 'The date on which this record was created in the database (indicates when the given associated data stream parent record was first evaluated)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS"."LAST_EVAL_DATE" IS 'The date on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';
   COMMENT ON TABLE "DVM_PTA_ERRORS"  IS 'Error Types/Errors (PTA)

This table represents a generalized intersection table that allows multiple Error and Error Type Association records to reference this consolidated table that allows multiple Errors and Error Types to be associated with the given parent table record (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_CANN_TRANSACTIONS, etc.).';
--------------------------------------------------------
--  DDL for Table DVM_QC_OBJECTS
--------------------------------------------------------

  CREATE TABLE "DVM_QC_OBJECTS" 
   (	"QC_OBJECT_ID" NUMBER, 
	"OBJECT_NAME" VARCHAR2(30), 
	"QC_OBJ_ACTIVE_YN" CHAR(1) DEFAULT 'Y', 
	"QC_SORT_ORDER" NUMBER, 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "DVM_QC_OBJECTS"."QC_OBJECT_ID" IS 'Primary Key for the SPT_QC_OBJECTS table';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "DVM_QC_OBJECTS"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON TABLE "DVM_QC_OBJECTS"  IS 'Data QC Objects

This is a reference table that defines all of the QC validation views that are executed on the data model after a given data stream is loaded into the database (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES).';
--------------------------------------------------------
--  DDL for Table DVM_PTA_ERR_TYP_ASSOC
--------------------------------------------------------

  CREATE TABLE "DVM_PTA_ERR_TYP_ASSOC" 
   (	"PTA_ERR_TYP_ASSOC_ID" NUMBER, 
	"PTA_ERROR_ID" NUMBER, 
	"ERROR_TYPE_ID" NUMBER, 
	"CREATE_DATE" DATE, 
	"EFFECTIVE_DATE" DATE, 
	"END_DATE" DATE
   ) ;

   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."PTA_ERR_TYP_ASSOC_ID" IS 'Primary Key for the SPT_PTA_ERR_TYP_ASSOC table';
   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."PTA_ERROR_ID" IS 'Foreign key reference to the Error Types/Errors (PTA) table.  This indicates a given Data Error Type rule was active at the time a given data table record was added to the database (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_CANN_TRANSACTIONS, etc.)';
   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."ERROR_TYPE_ID" IS 'Foreign key reference to the Data Error Types table that indicates a given Data Error Type was active for a given data table (depends on related Error Data Category) at the time it was added to the database';
   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."EFFECTIVE_DATE" IS 'The effective date for the given set of enabled Error Type Definitions';
   COMMENT ON COLUMN "DVM_PTA_ERR_TYP_ASSOC"."END_DATE" IS 'The end date for the given set of enabled Error Type Definitions';
   COMMENT ON TABLE "DVM_PTA_ERR_TYP_ASSOC"  IS 'Error Type Associations (PTA)

This intersection table allows multiple Error Types to be associated with a given table (e.g. SPT_VESSEL_TRIPS, SPT_UL_TRANSACTIONS, SPT_APP_XML_FILES, etc.).  These associations represent the Error Types that are defined at the time that a given table record is created so that the specific rules can be applied for subsequent validation assessments over time.  ';


--------------------------------------------------------
--  File created - Friday-March-10-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Index DVM_DATA_STREAMS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_DATA_STREAMS_PK" ON "DVM_DATA_STREAMS" ("DATA_STREAM_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_DATA_STREAMS_U1
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_DATA_STREAMS_U1" ON "DVM_DATA_STREAMS" ("DATA_STREAM_CODE") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_DATA_STREAMS_U2
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_DATA_STREAMS_U2" ON "DVM_DATA_STREAMS" ("DATA_STREAM_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERRORS_I1
--------------------------------------------------------

  CREATE INDEX "DVM_ERRORS_I1" ON "DVM_ERRORS" ("PTA_ERROR_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERRORS_I2
--------------------------------------------------------

  CREATE INDEX "DVM_ERRORS_I2" ON "DVM_ERRORS" ("ERROR_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERRORS_I3
--------------------------------------------------------

  CREATE INDEX "DVM_ERRORS_I3" ON "DVM_ERRORS" ("ERR_RES_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERRORS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERRORS_PK" ON "DVM_ERRORS" ("ERROR_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERROR_TYPES_I1
--------------------------------------------------------

  CREATE INDEX "DVM_ERROR_TYPES_I1" ON "DVM_ERROR_TYPES" ("QC_OBJECT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERROR_TYPES_I2
--------------------------------------------------------

  CREATE INDEX "DVM_ERROR_TYPES_I2" ON "DVM_ERROR_TYPES" ("ERR_SEVERITY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERROR_TYPES_I3
--------------------------------------------------------

  CREATE INDEX "DVM_ERROR_TYPES_I3" ON "DVM_ERROR_TYPES" ("DATA_STREAM_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERROR_TYPES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERROR_TYPES_PK" ON "DVM_ERROR_TYPES" ("ERROR_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERROR_TYPES_U1
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERROR_TYPES_U1" ON "DVM_ERROR_TYPES" ("IND_FIELD_NAME", "DATA_STREAM_ID", "QC_OBJECT_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_RES_TYPES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_RES_TYPES_PK" ON "DVM_ERR_RES_TYPES" ("ERR_RES_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_RES_TYPES_U1
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_RES_TYPES_U1" ON "DVM_ERR_RES_TYPES" ("ERR_RES_TYPE_CODE") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_RES_TYPES_U2
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_RES_TYPES_U2" ON "DVM_ERR_RES_TYPES" ("ERR_RES_TYPE_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_SEVERITY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_SEVERITY_PK" ON "DVM_ERR_SEVERITY" ("ERR_SEVERITY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_SEVERITY_U1
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_SEVERITY_U1" ON "DVM_ERR_SEVERITY" ("ERR_SEVERITY_CODE") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_ERR_SEVERITY_U2
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_ERR_SEVERITY_U2" ON "DVM_ERR_SEVERITY" ("ERR_SEVERITY_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_PTA_ERRORS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_PTA_ERRORS_PK" ON "DVM_PTA_ERRORS" ("PTA_ERROR_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_PTA_ERR_TYP_ASSOC_I1
--------------------------------------------------------

  CREATE INDEX "DVM_PTA_ERR_TYP_ASSOC_I1" ON "DVM_PTA_ERR_TYP_ASSOC" ("PTA_ERROR_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_PTA_ERR_TYP_ASSOC_I2
--------------------------------------------------------

  CREATE INDEX "DVM_PTA_ERR_TYP_ASSOC_I2" ON "DVM_PTA_ERR_TYP_ASSOC" ("ERROR_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_PTA_ERR_TYP_ASSOC_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_PTA_ERR_TYP_ASSOC_PK" ON "DVM_PTA_ERR_TYP_ASSOC" ("PTA_ERR_TYP_ASSOC_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_PTA_ERR_TYP_ASSOC_U1
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_PTA_ERR_TYP_ASSOC_U1" ON "DVM_PTA_ERR_TYP_ASSOC" ("PTA_ERROR_ID", "ERROR_TYPE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index DVM_QC_OBJECTS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DVM_QC_OBJECTS_PK" ON "DVM_QC_OBJECTS" ("QC_OBJECT_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table DVM_DATA_STREAMS
--------------------------------------------------------

  ALTER TABLE "DVM_DATA_STREAMS" ADD CONSTRAINT "DVM_DATA_STREAMS_PK" PRIMARY KEY ("DATA_STREAM_ID") ENABLE;
  ALTER TABLE "DVM_DATA_STREAMS" ADD CONSTRAINT "DVM_DATA_STREAMS_U1" UNIQUE ("DATA_STREAM_CODE") ENABLE;
  ALTER TABLE "DVM_DATA_STREAMS" ADD CONSTRAINT "DVM_DATA_STREAMS_U2" UNIQUE ("DATA_STREAM_NAME") ENABLE;
  ALTER TABLE "DVM_DATA_STREAMS" MODIFY ("DATA_STREAM_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_DATA_STREAMS" MODIFY ("DATA_STREAM_CODE" NOT NULL ENABLE);
  ALTER TABLE "DVM_DATA_STREAMS" MODIFY ("DATA_STREAM_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_ERRORS
--------------------------------------------------------

  ALTER TABLE "DVM_ERRORS" ADD CONSTRAINT "DVM_ERRORS_PK" PRIMARY KEY ("ERROR_ID") ENABLE;
  ALTER TABLE "DVM_ERRORS" MODIFY ("ERROR_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERRORS" MODIFY ("PTA_ERROR_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERRORS" MODIFY ("ERROR_TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERRORS" MODIFY ("ERROR_DESCRIPTION" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_ERROR_TYPES
--------------------------------------------------------

  ALTER TABLE "DVM_ERROR_TYPES" ADD CONSTRAINT "DVM_ERROR_TYPES_PK" PRIMARY KEY ("ERROR_TYPE_ID") ENABLE;
  ALTER TABLE "DVM_ERROR_TYPES" ADD CONSTRAINT "DVM_ERROR_TYPES_U1" UNIQUE ("IND_FIELD_NAME", "DATA_STREAM_ID", "QC_OBJECT_ID") ENABLE;
  ALTER TABLE "DVM_ERROR_TYPES" MODIFY ("ERROR_TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERROR_TYPES" MODIFY ("ERR_TYPE_NAME" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERROR_TYPES" MODIFY ("IND_FIELD_NAME" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERROR_TYPES" MODIFY ("ERR_TYPE_ACTIVE_YN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_ERR_RES_TYPES
--------------------------------------------------------

  ALTER TABLE "DVM_ERR_RES_TYPES" ADD CONSTRAINT "DVM_ERR_RES_TYPES_PK" PRIMARY KEY ("ERR_RES_TYPE_ID") ENABLE;
  ALTER TABLE "DVM_ERR_RES_TYPES" ADD CONSTRAINT "DVM_ERR_RES_TYPES_U1" UNIQUE ("ERR_RES_TYPE_CODE") ENABLE;
  ALTER TABLE "DVM_ERR_RES_TYPES" ADD CONSTRAINT "DVM_ERR_RES_TYPES_U2" UNIQUE ("ERR_RES_TYPE_NAME") ENABLE;
  ALTER TABLE "DVM_ERR_RES_TYPES" MODIFY ("ERR_RES_TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERR_RES_TYPES" MODIFY ("ERR_RES_TYPE_CODE" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERR_RES_TYPES" MODIFY ("ERR_RES_TYPE_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_ERR_SEVERITY
--------------------------------------------------------

  ALTER TABLE "DVM_ERR_SEVERITY" ADD CONSTRAINT "DVM_ERR_SEVERITY_PK" PRIMARY KEY ("ERR_SEVERITY_ID") ENABLE;
  ALTER TABLE "DVM_ERR_SEVERITY" ADD CONSTRAINT "DVM_ERR_SEVERITY_U1" UNIQUE ("ERR_SEVERITY_CODE") ENABLE;
  ALTER TABLE "DVM_ERR_SEVERITY" ADD CONSTRAINT "DVM_ERR_SEVERITY_U2" UNIQUE ("ERR_SEVERITY_NAME") ENABLE;
  ALTER TABLE "DVM_ERR_SEVERITY" MODIFY ("ERR_SEVERITY_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERR_SEVERITY" MODIFY ("ERR_SEVERITY_CODE" NOT NULL ENABLE);
  ALTER TABLE "DVM_ERR_SEVERITY" MODIFY ("ERR_SEVERITY_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_PTA_ERRORS
--------------------------------------------------------

  ALTER TABLE "DVM_PTA_ERRORS" ADD CONSTRAINT "DVM_PTA_ERRORS_PK" PRIMARY KEY ("PTA_ERROR_ID") ENABLE;
  ALTER TABLE "DVM_PTA_ERRORS" MODIFY ("PTA_ERROR_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_PTA_ERRORS" MODIFY ("CREATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "DVM_PTA_ERRORS" MODIFY ("LAST_EVAL_DATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_PTA_ERR_TYP_ASSOC
--------------------------------------------------------

  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" ADD CONSTRAINT "DVM_PTA_ERR_TYP_ASSOC_PK" PRIMARY KEY ("PTA_ERR_TYP_ASSOC_ID") ENABLE;
  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" ADD CONSTRAINT "DVM_PTA_ERR_TYP_ASSOC_U1" UNIQUE ("PTA_ERROR_ID", "ERROR_TYPE_ID") ENABLE;
  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" MODIFY ("PTA_ERR_TYP_ASSOC_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" MODIFY ("PTA_ERROR_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" MODIFY ("ERROR_TYPE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DVM_QC_OBJECTS
--------------------------------------------------------

  ALTER TABLE "DVM_QC_OBJECTS" ADD CONSTRAINT "DVM_QC_OBJECTS_PK" PRIMARY KEY ("QC_OBJECT_ID") ENABLE;
  ALTER TABLE "DVM_QC_OBJECTS" MODIFY ("QC_OBJECT_ID" NOT NULL ENABLE);
  ALTER TABLE "DVM_QC_OBJECTS" MODIFY ("OBJECT_NAME" NOT NULL ENABLE);
  ALTER TABLE "DVM_QC_OBJECTS" MODIFY ("QC_OBJ_ACTIVE_YN" NOT NULL ENABLE);

--------------------------------------------------------
--  Ref Constraints for Table DVM_ERRORS
--------------------------------------------------------

  ALTER TABLE "DVM_ERRORS" ADD CONSTRAINT "DVM_ERRORS_FK1" FOREIGN KEY ("PTA_ERROR_ID")
	  REFERENCES "DVM_PTA_ERRORS" ("PTA_ERROR_ID") ENABLE;
  ALTER TABLE "DVM_ERRORS" ADD CONSTRAINT "DVM_ERRORS_FK2" FOREIGN KEY ("ERROR_TYPE_ID")
	  REFERENCES "DVM_ERROR_TYPES" ("ERROR_TYPE_ID") ENABLE;
  ALTER TABLE "DVM_ERRORS" ADD CONSTRAINT "DVM_ERRORS_FK3" FOREIGN KEY ("ERR_RES_TYPE_ID")
	  REFERENCES "DVM_ERR_RES_TYPES" ("ERR_RES_TYPE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table DVM_ERROR_TYPES
--------------------------------------------------------

  ALTER TABLE "DVM_ERROR_TYPES" ADD CONSTRAINT "DVM_ERROR_TYPES_FK1" FOREIGN KEY ("QC_OBJECT_ID")
	  REFERENCES "DVM_QC_OBJECTS" ("QC_OBJECT_ID") ENABLE;
  ALTER TABLE "DVM_ERROR_TYPES" ADD CONSTRAINT "DVM_ERROR_TYPES_FK2" FOREIGN KEY ("ERR_SEVERITY_ID")
	  REFERENCES "DVM_ERR_SEVERITY" ("ERR_SEVERITY_ID") ENABLE;
  ALTER TABLE "DVM_ERROR_TYPES" ADD CONSTRAINT "DVM_ERROR_TYPES_FK3" FOREIGN KEY ("DATA_STREAM_ID")
	  REFERENCES "DVM_DATA_STREAMS" ("DATA_STREAM_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table DVM_PTA_ERR_TYP_ASSOC
--------------------------------------------------------

  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" ADD CONSTRAINT "DVM_PTA_ERR_TYP_ASSOC_FK1" FOREIGN KEY ("PTA_ERROR_ID")
	  REFERENCES "DVM_PTA_ERRORS" ("PTA_ERROR_ID") ENABLE;
  ALTER TABLE "DVM_PTA_ERR_TYP_ASSOC" ADD CONSTRAINT "DVM_PTA_ERR_TYP_ASSOC_FK2" FOREIGN KEY ("ERROR_TYPE_ID")
	  REFERENCES "DVM_ERROR_TYPES" ("ERROR_TYPE_ID") ENABLE;




--create sequences
CREATE SEQUENCE DVM_ERRORS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE DVM_ERROR_TYPES_SEQ INCREMENT BY 1 START WITH 142;
CREATE SEQUENCE DVM_QC_OBJECTS_SEQ INCREMENT BY 1 START WITH 4;
CREATE SEQUENCE DVM_PTA_ERRORS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE DVM_PTA_ERR_TYP_ASSOC_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE DVM_ERR_SEVERITY_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE DVM_DATA_STREAMS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE DVM_ERR_RES_TYPES_SEQ INCREMENT BY 1 START WITH 1;




--trigger definitions:


CREATE OR REPLACE TRIGGER DVM_ERRORS_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ERRORS FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

CREATE OR REPLACE TRIGGER DVM_ERROR_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ERROR_TYPES FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

CREATE OR REPLACE TRIGGER DVM_QC_OBJECTS_AUTO_BRU BEFORE
  UPDATE
    ON DVM_QC_OBJECTS FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



CREATE OR REPLACE TRIGGER DVM_ERR_SEVERITY_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ERR_SEVERITY FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

CREATE OR REPLACE TRIGGER DVM_DATA_STREAMS_AUTO_BRU BEFORE
  UPDATE
    ON DVM_DATA_STREAMS FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

CREATE OR REPLACE TRIGGER DVM_ERR_RES_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ERR_RES_TYPES FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



create or replace TRIGGER DVM_ERRORS_AUTO_BRI
before insert on DVM_ERRORS
for each row
begin
  select DVM_ERRORS_SEQ.nextval into :new.ERROR_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER DVM_ERROR_TYPES_AUTO_BRI
before insert on DVM_ERROR_TYPES
for each row
begin
  select DVM_ERROR_TYPES_SEQ.nextval into :new.ERROR_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER DVM_QC_OBJECTS_AUTO_BRI
before insert on DVM_QC_OBJECTS
for each row
begin
  select DVM_QC_OBJECTS_SEQ.nextval into :new.QC_OBJECT_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/



create or replace TRIGGER DVM_ERR_SEVERITY_AUTO_BRI
before insert on DVM_ERR_SEVERITY
for each row
begin
  select DVM_ERR_SEVERITY_SEQ.nextval into :new.ERR_SEVERITY_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER DVM_DATA_STREAMS_AUTO_BRI
before insert on DVM_DATA_STREAMS
for each row
begin
  select DVM_DATA_STREAMS_SEQ.nextval into :new.DATA_STREAM_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER DVM_ERR_RES_TYPES_AUTO_BRI
before insert on DVM_ERR_RES_TYPES
for each row
begin
  select DVM_ERR_RES_TYPES_SEQ.nextval into :new.ERR_RES_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/






CREATE OR REPLACE TRIGGER DVM_PTA_ERR_TYP_ASSOC_AUTO_BRI
before insert on DVM_PTA_ERR_TYP_ASSOC
for each row
begin
select DVM_PTA_ERR_TYP_ASSOC_SEQ.nextval into :new.PTA_ERR_TYP_ASSOC_ID from dual;
end;
/



CREATE OR REPLACE TRIGGER DVM_PTA_ERRORS_AUTO_BRI
before insert on DVM_PTA_ERRORS
for each row
begin
select DVM_PTA_ERRORS_SEQ.nextval into :new.PTA_ERROR_ID from dual;
end;
/




--------------------------------------------------------
--  File created - Friday-March-10-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View DVM_DATA_STREAMS_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DVM_DATA_STREAMS_V" ("DATA_STREAM_ID", "DATA_STREAM_CODE", "DATA_STREAM_NAME", "DATA_STREAM_DESC", "DATA_STREAM_PAR_TABLE", "DATA_STREAM_PK_FIELD") AS 
  SELECT 
DVM_DATA_STREAMS.DATA_STREAM_ID,
DVM_DATA_STREAMS.DATA_STREAM_CODE,
DVM_DATA_STREAMS.DATA_STREAM_NAME,
DVM_DATA_STREAMS.DATA_STREAM_DESC,
DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE,
PK_INFO.COLUMN_NAME DATA_STREAM_PK_FIELD
from 
dvm_data_streams left join
(
  SELECT A.TABLE_NAME, A.COLUMN_NAME
  
  FROM 

user_cons_columns A

INNER JOIN user_CONSTRAINTS C
ON
A.TABLE_NAME       = C.TABLE_NAME
AND A.CONSTRAINT_NAME  = C.CONSTRAINT_NAME
--retrieve only primary key constraints
AND C.CONSTRAINT_TYPE IN ('P')) PK_INFO
ON PK_INFO.TABLE_NAME = DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE;

   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_PAR_TABLE" IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
   COMMENT ON TABLE "DVM_DATA_STREAMS_V"  IS 'Data Streams (View)

This query returns all data streams that are implemented in the data validation module.  Examples of data streams are RPL, eTunaLog, UL, FOT, LFSC.  This is used to filter error records based on the given context of the processing/validation.  This view also returns the PK field name for each of the data streams based on the value of DATA_STREAM_PAR_TABLE using the current schema''s data dictionary';
--------------------------------------------------------
--  DDL for View DVM_PTA_ERRORS_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DVM_PTA_ERRORS_V" ("PTA_ERROR_ID", "CREATE_DATE", "FORMATTED_CREATE_DATE", "LAST_EVAL_DATE", "FORMATTED_LAST_EVAL_DATE", "ERROR_ID", "ERROR_DESCRIPTION", "ERROR_NOTES", "ERROR_TYPE_ID", "ERR_TYPE_NAME", "ERR_TYPE_COMMENT_TEMPLATE", "QC_OBJECT_ID", "OBJECT_NAME", "QC_OBJ_ACTIVE_YN", "QC_SORT_ORDER", "ERR_TYPE_DESC", "IND_FIELD_NAME", "ERR_SEVERITY_ID", "ERR_SEVERITY_CODE", "ERR_SEVERITY_NAME", "ERR_SEVERITY_DESC", "DATA_STREAM_ID", "DATA_STREAM_CODE", "DATA_STREAM_NAME", "DATA_STREAM_DESC", "ERR_TYPE_ACTIVE_YN", "ERR_RES_TYPE_ID", "ERR_RES_TYPE_CODE", "ERR_RES_TYPE_NAME", "ERR_RES_TYPE_DESC") AS 
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

  ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_QC_OBJECTS.QC_SORT_ORDER, DVM_QC_OBJECTS.OBJECT_NAME;

   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."PTA_ERROR_ID" IS 'Foreign key reference to the Errors (PTA) intersection table';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."LAST_EVAL_DATE" IS 'The date on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';
   COMMENT ON COLUMN "DVM_PTA_ERRORS_V"."FORMATTED_LAST_EVAL_DATE" IS 'The formatted date/time on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated (MM/DD/YYYY HH24:MI)';
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
   COMMENT ON TABLE "DVM_PTA_ERRORS_V"  IS 'PTA Errors (View)

This View returns all unresolved Errors associated with a given PTA Error record that were identified during the last evaluation of the associated PTA Error Types.  A PTA Error record can be referenced by any data table that represents the parent record for a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  The query returns detailed information about the specifics of each error identified as well as general information about the given Error''s Error Type.  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.';
--------------------------------------------------------
--  DDL for View DVM_PTA_ERROR_TYPES_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DVM_PTA_ERROR_TYPES_V" ("PTA_ERROR_ID", "CREATE_DATE", "FORMATTED_CREATE_DATE", "PTA_ERR_TYP_ASSOC_ID", "ERROR_TYPE_ID", "ERR_TYPE_NAME", "ERR_TYPE_COMMENT_TEMPLATE", "QC_OBJECT_ID", "OBJECT_NAME", "QC_OBJ_ACTIVE_YN", "QC_SORT_ORDER", "ERR_TYPE_DESC", "IND_FIELD_NAME", "ERR_SEVERITY_ID", "ERR_SEVERITY_CODE", "ERR_SEVERITY_NAME", "ERR_SEVERITY_DESC", "DATA_STREAM_ID", "DATA_STREAM_CODE", "DATA_STREAM_NAME", "DATA_STREAM_DESC", "ERR_TYPE_ACTIVE_YN") AS 
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
ORDER BY DVM_PTA_ERRORS.PTA_ERROR_ID, DVM_QC_OBJECTS.QC_SORT_ORDER, DVM_QC_OBJECTS.OBJECT_NAME;

   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."PTA_ERROR_ID" IS 'Primary Key for the SPT_PTA_ERRORS table';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."FORMATTED_CREATE_DATE" IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."PTA_ERR_TYP_ASSOC_ID" IS 'Primary Key for the SPT_PTA_ERR_TYP_ASSOC table';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERROR_TYPE_ID" IS 'The Error Type for the given error';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."QC_OBJECT_ID" IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_TYPE_DESC" IS 'The description for the given QC validation error type';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_SEVERITY_ID" IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_SEVERITY_CODE" IS 'The code for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_SEVERITY_NAME" IS 'The name for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_SEVERITY_DESC" IS 'The description for the given error severity';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_PTA_ERROR_TYPES_V"."ERR_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given error type criteria is active';
   COMMENT ON TABLE "DVM_PTA_ERROR_TYPES_V"  IS 'PTA Error Types (View)

This View returns all Error Types associated with a given PTA Error Type record.  The PTA Error Type record is defined the first time the given data stream is first entered into the database, all active Error Types at this point in time are saved and associated with a new PTA Error Type record and this is referenced by a given parent record of a given data stream (e.g. SPT_VESSEL_TRIPS for RPL data).  Each associated date/time is provided as a standard formatted date in MM/DD/YYYY HH24:MI format.  This relationship is used to determine the Error Types that were associated with the a data stream when the given parent record is first entered into the database.  ';
--------------------------------------------------------
--  DDL for View DVM_QC_CRITERIA_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DVM_QC_CRITERIA_V" ("QC_OBJECT_ID", "OBJECT_NAME", "QC_OBJ_ACTIVE_YN", "QC_SORT_ORDER", "ERROR_TYPE_ID", "ERR_TYPE_NAME", "ERR_TYPE_COMMENT_TEMPLATE", "ERR_TYPE_DESC", "IND_FIELD_NAME", "ERR_SEVERITY_ID", "ERR_SEVERITY_CODE", "ERR_SEVERITY_NAME", "ERR_SEVERITY_DESC", "DATA_STREAM_ID", "DATA_STREAM_CODE", "DATA_STREAM_NAME", "DATA_STREAM_DESC", "DATA_STREAM_PK_FIELD", "ERR_TYPE_ACTIVE_YN") AS 
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

DVM_QC_OBJECTS.QC_SORT_ORDER;

   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."QC_OBJECT_ID" IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."OBJECT_NAME" IS 'The name of the object that is used in the given QC validation criteria';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."QC_OBJ_ACTIVE_YN" IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."QC_SORT_ORDER" IS 'Relative sort order for the QC object to be executed in';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERROR_TYPE_ID" IS 'The Error Type for the given error';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_TYPE_NAME" IS 'The name of the given QC validation criteria';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_TYPE_COMMENT_TEMPLATE" IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_TYPE_DESC" IS 'The description for the given QC validation error type';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."IND_FIELD_NAME" IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_SEVERITY_ID" IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_SEVERITY_CODE" IS 'The code for the given error severity';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_SEVERITY_NAME" IS 'The name for the given error severity';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_SEVERITY_DESC" IS 'The description for the given error severity';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."DATA_STREAM_ID" IS 'Primary Key for the SPT_DATA_STREAMS table';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."DATA_STREAM_CODE" IS 'The code for the given data stream';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."DATA_STREAM_NAME" IS 'The name for the given data stream';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."DATA_STREAM_DESC" IS 'The description for the given data stream';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."DATA_STREAM_PK_FIELD" IS 'The Data stream''s parent record''s primary key field (used when evaluating QC validation criteria to specify a given parent record)';
   COMMENT ON COLUMN "DVM_QC_CRITERIA_V"."ERR_TYPE_ACTIVE_YN" IS 'Flag to indicate if the given error type criteria is active';
   COMMENT ON TABLE "DVM_QC_CRITERIA_V"  IS 'QC Criteria (View)

This View returns all QC Criteria (Error Types) defined in the database and their associated QC Object, Error Severity, and Error Category.  This query is used to define all PTA Error Types when a data stream is first entered into the database';


drop synonym DAT_STRM;
drop synonym ERRS;
drop synonym ERR_TYP;
drop synonym ERR_RES;
drop synonym QC_OBJ;
drop synonym PTA_ER_TYP;
drop synonym PTA_ERR;
drop synonym PTA_ER_ASC;
drop synonym ERR_SEV;


CREATE SYNONYM QC_OBJ FOR DVM_QC_OBJECTS;
CREATE SYNONYM ERR_RES FOR DVM_ERR_RES_TYPES;
CREATE SYNONYM PTA_ER_TYP FOR DVM_PTA_ERROR_TYPES;
CREATE SYNONYM PTA_ERR FOR DVM_PTA_ERRORS;
CREATE SYNONYM ERR_TYP FOR DVM_ERROR_TYPES;
CREATE SYNONYM ERRS FOR DVM_ERRORS;
CREATE SYNONYM DAT_STRM FOR DVM_DATA_STREAMS;
CREATE SYNONYM PTA_ER_ASC FOR DVM_PTA_ERR_TYP_ASSOC;
CREATE SYNONYM ERR_SEV FOR DVM_ERR_SEVERITY;

