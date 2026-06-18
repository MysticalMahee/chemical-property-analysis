-- Which compounds have the highest molecular weights?
-- Objective: have the name, molecular_weight joined together with CAS, and order them in order using DESC and select TOP nth rows

SELECT 
    a.[name],
    b.molecular_weight
FROM 
    [1_Basic_Identification] a
JOIN 
    [3_Molecular_Properties] b ON a.CAS = b.CAS
WHERE 
    a.[name] IS NOT NULL
    AND b.molecular_weight IS NOT NULL

-------------------------------------------------

SELECT TOP 5 -- we wish to select the top 5 molecules with the highest molecular weight
    a.[name],
    MAX(b.molecular_weight) AS highest_molecular_weight
FROM 
    [1_Basic_Identification] a
JOIN 
    [3_Molecular_Properties] b ON a.CAS = b.CAS
WHERE 
    a.[name] IS NOT NULL
    AND b.molecular_weight IS NOT NULL
GROUP BY 
    a.[name]
ORDER BY 
    highest_molecular_weight DESC


