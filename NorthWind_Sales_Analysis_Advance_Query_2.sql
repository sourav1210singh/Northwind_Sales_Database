# Advanced Level (5 Questions)

# 1️. Monthly Sales Trend (Cumulative Revenue)
SELECT 
    month,
    total_orders,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2) AS cumulative_revenue
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(od.unit_price * od.quantity), 2) AS monthly_revenue
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY month
) AS monthly_summary
ORDER BY month;

# 2. Best & Worst Performing Products
SELECT product_id, SUM(quantity) AS total_sold, 
       RANK() OVER (ORDER BY SUM(quantity) DESC) AS sales_rank
FROM northwind_order_details
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

-- (B)Agar sabse bekaar bikne wale products dikhane hain:
SELECT product_id, SUM(quantity) AS total_sold,
RANK() OVER (ORDER BY SUM(quantity) ) AS sales_rank_from_bottom
FROM northwind_order_details
GROUP BY product_id
ORDER BY total_sold Asc
LIMIT 5;

# 3. Employee Performance Analysis
SELECT employee_id, COUNT(order_id) AS total_orders,
       RANK() OVER (ORDER BY COUNT(order_id) DESC) AS performance_rank
FROM northwind_orders
GROUP BY employee_id
ORDER BY total_orders DESC
LIMIT 3;

# 4. Most Popular Shipping Destination
SELECT ship_country, COUNT(order_id) AS total_shipments
FROM northwind_orders
GROUP BY ship_country
ORDER BY total_shipments DESC
LIMIT 3;

# 5. Average Delivery Time Analysis
SELECT 
    ROUND(AVG(DATEDIFF(shipped_date, order_date)), 2) AS avg_delivery_days
FROM northwind_orders
WHERE shipped_date IS NOT NULL;
