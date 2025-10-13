SELECT 
    case when (Traduccion.Descrip is null or Traduccion.Descrip = '') and Pedidos_Cli_lineas.descrip = articulos.Descrip then Articulos.Descrip
		 when (Traduccion.Descrip is null or Traduccion.Descrip = '') and Pedidos_Cli_lineas.descrip <> articulos.Descrip then Pedidos_Cli_lineas.Descrip
		 when  Pedidos_Cli_lineas.descrip <> articulos.Descrip and Traduccion.Descrip = articulos.Descrip then Pedidos_Cli_lineas.Descrip
	else Traduccion.Descrip end AS DescripcionArticulo,
	case when vPers_RowNumbers_CR_Bundle.Cantidad is not null and vPers_RowNumbers_CR_Bundle.tipounidad is not null and vPers_RowNumbers_CR_Bundle.total is not null then 1 else 0 end as IsBundle

FROM 
   Albaranes_Cli_Cab
	inner join Pedidos_Cli_lineas on Pedidos_Cli_lineas.idalbaran = Albaranes_Cli_Cab.IdAlbaran
inner join Articulos on Articulos.idarticulo = Pedidos_Cli_lineas.idarticulo
inner join vPers_RowNumbers_CR_Bundle on vPers_RowNumbers_CR_Bundle.iddoc =  Pedidos_Cli_lineas.IdDoc
    OUTER APPLY dbo.funPers_Traduccion_Articulo(Albaranes_Cli_Cab.IdCliente, Pedidos_Cli_lineas.IdArticulo) AS Traduccion
where  Pedidos_Cli_lineas.IdDoc = {?IdDoc}