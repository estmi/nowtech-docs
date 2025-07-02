CREATE TABLE pers_recarrec_client_tipusABC(
	TipusABC varchar(1) NOT NULL,
	importMinim decimal(38, 14) NOT NULL,
	importDilluns decimal(38, 14) NULL,
	importDimarts decimal(38, 14) NULL,
	importDimecres decimal(38, 14) NULL,
	importDijous decimal(38, 14) NULL,
	importDivendres decimal(38, 14) NULL,
	importDissabte decimal(38, 14) NULL,
	importDiumenge decimal(38, 14) NULL,
	IdDoc T_Id_Doc IDENTITY(1,1) NOT NULL,
	InsertUpdate T_CEESI_Insert_Update NOT NULL,
	Usuario T_CEESI_Usuario NOT NULL,
	FechaInsertUpdate T_CEESI_Fecha_Sistema NOT NULL,
 CONSTRAINT PK_pers_recarrec_client_tipusABC PRIMARY KEY CLUSTERED 
(
	[IdDoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_InsertUpdate  DEFAULT ((0)) FOR [InsertUpdate]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDilluns  DEFAULT ((0)) FOR [importDilluns]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDimarts  DEFAULT ((0)) FOR [importDimarts]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDimecres  DEFAULT ((0)) FOR [importDimecres]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDijous  DEFAULT ((0)) FOR [importDijous]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDivendres  DEFAULT ((0)) FOR [importDivendres]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDissabte  DEFAULT ((0)) FOR [importDissabte]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_importDiumenge  DEFAULT ((0)) FOR [importDiumenge]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_Usuario  DEFAULT (user_name()) FOR [Usuario]
ALTER TABLE pers_recarrec_client_tipusABC ADD CONSTRAINT DF_pers_recarrec_client_tipusABC_FechaInsertUpdate  DEFAULT (getdate()) FOR [FechaInsertUpdate]

ZPermisos pers_recarrec_client_tipusABC;

CREATE OR ALTER VIEW vpers_recarrec_client_tipusABC as
Select recarrec.*
from pers_recarrec_client_tipusABC recarrec;

ZPermisos vpers_recarrec_client_tipusABC;

-- Crear Objecte
INSERT INTO OBJETOS(Objeto,Descrip,SQL,FiltroDefecto,Limita,Menu,Tabla,Coleccion,AltaDirecta,Personalizado,Libreria,Raiz,Icono1,IdClasificacion) VALUES('Recarrec TipusABC','Recarrec de TipusABC','SELECT * FROM pers_recarrec_client_tipusABC','SELECT * FROM pers_recarrec_client_tipusABC',0,0,'pers_recarrec_client_tipusABC',0,1,1,'AhoraSistema',0,123,0);
-- Update Objecte
UPDATE Objetos SET Sql='SELECT * FROM vpers_recarrec_client_tipusABC',CadenaDescrip='[TipusABC] - [importMinim]' WHERE Objeto='Recarrec TipusABC';

-- Insert Coleccion
INSERT INTO OBJETOS(Objeto,Descrip,SQL,FiltroDefecto,Limita,Menu,Tabla,Coleccion,AltaDirecta,Personalizado,Libreria,Raiz,Icono1,IdClasificacion) VALUES('Recarrecs TipusABC','Recarrecs de TipusABC','SELECT * FROM pers_recarrec_client_tipusABC','SELECT * FROM pers_recarrec_client_tipusABC',0,0,'pers_recarrec_client_tipusABC',1,1,1,'AhoraSistema',1,123,0);
INSERT INTO Objetos_Propiedades(Objeto,Propiedad,Descrip) SELECT 'Recarrecs TipusABC',CAmpo,Campo FROM dbo.funDameObjetosCamposTipos('pers_recarrec_client_tipusABC') WHERE not Campo IN ('IdDoc','FechaInsertUpdate','InsertUpdate','Usuario');
UPDATE Objetos SET HijoDefecto='Recarrec TipusABC' WHERE Objeto='Recarrecs TipusABC';
UPDATE Objetos SET CadenaDescrip='[TipusABC] - [importMinim]' WHERE Objeto='Recarrecs TipusABC';