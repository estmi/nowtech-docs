ALTER VIEW vPers_Gestio_Articles_Reserva_Detall_PrePedidoAvui_Empresa
AS
SELECT OrigenTabla
    , Id
    , IdLlotja
    , IdNevera
    , IdOferta
    , Data
    , DataReserva
    , Persona
    , Article
    , UnitatsDemanades
    , UnitatsAssignades
    , Comentaris
    , Client
    , Preparador
    , NomPreparador
    , Ruta
    , NomRuta
    , ObservacionsComanda
    , Usuari
    , OrigenDetall
    , ComandaOrigen
    , Comanda
    , ArticlePare
    , NomArticlePare
    , LiniaComanda
    , pp.IdPrePedido
    , vgrt.Origen
    , vgrt.Num  NumOrigen
    , coalesce(coalesce(IdLlotja,IdNevera),IdOferta) CustomIdNum
    , concat(pp.IdPrePedido,'-',vgrt.Origen,'-',coalesce(coalesce(IdLlotja,IdNevera),IdOferta)) CustomId
    , d.IdEmpresa
FROM vPers_Gestio_Articles_Reserva_Detall_Empresa d
LEFT JOIN vPers_Gestio_Articles_Reserva_RelacioTaules vgrt ON d.OrigenTabla = vgrt.OrigenDetall
LEFT JOIN Pers_PrePedido pp ON d.IdEmpresa = pp.IdEmpresa 
    OR (d.IdEmpresa = 0 AND d.OrigenTabla = 'ArticleArrivaReserves')