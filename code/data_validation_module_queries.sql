
--select all errors for a given vessel trip:
select * from dvm_pta_errors_v where pta_error_id IN (SELECT pta_error_id from spt_vessel_trips where vess_trip_id = :vtid);

--retrieve all of the trips with counts of errors:
select vess_trip_id, spt_vessel_trips.pta_error_id, count(*) from spt_vessel_trips left join dvm_pta_errors_v on (spt_vessel_trips.pta_error_id = dvm_pta_errors_v.pta_error_id) group by vess_trip_id, spt_vessel_trips.pta_error_id order by vess_trip_id;






--set of queries to remove all DVM records from a given vessel trip (example parent record)

delete from dvm_errors where PTA_ERROR_ID IN (SELECT pta_error_id from spt_vessel_trips where vess_trip_id = :vtid);
UPDATE spt_Vessel_trips set pta_error_id = NULL where vess_trip_id = :vtid;
delete from dvm_pta_err_typ_assoc where PTA_ERROR_ID IN (SELECT pta_error_id from spt_vessel_trips where vess_trip_id = :vtid);
delete from dvm_pta_errors where PTA_ERROR_ID IN (SELECT pta_error_id from spt_vessel_trips where vess_trip_id = :vtid);


--sample usage for data validation module:
DECLARE
  P_DATA_STREAM_CODE SPTT_DATA_VALIDATOR.DVM_PKG.VARCHAR_ARRAY_NUM;
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
