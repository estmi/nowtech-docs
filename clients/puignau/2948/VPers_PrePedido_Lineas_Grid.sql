ALTER VIEW [dbo].[VPers_PrePedido_Lineas_Grid] AS
SELECT
    V.orden,
    V.IdPrePedido, 
    IdPrePedidoLinea, 
    V.IdArticulo, 
    DescripArticle, 
    QuantVenta, 
    cantidad, 
    TipoUnidad, 
    v.Precio, 
    TipoObservacion, 
    left(V.Observacion, 250) as Observacion,
    UltPrecio, 
    UltVenta, 
    StockCalc,v.PrecioSinFeina, v.IdArticuloFeina,v.IdArticuloHijo,
    CASE 
        WHEN COLOR IS NOT NULL THEN 
            CONCAT('background-color: ', COLOR, ' !important;') 
		when V.IdGestioReserva is not null or V.IdGestioReserva <> 0
		then 'background-color: #ffe285 !important;' 
        when cantidad<>0 then'background-color: #bfffb3 !important;' 
		else ''
    END AS Color,
    CASE 
        WHEN v.Precio IS NULL OR v.Precio = 0 THEN 
            CONCAT('background-color: #fdbdbd !important;', '') 
        WHEN COLOR IS NOT NULL THEN 
            '' 
        ELSE  
            CONCAT('background-color: #98ceff !important;', '') 
    END AS ColorPrecio,
    Cursiva, 
    Tachado ,
	case when ca.P_BloquejaVenta = 1 then 'none' else 'auto' end as pointerEvents,
	CASE 
        WHEN TipoUnidad LIKE 'Far.'  THEN 
            (CASE WHEN CA.P_PecXFdo = 0 THEN 1 ELSE CA.P_PecXFdo END) * (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END)*cantidad
        WHEN TipoUnidad = 'Pec' THEN 
                        (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END) * cantidad
	else cantidad
    END AS TotalCantidad,
	coalesce(CASE 
        WHEN TipoUnidad LIKE 'Far.'  THEN 
            (CASE WHEN CA.P_PecXFdo = 0 THEN 1 ELSE CA.P_PecXFdo END) * (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END)*1
        WHEN TipoUnidad = 'Pec' THEN 
                        (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END) * 1
    END,1) AS KGPres,
	(CASE 
        WHEN TipoUnidad LIKE 'Far.'  THEN 
            (CASE WHEN CA.P_PecXFdo = 0 THEN 1 ELSE CA.P_PecXFdo END) * (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END)*cantidad
        WHEN TipoUnidad = 'Pec' THEN 
                        (CASE WHEN CA.P_KgsXPec = 0 THEN 1 ELSE CA.P_KgsXPec END) * cantidad
	else cantidad
    END)*v.Precio AS TotalPrecio, a.IdTipoUnidadPres,a.TipoCantidad
, ca.P_ComandaPresKgs as PermiteKGS,  ca.P_ComandaPresPec as PermitePEC,  ca.P_ComandaPresFdo as PermiteFDO
,Coalesce((ept.PermetT1* coalesce(LL1.Precio, hLL1.Precio)),coalesce(LL1.Precio, hLL1.Precio))				 as PrecioT1
,ept.PermetT2* coalesce(nullif(LL2.Precio,0), hLL2.Precio)										 as PrecioT2
,ept.PermetT3* coalesce(LL3.Precio, hLL3.Precio)										 as PrecioT3
,ept.PermetT4* coalesce(LL4.Precio, hLL4.Precio)										 as PrecioT4
,ept.PermetT5* coalesce(LL5.Precio, hLL5.Precio)										 as PrecioT5
,v.PreuCost, v.PrecioFeina, ca.P_BloquejaVenta
FROM [VPers_PrePedido_Lineas] V
LEFT JOIN Pers_PrePedido PP ON v.IdPrePedido = pp.IdPrePedido
LEFT JOIN Conf_Clientes cc on pp.IdCliente = cc.IdCliente
LEFT JOIN Clientes_Datos_Economicos cde on pp.IdCliente = cde.IdCliente
LEFT JOIN Articulos A ON V.IdArticulo = A.IdArticulo 
LEFT JOIN Conf_Articulos CA ON V.IdArticulo = CA.IdArticulo
left join Conf_Empresas ce on ce.IdEmpresa = pp.IdEmpresa
LEFT JOIN Listas_Precios_Cli_Art LL1 ON LL1.IdLista = ce.Pers_IdListaPrecioCliT1 and V.IdArticulo = LL1.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art LL2 ON LL2.IdLista = ce.Pers_IdListaPrecioCliT2 and V.IdArticulo = LL2.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art LL3 ON LL3.IdLista = ce.Pers_IdListaPrecioCliT3 and V.IdArticulo = LL3.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art LL4 ON LL4.IdLista = ce.Pers_IdListaPrecioCliT4 and V.IdArticulo = LL4.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art LL5 ON LL5.IdLista = ce.Pers_IdListaPrecioCliT5 and V.IdArticulo = LL5.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art hLL1 ON hLL1.IdLista = ce.Pers_IdListaPrecioCliT1 and V.IdArticuloHijo = hLL1.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art hLL2 ON hLL2.IdLista = ce.Pers_IdListaPrecioCliT2 and V.IdArticuloHijo = hLL2.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art hLL3 ON hLL3.IdLista = ce.Pers_IdListaPrecioCliT3 and V.IdArticuloHijo = hLL3.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art hLL4 ON hLL4.IdLista = ce.Pers_IdListaPrecioCliT4 and V.IdArticuloHijo = hLL4.IdArticulo
LEFT JOIN Listas_Precios_Cli_Art hLL5 ON hLL5.IdLista = ce.Pers_IdListaPrecioCliT5 and V.IdArticuloHijo = hLL5.IdArticulo
LEFT JOIN [Puignau].[dbo].[ExcepcionsPermisosTipusClient] EPT ON cc.P_TipusABC = EPT.TipusClient