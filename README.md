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
  
<img width="552" height="106" alt="Screenshot 2026-06-20 210143" src="https://github.com/user-attachments/assets/ae5c6b4a-641f-42d0-a20a-67c8a69e6ceb" />

* Then, we have used the (`pandas`) library and loaded the raw data from Google Drive
* Then, we have applied some initial cleaning, in which we drop rows with duplicate CAS numbers using the script:
  
<img width="691" height="69" alt="Screenshot 2026-06-20 210829" src="https://github.com/user-attachments/assets/a305e4ad-281b-429f-89f2-5c14e319568e" />

* We have used the (`len(df)`) command, which returns the length of the DataFrame: i.e. the length value of the number of rows dropped after applying the above script, and we can see that 49 rows were dropped, telling us 49 entries with the same CAS entry were present, hence there were copies of the same molecules present in the raw dataset, which we do not require.

<img width="378" height="17" alt="Screenshot 2026-06-20 212122" src="https://github.com/user-attachments/assets/bdcbf270-d9ae-48e3-a804-b50271f78bd9" />

* Then, We have carefully selected which columns we wish to categorise, which put together form a specific chemical nature, such as temperatures, classes, functional groups etc. This can be done with the following python script:

<img width="968" height="283" alt="Screenshot 2026-06-20 211223" src="https://github.com/user-attachments/assets/a795a49d-8d86-4c1f-946c-7b0587068758" />

* Finally, we have categorised the above columns into 5 different datasets, each classified accordingly to their chemical nature, and this is trivially done with the given script:
  
<img width="525" height="144" alt="Screenshot 2026-06-20 211600" src="https://github.com/user-attachments/assets/9c1d4ccc-afc9-488c-acdf-8ee19c80a880" />




### 2. Relational Database Design (SQL)
From the above Python Script, we have outputted 5 distinct datasets, and they are:
1. `1_Basic_Indentification`
2. `2_Chemical_Features`
3. `3_Molecular_Properties`
4. `4_Safety_Hazards`
5. `5_Functional_Flags`

<img width="265" height="189" alt="Screenshot 2026-06-20 210107" src="https://github.com/user-attachments/assets/7b0f3d28-78eb-4085-9e18-2716efc19a8b" />


---

## 🔬 Key Analytical Queries & Findings

* <ins>**In all SQL scripts below, we have always used a primary starting script to help us visualise which columns we will be working with and the 2nd script answered out desired question.**</ins>

### Part 1: Thermodynamic Temperatures by Superclass
* **QUESTION:** Which superclass has the highest average boiling point?
* **Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data and used the `AVG` function to find the average boiling points of each superclasses present. We have also used the `TOP 1` command to ensure the first superclass average with the highest boiling point is printed, as linked with the `DESC` command. We can see from both the SQL script and output, we get the following:

* SQL Script:
<img width="826" height="395" alt="Screenshot 2026-06-20 215846" src="https://github.com/user-attachments/assets/e46f019c-1a47-432f-8c17-7d6d5f6d0b08" />

* Output for both script 1 and 2 respectively:
<img width="283" height="297" alt="Screenshot 2026-06-20 215935" src="https://github.com/user-attachments/assets/7022fd21-2f62-4736-bd62-1a8dd83b04db" />
<img width="351" height="62" alt="Screenshot 2026-06-20 215948" src="https://github.com/user-attachments/assets/b12fd6ad-d1d3-44ab-b4b7-bb0ac8fdef6e" />

### Part 2: Ranking Heavy Molecules
* **QUESTION:** Which compounds have the highest molecular weights? Show the top 5 heaviest molecules
* **Method:**  Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data and used the `MAX` function to output the highest value present. We have also used the `TOP 5` command to ensure the first 5 heaviest molecules are printed, as linked with the `DESC` command.
  
* SQL Script:
<img width="865" height="419" alt="Screenshot 2026-06-20 220628" src="https://github.com/user-attachments/assets/4b5b7e87-f8ba-4723-b594-9a1a6642eceb" />

* Output for both script 1 and 2 respectively:
<img width="281" height="246" alt="Screenshot 2026-06-20 220642" src="https://github.com/user-attachments/assets/11a93665-e4d3-4d0d-a235-34189a80e025" />
<img width="336" height="150" alt="Screenshot 2026-06-20 220634" src="https://github.com/user-attachments/assets/68e156c7-0f37-400c-989f-e9bbe4598ace" />



### Part 3: Aromaticity vs Lipophilicity (LogP)
**Objective:** Statistically quantify the thermodynamic drive of delocalized pi-systems into lipid phases by comparing the average partition coefficient (LogP) of aromatic vs non-aromatic compounds.
**Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data. Used `JOIN` between the Functional Flags and Safety Hazards tables, aggregating the average LogP. 

* SQL Script:
<img width="783" height="504" alt="image" src="https://github.com/user-attachments/assets/15982b29-5c00-4515-8632-7114ed6720e1" />

* Output for both script 1 and 2 respectively:
<img width="274" height="309" alt="image" src="https://github.com/user-attachments/assets/a663da7b-3e6a-41c3-b13e-fc6d8e2a8a24" />
<img width="253" height="77" alt="image" src="https://github.com/user-attachments/assets/10595c4c-4756-4943-bce5-e4d7cf4fa5ad" />

* <ins>Here, the binary values 0 and 1 represent the Boolean logic for FALSE and TRUE respectively.<ins>

### Part 4: Most Frequent Classes
**Objective:** Which chemical classes appear most frequently?
**Method:** Utilised `GROUP BY` aggregations and `ORDER BY` to filter out null thermodynamic readings and rank the data. Used `COUNT(*)` on class to count all rows in the [2_chemical_nature] table, including rows with NULL values. Furthermore, the use of the `WITH TIES` command was been used as there could be classes with equal repetitions, and of course we wish to also display those classes. If we knew for fact that there will be only 1 class with highest repetition, we can remove the `WITH TIES` part, else keep that if we don’t know if there any multiple classes with equal number of repetitions. As usual, we also have the `TOP 1` command to make sure the superclass with the most repetitions gets printed.

* SQL Script:
<img width="863" height="431" alt="Screenshot 2026-06-20 222853" src="https://github.com/user-attachments/assets/324f2409-f58d-4e47-87f9-7c6bcf15310e" />

* Output for both script 1 and 2 respectively:
<img width="234" height="226" alt="Screenshot 2026-06-20 222842" src="https://github.com/user-attachments/assets/37b60e82-ac9f-4e4f-adbe-8d47a2f40e5b" />
<img width="379" height="51" alt="Screenshot 2026-06-20 222846" src="https://github.com/user-attachments/assets/237b0264-d87a-4580-a1e7-b5e7f8a58ce4" />


### Part 5: Unpivoting Functional Group
**Objective:** Transform wide boolean flags (e.g., `has_alcohol`, `has_ketone`) into a tall, queryable format to analyze how specific functional groups impact average melting and boiling points. Also, find the liquid range in Kelvin.
**Method:** Utilised the `CROSS APPLY` (UNPIVOT) function to restructure the dataset. The 1st prompt (lines 6-29) will convert the columns from [dbo].[5_Functional_Flags] into rows. This is done because the GROUP BY command groups values horizontally and not vertically. Our functional groups are in column formats, hence if we wish to do maths with those entries, we need to “ rotate the functional groups column by 90° “ as the `CROSS APPLY` command only does the maths in rows and not columns. From there, we have named the functional groups headers into more simple names, as shown in red writing. And for cleanliness, we have only dealt with values whose molecules do have a functional group, which are given by either “TRUE” or “FALSE”: i.e. 1 or 0, hence the command in line 29. The use of the `CAST` function was used explicitly to convert a value of one data type to another, which helped us find out desired temperature requests from the question.

* SQL Script:
<img width="755" height="476" alt="Screenshot 2026-06-20 224504" src="https://github.com/user-attachments/assets/86408e49-de52-41c2-8f9d-73beaf6a8c7d" />


* Output for both script 1 and 2 respectively:
<img width="486" height="194" alt="Screenshot 2026-06-20 224424" src="https://github.com/user-attachments/assets/dde3de95-d0d7-42eb-9e21-7b79dd81f478" />


---

## 💡 Conclusion
This pipeline successfully transforms messy, chemical data into a robust relational model. By systematically categorizing over 4,000 molecules, the SQL queries successfully replicate known physical chemistry principles (e.g., the increased hydrophobicity of aromatic rings) purely through data-driven aggregation.
