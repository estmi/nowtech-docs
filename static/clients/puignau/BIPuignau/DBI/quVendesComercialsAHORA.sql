DECLARE @DataPedido DATETIME, @IdEmpresa int

SET @DataPedido = :Data
SET @IdEmpresa = :IdEmpresa

;WITH DadesPeix as (
select 'Fresc' as Tipus, EliminarAlbara, Article, Client, DetallPare from Puignau..ComandesPeixFresc where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000'
union all
select 'Fresc' as Tipus, EliminarAlbara, Article, Client, DetallPare from PuignauBCN..ComandesPeixFresc where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000'
union all
select 'Fresc' as Tipus, EliminarAlbara, Article, Client, DetallPare from Puignau..ComandesPeixFrescHistoric where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000'
union all
select 'Fresc' as Tipus, EliminarAlbara, Article, Client, DetallPare from PuignauBCN..ComandesPeixFrescHistoric where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000'
union all
select 'Manipulat' as Tipus, EliminarAlbara, Article, Client, DetallPare from Puignau..ComandesPeixManipulat where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000' and DetallPare = 0
union all
select 'Manipulat' as Tipus, EliminarAlbara, Article, Client, DetallPare from PuignauBCN..ComandesPeixManipulat where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000' and DetallPare = 0
union all
select 'Manipulat' as Tipus, EliminarAlbara, Article, Client, DetallPare from Puignau..ComandesPeixManipulatHistoric where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000' and DetallPare = 0
union all
select 'Manipulat' as Tipus, EliminarAlbara, Article, Client, DetallPare from PuignauBCN..ComandesPeixManipulatHistoric where DataLliurament = @DataPedido and EliminarAlbara = 1 and Article <> '00000' and DetallPare = 0
)
Select
(Case 
	When EliminarAlbara is not null and EliminarAlbara = 1 
		then 'Eliminat a Peix ' + DadesPeix.Tipus
	else '' end) as MotiuEliminacio
	, LD.*
	, @DataPedido as Fecha
	, E.Nombre as NomRepartidor
From fPers_Vendes_Dia_Comercials_Empresa(@DataPedido, @IdEmpresa) as LD
LEFT JOIN DadesPeix on DadesPeix.Client = LD.Client and DadesPeix.Article = LD.Article
left join Articulos A on A.IdArticulo = LD.Article
Left Join Empleados_Datos E on LD.Repartidor = E.IdEmpleado
where LD.Article <> '99996'
order by LD.Comercial, LD.Client
