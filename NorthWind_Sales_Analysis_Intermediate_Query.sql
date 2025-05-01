# Intermediate Level (11 Questions)

# 1. Most Frequently Used Shipping Method (ship_via)
SELECT ship_via, COUNT(*) AS total_shipments
FROM northwind_orders
GROUP BY ship_via
ORDER BY total_shipments DESC
LIMIT 3;

# 2️ Top 3 Customers with Most Orders
SELECT customer_id, COUNT(*) AS total_orders
FROM northwind_orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 3;

# 3. Total Revenue Per Order
SELECT od.order_id, ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
FROM northwind_order_details od
GROUP BY od.order_id
ORDER BY total_revenue DESC;

# 4️. Most Expensive Order (Highest Revenue)
SELECT od.order_id, ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
FROM northwind_order_details od
GROUP BY od.order_id
ORDER BY total_revenue DESC
LIMIT 1;

# 5. Total Revenue Per Country
SELECT o.ship_country, ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY total_revenue DESC;

# 6. Orders That Were Shipped Late
SELECT order_id, order_date, required_date, shipped_date
FROM northwind_orders
WHERE shipped_date > required_date;

# 7. Average Freight Cost Per Country
SELECT ship_country, ROUND(AVG(freight), 2) AS avg_freight_cost
FROM northwind_orders
GROUP BY ship_country
ORDER BY avg_freight_cost DESC;

# 8. First & Last Order in Database
(SELECT 'First_Order' AS order_type, order_id, order_date 
 FROM northwind_orders 
 ORDER BY order_date ASC LIMIT 1)
UNION ALL
(SELECT 'Last_Order' AS order_type, order_id, order_date 
 FROM northwind_orders 
 ORDER BY order_date DESC LIMIT 1);

# 9. Find the month-wise Order Count & total sales
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS Order_Month,  -- Extract Year-Month
	COUNT(*) AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity),2) AS Total_Sales
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY Order_Month
ORDER BY Total_Sales Desc ;

# 10. Highest Discounted Order
SELECT order_id, discount_percentage AS highest_discount
FROM northwind_order_details
WHERE discount_percentage = (SELECT MAX(discount_percentage) FROM northwind_order_details);