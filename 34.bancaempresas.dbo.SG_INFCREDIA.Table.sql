USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[SG_INFCREDIA]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[SG_INFCREDIA]
CREATE TABLE [dbo].[SG_INFCREDIA](
	[INF_FECHA] [datetime] NOT NULL,
	[INF_RUTCL] [numeric](12, 0) NOT NULL,
	[INF_DVCL] [varchar](1) NULL,
	[INF_NOMBRECL] [varchar](50) NULL,
	[INF_OPERACION] [decimal](12, 0) NOT NULL,
	[INF_DOCUMENTO] [decimal](18, 0) NOT NULL,
	[INF_TIPOPE] [decimal](3, 0) NULL,
	[INF_TIPOPROD] [decimal](3, 0) NOT NULL,
	[INF_MONEDA] [decimal](3, 0) NULL,
	[INF_TASA] [float] NULL,
	[INF_FECINI] [datetime] NULL,
	[INF_FECFIN] [datetime] NULL,
	[INF_FECSUS] [datetime] NULL,
	[INF_NCUOTAS] [decimal](14, 0) NULL,
	[INF_NCUOPAG] [decimal](14, 0) NULL,
	[INF_NCUOMOR] [decimal](14, 0) NULL,
	[INF_NDIASMOR] [decimal](14, 0) NULL,
	[INF_CAPINIML] [float] NULL,
	[INF_CAPVIGML] [float] NULL,
	[INF_CAPVENML] [float] NULL,
	[INF_INTVIGML] [float] NULL,
	[INF_INTVENML] [float] NULL,
	[INF_REAVIGML] [float] NULL,
	[INF_REAVENML] [float] NULL,
	[INF_INTSUSML] [float] NULL,
	[INF_REASUSML] [float] NULL,
	[INF_CAPINIMO] [float] NULL,
	[INF_CAPVIGMO] [float] NULL,
	[INF_CAPVENMO] [float] NULL,
	[INF_INTVIGMO] [float] NULL,
	[INF_INTVENMO] [float] NULL,
	[INF_SISTEMA] [varchar](3) NOT NULL,
	[inf_estado] [varchar](3) NULL,
	[inf_indsusp] [varchar](1) NULL,
	[inf_rutdeudor] [decimal](10, 0) NULL,
	[inf_dvdeudor] [varchar](1) NULL,
	[inf_indresp] [decimal](1, 0) NULL,
	[inf_clasRgo] [varchar](2) NULL,
	[inf_clasRgodeudor] [varchar](2) NULL,
	[inf_plazo] [decimal](6, 0) NULL,
	[inf_confirming] [decimal](2, 0) NULL,
	[Disponible] [float] NULL,
	[Composicion_institucional] [decimal](6, 0) NULL,
	[cta_ifrs] [decimal](10, 0) NULL,
 CONSTRAINT [PK_SG_INFCREDIA] PRIMARY KEY CLUSTERED 
(
	[INF_FECHA] ASC,
	[INF_RUTCL] ASC,
	[INF_OPERACION] ASC,
	[INF_DOCUMENTO] ASC,
	[INF_TIPOPROD] ASC,
	[INF_SISTEMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SG_INFCREDIA]  WITH NOCHECK ADD  CONSTRAINT [FK_SG_INFCREDIA_gc_clientes] FOREIGN KEY([INF_RUTCL])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[SG_INFCREDIA] CHECK CONSTRAINT [FK_SG_INFCREDIA_gc_clientes]
GO
