-- =============================================
-- Author:		Dani Coll
-- Create date: 2024-09-04
-- Description:	Importar Clients d'Ahora
-- =============================================
ALTER   PROCEDURE [dbo].[pPers_Importar_Ahora_Clients]
AS
BEGIN
Truncate table ClientsContactes
delete from Clients where client > 0
Insert into Clients (Client, Nom, Zona, AdrecaFiscal, AdrecaEnviament, CP, Poblacio, Comercial,
      DataIniciVacances, DataFiVacances, DataBaixa, OperariTelevenda, HoraIniciTelevenda, HoraFiTelevenda,
      ObservacionsTelevenda, NomContacteTelevenda, TelefonTelevenda, TelefonTelevenda2, EmailTelevenda,
	  GrupClient, NomGrupClient, DteC, NomContacteComercial, TelefonContacteComercial, TelefonContacteComercial2,
	  EmailContacteComercial, ObservacionsComercial, TipusClient, Merma, EnviarEtiquetaEmail, EmailEtiqueta,
	  Potencial, TipusABCClient, Objectiu, TipusFacturacio, Actiu, DataAlta, FormaPagament, NomFormaPagament,
	  PreClient, ClientEstadistic, PreusMinims, ObservacionsCRM, OfertesLlistats, Idioma)
Select Client, left(Nom, 50), left(Zona,3), left(AdrecaFiscal, 50), left(AdrecaEnviament, 50), left(CP, 5), Poblacio, Comercial,
      DataIniciVacances, DataFiVacances, DataBaixa, OperariTelevenda, HoraIniciTelevenda, HoraFiTelevenda,
      ObservacionsTelevenda, NomContacteTelevenda, TelefonTelevenda, TelefonTelevenda2, EmailTelevenda,
	  left(GrupClient, 3), Left(NomGrupClient, 50), DteC, cast(NomContacteComercial as varchar), cast(TelefonContacteComercial as varchar), cast(TelefonContacteComercial2 as varchar),
	  EmailContacteComercial, ObservacionsComercial, TipusClient, Merma, EnviarEtiquetaEmail, EmailEtiqueta,
	  Potencial, TipusABCClient, Objectiu, TipusFacturacio, Actiu, DataAlta, FormaPagament, NomFormaPagament,
	  cast(PreClient as bit), ClientEstadistic, PreusMinims, ObservacionsCRM, OfertesLlistats, Idioma
From PuignauERP.dbo.vPers_Clients

INSERT INTO [dbo].[ClientsContactes]
           ([Client], [TipusContacte], [Departament], [Principal], [Nom], [Carrec], [Observacions]
           , [Telefon], [Telefon2], [Email], [ContacteFactura], [ContacteComercial], [CodiContacte])
		   Select cc.IdCliente, null, cc.Departamento, 1, cc.Nombre, cc.Cargo, c.Observaciones
		   , cc.TelefonoCasa, cc.TelefonoMovil, cc.E_Mail, null, null, cc.IdContacto
		   from PuignauERP..Clientes_Contactos cc 
		   left join PuignauERP..contactos c on c.iddoc = cc.iddoc
END