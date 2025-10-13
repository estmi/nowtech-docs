ALTER VIEW [dbo].[vPers_RowNumbers_CR_Bundle] AS
WITH DistinctDocs AS (
    -- una fila por documento + configuración de cliente (probablemente 1 por documento)
    SELECT DISTINCT
        acc.IdDoc,
        cc.Pers_ImpBundle
    FROM dbo.Pedidos_Cli_Lineas pcl
    INNER JOIN dbo.Pedidos_Cli_Cabecera pcc ON pcl.IdPedido = pcc.IdPedido
    INNER JOIN dbo.Albaranes_Cli_Cab acc    ON pcl.IdAlbaran = acc.IdAlbaran
    INNER JOIN dbo.Conf_Clientes cc         ON cc.IdCliente = pcc.IdCliente
),
Bundles AS (
    -- ejecutar la TVF solo por cada (IdDoc, Pers_ImpBundle) distinto
    SELECT
        d.IdDoc,
        f.IdPedido,
        f.IdLinea,
        f.Precio,
        f.IdIva,
        f.Cantidad,
        f.TipoUnidad,
        f.total,
        f.ImporteBruto
    FROM DistinctDocs d
    CROSS APPLY dbo.fpers_devuelveLineas_Bundle_rll(d.IdDoc, d.Pers_ImpBundle) f
)
SELECT
    pcl.IdDoc,
    pcl.IdAlbaran,
    pcl.IdLinea,
    ROW_NUMBER() OVER (PARTITION BY pcl.IdAlbaran ORDER BY pcl.IdLinea) AS RowNum,
    b.Precio,
    b.IdIva,
    b.Cantidad,
    b.TipoUnidad,
    b.total,
    b.ImporteBruto
FROM dbo.Pedidos_Cli_Lineas pcl
INNER JOIN dbo.Pedidos_Cli_Cabecera pcc ON pcl.IdPedido = pcc.IdPedido
INNER JOIN dbo.Albaranes_Cli_Cab acc    ON pcl.IdAlbaran = acc.IdAlbaran
INNER JOIN dbo.Conf_Clientes cc         ON cc.IdCliente = pcc.IdCliente
-- unir al resultado ya calculado de la TVF por documento/configuración
INNER JOIN Bundles b
    ON b.IdDoc    = acc.IdDoc
   AND b.IdPedido = pcl.IdPedido
   AND b.IdLinea  = pcl.IdLinea;