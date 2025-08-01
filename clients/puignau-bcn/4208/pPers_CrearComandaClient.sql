ALTER   PROCEDURE [dbo].[pPers_CrearComandaClient]
@Client varchar(15), 
@Data datetime,
@DataPreparacio datetime,
@DataLliurament datetime,
@ComandaPrigest int,
@Usuari T_CEESI_Usuario,
@Observacions varchar(250),
@P_IdPedido int = 0 output,
@IdDelegacio int = 0,
@Debug bit = 1
AS
BEGIN
-- La Data passada és la data de la comanda. 
-- La DataPreparació caldrà actualitzar-la a CONF_PEDIDOS_CLI.
-- La DataLliurament és el camp FechaSalida de PEDIDOS_CLI_CABECERA.
-- Cal retornar el nou núm de comanda creat.
	
	DECLARE @IdEmpresa T_Id_Empresa, @IdEmpresa_SerieCliente T_Id_Empresa, @AñoNum T_AñoNum
	DECLARE @SeriePedidoCliente int
	DECLARE @IdIva T_Id_Iva 
	DECLARE @IdLista int 
	DECLARE @FormaPagoCliente int
	Select @IdIva = IdIva, @IdLista = IdLista, @FormaPagoCliente = FormaPago, @SeriePedidoCliente = NSerie From Clientes_Datos_Economicos where IdCliente = @Client

	-- Recuperem l'empresa segons la delegació passada per paràmetre
	Select @IdEmpresa = IdEmpresa From Delegaciones Where IdDelegacion = @IdDelegacio

	-- Determinem el número de la comanda.
	select @IdEmpresa_SerieCliente = IdEmpresa, @AñoNum = AñoNum from Fun_Dame_AnyoNum_Serie(@SeriePedidoCliente,@Data, 0) --Primera variable SeriePedido, Segona variable Data i Tercera variable ha de ser 0 perque consti com a pedido
	if (@AñoNum is null) or (@AñoNum = 0)
	begin
		select @AñoNum = YEAR(@Data)
	end
	DECLARE @DescripcionPed nvarchar(100) = (select 'Cliente: '+ @Client)
	
	DECLARE @IdContacto T_Id_Contacto 
	DECLARE @IdContactoA T_Id_Contacto
	DECLARE @IdClientePadre T_Id_Cliente 
	DECLARE @IdTipoCliente int 
	Select  @IdContacto = IdContacto, @IdContactoA = IdContactoA, @IdTipoCliente = IdTipo, @IdClientePadre = Padre from Clientes_Datos where IdCliente = @Client
	DECLARE @IdContactoF T_Id_Contacto = (select top 1 IdContactoF from Clientes_Datos where IdCliente = coalesce(@IdClientePadre, @Client))
	DECLARE @RepresentanteClient int = (select IdEmpleado from Clientes_Datos_Comerciales where IdCliente = @Client)
	--ES FA EL DESCOMPTE PER LINIA I NO PER CAPÇALERA
	--DECLARE @Descuento T_Decimal = isnull((select Descuento from Clientes_Datos_Economicos where IdCliente = @Client),0)

	-- Si no hi ha sèrie al client o no coincideixen l'empresa de la sèrie del client amb l'empresa de la delegació passada per pàràmetre, prenem la per defecte de la delegació passada.
	if (@SeriePedidoCliente is null) or (@IdEmpresa <> @IdEmpresa_SerieCliente)
	begin
		select @SeriePedidoCliente = Valor from Ceesi_configuracion where Parametro = 'SERIE_PEDIDO' and IdDelegacion = @IdDelegacio
	end	

	EXEC pPedidos_Cli_Cabecera_I
		@IdPedido = @P_IdPedido output,
		@IdEmpresa = @IdEmpresa,
		@AñoNum = @AñoNum,
		@SeriePedido = @SeriePedidoCliente,
		@NumPedido = 0,
		@Fecha = @Data,
		@IdCliente = @Client,
		@Origen = NULL,
		@IdPedidoCli = NULL,
		@IdContacto = @IdContacto,
		@IdContactoA = @IdContactoA,
		@IdContactoF = @IdContactoF,
		@DescripcionPed = @DescripcionPed,
		@IdLista = @IdLista,
		@IdListaRevision = 1,
		@IdEmpleado = 0,
		@IdDepartamento = 0,
		@IdTransportista = NULL,
		@IdMoneda = 1,
		@FormaPago = @FormaPagoCliente,
		@Descuento = 0,
		@ProntoPago = 0,
		@IdPortes = 'D',
		@IdIva = @IdIva,
		@IdEstado = 0,
		@IdSituacion = 0,
		@FechaSalida = @DataLliurament,
		@Observaciones = @Observacions,
		@Comision = 0,
		@Cambio = 0,
		@CambioEuros = 1,
		@CambioBloqueado = 0,
		@Representante = @RepresentanteClient,
		@IdCentroCoste = NULL,
		@IdProyecto = NULL,
		@IdOferta = NULL,
		@Revision = NULL,
		@Inmovilizado = 0,
		@Referencia = 0,
		@RecogidaPorCli = 0,
		@ContactoLlamada = NULL,
		@Hora = NULL,
		@HoraSalida = NULL,
		@IdTipoPedido = 0,
		@RecEquivalencia = 0,
		@Bloqueado = 0,
		@IdMotivoBloqueo = NULL,
		@IdEmpleadoBloqueo = NULL,
		@IdApertura = NULL,
		@IdPedidoOrigen = 0,
		@NoCalcularPromo = 0,
		@ECommerce = 0,
		@IdTipoCli = @IdTipoCliente,
		@PedidoDirecto = 0,
		@IdDoc = NULL,
		@Usuario = @Usuari,
		@FechaInsertUpdate = @Data

	UPDATE Conf_Pedidos_Cli set Pers_DataPreparacio = @DataPreparacio, Pers_ComandaPrigest = @ComandaPrigest where IdPedido = @P_IdPedido

	DECLARE @IdDoc T_Id_Doc = (select IdDoc from Pedidos_Cli_Cabecera where IdPedido = @P_IdPedido)
	if @Debug = 1
		SELECT @P_IdPedido AS UltimIdPedido;
	RETURN
END