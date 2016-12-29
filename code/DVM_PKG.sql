CREATE OR REPLACE PACKAGE DVM_PKG IS

    TYPE DATA_STREAM_TYP IS TABLE OF DVM_QC_CRITERIA_V%ROWTYPE INDEX BY PLS_INTEGER;
    ALL_CRITERIA DATA_STREAM_TYP;
    v_PK_ID NUMBER;

    v_PTA_ERROR DVM_PTA_ERRORS%ROWTYPE;
    v_data_stream DVM_DATA_STREAMS%ROWTYPE;
    
    TYPE NUM_ASSOC_VARCHAR IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);
    assoc_field_list NUM_ASSOC_VARCHAR;
  
    TYPE VARCHAR_ARRAY_NUM IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    num_field_list VARCHAR_ARRAY_NUM;
    
    desctab  DBMS_SQL.DESC_TAB;

    TYPE DVM_ERRORS_TABLE IS TABLE OF DVM_ERRORS%ROWTYPE INDEX BY PLS_INTEGER;
    v_error_rec_table DVM_ERRORS_TABLE;

    
    
    --Main package procedure that validates a given data stream (p_data_stream_code) record (uniquely identified by p_PK_ID)
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_code IN DVM_DATA_STREAMS.DATA_STREAM_CODE%TYPE, p_PK_ID IN NUMBER);
    
    --procedure to retrieve a parent record based off of the data stream and PK ID supplied:
    PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER);
    
    --package procedure that retrieves a parent error record and returns p_proc_return_code with a code that indicates the result of the operation
    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);
    
    --package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
    PROCEDURE RETRIEVE_QC_CRITERIA (p_first_validation IN BOOLEAN, p_proc_return_code OUT PLS_INTEGER);

    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_ALL_ERROR_TYPE_ASSOC (p_proc_return_code OUT PLS_INTEGER);
    
    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);

    --associate the new parent error record with the parent record:
    PROCEDURE ASSOC_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER);

    --evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
    PROCEDURE EVAL_QC_CRITERIA (p_proc_return_code OUT PLS_INTEGER);

    --validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
    PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER);
    
    --procedure to populate an error record with the information from the corresponding result set row:
    PROCEDURE POPULATE_ERROR_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, error_rec OUT DVM_ERRORS%ROWTYPE, p_proc_return_code OUT PLS_INTEGER);


END DVM_PKG;
/



--Main package procedure that validates the parent record and all child records based on the validation rules defined in the database:
CREATE OR REPLACE PACKAGE BODY DVM_PKG IS
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_code IN DVM_DATA_STREAMS.DATA_STREAM_CODE%TYPE, p_PK_ID IN NUMBER) IS
    
        v_temp_SQL CLOB;
        
        v_proc_return_code PLS_INTEGER;
        
        v_continue BOOLEAN;
        
        v_first_validation BOOLEAN;

--        TYPE QC_criteria  IS REF CURSOR;
--        v_qc_cursor    QC_criteria;

--        v_PTA_ERROR_ID DVM_PTA_ERRORS.PTA_ERROR_ID%TYPE;
--        v_PTA_ERROR_CREATE_DATE DVM_PTA_ERRORS.CREATE_DATE%TYPE;

--        ALL_CRITERIA DATA_STREAM_TYP;


    
    BEGIN

        DBMS_OUTPUT.PUT_LINE('Running VALIDATE_PARENT_RECORD('||p_data_stream_code||', '||p_PK_ID||')');


        --initialize the v_continue variable:
        v_continue := true;

        --set the package variables to the parameter values:
        v_PK_ID := p_PK_ID;

        --retrieve the data stream information from the database:
        SELECT * INTO v_data_stream FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = p_data_stream_code;
        
        DBMS_OUTPUT.PUT_LINE('The data stream code "'||p_data_stream_code||'" was found in the database');

        
        
        --check if the parent record exists using the information from the corresponding data stream:
        RETRIEVE_PARENT_REC (v_proc_return_code);
        IF (v_proc_return_code = 1) THEN
        
            --the parent record exists, continue processing:
        
        
            --check if the parent record and PTA error record exist:
            RETRIEVE_PARENT_ERROR_REC (v_proc_return_code);
    
    
            --check the return code from RETRIEVE_PARENT_ERROR_REC():
            IF (v_proc_return_code = 1) THEN
                --the parent record's PTA error record exists:
                DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'" was found in the database');
                
                --the parent error record already exists, use the data validation criteria was active when the record was first validated:
                v_first_validation := false;
                
            ELSIF (v_proc_return_code = 0) THEN
                --the parent record's PTA error record does not exist:
                DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'" was NOT found in the database');
                
                --the parent error record does not already exist, use the data validation criteria that is currently active:
                v_first_validation := true;
                 
                --insert the new parent error record:
                DEFINE_PARENT_ERROR_REC (v_proc_return_code);
    
                IF (v_proc_return_code = 1) THEN
                    --the parent error record was loaded successfully, proceed with the validation process:
                
    
                    DBMS_OUTPUT.PUT_LINE('The parent error record was loaded successfully for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
    
    
                    ASSOC_PARENT_ERROR_REC (v_proc_return_code);
                    
                    IF (v_proc_return_code = 1) THEN
                    
                        --the parent error record was updated successfully:
                        DBMS_OUTPUT.PUT_LINE('The new parent error record was associated successfully with the parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
    
    
    
                        --insert the error type association records:
                        DEFINE_ALL_ERROR_TYPE_ASSOC (v_proc_return_code);
                        
                        IF (v_proc_return_code = 1) THEN
                            --the association records were loaded successfully:
                            DBMS_OUTPUT.PUT_LINE('The error type association records were loaded successfully for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
                            
                        
                        
                        ELSE
            
                            --the association records were not loaded successfully:
                            DBMS_OUTPUT.PUT_LINE('The error type association records could not be loaded successfully for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
            
                            --do not continue processing the record:
                            v_continue := false;
                        
                        
                        END IF;
                        
                    ELSE
                        --the parent error record was not updated successfully:
                        DBMS_OUTPUT.PUT_LINE('The new parent error record could not be associated successfully with the parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
        
                        --do not continue processing the record:
                        v_continue := false;
    
                    
                    
                    END IF;
    
                ELSE
                    --the parent error record was not loaded successfully:
                    DBMS_OUTPUT.PUT_LINE('The parent error record could not be loaded successfully for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');
    
                    --do not continue processing the record:
                    v_continue := false;
                
    
                
                END IF;
    
            ELSE
            
            
                --there was an error:
                DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the data stream code "'||p_data_stream_code||'"');
    
    
                --there was a database error, do not continue processing:
                v_continue := false;
    
            
            END IF;
        
        ELSIF (v_proc_return_code = 0) THEN

            --the parent record does not exist:
            DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'" does not exist');


            --there is no parent record, do not continue processing:
            v_continue := false;
        
        ELSE
        
        
            --there was an error:
            DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the parent record for the data stream code "'||p_data_stream_code||'" and PK: "'||v_PK_ID||'"');


            --there was a database error, do not continue processing:
            v_continue := false;

        
        END IF;
        
        --check if the processing should continue:
        IF v_continue THEN
        
            --retrieve the QC criteria:
            RETRIEVE_QC_CRITERIA (v_first_validation, v_proc_return_code);
            
            --handle error codes:
            IF (v_proc_return_code = 1) THEN
                --the QC criteria records were loaded successfully:







                --evaluate the QC criteria:
                EVAL_QC_CRITERIA (v_proc_return_code);
                







                
                


            ELSE
                --the QC criteria records were not loaded successfully:
                DBMS_OUTPUT.PUT_LINE('The QC validation criteria records were not loaded successfully');

                --do not continue processing the record:
                v_continue := false;


            
            END IF;
            
            
            
            
        
        END IF;
        
        
    
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --no DVM_PTA_ERRORS record exists for the given parent record:
                DBMS_OUTPUT.PUT_LINE('The data stream code "'||p_data_stream_code||'" was not found in the database');
                
            WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
    
    END VALIDATE_PARENT_RECORD;


    --procedure to retrieve a parent record based off of the data stream and PK ID supplied:
    PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER) IS
  
        v_temp_SQL CLOB;
        
        v_return_ID NUMBER;
    
    BEGIN

        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_REC()');
    
    
    --query the parent table to see if the record exists:
        v_temp_SQL := 'SELECT '||v_data_stream.DATA_STREAM_PAR_TABLE||'.'||v_data_stream.DATA_STREAM_PK_FIELD||' FROM '||v_data_stream.DATA_STREAM_PAR_TABLE||' WHERE '||v_data_stream.DATA_STREAM_PK_FIELD||' = :pkid';
        
        EXECUTE IMMEDIATE v_temp_SQL INTO v_return_ID USING v_PK_ID;
        
        p_proc_return_code := 1;
        
        
        
    EXCEPTION
    
        WHEN NO_DATA_FOUND THEN
            --the parent record does not exist:
            DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code "'||v_data_stream.DATA_STREAM_CODE||'" and PK: "'||v_PK_ID||'" was not found in the database');

            --set the return code to indicate the parent record was not found:
            p_proc_return_code := 0;
    
        WHEN OTHERS THEN
            
            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
            
            --set the return code to indicate there was an unexpected exception during runtime:
            p_proc_return_code := -1;
    
    END RETRIEVE_PARENT_REC;


    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS
  
        v_temp_SQL CLOB;
    
    BEGIN

        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_ERROR_REC()');
    
    
    --query the parent table to check if the PTA_ERROR_ID already exists, if so then re-use that PTA_ERROR_ID otherwise query for all of the active data validation criteria:
        v_temp_SQL := 'SELECT DVM_PTA_ERRORS.* FROM '||v_data_stream.DATA_STREAM_PAR_TABLE||' INNER JOIN DVM_PTA_ERRORS ON ('||v_data_stream.DATA_STREAM_PAR_TABLE||'.PTA_ERROR_ID = DVM_PTA_ERRORS.PTA_ERROR_ID) WHERE '||v_data_stream.DATA_STREAM_PK_FIELD||' = :pkid';
        
        EXECUTE IMMEDIATE v_temp_SQL INTO v_PTA_ERROR USING v_PK_ID;
        
        --set the return code to indicate the parent table and parent error record was found:
        p_proc_return_code := 1;
        
        
    EXCEPTION
    
        WHEN NO_DATA_FOUND THEN
            --no DVM_PTA_ERRORS record exists for the given parent record:
            DBMS_OUTPUT.PUT_LINE('The parent error record for the data stream code "'||v_data_stream.DATA_STREAM_CODE||'" and PK: "'||v_PK_ID||'" was not found in the database');

            --set the return code to indicate the parent error record was not found:
            p_proc_return_code := 0;
    
        WHEN OTHERS THEN
            
            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
            
            --set the return code to indicate there was an unexpected exception during runtime:
            p_proc_return_code := -1;
    
    END RETRIEVE_PARENT_ERROR_REC;


    --procedure to retrieve all parent error records
    PROCEDURE RETRIEVE_QC_CRITERIA (p_first_validation IN BOOLEAN, p_proc_return_code OUT PLS_INTEGER) IS
  
        v_temp_SQL CLOB;
    
    BEGIN

        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_QC_CRITERIA()');
    
    
        --check if this is the first time this parent record has been validated:
        IF p_first_validation THEN
            v_temp_SQL := 'SELECT
                   DVM_QC_CRITERIA_V.*
                  FROM DVM_QC_CRITERIA_V
                  WHERE ERR_TYPE_ACTIVE_YN = ''Y''
                  AND QC_OBJ_ACTIVE_YN = ''Y''
                  AND DATA_STREAM_CODE = :DATA_STREAM_CODE
                  ORDER BY QC_SORT_ORDER, ERROR_TYPE_ID';
                  
            EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO ALL_CRITERIA USING v_data_stream.data_stream_code;
        ELSE
        
    
            --return the whole result set so it can be used to process the QC criteria:
            v_temp_SQL := 'SELECT DVM_QC_CRITERIA_V.*
                    FROM DVM_QC_CRITERIA_V
                   INNER JOIN DVM_PTA_ERR_TYP_ASSOC
                   ON DVM_QC_CRITERIA_V.ERROR_TYPE_ID = DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID
                   WHERE
                   DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID = :ptaeid               
                   AND DATA_STREAM_CODE = :DATA_STREAM_CODE
                   ORDER BY QC_SORT_ORDER, DVM_QC_CRITERIA_V.ERROR_TYPE_ID';            
                
            EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO ALL_CRITERIA USING v_PTA_ERROR.PTA_ERROR_ID, v_data_stream.data_stream_code;
        END IF;        
        
        --the query was successful:
        p_proc_return_code := 1;
        
        
    EXCEPTION
        WHEN OTHERS THEN

            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
           
            --set the return code to indicate there was an unexpected exception during runtime:
            p_proc_return_code := -1;
    END RETRIEVE_QC_CRITERIA;


    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_ALL_ERROR_TYPE_ASSOC (p_proc_return_code OUT PLS_INTEGER) IS
        v_temp_SQL CLOB;
    
    BEGIN
    
        v_temp_SQL := 'INSERT INTO DVM_PTA_ERR_TYP_ASSOC (PTA_ERROR_ID, ERROR_TYPE_ID, CREATE_DATE) SELECT
               :PTA_ERROR_ID, DVM_QC_CRITERIA_V.ERROR_TYPE_ID, SYSDATE
              FROM DVM_QC_CRITERIA_V
              WHERE ERR_TYPE_ACTIVE_YN = ''Y''
              AND QC_OBJ_ACTIVE_YN = ''Y''
              AND DATA_STREAM_CODE = :DATA_STREAM_CODE';
              
        EXECUTE IMMEDIATE v_temp_SQL USING v_PTA_ERROR.PTA_ERROR_ID, v_data_stream.data_stream_code;
        
        --association records were loaded successfully:
        p_proc_return_code := 1;
        
        
    EXCEPTION
        WHEN OTHERS THEN

            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --association records were not loaded successfully:
            p_proc_return_code := -1;
    
    END DEFINE_ALL_ERROR_TYPE_ASSOC;
    
    
    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS
        v_temp_SQL CLOB;
    
    BEGIN
    
        INSERT INTO DVM_PTA_ERRORS (CREATE_DATE, LAST_EVAL_DATE) VALUES (SYSDATE, SYSDATE) RETURNING PTA_ERROR_ID, CREATE_DATE INTO v_PTA_ERROR.PTA_ERROR_ID, v_PTA_ERROR.CREATE_DATE;

        --parent error record was loaded successfully:
        p_proc_return_code := 1;
        
        
    EXCEPTION
        WHEN OTHERS THEN

            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --parent error record was not loaded successfully:
            p_proc_return_code := -1;
    
    END DEFINE_PARENT_ERROR_REC;
    
    
    --associate the new parent error record with the parent record:
    PROCEDURE ASSOC_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS
        v_temp_SQL CLOB;
    
    
    BEGIN
    
        DBMS_OUTPUT.PUT_LINE('running ASSOC_PARENT_ERROR_REC ()');
    
        --update the parent record to associate it with the new parent error record:
        v_temp_SQL := 'UPDATE '||v_data_stream.DATA_STREAM_PAR_TABLE||' SET PTA_ERROR_ID = :pta_errid WHERE '||v_data_stream.DATA_STREAM_PK_FIELD||' = :pkid';
        
        DBMS_OUTPUT.PUT_LINE('v_temp_SQL is: '||v_temp_SQL);
        
        
        EXECUTE IMMEDIATE v_temp_SQL USING v_PTA_ERROR.PTA_ERROR_ID, v_PK_ID;
        
        --set the return code to indicate the parent table record was found:
        p_proc_return_code := 1;


    
    EXCEPTION
        WHEN OTHERS THEN

            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --The parent record was not associated with the parent error record successfully:
            p_proc_return_code := -1;
        
    
    END ASSOC_PARENT_ERROR_REC;
    

    --evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
    PROCEDURE EVAL_QC_CRITERIA (p_proc_return_code OUT PLS_INTEGER) IS 
        
        v_curr_QC_begin_pos PLS_INTEGER;
        
        v_continue BOOLEAN;
        
        v_current_QC_OBJ_ID NUMBER;
        
        v_temp_SQL CLOB;
        
        v_proc_return_code PLS_INTEGER;
    
    BEGIN
   
        DBMS_OUTPUT.PUT_LINE('running EVAL_QC_CRITERIA ()');

        --initialize the tracking variable for the processing loop:
        v_current_QC_OBJ_ID := NULL;

        --initialize the v_continue variable:
        v_continue := true;
        
        --initialize the v_error_rec_table
        v_error_rec_table.delete;


        --loop through the QC criteria to execute each query and process each QC object separately:
        FOR indx IN 1 .. ALL_CRITERIA.COUNT
        LOOP
            IF (v_current_QC_OBJ_ID IS NULL) THEN
                --the QC object ID is NULL, this is the first record in the loop:

                --set the QC object's begin position to 1 since this is the first value to be processed:
                v_curr_QC_begin_pos := 1;
                
                --initialize the v_current_QC_OBJ_ID variable:
                v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;
            
            ELSIF (v_current_QC_OBJ_ID <> ALL_CRITERIA(indx).QC_OBJECT_ID) THEN
                --this is not the same QC object as the previous error type:
                
                
                --process the previous object:
                PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, (indx - 1), v_proc_return_code);
                
                IF (v_proc_return_code = -1) THEN
                
                    --there was an error processing the current QC criteria:
                    
                    DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(indx - 1).OBJECT_NAME);
                    
                    --set the continue variable to false:
                    v_continue := false;
                    
                    --exit the loop, no additional processing is necessary since there was an error processing the validation criteria:
                    EXIT;
                END IF;
                
                
                
                --initialize the current object:
                
                v_curr_QC_begin_pos := indx;
                
                
                --set the QC_OBJ_ID variable value to the current row's corresponding value:
                v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;
                
                
            
            END IF;
            




        END LOOP;
        
        
        --process the last QC criteria:
        IF (v_continue) THEN
            
            PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, ALL_CRITERIA.COUNT, v_proc_return_code);
            
            IF (v_proc_return_code = -1) THEN
            
                --there was an error processing the current QC criteria:
                DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(v_curr_QC_begin_pos).OBJECT_NAME);
                
                --set the continue variable to false:
                v_continue := false;
                
            END IF;


        
        END IF;
        
        
        --check if all of the QC criteria was processed successfully:
        IF (v_continue) THEN
            --loop through each of the error records that were returned by the POPULATE_ERROR_REC() procedure:
            
            DBMS_OUTPUT.PUT_LINE('insert all of the DVM errors, there are '||v_error_rec_table.COUNT||' errors to load');

            v_temp_SQL := 'INSERT INTO DVM_ERRORS (PTA_ERROR_ID, ERROR_DESCRIPTION, CREATE_DATE, CREATED_BY, ERROR_TYPE_ID) VALUES (:p01, :p02, SYSDATE, :p03, :p04)';

            FOR i IN 1 .. v_error_rec_table.COUNT LOOP
                
                EXECUTE IMMEDIATE v_temp_SQL USING v_error_rec_table(i).PTA_ERROR_ID, v_error_rec_table(i).ERROR_DESCRIPTION, sys_context( 'userenv', 'current_schema' ), v_error_rec_table(i).ERROR_TYPE_ID;

            END LOOP;
            
            p_proc_return_code := 1;

        ELSE
            --QC criteria was not processed successfully:
            p_proc_return_code := -1;
            
        
        END IF;
        
    


    
    EXCEPTION
        WHEN OTHERS THEN
            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --QC criteria was not processed successfully:
            p_proc_return_code := -1;

        
    
    END EVAL_QC_CRITERIA;


    --validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
    PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER) IS
    
        v_temp_SQL CLOB;
        

        TYPE curtype IS REF CURSOR;
        src_cur  curtype;
        curid    NUMBER;
        colcnt   NUMBER;
        namevar  VARCHAR2(2000);
        numvar   NUMBER;
        datevar  DATE;
        
        v_temp_error_rec DVM_ERRORS%ROWTYPE;

        v_continue BOOLEAN;

        v_proc_return_code PLS_INTEGER;
        
    
    BEGIN

        DBMS_OUTPUT.PUT_LINE('running PROCESS_QC_CRITERIA ('||p_begin_pos||', '||p_end_pos||')');

        --initialize the v_continue variable:
        v_continue := true;

        --initialize the variables that contain information about the result set:
        assoc_field_list.delete;
        num_field_list.delete;
        desctab.delete;
       

        --construct the QC query to be executed:
        v_temp_SQL := 'SELECT * FROM '||ALL_CRITERIA(p_begin_pos).OBJECT_NAME||' WHERE '||ALL_CRITERIA(p_begin_pos).DATA_STREAM_PK_FIELD||' = :pkid';

        DBMS_OUTPUT.PUT_LINE('the value of the QC query to be executed is: '||v_temp_SQL);

        -- Open REF CURSOR variable:
        OPEN src_cur FOR v_temp_SQL USING v_PK_ID;
      
        -- Switch from native dynamic SQL to DBMS_SQL package:
        curid := DBMS_SQL.TO_CURSOR_NUMBER(src_cur);
        DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);



        DBMS_OUTPUT.PUT_LINE ('fetching column descriptions');

        -- Define columns:
        FOR i IN 1 .. colcnt LOOP
--          DBMS_OUTPUT.PUT_LINE ('current column name is: '||desctab(i).col_name);
          
          --save the column position in the array element defined by the column name:
          assoc_field_list (desctab(i).col_name) := i;
          
          --save the column name in the array element defined by the column position:
          num_field_list (i) := desctab(i).col_name;
      
          
          --retrieve column metadata from query results:
          IF desctab(i).col_type = 2 THEN
            DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);
--            DBMS_OUTPUT.PUT_LINE ('current numvar is: '||numvar);
      
          ELSIF desctab(i).col_type = 12 THEN
            DBMS_SQL.DEFINE_COLUMN(curid, i, datevar);
--            DBMS_OUTPUT.PUT_LINE ('current datevar is: '||datevar);
      
            -- statements
          ELSIF desctab(i).col_type IN (1, 96) THEN
            DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);
--            DBMS_OUTPUT.PUT_LINE ('current namevar is: '||namevar);
      
          END IF;
      
        END LOOP;
      
        DBMS_OUTPUT.PUT_LINE ('fetching rows');
              
      
        -- Fetch rows with DBMS_SQL package:
        WHILE DBMS_SQL.FETCH_ROWS(curid) > 0 LOOP
        
            DBMS_OUTPUT.PUT_LINE('fetching new row from result set');
        
      
      
            --loop through the ERROR_TYPES for the given QC View (all of these values are CHAR/VARCHAR2 fields based on documented requirements):
            FOR j IN p_begin_pos .. p_end_pos LOOP
              
              
              DBMS_OUTPUT.PUT_LINE ('loop #'||j||' for error types');
              
--              DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME is: '||ALL_CRITERIA(j).IND_FIELD_NAME);
--              DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME position is: '||assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME));
              
      
              --retrieve the field name for the current QC criteria and retrieve the result set's 
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME), namevar);
--              DBMS_OUTPUT.PUT_LINE ('The result set value is: '||namevar);
      
      
              --check if the current QC criteria was evaluated to true:
              IF (namevar = 'Y') THEN
                  --the current QC criteria was evaluated as an error, generate the error message:
                  
                  
                  DBMS_OUTPUT.PUT_LINE ('The IND_FIELD_NAME ('||ALL_CRITERIA(j).IND_FIELD_NAME||') is ''Y'', evaluate the error description and save the error information');
                  
                  POPULATE_ERROR_REC (curid, j, v_temp_error_rec, v_proc_return_code);
              
                    --add the error record information to the v_error_rec_table variable:
                  v_error_rec_table ((v_error_rec_table.COUNT + 1)) := v_temp_error_rec;
              
                  --re-initialize the error rec:
                  v_temp_error_rec := NULL;
                  
                  IF (v_proc_return_code = -1) THEN
                    
                      --the POPULATE_ERROR_REC procedure failed, exit the loop:
                    
                        v_continue := false;
                      
                      EXIT;
                  
                  END IF;
              
              
              END IF;
      
            END LOOP;

        END LOOP;
      
        DBMS_SQL.CLOSE_CURSOR(curid);
    
    EXCEPTION
        WHEN OTHERS THEN
        
            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --QC criteria was not processed successfully:
            p_proc_return_code := -1;
    
    
    END PROCESS_QC_CRITERIA;

    
    --procedure to populate an error record with the information from the corresponding result set row:
    PROCEDURE POPULATE_ERROR_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, error_rec OUT DVM_ERRORS%ROWTYPE, p_proc_return_code OUT PLS_INTEGER) IS
    
        v_proc_return_code PLS_INTEGER;
    
        temp_error_message VARCHAR2(2000);
        namevar  VARCHAR2(2000);
        numvar   NUMBER;
        datevar  DATE;
        
        temp_field_name VARCHAR2(30);
    
    
    BEGIN
        
        
        DBMS_OUTPUT.PUT_LINE('Running POPULATE_ERROR_REC('||QC_criteria_pos||')');
        
        --set the temp_error_message to the given error type comment template:
        temp_error_message := ALL_CRITERIA(QC_criteria_pos).ERR_TYPE_COMMENT_TEMPLATE;
        
        DBMS_OUTPUT.PUT_LINE('The value of temp_error_message before any replacements is: '||temp_error_message);
        
        --loop through each field and replace each placeholder value with the corresponding result set row value:
        
        temp_field_name := assoc_field_list.FIRST;  -- Get first element of array
     
        WHILE temp_field_name IS NOT NULL LOOP
            
            IF (desctab(assoc_field_list(temp_field_name)).col_type IN (1, 96)) THEN
              --this is a varchar or char field:
            
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), namevar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||namevar);
      
              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', namevar);
    
      
            ELSIF (desctab(assoc_field_list(temp_field_name)).col_type = 2) THEN
              --this is a NUMBER field:
      
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), numvar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||TO_CHAR(numvar));
    
              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', TO_CHAR(numvar));
    
      
            ELSIF (desctab(assoc_field_list(temp_field_name)).col_type = 12) THEN
              --this is a DATE field:
      
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), datevar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||TO_CHAR(datevar));
      
              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', TO_CHAR(datevar));
    
            END IF;
            
            temp_field_name := assoc_field_list.NEXT(temp_field_name);  -- Get next element of array
        END LOOP;    
    
        DBMS_OUTPUT.PUT_LINE('The value of the replaced temp_error_message is: '||temp_error_message);
    
        --set the attribute information for the given error message:
        error_rec.ERROR_DESCRIPTION := temp_error_message;
        error_rec.ERROR_TYPE_ID := ALL_CRITERIA(QC_criteria_pos).ERROR_TYPE_ID;
        error_rec.PTA_ERROR_ID := v_PTA_ERROR.PTA_ERROR_ID;
        
        EXCEPTION
            WHEN OTHERS THEN
            
                --output database error code and message:
                DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);
    
                --QC criteria was not processed successfully:
                p_proc_return_code := -1;
    
    END POPULATE_ERROR_REC;


END DVM_PKG;
/