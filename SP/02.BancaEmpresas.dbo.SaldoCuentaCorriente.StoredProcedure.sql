USE [BancaEmpresas]
GO
/****** Object:  StoredProcedure [dbo].[SaldoCuentaCorriente]    Script Date: 05/03/2018 15:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[SaldoCuentaCorriente]
ALTER PROCEDURE [dbo].[SaldoCuentaCorriente] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select	d.plataforma
			, (case when a.Tipo = 'Otro' then c.rut_ejec else 0 end) as rut_ejc
			, (case when a.Tipo = 'Otro' then c.nombre else 'Relacionado' end) as Nombre_Ejc
			, sum(a.saldo) as Saldo, 
			sum(a.Saldoprom) as SProm   
	from                                                                                                                   
	(   select	
				a.cta_rut
				, Tipo
				, Saldo
				, SaldoProm                         
        from                                                                                                    
            (                                                                                                            
				select 	cta_rut
						, (case when cta_rut in (82878900, 96772490, 76246552, 79619200, 82878900) then 'RELACIONADO' else 'Otro' end) as Tipo
						, sum(cta_saldoreal)	as Saldo    
               	from 	dbo.SG_CTACTE                                                  
               	where 	cta_fechapro = (
										select 	max(cta_fechapro) 
										from 	dbo.SG_CTACTE
										)   
				group by cta_rut                                             
				) as A                                                                                                   
				left join                                                                                              
				(                                                                                                            
					select	cta_rut
							, sum(cta_saldoreal)/(                     
													  select 	count(distinct cta_fechapro) as Dias
													  from 		dbo.SGH_CTACTE                               
													  where 	cta_fechapro between 
													  (
														  select	dateadd(m,-1,dateadd(d,1-day(max(cta_fechapro)),max(cta_fechapro))) 
														  from 		dbo.SG_CTACTE
													  )
													  and    	(
																	select 
																			dateadd(d,1-day(max(cta_fechapro)),max(cta_fechapro)) 
																	from 	dbo.SG_CTACTE
																)
							) as SaldoProm
					from 	dbo.SGH_CTACTE                                               
					where 	cta_fechapro between                                 
											(
												select	dateadd(m,-1,dateadd(d,1-day( max(cta_fechapro)),max(cta_fechapro))) 
												from 	dbo.SG_CTACTE
											)
					and    (
							select 	dateadd(d,1-day(max(cta_fechapro)),max(cta_fechapro)) 
							from 	dbo.SG_CTACTE
							)
					and		cta_fechapro <> '20171114'		--día con problema
				group by cta_rut                                                            
			) as B
			on a.cta_rut = b.cta_rut                                              
	) as A                                                                                                                  
	INNER join  	dbo.gc_clientes		b
	on 			a.cta_rut = b.rut_cli
	left join 	dbo.gc_ejecutivos	c
	on			b.rut_ejec = c.rut_ejec                                                              
	left join   dbo.gc_ejecutivos	d
	on			c.rut_jefe = d.rut_ejec                                                         
	group by   d.plataforma, c.rut_ejec, c.nombre, a.tipo    

	
END


GO
