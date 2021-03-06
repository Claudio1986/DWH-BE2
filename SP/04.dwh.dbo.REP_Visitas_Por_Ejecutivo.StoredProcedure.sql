USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_Visitas_Por_Ejecutivo]    Script Date: 05/04/2018 14:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('[dbo].[REP_Visitas_Por_Ejecutivo]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[REP_Visitas_Por_Ejecutivo]
END
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-01-23>
-- Description:	<Rep Visitas Ejecutivo>
-- =============================================
--
ALTER PROCEDURE [dbo].[REP_Visitas_Por_Ejecutivo]
AS
BEGIN

--Plataforma	Plataforma de BE
--Ejecutivo	Ejecutivo perteneciente a la Plataforma
--# Clientes 	Cantidad de Clientes Visitados
--# No Clientes	Cantidad de visitas a clientes no asignados a él.
declare @mesactual datetime, @iniano int, @ultmaes datetime

select 	@mesactual	= convert(varchar(10),dateadd(day,1,EOMONTH(dateadd(month,-1,getdate()))),112)
		,@ultmaes	= dateadd(day,1,convert(varchar(10),max(fecha),112))
FROM	DWH.dbo.maestro_cli;

set		@iniano		= convert(varchar(4),datepart(year,getdate()))+'0101'

	SELECT 
			MAX(canal)						Canal,
			MAX(plataforma)					Plataforma,
			rut_ejec						RutEjec,
			MAX(nom_ejec)					Ejecutivo,
			
			sum(CASE 
				WHEN	tipo_cliente	=	'VISITA_CLIENTE'
					THEN	acumulado
				ELSE	0
			END)							acum_Clientes,
			sum(CASE 
				WHEN	tipo_cliente	=	'VISITA_PROSPECTO'
					THEN	acumulado
				ELSE	0
			END)							acum_Prospectos,
			sum(CASE 
				WHEN	tipo_cliente	=	'VISITA_CLIENTE'
					THEN	mes
				ELSE	0
			END)							act_Clientes,
			SUM(CASE 
				WHEN	tipo_cliente	=	'VISITA_PROSPECTO'
					THEN	mes
				ELSE	0
			END)							act_Prospectos,
			sum(CASE 
				WHEN	tipo_cliente	=	'VISITA_CLIENTE'
					THEN	round(isnull(presupuesto,0)*datepart(month,getdate())/12,0)
				ELSE	0
			END)							ppto_Clientes,
			SUM(CASE 
				WHEN	tipo_cliente	=	'VISITA_PROSPECTO'
					THEN	round(isnull(presupuesto,0)*datepart(month,getdate())/12,0)
				ELSE	0
			END)							ppto_Prospectos
	FROM 
	(
		SELECT	
					iSNULL(canal,'')					canal
					,iSNULL(plataforma,'')				plataforma
					,ISNULL(a.rut_ejec,PPTO.rut_ejec)	rut_ejec
					,iSNULL(nom_ejec,'')				nom_ejec
					,tipo_cliente
					,sum(acumulado)						acumulado
					,sum(mes)							mes
					,sum(PPTO.presupuesto)				presupuesto
		FROM	
		(
			SELECT 
						rut_ejec	
						,tipo_meta	tipo	
						,valor		presupuesto
			from		DWH.dbo.metas_ejecutivos		meej
			LEFT JOIN 	DWH.dbo.ejecutivos				EJECUT
			ON			meej.id_ejecutivo	=	EJECUT.id
			AND			EJECUT.id_plataforma	IS  NULL
			AND			especialista_prod		IS  NULL
			LEFT JOIN 	DWH.[dbo].[tipo_meta_ejecutivos] tipm
			ON			meej.id_tipo_meta	=	tipm.id
			WHERE		fec_hasta			=	29991231
		)PPTO
		FULL OUTER JOIN
		(	
			
			SELECT 
					sum(acumulado) acumulado,rut_ejec,sum(mes) mes,tipo_cliente,plataforma,nom_ejec,canal,nombre
			FROM	
			(
				SELECT	
							CONVERT(VARCHAR(10),visi.fec_realizacion,121)	fec_realizacion
							,count(visi.rut_cli)							acumulado
							,EJECUT.rut_ejec
							,sum(
							CASE
								WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,convert(varchar(10),isnull(visi.fec_realizacion,19990101),112)))) = @ultmaes--@mesactual
									THEN	1
								ELSE	0
							END
							)											mes
							,ISNULL(visi.tipo_cliente,0)				tipo_cliente
							,plataf.descripcion							plataforma
							,EJECUT.nombre								nom_ejec
							,canal.canal
							,jefe.nombre
				FROM		[DWH].[dbo].[ejecutivos]	EJECUT
				
				LEFT JOIN	
				(
					select 
								max(fec_realizacion)	fec_realizacion
								,rut_ejec
								,CASE WHEN cli.tipo_cliente = 1 THEN 'VISITA_CLIENTE' ELSE 'VISITA_PROSPECTO' END 	tipo_cliente
								,rut_cli
					from		dwh.dbo.visitas  vis
					LEFT JOIN	dwh.dbo.clientes cli
					ON			cli.id = vis.id_cliente
					LEFT JOIN	dwh.dbo.ejecutivos ejec
					ON			ejec.id = vis.id_ejecutivo
					where		fec_realizacion >= @iniano
					--AND		rut_ejec	=	17699169
					GROUP BY	fec_realizacion
								,rut_ejec
								,CASE WHEN cli.tipo_cliente = 1 THEN 'VISITA_CLIENTE' ELSE 'VISITA_PROSPECTO' END
								,rut_cli

				)visi
				ON			visi.rut_ejec	=	EJECUT.rut_ejec
				
				LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
				ON			jera.id_ejecutivo		=	EJECUT.id
				AND			convert(varchar(10),getdate(),112) BETWEEN	jera.fec_desde	AND	jera.fec_hasta
				
				LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
				ON			jera.id_jefe		=	JEFE.id
				AND			JEFE.id_plataforma	IS NOT NULL
				AND			convert(varchar(10),getdate(),112) BETWEEN	JEFE.fec_desde	AND	JEFE.fec_hasta
				
				LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
				ON			UPPER(CASE
							WHEN	JEFE.id_plataforma	IS NULL
							THEN	EJECUT.id_plataforma
							ELSE	JEFE.id_plataforma
							END)				=	PLATAF.id
				AND			convert(varchar(10),getdate(),112) BETWEEN	PLATAF.fec_desde	AND	PLATAF.fec_hasta
				
				LEFT JOIN 	[DWH].[dbo].[canales]	Canal
				ON			Canal.id			=	PLATAF.id_canal
				
				WHERE		EJECUT.id_plataforma		IS  NULL
				--AND			EJECUT.especialista_prod	IS  NULL
				AND			convert(varchar(10),getdate(),112) BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta
				--AND			EJECUT.rut_ejec = 17699169
				GROUP BY 
							CONVERT(VARCHAR(10),visi.fec_realizacion,121)
							,EJECUT.rut_ejec	
							,ISNULL(visi.tipo_cliente,0)		
							,plataf.descripcion
							,EJECUT.nombre	
							,canal.canal	
							,JEFE.nombre	
			)a group by rut_ejec,tipo_cliente,plataforma,nom_ejec,canal,nombre
		)a
		--
		ON		PPTO.rut_ejec	=	a.rut_ejec
		AND		tipo_cliente	=	tipo
		--WHERE	ISNULL(a.rut_ejec,PPTO.rut_ejec) = 17699169
		GROUP BY	ISNULL(a.rut_ejec,PPTO.rut_ejec), plataforma,nom_ejec, canal,tipo_cliente
	)Visitas
	GROUP BY		rut_ejec

END		
