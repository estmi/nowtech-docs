ALTER PROCEDURE [dbo].[pPers_PrePedido_Borra_Pedido]
    @IdPrePedido INT,
	@FlexyGO bit = 1
AS
BEGIN
    SET NOCOUNT ON;
	/* a dia 25/06/2025 s'ha decidit que no es poden esborrar comandes del CRM, tiquet: */
	--A IMPLEMENTAR
	declare @idPedido int
	declare @idCliente varchar(15)

	if (select COUNT (*) from [dbo].[vPers_PrePedido_Butonera] where IdPrePedido = @IdPrePedido and IdAlbaran is null) >0
	begin
		set @idPedido = (select top 1 IdPedido from Pers_PrePedido where IdPrePedido = @IdPrePedido)
		if (@idPedido is not null)
		begin
			set @idCliente = (select top 1 IdCliente from Pedidos_Cli_Cabecera where IdPedido = @idPedido)
			set @idPedido = (select top 1 IdPedido from Pers_PrePedido where IdPrePedido = @IdPrePedido)
			INSERT INTO Pers_Pedidos_Cli_Cabecera_Del_Log(IdPedido, IdCliente, Usuario, FechaInsertUpdate, IdPrePedido)
			VALUES(@idPedido, @idCliente, 'CRM', GETDATE(), @IdPrePedido)
			delete Pedidos_Cli_Lineas where IdPedido = @idPedido
			delete Pedidos_Cli_Cabecera where IdPedido = @idPedido
			if @FlexyGO = 1
				Select 'refreshButtonera();refreshEditGridP();' as JSCode
		end
	end
	else
	begin
		Select 'flexygo.msg.alert(''No es poden borrar comandes amb albarà generat.'');' as JSCode
	end
    return -1
END;