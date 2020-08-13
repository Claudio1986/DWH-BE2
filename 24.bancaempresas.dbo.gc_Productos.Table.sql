USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[gc_Productos]    Script Date: 06/04/2018 09:33:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[gc_Productos]') IS NOT NULL
BEGIN
	drop table [dbo].[gc_Productos]
END
GO
DROP TABLE [dbo].[gc_Productos]
CREATE TABLE [dbo].[gc_Productos](
	[id_producto] [smallint] NOT NULL,
	[descripcion] [nvarchar](50) NULL,
	[banca_empresa] [smallint] NULL,
 CONSTRAINT [PK_gc_PRODUCTOS] PRIMARY KEY CLUSTERED 
(
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
USE [BancaEmpresas]
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (1, N'LEASING', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (2, N'RENTA_FIJA', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (3, N'FACTORING', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (4, N'CREDITOS_CIERRE_MES', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (5, N'CREDITOS', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (6, N'CCB', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (7, N'BONOS_DEUDA', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (8, N'BONEX', 1)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (9, N'BOLETASDEGARANTIA
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (10, N'COMERCIAL
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (11, N'COMERCIAL(COMPLEMENTARIO)
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (12, N'COMERCIAL(FFGG)
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (13, N'COMEX_CONTINGENTE
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (14, N'COMPLEMENTARIOS
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (15, N'CONSUMO
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (16, N'CREDITOS_COMERCIALES
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (17, N'HIPOTECARIO
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (18, N'INTERBANCARIOS
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (19, N'LÍNEAAUXILIARDEIMPREVISTOS(CONTINGENTE)
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (20, N'LÍNEAAUXILIARDEIMPREVISTOS(DEUDA)
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (21, N'LINEASDECREDITO(CONTINGENTE)
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (22, N'LINEASDECREDITOS
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (23, N'OTRASLINEASDECREDITO
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (24, N'PAE
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (25, N'VARIOSDEUDORES
', 0)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (26, N'COMEX', NULL)
GO
INSERT [dbo].[gc_Productos] ([id_producto], [descripcion], [banca_empresa]) VALUES (27, N'MESA DINERO', NULL)
GO



