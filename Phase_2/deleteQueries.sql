--מחיקת לוגים של ציוד כיול ישן (מלפני יותר מ-5 שנים) שעבר בהצלחה 
DELETE FROM Calibration_Logs
WHERE Result_Status = 'Pass' 
AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, Check_Date)) > 5;

-----------------------------------------------------------------------------------------------------------
--מחיקת טיפולי מוסך בסכום קטן מ-100 שקלים שבוצעו לפני שנת 2020
DELETE FROM Maintenance_Log
WHERE Cost < 100 
AND EXTRACT(YEAR FROM Treatment_Date) < 2020;

-----------------------------------------------------------------------------------------------------------
--ביטול הזמנה: מחיקת פריטים מהזמנה מסוימת שבוטלה, לפני מחיקת ההזמנה עצמה
DELETE FROM Order_Items
WHERE Order_ID = 5050;

--מחיקת ההזמנה עצמה (טבלת האב):
DELETE FROM Purchase_Order
WHERE Order_ID = 5050;