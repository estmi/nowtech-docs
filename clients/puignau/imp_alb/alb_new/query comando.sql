;WITH Lines AS (
    -- Filtramos por IdDoc en Pedidos_Cli_Lineas (no en Albaranes)
    SELECT
        pcl.IdDoc,
        pcl.IdAlbaran,
        pcl.IdPedido,
        pcl.IdLinea,
        pcl.IdArticulo,
        pcl.Descrip     AS PclDescrip,
        art.Descrip     AS ArtDescrip,
        pcc.IdCliente
    FROM dbo.Pedidos_Cli_lineas pcl WITH (NOLOCK)
    INNER JOIN dbo.Pedidos_Cli_Cabecera pcc WITH (NOLOCK) ON pcl.IdPedido = pcc.IdPedido
    INNER JOIN dbo.Articulos art WITH (NOLOCK) ON art.IdArticulo = pcl.IdArticulo
    WHERE pcl.IdDoc = {?IdDoc}
),
DistinctBundles AS (
    -- Usamos el IdDoc de las líneas y la configuración del cliente por IdPedido -> IdCliente
    SELECT DISTINCT
        L.IdDoc,
        cc.Pers_ImpBundle
    FROM Lines L
    INNER JOIN dbo.Pedidos_Cli_Cabecera pcc WITH (NOLOCK) ON L.IdPedido = pcc.IdPedido
    INNER JOIN dbo.Conf_Clientes cc WITH (NOLOCK) ON cc.IdCliente = pcc.IdCliente
),
Bundles AS (
    -- Ejecutamos la TVF por cada (IdDoc, Pers_ImpBundle) distinto
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
    FROM DistinctBundles d
    CROSS APPLY dbo.fpers_devuelveLineas_Bundle_rll(d.IdDoc, d.Pers_ImpBundle) f
),
DistinctPairs AS (
    SELECT DISTINCT L.IdCliente, L.IdArticulo
    FROM Lines L
),
Translations AS (
    SELECT dp.IdCliente, dp.IdArticulo, tr.Descrip
    FROM DistinctPairs dp
    OUTER APPLY dbo.funPers_Traduccion_Articulo(dp.IdCliente, dp.IdArticulo) tr
)
SELECT
    COALESCE(NULLIF(t.Descrip, ''), L.PclDescrip) AS DescripcionArticulo,

    CASE WHEN b.IdPedido IS NOT NULL
              AND b.Cantidad IS NOT NULL
              AND b.TipoUnidad IS NOT NULL
              AND b.total IS NOT NULL
         THEN 1 ELSE 0 END AS IsBundle,

    b.Precio, b.IdIva, b.Cantidad AS BundleCantidad, b.TipoUnidad, b.total AS BundleTotal

FROM Lines L
LEFT JOIN Translations t
    ON t.IdCliente = L.IdCliente AND t.IdArticulo = L.IdArticulo
LEFT JOIN Bundles b
    ON b.IdDoc    = L.IdDoc
   AND b.IdPedido = L.IdPedido
   AND b.IdLinea  = L.IdLinea;