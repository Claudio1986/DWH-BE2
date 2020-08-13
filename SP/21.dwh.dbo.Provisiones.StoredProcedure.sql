USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[ClientesNuevosMes]    Script Date: 09/04/2018 18:25:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[Provisiones]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[Provisiones]
END
GO
CREATE PROCEDURE [dbo].[Provisiones] @Mes Varchar(8)
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-04-10>
-- Description:	<Provisiones por Mes>
-- =============================================
--exec  [dbo].[Provisiones] '201802'
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	declare @Fecha VARCHAR(10)
	set @Fecha = CONVERT(VARCHAR(10),EOMONTH(@Mes+'01'),112)

	--SELECT 	@Fecha

	SET NOCOUNT ON;

	SELECT	[fecha]
			,[rut_cli]
			,[dv_cli]
			,[nombre]
			,[CSbif]
			,[NRO_OPE]
			,[T_TOTAL_CARTERA]
			,[T_TOTAL_PROVISION]
			,[PRODUCTO]
			,[PRODUCTO_AGRUPADO]
	FROM	[BancaEmpresas].[dbo].[provisiones]
	WHERE	FECHA = @Fecha;

END
