USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_FUGA_WRK_DESACT]    Script Date: 22/02/2018 19:57:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-01-23>
-- Description:	<Rep Visitas Ejecutivo>
-- =============================================
--[REP_FUGA_WRK_DESACT]	20180101,20180101
ALTER PROCEDURE [dbo].[REP_FUGA_WRK_DESACT] 
	@fechai int
	, @fechaf int
AS
BEGIN

	SET NOCOUNT ON;		 

		TRUNCATE table DWH_STG.DBO.wrk_fuga_tabla_desactivados
		
		INSERT INTO  DWH_STG.dbo.wrk_fuga_tabla_desactivados
		(
			id_cliente		,
			Desactivacion	
		)
		SELECT 
				id_cliente
				,Desactivacion		
		FROM 
		(	select	
					id_cliente
					,Desactivacion
			from	
			(
				select
						id_cliente
					  , sum(activo) as Desactivacion
				from	DWH.dbo.maestro_cli
				where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
							  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-3,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
				and 	activo     = 1
				and 	movimiento = 0
				group by
						id_cliente
			)
			as A
			where	Desactivacion = 4
		
			union all
			
			select	
					id_cliente
					,Desactivacion
			from
			(
				select
						id_cliente
					  , sum(activo) as Desactivacion
				from
						DWH.dbo.maestro_cli
				where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
							  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
				and 	activo     = 1
				and 	movimiento = 0
				and 	id_cliente not in
				(
					select 
							distinct
							id_cliente
					from
					(
						select
								id_cliente
								, sum(activo) as Des1Mes
						from
								DWH.dbo.maestro_cli
						where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
							  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-3,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
						and 	activo     = 1
						and 	movimiento = 0
						group by	id_cliente
					)
					as A
					where	Des1mes = 4
				)
				group by
						id_cliente
			)
			as A
			where	Desactivacion = 3
			
			union all
			
			select 
					id_cliente
					,Desactivacion
			from
			(
				select
						id_cliente
					  , sum(activo) as Desactivacion
				from
						DWH.dbo.maestro_cli
				where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
					  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
				and 	activo     = 1
				and 	movimiento = 0
				and 	id_cliente not in
				(
			   
					select distinct
						  id_cliente
					from
					(
						select
								id_cliente
							  , sum(activo) as Des1Mes
						from	DWH.dbo.maestro_cli
						where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
							  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-3,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
						and 	activo     = 1
						and 	movimiento = 0
						group by
								id_cliente
					)
					as A
					where
						  Des1mes = 4
			
					union all
			
					select distinct
						  id_cliente
					from
					(
						select
								id_cliente
							  , sum(activo) as Desactivacion
						from	DWH.dbo.maestro_cli
						where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
							  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
							  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
						and 	activo     = 1
						and 	movimiento = 0
						and 	id_cliente not in
						(
							select distinct
								  id_cliente
							from
							(
								select
										id_cliente
									  , sum(activo) as Des1Mes
								from
										DWH.dbo.maestro_cli
								where	CONVERT(VARCHAR(10),Fecha,112) in (CONVERT(VARCHAR(10),@fechaf,112)
											  , dateadd(d,-1,dateadd(m,-1,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
											  , dateadd(d,-1,dateadd(m,-2,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112))))
											  , dateadd(d,-1,dateadd(m,-3,dateadd(d,1,CONVERT(VARCHAR(10),@fechaf,112)))))
								and 	activo     = 1
								and 	movimiento = 0
								group by
										id_cliente
							)
							as A
							where
								  Des1mes = 4
								)
						group by
								id_cliente
					)
					as A
					where
						  Desactivacion = 3
						)
				group by
						id_cliente
			)
			as A
			where
				  Desactivacion = 2
		)W
END
GO
