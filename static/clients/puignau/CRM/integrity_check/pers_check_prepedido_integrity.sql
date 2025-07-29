ALTER procedure [dbo].[pers_check_prepedido_integrity]
@IdPrePedido int, @Bach bit = 0
as
begin
    DECLARE @txt varchar(max)
    
    if (SELECT COUNT(*) FROM Pers_PrePedido_Lineas where (IdPedido is null or (IdPedidoLinea = 0 and IdPedido is not null)) and IdPrePedido = @IdPrePedido) >=1
    begin
        set @txt = concat('Aquesta comanda no ha arribat correctament. Per assegurar-te que estigui bé elimina la comanda i torna-la a enviar. IdPrepedido: ', @IdPrepedido)
        EXECUTE [dbo].[ppers_insertlog] @txt, @IdPrepedido, 'IntegrityCheck_ERROR_2 @IdPrePedido'
        select concat('refreshButtonera();','refreshEditGridP();'
        , 'Swal.fire({icon: ''error'',title: ''Error d\''enviament de comanda'',theme: ''borderless'',allowOutsideClick: false,text: ''',@txt,'''});'
        ) as JSCode
        return -1
    end
    else -- Missatge Correcte
    begin
        DECLARE @IdPedido int
        select @IdPedido = idpedido from Pers_PrePedido where IdPrePedido = @IdPrepedido
        set @txt = concat('Comanda traspassada correctament. IdPrepedido: ', @IdPrepedido, ' IdPedido: ', @IdPedido)
        EXECUTE [dbo].[ppers_insertlog] @txt, @IdPrepedido, 'IntegrityCheck_OK @IdPrePedido'
        select concat('refreshButtonera();','refreshEditGridP();'
        --, 'Swal.fire({icon: ''success'',title: ''Tot Ok'',theme: ''borderless'',allowOutsideClick: false,text: ''',@txt,'''});'
        ) 
        as JSCode
        return -1
    end
end