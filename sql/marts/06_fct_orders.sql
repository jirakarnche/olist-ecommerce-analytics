CREATE TABLE marts.fct_orders AS
WITH payments_agg AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value,
        MAX(payment_type) AS payment_type,
        MAX(payment_installments) AS payment_installments
    FROM raw.order_payments
    GROUP BY order_id
),
reviews_agg AS (
    SELECT
        order_id,
        AVG(review_score)::numeric(3,2) AS review_score
    FROM raw.order_reviews
    GROUP BY order_id
)
SELECT
    ROW_NUMBER() OVER (ORDER BY oi.order_id, oi.order_item_id) AS order_item_key,
    oi.order_id,
    oi.order_item_id,
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    TO_CHAR(o.order_purchase_timestamp::date, 'YYYYMMDD')::int AS order_date_key,
    TO_CHAR(o.order_delivered_customer_date::date, 'YYYYMMDD')::int AS delivery_date_key,
    o.order_status,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_value,
    pa.payment_value,
    pa.payment_type,
    pa.payment_installments,
    ra.review_score,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
        THEN (o.order_delivered_customer_date::date - o.order_purchase_timestamp::date)
        ELSE NULL
    END AS delivery_days
FROM raw.order_items oi
INNER JOIN raw.orders o ON oi.order_id = o.order_id
INNER JOIN raw.customers c ON o.customer_id = c.customer_id
INNER JOIN marts.dim_customers dc ON c.customer_unique_id = dc.customer_unique_id
INNER JOIN marts.dim_products dp ON oi.product_id = dp.product_id
INNER JOIN marts.dim_sellers ds ON oi.seller_id = ds.seller_id
LEFT JOIN payments_agg pa ON o.order_id = pa.order_id
LEFT JOIN reviews_agg ra ON o.order_id = ra.order_id;

ALTER TABLE marts.fct_orders ADD PRIMARY KEY (order_item_key);
CREATE INDEX idx_fct_orders_order_id ON marts.fct_orders(order_id);
CREATE INDEX idx_fct_orders_customer_key ON marts.fct_orders(customer_key);
CREATE INDEX idx_fct_orders_product_key ON marts.fct_orders(product_key);
CREATE INDEX idx_fct_orders_seller_key ON marts.fct_orders(seller_key);
CREATE INDEX idx_fct_orders_date_key ON marts.fct_orders(order_date_key);