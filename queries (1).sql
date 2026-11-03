-- Pizza Sales Analysis: PostgreSQL queries

CREATE TABLE pizza_sales (
  pizza_id INT,
  order_id INT,
  pizza_name_id TEXT,
  quantity INT,
  order_date DATE,
  order_time TIME,
  unit_price NUMERIC,
  total_price NUMERIC,
  pizza_size TEXT,
  pizza_category TEXT,
  pizza_ingredients TEXT,
  pizza_name TEXT,
  month_name TEXT,
  month_no INT,
  day_name TEXT,
  day_no INT,
  order_hour INT
);

-- Check the row count after loading the cleaned data (expected: 48620)
SELECT COUNT(*) FROM pizza_sales;

-- 1. KPIs
SELECT ROUND(SUM(total_price), 2) AS total_revenue,
       ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
       SUM(quantity) AS total_pizzas_sold,
       COUNT(DISTINCT order_id) AS total_orders,
       ROUND(SUM(quantity)::numeric / COUNT(DISTINCT order_id), 2) AS avg_pizzas_per_order
FROM pizza_sales;

-- 2. Orders by day of the week
SELECT day_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY day_name
ORDER BY total_orders DESC;

-- 3. Orders and revenue by month
SELECT month_no, month_name,
       COUNT(DISTINCT order_id) AS total_orders,
       ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY month_no, month_name
ORDER BY month_no;

-- 4. Revenue share by pizza category
SELECT pizza_category,
       ROUND(SUM(total_price), 2) AS revenue,
       ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS pct
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pct DESC;

-- 5. Revenue share by pizza size
SELECT pizza_size,
       ROUND(SUM(total_price), 2) AS revenue,
       ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS pct
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pct DESC;

-- 6. Top 5 pizzas by revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;

-- 7. Bottom 5 pizzas by revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue ASC
LIMIT 5;

-- 8. Busiest hours
SELECT order_hour, COUNT(DISTINCT order_id) AS orders
FROM pizza_sales
GROUP BY order_hour
ORDER BY orders DESC
LIMIT 5;
