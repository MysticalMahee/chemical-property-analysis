-- What is the average LogP for aromatic compounds?
-- Objective: we need LogP and the aromatic columns joined together under CAS and average LogP

SELECT 
    a.[logP],
    b.is_aromatic
FROM 
    [4_Safety_Hazards] a
JOIN 
    [5_Functional_Flags] b ON a.CAS = b.CAS        -- join logP and is_aromatic into 1 table
WHERE 
    a.[logP] IS NOT NULL
AND b.is_aromatic IS NOT NULL

-------------------------------------------------

SELECT 
    b.is_aromatic,
    AVG(a.logP) AS avg_logP
FROM 
    [5_Functional_Flags] b
JOIN 
    [4_Safety_Hazards] a ON b.CAS = a.CAS
WHERE 
    b.is_aromatic IS NOT NULL
    AND a.logP IS NOT NULL
GROUP BY 
    b.is_aromatic
ORDER BY 
    avg_logP