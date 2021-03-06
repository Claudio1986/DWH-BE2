USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[REPORTEFUGA]    Script Date: 22/03/2018 11:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2017-11-09>
-- Description:	<REPORTE FUGA>
-- =============================================
--[dbo].[REPORTEFUGA] NULL,NULL,'G.G.E.E.1'
ALTER PROCEDURE [dbo].[REPORTEFUGA] @fecha varchar(8), @subtipo	varchar(30), @plataforma varchar(30),@rut_ejec int
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	DECLARE @fechaMin1		int

	SET		LANGUAGE Spanish;
	set		@fechaMin1		=	convert(varchar(10),EOMONTH(dateadd(month,-14,dateadd(day,1,getdate()))),112)

		select	
					wkfu.rut_cli	RutCli
					,cliente		Cliente
					,fecha			Fecha
					,subtipo		Subtipo
					,plataforma		Plataforma
					,rut_ejec		RutEjec
					,Nombre_Ejc		Ejecutivo
					,cate.categoria
					,cate.decision
					,cate.tipo
		from		dwh_stg.dbo.wrk_rep_fugados	wkfu		 
		LEFT JOIN 
		(		
			select		
						clie.rut_cli
						,catfug.categoria	
						,catfug.decision	
						,catfug.tipo
			from		[dbo].[clientes_fugados]	clifug
			LEFT JOIN 	[dbo].[clientes]	clie
			ON			clifug.id_cliente	=	clie.id
			LEFT JOIN 	[dbo].[categorias_fuga]	 	catfug
			ON			clifug.id_categoria_fuga=	catfug.id
			WHERE		clifug.fec_hasta		=	29991231		
		)cate
		ON		wkfu.rut_cli	=	cate.rut_cli
		WHERE		fecha	>=	@fechaMin1		
		AND		(	fecha		=	@fecha		OR	@fecha		IS NULL)
		AND		(	subtipo		=	@subtipo	OR	@subtipo	IS NULL)	
		AND		(	plataforma	=	@plataforma	OR 	@plataforma	IS NULL)
		AND		(	rut_ejec	=	@rut_ejec	OR 	@rut_ejec	IS NULL)
		AND		plataforma NOT IN ('ESTRUCTURADOS','INMOBILIARIA','NORMALIZACION'
				,'PLATAFORMA EMPRESAS')
		order by	
					Fecha
					,Plataforma
					,wkfu.rut_cli
					,case
					when	subtipo = 'Fugado'	then	2
					when	subtipo = 'Nuevo_Recup'	then	1
					when	subtipo = 'Perdido'	then	3
					when	subtipo = 'Total'	then	4
					end

END


