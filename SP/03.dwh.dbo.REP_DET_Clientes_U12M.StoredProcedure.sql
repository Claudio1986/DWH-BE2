USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_DET_Clientes_U12M]    Script Date: 22/02/2018 19:57:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE [DWH]
--GO
--/****** Object:  StoredProcedure [dbo].[REP_DET_Clientes_U12M]    Script Date: 19/02/2018 13:46:35 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Claudio Ruz Castro>
---- Create date: <2018-01-23>
---- Description:	<Rep Visitas Ejecutivo>
---- =============================================
----[REP_DET_Clientes_U12M] 'CORPORATIVA','C&I',9698854,1,null
ALTER PROCEDURE [dbo].[REP_DET_Clientes_U12M] 
	@Plataforma		varchar(30)
	, @Canal		varchar(30)
	, @Ejecutivo	int
	, @Clientes		varchar(1)
	, @MesAct		varchar(1)
AS
BEGIN

--Plataforma	Plataforma de BE
--Ejecutivo	Ejecutivo perteneciente a la Plataforma
--# Clientes 	Cantidad de Clientes Visitados
--# No Clientes	Cantidad de visitas a clientes no asignados a él.
declare @mesactual datetime, @iniano int


set		@mesactual = convert(varchar(10),dateadd(day,1,EOMONTH(dateadd(month,-1,getdate()))),112)
set		@iniano		= 
						--dateadd(month,-1,
						convert(varchar(10),convert(datetime,EOMONTH(DATEADD(month,-1,getdate())))+1,112)
						--)	

	SELECT		
				CONVERT(VARCHAR(10),visi.fec_realizacion,121)	FecRealizacion,
				visi.rut_cli									RutCli
				,clie.nombre									Cliente
				,EJECUT.rut_ejec								RutEjec
				,CASE
					WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,CONVERT(VARCHAR(10),visi.fec_realizacion,112)))) = @mesactual
						THEN	1
					ELSE	0
				END												MesActual							
				,CASE
					WHEN	clie.rut_cli IS NOT NULL
						THEN	1
					ELSE	0
				END												Clientes
				,PLATAF.descripcion								Plataforma
				,EJECUT.nombre									NomEjec
				,canal.canal									Canal
				,JEFE.nombre									Jefe
	FROM		
	(
		SELECT 
					visi.fec_realizacion,
					clie.rut_cli		Rut_cli,
					visi.id_cliente,
					visi.id_ejecutivo,
					clie.nombre cliente

		FROM				
		(
			SELECT 
					fec_realizacion,
					id_cliente,
					--cliente,
					id_ejecutivo
			FROM	dwh.[dbo].[visitas]	visi
			WHERE	fec_realizacion >= @iniano
			GROUP BY 
					fec_realizacion,
					id_cliente,
					id_ejecutivo--,
					--cliente
		)visi
		LEFT JOIN	dwh.dbo.clientes		cendes
		ON			cendes.id				=	visi.id_cliente	
		AND			cendes.rut_cli			=	centro_decision
		AND			visi.fec_realizacion BETWEEN cendes.fec_desde and cendes.fec_hasta

		LEFT JOIN	dwh.dbo.clientes		clie
		ON		(	clie.id					=	visi.id_cliente	
		OR			clie.centro_decision	=	cendes.centro_decision
				)
		AND			visi.fec_realizacion BETWEEN clie.fec_desde and clie.fec_hasta
	)visi

	LEFT JOIN	(
			SELECT 
					fec_realizacion,
					id_cliente,
					--MAX(cliente)	cliente,
					id_ejecutivo
			FROM	dwh.[dbo].[visitas]	visi
			WHERE	fec_realizacion >= @iniano
			GROUP BY 
					fec_realizacion,
					id_cliente,
					id_ejecutivo
	)visiDet
	ON			visi.fec_realizacion	=	visiDet.fec_realizacion
	AND			visi.id_ejecutivo		=	visiDet.id_ejecutivo

	LEFT JOIN	dwh.dbo.clientes	clie
	ON			visi.id_cliente	=	clie.id
	AND			visi.fec_realizacion BETWEEN	clie.fec_desde	AND	clie.fec_hasta

	LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
	ON			CLIE.id		=	ascl.id_cliente
	AND			visi.fec_realizacion BETWEEN	ascl.fec_desde	AND	ascl.fec_hasta

	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
	ON			ascl.id_ejecutivo		=	EJECUT.id
	AND			visi.id_ejecutivo		=	EJECUT.id
	AND			visi.fec_realizacion BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta		

	LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
	ON			jera.id_ejecutivo		=	EJECUT.id
	AND			visi.fec_realizacion BETWEEN	jera.fec_desde	AND	jera.fec_hasta

	LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
	ON			jera.id_jefe		=	JEFE.id
	AND			JEFE.id_plataforma	IS NOT NULL
	AND			visi.fec_realizacion BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta

	LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
	ON			UPPER(CASE
				WHEN	JEFE.id_plataforma	IS NULL
				THEN	EJECUT.id_plataforma
				ELSE	JEFE.id_plataforma
				END)				=	PLATAF.id

	LEFT JOIN 	[DWH].[dbo].[canales]	Canal
	ON			Canal.id			=	PLATAF.id_canal

	WHERE	EJECUT.nombre IS NOT NULL
	AND		(	canal.canal		=	@Canal	OR	@Canal IS NULL)
	AND		(	PLATAF.descripcion	=	@Plataforma	OR	@Plataforma IS NULL)
	AND		(	EJECUT.rut_ejec	=	@Ejecutivo	OR	@Ejecutivo IS NULL)
	AND		(	CASE
						WHEN	clie.rut_cli IS NOT NULL
							THEN	1
						ELSE	0
				END				=	@Clientes	OR	@Clientes IS NULL)
	AND		(	CASE
						WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,CONVERT(VARCHAR(10),visi.fec_realizacion,112)))) = @mesactual
							THEN	1
						ELSE	0
				END				=	1		OR	@MesAct IS NULL	OR	@MesAct = 0)
	GROUP BY 
				CONVERT(VARCHAR(10),visi.fec_realizacion,121)
				,visi.rut_cli	
				,clie.nombre
				,EJECUT.rut_ejec	
				,CASE
					WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,CONVERT(VARCHAR(10),visi.fec_realizacion,112)))) = @mesactual
						THEN	1
					ELSE	0
				END
				,CASE
					WHEN	clie.rut_cli IS NOT NULL
						THEN	1
					ELSE	0
				END
				,plataf.descripcion
				,EJECUT.nombre	
				,canal.canal	
				,JEFE.nombre	
	ORDER BY	
				canal.canal	
				,plataf.descripcion
				,EJECUT.rut_ejec	
				,CASE
					WHEN	clie.rut_cli IS NOT NULL
						THEN	1
					ELSE	0
				END desc
				,clie.nombre
				,CONVERT(VARCHAR(10),visi.fec_realizacion,121)

END






GO
