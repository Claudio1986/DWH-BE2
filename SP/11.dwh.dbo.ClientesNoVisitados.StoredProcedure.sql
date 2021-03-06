USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[ClientesNoVisitados]    Script Date: 22/02/2018 19:57:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[ClientesNoVisitados]	'C&I'
ALTER PROCEDURE [dbo].[ClientesNoVisitados] @Canal VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--declare @Canal VARCHAR(30);

	SET NOCOUNT ON;

	DECLARE @mesActividad int
	
	SELECT		@mesActividad	=	max(maestAct.Fecha)
	FROM		dbo.maestro_cli		maestAct

	
	SELECT 
			Totales.rut_ejec
			--,Totales.dv_ejec
			,Totales.nombre
			,Totales.rut_jefe
			--,Totales.dv_jefe
			,Totales.Jefe
			,Platafor.descripcion			plataforma
			,canal.Canal
			,ISNULL(VistadosClientes.clientes,0)									Visitados
			,Totales.clientes-Totales.clientes_excl-ISNULL(VistadosClientes.clientes,0)	
																					NoVisitados
			,Totales.clientes_excl													Excluidos
			,Totales.clientes-ISNULL(Totales.clientes_excl,0)						Totales
			,isnULL(VistadosNumero.visitas4M,0)										visitas4M
			,
			CASE 
				WHEN CAST(Totales.clientes-ISNULL(Totales.clientes_excl,0) as decimal(10,4))  <> 0
					THEN CAST(ROUND(CAST((Totales.clientes-ISNULL(VistadosClientes.clientes,0)-ISNULL(Totales.clientes_excl,0))*100 as decimal(10,4))
						/CAST(Totales.clientes-ISNULL(Totales.clientes_excl,0) as decimal(10,4)),0) as decimal(10,0))			
				ELSE	0
			END																		'%No_Visitado'
			,isNULL(VENCE_MES,0)													VENCE_MES
	--select *
	FROM
	(
			SELECT 
						0 as visitas
						,count(CLIE.rut_cli) clientes
						,SUM(
						CASE
							WHEN	CLIEXC.id_cliente	IS NOT NULL
								THEN	1
							ELSE	0
						END)				clientes_excl
						,EJECUT.rut_ejec	rut_ejec
						,EJECUT.nombre		nombre
						,JEFE.rut_ejec		rut_jefe	
						,JEFE.nombre		Jefe
						,PLATAF.id			id_plataforma
						,'existente'		tipo
			FROM		[DWH].[dbo].[clientes]				CLIE
			LEFT JOIN 	[dwh].[dbo].[clientes_excluidos_vis]	CLIEXC
			on			CLIE.id	=	   CLIEXC.id_cliente

			LEFT JOIN 	[dwh].[dbo].[motivo_exclusion_vis]	moex
			on			moex.id	=	   CLIEXC.id_motivo

			LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
			ON			CLIE.id		=	ascl.id_cliente

			LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
			ON			ascl.id_ejecutivo		=	EJECUT.id		

			LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
			ON			jera.id_ejecutivo		=	EJECUT.id

			LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
			ON			jera.id_jefe		=	JEFE.id
			AND			JEFE.id_plataforma	IS NOT NULL

			LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
			ON			UPPER(CASE
						WHEN	JEFE.id_plataforma	IS NULL
						THEN	EJECUT.id_plataforma
						ELSE	JEFE.id_plataforma
						END)				=	PLATAF.id

			LEFT JOIN 	[DWH].[dbo].[canales]	Canal
			ON			Canal.id			=	PLATAF.id_canal

			LEFT JOIN	DWH.dbo.maestro_cli		maestAct
			ON			maestAct.id_Cliente	=	CLIE.id
			AND			maestAct.Fecha		=	@mesActividad
				
			where		1=1
			AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	CLIE.fec_desde	AND	ISNULL(CLIE.fec_hasta,29991231)
			AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	EJECUT.[fec_desde]	AND	ISNULL(EJECUT.[fec_hasta],29991231)
			AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	PLATAF.[fec_desde]	AND	ISNULL(PLATAF.[fec_hasta],29991231)
			AND			Activo = 1


			
			group by	EJECUT.rut_ejec		
						,EJECUT.nombre		
						,JEFE.rut_ejec		
						,JEFE.nombre
						,PLATAF.id
	)Totales
	left join 
	(
		SELECT 
					sum(visitasmes)	visitas4M
					,rut_ejec
					,nombre
					,rut_jefe
					,Jefe
					--,plataforma
					,'VISITADO'			tipo
		from
		(
					SELECT 
								sum(nrovisitas)		visitasmes
								,EJECUT.rut_ejec	rut_ejec
								,EJECUT.dv_ejec		dv_ejc
								,EJECUT.nombre		nombre
								,JEFE.rut_ejec		rut_jefe	
								,JEFE.dv_ejec		dv_jefe
								,JEFE.nombre		Jefe
								--,CASE
								--WHEN	PLATAF.plataforma	IS NULL
								--THEN	EJECUT.plataforma
								--ELSE	PLATAF.plataforma
								--END					plataforma
								,MAX(VisitaCli.fechafm)		fechafm
					FROM		
					(
						SELECT 
								rut_cli
								,fechaFM
								--,fecha
								,count(rut_cli)	nrovisitas
						FROM 
						(
								SELECT		
											CLIENT.rut_cli
											,fecha
											,EOMONTH(CONVERT(VARCHAR(8),fecha,112))	fechaFM
								FROM		[DWH].dbo.clientes	CLIENT
								LEFT JOIN	
								(
									select 
												MAX(VISITA.[fec_realizacion])	fecha
												,CLIENT.centro_decision
									from 		[DWH].dbo.visitas		VISITA
									LEFT JOIN	[DWH].dbo.clientes	CLIENT
									ON			VISITA.id_cliente = CLIENT.id
									WHERE		CLIENT.centro_decision IS NOT NULL
									GROUP BY	CLIENT.centro_decision
												--,VISITA.rut_cli
								)CLIVIS
								ON			CLIVIS.centro_decision = CLIENT.centro_decision
								WHERE		1=1

								--AND			fecha	>= DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))
								AND			CLIVIS.centro_decision IS NOT NULL
						)Visita
						group by	rut_cli
									,fechaFM
					)VisitaCli				
					LEFT JOIN 	[DWH].[dbo].[clientes]			CLIE
					ON			VisitaCli.rut_cli	= CLIE.rut_cli

					LEFT JOIN 	[dwh].[dbo].[clientes_excluidos_vis]	CLIEXC
					on			CLIE.id	=	   CLIEXC.id_cliente

					LEFT JOIN 	[dwh].[dbo].[motivo_exclusion_vis]	moex
					on			moex.id	=	   CLIEXC.id_motivo

					LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
					ON			CLIE.id		=	ascl.id_cliente

					LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
					ON			ascl.id_ejecutivo		=	EJECUT.id		

					LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
					ON			jera.id_ejecutivo		=	EJECUT.id

					LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
					ON			jera.id_jefe		=	JEFE.id
					AND			JEFE.id_plataforma	IS NOT NULL

					LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
					ON			UPPER(CASE
								WHEN	JEFE.id_plataforma	IS NULL
								THEN	EJECUT.id_plataforma
								ELSE	JEFE.id_plataforma
								END)				=	PLATAF.id

					LEFT JOIN 	[DWH].[dbo].[canales]	Canal
					ON			Canal.id			=	PLATAF.id_canal

					LEFT JOIN	DWH.dbo.maestro_cli		maestAct
					ON			maestAct.id_Cliente	=	CLIE.id
					AND			maestAct.Fecha		=	@mesActividad

					where		1=1
					AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	CLIE.fec_desde	AND	ISNULL(CLIE.fec_hasta,29991231)
					AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	EJECUT.[fec_desde]	AND	ISNULL(EJECUT.[fec_hasta],29991231)
					AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	PLATAF.[fec_desde]	AND	ISNULL(PLATAF.[fec_hasta],29991231)
					AND			maestAct.Activo = 1
					AND			fechaFM	>= DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 111))
					AND			CLIEXC.id_cliente	IS NULL
					group by 		
								EJECUT.rut_ejec
								,EJECUT.dv_ejec	
								,EJECUT.nombre	
								,Jefe.rut_ejec	
								,Jefe.dv_ejec
								,Jefe.nombre	
								--,CASE
								--WHEN	PLATAF.plataforma	IS NULL
								--THEN	EJECUT.plataforma
								--ELSE	PLATAF.plataforma
								--END		  
								,VisitaCli.fechaFM
		)a	
		group by rut_ejec,dv_ejc,nombre,rut_jefe,dv_jefe,Jefe
		--,plataforma
	)VistadosNumero
	ON VistadosNumero.rut_ejec = Totales.rut_ejec
	LEFT JOIN 
	(
--clientes visitados
		SELECT 
					count(VisitaCli.rut_cli)	clientes
					,SUM(VENCE_MES)				VENCE_MES
					,EJECUT.rut_ejec			rut_ejec
					,EJECUT.dv_ejec				dv_ejc
					,EJECUT.nombre				nombre
					,Jefe.rut_ejec				rut_jefe	
					,Jefe.dv_ejec				dv_jefe
					,Jefe.nombre				Jefe
					,PLATAF.descripcion			plataforma
		FROM		
		(
			SELECT 
					rut_cli
					,VENCE_MES
			FROM 
			(
				SELECT		
							CLIENT.rut_cli
							,CASE
								WHEN	CONVERT(VARCHAR(10),fecha,112)	BETWEEN	EOMONTH(DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 112))) 
									AND	EOMONTH(DATEADD (month,-CASE WHEN frec_visita is null then 3 else frec_visita-1 END,CONVERT(VARCHAR(10), GETDATE(), 112)))
									THEN	1
								ELSE	0
							END				VENCE_MES
				FROM		[DWH].dbo.clientes	CLIENT
				LEFT JOIN	
				(
					select 
								MAX(VISITA.[fec_realizacion])	fecha
								,CLIENT.centro_decision
					from 		[DWH].dbo.visitas		VISITA
					LEFT JOIN	[DWH].dbo.clientes	CLIENT
					ON			VISITA.id_cliente = CLIENT.id
					WHERE		CLIENT.centro_decision IS NOT NULL
					GROUP BY	CLIENT.centro_decision
								--,VISITA.rut_cli
				)CLIVIS
				ON			CLIVIS.centro_decision = CLIENT.centro_decision
				WHERE		1=1

				AND			convert(varchar(10),fecha,112)	>= DATEADD (month,-CASE WHEN frec_visita is null then 4 else frec_visita END,CONVERT(VARCHAR(10), GETDATE(), 112))
				AND			CLIVIS.centro_decision IS NOT NULL
			)Visita
			group by	rut_cli
						,VENCE_MES
		)VisitaCli				
		LEFT JOIN 	[DWH].[dbo].[clientes]			CLIE
		ON			VisitaCli.rut_cli	= CLIE.rut_cli

		LEFT JOIN 	[dwh].[dbo].[clientes_excluidos_vis]	CLIEXC
		on			CLIE.id	=	   CLIEXC.id_cliente

		LEFT JOIN 	[dwh].[dbo].[motivo_exclusion_vis]	moex
		on			moex.id	=	   CLIEXC.id_motivo

		LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
		ON			CLIE.id		=	ascl.id_cliente

		LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
		ON			ascl.id_ejecutivo		=	EJECUT.id		

		LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
		ON			jera.id_ejecutivo		=	EJECUT.id

		LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
		ON			jera.id_jefe		=	JEFE.id
		AND			JEFE.id_plataforma	IS NOT NULL

		LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
		ON			UPPER(CASE
					WHEN	JEFE.id_plataforma	IS NULL
					THEN	EJECUT.id_plataforma
					ELSE	JEFE.id_plataforma
					END)				=	PLATAF.id

		LEFT JOIN 	[DWH].[dbo].[canales]	Canal
		ON			Canal.id			=	PLATAF.id_canal

		LEFT JOIN	DWH.dbo.maestro_cli		maestAct
		ON			maestAct.id_Cliente	=	CLIE.id
		AND			maestAct.Fecha		=	@mesActividad

		where		1=1
		AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	CLIE.fec_desde	AND	ISNULL(CLIE.fec_hasta,29991231)
		AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	EJECUT.[fec_desde]	AND	ISNULL(EJECUT.[fec_hasta],29991231)
		AND			CONVERT(VARCHAR(10), GETDATE(), 112) BETWEEN	PLATAF.[fec_desde]	AND	ISNULL(PLATAF.[fec_hasta],29991231)
		AND			maestAct.Activo = 1
		AND			CLIEXC.id_cliente	IS NULL
		group by 		
					EJECUT.rut_ejec
					,EJECUT.dv_ejec	
					,EJECUT.nombre	
					,JEFE.rut_ejec	
					,JEFE.dv_ejec
					,JEFE.nombre	
					,PLATAF.descripcion		  
	
	)VistadosClientes
	ON			VistadosClientes.rut_ejec = Totales.rut_ejec
	LEFT JOIN	[DWH].dbo.plataformas	Platafor
	ON			UPPER(Totales.id_plataforma) = Platafor.id

	LEFT JOIN 	[DWH].[dbo].[canales]	Canal
	ON			Canal.id			=	Platafor.id_canal

	WHERE		canal.Canal	<>	'OTRO'
	AND	(		canal.Canal	=	@Canal	OR @Canal = '')
	order by 
				Canal, 
				plataforma
				,nombre;

END




GO
