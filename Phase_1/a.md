
שיחה עם Gemini
תסדר את זה בפורמט .md

שיהיה בצורה טבלאית ומסודר:

Data Dictionary: MDA Logistics & Fleet Management System



System Overview:

This database manages the logistical operations, personnel, vehicle fleet, equipment inventory, and purchase orders for an emergency medical service organization.



Table: Station

Purpose: Stores information about the various bases and stations.

Relationships:



1:N with Personnel, Vehicle, Purchase_Order, Station_Inventory, Calibration_Logs.

Fields:



Station_ID (INT) [Primary Key]: Unique identifier for each station.



Station_Name (VARCHAR): Name of the station.



City (VARCHAR): City where the station is located.



Address (VARCHAR): Specific address of the station.



Table: Personnel

Purpose: Manages information about all workers and staff members.

Relationships:



N:1 with Station.



1:N with Maintenance_Log, Purchase_Order, Uniform_Issues (as Receiver and Issuer), Controlled_Substances_Log.

Fields:



Worker_ID (INT) [Primary Key]: Unique identifier for the worker.



Full_Name (VARCHAR): Full name of the worker.



Specialization (VARCHAR): Worker's medical or technical specialty.



Role (VARCHAR): Job title or role.



Phone_Number (VARCHAR): Contact phone number.



Email (VARCHAR): Contact email address.



Station_ID (INT) [Foreign Key]: References Station(Station_ID).



Table: Vehicle

Purpose: Tracks the fleet of emergency vehicles.

Relationships:



N:1 with Station.



1:N with Maintenance_Log.

Fields:



License_Plate (VARCHAR) [Primary Key]: Unique vehicle registration number.



Purchase_Date (DATE): Date the vehicle was acquired.



Vehicle_Type (VARCHAR): Classification of the vehicle.



Manufacturer (VARCHAR): Maker of the vehicle.



Manufacture_Year (INT): Year the vehicle was built.



Station_ID (INT) [Foreign Key]: References Station(Station_ID).



Table: Maintenance_Log

Purpose: Records repairs and maintenance performed on vehicles.

Relationships:



N:1 with Vehicle, Personnel.

Fields:



Log_ID (INT) [Primary Key]: Unique identifier for the maintenance record.



Treatment_Date (DATE): Date the maintenance was performed.



Cost (VARCHAR): Cost of the repair.



Garage_Name (VARCHAR): Name of the repair shop.



Repair_Description (VARCHAR): Details of the work done.



Worker_ID (INT) [Foreign Key]: References Personnel(Worker_ID).



License_Plate (VARCHAR) [Foreign Key]: References Vehicle(License_Plate).



Table: Supplier

Purpose: Directory of external vendors providing equipment.

Relationships:



1:N with Purchase_Order.

Fields:



Supplier_ID (INT) [Primary Key]: Unique identifier for the supplier.



Company_Name (VARCHAR): Name of the vendor.



Contact_Person (VARCHAR): Primary contact at the company.



Phone_Number (VARCHAR): Supplier phone number.



Email (VARCHAR): Supplier email address.



Table: Purchase_Order

Purpose: Logs orders placed with suppliers for equipment.

Relationships:



N:1 with Personnel, Station, Supplier.



1:N with Order_Items.

Fields:



Order_ID (INT) [Primary Key]: Unique identifier for the order.



Order_Date (DATE): Date the order was placed.



Delivery_Date (DATE): Expected or actual delivery date.



Worker_ID (INT) [Foreign Key]: References Personnel(Worker_ID).



Station_ID (INT) [Foreign Key]: References Station(Station_ID).



Supplier_ID (INT) [Foreign Key]: References Supplier(Supplier_ID).



Table: Equipment_Catalog

Purpose: Master list of all available equipment types.

Relationships:



1:N with Station_Inventory, Order_Items, Calibration_Logs, Controlled_Substances_Log.

Fields:



Item_Code (VARCHAR) [Primary Key]: Unique identifier for the equipment type.



Item_Name (VARCHAR): Description or name of the item.



Category (VARCHAR): Classification of the equipment.



Table: Station_Inventory

Purpose: Tracks the quantity of specific equipment at each station.

Relationships:



N:1 with Station, Equipment_Catalog.

Fields:



Station_ID (INT) [Primary Key, Foreign Key]: References Station(Station_ID).



Item_Code (VARCHAR) [Primary Key, Foreign Key]: References Equipment_Catalog(Item_Code).



Quantity (INT): Current stock level.



Table: Order_Items

Purpose: Details the specific items and quantities within a purchase order.

Relationships:



N:1 with Purchase_Order, Equipment_Catalog.

Fields:



Order_ID (INT) [Primary Key, Foreign Key]: References Purchase_Order(Order_ID).



Item_Code (VARCHAR) [Primary Key, Foreign Key]: References Equipment_Catalog(Item_Code).



Amount (INT): Quantity of the item ordered.



Table: Uniform_Issues

Purpose: Logs the distribution of gear and uniforms to personnel.

Relationships:



N:1 with Personnel (twice: for receiver and issuer).

Fields:



Issue_ID (INT) [Primary Key]: Unique identifier for the issuance record.



Issue_Date (DATE): Date the gear was provided.



Gear_Type (VARCHAR): Description of the item issued.



Size (VARCHAR): Size of the issued gear.



Receiver_ID (INT) [Foreign Key]: References Personnel(Worker_ID).



Issuer_ID (INT) [Foreign Key]: References Personnel(Worker_ID).



Table: Calibration_Logs

Purpose: Tracks mandatory testing and calibration of medical equipment.

Relationships:



N:1 with Equipment_Catalog, Station.

Fields:



Calibration_ID (INT) [Primary Key]: Unique identifier for the calibration record.



Check_Date (DATE): Date the equipment was tested.



Result_Status (VARCHAR): Outcome of the test (e.g., Pass/Fail).



Item_Code (VARCHAR) [Foreign Key]: References Equipment_Catalog(Item_Code).



Station_ID (INT) [Foreign Key]: References Station(Station_ID).



Table: Controlled_Substances_Log

Purpose: Audits the usage and withdrawal of sensitive medications.

Relationships:



N:1 with Personnel, Equipment_Catalog.

Fields:



Log_ID (INT) [Primary Key]: Unique identifier for the log entry.



Withdrawal_Date (DATE): Date the substance was taken.



Amount_Drawn (INT): Quantity of the substance used.



Worker_ID (INT) [Foreign Key]: References Personnel(Worker_ID).



Item_Code (VARCHAR) [Foreign Key]: References Equipment_Catalog(Item_Code).

הקובץ בפורמט Markdown מוכן עבורך. סידרתי את כל הנתונים בטבלאות נפרדות לכל טבלה במערכת, כולל פירוט המפתחות (PK/FK), סוגי הנתונים והקשרים בין הטבלאות.

Your Markdown file is ready
סמל של MD
 MDA_Logist...Dictionary 
MD

מבנה המסמך:
System Overview: סקירה כללית של המערכת.

Tables: לכל טבלה יש כותרת, תיאור המטרה (Purpose), פירוט הקשרים (Relationships) וטבלה המפרטת את השדות.

Keys: עמודת Key מציינת האם השדה הוא מפתח ראשי (PK) או מפתח זר (FK).





‫Gemini מבוסס על AI ויכול לטעות.

# Data Dictionary: MDA Logistics & Fleet Management System

## System Overview
This database manages the logistical operations, personnel, vehicle fleet, equipment inventory, and purchase orders for an emergency medical service organization.

---

## 1. Station
**Purpose:** Stores information about the various bases and stations.  
**Relationships:** 1:N with Personnel, Vehicle, Purchase_Order, Station_Inventory, Calibration_Logs.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Station_ID | INT | PK | Unique identifier for each station. |
| Station_Name | VARCHAR | | Name of the station. |
| City | VARCHAR | | City where the station is located. |
| Address | VARCHAR | | Specific address of the station. |

---

## 2. Personnel
**Purpose:** Manages information about all workers and staff members.  
**Relationships:** N:1 with Station; 1:N with Maintenance_Log, Purchase_Order, Uniform_Issues, Controlled_Substances_Log.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Worker_ID | INT | PK | Unique identifier for the worker. |
| Full_Name | VARCHAR | | Full name of the worker. |
| Specialization | VARCHAR | | Worker's medical or technical specialty. |
| Role | VARCHAR | | Job title or role. |
| Phone_Number | VARCHAR | | Contact phone number. |
| Email | VARCHAR | | Contact email address. |
| Station_ID | INT | FK | References Station(Station_ID). |

---

## 3. Vehicle
**Purpose:** Tracks the fleet of emergency vehicles.  
**Relationships:** N:1 with Station; 1:N with Maintenance_Log.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| License_Plate | VARCHAR | PK | Unique vehicle registration number. |
| Purchase_Date | DATE | | Date the vehicle was acquired. |
| Vehicle_Type | VARCHAR | | Classification of the vehicle. |
| Manufacturer | VARCHAR | | Maker of the vehicle. |
| Manufacture_Year| INT | | Year the vehicle was built. |
| Station_ID | INT | FK | References Station(Station_ID). |

---

## 4. Maintenance_Log
**Purpose:** Records repairs and maintenance performed on vehicles.  
**Relationships:** N:1 with Vehicle, Personnel.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Log_ID | INT | PK | Unique identifier for the maintenance record. |
| Treatment_Date | DATE | | Date the maintenance was performed. |
| Cost | VARCHAR | | Cost of the repair. |
| Garage_Name | VARCHAR | | Name of the repair shop. |
| Repair_Description| VARCHAR | | Details of the work done. |
| Worker_ID | INT | FK | References Personnel(Worker_ID). |
| License_Plate | VARCHAR | FK | References Vehicle(License_Plate). |

---

## 5. Supplier
**Purpose:** Directory of external vendors providing equipment.  
**Relationships:** 1:N with Purchase_Order.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Supplier_ID | INT | PK | Unique identifier for the supplier. |
| Company_Name | VARCHAR | | Name of the vendor. |
| Contact_Person | VARCHAR | | Primary contact at the company. |
| Phone_Number | VARCHAR | | Supplier phone number. |
| Email | VARCHAR | | Supplier email address. |

---

## 6. Purchase_Order
**Purpose:** Logs orders placed with suppliers for equipment.  
**Relationships:** N:1 with Personnel, Station, Supplier; 1:N with Order_Items.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Order_ID | INT | PK | Unique identifier for the order. |
| Order_Date | DATE | | Date the order was placed. |
| Delivery_Date | DATE | | Expected or actual delivery date. |
| Worker_ID | INT | FK | References Personnel(Worker_ID). |
| Station_ID | INT | FK | References Station(Station_ID). |
| Supplier_ID | INT | FK | References Supplier(Supplier_ID). |

---

## 7. Equipment_Catalog
**Purpose:** Master list of all available equipment types.  
**Relationships:** 1:N with Station_Inventory, Order_Items, Calibration_Logs, Controlled_Substances_Log.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Item_Code | VARCHAR | PK | Unique identifier for the equipment type. |
| Item_Name | VARCHAR | | Description or name of the item. |
| Category | VARCHAR | | Classification of the equipment. |

---

## 8. Station_Inventory
**Purpose:** Tracks the quantity of specific equipment at each station.  
**Relationships:** N:1 with Station, Equipment_Catalog.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Station_ID | INT | PK, FK | References Station(Station_ID). |
| Item_Code | VARCHAR | PK, FK | References Equipment_Catalog(Item_Code). |
| Quantity | INT | | Current stock level. |

---

## 9. Order_Items
**Purpose:** Details the specific items and quantities within a purchase order.  
**Relationships:** N:1 with Purchase_Order, Equipment_Catalog.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Order_ID | INT | PK, FK | References Purchase_Order(Order_ID). |
| Item_Code | VARCHAR | PK, FK | References Equipment_Catalog(Item_Code). |
| Amount | INT | | Quantity of the item ordered. |

---

## 10. Uniform_Issues
**Purpose:** Logs the distribution of gear and uniforms to personnel.  
**Relationships:** N:1 with Personnel (Receiver and Issuer).

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Issue_ID | INT | PK | Unique identifier for the issuance record. |
| Issue_Date | DATE | | Date the gear was provided. |
| Gear_Type | VARCHAR | | Description of the item issued. |
| Size | VARCHAR | | Size of the issued gear. |
| Receiver_ID | INT | FK | References Personnel(Worker_ID). |
| Issuer_ID | INT | FK | References Personnel(Worker_ID). |

---

## 11. Calibration_Logs
**Purpose:** Tracks mandatory testing and calibration of medical equipment.  
**Relationships:** N:1 with Equipment_Catalog, Station.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Calibration_ID | INT | PK | Unique identifier for the calibration record. |
| Check_Date | DATE | | Date the equipment was tested. |
| Result_Status | VARCHAR | | Outcome of the test (e.g., Pass/Fail). |
| Item_Code | VARCHAR | FK | References Equipment_Catalog(Item_Code). |
| Station_ID | INT | FK | References Station(Station_ID). |

---

## 12. Controlled_Substances_Log
**Purpose:** Audits the usage and withdrawal of sensitive medications.  
**Relationships:** N:1 with Personnel, Equipment_Catalog.

| Field Name | Data Type | Key | Description |
| :--- | :--- | :--- | :--- |
| Log_ID | INT | PK | Unique identifier for the log entry. |
| Withdrawal_Date | DATE | | Date the substance was taken. |
| Amount_Drawn | INT | | Quantity of the substance used. |
| Worker_ID | INT | FK | References Personnel(Worker_ID). |
| Item_Code | VARCHAR | FK | References Equipment_Catalog(Item_Code). |