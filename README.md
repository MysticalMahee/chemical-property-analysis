## 📌 Summary
This project demonstrates the extraction, transformation, and loading (ETL) of raw chemical datasets into a structured, 5-table relational database. By leveraging **Python (pandas)** for programmatic data cleansing and **SQL** for querying, this repository mathematically investigates molecular weight distributions, phase change thermodynamics, and the influence of aromaticity on lipid-phase partitioning.

---

## 🛠️ Tech Stack & Architecture
* **Data Cleansing & ETL:** Python (`pandas`)
* **Database Architecture:** Relational 5-Table Schema (Normalized)
* **Querying & Analysis:** SQL Server Managent Studio 22 (SSMS), SQL (Window Functions, CTEs, UNPIVOT)

### 1. Data Ingestion & Cleansing (Python)
The raw dataset contained thousands of organic molecules with missing values, duplicate CAS registry numbers, and unformatted columns. A Python script was developed to programmatically clean the data and resolve schema inconsistencies before export. 
* Since we have used Google Colab, we first imported out raw dataset from Google Drive to colab using the (`drive.mount`) command:

```python
from google.colab import drive
drive.mount("/content/drive", force_remount=True)
```

* Then, we have used the (`pandas`) library and loaded the raw data from Google Drive
* Then, we have applied some initial cleaning, in which we drop rows with duplicate CAS numbers using the script:

```python
initial_rows = len(df)
df = df.drop_duplicates(subset=['CAS'], keep='first')
print(f"Dropped {initial_rows - len(df)} duplicate CAS entries. Clean rows: {len(df)}")
```

* We have used the (`len(df)`) command, which returns the length of the DataFrame: i.e. the length value of the number of rows dropped after applying the above script, and we can see that 49 rows were dropped, telling us 49 entries with the same CAS entry were present, hence there were copies of the same molecules present in the raw dataset, which we do not require.

```python
basic_id_cols = ['CAS', 'name', 'improved_name', 'formula', 'smiles', 'InChI', 'InChIKey']
df_id = df[basic_id_cols]

chemical_nature_cols = ['CAS', 'kingdom', 'superclass', 'class', 'direct_parent', 'substituents', 'is_organic']
df_nature = df[chemical_nature_cols]

molecular_cols = ['CAS', 'molecular_weight', 'melting_point_K', 'boiling_point_K', 'heat_of_fusion', 'heat_of_vaporization', 'critical_temperature', 'critical_pressure']
df_molecular = df[molecular_cols]

safety_cols = ['CAS', 'flash_point', 'logP']
df_safety = df[safety_cols]

flag_cols = ['CAS'] + df.columns[22:].tolist()
df_flags = df[flag_cols]
```

* Then, We have carefully selected which columns we wish to categorise, which put together form a specific chemical nature, such as temperatures, classes, functional groups etc. This can be done with the following python script:


* Finally, we have categorised the above columns into 5 different datasets, each classified accordingly to their chemical nature, and this is trivially done with the given script:

```python
df_id.to_csv('1_Basic_Identification.csv', index=False)
df_nature.to_csv('2_Chemical_Nature.csv', index=False)
df_molecular.to_csv('3_Molecular_Properties.csv', index=False)
df_safety.to_csv('4_Safety_Hazards.csv', index=False)
df_flags.to_csv('5_Functional_Flags.csv', index=False)

print("Ready to use for SQL manipulation")
```




### 2. Relational Database Design (SQL)
From the above Python Script, we have outputted 5 distinct datasets, and they are:
1. `1_Basic_Indentification`
2. `2_Chemical_Features`
3. `3_Molecular_Properties`
4. `4_Safety_Hazards`
5. `5_Functional_Flags`


---

## 🔬 Key Analytical Queries & Findings

* <ins>**In all SQL scripts below, we have always used a primary starting script to help us visualise which columns we will be working with and the 2nd script answered out desired question.<ins>**
* *** *** N.B.: FOR PART 1,2,3 and 4, THE TOP SCRIPTS OF EACH OF THE SQL SCRIPTS HAVE DISPLAYED OUTPUTS WHICH HAVE NOT BEEN FULLY TAKEN IN THE SCREENSHOTS, DUE TO LARGE SIZE OF TABLE, HENCE ONLY A SMALL PART HAS BEEN SHOWN. *** ***

### Part 1: Thermodynamic Temperatures by Superclass
* **QUESTION:** Which superclass has the highest average boiling point?
* **Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data and used the `AVG` function to find the average boiling points of each superclasses present. We have also used the `TOP 1` command to ensure the first superclass average with the highest boiling point is printed, as linked with the `DESC` command. From the `SQL_Scripts/01_Highest_Boiling_Point_by_Superclass.sql` file, we get the following output: 


* Output for both script 1 and 2 respectively:
<img width="283" height="297" alt="Screenshot 2026-06-20 215935" src="https://github.com/user-attachments/assets/7022fd21-2f62-4736-bd62-1a8dd83b04db" />
<img width="351" height="62" alt="Screenshot 2026-06-20 215948" src="https://github.com/user-attachments/assets/b12fd6ad-d1d3-44ab-b4b7-bb0ac8fdef6e" />

### Part 2: Ranking Heavy Molecules
* **QUESTION:** Which compounds have the highest molecular weights? Show the top 5 heaviest molecules
* **Method:**  Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data and used the `MAX` function to output the highest value present. We have also used the `TOP 5` command to ensure the first 5 heaviest molecules are printed, as linked with the `DESC` command. From the `SQL_Scripts/02_Heaviest_Molecules_Window_Function.sql` file, we get the following output:

* Output for both script 1 and 2 respectively:
<img width="281" height="246" alt="Screenshot 2026-06-20 220642" src="https://github.com/user-attachments/assets/11a93665-e4d3-4d0d-a235-34189a80e025" />
<img width="336" height="150" alt="Screenshot 2026-06-20 220634" src="https://github.com/user-attachments/assets/68e156c7-0f37-400c-989f-e9bbe4598ace" />



### Part 3: Aromaticity vs Lipophilicity (LogP)
* **Objective:** Statistically quantify the thermodynamic drive of delocalized pi-systems into lipid phases by comparing the average partition coefficient (LogP) of aromatic vs non-aromatic compounds.
* **Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data. Used `JOIN` between the Functional Flags and Safety Hazards tables, aggregating the average LogP. From the `SQL_Scripts/03_LogP_Aromaticity_Analysis.sql` file, we get the following output:

* Output for both script 1 and 2 respectively:
<img width="274" height="309" alt="image" src="https://github.com/user-attachments/assets/a663da7b-3e6a-41c3-b13e-fc6d8e2a8a24" />
<img width="253" height="77" alt="image" src="https://github.com/user-attachments/assets/10595c4c-4756-4943-bce5-e4d7cf4fa5ad" />

* <ins>Here, the binary values 0 and 1 represent the Boolean logic for FALSE and TRUE respectively.<ins>

### Part 4: Most Frequent Classes
* **QUESTION:** Which chemical classes appear most frequently?
* **Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data. Used `COUNT(*)` on class to count all rows in the [2_chemical_nature] table, including rows with NULL values. Furthermore, the use of the `WITH TIES` command was been used as there could be classes with equal repetitions, and of course we wish to also display those classes. If we knew for fact that there will be only 1 class with highest repetition, we can remove the `WITH TIES` part, else keep that if we don’t know if there any multiple classes with equal number of repetitions. As usual, we also have the `TOP 1` command to make sure the superclass with the most repetitions gets printed. From the `SQL_Scripts/04_Chemical_Class_Frequency_Count.sql` file, we get the following output:

* Output for both script 1 and 2 respectively:
<img width="234" height="226" alt="Screenshot 2026-06-20 222842" src="https://github.com/user-attachments/assets/37b60e82-ac9f-4e4f-adbe-8d47a2f40e5b" />
<img width="379" height="51" alt="Screenshot 2026-06-20 222846" src="https://github.com/user-attachments/assets/237b0264-d87a-4580-a1e7-b5e7f8a58ce4" />


### Part 5: Unpivoting Functional Group
* **Objective:** Transform wide boolean flags (e.g., `has_alcohol`, `has_ketone`) into a tall, queryable format to analyze how specific functional groups impact average melting and boiling points. Also, find the liquid range in Kelvin.
* **Method:** Utilised the `CROSS APPLY` (UNPIVOT) function to restructure the dataset. The 1st prompt (lines 6-29) will convert the columns from [dbo].[5_Functional_Flags] into rows. This is done because the GROUP BY command groups values horizontally and not vertically. Our functional groups are in column formats, hence if we wish to do maths with those entries, we need to “ rotate the functional groups column by 90° “ as the `CROSS APPLY` command only does the maths in rows and not columns. From there, we have named the functional groups headers into more simple names, as shown in red writing. And for cleanliness, we have only dealt with values whose molecules do have a functional group, which are given by either “TRUE” or “FALSE”: i.e. 1 or 0, hence the command in line 29. The use of the `CAST` function was used explicitly to convert a value of one data type to another, which helped us find out desired temperature requests from the question. From the `SQL_Scripts/05_Functional_Group_Unpivot_Thermodynamics.sql` file, we get the following output:


* Output for both script 1 and 2 respectively:
<img width="486" height="194" alt="Screenshot 2026-06-20 224424" src="https://github.com/user-attachments/assets/dde3de95-d0d7-42eb-9e21-7b79dd81f478" />


---

## 💡 Conclusion
This pipeline successfully transforms messy, chemical data into a robust relational model. By systematically categorizing over 4,000 molecules, the SQL queries successfully replicate known physical chemistry principles (e.g., the increased hydrophobicity of aromatic rings) purely through data-driven aggregation.
