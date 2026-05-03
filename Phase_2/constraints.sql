ALTER TABLE Personnel 
ADD CONSTRAINT chk_email_valid CHECK (Email LIKE '%@%');

ALTER TABLE Controlled_Substances_Log 
ADD CONSTRAINT chk_max_withdrawal CHECK (Amount_Drawn <= 50);

ALTER TABLE Vehicle 
ADD CONSTRAINT chk_manufacture_vs_purchase CHECK (Manufacture_Year <= EXTRACT(YEAR FROM Purchase_Date));