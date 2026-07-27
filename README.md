# 📊 Restaurant Market Analysis & Data Pipeline

## 🎯 Project Objective
This project analyzes a restaurant dataset to identify strategic market opportunities (Gap Analysis). It relies on building a comprehensive data pipeline, structured around a **Medallion Architecture** (Bronze, Silver, Gold), transforming raw data into actionable decision-making indicators ready for visualization.

> **📂 Data Source:** The initial dataset used for this analysis is provided by [Maven Analytics](https://mavenanalytics.io/data-playground/restaurant-ratings).

## 🛠️ Technical Stack
*   **Data Ingestion:** Python (Pandas, SQLAlchemy, dotenv) via VS Code
*   **Language:** SQL (MariaDB / MySQL)
*   **Architecture:** Medallion (Bronze / Silver / Gold)
*   **Business Intelligence:** Tableau Desktop

## 🏗️ Data Architecture

1.  **Bronze Layer (Raw Data):**
    *   Automated data ingestion from local CSV files into a MariaDB database using a secure Python script.
    *   Standardization of column names and documentation comments.
2.  **Silver Layer (Cleaned & Profiled Data):**
    *   Cleaning and strict typing (handling NULLs via `COALESCE()`, conversions via `CAST()`).
    *   Exploratory analysis and profiling of key variables (smokers, accessibility, budget).
3.  **Gold Layer (Data Marts):**
    *   Data denormalization to optimize query performance for the BI tool.
    *   Creation of business-oriented views (`dm_restaurant_performance`, `dm_consumer_behavior`, `dm_market_opportunities`).

## 💡 Key Findings & Business Insights

### 1. Selection Bias & Profiling (The Persona)
Customer analysis revealed a massive selection bias in the sample. The database does not represent the general population, but rather a **highly specific Persona**:
*   **82%** students (under 28 years old).
*   Predominantly single, non-smokers, and reliant on public transportation.
*   Hyper-localized in San Luis Potosi.

### 2. Opportunity Analysis (Gap Analysis)
Analyzing the relationship between supply (restaurants) and demand (ratings and volumes) highlighted two market dynamics:
*   **The Red Ocean (To Avoid):** Mexican restaurants and traditional bars saturate the market with average excellence rates (~41%), diluting profitability.
*   **The Gap (Opportunity):** "Coffee Shop" concepts and "Family/International" spaces enjoy the highest excellence rates (up to 64%) but suffer from a glaring lack of supply. 

### 3. Investment Recommendation
The ideal data-driven restaurant project: 
> A café or small international eatery, located in San Luis Potosi near transit hubs or campuses, 100% smoke-free, with student pricing and a layout conducive to extended working sessions.

## 🚀 How to Use This Repository
1. Set up your `.env` file with your `MARIADB_USER` and `MARIADB_PASSWORD` credentials.
2. Run the Python ingestion script (`scripts/data_ingestion.py`) to load the raw CSV data into the Bronze tables.
3. Execute the scripts in the `sql/01_bronze/` folder to initialize the schema.
4. Apply business transformations via `sql/02_silver/`.
5. Generate the analytical views using `sql/03_gold/`.
6. Connect Tableau Desktop to the silver layers for dashboard creation.
