USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[fact_cartera]    Script Date: 07/03/2018 18:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[fact_cartera]
CREATE TABLE [dbo].[fact_cartera](
	[fecha] [date] NOT NULL,
	[rut_deudor] [int] NULL,
	[rut_cli_ori] [numeric](12, 0) NULL,
	[rut_cli] [numeric](12, 0) NOT NULL,
	[tipo_rut_cli] [int] NULL,
	[nro_operacion] [int] NOT NULL,
	[fecha_op] [date] NULL,
	[garantia_op] [int] NULL,
	[nro_doc] [float] NOT NULL,
	[tipo_doc] [int] NULL,
	[fecha_vencimiento] [date] NULL,
	[valor_nominal_doc] [float] NULL,
	[diferencia_precio_no_financiado] [int] NULL,
	[diferencia_precio_favor_factor] [int] NULL,
	[abonos] [int] NULL,
	[valor_actual_neto] [float] NULL,
	[tasa_desc] [float] NULL,
	[renegociacion] [int] NULL,
	[responsabilidad] [int] NULL,
	[verificacion_del_doc] [int] NULL,
	[notificacion_del_deudor] [int] NULL,
	[moneda] [int] NULL,
 CONSTRAINT [PK_fact_cartera_1] PRIMARY KEY CLUSTERED 
(
	[fecha] ASC,
	[rut_cli] ASC,
	[nro_operacion] ASC,
	[nro_doc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[fact_cartera]  WITH NOCHECK ADD  CONSTRAINT [FK_fact_cartera_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[fact_cartera] CHECK CONSTRAINT [FK_fact_cartera_gc_clientes]
GO
