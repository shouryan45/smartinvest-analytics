-- 04_views_scoring.sql
USE mf_analytics;

-- Flattened view for analysis
CREATE OR REPLACE VIEW vw_fund_flat AS
SELECT
  f.fund_id, f.scheme_name,
  a.amc_name,
  c.category, c.sub_category,
  r.risk_level,
  f.fund_rating,
  d.date_value AS as_of_date,
  fact.nav, fact.aum_cr, fact.expense_ratio, fact.return_1y, fact.return_3y, fact.return_5y,
  fact.min_sip, fact.min_lumpsum
FROM fact_fund_snapshot fact
JOIN dim_fund f ON fact.fund_id = f.fund_id
JOIN dim_amc a ON f.amc_id = a.amc_id
JOIN dim_category c ON f.category_id = c.category_id
LEFT JOIN dim_risk r ON f.risk_id = r.risk_id
JOIN dim_date d ON fact.date_id = d.date_id;

-- Normalized risk-adjusted score (0..1) using window min/max
CREATE OR REPLACE VIEW vw_fund_scores AS
WITH s AS (
  SELECT *,
    MIN(return_1y) OVER () AS mn_r1,
    MAX(return_1y) OVER () AS mx_r1,
    MIN(return_3y) OVER () AS mn_r3,
    MAX(return_3y) OVER () AS mx_r3,
    MIN(return_5y) OVER () AS mn_r5,
    MAX(return_5y) OVER () AS mx_r5,
    MIN(expense_ratio) OVER () AS mn_er,
    MAX(expense_ratio) OVER () AS mx_er
  FROM vw_fund_flat
)
SELECT
  fund_id, scheme_name, amc_name, category, sub_category, risk_level, fund_rating, as_of_date,
  nav, aum_cr, expense_ratio, return_1y, return_3y, return_5y,
  /* normalized features */
  (return_1y - mn_r1)/NULLIF(mx_r1 - mn_r1,0) AS n_r1y,
  (return_3y - mn_r3)/NULLIF(mx_r3 - mn_r3,0) AS n_r3y,
  (return_5y - mn_r5)/NULLIF(mx_r5 - mn_r5,0) AS n_r5y,
  1 - ((expense_ratio - mn_er)/NULLIF(mx_er - mn_er,0)) AS n_exp_inv,
  /* blend weights (tweak as you like) */
  (0.30*((return_1y - mn_r1)/NULLIF(mx_r1 - mn_r1,0)) +
   0.45*((return_3y - mn_r3)/NULLIF(mx_r3 - mn_r3,0)) +
   0.15*((return_5y - mn_r5)/NULLIF(mx_r5 - mn_r5,0)) +
   0.10*(1 - ((expense_ratio - mn_er)/NULLIF(mx_er - mn_er,0)))
  ) AS score
FROM s;

CREATE OR REPLACE VIEW vw_top_30_by_score AS
SELECT * FROM vw_fund_scores
ORDER BY score DESC
LIMIT 30;
