ALTER VIEW [dbo].[Vpers_Albaranes_CR_RLL]  
AS  
SELECT 
    CAST(a.IdAlbaran AS varchar) + s.Sufijo AS Ord,
    a.IdAlbaran
FROM 
    Albaranes_Cli_Cab  a WITH (NOLOCK)
CROSS JOIN 
    (VALUES ('A'), ('B')) AS s(Sufijo)

--OPTIMITZACIÓ 12/06/25 EPAREDES, VERSIÓ VELLA:
   
--Select cast(IdAlbaran as varchar) + 'A'  as Ord, IdAlbaran from Albaranes_Cli_Cab  
--UNION ALL  
--SELECT cast(IdAlbaran as varchar) + 'B'  as Ord, IdAlbaran from Albaranes_Cli_Cab  