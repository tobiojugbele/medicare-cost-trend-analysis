import sqlite3
import pandas as pd
import numpy as np
import statsmodels.api as sm

def run_predictive_modeling():
    db_path = "medicare_project.db"
    
    print("🔄 Step 1: Querying data aggregates from SQLite...")
    conn = sqlite3.connect(db_path)
    
    # Check what age groups actually exist in the table dynamically
    try:
        age_check = pd.read_sql_query("SELECT DISTINCT bene_age_lvl FROM geo_variation LIMIT 5;", conn)
        print("📋 Found age groups in database:", age_check['bene_age_lvl'].tolist())
        
        # Grab the first available age group dynamically to prevent filter mismatch
        target_age = age_check['bene_age_lvl'].iloc[0] if not age_check.empty else 'All Beneficiaries'
        
        query = f"""
        SELECT year, AVG(tot_mdcr_stdzd_pymt_pc) as avg_std_pc_spending
        FROM geo_variation
        WHERE bene_age_lvl = '{target_age}'
        GROUP BY year
        ORDER BY year;
        """
        df = pd.read_sql_query(query, conn)
    except Exception as e:
        print(f"❌ Database Query Error: {e}")
        conn.close()
        return
    finally:
        conn.close()
    
    if df.empty or len(df) < 2:
        print("❌ Error: Not enough data points found. Printing raw sample of table:")
        conn = sqlite3.connect(db_path)
        sample = pd.read_sql_query("SELECT year, bene_age_lvl, tot_mdcr_stdzd_pymt_pc FROM geo_variation LIMIT 5;", conn)
        print(sample)
        conn.close()
        return

    print("📊 Historical Baselines Established:")
    print(df.to_string(index=False))

    print("\n🔬 Step 2: Training Ordinary Least Squares (OLS) Linear Regression Model...")
    X = df['year']
    X_with_constant = sm.add_constant(X)
    y = df['avg_std_pc_spending']
    
    model = sm.OLS(y, X_with_constant).fit()
    
    intercept = model.params['const']
    slope = model.params['year']
    r_squared = model.rsquared
    
    print(f"✅ Model Fit Confirmed. R-Squared Score: {r_squared:.4f}")
    print(f"📈 Formula: Per-Capita Spending = {intercept:.2f} + ({slope:.2f} * Year)")

    print("\n🔮 Step 3: Projecting Future Expenditures...")
    max_year = int(df['year'].max())
    future_years = [max_year + 1, max_year + 2, max_year + 3]
    
    print(f"🔮 Cost Projections for Next 3 Operational Cycles:")
    for year in future_years:
        prediction = intercept + (slope * year)
        print(f"   • Calendar Year {year} Target: ${prediction:,.2f} Per Capita")
        
    print("\n🎉 Regression analysis pipeline executed successfully!")

if __name__ == "__main__":
    run_predictive_modeling()
