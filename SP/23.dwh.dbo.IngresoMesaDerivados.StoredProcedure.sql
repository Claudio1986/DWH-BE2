USE [DWH]
GO

/****** Object:  StoredProcedure [dbo].[IngresoMesaDerivados]    Script Date: 05/11/2018 15:57:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[IngresoMesaDerivados] 
CREATE PROCEDURE [dbo].[IngresoMesaDerivados] 
AS
BEGIN

	DECLARE	@Fecha		int
			,@Mes		int
			,@MesAnt	int
			,@Año		int

	select 		
				@Fecha	=	convert(varchar(10),MAX(FECHA),112)
				,@Mes	=	convert(varchar(10),dateadd(day,1,EOMONTH(dateadd(month,-1,convert(varchar(10),MAX(FECHA),112)))),112)
				,@MesAnt=	convert(varchar(10),EOMONTH(dateadd(month,-1,convert(varchar(10),MAX(FECHA),112))),112)
				,@Año	=	year(dateadd(month,-1,convert(varchar(10),MAX(FECHA),112)))*10000+101
	FROM		[DWH].[dbo].[spotfwd]	SPOT

	SELECT	
			@Fecha		fecha	
			,@Mes		MesAnt
			,@Año		Año
			,año.rut_ejec
			,año.Ejecutivo
			,año.rut_jefe
			,año.Jefe
			,año.Plataforma 
			,año.Canal			
			,cast(round(ISNULL(año.margen,0)/1000,0)as int)	margenAño
			,cast(round(ISNULL(mes.margen,0)/1000,0)as int)	margenMes
			,cast(round(ISNULL(dia.margen,0)/1000,0)as int)	margenDia
			,cast(round(ISNULL(valorMeta,0)/1000,0)as int)	valorMeta
			,CASE
			WHEN valorMeta IS NOT NULL	AND	valorMeta	<>	0
				THEN	cast(round(ISNULL(año.margen,0)*100/ISNULL(valorMeta,0),0)as int)
			ELSE	0
			END	[% Cumpl.]
	FROM
	(
		SELECT  
					SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,4)+'0101'	  fecha
		--			,clie.rut_cli
					,clie.rut_ejec 
					,clie.Ejecutivo
					,clie.rut_jefe
					,clie.Jefe
					,clie.Plataforma 
					,clie.Canal
					,sum([Utilidad])		margen
		FROM		[DWH].[dbo].[spotfwd]	SPOT
		INNER JOIN	[DWH].[dbo].[VW_CliAct]	CLIE
		ON			SPOT.id_cliente	=	clie.id_cliente
		AND			clie.Fecha		=	@MesAnt
		WHERE		Utilidad IS NOT NULL
		AND			rut_cli	IS NOT NULL	
		AND			SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,4)	=	SUBSTRING(convert(varchar(10),@Fecha,112),1,4)
		group by	SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,4)
		--			,clie.rut_cli
					,clie.rut_ejec 
					,clie.rut_jefe
					,clie.Ejecutivo
					,clie.Jefe
					,clie.Plataforma 
					,clie.Canal
	)AÑO
	LEFT JOIN 
	(
		SELECT  
					SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,6)+'01'		fecha
					--,clie.rut_cli
					,clie.rut_ejec 
					,sum([Utilidad])		margen
		FROM		[DWH].[dbo].[spotfwd]	SPOT
		INNER JOIN	[DWH].[dbo].[VW_CliAct]	CLIE
		ON			SPOT.id_cliente	=	clie.id_cliente
		AND			clie.Fecha		=	@MesAnt
		WHERE		Utilidad IS NOT NULL
		AND			SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,6)	=	SUBSTRING(convert(varchar(10),@Fecha,112),1,6)
		group by	SUBSTRING(convert(varchar(10),SPOT.[Fecha],112),1,6)
					--,clie.rut_cli
					,clie.rut_ejec 
	)MES
	ON		MES.rut_ejec	=	año.rut_ejec
	LEFT JOIN 
	(
		SELECT  
					SPOT.[Fecha]
					--,clie.rut_cli
					,clie.rut_ejec 
					,sum([Utilidad])		margen
		FROM		[DWH].[dbo].[spotfwd]	SPOT
		INNER JOIN	[DWH].[dbo].[VW_CliAct]	CLIE
		ON			SPOT.id_cliente	=	clie.id_cliente
		AND			clie.Fecha		=	@MesAnt
		WHERE		Utilidad IS NOT NULL
		AND			SPOT.[Fecha]	=	@Fecha
		group by	SPOT.[Fecha]
					--,clie.rut_cli
					,clie.rut_ejec 

	)dia
	ON		MES.rut_ejec	=	dia.rut_ejec
	LEFT JOIN 
	(
		SELECT	
					ejec.rut_ejec	
					,valor*1000	valorMeta
		FROM		dwh.[dbo].[metas_ejecutivos]	meej
		LEFT JOIN	dwh.[dbo].[ejecutivos]			ejec
		ON			meej.id_ejecutivo	=	ejec.id
		WHERE		id_tipo_meta		=	3
		AND			año					=	year(dateadd(month,-1,getdate()-1))
	)meta
	On		Meta.rut_ejec	=	año.rut_ejec
	WHERE	año.rut_ejec		<>	0
	--AND		año.rut_jefe = 10220213


END
GO


