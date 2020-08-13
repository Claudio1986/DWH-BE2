USE [DWH]
GO

/****** Object:  View [dbo].[VW_maestro_cli]    Script Date: 06/04/2018 15:40:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[VW_maestro_cli] as 

	select		
				Fecha,clie2.id id_cliente,clie2.rut_cli rut_cli
				,FechaProceso
				,Movimiento
				,Activo
				,Recuperable,Nuevo,Act_Com,Mov_Com,Act_BG,Mov_BG,Act_Fact,Mov_Fact,Act_Leas
				,Mov_Leas,Act_Comex,Mov_Comex,Act_Dap,Mov_Dap,Act_Mesa,Mov_mesa,Cta_Cte,MP
				,N_Productos,Fugado,Visitado,Recuperado,Visitado_U4M
				,CLIE2.nombre			Cliente
	from		dwh.dbo.maestro_cli					maes
	INNER join	dwh.dbo.clientes					clie
	ON			maes.id_cliente						=	clie.id
	INNER join	dwh.dbo.clientes						CLIE2
	ON			clie2.rut_cli						=	clie.rut_cli
	AND			clie2.fec_hasta						=	29991231



GO


