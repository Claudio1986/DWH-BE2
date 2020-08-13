USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[op_cartera]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[op_cartera]
CREATE TABLE [dbo].[op_cartera](
	[nro_operacion] [int] NOT NULL,
	[Rut_cli] [numeric](12, 0) NOT NULL,
	[DV_cliente] [nvarchar](1) NULL,
	[Producto] [nvarchar](3) NULL,
	[Moneda] [nvarchar](10) NULL,
	[Fecha_curse] [date] NULL,
	[Monto_inicial] [int] NULL,
	[Moneda_Equivalente_Pesos] [int] NULL,
	[Comision] [int] NULL,
	[Composición_Tasa] [nvarchar](50) NULL,
	[Plazo] [int] NULL,
	[COF_anual] [int] NULL,
	[Spread_anual] [int] NULL,
	[Tasa_final_anual] [int] NULL,
	[Numero_Cuotas] [int] NULL,
	[Valor_Cuota] [int] NULL,
	[Fecha_Venc] [date] NULL,
	[Capital_Insoluto] [int] NULL,
	[Saldo_Insoluto] [int] NULL,
	[Tipo_Curse] [nvarchar](50) NULL,
 CONSTRAINT [PK_op_cartera] PRIMARY KEY CLUSTERED 
(
	[nro_operacion] ASC,
	[Rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[op_cartera]  WITH NOCHECK ADD  CONSTRAINT [FK_op_cartera_gc_clientes] FOREIGN KEY([Rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[op_cartera] CHECK CONSTRAINT [FK_op_cartera_gc_clientes]
GO
