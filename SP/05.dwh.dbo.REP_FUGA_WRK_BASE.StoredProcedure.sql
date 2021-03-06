USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REP_FUGA_WRK_BASE]    Script Date: 22/03/2018 11:01:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('[dbo].[REP_FUGA_WRK_BASE]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[REP_FUGA_WRK_BASE] 
END
GO
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-01-23>
-- Description:	<Rep Visitas Ejecutivo>
-- =============================================
-- REP_FUGA_WRK_BASE
ALTER PROCEDURE [dbo].[REP_FUGA_WRK_BASE] 
AS
BEGIN

	SET NOCOUNT ON;		 

	DELETE FROM DWH_STG.DBO.WRK_REP_FUGADOS;

	declare @fecha1 varchar(10)
	declare @fecha datetime
	set		@fecha1 = convert(varchar(10),dateadd(year,-2,dateadd(d,1,(select convert(varchar(10),max(fecha),112) from dwh.dbo.VW_maestro_cli))),112)

	INSERT into	DWH_STG.DBO.WRK_REP_FUGADOS
	select		
				clie.canal
				, clie.plataforma		Plataforma
				, clie.rut_ejec
				, clie.Ejecutivo		Nombre_Ejc
				, clie.rut_cli
				, clie.Cliente			Cliente
				, A.fecha
				, A.tipo
				, A.desactivacion
				, A.subtipo
				, A.valor

	from           
	(
		   select
			   maac.fecha, maac.rut_cli, maac.tipo
			   , 'Activo' as subtipo
			   , 1 as Valor, 
				case 
				
					when 1000*maac.movimiento+100*isnull(mam1.movimiento,0)+10*isnull(mam2.movimiento,0)+isnull(mam3.movimiento,0) = 0 
						then 0 
					when 1000*maac.movimiento+100*isnull(mam1.movimiento,0)+10*isnull(mam2.movimiento,0)+isnull(mam3.movimiento,0) = 1 
						then 1 
					when 1000*maac.movimiento+100*isnull(mam1.movimiento,0)+10*isnull(mam2.movimiento,0)+isnull(mam3.movimiento,0) <= 10 
						then 2 
					when 1000*maac.movimiento+100*isnull(mam1.movimiento,0)+10*isnull(mam2.movimiento,0)+isnull(mam3.movimiento,0) <= 100 
						then 3 
					else 4 
				end	as Desactivacion
		   from
		   (
			   select	fecha, rut_cli, movimiento, 'Activo' as tipo
			   from		dwh.dbo.VW_maestro_cli
			   where	fecha >= @fecha1
			   and		activo = 1
		   ) as maac
		   left join	dwh.dbo.VW_maestro_cli as mam1
		   on			maac.rut_cli = mam1.rut_cli
		   and			mam1.fecha = convert(varchar(10),dateadd(d,-1,dateadd(m,-1,dateadd(d,1,convert(varchar(10),maac.fecha,112)))),112) 
		   left join	dwh.dbo.VW_maestro_cli as mam2
		   on			maac.rut_cli = mam2.rut_cli
		   and			mam2.fecha = convert(varchar(10),dateadd(d,-1,dateadd(m,-2,dateadd(d,1,convert(varchar(10),maac.fecha,112)))),112) 
		   left join	dwh.dbo.VW_maestro_cli as mam3
		   on			maac.rut_cli = mam3.rut_cli
		   and			mam3.fecha = convert(varchar(10),dateadd(d,-1,dateadd(m,-3,dateadd(d,1,convert(varchar(10),maac.fecha,112)))),112)

		   union all

		   select	mana.fecha, mana.rut_cli, 'Movimiento'
					, (case when c.rut_cli is null then 'Fugado' else 'Perdido' end) as Tipo, -1, 0 
		   from
		   (
					   select	fecha, rut_cli, activo
					   from		dwh.dbo.VW_maestro_cli
					   where	fecha >= @fecha1  
					   and		activo = 0
		   ) as mana				
		   inner join	(
						select 
								rut_cli, fecha
						from	dwh.dbo.VW_maestro_cli 
						where	activo = 1
		   ) as mam1
		   on			mana.rut_cli = mam1.rut_cli
		   and			mam1.fecha = convert(varchar(10),dateadd(d,-1,dateadd(m,-1,dateadd(d,1,convert(varchar(10),mana.fecha,112)))),112)
		   left join	
		   (
			  select	
						rut_cli
			  from		dwh.[dbo].[clientes_fugados]	clifug
			  LEFT JOIN	dwh.[dbo].[clientes]	  		clie
			  ON		clifug.id_cliente			=	clie.id	   
		   )c
		   on			mana.rut_cli = c.rut_cli

		   union all

		  select		maac.fecha, maac.rut_cli, 'Movimiento', 'Nuevo_Recup' as Tipo, 1, 0 
		   from
		   (
					select	fecha, rut_cli, activo
					from	dwh.dbo.VW_maestro_cli
					where	fecha >= @fecha1 
					and		activo = 1
		   ) as maac
		   left join (
					select	* 
					from	dwh.dbo.VW_maestro_cli 
					where	fecha >= convert(varchar(10),dateadd(d,-1,dateadd(m,-1,dateadd(d,1,convert(varchar(10),@fecha1,112)))),112) 
					and		activo = 1
		   ) as mam1
		   on           maac.rut_cli = mam1.rut_cli
		   and          isNULL(mam1.fecha,19010101) = convert(varchar(10),EOMONTH(dateadd(month,-1,convert(varchar(10),maac.fecha,112))),112)
		   where		mam1.rut_cli is null

	) as A      
	left join	dwh.dbo.VW_CliAct   clie
	on			A.rut_cli = clie.rut_cli
	AND			convert(varchar(10),A.fecha,112) = clie.FEcha
	where		( clie.canal <> 'LIBRE' or clie.canal = 'OTRO')

		

END			