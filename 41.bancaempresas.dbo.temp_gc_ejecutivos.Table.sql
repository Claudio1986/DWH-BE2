USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[temp_gc_ejecutivos]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[temp_gc_ejecutivos]
CREATE TABLE [dbo].[temp_gc_ejecutivos](
	[rut_ejec] [numeric](12, 0) NOT NULL,
	[dv_ejec] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NULL,
	[cargo] [varchar](50) NULL,
	[tipo] [int] NULL,
	[rut_jefe] [numeric](12, 0) NULL,
	[plataforma] [varchar](50) NULL,
	[especialista_prod] [smallint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
