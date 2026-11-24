import os
from pathlib import Path
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("POSTGRES_HOST")
DB_PORT = os.getenv("POSTGRES_PORT")
DB_NAME = os.getenv("POSTGRES_DB")

SQL_DIR = Path(__file__).parent.parent / "sql" / "marts"


def get_engine():
    url = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    return create_engine(url)


def run_sql_file(engine, sql_path):
    print(f"Running {sql_path.name}...")
    sql = sql_path.read_text()
    with engine.begin() as conn:
        conn.execute(text(sql))
    print(f"  Done")


def main():
    engine = get_engine()
    sql_files = sorted(SQL_DIR.glob("*.sql"))
    for sql_file in sql_files:
        run_sql_file(engine, sql_file)
    print(f"\nBuilt {len(sql_files)} mart tables.")


if __name__ == "__main__":
    main()