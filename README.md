# Database Project

**Submitted by:** Harel Gabay  
**Subject:** MDA Logistics 

---

## Table of Contents
1. [Phase 1](#phase-1)
   * [Project Overview](#project-overview)
   * [Google Ai Studio](#google-ai-studio)
   * [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
   * [Data Structure Diagram (DSD)](#data-structure-diagram-dsd)
   * [SQL Scripts](#sql-scripts)
   * [Data Insertion](#data-insertion)
   * [Backup Process](#backup-process)
2. [Phase 2](#phase-2)
   * [Queries](#queries)
     - [Select Queries](#select-queries)
     - [Update Queries](#update-queries)
     - [Delete Queries](#delete-queries)
   * [Rollback and Commit](#rollback-and-commit)
   * [Constraints](#constraints)
   * [Indexes](#indexes)
---

## Phase 1

### Project Overview
The project manages the complex logistics of an MDA organization, focusing on operational readiness—tracking stations, personnel, fleet maintenance, and inventory without handling private medical records.

#### Purpose of the Database
The primary goals of this project are:
* **Database Design**: Creating a well-structured relational database normalized to 3NF.
* **Efficient Data Storage**: Organizing data to allow quick retrieval and manipulation.
* **Data Integrity and Consistency**: Implementing constraints (PK, FK, Check) to maintain valid data.
* **Backup and Recovery**: Ensuring that data is not lost and can be restored when needed.

#### Key Functionalities
* **Data storage and retrieval** using advanced SQL queries.
* **Relationships between tables** ensuring logical connections and referential integrity.
* **Simulating real-world scenarios** where database management is crucial for life-saving logistics.
* **Automation of data entry** using external Python scripts and bulk injection tools.

### Google Ai Studio
* **Live Website:** [MDA Logistics](https://ems-logistics-pro-505350528104.us-west1.run.app/)

1. **Main Dashboard**: Overview of active vehicles and logistical activities. ![Main Dashboard](./Phase_1/Images/Screen4.png)
2. **Inventory & Procurement**: Management of station inventory and purchase orders. ![Inventory & Procurement](./Phase_1/Images/Screen5.png)
3. **Fleet Management**: Tracking of ambulance fleet details and garage logs. ![Fleet Management](./Phase_1/Images/Screen1.png)
4. **Compliance & Tracking**: Sensitive tracking for equipment calibration and substances. ![Compliance & Tracking](./Phase_1/Images/Screen2.png)
5. **Personnel & Gear**: Directory of medical staff and gear logs. ![Personnel & Gear](./Phase_1/Images/Screen3.png)

### Entity Relationship Diagram (ERD)
The conceptual data model mapping out 12 core entities and their relationships.
![ERD Screenshot](./Phase_1/Images/erd.png)

### Data Structure Diagram (DSD)
The logical database schema normalized to **3NF**, including PK/FK mappings.
![DSD Screenshot](./Phase_1/Images/dsd.png)

### SQL Scripts
**The following SQL scripts are included in the repository:**

* **Create Tables:** Defines the database schema.
* [📜 View](./Phase_1/Sql_commands/createTables.sql)
* **Insert Data:** Populates the tables with sample data.
* [📜 View](./Phase_1/Sql_commands/insertTables.sql)
* **Drop Tables:** Removes all tables from the database.
* [📜 View](./Phase_1/Sql_commands/dropTables.sql)
* **Select All Data:** Retrieves all data from the tables.
* [📜 View](./Phase_1/Sql_commands/selectAll.sql)

### Data Insertion

#### 1. Phase A: Manual Baseline
Small-scale, high-quality manual insertions were performed to verify schema constraints and relationship integrity.
* **File:** [insertTables.sql](./Phase_1/sql_commands/insertTables.sql)

#### 2. Phase B: Institutional Scaling (500+ Records)
To reach a realistic scale for a national EMS organization, a Python-based generator was developed using the **Faker** library. This phase populated 9 core tables with over **500 records each**.
* **Methodology**: Uses an idempotent approach with `ON CONFLICT DO NOTHING` to allow repeatable generation without collisions.
* **Script:** [generate_sql.py](./Phase_1/Programming/generate_sql.py)

#### 3. Phase C: Bulk Injection (40,000+ Records)
Simulating years of operational history, we injected **20,000 records each** into `Maintenance_Log` and `Controlled_Substances_Log`.
* **Mock Data Generation (Mockaroo)**: Used to generate random CSV files for data insertion.
![Mock Data](./Phase_1/Images/mock_data.png)
* **Bulk Loading**: Utilizes the PostgreSQL **COPY** command for high-speed injection, bypassing standard INSERT overhead.
* **Script:** [insert_to_db.py](./Phase_1/mockarooFiles/insert_to_db.py)

Final state of tables:
![CountAll](./Phase_1/Images/CountAll.png)

### Backup Process
The backup was generated using the **pgAdmin 4** management interface. We fully restored it on a fresh container to ensure data portability.
![pgAdmin Backup Process Placeholder](./Phase_1/Images/backup.png)
![pgAdmin Restore Process Placeholder](./Phase_1/Images/restore.jpg)

* **File:** [backup_23_03_2026.sql](./Phase_1/backup_23_03_2026.sql)

---

## **Phase 2**
### Queries

#### Select Queries:
**1. ספקים שלא ביצעו הזמנות משנת 2025**

הסבר יעילות: תצורה 1 (NOT EXISTS) מומלצת כי היא עוצרת מיד כשנמצאת התאמה. תצורה 2 (LEFT JOIN) מאלצת לבצע חיבור מלא של הטבלאות בזיכרון ורק אז מסננת ערכי NULL.
![codePic](./Phase_2/Images/select/select1code.png)
![outcomePic](./Phase_2/Images/select/select1.png)

**2. עובדים שמשכו חומרים נרקוטים בחודש נובמבר 2025**

הסבר יעילות: תצורה 1 (IN) עדיפה כי היא בודקת רק קיום של רשומה. תצורה 2 (JOIN) משכפלת רשומות ומאלצת שימוש ב-DISTINCT, המצריך פעולת מיון (Sort) שגוזלת משאבים רבים.
![codePic](./Phase_2/Images/select/select2code.png)
![outcomePic](./Phase_2/Images/select/select2.png)

**3. פריטי ציוד רפואי שהכמות שלהם במלאי קטנה מ-10**

הסבר יעילות: תצורה 1 (JOIN) הרבה יותר יעילה. תצורה 2 מריצה תתי-שאילתות בשורת ה-SELECT עבור כל שורה שמוחזרת (בעיית N+1), מה שמאט מאוד את זמן הריצה.
![codePic](./Phase_2/Images/select/select3code.png)
![outcomePic](./Phase_2/Images/select/select3.png)

**4. רכבים שעלות הטיפולים שלהם גבוהה מהממוצע הארצי**

הסבר יעילות: תצורה 1 (WITH - CTE) מחשבת את הממוצע הארצי פעם אחת בלבד ושומרת אותו בזיכרון. לכן היא קריאה ויעילה יותר לעומת תצורה 2 שמחשבת זאת מחדש בתוך ה-HAVING.
![codePic](./Phase_2/Images/select/select4code.png)
![outcomePic](./Phase_2/Images/select/select4.png)

**5. דוח עלויות טיפולי מוסך מקובץ לפי תחנה וחודש**
![codePic](./Phase_2/Images/select/select5code.png)
![outcomePic](./Phase_2/Images/select/select5.png)

**6. היסטוריית חלוקת מדים - מנפק מול מקבל**
![codePic](./Phase_2/Images/select/select6code.png)
![outcomePic](./Phase_2/Images/select/select6.png)

**7. ציוד כיול שחזר עם סטטוס כשלון, מספר כישלונות, ותאריך אחרון לפי תחנה**
![codePic](./Phase_2/Images/select/select7code.png)
![outcomePic](./Phase_2/Images/select/select7.png)

**8. הזמנות רכש פתוחות טרם סופקו וכמות הפריטים שהוזמנה**
![codePic](./Phase_2/Images/select/select8code.png)
![outcomePic](./Phase_2/Images/select/select8.png)


#### Update Queries

##### **1 – עדכון כמות מלאי לציוד רפואי בתחנות ירושלים**
שאילתא זו מגדילה ב־10% את כמות המלאי של פריטים רפואיים בתחנות הממוקמות בעיר ירושלים.

לפני:
![beforePic](./Phase_2/Images/update/update1before.png)

אחרי:
![afterPic](./Phase_2/Images/update/update1after.png)


##### **2 – עדכון שיוך רכבים ישנים לתחנה 500**
שאילתא זו מעבירה רכבים שיוצרו לפני שנת 2020 מסוג ALS Ambulance או MICU לתחנה מספר 500.

לפני:
![beforePic](./Phase_2/Images/update/update2before.jpg)

אחרי:
![afterPic](./Phase_2/Images/update/update2after.png)



##### **3 – דחיית תאריך אספקה להזמנות מספק 101**
שאילתא זו דוחה ב־5 ימים את תאריך האספקה של הזמנות מספק מספר 101 אשר טרם סופקו.

לפני:
![beforePic](./Phase_2/Images/update/update3before.png)

אחרי:
![afterPic](./Phase_2/Images/update/update3after.png)


#### Delete Queries

##### **1 – מחיקת לוגים ישנים של ציוד כיול**
שאילתא זו מוחקת רשומות של בדיקות כיול שעברו בהצלחה ובוצעו לפני יותר מ־5 שנים.

לפני:
![beforePic](./Phase_2/Images/delete/delete1before.png)

אחרי:
![afterPic](./Phase_2/Images/delete/delete1after.png)


##### **2 – מחיקת טיפולים זולים לפני שנת 2020**
שאילתא זו מוחקת טיפולי מוסך בעלות נמוכה מ־100 ש"ח שבוצעו לפני שנת 2020.

לפני:
![beforePic](./Phase_2/Images/delete/delete2before.png)

אחרי:
![afterPic](./Phase_2/Images/delete/delete2after.png)


##### **3 – מחיקת טיפולים זולים לרכבים בירושלים**
שאילתא זו מוחקת טיפולי מוסך בעלות נמוכה מ־100 ש"ח שבוצעו על רכבים המשויכים לתחנות בעיר ירושלים.

לפני:
![beforePic](./Phase_2/Images/delete/delete3before.png)

אחרי:
![afterPic](./Phase_2/Images/delete/delete3after.png)

### Rollback and Commit
[Code Rollback and Commit](/Phase_2/RollbackCommit.sql)

#### Rollback
**איפוס כמות ממוצר בתחנה**

לפני:
![beforePic](./Phase_2/Images/rollback/before.png)

אחרי:
![afterPic](./Phase_2/Images/rollback/after.png)

ביצוע ROLLBACK:
![rollbackPic](./Phase_2/Images/rollback/rollback.png)

אחרי:
![beforePic](./Phase_2/Images/rollback/before.png)

#### Commit
**שינוי תפקיד לעובד**

לפני:
![beforePic](/Phase_2/Images/commit/before.png)

אחרי:
![afterPic](/Phase_2/Images/commit/after.png)

ביצוע COMMIT:
![commitPic](/Phase_2/Images/commit/commit.png)

אחרי:
![afterPic](/Phase_2/Images/commit/after.png)

### Constraints
[Code Of Constraints](/Phase_2/constraints.sql)

#### **אילוץ ראשון:** כל אמייל חייב להכיל @ בתוכו
הקוד שניסינו להריץ:
![code1](./Phase_2/Images/constraints/code1.png)

מישום שזה נוגד לאילוץ קיבלנו את השגיאה הבאה:
![error1](/Phase_2/Images/constraints/error1.png)

#### **אילוץ שני:** הגבלת כמות האפשרית למשיכה של חומרים רגישיים בפעם אחת ל 50
הקוד שניסינו להריץ:
![code2](./Phase_2/Images/constraints/code2.png)

מישום שזה נוגד לאילוץ קיבלנו את השגיאה הבאה:
![error2](/Phase_2/Images/constraints/error2.png)

#### **אילוץ שלישי:** שנת ייצור של רכב חייבת להיות קטנה או שווה לשנת רכישה
הקוד שניסינו להריץ:
![code3](./Phase_2/Images/constraints/code3.png)

מישום שזה נוגד לאילוץ קיבלנו את השגיאה הבאה:
![error3](/Phase_2/Images/constraints/error3.png)

### Indexes
#### **אינדקס ראשון על תאריך טיפול (Maintenance_Log):** 
לפני:
![before](/Phase_2/Images/index/index1before.png)

אחרי:
![after](/Phase_2/Images/index/index1after.png)

#### **אינדקס שני על ת.ז עובד (Maintenance_Log):** 
לפני:
![before](/Phase_2/Images/index/index2before.png)

אחרי:
![after](/Phase_2/Images/index/index2after.png)

#### **אינדקס שלישי על קוד פריט רגיש במשיכות (Controlled_Substances_Log):** 
לפני:
![before](/Phase_2/Images/index/index3before.png)

אחרי:
![after](/Phase_2/Images/index/index3after.png)

#### **הסבר לתוצאות:**
לפני הוספת האינדקסים, מסד הנתונים נאלץ לבצע סריקה מלאה של כל 20,000 השורות בטבלה כדי למצוא את הנתונים המבוקשים (פעולה המכונה Full Table Scan), מה שלקח זמן רב יותר. לאחר יצירת האינדקסים, מסד הנתונים השתמש במבנה נתונים ממוין (B-Tree) המאפשר "קפיצה" ישירה לנתונים הרלוונטיים (Index Seek), וכתוצאה מכך זמן הריצה התקצר משמעותית לאלפיות שנייה בודדות.

* **File:** [backup_03_05_2026.sql](./Phase_2/backup_03_05_2026.sql)

## שלב ג' – אינטגרציית בסיסי נתונים ומבטים מתקדמים

## 1. תרשימי ה-ERD וה-DSD המעודכנים

### 1.1 תרשים קונספטואלי (ERD)
מציג את ישות האם `Personnel` ואת קשר ההורשה (IS-A) המתפצל לישויות הבנות `Drivers` ו-`Volunteers` (ביחס של 1:1). בנוסף, מוצגת ישות `Emergency_Dispatches` (שיגורים) המקושרת לנהג ולרכב, ואת קשר הרבים-לרבים (M:N) `Crew_Of` בין מתנדבים לשיגורים.

![תרשים ERD מעודכן ומאוחד](Phase_3/new_ERD.png)

### 1.2 תרשים מבני / סכמה רלציונית (DSD)
מציג את הטבלאות הפיזיות, מפתחות ראשיים (PK) ומפתחות זרים (FK). בתרשים זה ניתן לראות את טבלת הגישור הפיזית `dispatch_volunteers` המכילה מפתח ראשי מורכב, וכן את הקישורים הישירים מטבלאות הרכש, המדים והמוסך אל טבלת האם `personnel`.

![תרשים DSD / סכמה רלציונית מעודכנת](Phase_3/new_DSD.png)

---

## 2. החלטות שנעשו בשלב האינטגרציה

במהלך מיזוג המערכת המבצעית-רפואית עם המערכת הלוגיסטית ומערכת משאבי האנוש, התמודדנו עם אתגר ארכיטקטוני מורכב: כיצד להחיל חוקים מבצעיים נוקשים על אנשי הצוות מבלי לפגוע בשלמות הנתונים של המערכת הלוגיסטית (שבה כלל אנשי הצוות מבצעים פעולות רכש, ניפוק מדים או טיפול ברכבים).

להלן ההחלטות ההנדסיות המרכזיות שנתקבלו:

1. **אימוץ מודל הכללה והתמחות (Supertype / Subtype):** הוחלט לשמר את טבלת `personnel` המקורית כטבלת אב (Supertype). היא מרכזת את הפרטים האישיים והשיוך התחנתי של כלל העובדים בארגון. תחתיה, הוקמו שתי טבלאות בנות – `drivers` ו-`volunteers` – המקושרות אליה בקשר ירושה (1:1). החלטה זו מנעה כפילות נתונים (Data Redundancy) ושמרה על שלמות מוחלטת של כל קשרי הלוגיסטיקה הקיימים.
2. **ייצוג קשר רבים-לרבים לצוותי המשימה:** באמבולנס יחיד משובץ נהג אחד בדיוק, אך מספר משתנה של מתנדבים. כדי לאפשר שיבוץ דינמי זה תוך שמירה על נרמול, הוקמה טבלת גישור ייעודית בשם `dispatch_volunteers`.
3. **העברת אכיפת החוקים העסקיים לרמת מסד הנתונים (Triggers):** הוחלט לנעול את החוקים המבצעיים באמצעות טריגרים הרצים לפני פעולות הוספה או עדכון, כגון:
    * **טריגר אימות נוכחות בצוות:** מונע רישום של איש צוות כמבצע פעולה רפואית בשטח, אלא אם המערכת מאמתת שהוא שובץ פיזית באמבולנס הספציפי שייצא לאירוע.
    * **טריגר סמכות מסירה למיון:** חוסם כל ניסיון לחתום על טופס העברת מטופל לבית חולים, אלא אם החותם הוא הנהג המוגדר של אותה הנסיעה.
4. **פתרון בעיית אופטימיזציית ההגרלה ב-PostgreSQL:** כדי להבטיח פיזור אקראי אמיתי של שיבוץ רכבים ונהגים לכל נסיעה (ולמנוע שיוך של אותו רכב לכל הנסיעות בבת אחת בשל אופטימיזציית מנוע), השתמשנו בהמרת עמודות למערכים דינמיים ושליפת אינדקס אקראי המחושב מחדש אקטיבית לכל שורת נתונים בנפרד.

---

## 3. הסבר מילולי של התהליך והפקודות

תהליך המיזוג והחלת הארכיטקטורה החדשה בוצע במספר פעימות של שאילתות ופעולות על בסיס הנתונים:

* **שלב א' - פיצול ישויות (Subtypes):** יצרנו את טבלאות הנהגים והמתנדבים. הנתונים נשאבו לתוכן מתוך טבלת `personnel` המקורית באמצעות חיתוך טקסטואלי על שדה התפקיד, תוך הגדרת מפתח ראשי המהווה גם מפתח זר לטבלת האם עם חוק מחיקה מדורגת.
* **שלב ב' - הרחבת התשתיות:** הוספנו את עמודות הקישור הנדרשות לטבלאות המבצעיות (כגון שדה מזהה נהג או לוחית רישוי בטבלת השיגורים), ויצרנו פיזית את טבלת הגישור של המתנדבים עם מפתח ראשי מורכב למניעת כפילויות שיבוץ באותה נסיעה.
* **שלב ג' - סימולציה ויישור נתונים לוגי (Data Alignment):** ביצענו עדכון גורף לשיבוץ רנדומלי של רכבים ונהגים חוקיים לכל משימה. בנוסף, סינכרנו את הזמנים כך שזמני ההגעה והעזיבה יהיו כרונולוגיים והגיוניים לזמן הקריאה, ודאגנו להתאמה גיאוגרפית של בית החולים הקולט. להגרלת המתנדבים השתמשנו בלולאת הצלבה מתקדמת.
* **שלב ד' - החלת אילוצי שלמות (Constraints):** הוגדרו המפתחות הזרים הפיזיים אשר חוסמים הזנת רשומות ללא סימוכין (למשל, שיגור רכב שאינו קיים במצבת הרכבים או נהג שלא קיים בטבלת נהגים).
* **שלב ה' - פיתוח טריגרים (Triggers):** נכתבו פונקציות אכיפה אשר בודקות תנאים לוגיים המאחדים את צוות הנהגים והמתנדבים בנסיעה ספציפית, וזורקות שגיאה חמורה העוצרת את התהליך במידה ויש ניסיון להזין נתון המפר את נוהלי הארגון.

---

## 4. תיאור מילולי של המבטים ושליפת נתונים בסיסית

### מבט 1: אגף משאבי אנוש ולוגיסטיקה (`hr_personnel_deployment_view`)
**תיאור מילולי:** מבט ניהולי המחבר בין טבלת האם של העובדים לטבלת התחנות, ומבצע בדיקה דינמית מול טבלאות הבנות כדי לקבוע באופן מילולי האם העובד מתפקד בארגון כנהג ('Driver') או כמתנדב ('Volunteer'). המבט חוסך למנהל כוח האדם את הצורך לבצע תתי-שאילתות מורכבות בעת הפקת דוח מצבת עובדים.

![פלט שליפת נתונים בסיסית - מבט 1](Phase_3/view_1/View_1.png)

---

### מבט 2: האגף המבצעי-רפואי (`medical_procedures_tracking_view`)
**תיאור מילולי:** מבט המיועד לבקרת איכות רפואית. הוא משלב נתונים מטבלת הטיפולים הרפואיים בשטח, טבלת נסיעות החירום, טבלת האירועים המרכזית וטבלת העובדים. המבט מציג תמונה אחודה הכוללת את שם הטיפול, אחוז ההצלחה, רמת החומרה, וסוג המקרה, לצד שמו המלא של איש הצוות שביצע את הטיפול בפועל (נהג או מתנדב).

![פלט שליפת נתונים בסיסית - מבט 2](Phase_3/view_2/View_2.png)

---

### מבט 3: אינטגרציית מערכות - המבט המשולב (`integrated_mission_log_view`)
**תיאור מילולי:** זהו המבט האינטגרטיבי המרכזי של הפרויקט, המהווה גשר ישיר בין האגף המבצעי לאגף הלוגיסטי. עבור כל נסיעת חירום, המבט שולף את זמן ההזנקה וחומרת האירוע, ומחבר אותם ישירות ללוחית הרישוי של הרכב, סוג האמבולנס, תחנת האם אליה הרכב שייך, ושמו המלא של הנהג שהוביל את המשימה.

![פלט שליפת נתונים בסיסית - מבט 3](Phase_3/view_3/View_3.png)

---

## 5. שאילתות משמעותיות על המבטים

### 5.1 שאילתות על מבט משאבי אנוש ולוגיסטיקה

#### שאילתא א': התפלגות כוח אדם בתחנות
**תיאור מילולי:** שאילתא ניהולית המציגה את התפלגות התפקידים בארגון. היא מקבצת את הנתונים לפי תחנה ולפי סוג העובד, וסופרת כמה נהגים וכמה מתנדבים רשומים ומסווגים בכל תחנה.

![פלט שאילתא 1א](Phase_3/view_1/Select_1_1.png)

#### שאילתא ב': יומן כוננות נהגים מרחבי
**תיאור מילולי:** שליפת רשימת שמותיהם המלאים של כלל אנשי הצוות המוגדרים כנהגים ומשרתים בתחנות במחוז או בעיר ספציפית, לצורך שיבוץ משמרות זמין ויעיל.

![פלט שאילתא 1ב](Phase_3/view_1/Select_1_2.png)

---

### 5.2 שאילתות על מבט מעקב פרוצדורות רפואיות

#### שאילתא א': בקרת מקרים קריטיים
**תיאור מילולי:** איתור וריכוז של כל הפעולות הרפואיות שבוצעו בשטח באירועים קריטיים במיוחד (דרגת חומרה 5). השאילתה מסדרת את הנתונים לפי רמת הצלחת הטיפול בסדר יורד, לשם ביצוע תחקיר אירוע והפקת לקחים רפואיים.

![פלט שאילתא 2א](Phase_3/view_2/Select_2_1.png)

#### שאילתא ב': איתור אנשי צוות פעילים
**תיאור מילולי:** שאילתת אופטימיזציה המזהה מיהם חמשת אנשי הצוות (נהגים או מתנדבים) הפעילים ביותר בשטח, אשר ביצעו בפועל את כמות הפרוצדורות הרפואיות הגבוהה ביותר מתוך סך כלל האירועים.

![פלט שאילתא 2ב](Phase_3/view_2/Select_2_2.png)

---

### 5.3 שאילתות על המבט המשולב

#### שאילתא א': יומן פעילות כלי רכב
**תיאור מילולי:** הפקת דוח היסטורי ומלא עבור אמבולנס ספציפי המציג מתי הוא הוזנק לאירוע, מה הייתה חומרת המקרה, ומי הנהג שפיקד על הרכב באותה נסיעה. מיועד למעקב קילומטראז' מבצעי וטיפולים מונעים של הצי.

![פלט שאילתא 3א](Phase_3/view_3/Select_3_1.png)

#### שאילתא ב': ניתוח עומסי חירום למרחב
**תיאור מילולי:** שאילתת אסטרטגיה המדרגת את כמות אירועי החירום הקשים (חומרה 4 ו-5) שהוזנקו מכל תחנה לוגיסטית, במטרה לאתר נקודות פריסה הדורשות תגבור עתידי של ניידות טיפול נמרץ (נט"ן).

![פלט שאילתא 3ב](Phase_3/view_3/Select_3_2.png)

