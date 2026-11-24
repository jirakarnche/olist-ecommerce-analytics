-- Business question: Which days of the week do customers buy the most?
-- Why it matters: Marketing campaign scheduling and staffing decisions.

SELECT
    dd.day_of_week,
    TRIM(dd.day_name) AS day_name,
    COUNT(DISTINCT f.order_id) AS num_orders,
    ROUND(SUM(f.price)::numeric, 2) AS total_revenue,
    ROUND(AVG(f.price)::numeric, 2) AS avg_item_price
FROM marts.fct_orders f
JOIN marts.dim_dates dd ON f.order_date_key = dd.date_key
WHERE f.order_status = 'delivered'
GROUP BY dd.day_of_week, dd.day_name
ORDER BY dd.day_of_week;