USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[normalizacion]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[normalizacion]
CREATE TABLE [dbo].[normalizacion](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[dv_cli] [varchar](50) NULL,
	[nombre] [varchar](50) NULL,
	[centro_decision] [varchar](50) NULL,
	[plataforma] [varchar](50) NOT NULL,
 CONSTRAINT [PK_normalizacion] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC,
	[plataforma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[normalizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_normalizacion_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[normalizacion] CHECK CONSTRAINT [FK_normalizacion_gc_clientes]
GO
ALTER TABLE [dbo].[normalizacion]  WITH CHECK ADD  CONSTRAINT [FK_normalizacion_gc_plataformaNew] FOREIGN KEY([plataforma])
REFERENCES [dbo].[gc_plataformaNew] ([descripcion])
GO
ALTER TABLE [dbo].[normalizacion] CHECK CONSTRAINT [FK_normalizacion_gc_plataformaNew]
GO
