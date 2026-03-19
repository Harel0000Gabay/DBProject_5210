-- 1. Station
INSERT INTO Station (Station_ID, Station_Name, City, Address) VALUES 
(1, 'Jerusalem Central', 'Jerusalem', '8 HaMem Gimel St'),
(2, 'Tel Aviv Main', 'Dan', '60 Yigal Alon St'),
(3, 'Beer Sheva South', 'Negev', '4向Sokolov St'),
(4, 'Haifa North', 'Carmel', '12 HaNatziv St'),
(5, 'Netanya East', 'Sharon', '30 Herzl St');

-- 2. Personnel
INSERT INTO Personnel (Worker_ID, Full_Name, Specialization, Role, Phone_Number, Email, Station_ID) VALUES 
(1001, 'John Doe', 'Trauma Care', 'Paramedic', '054-1112222', 'john@mda.org', 1),
(1002, 'Jane Smith', 'Logistics', 'Logistics Manager', '052-3334444', 'jane@mda.org', 2),
(1003, 'Mike Ross', 'Emergency Driving', 'Ambulance Driver', '050-5556666', 'mike@mda.org', 3),
(1004, 'Sarah Connor', 'Dispatch', 'Dispatcher', '054-7778888', 'sarah@mda.org', 4),
(1005, 'Harvey Specter', 'Fleet', 'Fleet Officer', '052-9990000', 'harvey@mda.org', 5);

-- 3. Vehicle
INSERT INTO Vehicle (License_Plate, Purchase_Date, Vehicle_Type, Manufacturer, Manufacture_Year, Station_ID) VALUES 
('10-100-10', '2023-01-01', 'MICU', 'Chevrolet', 2023, 1),
('20-200-20', '2022-05-10', 'BLS Ambulance', 'Ford', 2022, 2),
('30-300-30', '2021-11-20', 'Motorcycle', 'Piaggio', 2021, 3),
('40-400-40', '2020-03-15', 'ALS Ambulance', 'Mercedes', 2020, 4),
('50-500-50', '2024-02-01', 'MCI Vehicle', 'Man', 2024, 5);

-- 4. Equipment_Catalog
INSERT INTO Equipment_Catalog (Item_Code, Item_Name, Category) VALUES 
('ITM-001', 'Defibrillator', 'Medical Device'),
('ITM-002', 'Morphine 10mg', 'Medication'),
('ITM-003', 'Work Shirt', 'Fixed Equipment'),
('ITM-004', 'Syringe 5ml', 'Disposable'),
('ITM-005', 'Office Paper', 'Office Supplies');

-- 5. Supplier
INSERT INTO Supplier (Supplier_ID, Company_Name, Contact_Person, Phone_Number, Email) VALUES 
(501, 'MedTech Solutions', 'Robert Paulson', '03-1234567', 'sales@medtech.com'),
(502, 'PharmaCorp', 'Ellen Ripley', '04-7654321', 'info@pharmacorp.com'),
(503, 'Uniforms Plus', 'James Bond', '09-1112223', 'orders@uplus.com'),
(504, 'LogiLink', 'Tony Stark', '02-8889990', 'stark@logilink.com'),
(505, 'Global Gear', 'Bruce Wayne', '07-4445556', 'bruce@globalgear.com');

-- 6. Maintenance_Log
INSERT INTO Maintenance_Log (Log_ID, Treatment_Date, Cost, Garage_Name, Repair_Description, Worker_ID, License_Plate) VALUES 
(1, '2024-01-10', 1500.50, 'Central Garage', 'Brake replacement', 1005, '10-100-10'),
(2, '2024-02-05', 450.00, 'Quick Fix', 'Oil change', 1005, '20-200-20'),
(3, '2023-11-20', 2300.00, 'Central Garage', 'Engine repair', 1005, '30-300-30'),
(4, '2024-01-25', 800.00, 'Tire Shop', 'Full tire set', 1005, '40-400-40'),
(5, '2023-12-12', 300.00, 'Quick Fix', 'Battery replacement', 1005, '50-500-50');

-- 7. Purchase_Order
INSERT INTO Purchase_Order (Order_ID, Order_Date, Delivery_Date, Worker_ID, Station_ID, Supplier_ID) VALUES 
(101, '2024-01-01', '2024-01-05', 1002, 1, 501),
(102, '2024-01-10', '2024-01-15', 1002, 2, 502),
(103, '2024-02-01', '2024-02-05', 1002, 3, 503),
(104, '2024-02-10', '2024-02-15', 1002, 4, 504),
(105, '2024-03-01', '2024-03-05', 1002, 5, 505);

-- 8. Station_Inventory
INSERT INTO Station_Inventory (Quantity, Station_ID, Item_Code) VALUES 
(50, 1, 'ITM-001'),
(100, 2, 'ITM-002'),
(200, 3, 'ITM-003'),
(500, 4, 'ITM-004'),
(10, 5, 'ITM-005');

-- 9. Order_Items
INSERT INTO Order_Items (Amount, Order_ID, Item_Code) VALUES 
(5, 101, 'ITM-001'),
(50, 102, 'ITM-002'),
(100, 103, 'ITM-003'),
(1000, 104, 'ITM-004'),
(20, 105, 'ITM-005');

-- 10. Uniform_Issues
INSERT INTO Uniform_Issues (Issue_ID, Issue_Date, Gear_Type, Size, Worker_ID_Issuer, Worker_ID) VALUES 
(1, '2024-01-05', 'Formal Shirt', 'M', 1002, 1001),
(2, '2024-01-06', 'Work Pants', 'L', 1002, 1003),
(3, '2024-02-10', 'Winter Jacket', 'XL', 1002, 1004),
(4, '2024-02-11', 'Identification Vest', 'S', 1002, 1005),
(5, '2024-03-01', 'First Responder Kit', 'L', 1002, 1001);

-- 11. Calibration_Logs
INSERT INTO Calibration_Logs (Calibration_ID, Check_Date, Result_Status, Item_Code, Station_ID) VALUES 
(1, '2024-01-01', 'Pass', 'ITM-001', 1),
(2, '2024-02-01', 'Pass', 'ITM-001', 2),
(3, '2024-03-01', 'Needs Repair', 'ITM-001', 3),
(4, '2024-01-15', 'Fail', 'ITM-001', 4),
(5, '2024-02-15', 'Pass', 'ITM-001', 5);

-- 12. Controlled_Substances_Log
INSERT INTO Controlled_Substances_Log (Log_ID, Withdrawal_Date, Amount_Drawn, Worker_ID, Item_Code) VALUES 
(1, '2024-01-10', 2, 1001, 'ITM-002'),
(2, '2024-01-12', 1, 1001, 'ITM-002'),
(3, '2024-02-05', 3, 1003, 'ITM-002'),
(4, '2024-02-20', 2, 1003, 'ITM-002'),
(5, '2024-03-01', 1, 1001, 'ITM-002');