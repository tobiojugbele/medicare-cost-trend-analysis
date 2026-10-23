-- 📈 1. State-Level Longitudinal Expenditure Growth & YoY Trend Matrix
SELECT 
    bene_geo_desc AS state_name,
    year,
    tot_mdcr_stdzd_pymt_pc AS per_capita_spending,
    LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year) AS prior_year_spending,
    ROUND(((tot_mdcr_stdzd_pymt_pc - LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year)) / 
          LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year)) * 100, 2) AS yoy_pct_change
FROM geo_variation
WHERE bene_geo_lvl = 'State' 
  AND bene_age_lvl = 'All Beneficiaries'
ORDER BY state_name, year;

-- 🏥 2. Institutional Intensity: Inpatient vs. Outpatient Care Share Profile
SELECT 
    bene_geo_desc AS region_name,
    year,
    tot_mdcr_stdzd_pymt_pc AS total_per_capita,
    ip_mdcr_stdzd_pymt_pc AS inpatient_per_capita,
    op_mdcr_stdzd_pymt_pc AS outpatient_per_capita,
    ROUND(ip_mdcr_pymt_pct, 2) AS inpatient_budget_share,
    ROUND(op_mdcr_pymt_pct, 2) AS outpatient_budget_share
FROM geo_variation
WHERE bene_geo_lvl = 'State'
  AND bene_age_lvl = 'All Beneficiaries'
ORDER BY total_per_capita DESC;

-- 🔬 3. High-Variance Risk-Adjusted Cost Efficiencies
SELECT 
    bene_geo_desc AS location_name,
    bene_geo_lvl AS geographic_level,
    year,
    tot_mdcr_stdzd_pymt_pc AS per_capita_spending,
    bene_avg_risk_scre AS population_risk_score,
    ROUND(tot_mdcr_stdzd_pymt_pc / bene_avg_risk_scre, 2) AS risk_adjusted_spending
FROM geo_variation
WHERE bene_geo_lvl IN ('State', 'County')
  AND bene_age_lvl = 'All Beneficiaries'
  AND bene_avg_risk_scre > 0
ORDER BY risk_adjusted_spending DESC;
