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
