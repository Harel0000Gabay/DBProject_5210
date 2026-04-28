--ROLLBACK
BEGIN; 

UPDATE Station_Inventory 
SET Quantity = 0 
WHERE Station_ID = 1 AND Item_Code = 'MED-001';


SELECT * FROM Station_Inventory WHERE Station_ID = 1 AND Item_Code = 'MED-001';

ROLLBACK;
SELECT * FROM Station_Inventory WHERE Station_ID = 1 AND Item_Code = 'MED-001';

--COMMIT
BEGIN; 

UPDATE Personnel 
SET Role = 'Paramedic' 
WHERE Worker_ID = 101;

SELECT * FROM Personnel WHERE Worker_ID = 101;
COMMIT;
SELECT * FROM Personnel WHERE Worker_ID = 101;