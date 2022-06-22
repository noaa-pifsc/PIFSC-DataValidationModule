cd C:\Users\Jesse.Abdul\Documents\Version Control\Git\data-validation-module\SQL

sqlplus /nolog

--deploy version 0.1 of the standalone DVM DB
@@"../docs/SPTT Upgrade/scripts/deploy_DVM_v0.1.sql"

--upgrade the standalone DVM DB from version 0.1 to 1.4
@@"../docs/SPTT Upgrade/scripts/upgrade_DVM_dev_0.1_to_1.4.sql"
