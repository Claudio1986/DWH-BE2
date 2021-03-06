USE [BancaEmpresas]
GO
/****** Object:  StoredProcedure [dbo].[ProcesaFactoring]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[ProcesaFactoring] '201801'
ALTER PROCEDURE [dbo].[ProcesaFactoring] @Mes varchar(6)
AS
BEGIN
	
	--declare @Mes varchar(6) = '201801'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @fecha datetime;

	SET @fecha = DATEADD (dd,-1,DATEADD (mm , 1 , cast(@Mes+'01' as DATETIME) ) ) ;


	--INSERT 	  bancaempresas.dbo.GC_CLIENTES
	--(rut_cli, dv_cli, nombre, centro_decision, rut_ejec, tipo_cliente)
	--SELECT
	--				CASE
	--					WHEN bols.rut_cli is NOT null OR tifa.nro_operacion IS NOT NULL
	--						THEN	fact.rut_deudor
	--					ELSE	fact.rut_cli 
	--				END						AS	rut_cli
	--				,0
	--				,'cliente factoring'
	--				,CASE
	--					WHEN bols.rut_cli is NOT null OR tifa.nro_operacion IS NOT NULL
	--						THEN	fact.rut_deudor
	--					ELSE	fact.rut_cli 
	--				END
	--				,0
	--				,3	
	--FROM		[BancaEmpresas].[dbo].[temp_fact_cartera] fact
	--LEFT JOIN	bancaempresas.dbo.fact_tipo			tifa
	--ON			fact.nro_operacion	=	tifa.nro_operacion
	--AND			id_tipo_fact		=	4		--confirming tabla [dbo].[tipo_factoring]
	--LEFT JOIN	bancaempresas.dbo.gc_bolsa			bols
	--ON			fact.rut_cli		=	bols.rut_bolsa
	--AND			fact.rut_deudor		=	bols.rut_cli
	--LEFT JOIN	bancaempresas.dbo.GC_CLIENTES CLIE
	--on			CASE
	--					WHEN bols.rut_cli is NOT null OR tifa.nro_operacion IS NOT NULL
	--						THEN	fact.rut_deudor
	--					ELSE	fact.rut_cli 
	--			END				=	CLIE.RUT_CLI  
	--WHERE		fact.fecha			=	@fecha
	--AND			CLIE.RUT_CLI	is null
	--group by 					   
	--				CASE
	--					WHEN bols.rut_cli is NOT null OR tifa.nro_operacion IS NOT NULL
	--						THEN	fact.rut_deudor
	--					ELSE	fact.rut_cli 
	--				END;

	DELETE 
	from		[BancaEmpresas].[dbo].[fact_cartera]
	WHERE		fecha			=	@fecha;

	INSERT INTO [BancaEmpresas].[dbo].[fact_cartera]
	SELECT
				fact.[fecha]
				,fact.[rut_deudor]
				,fact.[rut_cli]			AS	rut_cli_ori
				,CASE
					WHEN bols.rut_cli is NOT null OR tifa.nro_operacion IS NOT NULL
						THEN	fact.rut_deudor
					ELSE	fact.rut_cli 
				END						AS	rut_cli
				,CASE
					WHEN tifa.nro_operacion IS NOT NULL
						THEN	1
					WHEN bols.rut_cli is NOT null 
						THEN	2
					ELSE	0
				END
				,fact.[nro_operacion]
				,fact.[fecha_op]
				,fact.[garantia_op]
				,fact.[nro_doc]
				,fact.[tipo_doc]
				,fact.[fecha_vencimiento]
				,fact.[valor_nominal_doc]
				,fact.[diferencia_precio_no_financiado]
				,fact.[diferencia_precio_favor_factor]
				,fact.[abonos]
				,fact.[valor_actual_neto]
				,fact.[tasa_desc]
				,fact.[renegociacion]
				,fact.[responsabilidad]
				,fact.[verificacion_del_doc]
				,fact.[notificacion_del_deudor]
				,fact.[moneda]
	FROM		[BancaEmpresas].[dbo].[temp_fact_cartera] fact
	LEFT JOIN	dbo.fact_tipo			tifa
	ON			fact.nro_operacion	=	tifa.nro_operacion
	AND			id_tipo_fact		=	4		--confirming tabla [dbo].[tipo_factoring]
	LEFT JOIN	dbo.gc_bolsa			bols
	ON			fact.rut_cli		=	bols.rut_bolsa
	AND			fact.rut_deudor		=	bols.rut_cli
	WHERE		fact.fecha			=	@fecha

END

GO
