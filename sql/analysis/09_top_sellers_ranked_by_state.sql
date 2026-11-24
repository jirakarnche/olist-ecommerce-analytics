-- Business question: Who are the top 3 sellers in each state by revenue?
-- Why it matters: Seller partnership and tiering decisions.

WITH seller_revenue AS (
    SELECT
        ds.seller_id,
        ds.seller_state,
        SUM(f.price) AS revenue,
        COUNT(DISTINCT f.order_id) AS num_orders
    FROM marts.fct_orders f
    JOIN marts.dim_sellers ds ON f.seller_key = ds.seller_key
    WHERE f.order_status = 'delivered'
    GROUP BY ds.seller_id, ds.seller_state
),
ranked AS (
    SELECT
        seller_id,
        seller_state,
        ROUND(revenue::numeric, 2) AS revenue,
        num_orders,
        RANK() OVER (PARTITION BY seller_state ORDER BY revenue DESC) AS rank_in_state
    FROM seller_revenue
)
SELECT *
FROM ranked
WHERE rank_in_state <= 3
ORDER BY seller_state, rank_in_state;