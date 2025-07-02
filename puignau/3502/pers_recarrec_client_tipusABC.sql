CREATE TABLE [dbo].[pers_recarrec_client_tipusABC](
	TipusABC varchar(1) NOT NULL,
	[importMinim] [decimal](38, 14) NOT NULL,
	[importDilluns] [decimal](38, 14) NULL,
	[importDimarts] [decimal](38, 14) NULL,
	[importDimecres] [decimal](38, 14) NULL,
	[importDijous] [decimal](38, 14) NULL,
	[importDivendres] [decimal](38, 14) NULL,
	[importDissabte] [decimal](38, 14) NULL,
	[importDiumenge] [decimal](38, 14) NULL,
	[IdDoc] [dbo].[T_Id_Doc] IDENTITY(1,1) NOT NULL,
	[InsertUpdate] [dbo].[T_CEESI_Insert_Update] NOT NULL,
	[Usuario] [dbo].[T_CEESI_Usuario] NOT NULL,
	[FechaInsertUpdate] [dbo].[T_CEESI_Fecha_Sistema] NOT NULL,
 CONSTRAINT [PK_pers_recarrec_client_tipusABC] PRIMARY KEY CLUSTERED 
(
	[IdDoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].pers_recarrec_client_tipusABC ADD  CONSTRAINT [DF_pers_recarrec_client_tipusABC_InsertUpdate]  DEFAULT ((0)) FOR [InsertUpdate]
GO

ALTER TABLE [dbo].pers_recarrec_client_tipusABC ADD  CONSTRAINT [DF_pers_recarrec_client_tipusABC_Usuario]  DEFAULT (user_name()) FOR [Usuario]
GO

ALTER TABLE [dbo].pers_recarrec_client_tipusABC ADD  CONSTRAINT [DF_pers_recarrec_client_tipusABC_FechaInsertUpdate]  DEFAULT (getdate()) FOR [FechaInsertUpdate]
GO