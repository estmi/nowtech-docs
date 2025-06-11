---
toc_min_heading_level: 2
toc_max_heading_level: 2
---
# Test: fPers_Vendes_Empresa

## Test 1

```sql
Declare @DataInici datetime, @DataFi datetime

Set @DataInici = '20250505'
Set @DataFi = @DataInici;

select 'OLD' origin, count(*) total, count(distinct Client) clients, Count(distinct article) articles, 
	sum(Import) totalImport, sum(totalcost) totalCost, sum(preuvenda) totalPreuVenda 
from fPers_Vendes_old(@DataInici, @DataFi)
union all
select 'Puignau', count(*) total, count(distinct Client) clients, Count(distinct article) articles, 
	sum(Import) totalImport, sum(totalcost) totalCost, sum(preuvenda) totalPreuVenda 
from fPers_Vendes_Empresa(@DataInici, @DataFi, 0)
union all
select 'Base', count(*) total, count(distinct Client) clients, Count(distinct article) articles, 
	sum(Import) totalImport, sum(totalcost) totalCost, sum(preuvenda) totalPreuVenda 
from fPers_Vendes(@DataInici, @DataFi)
```

### Test Result

![test_result_fPers_Vendes_Empresa]

[test_result_fPers_Vendes_Empresa]: /puignau-bcn\3394\test_scripts\test_result_fPers_Vendes_Empresa.png
