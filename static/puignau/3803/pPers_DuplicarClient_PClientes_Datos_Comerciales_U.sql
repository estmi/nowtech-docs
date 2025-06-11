ALTER PROCEDURE [dbo].[pPers_DuplicarClient_PClientes_Datos_Comerciales_U] 
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
DECLARE @Sector [dbo].[T_Sector]
DECLARE @CapitalSocial [dbo].[T_Precio_EURO]
DECLARE @Facturacion [dbo].[T_Precio_EURO]
DECLARE @Empleados [dbo].[T_Cantidad]
DECLARE @Origen [dbo].[T_Origen]
DECLARE @ObservacionesCom nvarchar(4000)
DECLARE @Clasificacion [dbo].[T_Clasificación]
DECLARE @Mailing bit
DECLARE @DiasTransporte [dbo].[T_Cantidad]
DECLARE @FechaEntrega bit
DECLARE @IdEmpleado [dbo].[T_Id_Empleado]
DECLARE @Zona [dbo].[T_Zona]
DECLARE @Atencion [dbo].[T_Descripcion]
DECLARE @DirEntrega [dbo].[T_Descripcion_Larga]
DECLARE @NotaAlb [dbo].[T_Booleano]
DECLARE @NotaFact [dbo].[T_Booleano]
DECLARE @TextoFactura varchar(255)
DECLARE @TextoAlbaran varchar(255)
DECLARE @ImpFactura [dbo].[T_Id_Listado]
DECLARE @ImpAlbaran [dbo].[T_Id_Listado]
DECLARE @ImpPedido [dbo].[T_Id_Listado]
DECLARE @ImpOferta [dbo].[T_Id_Listado]
DECLARE @CodigoEAN [dbo].[T_Codigo_EAN13]
DECLARE @IdAgente int
DECLARE @IdRuta int
DECLARE @IdIdioma int
DECLARE @DescripDelOrigen nvarchar(500)
DECLARE @DescripDelEstado nvarchar(500)
DECLARE @IdEstadoComercial int
DECLARE @CreadoPorId [dbo].[T_Id_Empleado]
DECLARE @FechaModificacion smalldatetime
DECLARE @ModificadoPorId [dbo].[T_Id_Empleado]
DECLARE @Departamento nvarchar(500)
DECLARE @ImporteOportunidad decimal(18,2)
DECLARE @NombreContacto nvarchar(500)
DECLARE @CargoContacto nvarchar(100)
DECLARE @TelMovilContacto nvarchar(50)
DECLARE @Certificado varchar(250)
DECLARE @Tipo_EFactura smallint
DECLARE @Tipo_Envio_EFactura smallint
DECLARE @FechaCreacion smalldatetime
DECLARE @IdTipoRelacionContacto int
DECLARE @UltimaActuacion smalldatetime
DECLARE @IdInforme_FacturaE int
DECLARE @EmailContacto [dbo].[T_E_Mail]
DECLARE @Factura_Impresa [dbo].[T_Booleano]
DECLARE @B2BAdjuntarFactura bit
DECLARE @B2BAdjuntarGesDocu bit

select 
  @Sector = Sector
  ,@CapitalSocial = CapitalSocial
  ,@Facturacion = Facturacion
  ,@Empleados = Empleados
  ,@Origen = Origen
  ,@ObservacionesCom = ObservacionesCom
  ,@Clasificacion = Clasificacion
  ,@Mailing = Mailing
  ,@DiasTransporte = DiasTransporte
  ,@FechaEntrega = FechaEntrega
  ,@IdEmpleado = IdEmpleado
  ,@Zona = Zona
  ,@Atencion = Atencion
  ,@DirEntrega = DirEntrega
  ,@NotaAlb = NotaAlb
  ,@NotaFact = NotaFact
  ,@TextoFactura = TextoFactura
  ,@TextoAlbaran = TextoAlbaran
  ,@ImpFactura = ImpFactura
  ,@ImpAlbaran = ImpAlbaran
  ,@ImpPedido = ImpPedido
  ,@ImpOferta = ImpOferta
  ,@CodigoEAN = CodigoEAN
  ,@IdAgente = IdAgente
  ,@IdRuta = IdRuta
  ,@IdIdioma = IdIdioma
  ,@DescripDelOrigen = DescripDelOrigen
  ,@DescripDelEstado = DescripDelEstado
  ,@IdEstadoComercial = IdEstadoComercial
  ,@CreadoPorId = CreadoPorId
  ,@FechaModificacion = FechaModificacion
  ,@ModificadoPorId = ModificadoPorId
  ,@Departamento = Departamento
  ,@ImporteOportunidad = ImporteOportunidad
  ,@NombreContacto = NombreContacto
  ,@CargoContacto = CargoContacto
  ,@TelMovilContacto = TelMovilContacto
  ,@Certificado = Certificado
  ,@Tipo_EFactura = Tipo_EFactura
  ,@Tipo_Envio_EFactura = Tipo_Envio_EFactura
  ,@FechaCreacion = FechaCreacion
  ,@IdTipoRelacionContacto = IdTipoRelacionContacto
  ,@UltimaActuacion = UltimaActuacion
  ,@IdInforme_FacturaE = IdInforme_FacturaE
  ,@EmailContacto = EmailContacto
  ,@Factura_Impresa = Factura_Impresa
  ,@B2BAdjuntarFactura = B2BAdjuntarFactura
  ,@B2BAdjuntarGesDocu = B2BAdjuntarGesDocu
  from Clientes_Datos_Comerciales
  where IdCliente = @Client_Orig

select @IdCliente = IdCliente
  ,@IdCliente_A= IdCliente
  ,@Usuario = Usuario
  ,@FechaInsertUpdate = FechaInsertUpdate
  from Clientes_Datos_Comerciales
  where IdCliente = @Client_Desti

EXECUTE @RC = [dbo].[PClientes_Datos_Comerciales_U] 
	@IdCliente_A
  ,@Usuario OUTPUT
  ,@FechaInsertUpdate OUTPUT
  ,@IdCliente OUTPUT
  ,@Sector OUTPUT
  ,@CapitalSocial OUTPUT
  ,@Facturacion OUTPUT
  ,@Empleados OUTPUT
  ,@Origen OUTPUT
  ,@ObservacionesCom OUTPUT
  ,@Clasificacion OUTPUT
  ,@Mailing OUTPUT
  ,@DiasTransporte OUTPUT
  ,@FechaEntrega OUTPUT
  ,@IdEmpleado OUTPUT
  ,@Zona OUTPUT
  ,@Atencion OUTPUT
  ,@DirEntrega OUTPUT
  ,@NotaAlb OUTPUT
  ,@NotaFact OUTPUT
  ,@TextoFactura OUTPUT
  ,@TextoAlbaran OUTPUT
  ,@ImpFactura OUTPUT
  ,@ImpAlbaran OUTPUT
  ,@ImpPedido OUTPUT
  ,@ImpOferta OUTPUT
  ,@CodigoEAN OUTPUT
  ,@IdAgente OUTPUT
  ,@IdRuta OUTPUT
  ,@IdIdioma OUTPUT
  ,@DescripDelOrigen OUTPUT
  ,@DescripDelEstado OUTPUT
  ,@IdEstadoComercial OUTPUT
  ,@CreadoPorId OUTPUT
  ,@FechaModificacion OUTPUT
  ,@ModificadoPorId OUTPUT
  ,@Departamento OUTPUT
  ,@ImporteOportunidad OUTPUT
  ,@NombreContacto OUTPUT
  ,@CargoContacto OUTPUT
  ,@TelMovilContacto OUTPUT
  ,@Certificado OUTPUT
  ,@Tipo_EFactura OUTPUT
  ,@Tipo_Envio_EFactura OUTPUT
  ,@FechaCreacion OUTPUT
  ,@IdTipoRelacionContacto OUTPUT
  ,@UltimaActuacion OUTPUT
  ,@IdInforme_FacturaE OUTPUT
  ,@EmailContacto OUTPUT
  ,@Factura_Impresa OUTPUT
  ,@B2BAdjuntarFactura OUTPUT
  ,@B2BAdjuntarGesDocu OUTPUT
END