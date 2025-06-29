ALTER FUNCTION [dbo].[fPers_Vendes_Dia_Comercials_Empresa](@DataPedido datetime, @IdEmpresa int = 0)
RETURNS TABLE 
AS
RETURN 
(
SELECT 'EXACTES' AS Estat, 1 AS Tipus, CC.IdCliente AS Client, C.Cliente AS NomClient, pre.IdPedido, pre.IdArticulo as Article, A.Descrip AS NomArticle,
CAST(pre.Cantidad AS float) as QuantitatPrePedido, pcl.Cantidad AS QuantitatPedido, CAST(pre.Precio AS Float) AS PreuPrePedido, pcl.Precio_EURO AS PreuPedido,
pre.TipoUnidad AS TipusUnitatPre, pcl.TipoUnidadPres AS TiposUnitatPed, pcc.IdTransportista as Repartidor, CC.IdAgente as Comercial,
CA.Descrip as NomComercial, pcl.Observaciones AS Descripcio, pcl.Precio_EURO as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda,
pcl.Cantidad as QuantitatAlbara, E.Nombre + ' ' + E.Apellidos as NomTransportista, EE.Nombre as NomComanda, A.TipoCantidad as TipoCantidad,
pcl.IdLinea as Linia
FROM Pers_PrePedido_Lineas as pre
LEFT JOIN Pers_PrePedido as pr on pr.IdPedido = pre.IdPedido
JOIN Pedidos_Cli_Lineas as pcl on pcl.IdPedido = pre.IdPedido and pcl.IdLinea = pre.IdPedidoLinea and pcl.IdArticulo = pre.IdArticulo
LEFT JOIN Pedidos_Cli_Cabecera as pcc on pcc.IdPedido = pcl.IdPedido
LEFT JOIN Articulos as A on A.IdArticulo = pre.IdArticulo
LEFT JOIN Clientes_Datos as C ON C.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CC ON CC.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CC.IdAgente
LEFT JOIN Empleados_Datos as E ON E.IdEmpleado = pcc.IdTransportista
LEFT JOIN Pers_PrePedido as prec ON prec.IdPedido = pre.IdPedido
LEFT JOIN Empleados_Datos as EE ON EE.IdEmpleado = prec.IdEmpleadoPedido
WHERE CAST(CAST(pcc.FechaSalida as DATE) as datetime) = CAST(CAST(@DataPedido as date) as datetime) and CC.IdAgente <> 99999 and CC.IdAgente <> 10 and CC.IdAgente <> 30
and CC.Zona not In (1,2) and pcc.IdEstado > 0
and pcc.IdEmpresa = @IdEmpresa

UNION

SELECT 'NO ALBARÀ' AS Estat, 2 as Tipus, CC.IdCliente AS Client, C.Cliente AS NomClient, pre.IdPedido, pre.IdArticulo as Article, A.Descrip AS NomArticle,
CAST(pre.Cantidad AS float) as QuantitatPrePedido, 0 AS QuantitatPedido,CAST(pre.Precio AS Float) AS PreuPrePedido, 0 AS PreuPedido,
pre.TipoUnidad AS TipusUnitatPre, '' AS TiposUnitatPed, pcc.IdTransportista as Repartidor, CC.IdAgente as Comercial,
CA.Descrip as NomComercial, pre.Observacion AS Descripcio, 0 as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda,
0 as QuantitatAlbara, E.Nombre + ' ' + E.Apellidos as NomTransportista, EE.Nombre as NomComanda, A.TipoCantidad as TipoCantidad,
pre.IdPedidoLinea as Linia
FROM Pers_PrePedido_Lineas as pre
LEFT JOIN Pers_PrePedido as pr on pr.IdPedido = pre.IdPedido
LEFT JOIN Pedidos_Cli_Cabecera as pcc on pcc.IdPedido = pre.IdPedido
LEFT JOIN Articulos as A on A.IdArticulo = pre.IdArticulo
LEFT JOIN Clientes_Datos as C ON C.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CC ON CC.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CC.IdAgente
LEFT JOIN Empleados_Datos as E ON E.IdEmpleado = pcc.IdTransportista
LEFT JOIN Pers_PrePedido as prec ON prec.IdPedido = pre.IdPedido
LEFT JOIN Empleados_Datos as EE ON EE.IdEmpleado = prec.IdEmpleadoPedido
WHERE CAST(CAST(pcc.FechaSalida as DATE) as datetime) = CAST(CAST(@DataPedido as date) as datetime) AND 
(((SELECT COUNT(*) FROM Pedidos_Cli_Lineas as PCL
WHERE pcl.IdPedido = pre.IdPedido and pcl.IdLinea = pre.IdPedidoLinea and PCL.IdArticulo = pre.IdArticulo) = 0)
)--or
--(pre.IdPedido is null OR NOT EXISTS (
--    SELECT 1
--    FROM Pedidos_Cli_Lineas pcl
  --  WHERE pcl.IdLinea = pre.IdPedidoLinea and pcl.IdPedido = pre.IdPedido
  --)))
and CC.IdAgente <> 99999 and CC.IdAgente <> 10 and CC.IdAgente <> 30
and CC.Zona not In (1,2) and pcc.IdEstado > 0
and pcc.IdEmpresa = @IdEmpresa


UNION
/*
SELECT 'NO ALBARÀ' AS Estat, 2 as Tipus, CC.IdCliente AS Client, C.Cliente AS NomClient, pre.IdPedido, pre.IdArticulo as Article, A.Descrip AS NomArticle,
CAST(pre.Cantidad AS float) as QuantitatPrePedido, 0 AS QuantitatPedido,CAST(pre.Precio AS Float) AS PreuPrePedido, 0 AS PreuPedido,
pre.TipoUnidad AS TipusUnitatPre, '' AS TiposUnitatPed, '' as Repartidor, CC.IdAgente as Comercial,
CA.Descrip as NomComercial, pre.Observacion AS Descripcio, 0 as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda,
0 as QuantitatAlbara, '' as NomTransportista, EE.Nombre as NomComanda, A.TipoCantidad as TipoCantidad,
pre.IdPedidoLinea as Linia
FROM Pers_PrePedido_Lineas as pre
LEFT JOIN Pers_PrePedido as Pr on Pr.IdPrePedido = pre.IdPrePedido
LEFT JOIN Articulos as A on A.IdArticulo = pre.IdArticulo
LEFT JOIN Clientes_Datos as C ON C.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CC ON CC.IdCliente = pr.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CC.IdAgente
LEFT JOIN Pers_PrePedido as prec ON prec.IdPedido = pre.IdPedido
LEFT JOIN Empleados_Datos as EE ON EE.IdEmpleado = prec.IdEmpleadoPedido
WHERE (Pr.Fecha_Preparacion = CAST(CAST(@DataPedido as date) as datetime)) --AND (pre.IdPedido is null)
and CC.IdAgente <> 99999 and CC.IdAgente <> 10 and CC.IdAgente <> 30
and CC.Zona not In (1,2)
AND (pre.IdPedido is null OR NOT EXISTS (
    SELECT 1
    FROM Pedidos_Cli_Lineas pcl
    WHERE pcl.IdLinea = pre.IdPedidoLinea and pcl.IdPedido = pre.IdPedido
  ))
  
UNION */

SELECT 'NO COMANDA' AS Estat, 3 as Tipus, CC.IdCliente AS Client, C.Cliente AS NomClient, pcl.IdPedido, pcl.IdArticulo as Article, A.Descrip AS NomArticle,
0 QuantitatPrePedido, pcl.Cantidad AS QuantitatPedido, 0 AS PreuPrePedido, pcl.Precio_EURO AS PreuPedido,
'' AS TipusUnitatPre, pcl.TipoUnidadPres AS TiposUnitatPed, pcc.IdTransportista as Repartidor, CC.IdAgente as Comercial,
CA.Descrip as NomComercial, pcl.Observaciones AS Descripcio, pcl.Precio_EURO as PreuVendaAlbara, 0 as PreuCostAlbara, 0 as PreuVendaComanda,
pcl.Cantidad as QuantitatAlbara, E.Nombre + ' ' + E.Apellidos as NomTransportista, EE.Nombre as NomComanda, A.TipoCantidad as TipoCantidad,
pcl.IdLinea as Linia
FROM Pedidos_Cli_Lineas as pcl
LEFT JOIN Pedidos_Cli_Cabecera as pcc on pcc.IdPedido = pcl.IdPedido
LEFT JOIN Articulos as A on A.IdArticulo = pcl.IdArticulo
LEFT JOIN Clientes_Datos as C ON C.IdCliente = pcc.IdCliente
LEFT JOIN Clientes_Datos_Comerciales as CC ON CC.IdCliente = pcc.IdCliente
LEFT JOIN Clientes_Agentes as CA ON CA.IdAgente = CC.IdAgente
LEFT JOIN Empleados_Datos as E ON E.IdEmpleado = pcc.IdTransportista
LEFT JOIN Pers_PrePedido as prec ON prec.IdPedido = pcl.IdPedido
LEFT JOIN Empleados_Datos as EE ON EE.IdEmpleado = prec.IdEmpleadoPedido
WHERE CAST(CAST(pcc.FechaSalida as DATE) as datetime) = CAST(CAST(@DataPedido as date) as datetime) AND (SELECT COUNT(*) FROM Pers_PrePedido_Lineas as pre WHERE
pre.IdPedido = pcl.IdPedido and pre.IdPedidoLinea = pcl.IdLinea and pre.IdArticulo = pcl.IdArticulo) = 0 
and CC.IdAgente <> 99999 and CC.IdAgente <> 10 and CC.IdAgente <> 30
and CC.Zona not In (1,2) and pcc.IdEstado > 0
and pcc.IdEmpresa = @IdEmpresa
);