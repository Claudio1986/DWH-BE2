USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_canales]    Script Date: 05/03/2018 15:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_canales]
CREATE TABLE [dbo].[gc_canales](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[canal] [varchar](50) NULL,
 CONSTRAINT [PK_gc_canales] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
