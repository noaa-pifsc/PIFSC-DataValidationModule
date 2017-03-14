--this code snippet will run the data validation module to validate SPTT RPL data for the results of the SELECT query.  This can be used to batch process vessel trips

DECLARE
    
    --declare variable for storing data stream codes
    P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;

    --declare variable for numeric surrogate primary key
    P_PK_ID NUMBER;
BEGIN
    -- Modify the code to initialize the variable

    --define the data stream codes for the given data stream (hard-coded due to RPL data stream):
    P_DATA_STREAM_CODE(1) := 'RPL';
    P_DATA_STREAM_CODE(2) := 'XML';

    --query for VESS_TRIP_ID values that are to be batch processed (currently for processing all 2016 RPL data):
    FOR rec IN (SELECT VESS_TRIP_ID FROM SPT_VESSEL_TRIPS WHERE TO_CHAR(VESS_TRIP_DEPART_DTM, 'YYYY') IN ('2016'))

    --loop through each VESS_TRIP_ID returned by the SELECT query:    
    LOOP
    
      DBMS_OUTPUT.put_line ('running VALIDATE_PARENT_RECORD('||rec.VESS_TRIP_ID||')');    
      
      P_PK_ID := rec.VESS_TRIP_ID;
      
      --run the validator procedure on the given data stream(s) and primary key value:
      DVM_PKG.VALIDATE_PARENT_RECORD(
      P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
      P_PK_ID => P_PK_ID
      );
      
    END LOOP;

END;