CREATE OR REPLACE PACKAGE DVM_PKG IS

    TYPE DATA_STREAM_TYP IS TABLE OF DVM_QC_CRITERIA_V%ROWTYPE INDEX BY PLS_INTEGER;
    ALL_CRITERIA DATA_STREAM_TYP;
    v_PK_ID NUMBER;

    v_PTA_ERROR DVM_PTA_ERRORS%ROWTYPE;
    v_data_stream DVM_DATA_STREAMS%ROWTYPE;
    
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_code IN DVM_DATA_STREAMS.DATA_STREAM_CODE%TYPE, p_PK_ID IN NUMBER);
    
    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT NUMBER);
    
--    PROCEDURE RETRIEVE_QC_CRITERIA (v_proc_return_code OUT NUMBER);



END DVM_PKG;
/

CREATE OR REPLACE PACKAGE BODY DVM_PKG IS
    PROCEDURE VALIDATE_PARENT_RECORD (p_data_stream_code IN DVM_DATA_STREAMS.DATA_STREAM_CODE%TYPE, p_PK_ID IN NUMBER) IS
    
        temp_SQL CLOB;
        
        v_proc_return_code NUMBER;

--        TYPE QC_criteria  IS REF CURSOR;
--        v_qc_cursor    QC_criteria;

--        v_PTA_ERROR_ID DVM_PTA_ERRORS.PTA_ERROR_ID%TYPE;
--        v_PTA_ERROR_CREATE_DATE DVM_PTA_ERRORS.CREATE_DATE%TYPE;

--        ALL_CRITERIA DATA_STREAM_TYP;


    
    BEGIN

        --set the package variables to the parameter values:
        v_PK_ID := p_PK_ID;

        --retrieve the data stream information from the database:
        SELECT * INTO v_data_stream FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = p_data_stream_code;
        
        
        RETRIEVE_PARENT_ERROR_REC (v_proc_return_code);


        --check the return code from RETRIEVE_QC_CRITERIA():
        IF (v_proc_return_code = 1) THEN
            --the parent record's PTA error record exists:
            DBMS_OUTPUT.PUT_LINE('The data stream code "'||p_data_stream_code||'" was found in the database');
            
            
            --retrieve all of the related QC criteria:
            
--            RETRIEVE_QC_CRITERIA (v_PTA_ERROR., v_proc_return_code)
            
            
        
        
        ELSIF (v_proc_return_code = 0) THEN
            --the parent record's PTA error record does not exist:
            DBMS_OUTPUT.PUT_LINE('The data stream code "'||p_data_stream_code||'" was not found in the database');

        ELSE
            --there was an error:
            DBMS_OUTPUT.PUT_LINE('There was a database error when querying for the data stream code "'||p_data_stream_code||'"');



        
        END IF;
        
        
    
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --no DVM_PTA_ERRORS record exists for the given parent record:
                DBMS_OUTPUT.PUT_LINE('The data stream code "'||p_data_stream_code||'" was not found in the database');
                
            WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SUBSTR(SQLERRM, 1 , 64));
    
    END VALIDATE_PARENT_RECORD;


    PROCEDURE RETRIEVE_PARENT_ERROR_REC (p_proc_return_code OUT NUMBER) IS
  
        temp_SQL CLOB;
        v_proc_return_code NUMBER;
    
    BEGIN
    
    
    --query the parent table to check if the PTA_ERROR_ID already exists, if so then re-use that PTA_ERROR_ID otherwise query for all of the active data validation criteria:
        temp_SQL := 'SELECT DVM_PTA_ERRORS.* FROM '||v_data_stream.DATA_STREAM_PAR_TABLE||' INNER JOIN DVM_PTA_ERRORS ON ('||v_data_stream.DATA_STREAM_PAR_TABLE||'.PTA_ERROR_ID = DVM_PTA_ERRORS.PTA_ERROR_ID) WHERE '||v_data_stream.DATA_STREAM_PK_FIELD||' = :pkid';
        
        EXECUTE IMMEDIATE temp_SQL INTO v_PTA_ERROR USING v_PK_ID;
        
        --set the return code to indicate the parent table record was found:
        p_proc_return_code := 1;
        
        
        
        
        
        
--        IF SQL%ROWCOUNT > 0 THEN
        --This parent record has been validated before:    
        
        --*****************************************************************************--
        --**look into using a collection/array to supply one or more data stream codes:**
        --*****************************************************************************--
        

            --return the whole result set so it can be used to process the QC criteria:
            temp_SQL := 'SELECT DVM_QC_CRITERIA_V.*
                    FROM DVM_QC_CRITERIA_V
                   INNER JOIN DVM_PTA_ERR_TYP_ASSOC
                   ON DVM_QC_CRITERIA_V.ERROR_TYPE_ID = DVM_PTA_ERR_TYP_ASSOC.ERROR_TYPE_ID
                   WHERE
                   DVM_PTA_ERR_TYP_ASSOC.PTA_ERROR_ID = :ptaeid               
                   AND DATA_STREAM_CODE = :DATA_STREAM_CODE
                   ORDER BY QC_SORT_ORDER, DVM_QC_CRITERIA_V.ERROR_TYPE_ID';            
                
                    EXECUTE IMMEDIATE temp_SQL BULK COLLECT INTO ALL_CRITERIA USING v_PTA_ERROR.PTA_ERROR_ID, v_data_stream.data_stream_code;
            
                    --purge/replace the existing error records:


--        ELSE
           
--        END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --no DVM_PTA_ERRORS record exists for the given parent record:
            DBMS_OUTPUT.PUT_LINE('The parent table "'||v_data_stream.DATA_STREAM_PAR_TABLE||'" with the "'||v_data_stream.DATA_STREAM_PK_FIELD||'" primary key value of '||v_PK_ID||' was not found in the database');
            
            --set the return code to indicate the parent table record was not found:
            p_proc_return_code := 0;


            --This parent record has not been validated before:


            --insert the new PTA_ERROR_ID record and associate with the parent record

            INSERT INTO DVM_PTA_ERRORS (CREATE_DATE) VALUES (SYSDATE) RETURNING PTA_ERROR_ID, CREATE_DATE INTO v_PTA_ERROR.PTA_ERROR_ID, v_PTA_ERROR.CREATE_DATE;
            
        
            --return the whole result set so it can be used to process the QC criteria:
            temp_SQL := 'SELECT
                   DVM_QC_CRITERIA_V.*
                  FROM DVM_QC_CRITERIA_V
                  WHERE ERR_TYPE_ACTIVE_YN = ''Y''
                  AND QC_OBJ_ACTIVE_YN = ''Y''
                  AND DATA_STREAM_CODE = :DATA_STREAM_CODE
                  ORDER BY QC_SORT_ORDER, ERROR_TYPE_ID';
                  
            EXECUTE IMMEDIATE temp_SQL BULK COLLECT INTO ALL_CRITERIA USING v_data_stream.data_stream_code;
                  


            --save all of the active criteria with the current record:
            temp_SQL := 'INSERT INTO DVM_PTA_ERR_TYP_ASSOC (PTA_ERROR_ID, ERROR_TYPE_ID, CREATE_DATE) SELECT
                   :PTA_ERROR_ID, DVM_QC_CRITERIA_V.ERROR_TYPE_ID, SYSDATE
                  FROM DVM_QC_CRITERIA_V
                  WHERE ERR_TYPE_ACTIVE_YN = ''Y''
                  AND QC_OBJ_ACTIVE_YN = ''Y''
                  AND DATA_STREAM_CODE = :DATA_STREAM_CODE';
                  
            EXECUTE IMMEDIATE temp_SQL USING v_PTA_ERROR.PTA_ERROR_ID, v_data_stream.data_stream_code;
            
            
            
                  
                  


            
        WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SUBSTR(SQLERRM, 1 , 64));
        
        --set the return code to indicate there was an unexpected exception during runtime:
        p_proc_return_code := -1;
    
    END RETRIEVE_PARENT_ERROR_REC;


END DVM_PKG;
/