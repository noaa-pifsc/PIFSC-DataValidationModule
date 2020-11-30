# Version 0.5 Upgrade Instructions

## Overview:
The version 0.5 database upgrade made significant changes to the data model and this requires a special data migration process to ensure data integrity if the given database instance has utilized the Data Validation Module to evaluate QC criteria.  If the data rules are consistent over time then a PL/SQL script can be used to migrate the data into the new data model, otherwise a manual migration process must be conducted.

## Resources:
- [DVM Documentation](./Data%20Validation%20Module%20Documentation.md)

## Procedure:
- <mark>Determine if the validation rules from the old data model can be migrated using the automated script</mark>
- Execute [part 1](../SQL/upgrades/DVM_DDL_DML_upgrade_v0.5_pt1.sql) of the version 0.5 upgrade
- Migrate the DVM data to the new data model using the [migration script](../SQL/scripts/migrate_error_type_assoc_values.sql)
  - Verify the DVM data in the new data model using the [verification script](../SQL/scripts/compare_validation_rules.sql), if the return value is "Y" then the data was migrated successfully
- Execute [part 2](../SQL/upgrades/DVM_DDL_DML_upgrade_v0.5_pt2.sql) of the version 0.5 upgrade
