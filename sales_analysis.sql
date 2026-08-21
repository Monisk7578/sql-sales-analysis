USE sales_analysis;

-- =====================================================
-- SQL-BASED SALES ANALYSIS
-- =====================================================


-- 1. TOTAL SALES
SELECT
    COUNT(*) AS total_orders
FROM sales;


-- 2. TOTAL UNITS SOLD
SELECT
    SUM(quantity) AS total_units_sold
FROM sales;


-- 3. TOTAL REVENUE
SELECT
    ROUND(
        SUM(
            quantity * unit_price *
            (1 - discount / 100)
        ),
        2
    ) AS total_revenue
FROM sales;


-- 4. SALES SUMMARY
SELECT
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units_sold,

    ROUND(
        SUM(quantity * unit_price),
        2
    ) AS gross_revenue,

    ROUND(
        SUM(
            quantity * unit_price *
            (1 - discount / 100)
        ),
        2
    ) AS net_revenue,

    ROUND(AVG(discount), 2) AS average_discount

FROM sales;


-- 5. REVENUE BY PRODUCT CATEGORY
SELECT
    p.category,

    COUNT(s.sale_id) AS total_orders,

    SUM(s.quantity) AS units_sold,

    ROUND(
        SUM(
            s.quantity *
            s.unit_price *
            (1 - s.discount / 100)
        ),
        2
    ) AS revenue

FROM sales s

JOIN products p
    ON s.product_id = p.product_id

GROUP BY p.category

ORDER BY revenue DESC;


-- 6. TOP 10 PRODUCTS
SELECT
    p.product_id,
    p.product_name,
    p.category,

    SUM(s.quantity) AS units_sold,

    ROUND(
        SUM(
            s.quantity *
            s.unit_price *
            (1 - s.discount / 100)
        ),
        2
    ) AS revenue

FROM sales s

JOIN products p
    ON s.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category

ORDER BY revenue DESC

LIMIT 10;


-- 7. REVENUE BY SALES CHANNEL
SELECT
    sales_channel,

    COUNT(*) AS total_orders,

    SUM(quantity) AS units_sold,

    ROUND(
        SUM(
            quantity *
            unit_price *
            (1 - discount / 100)
        ),
        2
    ) AS revenue

FROM sales

GROUP BY sales_channel

ORDER BY revenue DESC;


-- 8. REVENUE BY PAYMENT METHOD
SELECT
    payment_method,

    COUNT(*) AS total_orders,

    ROUND(
        SUM(
            quantity *
            unit_price *
            (1 - discount / 100)
        ),
        2
    ) AS revenue

FROM sales

GROUP BY payment_method

ORDER BY revenue DESC;


-- 9. MONTHLY REVENUE TREND
SELECT
    YEAR(sale_date) AS sales_year,
    MONTH(sale_date) AS sales_month,

    ROUND(
        SUM(
            quantity *
            unit_price *
            (1 - discount / 100)
        ),
        2
    ) AS revenue

FROM sales

GROUP BY
    YEAR(sale_date),
    MONTH(sale_date)

ORDER BY
    sales_year,
    sales_month;


-- 10. CUSTOMER SPENDING
SELECT
    c.customer_id,
    c.customer_name,

    COUNT(s.sale_id) AS total_orders,

    SUM(s.quantity) AS total_units,

    ROUND(
        SUM(
            s.quantity *
            s.unit_price *
            (1 - s.discount / 100)
        ),
        2
    ) AS total_spent

FROM customers c

JOIN sales s
    ON c.customer_id = s.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_spent DESC;


-- 11. TOP CUSTOMERS USING RANK
WITH customer_spending AS (

    SELECT
        c.customer_id,
        c.customer_name,

        SUM(
            s.quantity *
            s.unit_price *
            (1 - s.discount / 100)
        ) AS total_spent

    FROM customers c

    JOIN sales s
        ON c.customer_id = s.customer_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_id,
    customer_name,

    ROUND(total_spent, 2) AS total_spent,

    DENSE_RANK() OVER (
        ORDER BY total_spent DESC
    ) AS customer_rank

FROM customer_spending

ORDER BY customer_rank;


-- 12. TOP PRODUCTS WITHIN EACH CATEGORY
WITH product_revenue AS (

    SELECT
        p.product_id,
        p.product_name,
        p.category,

        SUM(
            s.quantity *
            s.unit_price *
            (1 - s.discount / 100)
        ) AS revenue

    FROM sales s

    JOIN products p
        ON s.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name,
        p.category
),

ranked_products AS (

    SELECT
        product_id,
        product_name,
        category,
        revenue,

        RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS category_rank

    FROM product_revenue
)

SELECT
    product_id,
    product_name,
    category,

    ROUND(revenue, 2) AS revenue,

    category_rank

FROM ranked_products

WHERE category_rank <= 3

ORDER BY
    category,
    category_rank;


-- 13. MONTH-OVER-MONTH REVENUE
WITH monthly_revenue AS (

    SELECT
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,

        SUM(
            quantity *
            unit_price *
            (1 - discount / 100)
        ) AS revenue

    FROM sales

    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
)

SELECT
    sales_year,
    sales_month,

    ROUND(revenue, 2) AS revenue,

    ROUND(
        LAG(revenue) OVER (
            ORDER BY sales_year, sales_month
        ),
        2
    ) AS previous_month_revenue

FROM monthly_revenue

ORDER BY
    sales_year,
    sales_month;


-- 14. CUSTOMER SEGMENTATION
WITH customer_spending AS (

    SELECT
        customer_id,

        SUM(
            quantity *
            unit_price *
            (1 - discount / 100)
        ) AS total_spent

    FROM sales

    GROUP BY customer_id
)

SELECT
    customer_id,

    ROUND(total_spent, 2) AS total_spent,

    CASE
        WHEN total_spent >= 100000
            THEN 'High Value'

        WHEN total_spent >= 50000
            THEN 'Medium Value'

        ELSE 'Low Value'

    END AS customer_segment

FROM customer_spending

ORDER BY total_spent DESC;