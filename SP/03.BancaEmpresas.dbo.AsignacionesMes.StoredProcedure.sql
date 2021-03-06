USE [BancaEmpresas]
GO
/****** Object:  StoredProcedure [dbo].[AsignacionesMes]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--drop PROCEDURE dbo.CargaMaestro;
ALTER PROCEDURE [dbo].[AsignacionesMes] @Mes varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @fecha datetime;

	SET @fecha = DATEADD (dd,-1,DATEADD (mm , 1 , cast(@Mes+'01' as DATETIME) ) ) ;


	select --distinct 
			ISNULL(norm.[rut_cli],CLIENT.rut_cli)													Rut_cli
			,ISNULL(norm.[nombre],CLIENT.nombre)													Cliente 
			,	CASE 
					WHEN	norm.[rut_cli] IS NOT NULL 
						THEN 'NORMALIZACION' 
					WHEN	rut_ejc	=	0
						THEN	'LIBRE'
					ELSE ejecut.nombre 
				END																					Ejecutivo
			,	CASE 
					WHEN norm.[rut_cli] IS NOT NULL OR CLIENT.[rut_ejc] = 0
						THEN 0 
					ELSE ejecut.rut_jefe 
				END																					rut_jefe
			,ISNULL(norm.[centro_decision],CLIENT.[centro_decision])								[centro_decision]
			, ISNULL(norm.[plataforma_],
				CASE
					WHEN Plataf.plataforma = ' '
						THEN	UPPER(ejecut.plataforma)
					WHEN CLIENT.[rut_ejc] = 0
						THEN 'LIBRE' 
					ELSE UPPER(Plataf.plataforma)
				END)	plataforma
	from		dbo.gc_clientes_act   CLIENT
	left join	[BancaEmpresas].[dbo].[normalizacion]	norm
	ON			norm.rut_cli	=	CLIENT.rut_cli
	left join	dbo.gc_ejecutivosNew       ejecut
	on			CLIENT.rut_ejc = ejecut.rut_ejec  
	left join	dbo.gc_ejecutivosNew    Plataf
	on			ejecut.rut_jefe   = Plataf.rut_ejec  
	ORDER BY 
				ejecut.rut_jefe  ASC
				,ejecut.rut_ejec  asc
				,CLIENT.rut_cli   asc
				
	;					
END


GO
