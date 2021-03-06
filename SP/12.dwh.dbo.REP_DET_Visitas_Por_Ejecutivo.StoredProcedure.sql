USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_DET_Visitas_Por_Ejecutivo]    Script Date: 05/04/2018 14:46:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('[dbo].[REP_DET_Visitas_Por_Ejecutivo]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[REP_DET_Visitas_Por_Ejecutivo]
END
GO

--[REP_DET_Visitas_Por_Ejecutivo] NULL,NULL,NULL,NULL,NULL
ALTER PROCEDURE [dbo].[REP_DET_Visitas_Por_Ejecutivo] --	17699169
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-01-23>
-- Description:	<Rep Visitas Ejecutivo>
-- =============================================
	@Plataforma		varchar(30)
	, @Canal		varchar(30)
	, @Ejecutivo	int
	, @Clientes		varchar(1)
	, @MesAct		varchar(1)
AS
BEGIN
	--  declare 
	--  @Plataforma	varchar(30)	=	'INMOBILIARIA'
	--, @Canal		varchar(30)	=	'C&I'
	--, @Ejecutivo	int			=	17699169
	--, @Clientes		varchar(1)	--=	0
	--, @MesAct		varchar(1)	=	0
--Plataforma	Plataforma de BE
--Ejecutivo	Ejecutivo perteneciente a la Plataforma
--# Clientes 	Cantidad de Clientes Visitados
--# No Clientes	Cantidad de visitas a clientes no asignados a él.
declare @mesactual datetime, @iniano int, @ultmaes datetime

--set		@mesactual	= convert(varchar(10),dateadd(day,1,EOMONTH(dateadd(month,-2,getdate()))),112)

select 	@mesactual	= convert(varchar(10),dateadd(day,1,EOMONTH(dateadd(month,-1,getdate()))),112)
		,@ultmaes	= dateadd(day,1,convert(varchar(10),max(fecha),112))
FROM	DWH.dbo.maestro_cli;

--select 	@mesactual	
--		,@ultmaes	

set		@iniano		= convert(varchar(4),datepart(year,getdate()))+'0101'
	   --select @iniano

	SELECT	   CONVERT(VARCHAR(10),visi.fec_realizacion,121)	fec_realizacion
				,visi.rut_cli									rutCli
				,visi.nombCli									Cliente
				,EJECUT.rut_ejec								rutEjec
				,CASE
					WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,convert(varchar(10),isnull(visi.fec_realizacion,19990101),112)))) = @ultmaes--@mesactual
						THEN	1
					ELSE	0
				END												mes
				,ISNULL(visi.tipo_cliente,0)					tipo_cliente
				,plataf.descripcion								plataforma
				,EJECUT.nombre									nomEjec
				,canal.canal									canal
				,jefe.nombre									NomJefe
	FROM		[DWH].[dbo].[ejecutivos]	EJECUT

	LEFT JOIN	
	(
		select 
					--MAX(fec_realizacion)	
					fec_realizacion, 
					rut_ejec
					,CASE WHEN cli.tipo_cliente = 1 THEN 'VISITA_CLIENTE' else 'VISITA_PROSPECTO' END 	tipo_cliente
					,rut_cli
					,cli.nombre	nombCli
		from		dwh.dbo.visitas  vis
		LEFT JOIN	dwh.dbo.clientes cli
		ON			cli.id = vis.id_cliente
		LEFT JOIN	dwh.dbo.ejecutivos ejec
		ON			ejec.id = vis.id_ejecutivo
		where		fec_realizacion >= @iniano
		GROUP BY	 fec_realizacion
					,rut_ejec
					,CASE WHEN cli.tipo_cliente = 1 THEN 'VISITA_CLIENTE' else 'VISITA_PROSPECTO' END
					,rut_cli
					,cli.nombre
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

	WHERE		fec_realizacion IS NOT NULL
	AND			EJECUT.id_plataforma		IS  NULL
	--AND			EJECUT.especialista_prod	IS  NULL
	AND			convert(varchar(10),getdate(),112) BETWEEN	EJECUT.fec_desde	AND	EJECUT.fec_hasta

	AND		(	canal		=	@Canal	OR	@Canal IS NULL)
	AND		(	plataf.descripcion	=	@Plataforma	OR	@Plataforma IS NULL)
	AND		(	EJECUT.rut_ejec	=	@Ejecutivo	OR	@Ejecutivo IS NULL)
	AND		(	CASE
						WHEN	tipo_cliente	=	'VISITA_CLIENTE'
							THEN	1
						ELSE	0
				END				=	@Clientes	OR	@Clientes IS NULL)
	AND		(	CASE
					WHEN	dateadd(day,1,EOMONTH(dateadd(month,-1,convert(varchar(10),isnull(visi.fec_realizacion,19990101),112)))) = @ultmaes--

						THEN	0
					ELSE	1
				END				=	@MesAct		OR	@MesAct IS NULL	OR	@MesAct = 1)
END
