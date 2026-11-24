-- Business question: How has our monthly revenue trended over time?
-- Why it matters: Shows company growth trajectory, seasonality, and anomalies.

SELECT
    dd.year,
    dd.month,
    TO_CHAR(TO_DATE(dd.year || '-' || dd.month, 'YYYY-MM'), 'YYYY-MM') AS year_month,
    COUNT(DISTINCT f.order_id) AS num_orders,
    COUNT(*) AS num_order_items,
    ROUND(SUM(f.price)::numeric, 2) AS total_revenue,
    ROUND(AVG(f.price)::numeric, 2) AS avg_item_price
FROM marts.fct_orders f
JOIN marts.dim_dates dd ON f.order_date_key = dd.date_key
WHERE f.order_status = 'delivered'
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;