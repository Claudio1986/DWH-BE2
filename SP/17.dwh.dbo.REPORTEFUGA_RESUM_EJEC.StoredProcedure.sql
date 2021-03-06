USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REPORTEFUGA_RESUM_EJEC]    Script Date: 22/03/2018 14:38:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<REPORTE FUGA>
-- =============================================
--[dbo].[REPORTEFUGA_RESUM_EJEC] 'C&I',NULL, NULL, NULL, 20180228
ALTER PROCEDURE [dbo].[REPORTEFUGA_RESUM_EJEC] @Canal varchar(30), @Plataforma Varchar(30), @rut_ejec int , @subtipo Varchar(30), @Fecha int
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	DECLARE @SQLString		nvarchar(max),
			@ParmDefinition nvarchar(500) ,
			@fechaMinM1		int,
			@fechaMin		int,
			@fechaMin1		int,
			@fechaMax		int,
			@Meses			nVARCHAR(MAX),
			@MesesTexto		nVARCHAR(MAX),
			@stmt			nvarchar(max)

	SET		LANGUAGE Spanish;
	set		@fechaMinM1		=	convert(varchar(10),EOMONTH(dateadd(month,-12,dateadd(day,1,getdate()))),112)
	set		@fechaMin		=	convert(varchar(10),EOMONTH(dateadd(month,-13,dateadd(day,1,getdate()))),112)
	set		@fechaMin1		=	convert(varchar(10),EOMONTH(dateadd(month,-14,dateadd(day,1,getdate()))),112)
	set		@fechaMax		=	convert(varchar(10),EOMONTH(dateadd(month,-1,dateadd(day,1,getdate()))),112)

		select	
				@MesesTexto	=	
				COALESCE(@MesesTexto  + ', ', '') + 'ISNULL(['+CONVERT(varchar(10),FECHA,112)+ '],0) '''
				+
				--DATENAME(MONTH, FECHA)+' '+DATENAME(YEAR, FECHA)
				'ID'+convert(varchar(2),ROW_NUMBER() OVER(ORDER BY FECHA ASC),112)
				+''' '
				,
				@Meses	=	COALESCE(@Meses  + ', ', '') + + '['+CONVERT(varchar(10),FECHA,112)+ '] '
		FROM	DWH.DBO.maestro_cli	maes
		WHERE	FECHA BETWEEN @fechaMinM1	AND	@fechaMax

		GROUP BY FECHA
		ORDER BY FECHA asc


		SELECT @stmt = '
				SELECT 	canal,
						plataforma,
						rut_ejec
						,Nombre_Ejc
						,subtipo,
						'+@MesesTexto +'
				FROM	
				(
					select	
								count(rut_cli)*valor		valor
								,fecha
								,rut_ejec
								,Nombre_Ejc
								,subtipo
								,case
								when	subtipo = ''Fugado''	then	2
								when	subtipo = ''Nuevo_Recup''	then	1
								when	subtipo = ''Perdido''	then	3
								when	subtipo = ''Activo''	then	4
								end			orden
								,plataforma
								,canal
					from		dwh_stg.dbo.wrk_rep_fugados
					WHERE		fecha	>=	@fechaMin1
					AND		(	@Fecha	=	fecha	OR 	@Fecha IS NULL)
					group by	
								fecha
								,rut_ejec
								,Nombre_Ejc
								,subtipo
								,valor
								,plataforma
								,canal
								,case
								when	subtipo = ''Fugado''	then	2
								when	subtipo = ''Nuevo_Recup''	then	1
								when	subtipo = ''Perdido''	then	3
								when	subtipo = ''Activo''	then	4
								end
				)
				as T
				PIVOT 
				(
					MAX(valor)
					FOR Fecha IN (' + @Meses + ')
				) as P 
				WHERE plataforma NOT IN (''ESTRUCTURADOS'',''INMOBILIARIA'',''NORMALIZACION''
				,''PLATAFORMA EMPRESAS'')
				AND	(	@Plataforma	=	Plataforma	OR 	@Plataforma IS NULL)
				AND	(	@subtipo	=	subtipo		OR 	@subtipo IS NULL)
				AND	(	@rut_ejec	=	rut_ejec	OR 	@rut_ejec IS NULL)
				AND	(	@Canal	=	canal	OR 	@Canal IS NULL)
				order by plataforma,orden
				'


		SET @ParmDefinition = 
				N'
				@fechaMin1		int  
				,@Plataforma	varchar(30)  
				,@subtipo		varchar(30)
				,@rut_ejec		int
				,@Canal		varchar(30)
				,@Fecha			int';  ;  


		EXEC sp_executesql  @stmt = @stmt, @ParmDefinition = @ParmDefinition,  
							  @fechaMin1 = @fechaMin1
							  ,@Plataforma =	@Plataforma
							  ,@subtipo	=	@subtipo
							  ,@rut_ejec=	@rut_ejec
							  ,@Canal=	@Canal
							  ,@Fecha=	@Fecha;

END


