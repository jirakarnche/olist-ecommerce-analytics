CREATE TABLE marts.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_unique_id) AS customer_key,
    customer_unique_id,
    MAX(customer_id) AS customer_id,
    MAX(customer_city) AS customer_city,
    MAX(customer_state) AS customer_state,
    MAX(customer_zip_code_prefix) AS customer_zip_code_prefix
FROM raw.customers
GROUP BY customer_unique_id;

ALTER TABLE marts.dim_customers ADD PRIMARY KEY (customer_key);
CREATE INDEX idx_dim_customers_unique_id ON marts.dim_customers(customer_unique_id);
CREATE INDEX idx_dim_customers_id ON marts.dim_customers(customer_id);