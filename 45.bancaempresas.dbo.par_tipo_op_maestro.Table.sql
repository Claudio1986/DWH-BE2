USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[par_tipo_op_maestro]    Script Date: 07/11/2018 15:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[par_tipo_op_maestro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo_prod] [varchar](30) NULL,
	[val_min] [decimal](18, 0) NULL,
	[val_max] [decimal](18, 0) NULL,
	[activo] [int] NULL,
	[nivel] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


