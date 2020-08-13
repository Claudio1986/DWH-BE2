USE [BancaEmpresas]
GO
/****** Object:  Table [dbo].[gc_maestro2]    Script Date: 07/03/2018 18:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE [dbo].[gc_maestro2]
CREATE TABLE [dbo].[gc_maestro2](
	[mes] [date] NOT NULL,
	[Rut_cli] [numeric](12, 0) NOT NULL,
	[Movimiento] [int] NULL,
	[Activo] [int] NULL,
	[Recuperable] [int] NULL,
	[Nuevo] [int] NULL,
	[Act_Com] [int] NULL,
	[Mov_Com] [int] NOT NULL,
	[Act_BG] [int] NULL,
	[Mov_BG] [int] NOT NULL,
	[Act_Fact] [int] NULL,
	[Mov_Fact] [int] NOT NULL,
	[Act_Leas] [int] NULL,
	[Mov_Leas] [int] NOT NULL,
	[Act_Comex] [int] NULL,
	[Mov_Comex] [int] NOT NULL,
	[Act_Dap] [int] NULL,
	[Mov_Dap] [int] NOT NULL,
	[Act_Mesa] [int] NULL,
	[Mov_mesa] [int] NOT NULL,
	[Cta_Cte] [int] NOT NULL,
	[MP] [int] NULL,
	[N_Productos] [int] NULL,
	[Fugado] [int] NULL,
	[Visitado] [int] NULL,
	[Recuperado] [int] NULL,
	[Visitado_U4M] [int] NULL,
 CONSTRAINT [PK_gc_maestro2] PRIMARY KEY CLUSTERED 
(
	[mes] ASC,
	[Rut_cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[gc_maestro2]  WITH NOCHECK ADD  CONSTRAINT [FK_gc_maestro2_gc_clientes] FOREIGN KEY([Rut_cli])
REFERENCES [dbo].[gc_clientes] ([rut_cli])
GO
ALTER TABLE [dbo].[gc_maestro2] CHECK CONSTRAINT [FK_gc_maestro2_gc_clientes]
GO
