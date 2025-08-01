ALTER TRIGGER tr_Pers_PrePedido_Lineas_BeforeDelete
ON Pers_PrePedido_Lineas
after delete
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdGestioReserva INT, @OrigenTaula NVARCHAR(255),@IdPrePedido int;
    DECLARE @SQL NVARCHAR(MAX);

    -- Cursor para recorrer los registros que se van a eliminar
    DECLARE delete_cursor CURSOR FOR
    SELECT IdGestioReserva, OrigenTaula, IdPrePedido
    FROM deleted where IdGestioReserva is not null;

    OPEN delete_cursor;
    FETCH NEXT FROM delete_cursor INTO @IdGestioReserva, @OrigenTaula,@IdPrePedido;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Construimos la consulta dinámica para borrar de la tabla relacionada
        DECLARE @IDEMPRESA INT		
		SELECT @IDEMPRESA = BorrarAEmpresa FROM deleted WHERE IdPrePedido = @IdPrePedido AND BorrarAEmpresa IS NOT NULL	
		if (@IDEMPRESA is null)
		begin
			SELECT @IDEMPRESA = IdEmpresa FROM Pers_PrePedido WHERE IdPrePedido = @IdPrePedido		
		end
			--insert into Pers_Debug (t) select concat('delete ', @OrigenTaula,' ',@IdGestioReserva ,' ', @IDEMPRESA)
		if (@IDEMPRESA = 2)
		begin
			If @OrigenTaula = 'ArticleArrivaReserves' 
			begin
				DECLARE @IdLlotja int, @IdLlotjaGirona int, @IdComandaRel int

				Select @IdLlotja = aar.IdLlotja, @IdLlotjaGirona = IdLlotjaGirona, @IdComandaRel = IDComandaRel
				FROM PuignauBCN..ArticleArriva aa
				Left join PuignauBCN..ArticleArrivaReserves aar on aar.IdLlotja = aa.id
				where aar.id = @IdGestioReserva

				if @IdLlotjaGirona is not null /* Borrem comanda Girona -> PUBA */
				begin
					exec pPers_PrePedido_Borra_Pedido @IdComandaRel, 0
					exec pPers_PrePedido_Borra_PrePedido @IdComandaRel
					delete from PuignauBCN..ArticleArriva where Id = @IdLlotja
				end
			end
			SET @SQL = 'DELETE FROM [PuignauBCN].[dbo].' + QUOTENAME(@OrigenTaula) + ' WHERE Id = '+convert(varchar(10),@IdGestioReserva)+'';
			-- Ejecutamos la consulta dinámica
			insert into Pers_Debug (t) select concat('delete ', @OrigenTaula,' ',@IdGestioReserva )
			EXEC sp_executesql @SQL, N'@IdGestioReserva INT', @IdGestioReserva;

		end
		else if (@IDEMPRESA = 0)
		begin
			SET @SQL = 'DELETE FROM [Puignau].[dbo].' + QUOTENAME(@OrigenTaula) + ' WHERE Id = '+convert(varchar(10),@IdGestioReserva)+'';
			-- Ejecutamos la consulta dinámica
			EXEC sp_executesql @SQL, N'@IdGestioReserva INT', @IdGestioReserva;
		end
        FETCH NEXT FROM delete_cursor INTO @IdGestioReserva, @OrigenTaula,@IdPrePedido;
    END;

    CLOSE delete_cursor;
    DEALLOCATE delete_cursor;

END;