USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[op_spotfwd]    Script Date: 08/03/2018 15:02:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[op_spotfwd]
CREATE TABLE [dbo].[op_spotfwd](
	[Fecha] [date] NOT NULL,
	[Tipo] [nvarchar](50) NOT NULL,
	[nro_operacion] [int] NOT NULL,
	[Moneda] [nvarchar](5) NULL,
	[Mto_compra] [int] NULL,
	[Mto_venta] [int] NULL,
	[Pre_compra] [int] NULL,
	[Pre_venta] [int] NULL,
	[P_futuro] [int] NULL,
	[Ptos_fwd] [int] NULL,
	[fec_vencimiento] [date] NULL,
	[Plazo] [int] NULL,
	[precio_compra] [int] NULL,
	[precio_venta] [int] NULL,
	[Utilidad] [int] NULL,
	[mto_compra_clp] [float] NULL,
	[Mto_vta_clp] [float] NULL,
	[rut_cli] [numeric](12, 0) NOT NULL,
	[Mto_usd] [float] NULL,
 CONSTRAINT [PK_op_spotfwd_2] PRIMARY KEY CLUSTERED 
(
	[Fecha] ASC,
	[Tipo] ASC,
	[nro_operacion] ASC,
	[rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[op_spotfwd]  WITH NOCHECK ADD  CONSTRAINT [FK_op_spotfwd_2_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO

ALTER TABLE [dbo].[op_spotfwd] CHECK CONSTRAINT [FK_op_spotfwd_2_gc_clientes]
GO


