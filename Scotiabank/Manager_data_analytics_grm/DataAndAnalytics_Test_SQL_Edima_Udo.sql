/*
OBJECTIVE 
- CREATE/UPDATE PRODUCT RISK TABLE WITH CATEGORICAL VARIABLES FOR ANALYSIS
USING THE DATA PROVIDED.

ASSUMPTIONS 
- DB ALREADY EXISTS IN SQL SERVER
- XLSX DATASET WILL BE TRANSFORMED TO CSV BEFORE LOADING TABLE
*/


### SETUP STAGING TABLE
DROP TABLE IF EXISTS staging_product_risk;

CREATE TABLE staging_product_risk (
    Seq_num        INTEGER,          -- Unique record identifier
    ProductF       VARCHAR(20),       -- Product type (Card / Line)
    Delq           VARCHAR(10),       -- Delinquency status (CURR, D031, etc.)
    StRollF        VARCHAR(5),        -- 'Yes' if past 4 months unpaid
    Score          VARCHAR(10),       -- Risk score, 'NA' allowed
    OpenDt         DATE,
    BirthDt        DATE,
    Acct_stat_cd   VARCHAR(10),
    Province       VARCHAR(50),
    Limit          DECIMAL(18,2),
    Balance        DECIMAL(18,2),
    Date           DATE               -- Observation date
);


### LOAD DATA INTO STAGING TABLE
COPY INTO staging_product_risk
FROM 'path/to/DataTest.csv'  ### UPDATE THE PATH
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1
);


### SETUP PRODUCT RISK TABLE
DROP TABLE IF EXISTS product_risk_table;

CREATE TABLE product_risk_table AS
SELECT
    Seq_num,
    ProductF        AS product_type,
    Delq            AS delinquency_code,
    StRollF         AS severe_roll_flag,
    Score,
    OpenDt          AS account_open_date,
    BirthDt         AS birth_date,
    Acct_stat_cd    AS account_status,
    Province,
    Limit           AS credit_limit,
    Balance,
    Date            AS observation_date
FROM staging_product_risk;


### CREATE CATEGORICAL VARIABLES
DROP TABLE IF EXISTS risk_analytics_enriched;

CREATE TABLE risk_analytics_enriched AS
SELECT
    Seq_num,
    product_type,
    province,
    account_status,
    observation_date,

    # CORE METRICS
    credit_limit,
    balance,
    CASE 
        WHEN credit_limit > 0 THEN balance / credit_limit
        ELSE 0
    END AS utilization_pct,

    # CREDIT RISK CATEGORIES
    CASE
        WHEN credit_limit > 0 AND balance / credit_limit < 0.30 THEN 'Low Utilization (<30%)'
        WHEN credit_limit > 0 AND balance / credit_limit BETWEEN 0.30 AND 0.70 THEN 'Medium Utilization (30-70%)'
        WHEN credit_limit > 0 AND balance / credit_limit > 0.70 THEN 'High Utilization (>70%)'
        ELSE 'Unknown'
    END AS utilization_band,

    CASE
        WHEN delinquency_code = 'CURR' THEN 'Current'
        WHEN delinquency_code = 'D001' THEN '1–30 DPD'
        WHEN delinquency_code = 'D031' THEN '31–60 DPD'
        WHEN delinquency_code = 'D061' THEN '61–90 DPD'
        WHEN delinquency_code = 'D091' THEN '91–120 DPD'
        WHEN delinquency_code = 'D121' THEN '121–150 DPD'
        WHEN delinquency_code = 'D151' THEN '150+ DPD'
        ELSE 'Unknown'
    END AS delinquency_bucket,

    CASE
        WHEN severe_roll_flag = 'Yes' THEN 'Severe Roll (4+ Months)'
        ELSE 'No Severe Roll'
    END AS roll_severity_flag,

    # SCORE SEGMENTATION
    CASE
        WHEN Score = 'NA' THEN 'Score Not Available'
        WHEN CAST(Score AS INTEGER) < 600 THEN 'High Risk'
        WHEN CAST(Score AS INTEGER) BETWEEN 600 AND 699 THEN 'Medium Risk'
        WHEN CAST(Score AS INTEGER) >= 700 THEN 'Low Risk'
        ELSE 'Unknown'
    END AS score_band,

    # ACCOUNT TENURE
    CASE
        WHEN DATE_DIFF(observation_date, account_open_date) < 180 THEN 'New (<6M)'
        WHEN DATE_DIFF(observation_date, account_open_date) BETWEEN 180 AND 730 THEN 'Mid (6M–2Y)'
        ELSE 'Tenured (2Y+)'
    END AS tenure_segment,
    # AGE SEGMENT
    CASE
        WHEN DATE_DIFF(observation_date, birth_date) / 365 < 30 THEN '<30'
        WHEN DATE_DIFF(observation_date, birth_date) / 365 BETWEEN 30 AND 49 THEN '30–49'
        ELSE '50+'
    END AS age_band

FROM product_risk_table;

