/*
Sales Performance Dashboard - Profitability analysis
Purpose: Diagnose margin drivers, loss-making products, discount impact, and profit risk.
*/

USE sales_performance_dashboard;

/*
Business purpose:
Profitability segmentation by sales and margin to prioritize strategic action.
*/
WITH product_profitability AS (
    SELECT
        product_id,
        product_name,
        category,
        sub_category,
        SUM(sales) AS sales,
        SUM(profit) AS profit,
        SUM(quantity) AS quantity,
        AVG(discount) AS average_discount
    FROM superstore
    GROUP BY product_id, product_name, category, sub_category
)
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(sales, 2) AS sales,
    ROUND(profit, 2) AS profit,
    ROUND(profit / NULLIF(sales, 0) * 100, 2) AS profit_margin_pct,
    quantity,
    ROUND(average_discount * 100, 2) AS average_discount_pct,
    CASE
        WHEN profit < 0 THEN 'Loss Maker'
        WHEN sales >= 5000 AND profit / NULLIF(sales, 0) >= 0.20 THEN 'Star Product'
        WHEN sales >= 5000 AND profit / NULLIF(sales, 0) < 0.10 THEN 'High Sales Low Margin'
        WHEN sales < 1000 AND profit / NULLIF(sales, 0) >= 0.20 THEN 'Niche Profitable'
        ELSE 'Stable'
    END AS profitability_segment
FROM product_profitability
ORDER BY profit ASC;

/*
Business purpose:
Loss-making products that require pricing, discount, or assortment review.
*/
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit_loss,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct,
    COUNT(DISTINCT order_id) AS orders,
    RANK() OVER (ORDER BY SUM(profit) ASC) AS loss_rank
FROM superstore
GROUP BY product_id, product_name, category, sub_category
HAVING SUM(profit) < 0
ORDER BY profit_loss ASC
LIMIT 25;

/*
Business purpose:
Discount impact analysis showing how discount bands affect profit margin.
*/
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount > 0 AND discount <= 0.10 THEN '0-10%'
        WHEN discount > 0.10 AND discount <= 0.20 THEN '10-20%'
        WHEN discount > 0.20 AND discount <= 0.40 THEN '20-40%'
        ELSE '40%+'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct
FROM superstore
GROUP BY discount_band
ORDER BY MIN(discount);

/*
Business purpose:
Category and region profitability matrix for heatmap visuals.
*/
SELECT
    region,
    category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC) AS profit_rank_in_region
FROM superstore
GROUP BY region, category
ORDER BY region, profit_rank_in_region;

/*
Business purpose:
Reusable Power BI view for profitability segmentation.
*/
CREATE OR REPLACE VIEW vw_profitability_segments AS
WITH product_profitability AS (
    SELECT
        product_id,
        product_name,
        category,
        sub_category,
        SUM(sales) AS sales,
        SUM(profit) AS profit,
        SUM(quantity) AS quantity,
        AVG(discount) AS average_discount
    FROM superstore
    GROUP BY product_id, product_name, category, sub_category
)
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(sales, 2) AS sales,
    ROUND(profit, 2) AS profit,
    ROUND(profit / NULLIF(sales, 0) * 100, 2) AS profit_margin_pct,
    quantity,
    ROUND(average_discount * 100, 2) AS average_discount_pct,
    CASE
        WHEN profit < 0 THEN 'Loss Maker'
        WHEN sales >= 5000 AND profit / NULLIF(sales, 0) >= 0.20 THEN 'Star Product'
        WHEN sales >= 5000 AND profit / NULLIF(sales, 0) < 0.10 THEN 'High Sales Low Margin'
        WHEN sales < 1000 AND profit / NULLIF(sales, 0) >= 0.20 THEN 'Niche Profitable'
        ELSE 'Stable'
    END AS profitability_segment
FROM product_profitability;
