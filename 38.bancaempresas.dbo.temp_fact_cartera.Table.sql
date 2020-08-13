USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[temp_fact_cartera]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[temp_fact_cartera]
CREATE TABLE [dbo].[temp_fact_cartera](
	[fecha] [date] NOT NULL,
	[rut_deudor] [int] NULL,
	[rut_cli] [numeric](12, 0) NOT NULL,
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
	[moneda] [int] NULL
) ON [PRIMARY]

GO
