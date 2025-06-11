---
toc_min_heading_level: 2
toc_max_heading_level: 2
---
# Test: fPers_DamePrecio_Articulo_Delegacion

## Test 1

```sql
DECLARE @IdArticulo T_ID_Articulo, @Fecha datetime, @IdCliente T_Id_Cliente, @IdLista T_Id_Lista

Set @IdArticulo = '00029'
Set @Fecha = '20250505'
Set @IdCliente = '5535'
Select @IdLista = 1

select 'Base' as Origen, * from FunPers_DamePrecio_Articulo(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null)
union all
select 'Puignau', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 0)
union all
select 'PBCN', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 2)
```

### Test Result

![test_result_fPers_DamePrecio_Articulo_Delegacion]

## Test 2

```sql
DECLARE @IdArticulo T_ID_Articulo, @Fecha datetime, @IdCliente T_Id_Cliente, @IdLista T_Id_Lista

Set @IdArticulo = '00029'
Set @Fecha = '20250505'
Set @IdCliente = '5535'
Select @IdLista = 50

select 'Base' as Origen, * from FunPers_DamePrecio_Articulo(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null)
union all
select 'Puignau', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 0)
union all
select 'PBCN', * from fPers_DamePrecio_Articulo_Delegacion(@IdArticulo, @IdCliente, @IdLista, @Fecha, null,null, 2)
```

### Test Result

![test_result_fPers_DamePrecio_Articulo_Delegacion2]

[test_result_fPers_DamePrecio_Articulo_Delegacion]: /puignau-bcn\3394\test_scripts\test_result_fPers_DamePrecio_Articulo_Delegacion.png
[test_result_fPers_DamePrecio_Articulo_Delegacion2]: /puignau-bcn\3394\test_scripts\test_result_fPers_DamePrecio_Articulo_Delegacion2.png
