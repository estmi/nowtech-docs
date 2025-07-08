ALTER PROCEDURE [dbo].[pPers_Gestio_Articles_Reserva_Precio]
(
    @NumOrigen      INT,
    @Id             INT, 
    @IdPrePedido    INT, 
    @Precio         NUMERIC(18,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrigenTabla VARCHAR(50);
    DECLARE @IdPrePedidoLinea INT;
    -- Obtener el nombre de la tabla de origen
    SELECT @OrigenTabla = OrigenDetall 
    FROM vPers_Gestio_Articles_Reserva_RelacioTaules 
    WHERE Num = @NumOrigen;
    -- Obtener el IdPrePedidoLinea correspondiente
    SELECT TOP 1 @IdPrePedidoLinea = ppl.IdPrePedidoLinea
    FROM [vPers_Gestio_Articles_Reserva_Detall_PrePedidoAvui] a
    INNER JOIN Pers_PrePedido_Lineas ppl 
        ON a.IdPrePedido = ppl.IdPrePedido 
        AND a.OrigenTabla = ppl.OrigenTaula 
        AND a.Id = ppl.IdGestioReserva
    WHERE a.IdPrePedido = @IdPrePedido
      and (a.idllotja = @Id or a.idnevera = @Id or a.idoferta = @Id) 
      AND a.OrigenTabla = @OrigenTabla;
if @Precio is null
	begin
		    SELECT TOP 1 @Precio = PreuVenda1
			FROM [vPers_Gestio_Articles_Reserva_PrePedidoAvui] a
			INNER JOIN Pers_PrePedido_Lineas ppl 
				ON a.IdPrePedido = ppl.IdPrePedido 
				AND a.Origen = ppl.OrigenTaula 
				AND a.Id = ppl.IdGestioReserva
			WHERE a.IdPrePedido = @IdPrePedido 
			  AND a.Id = ppl.IdGestioReserva 
			  AND a.Origen = @OrigenTabla;
	end
    -- Realizar el UPDATE si se ha encontrado un IdPrePedidoLinea válido
    IF @IdPrePedidoLinea IS NOT NULL
    BEGIN
        UPDATE Pers_PrePedido_Lineas
        SET Precio = @Precio
        WHERE IdPrePedido = @IdPrePedido 
          AND IdPrePedidoLinea = @IdPrePedidoLinea;
        select 'refreshEditGridP(); refreshButtonera();' as JSCode
    END
    ELSE
    BEGIN
        SELECT 'No se encontró la línea de pedido correspondiente.' AS Mensaje;
    END

    RETURN -1;
END;