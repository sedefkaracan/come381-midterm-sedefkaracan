
-- ODEV 2 - BOLUM B: IHLAL TESTLERI
-- Universite Kulup ve Etkinlik Yonetim Sistemi

-- Hatalarda SQLSTATE kodunu goster.
\set VERBOSITY verbose

-- Beklenen hatalarda testlere devam et.
\set ON_ERROR_STOP off

-- HAZIRLIK
-- Testlerin her calistirmada ayni sonucu vermesi icin
-- once test verileri temizlenir.
TRUNCATE TABLE
    event_registration,
    club_membership,
    event,
    club,
    student
RESTART IDENTITY CASCADE;

-- Ornek ogrenciler
INSERT INTO student
(first_name, last_name, email, department)
VALUES
('Ada', 'Yilmaz', 'ada@example.edu', 'Bilgisayar'),
('Deniz', 'Kaya', 'deniz@example.edu', 'Isletme');

-- Ornek kulupler
INSERT INTO club (club_name, description)
VALUES
('Yazilim Kulubu', 'Teknoloji etkinlikleri'),
('Spor Kulubu', 'Spor etkinlikleri');

-- Ornek kulup uyelikleri
INSERT INTO club_membership
(student_id, club_id, join_date)
VALUES
(1, 1, '2026-11-01'),
(2, 2, '2026-11-02');

-- Ornek etkinlikler
INSERT INTO event
(club_id, event_name, event_date, end_date,
 capacity, category, status, location)
VALUES
(1, 'Python Atolyesi', '2026-11-15', '2026-11-15',
 30, 'technology', 'planned', 'Salon A'),
(2, 'Spor Turnuvasi', '2026-11-20', '2026-11-21',
 20, 'sport', 'planned', 'Spor Salonu');

-- Ornek etkinlik kaydi
INSERT INTO event_registration
(student_id, event_id, registration_date)
VALUES (1, 1, '2026-11-10');


-- NOT NULL TESTLERI

-- T01 | student.first_name NOT NULL | Beklenen: 23502
-- Ogrencinin adi bos olamaz.
\echo T01 - Beklenen 23502
INSERT INTO student (first_name, last_name, email)
VALUES (NULL, 'Demir', 'test01@example.edu');

-- T02 | student.last_name NOT NULL | Beklenen: 23502
-- Ogrencinin soyadi bos olamaz.
\echo T02 - Beklenen 23502
INSERT INTO student (first_name, last_name, email)
VALUES ('Ece', NULL, 'test02@example.edu');

-- T03 | student.email NOT NULL | Beklenen: 23502
-- Ogrencinin e-postasi bos olamaz.
\echo T03 - Beklenen 23502
INSERT INTO student (first_name, last_name, email)
VALUES ('Ece', 'Demir', NULL);

-- T04 | club.club_name NOT NULL | Beklenen: 23502
-- Kulup adi bos olamaz.
\echo T04 - Beklenen 23502
INSERT INTO club (club_name)
VALUES (NULL);

-- T05 | club_membership.student_id NOT NULL | Beklenen: 23502
-- Uyeligin ogrencisi bos olamaz.
\echo T05 - Beklenen 23502
INSERT INTO club_membership (student_id, club_id)
VALUES (NULL, 1);

-- T06 | club_membership.club_id NOT NULL | Beklenen: 23502
-- Uyeligin kulubu bos olamaz.
\echo T06 - Beklenen 23502
INSERT INTO club_membership (student_id, club_id)
VALUES (1, NULL);

-- T07 | event.club_id NOT NULL | Beklenen: 23502
-- Etkinligin kulubu bos olamaz.
\echo T07 - Beklenen 23502
INSERT INTO event
(club_id, event_name, event_date, category)
VALUES (NULL, 'Test', '2026-11-25', 'sport');

-- T08 | event.event_name NOT NULL | Beklenen: 23502
-- Etkinlik adi bos olamaz.
\echo T08 - Beklenen 23502
INSERT INTO event
(club_id, event_name, event_date, category)
VALUES (1, NULL, '2026-11-25', 'sport');

-- T09 | event.event_date NOT NULL | Beklenen: 23502
-- Etkinlik tarihi bos olamaz.
\echo T09 - Beklenen 23502
INSERT INTO event
(club_id, event_name, event_date, category)
VALUES (1, 'Test', NULL, 'sport');

-- T10 | event.category NOT NULL | Beklenen: 23502
-- Etkinlik kategorisi bos olamaz.
\echo T10 - Beklenen 23502
INSERT INTO event
(club_id, event_name, event_date, category)
VALUES (1, 'Test', '2026-11-25', NULL);

-- T11 | event.status NOT NULL | Beklenen: 23502
-- Etkinlik durumu bos olamaz.
\echo T11 - Beklenen 23502
INSERT INTO event
(club_id, event_name, event_date, category, status)
VALUES (1, 'Test', '2026-11-25', 'sport', NULL);

-- T12 | event_registration.student_id NOT NULL | Beklenen: 23502
-- Etkinlik kaydinin ogrencisi bos olamaz.
\echo T12 - Beklenen 23502
INSERT INTO event_registration (student_id, event_id)
VALUES (NULL, 1);

-- T13 | event_registration.event_id NOT NULL | Beklenen: 23502
-- Etkinlik kaydinin etkinligi bos olamaz.
\echo T13 - Beklenen 23502
INSERT INTO event_registration (student_id, event_id)
VALUES (1, NULL);


-- UNIQUE TESTLERI

-- T14 | uq_student_email | Beklenen: 23505
-- Ayni e-posta iki kez kullanilamaz.
\echo T14 - Beklenen 23505
INSERT INTO student (first_name, last_name, email)
VALUES ('Ali', 'Can', 'ada@example.edu');

-- T15 | uq_club_membership_student_club | Beklenen: 23505
-- Bir ogrenci ayni kulube iki kez uye olamaz.
\echo T15 - Beklenen 23505
INSERT INTO club_membership (student_id, club_id)
VALUES (1, 1);

-- T16 | uq_event_registration_student_event | Beklenen: 23505
-- Ogrenci ayni etkinlige iki kez kaydolamaz.
\echo T16 - Beklenen 23505
INSERT INTO event_registration (student_id, event_id)
VALUES (1, 1);


-- CHECK TESTLERI

-- T17 | chk_event_capacity | Beklenen: 23514
-- Etkinlik kapasitesi sifir olamaz.
\echo T17 - Beklenen 23514
INSERT INTO event
(club_id, event_name, event_date, capacity, category)
VALUES (1, 'Kapasite Testi', '2026-12-01', 0, 'sport');

-- T18 | chk_event_status | Beklenen: 23514
-- Etkinlik durumu izin verilen degerlerden biri olmalidir.
\echo T18 - Beklenen 23514
INSERT INTO event
(club_id, event_name, event_date, category, status)
VALUES (1, 'Durum Testi', '2026-12-01', 'sport', 'unknown');

-- T19 | chk_event_date_order | Beklenen: 23514
-- Bitis tarihi baslangictan once olamaz.
\echo T19 - Beklenen 23514
INSERT INTO event
(club_id, event_name, event_date, end_date, category)
VALUES
(1, 'Tarih Testi', '2026-12-10', '2026-12-09', 'sport');


-- FOREIGN KEY TESTLERI

-- T20 | fk_club_membership_student | Beklenen: 23503
-- Olmayan ogrenci icin kulup uyeligi olusturulamaz.
\echo T20 - Beklenen 23503
INSERT INTO club_membership (student_id, club_id)
VALUES (9999, 1);

-- T21 | fk_club_membership_club | Beklenen: 23503
-- Olmayan kulube uyelik olusturulamaz.
\echo T21 - Beklenen 23503
INSERT INTO club_membership (student_id, club_id)
VALUES (1, 9999);

-- T22 | fk_event_club | Beklenen: 23503
-- Olmayan kulup icin etkinlik olusturulamaz.
\echo T22 - Beklenen 23503
INSERT INTO event
(club_id, event_name, event_date, category)
VALUES (9999, 'FK Testi', '2026-12-01', 'sport');

-- T23 | fk_event_registration_student | Beklenen: 23503
-- Olmayan ogrenci etkinlige kaydedilemez.
\echo T23 - Beklenen 23503
INSERT INTO event_registration (student_id, event_id)
VALUES (9999, 1);

-- T24 | fk_event_registration_event | Beklenen: 23503
-- Olmayan etkinlige kayit yapilamaz.
\echo T24 - Beklenen 23503
INSERT INTO event_registration (student_id, event_id)
VALUES (1, 9999);

-- T25 | fk_event_club | Beklenen: 23503
-- Etkinligi bulunan kulup RESTRICT nedeniyle silinemez.
\echo T25 - Beklenen 23001
DELETE FROM club WHERE club_id = 1;


-- SINIR TESTLERI

-- T26 | chk_event_capacity | Beklenen: OK
-- Kapasite 1 oldugunda veri kabul edilmelidir.
\echo T26 - Beklenen OK
INSERT INTO event
(club_id, event_name, event_date, end_date, capacity,
 category, status)
VALUES
(1, 'Sinir Kapasite', '2026-12-01', '2026-12-01',
 1, 'sport', 'planned');

-- T27 | chk_event_date_order | Beklenen: OK
-- Baslangic ve bitis tarihi ayni olabilir.
\echo T27 - Beklenen OK
INSERT INTO event
(club_id, event_name, event_date, end_date, capacity,
 category, status)
VALUES
(1, 'Sinir Tarih', '2026-12-02', '2026-12-02',
 10, 'technology', 'planned');


-- NULL TESTI

-- T28 | chk_event_capacity | Beklenen: OK
-- capacity NOT NULL degildir.
-- CHECK kuralinda NULL degeri UNKNOWN sonucu verir.
-- PostgreSQL bu satiri kabul etmelidir.
\echo T28 - Beklenen OK
INSERT INTO event
(club_id, event_name, event_date, capacity, category,
 status)
VALUES
(1, 'NULL Kapasite Testi', '2026-12-03',
 NULL, 'sport', 'planned');


-- T29 | fk_event_registration_student / fk_club_membership_student
-- Beklenen: 23503
-- Kaydi bulunan ogrencinin kimlik numarasi degistirilemez.
\echo T29 - Beklenen 23503

UPDATE student
SET student_id = DEFAULT
WHERE student_id = 1;

