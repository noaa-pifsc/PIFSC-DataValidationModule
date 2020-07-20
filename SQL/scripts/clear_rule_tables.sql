--delete the DVM rules (do not include issue severity type or issue resolution type tables as they are part of the core reference tables):
delete from dvm_iss_types;
delete from dvm_data_streams;
delete from dvm_qc_objects;
