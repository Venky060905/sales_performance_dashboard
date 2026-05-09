/*
Sales Performance Dashboard - MySQL table design
Purpose: Create a clean, typed production table for the Sample Superstore dataset.
Recommended order:
  1. Run create_table.sql
  2. Run import_data.sql
  3. Run analysis scripts as views or dashboard source queries
*/

CREATE DATABASE IF NOT EXISTS sales_performance_dashboard
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE sales_performance_dashboard;

DROP VIEW IF EXISTS vw_advanced_monthly_trends;
DROP VIEW IF EXISTS vw_profitability_segments;
DROP VIEW IF EXISTS vw_customer_performance;
DROP VIEW IF EXISTS vw_monthly_sales_trend;
DROP VIEW IF EXISTS vw_kpi_summary;

DROP TABLE IF EXISTS superstore_stage;
DROP TABLE IF EXISTS superstore;

/*
Business purpose:
Stage raw CSV values as text first so file import is resilient.
This protects the production table from bad rows, date parsing issues, or CSV formatting problems.
*/
CREATE TABLE superstore_stage (
    row_id VARCHAR(20),
    order_id VARCHAR(30),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(30),
    customer_id VARCHAR(30),
    customer_name VARCHAR(120),
    segment VARCHAR(30),
    country VARCHAR(60),
    city VARCHAR(80),
    state VARCHAR(80),
    postal_code VARCHAR(20),
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(60),
    product_name VARCHAR(255),
    sales VARCHAR(40),
    quantity VARCHAR(20),
    discount VARCHAR(20),
    profit VARCHAR(40),
    profit_margin VARCHAR(40),
    order_year VARCHAR(10),
    order_month VARCHAR(20),
    shipping_days VARCHAR(20)
);

/*
Business purpose:
Production fact table for order-line analytics.
Each row represents one product line in a customer order.
*/
CREATE TABLE superstore (
    row_id INT NOT NULL,
    order_id VARCHAR(30) NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    customer_id VARCHAR(30) NOT NULL,
    customer_name VARCHAR(120) NOT NULL,
    segment VARCHAR(30) NOT NULL,
    country VARCHAR(60) NOT NULL,
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    postal_code VARCHAR(20),
    region VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    category VARCHAR(50) NOT NULL,
    sub_category VARCHAR(60) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    sales DECIMAL(12,4) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(5,4) NOT NULL,
    profit DECIMAL(12,4) NOT NULL,
    profit_margin DECIMAL(8,4),
    order_year SMALLINT NOT NULL,
    order_month VARCHAR(20) NOT NULL,
    shipping_days INT NOT NULL,
    order_month_number TINYINT GENERATED ALWAYS AS (MONTH(order_date)) STORED,
    is_profitable TINYINT GENERATED ALWAYS AS (CASE WHEN profit > 0 THEN 1 ELSE 0 END) STORED,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (row_id),
    CONSTRAINT chk_sales_non_negative CHECK (sales >= 0),
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_discount_range CHECK (discount >= 0 AND discount <= 1),
    CONSTRAINT chk_ship_after_order CHECK (ship_date >= order_date)
);

/*
Business purpose:
Indexes speed up Power BI slicers, KPI cards, trend charts, ranking tables, and drill-through pages.
*/
CREATE INDEX idx_superstore_order_date ON superstore (order_date);
CREATE INDEX idx_superstore_region_category ON superstore (region, category, sub_category);
CREATE INDEX idx_superstore_customer ON superstore (customer_id, customer_name);
CREATE INDEX idx_superstore_product ON superstore (product_id, product_name);
CREATE INDEX idx_superstore_profitability ON superstore (profit, discount);
CREATE INDEX idx_superstore_shipping ON superstore (ship_mode, shipping_days);
CREATE INDEX idx_superstore_year_month ON superstore (order_year, order_month_number);
