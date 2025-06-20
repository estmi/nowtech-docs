select * 
from Pers_PrePedido_Lineas ppl
inner join Pers_PrePedido pp on pp.IdPrePedido = ppl.IdPrePedido
where 
	(ppl.IdPedido is null 
		or ppl.IdPedidoLinea = 0)
	and idestado = 2
	and Fecha_Entrega > GETDATE()