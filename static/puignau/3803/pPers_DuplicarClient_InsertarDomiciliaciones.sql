ALTER PROCEDURE [dbo].[pPers_DuplicarClient_InsertarDomiciliaciones]
	@Client_Orig T_ID_Cliente,
	@Client_Desti T_ID_Cliente,
	@IdClientNuevoPadre T_ID_Cliente = null
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Clientes_Domiciliaciones]
           ([IdCliente]
           ,[IdDomiciliacion]
           ,[IdBanco]
           ,[IdSucursal]
           ,[CuentaCorriente]
           ,[DigitoControl]
           ,[Descrip]
           ,[FechaAlta]
           ,[FechaVencimiento]
           ,[Importe]
           ,[Importe_EURO]
           ,[Cuenta]
           ,[Credito]
           ,[Riesgo]
           ,[Credito_EURO]
           ,[Riesgo_EURO]
           ,[IBAN]
           ,[DomicExtranjera]
           ,[CuentaExtranjera]
           ,[Activa]
           ,[InsertUpdate]
           ,[Usuario]
           ,[FechaInsertUpdate])
	SELECT @Client_Desti
      ,[IdDomiciliacion]
      ,[IdBanco]
      ,[IdSucursal]
      ,[CuentaCorriente]
      ,[DigitoControl]
      ,[Descrip]
      ,[FechaAlta]
      ,[FechaVencimiento]
      ,[Importe]
      ,[Importe_EURO]
      ,[Cuenta]
      ,[Credito]
      ,[Riesgo]
      ,[Credito_EURO]
      ,[Riesgo_EURO]
      ,[IBAN]
      ,[DomicExtranjera]
      ,[CuentaExtranjera]
      ,[Activa]
      ,[InsertUpdate]
      ,[Usuario]
      ,[FechaInsertUpdate]
  FROM [dbo].[Clientes_Domiciliaciones]
  where IdCliente = @Client_Orig
  
END