# Sales Performance Dashboard

Portfolio project using Python, MySQL, SQL, and Power BI to analyze the Sample Superstore dataset.

## Folder Structure

```text
dataset/
  raw/                 Original Sample Superstore file
  cleaned/             Cleaned CSV used for MySQL import
notebooks/             Python cleaning and exploratory analysis
sql/                   MySQL database, import, KPI, and analysis scripts
dashboard/             Power BI dashboard files
images/                Dashboard screenshots and project visuals
```

## SQL Workflow

Run the SQL scripts in this order:

1. `sql/create_table.sql` creates the `sales_performance_dashboard` database, a resilient `superstore_stage` table, a typed `superstore` production table, constraints, generated columns, and indexes.
2. `sql/import_data.sql` loads `dataset/cleaned/superstore_cleaned.csv` with `LOAD DATA LOCAL INFILE`, validates the staging data, and inserts clean rows into the production table.
3. `sql/kpi_queries.sql` builds executive KPI outputs and the `vw_kpi_summary` Power BI view.
4. `sql/sales_analysis.sql` analyzes monthly trends, running totals, category mix, seasonality, state performance, and regional performance.
5. `sql/customer_analysis.sql` identifies top customers, segment performance, customer tenure, and revenue concentration.
6. `sql/profitability_analysis.sql` detects loss-making products, discount impact, margin leakage, and product profitability segments.
7. `sql/advanced_queries.sql` adds rolling trends, year-over-year sales, ABC product classification, rank gaps, and shipping analysis.

For CSV import, SQLTools may require local infile support in the MySQL connection. If `LOAD DATA LOCAL INFILE` is blocked, check `SHOW VARIABLES LIKE 'local_infile';` and enable local infile in the client connection.

A runnable helper script is included at `import_data.js` and works with mysql2 v2.0+ by using `localInfile: true` and `streamFactory`.

Install dependencies and run the import with:

```bash
npm install
npm run import-data
```

You can configure the database connection with environment variables:

- `DB_HOST`
- `DB_PORT`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`

If LOCAL INFILE is still unavailable, copy the CSV into the folder returned by `SHOW VARIABLES LIKE 'secure_file_priv';` and use the server-side `LOAD DATA INFILE` option in `sql/import_data.sql`.

## Database Design

The model uses one production fact table: `superstore`.

Grain: one row per order line item.

Key fields:

- Date fields: `order_date`, `ship_date`, `order_year`, `order_month_number`
- Customer fields: `customer_id`, `customer_name`, `segment`
- Product fields: `product_id`, `product_name`, `category`, `sub_category`
- Geography fields: `country`, `region`, `state`, `city`, `postal_code`
- Measures: `sales`, `quantity`, `discount`, `profit`, `profit_margin`, `shipping_days`

Indexes are added for date trends, customer drill-through, product analysis, regional slicing, profitability analysis, and shipping analysis.

## KPI Calculations

- Total Sales: `SUM(sales)`
- Total Profit: `SUM(profit)`
- Profit Margin %: `SUM(profit) / SUM(sales) * 100`
- Total Orders: `COUNT(DISTINCT order_id)`
- Active Customers: `COUNT(DISTINCT customer_id)`
- Average Order Value: `SUM(sales) / COUNT(DISTINCT order_id)`
- Average Discount %: `AVG(discount) * 100`
- Average Shipping Days: `AVG(shipping_days)`
- Year-over-Year Sales %: current period sales compared with prior year sales using `LAG()`

## Business Insights

- Discounting should be monitored closely because high discount bands can generate strong sales while reducing margin.
- Loss-making products should be reviewed for pricing, promotion rules, supplier cost, or removal from campaigns.
- Regional performance should be measured by both sales and profit because high revenue regions may not always produce the best margin.
- Top customers are useful for retention and account management, but customer concentration should be tracked to reduce dependency risk.
- Shipping modes can be compared by order volume, delivery speed, and profitability to identify fulfillment trade-offs.
- Category and sub-category ranking helps separate growth categories from low-margin product groups.

## Power BI Dashboard Recommendations

Suggested pages:

- Executive Overview: KPI cards, monthly sales trend, profit margin trend, regional sales map, category sales mix.
- Sales Performance: monthly running totals, year-over-year sales, sub-category rankings, state leaderboard.
- Customer Insights: top customers, segment performance, customer lifetime sales, customer concentration curve.
- Profitability: loss-making products, discount impact, profitability segments, region-category margin heatmap.
- Shipping & Operations: ship mode comparison, average shipping days, shipping speed rank, sales by shipping mode.
- Product Portfolio: ABC classification, top products, high-sales low-margin products, category drill-through.

Recommended visuals:

- KPI cards for total sales, profit, margin, orders, customers, and average order value.
- Line chart for monthly sales and rolling 3-month sales.
- Combo chart for sales and profit margin by month.
- Matrix heatmap for region vs category profit margin.
- Bar charts for top customers, top products, and loss-making products.
- Map visual for state-level sales and profit.
- Scatter plot for discount vs profit margin.
- Decomposition tree for profit drivers by region, category, customer segment, and ship mode.

## SQL Best Practices Used

- Load raw CSV into a staging table before inserting into production.
- Use typed columns for reliable calculations.
- Use `NULLIF()` to avoid divide-by-zero errors in margin metrics.
- Add constraints for sales, quantity, discount, and shipping date quality.
- Add indexes aligned with dashboard filters and joins.
- Use window functions such as `RANK()`, `DENSE_RANK()`, `LAG()`, running totals, and rolling averages.
- Create reusable views for Power BI instead of duplicating logic in reports.

## Advanced Analytics Ideas

- Build a star schema with dimension tables for date, customer, product, geography, and shipping.
- Add Python forecasting for monthly sales using Prophet, ARIMA, or scikit-learn.
- Create customer segmentation using RFM analysis.
- Detect discount outliers and margin leakage using statistical thresholds.
- Build a Power BI what-if parameter for discount reduction scenarios.
- Add incremental refresh in Power BI using `order_date`.
- Automate the CSV-to-MySQL pipeline with Python and scheduled jobs.
- Add dbt-style SQL tests for row counts, uniqueness, accepted values, and non-null fields.
