-- Business question: Which states have the longest delivery times?
-- Why it matters: Logistics bottlenecks hurt customer satisfaction and retention.

SELECT
    dc.customer_state,
    COUNT(*) AS num_delivered_orders,
    ROUND(AVG(f.delivery_days)::numeric, 1) AS avg_delivery_days,
    MIN(f.delivery_days) AS min_days,
    MAX(f.delivery_days) AS max_days
FROM marts.fct_orders f
JOIN marts.dim_customers dc ON f.customer_key = dc.customer_key
WHERE f.delivery_days IS NOT NULL
  AND f.order_status = 'delivered'
GROUP BY dc.customer_state
HAVING COUNT(*) >= 100
ORDER BY avg_delivery_days DESC;