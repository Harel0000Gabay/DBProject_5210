-- =======================================================================
-- שלב 1: בניית היררכיית עובדים (Supertype / Subtype)
-- טבלת personnel המקורית נשארת כטבלת אם, ואנחנו יוצרים טבלאות בנות
-- =======================================================================

-- 1. יצירת טבלת בן: נהגים (Drivers) - שומרת רק את ה-ID ומקושרת לטבלת האם
CREATE TABLE public.drivers (
    worker_id INTEGER PRIMARY KEY,
    CONSTRAINT fk_driver_is_personnel FOREIGN KEY (worker_id) REFERENCES public.personnel(worker_id) ON DELETE CASCADE
);

-- שאיבת הנהגים פנימה מתוך טבלת האם
INSERT INTO public.drivers (worker_id)
SELECT worker_id FROM public.personnel WHERE role ILIKE '%נהג%' OR role ILIKE '%driver%';

-- 2. יצירת טבלת בן: מתנדבים (Volunteers)
CREATE TABLE public.volunteers (
    worker_id INTEGER PRIMARY KEY,
    CONSTRAINT fk_volunteer_is_personnel FOREIGN KEY (worker_id) REFERENCES public.personnel(worker_id) ON DELETE CASCADE
);

-- שאיבת שאר אנשי הצוות (חובשים, מלווים, נוער)
INSERT INTO public.volunteers (worker_id)
SELECT worker_id FROM public.personnel WHERE role NOT ILIKE '%נהג%' AND role NOT ILIKE '%driver%' OR role IS NULL;

-- =======================================================================
-- שלב 2: הכנת עמודות למערכת המבצעית (נאמנות לשדות ב-ERD)
-- =======================================================================

-- הוספת שדה לוחית רישוי (License_Plate) לטבלת השיגורים כפי שמופיע בתמונה
ALTER TABLE public.emergency_dispatches ADD COLUMN IF NOT EXISTS license_plate VARCHAR(50);
-- הוספת שדה נהג חובה
ALTER TABLE public.emergency_dispatches ADD COLUMN IF NOT EXISTS driver_id INTEGER;

-- עמודת המטפל בשטח (יכול להיות נהג או מתנדב)
ALTER TABLE public.procedures_performed ADD COLUMN IF NOT EXISTS treating_worker_id INTEGER;

-- עמודת המוסר לבית החולים
ALTER TABLE public.transfer_summaries ADD COLUMN IF NOT EXISTS handing_over_worker_id INTEGER;

-- יצירת טבלת הגישור שמקשרת בין שיגור למספר מתנדבים
CREATE TABLE public.dispatch_volunteers (
    dispatch_id_ INTEGER REFERENCES public.emergency_dispatches(dispatch_id_) ON DELETE CASCADE,
    volunteer_id INTEGER REFERENCES public.volunteers(worker_id) ON DELETE CASCADE,
    PRIMARY KEY (dispatch_id_, volunteer_id)
);

-- =======================================================================
-- שלב 3: יישור נתונים וסימולציה הגיונית (Data Alignment)
-- =======================================================================

-- א. שיבוץ לוחית רישוי חוקית ונהג חוקי (מטבלת הבת של הנהגים)
UPDATE public.emergency_dispatches
SET license_plate = (SELECT license_plate FROM public.vehicle ORDER BY random() LIMIT 1),
    driver_id = (SELECT worker_id FROM public.drivers ORDER BY random() LIMIT 1);

-- ב. סימולציית זמנים ריאלית: הגעה אחרי 5-20 דק', עזיבה אחרי 30 דק'
UPDATE public.emergency_dispatches
SET arrival_time_ = dispatch_time_ + (random() * 15 + 5) * interval '1 minute',
    departure_time_ = dispatch_time_ + (random() * 15 + 25) * interval '1 minute'
WHERE dispatch_time_ IS NOT NULL;

-- ג. שיבוץ מתנדב ראשון (חובה) לצוות האמבולנס
INSERT INTO public.dispatch_volunteers (dispatch_id_, volunteer_id)
SELECT ed.dispatch_id_, v.worker_id
FROM public.emergency_dispatches ed
CROSS JOIN LATERAL (
    SELECT worker_id FROM public.volunteers ORDER BY random() LIMIT 1
) v;

-- ד. שיבוץ מתנדב שני אופציונלי (לחלק מהנסיעות)
INSERT INTO public.dispatch_volunteers (dispatch_id_, volunteer_id)
SELECT ed.dispatch_id_, v.worker_id
FROM public.emergency_dispatches ed
CROSS JOIN LATERAL (
    SELECT worker_id FROM public.volunteers 
    WHERE worker_id NOT IN (SELECT volunteer_id FROM public.dispatch_volunteers WHERE dispatch_id_ = ed.dispatch_id_)
    ORDER BY random() LIMIT 1
) v
WHERE random() > 0.4;

-- ה. התאמת בית החולים הקולט למיקום הגיאוגרפי של אירוע החירום
UPDATE public.transfer_summaries ts
SET hospital_id_ = COALESCE(
    (
        SELECT h.hospital_id_
        FROM public.hospitals h
        JOIN public.emergency_dispatches ed ON ed.dispatch_id_ = ts.dispatch_id_
        JOIN public.locations l ON l.incident_id_ = ed.incident_id_
        WHERE h.city_ = l.city_
        LIMIT 1
    ),
    ts.hospital_id_
);

-- ו. הגרלת מבצע הטיפול (מתוך רשימת הנוכחים באמבולנס הספציפי בלבד!)
UPDATE public.procedures_performed pp
SET treating_worker_id = (
    SELECT crew_id FROM (
        SELECT driver_id AS crew_id FROM public.emergency_dispatches WHERE dispatch_id_ = pp.dispatch_id_
        UNION
        SELECT volunteer_id AS crew_id FROM public.dispatch_volunteers WHERE dispatch_id_ = pp.dispatch_id_
    ) as actual_crew
    ORDER BY random() LIMIT 1
);

-- ז. חתימה על טופס ההעברה במיון: חובה - הנהג בלבד
UPDATE public.transfer_summaries ts
SET handing_over_worker_id = (
    SELECT driver_id FROM public.emergency_dispatches WHERE dispatch_id_ = ts.dispatch_id_
);

-- =======================================================================
-- שלב 4: מפתחות זרים (Foreign Keys) - אכיפת קשרים מובנים
-- =======================================================================

-- חיבור שיגורים לרכבים ולנהגים
ALTER TABLE public.emergency_dispatches
  ADD CONSTRAINT fk_dispatches_to_vehicles 
  FOREIGN KEY (license_plate) REFERENCES public.vehicle(license_plate);

ALTER TABLE public.emergency_dispatches 
  ADD CONSTRAINT fk_dispatch_to_drivers 
  FOREIGN KEY (driver_id) REFERENCES public.drivers(worker_id);

-- המטפלים והמוסרים הם עובדים מוכרים (מקושרים לטבלת האם)
ALTER TABLE public.procedures_performed 
  ADD CONSTRAINT fk_procedure_personnel 
  FOREIGN KEY (treating_worker_id) REFERENCES public.personnel(worker_id);

ALTER TABLE public.transfer_summaries 
  ADD CONSTRAINT fk_transfer_personnel 
  FOREIGN KEY (handing_over_worker_id) REFERENCES public.personnel(worker_id);

-- =======================================================================
-- שלב 5: אכיפת חוקים עסקיים מתקדמים (Business Logic Triggers)
-- =======================================================================

-- 1. טריגר: המטפל הרפואי חייב להיות באמבולנס באותו אירוע!
CREATE OR REPLACE FUNCTION public.check_treating_worker_in_crew()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM public.emergency_dispatches WHERE dispatch_id_ = NEW.dispatch_id_ AND driver_id = NEW.treating_worker_id
        UNION
        SELECT 1 FROM public.dispatch_volunteers WHERE dispatch_id_ = NEW.dispatch_id_ AND volunteer_id = NEW.treating_worker_id
    ) THEN
        RAISE EXCEPTION 'הפרת חוק עסקי: העובד שביצע את הטיפול לא היה נוכח בצוות האמבולנס של שיגור %', NEW.dispatch_id_;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_treating_worker
BEFORE INSERT OR UPDATE ON public.procedures_performed
FOR EACH ROW EXECUTE FUNCTION public.check_treating_worker_in_crew();

-- 2. טריגר: אך ורק נהג האמבולנס מוסמך לחתום על טופס קבלה במיון!
CREATE OR REPLACE FUNCTION public.check_handover_is_driver()
RETURNS TRIGGER AS $$
DECLARE
    actual_driver_id INTEGER;
BEGIN
    SELECT driver_id INTO actual_driver_id FROM public.emergency_dispatches WHERE dispatch_id_ = NEW.dispatch_id_;
    
    IF NEW.handing_over_worker_id != actual_driver_id THEN
        RAISE EXCEPTION 'הפרת נהלים: רק נהג האמבולנס (ID: %) מורשה למסור את המטופל למיון בשיגור זה!', actual_driver_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_handover_driver
BEFORE INSERT OR UPDATE ON public.transfer_summaries
FOR EACH ROW EXECUTE FUNCTION public.check_handover_is_driver();

commit;