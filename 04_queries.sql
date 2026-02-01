USE bike_store;

-- A) CORE KPIs

-- KPI 1: Total Revenue
SELECT
    SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS total_revenue
FROM order_items as oi;

-- KPI 2: Average Order Value (AOV)
SELECT
    AVG(order_total) AS avg_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS order_total
    FROM orders as o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id
);

-- KPI 3: Orders by Status
SELECT
    order_status,
    COUNT(*) AS num_orders
FROM orders
GROUP BY order_status
ORDER BY num_orders DESC;

-- Revenue by Store
SELECT
    o.store_id,
    SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS revenue
FROM orders as o
JOIN order_items as oi ON oi.order_id = o.order_id
GROUP BY o.store_id
ORDER BY revenue DESC;

-- Orders per Store
SELECT
    store_id,
    COUNT(*) AS num_orders
FROM orders
GROUP BY store_id
ORDER BY num_orders DESC;

-- Top 10 Customers by Total Spend
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS total_spent
FROM customers as c
JOIN orders as o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Customers with Most Orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS num_orders
FROM customers as c
JOIN orders as o ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY num_orders DESC
LIMIT 10;

-- Best-Selling Products (Units Sold)
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products as p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY units_sold DESC
LIMIT 10;

-- Best-Selling Products (Revenue)
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS revenue
FROM products as p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Revenue by Category
SELECT
    c.category_name,
    SUM(oi.quantity * oi.list_price * (1 - IFNULL(oi.discount, 0))) AS revenue
FROM categories as c
JOIN products as p ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY c.category_name
ORDER BY revenue DESC;

-- Lowest Stock Items (Top 20)
SELECT
    s.store_id,
    s.product_id,
    p.product_name,
    s.quantity
FROM stocks as s
JOIN products as p ON p.product_id = s.product_id
ORDER BY s.quantity ASC
LIMIT 20;

-- Out-of-Stock Products
SELECT
    s.store_id,
    s.product_id,
    p.product_name
FROM stocks as s
JOIN products as p ON p.product_id = s.product_id
WHERE s.quantity = 0;


