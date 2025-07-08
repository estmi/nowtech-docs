# Vista televendes

## Source Linies

```sql
select 
orden,IdPrePedido,IdPrePedidoLinea,IdArticulo,DescripArticle,QuantVenta,cantidad,TipoUnidad,Precio,TipoObservacion,Observacion,UltPrecio,UltVenta,StockCalc,Color,ColorPrecio,Cursiva,Tachado,TotalCantidad,KGPres,TotalPrecio,IdTipoUnidadPres,TipoCantidad,PermiteKGS,PermitePEC,PermiteFDO,PrecioT1,PrecioT2,PrecioT3,PrecioT4,PrecioT5,PreuCost
, pointerEvents
 from VPers_PrePedido_Lineas_Grid [Pers_PrePedido_Lineas]
```

<SqlViewer file="clients/puignau\CRM\view_televendes\VPers_PrePedido_Lineas_Grid.sql"/>
