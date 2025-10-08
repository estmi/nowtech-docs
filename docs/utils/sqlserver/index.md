# SQL Server Utils

## Search for text in SQL Server

<SqlViewer file="utils/search_for_text_in_query.sql"/>

## Enable xmdshell per poder crear arxius desde sqlserver

```sql
-- this turns on advanced options and is needed to configure xp_cmdshell
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
EXEC sp_configure 'xp_cmdshell', '1' 
RECONFIGURE
```
