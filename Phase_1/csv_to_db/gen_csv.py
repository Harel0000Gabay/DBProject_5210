import csv
import random
import psycopg2
from faker import Faker

fake = Faker()

# פרטי החיבור לצורך בדיקת המפתחות הקיימים
DB_PARAMS = {
    "host": "localhost",
    "database": "DBP",
    "user": "user123",
    "password": "password123",
    "port": "5432"
}

def get_valid_ids():
    """שואב מה-DB את המפתחות שבאמת קיימים כדי למנוע שגיאות FK"""
    conn = psycopg2.connect(**DB_PARAMS)
    cur = conn.cursor()
    
    cur.execute("SELECT worker_id FROM Personnel")
    workers = [row[0] for row in cur.fetchall()]
    
    cur.execute("SELECT item_code FROM Equipment_Catalog")
    items = [row[0] for row in cur.fetchall()]
    
    cur.execute("SELECT license_plate FROM Vehicle")
    vehicles = [row[0] for row in cur.fetchall()]
    
    cur.close()
    conn.close()
    return workers, items, vehicles

def create_massive_csvs():
    workers, items, vehicles = get_valid_ids()
    
    if not workers or not vehicles:
        print("Error: Personnel or Vehicle tables are empty! Run Phase B SQL first.")
        return

    print(f"Found {len(workers)} workers and {len(vehicles)} vehicles. Generating CSVs...")

    # 1. Maintenance_Log CSV
    with open('maintenance_20k.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['log_id', 'treatment_date', 'cost', 'garage_name', 'repair_description', 'worker_id', 'license_plate'])
        for i in range(20000):
            log_id = 2000000 + i
            m_date = fake.date_between(start_date='-3y', end_date='today')
            garage = (fake.company() + " Garage").replace("'", "").replace(",", "")
            writer.writerow([log_id, m_date, random.randint(100, 5000), garage, 'Massive Data', random.choice(workers), random.choice(vehicles)])

    # 2. Controlled_Substances_Log CSV
    with open('substances_20k.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['log_id', 'withdrawal_date', 'amount_drawn', 'worker_id', 'item_code'])
        for i in range(20000):
            log_id = 3000000 + i
            writer.writerow([log_id, fake.date_between(start_date='-2y', end_date='today'), random.randint(1, 5), random.choice(workers), random.choice(items)])

    print("Step 1 Smart Complete: CSVs are now guaranteed to match your DB.")

if __name__ == "__main__":
    create_massive_csvs()