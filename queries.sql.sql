SELECT * 
FROM ecommerce_sales_clean
LIMIT 10;


-- 1. Monthly revenue trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(revenue) AS total_revenue
FROM ecommerce_sales_clean
GROUP BY month
ORDER BY month;

-- 2. Top 5 Products by Revenue
SELECT product_name, SUM(revenue) AS revenue FROM ecommerce_sales_clean
group by product_name 
ORDER BY revenue DESC 
LIMIT 5;


-- 3. Revenue by Region and Category
SELECT region, product_category, SUM(revenue) AS revenue
 FROM ecommerce_sales_clean
GROUP BY region, product_category
order by revenue DESC;


-- 4. Customer Segment Contribution %
SELECT 
    customer_segment,
    SUM(revenue) AS revenue,
    ROUND(
        SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (),
        1
    ) AS pct_of_total
FROM ecommerce_sales_clean
GROUP BY customer_segment;


-- 5.  Order Status Breakdown
SELECT 
    order_status,
    COUNT(*) AS orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        1
    ) AS pct
FROM ecommerce_sales_clean
GROUP BY order_status;


-- 6.  Repeat Customers
SELECT 
    customer_name,
    COUNT(order_id) AS orders,
    SUM(revenue) AS total_spent
FROM ecommerce_sales_clean
GROUP BY customer_name
HAVING COUNT(order_id) > 1
ORDER BY total_spent DESC;


DESCRIBE ecommerce_sales_clean;


