/* =========================================================
   SALES DATA ANALYSIS PROJECT
   ========================================================= */

/* =========================================================
   1. OVERALL BUSINESS PERFORMANCE
   ========================================================= */

-- Q1: What is the total revenue, profit, and quantity sold?
SELECT 
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales;

-- Q2: How many total orders were placed?
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales;

-- Q3: What is the average order value (AOV)?
SELECT 
    SUM(sales) / COUNT(DISTINCT order_id) AS avg_order_value
FROM sales;


/* =========================================================
   2. TIME-BASED ANALYSIS
   ========================================================= */

-- Q4: Sales trend by year
SELECT 
    EXTRACT(YEAR FROM TO_DATE(order_date, 'YYYY-MM-DD')) AS year,
    SUM(sales) AS total_sales
FROM sales
GROUP BY year
ORDER BY year;

-- Q5: Monthly sales trend
SELECT 
    EXTRACT(MONTH FROM TO_DATE(order_date, 'YYYY-MM-DD')) AS month,
    SUM(sales) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

-- Q6: Average delivery time
SELECT 
    AVG(TO_DATE(ship_date,'YYYY-MM-DD') - TO_DATE(order_date,'YYYY-MM-DD')) AS avg_delivery_days
FROM sales;


/* =========================================================
   3. CUSTOMER ANALYSIS
   ========================================================= */

-- Q7: Top 10 customers by revenue
SELECT 
    c.customer_name,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Q8: Revenue by customer segment
SELECT 
    c.segment,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
GROUP BY c.segment;

-- Q9: Customer lifetime value (CLV)
SELECT 
    c.customer_name,
    SUM(s.sales) AS lifetime_value
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY lifetime_value DESC;


/* =========================================================
   4. PRODUCT ANALYSIS
   ========================================================= */

-- Q10: Top-selling products
SELECT 
    p.product_name,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Q11: Sales by category
SELECT 
    p.category,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.category;

-- Q12: Profit by sub-category
SELECT 
    p.sub_category,
    SUM(s.profit) AS total_profit
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.sub_category;

-- Q13: Least performing products
SELECT 
    p.product_name,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales ASC
LIMIT 10;


/* =========================================================
   5. GEOGRAPHICAL ANALYSIS
   ========================================================= */

-- Q14: Sales by region
SELECT 
    g.region,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN geography g ON s.geography_key = g.geography_key
GROUP BY g.region;

-- Q15: Profit by country
SELECT 
    g.country,
    SUM(s.profit) AS total_profit
FROM sales s
JOIN geography g ON s.geography_key = g.geography_key
GROUP BY g.country;

-- Q16: Top cities by revenue
SELECT 
    g.city,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN geography g ON s.geography_key = g.geography_key
GROUP BY g.city
ORDER BY total_sales DESC
LIMIT 10;


/* =========================================================
   6. SHIPPING & OPERATIONS
   ========================================================= */

-- Q17: Orders by shipping mode
SELECT 
    ship_mode,
    COUNT(*) AS total_orders
FROM sales
GROUP BY ship_mode;

-- Q18: Average shipping cost by mode
SELECT 
    ship_mode,
    AVG(shipping_cost) AS avg_shipping_cost
FROM sales
GROUP BY ship_mode;

-- Q19: Late deliveries (more than 5 days)
SELECT *
FROM sales
WHERE 
    (TO_DATE(ship_date,'YYYY-MM-DD') - TO_DATE(order_date,'YYYY-MM-DD')) > 5;


/* =========================================================
   7. DISCOUNT & PROFIT ANALYSIS
   ========================================================= */

-- Q20: Discount vs Profit
SELECT 
    discount,
    AVG(profit) AS avg_profit
FROM sales
GROUP BY discount
ORDER BY discount;

-- Q21: Loss-making transactions
SELECT *
FROM sales
WHERE profit < 0;


/* =========================================================
   8. ADVANCED ANALYSIS
   ========================================================= */

-- Q22: Profit margin by category
SELECT 
    p.category,
    SUM(s.profit)/SUM(s.sales)*100 AS profit_margin
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.category;

-- Q23: Running total of sales
SELECT 
    order_date,
    SUM(sales) OVER (ORDER BY TO_DATE(order_date,'YYYY-MM-DD')) AS running_sales
FROM sales;

-- Q24: Rank customers by revenue
SELECT 
    c.customer_name,
    SUM(s.sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(s.sales) DESC) AS rank
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
GROUP BY c.customer_name;

-- Q25: Top product in each category
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(s.sales) AS total_sales,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.sales) DESC) AS rnk
    FROM sales s
    JOIN product p ON s.product_id = p.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rnk = 1;

/* ===================== END OF PROJECT ===================== */