ALTER PROCEDURE [dbo].[pPers_DuplicarClient_PClientes_Datos_Economicos_U] 
	-- Add the parameters for the stored procedure here
	@Client_Orig T_Id_Cliente,
	@Client_Desti T_Id_Cliente,
	@IdClientNuevoPadre T_ID_Cliente = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RC int
DECLARE @IdCliente_A [dbo].[T_Id_Cliente]
DECLARE @Usuario [dbo].[T_CEESI_Usuario]
DECLARE @FechaInsertUpdate [dbo].[T_CEESI_Fecha_Sistema]
DECLARE @IdCliente [dbo].[T_Id_Cliente]
DECLARE @IdLista [dbo].[T_Id_Lista]
DECLARE @FormaPago [dbo].[T_Forma_Pago]
DECLARE @Descuento [dbo].[T_Decimal]
DECLARE @ProntoPago [dbo].[T_Decimal]
DECLARE @IdIva [dbo].[T_Id_Iva]
DECLARE @CopiasFactura [dbo].[T_Cantidad_Bulto]
DECLARE @CopiasAlbaran [dbo].[T_Cantidad_Bulto]
DECLARE @Cuenta [dbo].[T_Cuenta_Contable]
DECLARE @IdDomiciliacion [dbo].[T_Id_Domiciliacion]
DECLARE @DiaPago1 [dbo].[T_Dia_Pago]
DECLARE @DiaPago2 [dbo].[T_Dia_Pago]
DECLARE @DiaPago3 [dbo].[T_Dia_Pago]
DECLARE @Riesgo [dbo].[T_Riesgo]
DECLARE @Riesgo_Euro [dbo].[T_Riesgo]
DECLARE @IdPortes [dbo].[T_Id_Portes]
DECLARE @AlbValorado [dbo].[T_Booleano]
DECLARE @AlbPorPedido [dbo].[T_Booleano]
DECLARE @PeriodicidadPago [dbo].[T_Periodicidad_Pago]
DECLARE @MesVacaciones [dbo].[T_Mes_Vacaciones]
DECLARE @IdTransportista [dbo].[T_Id_Proveedor]
DECLARE @IdMoneda [dbo].[T_Id_Moneda]
DECLARE @NSerie [dbo].[T_Serie]
DECLARE @Precodigo varchar(255)
DECLARE @FacturarPorContacto [dbo].[T_Booleano]
DECLARE @TipoFacturacion smallint
DECLARE @RecEquivalencia [dbo].[T_Booleano]
DECLARE @SerieContrato [dbo].[T_Serie]
DECLARE @CopiasPedido smallint
DECLARE @CopiasOferta smallint
DECLARE @FacturarPorReferencia [dbo].[T_Booleano]
DECLARE @NumPedidoObligado [dbo].[T_Booleano]
DECLARE @DiasPrecioMin smallint
DECLARE @IdRegimen smallint
DECLARE @MaxFacturacion float
DECLARE @IdListaTra [dbo].[T_Id_Lista]
DECLARE @NoBloqueaRiesgo [dbo].[T_Booleano]
DECLARE @IdTipoPedido int
DECLARE @DiasCarencia smallint
DECLARE @AgruparEfectos [dbo].[T_Booleano]
DECLARE @IdListaCont [dbo].[T_Id_Lista]
DECLARE @IdTarifa [dbo].[T_Id_Tarifa]
DECLARE @IdDelegacionDto [dbo].[T_Id_Delegacion]
DECLARE @FactXContrato [dbo].[T_Booleano]
DECLARE @IdImpuestoIndirecto smallint
DECLARE @F_Nacimiento [dbo].[T_Fecha_Corta]
DECLARE @Sexo smallint
DECLARE @Asociacion smallint
DECLARE @No_Paga_Cuota [dbo].[T_Booleano]
DECLARE @Categoria smallint
DECLARE @IdProveedor [dbo].[T_Id_Proveedor]
DECLARE @F_Alta_Socio [dbo].[T_Fecha_Corta]
DECLARE @F_Baja_Socio [dbo].[T_Fecha_Corta]
DECLARE @Aportacion_Socio float
DECLARE @AplicarLeyMorosidad [dbo].[T_Booleano]
DECLARE @CambioEnFactura [dbo].[T_Booleano]
DECLARE @IdMetodoPrecio smallint
DECLARE @IdGrupoRet int
DECLARE @IvaDefecto [dbo].[T_Booleano]
DECLARE @IdLineaDescuento int
DECLARE @IdModoFacturacion smallint

select 
  @IdLista = IdLista
  ,@FormaPago = FormaPago
  ,@Descuento = Descuento
  ,@ProntoPago = ProntoPago
  ,@IdIva = IdIva
  ,@CopiasFactura = CopiasFactura
  ,@CopiasAlbaran = CopiasAlbaran
  ,@Cuenta = Cuenta
  ,@IdDomiciliacion = IdDomiciliacion
  ,@DiaPago1 = DiaPago1
  ,@DiaPago2 = DiaPago2
  ,@DiaPago3 = DiaPago3
  ,@Riesgo = Riesgo
  ,@Riesgo_Euro = Riesgo_Euro
  ,@IdPortes = IdPortes
  ,@AlbValorado = AlbValorado
  ,@AlbPorPedido = AlbPorPedido
  ,@PeriodicidadPago = PeriodicidadPago
  ,@MesVacaciones = MesVacaciones
  ,@IdTransportista = IdTransportista
  ,@IdMoneda = IdMoneda
  ,@NSerie = NSerie
  ,@Precodigo = Precodigo
  ,@FacturarPorContacto = FacturarPorContacto
  ,@TipoFacturacion = TipoFacturacion
  ,@RecEquivalencia = RecEquivalencia
  ,@SerieContrato = SerieContrato
  ,@CopiasPedido = CopiasPedido
  ,@CopiasOferta = CopiasOferta
  ,@FacturarPorReferencia = FacturarPorReferencia
  ,@NumPedidoObligado = NumPedidoObligado
  ,@DiasPrecioMin = DiasPrecioMin
  ,@IdRegimen = IdRegimen
  ,@MaxFacturacion = MaxFacturacion
  ,@IdListaTra = IdListaTra
  ,@NoBloqueaRiesgo = NoBloqueaRiesgo
  ,@IdTipoPedido = IdTipoPedido
  ,@DiasCarencia = DiasCarencia
  ,@AgruparEfectos = AgruparEfectos
  ,@IdListaCont = IdListaCont
  ,@IdTarifa = IdTarifa
  ,@IdDelegacionDto = IdDelegacionDto
  ,@FactXContrato = FactXContrato
  ,@IdImpuestoIndirecto = IdImpuestoIndirecto
  ,@F_Nacimiento = F_Nacimiento
  ,@Sexo = Sexo
  ,@Asociacion = Asociacion
  ,@No_Paga_Cuota = No_Paga_Cuota
  ,@Categoria = Categoria
  ,@IdProveedor = IdProveedor
  ,@F_Alta_Socio = F_Alta_Socio
  ,@F_Baja_Socio = F_Baja_Socio
  ,@Aportacion_Socio = Aportacion_Socio
  ,@AplicarLeyMorosidad = AplicarLeyMorosidad
  ,@CambioEnFactura = CambioEnFactura
  ,@IdMetodoPrecio = IdMetodoPrecio
  ,@IdGrupoRet = IdGrupoRet
  ,@IvaDefecto = IvaDefecto
  ,@IdLineaDescuento = IdLineaDescuento
  ,@IdModoFacturacion = IdModoFacturacion
	from Clientes_Datos_Economicos
	where IdCliente = @Client_Orig

select @IdCliente = IdCliente
  ,@IdCliente_A= IdCliente
  ,@Usuario = Usuario
  ,@FechaInsertUpdate = FechaInsertUpdate
  from Clientes_Datos_Comerciales
  where IdCliente = @Client_Desti

EXECUTE @RC = [dbo].[PClientes_Datos_Economicos_U] 
   @IdCliente_A
  ,@Usuario OUTPUT
  ,@FechaInsertUpdate OUTPUT
  ,@IdCliente OUTPUT
  ,@IdLista OUTPUT
  ,@FormaPago OUTPUT
  ,@Descuento OUTPUT
  ,@ProntoPago OUTPUT
  ,@IdIva OUTPUT
  ,@CopiasFactura OUTPUT
  ,@CopiasAlbaran OUTPUT
  ,@Cuenta OUTPUT
  ,@IdDomiciliacion OUTPUT
  ,@DiaPago1 OUTPUT
  ,@DiaPago2 OUTPUT
  ,@DiaPago3 OUTPUT
  ,@Riesgo OUTPUT
  ,@Riesgo_Euro OUTPUT
  ,@IdPortes OUTPUT
  ,@AlbValorado OUTPUT
  ,@AlbPorPedido OUTPUT
  ,@PeriodicidadPago OUTPUT
  ,@MesVacaciones OUTPUT
  ,@IdTransportista OUTPUT
  ,@IdMoneda OUTPUT
  ,@NSerie OUTPUT
  ,@Precodigo OUTPUT
  ,@FacturarPorContacto OUTPUT
  ,@TipoFacturacion OUTPUT
  ,@RecEquivalencia OUTPUT
  ,@SerieContrato OUTPUT
  ,@CopiasPedido OUTPUT
  ,@CopiasOferta OUTPUT
  ,@FacturarPorReferencia OUTPUT
  ,@NumPedidoObligado OUTPUT
  ,@DiasPrecioMin OUTPUT
  ,@IdRegimen OUTPUT
  ,@MaxFacturacion OUTPUT
  ,@IdListaTra OUTPUT
  ,@NoBloqueaRiesgo OUTPUT
  ,@IdTipoPedido OUTPUT
  ,@DiasCarencia OUTPUT
  ,@AgruparEfectos OUTPUT
  ,@IdListaCont OUTPUT
  ,@IdTarifa OUTPUT
  ,@IdDelegacionDto OUTPUT
  ,@FactXContrato OUTPUT
  ,@IdImpuestoIndirecto OUTPUT
  ,@F_Nacimiento OUTPUT
  ,@Sexo OUTPUT
  ,@Asociacion OUTPUT
  ,@No_Paga_Cuota OUTPUT
  ,@Categoria OUTPUT
  ,@IdProveedor OUTPUT
  ,@F_Alta_Socio OUTPUT
  ,@F_Baja_Socio OUTPUT
  ,@Aportacion_Socio OUTPUT
  ,@AplicarLeyMorosidad OUTPUT
  ,@CambioEnFactura OUTPUT
  ,@IdMetodoPrecio OUTPUT
  ,@IdGrupoRet OUTPUT
  ,@IvaDefecto OUTPUT
  ,@IdLineaDescuento OUTPUT
  ,@IdModoFacturacion OUTPUT
END