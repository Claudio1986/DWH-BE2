USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_asignacion_maestro]    Script Date: 06/11/2018 13:53:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_asignacion_maestro](
	[RUT] [nvarchar](10) NULL,
	[RUT EJECUTIVO] [nvarchar](10) NULL,
	[EJECUTIVO] [nvarchar](50) NULL,
	[PLATAFORMA] [nvarchar](50) NULL,
	[CANAL] [nvarchar](50) NULL,
	[CLIENTE] [nvarchar](50) NULL
) ON [PRIMARY]

GO


