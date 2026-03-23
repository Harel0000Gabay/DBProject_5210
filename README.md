# Database Project

**Submitted by:** Harel Gabay  
**Subject:** MDA Logistics 

---

## Table of Contents
1. [Phase 1](#phase-1)
   * [Project Overview](#project-overview)
   * [GOOGLE AI STUDIO](#google-ai-studio)
   * [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
   * [Data Structure Diagram (DSD)](#data-structure-diagram-dsd)
   * [Data Insertion](#data-insertion)
   * [Backup Process](#backup-process)
2. [Phase 2](#phase-2)

---

## Phase 1

### Project Overview
The project manages the complex logistics of an MDA organization, focusing on operational readiness—tracking stations, personnel, fleet maintenance, and inventory without handling private medical records.

#### Purpose of the Database
The primary goals of this project are:
* **Database Design**: Creating a well-structured relational database normalized to 3NF.
* **Efficient Data Storage**: Organizing data to allow quick retrieval and manipulation.
* **Data Integrity and Consistency**: Implementing constraints (PK, FK, Check) to maintain valid data.
* **Backup and Recovery**: Ensuring that data is not lost and can be restored when needed.

#### Key Functionalities
* **Data storage and retrieval** using advanced SQL queries.
* **Relationships between tables** ensuring logical connections and referential integrity.
* **Simulating real-world scenarios** where database management is crucial for life-saving logistics.
* **Automation of data entry** using external Python scripts and bulk injection tools.

### GOOGLE AI STUDIO
* **Live Website:** [MDA Logistics](https://ems-logistics-pro-505350528104.us-west1.run.app/)

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

### Data Insertion

#### 1. Phase A: Manual Baseline
Small-scale, high-quality manual insertions were performed to verify schema constraints and relationship integrity.
* **File:** [insertTables.sql](./Phase_1/sql_commands/insertTables.sql)

#### 2. Phase B: Institutional Scaling (500+ Records)
To reach a realistic scale for a national EMS organization, a Python-based generator was developed using the **Faker** library. This phase populated 9 core tables with over **500 records each**.
* **Methodology**: Uses an idempotent approach with `ON CONFLICT DO NOTHING` to allow repeatable generation without collisions.
* **Script:** [generate_sql.py](./Phase_1/python_to_sql/generate_sql.py)

#### 3. Phase C: Big Data & Bulk Injection (40,000+ Records)
Simulating years of operational history, we injected **20,000 records each** into `Maintenance_Log` and `Controlled_Substances_Log`.
* **Smart Generation**: The script queries the live DB to fetch valid `Worker_IDs` and `License_Plates` before creating synchronized CSV files, ensuring 100% referential integrity.
* **Bulk Loading**: Utilizes the PostgreSQL **COPY** command for high-speed injection, bypassing standard INSERT overhead.
* **Scripts:** [gen_csv.py](./Phase_1/csv_to_db/gen_csv.py) & [insert_to_db.py](./Phase_1/csv_to_db/insert_to_db.py)

### Backup Process
The backup was generated using the **pgAdmin 4** management interface. We fully restored it on a fresh container to ensure data portability.
![pgAdmin Backup Process Placeholder](./Phase_1/Images/backup.png)
![pgAdmin Restore Process Placeholder](./Phase_1/Images/restore.jpg)

* **File:** [backup_23_03_2026.sql](./Phase_1/backup_23_03_2026.sql)

---

## Phase 2
*(To be updated with analytical queries, views, and complex data retrieval processes...)*