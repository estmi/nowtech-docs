ALTER   PROCEDURE [dbo].[pPers_DuplicarClient]
	@Client_Orig T_ID_Cliente,
	@Client_Desti T_ID_Cliente,
	@IdClientNuevoPadre T_ID_Cliente = null
AS
BEGIN
  exec pPers_DuplicarClient_pClientes_DatosI @Client_Orig, @Client_Desti, @IdClientNuevoPadre
  exec pPers_DuplicarClient_InsertarDomiciliaciones @Client_Orig, @Client_Desti, @IdClientNuevoPadre
  exec pPers_DuplicarClient_PClientes_Datos_Comerciales_U @Client_Orig, @Client_Desti, @IdClientNuevoPadre
  exec pPers_DuplicarClient_PClientes_Datos_Economicos_U @Client_Orig, @Client_Desti, @IdClientNuevoPadre
  exec pPers_DuplicarClient_CopiaConfigurables @Client_Orig, @Client_Desti
END