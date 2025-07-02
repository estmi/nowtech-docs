DECLARE @Client T_Id_Cliente, @Date T_Fecha_corta, @Import T_Decimal

Set @Client = '4440'
Set @Date = '20250706'
Set @Import = 100

select @Client, @Date, @Import, * from fPers_ObtenirRecarrecPerClient(@Client, @Date)
outer apply [fPers_ObtenirRecarrecPerClientIImport_new](@Client, @import, @Date)


select * from pers_recarrec_client where idCliente = @Client