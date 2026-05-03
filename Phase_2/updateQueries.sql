--עדכון כמות המלאי (תוספת 10%) לפריטים רפואיים בתחנות ירושלים
UPDATE Station_Inventory
SET Quantity = Quantity * 1.10
WHERE Station_ID IN (SELECT Station_ID FROM Station WHERE City = 'Jerusalem')
AND Item_Code IN (SELECT Item_Code FROM Equipment_Catalog WHERE Category = 'Medical Device');

-----------------------------------------------------------------------------------------------------------
UPDATE Vehicle
SET Station_ID = 500
WHERE Manufacture_Year < 2020 
AND Vehicle_Type IN ('ALS Ambulance', 'MICU');

-----------------------------------------------------------------------------------------------------------
--דחיית תאריך אספקה ב-5 ימים להזמנות מספק ספציפי (מזהה 101) שטרם סופקו
UPDATE Purchase_Order
SET Delivery_Date = Delivery_Date + INTERVAL '5 days'
WHERE Supplier_ID = 101 AND Delivery_Date >= CURRENT_DATE;

