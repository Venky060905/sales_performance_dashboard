/*
Sales Performance Dashboard - Executive KPI queries
Purpose: Create reliable headline metrics for Power BI cards and scorecards.
*/

USE sales_performance_dashboard;

/*
Business purpose:
Executive overview for KPI cards: revenue, profit, order volume, average order value, margin, and discount.
*/
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct,
    ROUND(AVG(shipping_days), 2) AS average_shipping_days
FROM superstore;

/*
Business purpose:
Annual KPI scorecard for trend comparison and year slicers.
*/
SELECT
    order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM superstore
GROUP BY order_year
ORDER BY order_year;

/*
Business purpose:
Year-over-year KPI movement for executive insight cards.
*/
WITH annual_kpis AS (
    SELECT
        order_year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM superstore
    GROUP BY order_year
)
SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_sales - LAG(total_sales) OVER (ORDER BY order_year), 2) AS sales_yoy_change,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY order_year))
        / NULLIF(LAG(total_sales) OVER (ORDER BY order_year), 0) * 100, 2) AS sales_yoy_pct,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(total_profit - LAG(total_profit) OVER (ORDER BY order_year), 2) AS profit_yoy_change,
    ROUND((total_profit - LAG(total_profit) OVER (ORDER BY order_year))
        / NULLIF(LAG(total_profit) OVER (ORDER BY order_year), 0) * 100, 2) AS profit_yoy_pct,
    total_orders,
    total_orders - LAG(total_orders) OVER (ORDER BY order_year) AS orders_yoy_change
FROM annual_kpis
ORDER BY order_year;

/*
Business purpose:
Profit health KPI showing how much revenue comes from profitable vs loss-making order lines.
*/
SELECT
    CASE
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit = 0 THEN 'Break-even'
        ELSE 'Loss-making'
    END AS profitability_status,
    COUNT(*) AS line_items,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(sales) / NULLIF((SELECT SUM(sales) FROM superstore), 0) * 100, 2) AS sales_share_pct
FROM superstore
GROUP BY profitability_status
ORDER BY profit;

/*
Business purpose:
Create a reusable Power BI source view for KPI cards.
*/
CREATE OR REPLACE VIEW vw_kpi_summary AS
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct,
    ROUND(AVG(shipping_days), 2) AS average_shipping_days
FROM superstore;
