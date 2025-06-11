ALTER PROCEDURE pPers_Gestio_Articles_Reserva_IU
(  --PARAMS OBLIGATORIS
    @NumOrigen		int,
    @Id               INT, 
    @IdPrePedido      INT,   
	--------------------
    @ArticleBundle    VARCHAR(50) = null,
    @Article2    VARCHAR(50) = null,
    @Demanat          NUMERIC(18,2) = null,
    @Comentaris       VARCHAR(150) = null
)
AS
BEGIN
	
    SET NOCOUNT ON;
	--==========================	DECLARACIÓN				========================
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @RecordExists		INT,		
		@OrigenTabla			VARCHAR(50),
		@Comercial				INT = null,
		@Client					INT = null,
		@Grup					INT = 0,
		@TipusObs				INT = 4,
		@Article				VARCHAR(15) = null,
		@TipusUnitat			VARCHAR(15) = null,
		@Usuari					VARCHAR(80) = null,
		@Queden					NUMERIC(18,2) = null,
		@Asignat				NUMERIC(18,2) = null,
		@comanda				NUMERIC(18,2) = null,
		@Preua				    NUMERIC(18,2) = null,
		@Preut1				    NUMERIC(18,2) = null,
		@IdUsuari				INT = null,
		@TipusReserva			INT = null,
		@EstadoPrepedido		INT = null,
		@MODO					INT = null,
		@Update					bit = 0,
		@InsertA				bit = 1,
		@preufix				bit = 1,
		@AvisQuedenMenys		bit = 0,
		@IdReserva				INT = null,
		@IdReservaDetall        INT = null,
		@DescripArticleBundle	varchar (250),
		@ObsComanda				varchar (250),
		@Data					date,
		@IdEmpresa				INT = 0
	--==========================	INICIALIZAMOS			========================
	IF @Comentaris = '0' SET @Comentaris = NULL
	
	SELECT @OrigenTabla = OrigenDetall , @TipusReserva = TipusReserva
		FROM vPers_Gestio_Articles_Reserva_RelacioTaules WHERE Num = @NumOrigen

	SELECT @Client = IdCliente, @IdUsuari = IdEmpleadoPedido, @MODO= Modo, @EstadoPrepedido = IdEstado, @IdEmpresa = IdEmpresa
		FROM Pers_PrePedido	WHERE IdPrePedido = @IdPrePedido
	if @EstadoPrepedido in (select IdEstado from Pers_PrePedido_Estados where PermiteTraspaso = 1)
	begin

		SELECT @usuari = Login from Empleados_Datos where IdEmpleado = @IdUsuari
		select @DescripArticleBundle = descrip from articulos where IdArticulo = @ArticleBundle
		select @Comercial = IdEmpleado 
			from Clientes_Datos_Comerciales where IdCliente = @Client
		
		SELECT top 1 @Article = Article, @TipusUnitat = TipusUnitat, @Queden = Queden , @Data = Data , @comanda = comanda, @Grup = Grup, @Preut1 = PreuMinimAplicable
			FROM vPers_Gestio_Articles_Reserva_PrePedidoAvui where IdPrePedido = @IdPrePedido and NumOrigen = @NumOrigen and Id = @Id
	
		if @TipusUnitat is null
		begin
			set @TipusUnitat = (select top 1 coalesce(IdTipoUnidadPres,TipoCantidad) from articulos where IdArticulo = @Article)
		end
		if @ArticleBundle = '0'
		begin
			set @ArticleBundle = null
			set @DescripArticleBundle = null
		end
		declare @idlinea int
		if @comanda > 0
		begin
		 set @update = 1
		 set @idlinea = (	select top 1 IdPrePedidoLinea from [vPers_Gestio_Articles_Reserva_Detall_PrePedidoAvui] a
							left join Pers_PrePedido_Lineas ppl on  a.IdPrePedido = ppl.IdPrePedido and a.OrigenTabla = ppl.OrigenTaula and a.Id = ppl.IdGestioReserva
						where IdPrePedidoLinea is not null and a.IdPrePedido = @IdPrePedido and a.Id = ppl.IdGestioReserva and a.OrigenTabla = @OrigenTabla and Article = @Article AND Client = @Client)
		end
		if (@demanat > 0)
		begin
		--==========================	FEM RESERVA		========================
		if (@Demanat is not null)
		begin
			--QUEDEN MENYS DEL DEMANAT
			if (@Queden < @Demanat) 
			BEGIN
			set @AvisQuedenMenys = 1 --AVISEM DE QUE QUEDEN MENYS DEL DEMANAT
				if (@Update) = 1
				begin
				
					set @Asignat = @Queden -- (select cantidad from Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido and IdPrePedidoLinea = @idlinea)	
					
				end
				else
				begin
					set @Asignat = @Queden
				end
			END
			ELSE
			BEGIN
				set @Asignat = @Demanat
			END
		
			--==========================	ArticleLlotja		========================
			IF @NumOrigen = 2 --
			BEGIN
				if (select top 1 LlotjaReservesActives from [vPers_Gestio_Articles_Reserva_Actius] where IdPrePedido = @IdPrePedido ) = 1
				begin
					set @Preua = 0
					IF @MODO = 2
					begin
						set @ObsComanda = '[RC LLOT]'
					end
					else
					begin
						set @ObsComanda = '< [RT LLOT] >'
					end
					if @update = 1
					begin
						if (@IdEmpresa = 2)
						begin	
							delete [PuignauBCN].[dbo].[ArticleLlotjaReserves]  --set UnitatsAssignades  =  @Asignat , UnitatsDemanades = @Demanat, Data = getdate()
							where IdLlotja = @Id and article = @Article and Client = @Client
						end
						else
						begin
							delete [Puignau].[dbo].[ArticleLlotjaReserves]  --set UnitatsAssignades  =  @Asignat , UnitatsDemanades = @Demanat, Data = getdate()
							where IdLlotja = @Id and article = @Article and Client = @Client
						end
					end
					if (@IdEmpresa = 2)
						begin
							insert into [PuignauBCN].[dbo].[ArticleLlotjaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris, @Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda 
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleLlotjaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
						else
						begin

							insert into [Puignau].[dbo].[ArticleLlotjaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris, @Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda 
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleLlotjaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
				end
				else
				begin
					set @InsertA = 0
					Select 'flexygo.msg.alert(''No es poden crear reserves de llotja quan Llotja està inactiva.'');' as JSCode
				end	
				set @preufix = 1
				set @Preua = @Preut1
			END
			--==========================	ArticleNevera		========================
			IF @NumOrigen = 4 and @Grup = 0  --
			BEGIN
				if (select top 1 NeveraReservesActives from [vPers_Gestio_Articles_Reserva_Actius] where IdPrePedido = @IdPrePedido ) = 1
				begin
					IF @MODO = 2
					begin
						set @ObsComanda = '[RC NEV]'
					end
					else
					begin
						set @ObsComanda = '< [RT NEV] >'
					end
					if @update = 1
					begin  
						if (@IdEmpresa = 2)
						begin
							delete [PuignauBCN].[dbo].[ArticleNeveraReserves]  
							where IdNevera = @Id and article = @Article and Client = @Client
						end
						else
						begin
							delete [Puignau].[dbo].[ArticleNeveraReserves]  
							where IdNevera = @Id and article = @Article and Client = @Client
						end
					end
					if (@IdEmpresa = 2)
					begin
						insert into [PuignauBCN].[dbo].[ArticleNeveraReserves] (IdNevera,Data,Persona,Article,DataNevera,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
							select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
						SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleNeveraReserves] WHERE IdNevera = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
					end
					else
					begin
						insert into [Puignau].[dbo].[ArticleNeveraReserves] (IdNevera,Data,Persona,Article,DataNevera,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
							select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
						SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleNeveraReserves] WHERE IdNevera = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
					end
					set @preufix = 0
				end
				else
				begin
					set @InsertA = 0
					Select 'flexygo.msg.alert(''No es poden crear reserves de nevera quan nevera està inactiva.'');' as JSCode
				end
				set @preufix = 1
				set @Preua = @Preut1
			END
			--==========================	ArticleNevera	TOP	========================
			IF @NumOrigen = 4 and @Grup = 1  --
			BEGIN
				if (select top 1 Nevera1ReservesActives from [vPers_Gestio_Articles_Reserva_Actius] where IdPrePedido = @IdPrePedido ) = 1
				begin
					IF @MODO = 2
					begin
						set @ObsComanda = '[RC NEV]'
					end
					else
					begin
						set @ObsComanda = '< [RT NEV] >'
					end
					if @update = 1
					begin 
						if (@IdEmpresa = 2)
						begin
							delete [PuignauBCN].[dbo].[ArticleNeveraReserves]  
							where IdNevera = @Id and article = @Article and Client = @Client
						end
						else
						begin
							delete [Puignau].[dbo].[ArticleNeveraReserves]  
							where IdNevera = @Id and article = @Article and Client = @Client
						end
					end
						if (@IdEmpresa = 2)
						begin
							insert into [PuignauBCN].[dbo].[ArticleNeveraReserves] (IdNevera,Data,Persona,Article,DataNevera,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleNeveraReserves] WHERE IdNevera = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
						else
						begin
							insert into [Puignau].[dbo].[ArticleNeveraReserves] (IdNevera,Data,Persona,Article,DataNevera,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleNeveraReserves] WHERE IdNevera = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
					set @preufix = 0
				end
				else
				begin
					set @InsertA = 0
					Select 'flexygo.msg.alert(''No es poden crear reserves de nevera quan nevera TOP està inactiva.'');' as JSCode
				end
				set @preufix = 1
				set @Preua = @Preut1
			END
			--==========================	ArticlePA		========================
			IF @NumOrigen = 1 --
			BEGIN
				set @TipusObs = 3
				IF @MODO = 2
				begin
					set @ObsComanda = '[RC PA]'
				end
				else
				begin
					set @ObsComanda = '< [RT PA] >'
				end
				if @update = 1
				begin 				
					if (@IdEmpresa = 2)
					begin
						delete [PuignauBCN].[dbo].[ArticleArrivaReserves]  
						where IdLlotja = @Id and article = @Article and Client = @Client						
					end
					else
					begin
						delete [Puignau].[dbo].[ArticleArrivaReserves]  
						where IdLlotja = @Id and article = @Article and Client = @Client
					end
				end		
					if (@IdEmpresa = 2)
					begin
					insert into [PuignauBCN].[dbo].[ArticleArrivaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare)
						select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, concat(@ObsComanda,@Comentaris),@Client,@usuari,@ArticleBundle,@DescripArticleBundle
					SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleArrivaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
					end
					else
					begin
					insert into [Puignau].[dbo].[ArticleArrivaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare)
						select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, concat(@ObsComanda,@Comentaris),@Client,@usuari,@ArticleBundle,@DescripArticleBundle
					SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleArrivaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
					end
				set @preufix = 1
				set @Preua = @Preut1
			END
		
			--==========================	ArticleOfertes		========================
			IF @NumOrigen = 5 --
			BEGIN
				if (select top 1 OfertaReservesActives from [vPers_Gestio_Articles_Reserva_Actius] where IdPrePedido = @IdPrePedido ) = 1
				begin
					IF @MODO = 2
					begin
						set @ObsComanda = '[RC LIQ]'
					end
					else
					begin
						set @ObsComanda = '< [RT LIQ] >'
					end
					if @update = 1
					begin 
					
						if (@IdEmpresa = 2)
						begin
							delete [PuignauBCN].[dbo].[ArticleOfertaReserves] 
							where IdOferta = @Id and article = @Article and Client = @Client							
						end
						else
						begin
							delete [Puignau].[dbo].[ArticleOfertaReserves] 
							where IdOferta = @Id and article = @Article and Client = @Client
						end
					end
						if (@IdEmpresa = 2)
						begin
							insert into [PuignauBCN].[dbo].[ArticleOfertaReserves] (IdOferta,Data,Persona,Article,DataOferta,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleOfertaReserves] WHERE IdOferta = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
						else
						begin
							insert into [Puignau].[dbo].[ArticleOfertaReserves] (IdOferta,Data,Persona,Article,DataOferta,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare, ObservacionsComanda)
								select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, @Comentaris,@Client,@usuari,@ArticleBundle,@DescripArticleBundle, @ObsComanda --'[RC LLOT]' --TELEVENDA
							SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleOfertaReserves] WHERE IdOferta = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
						end
				end
				else
				begin
					set @InsertA = 0
					Select 'flexygo.msg.alert(''No es poden crear reserves de liquidacions quan liquidacions està inactiva.'');' as JSCode
				end
				set @preufix = 1
				set @Preua = @Preut1
			END
		
			--==========================	ArticleOfertes		========================

		
				if @update = 1
				begin
				
					delete Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido and IdPrePedidoLinea = @idlinea
				end	
				--==========================	INSERTEM LINIA PREPEDIDO		========================
				if @InsertA = 1
				begin

                    SELECT 
                    @TipusUnitat = CASE 
                                    WHEN @TipusUnitat = 'KGS' THEN 'KG'
                                    WHEN @TipusUnitat = 'FDO' THEN 'Far.'
                                    WHEN @TipusUnitat = 'PEC' THEN 'Pec '
                                    ELSE @TipusUnitat  -- Si no coincide con ningún valor, se mantiene igual
                                END;
                    if @ArticleBundle is null
                    begin
                        insert into Pers_PrePedido_Lineas (IdPrePedido,IdPrePedidoLinea,IdArticulo,Cantidad,Precio,TipoUnidad,TipoObservacion,Observacion,
                        IdGestioReserva,OrigenTaula,IdOrigenReserva,LinNueva,PreuFixat)
                        select @IdPrePedido,
                                    (select max(IdPrePedidoLinea) +1 from Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido) as IdPrePedidoLinea,
                                    @Article,
                                    @Asignat
                                    ,@Preua as Precio --HO EMPLENA EL TRIGGER SEGONS FUNDAMEPRECIO
                                    ,ltrim(rtrim(@TipusUnitat)), @TipusObs as TipoObservacions--HO EMPLENA EL TRIGGER SEGONS CLIENT
                                    , Concat(@ObsComanda,' ', (select top 1 Observaciones from fPers_ObtenerObservacionClienteArticulo(coalesce(@articlebundle,@Article),@Client)) )
                                    ,@IdReservaDetall
                                    , @OrigenTabla
                                    ,@TipusReserva, 0 as linnueva,
                                    @preufix as PreuFixat
                    end
                    else
                    begin
                        DECLARE @IdArticuloFeina T_ID_Articulo, @price T_precio
                        select @IdArticuloFeina = ac.IdArticulo, @price = precio.Precio from Articulos_Conjuntos ac
                        left join clientes_datos cd on cd.IdCliente = @Client
                        left join Clientes_Datos_Economicos cde on cde.IdCliente = cd.IdCliente
                        outer apply fPers_DamePrecio_Articulo_Delegacion(IdArticulo, cd.IdCliente, cde.IdLista, getdate(), null, null, cd.IdDelegacion) precio
                        where IdArticuloPadre = @ArticleBundle and ac.IdArticulo != @Article2

                            insert into Pers_PrePedido_Lineas (IdPrePedido,IdPrePedidoLinea,IdArticulo,Cantidad,Precio,TipoUnidad,TipoObservacion,Observacion,
                            IdGestioReserva,OrigenTaula,IdOrigenReserva,LinNueva,PreuFixat,IdArticuloHijo, IdArticuloFeina, PrecioFeina)
                            select @IdPrePedido,
                                        (select max(IdPrePedidoLinea) +1 from Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido) as IdPrePedidoLinea,
                                        @ArticleBundle,
                                        @Asignat
                                        ,@Preua as Precio --HO EMPLENA EL TRIGGER SEGONS FUNDAMEPRECIO
                                        ,ltrim(rtrim(@TipusUnitat)), @TipusObs as TipoObservacions--HO EMPLENA EL TRIGGER SEGONS CLIENT
                                        , Concat(@ObsComanda,' ', (select top 1 Observaciones from fPers_ObtenerObservacionClienteArticulo(coalesce(@articlebundle,@Article),@Client)) )
                                        ,@IdReservaDetall
                                        , @OrigenTabla
                                        ,@TipusReserva, 0 as linnueva,
                                        @preufix as PreuFixat,
                                        @Article2, @IdArticuloFeina, @price

                    end
			    end 
		    end
		end
		else
		begin
			if (@IdEmpresa = 2)
			begin
				delete [PuignauBCN].[dbo].[ArticleLlotjaReserves] 
				where IdLlotja = @Id and article = @Article and Client = @Client				
			end
			else
			begin
				delete [Puignau].[dbo].[ArticleLlotjaReserves] 
				where IdLlotja = @Id and article = @Article and Client = @Client
			end
			delete Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido and IdPrePedidoLinea = @idlinea
		end


		IF @AvisQuedenMenys = 1
		BEGIN
			select 'flexygo.msg.alert(''ATENCIÓ! S HA DEMANAT MÉS DEL DISPONIBLE.'');refreshEditGridP(); refreshButtonera();' as JSCode			
		END
		ELSE
		BEGIN
			select 'refreshEditGridP(); refreshButtonera();' as JSCode
		END
	end
	else
	begin
		Select 'flexygo.msg.alert(''No es poden crear reserves quan el prepedido està enviat.'');' as JSCode	 
	end
	return -1
END;