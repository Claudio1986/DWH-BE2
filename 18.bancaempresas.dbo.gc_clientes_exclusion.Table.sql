USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_clientes_exclusion]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[gc_clientes_exclusion]
CREATE TABLE [dbo].[gc_clientes_exclusion](
	[rut_cli] [numeric](12, 0) NOT NULL,
	[id_motivo] [int] NULL,
 CONSTRAINT [PK_gc_clientes_exclusion] PRIMARY KEY CLUSTERED 
(
	[rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[gc_clientes_exclusion]  WITH NOCHECK ADD  CONSTRAINT [FK_gc_clientes_exclusion_gc_clientes] FOREIGN KEY([rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[gc_clientes_exclusion] CHECK CONSTRAINT [FK_gc_clientes_exclusion_gc_clientes]
GO
ALTER TABLE [dbo].[gc_clientes_exclusion]  WITH CHECK ADD  CONSTRAINT [FK_gc_clientes_exclusion_motivo_exclusion_vis] FOREIGN KEY([id_motivo])
REFERENCES [dbo].[motivo_exclusion_vis] ([id])
GO
ALTER TABLE [dbo].[gc_clientes_exclusion] CHECK CONSTRAINT [FK_gc_clientes_exclusion_motivo_exclusion_vis]
GO
