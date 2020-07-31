
# Data Validation Module
## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in a given Oracle database based on flexible data validation criteria that can be developed and implemented in Oracle Views by a data manager/developer without requiring application development skills.  A series of data QC Views can be developed to identify problematic values in the database and implemented in the framework to allow each validation rule to be evaluated on the given Data Stream.  
## Prerequisites:
- Oracle 11g or higher

## Installing
- Installation instructions can be found in the [DVM Documentation](./docs/Data%20Validation%20Module%20Documentation.MD#database_setup)

## <mark>Running the tests
- Refer to the DVM Testing Documentation (docs/test cases/DVM_PKG/Centralized Cruise Database DVM Testing Documentation.docx) in the Centralized Cruise Database Git repository (git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git).  The git tag for the current DVM version (e.g. DVM_db_v1.0) is also defined on the version of the CCD repository that contains the corresponding DVM test cases.

## Resources
- [DVM Documentation](./docs/Data%20Validation%20Module%20Documentation.MD)

## Versioning
We use Git for versioning

## Authors
- Jesse Abdul - Initial work

## License
This project is licensed under the Apache-2.0 - see the [LICENSE.MD](./LICENSE.MD) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and
Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is
provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of
Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed
by all applicable Federal law. Any reference to specific commercial products, processes, or services by service
mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or
favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a
DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by
DOC or the United States Government.
