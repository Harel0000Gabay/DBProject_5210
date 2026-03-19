import random
from faker import Faker
from datetime import datetime, date, timedelta

fake = Faker()
output_file = "insert_phase_b_500.sql"

CITIES = ['Jerusalem', 'Dan', 'Negev', 'Sharon', 'Carmel']


ROLES = ['Ambulance Driver', 'Senior Medic', 'Paramedic', 'Fleet Officer', 'Logistics Manager', 'Dispatcher']
VEHICLE_TYPES = ['BLS Ambulance', 'MICU', 'ALS Ambulance', 'MCI Vehicle', 'Motorcycle']
CATEGORIES = ['Disposable', 'Medical Device', 'Fixed Equipment', 'Medication', 'Office Supplies']
STATUSES = ['Pass', 'Fail', 'Needs Repair']


NUM_STATIONS = 35
NUM_SUPPLIERS = 55
NUM_ITEMS = 110
NUM_TARGET = 510

STATION_IDS = list(range(500, 500 + NUM_STATIONS))
SUPPLIER_IDS = list(range(5000, 5000 + NUM_SUPPLIERS))
ITEM_CODES = [f"ITM-{i}" for i in range(1000, 1000 + NUM_ITEMS)]
WORKER_IDS = list(range(10000, 10000 + NUM_TARGET))
ORDER_IDS = list(range(80000, 80000 + NUM_TARGET))
LOG_BASE_ID = 500000

def generate_sql():
    sql = []
    
    # 1. Station - כאן התיקון! משתמשים ב-random.choice(CITIES)
    for s_id in STATION_IDS:
        s_name = f"{fake.city()} Unit"
        s_addr = fake.street_address().replace("'", "''")
        chosen_city = random.choice(CITIES)
        sql.append(f"INSERT INTO Station VALUES ({s_id}, '{s_name}', '{chosen_city}', '{s_addr}') ON CONFLICT (Station_ID) DO NOTHING;")

    # 2. Equipment_Catalog
    for i_code in ITEM_CODES:
        i_name = f"{fake.word().capitalize()} Pack"
        sql.append(f"INSERT INTO Equipment_Catalog VALUES ('{i_code}', '{i_name}', '{random.choice(CATEGORIES)}') ON CONFLICT (Item_Code) DO NOTHING;")

    # 3. Supplier
    for sup_id in SUPPLIER_IDS:
        s_comp = fake.company().replace("'", "''")
        s_cont = fake.name().replace("'", "''")
        sql.append(f"INSERT INTO Supplier VALUES ({sup_id}, '{s_comp}', '{s_cont}', '03-1234567', '{fake.email()}') ON CONFLICT (Supplier_ID) DO NOTHING;")

    # 4. Personnel (500+)
    for w_id in WORKER_IDS:
        w_name = fake.name().replace("'", "''")
        sql.append(f"INSERT INTO Personnel VALUES ({w_id}, '{w_name}', 'General', '{random.choice(ROLES)}', '054-0000000', '{fake.email()}', {random.choice(STATION_IDS)}) ON CONFLICT (Worker_ID) DO NOTHING;")

    # 5. Vehicle (500+)
    l_plates = []
    for i in range(NUM_TARGET):
        lp = f"{random.randint(10,99)}-{random.randint(100,999)}-{i:02d}"
        l_plates.append(lp)
        sql.append(f"INSERT INTO Vehicle VALUES ('{lp}', '2023-01-01', '{random.choice(VEHICLE_TYPES)}', 'Ford', 2023, {random.choice(STATION_IDS)}) ON CONFLICT (License_Plate) DO NOTHING;")

    # 6. Purchase_Order (500+)
    for o_id in ORDER_IDS:
        o_date = fake.date_between(start_date='-1y', end_date='today')
        d_date = o_date + timedelta(days=7)
        sql.append(f"INSERT INTO Purchase_Order VALUES ({o_id}, '{o_date}', '{d_date}', {random.choice(WORKER_IDS)}, {random.choice(STATION_IDS)}, {random.choice(SUPPLIER_IDS)}) ON CONFLICT (Order_ID) DO NOTHING;")

    # 7-10. Logs (500+ לכל סוג)
    for i in range(NUM_TARGET):
        log_date = fake.date_between(start_date='-1y', end_date='today')
        # Maintenance
        g_name = f"{fake.company()} Garage".replace("'", "''")
        sql.append(f"INSERT INTO Maintenance_Log VALUES ({LOG_BASE_ID + i}, '{log_date}', {random.randint(200, 2000)}, '{g_name}', 'Routine Check', {random.choice(WORKER_IDS)}, '{random.choice(l_plates)}') ON CONFLICT (Log_ID) DO NOTHING;")
        # Uniforms
        sql.append(f"INSERT INTO Uniform_Issues VALUES ({LOG_BASE_ID + 1000 + i}, '{log_date}', 'Work Pants', 'L', {random.choice(WORKER_IDS)}, {random.choice(WORKER_IDS)}) ON CONFLICT (Issue_ID) DO NOTHING;")
        # Calibration
        sql.append(f"INSERT INTO Calibration_Logs VALUES ({LOG_BASE_ID + 2000 + i}, '{log_date}', '{random.choice(STATUSES)}', '{random.choice(ITEM_CODES)}', {random.choice(STATION_IDS)}) ON CONFLICT (Calibration_ID) DO NOTHING;")
        # Controlled_Substances
        sql.append(f"INSERT INTO Controlled_Substances_Log VALUES ({LOG_BASE_ID + 3000 + i}, '{log_date}', {random.randint(1, 3)}, {random.choice(WORKER_IDS)}, '{random.choice(ITEM_CODES)}') ON CONFLICT (Log_ID) DO NOTHING;")

    # 11-12. Junction Tables (500+)
    inv_pairs = set()
    while len(inv_pairs) < NUM_TARGET:
        inv_pairs.add((random.choice(STATION_IDS), random.choice(ITEM_CODES)))
    for s_id, i_code in inv_pairs:
        sql.append(f"INSERT INTO Station_Inventory VALUES ({random.randint(1, 100)}, {s_id}, '{i_code}') ON CONFLICT (Station_ID, Item_Code) DO NOTHING;")

    ord_pairs = set()
    while len(ord_pairs) < NUM_TARGET:
        ord_pairs.add((random.choice(ORDER_IDS), random.choice(ITEM_CODES)))
    for o_id, i_code in ord_pairs:
        sql.append(f"INSERT INTO Order_Items VALUES ({random.randint(1, 50)}, {o_id}, '{i_code}') ON CONFLICT (Order_ID, Item_Code) DO NOTHING;")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n".join(sql))

if __name__ == "__main__":
    generate_sql()
    print(f"DONE! {output_file}")