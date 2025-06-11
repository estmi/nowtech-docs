ALTER FUNCTION fPers_Vendes_Dia_Comercials_Empresa(@DataPedido datetime, @IdEmpresa int = 0)
RETURNS TABLE 
AS
RETURN 
(
SELECT 'EXACTES' AS Estat, 1 AS Tipus, CDC.IdCliente AS Client, CD.Cliente AS NomClient, PrePedLin.IdPedido, 
    PrePedLin.IdArticulo as Article, A.Descrip AS NomArticle, CAST(PrePedLin.Cantidad AS float) as QuantitatPrePedido, 
    PedCliLin.Cantidad AS QuantitatPedido, 
	CAST(PrePedLin.Precio AS Float) + coalesce(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 
	PedCliLin.Precio_EURO + coalesce(sum(PrePedLinDetall.Precio_EURO),0) AS PreuPedido, 
	PrePedLin.TipoUnidad AS TipusUnitatPre, PedCliLin.TipoUnidadPres AS TiposUnitatPed, 
	PedCliCab.IdTransportista as Repartidor, CDC.IdAgente as Comercial, CA.Descrip as NomComercial, 
	PedCliLin.Observaciones AS Descripcio, PedCliLin.Precio_EURO as PreuVendaAlbara, 0 as PreuCostAlbara, 
	0 as PreuVendaComanda, PedCliLin.Cantidad as QuantitatAlbara, 
	ETransportista.Nombre + ' ' + ETransportista.Apellidos as NomTransportista, 
	EEntradaPedido.Nombre as  NomComanda /* Nom Usuari Entrada Pedido */, A.TipoCantidad as TipoCantidad, 
	PedCliLin.IdLinea as Linia, PedCliLin.IdDocPadre as IdDocPadre, PedCliLin.IdDoc as IdDoc
FROM Pers_PrePedido_Lineas as PrePedLin
LEFT JOIN Pers_PrePedido as PrePed on PrePed.IdPedido = PrePedLin.IdPedido
JOIN Pedidos_Cli_Lineas as PedCliLin on PedCliLin.IdPedido = PrePedLin.IdPedido and PedCliLin.IdLinea = PrePedLin.IdPedidoLinea 
    and PedCliLin.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Pedidos_Cli_Cabecera as PedCliCab on PedCliCab.IdPedido = PedCliLin.IdPedido
LEFT JOIN Pedidos_Cli_Lineas PrePedLinDetall on PrePedLinDetall.IdDocPadre = PedCliLin.IdDoc
LEFT JOIN Articulos as A on A.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos as CD ON CD.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CDC ON CDC.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CDC.IdAgente
LEFT JOIN Empleados_Datos as ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos as EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(CAST(PedCliCab.FechaSalida as DATE) as datetime) = CAST(CAST(@DataPedido as date) as datetime)
    AND CDC.IdAgente NOT IN (99999, 30)
    and CDC.Zona NOT IN (1,2, 200) 
    and PedCliCab.IdEstado > 0
    and PedCliCab.IdEmpresa = @IdEmpresa 
    and PedCliLin.IdDocPadre IS NULL
group by CDC.IdCliente, CD.Cliente, PrePedLin.IdPedido, PrePedLin.IdArticulo, A.Descrip, 
    CAST(PrePedLin.Cantidad AS float), PedCliLin.Cantidad, CAST(PrePedLin.Precio AS Float), PedCliLin.Precio_EURO, 
    PrePedLin.TipoUnidad, PedCliLin.TipoUnidadPres, PedCliCab.IdTransportista, CDC.IdAgente, CA.Descrip, PedCliLin.Observaciones, 
    PedCliLin.Cantidad, ETransportista.Nombre, ETransportista.Apellidos, EEntradaPedido.Nombre, A.TipoCantidad, PedCliLin.IdLinea, 
    PedCliLin.IdDocPadre, PedCliLin.IdDoc,PrePedLin.PrecioFeina

UNION

SELECT 'NO ALBARÀ' AS Estat, 2 as Tipus, CDC.IdCliente AS Client, CD.Cliente AS NomClient, PrePedLin.IdPedido, 
	PrePedLin.IdArticulo as Article, Art.Descrip AS NomArticle, 
	CAST(PrePedLin.Cantidad AS float) as QuantitatPrePedido, 0 AS QuantitatPedido, 
	CAST(PrePedLin.Precio AS Float) + coalesce(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 0 AS PreuPedido, 
	PrePedLin.TipoUnidad AS TipusUnitatPre, '' AS TiposUnitatPed, PedCliCab.IdTransportista as Repartidor, 	
	CDC.IdAgente as Comercial, CA.Descrip as NomComercial, PrePedLin.Observacion AS Descripcio, 0 as PreuVendaAlbara, 
	0 as PreuCostAlbara, 0 as PreuVendaComanda, 0 as QuantitatAlbara, 
	ETransportista.Nombre + ' ' + ETransportista.Apellidos as NomTransportista, EEntradaPedido.Nombre as NomComanda, 
	Art.TipoCantidad as TipoCantidad, PrePedLin.IdPedidoLinea as Linia, PedCliLin.IdDocPadre as IdDocPadre, 
	PedCliLin.IdDoc as IdDoc
FROM Pers_PrePedido_Lineas as PrePedLin
LEFT JOIN Pers_PrePedido as PrePed on PrePed.IdPrePedido = PrePedLin.IdPrePedido
LEFT JOIN Pedidos_Cli_Cabecera as PedCliCab on PedCliCab.IdPedido = PrePed.IdPedido
LEFT JOIN Pedidos_Cli_Lineas PedCliLin on PedCliLin.IdPedido = PrePedLin.IdPedido 
	and PedCliLin.IdLinea = PrePedLin.IdPedidoLinea and PedCliLin.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Articulos as Art on Art.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos as CD ON CD.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CDC ON CDC.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CDC.IdAgente
LEFT JOIN Empleados_Datos as ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos as EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(PrePed.Fecha_Entrega as DATE) = CAST(@DataPedido as date) 
	AND PedCliLin.IdDoc is null
	and CDC.IdAgente not in (99999, 30)
	and CDC.Zona not In (1,2, 200)
	and PrePed.IdEstado = 2
	and PrePed.IdEmpresa = @IdEmpresa
	AND PrePedLin.IdPedido IS not NULL

UNION

declare @IDempresa int = 0, @DataPedido date = '20250611'

SELECT 'NO ALBARÀ' as Estat, 2 as Tipus, PedCliCab.IdCliente AS Client, CD.Cliente as NomClient, 
	PrePedLin.IdPedido as IdPedido, PrePedLin.IdArticulo as Article, Art.Descrip as NomArticle, 0 as QuantitatPrePedido,
	PrePedLin.Cantidad as QuantitatPedido,
	CAST(PrePedLin.Precio AS Float) + coalesce(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 
	0 as PreuPedido, '' AS TipusUnitatPre, PrePedLin.TipoUnidad as TiposUnitatPed, PedCliCab.IdTransportista as Repartidor, 
	CliDatCom.IdAgente as Comercial, CA.Descrip as NomComercial, PrePedLin.Observacion as Observacions, 
	0 as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda, 0 as QuantitatAlbara, 
	ETransportista.Nombre + ' ' + ETransportista.Apellidos as NomTransportista, EEntradaPedido.Nombre as NomComanda, 
	Art.TipoCantidad as TipoCantidad, 0 as Linia, PedCliLin.IdDocPadre as IdDocPadre, PedCliLin.IdDoc as IdDoc
FROM Pers_PrePedido_Lineas as PrePedLin
INNER JOIN Pers_PrePedido as PrePed on PrePed.IdPrePedido = PrePedLin.IdPrePedido
INNER JOIN Pedidos_Cli_Cabecera as PedCliCab on PedCliCab.IdPedido = PrePed.IdPedido
left join Pedidos_Cli_Lineas PedCliLin on PedCliLin.IdPedido = PrePedLin.IdPedido 
	AND PedCliLin.IdLinea = PrePedLin.IdPedidoLinea
INNER JOIN Clientes_Datos as CD on CD.IdCliente = PedCliCab.IdCliente
INNER JOIN Articulos as Art on Art.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos_Comerciales as CliDatCom ON CliDatCom.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CliDatCom.IdAgente
LEFT JOIN Empleados_Datos as ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos as EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(PrePed.Fecha_Entrega as date) = CAST(@DataPedido as date) 
	AND PrePedLin.IdPedido IS NULL
	and CliDatCom.IdAgente not in (99999, 30)
	and PrePed.IdEmpresa = @IdEmpresa
	and CliDatCom.Zona not In (1,2,200)
	and PrePed.IdEstado = 2

UNION

SELECT 'NO COMANDA' AS Estat, 3 as Tipus, CC.IdCliente AS Client, C.Cliente AS NomClient, pcl.IdPedido, pcl.IdArticulo as Article, A.Descrip AS NomArticle,
0 QuantitatPrePedido, pcl.Cantidad AS QuantitatPedido, 0 AS PreuPrePedido, pcl.Precio_EURO + coalesce(sum(pclDetall.Precio_EURO),0) AS PreuPedido,
'' AS TipusUnitatPre, pcl.TipoUnidadPres AS TiposUnitatPed, pcc.IdTransportista as Repartidor, CC.IdAgente as Comercial,
CA.Descrip as NomComercial, pcl.Observaciones AS Descripcio, pcl.Precio_EURO as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda,
pcl.Cantidad as QuantitatAlbara, E.Nombre + ' ' + E.Apellidos as NomTransportista, EE.Nombre as NomComanda, A.TipoCantidad as TipoCantidad,
pcl.IdLinea as Linia, pcl.IdDocPadre as IdDocPadre, pcl.IdDoc as IdDoc
FROM Pedidos_Cli_Lineas as pcl
LEFT JOIN Pedidos_Cli_Cabecera as pcc on pcc.IdPedido = pcl.IdPedido
LEFT JOIN Pedidos_Cli_Lineas pclDetall on pclDetall.IdDocPadre = pcl.IdDoc
LEFT JOIN Articulos as A on A.IdArticulo = pcl.IdArticulo
LEFT JOIN Clientes_Datos as C ON C.IdCliente = pcc.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CC ON CC.IdCliente = pcc.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CC.IdAgente
LEFT JOIN Empleados_Datos as E ON E.IdEmpleado = pcc.IdTransportista
LEFT JOIN Pers_PrePedido as prec ON prec.IdPedido = pcl.IdPedido
left join Pers_PrePedido_Lineas as PrePedLin on PrePedLin.IdPedido = pcl.IdPedido and PrePedLin.IdPedidoLinea = pcl.IdLinea and PrePedLin.IdArticulo = pcl.IdArticulo
LEFT JOIN Empleados_Datos as EE ON EE.IdEmpleado = prec.IdEmpleadoPedido
inner join Conf_Pedidos_Cli_Lineas cpcl on cpcl.IdPedido = pcl.IdPedido and cpcl.IdLinea = pcl.IdLinea
WHERE 
CAST(pcc.FechaSalida as DATE) = CAST(@DataPedido as date)
and pcc.IdEmpresa = @IdEmpresa
AND PrePedLin.iddoc is null
and CC.IdAgente not in (99999, 30)
and CC.Zona not In (1,2, 200)
and pcc.IdEstado > 0
and pcl.IdDocPadre is null
group by CC.IdCliente, C.Cliente, pcl.IdPedido, pcl.IdArticulo, A.Descrip,
pcl.Cantidad, pcl.Precio_EURO, pcl.TipoUnidadPres, pcc.IdTransportista, CC.IdAgente,
CA.Descrip, pcl.Observaciones, pcl.Precio_EURO, pcl.Cantidad, E.Nombre, E.Apellidos,
EE.Nombre, A.TipoCantidad, pcl.IdLinea, pcl.IdDocPadre, pcl.IdDoc
);