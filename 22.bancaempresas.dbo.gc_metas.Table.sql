USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_metas]    Script Date: 05/03/2018 15:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_metas]
CREATE TABLE [dbo].[gc_metas](
	[año] [int] NOT NULL,
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[tipo] [varchar](50) NOT NULL,
	[valor] [int] NULL,
 CONSTRAINT [PK_gc_metas] PRIMARY KEY CLUSTERED 
(
	[año] ASC,
	[rut_ejec] ASC,
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gc_metas]  WITH CHECK ADD  CONSTRAINT [FK_gc_metas_gc_ejecutivos] FOREIGN KEY([rut_ejec])
REFERENCES [dbo].[gc_ejecutivos] ([rut_ejec])
GO
ALTER TABLE [dbo].[gc_metas] CHECK CONSTRAINT [FK_gc_metas_gc_ejecutivos]
GO
