# SQL-Based Sales Analysis

## 📌 Project Overview

This project analyzes sales transaction data using MySQL to identify revenue trends, customer purchasing behavior, product performance, and sales-channel performance.

The analysis was performed on a MySQL database containing 5,000+ sales transactions.

## 🛠️ Technologies Used

- MySQL
- SQL
- MySQL Workbench
- GitHub

## 🗄️ Database Structure

The project contains three main tables:

### Customers
Contains customer information such as:

- Customer ID
- Customer Name
- Email
- City
- State
- Region
- Signup Date

### Products

Contains:

- Product ID
- Product Name
- Category
- Unit Price

### Sales

Contains:

- Sale ID
- Customer ID
- Product ID
- Sale Date
- Quantity
- Unit Price
- Discount
- Payment Method
- Sales Channel

## 📊 Dataset

| Table | Records |
|---|---:|
| Customers | 100 |
| Products | 50 |
| Sales | 5,000+ |

## 🔍 SQL Analysis Performed

### Sales & Revenue Analysis

- Total sales transactions
- Total units sold
- Gross revenue
- Net revenue
- Average discount
- Monthly revenue trends

### Product Analysis

- Top-performing products
- Revenue by product category
- Units sold by product
- Top 3 products within each category

### Customer Analysis

- Customer spending
- Top customers
- Customer ranking
- Customer segmentation
- Average customer spending

### Sales Channel Analysis

- Revenue by sales channel
- Orders by sales channel
- Revenue by payment method

## 🧠 Advanced SQL Techniques

This project demonstrates:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate Functions
- INNER JOIN
- Subqueries
- Common Table Expressions (CTEs)
- CASE statements
- RANK()
- DENSE_RANK()
- LAG()
- Window Functions

## 💡 Business Questions Answered

1. What is the total revenue generated?
2. Which product categories generate the highest revenue?
3. Which products are the top performers?
4. Which customers contribute the most revenue?
5. Which sales channel performs best?
6. Which payment method is most frequently used?
7. How does revenue change month over month?
8. Who are the high-value customers?
9. What are the top 3 products in each category?

## 📈 Key Business Insights

The analysis can be used to identify:

- High-performing products and categories
- High-value customers
- Revenue growth patterns
- Sales-channel performance
- Customer purchasing behavior

## 📂 Project Structure

```text
SQL-Based-Sales-Analysis/
│
├── README.md
├── database.sql
└── sales_analysis.sql