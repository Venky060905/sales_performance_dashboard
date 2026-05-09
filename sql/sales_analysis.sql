-- Sales by Region
SELECT 
    region,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Sales by Category
SELECT 
    category,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Sales by Sub Category
SELECT 
    sub_category,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Monthly Sales Trend
SELECT 
    order_year,
    order_month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM superstore
GROUP BY order_year, order_month
ORDER BY order_year;

-- Top 10 Products
SELECT 
    product_name,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Cities
SELECT 
    city,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;