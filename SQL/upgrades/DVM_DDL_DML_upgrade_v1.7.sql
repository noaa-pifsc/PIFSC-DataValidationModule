--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 1.7 updates:
--------------------------------------------------------

-- increase the size of the created/modified by fields
ALTER TABLE DVM_DATA_STREAMS  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_DATA_STREAMS
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );

-- increase the size of the created/modified by fields
ALTER TABLE DVM_ISS_RES_TYPES  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_ISS_RES_TYPES
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );

-- increase the size of the created/modified by fields
ALTER TABLE DVM_ISS_SEVERITY  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_ISS_SEVERITY
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );

-- increase the size of the created/modified by fields
ALTER TABLE DVM_ISS_TYPES  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_ISS_TYPES
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );

-- increase the size of the created/modified by fields
ALTER TABLE DVM_ISSUES  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_ISSUES
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );

-- increase the size of the created/modified by fields
ALTER TABLE DVM_QC_OBJECTS  
MODIFY (CREATED_BY VARCHAR2(128 BYTE) );
ALTER TABLE DVM_QC_OBJECTS
MODIFY (LAST_MOD_BY VARCHAR2(128 BYTE) );



ALTER VIEW DVM_CRITERIA_V COMPILE;

ALTER VIEW DVM_DATA_STREAMS_V COMPILE;

ALTER VIEW DVM_PTA_ISS_TYPES_V COMPILE;
ALTER VIEW DVM_PTA_ISSUE_SUMM_V COMPILE;
ALTER VIEW DVM_PTA_ISSUES_V COMPILE;
ALTER VIEW DVM_PTA_RULE_SETS_RPT_V COMPILE;
ALTER VIEW DVM_PTA_RULE_SETS_V COMPILE;
ALTER VIEW DVM_QC_MSG_MISS_FIELDS_V COMPILE;
ALTER VIEW DVM_RULE_SETS_RPT_V COMPILE;

ALTER VIEW DVM_STD_QC_ISS_TEMPL_V COMPILE;
ALTER VIEW DVM_STD_QC_ALL_RPT_V COMPILE;



--redefine the triggers to use flexible auditing field values
CREATE OR REPLACE TRIGGER DVM_QC_OBJECTS_AUTO_BRU BEFORE
  UPDATE
    ON DVM_QC_OBJECTS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/



CREATE OR REPLACE TRIGGER DVM_DATA_STREAMS_AUTO_BRU BEFORE
  UPDATE
    ON DVM_DATA_STREAMS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/


create or replace TRIGGER DVM_QC_OBJECTS_AUTO_BRI
before insert on DVM_QC_OBJECTS
for each row
begin
  select DVM_QC_OBJECTS_SEQ.nextval into :new.QC_OBJECT_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/



create or replace TRIGGER DVM_DATA_STREAMS_AUTO_BRI
before insert on DVM_DATA_STREAMS
for each row
begin
  select DVM_DATA_STREAMS_SEQ.nextval into :new.DATA_STREAM_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/



--replace with the new triggers with the updated sequence/table names:
create or replace TRIGGER DVM_ISSUES_AUTO_BRI
before insert on DVM_ISSUES
for each row
begin
  select DVM_ISSUES_SEQ.nextval into :new.ISS_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISSUES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISSUES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/

create or replace TRIGGER DVM_ISS_RES_TYPES_AUTO_BRI
before insert on DVM_ISS_RES_TYPES
for each row
begin
  select DVM_ISS_RES_TYPES_SEQ.nextval into :new.ISS_RES_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_RES_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_RES_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/

create or replace TRIGGER DVM_ISS_SEVERITY_AUTO_BRI
before insert on DVM_ISS_SEVERITY
for each row
begin
  select DVM_ISS_SEVERITY_SEQ.nextval into :new.ISS_SEVERITY_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_SEVERITY_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_SEVERITY FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/

create or replace TRIGGER DVM_ISS_TYPES_AUTO_BRI
before insert on DVM_ISS_TYPES
for each row
begin
  select DVM_ISS_TYPES_SEQ.nextval into :new.ISS_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
end;
/
	CREATE OR REPLACE TRIGGER DVM_ISS_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON DVM_ISS_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := SUBSTR(
            COALESCE(
                SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                SYS_CONTEXT('USERENV', 'OS_USER'),
                SYS_CONTEXT('USERENV', 'SESSION_USER')
            ), 1, 128);
END;
/



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '1.7', TO_DATE('03-AUG-26', 'DD-MON-YY'), 'Increased the size of the created/modified by fields. Updated triggers to use the client identifier, OS user, and session user when available (in order of precedence)');
