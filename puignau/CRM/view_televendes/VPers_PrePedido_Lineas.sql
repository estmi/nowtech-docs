ALTER VIEW [dbo].[VPers_PrePedido_Lineas] AS
SELECT 
    case when ppl.IdTipoOferta IS NULL then ppfo.Orden + 100 else coalesce(ppfo.Orden,9999) end AS orden, --PRIMERO LAS OFERTAS
    IdPrePedido, IdPrePedidoLinea, ppl.IdArticulo, DescripArticle, 
    COALESCE(QuantVenta, 0) AS QuantVenta, cantidad, TipoUnidad, coalesce(PrecioFeina,0)+Precio as Precio, Precio as PrecioSinFeina,
    TipoObservacion, Observacion, COALESCE(UltPrecio, 0) AS UltPrecio,
    CONVERT(VARCHAR(50), UltVenta, 103) AS UltVenta,
    COALESCE(CONVERT(VARCHAR(20), StockCalc), '') AS StockCalc, 
    PPT.Color AS COLOR, ppfo.CSSCursiva AS Cursiva,
	
	 CASE 
        WHEN (ppfo.StockTachado = 1 and (ppl.StockCalc IS NULL OR ppl.StockCalc < 0.1)) or (va.P_BloquejaVenta is not null and va.P_BloquejaVenta = 1) THEN ppfo.CSSTachado
        ELSE 'none'
    END AS Tachado , ppl.PreuCost, ppl.PrecioFeina, ppl.IdArticuloFeina, ppl.IdArticuloHijo, ppl.IdGestioReserva
FROM Pers_PrePedido_Lineas PPL
LEFT JOIN [dbo].[Pers_PrePedido_TipoPromocion] PPT 
    ON PPT.IdTipoPromocion = PPL.IdTipoOferta
LEFT JOIN vPers_Articles_Simplificado va 
    ON ppl.IdArticulo = va.IdArticulo
LEFT JOIN [dbo].[Pers_PrePedido_Familias_Orden] PPFO
	ON PPFO.Familia = VA.Familia
WHERE ppl.Visible = 1 