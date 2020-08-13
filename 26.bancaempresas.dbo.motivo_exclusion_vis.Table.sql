USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[motivo_exclusion_vis]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[motivo_exclusion_vis]
CREATE TABLE [dbo].[motivo_exclusion_vis](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[motivo] [varchar](100) NULL,
 CONSTRAINT [PK_motivo_exclusion_vis] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
