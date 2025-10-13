ALTER VIEW [dbo].[vPers_Numeros_CR2_IL] AS          
SELECT TOP (      
    CEILING((SELECT MAX(RowNum) FROM dbo.vPers_RowNumbers_CR_Bundle_RLL  with (nolock)) / 14) * 14 + 14
    /*112*/
)      
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) * 1 AS fila        
FROM master.dbo.spt_values  with (nolock) -- Usamos una tabla del sistema para generar filas      
WHERE type = 'P'