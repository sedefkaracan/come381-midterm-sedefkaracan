
-- ODEV 2 - BOLUM D: ORNEK VERILER
-- Universite Kulup ve Etkinlik Yonetim Sistemi

-- Bu dosya yalnizca test veritabaninda calistirilmalidir.
-- Her calistirmada ayni sonucu almak icin veriler temizlenir.

BEGIN;

TRUNCATE TABLE
    event_registration,
    club_membership,
    event,
    club,
    student
RESTART IDENTITY CASCADE;


-- 1. OGRENCILER (8 kayit)

INSERT INTO student
(first_name, last_name, email, department)
VALUES
('Ada', 'Yilmaz', 'ada@uni.edu', 'Bilgisayar Muhendisligi'),
('Deniz', 'Kaya', 'deniz@uni.edu', 'Bilgisayar Muhendisligi'),
('Ece', 'Demir', 'ece@uni.edu', 'Isletme'),
('Mert', 'Can', 'mert@uni.edu', 'Isletme'),
('Elif', 'Arslan', 'elif@uni.edu', 'Mimarlik'),
('Can', 'Aksoy', 'can@uni.edu', 'Mimarlik'),
('Zeynep', 'Cetin', 'zeynep@uni.edu', 'Bilgisayar Muhendisligi'),
('Burak', 'Aydin', 'burak@uni.edu', 'Isletme');


-- 2. KULUPLER (5 kayit)

INSERT INTO club
(club_name, description)
VALUES
('Yazilim Kulubu', 'Programlama etkinlikleri'),
('Spor Kulubu', 'Spor etkinlikleri'),
('Muzik Kulubu', 'Muzik etkinlikleri'),
('Kariyer Kulubu', 'Kariyer etkinlikleri'),
('Fotografcilik Kulubu', 'Fotograf etkinlikleri');


-- 3. KULUP UYELIKLERI (11 kayit)

INSERT INTO club_membership
(student_id, club_id, join_date)
VALUES
(1, 1, '2026-10-01'),
(1, 2, '2026-10-02'),
(2, 2, '2026-10-03'),
(2, 3, '2026-10-04'),
(3, 2, '2026-10-05'),
(4, 1, '2026-10-06'),
(4, 4, '2026-10-07'),
(5, 3, '2026-10-08'),
(6, 4, '2026-10-09'),
(7, 5, '2026-10-10'),
(8, 5, '2026-10-11');


-- 4. ETKINLIKLER (8 kayit)
-- Ilk 3 etkinlik spor kategorisindedir.

INSERT INTO event
(club_id, event_name, event_date, end_date,
 capacity, category, status, location)
VALUES
(2, 'Basketbol Turnuvasi',
 '2026-11-20', '2026-11-20',
 80, 'sport', 'planned', 'Spor Salonu'),

(2, 'Futbol Maci',
 '2026-11-22', '2026-11-22',
 40, 'sport', 'planned', 'Futbol Sahasi'),

(2, 'Yuzme Yarisi',
 '2026-11-25', '2026-11-25',
 60, 'sport', 'planned', 'Havuz'),

(1, 'Python Atolyesi',
 '2026-11-28', '2026-11-28',
 30, 'technology', 'planned', 'Bilgisayar Laboratuvari'),

(1, 'Veri Bilimi Semineri',
 '2026-12-01', '2026-12-01',
 70, 'technology', 'planned', 'Konferans Salonu'),

(3, 'Muzik Gecesi',
 '2026-12-05', '2026-12-05',
 120, 'culture', 'planned', 'Konser Salonu'),

(4, 'Kariyer Bulusmasi',
 '2026-12-08', '2026-12-08',
 75, 'career', 'planned', 'Konferans Salonu'),

(5, 'Fotograf Sergisi',
 '2026-12-10', '2026-12-12',
 55, 'culture', 'planned', 'Sergi Salonu');


-- 5. ETKINLIK KAYITLARI (13 kayit)

INSERT INTO event_registration
(student_id, event_id, registration_date)
VALUES
-- Ada: Tum spor etkinliklerine katilir.
(1, 1, '2026-11-10'),
(1, 2, '2026-11-10'),
(1, 3, '2026-11-10'),

-- Deniz: 2 spor ve 1 teknoloji etkinligine katilir.
-- Bir spor etkinligi eksiktir.
(2, 1, '2026-11-10'),
(2, 2, '2026-11-10'),
(2, 4, '2026-11-10'),

-- Ece: 2 spor etkinligine katilir.
(3, 2, '2026-11-10'),
(3, 3, '2026-11-10'),

-- Mert: Teknoloji etkinliklerine katilir.
(4, 4, '2026-11-10'),
(4, 5, '2026-11-10'),

-- Elif: Muzik etkinligine katilir.
(5, 6, '2026-11-10'),

-- Can: Kariyer etkinligine katilir.
(6, 7, '2026-11-10'),

-- Zeynep: Bir spor etkinligine katilir.

(7, 1, '2026-11-10'),

-- Ek test: Ada, spor disinda bir teknoloji etkinligine de katilir.
-- Dogru D6 sorgusu Ada'yi yine bulmalidir.
(1, 4, '2026-11-10');


-- Burak (student_id = 8) hicbir etkinlige kayitli degildir.
-- D4 difference sorgusunda bulunmasi beklenir.

COMMIT;


-- TABLOLARDAKI KAYIT SAYILARINI KONTROL ET

SELECT 'student' AS table_name, COUNT(*) AS kayit_sayisi
FROM student
UNION ALL
SELECT 'club', COUNT(*) FROM club
UNION ALL
SELECT 'club_membership', COUNT(*) FROM club_membership
UNION ALL
SELECT 'event', COUNT(*) FROM event
UNION ALL
SELECT 'event_registration', COUNT(*) FROM event_registration;
