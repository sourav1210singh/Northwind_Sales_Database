# Advanced Level (11 Questions)

# 1. Find the Top 5 Most Ordered Products (By Quantity)
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM northwind_order_details
GROUP BY product_id
ORDER BY total_quantity_sold DESC
LIMIT 5;

# 2. Find Yearly Order Trend and Revenue
SELECT 
    YEAR(STR_TO_DATE(order_date, '%Y-%m-%d')) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY order_year
ORDER BY order_year;

# 3. Find the Customer with the Highest Lifetime Value (LTV)
SELECT customer_id, ROUND(SUM(od.unit_price * od.quantity), 2) AS total_spent
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;

# 4. Find the Average Order Value (AOV)
SELECT ROUND(SUM(od.unit_price * od.quantity) / COUNT(DISTINCT od.order_id), 2) AS avg_order_value
FROM northwind_order_details od;

# 5. Find the Most Expensive Shipping Cost per Order
SELECT order_id, freight
FROM northwind_orders
ORDER BY freight DESC
LIMIT 5;

# 6. Monthly Sales Trend Analysis (Using Window Functions)
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, 
       COUNT(*) AS total_orders, 
       ROUND(SUM(freight),2) AS total_freight,
       ROUND(SUM(SUM(freight)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')),2) AS running_total_freight
FROM northwind_orders
GROUP BY order_month
ORDER BY order_month;

# 7. Find the Second-Highest Revenue Generating Order (Using Subquery)
SELECT order_id, total_revenue
FROM (
    SELECT order_id, ROUND(SUM(unit_price * quantity), 2) AS total_revenue
    FROM northwind_order_details
    GROUP BY order_id
    ORDER BY total_revenue DESC
    LIMIT 2
) AS top_2_orders
ORDER BY total_revenue ASC
LIMIT 1;

# 8. Find Customers Who Ordered More Than the Average Order Quantity
SELECT customer_id, COUNT(order_id) AS total_orders
FROM northwind_orders
GROUP BY customer_id
HAVING total_orders > ( SELECT AVG ( order_count ) 
						FROM ( SELECT COUNT(order_id) AS order_count 
							   FROM northwind_orders 
                               GROUP BY customer_id) AS avg_orders )
ORDER BY total_orders DESC;

# 9. Find the Fastest & Slowest Shipped Orders (Using DATEDIFF)
SELECT order_id, order_date, shipped_date, 
       DATEDIFF(shipped_date, order_date) AS shipping_days
FROM northwind_orders
ORDER BY shipping_days;

# 10. Find the Total Discount Given Per Country
SELECT o.ship_country, ROUND(SUM(od.discount_percentage), 2) AS total_discount
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY total_discount DESC;

# 11. Identify Orders with the Highest Revenue Loss Due to Discounts
SELECT order_id, 
       ROUND(SUM(unit_price * quantity), 2) AS original_revenue, 
       ROUND(SUM(unit_price * quantity * (1 - discount_percentage/100)), 2) AS discounted_revenue,
       ROUND(SUM(unit_price * quantity) - SUM(unit_price * quantity * (1 - discount_percentage/100)), 2) AS revenue_loss
FROM northwind_order_details
GROUP BY order_id
ORDER BY revenue_loss DESC
LIMIT 5;