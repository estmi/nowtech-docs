# Metodes a revisar

## pPers_Sync_Precios vs pPers_Sync_Precios_Delegacion

Taules promociones, promociones_detalle, listas_precios_cli y listas_precios_cli_art.
pers_tarifas_venta y pers_excepciones_venta.

### SQL Code

```sql
CREATE OR ALTER PROCEDURE [dbo].[pPers_Sync_Precios_Delegacion](@IdDelegacion T_ID_Delegacion)
AS
BEGIN TRY

begin tran

declare @IdLista int
declare @Revision varchar(10)
declare @IdEmpresa T_Id_Empresa

-- Recuperem empresa de la delegació
Select @IdEmpresa = IdEmpresa from Delegaciones Where IdDelegacion = @IdDelegacion

/*
 1. TRACTAMENT DE LES LLISTES DE PREUS

 S'actualitza les llistes de preus d'articles amb els articles de la taula Pers_Tarifas_Venta.
 Primerament es fa una còpia de les llistes existents a l'històric.
 Tot seguit s'eliminem UNICAMENT els preus passats a Pers_Tarifas_Venta i s'insereixen a Listas_Precios_Cli_Art
 Han d'existir les 5 Llistes de preus.
*/ 

-- Procés de còpia històric dels preus de cada llista.
Select @IdLista = null, @Revision = null
Select @IdLista = Pers_IdListaPrecioCliT1 from Conf_Empresas Where IdEmpresa = @IdEmpresa
Select @Revision=Revision from Listas_Precios_Cli where IdLista=@IdLista
if (@IdLista is not null) and (@Revision is not null)
begin
  Update Listas_Precios_Cli set Cerrado=1 where IdLista=@IdLista
  Exec PListas_Precios_Cli_a_Hist @IdLista, @Revision
end

Select @IdLista = null, @Revision = null
Select @IdLista = Pers_IdListaPrecioCliT2 from Conf_Empresas Where IdEmpresa = @IdEmpresa
Select @Revision=Revision from Listas_Precios_Cli where IdLista=@IdLista
if (@IdLista is not null) and (@Revision is not null)
begin
  Update Listas_Precios_Cli set Cerrado=1 where IdLista=@IdLista
  Exec PListas_Precios_Cli_a_Hist @IdLista, @Revision
end

Select @IdLista = null, @Revision = null
Select @IdLista = Pers_IdListaPrecioCliT3 from Conf_Empresas Where IdEmpresa = @IdEmpresa
Select @Revision=Revision from Listas_Precios_Cli where IdLista=@IdLista
if (@IdLista is not null) and (@Revision is not null)
begin
  Update Listas_Precios_Cli set Cerrado=1 where IdLista=@IdLista
  Exec PListas_Precios_Cli_a_Hist @IdLista, @Revision
end

Select @IdLista = null, @Revision = null
Select @IdLista = Pers_IdListaPrecioCliT4 from Conf_Empresas Where IdEmpresa = @IdEmpresa
Select @Revision=Revision from Listas_Precios_Cli where IdLista=@IdLista
if (@IdLista is not null) and (@Revision is not null)
begin
  Update Listas_Precios_Cli set Cerrado=1 where IdLista=@IdLista
  Exec PListas_Precios_Cli_a_Hist @IdLista, @Revision
end

Select @IdLista = null, @Revision = null
Select @IdLista = Pers_IdListaPrecioCliT5 from Conf_Empresas Where IdEmpresa = @IdEmpresa
Select @Revision=Revision from Listas_Precios_Cli where IdLista=@IdLista
if (@IdLista is not null) and (@Revision is not null)
begin
  Update Listas_Precios_Cli set Cerrado=1 where IdLista=@IdLista
  Exec PListas_Precios_Cli_a_Hist @IdLista, @Revision
end

-- Primer eliminem de la llista els articles de cada empresa i llista que ens venen a Pers_Tarifas_Venta
delete Listas_Precios_Cli_Art
From Listas_Precios_Cli_Art as L
Inner Join Pers_Tarifas_Venta as P on P.IdEmpresa = @IdEmpresa and P.IdLista = L.IdLista and P.IdArticulo = L.IdArticulo

-- Insertem els preus dels articles a cada llista
insert into Listas_Precios_Cli_Art(IdLista, IdArticulo, Precio, Descuento1, DesdeFecha)
select idlista, IdArticulo, Precio, Descuento, FechaDesde
from pers_tarifas_venta 
Where IdEmpresa = @IdEmpresa

/*
 2. TRACTAMENT DE LES EXCEPCIONS DE PREUS

 Es crea les Promocions i Promocions Detalls per cada excepció passada a Pers_Excepciones_Ventas
 Primerament es crea la capçalera de la Promoció assignant el client a Conf_Promociones
*/

-- Creem una nova promoció pels clients diferents trobats.
Declare @temp table (IdCliente varchar(15))
insert into @temp 
select IdCliente From Pers_Excepciones_Venta Where IdDelegacion = @IdDelegacion group by IdCliente order by IdCliente

-- Creem les promocions dels clients.
insert into Promociones(IdPromocion, Descrip, IdEmpresa, IdDelegacion)
select (select coalesce(max(IdPromocion),0) from Promociones)+ROW_NUMBER() over (order by cp.P_Idcliente), pev.IdCliente, @IdEmpresa, @IdDelegacion
from @temp pev
left join Conf_Promociones cp on pev.IdCliente=cp.P_IdCliente
left join Clientes_Datos as C on C.IdCliente = pev.IdCliente
Left Join Delegaciones as D on D.IdDelegacion = C.IdDelegacion
where cp.IdPromocion is null

-- Guardem el client dins configurable per tal de poder-lo cercar.
update cp set cp.P_IdCliente=cd.IdCliente
from Promociones p
inner join Clientes_Datos cd on p.Descrip=cd.IdCliente
inner join Conf_Promociones cp on p.IdPromocion=cp.IdPromocion

-- Guardem el nom del client dins la descripció de la promoció per poder-lo cercar.
update p set p.Descrip=concat('Cliente ', p.Descrip)
from Promociones p
inner join Clientes_Datos cd on p.Descrip=cd.IdCliente

-- Inserim les excepcions a afegir a Promociones Detalles
select cp.IdPromocion, 
IsNull((Select Max(L.IdLinea) From Promociones_Detalles as L Where L.IdPromocion = cp.IdPromocion), 0) + ROW_NUMBER() over (partition by cp.idpromocion order by cp.idpromocion) as IdLinea, pe.IdFamilia, pe.IdArticulo,
case when pe.DescuentoTarifa is not null then 7
	when pe.PorcCoste is not null then 9
	when pe.IncrementoTarifa is not null then 8
	else 6 end as IdTipo,
case when pe.DescuentoTarifa is not null then pe.DescuentoTarifa
	when pe.PorcCoste is not null then pe.PorcCoste
	when pe.IncrementoTarifa is not null then pe.IncrementoTarifa
	else pe.Precio end as ValorPromocion,
pe.FechaDesde, pe.FechaHasta, pe.Activo, pe.IdEmpleado, pe.IdEmpleadoValida, pe.Motivo, pe.promocion, pe.IdLista
into #Temp
from Pers_Excepciones_Venta pe
inner join Conf_Promociones cp on pe.IdCliente=cp.P_IdCliente
Where pe.IdDelegacion = @IdDelegacion

-- Eliminem primer les excepcions de Promociones Detalles que tenim a la taula Pers_Excepciones_Venta i que no siguin OFERTA.
Delete Promociones_Detalles
From Promociones_Detalles as D
Left Join Conf_Promociones as CP on CP.IdPromocion = D.IdPromocion
Inner Join Pers_Excepciones_Venta as E on IsNull(E.IdCliente, '') = IsNull(CP.P_IdCliente, '') and IsNull(E.IdFamilia, -1) = IsNull(D.IdFamilia, -1) and IsNull(E.IdArticulo, '') = IsNull(D.IdArticulo, '')
Where IsNull(E.Promocion, 0) = 0
and E.IdDelegacion = @IdDelegacion

-- Inserim l'excepció.
insert into Promociones_Detalles(IdPromocion,IdLinea,IdFamilia,IdArticulo,IdTipo,ValorPromocion,FechaIni,FechaFin)
select IdPromocion,IdLinea,IdFamilia,IdArticulo,IdTipo,ValorPromocion,FechaDesde,FechaHasta
from #Temp

-- Posem la línia d'excepció com a activa
update cpd set cpd.P_Activa=t.Activo, cpd.P_IdEmpSol=t.IdEmpleado, cpd.P_IdEmpVal=t.IdEmpleadoValida, cpd.P_IdLista=t.IdLista, cpd.P_Motivo=t.Motivo, cpd.P_Oferta=t.promocion
from Promociones_Detalles pd
inner join #Temp t on pd.IdPromocion=t.IdPromocion and pd.IdLinea=t.IdLinea
inner join Conf_Promociones_Detalles cpd on pd.IdPromocion=cpd.IdPromocion and pd.IdLinea=cpd.IdLinea

commit tran
		
	RETURN -1
	
END TRY
BEGIN CATCH
	IF @@TRANCOUNT >0 BEGIN
		ROLLBACK TRAN
	END
	DECLARE @CatchError NVARCHAR(MAX)
	SET @CatchError=dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
	RAISERROR(@CatchError,12,1)
	RETURN 0
END CATCH
GO
```

## Buidar taules (create methods)

### SQL Code

```sql
CREATE OR ALTER PROCEDURE [dbo].[pPers_BuidarTaulaExcepcions] 
	@IdDelegacion T_ID_Delegacion
AS
BEGIN
  Delete From Pers_Excepciones_Venta Where IdDelegacion = @IdDelegacion
END
```

```sql
CREATE OR ALTER PROCEDURE [dbo].[pPers_BuidarTaulaPreus] 
	@IdEmpresa T_ID_Empresa
AS
BEGIN
  Delete From Pers_Tarifas_Venta Where IdEmpresa = @IdEmpresa
END
```

## pPers_Actualitzar_Preus_Article vs pPers_Actualitzar_Preus_Article_NOU

```sql
CREATE PROCEDURE [dbo].[pPers_Actualitzar_Preus_Article_Nou]
@IdArticulo T_ID_Articulo,
@CanviarPreuCost bit,
@PCost numeric(18, 2), 
@PV1 numeric(18, 2), 
@PV2 numeric(18, 2), 
@PV3 numeric(18, 2), 
@PV4 numeric(18, 2), 
@PV5 numeric(18, 2),
@CanviPreuCaixa bit,
@PreuCaixa numeric(18,2),
@IdEmpresa int = 0 -- Per defecte 0, Empresa Puignau
AS
BEGIN
    -- Recuperem les 5 llistes de preus segons l'empresa.
	Declare @IdLista1 T_ID_Lista, @IdLista2 T_ID_Lista, @IdLista3 T_ID_Lista,  @IdLista4 T_ID_Lista, @IdLista5 T_ID_Lista 

	Select @IdLista1 = Pers_IdListaPrecioCliT1, @IdLista2 = Pers_IdListaPrecioCliT2, @IdLista3 = Pers_IdListaPrecioCliT3, 
	       @IdLista4 = Pers_IdListaPrecioCliT4, @IdLista5 = Pers_IdListaPrecioCliT5 From Conf_Empresas where IdEmpresa = @IdEmpresa

    -- Si l'article ja existeix dins la taula Pers_Tarifas_Venta, primer l'eliminem
    if (Select count(*) From Pers_Tarifas_Venta Where IdArticulo = @IdArticulo) > 0
	   Delete From Pers_Tarifas_Venta Where IdArticulo = @IdArticulo and IdEmpresa = @IdEmpresa

    -- Actualitzar els 5 preus de venda de l'article. Cada preu correspon al preu del client a la llista de preus
	if (Select Count(*) From Articulos as A Where A.IdArticulo = @IdArticulo and (A.IdEmpresa = -1 or A.IdEmpresa = @IdEmpresa)) > 0
	begin
   	  Insert Into Pers_Tarifas_Venta(IdLista, IdArticulo, Precio, Descuento, FechaDesde) 
	  Values (@IdLista1, @IdArticulo, @PV1, 0, '1-1-2000'), (@IdLista2, @IdArticulo, @PV2, 0, '1-1-2000'), (@IdLista3, @IdArticulo, @PV3, 0, '1-1-2000'), 
		     (@IdLista4, @IdArticulo, @PV4, 0, '1-1-2000'), (@IdLista5, @IdArticulo, @PV5, 0, '1-1-2000')
	end


	-- Canviem el preu de caixa
	If(@CanviPreuCaixa) = 1
	begin
		UPDATE Conf_Articulos set P_PreuCaixa = @PreuCaixa where IdArticulo = @IdArticulo
	end

	-- Si ens han demanat canviar el preu de cost de l'article cal actualitzar a la taula Pers_Costes_Manuales.
	IF(@CanviarPreuCost) = 1
	begin
		if exists (Select 1 From Pers_Costes_Manuales as PCM Where PCM.IdArticulo = @IdArticulo and PCM.IdEmpresa = @IdEmpresa)
		begin
		  Update Pers_Costes_Manuales 
		  Set Coste = @PCost, FechaDesde = '1-1-2000', FechaHasta = '31-12-2990'
		  From Pers_Costes_Manuales as PCM
		  Where PCM.IdArticulo = @IdArticulo and PCM.IdEmpresa = @IdEmpresa
		end
		else
		begin
		  Insert into Pers_Costes_Manuales (IdArticulo, Coste, FechaDesde, FechaHasta, IdEmpresa) Values (@IdArticulo, @PCost, '1-1-2000', '31-12-2990', @IdEmpresa)
		end
	end
RETURN -1
END
```

## pPers_Inicialitzar_Preus_A0_Empresa vs pPers_Inicialitzar_Preus_A0

```sql
CREATE PROCEDURE [dbo].[pPers_Inicialitzar_Preus_A0_Empresa]
@IdEmpresa T_Id_Empresa = 0
AS
BEGIN
	-- Obtenim llistes de treball
	Declare @IdLista1 T_ID_Lista, @IdLista2 T_ID_Lista, @IdLista3 T_ID_Lista,  @IdLista4 T_ID_Lista, @IdLista5 T_ID_Lista 

	Select @IdLista1 = Pers_IdListaPrecioCliT1, @IdLista2 = Pers_IdListaPrecioCliT2, @IdLista3 = Pers_IdListaPrecioCliT3, 
	       @IdLista4 = Pers_IdListaPrecioCliT4, @IdLista5 = Pers_IdListaPrecioCliT5 From Conf_Empresas where IdEmpresa = @IdEmpresa

    -- Eliminem les definicions dels articles de la empresa de treball
	DELETE FROM Pers_Tarifas_Venta where IdEmpresa = @IdEmpresa

    -- Inserim preus a 0 per cada article i llista
    INSERT INTO Pers_Tarifas_Venta (IdLista, IdArticulo, Precio, Descuento, FechaDesde)
    SELECT IdLista, Article as IdArticulo, 0 as Precio, 0 as Descuento, GETDATE() as FechaDesde 
    FROM vPers_Articles
    CROSS JOIN (SELECT @IdLista1 as IdLista UNION ALL
                SELECT @IdLista2 UNION ALL
                SELECT @IdLista3 UNION ALL
                SELECT @IdLista4 UNION ALL
                SELECT @IdLista5) AS Lista
    WHERE Familia IN ('PF', 'PFA', 'ECO') 
      AND DataBaixa IS NULL and (Empresa = -1 or Empresa = @IdEmpresa)

    RETURN -1;
END
```

## vpers_articles vs fpers_articles

```sql
```
