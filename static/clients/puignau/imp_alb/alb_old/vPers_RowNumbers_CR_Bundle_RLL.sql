ALTER view [dbo].[vPers_RowNumbers_CR_Bundle_RLL] as  
 SELECT     
 Pcl.iddoc,    
    pcl.IdAlbaran,            
    pcl.IdLinea,  
    pclu.Lote,
    ROW_NUMBER() OVER (PARTITION BY pcl.IdAlbaran ORDER BY /*pcl.idpedido,*/ pcl.Orden, pcl.IdLinea) AS RowNum,
    f.Precio ,f.IdIva ,f.Cantidad,f.TipoUnidad,f.total
FROM             
    Pedidos_Cli_Lineas pcl    with (nolock)    
 inner join Pedidos_Cli_Cabecera pcc  with (nolock) on pcl.IdPedido = pcc.IdPedido    
 left join Pedidos_Cli_LineasUbic pclu with (nolock)  on pcl.IdPedido=pclu.IdPedido and pcl.IdLinea=pclu.IdLinea
 inner join Albaranes_Cli_Cab acc  with (nolock) on pcl.IdAlbaran=acc.IdAlbaran    
 inner join Conf_Clientes cc  with (nolock) on cc.IdCliente = pcc.IdCliente    
 outer apply fpers_devuelveLineas_Bundle_IL(acc.IdDoc, cc.Pers_ImpBundle) f
 where pcl.IdLinea = f.IdLinea   and pcl.IdPedido = f.IdPedido
 group by pcl.idpedido, Pcl.iddoc,pcl.Orden,    
    pcl.IdAlbaran,            
    pcl.IdLinea,  
    pclu.Lote,f.Precio ,f.IdIva ,f.Cantidad,f.TipoUnidad,f.total