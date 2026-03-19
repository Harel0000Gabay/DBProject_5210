CREATE TABLE Station
(
  Station_ID INT NOT NULL,
  Station_Name VARCHAR(50) NOT NULL,
  City VARCHAR(50) NOT NULL CHECK (City IN ('Jerusalem', 'Dan', 'Negev', 'Sharon', 'Carmel')),
  Address VARCHAR(100) NOT NULL,
  PRIMARY KEY (Station_ID)
);

CREATE TABLE Personnel
(
  Worker_ID INT NOT NULL,
  Full_Name VARCHAR(50) NOT NULL,
  Specialization VARCHAR(50) NOT NULL,
  Role VARCHAR(50) NOT NULL CHECK (Role IN ('Ambulance Driver', 'Senior Medic', 'Paramedic', 'Fleet Officer', 'Logistics Manager', 'Dispatcher')),
  Phone_Number VARCHAR(15) NOT NULL,
  Email VARCHAR(100) NOT NULL UNIQUE,
  Station_ID INT NOT NULL,
  PRIMARY KEY (Worker_ID),
  FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID)
);

CREATE TABLE Vehicle
(
  License_Plate VARCHAR(15) NOT NULL,
  Purchase_Date DATE NOT NULL,
  Vehicle_Type VARCHAR(30) NOT NULL CHECK (Vehicle_Type IN ('BLS Ambulance', 'MICU', 'ALS Ambulance', 'MCI Vehicle', 'Motorcycle')),
  Manufacturer VARCHAR(30) NOT NULL,
  Manufacture_Year INT NOT NULL CHECK (Manufacture_Year > 1990),
  Station_ID INT NOT NULL,
  PRIMARY KEY (License_Plate),
  FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID)
);

CREATE TABLE Maintenance_Log
(
  Log_ID INT NOT NULL,
  Treatment_Date DATE NOT NULL,
  Cost NUMERIC(10,2) NOT NULL CHECK (Cost >= 0),
  Garage_Name VARCHAR(50) NOT NULL,
  Repair_Description VARCHAR(255) NOT NULL,
  Worker_ID INT NOT NULL,
  License_Plate VARCHAR(15) NOT NULL,
  PRIMARY KEY (Log_ID),
  FOREIGN KEY (Worker_ID) REFERENCES Personnel(Worker_ID),
  FOREIGN KEY (License_Plate) REFERENCES Vehicle(License_Plate)
);

CREATE TABLE Supplier
(
  Supplier_ID INT NOT NULL,
  Company_Name VARCHAR(50) NOT NULL,
  Contact_Person VARCHAR(50) NOT NULL,
  Phone_Number VARCHAR(15) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  PRIMARY KEY (Supplier_ID)
);

CREATE TABLE Purchase_Order
(
  Order_ID INT NOT NULL,
  Order_Date DATE NOT NULL,
  Delivery_Date DATE NOT NULL CHECK (Delivery_Date >= Order_Date),
  Worker_ID INT NOT NULL,
  Station_ID INT NOT NULL,
  Supplier_ID INT NOT NULL,
  PRIMARY KEY (Order_ID),
  FOREIGN KEY (Worker_ID) REFERENCES Personnel(Worker_ID),
  FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID),
  FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE Equipment_Catalog
(
  Item_Code VARCHAR(20) NOT NULL,
  Item_Name VARCHAR(50) NOT NULL,
  Category VARCHAR(30) NOT NULL CHECK (Category IN ('Disposable', 'Medical Device', 'Fixed Equipment', 'Medication', 'Office Supplies')),
  PRIMARY KEY (Item_Code)
);

CREATE TABLE Station_Inventory
(
  Quantity INT NOT NULL CHECK (Quantity >= 0),
  Station_ID INT NOT NULL,
  Item_Code VARCHAR(20) NOT NULL,
  PRIMARY KEY (Station_ID, Item_Code),
  FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID),
  FOREIGN KEY (Item_Code) REFERENCES Equipment_Catalog(Item_Code)
);

CREATE TABLE Order_Items
(
  Amount INT NOT NULL CHECK (Amount > 0),
  Order_ID INT NOT NULL,
  Item_Code VARCHAR(20) NOT NULL,
  PRIMARY KEY (Order_ID, Item_Code),
  FOREIGN KEY (Order_ID) REFERENCES Purchase_Order(Order_ID),
  FOREIGN KEY (Item_Code) REFERENCES Equipment_Catalog(Item_Code)
);

CREATE TABLE Uniform_Issues
(
  Issue_ID INT NOT NULL,
  Issue_Date DATE NOT NULL,
  Gear_Type VARCHAR(50) NOT NULL CHECK (Gear_Type IN ('Formal Shirt', 'Work Pants', 'Winter Jacket', 'Identification Vest', 'First Responder Kit')),
  Size VARCHAR(10) NOT NULL CHECK (Size IN ('S', 'M', 'L', 'XL', 'XXL')),
  Worker_ID_Issuer INT NOT NULL,
  Worker_ID INT NOT NULL,
  PRIMARY KEY (Issue_ID),
  FOREIGN KEY (Worker_ID_Issuer) REFERENCES Personnel(Worker_ID),
  FOREIGN KEY (Worker_ID) REFERENCES Personnel(Worker_ID)
);

CREATE TABLE Calibration_Logs
(
  Calibration_ID INT NOT NULL,
  Check_Date DATE NOT NULL,
  Result_Status VARCHAR(20) NOT NULL CHECK (Result_Status IN ('Pass', 'Fail', 'Needs Repair')),
  Item_Code VARCHAR(20) NOT NULL,
  Station_ID INT NOT NULL,
  PRIMARY KEY (Calibration_ID),
  FOREIGN KEY (Item_Code) REFERENCES Equipment_Catalog(Item_Code),
  FOREIGN KEY (Station_ID) REFERENCES Station(Station_ID)
);

CREATE TABLE Controlled_Substances_Log
(
  Log_ID INT NOT NULL,
  Withdrawal_Date DATE NOT NULL,
  Amount_Drawn INT NOT NULL CHECK (Amount_Drawn > 0),
  Worker_ID INT NOT NULL,
  Item_Code VARCHAR(20) NOT NULL,
  PRIMARY KEY (Log_ID),
  FOREIGN KEY (Worker_ID) REFERENCES Personnel(Worker_ID),
  FOREIGN KEY (Item_Code) REFERENCES Equipment_Catalog(Item_Code)
);