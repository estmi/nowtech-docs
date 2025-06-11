# Update preus en calent de l'historic de CRM

## Articles tots

```sql
update pph
set pph.precioUnidad = precioart.precio

from Pers_PrePedido_Calculo_Historico pph

OUTER APPLY 
(
	SELECT Precio
	FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
	(
		pph.IdArticulo, pph.IdCliente, NULL, GETDATE(), NULL, NULL,
			(select top 1 iddelegacion from Clientes_Datos where IdCliente = pph.IdCliente)
	)
) AS PrecioArt
```

## Bundles

```sql
update pph
set pph.idarticulohijo = ac.IdArticulo,pph.IdArticuloFeina = acFeina.IdArticulo, pph.PrecioFeina=PrecioFeina.Precio , pph.PrecioUnidad = PrecioArt.Precio

from Pers_PrePedido_Calculo_Historico pph
inner join Articulos_Conjuntos ac ON ac.IdArticuloPadre = pph.IdArticulo and ac.IdArticulo not in (select Article from vPers_Articles where Familia = 'Z-TX')
inner join Articulos_Conjuntos acFeina ON acFeina.IdArticuloPadre = pph.IdArticulo and acFeina.IdArticulo  in (select Article from vPers_Articles where Familia = 'Z-TX')
OUTER APPLY 
(
	SELECT Precio
	FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
	(
		acFeina.IdArticulo, pph.IdCliente, NULL, GETDATE(), NULL, NULL,
			(select top 1 iddelegacion from Clientes_Datos where IdCliente = pph.IdCliente)
	)
) AS PrecioFeina
OUTER APPLY 
(
	SELECT Precio
	FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
	(
		ac.IdArticulo, pph.IdCliente, NULL, GETDATE(), NULL, NULL,
			(select top 1 iddelegacion from Clientes_Datos where IdCliente = pph.IdCliente)
	)
) AS PrecioArt
```
