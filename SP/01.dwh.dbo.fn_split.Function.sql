use DWH
Go
IF OBJECT_ID('[dbo].[fn_split]') IS NOT NULL
BEGIN
	drop  FUNCTION [dbo].[fn_split]
END
GO

ALTER FUNCTION [dbo].[fn_split](
-- =============================================
-- Author:		<Claudio Ruz Castro>
-- Create date: <2018-04-12>
-- Description:	<Funcion que divide un string>
-- =============================================
--usage: select * from fn_split('1,24,5',',')

@str VARCHAR(MAX),
@delimiter CHAR(1)
)
RETURNS @returnTable TABLE (idx INT PRIMARY KEY IDENTITY, item VARCHAR(8000))
AS
BEGIN
DECLARE @pos INT
SELECT @str = @str + @delimiter
WHILE LEN(@str) > 0 
    BEGIN
        SELECT @pos = CHARINDEX(@delimiter,@str)
        IF @pos = 1
            INSERT @returnTable (item)
                VALUES (NULL)
        ELSE
            INSERT @returnTable (item)
                VALUES (SUBSTRING(@str, 1, @pos-1))
        SELECT @str = SUBSTRING(@str, @pos+1, LEN(@str)-@pos)       
    END
RETURN
END