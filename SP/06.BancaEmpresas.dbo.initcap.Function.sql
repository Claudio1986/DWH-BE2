USE [BancaEmpresas]
GO

/****** Object:  UserDefinedFunction [dbo].[INITCAP]    Script Date: 06/11/2018 13:36:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[INITCAP](@par varchar(8000))
returns varchar(8000)
as
begin
declare @counter as int
declare @lastchar as varchar(1)
declare @point as varchar(1)

set @counter=1
set @lastchar=' '
set @point='.'

while @counter <= len(@par)
begin
if @lastchar=' ' or @point='.' 
begin
set @par= STUFF(@par, @counter, 1, upper(substring(@par,@counter,1)))
set @lastchar=substring(@par,@counter,1)
set @point=substring(@par,@counter,1)
set @counter=@counter+1
end
else
begin
select @par= STUFF(@par, @counter, 1, lower(substring(@par,@counter,1)))
set @lastchar=substring(@par,@counter,1)
set @point=substring(@par,@counter,1)
set @counter=@counter+1
end

end
return @par
end

GO


