
-- ODEV 2 - BOLUM D
-- UNIVERSITE KULUP VE ETKINLIK YONETIM SISTEMI
-- ILISKISEL CEBIR SORULARININ SQL KARSILIKLARI


-- D1: SELECTION VE PROJECTION
-- Kapasitesi 50'den buyuk etkinliklerin adlari nelerdir?

\echo D1 - Kapasitesi 50'den buyuk etkinlikler

SELECT DISTINCT event_name
FROM event
WHERE capacity > 50
ORDER BY event_name;


-- D2: JOIN
-- Spor etkinliklerine kayitli ogrenciler ve etkinlikleri nelerdir?

\echo D2 - Spor etkinliklerine kayitli ogrenciler

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    e.event_name
FROM student s
JOIN event_registration er
    ON s.student_id = er.student_id
JOIN event e
    ON er.event_id = e.event_id
WHERE e.category = 'sport'
ORDER BY s.student_id, e.event_id;


-- D3: UNION
-- Spor veya teknoloji etkinliklerine kayitli ogrenciler kimlerdir?

\echo D3 - Spor veya teknoloji etkinliklerine katilanlar

SELECT er.student_id
FROM event_registration er
JOIN event e ON er.event_id = e.event_id
WHERE e.category = 'sport'

UNION

SELECT er.student_id
FROM event_registration er
JOIN event e ON er.event_id = e.event_id
WHERE e.category = 'technology'

ORDER BY student_id;


-- D4-A: DIFFERENCE (EXCEPT)
-- Hicbir etkinlige kaydolmamis ogrenciler kimlerdir?

\echo D4-A - EXCEPT yontemi

SELECT student_id, first_name, last_name
FROM student

EXCEPT

SELECT s.student_id, s.first_name, s.last_name
FROM student s
JOIN event_registration er
    ON s.student_id = er.student_id

ORDER BY student_id;


-- D4-B: DIFFERENCE (NOT EXISTS)
-- Ayni sorunun ikinci SQL cozumu.

\echo D4-B - NOT EXISTS yontemi

SELECT
    s.student_id,
    s.first_name,
    s.last_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM event_registration er
    WHERE er.student_id = s.student_id
)
ORDER BY s.student_id;


-- D5: RENAME VE SELF JOIN
-- Ayni bolumde okuyan farkli ogrenci ciftleri kimlerdir?

\echo D5 - Ayni bolumde okuyan ogrenci ciftleri

SELECT
    s1.first_name AS ogrenci_1,
    s2.first_name AS ogrenci_2,
    s1.department AS bolum
FROM student s1
JOIN student s2
    ON s1.department = s2.department
    AND s1.student_id < s2.student_id
ORDER BY s1.student_id, s2.student_id;


-- D6: DIVISION
-- Spor kategorisindeki TUM etkinliklere kayitli
-- ogrenciler kimlerdir?
-- Ic ice iki NOT EXISTS kullanilmistir.

\echo D6 - Tum spor etkinliklerine kayitli ogrenciler

SELECT
    s.student_id,
    s.first_name,
    s.last_name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM event e
    WHERE e.category = 'sport'
      AND NOT EXISTS (
          SELECT 1
          FROM event_registration er
          WHERE er.student_id = s.student_id
            AND er.event_id = e.event_id
      )
)
ORDER BY s.student_id;
