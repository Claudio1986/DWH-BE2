USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[gc_fuga]    Script Date: 06/11/2018 14:54:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
DROP TABLE [dbo].[gc_fuga]
CREATE TABLE [dbo].[gc_fuga](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[categoria] [varchar](50) NULL,
	[Decision] [varchar](50) NULL,
	[Tipo] [varchar](50) NULL,
 CONSTRAINT [PK_gc_fuga_1] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[gc_fuga]  WITH NOCHECK ADD  CONSTRAINT [FK_gc_fuga_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO

ALTER TABLE [dbo].[gc_fuga] CHECK CONSTRAINT [FK_gc_fuga_gc_clientes]
GO


