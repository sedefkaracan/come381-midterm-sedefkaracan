
-- Universite Kulup ve Etkinlik Yonetim Sistemi
-- Odev 1: Veritabani tablolari

-- 1. Ogrenciler
CREATE TABLE student (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(100)
);

-- 2. Kulupler
CREATE TABLE club (
    club_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    club_name VARCHAR(100),
    description TEXT
);

-- 3. Kulup uyelikleri
CREATE TABLE club_membership (
    membership_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER REFERENCES student(student_id),
    club_id INTEGER REFERENCES club(club_id),
    join_date DATE
);

-- 4. Etkinlikler
CREATE TABLE event (
    event_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    club_id INTEGER REFERENCES club(club_id),
    event_name VARCHAR(100),
    event_date DATE,
    location VARCHAR(150)
);

-- 5. Etkinlik kayitlari
CREATE TABLE event_registration (
    registration_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER REFERENCES student(student_id),
    event_id INTEGER REFERENCES event(event_id),
    registration_date DATE
);
