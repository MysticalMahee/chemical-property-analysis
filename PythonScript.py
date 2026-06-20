from google.colab import drive
drive.mount("/content/drive", force_remount=True)

import pandas as pd

file_path = '/content/drive/MyDrive/physical_chemical_properties_of_organic_substances.csv'
df = pd.read_csv(file_path)

initial_rows = len(df)
df = df.drop_duplicates(subset=['CAS'], keep='first')
print(f"Dropped {initial_rows - len(df)} duplicate CAS entries. Clean rows: {len(df)}")

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

df_id.to_csv('1_Basic_Identification.csv', index=False)
df_nature.to_csv('2_Chemical_Nature.csv', index=False)
df_molecular.to_csv('3_Molecular_Properties.csv', index=False)
df_safety.to_csv('4_Safety_Hazards.csv', index=False)
df_flags.to_csv('5_Functional_Flags.csv', index=False)

print("Ready to use for SQL manipulation")



