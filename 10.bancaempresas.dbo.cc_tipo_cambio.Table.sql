USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_tipo_cambio]    Script Date: 06/11/2018 13:58:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_tipo_cambio](
	[FECHA] [nvarchar](8) NULL,
	[VALOR_CLP] [numeric](18, 4) NULL,
	[MONEDA] [numeric](3, 0) NULL,
	[TIPO_MONEDA] [nvarchar](3) NULL,
	[PERIODO] [decimal](2, 0) NULL
) ON [PRIMARY]

GO


