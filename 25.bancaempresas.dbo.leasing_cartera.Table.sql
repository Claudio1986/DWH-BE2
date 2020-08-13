USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[leasing_cartera]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[leasing_cartera]
CREATE TABLE [dbo].[leasing_cartera](
	[Fecha] [date] NOT NULL,
	[FECHA_OTO_2] [date] NOT NULL,
	[RUT_CLI] [numeric](12, 0) NOT NULL,
	[DV_CLIENTE] [nvarchar](1) NOT NULL,
	[NOMBRE_CLIENTE] [nvarchar](50) NOT NULL,
	[NRO_OPERACION] [int] NOT NULL,
	[NRO_DOCUMENTO] [int] NOT NULL,
	[TIPO_OPERACION] [int] NULL,
	[TIPO_PROD_FISA] [int] NULL,
	[MONEDA] [int] NULL,
	[TASA] [float] NULL,
	[FECHA_OTORGAMIENTO] [date] NULL,
	[FECHA_VENCIMIENTO] [date] NULL,
	[FECHA_SUSPENSION] [date] NULL,
	[NRO_CUOTAS] [int] NULL,
	[NRO_CUOTAS_PAGADAS] [int] NULL,
	[NRO_CUOTAS_MOROSAS] [int] NULL,
	[NRO_DIAS_MOROSAS] [int] NULL,
	[CAPITAL_INICIAL_ML] [float] NULL,
	[CAPITAL_VIGENTE_ML] [float] NULL,
	[CAPITAL_VENCIDO_ML] [float] NULL,
	[INTERES_VIGENTE_ML] [int] NULL,
	[INTERES_VENCIDO_ML] [int] NULL,
	[REAJUSTE_VIGENTE] [int] NULL,
	[REAJUSTE_VENCIDO] [int] NULL,
	[INTERES_SUSPENDIDO] [int] NULL,
	[REAJUSTE_SUSPENDIDO] [int] NULL,
	[CAPITAL_INICIAL_MO] [float] NULL,
	[CAPITAL_VIGENTE_MO] [float] NULL,
	[CAPITAL_VENCIDO_MO] [float] NULL,
	[INTERES_VIGENTE_MO] [int] NULL,
	[INTERES_VENCIDO_MO] [int] NULL,
 CONSTRAINT [PK_leasing_cartera] PRIMARY KEY CLUSTERED 
(
	[Fecha] ASC,
	[FECHA_OTO_2] ASC,
	[RUT_CLI] ASC,
	[DV_CLIENTE] ASC,
	[NOMBRE_CLIENTE] ASC,
	[NRO_OPERACION] ASC,
	[NRO_DOCUMENTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[leasing_cartera]  WITH NOCHECK ADD  CONSTRAINT [FK_leasing_cartera_gc_clientes] FOREIGN KEY([RUT_CLI])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[leasing_cartera] CHECK CONSTRAINT [FK_leasing_cartera_gc_clientes]
GO
