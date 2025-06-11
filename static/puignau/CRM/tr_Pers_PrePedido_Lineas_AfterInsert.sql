ALTER TRIGGER [dbo].[tr_Pers_PrePedido_Lineas_AfterInsert]
ON [dbo].[Pers_PrePedido_Lineas]
AFTER INSERT
AS
BEGIN
    if (select COUNT(*) from inserted  where DescripArticle is null or DescripArticle = '') >0
    begin
        update Pl
        set pl.DescripArticle = a.descrip--concat(a.IdArticulo,' ', a.descrip)
        , LinNueva = null
        from [Pers_PrePedido_Lineas] pl
        inner join inserted i on pl.IdPrePedido = i.IdPrePedido and pl.IdPrePedidoLinea = i.IdPrePedidoLinea
        left join Articulos a on i.IdArticulo = a.IdArticulo
        where i.DescripArticle is null or i.DescripArticle = ''
    end
    if (select COUNT(*) from inserted lin
        left join Pers_PrePedido p on p.IdPrePedido = lin.IdPrePedido
        where (Precio is null or nullif(PrecioFeina, 0) is null) and p.Modo <> 1 ) >0
    begin
        declare @ids table (iddoc int)
        insert into @ids (iddoc) select iddoc from inserted where Precio is null or nullif(PrecioFeina, 0) is null
        while (select COUNT(*) from @ids) >0
        begin
            DECLARE @IdGestioReserva INT
            declare @currentId int
            declare @Preu decimal (38,14)
            declare @TipoObs int
            declare @Modo int
            declare @fixarpreuventa bit
            declare @Tipound varchar (10)
            declare @IdArt varchar (50)
            declare @OrigenTaula varchar (50)
            declare @idCli varchar (15)
            declare @Obs varchar (255)
            set @currentId = (select top 1 iddoc from @ids )
            --ACTUALITZACIÓ
            select top 1 @IdArt= idarticulo , @idCli = p.IdCliente, @Modo = p.Modo, @IdGestioReserva = i.IdOrigenReserva, @Obs = i.Observacion, @OrigenTaula = OrigenTaula, @TipoObs = TipoObservacion,
            @fixarpreuventa = PreuFixat, @Tipound = TipoUnidad
            from inserted i
            left join Pers_PrePedido p on i.IdPrePedido = p.IdPrePedido
            if (@fixarpreuventa = 1)
            begin
                if (@OrigenTaula = 'ArticleLlotja')
                begin
                    set @Preu = 0
                end
            end
            else
            begin
                if (select count(*) from Articulos_Conjuntos where IdArticuloPadre = @IdArt)>0
                begin
                    SELECT
                        @Preu = sum(p.Precio) 
                    FROM articulos a
                    left join Articulos_Conjuntos ac on a.IdArticulo = ac.IdArticuloPadre
                    LEFT JOIN Clientes_Datos c ON c.IdCliente = @idcli  
                    OUTER APPLY fPers_DamePrecio_Articulo_Delegacion(ac.IdArticulo, c.IdCliente, NULL,
                                            GETDATE(), 0, 0, c.IdDelegacion) p
                    where ac.IdArticulo is not null and c.IdCliente = @idcli and a.IdArticulo = @IdArt
                    group by a.IdArticulo,
                        c.IdCliente
                end
                else
                begin
                    IF (SELECT COUNT(*) FROM Articulos_Conjuntos WHERE IdArticuloPadre = @IdArt)=0
                    BEGIN
                        set @Preu = (select top 1 precio from [dbo].[fPers_DamePrecio_Articulo_Delegacion](@IdArt,@idcli,null,getdate(),null,null, (select IdDelegacion from Clientes_Datos where Clientes_Datos.IdCliente = @idCli)))
                    END
                end
            end
            if @IdGestioReserva is null
            begin
                set @Tipound = (SELECT top 1 IdTipoUnidad FROM [funPers_PrePedidoUnidades](@IdArt,@Modo) )
            end
            if @Tipound is null
            begin
                set @Tipound =(select coalesce(IdTipoUnidadPres, tipocantidad) from Articulos where idarticulo = @IdArt)
            end
            if @Tipound = 'KGS'
            begin
                set @Tipound = 'KG'
            end
            if (@TipoObs is null) or (@TipoObs = 0)
            begin
            set @TipoObs = (SELECT top 1 TipoObservacion FROM fPers_ObtenerObservacionClienteArticulo (@IdArt,@idCli) )
            end
            set @Obs = (select concat((SELECT top 1 Observaciones FROM fPers_ObtenerObservacionClienteArticulo (@IdArt,@idCli) ), @Obs))

            update Pers_PrePedido_Lineas set Precio =  @Preu, TipoUnidad = @Tipound, TipoObservacion = @TipoObs, Observacion = @Obs
            where iddoc = @currentId
            --BUNDLES
            IF (SELECT COUNT(*) FROM Articulos_Conjuntos WHERE IdArticuloPadre = @IdArt)>0
            BEGIN
                with dele as (select top 1 iddelegacion from Clientes_Datos where IdCliente = @idCli)
                update pph
                set pph.idarticulohijo = ac.IdArticulo,pph.IdArticuloFeina = acFeina.IdArticulo, 
                pph.PrecioFeina=PrecioFeina.Precio, 
                pph.Precio=PrecioPare.Precio
                from Pers_PrePedido_Lineas pph
                outer apply dele as d
                left join Articulos_Conjuntos ac ON ac.IdArticuloPadre = pph.IdArticulo and ac.IdArticulo not in 
                (select Article from fPers_Articles(d.iddelegacion) where Familia = 'Z-TX')
                left join Articulos_Conjuntos acFeina ON acFeina.IdArticuloPadre = pph.IdArticulo and acFeina.IdArticulo  in 
                (select Article from fPers_Articles(d.iddelegacion) where Familia = 'Z-TX')
                OUTER APPLY 
                (
                    SELECT Precio
                    FROM dbo.fPers_DamePrecio_Articulo_Delegacion
                    (
                        acFeina.IdArticulo, @idCli, NULL, GETDATE(), NULL, NULL,d.iddelegacion
                    )
                ) AS PrecioFeina
                OUTER APPLY 
                (
                    SELECT Precio
                    FROM dbo.fPers_DamePrecio_Articulo_Delegacion
                    (
                        ac.IdArticulo, @idCli, NULL, GETDATE(), NULL, NULL,d.iddelegacion
                    )
                ) AS PrecioPare
                where pph.iddoc = @currentId
            END

            delete @ids where iddoc = @currentId
        end
    end
end