ALTER view [dbo].[Pers_albaranes_lineas_min4] as    
SELECT -- top 100 percent  
    vac.Ord,  
    rn.IdLinea,  
 rn.iddoc,  
    n.fila,  
 ac.idalbaran ,  --((ROW_NUMBER() OVER (PARTITION BY vac.Ord ORDER BY Ord,fila) - 1) / 14) + 1 AS reset_count  ,    
 case when n.fila <=14 then 1  
  when n.fila between 15 and 28 then 2  
  when n.fila between 29 and 42 then 3  
  when n.fila between 43 and 56 then 4  
  when n.fila between 57 and 70 then 5  
  when n.fila between 71 and 84 then 6  
  when n.fila between 85 and 98 then 7  
  when n.fila between 99 and 112 then 8  
  when n.fila between 113 and 126 then 9  
  when n.fila between 127 and 140 then 10   
  when n.fila between 141 and 154 then 11  
  when n.fila between 155 and 168 then 12  
  when n.fila between 169 and 182 then 13  
  when n.fila between 183 and 196 then 14  
  when n.fila between 197 and 210 then 15  
  when n.fila between 211 and 224 then 16  
  when n.fila between 225 and 238 then 17  
  when n.fila between 239 and 252 then 18  
  when n.fila between 253 and 266 then 19  
  when n.fila between 280 and 284 then 20 end as reset_count,  
 rn.precio,  
 rn.IdIva,  
rn.Cantidad,  
rn.TipoUnidad,  
rn.total,  
zz.Lote  
FROM  
    vPers_Numeros_CR2_IL n WITH (NOLOCK)  
LEFT JOIN  
   Albaranes_Cli_Cab ac  WITH (NOLOCK)  
    ON 1=1   --  and ac.IdAlbaran=9226  
LEFT JOIN  
    vPers_RowNumbers_CR_Bundle_RLL rn WITH (NOLOCK)  
    ON n.fila = rn.RowNum AND rn.IdAlbaran = ac.IdAlbaran  
LEFT JOIN  
    Vpers_Albaranes_CR_RLL vac WITH (NOLOCK)  
    ON ac.IdAlbaran = vac.IdAlbaran   
outer apply (select pclu.Lote  
   from Pedidos_Cli_Lineas pcl WITH (NOLOCK)  
   inner join Pedidos_Cli_LineasUbic pclu WITH (NOLOCK) on pcl.IdPedido=pclu.IdPedido and pcl.IdLinea=pclu.IdLinea and pcl.IdDoc=rn.iddoc and pclu.Lote=rn.Lote  
   group by pclu.Lote) zz  
 where n.fila <= (  
 SELECT  
    CASE  
        WHEN MAX(RowNum) % 14 = 0 THEN MAX(RowNum)  
        ELSE (MAX(RowNum) / 14) * 14 + 14  
    end  
FROM  
    vPers_RowNumbers_CR_Bundle_RLL  WITH (NOLOCK)  
WHERE                 
    IdAlbaran = ac.IdAlbaran)