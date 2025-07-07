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