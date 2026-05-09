-- Rank Customers by Sales
SELECT 
    customer_name,
    ROUND(SUM(sales),2) AS total_sales,

    RANK() OVER(
        ORDER BY SUM(sales) DESC
    ) AS sales_rank

FROM superstore
GROUP BY customer_name;

-- Running Total Sales
SELECT 
    order_date,
    ROUND(SUM(sales),2) AS daily_sales,

    ROUND(
        SUM(SUM(sales)) OVER(
            ORDER BY order_date
        ),2
    ) AS running_total_sales

FROM superstore
GROUP BY order_date;

-- Year-over-Year Sales
SELECT 
    order_year,
    ROUND(SUM(sales),2) AS yearly_sales,

    LAG(SUM(sales)) OVER(
        ORDER BY order_year
    ) AS previous_year_sales

FROM superstore
GROUP BY order_year;

-- Profitability Category
SELECT 
    product_name,
    profit,

    CASE
        WHEN profit > 500 THEN 'High Profit'
        WHEN profit > 0 THEN 'Medium Profit'
        ELSE 'Loss'
    END AS profit_category

FROM superstore;

-- Shipping Performance
SELECT 
    ship_mode,
    ROUND(AVG(shipping_days),2) AS avg_shipping_days
FROM superstore
GROUP BY ship_mode;

-- Top Products per Category
SELECT *
FROM (
    SELECT 
        category,
        product_name,
        ROUND(SUM(sales),2) AS total_sales,

        RANK() OVER(
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS product_rank

    FROM superstore
    GROUP BY category, product_name
) ranked_products

WHERE product_rank <= 3;