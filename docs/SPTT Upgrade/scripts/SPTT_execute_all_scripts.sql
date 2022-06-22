cd C:\Users\Jesse.Abdul\Documents\Version Control\Git\data-validation-module\SQL

sqlplus /nolog

--deploy version 0.1 of the standalone DVM DB, Upgrade SPTT DVM to Standalone DVM
@@"../docs/SPTT Upgrade/scripts/deploy_SPTT_v1.0_to_DVM_0.1.sql"

--Upgrade Standalone DVM (version 0.1 to 1.4) and retain all existing DVM data
@@"../docs/SPTT Upgrade/scripts/upgrade_SPTT_dev_retain_data_0.1_to_1.4.sql"
