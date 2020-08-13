USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[SG_CTACTE]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[SG_CTACTE]
CREATE TABLE [dbo].[SG_CTACTE](
	[CTA_FECHAPRO] [varchar](8) NOT NULL,
	[CTA_RUT] [numeric](12, 0) NOT NULL,
	[CTA_COD] [decimal](1, 0) NULL,
	[CTA_SUCURSAL] [decimal](7, 0) NULL,
	[CTA_MONEDA] [decimal](3, 0) NOT NULL,
	[CTA_NUMCTA] [decimal](12, 0) NOT NULL,
	[CTA_FECHAINI] [varchar](8) NULL,
	[CTA_FECHAFIN] [varchar](8) NULL,
	[CTA_ESTADO] [varchar](3) NULL,
	[CTA_DIG_VER] [char](2) NULL,
	[cta_SaldoReal] [float] NULL,
	[cta_SaldoContable] [float] NULL,
	[cta_SaldoPromMes] [decimal](18, 0) NULL,
	[cta_SaldoPromAno] [decimal](18, 0) NULL,
	[cta_retencion] [float] NULL,
	[cta_snp] [float] NULL,
	[cta_IntSnp] [float] NULL,
	[cta_codEje] [varchar](20) NULL,
	[cta_Subtipo] [varchar](5) NULL,
	[cta_Tipo] [varchar](5) NULL,
	[cta_sistema] [varchar](3) NULL,
	[LCR_LCR] [decimal](10, 0) NULL,
	[CLTIPCLISUPER] [decimal](2, 0) NULL,
	[Monto_tramo] [decimal](16, 0) NULL,
	[Nro_tramo] [decimal](2, 0) NULL,
	[Tipo_Mov] [varchar](4) NULL,
 CONSTRAINT [PK_SG_CTACTE_1] PRIMARY KEY CLUSTERED 
(
	[CTA_FECHAPRO] ASC,
	[CTA_RUT] ASC,
	[CTA_MONEDA] ASC,
	[CTA_NUMCTA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SG_CTACTE]  WITH NOCHECK ADD  CONSTRAINT [FK_SG_CTACTE_gc_clientes] FOREIGN KEY([CTA_RUT])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[SG_CTACTE] CHECK CONSTRAINT [FK_SG_CTACTE_gc_clientes]
GO
