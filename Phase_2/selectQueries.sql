--ספקים שלא ביצעו הזמנות משנת 2025
--1:
SELECT s.Company_Name, s.Contact_Person, s.Phone_Number
FROM Supplier s
WHERE NOT EXISTS (
    SELECT 1 
    FROM Purchase_Order po 
    WHERE po.Supplier_ID = s.Supplier_ID 
    AND EXTRACT(YEAR FROM po.Order_Date) = 2025
);
--2:
SELECT s.Company_Name, s.Contact_Person, s.Phone_Number
FROM Supplier s
LEFT JOIN Purchase_Order po ON s.Supplier_ID = po.Supplier_ID AND EXTRACT(YEAR FROM po.Order_Date) = 2025
WHERE po.Order_ID IS NULL;

-----------------------------------------------------------------------------------------------------------
--עובדים שמשכו חומרים נרקוטים בחודש נובמבר 2025
--1:
SELECT p.Full_Name, p.Role, st.Station_Name
FROM Personnel p
JOIN Station st ON p.Station_ID = st.Station_ID
WHERE p.Worker_ID IN (
    SELECT Worker_ID 
    FROM Controlled_Substances_Log 
    WHERE EXTRACT(MONTH FROM Withdrawal_Date) = 11 AND EXTRACT(YEAR FROM Withdrawal_Date) = 2025
);
--2:
SELECT DISTINCT p.Full_Name, p.Role, st.Station_Name
FROM Personnel p
JOIN Station st ON p.Station_ID = st.Station_ID
JOIN Controlled_Substances_Log csl ON p.Worker_ID = csl.Worker_ID
WHERE EXTRACT(MONTH FROM csl.Withdrawal_Date) = 11 AND EXTRACT(YEAR FROM csl.Withdrawal_Date) = 2025;

-----------------------------------------------------------------------------------------------------------
--פריטי ציוד רפואי שהכמות שלהם במלאי קטנה מ-10 [כולל שם התחנה]
--1:
SELECT s.Station_Name, ec.Item_Name, si.Quantity
FROM Station_Inventory si
JOIN Station s ON si.Station_ID = s.Station_ID
JOIN Equipment_Catalog ec ON si.Item_Code = ec.Item_Code
WHERE si.Quantity < 10 AND ec.Category = 'Medical Device';
--2:
SELECT 
    (SELECT Station_Name FROM Station s WHERE s.Station_ID = si.Station_ID) AS Station_Name,
    (SELECT Item_Name FROM Equipment_Catalog ec WHERE ec.Item_Code = si.Item_Code AND ec.Category = 'Medical Device') AS Item_Name,
    si.Quantity
FROM Station_Inventory si
WHERE si.Quantity < 10 AND EXISTS (SELECT 1 FROM Equipment_Catalog ec2 WHERE ec2.Item_Code = si.Item_Code AND ec2.Category = 'Medical Device');

-----------------------------------------------------------------------------------------------------------
--רכבים שעלות הטיפולים הכוללת שלהם גבוהה מהממוצע הארצי של כלל הרכבים
--1:
WITH VehicleCosts AS (
    SELECT License_Plate, SUM(Cost) as Total_Cost
    FROM Maintenance_Log
    GROUP BY License_Plate
),
GlobalAvg AS (
    SELECT AVG(Total_Cost) as Avg_Cost FROM VehicleCosts
)
SELECT v.License_Plate, v.Vehicle_Type, vc.Total_Cost
FROM Vehicle v
JOIN VehicleCosts vc ON v.License_Plate = vc.License_Plate
CROSS JOIN GlobalAvg ga
WHERE vc.Total_Cost > ga.Avg_Cost;
--2:
SELECT v.License_Plate, v.Vehicle_Type, SUM(ml.Cost) AS Total_Cost
FROM Vehicle v
JOIN Maintenance_Log ml ON v.License_Plate = ml.License_Plate
GROUP BY v.License_Plate, v.Vehicle_Type
HAVING SUM(ml.Cost) > (
    SELECT AVG(Total_Cost) FROM (
        SELECT SUM(Cost) as Total_Cost FROM Maintenance_Log GROUP BY License_Plate
    ) AS AvgTable
);

-----------------------------------------------------------------------------------------------------------
--דוח עלויות טיפולי מוסך מקובץ לפי תחנה וחודש (שימוש בתאריכים וקיבוץ)
SELECT 
    s.Station_Name,
    EXTRACT(YEAR FROM ml.Treatment_Date) AS Treatment_Year,
    EXTRACT(MONTH FROM ml.Treatment_Date) AS Treatment_Month,
    COUNT(ml.Log_ID) AS Number_Of_Treatments,
    SUM(ml.Cost) AS Total_Cost
FROM Maintenance_Log ml
JOIN Vehicle v ON ml.License_Plate = v.License_Plate
JOIN Station s ON v.Station_ID = s.Station_ID
GROUP BY s.Station_Name, EXTRACT(YEAR FROM ml.Treatment_Date), EXTRACT(MONTH FROM ml.Treatment_Date)
ORDER BY Treatment_Year DESC, Treatment_Month DESC, Total_Cost DESC;

-----------------------------------------------------------------------------------------------------------
--היסטוריית חלוקת מדים - מנפק מול מקבל 
SELECT 
    ui.Issue_Date,
    ui.Gear_Type,
    ui.Size,
    receiver.Full_Name AS Receiver_Name,
    issuer.Full_Name AS Issuer_Name,
    issuer.Role AS Issuer_Role
FROM Uniform_Issues ui
JOIN Personnel receiver ON ui.Worker_ID = receiver.Worker_ID
JOIN Personnel issuer ON ui.Worker_ID_Issuer = issuer.Worker_ID
ORDER BY ui.Issue_Date DESC;

-----------------------------------------------------------------------------------------------------------
--ציוד כיול שחזר עם סטטוס כשלון, מספר הכישלונות, ותאריך הכישלון האחרון לפי תחנה
SELECT 
    ec.Item_Name,
    s.Station_Name,
    COUNT(cl.Calibration_ID) AS Total_Fails,
    MAX(cl.Check_Date) AS Last_Fail_Date
FROM Calibration_Logs cl
JOIN Equipment_Catalog ec ON cl.Item_Code = ec.Item_Code
JOIN Station s ON cl.Station_ID = s.Station_ID
WHERE cl.Result_Status = 'Fail'
GROUP BY ec.Item_Name, s.Station_Name
HAVING COUNT(cl.Calibration_ID) >= 2
ORDER BY Total_Fails DESC;


-----------------------------------------------------------------------------------------------------------
--הזמנות רכש פתוחות (טרם סופקו) וכמות הפריטים הכוללת שהוזמנה בהן
SELECT 
    po.Order_ID,
    po.Order_Date,
    po.Delivery_Date,
    sup.Company_Name,
    s.Station_Name,
    SUM(oi.Amount) AS Total_Items
FROM Purchase_Order po
JOIN Supplier sup ON po.Supplier_ID = sup.Supplier_ID
JOIN Station s ON po.Station_ID = s.Station_ID
JOIN Order_Items oi ON po.Order_ID = oi.Order_ID
WHERE po.Delivery_Date > '2024-02-01' --should be CURRENT
GROUP BY po.Order_ID, po.Order_Date, po.Delivery_Date, sup.Company_Name, s.Station_Name
ORDER BY po.Delivery_Date ASC;