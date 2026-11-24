-- Business question: What percentage of our customers are repeat buyers?
-- Why it matters: Core retention metric. Acquiring new customers costs 5-10x more than retaining existing ones.

WITH customer_order_counts AS (
    SELECT
        dc.customer_unique_id,
        COUNT(DISTINCT f.order_id) AS num_orders
    FROM marts.fct_orders f
    JOIN marts.dim_customers dc ON f.customer_key = dc.customer_key
    WHERE f.order_status = 'delivered'
    GROUP BY dc.customer_unique_id
)
SELECT
    CASE
        WHEN num_orders = 1 THEN '1 order (one-time)'
        WHEN num_orders = 2 THEN '2 orders'
        WHEN num_orders BETWEEN 3 AND 5 THEN '3-5 orders'
        ELSE '6+ orders'
    END AS customer_segment,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()::numeric, 2) AS pct_of_total
FROM customer_order_counts
GROUP BY 1
ORDER BY MIN(num_orders);