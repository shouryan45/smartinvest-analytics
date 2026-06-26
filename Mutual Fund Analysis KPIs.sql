-- =======================================================
-- MUTUAL FUND ANALYTICS DASHBOARD KPIs
-- =======================================================

-- ======================================
-- 1. PERFORMANCE KPIs
-- ======================================

-- Top 10 funds by 1-Year Return
SELECT scheme_name, return_1yr
FROM fact_fund_snapshot
ORDER BY return_1yr DESC
LIMIT 10;

-- Top 10 funds by 3-Year CAGR
SELECT scheme_name, return_3yr
FROM fact_fund_snapshot
ORDER BY return_3yr DESC
LIMIT 10;

-- Top 10 funds by 5-Year CAGR
SELECT scheme_name, return_5yr
FROM fact_fund_snapshot
ORDER BY return_5yr DESC
LIMIT 10;


-- ======================================
-- 2. RISK-ADJUSTED KPIs
-- ======================================

-- Best Sharpe Ratio funds
SELECT scheme_name, sharpe
FROM fact_fund_snapshot
WHERE sharpe IS NOT NULL
ORDER BY sharpe DESC
LIMIT 10;

-- Best Sortino Ratio funds
SELECT scheme_name, sortino
FROM fact_fund_snapshot
WHERE sortino IS NOT NULL
ORDER BY sortino DESC
LIMIT 10;

-- Lowest Beta (less market-sensitive)
SELECT scheme_name, beta
FROM fact_fund_snapshot
WHERE beta IS NOT NULL
ORDER BY beta ASC
LIMIT 10;


-- ======================================
-- 3. CATEGORY INSIGHTS
-- ======================================

-- Average 3-Year return by Category
SELECT c.category, ROUND(AVG(f.return_3yr),2) AS avg_3yr_return
FROM fact_fund_snapshot f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY avg_3yr_return DESC;

-- Category Risk (Volatility vs Sharpe)
SELECT c.category, ROUND(AVG(f.volatile_sd),2) AS avg_volatility,
       ROUND(AVG(f.sharpe),2) AS avg_sharpe
FROM fact_fund_snapshot f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY avg_sharpe DESC;


-- ======================================
-- 4. AMC / MANAGER KPIs
-- ======================================

-- Top AMCs by Average 3-Year Return
SELECT a.amc_name, ROUND(AVG(f.return_3yr),2) AS avg_3yr_return
FROM fact_fund_snapshot f
JOIN dim_amc a ON f.amc_id = a.amc_id
GROUP BY a.amc_name
ORDER BY avg_3yr_return DESC
LIMIT 10;

-- Top Fund Managers by Sharpe Ratio
SELECT m.manager_name, ROUND(AVG(f.sharpe),2) AS avg_sharpe
FROM fact_fund_snapshot f
JOIN dim_manager m ON f.manager_id = m.manager_id
GROUP BY m.manager_name
ORDER BY avg_sharpe DESC
LIMIT 10;


-- ======================================
-- 5. FUND SIZE & POPULARITY
-- ======================================

-- Largest Funds by AUM
SELECT scheme_name, fund_size_cr
FROM fact_fund_snapshot
ORDER BY fund_size_cr DESC
LIMIT 10;

-- Smallest Funds by AUM
SELECT scheme_name, fund_size_cr
FROM fact_fund_snapshot
ORDER BY fund_size_cr ASC
LIMIT 10;


-- ======================================
-- 6. RISK vs RETURN FILTER
-- ======================================

-- High return (>10%) with low volatility (<15)
SELECT scheme_name, return_3yr, volatile_sd
FROM fact_fund_snapshot
WHERE return_3yr > 10 AND volatile_sd < 15
ORDER BY return_3yr DESC;


-- ======================================
-- 7. QUALITY & RATING
-- ======================================

-- Top-rated Funds
SELECT scheme_name, rating, return_3yr
FROM fact_fund_snapshot
ORDER BY rating DESC, return_3yr DESC
LIMIT 10;

-- Funds ranked in Top 5
SELECT scheme_name, rank_id, return_3yr
FROM fact_fund_snapshot
WHERE rank_id <= 5
ORDER BY rank_id ASC;


-- ======================================
-- 8. EXPENSE EFFICIENCY
-- ======================================

-- Funds with Lowest Expense Ratio
SELECT scheme_name, expense_ratio, return_3yr
FROM fact_fund_snapshot
ORDER BY expense_ratio ASC
LIMIT 10;

-- High Sharpe despite Low Expenses
SELECT scheme_name, expense_ratio, sharpe
FROM fact_fund_snapshot
WHERE sharpe IS NOT NULL
ORDER BY sharpe DESC, expense_ratio ASC
LIMIT 10;

-- =======================================================
-- END OF KPI DASHBOARD SCRIPT
-- =======================================================
