USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[IndiceRiesgoCli]    Script Date: 09/04/2018 18:25:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[IndiceRiesgoCli]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[IndiceRiesgoCli]
END
GO
CREATE PROCEDURE [dbo].[IndiceRiesgoCli] @Mes Varchar(8)
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-04-10>
-- Description:	<Indice Riesgo por Cliente por Mes>
-- =============================================
--exec  [dbo].[IndiceRiesgoCli] '201802'
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	declare @Fecha VARCHAR(10)
	set @Fecha = CONVERT(VARCHAR(10),EOMONTH(@Mes+'01'),112)

	--SELECT 	@Fecha

	SET NOCOUNT ON;

	SELECT 
				[rut_cli]
				,[CSbif]
				,ROUND(
				CASE 
				WHEN ISNULL(SUM([T_TOTAL_CARTERA]),0) = 0
					THEN 0
					ELSE SUM([T_TOTAL_PROVISION])/SUM([T_TOTAL_CARTERA])*100
				END,2)						IndiceRiesgo
	FROM		[BancaEmpresas].[dbo].[provisiones]
	WHERE		FECHA = @Fecha
	GROUP BY 	[rut_cli]
				,[CSbif];

END
