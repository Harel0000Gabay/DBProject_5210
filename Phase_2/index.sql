CREATE INDEX idx_maintenance_date ON Maintenance_Log(Treatment_Date);

CREATE INDEX idx_maintenance_worker ON Maintenance_Log(Worker_ID);

CREATE INDEX idx_substances_item ON Controlled_Substances_Log(Item_Code);