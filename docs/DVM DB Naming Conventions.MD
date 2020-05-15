
# Data Validation Module Database Naming Conventions
## Overview:
When developing a database it is important to use consistent naming conventions so that database objects and associated fields are easily understandable.  Consistent prefixes can be used to differentiate between the core data objects being managed in the database and the data objects for the various modules installed.  Consistent object suffixes indicate what each object represents and what type of data each field contains.  Oracle requires object names and field names to have a maximum of 30 characters so abbreviations are required to keep the length within the acceptable range, consistent abbreviations improve the usability of the database.  The underscore character should be used to separate the various abbreviations for objects/fields.  The [PIFSC-ITS DB naming and coding standards](https://drive.google.com/file/d/1fcKwGN0aYNKAI1y7E7DGkh0FiIPUJase/view?usp=sharing) defines database naming standards for PIFSC.  This document defines the database naming conventions for the Data Validation Module (DVM).
## Resources:
- [DVM Documentation](./Data%20Validation%20Module%20Documentation.MD)
## Naming Conventions:
- Object Prefixes:
	- DVM - Data Validation Module
- Object Suffixes:
	- BRI: Before Row Insert (for triggers)
	- BRU: Before Row Update (for triggers)
	- FN: Function
	- HIST: Historical table
	- PKG: Package
	- SEQ: Sequence
	- V: View
- Field Suffixes:
	- CODE: Code field
	- DATE: Date field
	- DESC: Description field
	- ID: Primary/foreign keys (e.g. LOC_ID, SPECIES_ID)
	- YN: Yes/No field (Boolean)
- Abbreviations:
	- APP: Application
	- ASSOC: Associated
	- ERR: Error
	- IND: Indicator
	- MISS: Missing
	- MOD: Modified
	- MSG: Message
	- PTA: Point in Time Architecture
	- QC: Quality Control
	- RES: Resolution
	- TYP: Type
	- URL: Uniform Resource Locator
