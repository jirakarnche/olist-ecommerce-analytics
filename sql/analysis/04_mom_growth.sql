-- Business question: What is our month-over-month revenue growth rate?
-- Why it matters: Key investor metric. Shows momentum and seasonality.

WITH monthly AS (
    SELECT
        dd.year,
        dd.month,
        SUM(f.price) AS revenue
    FROM marts.fct_orders f
    JOIN marts.dim_dates dd ON f.order_date_key = dd.date_key
    WHERE f.order_status = 'delivered'
    GROUP BY dd.year, dd.month
)
SELECT
    year,
    month,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY year, month)::numeric, 2) AS prev_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY year, month)) * 100.0 / LAG(revenue) OVER (ORDER BY year, month))::numeric, 2) AS mom_growth_pct
FROM monthly
ORDER BY year, month;