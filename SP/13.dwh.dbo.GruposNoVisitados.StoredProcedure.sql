USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[GruposNoVisitados]    Script Date: 09/04/2018 20:38:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[GruposNoVisitados]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[GruposNoVisitados]
END
GO

ALTER PROCEDURE [dbo].[GruposNoVisitados] @Canal VARCHAR(30)
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[GruposNoVisitados]	'PYME'
AS
BEGIN
	--declare  @Canal VARCHAR(30) =   'C&I'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @mesActividad int
	
	SELECT		@mesActividad	=	max(maestAct.FECHA)
	FROM		dbo.maestro_cli		maestAct

	SELECT 
			Totales.rut_ejec
			,Totales.Ejecutivo
			,Totales.rut_jefe
			,Totales.Jefe
			,Totales.plataforma
			,Totales.Canal
			,ISNULL(VistadosClientes.clientes,0)									Visitados
			,Totales.clientes-Totales.clientes_excl-ISNULL(VistadosClientes.clientes,0)	
																					NoVisitados
			,Totales.clientes_excl													Excluidos
			,Totales.clientes-ISNULL(Totales.clientes_excl,0)						Totales
--			,isnULL(VistadosNumero.visitas4M,0)										visitas4M
			,CAST(ROUND(CAST((Totales.clientes-ISNULL(VistadosClientes.clientes,0)-ISNULL(Totales.clientes_excl,0))*100 as decimal(10,4))
			/CAST(Totales.clientes-ISNULL(Totales.clientes_excl,0) as decimal(10,4)),0) as decimal(10,0))			'%No_Visitado'
			,VENCE_MES
	--select VistadosClientes.*
	FROM
	(
			SELECT 
						0 as visitas
						,count(CLIE.rut_cli) clientes
						,SUM(
						CASE
							WHEN	CLIEXC.rut_cli	IS NOT NULL
								THEN	1
							ELSE	0
						END)				clientes_excl
						,EJECUT.rut_ejec	rut_ejec
						,EJECUT.nombre		Ejecutivo
						,JEFE.rut_ejec	rut_jefe	
						,JEFE.nombre		Jefe
						,PLATAF.descripcion	plataforma
						,Canal.canal canal
						,'existente'		tipo
------------------------------------						
	FROM		[DWH].[dbo].[clientes]						CLIE	
	INNER JOIN 	
	(
		SELECT		
					--CLCD.id id_cliente, 
					CLCD.RUT_CLI,
					max(fecha)		fecha
		FROM		DWH.dbo.clientes		CLCD
		INNER JOIN 
		(
			SELECT		
						CLNW.centro_decision centro_decision
						,max(VICL.fec_realizacion)		fecha	
			from 		DWH.dbo.maestro_cli	 maestAct
			INNER JOIN  DWH.dbo.clientes		CLMA
			ON			maestAct.id_cliente	=	CLMA.id
			AND			maestAct.fecha		=	@mesActividad
			AND			maestAct.Activo		=	1
			LEFT JOIN	DWH.dbo.clientes		CLNW
			ON			CLNW.rut_cli		=	CLMA.rut_cli
			AND			CLNW.fec_hasta		=	29991231
			LEFT JOIN	(
							SELECT		[fec_realizacion], rut_cli
							FROM		DWH.dbo.clientes		CLVI
							LEFT JOIN	DWH.dbo.visitas			VISI
							ON			VISI.id_cliente		=	CLVI.id
							--WHERE CLVI.rut_cli = 76217649
						)VICL
			ON			VICL.rut_cli	=	CLNW.rut_cli
			WHERE		maestAct.fecha		=	@mesActividad
			AND			maestAct.Activo		=	1
			GROUP BY	CLNW.centro_decision
		)VICL
		ON		CLCD.rut_cli	=	 VICL.centro_decision
		WHERE	CLCD.rut_cli	=	 CLCD.centro_decision
		AND		CLCD.fec_hasta	=	29991231
		group by 
					--CLCD.id
					CLCD.RUT_CLI

	)VisitaCli				
	--ON			VisitaCli.id_cliente	= CLIE.id
	ON			VisitaCli.RUT_CLI	= CLIE.RUT_CLI
	
	
	LEFT JOIN 	
	(
		SELECT		CLIE.rut_cli,CLIEXC.id_motivo--,CLIEXC.fec_desde,CLIEXC.fec_hasta
		FROM		[dwh].[dbo].[clientes]					CLIE
		INNER JOIN	[dwh].[dbo].[clientes_excluidos_vis]	CLIEXC
		ON			CLIE.id				=	CLIEXC.id_cliente	
		--WHERE		CLIEXC.fec_hasta	=	29991231
		GROUP BY	CLIE.rut_cli,CLIEXC.id_motivo--,CLIEXC.fec_desde,CLIEXC.fec_hasta 
	) CLIEXC
	on			CLIE.rut_cli	=	   CLIEXC.rut_cli
	--AND			fecha	BETWEEN	CLIEXC.fec_desde	AND	CLIEXC.fec_hasta-1
	--AND			convert(varchar(10),getdate(),112)	BETWEEN	CLIEXC.fec_desde	AND	CLIEXC.fec_hasta-1
	
	LEFT JOIN 	[dwh].[dbo].[motivo_exclusion_vis]	moex
	on			moex.id	=	   CLIEXC.id_motivo
	
	LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
	ON			CLIE.id		=	ascl.id_cliente
	--AND			fecha	BETWEEN	ascl.fec_desde	AND	ascl.fec_hasta-1
	AND			convert(varchar(10),getdate(),112)	BETWEEN	ascl.fec_desde	AND	ascl.fec_hasta-1
	
	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
	ON			ascl.id_ejecutivo		=	EJECUT.id		
	--AND			fecha	BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta -1
	AND			convert(varchar(10),getdate(),112)	BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta-1
	
	LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
	ON			jera.id_ejecutivo		=	EJECUT.id
	--AND			fecha	BETWEEN	jera.fec_desde	AND	jera.fec_hasta -1
	AND			convert(varchar(10),getdate(),112)	BETWEEN	jera.fec_desde	AND	jera.fec_hasta-1
	
	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
	ON			jera.id_jefe		=	JEFE.id
	AND			JEFE.id_plataforma	IS NOT NULL
	--AND			fecha	BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta -1
	AND			convert(varchar(10),getdate(),112)	BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta-1
	
	LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
	ON			UPPER(CASE
				WHEN	JEFE.id_plataforma	IS NULL
				THEN	EJECUT.id_plataforma
				ELSE	JEFE.id_plataforma
				END)				=	PLATAF.id
	--AND			fecha	BETWEEN	PLATAF.fec_desde	AND	PLATAF.fec_hasta-1
	AND			convert(varchar(10),getdate(),112)	BETWEEN	PLATAF.fec_desde	AND	PLATAF.fec_hasta-1
	
	LEFT JOIN 	[DWH].[dbo].[canales]	Canal
	ON			Canal.id			=	PLATAF.id_canal

	where		1=1
	AND			Canal.Canal	<>	'OTRO'
--##	FILTRO GRUPOS
		AND			CLIE.rut_cli = CLIE.centro_decision
--##	FILTRO GRUPOS
	AND		CLIE.fec_hasta	=	29991231
------------------------------------			

			group by	EJECUT.rut_ejec		
						,EJECUT.nombre		
						,Jefe.rut_ejec		
						,Jefe.nombre		
						,PLATAF.descripcion
						,Canal.canal
	)Totales

	LEFT JOIN 
	(
--clientes visitados
		SELECT 
					count(VisitaCli.RUT_CLI)		clientes
					,SUM(VENCE_MES)				VENCE_MES
					,EJECUT.rut_ejec	rut_ejec
					,EJECUT.nombre		nombre
					,Jefe.rut_ejec		rut_jefe	
					,Jefe.nombre		Jefe
					,PLATAF.descripcion plataforma
------------------------------------
		FROM		[DWH].[dbo].[clientes]						CLIE	
		left JOIN 	
		(
			SELECT		
						--CLCD.id id_cliente, 
						CLCD.RUT_CLI,
						CASE
							WHEN	CONVERT(VARCHAR(10),fecha,112)	BETWEEN	EOMONTH(DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))) 
										AND EOMONTH(DATEADD (month,1-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111)))
								THEN	1
							ELSE	0
						END				VENCE_MES
			FROM		DWH.dbo.clientes		CLCD
			INNER JOIN 
			(
				SELECT		
							CLNW.centro_decision centro_decision
							,max(VICL.fec_realizacion)		fecha	
				from 		DWH.dbo.maestro_cli	 maestAct
				INNER JOIN  DWH.dbo.clientes		CLMA
				ON			maestAct.id_cliente	=	CLMA.id
				AND			maestAct.fecha		=	@mesActividad
				AND			maestAct.Activo		=	1
				LEFT JOIN	DWH.dbo.clientes		CLNW
				ON			CLNW.rut_cli		=	CLMA.rut_cli
				AND			CLNW.fec_hasta		=	29991231
				LEFT JOIN	(
								SELECT		[fec_realizacion], rut_cli
								FROM		DWH.dbo.clientes		CLVI
								LEFT JOIN	DWH.dbo.visitas			VISI
								ON			VISI.id_cliente		=	CLVI.id
								--WHERE CLVI.rut_cli = 76217649
							)VICL
				ON			VICL.rut_cli	=	CLNW.rut_cli
				WHERE		maestAct.fecha		=	@mesActividad
				AND			maestAct.Activo		=	1
				GROUP BY	CLNW.centro_decision
			)VICL
			ON		CLCD.rut_cli	=	 VICL.centro_decision
			WHERE	CLCD.rut_cli	=	 CLCD.centro_decision
			AND		CLCD.fec_hasta	=	29991231
			AND		fecha	>= CONVERT(VARCHAR(10),DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111)),112)
			group by 
						CLCD.RUT_CLI
						,CASE
							WHEN	CONVERT(VARCHAR(10),fecha,112)	BETWEEN	EOMONTH(DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))) 
										AND EOMONTH(DATEADD (month,1-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111)))
								THEN	1
							ELSE	0
						END

		)VisitaCli				
		--ON			VisitaCli.id_cliente	= CLIE.id
		ON			VisitaCli.RUT_CLI	= CLIE.RUT_CLI
	
	
		LEFT JOIN 	
		(
			SELECT		CLIE.rut_cli,CLIEXC.id_motivo--,CLIEXC.fec_desde,CLIEXC.fec_hasta
			FROM		[dwh].[dbo].[clientes]					CLIE
			INNER JOIN	[dwh].[dbo].[clientes_excluidos_vis]	CLIEXC
			ON			CLIE.id				=	CLIEXC.id_cliente	
			--WHERE		CLIEXC.fec_hasta	=	29991231
			GROUP BY	CLIE.rut_cli,CLIEXC.id_motivo--,CLIEXC.fec_desde,CLIEXC.fec_hasta 
		) CLIEXC
		on			CLIE.rut_cli	=	   CLIEXC.rut_cli
		--AND			fecha	BETWEEN	CLIEXC.fec_desde	AND	CLIEXC.fec_hasta-1
		--AND			convert(varchar(10),getdate(),112)	BETWEEN	CLIEXC.fec_desde	AND	CLIEXC.fec_hasta-1
	
		LEFT JOIN 	[dwh].[dbo].[motivo_exclusion_vis]	moex
		on			moex.id	=	   CLIEXC.id_motivo
	
		LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
		ON			CLIE.id		=	ascl.id_cliente
		--AND			fecha	BETWEEN	ascl.fec_desde	AND	ascl.fec_hasta-1
		AND			convert(varchar(10),getdate(),112)	BETWEEN	ascl.fec_desde	AND	ascl.fec_hasta-1
	
		LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
		ON			ascl.id_ejecutivo		=	EJECUT.id		
		--AND			fecha	BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta -1
		AND			convert(varchar(10),getdate(),112)	BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta-1
	
		LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
		ON			jera.id_ejecutivo		=	EJECUT.id
		--AND			fecha	BETWEEN	jera.fec_desde	AND	jera.fec_hasta -1
		AND			convert(varchar(10),getdate(),112)	BETWEEN	jera.fec_desde	AND	jera.fec_hasta-1
	
		LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
		ON			jera.id_jefe		=	JEFE.id
		AND			JEFE.id_plataforma	IS NOT NULL
		--AND			fecha	BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta -1
		AND			convert(varchar(10),getdate(),112)	BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta-1
	
		LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
		ON			UPPER(CASE
					WHEN	JEFE.id_plataforma	IS NULL
					THEN	EJECUT.id_plataforma
					ELSE	JEFE.id_plataforma
					END)				=	PLATAF.id
		--AND			fecha	BETWEEN	PLATAF.fec_desde	AND	PLATAF.fec_hasta-1
		AND			convert(varchar(10),getdate(),112)	BETWEEN	PLATAF.fec_desde	AND	PLATAF.fec_hasta-1
	
		LEFT JOIN 	[DWH].[dbo].[canales]	Canal
		ON			Canal.id			=	PLATAF.id_canal

		where		1=1
		AND			Canal.Canal	<>	'OTRO'
		and			CLIE.fec_hasta = 29991231
--##	FILTRO GRUPOS
		AND			CLIE.rut_cli = CLIE.centro_decision

		AND			CLIEXC.rut_cli IS NULL

--##	FILTRO GRUPOS
------------------------------------
		GROUP BY				
							
--,SUM(VENCE_MES)				VENCE_MES
					EJECUT.rut_ejec	
					,EJECUT.nombre		
					,Jefe.rut_ejec			
					,Jefe.nombre		
					,PLATAF.descripcion 		  
	
	)VistadosClientes
	ON VistadosClientes.rut_ejec = Totales.rut_ejec
	WHERE	Totales.Canal	<>	'OTRO'
	AND	(	Totales.Canal	=	@Canal	OR @Canal = '')

	order by Totales.Canal, Totales.plataforma
			--,nombre;

END


