ALTER procedure [dbo].[pers_check_prepedido_integrity]
@IdPrePedido int, @Bach bit = 0
as
begin
    DECLARE @txt varchar(max)
    
    if (SELECT COUNT(*) FROM Pers_PrePedido_Lineas where (IdPedido is null or (IdPedidoLinea = 0 and IdPedido is not null)) and IdPrePedido = @IdPrePedido) >=1
    begin
        set @txt = concat('Aquesta comanda no ha arribat correctament. Per assegurarte de que estigui be elimina la comanda i torna-la a enviar. IdPrepedido: ', @IdPrepedido)
        EXECUTE [dbo].[ppers_insertlog] @txt, @IdPrepedido, 'IntegrityCheck_ERROR_1 @IdPrePedido'

        begin try
            -- Borrar Pedido relacionat
            EXECUTE [dbo].[ppers_insertlog] '', @IdPrepedido, 'IntegrityCheck_ERROR_DELETE @IdPrePedido'
            exec pPers_PrePedido_Borra_Pedido @IdPrePedido
            -- Enviar Preped a pedido
            EXECUTE [dbo].[ppers_insertlog] '', @IdPrepedido, 'IntegrityCheck_ERROR_RESEND @IdPrePedido'
            exec pPers_PrePedido_Inserta_Pedido @idprepedido, @Bach
        end try
        begin catch
            DECLARE @CatchError NVARCHAR(MAX)
            SET @CatchError=dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
            EXECUTE [dbo].[ppers_insertlog] @CatchError, @IdPrepedido, 'IntegrityCheck_ERROR_ONDELETE_ONRESEND @IdPrePedido'
        end catch

        if (SELECT COUNT(*) FROM Pers_PrePedido_Lineas where (IdPedido is null or (IdPedidoLinea = 0 and IdPedido is not null)) and IdPrePedido = @IdPrePedido) >=1
        begin
            EXECUTE [dbo].[ppers_insertlog] @txt, @IdPrepedido, 'IntegrityCheck_ERROR_2 @IdPrePedido'
            select concat('flexygo.msg. alert(''', @txt,''');') as JSCode
            return 0
        end
        else
        begin 
            return -1
        end
    end
    else -- Missatge Correcte
    begin
        DECLARE @IdPedido int
        select @IdPedido = idpedido from Pers_PrePedido where IdPrePedido = @IdPrepedido
        set @txt = concat('Comanda traspassada correctament. IdPrepedido: ', @IdPrepedido, ' IdPedido: ', @IdPedido)
        EXECUTE [dbo].[ppers_insertlog] @txt, @IdPrepedido, 'IntegrityCheck_OK @IdPrePedido'
        -- select concat('flexygo.msg.alert(''',@txt,''');') as JSCode
        return -1
    end
end