# 💹 SmartInvest – Mutual Fund Analytics & Insights  

This project delivers **data-driven insights** into mutual funds by identifying the **Top 30 best-performing, low-risk schemes** from a dataset of 2500+ funds.  
The process combines **SQL, Excel, and Power BI** to transform raw financial data into **clear, actionable dashboards**.  

🛠️ **Tech Stack:** SQL (MySQL), Excel, Power BI  
📁 **Dataset Size:** 2500+ Mutual Fund Schemes → Final Top 30 Selection  

---
## 🧠 Project Goal  

To design a **data pipeline** that cleans raw mutual fund data, loads it into a structured **SQL data warehouse**, and visualizes insights through an interactive **Power BI dashboard**.  

---

## 🐍 Python + Excel – Data Preparation  

- Cleaned raw dataset (2500+ schemes)  
- Removed nulls, duplicates, unnecessary columns  
- Standardized numeric values (returns %, expense ratios, fund size)  
- Exported **Top 30 Mutual Funds** to Excel for downstream analysis  

📁 **Output:** [Top 30 Mutual Funds (Excel)](./top_30_mutual_funds.xlsx)  

---

## 🗄️ SQL Data Warehouse Design  

The cleaned data was loaded into **MySQL** and structured using a **star schema** for analytics.  

### 🔹 Database: `mf_analytics`  
- **Staging Table:** `stg_mutual_funds` (raw CSV load)  
- **Dimensions:**  
  - `dim_amc` → Asset Management Companies  
  - `dim_category` → Fund categories & sub-categories  
  - `dim_manager` → Fund managers  
  - `dim_date` → Date dimension (for snapshots)  
- **Fact Table:**  
  - `fact_fund_snapshot` → Core performance & return metrics  

### 🔹 Example KPI Queries  

```sql
-- Top 5 funds by 3-year return
SELECT scheme_name, return_3yr
FROM fact_fund_snapshot
ORDER BY return_3yr DESC
LIMIT 5;

-- AMC with highest AUM
SELECT a.amc_name, SUM(fund_size_cr) AS total_aum
FROM fact_fund_snapshot f
JOIN dim_amc a ON f.amc_id = a.amc_id
GROUP BY a.amc_name
ORDER BY total_aum DESC
LIMIT 1;

-- Risk distribution of funds
SELECT risk_level, COUNT(*) AS fund_count
FROM stg_mutual_funds
GROUP BY risk_level;
```

### SQL Files in Repo:

**01_create_schema.sql** → Database & schema creation

**02_load_staging.sql** → Load raw CSV into staging

**03_transform_star.sql** → Build star schema

**04_views_scoring.sql** → Create analytics-friendly views

**05_kpi_queries.sql** → KPI queries for reporting
## 🐍 Python-Based Fund Analysis

I started by importing and exploring a dataset of over 2500 mutual fund schemes.  
🔗 [Python Script](https://github.com/niravtrivedi23/Mutual-Fund-Analysis/commit/851d5bb1928e3c85b1f22495efb141ed287bf943)

### 1. Data Cleaning
- Removed unnecessary columns
- Handled missing values
- Standardized numeric formats (returns, expense ratios)

### 2. Data Description & Understanding
- Statistical summaries using Pandas: mean, median, mode, min, max, std deviation
- Analyzed fund distributions across return rates, risk levels, and fund age

### 3. Data Normalization
- Used `MinMaxScaler` from `sklearn.preprocessing` to normalize numeric fields
- Compared returns and expense ratios on a common scale

### 4. Fund Scoring & Ranking
Custom scoring formula based on:
- High 3-Year Returns  
- Low Expense Ratio  
- Moderate Fund Age  
- Consistent 1-Year Return > 0

### 5. Final Output – Top 30 Funds
Extracted the **Top 30 Mutual Funds** with best return-low risk balance  
🔗 [Top 30 Mutual Funds (Excel)](https://github.com/niravtrivedi23/Mutual-Fund-Analysis/blob/main/top_30_mutual_funds.xlsx)

---

## 📈 Power BI Dashboard – Mutual Fund Insights

After processing the data using Python and Excel, I built an **interactive dashboard** in Power BI.  
🔗 [Power BI Dashboard File (.pbix)](https://github.com/niravtrivedi23/Mutual-Fund-Analysis/blob/main/Mutual%20Fund%20Dashboard.pbix)  
🔗 [Dashboard Preview Image](https://github.com/niravtrivedi23/Mutual-Fund-Analysis/blob/main/Mutual%20Fund%20Dashboard%20.png)

### 📌 Key Features

#### 📅 Dynamic Filters
- Filter by Fund Type, Category, Sub-category, AMC Name, Risk Level, Fund Rating

#### 📊 Key Visuals & KPIs
- 💼 **Total Investment by Fund Type:** AUM across Equity, Debt, Hybrid, etc.  
- 🔁 **SIP vs Lumpsum Summary Cards:** Monthly SIP trends and minimum lump sum amounts  
- 🧾 **Expense Ratio Comparison:** By Investment Strategy and Sub-Category  
- 📈 **3-Year Returns (Donut Chart):** Category-wise long-term returns  
- 🏆 **Top Performing AMCs:** Average return and AUM  
- 👤 **Fund Manager AUM Comparison:** Largest fund managers by assets  
- 🧠 **Insight Cards:** Auto-generated insights with simple explanations

---

## 🔍 Mutual Fund Investment Insights

| Insight Category | Summary |
|------------------|---------|
| 💼 **Investment Trends** | Equity Funds lead with ₹1.35M Cr total size |
| 👤 **Fund Manager** | Vivek Sharma manages highest AUM: ₹7.3M Cr |
| 📉 **Cost vs Return** | Index Funds have lowest expense ratio: 0.26% |
| 🏦 **Best Return (1Y)** | Bank of India Mutual Fund: 14.4% |
| 🔄 **SIP vs Lumpsum** | Avg. SIP: ₹528.50/month, Lumpsum Min: ₹3.05K |
| ⏳ **3-Year Returns** | Equity Funds: 37.84%, Hybrid: 14.25% |

---

## 🖼️ Dashboard Preview

![Mutual Fund Dashboard Preview](https://github.com/niravtrivedi23/Mutual-Fund-Analysis/blob/main/Mutual%20Fund%20Dashboard%20.png)

---

### 🧠 Final Conclusion – See the Power of Investment

Through this project and dashboard, you can clearly see the **power of investing in mutual funds** when guided by data-driven insights.

By analyzing returns, expense ratios, risk levels, and fund manager performance, I’ve shown how even basic financial knowledge, supported by visual tools, can help improve financial decisions.

💡 This dashboard isn't just about numbers—it's about empowering people to make **smarter, low-risk investments** and take control of their financial future.
Early and informed mutual fund investment leads to **long-term wealth creation**.  
By combining:
- Python for filtering,
- Excel for cleaning,
- Power BI for storytelling,

I created a tool that helps both beginners and experts make **data-driven, low-risk, high-reward decisions**.

---

## 🔧 Tool Summary

| Tool   | Purpose |
|--------|---------|
| Python | Data cleaning, scoring, filtering top 30 funds |
| Excel  | Formatting, validation, supporting data |
| Power BI | Interactive dashboard and visual storytelling |
|   SQL    |Data warehouse design, KPI queries |

---

| File                         | Description                   |
| ---------------------------- | ----------------------------- |
| `top_30_mutual_funds.xlsx`   | Final top 30 filtered funds   |
| `01_create_schema.sql`       | Schema creation script        |
| `02_load_staging.sql`        | Load staging table script     |
| `03_transform_star.sql`      | Transform data to star schema |
| `04_views_scoring.sql`       | Views for analysis            |
| `05_kpi_queries.sql`         | KPI queries                   |
| `Mutual Fund Dashboard.pbix` | Power BI dashboard            |
| `Mutual Fund Dashboard.png`  | Dashboard preview image       |


---

✅ **Feel free to fork, explore, and contribute!**

### 🙌 Feedback Welcome


Your feedback helps me grow and build better data-driven solutions. Let’s connect and discuss ideas!
