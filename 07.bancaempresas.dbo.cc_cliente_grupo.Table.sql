USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_cliente_grupo]    Script Date: 06/11/2018 13:56:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_cliente_grupo](
	[rut_cli] [nchar](10) NULL,
	[nombre_cli] [nvarchar](50) NULL,
	[plataforma] [nchar](15) NULL,
	[canal] [nchar](15) NULL,
	[descripcion] [nchar](30) NULL
) ON [PRIMARY]

GO


