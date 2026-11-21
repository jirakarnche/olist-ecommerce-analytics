import os
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("POSTGRES_HOST")
DB_PORT = os.getenv("POSTGRES_PORT")
DB_NAME = os.getenv("POSTGRES_DB")

DATA_DIR = Path(__file__).parent.parent / "data" / "raw"
SCHEMA = "raw"

CSV_TO_TABLE = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "product_category_translation",
}


def get_engine():
    url = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    return create_engine(url)


def create_schema(engine):
    with engine.begin() as conn:
        conn.exec_driver_sql(f"CREATE SCHEMA IF NOT EXISTS {SCHEMA}")
    print(f"Schema '{SCHEMA}' ready")


def load_csv_to_postgres(engine, csv_path, table_name):
    print(f"Loading {csv_path.name} into {SCHEMA}.{table_name}...")
    df = pd.read_csv(csv_path)
    row_count = len(df)
    df.to_sql(
        table_name,
        engine,
        schema=SCHEMA,
        if_exists="replace",
        index=False,
        chunksize=10000,
    )
    print(f"  Loaded {row_count:,} rows")
    return row_count


def main():
    engine = get_engine()
    create_schema(engine)

    total_rows = 0
    for csv_name, table_name in CSV_TO_TABLE.items():
        csv_path = DATA_DIR / csv_name
        if not csv_path.exists():
            print(f"  SKIPPED: {csv_name} not found")
            continue
        rows = load_csv_to_postgres(engine, csv_path, table_name)
        total_rows += rows

    print(f"\nDone. Loaded {total_rows:,} total rows across {len(CSV_TO_TABLE)} tables.")


if __name__ == "__main__":
    main()