-- Business question: Who are our top 10 customers by lifetime value?
-- Why it matters: VIP identification for retention programs and VIP support.

SELECT
    dc.customer_unique_id,
    dc.customer_city,
    dc.customer_state,
    COUNT(DISTINCT f.order_id) AS num_orders,
    COUNT(*) AS num_items,
    ROUND(SUM(f.price)::numeric, 2) AS lifetime_value,
    ROUND(AVG(f.price)::numeric, 2) AS avg_item_price
FROM marts.fct_orders f
JOIN marts.dim_customers dc ON f.customer_key = dc.customer_key
WHERE f.order_status = 'delivered'
GROUP BY dc.customer_unique_id, dc.customer_city, dc.customer_state
ORDER BY lifetime_value DESC
LIMIT 10;