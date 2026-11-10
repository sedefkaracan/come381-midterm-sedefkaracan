
-- ODEV 2 - BOLUM A: CONSTRAINT KURALLARI
-- Universite Kulup ve Etkinlik Yonetim Sistemi

-- 1. YENI SUTUNLAR

-- Etkinligin bitis tarihini tutar.
ALTER TABLE event
ADD COLUMN end_date DATE;

-- Etkinligin katilimci kapasitesini tutar.
ALTER TABLE event
ADD COLUMN capacity INTEGER;

-- Etkinligin kategorisini tutar.
ALTER TABLE event
ADD COLUMN category VARCHAR(30);

-- Etkinligin durumunu tutar.
ALTER TABLE event
ADD COLUMN status VARCHAR(20) DEFAULT 'planned';


-- 2. NOT NULL KURALLARI

-- Ogrencinin adi bos birakilamaz.
ALTER TABLE student
ALTER COLUMN first_name SET NOT NULL;

-- Ogrencinin soyadi bos birakilamaz.
ALTER TABLE student
ALTER COLUMN last_name SET NOT NULL;

-- Ogrencinin e-posta adresi bos birakilamaz.
ALTER TABLE student
ALTER COLUMN email SET NOT NULL;

-- Kulubun adi bos birakilamaz.
ALTER TABLE club
ALTER COLUMN club_name SET NOT NULL;

-- Kulup uyeliginin ogrencisi belirtilmelidir.
ALTER TABLE club_membership
ALTER COLUMN student_id SET NOT NULL;

-- Kulup uyeliginin kulubu belirtilmelidir.
ALTER TABLE club_membership
ALTER COLUMN club_id SET NOT NULL;

-- Her etkinlik bir kulube ait olmalidir.
ALTER TABLE event
ALTER COLUMN club_id SET NOT NULL;

-- Etkinlik adi bos birakilamaz.
ALTER TABLE event
ALTER COLUMN event_name SET NOT NULL;

-- Etkinligin tarihi belirtilmelidir.
ALTER TABLE event
ALTER COLUMN event_date SET NOT NULL;

-- Etkinligin kategorisi belirtilmelidir.
ALTER TABLE event
ALTER COLUMN category SET NOT NULL;

-- Etkinligin durumu bos birakilamaz.
ALTER TABLE event
ALTER COLUMN status SET NOT NULL;

-- Etkinlik kaydinda ogrenci belirtilmelidir.
ALTER TABLE event_registration
ALTER COLUMN student_id SET NOT NULL;

-- Etkinlik kaydinda etkinlik belirtilmelidir.
ALTER TABLE event_registration
ALTER COLUMN event_id SET NOT NULL;


-- 3. UNIQUE KURALLARI

-- Ayni e-posta adresi iki farkli ogrenciye atanamaz.
ALTER TABLE student
ADD CONSTRAINT uq_student_email
UNIQUE (email);

-- Bir ogrenci ayni kulube iki kez uye olamaz.
ALTER TABLE club_membership
ADD CONSTRAINT uq_club_membership_student_club
UNIQUE (student_id, club_id);

-- Bir ogrenci ayni etkinlige iki kez kaydolamaz.
ALTER TABLE event_registration
ADD CONSTRAINT uq_event_registration_student_event
UNIQUE (student_id, event_id);


-- 4. CHECK KURALLARI

-- Etkinlik kapasitesi girildiyse sifirdan buyuk olmalidir.
ALTER TABLE event
ADD CONSTRAINT chk_event_capacity
CHECK (capacity > 0);

-- Etkinlik durumu yalnizca izin verilen degerlerden biri olabilir.
ALTER TABLE event
ADD CONSTRAINT chk_event_status
CHECK (status IN ('planned', 'active', 'cancelled'));

-- Etkinligin bitis tarihi baslangic tarihinden once olamaz.
ALTER TABLE event
ADD CONSTRAINT chk_event_date_order
CHECK (end_date >= event_date);


-- 5. FOREIGN KEY KURALLARI

-- Eski otomatik isimlendirilmis ogrenci baglantisi kaldirilir.
ALTER TABLE club_membership
DROP CONSTRAINT IF EXISTS club_membership_student_id_fkey;

-- Kulup uyeligi gecerli bir ogrenciye ait olmalidir.
-- Ogrenci silinirse uyelik kayitlari da silinir.
ALTER TABLE club_membership
ADD CONSTRAINT fk_club_membership_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

-- Eski otomatik isimlendirilmis kulup baglantisi kaldirilir.
ALTER TABLE club_membership
DROP CONSTRAINT IF EXISTS club_membership_club_id_fkey;

-- Kulup uyeligi gecerli bir kulube ait olmalidir.
-- Kulup silinirse uyelikleri de silinir.
ALTER TABLE club_membership
ADD CONSTRAINT fk_club_membership_club
FOREIGN KEY (club_id)
REFERENCES club(club_id)
ON DELETE CASCADE;

-- Eski otomatik isimlendirilmis etkinlik-kulup baglantisi kaldirilir.
ALTER TABLE event
DROP CONSTRAINT IF EXISTS event_club_id_fkey;

-- Etkinlik gecerli bir kulube ait olmalidir.
-- Etkinligi bulunan kulubun silinmesi engellenir.
ALTER TABLE event
ADD CONSTRAINT fk_event_club
FOREIGN KEY (club_id)
REFERENCES club(club_id)
ON DELETE RESTRICT;

-- Eski otomatik isimlendirilmis kayit-ogrenci baglantisi kaldirilir.
ALTER TABLE event_registration
DROP CONSTRAINT IF EXISTS event_registration_student_id_fkey;

-- Etkinlik kaydi gecerli bir ogrenciye ait olmalidir.
-- Ogrenci silinirse etkinlik kayitlari da silinir.
ALTER TABLE event_registration
ADD CONSTRAINT fk_event_registration_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

-- Eski otomatik isimlendirilmis kayit-etkinlik baglantisi kaldirilir.
ALTER TABLE event_registration
DROP CONSTRAINT IF EXISTS event_registration_event_id_fkey;

-- Etkinlik kaydi gecerli bir etkinlige ait olmalidir.
-- Etkinlik silinirse ilgili kayitlar da silinir.
ALTER TABLE event_registration
ADD CONSTRAINT fk_event_registration_event
FOREIGN KEY (event_id)
REFERENCES event(event_id)
ON DELETE CASCADE;
