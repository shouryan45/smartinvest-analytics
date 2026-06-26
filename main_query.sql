CREATE DATABASE mutual_funds;
USE mutual_funds;
CREATE TABLE top_30_mutual_funds (
    scheme_name     VARCHAR(255),
    min_sip         INT,
    min_lumpsum     INT,
    expense_ratio   DECIMAL(5,2),
    fund_size_cr    DECIMAL(12,2),
    fund_age_yr     INT,
    fund_manager    VARCHAR(255),
    sortino         DECIMAL(10,4),
    alpha           DECIMAL(10,4),
    beta            DECIMAL(10,4),
    sharpe          DECIMAL(10,4),
    risk_level      INT,
    amc_name        VARCHAR(255),
    rating          INT,
    category        VARCHAR(100),
    b_category      VARCHAR(100),
    returns_1yr     DECIMAL(10,4),
    returns_3yr     DECIMAL(10,4),
    returns_5yr     DECIMAL(10,4),
    volatile_sd     DECIMAL(10,4),
    rank_id         INT
);
SELECT * FROM top_30_mutual_funds LIMIT 10;

