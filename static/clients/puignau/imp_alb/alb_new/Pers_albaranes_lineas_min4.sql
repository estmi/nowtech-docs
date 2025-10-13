ALTER view [dbo].[Pers_albaranes_lineas_min4] as    
SELECT
    CAST(ac.IdAlbaran AS varchar) + s.Sufijo as Ord,  
    rn.IdLinea,  
    rn.iddoc,  
    n.fila,  
    ac.idalbaran ,  --((ROW_NUMBER() OVER (PARTITION BY vac.Ord ORDER BY Ord,fila) - 1) / 14) + 1 AS reset_count  ,    
    n.reset_count,  
    rn.precio,  
    rn.IdIva,  
    rn.Cantidad,  
    rn.TipoUnidad,  
    rn.total,  
    rn.Lote  
FROM  
    vPers_Numeros_CR2_IL n WITH (NOLOCK)  
LEFT JOIN  
   Albaranes_Cli_Cab ac  WITH (NOLOCK)  
    ON 1=1   --  and ac.IdAlbaran=9226  
LEFT JOIN  
    vPers_RowNumbers_CR_Bundle_RLL rn WITH (NOLOCK)  
    ON n.fila = rn.RowNum AND rn.IdAlbaran = ac.IdAlbaran  
CROSS JOIN 
    (VALUES ('A'), ('B')) AS s(Sufijo)
 where n.fila <= (
    SELECT COUNT(1) / 14 * 14 + 14 FROM Pedidos_Cli_Lineas PedCliLin WITH (NOLOCK)  
    WHERE PedCliLin.IdAlbaran = ac.IdAlbaran)