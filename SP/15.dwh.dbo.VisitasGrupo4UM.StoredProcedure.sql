USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[VisitasGrupo4UM]    Script Date: 09/04/2018 18:25:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[VisitasGrupo4UM]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[VisitasGrupo4UM]
END
GO

ALTER PROCEDURE [dbo].[VisitasGrupo4UM] @Ejecutivo decimal(10),@Visitado smallint, @Canal VARCHAR(10), @Plataforma varchar(50)
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Visitas por Centro de Decision>
-- =============================================
--exec  [dbo].[VisitasGrupo4UM]0,5,'PYME',NULL ;
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--declare @Ejecutivo decimal(10),@Visitado smallint, @Canal VARCHAR(10), @Plataforma VARCHAR(30)
	--set @Ejecutivo = 9494147 
	--SET @Visitado = 0
	--SET @Canal = ''

	SET NOCOUNT ON;

	DECLARE @mesActividad int
	
	SELECT		@mesActividad	=	max(maestAct.Fecha)
	FROM		DWH.dbo.maestro_cli		maestAct

	DECLARE @fecha datetime;


	SELECT 
				Canal
				,PLATAF.descripcion Plataforma
				,CLIE.rut_cli		Rut_cli
				,CLIE.nombre		Cliente
				,EJECUT.nombre		Ejecutivo
				,CONVERT(VARCHAR(10),VisitaCli.fecha,111)	Fecha_Visita
				,CASE
				WHEN	VisitaCli.fecha	>= CONVERT(VARCHAR(10),DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), getdate(), 112)), 112)
				THEN	'VISITADO4M'
				ELSE	'NO VISITADO'
				END											Visita
				,moex.motivo								Motivo_Exclusion
	FROM		[DWH].[dbo].[clientes]						CLIE	
	INNEr JOIN 	
	(
		SELECT		CLCD.id id_cliente, 
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
						)VICL
			ON			VICL.rut_cli	=	CLNW.rut_cli
			GROUP BY	CLNW.centro_decision
		)VICL
		ON		CLCD.rut_cli	=	 VICL.centro_decision
		WHERE	CLCD.rut_cli	=	 CLCD.centro_decision
		AND		CLCD.fec_hasta	=	29991231
		group by CLCD.id

	)VisitaCli				
	ON			VisitaCli.id_cliente	= CLIE.id
	
	
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

	AND		(	Canal			=	@Canal		OR	@Canal = '')
	AND		(	EJECUT.rut_ejec	=	@Ejecutivo	OR	@Ejecutivo = 0)
		--
	AND		(	CASE
				WHEN	CLIEXC.rut_cli	IS NOT NULL
					THEN	2
				WHEN	convert(varchar(10),ISNULL(VisitaCli.fecha,19000101),112)	>= DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))
					THEN
						CASE	
							WHEN	@Visitado = 1 AND convert(varchar(10),ISNULL(VisitaCli.fecha,19000101),112)	>= DATEADD (month,-CASE WHEN frec_visita is null then CASE WHEN frec_visita is null then 4 else frec_visita END else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))
								THEN	1--'VISITADO4M'
							WHEN	@Visitado = 3 AND convert(varchar(10),ISNULL(VisitaCli.fecha,19000101),112)	BETWEEN EOMONTH(DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))) AND EOMONTH(DATEADD (month,-3,CONVERT(VARCHAR(10), GETDATE(), 111)))
								THEN	3--'PORVENCER'					
						END
				WHEN	convert(varchar(10),ISNULL(VisitaCli.fecha,19000101),112)	< DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))
					THEN	0--'NO VISITADO'
					else CASE WHEN frec_visita is null then 4 else frec_visita END--'TODOS NO EXCLUIDOS'
				END	=	@Visitado	OR (@Visitado = 4 and CLIEXC.rut_cli 	IS NULL) OR (@Visitado = 5))--5= TODOS incl EXCLUIDOS

	GROUP BY				
				Canal
				,PLATAF.descripcion
				,CLIE.rut_cli	
				,CLIE.nombre		
				,EJECUT.nombre 		
				,CONVERT(VARCHAR(10),VisitaCli.fecha,111)
				,CASE
				WHEN	VisitaCli.fecha	>= CONVERT(VARCHAR(10),DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), getdate(), 112)), 112)
				THEN	'VISITADO4M'
				ELSE	'NO VISITADO'
				END							
				,moex.motivo	
	
	order by CLIE.rut_cli asc

END
