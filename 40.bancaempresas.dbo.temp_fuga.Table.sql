USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[temp_fuga]    Script Date: 06/11/2018 15:26:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[temp_fuga](
	[Mes] [date] NULL,
	[plataforma] [nvarchar](50) NULL,
	[nombre] [varchar](50) NULL,
	[rut_cli] [int] NULL,
	[nom_cliente] [varchar](50) NULL,
	[Valor] [int] NULL,
	[Tipo] [varchar](6) NOT NULL,
	[Producto] [nvarchar](128) NULL,
	[categoria] [varchar](50) NULL,
	[decision] [varchar](50) NULL,
	[tipoFuga] [varchar](50) NULL,
	[MesesDesact] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


