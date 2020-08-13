USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_cart_ctacte_pre]    Script Date: 06/11/2018 13:55:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_cart_ctacte_pre](
	[CUENTA] [nvarchar](255) NULL,
	[NOMBRE_CTA] [nvarchar](255) NULL,
	[SALDO_DISPONIBLE] [float] NULL,
	[SALDO_CONTABLE] [float] NULL,
	[RET_MISMA_PLAZA] [float] NULL,
	[SALDO_DIARIO] [float] NULL,
	[OTRAS_RETENCIONES] [float] NULL,
	[ESTADO] [nvarchar](255) NULL,
	[MONEDA] [nvarchar](3) NULL,
	[FECHA] [nvarchar](10) NULL,
	[MONEDA_JOIN] [int] NULL,
	[RUT] [nvarchar](10) NULL,
	[RUT_EJECUTIVO] [nvarchar](10) NULL,
	[EJECUTIVO] [nvarchar](80) NULL,
	[PLATAFORMA] [nvarchar](30) NULL,
	[CANAL] [nvarchar](30) NULL
) ON [PRIMARY]

GO


