-- ==================================================
-- 01. CREATE DATABASE
-- ==================================================
DROP DATABASE IF EXISTS mf_analytics;
CREATE DATABASE mf_analytics CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE mf_analytics;

-- ==================================================
-- 02. STAGING TABLE (Raw from CSV)
-- ==================================================
DROP TABLE IF EXISTS stg_mutual_funds;
CREATE TABLE stg_mutual_funds (
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

-- ==================================================
-- 03. DIMENSIONS
-- ==================================================
CREATE TABLE dim_amc (
  amc_id INT AUTO_INCREMENT PRIMARY KEY,
  amc_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dim_category (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(100),
  sub_category VARCHAR(100),
  UNIQUE KEY uq_cat (category, sub_category)
);

CREATE TABLE dim_manager (
  manager_id INT AUTO_INCREMENT PRIMARY KEY,
  manager_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE dim_date (
  date_id    INT AUTO_INCREMENT PRIMARY KEY,
  date_value DATE NOT NULL,
  year SMALLINT NOT NULL,
  quarter TINYINT NOT NULL,
  month TINYINT NOT NULL,
  day TINYINT NOT NULL,
  UNIQUE KEY uq_date (date_value)
);

-- ==================================================
-- 04. FACT TABLE
-- ==================================================
CREATE TABLE fact_fund_snapshot (
  fund_id       INT AUTO_INCREMENT PRIMARY KEY,
  scheme_name   VARCHAR(255),
  amc_id        INT,
  category_id   INT,
  manager_id    INT,
  expense_ratio DECIMAL(5,2),
  fund_size_cr  DECIMAL(12,2),
  fund_age_yr   INT,
  sortino       DECIMAL(10,4),
  alpha         DECIMAL(10,4),
  beta          DECIMAL(10,4),
  sharpe        DECIMAL(10,4),
  return_1yr    DECIMAL(10,4),
  return_3yr    DECIMAL(10,4),
  return_5yr    DECIMAL(10,4),
  volatile_sd   DECIMAL(10,4),
  rank_id       INT,
  date_id       INT,
  FOREIGN KEY (amc_id) REFERENCES dim_amc(amc_id),
  FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
  FOREIGN KEY (manager_id) REFERENCES dim_manager(manager_id),
  FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

-- ==================================================
-- 05. DATE SEEDING PROCEDURE
-- ==================================================
DROP PROCEDURE IF EXISTS sp_seed_dim_date;
DELIMITER $$
CREATE PROCEDURE sp_seed_dim_date(IN start_date DATE, IN end_date DATE)
BEGIN
  DECLARE d DATE;
  SET d = start_date;
  WHILE d <= end_date DO
    INSERT IGNORE INTO dim_date(date_value, year, quarter, month, day)
    VALUES (d, YEAR(d), QUARTER(d), MONTH(d), DAY(d));
    SET d = DATE_ADD(d, INTERVAL 1 DAY);
  END WHILE;
END $$
DELIMITER ;

-- Seed dates (last 1 year to next 1 year)
CALL sp_seed_dim_date(DATE_SUB(CURDATE(), INTERVAL 365 DAY), DATE_ADD(CURDATE(), INTERVAL 365 DAY));

-- ==================================================
-- 06. MOVING DATA FROM IMPORTED TABLE → STAGING
-- ==================================================
-- (⚠️ Run this only AFTER you use the Import Wizard and it creates `imported_table`)
ALTER TABLE imported_table
CHANGE COLUMN `ï»¿scheme_name` scheme_name VARCHAR(255);

INSERT INTO stg_mutual_funds (
    scheme_name,
    min_sip,
    min_lumpsum,
    expense_ratio,
    fund_size_cr,
    fund_age_yr,
    fund_manager,
    sortino,
    alpha,
    beta,
    sharpe,
    risk_level,
    amc_name,
    rating,
    category,
    b_category,
    returns_1yr,
    returns_3yr,
    returns_5yr,
    volatile_sd,
    rank_id
)
SELECT
    scheme_name,
    min_sip,
    min_lumpsum,
    expense_ratio,
    fund_size_cr,
    fund_age_yr,
    fund_manager,
    sortino,
    alpha,
    beta,
    sharpe,
    risk_level,
    amc_name,
    rating,
    category,
    sub_category,     -- mapped to b_category
    returns_1yr,
    returns_3yr,
    returns_5yr,
    sd,               -- mapped to volatile_sd
    NULL              -- rank_id (no source column, set NULL)
FROM imported_table;


-- ==================================================
-- 07. VALIDATION
-- ==================================================
SELECT COUNT(*) AS staging_rows FROM stg_mutual_funds;
SELECT * FROM stg_mutual_funds LIMIT 10;
