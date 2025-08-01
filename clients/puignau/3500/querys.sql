-- ========== QUERY FACTS ==========

Select
CLIE_NOMCOMERCIAL as NomClient,
CLIE_CLIENT as CodiClient,
FACT_FACTURA as CodiFactura,
FACT_DATA as DataFactura,
FACT_BASE1 as Base1,
FACT_BASE2 as Base2,
FACT_BASE3 as Base3,
FACT_BASEEXEMPTA as BaseExempta,
FACT_IMPORTIVA1 as ImportIva1,
FACT_IMPORTIVA2 as ImportIva2,
FACT_IMPORTIVA3 as ImportIva3,
FACT_ANY as FacturaAny,
FACT_Diari as FacturaDiari

From Factures
Join Clients on CLIE_CLIENT = FACT_CLIENT

Where CLIE_GRUPCLIENT = 30
AND FACT_DATA >= :DataInici AND FACT_DATA <= :DataFi
Order by FACT_CLIENT, FACT_DATA, FACT_ANY, FACT_FACTURA

-- ========== QUERY FACTS ==========
-- ========== QUERY LINIES ==========

Select
CLIE_NOMCOMERCIAL as NomClient,
CLIE_CLIENT as CodiClient,
FACT_FACTURA as CodiFactura,
FACT_DATA as DataFactura,
ARTI_ARTICLE as CodiProducte,
ARTI_DESCRIPCIO as Concepte,
MESU_DESCRIPCIO as UnitatMesura,
DEAL_QUANTITAT as Quantitat,
DEAL_PREUVENDA as PreuUnitari,
(Select TIIV_IVA From TipusIves Where TIIV_TIPUSIVA = DEAL_TIPUSIVA Order by TIIV_DATA desc Limit 1) as PercentatgeImpost,
ALBA_ALBARA as ReferenciaAlbara,
ALBA_DATA as DataAlbara,
DEAL_COMANDA as ReferenciaComanda,
FACT_IMPORTIVA1 as ImportIva1,
FACT_IMPORTIVA2 as ImportIva2,
FACT_IMPORTIVA3 as ImportIva3,
FACT_ANY as FacturaAny,
FACT_Diari as FacturaDiari,
FACT_BASE1 as Base1,
FACT_BASE2 as Base2,
FACT_BASE3 as Base3,
FACT_BASEEXEMPTA as BaseExempta,
DEAL_ARTICLE as ArticleAlbara

From DetallAlbarans
Join Albarans on ALBA_ANY = DEAL_ANY AND ALBA_CANAL = DEAL_CANAL AND ALBA_DIARI = DEAL_DIARI AND ALBA_ALBARA = DEAL_ALBARA
Join Factures on FACT_CANAL = ALBA_CANALFACTURA AND FACT_ANY = ALBA_ANYFACTURA  AND FACT_DIARI = ALBA_DIARIFACTURA AND FACT_FACTURA = ALBA_FACTURA
Join Clients on CLIE_CLIENT = FACT_CLIENT
Left Join Articles on ARTI_ARTICLE = DEAL_ARTICLE
Left Join Mesures on MESU_MESURA = ARTI_MESURA

Where CLIE_GRUPCLIENT = 30
AND IfNull(DEAL_PARE,0) = 0
AND FACT_DATA >= :DataInici AND FACT_DATA <= :DataFi
AND ARTI_ARTICLE <> ''
Order by FACT_CLIENT, FACT_DATA, FACT_ANY, FACT_FACTURA, DEAL_ANY, DEAL_ALBARA, DEAL_ARTICLE


-- ========== QUERY LINIES ==========