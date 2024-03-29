CREATE OR REPLACE PACKAGE BODY SPTT.DVM_PKG IS
--===========================================================================
--   Application:   SPTT
--   Script Name:   dvm_pkg.pkb
--   Author:
--   Purpose:
--      Patches bugs in the data validation module package used in SPTT.
--      This is an older version of the package and should not be mixed with the new
--      and improved DVM package where these bugs have already been fixed.
--      This file is to be stored in Git under SPTT only.
--
--    Modifications:
--      Date:       Person:    Reason:
--      10-AUG-2021 psalmu     Generated script from database PIC.
--                             Added CLOSE_CURSOR commands to procedures
--                             RETRIEVE_QC_CRITERIA and DEFINE_ALL_ERROR_TYPE_ASSOC.
--===========================================================================

    --Custom record type to store standard information returned by the DVM_QC_CRITERIA_V View when the corresponding data validation criteria information is queried for the given parent table (populated in RETRIEVE_QC_CRITERIA() method procedure)
    TYPE QC_CRITERIA_INFO IS RECORD (
    OBJECT_NAME DVM_QC_CRITERIA_V.OBJECT_NAME%TYPE,
    DATA_STREAM_PK_FIELD DVM_QC_CRITERIA_V.DATA_STREAM_PK_FIELD%TYPE,
    IND_FIELD_NAME DVM_QC_CRITERIA_V.IND_FIELD_NAME%TYPE,
    ERR_TYPE_COMMENT_TEMPLATE DVM_QC_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE%TYPE,
    ERROR_TYPE_ID DVM_QC_CRITERIA_V.ERROR_TYPE_ID%TYPE,
    QC_OBJECT_ID DVM_QC_CRITERIA_V.QC_OBJECT_ID%TYPE
    );

    --numeric based array Oracle type for QC_CRITERIA_INFO record type used to store all data validation criteria for processing
    TYPE QC_CRITERIA_TABLE IS TABLE OF QC_CRITERIA_INFO INDEX BY PLS_INTEGER;

    --variable for the QC criteria Oracle type
    ALL_CRITERIA QC_CRITERIA_TABLE;


    --member variable to store the PK ID that is initially supplied to the VALIDATE_PARENT_RECORD procedure when the package is initialized and processed:
    v_PK_ID NUMBER;

    --member variable to store the DVM_PTA_ERRORS (parent error table) record for the given parent record (e.g. SPT_VESSEL_TRIPS)
    v_PTA_ERROR DVM_PTA_ERRORS%ROWTYPE;

    --member variable to hold the name of the Oracle parent table for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS.DATA_STREAM_PAR_TABLE field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure:
    v_data_stream_par_table VARCHAR(30);


    --member variable to hold the name of the Oracle parent table's primary key field for the given data validation module execution.  This is defined in the DVM_DATA_STREAMS_V.DATA_STREAM_PK_FIELD field for the corresponding data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure:
    v_data_stream_pk_field VARCHAR(30);


    --declare the associative array of integers Oracle type
    TYPE NUM_ASSOC_VARCHAR IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);


    --associative array variable used to store the relative position of each column that is returned by the QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
    assoc_field_list NUM_ASSOC_VARCHAR;


    --numeric-based array variable used to store the name of each column in its relative position returned by QC queries executed using the DBMS_SQL package methods to allow dynamic processing:
    num_field_list VARCHAR_ARRAY_NUM;

    --numeric-based array variable used to store the value of p_data_stream_codes supplied to the VALIDATE_PARENT_RECORD procedure
    v_data_stream_codes VARCHAR_ARRAY_NUM;

    --member variable used to store column-level information for dynamic queries executed using the DBMS_SQL package methods to allow dynamic processing
    desctab  DBMS_SQL.DESC_TAB;

    --declare the numeric array of DVM_ERRORS record Oracle type
    TYPE DVM_ERRORS_TABLE IS TABLE OF DVM_ERRORS%ROWTYPE INDEX BY PLS_INTEGER;

    --member variable used to store each error that is determined by the data validation module execution so it can be loaded into the database as separate DVM_ERRORS records
    v_error_rec_table DVM_ERRORS_TABLE;


    --member variable used to store the comma delimited string of the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
    v_data_stream_code_string CLOB;

    --member variable used to store the comma delimited string of the placeholders used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
    v_data_str_placeholder_string CLOB;

    --member variable used to store each placholder used when querying using the data stream code(s) supplied to the VALIDATE_PARENT_RECORD procedure
    v_data_str_placeholder_array VARCHAR_ARRAY_NUM;


    --procedure boolean variable whose value is set based off of whether the parent record (e.g. SPT_VESSEL_TRIPS) has an associated parent error record (DVM_PTA_ERRORS) to determine the behavior of the module
    v_first_validation BOOLEAN;

    --declare the associative array of integers Oracle type
    TYPE NUM_ARRAY IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;



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
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_codes IN VARCHAR_ARRAY_NUM, p_PK_ID IN NUMBER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

        --procedure boolean variable that determines if the procedure execution continues based on the results of the various procedure calls:
        v_continue BOOLEAN;

    BEGIN

        DBMS_OUTPUT.PUT_LINE('Running VALIDATE_PARENT_RECORD('||p_data_stream_codes(1)||', '||p_PK_ID||')');

        --set the member variable for usage later:
        v_data_stream_codes := p_data_stream_codes;

        --initialize the v_continue variable:
        v_continue := true;

        --set the package variables to the parameter values:
        v_PK_ID := p_PK_ID;


        --query the database to for the data stream code(s) that will be used to determine the parent record and associated data validation criteria:
        RETRIEVE_DATA_STREAM_INFO(v_proc_return_code);

        --check the return code from RETRIEVE_DATA_STREAM_INFO():
        IF (v_proc_return_code = 1) THEN

            --the data stream code(s) have been returned a single parent table, continue processing:

            --check if the parent record exists using the information from the corresponding data stream:
            RETRIEVE_PARENT_REC (v_proc_return_code);

            --check the return code from RETRIEVE_PARENT_REC():
            IF (v_proc_return_code = 1) THEN

                --the parent record exists, continue processing:


                --check if the parent record and PTA error record exist:
                RETRIEVE_PARENT_ERROR_REC (v_proc_return_code);


                --check the return code from RETRIEVE_PARENT_ERROR_REC():
                IF (v_proc_return_code = 1) THEN
                    --the parent record's PTA error record exists:
                    DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was found in the database');

                    --the parent error record already exists, use the data validation criteria that was active when the parent record was first validated:
                    v_first_validation := false;

                ELSIF (v_proc_return_code = 0) THEN
                    --the parent record's parent error record (DVM_PTA_ERRORS) does not exist:
                    DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was NOT found in the database');

                    --the parent error record does not already exist, use the data validation criteria that is currently active:
                    v_first_validation := true;

                    --insert the new parent error record:
                    DEFINE_PARENT_ERROR_REC (v_proc_return_code);


                    --check the return code from DEFINE_PARENT_ERROR_REC():
                    IF (v_proc_return_code = 1) THEN

                        --the parent error record was loaded successfully, proceed with the validation process:
                        DBMS_OUTPUT.PUT_LINE('The parent error record was loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');


                        --update the parent record to associate it with the new parent error record (DVM_PTA_ERRORS)
                        ASSOC_PARENT_ERROR_REC (v_proc_return_code);


                        --check the return code from ASSOC_PARENT_ERROR_REC():
                        IF (v_proc_return_code = 1) THEN

                            --the parent record was updated successfully:
                            DBMS_OUTPUT.PUT_LINE('The new parent error record was associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                            --insert the error type association records that are currently active:
                            DEFINE_ALL_ERROR_TYPE_ASSOC (v_proc_return_code);


                            --check the return code from DEFINE_ALL_ERROR_TYPE_ASSOC():
                            IF (v_proc_return_code = 1) THEN
                                --the association records were loaded successfully:
                                DBMS_OUTPUT.PUT_LINE('The error type association records were loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');



                            ELSE
                                --The return code from the DEFINE_ALL_ERROR_TYPE_ASSOC() procedure indicates an error associating the error types that are currently active
                                DBMS_OUTPUT.PUT_LINE('The error type association records could not be loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                                --do not continue processing the record:
                                v_continue := false;
                            END IF;

                        ELSE
                            --The return code from the ASSOC_PARENT_ERROR_REC() procedure indicates an error: the parent error record was not updated successfully
                            DBMS_OUTPUT.PUT_LINE('The new parent error record could not be associated successfully with the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                            --do not continue processing the record:
                            v_continue := false;



                        END IF;

                    ELSE

                        --The return code from the DEFINE_PARENT_ERROR_REC() procedure indicates an error: the parent error record was not loaded successfully:
                        DBMS_OUTPUT.PUT_LINE('The parent error record could not be loaded successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                        --do not continue processing the record:
                        v_continue := false;



                    END IF;

                ELSE
                    ----The return code from the RETRIEVE_PARENT_ERROR_REC() procedure indicates a database query error
                    DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the parent error record for the data stream code(s) "'||v_data_stream_code_string||'"');

                    --there was a database error, do not continue processing:
                    v_continue := false;


                END IF;

            ELSIF (v_proc_return_code = 0) THEN
                --The return code from the RETRIEVE_PARENT_REC() procedure indicates an error: the parent record does not exist
                DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" does not exist');

                --there is no parent record, do not continue processing:
                v_continue := false;

            ELSE
                --The return code from the RETRIEVE_PARENT_REC() procedure indicates a database query error
                DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                --there was a database error, do not continue processing:
                v_continue := false;

            END IF;

        ELSE
            --The return code from the RETRIEVE_DATA_STREAM_INFO() procedure indicates an error: the data stream code(s) did not resolve to a single parent table, stop processing the data validation module

            --there was more than one parent record indicated by the data stream code(s), do not continue processing:
            v_continue := false;

        END IF;


        --check if the data validation module processing should continue:
        IF v_continue THEN
            --there were no database errors or error conditions, continue processing:

            --retrieve the QC criteria for processing:
            RETRIEVE_QC_CRITERIA (v_first_validation, v_proc_return_code);

            --check the return code from RETRIEVE_QC_CRITERIA():
            IF (v_proc_return_code = 1) THEN
                --the QC criteria were loaded successfully:

                --evaluate the QC criteria:
                EVAL_QC_CRITERIA (v_proc_return_code);

                --check the return code from EVAL_QC_CRITERIA():
                IF (v_proc_return_code = 1) THEN
                    --The QC Criteria was retrieved and evaluated successfully:
                    DBMS_OUTPUT.PUT_LINE('The parent record was evaluated successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                    --the data validation criteria evaluation process was successful, commit the SQL transaction
                    COMMIT;

                ELSE
                    --The return code from the EVAL_QC_CRITERIA() procedure indicates an error processing the QC validation criteria:
                    DBMS_OUTPUT.PUT_LINE('The parent record was not evaluated successfully for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

                    --the data validation criteria evaluation process was not successful, rollback the SQL transaction:
                    ROLLBACK;

                END IF;

            ELSE
                --The return code from the RETRIEVE_QC_CRITERIA() procedure indicates an error retrieving the QC validation criteria:

                --there was no DML executed, there is no need to rollback the transaction


                --the QC criteria records were not loaded successfully:
                DBMS_OUTPUT.PUT_LINE('The QC validation criteria records were not loaded successfully');

            END IF;

        END IF;

    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --there was a PL/SQL error, rollback the SQL transaction:
            ROLLBACK;

    END VALIDATE_PARENT_RECORD;


    --procedure to generate a placeholder string based on the p_input_string_array elements that are supplied.  p_placeholder_string will contain a comma delimited string with generated placholder values, p_placeholder_array will contain the generated placeholder values, and p_delimited_string will contain a comma delimited string of the p_input_string_array elements:
    PROCEDURE GENERATE_PLACEHOLDERS (p_input_string_array IN VARCHAR_ARRAY_NUM, p_placeholder_string OUT CLOB, p_placeholder_array OUT VARCHAR_ARRAY_NUM, p_delimited_string OUT CLOB) IS

    BEGIN



        --initialize variables:

        --string of comma-delimited placeholders to be used in a dynamic query that will be bound with variables:
        p_placeholder_string := '';

        --string of comma-delimited p_input_string_array array elements for display purposes:
        p_delimited_string := '';

        --array of placeholders that will be used in a dynamic query that will be bound with variables:
        p_placeholder_array.delete;


        --loop through each element in the p_input_string_array
        FOR i IN 1 .. p_input_string_array.COUNT LOOP

            --check if this is the first array element in the processing loop:
            IF (i > 1) THEN

                --this is not the first variable, prepend a comma to generate the comma-delimited strings:
                p_delimited_string := p_delimited_string||', ';
                p_placeholder_string := p_placeholder_string||', ';
            END IF;

            --add the bind placeholder to the delimited string:
            p_placeholder_string := p_placeholder_string||':'||TO_CHAR(i);

            --add the bind placeholder name into the p_placeholder_array variable:
            p_placeholder_array(i) := ':'||TO_CHAR(i);

            --add the current p_input_string_array element to the delimited string for display purposes:
            p_delimited_string := p_delimited_string||v_data_stream_codes(i);

        END LOOP;



    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

    END GENERATE_PLACEHOLDERS;





    --procedure to retrieve the data stream information for the supplied data stream code(s).  This procedure utilizes the DBMS_SQL package because the number of data stream code(s) that are allowed as arguments are only known at runtime:
    PROCEDURE RETRIEVE_DATA_STREAM_INFO (p_proc_return_code OUT PLS_INTEGER) IS

        --numeric variable to store the dynamic cursor variable:
        curid    NUMBER;

        --return code from the dynamic query using the DBMS_SQL package:
        ignore   NUMBER;

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable to store the current result set row that is being processed:
        v_row_counter PLS_INTEGER;


    BEGIN

--        DBMS_OUTPUT.PUT_LINE('running RETRIEVE_DATA_STREAM_INFO()');

        --construct the bind variables and display variable for the data stream code(s):
        GENERATE_PLACEHOLDERS (v_data_stream_codes, v_data_str_placeholder_string, v_data_str_placeholder_array, v_data_stream_code_string);


        --construct the query to retrieve the parent table name and primary key field name from the DVM_DATA_STREAMS_V view for the data stream code(s):
        v_temp_SQL := 'SELECT DISTINCT DATA_STREAM_PAR_TABLE, DATA_STREAM_PK_FIELD FROM DVM_DATA_STREAMS_V WHERE DATA_STREAM_CODE IN ('||v_data_str_placeholder_string||')';


        -- Open SQL cursor number:
        curid := DBMS_SQL.OPEN_CURSOR;

        -- Parse SQL query:
        DBMS_SQL.PARSE(curid, v_temp_SQL, DBMS_SQL.NATIVE);

        --define the field data types and variables that will be returned by the dynamic query, the SELECT fields are known at compile time and these cannot be > 30 characters based on Oracle object naming policies so these are hard-coded:
        DBMS_SQL.DEFINE_COLUMN(curid, 1, v_data_stream_par_table, 30);
        DBMS_SQL.DEFINE_COLUMN(curid, 2, v_data_stream_pk_field, 30);

         -- Bind variables:
        FOR i IN 1 .. v_data_stream_codes.COUNT LOOP
            --loop through the data stream codes:

            --bind the given placeholder variable with the corresponding data stream code value:
            DBMS_SQL.BIND_VARIABLE(curid, v_data_str_placeholder_array(i), v_data_stream_codes(i));

        END LOOP;

        --execute the query
        ignore := DBMS_SQL.EXECUTE(curid);

        --initialize the result row counter:
        v_row_counter := 0;

        --loop through the result set:
        LOOP

            --fetch the next row if there is another on in the result set:
            IF DBMS_SQL.FETCH_ROWS(curid)>0 THEN

              -- get column values of the current row and store them in the corresponding member variables to store the parent table and parent table primary key field name respectively:
              DBMS_SQL.COLUMN_VALUE(curid, 1, v_data_stream_par_table);
              DBMS_SQL.COLUMN_VALUE(curid, 2, v_data_stream_pk_field);

              --increment the row counter variable:
              v_row_counter := v_row_counter + 1;

           ELSE

                -- No more rows to process, exit the loop:
                EXIT;
           END IF;
        END LOOP;

        --close the cursor:
        DBMS_SQL.CLOSE_CURSOR(curid);

        --check how many rows were returned by the data stream query, only one parent record should be indicated even if there are multiple data stream codes defined since only one parent record can be validated at a time with the module and if more than one parent record are returned the PK value would indicate more than one separate record:
        IF (v_row_counter = 1) THEN
            --there was one row returned by the query, continue processing the parent record:
--            DBMS_OUTPUT.PUT_LINE('The data stream code(s) "'||v_data_stream_code_string||'" were found in the database');


            --define the return code that indicates that the processing should continue because a single parent record was identified by the query:
            p_proc_return_code := 1;

        ELSIF (v_row_counter = 0) THEN
            --no rows were returned by the query, no parent record was indicated.  Stop the processing since the parent record cannot be determined:

--            DBMS_OUTPUT.PUT_LINE('The data stream code(s) "'||v_data_stream_code_string||'" were not found in the database');

            --define the return code that indicates that there was processing error due to the query results:
            p_proc_return_code := 0;

        ELSE
            --more than one row was returned by the query which indicates that multiple parent records are associated.  Stop the processing

--            DBMS_OUTPUT.PUT_LINE('The data stream code(s) "'||v_data_stream_code_string||'" identified more than one parent table, only one parent table can be validated at a time');

            --define the return code that indicates that there was processing error due to the query results:
            p_proc_return_code := -1;


        END IF;




    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was processing error due a database or PL/SQL error:
            p_proc_return_code := -1;

    END RETRIEVE_DATA_STREAM_INFO;



    --procedure to retrieve a parent record based off of the data stream and PK ID supplied:
    PROCEDURE RETRIEVE_PARENT_REC (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable that will be used to return the PK field value from the query
        v_return_ID NUMBER;

    BEGIN

--        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_REC()');


        --construct the SQL query the parent table to see if the record exists:
        v_temp_SQL := 'SELECT '||v_data_stream_par_table||'.'||v_data_stream_pk_field||' FROM '||v_data_stream_par_table||' WHERE '||v_data_stream_pk_field||' = :pkid';

        --execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD() procedure call:
        EXECUTE IMMEDIATE v_temp_SQL INTO v_return_ID USING v_PK_ID;

        --define the return code that indicates that the parent record was found in the database
        p_proc_return_code := 1;

    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN NO_DATA_FOUND THEN
            --no records were returned by the query:

            --the parent record does not exist:
            DBMS_OUTPUT.PUT_LINE('The parent record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was not found in the database');

            --set the return code to indicate the parent record was not found:
            p_proc_return_code := 0;

        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was processing error due a database or PL/SQL error:
            p_proc_return_code := -1;

    END RETRIEVE_PARENT_REC;



    --package procedure that retrieves a parent error record and returns p_proc_return_code with a code that indicates the result of the operation
    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

    BEGIN

--        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_PARENT_ERROR_REC()');


        --construct the query to check if the parent error record (DVM_PTA_ERRORS) already exists, if so then re-use that PTA_ERROR_ID otherwise query for all of the active data validation criteria:
        v_temp_SQL := 'SELECT DVM_PTA_ERRORS.* FROM '||v_data_stream_par_table||' INNER JOIN DVM_PTA_ERRORS ON ('||v_data_stream_par_table||'.PTA_ERROR_ID = DVM_PTA_ERRORS.PTA_ERROR_ID) WHERE '||v_data_stream_pk_field||' = :pkid';


        --execute the query using the PK value supplied in the VALIDATE_PARENT_RECORD() procedure call:
        EXECUTE IMMEDIATE v_temp_SQL INTO v_PTA_ERROR USING v_PK_ID;

        --update the DVM_PTA_ERRORS.LAST_EVAL_DATE value to indicate the data validation module was evaluated again:
        UPDATE_PTA_ERROR_LAST_EVAL (v_proc_return_code);

        --check if the parent error record was updated successfully:
        IF (v_proc_return_code = 1) THEN

            --the parent error record was updated successfully:

            --define the return code that indicates that the parent error record was found in the database
            p_proc_return_code := 1;


        ELSE

            --The return code from the UPDATE_PTA_ERROR_LAST_EVAL() procedure indicates a database query error
            DBMS_OUTPUT.PUT_LINE('There was a database error when updating the parent record''s parent error record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'"');

        END IF;




    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN NO_DATA_FOUND THEN
            --no records were returned by the query:

            --no parent error record exists for the given parent record:
            DBMS_OUTPUT.PUT_LINE('The parent error record for the data stream code(s) "'||v_data_stream_code_string||'" and PK: "'||v_PK_ID||'" was not found in the database');

            --set the return code to indicate the parent error record was not found:
            p_proc_return_code := 0;

        WHEN OTHERS THEN
            --catch all other errors:

            --output database error code and message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was processing error due a database or PL/SQL error:
            p_proc_return_code := -1;

    END RETRIEVE_PARENT_ERROR_REC;


    --package procedure to retrieve all of the QC criteria based on whether or not the parent record has been validated before:
    PROCEDURE RETRIEVE_QC_CRITERIA (p_first_validation IN BOOLEAN, p_proc_return_code OUT PLS_INTEGER) IS


        --return code from the dynamic query using the DBMS_SQL package:
        ignore   NUMBER;

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable to store the CLOB data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        clobvar  VARCHAR2(2000);

        --procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        namevar  VARCHAR2(2000);

        --procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        numvar   NUMBER;

        --dynamic cursor used with the dynamic SQL query for the DBMS_SQL query method:
--        TYPE curtype IS REF CURSOR;

        --dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
        curid    NUMBER;

        --number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
        colcnt   NUMBER;

        --counter variable used when populating the ALL_CRITERIA package variable
        v_all_criteria_pos NUMBER := 1;

    BEGIN

--        DBMS_OUTPUT.PUT_LINE('Running RETRIEVE_QC_CRITERIA()');


        --check if this is the first time this parent record has been validated:
        IF p_first_validation THEN

            --This is the first time the parent record has been validated, query for all the currently active QC criteria so it can be used to evaluate the parent record and all applicable child records.  Since the number of data stream codes supplied are only known at runtime the query method will use the DBMS_SQL method

            --construct the SQL query using the placeholders generated when the data stream code(s) were initially queried for:
            v_temp_SQL := 'SELECT
                    DVM_QC_CRITERIA_V.OBJECT_NAME,
                    DVM_QC_CRITERIA_V.DATA_STREAM_PK_FIELD,
                    DVM_QC_CRITERIA_V.IND_FIELD_NAME,
                    DVM_QC_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE,
                    DVM_QC_CRITERIA_V.ERROR_TYPE_ID,
                    DVM_QC_CRITERIA_V.QC_OBJECT_ID
                  FROM DVM_QC_CRITERIA_V
                  WHERE ERR_TYPE_ACTIVE_YN = ''Y''
                  AND QC_OBJ_ACTIVE_YN = ''Y''
                  AND DATA_STREAM_CODE IN ('||v_data_str_placeholder_string||')
                  ORDER BY QC_SORT_ORDER, ERROR_TYPE_ID';

            -- Open SQL cursor number:
              curid := DBMS_SQL.OPEN_CURSOR;

            -- Parse SQL query:
            DBMS_SQL.PARSE(curid, v_temp_SQL, DBMS_SQL.NATIVE);

            --retrieve all of the column descriptions for the dynamic database query:
            DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

            --loop through each column's description to define each column's data type:
            FOR i IN 1 .. colcnt LOOP

                --save the column position in the array element defined by the column name:
                assoc_field_list (desctab(i).col_name) := i;

                --save the column name in the array element defined by the column position:
                num_field_list (i) := desctab(i).col_name;

                --retrieve column metadata from query results (the select list is known at compile time so it is already known that only numeric and character data types are used).  Check the data type of the current column


--                DBMS_OUTPUT.PUT_LINE('The current col name is: ' ||desctab(i).col_name || ' col type is: '|| desctab(i).col_type);

                IF desctab(i).col_type = 2 THEN
                    --this is a numeric value:

                    --define the column data type as a NUMBER
                    DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);

                ELSIF desctab(i).col_type IN (1, 96) THEN
                    --this is a CHAR/VARCHAR data type:

                    --define the column data type as a long character string
                    DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);

                ELSIF desctab(i).col_type = 112 THEN
                    --this is a CLOB data type:

                    --define the column data type as a long character string
                    DBMS_SQL.DEFINE_COLUMN(curid, i, clobvar, 10000);

                END IF;

            END LOOP;




             -- Bind the query variables, loop through each of the data stream codes defined for the parent table:
            FOR i IN 1 .. v_data_stream_codes.COUNT LOOP
                --loop through the data stream codes:

                --bind the given placeholder variable with the corresponding data stream code value:
                DBMS_SQL.BIND_VARIABLE(curid, v_data_str_placeholder_array(i), v_data_stream_codes(i));

            END LOOP;

            --execute the query
            ignore := DBMS_SQL.EXECUTE(curid);

            --initialize the result row counter:
            v_all_criteria_pos := 1;

            --loop through each QC criteria result set row:
            LOOP

                --fetch the next row if there is another on in the result set:
                IF DBMS_SQL.FETCH_ROWS(curid)>0 THEN

                  --loop through each column in the result set row:
                  FOR i IN 1 .. colcnt LOOP


                        --retrieve column metadata from query results:
                        IF desctab(i).col_type = 2 THEN
                            --this is a numeric value:

                            --retrieve the NUMBER value into the procedure variable
                            DBMS_SQL.COLUMN_VALUE(curid, i, numvar);

                            --check the column name to assign it to the corresponding ALL_CRITERIA element record field values
                            IF desctab(i).col_name = 'ERROR_TYPE_ID' THEN
                                ALL_CRITERIA(v_all_criteria_pos).ERROR_TYPE_ID := numvar;

                            ELSIF desctab(i).col_name = 'QC_OBJECT_ID' THEN
                                ALL_CRITERIA(v_all_criteria_pos).QC_OBJECT_ID := numvar;

                            END IF;

                        ELSIF desctab(i).col_type IN (1, 96) THEN
                            --this is a CHAR/VARCHAR data type:

                            DBMS_SQL.COLUMN_VALUE(curid, i, namevar);

                            --check the column name to assign it to the corresponding ALL_CRITERIA element record field values
                            IF desctab(i).col_name = 'OBJECT_NAME' THEN
                                ALL_CRITERIA(v_all_criteria_pos).OBJECT_NAME := namevar;

                            ELSIF desctab(i).col_name = 'DATA_STREAM_PK_FIELD' THEN
                                ALL_CRITERIA(v_all_criteria_pos).DATA_STREAM_PK_FIELD := namevar;

                            ELSIF desctab(i).col_name = 'IND_FIELD_NAME' THEN
                                ALL_CRITERIA(v_all_criteria_pos).IND_FIELD_NAME := namevar;

                            END IF;
                        ELSIF desctab(i).col_type = 112 THEN

                            --store the column value
                            DBMS_SQL.COLUMN_VALUE(curid, i, clobvar);

                            --check the column name to assign it to the corresponding ALL_CRITERIA element record field values
                            IF desctab(i).col_name = 'ERR_TYPE_COMMENT_TEMPLATE' THEN
                                ALL_CRITERIA(v_all_criteria_pos).ERR_TYPE_COMMENT_TEMPLATE := clobvar;
                            END IF;

                        END IF;

                  END LOOP;

                  --increment the row counter variable:
                  v_all_criteria_pos := v_all_criteria_pos + 1;

               ELSE

                    -- No more rows to process, exit the loop:
                    EXIT;
               END IF;
            END LOOP;

		        --close the dynamic query cursor:
			      DBMS_SQL.CLOSE_CURSOR(curid);

        ELSE
            --This is not the first time the parent record has been validated, query for all of the QC error types that were active at the time the parent record was first evaluated using the data validation module

            --construct the query to return all of the QC criteria associated with the given parent error record:
            -- HWANG (11/28/2017): added 2 conditions:  DVM_PTA_ERR_TYP_ASSOC.END_DATE IS NULL, and DVM_QC_CRITERIA_V.ERR_TYPE_ACTIVE_YN = ''Y''
            v_temp_SQL := 'SELECT DVM_QC_CRITERIA_V.OBJECT_NAME,
                    DVM_QC_CRITERIA_V.DATA_STREAM_PK_FIELD,
                    DVM_QC_CRITERIA_V.IND_FIELD_NAME,
                    DVM_QC_CRITERIA_V.ERR_TYPE_COMMENT_TEMPLATE,
                    DVM_QC_CRITERIA_V.ERROR_TYPE_ID,
                    DVM_QC_CRITERIA_V.QC_OBJECT_ID

                   FROM DVM_QC_CRITERIA_V
                   INNER JOIN DVM_PTA_ERR_TYP_ASSOC
                   ON DVM_QC_CRITERIA_V.ERROR_TYPE_ID = DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID
                   WHERE
                    DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID = :ptaeid
                    AND  DVM_PTA_ERR_TYP_ASSOC.END_DATE IS NULL
                    AND DVM_QC_CRITERIA_V.ERR_TYPE_ACTIVE_YN = ''Y''
                   ORDER BY QC_SORT_ORDER, DVM_QC_CRITERIA_V.ERROR_TYPE_ID';

            --execute the query using the parent error record PK value and store the results in the ALL_CRITERIA package variable:
            EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO ALL_CRITERIA USING v_PTA_ERROR.PTA_ERROR_ID;

        END IF;

        --define the return code that indicates that the QC criteria was successfully retrieved from the database
        p_proc_return_code := 1;


    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was processing error due a database or PL/SQL error:
            p_proc_return_code := -1;

    END RETRIEVE_QC_CRITERIA;












--STOPPED HERE 12/29/2016











    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_ALL_ERROR_TYPE_ASSOC (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --numeric variable to store the dynamic cursor variable:
        curid    NUMBER;

        --return code from the dynamic query using the DBMS_SQL package:
        ignore   NUMBER;

    BEGIN

        --construct the query to insert the error type records that are currently active with the given parent record so that these same criteria can be used for all subsequent QC validations for the given data stream code(s)
        v_temp_SQL := 'INSERT INTO DVM_PTA_ERR_TYP_ASSOC (PTA_ERROR_ID, ERROR_TYPE_ID, CREATE_DATE) SELECT
               :PTA_ERROR_ID, DVM_QC_CRITERIA_V.ERROR_TYPE_ID, SYSDATE
              FROM DVM_QC_CRITERIA_V
              WHERE ERR_TYPE_ACTIVE_YN = ''Y''
              AND QC_OBJ_ACTIVE_YN = ''Y''
              AND DATA_STREAM_CODE IN ('||v_data_str_placeholder_string||')';


        -- Open SQL cursor number:
          curid := DBMS_SQL.OPEN_CURSOR;

        -- Parse SQL cursor number:
        DBMS_SQL.PARSE(curid, v_temp_SQL, DBMS_SQL.NATIVE);

        --bind the PTA_ERROR_ID variable from the package variable value
        DBMS_SQL.BIND_VARIABLE(curid, ':PTA_ERROR_ID', v_PTA_ERROR.PTA_ERROR_ID);

         -- Bind variables:
        FOR i IN 1 .. v_data_stream_codes.COUNT LOOP
            --loop through the data stream codes:

            --bind the variable value with the current data stream code:
            DBMS_SQL.BIND_VARIABLE(curid, v_data_str_placeholder_array(i), v_data_stream_codes(i));

        END LOOP;


        --execute the query
        ignore := DBMS_SQL.EXECUTE(curid);

        DBMS_SQL.CLOSE_CURSOR(curid);

        --association records were loaded successfully:
        p_proc_return_code := 1;


    EXCEPTION
        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was processing error due a database or PL/SQL error:
            p_proc_return_code := -1;

    END DEFINE_ALL_ERROR_TYPE_ASSOC;


    --define all of the error type association records to associate the parent record with all error types that are currently active:
    PROCEDURE DEFINE_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

    BEGIN

        --execute the insert query to create a new parent error record for the given parent record:
        INSERT INTO DVM_PTA_ERRORS (CREATE_DATE, LAST_EVAL_DATE) VALUES (SYSDATE, SYSDATE) RETURNING PTA_ERROR_ID, CREATE_DATE INTO v_PTA_ERROR.PTA_ERROR_ID, v_PTA_ERROR.CREATE_DATE;

        --parent error record was loaded successfully:
        p_proc_return_code := 1;


    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that the parent error record was not loaded successfully:
            p_proc_return_code := -1;

    END DEFINE_PARENT_ERROR_REC;


    --associate the parent record with the new parent error record:
    PROCEDURE ASSOC_PARENT_ERROR_REC (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

    BEGIN

--        DBMS_OUTPUT.PUT_LINE('running ASSOC_PARENT_ERROR_REC ()');

        --construct the query to update the parent table to associate it with the new parent error record::
        v_temp_SQL := 'UPDATE '||v_data_stream_par_table||' SET PTA_ERROR_ID = :pta_errid WHERE '||v_data_stream_pk_field||' = :pkid';


--        DBMS_OUTPUT.PUT_LINE('v_temp_SQL is: '||v_temp_SQL);

        --execute the query
        EXECUTE IMMEDIATE v_temp_SQL USING v_PTA_ERROR.PTA_ERROR_ID, v_PK_ID;

        --set the return code to indicate the parent record was successfully associated with the new parent error record:
        p_proc_return_code := 1;



    EXCEPTION

        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that the parent record was not associated with the parent error record successfully:
            p_proc_return_code := -1;


    END ASSOC_PARENT_ERROR_REC;


    --evaluate the QC criteria stored in ALL_CRITERIA for the given parent record:
    PROCEDURE EVAL_QC_CRITERIA (p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store the ALL_CRITERIA array element position so it can be processed using the PROCESS_QC_CRITERIA procedure, this is used during the ALL_CRITERIA main processing loop:
        v_curr_QC_begin_pos PLS_INTEGER;

        --procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
        v_continue BOOLEAN;

        --procedure variable to store the current QC_OBJ_ID value (indicates which QC object from ALL_CRITERIA is currently being processed)
        v_current_QC_OBJ_ID NUMBER;

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

        --procedure variable to store numeric ERROR_ID values for deletion (when existing error records need to be purged if the error condition no longer applies)
        v_error_ids NUM_ARRAY;

        --procedure variable to store the existing DVM_ERRORS for the given parent error record
        v_existing_error_rec_table DVM_ERRORS_TABLE;

        --procedure variable to store the position of the given DVM_ERRORS record while looping through v_existing_error_rec_table:
        v_existing_error_rec_counter PLS_INTEGER;

        --procedure variable to store the position of the given DVM_ERRORS record while looping through v_error_rec_table:
        v_error_rec_counter PLS_INTEGER;



    BEGIN

--        DBMS_OUTPUT.PUT_LINE('running EVAL_QC_CRITERIA ()');

        --initialize the tracking variable for the processing loop:
        v_current_QC_OBJ_ID := NULL;

        --initialize the v_continue variable:
        v_continue := true;

        --initialize the v_error_rec_table
        v_error_rec_table.delete;


        --loop through the QC criteria to execute each query and process each QC object separately:
        FOR indx IN 1 .. ALL_CRITERIA.COUNT
        LOOP

            --check the QC_OBJECT_ID value:
            IF (v_current_QC_OBJ_ID IS NULL) THEN
                --the QC object ID is NULL, this is the first record in the loop:

                --set the QC object's begin position to 1 since this is the first value to be processed:
                v_curr_QC_begin_pos := 1;

                --initialize the v_current_QC_OBJ_ID variable:
                v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;

            ELSIF (v_current_QC_OBJ_ID <> ALL_CRITERIA(indx).QC_OBJECT_ID) THEN
                --this is not the same QC object as the previous error type:


                --process the last QC object:
                PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, (indx - 1), v_proc_return_code);

                --check the procedure return code
                IF (v_proc_return_code = -1) THEN

                    --there was an error processing the current QC criteria:

                    DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(indx - 1).OBJECT_NAME);

                    --set the continue variable to false:
                    v_continue := false;

                    --exit the loop, no additional processing is necessary since there was an error processing the validation criteria:
                    EXIT;
                END IF;



                --initialize the current QC object:
                v_curr_QC_begin_pos := indx;

                --set the QC_OBJ_ID variable value to the current row's corresponding value:
                v_current_QC_OBJ_ID := ALL_CRITERIA(indx).QC_OBJECT_ID;


            END IF;





        END LOOP;

        --check if there have been any processing errors so far
        IF (v_continue) THEN

            --there are no processing errors, process the last QC criteria:
            PROCESS_QC_CRITERIA (v_curr_QC_begin_pos, ALL_CRITERIA.COUNT, v_proc_return_code);

            --check the procedure return code
            IF (v_proc_return_code = -1) THEN

                --there was an error processing the current QC criteria:
                DBMS_OUTPUT.PUT_LINE('There was an error when processing the current QC criteria object: '||ALL_CRITERIA(v_curr_QC_begin_pos).OBJECT_NAME);

                --set the continue variable to false:
                v_continue := false;

            END IF;



        END IF;


        --check if all of the QC criteria was processed successfully:
        IF (v_continue) THEN
            --the QC criteria was processed successfully, loop through each of the error records that were defined in the package variable by the POPULATE_ERROR_REC() procedure:

--            DBMS_OUTPUT.PUT_LINE('insert all of the DVM errors, there are '||v_error_rec_table.COUNT||' errors to load');

            --check if this is the first time the given record has been validated:
            IF NOT (v_first_validation) THEN
                --this is not the first time the given record has been validated, check the pending error records against the existing ones:

--                DBMS_OUTPUT.PUT_LINE('This is a revalidation attempt, attempt to purge resolved errors, and add the new errors');


                --determine all of the ERROR_ID values of the existing error records that should be deleted (those are the existing error records that do not match a pending error record's generated error description)

                --retrieve all existing error records:
                --HYW(1/11/2018): added a condition "AND ERR_RES_TYPE_ID IS NULL" to prevent the annotated errors been deleted
                v_temp_SQL := 'SELECT * FROM DVM_ERRORS WHERE DVM_ERRORS.PTA_ERROR_ID = :pta_error_id AND ERR_RES_TYPE_ID IS NULL';

                --store the existing error records in v_existing_error_rec_table:
                EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO v_existing_error_rec_table USING v_PTA_ERROR.PTA_ERROR_ID;

--                DBMS_OUTPUT.PUT_LINE ('There are '||v_existing_error_rec_table.COUNT||' existing error records, compare them to the pending errors to determine which should be deleted, maintained, or added');

                --loop through and compare all existing error records to the pending error records:
                v_existing_error_rec_counter := v_existing_error_rec_table.FIRST;

                --begin the loop through the existing error records:
                WHILE v_existing_error_rec_counter IS NOT NULL LOOP

--                    DBMS_OUTPUT.PUT_LINE ('Looping through the existing error record ('||v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_ID||') description: '||v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_DESCRIPTION);


                    --loop through all pending error records::
                    v_error_rec_counter := v_error_rec_table.FIRST;

                    --start the loop:
                    WHILE v_error_rec_counter IS NOT NULL LOOP

--                        DBMS_OUTPUT.PUT_LINE ('Looping through the pending error record: '||v_error_rec_table(v_error_rec_counter).ERROR_DESCRIPTION);


                        --check if the current existing error description and error_type_ID matches the pending error description:
                        IF (v_error_rec_table(v_error_rec_counter).ERROR_DESCRIPTION = v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_DESCRIPTION) AND (v_error_rec_table(v_error_rec_counter).ERROR_TYPE_ID = v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_TYPE_ID) THEN
                            --the current existing error description and error_type_ID matches the pending error description

--                            DBMS_OUTPUT.PUT_LINE ('The Pending and Existing record description and error_type_ID match, remove both the pending and existing nested table elements');


                            --remove the current pending error record from the nested table variable:
                            v_error_rec_table.DELETE(v_error_rec_counter);

                            --remove the current existing error record from the nested table variable:
                            v_existing_error_rec_table.DELETE(v_existing_error_rec_counter);

                            EXIT;
                        END IF;



                        --increment to the next pending error record:
                        v_error_rec_counter := v_error_rec_table.NEXT(v_error_rec_counter);

                    END LOOP;



                    --increment to the next existing error record:
                    v_existing_error_rec_counter := v_existing_error_rec_table.NEXT(v_existing_error_rec_counter);
                END LOOP;




                DBMS_OUTPUT.PUT_LINE('all of the comparisons have been made, delete all of the existing error records that were not matched ('||v_existing_error_rec_table.COUNT||' total)');

                --construct the currnet delete DVM_ERRORS record since it doesn't match any pending error records:
                v_temp_SQL := 'DELETE FROM DVM_ERRORS WHERE ERROR_ID = :eid';


                --loop through all of the existing error records that did not match so they can be deleted:
                v_existing_error_rec_counter := v_existing_error_rec_table.FIRST;

                --begin the loop through the existing error records:
                WHILE v_existing_error_rec_counter IS NOT NULL LOOP

                    DBMS_OUTPUT.PUT_LINE('Delete the existing error record: '||v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_ID);


                    --store the results of the query into a collection that can be used to insert the new pending error records:
                    EXECUTE IMMEDIATE v_temp_SQL USING v_existing_error_rec_table(v_existing_error_rec_counter).ERROR_ID;

                    --increment to the next existing error record:
                    v_existing_error_rec_counter := v_existing_error_rec_table.NEXT(v_existing_error_rec_counter);

                END LOOP;

            END IF;

            --construct the parameterized query to insert all of the QC criteria error records:
            v_temp_SQL := 'INSERT INTO DVM_ERRORS (PTA_ERROR_ID, ERROR_DESCRIPTION, CREATE_DATE, CREATED_BY, ERROR_TYPE_ID) VALUES (:p01, :p02, SYSDATE, :p03, :p04)';


--            DBMS_OUTPUT.PUT_LINE('insert all of the unmatched pending error records ('||v_error_rec_table.COUNT||' total)');

            --loop through each element in the v_error_rec_table package variable:
            v_error_rec_counter := v_error_rec_table.FIRST;

            --start the loop:
            WHILE v_error_rec_counter IS NOT NULL LOOP

--                DBMS_OUTPUT.PUT_LINE('insert the error with error description: "'||v_error_rec_table(v_error_rec_counter).ERROR_DESCRIPTION);

                --execute the QC criteria error record insert query using the current v_error_rec_table package variable:
                EXECUTE IMMEDIATE v_temp_SQL USING v_error_rec_table(v_error_rec_counter).PTA_ERROR_ID, v_error_rec_table(v_error_rec_counter).ERROR_DESCRIPTION, sys_context( 'userenv', 'current_schema' ), v_error_rec_table(v_error_rec_counter).ERROR_TYPE_ID;

                --increment to the next pending error record:
                v_error_rec_counter := v_error_rec_table.NEXT(v_error_rec_counter);

            END LOOP;



            --define the return code that indicates that the QC criteria was processed successfully and the corresponding error records were loaded into the database:
            p_proc_return_code := 1;

        ELSE
            --QC criteria was not processed successfully:
            p_proc_return_code := -1;

        END IF;

    EXCEPTION


        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was an error when processing the QC validation criteria:
            p_proc_return_code := -1;

    END EVAL_QC_CRITERIA;


    --validate a specific QC criteria in ALL_CRITERIA in the elements from p_begin_pos to p_end_pos
    PROCEDURE PROCESS_QC_CRITERIA (p_begin_pos IN PLS_INTEGER, p_end_pos IN PLS_INTEGER, p_proc_return_code OUT PLS_INTEGER) IS


        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;


        TYPE curtype IS REF CURSOR;
        src_cur  curtype;

        --dynamic cursor ID variable for the dynamic SQL query for the DBMS_SQL query method:
        curid    NUMBER;

        --number used to store the number of columns returned by the dynamic query for the DBMS_SQL query method:
        colcnt   NUMBER;

        --procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        namevar  VARCHAR2(2000);

        --procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        numvar   NUMBER;

        --procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        datevar  DATE;

        --procedure variable to store a given DVM_ERRORS record values that is returned by the POPULATE_ERROR_REC() procedure:
        v_temp_error_rec DVM_ERRORS%ROWTYPE;

        --procedure variable to store a boolean that indicates if the processing of QC criteria should continue:
        v_continue BOOLEAN;

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;


    BEGIN

--        DBMS_OUTPUT.PUT_LINE('running PROCESS_QC_CRITERIA ('||p_begin_pos||', '||p_end_pos||')');

        --initialize the v_continue variable:
        v_continue := true;

        --initialize the variables that contain information about the result set:
        assoc_field_list.delete;
        num_field_list.delete;
        desctab.delete;


        --construct the QC query to be executed:
        v_temp_SQL := 'SELECT * FROM '||ALL_CRITERIA(p_begin_pos).OBJECT_NAME||' WHERE '||ALL_CRITERIA(p_begin_pos).DATA_STREAM_PK_FIELD||' = :pkid';

--        DBMS_OUTPUT.PUT_LINE('the value of the QC query to be executed is: '||v_temp_SQL);

        -- Open REF CURSOR variable:
        OPEN src_cur FOR v_temp_SQL USING v_PK_ID;

        -- Switch from native dynamic SQL to DBMS_SQL package:
        curid := DBMS_SQL.TO_CURSOR_NUMBER(src_cur);

        --retrieve the result set column information:
        DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

--        DBMS_OUTPUT.PUT_LINE ('fetching column descriptions');

        -- loop through each column and defined the data type of each column dynamically:
        FOR i IN 1 .. colcnt LOOP
--          DBMS_OUTPUT.PUT_LINE ('current column name is: '||desctab(i).col_name);

          --save the column position in the array element defined by the column name (to facilitate the generating of error messages based on the error type template value):
          assoc_field_list (desctab(i).col_name) := i;

          --save the column name in the array element defined by the column position (to facilitate the generating of error messages based on the error type template value):
          num_field_list (i) := desctab(i).col_name;

          --retrieve column metadata from query results:
          IF desctab(i).col_type = 2 THEN
            --define the result set data type as NUMBER for the current column:
            DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);
--            DBMS_OUTPUT.PUT_LINE ('current numvar is: '||numvar);

          ELSIF desctab(i).col_type = 12 THEN

            --define the result set data type as DATE for the current column:
            DBMS_SQL.DEFINE_COLUMN(curid, i, datevar);
--            DBMS_OUTPUT.PUT_LINE ('current datevar is: '||datevar);

            -- statements
          ELSIF desctab(i).col_type IN (1, 96) THEN
             --define the result set data type as VARCHAR2 for the current column:
            DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 2000);
--            DBMS_OUTPUT.PUT_LINE ('current namevar is: '||namevar);

          END IF;

        END LOOP;

--        DBMS_OUTPUT.PUT_LINE ('fetching rows');


        -- Fetch rows with DBMS_SQL package to loop through the result set:
        WHILE DBMS_SQL.FETCH_ROWS(curid) > 0 LOOP

--            DBMS_OUTPUT.PUT_LINE('fetching new row from result set');

            --loop through the ERROR_TYPES for the given QC View (all of these values are CHAR/VARCHAR2 fields based on documented requirements):
            FOR j IN p_begin_pos .. p_end_pos LOOP


--              DBMS_OUTPUT.PUT_LINE ('loop #'||j||' for error types');

/*              DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME is: '||ALL_CRITERIA(j).IND_FIELD_NAME);
              DBMS_OUTPUT.PUT_LINE ('current IND_FIELD_NAME position is: '||assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME));
              DBMS_OUTPUT.PUT_LINE ('current TO_CHAR(ERR_TYPE_COMMENT_TEMPLATE) is: '||TO_CHAR(ALL_CRITERIA(j).ERR_TYPE_COMMENT_TEMPLATE));
              DBMS_OUTPUT.PUT_LINE ('current CAST(ERR_TYPE_COMMENT_TEMPLATE AS VARCHAR2) is: '||CAST(ALL_CRITERIA(j).ERR_TYPE_COMMENT_TEMPLATE AS VARCHAR2));
              DBMS_OUTPUT.PUT_LINE ('current DBMS_LOB.SUBSTR(ERR_TYPE_COMMENT_TEMPLATE, 2000, 1) is: '||DBMS_LOB.SUBSTR(ALL_CRITERIA(j).ERR_TYPE_COMMENT_TEMPLATE, 2000, 1));
*/

              --retrieve the field name for the current QC criteria IND_FIELD_NAME and retrieve the result set's corresponding column value
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(ALL_CRITERIA(j).IND_FIELD_NAME), namevar);
--              DBMS_OUTPUT.PUT_LINE ('The result set value is: '||namevar);


              --check if the current QC criteria was evaluated to true:
              IF (namevar = 'Y') THEN
                  --the current QC criteria was evaluated as an error, generate the error message:


--                  DBMS_OUTPUT.PUT_LINE ('The IND_FIELD_NAME ('||ALL_CRITERIA(j).IND_FIELD_NAME||') is ''Y'', evaluate the error description and save the error information');
                  --populate the error rec based on the current QC criteria that was evaluated to true:
                  POPULATE_ERROR_REC (curid, j, v_temp_error_rec, v_proc_return_code);

                  --add the error record information to the v_error_rec_table array variable for loading into the database later:
                  v_error_rec_table ((v_error_rec_table.COUNT + 1)) := v_temp_error_rec;

                  --re-initialize the error rec:
                  v_temp_error_rec := NULL;

                  --check the procedure return code
                  IF (v_proc_return_code = -1) THEN

                        --the POPULATE_ERROR_REC procedure failed, exit the loop:

                        --set v_continue to false:
                        v_continue := false;

                        --exit the loop
                        EXIT;

                  END IF;

              END IF;

            END LOOP;

        END LOOP;

        --close the dynamic cursor:
        DBMS_SQL.CLOSE_CURSOR(curid);

    EXCEPTION
        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was an error when processing the QC validation criteria:
            p_proc_return_code := -1;


    END PROCESS_QC_CRITERIA;


    --procedure to populate an error record with the information from the corresponding result set row:
    PROCEDURE POPULATE_ERROR_REC (curid IN NUMBER, QC_criteria_pos IN NUMBER, error_rec OUT DVM_ERRORS%ROWTYPE, p_proc_return_code OUT PLS_INTEGER) IS

        --procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
        v_proc_return_code PLS_INTEGER;

        --variable to store the generated error message based off of the ERR_TYPE_COMMENT_TEMPLATE and the runtime values returned by the QC query result set:
        temp_error_message CLOB;

        --procedure variable to store the character string data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        namevar  VARCHAR2(2000);

        --procedure variable to store the numeric data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        numvar   NUMBER;

        --procedure variable to store the date data type values returned by the dynamic SQL query for the DBMS_SQL query method:
        datevar  DATE;

        --procedure variable to store the current field name from the associative array
        temp_field_name VARCHAR2(30);


    BEGIN


--        DBMS_OUTPUT.PUT_LINE('Running POPULATE_ERROR_REC('||QC_criteria_pos||')');

        --set the temp_error_message to the given error type comment template:
        temp_error_message := ALL_CRITERIA(QC_criteria_pos).ERR_TYPE_COMMENT_TEMPLATE;

--        DBMS_OUTPUT.PUT_LINE('The value of temp_error_message before any replacements is: '||temp_error_message);

        --loop through each field and replace each placeholder value with the corresponding result set row value:

        --store the first element name in the assoc_field_list in temp_field_name to initialize the processing loop:
        temp_field_name := assoc_field_list.FIRST;  -- Get first element of array

        --loop through each assoc_field_list array element:
        WHILE temp_field_name IS NOT NULL LOOP

            --check the data type of the given result set row column:
            IF (desctab(assoc_field_list(temp_field_name)).col_type IN (1, 96)) THEN
              --this is a varchar or char field:

              --retrieve the character column data type value into the namevar variable:
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), namevar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||namevar);

              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', namevar);


            ELSIF (desctab(assoc_field_list(temp_field_name)).col_type = 2) THEN
              --this is a NUMBER field:

              --retrieve the NUMBER column data type value into the numvar variable:
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), numvar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||TO_CHAR(numvar));

              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', TO_CHAR(numvar));


            ELSIF (desctab(assoc_field_list(temp_field_name)).col_type = 12) THEN
              --this is a DATE field:


              --retrieve the DATE column data type value into the datevar variable:
              DBMS_SQL.COLUMN_VALUE(curid, assoc_field_list(temp_field_name), datevar);
--              DBMS_OUTPUT.PUT_LINE ('replace ['||temp_field_name||'] with '||TO_CHAR(datevar));

              --update the error message by replacing the current column name placeholder to the corresponding runtime value:
              temp_error_message := REPLACE(temp_error_message, '['||temp_field_name||']', TO_CHAR(datevar));

            END IF;

            -- Get next element of array before the current loop iteration ends:
            temp_field_name := assoc_field_list.NEXT(temp_field_name);
        END LOOP;



--        DBMS_OUTPUT.PUT_LINE('The value of the replaced temp_error_message is: '||temp_error_message);

        --set the attribute information for the given error message so the calling procedure can process the current QC validation error:
        error_rec.ERROR_DESCRIPTION := temp_error_message;
        error_rec.ERROR_TYPE_ID := ALL_CRITERIA(QC_criteria_pos).ERROR_TYPE_ID;
        error_rec.PTA_ERROR_ID := v_PTA_ERROR.PTA_ERROR_ID;

        EXCEPTION
        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --define the return code that indicates that there was an error when generating the current QC validation error message:
            p_proc_return_code := -1;

    END POPULATE_ERROR_REC;

    --update the parent error record to indicate that the parent record was re-evaluated:
    PROCEDURE UPDATE_PTA_ERROR_LAST_EVAL (p_proc_return_code OUT PLS_INTEGER) IS


    BEGIN

        --update the DVM_PTA_ERRORS.LAST_EVAL_DATE
        UPDATE DVM_PTA_ERRORS SET LAST_EVAL_DATE = SYSDATE WHERE PTA_ERROR_ID = v_PTA_ERROR.PTA_ERROR_ID;

        --define the return code that indicates that the parent error record was updated successfully
        p_proc_return_code := 1;


    EXCEPTION
    --catch all PL/SQL database exceptions:
    WHEN OTHERS THEN
        --catch all other errors:

        --print out error message:
        DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

        --define the return code that indicates that there was an error when updating the parent error record:
        p_proc_return_code := -1;

    END UPDATE_PTA_ERROR_LAST_EVAL;

    --function that will return a comma-delimited list of the placeholder fields that are not in the result set of the given View identified by QC_OBJECT_NAME:
    FUNCTION QC_MISSING_QUERY_FIELDS (ERR_TYPE_COMMENT_TEMPLATE DVM_ERROR_TYPES.ERR_TYPE_COMMENT_TEMPLATE%TYPE, QC_OBJECT_NAME DVM_QC_CRITERIA_V.OBJECT_NAME%TYPE) RETURN CLOB IS

        --procedure variable to store generated SQL statements that are executed in the procedure:
        v_temp_SQL CLOB;


        --variable to hold the constructed comma-delimited string of placeholder fields:
        v_temp_return CLOB;

        v_regexp_count PLS_INTEGER;

        v_assoc_fields NUM_ASSOC_VARCHAR;

        v_array_fields VARCHAR_ARRAY_NUM;

        --variable to store all of the result set fields so they can be processed:
        v_result_fields VARCHAR_ARRAY_NUM;


        --Oracle data type to store if a given placeholder was found in the result set:
        TYPE BOOL_ASSOC_VARCHAR IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;

        --variable to track if the given field name has been seen before:
        v_array_found_fields BOOL_ASSOC_VARCHAR;

        --maximum length of the placeholder should be 30 characters since it is a View column name, the brackets add two extra characters:
        v_field_name VARCHAR2(32);

        v_first_unmatched_field BOOLEAN;


    BEGIN


        --count the number of occurences of placeholders:
        v_regexp_count := REGEXP_COUNT(ERR_TYPE_COMMENT_TEMPLATE, '\[[A-Z0-9\_]{1,}\]');

        IF (v_regexp_count > 0) THEN

            --loop through each placeholder and store them in an array:
            FOR i in 1..v_regexp_count LOOP

                --find the i oocurence of the pattern in the string:
                v_field_name := regexp_substr(ERR_TYPE_COMMENT_TEMPLATE, '\[[A-Z0-9\_]{1,}\]', 1, i) ;

                --strip off the enclosing brackets from the field name:
                v_field_name := SUBSTR(v_field_name, 2, LENGTH(v_field_name) - 2) ;

                --store the field name in the v_array_fields variable:
                v_array_fields(i) := v_field_name;

                --store the field position in the v_assoc_fields variable:
                v_assoc_fields(v_field_name) := i;

                --initialize the array that the given placeholder was not found yet:
                v_array_found_fields(i) := false;

            END LOOP;



            --query for all of the fields in the result set and mark off each


            v_temp_SQL := 'SELECT
              ALL_TAB_COLUMNS.COLUMN_NAME

            FROM
            (
            SELECT ALL_OBJECTS.OWNER, ALL_OBJECTS.OBJECT_NAME, ALL_OBJECTS.OBJECT_TYPE, ALL_TAB_COMMENTS.COMMENTS OBJECT_COMMENTS

            FROM SYS.ALL_OBJECTS
            INNER JOIN SYS.ALL_TAB_COMMENTS ON ALL_OBJECTS.OWNER = ALL_TAB_COMMENTS.OWNER AND ALL_OBJECTS.OBJECT_NAME = ALL_TAB_COMMENTS.TABLE_NAME AND
            ALL_OBJECTS.OBJECT_TYPE = ALL_TAB_COMMENTS.TABLE_TYPE

            WHERE ALL_OBJECTS.OBJECT_TYPE IN (''VIEW'', ''TABLE'')
            AND ALL_OBJECTS.OWNER = sys_context(''userenv'', ''current_schema'')
            ORDER BY ALL_OBJECTS.OWNER, ALL_OBJECTS.OBJECT_NAME
            ) V0_SYS_OBJECTS

            INNER JOIN SYS.ALL_TAB_COLUMNS
            ON V0_SYS_OBJECTS.OWNER        = ALL_TAB_COLUMNS.OWNER
            AND V0_SYS_OBJECTS.OBJECT_NAME = ALL_TAB_COLUMNS.TABLE_NAME
            INNER JOIN SYS.ALL_COL_COMMENTS
            ON ALL_COL_COMMENTS.OWNER        = V0_SYS_OBJECTS.OWNER
            AND ALL_COL_COMMENTS.TABLE_NAME  = V0_SYS_OBJECTS.OBJECT_NAME
            AND ALL_COL_COMMENTS.COLUMN_NAME = ALL_TAB_COLUMNS.COLUMN_NAME
            WHERE V0_SYS_OBJECTS.OBJECT_NAME = :QC_OBJECT_NAME
            ORDER BY V0_SYS_OBJECTS.OWNER,
              V0_SYS_OBJECTS.OBJECT_NAME,
              ALL_TAB_COLUMNS.COLUMN_NAME';


            EXECUTE IMMEDIATE v_temp_SQL BULK COLLECT INTO v_result_fields USING QC_OBJECT_NAME;

            --loop through all of the result set rows:
            FOR i IN 1 .. v_result_fields.COUNT LOOP

                --loop through each of the error templates'
                FOR j in 1.. v_array_fields.COUNT LOOP

                    --check if the current placeholder field name matches the current QC object's column name:
                    IF (v_array_fields(j) = v_result_fields(i)) THEN

                        --the current field was found, update the tracking array:
                        v_array_found_fields(j) := true;

                        --exit the current loop (commented out because it would ignore any subsequent occurences of the same placeholder that match a result set field name)
                        --EXIT;

                    END IF;



                END LOOP;


            END LOOP;


            --initialize tracking field:
            v_first_unmatched_field := true;

            --initialize return variable:
            v_temp_return := '';

            --loop through the array fields:
            FOR j in 1.. v_array_fields.COUNT LOOP

                --check if the current placeholder field name matches the current QC object's column name:
                IF (NOT v_array_found_fields(j)) THEN
                    --a match was found in the result set:




                    --check if this is the first field:
                    IF v_first_unmatched_field THEN


                        v_first_unmatched_field := false;

                    ELSE
                        --this is not the first placeholder that was not matched, add the comma delimiter:
                        v_temp_return := v_temp_return||', ';


                    END IF;

                    --add the current field name to the delimited string:
                    v_temp_return := v_temp_return||v_array_fields(j);

                END IF;



            END LOOP;

            --check if all of the placeholders were found in the result set:
            IF (v_first_unmatched_field) THEN
                v_temp_return := NULL;
            END IF;




        ELSE
            --no placeholders found:
            v_temp_return := NULL;

        END IF;





        RETURN v_temp_return;


        EXCEPTION
        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
            --catch all other errors:

            --print out error message:
            DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);

            --since there was an error return NULL:
            v_temp_return := NULL;

            RETURN v_temp_return;

    END QC_MISSING_QUERY_FIELDS;


END DVM_PKG;
/
