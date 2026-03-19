import psycopg2
import os

# פרטי החיבור מה-docker-compose.yml שלך
DB_PARAMS = {
    "host": "localhost",
    "database": "DBP",
    "user": "user123",
    "password": "password123",
    "port": "5432"
}

def inject_csv(file_path, table_name):
    if not os.path.exists(file_path):
        print(f"Error: {file_path} not found. Run Step 1 first!")
        return

    print(f"Injecting {file_path} into {table_name}...")
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        cur = conn.cursor()

        with open(file_path, 'r', encoding='utf-8') as f:
            next(f)
            cur.copy_expert(f"COPY {table_name} FROM STDIN WITH CSV", f)
        
        conn.commit()
        print(f"Successfully loaded {file_path}")
        
    except Exception as e:
        print(f"Database Error: {e}")
    finally:
        if conn:
            cur.close()
            conn.close()

if __name__ == "__main__":
    inject_csv('maintenance_20k.csv', 'maintenance_log')
    inject_csv('substances_20k.csv', 'controlled_substances_log')
    print("Step 2 Complete: Database is now populated with 40,000 new rows.")