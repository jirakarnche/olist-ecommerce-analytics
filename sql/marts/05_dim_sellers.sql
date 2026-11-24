CREATE TABLE marts.dim_sellers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
FROM raw.sellers;

ALTER TABLE marts.dim_sellers ADD PRIMARY KEY (seller_key);
CREATE INDEX idx_dim_sellers_id ON marts.dim_sellers(seller_id);