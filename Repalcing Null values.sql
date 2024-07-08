USE master;

WITH CTE AS (
    SELECT
        [Date],
        [BU],
        [Value],
        ROW_NUMBER() OVER (PARTITION BY [BU] ORDER BY [Date]) AS rn
    FROM HZL_Table
)
SELECT 
    c1.[Date],
    c1.[BU],
    COALESCE(c1.[Value], c2.[Value]) AS [Value]
FROM 
    CTE c1
OUTER APPLY (
    SELECT TOP 1 [Value]
    FROM CTE c2
    WHERE c2.[BU] = c1.[BU] 
      AND c2.rn < c1.rn
      AND c2.[Value] IS NOT NULL
    ORDER BY c2.rn DESC
) c2
ORDER BY 
    c1.[BU], 
    c1.[Date];