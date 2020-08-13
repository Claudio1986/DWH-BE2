USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[temp_gc_clientes]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[temp_gc_clientes]
CREATE TABLE [dbo].[temp_gc_clientes](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[dv_cli] [varchar](1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[grupo] [varchar](50) NULL,
	[centro_decision] [varchar](50) NULL,
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[frec_visita] [smallint] NULL,
	[tipo_cliente] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
