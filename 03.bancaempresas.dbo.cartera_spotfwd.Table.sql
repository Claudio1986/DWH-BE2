USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[cartera_spotfwd]    Script Date: 06/11/2018 13:52:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[cartera_spotfwd](
	[motipoper] [char](1) NULL,
	[fecha] [varchar](10) NULL,
	[tipo] [varchar](3) NULL,
	[nro_operacion] [numeric](18, 0) NULL,
	[moneda] [char](3) NULL,
	[moneda_conversion] [char](3) NULL,
	[Mto_compra] [numeric](18, 0) NULL,
	[Mto_venta] [numeric](18, 0) NULL,
	[Pre_compra] [numeric](18, 0) NULL,
	[Pre_venta] [numeric](18, 0) NULL,
	[P_futuro] [float] NULL,
	[Ptos_fwd] [float] NULL,
	[fec_vencimiento] [varchar](10) NULL,
	[Plazo] [int] NULL,
	[precio_compra] [numeric](18, 0) NULL,
	[precio_venta] [numeric](18, 0) NULL,
	[Utilidad] [numeric](18, 0) NULL,
	[mto_compra_clp] [numeric](18, 0) NULL,
	[Mto_vta_clp] [numeric](18, 0) NULL,
	[rut_cli] [numeric](18, 0) NULL,
	[Mto_usd] [numeric](18, 0) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


