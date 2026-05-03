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
-- מחיקת טיפולי מוסך בעלות של פחות מ-100 שקלים, 
-- שבוצעו על רכבים המשויכים לתחנות בעיר ירושלים
DELETE FROM Maintenance_Log
WHERE Cost < 100 
AND License_Plate IN (
    SELECT v.License_Plate 
    FROM Vehicle v
    JOIN Station s ON v.Station_ID = s.Station_ID
    WHERE s.City = 'Jerusalem'
);