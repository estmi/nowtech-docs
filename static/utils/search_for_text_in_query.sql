SELECT 
    OBJECT_NAME(o.object_id) AS NombreObjeto,
    type_desc AS TipoObjeto,
    definition AS Codigo
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
WHERE upper(m.definition) LIKE '%PERS_PEDIDOS_CLI_LINEAS_LOG%';