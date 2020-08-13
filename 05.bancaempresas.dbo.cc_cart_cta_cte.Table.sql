USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cc_cart_cta_cte]    Script Date: 06/11/2018 13:55:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cc_cart_cta_cte](
	[CUENTA] [nchar](10) NULL,
	[NOMBRE_CTA] [nchar](200) NULL,
	[SALDO_DISPONIBLE] [numeric](18, 2) NULL,
	[SALDO_CONTABLE] [numeric](18, 2) NULL,
	[RET_MISMA_PLAZA] [numeric](18, 2) NULL,
	[SALDO_DIARIO] [numeric](18, 2) NULL,
	[OTRAS_RETENCIONES] [numeric](18, 2) NULL,
	[ESTADO] [nchar](10) NULL,
	[FECHA] [nchar](10) NULL,
	[SALDO_FINAL] [numeric](18, 2) NULL,
	[PERIODO] [nchar](10) NULL,
	[RUT] [nchar](10) NULL,
	[CANAL] [nchar](30) NULL,
	[PLATAFORMA] [nchar](30) NULL,
	[RUT_EJECUTIVO] [nchar](10) NULL,
	[EJECUTIVO] [nchar](100) NULL,
	[MONEDA] [nchar](3) NULL,
	[TC] [numeric](5, 2) NULL,
	[FECHINI] [float] NULL,
	[FECHTER] [float] NULL,
	[FCC_ESTADO] [int] NULL,
	[SEMANA] [int] NULL
) ON [PRIMARY]

GO


