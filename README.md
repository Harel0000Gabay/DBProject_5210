# Emergency Medical Service (EMS) Logistics & Resource Management System

**Submitted by:** [Your Name / Student ID]  
**Course/Program:** [Course Name, if applicable]

## Introduction
This project is a comprehensive database system designed to manage the complex logistics, supply chain, and resources of an Emergency Medical Service organization (such as Magen David Adom). The system focuses entirely on operational readiness—tracking stations, personnel, fleet maintenance, inventory procurement, uniform distribution, and strict compliance logs for medical equipment calibration and controlled substances. It does not handle patient medical records, ensuring a strict focus on organizational logistics.

---

## Phase 1: System Design & UI Mockups

### User Interface Mockups
The following screens demonstrate the intended workflow and user experience for the logistics management dashboard. 

*(Note: Ensure the image paths match the actual filenames in your folder)*

**1. Main Dashboard** *Overview of active vehicles, pending orders, and recent logistical activities.* ![Main Dashboard](./Phase%201/Images/Screen4.png)

**2. Inventory & Procurement** *Management of station inventory and purchase orders from suppliers.* ![Inventory & Procurement](./Phase%201/Images/Screen5.png)

**3. Fleet Management** *Tracking of ambulance fleet details and their maintenance/garage logs.* ![Fleet Management](./Phase%201/Images/Screen1.png)

**4. Compliance & Tracking** *Sensitive tracking for medical equipment calibration and the controlled substances log.* ![Compliance & Tracking](./Phase%201/Images/Screen2.png)

**5. Personnel & Gear** *Directory of medical staff and logs for issued uniforms and personal gear.* ![Personnel & Gear](./Phase%201/Images/Screen3.png)

---

### Entity Relationship Diagram (ERD)
The conceptual data model mapping out the 10 core entities, their attributes, and the relationships between them (including 1:N and M:N relationships).

![ERD Screenshot](./Phase%201/Images/erd.png)

---

### Data Structure Diagram (DSD)
The logical database schema derived from the ERD, normalized to 3NF. This includes the resolution of many-to-many relationships into intersection tables and the mapping of all Primary Keys (PK) and Foreign Keys (FK).

![DSD Screenshot](./Phase%201/Images/dsd.png)