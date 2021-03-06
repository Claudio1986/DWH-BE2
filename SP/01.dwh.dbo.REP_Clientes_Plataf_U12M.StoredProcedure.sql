USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_Clientes_Plataf_U12M]    Script Date: 22/02/2018 19:57:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-01-23>
-- Description:	<Rep Visitas Ejecutivo>
-- =============================================
-- exec [dbo].[REP_Clientes_Plataf_U12M]
ALTER PROCEDURE [dbo].[REP_Clientes_Plataf_U12M] --@Mes varchar(6)
AS
BEGIN
	
	DECLARE @SQLString		nvarchar(max),
			@ParmDefinition nvarchar(500) ,
			@fechaMin		int,
			@fechaMax		int,
			@Meses			nVARCHAR(MAX),
			@MesesTexto		nVARCHAR(MAX),
			@stmt			nvarchar(max)

	SET		LANGUAGE Spanish;
	set		@fechaMin		=	convert(varchar(10),EOMONTH(dateadd(month,-12,dateadd(day,1,getdate()))),112)
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
		WHERE	FECHA BETWEEN @fechaMin	AND	@fechaMax
		GROUP BY FECHA
		ORDER BY FECHA asc

		SELECT @stmt = '
				SELECT 
						plataforma	Plataforma,

						'+@MesesTexto +'
				FROM	
				(
					SELECT		
								PLATAF.descripcion				plataforma
								,count(clie.rut_cli)			clientes
								,Fecha
					FROM		DWH.DBO.maestro_cli	maes

					LEFT JOIN	DWH.DBO.CLIENTES	clie
					ON			clie.id			=	maes.id_cliente
					AND			convert(varchar(10),getdate(),112)	BETWEEN clie.fec_desde		AND	clie.fec_hasta

					LEFT JOIN 	[DWH].[dbo].[asignacion_clientes]	ascl
					ON			CLIE.id		=	ascl.id_cliente
					AND			convert(varchar(10),getdate(),112)	BETWEEN ascl.fec_desde		AND	ascl.fec_hasta

					LEFT JOIN 	[DWH].[dbo].[ejecutivos]	EJECUT
					ON			ascl.id_ejecutivo		=	EJECUT.id		
					AND			convert(varchar(10),getdate(),112)	BETWEEN EJECUT.fec_desde	AND	EJECUT.fec_hasta

					LEFT JOIN 	[DWH].[dbo].[jerarquia_ejecutivos]	jera
					ON			jera.id_ejecutivo		=	EJECUT.id
					AND			convert(varchar(10),getdate(),112)	BETWEEN jera.fec_desde		AND	clie.fec_hasta

					LEFT JOIN 	[DWH].[dbo].[ejecutivos]	JEFE
					ON			jera.id_jefe		=	JEFE.id
					AND			JEFE.id_plataforma	IS NOT NULL
					AND			convert(varchar(10),getdate(),112)	BETWEEN JEFE.fec_desde		AND	JEFE.fec_hasta

					LEFT JOIN 	[DWH].[dbo].[plataformas]	PLATAF
					ON			UPPER(CASE
								WHEN	JEFE.id_plataforma	IS NULL
								THEN	EJECUT.id_plataforma
								ELSE	JEFE.id_plataforma
								END)				=	PLATAF.id

					WHERE		Fecha	BETWEEN @fechaMin AND	@fechaMax
					AND			activo = 1
					AND			EJECUT.rut_ejec	<>	0

					GROUP BY	PLATAF.descripcion
								,Fecha
				)
				as T
				PIVOT 
				(
					MAX(clientes)
					FOR Fecha IN (' + @Meses + ')
				) as P '


		SET @ParmDefinition = 
				N'
				@fechaMin	int, 
				@fechaMax	int';  

		EXEC sp_executesql  @stmt = @stmt, @ParmDefinition = @ParmDefinition,  
							  @fechaMin = @fechaMin,  
							  @fechaMax = @fechaMax;
END
GO
