ALTER VIEW [dbo].[Pers_albaranes_lineas_min4] AS
WITH PedidosPorAlbaran AS (
    -- Precalcula el número de filas por albarán (uso COUNT + fórmula)
    SELECT
        pcl.IdAlbaran,
        COUNT(1) AS LineCount,
        (CASE WHEN COUNT(1) = 0 THEN 14 ELSE ((COUNT(1) / 14) * 14 + 14) END) AS MaxFila
    FROM Pedidos_Cli_Lineas pcl WITH (NOLOCK)
    GROUP BY pcl.IdAlbaran
),
Albs AS (
    -- Unir la cabecera con el conteo precomputado
    SELECT
        ac.IdAlbaran,
        ISNULL(p.LineCount, 0) AS LineCount,
        ISNULL(p.MaxFila, 14) AS MaxFila
    FROM Albaranes_Cli_Cab ac WITH (NOLOCK)
    LEFT JOIN PedidosPorAlbaran p ON p.IdAlbaran = ac.IdAlbaran
)
SELECT
    CAST(a.IdAlbaran AS varchar(20)) + s.Sufijo AS Ord,
    rn.IdLinea,
    rn.IdDoc,
    n.fila,
    a.IdAlbaran,
    n.reset_count,
    rn.precio,
    rn.IdIva,
    rn.Cantidad,
    rn.TipoUnidad,
    rn.total,
    rn.Lote
FROM Albs a
CROSS JOIN (VALUES ('A'), ('B')) AS s(Sufijo)
-- Unir solo las filas de la tabla de números necesarias por albarán
JOIN vPers_Numeros_CR2_IL n WITH (NOLOCK)
    ON n.fila <= a.MaxFila
-- Traer las líneas (si existen) para ese IdAlbaran / RowNum
LEFT JOIN vPers_RowNumbers_CR_Bundle_RLL rn WITH (NOLOCK)
    ON rn.IdAlbaran = a.IdAlbaran
    AND rn.RowNum = n.fila;