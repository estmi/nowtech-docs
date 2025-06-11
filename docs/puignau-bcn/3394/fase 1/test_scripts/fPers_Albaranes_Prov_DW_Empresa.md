---
toc_min_heading_level: 2
toc_max_heading_level: 2
---
# Test: fPers_Albaranes_Prov_DW_Empresa

## Test 1

```sql
Declare @Proveidor int

Set @Proveidor = 1395


select 'OLD' origin, count(*) total, count(distinct IdProveedor) IdProveedor, 
	Count(distinct NumAlbaran) NumAlbaran, Count(distinct NumAlbProv) NumAlbProv, 
	sum(BaseEuros) BaseEuros
from fPers_Albaranes_Prov_DW_old(@Proveidor)
union all
select 'Puignau', count(*) total, count(distinct IdProveedor) IdProveedor, 
	Count(distinct NumAlbaran) NumAlbaran, Count(distinct NumAlbProv) NumAlbProv, 
	sum(BaseEuros) BaseEuros
from fPers_Albaranes_Prov_DW_Empresa(@Proveidor, 0)
union all
select 'Base', count(*) total, count(distinct IdProveedor) IdProveedor, 
	Count(distinct NumAlbaran) NumAlbaran, Count(distinct NumAlbProv) NumAlbProv, 
	sum(BaseEuros) BaseEuros
from fPers_Albaranes_Prov_DW(@Proveidor)
```

### Test Result

![test_result_fPers_Albaranes_Prov_DW_Empresa]

[test_result_fPers_Albaranes_Prov_DW_Empresa]: /puignau-bcn/3394/test_scripts/test_result_fPers_Albaranes_Prov_DW_Empresa.png
