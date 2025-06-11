---
toc_min_heading_level: 2
toc_max_heading_level: 2
---
# Test: fPers_Dame_Precio_Coste_Delegacion

## Test 1

```sql
DECLARE @IdArticulo T_ID_Articulo, @Fecha datetime

Set @IdArticulo = '00029'
Set @Fecha = '20250505'

select 'Base' as Origen, * from fPers_Dame_Precio_Coste(@IdArticulo, @Fecha, null, null)
union all
select 'Puignau', * from fPers_Dame_Precio_Coste_Delegacion(@IdArticulo, @Fecha, null, null, 0)
union all
select 'PBCN', * from fPers_Dame_Precio_Coste_Delegacion(@IdArticulo, @Fecha, null, null, 2)
```

### Test Result

![test_result_fPers_Dame_Precio_Coste]

[test_result_fPers_Dame_Precio_Coste]: /puignau-bcn\3394\test_scripts\test_result_fPers_Dame_Precio_Coste.png
