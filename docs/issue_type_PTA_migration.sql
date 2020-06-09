--query for all new DVM PTA errors and their associated error_type_ids:
SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID;




--query for all old DVM PTA errors and their associated error_type_ids:
SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID;




--query for all new DVM PTA errors and their associated error_type_ids:
SELECT
count(*) total_matches,
(select count(*) from (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) total_new,
(SELECT COUNT(*) FROM (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) total_old

FROM


((SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID) NEW_PTA_ISSUE_TYPES
INNER JOIN
--query for all old DVM PTA errors and their associated error_type_ids:
(SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID) OLD_PTA_ISSUE_TYPES
ON NEW_PTA_ISSUE_TYPES.PTA_ERROR_ID = OLD_PTA_ISSUE_TYPES.PTA_ERROR_ID
AND NEW_PTA_ISSUE_TYPES.ERROR_TYPE_ID = OLD_PTA_ISSUE_TYPES.ERROR_TYPE_ID);



--this query will verify that all of the same error type associations have been maintained successfully:
SELECT
CASE WHEN (select count(*) from (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) = total_matches AND (SELECT COUNT(*) FROM (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) = total_matches THEN 'Y' ELSE 'N' END values_match_yn,
total_matches,
(select count(*) from (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) total_new,
(SELECT COUNT(*) FROM (SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID)) total_old



FROM
(SELECT
count(*) total_matches
FROM
((SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_rule_sets on DVM_PTA_ERRORS.RULE_SET_ID =  dvm_pta_rule_sets.rule_set_id
INNER JOIN DVM_ISS_TYP_ASSOC
ON DVM_ISS_TYP_ASSOC.RULE_SET_ID = dvm_pta_rule_sets.rule_set_id
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID) NEW_PTA_ISSUE_TYPES
INNER JOIN
--query for all old DVM PTA errors and their associated error_type_ids:
(SELECT DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID FROM DVM_PTA_ERRORS INNER JOIN dvm_pta_err_typ_assoc on DVM_PTA_ERRORS.PTA_ERROR_ID =  dvm_pta_err_typ_assoc.PTA_ERROR_ID
order by DVM_PTA_ERRORS.PTA_ERROR_ID, ERROR_TYPE_ID) OLD_PTA_ISSUE_TYPES
ON NEW_PTA_ISSUE_TYPES.PTA_ERROR_ID = OLD_PTA_ISSUE_TYPES.PTA_ERROR_ID
AND NEW_PTA_ISSUE_TYPES.ERROR_TYPE_ID = OLD_PTA_ISSUE_TYPES.ERROR_TYPE_ID));
