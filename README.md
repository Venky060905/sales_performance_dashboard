# 📊 Sales Performance Dashboard | SQL + MySQL + Tableau

An interactive Business Intelligence dashboard built using **Tableau, MySQL, SQL, Python, and Node.js** to analyze sales performance, profitability, customer behavior, and regional trends using the Sample Superstore dataset.

This project demonstrates a complete end-to-end Data Analytics workflow — from raw data cleaning to SQL analysis and interactive dashboard visualization.

---

# 🚀 Live Dashboard

🔗 Tableau Public Dashboard
https://public.tableau.com/app/profile/venkatesh.kothamasu/viz/sales_17785529348890/Dashboard1?publish=yes

---

# 📌 Project Overview

The goal of this project is to transform raw retail sales data into actionable business insights through:

* Data Cleaning
* SQL-based Analysis
* KPI Tracking
* Executive Dashboard Design
* Interactive Visual Analytics

The dashboard helps business users monitor:

* Revenue growth
* Profitability
* Product performance
* Regional sales
* Customer segments
* Discount impact

---

# 🛠️ Tech Stack

| Technology      | Purpose                     |
| --------------- | --------------------------- |
| Tableau         | Dashboard Development       |
| MySQL           | Database Management         |
| SQL             | Data Analysis & KPI Queries |
| Python (Pandas) | Data Cleaning               |
| Node.js         | CSV Import Automation       |
| VS Code         | Development Environment     |

---

# 📂 Project Structure

```text id="r1"
sales_performance_dashboard/
│
├── dataset/
│   ├── raw/
│   └── cleaned/
│
├── notebooks/
│   └── data_cleaning.ipynb
│
├── sql/
│   ├── create_table.sql
│   ├── import_data.sql
│   ├── kpi_queries.sql
│   ├── sales_analysis.sql
│   ├── customer_analysis.sql
│   ├── profitability_analysis.sql
│   └── advanced_queries.sql
│
├── tableau/
│   └── Sales_analysis.twbx
│
├── images/
│   └── dashboard_preview.png
│
├── import_data.js
└── README.md
```

---

# 📊 Dashboard Features

## Executive KPI Cards

* 💰 Total Sales
* 📈 Total Profit
* 🛒 Total Orders
* 📊 Profit Margin %

## Interactive Filters

* Region
* Category
* Segment
* Order Year

## Visual Analytics

* Monthly Sales Trend
* Sales by Category
* Sales by Region
* Top 10 Products
* Profit by Region
* Discount vs Profit Analysis

---

# 🗄️ Database Workflow

## 1️⃣ Create Database & Tables

Run:

```sql id="r2"
create_table.sql
```

This script:

* Creates the MySQL database
* Creates production & staging tables
* Adds indexes and constraints

---

## 2️⃣ Import Cleaned Dataset

Run:

```bash id="r3"
node import_data.js
```

This imports the cleaned CSV dataset into MySQL automatically.

---

## 3️⃣ Execute SQL Analysis Files

```sql id="r4"
kpi_queries.sql
sales_analysis.sql
customer_analysis.sql
profitability_analysis.sql
advanced_queries.sql
```

These scripts generate:

* KPI metrics
* Customer insights
* Profitability analysis
* Sales trends
* Advanced SQL analytics

---

# 📈 Key Business Insights

* Technology generated the highest overall sales revenue.
* West region delivered the highest profitability.
* High discount levels negatively impacted profit margins.
* A small number of products contributed significantly to total sales.
* Monthly sales showed strong seasonal patterns.

---

# 📌 SQL Concepts Used

* Aggregate Functions
* Window Functions
* CTEs (Common Table Expressions)
* Ranking Functions
* Views
* CASE Statements
* Joins
* Date Functions
* KPI Calculations

---

# 📌 Tableau Features Used

* Interactive Dashboards
* Floating Layout Design
* KPI Cards
* Scatter Plots
* Line Charts
* Bar Charts
* Dashboard Filters
* Data Formatting
* Executive Dashboard Styling

---

# 📷 Dashboard Preview

*Add dashboard screenshot here*

---

# 🎯 Business Problems Solved

✅ Sales trend analysis
✅ Regional performance comparison
✅ Profitability tracking
✅ Discount impact analysis
✅ Product performance analysis
✅ Executive KPI monitoring
✅ Interactive business reporting

---

# ⚡ Future Enhancements

* Forecasting & Predictive Analytics
* Customer Segmentation (RFM Analysis)
* Real-Time Database Integration
* Mobile Responsive Dashboard
* AI-powered Insights

---

# 👨‍💻 Author

## Venkatesh Kothamasu

Aspiring Data Analyst & Business Intelligence Developer

### Skills

* SQL
* Tableau
* Python
* MySQL
* Data Visualization
* Business Intelligence

---

# ⭐ Why This Project Stands Out

✅ End-to-End Data Analytics Workflow
✅ SQL + Tableau Integration
✅ Real Business Intelligence Use Case
✅ Interactive Executive Dashboard
✅ Public Deployment on Tableau Public
✅ Portfolio & Resume Ready
