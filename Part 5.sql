/* How do specific functional groups (like alcohols, ketones, and aromatics) impact the average melting point, boiling point, and liquid-phase temperature range of organic molecules? */
/* Objective: due to the nature of [5_Functional_Flags], we need to UNPIVOT the table, so the GROUP BY command works, or else fails. 
   Then, we can combine our functional groups of interest. Then, we can also display the desired thermal values. */

WITH UnpivotedFlags AS (
    -- Step 1: Flip the horizontal columns into vertical rows
    SELECT 
        flags.CAS,
        f.Functional_Group,
        f.Is_Present
    FROM 
        [5_Functional_Flags] flags
    CROSS APPLY (
        -- we map the column name to a text string
        VALUES 
            ('Alcohol', flags.is_alcohol),
            ('Alkane', flags.is_alkane),
            ('Ketone', flags.is_ketone),
            ('Carboxylic Acid', flags.is_carboxylic_acid),
            ('Aromatic', flags.is_aromatic),
            ('Ester', flags.is_ester),
            ('Alkene', flags.is_alkene),
            ('Aldehyde', flags.is_aldehyde),
            ('Anhydride', flags.is_anhydride),
            ('Acyl Halide', flags.is_acyl_halide)
    ) AS f(Functional_Group, Is_Present)
    WHERE 
        f.Is_Present = 1 -- We only care if the molecule actually contains the group
)
-- join the Molecular_properties table and calculate the averages
SELECT 
    u.Functional_Group,
    COUNT(u.CAS) AS Sample_Size,
    CAST(AVG(t.melting_point_K) AS DECIMAL(10,2)) AS Avg_Melting_Point_K,
    CAST(AVG(t.boiling_point_K) AS DECIMAL(10,2)) AS Avg_Boiling_Point_K,
    CAST(AVG(t.boiling_point_K) - AVG(t.melting_point_K) AS DECIMAL(10,2)) AS Liquid_Range_Kelvin
FROM 
    UnpivotedFlags u
JOIN 
    [3_Molecular_Properties] t ON u.CAS = t.CAS
WHERE 
    t.boiling_point_K IS NOT NULL
    AND t.melting_point_K IS NOT NULL
GROUP BY 
    u.Functional_Group
ORDER BY 
    Avg_Boiling_Point_K DESC