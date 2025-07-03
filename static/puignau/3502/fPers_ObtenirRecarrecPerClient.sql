ALTER FUNCTION [dbo].[fPers_ObtenirRecarrecPerClient]
(
	@Client T_Id_Cliente,
	@Date T_Fecha_Corta
)
RETURNS TABLE 
AS
RETURN 
(
	with 
	dadesClient as (
		SELECT importMinim, importDilluns, 
			importDimarts, importDimecres, 
			importDijous, importDivendres, 
			importDissabte, importDiumenge
		FROM pers_recarrec_client
		WHERE idCliente = @Client and (importMinim = -1)
	),
	dadesClient2 as (
		SELECT importMinim, importDilluns, 
			importDimarts, importDimecres, 
			importDijous, importDivendres, 
			importDissabte, importDiumenge
		FROM pers_recarrec_client
		WHERE idCliente = 0 and (importMinim = -1)
	), 
	dadesTipusABC as (
	SELECT importMinim, importDilluns, 
			importDimarts, importDimecres, 
			importDijous, importDivendres, 
			importDissabte, importDiumenge
		FROM pers_recarrec_client_tipusABC recarrecs
		right join conf_clientes cd on cd.P_TipusABC = recarrecs.TipusABC
		WHERE cd.IdCliente = @Client and (importMinim = -1)
	)
	SELECT CASE 
		when (select count(*) from dadesClient) >= 1 then 
			(select case DATEPART(WEEKDAY, @Date)
            WHEN 1 THEN importDilluns
            WHEN 2 THEN importDimarts
            WHEN 3 THEN importDimecres
            WHEN 4 THEN importDijous
            WHEN 5 THEN importDivendres
            WHEN 6 THEN importDissabte
            WHEN 7 THEN importDiumenge
            ELSE 0.0 end as Recarrec
			from dadesClient)
		when (select count(*) from dadesTipusABC) >= 1 then 
			(select case DATEPART(WEEKDAY, @Date)
            WHEN 1 THEN importDilluns
            WHEN 2 THEN importDimarts
            WHEN 3 THEN importDimecres
            WHEN 4 THEN importDijous
            WHEN 5 THEN importDivendres
            WHEN 6 THEN importDissabte
            WHEN 7 THEN importDiumenge
            ELSE 0.0 end as Recarrec
			from dadesTipusABC)
		else
			(select case DATEPART(WEEKDAY, @Date)
            WHEN 1 THEN importDilluns
            WHEN 2 THEN importDimarts
            WHEN 3 THEN importDimecres
            WHEN 4 THEN importDijous
            WHEN 5 THEN importDivendres
            WHEN 6 THEN importDissabte
            WHEN 7 THEN importDiumenge
            ELSE 0.0 end 
			from dadesClient2)
			end as Recarrec, 
			case when DATEPART(WEEKDAY, @Date) = 7 then 1 else 0 end as recarrecDiumenge
)