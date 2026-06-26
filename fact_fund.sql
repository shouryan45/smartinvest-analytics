-- Step 1: Load dimension tables
INSERT IGNORE INTO dim_amc (amc_name)
SELECT DISTINCT amc_name FROM stg_mutual_funds WHERE amc_name IS NOT NULL;

INSERT IGNORE INTO dim_category (category, sub_category)
SELECT DISTINCT category, b_category FROM stg_mutual_funds;

INSERT IGNORE INTO dim_manager (manager_name)
SELECT DISTINCT fund_manager FROM stg_mutual_funds WHERE fund_manager IS NOT NULL;

-- Step 2: Insert into fact table
INSERT INTO fact_fund_snapshot (
    scheme_name, amc_id, category_id, manager_id,
    expense_ratio, fund_size_cr, fund_age_yr,
    sortino, alpha, beta, sharpe,
    return_1yr, return_3yr, return_5yr,
    volatile_sd, rank_id, date_id
)
SELECT
    s.scheme_name,
    a.amc_id,
    c.category_id,
    m.manager_id,
    s.expense_ratio,
    s.fund_size_cr,
    s.fund_age_yr,
    s.sortino,
    s.alpha,
    s.beta,
    s.sharpe,
    s.returns_1yr,
    s.returns_3yr,
    s.returns_5yr,
    s.volatile_sd,
    s.rank_id,
    (SELECT date_id FROM dim_date WHERE date_value = CURDATE() LIMIT 1)
FROM stg_mutual_funds s
LEFT JOIN dim_amc a ON s.amc_name = a.amc_name
LEFT JOIN dim_category c ON s.category = c.category AND s.b_category = c.sub_category
LEFT JOIN dim_manager m ON s.fund_manager = m.manager_name;
SELECT COUNT(*) FROM fact_fund_snapshot;
SELECT scheme_name, return_3yr FROM fact_fund_snapshot ORDER BY return_3yr DESC LIMIT 10;
