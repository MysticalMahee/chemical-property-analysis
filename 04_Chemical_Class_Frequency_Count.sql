-- Which chemical classes appear most frequently?
-- Objective: select the classes column and check for which group has the most repetition

SELECT 
    [class]
FROM 
    [2_Chemical_Nature]
WHERE 
    [class] IS NOT NULL

---------------------------------

SELECT 
    TOP 1 WITH TIES [class], COUNT(*) AS repetition_count
    -- WITH TIES allows for multiple equal repetitions to be displayed
FROM 
    [2_Chemical_Nature]
GROUP BY 
    [class]
ORDER BY 
    repetition_count DESC