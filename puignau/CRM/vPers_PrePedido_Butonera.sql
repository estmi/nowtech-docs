ALTER VIEW [dbo].[vPers_PrePedido_Butonera] AS
WITH CTE_IdAlbaran AS (
    SELECT 
        p.IdPedido,
        (SELECT TOP 1 IdAlbaran 
         FROM Pedidos_Cli_Lineas 
         WHERE IdPedido = p.IdPedido) AS IdAlbaran
    FROM 
        Pers_PrePedido p
)
SELECT 
    p.IdPrePedido, cd.idcliente,
    CASE 
        WHEN p.IdEstado <> 2 THEN
            '<div style="display: flex; align-items: center; justify-content: space-between; gap: 10px;">
                <div style="display: flex; gap: 10px;">
                    <button 
                        class="btn btn-default bg-tools saveButton" 
                        buttonid="DDCCB25F-1CF9-46DE-983C-D5D09DE46D2E" 
                        data-type="save" 
                        onclick="simulateCtrlG()" 
                        title="" 
                        tabindex="13">
                        <i class="fa fa-save" flx-fw=""></i> 
                        <span>Guardar cabecera (CTRL+G)</span>
                    </button>
                </div>
            </div>'
        ELSE ''
    END AS ButtonGuardar,
    -- CONCAT('',
    --            '<button class="btn btn-default bg-primary" buttonid="9cf04790-79ac-4a84-8ac8-9e9647303358s" data-type="new" onclick="flexygo.nav.openPage(''list'',''P_GestioArticlesReservaAvui'',''IdPrePedido = ',
				--p.IdPrePedido,''',{''IdPrePedido'': ',p.IdPrePedido,'},''modal1620x900'',false,$(this));" data-original-title="" title="" tabindex="11">
    --                <i class="flx-icon icon-fish" flx-fw=""></i> 
    --                <span>LLOTJA</span>
    --            </button>'
    --        ) as ButtonLlotja
	 CONCAT('',
                '<button class="btn btn-default bg-primary" buttonid="9cf04790-79ac-4a84-8ac8-9e9647303358s" data-type="new" onclick="
				let now = new Date();
				now.setHours(now.getHours() - 2);
				let dateString = now.toLocaleDateString(''en-GB''); 

				let filtros = `IdPrePedido = ',p.IdPrePedido,' AND DATA =  CONVERT(date,  ''${dateString}'', 103) AND Unitats > 0`;

				flexygo.nav.openPage(
				  ''list'',
				  ''P_GestioArticlesReservaAvui'',
				  filtros,
				  {''IdPrePedido'':  ',p.IdPrePedido,'},
				  ''modal1620x900'',
				  false,
				  $(this)
				);
				
				
				" data-original-title="" title="" tabindex="11">
                    <i class="flx-icon icon-fish" flx-fw=""></i> 
                    <span>LLOTJA</span>
                </button>'
            ) as ButtonLlotja
	,
    CASE 
        WHEN p.IdEstado = 1 Or p.IdEstado = 4 THEN 
            CONCAT(
                '<button class="btn btn-default ', 
                CASE 
                    WHEN p.Modo = 1 THEN 'bg-notify' 
                    ELSE 'bg-success' 
                END, 
                '" buttonid="cddb42f1-3e8c-4804-8ceb-2bd07669ed2e" data-type="process" onclick="flexygo.nav.execProcess(''Enviar_pedido'',''P_PrePedido'',''IdPrePedido = ', 
                p.IdPrePedido, 
                ''',''null'',null,''current'',false,$(this))" tabindex="12">
                    <i class="fa ', 
                CASE 
                    WHEN p.Modo = 1 THEN 'fa-envelope-o' 
                    ELSE 'fa-send-o' 
                END, 
                '" flx-fw=""></i> 
                    <span>',
                CASE 
                    WHEN p.Modo = 1 THEN 'Generar albarán (CTRL+Q)' 
                    WHEN p.Modo = 2 then 'ENVIAR P.(CTRL+Q)' 
					ELSE 'ENVIAR P.' 
                END,
                '</span>
                </button>'
            )
        ELSE ''
    END AS ButtonEnviarPedido,    
    CASE 
        WHEN p.IdEstado = 1 Or p.IdEstado = 4 THEN 
            CONCAT(
                '<button class="btn btn-default ', 
                'bg-danger', 
                '" buttonid="cddb42f1-3e8c-4804-8ceb-2bd07669ed2e" data-type="process" onclick="flexygo.nav.execProcess(''Borra_prepedido'',''P_PrePedido'',''IdPrePedido = ', 
                p.IdPrePedido, 
                ''',''null'',null,''current'',false,$(this)); flexygo.nav.openPage(''edit'',''P_PrePedido'',null,{''Modo'': ',Modo,'},''current'',false,$(this));" tabindex="12">
                    <i class="fa ', 
                 'fa fa-trash' ,
                '" flx-fw=""></i> 
                    <span>BORRAR</span>
                </button>'
            )
        ELSE ''
    END AS ButtonBorradoPedido,
	CASE 
        WHEN p.IdEstado = 1 Or p.IdEstado = 4 THEN 
            CONCAT(
                '<button class="btn btn-default ', 
                'btn-danger', 
                '" buttonid="cddb42f1-3e8c-4804-8ceb-2bd07669ed2e" data-type="process" onclick="flexygo.nav.execProcess(''Borra_prepedido'',''P_PrePedido'',''IdPrePedido = ', 
                p.IdPrePedido, 
                ''',''null'',null,''current'',false,$(this)); flexygo.nav.openPage(''edit'',''P_PrePedido_TELEV'',null,{''Modo'': ',Modo,'},''current'',false,$(this));" tabindex="12">
                    <i class="fa ', 
                 'fa fa-trash' ,
                '" flx-fw=""></i> 
                    <span>BORRAR</span>
                </button>'
            )
        ELSE ''
    END AS ButtonBorradoPedidoMod2,
    CASE 
        WHEN p.IdEstado = 1 Or p.IdEstado = 4 THEN 
            CONCAT(
                '<button class="btn btn-default ', 
                'btn-danger', 
                '" buttonid="cddb42f1-3e8c-4804-8ceb-2bd07669ed2e" data-type="process" onclick="flexygo.nav.execProcess(''Borra_prepedido'',''P_PrePedido'',''IdPrePedido = ', 
                p.IdPrePedido, 
                ''',''null'',null,''current'',false,$(this)); flexygo.nav.openPage(''edit'',''P_PrePedido_COMER'',null,{''Modo'': ',Modo,'},''current'',false,$(this));" tabindex="12">
                    <i class="fa ', 
                 'fa fa-trash' ,
                '" flx-fw=""></i> 
                    <span>BORRAR</span>
                </button>'
            )
        ELSE ''
    END AS ButtonBorradoPedidoMod3,
    
    CASE 
        WHEN p.IdEstado <> -1 and p.Modo = 1 THEN 
            CONCAT('',
                '<button class="btn btn-default bg-info" buttonid="9cf04790-79ac-4a84-8ac8-9e9647303358" data-type="new" onclick="flexygo.nav.openPage(''edit'',''P_PrePedido'',null,{''Modo'': ',Modo,'},''current'',false,$(this))" data-original-title="" title="" tabindex="11">
                    <i class="flx-icon icon-new-document" flx-fw=""></i> 
                    <span>NUEVO (CTRL+B)</span>
                </button>'
            )
        WHEN  p.IdEstado <> -1 AND  p.Modo = 2 THEN
			CONCAT('',
							'<button class="btn btn-default bg-info" buttonid="9cf04790-79ac-4a84-8ac8-9e9647303358" data-type="new" onclick="flexygo.nav.openPage(''edit'',''P_PrePedido_TELEV'',null,{''Modo'': ',Modo,'},''current'',false,$(this))" data-original-title="" title="" tabindex="11">
								<i class="flx-icon icon-new-document" flx-fw=""></i> 
								<span>NUEVO (CTRL+B)</span>
							</button>'
						)
		WHEN  p.IdEstado <> -1 AND  p.Modo = 3 THEN
			CONCAT('',
							'<button class="btn btn-default bg-info" buttonid="9cf04790-79ac-4a84-8ac8-9e9647303358" data-type="new" onclick="flexygo.nav.openPage(''edit'',''P_PrePedido_COMER'',null,{''Modo'': ',Modo,'},''current'',false,$(this))" data-original-title="" title="" tabindex="11">
								<i class="flx-icon icon-new-document" flx-fw=""></i> 
								<span>NUEVO</span>
							</button>'
						)
		ELSE ''
    END AS ButtonNuevo,
    
    CASE 
        WHEN p.IdEstado = 2 THEN
            CASE 
                WHEN cte.IdAlbaran IS NOT NULL THEN 
                    CONCAT(e.Descrip, ' IdAlbaran: ', cte.IdAlbaran)
                ELSE CONCAT(e.Descrip, ' IdPedido: ', p.IdPedido)
            END
        WHEN e.IdEstado = 1 Or e.IdEstado = 4 THEN e.Descrip
        ELSE CONCAT(e.Descrip, ' ID: ', p.IdPedido)
    END AS DescripEstado,
    
    CASE 
        WHEN cte.IdAlbaran IS NOT NULL THEN 
            CONCAT('<button class="btn btn-default" buttonid="3cea12b3-97d1-4b04-ae8d-cf5adb742304" data-type="report" onclick="flexygo.nav.viewReport(''Albaran2'',null,''P_albaran'',''Albaranes_Cli_Cab.IdAlbaran = ', 
                   cte.IdAlbaran, 
                   ''',null,null,''current'',false)" tabindex="15">
                       <span>Imprimir albarán</span>
                   </button>')
        ELSE ''
    END AS ButtonImprimirAlb,
    
    e.IdEstado,
    case WHEN p.IdEstado = 2 THEN
            CASE 
                WHEN cte.IdAlbaran IS NOT NULL THEN 
                    'ffe5b3'
            
			else e.HTML 
			end
	else e.HTML end AS HtmlColor,
    p.IdPedido,
    cte.IdAlbaran,
	CASE 
        WHEN (p.IdPedido IS NULL OR cte.IdAlbaran = '') AND (cte.idalbaran IS NULL OR cte.idalbaran = '') THEN 1
        ELSE 0
    END AS Permiteborrado,
	
	case when (cte.idalbaran is null) AND (P.IdPedido is not null) 
		THEN CONCAT ('<button class="btn btn-default bg-danger" buttonid="cddb42f1-3eAS8c-4804-8ceb-2bd076659ed2e" data-type="process" onclick="',
				'flexygo.nav.execProcess(''pPers_PrePedido_Borra_Pedido'',''P_PrePedido'',''IdPrePedido = ',P.IdPrePedido,' '',''null'',null,''current'',false,$(this)); ',
				'"
					 tabindex="12">                    
					 <i class="fa fa fa-trash" flx-fw=""></i> 
						 <span>B. PEDIDO</span>
					</button>
					'
			)
		ELSE '' end AS ButtonBorradoPedidoGenerado
	,
	case when cte.idalbaran is not null then sq.TotalMoneda else coalesce(T.TotalPrepedido,0) end as TotalPrepedido,
	case when cte.idalbaran is not null then sq.TotalIvaMoneda else (coalesce(T.TotalPrepedido,0)*1.1)+
			CASE WHEN cde.RecEquivalencia = 1 THEN ((select top 1 Recargo from  IVAs where IdIVA = 91)*TotalPrepedido)/100 ELSE 0 END 
		END as TotalPrepedidoIVAEST,
	case when 		e.PermiteTraspaso = 1 then coalesce(T.TotalPrepedido,0)	else ppre.total	end as TotalPrePedidoMod2,
	case when 		e.PermiteTraspaso = 1 then  (coalesce(T.TotalPrepedido,0)*1.1)+
			CASE WHEN cde.RecEquivalencia = 1 THEN ((select top 1 Recargo from  IVAs where IdIVA = 91)*TotalPrepedido)/100 ELSE 0 END 	else ppre.TotalIVA	end as TotalPrePedidoModIVA2
	, CONVERT(VARCHAR(50), p.Fecha_Pedido, 103) AS Fecha_Pedido
	, CONVERT(VARCHAR(50), p.Fecha_Preparacion, 103) AS Fecha_Preparacion,
	CONVERT(VARCHAR(50), p.Fecha_Entrega, 103) AS Fecha_Entrega
	, cd.Cliente 
FROM 
    Pers_PrePedido p
LEFT JOIN  (
			select coalesce(sum(TotalPrecio),0) as TotalPrepedido, idprepedido from(select TotalPrecio ,IdPrePedido,IdPrePedidoLinea from [VPers_PrePedido_Lineas_Grid_TotalPrecio_Solo])k
			group by IdPrePedido) T ON p.IdPrePedido = T.IdPrePedido
LEFT JOIN 
    Pers_PrePedido_Estados e ON p.IdEstado = e.IdEstado
LEFT JOIN Clientes_Datos_Economicos cde on p.IdCliente = cde.IdCliente
LEFT JOIN Clientes_Datos cd on p.IdCliente = cd.IdCliente
LEFT JOIN 
    CTE_IdAlbaran cte ON p.IdPedido = cte.IdPedido
left join (select TotalMoneda,TotalIvaMoneda, IdAlbaran from VDLG_Albaranes_Cli_Cab_Col) sq on cte.IdAlbaran = sq.IdAlbaran
left join (select IdPedido, total,TotalIVA,IvaTotal from VDLG_Pedidos_Cli_Cabecera_Col) ppre on p.IdPedido = ppre.IdPedido