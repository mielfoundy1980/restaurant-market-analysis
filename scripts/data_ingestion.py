import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

# 1. Load environment variables from the .env file
load_dotenv()

# 2. Retrieve credentials securely
utilisateur = os.getenv("MARIADB_USER")
mot_de_passe = os.getenv("MARIADB_PASSWORD")

# 3. Configure MariaDB connection string
chaine_connexion = f"mysql+mysqlconnector://{utilisateur}:{mot_de_passe}@localhost:3306/db_restaurant_ratings"
engine = create_engine(chaine_connexion)

# 4. Path to your local dataset directory
dossier_source = r"C:/Users/Pc/Desktop/DOSSIER PERSONNEL/ANALYSE DONNEES/DATASETS/RESTAURANT_RATINGS"

# 5. Mapping dictionary (CSV File Name -> SQL Table Name)
fichiers_tables = {
    "consumers.csv": "1_bronze_dim_consumers",
    "consumer_preferences.csv": "2_bronze_dim_consumer_preferences",
    "restaurants.csv": "3_bronze_dim_restaurants",
    "restaurant_cuisines.csv": "4_bronze_dim_restaurant_cuisines",
    "ratings.csv": "5_bronze_fact_ratings"
}

# 6. Automated ingestion loop
for fichier, table in fichiers_tables.items():
    chemin_complet = os.path.join(dossier_source, fichier)
    
    try:
        print(f"⏳ Loading {fichier} into table {table}...")
        
        # Read the CSV file 
        df = pd.read_csv(chemin_complet)
        
        # Insert data into MariaDB
        # if_exists='append' : appends data to your pre-existing table structure
        # index=False : prevents inserting the dataframe index as a SQL column
        df.to_sql(name=table, con=engine, if_exists='append', index=False)
        
        print(f"✅ Success: {len(df)} rows inserted into {table}.\n")
        
    except FileNotFoundError:
        print(f"❌ Error: The file {fichier} was not found. Please check the extension or filename.\n")
    except Exception as e:
        print(f"❌ Unexpected error while inserting {fichier}: {e}\n")
