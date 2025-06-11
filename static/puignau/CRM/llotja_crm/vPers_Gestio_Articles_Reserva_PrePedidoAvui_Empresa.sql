ALTER view [dbo].[vPers_Gestio_Articles_Reserva_PrePedidoAvui_Empresa]
as
select  p.IdPrePedido,k.Origen,
 k.Id, k.Data, k.Article, k.Nom, k.NomFrances, k.NomCastella, k.TipusUnitat, k.Unitats, k.PreuCost, k.PreuCostBotiga, ept.PermetT1,
 k.PreuVenda1* ept.PermetT1 as PreuVenda1,
 k.PreuVenda2* ept.PermetT2 as PreuVenda2, 
 k.PreuVenda3* ept.PermetT3 as PreuVenda3,
 k.PreuVenda4* ept.PermetT4 as PreuVenda4,
 k.PreuVenda5* ept.PermetT5 as PreuVenda5,
 coalesce (case when k.origen = 'ArticleArriva' then k.PreuVenda1 
 when k.origen = 'ArticleOferta' then k.PreuVenda1 
 when k.origen = 'ArticleNevera' or k.origen = 'ArticleLlotja' then
 case TipusExcepcio 
 when 1 then k.PreuCost * PercentInc -- % Sobre cost
 when 2 then k.PreuCost + ImportInc -- € Sobre Cost
 when 3 then -- % Sobre Tarifa
	case Tarifa 
	when 1 then PreuVenda1 * PercentIncVenda
	when 2 then PreuVenda2 * PercentIncVenda
	when 3 then PreuVenda3 * PercentIncVenda
	when 4 then PreuVenda4 * PercentIncVenda
	when 5 then PreuVenda5 * PercentIncVenda
	else PreuVenda1
	end
 when 4 then ImportFix -- Preu Fix
 else PreuVenda1
 end
 else precio.precio end, precio.precio) as PreuMinimAplicable,
 cc.P_TipusABC,
 k.PreuVenda1Minim, k.PreuVendaBotiga, k.Descte2, k.Descte3, k.Descte4, k.Descte5, k.IncT2, k.PreuVendaT2, k.Bloquejat, k.PendentArribar, k.KgsPerFardo, k.KgsPerPeca, k.PecesPerFardo, k.Kgs, k.UnitatMesura, k.PreuCostTotal, k.ConversioKgs, k.TipusLiquidacio, k.TipusMotiu,  convert(varchar(100),k.Motiu) as Motiu, k.CasellaCompra, k.Avis, k.AmbAlbara, k.Visible, k.UltimPreuVenda1, k.VeureComentarisMBCN, k.EsOferta, k.NomArticleClient, k.Comentaris, k.Grup, k.OrigenPreu, k.OrigenCarrega, k.Marge, k.Marge2, k.Marge3, k.Marge4, k.Marge5, k.UnitatsReservades
,
CONCAT(p.IdPrePedido,'-',k.Origen,'-',k.Id) as CustomId,vvv.Num as NumOrigen, Unitats-UnitatsReservades as Queden,

kk.Comanda as Comanda , case when k.Origen = 'ArticleNevera' and k.Grup = 0 then 'NEV' WHEN  k.Origen = 'ArticleNevera' and k.Grup = 1 THEN 'TOP' ELSE '' end AS NomGrup,
case when k.Comentaris is null or ltrim(rtrim( k.Comentaris )) = '' then '' else 'background-color: #ffe285 !important;' end as ColorComentaris

from [vPers_Gestio_Articles_Reserva_Empresa] k
left join Pers_PrePedido p on 1=1 and p.IdEmpresa = k.IdEmpresa
left join Clientes_Datos cd on p.IdCliente = cd.IdCliente
left join Conf_Clientes cc on p.IdCliente = cc.IdCliente
left join clientes_datos_economicos cde on cde.idcliente = cd.idcliente
LEFT JOIN [Puignau].[dbo].[ExcepcionsPermisosTipusClient] EPT ON IIF(cc.P_TipusABC='','D',cc.P_TipusABC) = EPT.TipusClient
left join [vPers_Gestio_Articles_Reserva_RelacioTaules] vvv on k.Origen = vvv.Origen
left join ( 
    select CustomIdNum, NumOrigen,Origen,a.IdPrePedido,sum(a.UnitatsAssignades) as Comanda from [vPers_Gestio_Articles_Reserva_Detall_PrePedidoAvui] a
    left join Pers_PrePedido_Lineas ppl on  a.IdPrePedido = ppl.IdPrePedido and a.OrigenTabla = ppl.OrigenTaula and a.Id = ppl.IdGestioReserva
    where IdPrePedidoLinea is not null
    group by CustomIdNum, NumOrigen,Origen,a.IdPrePedido
) kk on k.Id = kk.CustomIdNum and k.Origen = kk.Origen and p.idprepedido = kk.idprepedido
outer apply (
select precio from fPers_DamePrecio_Articulo_Delegacion_v2(k.article, cd.idcliente, cde.idlista, getdate(), null, null, cd.iddelegacion)
) as precio
left join articulos a on a.IdArticulo = k.Article
 left join Articulos_Familias subgrup on subgrup.IdFamilia = a.IdFamilia
 left join Articulos_Familias grup on grup.IdFamilia = subgrup.IdFamiliaPadre
 left join Articulos_Familias familia on familia.IdFamilia = grup.IdFamiliaPadre
 left join (select top 1 * from (select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda, ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
 from puignau..ArticlePreparaClients pugi 
	union all
	select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda, ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
	from puignaubcn..ArticlePreparaClients puba) a
	order by coalesce(Article, Subgrup, Grup, Familia)
	) as excepcionsPugiPuba on excepcionsPugiPuba.Client = cd.IdCliente 
	and (excepcionsPugiPuba.Article = k.Article 
	or excepcionsPugiPuba.Subgrup = subgrup.IdFamilia 
	or excepcionsPugiPuba.Grup = grup.IdFamilia 
	or excepcionsPugiPuba.Familia = familia.idfamilia)
where k.DATA > convert(date,dateadd(day,-10,GETDATE())) and Unitats > 0
GO


