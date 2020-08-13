USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[cre_cartera]    Script Date: 07/03/2018 18:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[cre_cartera]
CREATE TABLE [dbo].[cre_cartera](
	[Fecha] [datetime] NOT NULL,
	[Rut_cli] [numeric](12, 0) NOT NULL,
	[DV_CLIENTE] [char](1) NULL,
	[NOMBRE_CLIENTE] [nvarchar](255) NULL,
	[NRO_OPERACION] [numeric](12, 0) NOT NULL,
	[NRO_DOCUMENTO] [float] NULL,
	[TIPO_OPERACION] [float] NULL,
	[TIPO_PROD_FISA] [float] NULL,
	[MONEDA] [float] NULL,
	[TASA] [float] NULL,
	[FECHA_OTORGAMIENTO] [datetime] NULL,
	[FECHA_VENCIMIENTO] [datetime] NULL,
	[Plazo] [float] NULL,
	[FECHA_SUSPENSION] [datetime] NULL,
	[NRO_CUOTAS] [float] NULL,
	[NRO_CUOTAS_PAGADAS] [float] NULL,
	[NRO_CUOTAS_MOROSAS] [float] NULL,
	[NRO_DIAS_MOROSAS] [float] NULL,
	[CAPITAL_INICIAL_ML] [float] NULL,
	[CAPITAL_VIGENTE_ML] [float] NULL,
	[CAPITAL_VENCIDO_ML] [float] NULL,
	[INTERES_VIGENTE_ML] [float] NULL,
	[INTERES_VENCIDO_ML] [float] NULL,
	[REAJUSTE_VIGENTE] [float] NULL,
	[REAJUSTE_VENCIDO] [float] NULL,
	[INTERES_SUSPENDIDO] [float] NULL,
	[REAJUSTE_SUSPENDIDO] [float] NULL,
	[CAPITAL_INICIAL_MO] [float] NULL,
	[CAPITAL_VIGENTE_MO] [float] NULL,
	[CAPITAL_VENCIDO_MO] [float] NULL,
	[INTERES_VIGENTE_MO] [float] NULL,
	[INTERES_VENCIDO_MO] [float] NULL,
 CONSTRAINT [PK_cre_cartera_2_1] PRIMARY KEY CLUSTERED 
(
	[Fecha] ASC,
	[Rut_cli] ASC,
	[NRO_OPERACION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[cre_cartera]  WITH NOCHECK ADD  CONSTRAINT [FK_cre_cartera_gc_clientes] FOREIGN KEY([Rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[cre_cartera] CHECK CONSTRAINT [FK_cre_cartera_gc_clientes]
GO
