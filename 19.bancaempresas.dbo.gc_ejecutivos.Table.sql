USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_ejecutivos]    Script Date: 05/03/2018 15:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_ejecutivos]
CREATE TABLE [dbo].[gc_ejecutivos](
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[dv_ejec] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NULL,
	[cargo] [varchar](50) NULL,
	[tipo] [int] NULL,
	[rut_jefe] [numeric](12, 0) NULL,
	[plataforma] [varchar](50) NULL,
	[especialista_prod] [smallint] NULL,
 CONSTRAINT [PK_gc_ejecutivos] PRIMARY KEY CLUSTERED 
(
	[rut_ejec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gc_ejecutivos]  WITH CHECK ADD  CONSTRAINT [FK_gc_ejecutivos_gc_plataformaNew] FOREIGN KEY([plataforma])
REFERENCES [dbo].[gc_plataformaNew] ([descripcion])
GO
ALTER TABLE [dbo].[gc_ejecutivos] CHECK CONSTRAINT [FK_gc_ejecutivos_gc_plataformaNew]
GO
