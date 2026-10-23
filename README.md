# Longitudinal Medicare Expenditure Geographic Variation & Predictive Modeling

## 📋 Project Executive Summary
This analytics system establishes an end-to-end data engineering and statistical modeling pipeline evaluating regional variations in Medicare Fee-For-Service (FFS) standardized expenditures. Utilizing official public use files from the Centers for Medicare & Medicaid Services (CMS), the platform cleans dimensional records, provisions a relational analytical repository, isolates high-cost regional variance profiles via window functions, and trains an Ordinary Least Squares (OLS) regression model to project future healthcare outlays.

## 🛠️ Technological Stack Architecture
* **Data Engineering & ETL:** Python 3.11, Pandas, NumPy, OpenPyXL
* **Relational Warehousing Engine:** SQLite 3, SQL Data Modeling
* **Statistical Modeling & Inference:** StatsModels (Ordinary Least Squares Linear Regression)
* **Version Control Governance:** Advanced Git Workflow, Git Large File Security Controls

## 🗂️ Local Workspace Directory Mapping
```text
├── data/
│   ├── raw/                 # Original, untouched CMS source spreadsheet archives
│   └── processed/           # Normalized flat-file analytics matrix extractions
├── sql/
│   └── analysis.sql         # Production reporting transformations and window structures
├── python/
│   ├── etl.py               # Schema normalization, string scrubbing, and warehouse ingestion
│   └── analysis.py          # Predictive statistical modeling and longitudinal forecasting
├── README.md                # Portoflio summary and key mathematical findings
└── .gitignore               # Strict security guards protecting against binary/large-data leaks
```

## 📊 Core Statistical Findings & Projections
The predictive modeling pipeline isolated a consistent spending baseline across seven longitudinal operational cycles (2007–2013), confirming an **R-Squared model fit of 0.7478**:
* **Annualized Cost Momentum Vector:** Standardized per-capita spending increases by a structural average of **+$155.98** per year.
* **Regression Formula Baseline:** $\text{Per-Capita Expenditures} = -305,158.10 + (155.98 \times \text{Year})$
* **Three-Year Forward Cost Horizons:**
  * **Calendar Year 2014 Forecast Target:** \$8,990.03 Per Capita
  * **Calendar Year 2015 Forecast Target:** \$9,146.01 Per Capita
  * **Calendar Year 2016 Forecast Target:** \$9,301.99 Per Capita

## 🚀 Execution Instructions
To run this data pipeline locally inside your sandboxed environment, trigger the following operational modules:

```bash
# 1. Activate the local virtual environment workspace
source ~/venvs/medicare-project/bin/activate

# 2. Run the automated data engineering pipeline ingestion script
python python/etl.py

# 3. Trigger the predictive regression analytical framework
python python/analysis.py
```
