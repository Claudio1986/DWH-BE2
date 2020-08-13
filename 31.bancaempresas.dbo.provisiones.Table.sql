USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[provisiones]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[provisiones]
CREATE TABLE [dbo].[provisiones](
	[fecha] [date] NOT NULL,
	[rut_cli] [numeric](12, 0) NOT NULL,
	[dv_cli] [nvarchar](1) NULL,
	[nombre] [nvarchar](50) NULL,
	[CSbif] [nvarchar](2) NULL,
	[NRO_OPE] [float] NOT NULL,
	[T_TOTAL_CARTERA] [float] NULL,
	[T_TOTAL_PROVISION] [float] NULL,
	[PRODUCTO] [nvarchar](50) NOT NULL,
	[PRODUCTO_AGRUPADO] [nvarchar](50) NULL,
 CONSTRAINT [PK_provisiones_2] PRIMARY KEY CLUSTERED 
(
	[fecha] ASC,
	[rut_cli] ASC,
	[NRO_OPE] ASC,
	[PRODUCTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[provisiones]  WITH NOCHECK ADD  CONSTRAINT [FK_provisiones_2_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[provisiones] CHECK CONSTRAINT [FK_provisiones_2_gc_clientes]
GO
