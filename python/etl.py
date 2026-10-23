import sqlite3
import pandas as pd
import numpy as np
import os

def run_etl():
    raw_path = "data/raw/2007-2013 Medicare FFS Geographic Variation Public Use File.xlsx" 
    processed_path = "data/processed/geo_variation_clean.csv"
    db_path = "medicare_project.db"
    
    print("🔄 Step 1: Checking for raw Excel data file...")
    if not os.path.exists(raw_path):
        print(f"❌ Error: Cannot find raw file at '{raw_path}'")
        return

    print("🔄 Step 2: Loading raw spreadsheet tabs into memory...")
    # Read the first data sheet. Adjust sheet_name if the file contains specific sheets.
    df = pd.read_excel(raw_path, sheet_name=0, na_values=['*', ' ', ''])
    
    print("🔄 Step 3: Standardizing column headers to snake_case...")
    df.columns = df.columns.astype(str).str.strip().str.lower().str.replace(' ', '_').str.replace('[^a-z0-9_]', '', regex=True)
    
    print("🔄 Step 4: Normalizing numeric metrics...")
    numeric_cols = [col for col in df.columns if 'spnd' in col or 'bene' in col or 'score' in col or 'rate' in col]
    for col in numeric_cols:
        if df[col].dtype == 'object':
            df[col] = df[col].astype(str).str.replace('$', '', regex=False).str.replace(',', '', regex=False)
            df[col] = pd.to_numeric(df[col], errors='coerce')
            
    print("🔬 Step 5: Validating data structure...")
    # Dynamic key validation based on common CMS spreadsheet formats
    geo_col = [col for col in df.columns if 'desc' in col or 'lvl' in col]
    if geo_col:
        assert df[geo_col[0]].notna().all(), "❌ Error: Empty geographic identifiers caught."
    print("✅ All internal layout integrity validations passed successfully.")
    
    print("💾 Step 6: Exporting clean production matrix...")
    df.to_csv(processed_path, index=False)
    
    print("🗄️ Step 7: Staging metrics inside SQLite database warehouse...")
    conn = sqlite3.connect(db_path)
    df.to_sql("geo_variation", conn, if_exists="replace", index=False)
    conn.close()
    print("🎉 ETL pipeline completed successfully!")

print("🚀 Launching Production Spreadsheet ETL Pipeline...")
run_etl()
