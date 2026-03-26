<img width="1001" height="656" alt="Zrzut ekranu 2026-03-26 o 17 53 15" src="https://github.com/user-attachments/assets/749dee12-026b-4ddd-85ce-f54264af84ca" />

##Brazilian E-Commerce Analytics (Olist)
This repository contains a comprehensive data analysis project focused on customer behavior, retention, and financial performance using a Brazilian e-commerce dataset. The project was developed to showcase a full-cycle analytical process, from raw data engineering in a relational database to business intelligence visualization.

##Project Objectives

The main goal of this analysis was to process raw transactional data to identify valuable customer segments, measure loyalty, and track long-term revenue dynamics. Key objectives included:

Cleaning and structuring raw relational datasets (orders, customers, and payments).

Segmenting customers based on their monetary value and assigning VIP percentiles.

Analyzing customer loyalty and retention by calculating the time elapsed between repeat purchases.

Building an interactive financial dashboard to track monthly revenue, moving averages, and growth metrics.

##Tools & Technologies Used

Database: PostgreSQL (via DBeaver)

Language: SQL (Window Functions, CTEs, Advanced Aggregations, Time-series calculations)

Visualization: Tableau Public

##Key Analytical Steps

Data Engineering: Transformation of raw order data using ROW_NUMBER() to establish chronological purchase histories for unique customers.

Customer Segmentation: Application of PERCENT_RANK() to rank users by total spend and identify top-tier consumers.

Retention Analysis: Utilization of the LEAD() window function to calculate the exact number of days between consecutive orders for returning customers.

Financial Metrics Calculation: Aggregation of revenue into monthly intervals to compute running totals, month-over-month (MoM) growth using LAG(), and a 3-month rolling average.

Dashboard Creation: Visual analysis in Tableau combining bar charts and dual-axis line graphs to present revenue trends and growth patterns to business stakeholders.
