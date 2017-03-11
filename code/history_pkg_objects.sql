--------------------------------------------------------
--  File created - Thursday-March-09-2017   
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table DVM_DATA_STREAMS_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_DATA_STREAMS_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"DATA_STREAM_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_DATA_STREAMS_HIST"."DATA_STREAM_ID" IS 'Primary key column of the data table';
--------------------------------------------------------
--  DDL for Table DVM_ERRORS_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_ERRORS_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"ERROR_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_ERRORS_HIST"."ERROR_ID" IS 'Primary key column of the data table';
--------------------------------------------------------
--  DDL for Table DVM_ERROR_TYPES_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_ERROR_TYPES_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"ERROR_TYPE_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_ERROR_TYPES_HIST"."ERROR_TYPE_ID" IS 'Primary key column of the data table';
--------------------------------------------------------
--  DDL for Table DVM_ERR_RES_TYPES_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_ERR_RES_TYPES_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"ERR_RES_TYPE_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_ERR_RES_TYPES_HIST"."ERR_RES_TYPE_ID" IS 'Primary key column of the data table';
--------------------------------------------------------
--  DDL for Table DVM_ERR_SEVERITY_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_ERR_SEVERITY_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"ERR_SEVERITY_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_ERR_SEVERITY_HIST"."ERR_SEVERITY_ID" IS 'Primary key column of the data table';
--------------------------------------------------------
--  DDL for Table DVM_QC_OBJECTS_HIST
--------------------------------------------------------

  CREATE TABLE "DVM_QC_OBJECTS_HIST" 
   (	"H_SEQNUM" NUMBER(10,0), 
	"H_TYPE_OF_CHANGE" VARCHAR2(10), 
	"H_DATE_OF_CHANGE" DATE, 
	"H_USER_MAKING_CHANGE" VARCHAR2(30), 
	"H_OS_USER" VARCHAR2(30), 
	"H_CHANGED_COLUMN" VARCHAR2(30), 
	"H_OLD_DATA" VARCHAR2(4000), 
	"H_NEW_DATA" VARCHAR2(4000), 
	"QC_OBJECT_ID" NUMBER
   ) ;

   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_SEQNUM" IS 'A unique number for this record in the history table';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_TYPE_OF_CHANGE" IS 'The type of change is INSERT, UPDATE or DELETE';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_DATE_OF_CHANGE" IS 'The date and time the change was made to the data';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_USER_MAKING_CHANGE" IS 'The person (Oracle username) making the change to the record';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_OS_USER" IS 'The OS username of the person making the change to the record';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_CHANGED_COLUMN" IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_OLD_DATA" IS 'The data that has been updated';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."H_NEW_DATA" IS 'The updated column data';
   COMMENT ON COLUMN "DVM_QC_OBJECTS_HIST"."QC_OBJECT_ID" IS 'Primary key column of the data table';

--------------------------------------------------------
--  DDL for Sequence DVM_DATA_STREAMS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_DATA_STREAMS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence DVM_ERRORS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_ERRORS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence DVM_ERROR_TYPES_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_ERROR_TYPES_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence DVM_ERR_RES_TYPES_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_ERR_RES_TYPES_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence DVM_ERR_SEVERITY_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_ERR_SEVERITY_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence DVM_QC_OBJECTS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DVM_QC_OBJECTS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;


--------------------------------------------------------
--  DDL for Trigger TRG_DVM_DATA_STREAMS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_DATA_STREAMS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_DATA_STREAMS
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
ALTER TRIGGER "TRG_DVM_DATA_STREAMS_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DVM_ERRORS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_ERRORS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_ERRORS
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
      h_seqnum, ERROR_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      DVM_ERRORS_hist_seq.NEXTVAL, :old.ERROR_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
      h_seqnum, ERROR_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      DVM_ERRORS_hist_seq.NEXTVAL, :new.ERROR_ID, 
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'pta_error_id', :old.pta_error_id);
    insert_data('DELETE', 'error_type_id', :old.error_type_id);
    insert_data('DELETE', 'error_notes', :old.error_notes);
    insert_data('DELETE', 'err_res_type_id', :old.err_res_type_id);
  ELSE
    NULL;
    check_update('PTA_ERROR_ID', :old.pta_error_id, :new.pta_error_id);
    check_update('ERROR_TYPE_ID', :old.error_type_id, :new.error_type_id);
    check_update('ERROR_NOTES', :old.error_notes, :new.error_notes);
    check_update('ERR_RES_TYPE_ID', :old.err_res_type_id, :new.err_res_type_id);
  END IF;
END;
/
ALTER TRIGGER "TRG_DVM_ERRORS_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DVM_ERROR_TYPES_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_ERROR_TYPES_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_ERROR_TYPES
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
ALTER TRIGGER "TRG_DVM_ERROR_TYPES_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DVM_ERR_RES_TYPES_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_ERR_RES_TYPES_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_ERR_RES_TYPES
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
ALTER TRIGGER "TRG_DVM_ERR_RES_TYPES_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DVM_ERR_SEVERITY_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_ERR_SEVERITY_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_ERR_SEVERITY
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
ALTER TRIGGER "TRG_DVM_ERR_SEVERITY_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DVM_QC_OBJECTS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_DVM_QC_OBJECTS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON DVM_QC_OBJECTS
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
ALTER TRIGGER "TRG_DVM_QC_OBJECTS_HIST" ENABLE;
