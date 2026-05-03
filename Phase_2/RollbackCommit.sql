-- ROLLBACK
BEGIN; 


SELECT * FROM Station_Inventory WHERE Station_ID = 502 AND Item_Code = 'ITM-1008';

UPDATE Station_Inventory 
SET Quantity = 0 
WHERE Station_ID = 502 AND Item_Code = 'ITM-1008';

SELECT * FROM Station_Inventory WHERE Station_ID = 502 AND Item_Code = 'ITM-1008';

ROLLBACK;

SELECT * FROM Station_Inventory WHERE Station_ID = 502 AND Item_Code = 'ITM-1008';

-- COMMIT
BEGIN; 

SELECT * FROM Personnel WHERE Worker_ID = 101;

UPDATE Personnel 
SET Role = 'Paramedic' 
WHERE Worker_ID = 101;

SELECT * FROM Personnel WHERE Worker_ID = 101;

COMMIT;

SELECT * FROM Personnel WHERE Worker_ID = 101;