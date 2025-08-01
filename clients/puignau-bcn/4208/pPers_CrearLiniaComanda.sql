ALTER   PROCEDURE pPers_CrearLiniaComanda
	@IdPedido T_Id_Pedido,
	@IdAlbaran T_Id_Albaran,
	@Article T_Id_Articulo,

	@Quantitat T_Decimal_2,
	@TipoUnidadPres T_Tipo_Cantidad,
	@QuantitatPres T_Decimal_2,

	@FixarPreuVenda bit,
	@PreuVenda T_Precio,
	@PreuFeina T_Precio,

	@DetallComandaPrigest int,
	@TipusObs int,
	@Observacions varchar(250),

	@TipusReservaLlotja int = -1,
	@IdReservaLlotja int = null,
	@OrigenReservaLlotja varchar(50) = null,

	@IdOrigen int,
	@Usuari T_CEESI_Usuario,
	
	@IdArticuloCanviArticle varchar(15) = null,

	@IdDocCanviArticlePreparacio int = 0,

	@P_IdLinea int = 0 output,
	@Debug bit = 1

AS
BEGIN
DECLARE @CatchError NVARCHAR(MAX)
DECLARE @ObjTxt varchar(max)
	DECLARE @Descrip nvarchar(max),
			@Precio_EURO T_Precio,
			@PrecioMoneda T_Precio,
			@FechaInsertUpdate T_CEESI_Fecha_Sistema,
			@IdAlmacen T_Id_Almacen,
			@IdIva T_Id_Iva,
			@IdDocLinea int,
			@ControlBundle bit,
			@IdOpServicios int,
			@DescuentoCliente decimal(38,14)


	SET @ControlBundle = ISNULL((select top 1 case when IdArticuloPadre = @Article then 1 else 0 end from Articulos_Conjuntos where IdArticuloPadre = @Article), 0)
	----NOU 14012025
	--IF(select IdPresentacion from Articulos where IdArticulo = @Article) is null and @ControlBundle = 0
	--BEGIN
	--	set @TipoUnidadPres = null
	--	set @Quantitat = @QuantitatPres
	--	set @QuantitatPres = 0
		
	--END

	SET @Descrip = (SELECT Descrip from Articulos where IdArticulo = @Article)
	SET @Precio_EURO = (select CASE WHEN @FixarPreuVenda = 1 AND @ControlBundle = 0 THEN ISNULL(@PreuVenda, 0) ELSE 0 END)

	SET @PrecioMoneda = (select CASE WHEN @FixarPreuVenda = 1 AND @ControlBundle = 0 THEN ISNULL(@PreuVenda, 0) ELSE 0 END)
	SET @FechaInsertUpdate = (Select GETDATE())
	
	-- (select ISNULL(@IdMesura, IdTipoUnidadPres) from Articulos where IdArticulo = @Article)
	SET @IdAlmacen = (select ISNULL(IdAlmacenPref, 0) from Articulos where IdArticulo = @Article)
	SET @IdIva = (select IdIva from Articulos where IdArticulo = @Article)

	Set @TipoUnidadPres = NullIf(@TipoUnidadPres, '')

	set @IdOpServicios = (select ISNULL(IdOpServicios, 0) from Articulos where IdArticulo = @Article)
	if @Precio_EURO is null
	begin
		set @Precio_EURO = 0
	end
	if @PrecioMoneda is null
	begin
		set @PrecioMoneda = 0
	end

	--Agafem el descompte indicat en el configurable de la fitxa de client, aquest assignarà per linia el descompte que estigui indicat
	set @DescuentoCliente = (select coalesce(P_Descompte,0) from Conf_Clientes where idcliente = (select idcliente from Pedidos_Cli_Cabecera where IdPedido= @IdPedido))
	if @DescuentoCliente is null
	begin
		set @DescuentoCliente = 0
	end
	begin try
	EXEC pPedidos_Cli_Lineas_I
		 @IdPedido = @IdPedido,
		 @IdLinea = @P_IdLinea output,
		 @IdArticulo = @Article,
		 @IdArticuloCli = NULL,
		 @IdAlmacen = @IdAlmacen,
		 @Cantidad = @Quantitat,
		 @Precio = 0,
		 @Precio_EURO = @Precio_EURO,
		 @PrecioMoneda = @PrecioMoneda,
		 @Descuento = @DescuentoCliente,
		 @IdIva = @IdIva,
		 @IdEstado = 1, /* Posem sempre les línies a IdEstado = 1 MARCADES PER ALBARANEJAR */
		 @IdSituacion = 0,
		 @IdEmbalaje = NULL,
		 @CantidadEmbalaje = 1,
		 @Observaciones = @Observacions,
		 @Descrip = @Descrip,
		 @Comision = 0,
		 @IdAlbaran = NULL,
		 @FechaAlbaran = NULL,
		 @IdFactura = NULL,
		 @FechaFactura = NULL,
		 @CantidadLotes = 0,
		 @Marca = NULL,
		 @EmbalajeFinal = NULL,
		 @CantidadEmbalajeFinal = 1,
		 @Descrip2 = NULL,
		 @PesoNeto = 0,
		 @PesoEmbalaje = 0,
		 @PesoEmbalajeFinal = 0,
		 @Orden = 0,
		 @TotalComision = 0,
		 @Path = NULL,
		 @DtoLP1 = 0,
		 @DtoLP2 = 0,
		 @DtoGD = 0,
		 @DtoMan = 0,
		 @ConjManual = 0,
		 @IdDocPadre = NULL,
		 @IdFase = NULL,
		 @IdProyecto_Produccion = NULL,
		 @CuentaArticulo = NULL,
		 @TipoUnidadPres = @TipoUnidadPres,
		 @UnidadesStock = @Quantitat,
		 @UnidadesPres = @QuantitatPres,
		 @Precio_EuroPres = 0,
		 @PrecioMonedaPres = 0,
		 @IdOrdenCarga = NULL,
		 @IdOferta = NULL,
		 @Revision = NULL,
		 @IdOfertaLinea = NULL,
		 @RefCliente = NULL,
		 @NumPlano = NULL,
		 @IdParte = NULL,
		 @IdSeguimiento = NULL,
		 @IdConceptoCertif = NULL,
		 @NumBultos = 0,
		 @IdTipoOperacion = NULL,
		 @IdFacturaCertif = 0,
		 @UdsCarga = 0,
		 @IdEmbalaje_Disp = NULL,
		 @IdOrdenRecepcion = NULL,
		 @CantRecep = 0,
		 @NumBultosFinal = 0,
		 @DtoLP3 = 0,
		 @DtoLP4 = 0,
		 @DtoLP5 = 0,
		 @UdStockCarga = 0,
		 @UdStockRecep = 0,
		 @IdMaquina = NULL,
		 @Total_Euros = 0,
		 @Total_Moneda = 0,
		 @IdMotivoIVAExento = NULL,
		 @IdOpServicios = @IdOpServicios,
		 @IdOperacionFiscal = NULL,
		 @IdRetencion = 0,
		 @ImportadoEx = 0,
		 @EsSujetoPasivo = 0,
		 @PVP = 0,
		 @PVP_Moneda = 0,
		 @Total_PVP = 0,
		 @Total_PVP_Moneda = 0,
		 @CR = NULL,
		 @IdDoc = NULL,
		 @Usuario = @Usuari,
		 @FechaInsertUpdate = @FechaInsertUpdate
		 end try
                begin catch 
                
				SET @CatchError = dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
                SET @CatchError = concat(cast(ERROR_LINE() as varchar(250)),@CatchError)
				SET @ObjTxt = concat('[pPers_CrearLiniaComanda] Pers_Prepedido_linia_1 idpedido ', cast(@IdPedido as varchar(max)), 'Idlinia ', @P_IdLinea)
				exec ppers_insertlog @msg = @CatchError, @idobj = @IdPedido, @Obj = @ObjTxt
				return 0
                end catch
		begin try
		 SET @IdDocLinea = (SELECT TOP 1 IsNull(IdDocPadre, IdDoc) FROM Pedidos_Cli_Lineas where IdPedido = @IdPedido and IdLinea = @P_IdLinea order by IdLinea DESC)
		 
		 exec ppers_AplicarOrdreAutomaticLiniaComanda @IdDocLinea
		 
		 if @ControlBundle = 1
		 begin
			declare @iddocfillAct int
			declare iddocsfills cursor for 
			select iddoc from Pedidos_Cli_Lineas where IdDocPadre = @IdDocLinea;
			OPEN iddocsfills
			FETCH NEXT FROM iddocsfills INTO @iddocfillAct  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				exec ppers_AplicarOrdreAutomaticLiniaComanda @iddocfillAct
			    FETCH NEXT FROM iddocsfills INTO @iddocfillAct  
			END 

			CLOSE iddocsfills  
			DEALLOCATE iddocsfills
		 end

		 if @Debug = 1
			select @IdDocLinea as IdDocLinea
		 
		 -- select Usuario from Pedidos_Cli_Lineas where IdDoc = @IdDocLinea

		 IF(@IdAlbaran IS NOT NULL)
		 BEGIN
          -- Crear una sessió nova
		  declare @IdDocSesionGenerada int  
		  exec [dbo].[pPers_CreaAhoraSesion] @IdDocSesion = @IdDocSesionGenerada OUTPUT

		  DECLARE @IdLinea T_Id_Linea

		  SET @IdLinea = (select IdLinea from Pedidos_Cli_Lineas where IdPedido = @IdPedido and IdDoc = @IdDocLinea)
		  EXEC pLineaPedido_AgregarAlbaran
				 @IdPedido = @IdPedido,
				 @IdLinea = @IdLinea,
				 @IdAlbaran = @IdAlbaran,
				 @Uds = @Quantitat,
				 @NuevaLinea = 0

	         -- Eliminar Sessió creada
                 exec [pPers_EliminaAhoraSesion] @IdDocSesionGenerada

		 END

		-- Actualitzem el detall de comanda de Prigest.
		DECLARE @IdLin T_Id_Linea
		SET @IdLin = (select IdLinea from Pedidos_Cli_Lineas where IdPedido = @IdPedido and IdDoc = @IdDocLinea)

		-- Pel cas des articles de FRESC, forcem el preu de cost actual com a manual a la línia.
		-- Si és bundle, posem el preu de cost al fill que no sigui feina.
		-- (Això ho podem fer perquè pel cas dels bundles, les línies del bundle són creades automàticament pel trigger).
		Declare @PreuCost numeric(18, 2) = (Select 0)
		Declare @IdDelegacio T_Id_Delegacion
		Set @IdDelegacio = (Select top 1 iddelegacion from delegaciones where idempresa = (select idempresa from Pedidos_Cli_Cabecera where IdPedido = @IdPedido))
		if ((Select dbo.fpers_EsArticleFresc(@Article))  = 1)
		begin
			if (@ControlBundle <> 1) 
			begin
			  Set @PreuCost = (Select IsNull(Coste, 0) From fPers_Dame_Precio_Coste_Delegacion(@Article, getdate(), null, null, @IdDelegacio))
			  if @Debug = 1
				print @PreuCost
			end
			else
			begin
			  Update CL
			  Set CL.P_CosteManual = (Select IsNull(Coste, 0) From fPers_Dame_Precio_Coste_Delegacion(@Article, getdate(), null, null, @IdDelegacio))
			  From Conf_Pedidos_Cli_Lineas as CL
			  Join Pedidos_Cli_Lineas as L on L.IdPedido = CL.IdPedido and L.IdLinea = CL.IdLinea
			  Where L.IdPedido = @IdPedido and L.IdDocPadre = @IdDocLinea and dbo.fPers_EsArticleFeina(L.IdArticulo) <> 1
			end
		end 
		
		-- Actualitzem tipus obs, comanda prigest, preu de cost i IdArticuloCanviArticle i IdDocCanviArticlePreparacio
		IF @ControlBundle = 1
		BEGIN
			/* Actualitzem el pare bundle que correspon a la línia que estem tractant. */
			UPDATE Conf_Pedidos_Cli_Lineas 
			set P_TipusObs = @TipusObs, Pers_DetallComandaPrigest = @DetallComandaPrigest, P_CosteManual = @PreuCost,
				P_TipusReservaLlotja = NullIf(@TipusReservaLlotja, -1), P_IdReservaLlotja = @IdReservaLlotja, P_OrigenReservaLlotja = @OrigenReservaLlotja,
				P_IdArticuloCanviArticle = @IdArticuloCanviArticle, P_IdDocCanviArticlePreparacio = @IdDocCanviArticlePreparacio
			where IdPedido = @IdPedido and IdLinea = @IdLin	   	

			/* Actualitzem els fills amb l'Article canviat per tal que no ens tornin a Comandes peix manipulat.*/
			UPDATE conf_Pedidos_Cli_Lineas set p_IdArticuloCanviArticle = @IdArticuloCanviArticle, P_IdDocCanviArticlePreparacio = @IdDocCanviArticlePreparacio
			where IdPedido = @IdPedido and (IdLinea = @IdLin+1 or IdLinea = @IdLin+2)

			Update CL
			  Set CL.P_CosteManual = (Select IsNull(Coste, 0) From fPers_Dame_Precio_Coste_Delegacion(L.IdArticulo, getdate(), null, null, @IdDelegacio))
			  From Conf_Pedidos_Cli_Lineas as CL
			  Join Pedidos_Cli_Lineas as L on L.IdPedido = CL.IdPedido and L.IdLinea = CL.IdLinea
			  Where L.IdPedido = @IdPedido and L.IdDocPadre = @IdDocLinea and dbo.fPers_EsArticleFeina(L.IdArticulo) = 1
		END
		ELSE
		BEGIN
			/* Actualitzem la línia que estem tractant. */
			UPDATE Conf_Pedidos_Cli_Lineas 
			set P_TipusObs = @TipusObs, Pers_DetallComandaPrigest = @DetallComandaPrigest, P_CosteManual = @PreuCost,
				P_TipusReservaLlotja = NullIf(@TipusReservaLlotja, -1), P_IdReservaLlotja = @IdReservaLlotja, P_OrigenReservaLlotja = @OrigenReservaLlotja,
				P_IdArticuloCanviArticle = @IdArticuloCanviArticle, P_IdDocCanviArticlePreparacio = @IdDocCanviArticlePreparacio
			where IdPedido = @IdPedido and IdLinea = @IdLin	   	
		END

		--Executem el proces d'ajust de linies en el cas que hi hagi algun dels valors de presentació o quantitat buits.
		if @QuantitatPres = 0 or @Quantitat = 0 or IsNull(@TipoUnidadPres, '') = ''
		begin
		  Exec pPers_Ajusta_Cantidad_Linea @IdPedido, @IdLin
		end
		--NOU 14012025
		--Executem el proces per posar les quantitats correctes en el cas que entri un bundle com a inserció de linies
		begin try
			IF @ControlBundle = 1 and (IsNull(@TipoUnidadPres, '') <> '')
			BEGIN
				--DECLARE @QuantitatFills T_Decimal_2 = (select case when IdPresentacion is null and @ControlBundle = 0 then @Quantitat else @QuantitatPres end from Articulos where IdArticulo = @Article)

				Exec Ppers_Cantidad_Padre @IdPedido, @IdLin, @QuantitatPres
			END
		end try
        begin catch 
			SET @CatchError=dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
			exec ppers_insertlog @msg = @CatchError, @idobj = @IdDocLinea, @Obj = '[pPers_CrearLiniaComanda] pedido_cli_lin set Ppers_Cantidad_Padre'
        end catch
		IF @FixarPreuVenda = 1
		BEGIN
			IF @ControlBundle = 1
			BEGIN
				DECLARE @Tabla TABLE (Id int, IdArticulo T_Id_Articulo)

				INSERT INTO @Tabla
				select IdLinea, IdArticulo from Pedidos_Cli_Lineas where IdPedido = @IdPedido 
				and IdDocPadre in (select IdDocPadre from Pedidos_Cli_Lineas where IdPedido = @IdPedido and IdDocPadre is not null and IdDoc > @IdDocLinea)

				WHILE(select count(*) from @Tabla)>0
				BEGIN
					DECLARE @IdLineaUpdate T_Id_Linea, @ArticleUpdate T_Id_Articulo

					set @IdLineaUpdate = (select Top 1 Id from @Tabla)
					select top 1 @IdLineaUpdate = Id, @ArticleUpdate = IdArticulo from @Tabla

					update Conf_Pedidos_Cli_Lineas set P_PreuVendaForcat = 1 where IdPedido = @IdPedido and IdLinea = @IdLineaUpdate

					IF (select dbo.fPers_EsArticleFeina(@ArticleUpdate)) = 1
					begin
						UPDATE Pedidos_Cli_Lineas set Precio_EURO = @PreuFeina, PrecioMoneda = @PreuFeina where IdPedido = @IdPedido and IdLinea = @IdLineaUpdate
						-- update Conf_Pedidos_Cli_Lineas set P_CosteManual = (select coste from fPers_Dame_Precio_Coste_Delegacion(@ArticleUpdate, getdate(), null,null,@IdDelegacio))
						-- where IdPedido = @IdPedido and IdLinea = @IdLineaUpdate
					end
					else
					begin
						UPDATE Pedidos_Cli_Lineas set Precio_EURO = @PreuVenda, PrecioMoneda = @PreuVenda where IdPedido = @IdPedido and IdLinea = @IdLineaUpdate
					end
 
					delete from @Tabla where Id = @IdLineaUpdate
				END
			END
			ELSE
			BEGIN
				update Conf_Pedidos_Cli_Lineas set P_PreuVendaForcat = 1 where IdPedido = @IdPedido and IdLinea = @IdLin

				UPDATE Pedidos_Cli_Lineas set Precio_EURO = @PreuVenda, PrecioMoneda = @PreuVenda where IdPedido = @IdPedido and IdLinea = @IdLin
			END
		END
		ELSE
		BEGIN
			IF @ControlBundle = 1
			BEGIN
				UPDATE Pedidos_Cli_Lineas set Precio_EURO = 0, PrecioMoneda = 0 where IdPedido = @IdPedido and IdDocPadre = @IdDocLinea and dbo.fPers_EsArticleFresc(@Article) = 1
			END 
		END 

		if ((dbo.fpers_EsArticleCongelat(@Article) = 1) or (dbo.fPers_EsArticleRefrigerat(@Article) = 1) or (dbo.fpers_EsArticleAmbient(@Article) = 1))
			and @ControlBundle = 0
		begin
		  update Conf_Pedidos_Cli_Lineas set P_PreuVendaForcat = 1 where IdPedido = @IdPedido and IdLinea = @IdLin
		  UPDATE Pedidos_Cli_Lineas set Precio_EURO = @PreuVenda, PrecioMoneda = @PreuVenda where IdPedido = @IdPedido and IdLinea = @IdLin
		END

		--==== En cas de ser un article de Fresc i que la comanda sigui per d'aqui mes de 2 dies, es posara preu 0 
		if (dbo.fPers_Datapedido(@IdPedido) = 1) 
		begin
			UPDATE Pedidos_Cli_Lineas set Precio_EURO = 0, PrecioMoneda = 0 where IdPedido = @IdPedido and (IdDocPadre = @IdDocLinea or IdDoc = @IdDocLinea) and dbo.fPers_EsArticleFresc(IdArticulo) = 1
		end


		/*IF (@ControlBundle = 1) and (@TipoUnidadPres is null)
		BEGIN
			UPDATE Pedidos_Cli_Lineas
			SET TipoUnidadPres = (
				SELECT TOP 1 TipoCantidad
				FROM Articulos
				WHERE IdArticulo = @Article
			)
			WHERE IdPedido = @IdPedido AND IdLinea = @IdLin;
		END; */



		/*Acualitza el descompte dels fills segons el descompte que te el conf P_Descompte (conf_clientes) de la ficha client  */
		UPDATE Pedidos_Cli_Lineas set Descuento = @DescuentoCliente
		where IdPedido = @IdPedido and (IdLinea = @IdLin+1 or IdLinea = @IdLin+2)
		end try
        begin catch 
			SET @CatchError = dbo.funImprimeError(ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_PROCEDURE(),@@PROCID ,ERROR_LINE())
			SET @CatchError = concat(cast(ERROR_LINE() as varchar(250)),@CatchError)
			set @ObjTxt = concat('[pPers_CrearLiniaComanda] Pers_Prepedido_linia_2 idpedido ', cast(@IdPedido as varchar(max)), 'Idlinia ', @P_IdLinea)
			exec ppers_insertlog @msg = @CatchError, @idobj = @IdPedido, @Obj = @ObjTxt
        end catch



		INSERT INTO Pers_Processos_Logs(Stored, IdOrigen, Usuari, DataHora, Params, InsertUpdate, Usuario, FechaInsertUpdate)
			SELECT 
		 	'pPers_CrearLiniaComanda' AS Stored, @IdOrigen, @Usuari, GETDATE() AS DataHora,
		 	('IdPedido: ' + ISNULL(CAST(@IdPedido AS NVARCHAR(150)), 'NULL') + 
		 	 ', IdAlbaran: ' + ISNULL(CAST(@IdAlbaran AS NVARCHAR(150)), 'NULL') + 
		 	 ', Article: ' + ISNULL(CAST(@Article AS NVARCHAR(150)), 'NULL') + 
		 	 ', Quantitat: ' + ISNULL(CAST(@Quantitat AS NVARCHAR(150)), 'NULL') + 
		 	 ', TipoUnidadPres: ' + ISNULL(CAST(@TipoUnidadPres AS NVARCHAR(150)), 'NULL') + 
			 ', QuantitatPres: ' + ISNULL(CAST(@QuantitatPres AS NVARCHAR(150)), 'NULL') + 
		 	 ', FixarPreuVenda: ' + ISNULL(CAST(@FixarPreuVenda AS NVARCHAR(150)), 'NULL') + 
		 	 ', PreuVenda: ' + ISNULL(CAST(@PreuVenda AS NVARCHAR(150)), 'NULL') + 
		 	 ', IdOrigen: ' + ISNULL(CAST(@IdOrigen AS NVARCHAR(150)), 'NULL') + 
		 	 ', Usuari: ' + ISNULL(CAST(@Usuari AS NVARCHAR(150)), 'NULL')
		 	) AS Params, 0 AS InsertUpdate, @Usuari, @FechaInsertUpdate
	RETURN -1
END
