DECLARE @IdArticulo T_ID_Articulo, @Fecha datetime, @IdCliente T_Id_Cliente, @IdLista T_Id_Lista

Set @IdArticulo = '00029'
Set @Fecha = '20250505'
Set @IdCliente = '50'
Select @IdLista = 50

select 'Base' as Origen, * from FunPers_DamePrecio_Articulo(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null)
union all
select 'Puignau', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 0)
union all
select 'PBCN', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 2)