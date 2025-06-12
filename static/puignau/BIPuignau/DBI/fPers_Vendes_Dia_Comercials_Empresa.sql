ALTER FUNCTION fPers_Vendes_Dia_Comercials_Empresa(@DataPedido datetime, @IdEmpresa int = 0)
RETURNS TABLE 
AS
RETURN 
(
SELECT 'EXACTES' AS Estat, 1 AS Tipus, CDC.IdCliente AS Client, CD.Cliente AS NomClient, PrePedLin.IdPedido, 
    PrePedLin.IdArticulo AS Article, A.Descrip AS NomArticle, CAST(PrePedLin.Cantidad AS FLOAT) AS QuantitatPrePedido,
    PedCliLin.Cantidad AS QuantitatPedido, 
    CAST(PrePedLin.Precio AS FLOAT) + COALESCE(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 
    PedCliLin.Precio_EURO + COALESCE(SUM(PedCliLinDetall.Precio_EURO),0) AS PreuPedido, 
    PrePedLin.TipoUnidad AS TipusUnitatPre, PedCliLin.TipoUnidadPres AS TiposUnitatPed, 
    PedCliCab.IdTransportista AS Repartidor, CDC.IdAgente AS Comercial, CA.Descrip AS NomComercial, 
    PedCliLin.Observaciones AS Descripcio, 
    PedCliLin.Precio_EURO + COALESCE(SUM(PedCliLinDetall.Precio_EURO),0) AS PreuVendaAlbara, 0 AS PreuCostAlbara, 
    0 AS PreuVendaComanda, PedCliLin.Cantidad AS QuantitatAlbara, 
    ETransportista.Nombre + ' ' + ETransportista.Apellidos AS NomTransportista, 
    EEntradaPedido.Nombre AS  NomComanda /* Nom Usuari Entrada Pedido */, A.TipoCantidad AS TipoCantidad, 
    PedCliLin.IdLinea AS Linia, PedCliLin.IdDocPadre AS IdDocPadre, PedCliLin.IdDoc AS IdDoc
FROM Pers_PrePedido_Lineas AS PrePedLin
LEFT JOIN Pers_PrePedido AS PrePed ON PrePed.IdPedido = PrePedLin.IdPedido
JOIN Pedidos_Cli_Lineas AS PedCliLin ON PedCliLin.IdPedido = PrePedLin.IdPedido 
    AND PedCliLin.IdLinea = PrePedLin.IdPedidoLinea AND PedCliLin.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Pedidos_Cli_Cabecera AS PedCliCab ON PedCliCab.IdPedido = PedCliLin.IdPedido
LEFT JOIN Pedidos_Cli_Lineas PedCliLinDetall ON PedCliLinDetall.IdDocPadre = PedCliLin.IdDoc
LEFT JOIN Articulos AS A ON A.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos AS CD ON CD.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Datos_Comerciales AS CDC ON CDC.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes AS CA ON CA.IdAgente = CDC.IdAgente
LEFT JOIN Empleados_Datos AS ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos AS EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(PedCliCab.FechaSalida AS DATE) = CAST(@DataPedido AS DATE)
    AND CDC.IdAgente NOT IN (99999, 30)
    AND CDC.Zona NOT IN (1,2, 200) 
    AND PedCliCab.IdEstado > 0
    AND PedCliCab.IdEmpresa = @IdEmpresa 
    AND PedCliLin.IdDocPadre IS NULL
group by CDC.IdCliente, CD.Cliente, PrePedLin.IdPedido, PrePedLin.IdArticulo, A.Descrip, 
    CAST(PrePedLin.Cantidad AS FLOAT), PedCliLin.Cantidad, CAST(PrePedLin.Precio AS FLOAT), PedCliLin.Precio_EURO, 
    PrePedLin.TipoUnidad, PedCliLin.TipoUnidadPres, PedCliCab.IdTransportista, CDC.IdAgente, CA.Descrip, 
    PedCliLin.Observaciones, PedCliLin.Cantidad, ETransportista.Nombre, ETransportista.Apellidos, 
    EEntradaPedido.Nombre, A.TipoCantidad, PedCliLin.IdLinea, PedCliLin.IdDocPadre, PedCliLin.IdDoc,
    PrePedLin.PrecioFeina

UNION

SELECT 'NO ALBARÀ' AS Estat, 2 AS Tipus, CDC.IdCliente AS Client, CD.Cliente AS NomClient, PrePedLin.IdPedido, 
    PrePedLin.IdArticulo AS Article, Art.Descrip AS NomArticle, 
    CAST(PrePedLin.Cantidad AS FLOAT) AS QuantitatPrePedido, 0 AS QuantitatPedido, 
    CAST(PrePedLin.Precio AS FLOAT) + COALESCE(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 0 AS PreuPedido, 
    PrePedLin.TipoUnidad AS TipusUnitatPre, '' AS TiposUnitatPed, PedCliCab.IdTransportista AS Repartidor, 	
    CDC.IdAgente AS Comercial, CA.Descrip AS NomComercial, PrePedLin.Observacion AS Descripcio, 0 AS PreuVendaAlbara, 
    0 AS PreuCostAlbara, 0 AS PreuVendaComanda, 0 AS QuantitatAlbara, 
    ETransportista.Nombre + ' ' + ETransportista.Apellidos AS NomTransportista, EEntradaPedido.Nombre AS NomComanda, 
    Art.TipoCantidad AS TipoCantidad, PrePedLin.IdPedidoLinea AS Linia, PedCliLin.IdDocPadre AS IdDocPadre, 
    PedCliLin.IdDoc AS IdDoc
FROM Pers_PrePedido_Lineas AS PrePedLin
LEFT JOIN Pers_PrePedido AS PrePed ON PrePed.IdPrePedido = PrePedLin.IdPrePedido
LEFT JOIN Pedidos_Cli_Cabecera AS PedCliCab ON PedCliCab.IdPedido = PrePed.IdPedido
LEFT JOIN Pedidos_Cli_Lineas PedCliLin ON PedCliLin.IdPedido = PrePedLin.IdPedido 
	AND PedCliLin.IdLinea = PrePedLin.IdPedidoLinea AND PedCliLin.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Articulos AS Art ON Art.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos AS CD ON CD.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Datos_Comerciales AS CDC ON CDC.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes AS CA ON CA.IdAgente = CDC.IdAgente
LEFT JOIN Empleados_Datos AS ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos AS EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(PrePed.Fecha_Entrega AS DATE) = CAST(@DataPedido AS DATE) 
	AND PedCliLin.IdDoc is null
	AND CDC.IdAgente NOT IN (99999, 30)
	AND CDC.Zona NOT In (1,2, 200)
	AND PrePed.IdEstado = 2
	AND PrePed.IdEmpresa = @IdEmpresa
	AND PrePedLin.IdPedido IS NOT NULL

UNION

SELECT 'NO ALBARÀ' AS Estat, 2 AS Tipus, PedCliCab.IdCliente AS Client, CD.Cliente AS NomClient, 
    PrePedLin.IdPedido AS IdPedido, PrePedLin.IdArticulo AS Article, Art.Descrip AS NomArticle, 
    0 AS QuantitatPrePedido, PrePedLin.Cantidad AS QuantitatPedido, 
    CAST(PrePedLin.Precio AS FLOAT) + COALESCE(PrePedLin.PrecioFeina, 0) AS PreuPrePedido, 0 AS PreuPedido, 
    '' AS TipusUnitatPre, PrePedLin.TipoUnidad AS TiposUnitatPed, PedCliCab.IdTransportista AS Repartidor, 
    CliDatCom.IdAgente AS Comercial, CA.Descrip AS NomComercial, PrePedLin.Observacion AS Observacions, 
    0 AS PreuVendaAlbara, 0 AS PreuCostAlbara, 0 AS PreuVendaComanda, 0 AS QuantitatAlbara, 
    ETransportista.Nombre + ' ' + ETransportista.Apellidos AS NomTransportista, EEntradaPedido.Nombre AS NomComanda, 
    Art.TipoCantidad AS TipoCantidad, 0 AS Linia, PedCliLin.IdDocPadre AS IdDocPadre, PedCliLin.IdDoc AS IdDoc
FROM Pers_PrePedido_Lineas AS PrePedLin
INNER JOIN Pers_PrePedido AS PrePed ON PrePed.IdPrePedido = PrePedLin.IdPrePedido
INNER JOIN Pedidos_Cli_Cabecera AS PedCliCab ON PedCliCab.IdPedido = PrePed.IdPedido
left join Pedidos_Cli_Lineas PedCliLin ON PedCliLin.IdPedido = PrePedLin.IdPedido 
    AND PedCliLin.IdLinea = PrePedLin.IdPedidoLinea
INNER JOIN Clientes_Datos AS CD ON CD.IdCliente = PedCliCab.IdCliente
INNER JOIN Articulos AS Art ON Art.IdArticulo = PrePedLin.IdArticulo
LEFT JOIN Clientes_Datos_Comerciales AS CliDatCom ON CliDatCom.IdCliente = PrePed.IdCliente
LEFT JOIN Clientes_Agentes AS CA ON CA.IdAgente = CliDatCom.IdAgente
LEFT JOIN Empleados_Datos AS ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Empleados_Datos AS EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
WHERE CAST(PrePed.Fecha_Entrega AS DATE) = CAST(@DataPedido AS DATE) 
    AND PrePedLin.IdPedido IS NULL
    AND CliDatCom.IdAgente NOT IN (99999, 30)
    AND PrePed.IdEmpresa = @IdEmpresa
    AND CliDatCom.Zona NOT In (1,2,200)
    AND PrePed.IdEstado = 2

UNION

SELECT 'NO COMANDA' AS Estat, 3 AS Tipus, CliDatCom.IdCliente AS Client, CD.Cliente AS NomClient, PedCliLin.IdPedido, 
    PedCliLin.IdArticulo AS Article, A.Descrip AS NomArticle, 0 QuantitatPrePedido, 
    PedCliLin.Cantidad AS QuantitatPedido, 0 AS PreuPrePedido, 
    PedCliLin.Precio_EURO + COALESCE(SUM(PedCliLinDetall.Precio_EURO),0) AS PreuPedido, '' AS TipusUnitatPre, 
    PedCliLin.TipoUnidadPres AS TiposUnitatPed, PedCliCab.IdTransportista AS Repartidor, 
    CliDatCom.IdAgente AS Comercial, CA.Descrip AS NomComercial, PedCliLin.Observaciones AS Descripcio, 
    PedCliLin.Precio_EURO + COALESCE(SUM(PedCliLinDetall.Precio_EURO),0) AS PreuVendaAlbara, 0 AS PreuCostAlbara, 
    0 AS PreuVendaComanda, PedCliLin.Cantidad AS QuantitatAlbara, 
    ETransportista.Nombre + ' ' + ETransportista.Apellidos AS NomTransportista, EEntradaPedido.Nombre AS NomComanda, 
    A.TipoCantidad AS TipoCantidad, PedCliLin.IdLinea AS Linia, PedCliLin.IdDocPadre AS IdDocPadre, 
    PedCliLin.IdDoc AS IdDoc
FROM Pedidos_Cli_Lineas AS PedCliLin
LEFT JOIN Pedidos_Cli_Cabecera AS PedCliCab ON PedCliCab.IdPedido = PedCliLin.IdPedido
LEFT JOIN Pedidos_Cli_Lineas PedCliLinDetall ON PedCliLinDetall.IdDocPadre = PedCliLin.IdDoc
LEFT JOIN Articulos AS A ON A.IdArticulo = PedCliLin.IdArticulo
LEFT JOIN Clientes_Datos AS CD ON CD.IdCliente = PedCliCab.IdCliente
LEFT JOIN Clientes_Datos_Comerciales AS CliDatCom ON CliDatCom.IdCliente = PedCliCab.IdCliente
LEFT JOIN Clientes_Agentes AS CA ON CA.IdAgente = CliDatCom.IdAgente
LEFT JOIN Empleados_Datos AS ETransportista ON ETransportista.IdEmpleado = PedCliCab.IdTransportista
LEFT JOIN Pers_PrePedido AS PrePed ON PrePed.IdPedido = PedCliLin.IdPedido
LEFT JOIN Pers_PrePedido_Lineas AS PrePedLin ON PrePedLin.IdPedido = PedCliLin.IdPedido 
    AND PrePedLin.IdPedidoLinea = PedCliLin.IdLinea AND PrePedLin.IdArticulo = PedCliLin.IdArticulo
LEFT JOIN Empleados_Datos AS EEntradaPedido ON EEntradaPedido.IdEmpleado = PrePed.IdEmpleadoPedido
INNER JOIN Conf_Pedidos_Cli_Lineas cpcl ON cpcl.IdPedido = PedCliLin.IdPedido AND cpcl.IdLinea = PedCliLin.IdLinea
WHERE 
    CAST(PedCliCab.FechaSalida AS DATE) = CAST(@DataPedido AS DATE)
    AND PedCliCab.IdEmpresa = @IdEmpresa
    AND PrePedLin.iddoc IS NULL
    AND CliDatCom.IdAgente NOT IN (99999, 30)
    AND CliDatCom.Zona NOT IN (1,2, 200)
    AND PedCliCab.IdEstado > 0
    AND PedCliLin.IdDocPadre IS NULL
GROUP BY CliDatCom.IdCliente, CD.Cliente, PedCliLin.IdPedido, PedCliLin.IdArticulo, A.Descrip, PedCliLin.Cantidad, 
    PedCliLin.Precio_EURO, PedCliLin.TipoUnidadPres, PedCliCab.IdTransportista, CliDatCom.IdAgente, CA.Descrip, 
    PedCliLin.Observaciones, PedCliLin.Precio_EURO, PedCliLin.Cantidad, ETransportista.Nombre, 
    ETransportista.Apellidos, EEntradaPedido.Nombre, A.TipoCantidad, PedCliLin.IdLinea, PedCliLin.IdDocPadre, 
    PedCliLin.IdDoc
);