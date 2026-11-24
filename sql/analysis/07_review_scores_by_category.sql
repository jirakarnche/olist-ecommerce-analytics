-- Business question: Which product categories have the best and worst customer reviews?
-- Why it matters: Quality signals. Low-review categories need quality intervention.

SELECT
    dp.category_name_en,
    COUNT(f.review_score) AS num_reviews,
    ROUND(AVG(f.review_score)::numeric, 2) AS avg_review_score,
    SUM(CASE WHEN f.review_score >= 4 THEN 1 ELSE 0 END) AS positive_reviews,
    SUM(CASE WHEN f.review_score <= 2 THEN 1 ELSE 0 END) AS negative_reviews,
    ROUND(SUM(CASE WHEN f.review_score >= 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(f.review_score)::numeric, 2) AS pct_positive
FROM marts.fct_orders f
JOIN marts.dim_products dp ON f.product_key = dp.product_key
WHERE f.review_score IS NOT NULL
GROUP BY dp.category_name_en
HAVING COUNT(f.review_score) >= 100
ORDER BY avg_review_score DESC;