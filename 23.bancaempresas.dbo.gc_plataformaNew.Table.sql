USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_plataformaNew]    Script Date: 05/03/2018 15:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_plataformaNew]
CREATE TABLE [dbo].[gc_plataformaNew](
	[descripcion] [varchar](50) NOT NULL,
	[canal] [int] NULL,
 CONSTRAINT [PK_gc_plataformaNew] PRIMARY KEY CLUSTERED 
(
	[descripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gc_plataformaNew]  WITH CHECK ADD  CONSTRAINT [FK_gc_plataformaNew_gc_canales] FOREIGN KEY([canal])
REFERENCES [dbo].[gc_canales] ([id])
GO
ALTER TABLE [dbo].[gc_plataformaNew] CHECK CONSTRAINT [FK_gc_plataformaNew_gc_canales]
GO
