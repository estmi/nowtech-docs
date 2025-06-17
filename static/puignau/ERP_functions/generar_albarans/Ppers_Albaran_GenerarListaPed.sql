ALTER PROCEDURE [dbo].[Ppers_Albaran_GenerarListaPed]
	@IdAlbaranI			T_Id_Albaran,
	@IdAlbaranF			T_Id_Albaran OUTPUT,
	@NumAlbaranI		T_Id_Albaran,
	@NumAlbaranF		T_Id_Albaran OUTPUT,
	@IdEmpresa			T_Id_Empresa,
	@AñoNum				T_AñoNum,
	@SerieAlbaran		T_Serie,
	@FechaAlb 			T_Fecha_Corta,
	@NumAlbCliente		T_Id_Albaran,
	@IdContactoA		int,
	@IdContactoF		int,
	@DescripcionAlb		Varchar(255),
	@Embalaje 			Varchar(100),
	@IdEmpleado 		T_Id_Empleado,
	@IdDepartamento 	T_Id_Departamento,
	@IdTransportista	T_Id_Proveedor,
	@IdMoneda 			T_Id_Moneda,
	@CambioEuros		T_Precio, 
	@CambioBloqueado	T_Booleano, 
	@IdPortes 			T_Id_Portes,
	@FechaEntrega 		T_Fecha_Corta,
	@FechaEntregaTope	T_Fecha_Corta,
	@Bultos				Int,
	@Observaciones 		Varchar(1000),
	@Portes				T_Precio,
	@PortesEuros		T_Precio,
	@PesoNeto			Real,
	@PesoBruto          Real,
	@AlmacenRecogida	T_Id_Almacen,
	@Datos				Int,
	@IdProceso			int=NULL
AS

 ----------------------------------------------------------------------------------------------------------
 -- GENERACION DE ALBARANES PARA PEDIDOS DE UNA LISTA AGRUPADOS POR:
 --	PEDIDO
 --	MONEDA
 --
 -- la lista está en la tabla Pedidos_Cli_Seleccion 
 -- se genera 1 albaran por cada pedido y Moneda que se encuentre en la lista
 -- numeracion por pedido 
 -----------------------------------------------------------------------------------------------------------
 Declare @Ped T_Id_Pedido
 Declare @IdCliente T_Id_Cliente
 Declare @Msg_err varchar(255)
 Declare @Vret Int

 Declare @PegarNotas varchar(255)


 Declare @Moneda 			T_Id_Moneda
 Declare @MonedaCambio		T_Precio
 Declare @MonedaBloq		T_Booleano

DECLARE @P0 nvarchar(1000)
DECLARE @CadenaStr nvarchar(4000)

	----------------------------------------------------------------------------------
	-- Cursor con los pedidos que se encuentren en la lista
	---------------------------------------------------------------------------------- 
	DECLARE Marca CURSOR FOR
		SELECT DISTINCT Sel.IdPedido,
			VPM.Moneda_Alb AS Moneda, 
			VPM.MonedaCambio_Alb, 
			VPM.MonedaBloqueado_Alb

		FROM	Pedidos_Cli_Seleccion	Sel, 
			Pedidos_Cli_Cabecera	Ped,
			Pedidos_Cli_Lineas		Lin, 
			VPedidos_MarcadaAlb			VPM

		WHERE Sel.Usuario=USER_NAME() And
			Ped.IdEstado=0 And
			Lin.IdEstado = 1 And			-- Marcada Albaran 
			Lin.IdPedido = Sel.IdPedido And
			Ped.IdPedido = Sel.IdPedido AND
			VPM.IdPedido=SEL.IdPedido
			AND Ped.Bloqueado=0
	OPEN Marca

	FETCH NEXT FROM Marca INTO @Ped, @Moneda, @MonedaCambio ,@MonedaBloq
	WHILE @@FETCH_STATUS<>-1 BEGIN 
			-----------------------------------------------------------------
			-- Registro de la moneda del cliente
			-----------------------------------------------------------------
--			IF @Moneda=0 
				--// se escoge la moneda del cliente por fiabilidad
			--	SELECT @IdMoneda=Clientes_Datos_Economicos.IdMoneda
			--	FROM Clientes_Datos_Economicos, Pedidos_Cli_Cabecera
			--	WHERE Clientes_Datos_Economicos.IdCliente = Pedidos_Cli_Cabecera.IdCliente And Pedidos_Cli_Cabecera.IdPedido = @Ped
			--ELSE
			 	SELECT @IdMoneda=@Moneda

				select @idcliente=IdCliente from Pedidos_Cli_Cabecera where IdPedido=@Ped
			--------------------------------------------------------------
			-- Si la serie del albarán es nulo se coge la serie del pedido
			--------------------------------------------------------------
			IF @SerieAlbaran IS NULL BEGIN
				SELECT @SerieAlbaran = SeriePedido FROM Pedidos_Cli_Cabecera WHERE  IdPedido = @Ped
			END
			------------------------------------------------------------
			-- Buscar numeros de albaran (Si existen los elegidos)
			------------------------------------------------------------
			IF EXISTS
				(SELECT * FROM Albaranes_Cli_Cab WHERE IdAlbaran=@IdAlbaranI)
			BEGIN
				SELECT @IdAlbaranI=ISNULL(MAX(IdAlbaran)+1,1) FROM Albaranes_Cli_Cab
			END

			IF EXISTS
				(SELECT * FROM Albaranes_Cli_Cab
				WHERE IdEmpresa=@IdEmpresa And AñoNum=@AñoNum And SerieAlbaran=@SerieAlbaran And NumAlbaran=@NumAlbaranI)
			BEGIN
				SELECT @NumAlbaranI=ISNULL(Max(NumAlbaran)+1,1)
				FROM Albaranes_Cli_Cab
				WHERE Albaranes_Cli_Cab.IdEmpresa=@IdEmpresa And Albaranes_Cli_Cab.AñoNum=@AñoNum And SerieAlbaran=@SerieAlbaran 
			END
			-------------------------------------------------------------
			-- Comienzo transaccion
			-------------------------------------------------------------
			BEGIN TRANSACTION
			-------------------------------------------------------------
			-- Introducir Cabecera de Albaran Tomando:
				-- Los Datos pasados si @Datos=1 
				-- Los Datos que se puedan del cliente si @Datos=0
			-------------------------------------------------------------

			if exists(select 1 from Albaranes_Cli_Cab AlbCab
						inner join Conf_Albaranes_Cli conf on conf.IdAlbaran = AlbCab.IdAlbaran
						where IdCliente=@IdCliente and FechaAlb=@FechaAlb and IdEstado=0 and coalesce(conf.P_AlbaranSeparado,0) = 0)
				and exists(select 1 from Conf_Pedidos_Cli where IdPedido=@Ped and coalesce(P_AlbaranSeparado,0)=0) begin

				select top 1 @IdAlbaranI=AlbCab.IdAlbaran from Albaranes_Cli_Cab AlbCab inner join Conf_Albaranes_Cli conf on conf.IdAlbaran = AlbCab.IdAlbaran 
				where IdCliente=@IdCliente and FechaAlb=@FechaAlb and IdEstado=0 and coalesce(conf.P_AlbaranSeparado,0) = 0

			end else begin

			INSERT INTO Albaranes_Cli_Cab
					(IdAlbaran,
					IdEmpresa,
					AñoNum,
					SerieAlbaran,
					NumAlbaran,
					FechaAlb,                       
					IdCliente,       
					NumAlbCliente, 
					IdContactoA,
					IdContactoF,  
					DescripcionAlb,  
					Embalaje,                                                                                                                                                                                                                                                
					IdEmpleado,  
					IdDepartamento, 
					IdTransportista, 
					IdMoneda, 
					CambioEuros, 
					CambioBloqueado, 
					IdPortes, 
					FechaEntrega,                
					FechaEntregaTope,            
					Bultos,      
					Observaciones,                                                                                                                                                                                                                                                   
					Portes,                     
					PortesEuros,
					PesoNeto,
					PesoBruto,
					AlmacenRecogida,
					FecActualizacion,
					RecEquivalencia,IdProceso)
				SELECT @IdAlbaranI,
					@IdEmpresa,
					@AñoNum,
					@SerieAlbaran,
					@NumAlbaranI,
					@FechaAlb,                       
					IdCliente,
					@NumAlbCliente,                                   
					CASE @Datos
					WHEN 1 THEN @IdContactoA
					ELSE IdContactoA
					END,
					CASE @Datos
					WHEN 1 THEN @IdContactoF
					ELSE IdContactoF
					END,
					CASE WHEN @DescripcionAlb IS NULL THEN Descripcionped ELSE @DescripcionAlb END,
					@Embalaje,	                                                                                                                                                                                                                                                  
					CASE @Datos
					WHEN 1 THEN @IdEmpleado
					ELSE IdEmpleado
					END,  
					CASE @Datos
					WHEN 1 THEN @IdDepartamento
					ELSE IdDepartamento
					END, 
					CASE @Datos
					WHEN 1 THEN @IdTransportista
					ELSE IdTransportista
					END, 
					@IdMoneda,  
					@MonedaCambio, 
					@MonedaBloq, 
					CASE @Datos
					WHEN 1 THEN @IdPortes
					ELSE IdPortes
					END, 
					@FechaEntrega,                
					@FechaEntregaTope,            
					@Bultos,      
					CASE WHEN @Observaciones IS NULL THEN Observaciones ELSE @Observaciones END,
					@Portes,                     
					@PortesEuros,
					@PesoNeto,
					@PesoBruto,
					@AlmacenRecogida,
					@FechaAlb,
					RecEquivalencia,@IdProceso
				FROM Pedidos_Cli_cabecera WHERE IdPedido=@Ped

				update Conf_Albaranes_Cli
				set P_AlbaranSeparado = (select P_AlbaranSeparado from Conf_Pedidos_Cli where IdPedido=@Ped)
				where IdAlbaran = @IdAlbaranI
				
				end
	
			IF @@ROWCOUNT=0 BEGIN
				--SELECT @Msg_Err='ERROR AL ALBARANEAR EN PEDIDO: '+ Convert(Varchar,@Ped)+ '. NO SE HA PODIDO ALBARANEAR'
				SET @P0 = Convert(Varchar,@Ped)
				SET @CadenaStr = dbo.Traducir(20133, 'ERROR AL ALBARANEAR EN PEDIDO: %v. NO SE HA PODIDO ALBARANEAR')
				exec sprintf @Msg_Err OUT, @CadenaStr, @P0

				PRINT @Msg_Err
				ROLLBACK TRANSACTION
				CLOSE Marca
				DEALLOCATE Marca
				RETURN 0
			END
			-----------------------------------------------
			-- Insertar las notas del pedido
			-----------------------------------------------
			SELECT @PegarNotas=dbo.Valor_Parametro ('PEGAR_NOTAS_ALBARAN',USER) -- NO_TRADUCIR_TAG
			IF @PegarNotas IS NOT NULL AND @PegarNotas='ON' BEGIN
				IF EXISTS
					(SELECT * FROM Pedidos_Cli_Notas WHERE  IdPedido=@Ped)
				BEGIN
					INSERT INTO Albaranes_Cli_Notas (IdAlbaran,Notas) SELECT @IdAlbaranI,Notas FROM Pedidos_Cli_Notas WHERE IdPedido=@Ped
					IF @@ROWCOUNT=0 BEGIN
						PRINT dbo.Traducir(24145, 'ERROR AL ALBARANEAR. NO SE HA PODIDO INSERTAR LAS NOTAS DE PEDIDO')
						ROLLBACK TRANSACTION
						RETURN 0
					END	
				END
			END
			---------------------------------------------------
			-- Actualizar lineas: estado, albaran y fecha
			---------------------------------------------------
--			IF @Moneda = 0 BEGIN

				UPDATE  Pedidos_Cli_Lineas
				SET	IdEstado=3, 	--Albaran
					IdAlbaran=@IdAlbaranI,
					FechaAlbaran=@FechaAlb,
					InsertUpdate=1,
					Usuario=USER,       
					FechaInsertUpdate=getdate()
				FROM 	Pedidos_Cli_Lineas		Lin,
						Pedidos_Cli_Cabecera	Ped, 
						VPedidos_MarcadaAlb		VPM
				WHERE Lin.IdPedido=@Ped And
					Lin.IdEstado=1 And			--Marcada Albaran
					Lin.IdPedido = Ped.IdPedido AND
					VPM.IdPedido = Ped.IdPedido AND
					VPM.Moneda_Alb = @IdMoneda And
					VPM.MonedaCambio_Alb = @MonedaCambio AND
					VPM.MonedaBloqueado_Alb = @MonedaBloq
					--AND Ped.Bloqueado=0


/*			END ELSE BEGIN
				UPDATE Pedidos_Cli_Lineas
				SET	IdEstado=3, 				-- Albaran
					IdAlbaran=@IdAlbaranI,
					FechaAlbaran=@FechaAlb,
					InsertUpdate=1,
					Usuario=USER,       
					FechaInsertUpdate=getdate()
				FROM 	Pedidos_Cli_Lineas	Lin,
					Pedidos_Cli_Cabecera	Ped
				WHERE Lin.IdPedido=@Ped And
					Lin.IdEstado=1 And			--Marcada Albaran
					Ped.IdMoneda= @IdMoneda And
					Lin.IdPedido = Ped.IdPedido
			END*/
	
			IF @@ROWCOUNT=0 BEGIN
				--SELECT @Msg_Err='ERROR AL ALBARANEAR EN PEDIDO: '+ Convert(Varchar,@Ped)+ '. NO SE HA PODIDO ALBARANEAR.'
				SET @P0 = Convert(Varchar,@Ped)
				SET @CadenaStr = dbo.Traducir(20134, 'ERROR AL ALBARANEAR EN PEDIDO: %v. NO SE HA PODIDO ALBARANEAR.')
				exec sprintf @Msg_Err OUT, @CadenaStr, @P0

				PRINT	@Msg_Err
				ROLLBACK TRANSACTION
				CLOSE	Marca
				DEALLOCATE Marca
				RETURN 0
			END
			---------------------------------------------------
			-- Calcular PesoNeto y Bruto
			---------------------------------------------------
			IF (@PesoNeto IS NULL Or @PesoNeto=0) BEGIN
				EXEC @Vret=Actualiza_Pesos @IdAlbaranI
				IF @Vret=0 BEGIN 
					--SELECT @Msg_Err='ERROR AL ALBARANEAR EN PEDIDO: '+ Convert(Varchar,@Ped)+ '. NO SE HA PODIDO ALBARANEAR.'
					SET @P0 = Convert(Varchar,@Ped)
					SET @CadenaStr = dbo.Traducir(20134, 'ERROR AL ALBARANEAR EN PEDIDO: %v. NO SE HA PODIDO ALBARANEAR.')
					exec sprintf @Msg_Err OUT, @CadenaStr, @P0

					PRINT	@Msg_Err
					ROLLBACK TRANSACTION
					CLOSE	Marca
					DEALLOCATE Marca
					RETURN 0
				END
			END
			---------------------------------------------------
			-- Calcular Bultos
			--------------------------------------------------- 
			IF (@Bultos IS NULL Or @Bultos=0) BEGIN
				EXEC @Vret=Actualiza_Bultos @IdAlbaranI
				IF @Vret=0 BEGIN 
					--SELECT @Msg_Err='ERROR AL ALBARANEAR EN PEDIDO: '+ Convert(Varchar,@Ped)+ '. NO SE HA PODIDO ALBARANEAR.'
					SET @P0 = Convert(Varchar,@Ped)
					SET @CadenaStr = dbo.Traducir(20134, 'ERROR AL ALBARANEAR EN PEDIDO: %v. NO SE HA PODIDO ALBARANEAR.')
					exec sprintf @Msg_Err OUT, @CadenaStr, @P0

					PRINT	@Msg_Err
					ROLLBACK TRANSACTION
					CLOSE	Marca
					DEALLOCATE Marca
					RETURN 0
				END
			END
			---------------------------------------------------
			-- Comprobar estado de los pedidos albaraneados
			-- Si todas sus lineas están albaraneadas (ALB)
			--------------------------------------------------- 
			EXEC @Vret=Estado_Pedido_Cli_Alb @Ped,@Ped
			IF @Vret=0 BEGIN 
				--SELECT @Msg_Err='ERROR AL ALBARANEAR EN PEDIDO: '+ Convert(Varchar,@Ped)+ '. NO SE HA PODIDO ALBARANEAR.'
				SET @P0 = Convert(Varchar,@Ped)
				SET @CadenaStr = dbo.Traducir(20134, 'ERROR AL ALBARANEAR EN PEDIDO: %v. NO SE HA PODIDO ALBARANEAR.')
				exec sprintf @Msg_Err OUT, @CadenaStr, @P0

				PRINT	@Msg_Err
				ROLLBACK TRANSACTION
				CLOSE	Marca
				DEALLOCATE Marca
				RETURN 0
			END
			--------------------------------------------------------------------------------
			-- Albaranear por pedido: se incrementan los numeros por pedidos 
			-- Se devuelve en @%F los ultimo Numeros insertados
			--------------------------------------------------------------------------------
			SELECT @IdAlbaranF=@IdAlbaranI
			SELECT @IdAlbaranI=@IdAlbaranI+1
			SELECT @NumAlbaranF=@NumAlbaranI
			SELECT @NumAlbaranI=@NumAlbaranI+1
			SELECT @NumAlbCliente=@NumAlbCliente+1

			FETCH NEXT FROM Marca INTO @Ped, @Moneda ,@MonedaCambio ,@MonedaBloq
			COMMIT TRANSACTION
	END
	CLOSE Marca
	DEALLOCATE Marca
	RETURN -1