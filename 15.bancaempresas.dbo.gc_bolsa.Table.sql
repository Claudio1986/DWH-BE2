USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_bolsa]    Script Date: 07/03/2018 18:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_bolsa]
CREATE TABLE [dbo].[gc_bolsa](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[rut_bolsa] [numeric](12, 0) NOT NULL,
	[dv_bolsa] [varchar](50) NULL,
	[nombre_bolsa] [varchar](100) NULL,
	[fec_valido_desde] [datetime] NOT NULL,
	[fec_valido_hasta] [datetime] NOT NULL,
 CONSTRAINT [PK_gc_bolsa_2] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC,
	[rut_bolsa] ASC,
	[fec_valido_desde] ASC,
	[fec_valido_hasta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gc_bolsa]  WITH NOCHECK ADD  CONSTRAINT [FK_gc_bolsa_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[gc_bolsa] CHECK CONSTRAINT [FK_gc_bolsa_gc_clientes]
GO
