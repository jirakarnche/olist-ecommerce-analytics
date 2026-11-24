CREATE TABLE marts.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,
    p.product_id,
    p.product_category_name AS category_name_pt,
    COALESCE(t.product_category_name_english, 'unknown') AS category_name_en,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw.products p
LEFT JOIN raw.product_category_translation t
    ON p.product_category_name = t.product_category_name;

ALTER TABLE marts.dim_products ADD PRIMARY KEY (product_key);
CREATE INDEX idx_dim_products_id ON marts.dim_products(product_id);