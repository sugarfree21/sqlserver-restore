# SQL Server Restore

Many dental practice management softwares will provide database backups to their clients who want raw data for reporting. This project containerizes Microsoft SQL Server, making it easy to restore those backups. 

The project assumes that the backups are encrypted. The proper .cert and .pk files will need to be placed in the main directory before building. 

The docker container runs SQL Server on port 1433 by default. 

A .env file will need to be created with the following variables:
* MSSQL_SA_PASSWORD
* DATABASE_KEY
* DECRYPT_PASSWORD