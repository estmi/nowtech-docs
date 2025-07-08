ALTER   PROCEDURE [dbo].[pPers_DuplicarClient_pClientes_DatosI]
	@Client_Orig T_ID_Cliente,
	@Client_Desti T_ID_Cliente,
	@IdClientNuevoPadre T_ID_Cliente = null
AS
BEGIN
DECLARE @RC int
DECLARE @IdCompañia [dbo].[T_Id_Compañia]
DECLARE @IdCliente [dbo].[T_Id_Cliente]
DECLARE @Cliente [dbo].[T_Nombre_Corto]
DECLARE @Direccion [dbo].[T_Direccion]
DECLARE @Ciudad [dbo].[T_Ciudad]
DECLARE @Provincia [dbo].[T_Provincia]
DECLARE @CodPostal [dbo].[T_Codigo_Postal]
DECLARE @Pais [dbo].[T_Pais]
DECLARE @IdTipo [dbo].[T_Id_Tipo]
DECLARE @IdContacto int
DECLARE @IdContactoA int
DECLARE @IdContactoF int
DECLARE @NumTelefono [dbo].[T_Num_Telefono]
DECLARE @Extension [dbo].[T_Extension]
DECLARE @NumFax [dbo].[T_Num_Fax]
DECLARE @E_Mail [dbo].[T_E_Mail]
DECLARE @Web varchar(255)
DECLARE @FechaAlta [dbo].[T_Fecha_Corta]
DECLARE @Notas [dbo].[T_Notas]
DECLARE @Nif [dbo].[T_NIF]
DECLARE @Nif2 [dbo].[T_NIF]
DECLARE @Padre [dbo].[T_Id_Cliente]
DECLARE @Nivel tinyint
DECLARE @Micod varchar(15)
DECLARE @Bloqueado [dbo].[T_Booleano]
DECLARE @RazonSocial varchar(255)
DECLARE @IdContactoCliente int
DECLARE @TipoTransporte [dbo].[T_Id_TipoTransporte]
DECLARE @IdDelegacion [dbo].[T_Id_Delegacion]
DECLARE @IdPoblacion [dbo].[T_Id_Poblacion]
DECLARE @IdProvincia [dbo].[T_Id_Provincia]
DECLARE @IdPais [dbo].[T_Id_Pais]
DECLARE @Kmts [dbo].[T_Precio]
DECLARE @IdCalendario [dbo].[T_Id_Calendario]
DECLARE @IdTipoOtro [dbo].[T_Id_Tipo]
DECLARE @IdRelacion int
DECLARE @RappelsPorPlanta [dbo].[T_Booleano]
DECLARE @EsUbicacion [dbo].[T_Booleano]
DECLARE @Cliente_Contado [dbo].[T_Booleano]
DECLARE @IdMotivoBloqueo int
DECLARE @IdEmpleadoBloqueo int
DECLARE @IdContactoG [dbo].[T_Id_Contacto]
DECLARE @IdDelegacionCli [dbo].[T_Id_Delegacion]
DECLARE @ECommerce_PersonaNombre varchar(255)
DECLARE @ECommerce_PersonaApellidos varchar(255)
DECLARE @Observaciones [dbo].[T_Observaciones]
DECLARE @ECommerce_Activo bit
DECLARE @SWIN_IdVendedor1 int
DECLARE @SWIN_ComisionVendedor1 decimal(38,14)
DECLARE @SWIN_IdVendedor2 int
DECLARE @SWIN_ComisionVendedor2 decimal(38,14)
DECLARE @SWIN_IdVendedor3 int
DECLARE @SWIN_ComisionVendedor3 decimal(38,14)
DECLARE @SWIN_IdVendedor4 int
DECLARE @SWIN_ComisionVendedor4 decimal(38,14)
DECLARE @SWIN_TextoLibre1 varchar(1000)
DECLARE @SWIN_TextoLibre2 varchar(1000)
DECLARE @SWIN_TextoLibre3 varchar(1000)
DECLARE @SWIN_TextoLibre4 varchar(1000)
DECLARE @SWIN_TextoLibre5 varchar(1000)
DECLARE @SWIN_IdFormaPago int
DECLARE @SWIN_IdTipoEfecto [dbo].[T_Id_TipoEfecto]
DECLARE @SWIN_IdAgencia int
DECLARE @SWIN_PedidoPlantilla int
DECLARE @SWIN_PedidoEnviarEmail bit
DECLARE @SWIN_PedidoEmail varchar(250)
DECLARE @SWIN_PedidoReceptor varchar(250)
DECLARE @SWIN_PresupuestoPlantilla int
DECLARE @SWIN_PresupuestoEnviarEmail bit
DECLARE @SWIN_PresupuestoEmail varchar(250)
DECLARE @SWIN_PresupuestoReceptor varchar(250)
DECLARE @SWIN_AlbaranPlantilla int
DECLARE @SWIN_AlbaranEnviarEmail bit
DECLARE @SWIN_AlbaranEmail varchar(250)
DECLARE @SWIN_AlbaranReceptor varchar(250)
DECLARE @SWIN_FacturaPlantilla int
DECLARE @SWIN_FacturaEnviarEmail bit
DECLARE @SWIN_FacturaEmail varchar(250)
DECLARE @SWIN_FacturaReceptor varchar(250)
DECLARE @SWIN_Observaciones varchar(8000)
DECLARE @SWIN_VerObsEnDocumentos bit
DECLARE @FechaReclasificacion [dbo].[T_Fecha_Corta]
DECLARE @IdTipoNIF varchar(2)
DECLARE @IdDoc [dbo].[T_Id_Doc]
DECLARE @Usuario [dbo].[T_CEESI_Usuario]
DECLARE @FechaInsertUpdate [dbo].[T_CEESI_Fecha_Sistema]

Select @IdCompañia = IdCompañia
  ,@IdCliente = @Client_Desti
  ,@Cliente = Cliente
  ,@Direccion = Direccion
  ,@Ciudad = Ciudad
  ,@Provincia = Provincia
  ,@CodPostal = CodPostal
  ,@Pais = Pais
  ,@IdTipo = IdTipo
  ,@IdContacto = IdContacto
  ,@IdContactoA = IdContactoA
  ,@IdContactoF = IdContactoF
  ,@NumTelefono = NumTelefono
  ,@Extension = Extension
  ,@NumFax = NumFax
  ,@E_Mail = E_Mail
  ,@Web = Web
  ,@FechaAlta = FechaAlta
  ,@Notas = Notas
  ,@Nif = Nif
  ,@Nif2 = Nif2
  ,@Padre = coalesce(@IdClientNuevoPadre, Padre)
  ,@Nivel = Nivel
  ,@Micod = MiCod
  ,@Bloqueado = Bloqueado
  ,@RazonSocial = RazonSocial
  ,@IdContactoCliente = IdContactoCliente
  ,@TipoTransporte = TipoTransporte
  ,@IdDelegacion = IdDelegacion
  ,@IdPoblacion = IdPoblacion
  ,@IdProvincia = IdProvincia
  ,@IdPais = IdPais
  ,@Kmts = Kmts
  ,@IdCalendario = IdCalendario
  ,@IdTipoOtro = IdTipoOtro
  ,@IdRelacion = IdRelacion
  ,@RappelsPorPlanta = RappelsPorPlanta
  ,@EsUbicacion = EsUbicacion
  ,@Cliente_Contado = Cliente_Contado
  ,@IdMotivoBloqueo = IdMotivoBloqueo
  ,@IdEmpleadoBloqueo = IdEmpleadoBloqueo
  ,@IdContactoG = IdContactoG
  ,@IdDelegacionCli = IdDelegacionCli
  ,@ECommerce_PersonaNombre = ECommerce_PersonaNombre
  ,@ECommerce_PersonaApellidos = ECommerce_PersonaApellidos
  ,@Observaciones = Observaciones
  ,@ECommerce_Activo = ECommerce_Activo
  ,@SWIN_IdVendedor1 = SWIN_IdVendedor1
  ,@SWIN_ComisionVendedor1 = SWIN_ComisionVendedor1
  ,@SWIN_IdVendedor2 = SWIN_IdVendedor2
  ,@SWIN_ComisionVendedor2 = SWIN_ComisionVendedor2
  ,@SWIN_IdVendedor3 = SWIN_IdVendedor3
  ,@SWIN_ComisionVendedor3 = SWIN_ComisionVendedor3
  ,@SWIN_IdVendedor4 = SWIN_IdVendedor4
  ,@SWIN_ComisionVendedor4 = SWIN_ComisionVendedor4
  ,@SWIN_TextoLibre1 = SWIN_TextoLibre1
  ,@SWIN_TextoLibre2 = SWIN_TextoLibre2
  ,@SWIN_TextoLibre3 = SWIN_TextoLibre3
  ,@SWIN_TextoLibre4 = SWIN_TextoLibre4
  ,@SWIN_TextoLibre5 = SWIN_TextoLibre5
  ,@SWIN_IdFormaPago = SWIN_IdFormaPago
  ,@SWIN_IdTipoEfecto = SWIN_IdTipoEfecto
  ,@SWIN_IdAgencia = SWIN_IdAgencia
  ,@SWIN_PedidoPlantilla = SWIN_PedidoPlantilla
  ,@SWIN_PedidoEnviarEmail = SWIN_PedidoEnviarEmail
  ,@SWIN_PedidoEmail = SWIN_PedidoEmail
  ,@SWIN_PedidoReceptor = SWIN_PedidoReceptor
  ,@SWIN_PresupuestoPlantilla = SWIN_PresupuestoPlantilla
  ,@SWIN_PresupuestoEnviarEmail = SWIN_PresupuestoEnviarEmail
  ,@SWIN_PresupuestoEmail = SWIN_PresupuestoEmail
  ,@SWIN_PresupuestoReceptor = SWIN_PresupuestoReceptor
  ,@SWIN_AlbaranPlantilla = SWIN_AlbaranPlantilla
  ,@SWIN_AlbaranEnviarEmail = SWIN_AlbaranEnviarEmail
  ,@SWIN_AlbaranEmail = SWIN_AlbaranEmail
  ,@SWIN_AlbaranReceptor = SWIN_AlbaranReceptor
  ,@SWIN_FacturaPlantilla = SWIN_FacturaPlantilla
  ,@SWIN_FacturaEnviarEmail = SWIN_FacturaEnviarEmail
  ,@SWIN_FacturaEmail = SWIN_FacturaEmail
  ,@SWIN_FacturaReceptor = SWIN_FacturaReceptor
  ,@SWIN_Observaciones = SWIN_Observaciones
  ,@SWIN_VerObsEnDocumentos = SWIN_VerObsEnDocumentos
  ,@FechaReclasificacion = FechaReclasificacion
  ,@IdTipoNIF = IdTipoNIF
  ,@IdDoc = IdDoc
  ,@Usuario = Usuario
  ,@FechaInsertUpdate = FechaInsertUpdate
  from Clientes_Datos
  where IdCliente = @Client_Orig

EXECUTE @RC = [PClientes_Datos_I] 
   @IdCompañia OUTPUT
  ,@IdCliente OUTPUT
  ,@Cliente OUTPUT
  ,@Direccion OUTPUT
  ,@Ciudad OUTPUT
  ,@Provincia OUTPUT
  ,@CodPostal OUTPUT
  ,@Pais OUTPUT
  ,@IdTipo OUTPUT
  ,@IdContacto OUTPUT
  ,@IdContactoA OUTPUT
  ,@IdContactoF OUTPUT
  ,@NumTelefono OUTPUT
  ,@Extension OUTPUT
  ,@NumFax OUTPUT
  ,@E_Mail OUTPUT
  ,@Web OUTPUT
  ,@FechaAlta OUTPUT
  ,@Notas OUTPUT
  ,@Nif OUTPUT
  ,@Nif2 OUTPUT
  ,@Padre OUTPUT
  ,@Nivel OUTPUT
  ,@Micod OUTPUT
  ,@Bloqueado OUTPUT
  ,@RazonSocial OUTPUT
  ,@IdContactoCliente OUTPUT
  ,@TipoTransporte OUTPUT
  ,@IdDelegacion OUTPUT
  ,@IdPoblacion OUTPUT
  ,@IdProvincia OUTPUT
  ,@IdPais OUTPUT
  ,@Kmts OUTPUT
  ,@IdCalendario OUTPUT
  ,@IdTipoOtro OUTPUT
  ,@IdRelacion OUTPUT
  ,@RappelsPorPlanta OUTPUT
  ,@EsUbicacion OUTPUT
  ,@Cliente_Contado OUTPUT
  ,@IdMotivoBloqueo OUTPUT
  ,@IdEmpleadoBloqueo OUTPUT
  ,@IdContactoG OUTPUT
  ,@IdDelegacionCli OUTPUT
  ,@ECommerce_PersonaNombre OUTPUT
  ,@ECommerce_PersonaApellidos OUTPUT
  ,@Observaciones OUTPUT
  ,@ECommerce_Activo OUTPUT
  ,@SWIN_IdVendedor1 OUTPUT
  ,@SWIN_ComisionVendedor1 OUTPUT
  ,@SWIN_IdVendedor2 OUTPUT
  ,@SWIN_ComisionVendedor2 OUTPUT
  ,@SWIN_IdVendedor3 OUTPUT
  ,@SWIN_ComisionVendedor3 OUTPUT
  ,@SWIN_IdVendedor4 OUTPUT
  ,@SWIN_ComisionVendedor4 OUTPUT
  ,@SWIN_TextoLibre1 OUTPUT
  ,@SWIN_TextoLibre2 OUTPUT
  ,@SWIN_TextoLibre3 OUTPUT
  ,@SWIN_TextoLibre4 OUTPUT
  ,@SWIN_TextoLibre5 OUTPUT
  ,@SWIN_IdFormaPago OUTPUT
  ,@SWIN_IdTipoEfecto OUTPUT
  ,@SWIN_IdAgencia OUTPUT
  ,@SWIN_PedidoPlantilla OUTPUT
  ,@SWIN_PedidoEnviarEmail OUTPUT
  ,@SWIN_PedidoEmail OUTPUT
  ,@SWIN_PedidoReceptor OUTPUT
  ,@SWIN_PresupuestoPlantilla OUTPUT
  ,@SWIN_PresupuestoEnviarEmail OUTPUT
  ,@SWIN_PresupuestoEmail OUTPUT
  ,@SWIN_PresupuestoReceptor OUTPUT
  ,@SWIN_AlbaranPlantilla OUTPUT
  ,@SWIN_AlbaranEnviarEmail OUTPUT
  ,@SWIN_AlbaranEmail OUTPUT
  ,@SWIN_AlbaranReceptor OUTPUT
  ,@SWIN_FacturaPlantilla OUTPUT
  ,@SWIN_FacturaEnviarEmail OUTPUT
  ,@SWIN_FacturaEmail OUTPUT
  ,@SWIN_FacturaReceptor OUTPUT
  ,@SWIN_Observaciones OUTPUT
  ,@SWIN_VerObsEnDocumentos OUTPUT
  ,@FechaReclasificacion OUTPUT
  ,@IdTipoNIF OUTPUT
  ,@IdDoc OUTPUT
  ,@Usuario OUTPUT
  ,@FechaInsertUpdate OUTPUT
END