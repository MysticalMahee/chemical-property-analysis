-- Which superclass has the highest average boiling point?
-- Objective: have superclass and boiling point JOINED together into 1 table and order them using DESC and select highest value using TOP 1

SELECT 
    a.superclass,
    b.boiling_point_K
FROM 
    [2_Chemical_Nature] a
JOIN 
    [3_Molecular_Properties] b ON a.CAS = b.CAS
WHERE 
    a.superclass IS NOT NULL
    AND b.boiling_point_K IS NOT NULL

-------------------------------------------------

SELECT TOP 1 -- we can select the TOP Nth superclass from highest to lowest or vice versa
    a.superclass,
    AVG(b.boiling_point_K) AS avg_boiling_point_K
FROM 
    [2_Chemical_Nature] a
JOIN 
    [3_Molecular_Properties] b ON a.CAS = b.CAS
WHERE 
    a.superclass IS NOT NULL
    AND b.boiling_point_K IS NOT NULL
GROUP BY 
    a.superclass
ORDER BY 
    avg_boiling_point_K DESC



