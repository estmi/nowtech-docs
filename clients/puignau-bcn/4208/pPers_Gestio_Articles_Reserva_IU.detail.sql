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
					if (@IdEmpresa = 2 and @IdEmpresaLlotja = 2)
					begin
					insert into [PuignauBCN].[dbo].[ArticleArrivaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare)
						select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, concat(@ObsComanda,@Comentaris),@Client,@usuari,@ArticleBundle,@DescripArticleBundle
					SET @IdReservaDetall = (SELECT TOP 1 Id FROM [PuignauBCN].[dbo].[ArticleArrivaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = @Client ORDER BY ID  )
					end
					else if (@IdEmpresa = 2 and @IdEmpresaLlotja = 0)
					begin
						insert into [Puignau].[dbo].[ArticleArrivaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare)
						select @Id, GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, concat(@ObsComanda,@Comentaris),6507,@usuari,@ArticleBundle,@DescripArticleBundle
						SET @IdReservaDetall = (SELECT TOP 1 Id FROM [Puignau].[dbo].[ArticleArrivaReserves] WHERE IdLlotja = @Id AND Article = @Article AND Client = 6507 ORDER BY ID  )
						DECLARE @OutputTbl TABLE (ID INT)
						insert into PuignauBCN..ArticleArriva(Data,Article, Nom, NomFrances, NomCastella, TipusUnitat, Unitats, PreuCost, PreuVenda1, PreuVenda2, Comentaris, PreuCostTotal, IncT2, PreuVendaT2, CasellaCompra, avis, AmbAlbara, Visible, UltimPreuVenda1, VeureComentarisMBCN)
						output inserted.id into @OutputTbl
						select Data,Article, Nom, NomFrances, NomCastella, TipusUnitat, @Asignat, PreuCost, PreuVenda1, PreuVenda2, Comentaris, PreuCostTotal, IncT2, PreuVendaT2, CasellaCompra, avis, AmbAlbara, Visible, UltimPreuVenda1, VeureComentarisMBCN 
						from puignau..ArticleArriva where id = @Id
						insert into [PuignauBCN].[dbo].[ArticleArrivaReserves] (IdLlotja,Data,Persona,Article,DataLlotja,UnitatsDemanades,UnitatsAssignades,Comentaris,Client, Usuari,ArticlePare,NomArticlePare)
						select (select id from @OutputTbl), GETDATE(), @IdUsuari, @Article, @Data, @Demanat,@Asignat, concat(@ObsComanda,@Comentaris),@Client,@usuari,@ArticleBundle,@DescripArticleBundle
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
				if (select top 1 OfertaReservesActives from [vPers_Gestio_Articles_Reserva_Actius] ) = 1
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
								  WHEN @TipusUnitat = 'UTS' THEN 'Un'
								  ELSE @TipusUnitat  -- Si no coincide con ningún valor, se mantiene igual
							   END;
				if @ArticleBundle is null
				begin
					insert into Pers_PrePedido_Lineas (IdPrePedido,IdPrePedidoLinea,IdArticulo,Cantidad,Precio,TipoUnidad,TipoObservacion,Observacion,
					IdGestioReserva,OrigenTaula,IdOrigenReserva,LinNueva,PreuFixat)
					select @IdPrePedido,
								(select Coalesce(max(IdPrePedidoLinea),0) +1 from Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido) as IdPrePedidoLinea,
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
								(select coalesce(max(IdPrePedidoLinea), 0) +1 from Pers_PrePedido_Lineas where IdPrePedido = @IdPrePedido) as IdPrePedidoLinea,
								@ArticleBundle,
								@Asignat
								,@Preua as Precio --HO EMPLENA EL TRIGGER SEGONS FUNDAMEPRECIO
								,ltrim(rtrim(@TipusUnitat)), @TipusObs as TipoObservacions--HO EMPLENA EL TRIGGER SEGONS CLIENT
								, Concat(@ObsComanda,' ', (select top 1 Observaciones from fPers_ObtenerObservacionClienteArticulo(coalesce(@articlebundle,@Article),@Client)), @Comentaris )
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