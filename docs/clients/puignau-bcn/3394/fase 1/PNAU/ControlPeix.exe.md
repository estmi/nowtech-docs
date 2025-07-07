# Control Peix

## DBI

S'afegeix la funcionalitat de carrega de `Ahora.ini` que hi havia a Puignau Implementacio DBI.

### SQL procedures to review

- [X] pPers_CrearComandaClient
- [X] pPers_Actualitzar_Preus_Article
- [X] pPers_Inicialitzar_Preus_A0

### Queries Delphi (Done)

- quAHCarregaComandesPeixFresc
- quAHActualitzarPreusArticle
- quAHLiniesComandaNoReservades
- quAHQuantitatArticlesComandes
- quAHCarregaComandesPeixManipulat
- quAHArticle
- quAHLiniesImpresesPreparadorRutaPeixFresc
- quAHLiniesImpresesPreparadorRutaPeixManipulat

### Queries Delphi (To review)

- [X] quAHCrearComanda: IdEmrpesa no es te en compte
- [X] quAHArticles: Funciona de puignau, no existeix la vista.
- [X] quAHArticlesActius: La vista no existeix enlloc
- [X] quAHCanviComentaris: No existeix el ppers
- [X] quAHIncialitzarPreus0: No contempla barcelona
- [X] quAHPreparadorsData: No existeix
- [X] quAHClients: Desus

### Queries Delphi (Nothing)

- quAHEliminarComanda
- quAHPreuVendaArticleClient
- quAHLiniesComandaBundle
- quAHLiniesComandaReservesTipusLlotja
- quAHComanda
- quAHActualitzarLiniaComanda
- quAHActualitzarObservacionsLiniaComanda
- quAHCrearLiniaComanda
- quAHEliminarLiniaComanda
- quAHAlbaraJaActualitzat
- quAHEstocArticles
- quAHIvaArticle
- quAHActualitzarComercialClient
- quAHPreuArticleClient
- quAHCrearExcepcioOferta
- quAHBuidarTaulaPreus
- quAHBuidarTaulaExcepcionsPreus
- quAHSyncPrecios

## DImportacio

### SQL procedures to review

- [X] pPers_Importar_Ahora_Articles: Afegir Empresa
- [X] pPers_Importar_Ahora_Clients: BD AHORA_ERP_ARRANQUE no existeix

    ```SQL
    -- =============================================
    -- Author:		Dani Coll
    -- Create date: 2024-09-04
    -- Description:	Importar Clients d'Ahora
    -- =============================================
    ALTER   PROCEDURE [dbo].[pPers_Importar_Ahora_Clients]
    AS
    BEGIN
    Truncate table ClientsContactes
    delete from Clients
    Insert into Clients (Client, Nom, Zona, AdrecaFiscal, AdrecaEnviament, CP, Poblacio, Comercial,
        DataIniciVacances, DataFiVacances, DataBaixa, OperariTelevenda, HoraIniciTelevenda, HoraFiTelevenda,
        ObservacionsTelevenda, NomContacteTelevenda, TelefonTelevenda, TelefonTelevenda2, EmailTelevenda,
        GrupClient, NomGrupClient, DteC, NomContacteComercial, TelefonContacteComercial, TelefonContacteComercial2,
        EmailContacteComercial, ObservacionsComercial, TipusClient, Merma, EnviarEtiquetaEmail, EmailEtiqueta,
        Potencial, TipusABCClient, Objectiu, TipusFacturacio, Actiu, DataAlta, FormaPagament, NomFormaPagament,
        PreClient, ClientEstadistic, PreusMinims, ObservacionsCRM, OfertesLlistats, Idioma)
    Select Client, left(Nom, 50), left(Zona,3), left(AdrecaFiscal, 50), cast(AdrecaEnviament as varchar), left(CP, 5), Poblacio, Comercial,
        DataIniciVacances, DataFiVacances, DataBaixa, OperariTelevenda, HoraIniciTelevenda, HoraFiTelevenda,
        ObservacionsTelevenda, NomContacteTelevenda, TelefonTelevenda, TelefonTelevenda2, EmailTelevenda,
        left(GrupClient, 3), Left(NomGrupClient, 50), DteC, cast(NomContacteComercial as varchar), cast(TelefonContacteComercial as varchar), cast(TelefonContacteComercial2 as varchar),
        EmailContacteComercial, ObservacionsComercial, TipusClient, Merma, EnviarEtiquetaEmail, EmailEtiqueta,
        Potencial, TipusABCClient, Objectiu, TipusFacturacio, Actiu, DataAlta, FormaPagament, NomFormaPagament,
        cast(PreClient as bit), ClientEstadistic, PreusMinims, ObservacionsCRM, OfertesLlistats, Idioma
    From PuignauERP.dbo.vPers_Clients

    INSERT INTO [dbo].[ClientsContactes] ([Client], [TipusContacte], [Departament], [Principal], [Nom], [Carrec], [Observacions]
                , [Telefon], [Telefon2], [Email], [ContacteFactura], [ContacteComercial], [CodiContacte])
            Select cc.IdCliente, null, cc.Departamento, 1, cc.Nombre, cc.Cargo, c.Observaciones
                , cc.TelefonoCasa, cc.TelefonoMovil, cc.E_Mail, null, null, cc.IdContacto
            from PuignauERP..Clientes_Contactos cc 
            left join PuignauERP..contactos c on c.iddoc = cc.iddoc
    END
    ```

- [x] pPers_Importar_Ahora_Consums: Afegir empresa
- [x] pPers_Importar_Ahora_Vendes: Afegir empresa

### Queries Delphi (To review)

- [x] quImportar_Ahora_Articles
- [x] quImportar_Ahora_Clients
- [x] quImportar_Ahora_Consums
- [x] quImportar_Ahora_Vendes

### Queries Delphi (Nothing)

- quImportar_Ahora_Bundles
- quImportar_Ahora_Families
- quImportar_Ahora_GrupsArticles
- quImportar_Ahora_Marques
- quImportar_Ahora_Subgrups
- quImportar_Ahora_Zones

## FControlPeix

### Queries Delphi (Done)

- quTotalsAhora

### Queries Delphi (Nothing)

- quEstatPeix
- quCalculaTotals
- quEstatComandesFresc
- quEstatComandesManipulat
- quEstatComandesSGA
- quEliminarEstatInexistent
- quActualitzarEstatManipulat
- quActualitzarEstatFresc
- quTotals

## FControlPeixFresc

### Queries Delphi (Nothing)

- quEstatComandes

## FControlPeixSGA

### Done

- quEstatSGARutes
- quEstatSGARutesPrep

## GCarregaComandesPeixFresc

### SQL procedures to review

- [X] pPers_PeixFresc_Eliminar_Comandes_Inexistents: No contempla empresa

## GCarregaComandesPeixManipulat

### SQL procedures to review

- [X] pPers_PeixManipulat_Eliminar_Comandes_Inexistents: No contempla empresa

## LInformeArticlesTraspasCompresMercaBCN

Aplicar carrega ini i switch connexio.
