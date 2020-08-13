USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[visitas]    Script Date: 06/11/2018 15:28:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[visitas](
	[fec_creacion] [datetime] NULL,
	[fec_programada] [datetime] NULL,
	[fec_realizacion] [datetime] NULL,
	[rut_cli] [int] NULL,
	[cliente] [nvarchar](50) NULL,
	[rut_ejc] [int] NULL,
	[ejecutivo] [nvarchar](50) NULL
) ON [PRIMARY]

GO


