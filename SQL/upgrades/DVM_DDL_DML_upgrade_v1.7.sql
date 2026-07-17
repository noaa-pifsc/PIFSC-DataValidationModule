--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 1.7 updates:
--------------------------------------------------------


-- drop the legacy history table triggers
DROP TRIGGER TRG_DVM_DATA_STREAMS_HIST; 
DROP TRIGGER TRG_DVM_ISS_RES_TYPES_HIST; 
DROP TRIGGER TRG_DVM_ISS_SEVERITY_HIST; 
DROP TRIGGER TRG_DVM_ISS_TYPES_HIST; 
DROP TRIGGER TRG_DVM_ISSUES_HIST; 
DROP TRIGGER TRG_DVM_PTA_RULE_SETS_HIST; 
DROP TRIGGER TRG_DVM_QC_OBJECTS_HIST;


-- drop the legacy history tables
DROP TABLE DVM_DATA_STREAMS_HIST;
DROP TABLE DVM_ISS_RES_TYPES_HIST;
DROP TABLE DVM_ISS_SEVERITY_HIST;
DROP TABLE DVM_ISS_TYPES_HIST;
DROP TABLE DVM_ISSUES_HIST;
DROP TABLE DVM_PTA_RULE_SETS_HIST;
DROP TABLE DVM_QC_OBJECTS_HIST;


-- add the authorization user tables to the FDA
ALTER TABLE DVM_DATA_STREAMS FLASHBACK ARCHIVE; 
ALTER TABLE DVM_ISS_RES_TYPES FLASHBACK ARCHIVE; 
ALTER TABLE DVM_ISS_SEVERITY FLASHBACK ARCHIVE; 
ALTER TABLE DVM_ISS_TYPES FLASHBACK ARCHIVE; 
ALTER TABLE DVM_ISSUES FLASHBACK ARCHIVE; 
ALTER TABLE DVM_PTA_RULE_SETS FLASHBACK ARCHIVE; 
ALTER TABLE DVM_QC_OBJECTS FLASHBACK ARCHIVE;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '1.7', TO_DATE('17-JUL-26', 'DD-MON-YY'), 'Removed the data history triggers and tables and enabled the Oracle flashback data archive feature for them instead');
