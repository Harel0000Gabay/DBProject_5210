# Emergency Medical Service (EMS) Logistics & Resource Management System

**Submitted by:** Harel Gabay  
**Course/Program:** Data Base Project

---

## Introduction
This project is a comprehensive database system designed to manage the complex logistics, supply chain, and resources of an Emergency Medical Service organization (such as Magen David Adom). The system focuses entirely on operational readiness—tracking stations, personnel, fleet maintenance, inventory procurement, uniform distribution, and strict compliance logs for medical equipment calibration and controlled substances. 

---

## Phase 1: System Design & UI Mockups

### User Interface Mockups
The following screens demonstrate the intended workflow and user experience for the logistics management dashboard.

1. **Main Dashboard**: Overview of active vehicles and logistical activities. ![Main Dashboard](./Phase_1/Images/Screen4.png)
2. **Inventory & Procurement**: Management of station inventory and purchase orders. ![Inventory & Procurement](./Phase_1/Images/Screen5.png)
3. **Fleet Management**: Tracking of ambulance fleet details and garage logs. ![Fleet Management](./Phase_1/Images/Screen1.png)
4. **Compliance & Tracking**: Sensitive tracking for equipment calibration and substances. ![Compliance & Tracking](./Phase_1/Images/Screen2.png)
5. **Personnel & Gear**: Directory of medical staff and gear logs. ![Personnel & Gear](./Phase_1/Images/Screen3.png)

### Entity Relationship Diagram (ERD)
The conceptual data model mapping out 12 core entities and their relationships.
![ERD Screenshot](./Phase_1/Images/erd.png)

### Data Structure Diagram (DSD)
The logical database schema normalized to **3NF**, including PK/FK mappings.
![DSD Screenshot](./Phase_1/Images/dsd.png)

---

## Implementation (DDL)
The DSD was translated into a physical schema using **PostgreSQL 16**. The implementation enforces strict data integrity through:
* **Primary & Foreign Keys**: Ensuring consistent relations across all tables.
* **Check Constraints**: Validating business logic (e.g., valid cities, vehicle types).
* **Not Null Constraints**: Ensuring critical data is always captured.

---

## Phase 2: Data Population

To simulate a real-world operational environment, the database was populated in three distinct stages:

### 1. Phase A: Manual Baseline
Small-scale, high-quality manual insertions were performed to verify schema constraints and relationship integrity.
* **File:** [insertTables.sql](./Phase_1/sql_commands/insertTables.sql)

### 2. Phase B: Institutional Scaling (500+ Records)
To reach a realistic scale for a national EMS organization, a Python-based generator was developed using the **Faker** library. This phase populated 9 core tables with over **500 records each**.
* **Methodology**: Uses an idempotent approach with `ON CONFLICT DO NOTHING` to allow repeatable generation without collisions.
* **Script:** [generate_sql.py](./Phase_1/python_to_sql/generate_sql.py)

### 3. Phase C: Big Data & Bulk Injection (40,000+ Records)
Simulating years of operational history, we injected **20,000 records each** into `Maintenance_Log` and `Controlled_Substances_Log`.
* **Smart Generation**: The script queries the live DB to fetch valid `Worker_IDs` and `License_Plates` before creating synchronized CSV files, ensuring 100% referential integrity.
* **Bulk Loading**: Utilizes the PostgreSQL **COPY** command for high-speed injection, bypassing standard INSERT overhead.
* **Scripts:** [gen_csv.py](./Phase_1/csv_to_db/gen_csv.py) & [insert_to_db.py](./Phase_1/csv_to_db/insert_to_db.py)

---

## Tech Stack
* **Database**: PostgreSQL 16 (Containerized via Docker)
* **Programming**: Python 3.10
* **Key Libraries**: `psycopg2` (DB Driver), `Faker` (Synthetic Data), `csv`

---

## Data Verification
The following query verifies the successful population and scale of the system:

```sql
SELECT 
    (SELECT COUNT(*) FROM personnel) as total_staff,
    (SELECT COUNT(*) FROM vehicle) as total_fleet,
    (SELECT COUNT(*) FROM maintenance_log) as total_maintenance_records,
    (SELECT COUNT(*) FROM controlled_substances_log) as total_substance_logs;