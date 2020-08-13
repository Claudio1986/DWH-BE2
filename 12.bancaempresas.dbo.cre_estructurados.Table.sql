USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[cre_estructurados]    Script Date: 07/03/2018 18:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[cre_estructurados]
CREATE TABLE [dbo].[cre_estructurados](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[nro_ope] [float] NOT NULL,
	[nombre_cliente] [nvarchar](50) NULL,
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[nombre_ejec] [nvarchar](50) NULL,
 CONSTRAINT [PK_cre_estructurados] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC,
	[nro_ope] ASC,
	[rut_ejec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[cre_estructurados]  WITH NOCHECK ADD  CONSTRAINT [FK_cre_estructurados_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[cre_estructurados] CHECK CONSTRAINT [FK_cre_estructurados_gc_clientes]
GO
ALTER TABLE [dbo].[cre_estructurados]  WITH CHECK ADD  CONSTRAINT [FK_cre_estructurados_gc_ejecutivos1] FOREIGN KEY([rut_ejec])
REFERENCES [dbo].[gc_ejecutivos] ([rut_ejec])
GO
ALTER TABLE [dbo].[cre_estructurados] CHECK CONSTRAINT [FK_cre_estructurados_gc_ejecutivos1]
GO
