USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[tipo_factoring]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[tipo_factoring]
CREATE TABLE [dbo].[tipo_factoring](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [nvarchar](20) NULL,
 CONSTRAINT [PK_tipo_factoring] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
