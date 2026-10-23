-- 📈 QUERY 1: Longitudinal State Per-Capita Expenditure Growth & YoY Trend Matrix
-- Interview Note: Uses LAG() window function partitioned by region to isolate consecutive year-over-year cost adjustments across state boundaries.
SELECT 
    bene_geo_desc AS state_name,
    year,
    tot_mdcr_stdzd_pymt_pc AS per_capita_spending,
    LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year) AS prior_year_spending,
    ROUND(((tot_mdcr_stdzd_pymt_pc - LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year)) / 
          LAG(tot_mdcr_stdzd_pymt_pc, 1) OVER (PARTITION BY bene_geo_desc ORDER BY year)) * 100, 2) AS yoy_pct_change
FROM geo_variation
WHERE bene_geo_lvl = 'State' 
  AND bene_age_lvl = 'All'
ORDER BY state_name, year;


-- 🏥 QUERY 2: Institutional Care Setting Allocation & Intensity Profile
-- Interview Note: Pivots standardized inpatient and outpatient per-capita ratios to identify if regional costs are driven by expensive hospitalizations or clinical outpatient services.
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
  AND bene_age_lvl = 'All'
ORDER BY total_per_capita DESC;


-- 🔬 QUERY 3: High-Cost Regional Variation & Variance Rankings
-- Interview Note: Normalizes per-capita spending metrics against the average population risk score to isolate genuine geographic spending inefficiencies from structural patient sickness.
SELECT 
    bene_geo_desc AS location_name,
    bene_geo_lvl AS geographic_level,
    year,
    tot_mdcr_stdzd_pymt_pc AS per_capita_spending,
    bene_avg_risk_scre AS population_risk_score,
    ROUND(tot_mdcr_stdzd_pymt_pc / bene_avg_risk_scre, 2) AS risk_adjusted_spending
FROM geo_variation
WHERE bene_geo_lvl IN ('State', 'County')
  AND bene_age_lvl = 'All'
  AND bene_avg_risk_scre > 0
ORDER BY risk_adjusted_spending DESC;
