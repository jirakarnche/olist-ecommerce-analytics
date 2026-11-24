-- Business question: Which categories drive revenue, and what % of total do they represent?
-- Why it matters: Shows category concentration. Pareto principle (80/20) in action.

WITH category_revenue AS (
    SELECT
        dp.category_name_en,
        SUM(f.price) AS revenue
    FROM marts.fct_orders f
    JOIN marts.dim_products dp ON f.product_key = dp.product_key
    WHERE f.order_status = 'delivered'
    GROUP BY dp.category_name_en
)
SELECT
    category_name_en,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND((revenue * 100.0 / SUM(revenue) OVER ())::numeric, 2) AS pct_of_total,
    ROUND((SUM(revenue) OVER (ORDER BY revenue DESC) * 100.0 / SUM(revenue) OVER ())::numeric, 2) AS cumulative_pct
FROM category_revenue
ORDER BY revenue DESC
LIMIT 15;