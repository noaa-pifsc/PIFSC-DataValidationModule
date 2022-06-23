CREATE OR REPLACE PACKAGE SPTT.DVM_PKG IS



    --declare the numeric based array of strings, used in various package procedures
    TYPE VARCHAR_ARRAY_NUM IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;


    --Main package procedure that validates a parent record based on the given data stream code(s) defined by p_data_stream_codes, and uniquely identified by p_PK_ID.  This is the main procedure that is called by external programs to validate a given parent record.
    --Example usage for the RPL and XML data streams (defined in the DVM_DATA_STREAMS.DATA_STREAM_CODE table field):
/*
    --sample usage for data validation module:
    DECLARE
        P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
        P_PK_ID NUMBER;
    BEGIN
        -- Modify the code to initialize the variable
        P_DATA_STREAM_CODE(1) := 'RPL';
        P_DATA_STREAM_CODE(2) := 'XML';
        P_PK_ID := :vtid;
        
        DVM_PKG.VALIDATE_PARENT_RECORD(
        P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
        P_PK_ID => P_PK_ID
        );
        --rollback; 
    END;
*/    
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_PK_ID IN NUMBER);


    --procedure to generate a placeholder string based on the p_input_string_array elements that are supplied.  p_placeholder_string will contain a comma delimited string with generated placholder values, p_placeholder_array will contain the generated placeholder values, and p_delimited_string will contain a comma delimited string of the p_input_string_array elements:
    PROCEDURE GENERATE_PLACEHOLDERS (p_input_string_array IN VARCHAR_ARRAY_NUM, p_placeholder_string OUT CLOB, p_placeholder_array OUT VARCHAR_ARRAY_NUM, p_delimited_string OUT CLOB);

    --procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
    PROCEDURE RETRIEVE_DATA_STREAM_INFO (p_proc_return_code OUT PLS_INTEGER);

    --procedure to retrieve a parent record based off of the parent record and PK ID supplied:
    PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER);
    
    --package procedure that retrieves a parent error record and returns p_proc_return_code with a code that indicates the result of the operation
    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);
    
    --package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
    PROCEDURE RETRIEVE_QC_CRITERIA (p_first_validation IN BOOLEAN, p_proc_return_code OUT PLS_INTEGER);



    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_ALL_ERROR_TYPE_ASSOC (p_proc_return_code OUT PLS_INTEGER);
    
    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);

    --associate the parent record with the new parent error record:
    PROCEDURE ASSOC_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);

    --evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
    PROCEDURE EVAL_QC_CRITERIA (p_proc_return_code OUT PLS_INTEGER);

    --validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
    PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER);
    
    --procedure to populate an error record with the information from the corresponding result set row:
    PROCEDURE POPULATE_ERROR_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, error_rec OUT DVM_ERRORS%ROWTYPE, p_proc_return_code OUT PLS_INTEGER);

    --update the parent error record to indicate that the parent record was re-evaluated:
    PROCEDURE UPDATE_PTA_ERROR_LAST_EVAL (p_proc_return_code OUT PLS_INTEGER);

    --function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by QC_OBJECT_NAME:
    FUNCTION QC_MISSING_QUERY_FIELDS (ERR_TYPE_COMMENT_TEMPLATE DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE%TYPE, QC_OBJECT_NAME DVM_QC_CRITERIA_V.OBJECT_NAME%TYPE) RETURN CLOB;

END DVM_PKG;
/
