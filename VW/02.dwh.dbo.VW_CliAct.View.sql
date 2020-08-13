USE [DWH]
GO

/****** Object:  View [dbo].[VW_CliAct]    Script Date: 06/04/2018 16:14:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter view [dbo].[VW_CliAct] as 

	select		
				Fecha,clie2.id id_cliente,clie2.rut_cli rut_cli
				,FechaProceso
				,Movimiento
				,Activo
				,Recuperable,Nuevo,Act_Com,Mov_Com,Act_BG,Mov_BG,Act_Fact,Mov_Fact,Act_Leas
				,Mov_Leas,Act_Comex,Mov_Comex,Act_Dap,Mov_Dap,Act_Mesa,Mov_mesa,Cta_Cte,MP
				,N_Productos,Fugado,Visitado,Recuperado,Visitado_U4M
				,CLIE2.nombre			Cliente
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL 
				THEN 0
				ELSE 
				EJECUT.rut_ejec
				END 					rut_ejec
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL
				THEN 'LIBRE'
				ELSE 
				EJECUT.nombre
				END						Ejecutivo
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL
				THEN 0
				ELSE 
				JEFE.rut_ejec
				END 					rut_jefe
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL
				THEN 'LIBRE'
				ELSE 
				JEFE.nombre
				END						Jefe
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL AND	PLATAF.descripcion IS NULL
				THEN 'LIBRE'
				ELSE 
				PLATAF.descripcion
				END 					Plataforma
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL AND	Cana.canal IS NULL
				THEN 'LIBRE'
				ELSE 
				Cana.canal
				END						Canal
				,clie2.tipo_cliente		tipo_cliente
	from		dwh.dbo.maestro_cli					maes
	INNER join	dwh.dbo.clientes					clie
	ON			maes.id_cliente						=	clie.id
	INNER join	dwh.dbo.clientes						CLIE2
	ON			clie2.rut_cli						=	clie.rut_cli
	AND			clie2.fec_hasta						=	29991231

	INNER JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
	ON			CLIE2.id				=	ascl.id_cliente
	AND			ascl.fec_hasta			=	29991231
	
	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
	ON			ascl.id_ejecutivo		=	EJECUT.id		
	AND			EJECUT.fec_hasta		=	29991231
		
	LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
	ON			jera.id_ejecutivo		=	EJECUT.id
	AND			jera.fec_hasta			=	29991231
	
	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
	ON			jera.id_jefe			=	JEFE.id
	AND			JEFE.id_plataforma		IS NOT NULL
	AND			JEFE.fec_hasta			=	29991231

	LEFT JOIN 	
	(
		SELECT		
					id_cliente	
					,rut_cli
					,id_plataforma
		FROM		[DWH].dbo.normalizaciones	norm
		INNER join	dwh.dbo.clientes			clie
		ON			norm.id_cliente		=	clie.id
		WHERE		norm.fec_hasta		=	29991231
	) norm
	ON			CLIE2.rut_cli			=	norm.rut_cli
	
	LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
	ON			UPPER(
				CASE
				WHEN	norm.id_plataforma	IS NOT NULL AND	EJECUT.rut_ejec = 55555
					THEN	norm.id_plataforma
				WHEN	JEFE.id_plataforma	IS NOT NULL
					THEN	JEFE.id_plataforma
				WHEN	EJECUT.id_plataforma	IS NOT NULL
					THEN	EJECUT.id_plataforma
				END)				=	PLATAF.id
	AND			PLATAF.fec_hasta			=	29991231
		
	LEFT JOIN 	[DWH].[dbo].[canales]	Cana
	ON			Cana.id			=	PLATAF.id_canal


	WHERE		clie2.tipo_cliente		=	1
	



GO


