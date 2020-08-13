USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_ctacte_persona]    Script Date: 06/11/2018 13:57:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_ctacte_persona](
	[rut_cli] [nvarchar](10) NULL,
	[nombre_cli] [nchar](50) NULL,
	[observacion] [nvarchar](50) NULL
) ON [PRIMARY]

GO


