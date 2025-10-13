ALTER VIEW [dbo].[vPers_Numeros_CR2_IL] AS          
WITH CTE AS (
select
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS fila
FROM master.dbo.spt_values  with (nolock) -- Usamos una tabla del sistema para generar filas
WHERE type = 'P'
)
SELECT TOP (112)
    cte.fila,
    (cte.fila - 1)/14 + 1 as reset_count
FROM cte