/*
Sales Performance Dashboard - Customer analysis
Purpose: Identify best customers, segment behavior, retention signals, and customer concentration.
*/

USE sales_performance_dashboard;

/*
Business purpose:
Top customers by revenue with profit contribution for account prioritization.
*/
SELECT
    customer_id,
    customer_name,
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS orders,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_dense_rank
FROM superstore
GROUP BY customer_id, customer_name, segment
ORDER BY total_sales DESC
LIMIT 25;

/*
Business purpose:
Customer lifetime value style view for Power BI customer drill-through pages.
*/
SELECT
    customer_id,
    customer_name,
    segment,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS customer_tenure_days,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS lifetime_sales,
    ROUND(SUM(profit), 2) AS lifetime_profit,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM superstore
GROUP BY customer_id, customer_name, segment
ORDER BY lifetime_sales DESC;

/*
Business purpose:
Segment-level performance to compare Consumer, Corporate, and Home Office behavior.
*/
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) AS sales_per_customer
FROM superstore
GROUP BY segment
ORDER BY sales DESC;

/*
Business purpose:
Customer concentration analysis showing whether revenue depends heavily on a small customer group.
*/
WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(sales) AS sales
    FROM superstore
    GROUP BY customer_id, customer_name
),
ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        sales,
        ROW_NUMBER() OVER (ORDER BY sales DESC) AS customer_rank,
        SUM(sales) OVER () AS total_sales,
        SUM(sales) OVER (ORDER BY sales DESC) AS cumulative_sales
    FROM customer_sales
)
SELECT
    customer_rank,
    customer_id,
    customer_name,
    ROUND(sales, 2) AS sales,
    ROUND(cumulative_sales, 2) AS cumulative_sales,
    ROUND(cumulative_sales / NULLIF(total_sales, 0) * 100, 2) AS cumulative_sales_pct
FROM ranked_customers
WHERE customer_rank <= 50
ORDER BY customer_rank;

/*
Business purpose:
Reusable Power BI view for customer ranking and drill-through reports.
*/
CREATE OR REPLACE VIEW vw_customer_performance AS
SELECT
    customer_id,
    customer_name,
    segment,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM superstore
GROUP BY customer_id, customer_name, segment;
