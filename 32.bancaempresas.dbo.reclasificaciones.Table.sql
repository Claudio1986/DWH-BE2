USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[reclasificaciones]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[reclasificaciones]
CREATE TABLE [dbo].[reclasificaciones](
	[fecha] [date] NOT NULL,
	[rut_cli] [numeric](12, 0) NOT NULL,
	[Csbif] [nvarchar](2) NULL,
	[fechaant] [date] NULL,
	[Csbifant] [nvarchar](2) NULL,
 CONSTRAINT [PK_reclasificaciones] PRIMARY KEY CLUSTERED 
(
	[fecha] ASC,
	[rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[reclasificaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_reclasificaciones_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[reclasificaciones] CHECK CONSTRAINT [FK_reclasificaciones_gc_clientes]
GO
