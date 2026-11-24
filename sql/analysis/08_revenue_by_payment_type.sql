-- Business question: What payment methods generate the most revenue?
-- Why it matters: Payment strategy and fee negotiation with payment providers.

SELECT
    f.payment_type,
    COUNT(DISTINCT f.order_id) AS num_orders,
    ROUND(SUM(f.payment_value)::numeric, 2) AS total_payment_value,
    ROUND(AVG(f.payment_value)::numeric, 2) AS avg_payment_value,
    ROUND(AVG(f.payment_installments)::numeric, 2) AS avg_installments
FROM marts.fct_orders f
WHERE f.payment_type IS NOT NULL
GROUP BY f.payment_type
ORDER BY total_payment_value DESC;