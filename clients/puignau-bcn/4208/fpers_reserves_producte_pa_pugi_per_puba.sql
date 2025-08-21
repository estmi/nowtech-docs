SELECT pugiaa.CasellaCompra, pugica.Nom, pugiaa.Article, pugiaa.Nom, pugi.UnitatsAssignades, pugiaa.TipusUnitat,pugiaa.PreuCost, pugiaa.PreuCostTotal
FROM puignau..ArticleArrivaReserves pugi
INNER JOIN puignaubcn..ArticleArriva pubaaa on pubaaa.IdLlotjaGirona = pugi.IdLlotja
INNER JOIN puignau..ArticleArriva pugiaa on pugiaa.Id = pugi.IdLlotja
LEFT JOIN puignau..CasellesCompres pugica on pugica.Casella = pugiaa.CasellaCompra
WHERE Client = 6507