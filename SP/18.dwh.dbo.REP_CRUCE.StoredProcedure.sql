USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_STOCK_COLOCACIONES]    Script Date: 28/03/2018 18:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[REP_CRUCE] 
IF OBJECT_ID('[dbo].[REP_CRUCE]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[REP_CRUCE]
END
GO
CREATE PROCEDURE [dbo].[REP_CRUCE] --@Mes varchar(6)
AS
BEGIN

	select       
				 CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 0
				  ELSE	EJECUT.rut_ejec
				  END							Rut_Ejec
				 ,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 'LIBRE' 
				  ELSE EJECUT.nombre 
				  END							Ejecutivo 
				 ,PLATAF.descripcion			Plataforma
				 ,count(clie.rut_cli)			Cantidad
				 ,sum(maestros.Act_Com + maestros.Act_BG + maestros.Act_Fact + 
						 maestros.Act_Leas + maestros.Act_Comex + maestros.Act_Dap + maestros.Act_Mesa + maestros.Cta_Cte) N_productos
				 ,maestros.fecha			Fecha

	from         dwh.dbo.clientes                               clie
	INNER JOIN 
	(
		SELECT		rut_cli
					,fecha
					,mavl.Act_Com 
					,mavl.Act_BG 
					,mavl.Act_Fact 
					,mavl.Act_Leas
					,mavl.Act_Comex
					,mavl.Act_Dap
					,mavl.Act_Mesa
					,mavl.Cta_Cte
		from        dwh.dbo.clientes                               clie
		INNER JOIN  DWH.DBO.maestro_cli mavl   
		ON          mavl.id_cliente=   clie.id
		AND         mavl.Activo    =   1
		AND         mavl.fecha in (
									select 
											fecha
									from	dwh.dbo.maestro_cli 
									WHERE	fecha >= (select convert(varchar(10),dateadd(month,-1,convert(varchar(4),year(getdate()),112)+'0101'),112))
									group by fecha

									)
		GROUP BY	rut_cli
					,fecha
					,mavl.Act_Com 
					,mavl.Act_BG 
					,mavl.Act_Fact 
					,mavl.Act_Leas
					,mavl.Act_Comex
					,mavl.Act_Dap
					,mavl.Act_Mesa
					,mavl.Cta_Cte
	)maestros
	ON			 CLIE.rut_cli	=	maestros.rut_cli
	LEFT JOIN    [DWH].[dbo].[asignacion_clientes] ascl
	ON           CLIE.id                                 =      ascl.id_cliente
	AND          ascl.fec_hasta                    =      29991231

	LEFT JOIN    [DWH].[dbo].[ejecutivos]   EJECUT
	ON           ascl.id_ejecutivo          =      EJECUT.id    
	AND          EJECUT.fec_hasta           =      29991231


		   LEFT JOIN    [DWH].[dbo].[jerarquia_ejecutivos]  jera
		   ON                  jera.id_ejecutivo  = EJECUT.id
		   and                 jera.fec_hasta             =      29991231


		   LEFT JOIN    [DWH].[dbo].[ejecutivos]    JEFE
		   ON                  jera.id_jefe  = JEFE.id
		   AND                 JEFE.id_plataforma IS NOT NULL
		   and                 jefe.fec_hasta             =      29991231   

		   left join    dwh.dbo.normalizaciones as normal
		   on                  CLIE.id = normal.id_cliente
		   AND                 normal.fec_hasta    =      29991231   
       

		   LEFT JOIN  [DWH].[dbo].[plataformas]    PLATAF
		   ON                  UPPER(CASE
							   WHEN normal.id_plataforma IS NOT NULL
									  THEN normal.id_plataforma
							   WHEN JEFE.id_plataforma IS NOT NULL
									  THEN JEFE.id_plataforma
							   ELSE EJECUT.id_plataforma
							   END)                       = PLATAF.id
		   AND                 PLATAF.fec_hasta    =      29991231

	WHERE       clie.fec_hasta             =      29991231

	group by    CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 0
				  ELSE	EJECUT.rut_ejec
				  END
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 'LIBRE' 
				  ELSE EJECUT.nombre 
				  END
				,PLATAF.descripcion
				,maestros.fecha

	order by    
				PLATAF.descripcion
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 0
				  ELSE	EJECUT.rut_ejec
				  END
				,CASE WHEN ascl.id_cliente IS NOT NULL AND ascl.id_ejecutivo IS NULL  
					THEN 'LIBRE' 
				  ELSE EJECUT.nombre 
				  END
END