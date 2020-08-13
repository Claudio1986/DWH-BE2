USE [BancaEmpresas]
GO

/****** Object:  Table [dbo].[temp_DAP]    Script Date: 06/11/2018 15:24:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[temp_DAP](
	[fecha_operacion] [datetime] NOT NULL,
	[fecha_vencimiento] [datetime] NULL,
	[tipo_operacion] [char](3) NULL,
	[numero_operacion] [decimal](10, 0) NOT NULL,
	[correla_operacion] [decimal](5, 0) NOT NULL,
	[correla_corte] [decimal](3, 0) NOT NULL,
	[rut_cliente] [numeric](12, 0) NOT NULL,
	[codigo_rut] [decimal](5, 0) NULL,
	[entidad] [decimal](10, 0) NULL,
	[forma_pago] [char](4) NULL,
	[retiro] [char](3) NULL,
	[monto_inicio] [float] NULL,
	[monto_inicio_pesos] [float] NULL,
	[moneda] [decimal](3, 0) NULL,
	[tasa] [decimal](8, 4) NULL,
	[tasa_tran] [decimal](8, 4) NULL,
	[plazo] [decimal](5, 0) NULL,
	[monto_final] [float] NULL,
	[estado] [char](1) NULL,
	[fecha_origen] [datetime] NULL,
	[control_renov] [decimal](5, 0) NULL,
	[custodia] [char](1) NULL,
	[valor_ant_presente] [float] NULL,
	[interes_diario] [float] NULL,
	[reajuste_diario] [float] NULL,
	[interes_acumulado] [float] NULL,
	[reajuste_acumulado] [float] NULL,
	[valor_presente] [float] NULL,
	[interestran_acum] [float] NULL,
	[interestran_diario] [float] NULL,
	[valor_presente_tran] [float] NULL,
	[monto_final_tran] [float] NULL,
	[tipo_deposito] [char](1) NULL,
	[numero_original] [decimal](10, 0) NULL,
	[correla_original] [decimal](5, 0) NULL,
	[inicial_original] [float] NULL,
	[estado_renov] [char](1) NULL,
	[tipo_cartera] [int] NULL,
	[tipo_emision] [char](1) NULL,
	[Fecha_Desmaterial] [datetime] NULL,
	[Correla_Material] [decimal](10, 0) NULL,
	[FECHA_RENOVACION] [datetime] NULL,
	[ESTADO_ANTICIPO] [decimal](3, 0) NULL,
	[Aviso_Anticipo] [char](1) NULL,
	[Fecha_Anticipo] [datetime] NULL,
	[CodigoLibro] [decimal](10, 0) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


