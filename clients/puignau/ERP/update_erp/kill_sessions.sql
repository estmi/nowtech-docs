DECLARE @SessionId INT;

DECLARE cur CURSOR FOR
SELECT session_id
FROM sys.dm_exec_sessions
WHERE database_id != DB_ID('master')
  AND login_name not in ('sa', 'ahora') -- Keep this user
  AND session_id != @@SPID;           -- Don't kill yourself

OPEN cur;
FETCH NEXT FROM cur INTO @SessionId;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC ('KILL ' + @SessionId);
    FETCH NEXT FROM cur INTO @SessionId;
END

CLOSE cur;
DEALLOCATE cur;