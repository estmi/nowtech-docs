ALTER VIEW vPers_Gestio_Articles_Reserva_Actius AS
WITH 
Prefs as (
SELECT
    0 as Empresa,
    LlotjaReservesActives,
    NeveraReservesActives,
    Nevera1ReservesActives,
    OfertaReservesActives,
    Llotja2ReservesActives
FROM [Puignau]..[Preferencies]
UNION ALL
SELECT
    2 as Empresa,
    LlotjaReservesActives,
    NeveraReservesActives,
    Nevera1ReservesActives,
    OfertaReservesActives,
    Llotja2ReservesActives
FROM [PuignauBCN]..[Preferencies]
)
,ButonsHTML as (
    SELECT 
    '   .status-container {
            display: flex;
            gap: 10px; /* Espacio entre elementos */
            justify-content: center; /* Centrar elementos horizontalmente */
            flex-wrap: wrap; /* Permite que los elementos pasen a la siguiente línea si no caben */
        }
        .status-box { 
            padding: 10px 15px; 
            display: inline-block; 
            border-radius: 10px; 
            font-weight: bold;
            text-align: center;
            min-width: 150px;
        }
        .green-box { 
            background-color: #98FB98; /* Verde claro */
            color: black; 
        }
        .red-box { 
            background-color: #FFCCCC; /* Rojo claro */
            color: black; 
        }' 
    AS css,

    '<div class="status-container">' + 
        CASE 
            WHEN NeveraReservesActives = 1 THEN 
                '<div class="status-box green-box">NEVERA ACTIVA</div>' 
            ELSE 
                '<div class="status-box red-box">NEVERA INACTIVA</div>' 
        END +
        CASE 
            WHEN Nevera1ReservesActives = 1 THEN 
                '<div class="status-box green-box">NEVERA TOP ACTIVA</div>' 
            ELSE 
                '<div class="status-box red-box">NEVERA TOP INACTIVA</div>' 
        END +

        CASE 
            WHEN LlotjaReservesActives = 1 THEN 
                '<div class="status-box green-box">LLOTJA ACTIVA</div>' 
            ELSE 
                '<div class="status-box red-box">LLOTJA INACTIVA</div>' 
        END +

        CASE 
            WHEN OfertaReservesActives = 1 THEN 
                '<div class="status-box green-box">LIQUIDACIONS ACTIVES</div>' 
            ELSE 
                '<div class="status-box red-box">LIQUIDACIONS INACTIVES</div>' 
        END +
    '</div>' 
    AS html,
    Prefs.*
FROM Prefs
)
SELECT IdPrePedido, css, html, LlotjaReservesActives, NeveraReservesActives, Nevera1ReservesActives, OfertaReservesActives, Llotja2ReservesActives
--====DUMMY FlexyGO====
, 1 as Unitats, cast(GETDATE() as date) as Data
--====DUMMY FlexyGO====
FROM pers_Prepedido preped
LEFT JOIN ButonsHTML ON ButonsHTML.Empresa = preped.IdEmpresa