ALTER view vPers_Gestio_Articles_Reserva_PrePedidoAvui_Empresa
as
with Excepcions as (
	select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda,
	ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
	from puignau..ArticlePreparaClients pugi 
	where getdate() between DataInici and DataFi
	union all
	select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda,
	ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
	from puignaubcn..ArticlePreparaClients puba
	where getdate() between DataInici and DataFi
	union all
	select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda,
	ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
	from puignau..Articlellotjaexcepcions pugi 
	where getdate() between DataInici and DataFi
	union all
	select TipusExcepcio, PercentInc, ImportInc, PercentIncVenda,
		ImportFix, Tarifa, Client, Article, Subgrup, Grup, Familia
	from puignaubcn..Articlellotjaexcepcions puba
	where getdate() between DataInici and DataFi),
	ExcepcionsPermisosTipusClient as (
select
    0 as Empresa
    , ept.PermetT1
    , ept.PermetT2
    , ept.PermetT3
    , ept.PermetT4
    , ept.PermetT5
    , ept.TipusClient
from Puignau..ExcepcionsPermisosTipusClient ept
union
select 
    2 as Empresa
    , ept.PermetT1
    , ept.PermetT2
    , ept.PermetT3
    , ept.PermetT4
    , ept.PermetT5
    , ept.TipusClient
from PuignauBCN..ExcepcionsPermisosTipusClient ept
)

select  p.IdPrePedido,k.Origen,
 k.Id, k.Data, k.Article, k.Nom, k.NomFrances, k.NomCastella, k.TipusUnitat, k.Unitats, k.PreuCost, k.PreuCostBotiga,
 ept.PermetT1,
 k.PreuVenda1* ept.PermetT1 as PreuVenda1,
 k.PreuVenda2* ept.PermetT2 as PreuVenda2, 
 k.PreuVenda3* ept.PermetT3 as PreuVenda3,
 k.PreuVenda4* ept.PermetT4 as PreuVenda4,
 k.PreuVenda5* ept.PermetT5 as PreuVenda5,
  coalesce (
 case 
	when k.origen = 'ArticleArriva' then k.PreuVenda1 
	when k.origen = 'ArticleOferta' then k.PreuVenda1 
	when k.origen = 'ArticleNevera' or k.origen = 'ArticleLlotja' then
		case 
			when excepcionsArt.Article is not null then
				case excepcionsArt.TipusExcepcio 
					when 1 then k.PreuCost * excepcionsArt.PercentInc / 100 + k.PreuCost -- % Sobre cost
					when 2 then k.PreuCost + excepcionsArt.ImportInc -- € Sobre Cost
					when 3 then -- % Sobre Tarifa
						case excepcionsArt.Tarifa 
							when 1 then PreuVenda1 * excepcionsArt.PercentIncVenda / 100 + PreuVenda1
							when 2 then PreuVenda2 * excepcionsArt.PercentIncVenda / 100 + PreuVenda2
							when 3 then PreuVenda3 * excepcionsArt.PercentIncVenda / 100 + PreuVenda3
							when 4 then PreuVenda4 * excepcionsArt.PercentIncVenda / 100 + PreuVenda4
							when 5 then PreuVenda5 * excepcionsArt.PercentIncVenda / 100 + PreuVenda5
						else PreuVenda1
						end
					when 4 then excepcionsArt.ImportFix -- Preu Fix
				else PreuVenda1
				end
			when excepcionsSGrup.subgrup is not null then
				case excepcionsSGrup.TipusExcepcio 
					when 1 then k.PreuCost * excepcionsSGrup.PercentInc / 100 + k.PreuCost -- % Sobre cost
					when 2 then k.PreuCost + excepcionsSGrup.ImportInc -- € Sobre Cost
					when 3 then -- % Sobre Tarifa
						case excepcionsSGrup.Tarifa 
							when 1 then PreuVenda1 * excepcionsSGrup.PercentIncVenda / 100 + PreuVenda1
							when 2 then PreuVenda2 * excepcionsSGrup.PercentIncVenda / 100 + PreuVenda2
							when 3 then PreuVenda3 * excepcionsSGrup.PercentIncVenda / 100 + PreuVenda3
							when 4 then PreuVenda4 * excepcionsSGrup.PercentIncVenda / 100 + PreuVenda4
							when 5 then PreuVenda5 * excepcionsSGrup.PercentIncVenda / 100 + PreuVenda5
						else PreuVenda1
						end
					when 4 then excepcionsSGrup.ImportFix -- Preu Fix
				else PreuVenda1
				end
			when excepcionsGrup.Grup is not null then
				case excepcionsGrup.TipusExcepcio 
					when 1 then k.PreuCost * excepcionsGrup.PercentInc / 100 + k.PreuCost -- % Sobre cost
					when 2 then k.PreuCost + excepcionsGrup.ImportInc -- € Sobre Cost
					when 3 then -- % Sobre Tarifa
						case excepcionsGrup.Tarifa 
							when 1 then (PreuVenda1 * excepcionsGrup.PercentIncVenda / 100) + PreuVenda1
							when 2 then (PreuVenda2 * excepcionsGrup.PercentIncVenda / 100) + PreuVenda2
							when 3 then (PreuVenda3 * excepcionsGrup.PercentIncVenda / 100) + PreuVenda3
							when 4 then (PreuVenda4 * excepcionsGrup.PercentIncVenda / 100) + PreuVenda4
							when 5 then (PreuVenda5 * excepcionsGrup.PercentIncVenda / 100) + PreuVenda5
						else PreuVenda1
						end
					when 4 then excepcionsGrup.ImportFix -- Preu Fix
				else PreuVenda1
				end
			when excepcionsFam.Familia is not null then
				case excepcionsFam.TipusExcepcio 
					when 1 then k.PreuCost * excepcionsFam.PercentInc / 100 + k.PreuCost -- % Sobre cost
					when 2 then k.PreuCost + excepcionsFam.ImportInc -- € Sobre Cost
					when 3 then -- % Sobre Tarifa
						case excepcionsFam.Tarifa 
							when 1 then (PreuVenda1 * excepcionsFam.PercentIncVenda / 100) + PreuVenda1
							when 2 then (PreuVenda2 * excepcionsFam.PercentIncVenda / 100) + PreuVenda2
							when 3 then (PreuVenda3 * excepcionsFam.PercentIncVenda / 100) + PreuVenda3
							when 4 then (PreuVenda4 * excepcionsFam.PercentIncVenda / 100) + PreuVenda4
							when 5 then (PreuVenda5 * excepcionsFam.PercentIncVenda / 100) + PreuVenda5
						else PreuVenda1
						end
					when 4 then excepcionsFam.ImportFix -- Preu Fix
				else PreuVenda1
				end
			else PreuVenda1
			end
 else precio.precio end
 , precio.precio) as PreuMinimAplicable,
 cc.P_TipusABC,
 k.PreuVenda1Minim, k.PreuVendaBotiga, k.Descte2, k.Descte3, k.Descte4, k.Descte5, k.IncT2, k.PreuVendaT2, k.Bloquejat, k.PendentArribar, k.KgsPerFardo, k.KgsPerPeca, k.PecesPerFardo, k.Kgs, k.UnitatMesura, k.PreuCostTotal, k.ConversioKgs, k.TipusLiquidacio, k.TipusMotiu,  convert(varchar(100),k.Motiu) as Motiu, k.CasellaCompra, k.Avis, k.AmbAlbara, k.Visible, k.UltimPreuVenda1, k.VeureComentarisMBCN, k.EsOferta, k.NomArticleClient, k.Comentaris, k.Grup, k.OrigenPreu, k.OrigenCarrega, k.Marge, k.Marge2, k.Marge3, k.Marge4, k.Marge5, k.UnitatsReservades
,
CONCAT(p.IdPrePedido,'-',k.Origen,'-',k.Id) as CustomId,vvv.Num as NumOrigen, Unitats-UnitatsReservades as Queden,

kk.Comanda as Comanda , case when k.Origen = 'ArticleNevera' and k.Grup = 0 then 'NEV' WHEN  k.Origen = 'ArticleNevera' and k.Grup = 1 THEN 'TOP' ELSE '' end AS NomGrup,
case when k.Comentaris is null or ltrim(rtrim( k.Comentaris )) = '' then '' else 'background-color: #ffe285 !important;' end as ColorComentaris,
case when k.Origen = 'ArticleOferta' then concat('<td>',REPLICATE('R', k.TipusLiquidacio), '</td>') else '' end as ColumnaRLiq,
k.IdEmpresa IdEmpresaLlotja, p.IdEmpresa IdEmpresaPrepedido,
case when k.Origen = 'ArticleArriva' then concat('background-color: ', dbo.funColorHTML(empReserva.ColorEmpresa), ' !important;') else '' end as colorArt

from [vPers_Gestio_Articles_Reserva_Empresa] k
left join Pers_PrePedido p on 1=1 and p.IdEmpresa = k.IdEmpresa 
	or (k.IdEmpresa = 0 and k.Origen = 'ArticleArriva')/* PA Girona per PUBA */
left join Clientes_Datos cd on p.IdCliente = cd.IdCliente
left join Conf_Clientes cc on p.IdCliente = cc.IdCliente
LEFT JOIN Empresa empReserva ON empReserva.IdEmpresa = k.IdEmpresa
left join clientes_datos_economicos cde on cde.idcliente = cd.idcliente
LEFT JOIN ExcepcionsPermisosTipusClient EPT ON IIF(cc.P_TipusABC='','D',cc.P_TipusABC) = EPT.TipusClient and ept.Empresa = p.IdEmpresa
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
 left join Excepcions as excepcionsArt on excepcionsArt.Client = cd.IdCliente 
	and (excepcionsArt.Article = k.Article 
	or excepcionsArt.Subgrup = null
	or excepcionsArt.Grup = null
	or excepcionsArt.Familia = null)
left join Excepcions as excepcionsSGrup on excepcionsSGrup.Client = cd.IdCliente 
	and (excepcionsSGrup.Article = null 
	or excepcionsSGrup.Subgrup = subgrup.IdFamilia 
	or excepcionsSGrup.Grup = null 
	or excepcionsSGrup.Familia = null)
left join Excepcions as excepcionsGrup on excepcionsGrup.Client = cd.IdCliente 
	and (excepcionsGrup.Article = null
	or excepcionsGrup.Subgrup = null
	or excepcionsGrup.Grup = grup.IdFamilia 
	or excepcionsGrup.Familia = null)
left join Excepcions as excepcionsFam on excepcionsFam.Client = cd.IdCliente 
	and (excepcionsFam.Article = null or excepcionsFam.Subgrup = null 
	or excepcionsFam.Grup = null or excepcionsFam.Familia = familia.idfamilia)
where k.DATA > convert(date,dateadd(day,-10,GETDATE())) and Unitats > 0