# Beginner Level (11 Questions)

# 1. Rank orders by total amount (Window Function).
WITH Order_Totals AS (
    SELECT order_id, ROUND(SUM(unit_price * quantity),2) AS Total_Amount
    FROM northwind_order_details
    GROUP BY order_id
)
SELECT order_id, Total_Amount,
       RANK() OVER (ORDER BY Total_Amount DESC) AS Ranking
FROM Order_Totals;

# 2. Find the cumulative revenue over time (Window Function).
SELECT order_date, 
       ROUND(SUM(unit_price * quantity),2) AS Daily_Sales, 
       ROUND(SUM(SUM(unit_price * quantity)) OVER (ORDER BY order_date), 2) AS Cumulative_Revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY order_date;

# 3. Find the difference between two consecutive order dates (LAG Function).
SELECT order_id, order_date,
       LAG(order_date) OVER (ORDER BY order_date) AS Prev_order_date,
       DATEDIFF(order_date, LAG(order_date) OVER (ORDER BY order_date)) AS Days_Between
FROM northwind_orders
ORDER BY Days_Between DESC ;

# 4. Find the average order value for each customer using CTE.
WITH Order_Summary AS (
    SELECT o.customer_id, ROUND(SUM(od.unit_price * od.quantity),2) AS Order_Value 
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id, o.order_id
)
SELECT customer_id, ROUND(AVG(Order_Value),2) AS Avg_Order_Value FROM Order_Summary GROUP BY customer_id
ORDER BY Avg_Order_Value DESC;

# 5. Use CASE to categorize orders based on total value.
SELECT order_id, ROUND(SUM(unit_price * quantity),2) AS Total_Value,
       CASE 
           WHEN ROUND(SUM(unit_price * quantity),2) > 1000 THEN 'High Value'
           WHEN ROUND(SUM(unit_price * quantity),2) BETWEEN 500 AND 1000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS Order_Category
FROM northwind_order_details
GROUP BY order_id;


# 6. Find the percentage contribution of each product to the total revenue (Window Function).
SELECT product_id, 
       Total_Sales,
       ROUND(Total_Sales * 100.0 / SUM(Total_Sales) OVER (),2) AS Percentage_Contribution
FROM ( SELECT product_id, ROUND(SUM(unit_price * quantity),2) AS Total_Sales
    FROM northwind_order_details
    GROUP BY product_id ) AS ProductSales
ORDER BY Percentage_Contribution DESC;

# 7. Find the first order placed by each customer (Using CTE and ROW_NUMBER).
WITH RankedOrders AS (
    SELECT customer_id, order_id, order_date, 
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS RowNum
    FROM northwind_orders
)
SELECT customer_id, order_id, order_date
FROM RankedOrders
WHERE RowNum = 1
ORDER BY order_date;

# 8. Get the top 5 most ordered products.
SELECT product_id, COUNT(*) AS Order_Count 
FROM northwind_order_details 
GROUP BY product_id 
ORDER BY Order_Count DESC 
LIMIT 5;

# 9. Find the average unit price of products sold.
SELECT round(AVG(unit_price),2) AS Avg_Price FROM northwind_order_details;

# 10. Find customers who have placed more than 5 orders (HAVING).
SELECT 
    ROW_NUMBER() OVER (ORDER BY COUNT(order_id) DESC) AS Index_No,
    customer_id, 
    COUNT(order_id) AS Order_Count
FROM northwind_orders
GROUP BY customer_id
HAVING Order_Count > 5
ORDER BY Order_Count DESC;

# 11. Find the average order value per customer
SELECT 
    o.customer_id, 
    COUNT(o.order_id) AS Total_Orders, 
    ROUND(SUM(od.unit_price * od.quantity),2) AS Total_Revenue,
    ROUND(SUM(od.unit_price * od.quantity) / COUNT(o.order_id),2) AS Avg_Order_Value
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY Total_Revenue DESC;