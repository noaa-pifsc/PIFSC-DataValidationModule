set serveroutput on;

DECLARE


  CURR_MIN_DATE DATE;
  CURR_MAX_DATE DATE;

--  error_type_ids VARCHAR2(2000);
--  pta_error_ids VARCHAR2(2000);

--	TYPE DVM_ERRORS_TABLE IS TABLE OF DVM_ERRORS%ROWTYPE INDEX BY PLS_INTEGER;

--	pta_error_id_array VARCHAR_ARRAY_NUM;
--	error_type_id_array VARCHAR_ARRAY_NUM;
	V_RULE_SET_ID PLS_INTEGER;

	V_NUM_RULES PLS_INTEGER;

	V_RULE_COUNTER PLS_INTEGER := 1;

BEGIN

	SELECT COUNT(*) INTO V_NUM_RULES from
	(select MIN(CREATE_DATE) min_date, MAX(CREATE_DATE) max_date, error_type_list,
	LISTAGG(pta_error_id, ',') WITHIN GROUP (order by pta_error_id) as pta_error_list
	FROM
	(select pta_error_id,
	CREATE_DATE,
	LISTAGG(error_type_id, ',') WITHIN GROUP (order by error_type_id) as error_type_list

	FROM
	DVM_PTA_ERR_TYP_ASSOC group by pta_error_id, create_date)
	group by error_Type_list
	order by  MIN(CREATE_DATE));

	dbms_output.put_line('There are '||V_NUM_RULES||' rules defined in the DVM');



	FOR r_records IN (

  --query for all of the error rule sets:
  select MIN(CREATE_DATE) min_date, MAX(CREATE_DATE) max_date, error_type_list, data_stream_id,
	LISTAGG(pta_error_id, ',') WITHIN GROUP (order by pta_error_id) as pta_error_list
	FROM
	(select pta_error_id,
    data_stream_id,
	CREATE_DATE,
	LISTAGG(error_type_id, ',') WITHIN GROUP (order by error_type_id) as error_type_list

	FROM
    DVM_PTA_ERROR_TYPES_V

    group by pta_error_id, create_date, data_stream_id)
	group by error_Type_list, data_stream_id
	order by  MIN(CREATE_DATE))
	LOOP
		dbms_output.put_line('current min date is: '||r_records.min_date||', max date is: '||r_records.max_date);


    --insert the new rule set record and associate the error type ids:
		INSERT INTO DVM_RULE_SETS (RULE_SET_ACTIVE_YN, RULE_SET_CREATE_DATE, RULE_SET_INACTIVE_DATE, DATA_STREAM_ID) VALUES ((CASE WHEN V_RULE_COUNTER = V_NUM_RULES THEN 'Y' ELSE 'N' END), r_records.min_date, (CASE WHEN V_RULE_COUNTER = V_NUM_RULES THEN NULL ELSE r_records.max_date END), r_records.data_stream_id) RETURNING RULE_SET_ID INTO V_RULE_SET_ID;

		FOR r_error_type IN (select regexp_substr(r_records.error_type_list,'[^,]+', 1, level) error_type_id from dual
		connect by regexp_substr(r_records.error_type_list, '[^,]+', 1, level) is not null)
		LOOP


			dbms_output.put_line('The current value of error_type_id is: '||TO_CHAR(r_error_type.error_type_id));
			INSERT INTO DVM_ISS_TYP_ASSOC (RULE_SET_ID, ERROR_TYPE_ID) VALUES (V_RULE_SET_ID, TO_NUMBER(r_error_type.error_type_id));
		END LOOP;


		FOR r_pta_error IN (select regexp_substr(r_records.pta_error_list,'[^,]+', 1, level) pta_error_id from dual
		connect by regexp_substr(r_records.pta_error_list, '[^,]+', 1, level) is not null)
		LOOP

			dbms_output.put_line('The current value of pta_error_id ('||TO_CHAR(r_pta_error.pta_error_id)||'), update it for the current rule set: '||TO_CHAR(V_RULE_SET_ID));

			INSERT INTO DVM_PTA_RULE_SETS (RULE_SET_ID, PTA_ERROR_ID) VALUES (V_RULE_SET_ID, TO_NUMBER(r_pta_error.pta_error_id));

		END LOOP;



		--increment the counter:
		V_RULE_COUNTER := V_RULE_COUNTER + 1;

	END LOOP;














  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE ('There were no PTA error rules found in the DB, there are no traces of the DVM being executed yet');

      WHEN OTHERS THEN

	DBMS_OUTPUT.PUT_LINE('The error code is ' || SQLCODE || '- ' || SQLERRM);




END;
