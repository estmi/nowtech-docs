CREATE FUNCTION fpers_reserves_producte_pa_pugi_per_puba(@Data date)
RETURNS TABLE 
AS
RETURN 
(
	SELECT pugiaa.CasellaCompra
		, pugica.Nom as NomCasella
		, pugiaa.Article
		, pugiaa.Nom as NomArticle
		, pugi.UnitatsAssignades
		, pugiaa.TipusUnitat
		, pugiaa.PreuCost
		, pugiaa.PreuCostTotal
	FROM puignau..ArticleArrivaReserves pugi
	INNER JOIN puignaubcn..ArticleArriva pubaaa on pubaaa.IdLlotjaGirona = pugi.IdLlotja
	INNER JOIN puignau..ArticleArriva pugiaa on pugiaa.Id = pugi.IdLlotja
	LEFT JOIN puignau..CasellesCompres pugica on pugica.Casella = pugiaa.CasellaCompra
	WHERE Client = 6507 and pugiaa.Data = @Data
)