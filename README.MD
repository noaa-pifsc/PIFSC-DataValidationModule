# Data Validation Module
## Overview:
The Data Validation Module (DVM) was developed to provide a framework to validate data entered in a given Oracle database based on flexible data validation criteria that can be developed and implemented in Oracle Views by a data manager/developer without requiring application development skills.  A series of data QC Views can be developed to identify problematic values in the database and implemented in the framework to allow each validation rule to be evaluated on the given Data Stream.  

## Prerequisites:
- Oracle 11g or higher

## Installing
- Installation instructions can be found in the [DVM Documentation](./docs/Data%20Validation%20Module%20Documentation.MD#database_setup)

## Running the tests
- This process has been developed using the Centralized Cruise Database (Git URL: [git@gitlab.pifsc.gov](mailto:git@gitlab.pifsc.gov):centralized-data-tools/centralized-cruise-database.git) starting in version 0.23 (Git tag: cen_cruise_db_v0.23). Refer to the tagged versions of the CCD that match the version of the DVM (e.g. DVM_db_v1.0) for the corresponding automated test cases.
	- For more information review the Centralized Cruise Database DVM Testing Documentation.docx document in the docs/test_cases/DVM_PKG directory

## Resources
- [DVM Documentation](./docs/Data%20Validation%20Module%20Documentation.MD)

## Version Control Platform
- Git

## Authors
- Jesse Abdul - Initial work

## License
This project is licensed under the Apache-2.0 - see the [LICENSE.MD](./LICENSE.MD) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
