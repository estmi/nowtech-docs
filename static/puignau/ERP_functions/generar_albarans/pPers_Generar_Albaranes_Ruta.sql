ALTER Procedure [dbo].[pPers_Generar_Albaranes_Ruta]
		@FechaPrep date,
		@FechaSal date,
		@IdRuta int

as

BEGIN TRY
begin tran

declare @IdEmpresa int
declare @IdDelegacion int
declare @Serie int
declare @Fecha Date = (select getdate())
Declare @Año int = (select year(getdate()))
Declare @IdProceso int
Declare @IdEmpleado int = (select IdEmpleado from Ahora_Sesion where IdDoc=dbo.funDameIdDocSesion())

declare Series Cursor For
select distinct SeriePedido
from vPers_Pedidos_Expediciones
where FechaPreparacion=coalesce(@FechaPrep,FechaPreparacion) and FechaSalida=coalesce(@FechaSal,FechaSalida) and IdRuta=coalesce(@IdRuta,IdRuta)

Open Series

Fetch next from Series into @Serie

While @@FETCH_STATUS=0 Begin

select @IdProceso=max(IdProceso)+1 from Ahora_Procesos_Masivos

select @IdEmpresa=d.idempresa, @IdDelegacion=d.IdDelegacion
from Series_Facturacion sf
inner join Delegaciones d on sf.IdDelegacion=d.IdDelegacion
where SerieFactura=@Serie

insert into Ahora_Procesos_Masivos(IdProceso, Descrip, Fecha, IdAccion, IdTipo, IdEmpleado, IdEstado, IdDelegacion)
select @IdProceso, concat('Generación de albaranes ',@Fecha), @Fecha, 0, 6, @IdEmpleado, 0, @IdDelegacion

delete Pedidos_Cli_Seleccion where Usuario=USER_NAME()

insert into Pedidos_Cli_Seleccion
select idpedido, USER_NAME()
from vPers_Pedidos_Expediciones
where FechaPreparacion=coalesce(@FechaPrep,FechaPreparacion) and FechaSalida=coalesce(@FechaSal,FechaSalida) and IdRuta=coalesce(@IdRuta,IdRuta)
and SeriePedido=@Serie


update Pedidos_Cli_Cabecera set RecEquivalencia = 1
where IdCliente in (select IdCliente from Clientes_Datos_Economicos where RecEquivalencia = 1) and IdPedido in (select distinct idpedido from vPers_Pedidos_Expediciones
	where FechaPreparacion=coalesce(@FechaPrep,FechaPreparacion) and FechaSalida=coalesce(@FechaSal,FechaSalida) and IdRuta=coalesce(@IdRuta,IdRuta)
	and SeriePedido=@Serie)


update pcl set pcl.IdEstado=1
from Pedidos_Cli_Seleccion pcs
inner join Pedidos_Cli_Lineas pcl on pcs.IdPedido=pcl.IdPedido and pcs.Usuario=USER_NAME() and pcl.IdEstado=0

exec Ppers_Albaran_GenerarListaPed
	1,
	null,
	1,
	null,
	@IdEmpresa,
	@Año,
	@Serie,
	@Fecha,
	0,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null, 
	null, 
	null,
	null,
	null,
	0,
	null,
	0,
	0,
	0,
	0,
	null,
	0,
	@IdProceso

	Fetch next from Series into @Serie

End

close series
deallocate series


commit tran
/*
begin tran
EXECUTE [dbo].[pPers_Aplicar_Recarrec_Clients] @FechaPrep, @FechaSal,@IdRuta
commit tran
*/
Return -1

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