--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 1.3 updates:
--------------------------------------------------------

ALTER TABLE DVM_DATA_STREAMS_HIST ADD CONSTRAINT DVM_DATA_STREAMS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_ISSUES_HIST ADD CONSTRAINT DVM_ISSUES_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_ISS_RES_TYPES_HIST ADD CONSTRAINT DVM_ISS_RES_TYPES_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_ISS_SEVERITY_HIST ADD CONSTRAINT DVM_ISS_SEVERITY_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_ISS_TYPES_HIST ADD CONSTRAINT DVM_ISS_TYPES_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_PTA_RULE_SETS_HIST ADD CONSTRAINT DVM_PTA_RULE_SETS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE DVM_QC_OBJECTS_HIST ADD CONSTRAINT DVM_QC_OBJECTS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '1.3', TO_DATE('30-NOV-20', 'DD-MON-YY'), 'Updated the data model to define primary key constraints for the history tracking tables, this will allow the Centralized Utilities Package (git@gitlab.pifsc.gov:centralized-data-tools/centralized-utilities.git) to verify data using the file based verification method.');
