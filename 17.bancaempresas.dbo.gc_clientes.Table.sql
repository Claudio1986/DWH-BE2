USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_clientes]    Script Date: 07/03/2018 18:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_clientes]
CREATE TABLE [dbo].[gc_clientes](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[dv_cli] [varchar](1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[grupo] [varchar](50) NULL,
	[centro_decision] [varchar](50) NULL,
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[frec_visita] [smallint] NULL,
	[tipo_cliente] [int] not NULL,
 CONSTRAINT [PK_gc_clientes] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gc_clientes]  WITH NOCHECK ADD  CONSTRAINT [FK_gc_clientes_gc_ejecutivos] FOREIGN KEY([rut_ejec])
REFERENCES [dbo].[gc_ejecutivos] ([rut_ejec])
GO
ALTER TABLE [dbo].[gc_clientes] CHECK CONSTRAINT [FK_gc_clientes_gc_ejecutivos]
GO
ALTER TABLE [dbo].[gc_clientes]  WITH CHECK ADD  CONSTRAINT [FK_gc_clientes_tipo_cliente] FOREIGN KEY([tipo_cliente])
REFERENCES [dbo].[tipo_cliente] ([id])
GO
ALTER TABLE [dbo].[gc_clientes] CHECK CONSTRAINT [FK_gc_clientes_tipo_cliente]
GO
