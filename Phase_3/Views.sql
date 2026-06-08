----view 1----
CREATE OR REPLACE VIEW hr_personnel_deployment_view AS
SELECT 
    p.worker_id,
    p.full_name,
    p.role,
    s.station_name,
    s.city AS station_city,
    CASE 
        WHEN d.worker_id IS NOT NULL THEN 'Driver'
        WHEN v.worker_id IS NOT NULL THEN 'Volunteer'
        ELSE 'General Staff' 
    END AS worker_type
FROM public.personnel p
JOIN public.station s ON p.station_id = s.station_id
LEFT JOIN public.drivers d ON p.worker_id = d.worker_id
LEFT JOIN public.volunteers v ON p.worker_id = v.worker_id;

SELECT station_name, worker_type, COUNT(worker_id) AS total_workers
FROM hr_personnel_deployment_view
GROUP BY station_name, worker_type
ORDER BY station_name, worker_type;

SELECT full_name, station_name 
FROM hr_personnel_deployment_view
WHERE worker_type = 'Driver' AND station_city = 'Jerusalem';



----view 2----
CREATE OR REPLACE VIEW medical_procedures_tracking_view AS
SELECT 
    pp.action_id_,
    pp.procedure_name_,
    pp.success_rate_,
    i.severity_level_ AS incident_severity,
    it.type_name_ AS incident_type,
    p.full_name AS treating_worker_name
FROM public.procedures_performed pp
JOIN public.emergency_dispatches ed ON pp.dispatch_id_ = ed.dispatch_id_
JOIN public.incidents i ON ed.incident_id_ = i.incident_id_
JOIN public.incident_types it ON i.type_id_ = it.type_id_
JOIN public.personnel p ON pp.treating_worker_id = p.worker_id;

SELECT * FROM medical_procedures_tracking_view
LIMIT 10;

SELECT procedure_name_, treating_worker_name, success_rate_
FROM medical_procedures_tracking_view
WHERE incident_severity = 5
ORDER BY success_rate_ DESC;

SELECT treating_worker_name, COUNT(action_id_) AS total_procedures_performed
FROM medical_procedures_tracking_view
GROUP BY treating_worker_name
ORDER BY total_procedures_performed DESC
LIMIT 5;




----view 3----
CREATE OR REPLACE VIEW integrated_mission_log_view AS
SELECT 
    ed.dispatch_id_,
    ed.dispatch_time_,
    i.severity_level_ AS incident_severity,
    v.license_plate,
    v.vehicle_type,
    p.full_name AS driver_name,
    s.station_name AS dispatching_station
FROM public.emergency_dispatches ed
JOIN public.incidents i ON ed.incident_id_ = i.incident_id_
JOIN public.vehicle v ON ed.license_plate = v.license_plate
JOIN public.personnel p ON ed.driver_id = p.worker_id
JOIN public.station s ON v.station_id = s.station_id;

select * from integrated_mission_log_view
limit 10;

SELECT dispatch_time_, driver_name, incident_severity
FROM integrated_mission_log_view
WHERE license_plate = '34-852-339' 
ORDER BY dispatch_time_ DESC;

SELECT dispatching_station, COUNT(dispatch_id_) AS critical_dispatches
FROM integrated_mission_log_view
WHERE incident_severity >= 4
GROUP BY dispatching_station
ORDER BY critical_dispatches DESC;
