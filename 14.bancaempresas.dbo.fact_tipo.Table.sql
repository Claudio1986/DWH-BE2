USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[fact_tipo]    Script Date: 05/03/2018 15:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[fact_tipo]
CREATE TABLE [dbo].[fact_tipo](
	[Nro_operacion] [int] NOT NULL,
	[id_tipo_fact] [int] NOT NULL,
 CONSTRAINT [PK_fact_tipo_1] PRIMARY KEY CLUSTERED 
(
	[Nro_operacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[fact_tipo]  WITH CHECK ADD  CONSTRAINT [FK_fact_tipo_tipo_factoring] FOREIGN KEY([id_tipo_fact])
REFERENCES [dbo].[tipo_factoring] ([id])
GO
ALTER TABLE [dbo].[fact_tipo] CHECK CONSTRAINT [FK_fact_tipo_tipo_factoring]
GO
