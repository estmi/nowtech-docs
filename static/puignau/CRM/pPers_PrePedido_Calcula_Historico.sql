ALTER PROCEDURE [dbo].[pPers_PrePedido_Calcula_Historico]
AS
BEGIN
        SET NOCOUNT ON;

    DECLARE @ErrorMessage VARCHAR(500) = '';
    DECLARE @Registros INT = 0;
	DECLARE @Meses int = 10;  -- Cambia este valor según la cantidad de meses que deseas considerar

    BEGIN TRY
        -------------------------------------------------------------------------
        -- PASO 1: Limpiar la tabla temporal antes de cargarla (evitando TRUNCATE)
        -------------------------------------------------------------------------
        DELETE FROM dbo.Pers_PrePedido_Calculo_Historico_temp WITH (TABLOCK);

        -- Evitar bloqueos escalados en la tabla temporal
        ALTER TABLE dbo.Pers_PrePedido_Calculo_Historico_temp SET (LOCK_ESCALATION = DISABLE);

        -- Esperar un poco para evitar conflictos si hay ejecuciones concurrentes
        WAITFOR DELAY '00:00:02';

        -------------------------------------------------------------------------
        -- PASO 2: Cargar la información en la tabla temporal (sin cursor)
        -------------------------------------------------------------------------
        WITH CTE_Filtrada AS (
			SELECT 
				PCC.IdCliente,
				coalesce(cpc.Pers_DataPreparacio,pcc.fecha) as Fecha,
				PCL.Observaciones,
				PCL.IdArticulo,
				CAST(0 AS DECIMAL(18,2)) AS Cant,
				COALESCE(pcl.TipoUnidadPres,
					(SELECT TOP 1 IdTipoUnidad 
					 FROM dbo.funPers_PrePedidoUnidades(A.IdArticulo, 2)),
					 A.IdTipoUnidadPres,
					 A.TipoCantidad
				) AS IdTipoUnidad,
				ISNULL(Precio2.Precio, PCL.Precio_EURO) AS PrecioUnidad,
				PCL.Descuento,
				COALESCE(PCL.Total_Euros, 0) AS Ultimpreu,
				SUM(PCL.Total_Euros) OVER (PARTITION BY PCC.IdCliente, PCL.IdArticulo) AS VentaAcumulada,
				A.Descrip AS DescripArticle,
				ROW_NUMBER() OVER (PARTITION BY PCC.IdCliente, PCL.IdArticulo ORDER BY PCC.Fecha DESC) AS RowNum
			FROM pedidos_cli_cabecera AS PCC WITH (NOLOCK)
			INNER JOIN pedidos_cli_lineas AS PCL WITH (NOLOCK)
				ON PCC.IdPedido = PCL.IdPedido
				AND PCC.Fecha > DATEADD(MONTH, -@Meses, GETDATE()) 
				AND PCL.IdDocPadre IS NULL			
			LEFT JOIN Conf_Pedidos_Cli cpc WITH (NOLOCK) on  PCC.idpedido = cpc.IdPedido 
			INNER JOIN Articulos AS A WITH (NOLOCK)
				ON PCL.IdArticulo = A.IdArticulo
			OUTER APPLY 
			(
				SELECT Precio
				FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
				(
					PCL.IdArticulo, PCC.IdCliente, NULL, GETDATE(), NULL, NULL,
						(select top 1 iddelegacion from Clientes_Datos where IdCliente = PCC.IdCliente)
				)
			) AS Precio2
		),
		 cteParte2 AS
            (
                SELECT
                    Client AS IdCliente,
                    f2.ultimaVenda AS Fecha, a.descrip as DescripArticle,
                    NULL AS Observaciones,
                    f2.Article AS IdArticulo,
                    CAST(0 AS DECIMAL(18,2)) AS Cant,
                    (COALESCE(
                        COALESCE((SELECT TOP 1 IdTipoUnidad 
                                  FROM dbo.funPers_PrePedidoUnidades(a.IdArticulo,2)),
                                  a.IdTipoUnidadPres),
                        a.TipoCantidad)
                    ) AS IdTipoUnidad,
                    ISNULL(Precio.Precio, 0) AS PrecioUnidad,
                    0 AS Descuento,
                    COALESCE(ultimPreuvenda, 0) AS Ultimpreu,
                    VentaAcumulada
                FROM Pers_Historic_Vendes_Comandes_Rapides_Prigest AS f2 WITH (NOLOCK)
                INNER JOIN Articulos AS A WITH (NOLOCK)
                    ON f2.Article = A.IdArticulo
                LEFT JOIN vPers_PrePedido_Combo_Articulo_TipoUnidad AS tu2 WITH (NOLOCK)
                    ON f2.Article = tu2.IdArticulo
                    AND tu2.tipodefault = 1
                OUTER APPLY
                (
                    SELECT Precio 
                    FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
                    (
                        A.IdArticulo,
                        Client,
                        NULL,
                        GETDATE(),
                        NULL, 
                        NULL,
						(select top 1 iddelegacion from Clientes_Datos where IdCliente = Client)
                    )
                ) AS Precio
                WHERE  f2.DataUltimaVenda > DATEADD(MONTH, -@Meses, GETDATE())
                   AND NOT EXISTS (
					SELECT 1
					FROM CTE_Filtrada c1
					WHERE c1.IdArticulo = f2.Article
					  AND c1.IdCliente = f2.Client
				)
            )
		INSERT INTO dbo.Pers_PrePedido_Calculo_Historico_temp
		(
			IdCliente, Fecha, Observaciones, IdArticulo, Cant, IdTipoUnidad,
			PrecioUnidad, Descuento, Ultimpreu, VentaAcumulada, DescripArticle
		)
		SELECT 
			IdCliente, Fecha, Observaciones, IdArticulo, Cant, IdTipoUnidad,
			PrecioUnidad, Descuento, Ultimpreu, VentaAcumulada, DescripArticle
		FROM CTE_Filtrada
		UNION ALL
		SELECT IdCliente, Fecha, Observaciones, IdArticulo, Cant, IdTipoUnidad,
			PrecioUnidad, Descuento, Ultimpreu, VentaAcumulada, DescripArticle 
		FROM cteParte2
		--WHERE RowNum = 1; -- SOLO INSERTA EL REGISTRO MÁS RECIENTE POR CADA IdCliente-IdArticulo


        -- Contar registros insertados
        SET @Registros = @@ROWCOUNT;

        -- ACTUALIZAMOS PRECIOS CONJUNTOS
		--===========================
		-- Calcul incorrecte, els bundles el preu esta separat entre preciounidad i preciofeina
		--===========================
       /* UPDATE P
			SET PrecioUnidad = COALESCE(
				(SELECT PrecioTotal 
				 FROM dbo.[fPers_DamePrecio_Articulo_Bundle_Delegacion](P.IdArticulo, P.IdCliente,(select top 1 iddelegacion from Clientes_Datos where IdCliente =  P.IdCliente) )), 
				0
			)
			FROM Pers_PrePedido_Calculo_Historico_temp P
			WHERE P.IdArticulo IN (SELECT IdArticuloPadre FROM Articulos_Conjuntos);
			*/
		--===========END (commented on 20250610 1054)================
		-- Calcul incorrecte, els bundles el preu esta separat entre preciounidad i preciofeina
		--===========================
		--ELIMINAMOS FILAS REPETIDAS
		WITH CTE2 AS
			(
				SELECT 
					IdCliente,
					IdArticulo,
					Fecha,
					Observaciones,
					Cant,
					IdTipoUnidad,
					PrecioUnidad,
					Descuento,
					Ultimpreu,
					VentaAcumulada,
					DescripArticle,
					PrecioCoste,
					ROW_NUMBER() OVER (
						PARTITION BY IdCliente, IdArticulo
						ORDER BY fecha DESC
					) AS rn
				FROM Pers_PrePedido_Calculo_Historico_temp
			)
			DELETE
			FROM CTE2
			WHERE rn > 1;

        -- ELIMINAMOS REGISTROS EXCEDENTES
        WITH CTE AS 
        (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY fecha DESC) AS RowNum
            FROM Pers_PrePedido_Calculo_Historico_temp
            WHERE Observaciones NOT LIKE '%[RC LLOT]%' 
              AND Observaciones NOT LIKE '%< [RT LLOT] >%' 
              AND Observaciones NOT LIKE '%[RC NEV]>%' 
              AND Observaciones NOT LIKE '%< [RT NEV] >%'
              AND Observaciones NOT LIKE '%[RC PA]%' 
              AND Observaciones NOT LIKE '%< [RT PA] >%' 
              AND Observaciones NOT LIKE '%[RC LIQ]%' 
              AND Observaciones NOT LIKE '%< [RT LIQ] >%'
        )
        DELETE FROM CTE WHERE RowNum > 100;

        -- LIMPIEZA DE OBSERVACIONES
        UPDATE Pers_PrePedido_Calculo_Historico_temp 
        SET Observaciones = '' 
        WHERE Observaciones LIKE '%[RR LLOT]%' 
           OR Observaciones LIKE '%[RC LLOT]%' 
           OR Observaciones LIKE '%< [RT LLOT] >%'
           OR Observaciones LIKE '%[RC NEV]%' 
           OR Observaciones LIKE '%[RR NEV]%' 
           OR Observaciones LIKE '%< [RT NEV] >%'
           OR Observaciones LIKE '%[RC PA]%' 
           OR Observaciones LIKE '%[RR PA]%' 
           OR Observaciones LIKE '%< [RT PA] >%'
           OR Observaciones LIKE '%[RC LIQ]%' 
           OR Observaciones LIKE '%[RR LIQ]%' 
           OR Observaciones LIKE '%< [RT LIQ] >%';

        -- ACTUALIZACIÓN DE PRECIOS SEGÚN FAMILIA
        UPDATE Pers_PrePedido_Calculo_Historico_temp 
        SET PrecioUnidad = 0
        WHERE IdArticulo IN 
              (SELECT IDARTICULO FROM vPers_Articles_Simplificado WHERE Familia ='PFC');

        -- ELIMINACIÓN SEGÚN FAMILIA
        DELETE FROM Pers_PrePedido_Calculo_Historico_temp 
        WHERE IdArticulo IN 
              (SELECT IDARTICULO FROM vPers_Articles_Simplificado WHERE Familia IN ('XX','Z-TX','ZA-TX','ZZ'));

		--ACTUALIZAMOS COSTES:
		UPDATE PH
			SET PH.PrecioCoste = FC.Coste
			FROM Pers_PrePedido_Calculo_Historico_temp PH
			CROSS APPLY dbo.fPers_Dame_Precio_Coste_Delegacion(
				PH.IdArticulo,   -- @IdArticulo
				GETDATE(),       -- @Fecha
				NULL,            -- @IdPedido
				NULL,            -- @IdLinea
				(select IdDelegacion from clientes_datos cd where cd.idcliente = ph.IdCliente)
			) AS FC;

		--ACTUALIZAMOS ULTIM PREU
		
		UPDATE P
		SET 
			P.fecha = V.FechaAlbaran,
			P.Ultimpreu = V.Precio_EURO
		FROM 
			Pers_PrePedido_Calculo_Historico_temp P
		INNER JOIN 
			vPers_PrePedido_Calculo_Ventas V
			ON P.IdCliente = V.IdCliente AND P.IdArticulo = V.IdArticulo




		--ACTUALIZAMOS VENTA ACUMULADA
		UPDATE P
		SET 
			P.VentaAcumulada = ISNULL(T.TotalEurosAcumulados, 0)
			
		FROM 
			Pers_PrePedido_Calculo_Historico_temp P
		LEFT JOIN (
			SELECT 
				pcc.IdCliente,
				pcl.IdArticulo,
				SUM(pcl.Cantidad) AS TotalEurosAcumulados
			FROM 
				Pedidos_Cli_Lineas pcl
			INNER JOIN 
				Pedidos_Cli_Cabecera pcc ON pcl.IdPedido = pcc.IdPedido
			WHERE 
				pcl.FechaAlbaran >= DATEADD(MONTH, -@Meses, GETDATE())  -- Últimos 13 meses
				AND pcl.FechaAlbaran IS NOT NULL
			GROUP BY 
				pcc.IdCliente, pcl.IdArticulo
		) T
		ON P.IdCliente = T.IdCliente AND P.IdArticulo = T.IdArticulo;


		--ACTUALIZAMOS BUNDLES Y PRECIOS

		update pph
		set pph.idarticulohijo = ac.IdArticulo,pph.IdArticuloFeina = acFeina.IdArticulo, pph.PrecioFeina=PrecioFeina.Precio , pph.PrecioUnidad = PrecioArt.Precio

		from Pers_PrePedido_Calculo_Historico_temp pph
		inner join Articulos_Conjuntos ac ON ac.IdArticuloPadre = pph.IdArticulo and ac.IdArticulo not in (select Article from vPers_Articles where Familia = 'Z-TX')
		inner join Articulos_Conjuntos acFeina ON acFeina.IdArticuloPadre = pph.IdArticulo and acFeina.IdArticulo  in (select Article from vPers_Articles where Familia = 'Z-TX')
		OUTER APPLY 
					(
						SELECT Precio
						FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
						(
							acFeina.IdArticulo, pph.IdCliente, NULL, GETDATE(), NULL, NULL,
								(select top 1 iddelegacion from Clientes_Datos where IdCliente = pph.IdCliente)
						)
					) AS PrecioFeina
		OUTER APPLY 
					(
						SELECT Precio
						FROM dbo.fPers_DamePrecio_Articulo_Delegacion_v2
						(
							ac.IdArticulo, pph.IdCliente, NULL, GETDATE(), NULL, NULL,
								(select top 1 iddelegacion from Clientes_Datos where IdCliente = pph.IdCliente)
						)
					) AS PrecioArt


        -------------------------------------------------------------------------
        -- PASO 3: Insertar datos en la tabla real (evitando TRUNCATE)
        -------------------------------------------------------------------------
        IF EXISTS (SELECT 1 FROM Pers_PrePedido_Calculo_Historico_temp)
        BEGIN
            DELETE FROM dbo.Pers_PrePedido_Calculo_Historico WITH (TABLOCK);

            INSERT INTO dbo.Pers_PrePedido_Calculo_Historico
            (
                IdCliente, Fecha, Observaciones, IdArticulo, Cant, IdTipoUnidad,
                PrecioUnidad, Descuento, Ultimpreu, VentaAcumulada, DescripArticle, PrecioCoste, PrecioFeina, IdArticuloFeina, IdArticuloHijo
            )
            SELECT 
                IdCliente, Fecha, Observaciones, IdArticulo, Cant, IdTipoUnidad,
                PrecioUnidad, Descuento, Ultimpreu, VentaAcumulada, DescripArticle, PrecioCoste, PrecioFeina, IdArticuloFeina, IdArticuloHijo
            FROM dbo.Pers_PrePedido_Calculo_Historico_temp;
        END

        -------------------------------------------------------------------------
        -- PASO 4: Registrar la ejecución en el log
        -------------------------------------------------------------------------
        INSERT INTO dbo.Pers_PrePedido_Calculo_Historico_Log
            (FechaHora, RegistrosProcesados, Resultado)
        VALUES
            (GETDATE(), @Registros, 'OK');

    END TRY
    BEGIN CATCH
        -- Captura el error y lo registra en el log
        SET @ErrorMessage = ERROR_MESSAGE();

        INSERT INTO dbo.Pers_PrePedido_Calculo_Historico_Log
            (FechaHora, RegistrosProcesados, Resultado)
        VALUES
            (GETDATE(), @Registros, @ErrorMessage);

        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;