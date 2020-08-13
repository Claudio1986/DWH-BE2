USE [DWH]
GO

/****** Object:  StoredProcedure [dbo].[REP_STOCK_COLOCACIONES_DET]    Script Date: 31/10/2018 17:48:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[REP_STOCK_COLOCACIONES_DET] --@Mes varchar(6)
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<REPORTE DETALLE STOCK COLOCACIONES>
-- =============================================
--[dbo].[REP_STOCK_COLOCACIONES_DET] 
AS
BEGIN
	declare @año			int
	declare @UltMaes		int
	declare @MesAnt			int
	declare @ProxMes		int
	declare @hoy			int
	declare @ayer			int
	declare @denominacion	int=1--1000000

	select	
			@ProxMes	=	convert(varchar(10),dateadd(month,1,EOMONTH(getdate())),112) 
			,@MesAnt	=	convert(varchar(10),dateadd(month,-1,EOMONTH(getdate())),112) 
			,@año		=	convert(varchar(10),dateadd(day,-1,convert(varchar(4),year(getdate()))+'0101'),112) 
			,@hoy		=	convert(varchar(10),getdate()-1,112)
			,@ayer		=	convert(varchar(10),getdate()-2,112)
			,@UltMaes	=	max(fecha)
	FROM	dwh.dbo.maestro_cli


	--select	
	--		@año		año
	--		,@UltMaes	ultmaes
	--		,@MesAnt	mesant	
	--		,@ProxMes	proxmes
	--		,@hoy		hoy
	--		,@ayer		ayer

	delete from	dwh_stg.dbo.wrk_rep_proceso_stock_det;

--CARGA DE STOCK COMERCIAL VS AÑO PASADO	
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@año				fecha
				,'Comercial'	as	Tipo
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)	-	ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)	-	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)	-	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)	-	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)		-	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)		-	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as Stock
				,
				--sum
				(
						ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0))
					+	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0))
					+	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0))
					+	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0))
					+	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as INICIOAÑO
				,cast(0 as float)								CurseAbonoAño
				,cast(0 as float)								InteresMes
				,cast(0 as float)								COFMes
				,cast(0 as float)								SpreadMes
				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	--INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id
	ANd			cred.nro_operacion >= 6150000000
	ANd			cred.nro_operacion not between 6150000000 and 6160000000
	and			cred.nro_operacion not between 6230000000 and 6240000000
	and			cred.nro_operacion not between 6310000000 and 6320000000
	and			cred.nro_operacion not between 410000 and 411000
	AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@año		=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@año		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and isnull(deta3.nro_operacion,cred.nro_operacion) is not null;
	
--CARGA DE STOCK COMERCIAL VS MES PASADO
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@MesAnt				
				fecha
				,'Comercial'	as	Tipo
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)-ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)-ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)-ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)-ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)-ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as																			Stock
				,
				--sum
				(
						ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as																			InicioMes
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
				) as																			CurseAbonoMes			
				,cast(0 as float)								InteresMes
				,cast(0 as float)								COFMes
				,cast(0 as float)								SpreadMes
				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	--INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id
	ANd			cred.nro_operacion >= 6150000000
	ANd			cred.nro_operacion not between 6150000000 and 6160000000
	and			cred.nro_operacion not between 6230000000 and 6240000000
	and			cred.nro_operacion not between 6310000000 and 6320000000
	and			cred.nro_operacion not between 410000 and 411000
	AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@MesAnt	=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@MesAnt		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and			isnull(deta3.nro_operacion,cred.nro_operacion) is not null;

--CARGA DE STOCK E INTERESES COMERCIAL VS DIA PASADO
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@hoy	fecha
				,'Comercial' as Tipo
				,
				sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)-ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)-ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)-ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)-ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)-ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as											Stock
				,cast(0 as float)								InicioDia
				,
				sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_ml,0) 
				) as											CurseAbonoDia 
				,
				sum
				(
						isnULL(convert(float,deta.INTERES_VIGENTE_ML),0)  - isnULL(convert(float,deta2.INTERES_VIGENTE_ML),isnULL(convert(float,deta3.INTERES_VIGENTE_ML),0))
						+isnULL(convert(float,deta.INTERES_VENCIDO_ML),0) - isnULL(convert(float,deta2.INTERES_VENCIDO_ML),isnULL(convert(float,deta3.INTERES_VENCIDO_ML),0))
						+isnULL(convert(float,deta.INTERES_SUSPENDIDO),0) - isnULL(convert(float,deta2.INTERES_SUSPENDIDO),isnULL(convert(float,deta3.INTERES_SUSPENDIDO),0))
				) as											Intereses_D_Monto 
									
				,
				SUM
				(
						isnull(deta.COF_Monto,0)-ISNULL(deta2.COF_Monto,0) 
				) as											COF_D_Monto 
				,
				SUM
				(
						isnull(deta.SPREAD_Monto,0)-ISNULL(deta2.SPREAD_Monto,0) 
				) as											SPREAD_D_Monto 

				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	--INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id
	ANd			cred.nro_operacion >= 6150000000
	ANd			cred.nro_operacion not between 6150000000 and 6160000000
	and			cred.nro_operacion not between 6230000000 and 6240000000
	and			cred.nro_operacion not between 6310000000 and 6320000000
	and			cred.nro_operacion not between 410000 and 411000
	--AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta			
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@ayer		=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@ayer		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and			isnull(deta3.nro_operacion,cred.nro_operacion) is not null
	GROUP BY 
				clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal;

--CARGA DE STOCK COMEX VS AÑO PASADO
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@año				fecha
				,'Comex'	as	Tipo
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)	-	ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)	-	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)	-	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)	-	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)		-	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)		-	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as Stock
				,
				--sum
				(
						ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0))
					+	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0))
					+	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0))
					+	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0))
					+	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as INICIOAÑO
				,cast(0 as float)								CurseAbonoAño
				,cast(0 as float)								InteresMes
				,cast(0 as float)								COFMes
				,cast(0 as float)								SpreadMes
				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.Cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id
	
	ANd			cred.nro_operacion >= 6150000000		
	and			(nro_operacion between 6150000000 and 6160000000
	or			nro_operacion between 6230000000 and 6240000000
	or			nro_operacion between 6310000000 and 6320000000
	or			nro_operacion between 410000 and 411000)
	AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@año		=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@año		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and			isnull(deta3.nro_operacion,cred.nro_operacion) is not null;
	
--CARGA DE STOCK COMEX VS MES PASADO
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@MesAnt				fecha
				,'Comex'	as	Tipo
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)-ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)-ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)-ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)-ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)-ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as																			Stock
				,
				--sum
				(
						ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as																			InicioMes
				,
				--sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
				) as																			CurseAbonoMes			
				,cast(0 as float)								InteresMes
				,cast(0 as float)								COFMes
				,cast(0 as float)								SpreadMes
				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.Cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id

	ANd			cred.nro_operacion >= 6150000000		
	and			(nro_operacion between 6150000000 and 6160000000
	or			nro_operacion between 6230000000 and 6240000000
	or			nro_operacion between 6310000000 and 6320000000
	or			nro_operacion between 410000 and 411000)
	AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@MesAnt	=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@MesAnt		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and			isnull(deta3.nro_operacion,cred.nro_operacion) is not null;
	
--CARGA DE STOCK E INTERESES COMEX VS DIA PASADO
	INSERT INTO dwh_stg.dbo.wrk_rep_proceso_stock_det
	select 
				@hoy	fecha
				,'Comex' as Tipo
				,
				sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_mo,ISNULL(deta3.capital_vigente_ml,0)) 
					+	isnull(deta.capital_vencido_ml,0)-ISNULL(deta2.capital_vencido_mo,ISNULL(deta3.capital_vencido_ml,0)) 
					+	isnull(deta.interes_vigente_ml,0)-ISNULL(deta2.interes_vigente_mo,ISNULL(deta3.interes_vigente_ml,0)) 
					+	isnull(deta.interes_vencido_ml,0)-ISNULL(deta2.interes_vencido_mo,ISNULL(deta3.interes_vencido_ml,0)) 
					+	isnull(deta.reajuste_vigente,0)-ISNULL(deta2.reajuste_vigente,ISNULL(deta3.reajuste_vigente,0))	 
					+	isnull(deta.reajuste_vencido,0)-ISNULL(deta2.reajuste_vencido,ISNULL(deta3.reajuste_vencido,0))	 
				) as																			Stock
				,cast(0 as float)								InicioDia
				,
				sum
				(
						isnull(deta.capital_vigente_ml,0)-ISNULL(deta2.capital_vigente_ml,0) 
				) as											CurseAbonoDia 

				,
				sum
				(
						isnULL(convert(float,deta.INTERES_VIGENTE_ML),0)  - isnULL(convert(float,deta2.INTERES_VIGENTE_ML),isnULL(convert(float,deta3.INTERES_VIGENTE_ML),0))
						+isnULL(convert(float,deta.INTERES_VENCIDO_ML),0) - isnULL(convert(float,deta2.INTERES_VENCIDO_ML),isnULL(convert(float,deta3.INTERES_VENCIDO_ML),0))
						+isnULL(convert(float,deta.INTERES_SUSPENDIDO),0) - isnULL(convert(float,deta2.INTERES_SUSPENDIDO),isnULL(convert(float,deta3.INTERES_SUSPENDIDO),0))
				) as											Intereses_D_Monto 

				,
				SUM
				(
						isnull(deta.COF_Monto,0)-ISNULL(deta2.COF_Monto,0) 
				) as											COF_D_Monto 
				,
				SUM
				(
						isnull(deta.SPREAD_Monto,0)-ISNULL(deta2.SPREAD_Monto,0) 
				) as											SPREAD_D_Monto 

				,clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)	nro_operacion
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal
	from		dwh.[dbo].[VW_CliAct]				clie2
	LEFT JOIN	dwh.[dbo].[clientes]				clie
	ON			clie.id		=	clie2.id_cliente
	AND			clie2.fecha =	@UltMaes
	LEFT JOIN	dwh.[dbo].[credito_cart]			cred
	ON			cred.id_cliente =	clie.id

	ANd			cred.nro_operacion >= 6150000000
	and			(nro_operacion between 6150000000 and 6160000000
	or			nro_operacion between 6230000000 and 6240000000
	or			nro_operacion between 6310000000 and 6320000000
	or			nro_operacion between 410000 and 411000)
	--AND			cred.fec_hasta	=	29991231
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta			
	ON			cred.id		=	deta.id_credito
	AND			(@hoy		=	deta.fecha)
	LEFT JOIN	dwh.[dbo].[credito_cart_detalle]	deta2
	ON			cred.id		=	deta2.id_credito
	AND			(@ayer		=	deta2.fecha)

	LEFT JOIN	bancaempresas.[dbo].cre_cartera		deta3
	ON			clie.rut_cli=	deta3.rut_cli
	AND			(@ayer		=	convert(varchar(10),deta3.fecha,112))
	AND			cred.nro_operacion	=	deta3.nro_operacion

	WHERE		clie2.fecha =	@UltMaes
	and			clie2.tipo_cliente = 1
	and			isnull(deta3.nro_operacion,cred.nro_operacion) is not null
	GROUP BY 
				clie2.rut_ejec
				,clie2.rut_cli
				,isnull(deta3.nro_operacion,cred.nro_operacion)
				,clie2.cliente
				,clie2.Ejecutivo
				,clie2.rut_jefe
				,clie2.jefe
				,clie2.Plataforma
				,clie2.Canal;	
	;	


--CARGA DE STOCK RESUMEN
	delete from DWH_STG.dbo.wrk_rep_stock_det;

	INSERT INTO DWH_STG.dbo.wrk_rep_stock_det	
	(fecha,Tipo,Intereses_D_$,COF_D_$,SPREAD_D_$,Curses_Abonos_D_M$,Cartera_Neta_D_M$,Curses_Abonos_M_M$,
	Cartera_Neta_M_M$,Cierre_Mes_Anterior_M$,Stock_Mes_Actual_M$,rut_ejec,rut_cli,nro_operacion,Cliente,Ejecutivo
	,rut_jefe,jefe,Plataforma,Canal)
	SELECT 
		fecha
		,Tipo
		,[Intereses_D_$]							[Intereses_D_$]
		,[COF_D_$] 									[COF_D_$]
		,[SPREAD_D_$]								[SPREAD_D_$]
		,cast(Curses_Abonos_D_M$		/convert(float,@denominacion)	AS decimal(18,0))  Curses_Abonos_D_M$
		,cast(Cartera_Neta_D_M$			/convert(float,@denominacion)	AS decimal(18,0))  Cartera_Neta_D_M$
		,cast(Curses_Abonos_M_M$		/convert(float,@denominacion)	AS decimal(18,0))  Curses_Abonos_M_M$
		,cast(Cartera_Neta_M_M$			/convert(float,@denominacion)	AS decimal(18,0))  Cartera_Neta_M_M$
		,cast(Cierre_Mes_Anterior_M$	/convert(float,@denominacion)	AS decimal(18,0))  Cierre_Mes_Anterior_M$
		,cast(Stock_Mes_Actual_M$		/convert(float,@denominacion)	AS decimal(18,0))  Stock_Mes_Actual_M$
		,rut_ejec
		,rut_cli
		,nro_operacion
		,Cliente
		,Ejecutivo
		,rut_jefe
		,jefe
		,Plataforma
		,Canal
	--INTO DWH_STG.dbo.wrk_rep_stock_det	
	FROM 
	(
		SELECT 
					AÑO.fecha
					,AÑO.Tipo
					,DIA.Intereses_D_Monto									[Intereses_D_$]
					,DIA.COF_D_Monto 										[COF_D_$]
					,DIA.SPREAD_D_Monto										[SPREAD_D_$]
					,ISNULL(Dia.CurseAbonoPeriodo,0)						Curses_Abonos_D_M$
					,ISNULL(Dia.Stock,0)									Cartera_Neta_D_M$
					,ISNULL(Mes.CurseAbonoPeriodo,0)						Curses_Abonos_M_M$ 
					,ISNULL(Mes.Stock,0)									Cartera_Neta_M_M$
					,ISNULL((Mes.InicioPeriodo	-	año.INICIOPeriodo),0)	Cierre_Mes_Anterior_M$
					,ISNULL(AÑO.Stock,0)									Stock_Mes_Actual_M$
					--,META.valor							Meta
					,AÑO.rut_ejec
					,AÑO.rut_cli
					,AÑO.nro_operacion
					,AÑO.Cliente
					,AÑO.Ejecutivo
					,AÑO.rut_jefe
					,AÑO.jefe
					,AÑO.Plataforma
					,AÑO.Canal
		FROM		dwh_stg.dbo.wrk_rep_proceso_stock_det	 AÑO
		LEFT JOIN	dwh_stg.dbo.wrk_rep_proceso_stock_det	MES
		ON			Mes.Fecha = @MesAnt
		AND			MES.rut_ejec = AÑO.rut_ejec
		AND			MES.plataforma = AÑO.plataforma
		AND			MES.rut_cli = AÑO.rut_cli
		AND			MES.nro_operacion = AÑO.nro_operacion
		left join	dwh_stg.dbo.wrk_rep_proceso_stock_det	DIA
		ON			DIA.Fecha = @hoy
		AND			DIA.rut_ejec = AÑO.rut_ejec
		AND			DIA.plataforma = AÑO.plataforma
		AND			DIA.rut_cli = AÑO.rut_cli
		AND			DIA.nro_operacion = AÑO.nro_operacion
		WHERE		@año	=	año.fecha
   )A

END
GO


