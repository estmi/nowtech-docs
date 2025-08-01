ALTER PROCEDURE [dbo].[pPers_PrePedido_Inserta_Pedido]
    @IdPrePedido INT,
    @Bach BIT = 0,
    @Debug bit = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage VARCHAR(500) = '';
    DECLARE @Registros INT = 0;
    DECLARE @pPedido INT = 0;
    DECLARE @pIdAlbaran INT = NULL;
    DECLARE @TranStarted BIT = 0;
    SEt @ErrorMessage = concat('Traspassar Comanda PrePed: ', @IdPrePedido)
    exec ppers_insertlog @msg = @ErrorMessage, @idobj = @IdPrePedido, @Obj = '[pPers_PrePedido_Inserta_Pedido] Pers_Prepedido inici'
  exec [pPers_PrePedido_Actualizador_Estados]
  if (select count(*) from Pers_PrePedido where IdPrePedido = @IdPrePedido and IdPedido is null )>0
  begin
        ------------------------------------------------------------------------
        -- 1) Obtener datos del PrePedido
        ------------------------------------------------------------------------
        DECLARE @IdCliente VARCHAR(50), 
                @fechaPedido DATE, 
                @fechaprep DATE, 
                @fechaentrega DATE,
                @usuari VARCHAR(50), 
                @Observacion VARCHAR(50),
                @ObservacionLarga VARCHAR(50),
                @PermiteTraspaso BIT,
                @albseparat BIT,
                @idempleado INT,
                @Modo INT,
				@IdEmpresa T_Id_empresa,
				@iddelegacion T_id_delegacion;

        SELECT @IdCliente = IdCliente,
               @fechapedido = Fecha_Pedido,
               @fechaprep = Fecha_Preparacion,
               @fechaentrega = Fecha_Entrega,
               @idempleado = IdEmpleadoPedido,
               @Modo = modo,
               @albseparat = P_AlbaranSeparado, @ObservacionLarga = Observacion, @IdEmpresa = IdEmpresa
        FROM Pers_PrePedido
        LEFT JOIN Pers_PrePedido_Estados ON Pers_PrePedido.IdEstado = Pers_PrePedido_Estados.IdEstado
        WHERE IdPrePedido = @IdPrePedido;
		set @iddelegacion = (select top 1 iddelegacion from delegaciones where IdEmpresa = @IdEmpresa)
        UPDATE Pers_PrePedido_Lineas 
        SET Precio = 0 
        WHERE IdPrePedido = @IdPrePedido AND Precio IS NULL;

        SELECT @usuari = [LOGIN] 
        FROM Empleados_Datos 
        WHERE IdEmpleado = @idempleado;

        IF (@usuari IS NULL OR @usuari = 'NOLOGIN')
        BEGIN
            SELECT @usuari = CONCAT('IdEmpleado: ', @idempleado);
        END;
		--if (select count(*) from Pers_PrePedido where IdPrePedido = @IdPrePedido and IdPedido is null)>0
		--begin
		--	SET @PermiteTraspaso = 0
		--END
        IF (@PermiteTraspaso = 0)
        BEGIN
          --  SELECT 1;
          SEt @ErrorMessage = ''
        END
        ELSE
        BEGIN
            ------------------------------------------------------------------------
            -- 2) Insertar cabecera del pedido
            ------------------------------------------------------------------------
            EXEC [dbo].[pPers_CrearComandaClient]
                @Client = @IdCliente,       
                @Data = @fechapedido,     
                @DataPreparacio = @fechaprep,       
                @DataLliurament = @fechaentrega,    
                @ComandaPrigest = NULL,             
                @Usuari = @usuari,          
                @Observacions = @Observacion,
                @P_IdPedido = @pPedido OUTPUT,
				@iddelegacio = @iddelegacion,
                @Debug = @Debug;	

            -- Assignem IdPedido per prevenir el reenviament de pedido
            UPDATE Pers_PrePedido
            SET IdPedido = @pPedido, IdEstado = 2
            WHERE IdPrePedido = @IdPrePedido;

            DECLARE @rec BIT;
            SET @rec = (SELECT TOP 1 RecEquivalencia FROM Clientes_Datos_Economicos WHERE IdCliente = @IdCliente);

            UPDATE Pedidos_Cli_Cabecera 
            SET IdEmpleado = @idempleado, RecEquivalencia = @rec , Observaciones = @ObservacionLarga
            WHERE IdPedido = @pPedido;

            UPDATE Conf_Pedidos_Cli 
            SET P_AlbaranSeparado = @albseparat 
            WHERE IdPedido = @pPedido;

            UPDATE Pers_PrePedido
            SET IdPedido = @pPedido 
            WHERE IdPrePedido = @IdPrePedido;

            DELETE FROM Pers_PrePedido_Lineas 
            WHERE IdPrePedido = @IdPrePedido 
                AND (Cantidad = 0 OR Cantidad IS NULL OR IdArticulo IS NULL OR IdArticulo = '');

			
				
			--if (@Modo > 1)
			--begin
   --         UPDATE Pers_PrePedido_Lineas
   --         SET Precio = 0
			--WHERE IdPrePedido = @IdPrePedido and IdArticulo in (select IdArticuloPadre from Articulos_Conjuntos) --TREIEM PREUS PARES BUNDLE
					
			--end

            ------------------------------------------------------------------------
            -- 3) Insertar líneas del pedido
            ------------------------------------------------------------------------
            DECLARE @TablaTemporal TABLE (ActualIdDoc INT);
            INSERT INTO @TablaTemporal (ActualIdDoc) 
            SELECT iddoc FROM Pers_PrePedido_Lineas WHERE IdPrePedido = @IdPrePedido;

            WHILE (SELECT COUNT(*) FROM @TablaTemporal) > 0
            BEGIN
                DECLARE @iddocprepedidolinea INT;
                SET @iddocprepedidolinea = (SELECT TOP 1 ActualIdDoc FROM @TablaTemporal);

                DECLARE @CurrentArticle VARCHAR(50),
                        @CurrentQuantitatPres DECIMAL(18,2),
                        @CurrentTipoUnidadPres VARCHAR(10),
                        @CurrentTipusObs int,
                        @CurrentPreuVenda DECIMAL(18,2),
                        @CurrentPreuVendaFeina DECIMAL(18,2),
                        @CurrentUsuari VARCHAR(50),
                        @CurrentObservs VARCHAR(250),
                        @CurrentFixarPreuVenda BIT,
                        @CurrentPreuFixatPrePedido BIT,
						@currentReservaLlotja int,
						@currentORIGENReservaLlotja varchar(25),
						@currentIdGestioReserva int,
                        @pIdlinea INT = 0;

                SELECT @CurrentArticle = IdArticulo,
                       @CurrentQuantitatPres = Cantidad,
                       @CurrentTipoUnidadPres = TipoUnidad,
                       @CurrentPreuVenda = Precio,---PrecioFeina,
                       @CurrentUsuari = @usuari, 
					   @CurrentTipusObs = TipoObservacion, 
					   @CurrentObservs = Observacion,
					   @CurrentFixarPreuVenda = 0,
					   @CurrentPreuFixatPrePedido = PreuFixat,
					   @currentReservaLlotja = IdOrigenReserva,
					   @currentIdGestioReserva = IdGestioReserva,

					   @currentORIGENReservaLlotja = 
					   (CASE IdOrigenReserva
						when 1 then '[RT LLOT]' 
						when 2 then  '[RT NEV]'
						when 3 then  '[RT PA]'
						when 4 then  '[RT LIQ]'
						else  ''
					END),
							
						
					   @CurrentPreuVendaFeina = PrecioFeina
                FROM Pers_PrePedido_Lineas
                WHERE iddoc = @iddocprepedidolinea;

				
				if @currentReservaLlotja is null
				begin
					set @currentReservaLlotja = 0
				end 

				if (@CurrentPreuFixatPrePedido = 1)
				begin
					set @CurrentFixarPreuVenda = 1
				end
				if (@Modo = 1) or (@Modo = 3) or (@currentReservaLlotja is not null and @currentReservaLlotja != 0)
				begin
					set @CurrentFixarPreuVenda = 1
				end
				if (@Modo > 1) AND ( (@CurrentTipoUnidadPres IS NULL) or @CurrentTipoUnidadPres ='')--CORRETGIM SI NO TE TIPUS UNITAT
				BEGIN
					SET  @CurrentTipoUnidadPres = (SELECT IdTipoUnidadPres FROM Articulos WHERE IdArticulo = @CurrentArticle)
				END
				
				if @CurrentTipoUnidadPres = 'KGS'
				begin
					set @CurrentTipoUnidadPres = 'KG'
				end
				
				if @CurrentPreuVenda is null
				begin
					set @CurrentPreuVenda = 0
				end

				if @CurrentPreuVendaFeina is null
				begin
					set @CurrentPreuVendaFeina = 0
				end

				if (@CurrentPreuVendaFeina = 0) and ((select dbo.[fPers_EsArticlePareBundle](@CurrentArticle))=1)
				begin
					declare @idarticlefill varchar(50)
					select @idarticlefill = (select top 1 IdArticulo from Articulos_Conjuntos where IdArticuloPadre = @CurrentArticle and IdArticulo not in
							(select  IdArticulo from [dbo].[vPers_Articles_Simplificado] where Familia not in ('XX','Z-TX','ZA-TX')))
					
					set @CurrentPreuVendaFeina = (select top 1 precio from [dbo].[fPers_DamePrecio_Articulo_Delegacion](null,@IdCliente,null,getdate(),null,null, (Select IdDelegacion from clientes_datos where idcliente = @idcliente)))
				end

				/* NOU MANTENIMENT 28-05-2025 */
				IF @CurrentPreuVendaFeina = 0
				BEGIN
					DECLARE @IdArticleFeina varchar(50)
					SELECT @IdArticleFeina = (SELECT TOP 1 IdArticulo FROM Articulos_Conjuntos WHERE IdArticuloPadre = @CurrentArticle
					AND ([dbo].[fPers_EsArticleFeina](IdArticulo)) = 1)

					SET @CurrentPreuVendaFeina = (SELECT TOP 1 Precio FROM [dbo].[fPers_DamePrecio_Articulo_Delegacion](@IdArticleFeina, @IdCliente, 
					1, GETDATE(), NULL, NULL, (Select IdDelegacion from clientes_datos where idcliente = @idcliente))) 
				END
                begin try
                EXEC [dbo].[pPers_CrearLiniaComanda]
                    @IdPedido = @pPedido,
					@IdAlbaran = null,
                    @Article = @CurrentArticle,
                    @Quantitat = 0,
                    @TipoUnidadPres = @CurrentTipoUnidadPres,
                    @QuantitatPres = @CurrentQuantitatPres,
                    @FixarPreuVenda = 1,
                    @PreuVenda = @CurrentPreuVenda,
                    @PreuFeina = @CurrentPreuVendaFeina,
                    @DetallComandaPrigest = null,
                    @TipusObs = @CurrentTipusObs,
                    @Observacions = @CurrentObservs,
					@TipusReservaLlotja = @currentReservaLlotja,
					@IdReservaLlotja = @currentIdGestioReserva,
					@OrigenReservaLlotja = @currentORIGENReservaLlotja,
					@IdOrigen = 100,
                    @Usuari = @CurrentUsuari,
					@IdArticuloCanviArticle = null,
					@IdDocCanviArticlePreparacio = null,
                    @P_IdLinea = @pIdlinea OUTPUT,
                    @Debug = @Debug;
                end try
                begin catch 
                DECLARE @CatchError NVARCHAR(MAX)
				SET @CatchError = dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
                SET @CatchError = concat(cast(ERROR_LINE() as varchar),@CatchError)
				exec ppers_insertlog @msg = CatchError, @idobj = @iddocprepedidolinea, @Obj = '[pPers_PrePedido_Inserta_Pedido] Pers_Prepedido_linia IdDOC 1'
                end catch
                begin try
                UPDATE Pers_PrePedido_Lineas
                SET IdPedidoLinea = @pIdlinea, IdPedido = @pPedido
                WHERE iddoc = @iddocprepedidolinea;
                    end try
                begin catch 
                
				SET @CatchError=dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
                SET @CatchError = concat(cast(ERROR_LINE() as varchar),@CatchError)
				exec ppers_insertlog @msg = @CatchError, @idobj = @iddocprepedidolinea, @Obj = '[pPers_PrePedido_Inserta_Pedido] Pers_Prepedido_linia IdDOC 2'
                end catch
				if (@CurrentFixarPreuVenda = 0) and (dbo.fPers_Datapedido(@pPedido) = 0) 
				begin
					declare @ccIddoc int
					declare @ccIddocFill int
					declare @PreuArtFill DECIMAL(18,2)
					set @ccIddoc = (select top 1 iddoc from pedidos_cli_lineas where idpedido = @pPedido and idlinea = @pIdlinea )
					set @ccIddocFill = (select top 1 iddoc from pedidos_cli_lineas where iddocpadre = @ccIddoc and idarticulo in
						(select  IdArticulo from [dbo].[vPers_Articles_Simplificado] where Familia not in ('XX','Z-TX','ZA-TX')) ) --OBTENIM 
					set @PreuArtFill = (select top 1 precio from [dbo].[fPers_DamePrecio_Articulo_Delegacion]((select top 1 idarticulo from pedidos_cli_lineas where iddoc = @ccIddocFill),@IdCliente,null,getdate(),null,null, (Select IdDelegacion from clientes_datos where idcliente = @idcliente)))					
					update pedidos_cli_lineas set Precio_EURO = @PreuArtFill, PrecioMoneda = @PreuArtFill  where iddoc = @ccIddocFill
				end

                DELETE FROM @TablaTemporal WHERE ActualIdDoc = @iddocprepedidolinea;
            END;

			
			/* FER UPDATE DE LÍNIES DE FILLS PER POSAR OBSERVACIÓ DE RESERVA QUAN SIGUI EL CAS */
			IF @currentReservaLlotja > 0
			BEGIN
				DECLARE @idDocPareReserva INT
				DECLARE @LiniaFill INT
				SET @idDocPareReserva = (select top 1 iddoc from pedidos_cli_lineas where idpedido = @pPedido and idlinea = @pIdlinea )
				SET @LiniaFill = (select top 1 IdLinea from pedidos_cli_lineas where IdDocPadre = @idDocPareReserva and dbo.fPers_EsArticleFeina(IdArticulo) = 0)

				UPDATE Conf_Pedidos_Cli_Lineas
				SET P_TipusReservaLlotja = @currentReservaLlotja, P_IdReservaLlotja = @currentIdGestioReserva, P_OrigenReservaLlotja = @currentORIGENReservaLlotja
				WHERE IdPedido = @pPedido and IdLinea = @LiniaFill
			END

            ------------------------------------------------------------------------
            -- 4) Actualizar estado del pedido y generar albarán si corresponde
            ------------------------------------------------------------------------

            IF (@Modo = 1)
            BEGIN
                DECLARE @Re BIT;
                SELECT TOP 1 @Re = RecEquivalencia FROM Clientes_Datos_Economicos WHERE IdCliente = @IdCliente;

                EXEC [pPers_PrePedido_Generar_Albaran] @pPedido;

                SELECT TOP 1 @pIdAlbaran = IdAlbaran FROM Pedidos_Cli_Lineas WHERE IdPedido = @pPedido;

                UPDATE Albaranes_Cli_Cab 
                SET RecEquivalencia = @Re 
                WHERE IdAlbaran = @pIdAlbaran;

                --EXEC [pPers_PrePedido_Actualizar_Albaran] @pPedido;
            END;
        END;

    end
  exec [pPers_PrePedido_Actualizador_Estados]

	RETURN -1;
  
END;
