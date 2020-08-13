USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[op_financ_ctdo]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[op_financ_ctdo]
CREATE TABLE [dbo].[op_financ_ctdo](
	[nro_operacion] [numeric](12, 0) NOT NULL,
	[tipo] [int] NOT NULL,
 CONSTRAINT [PK_op_financ_ctdo_1] PRIMARY KEY CLUSTERED 
(
	[nro_operacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
