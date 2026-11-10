# Bölüm C – Silme Politikaları

## 1. Foreign Key Silme Politikaları

Üniversite Kulüp ve Etkinlik Yönetim Sistemi'nde, ilişkili kayıtların silinmesi için `CASCADE` ve `RESTRICT` politikaları kullanılmıştır.

| Foreign Key | Ebeveyn → Çocuk | Seçim | Neden | Diğer seçenek neden seçilmedi? |
|---|---|---|---|---|
| `fk_club_membership_student` | student → club_membership | CASCADE | Öğrenci silindiğinde kulüp üyeliklerinin de silinmesi gerekir. | RESTRICT, üyelik kaydı bulunan öğrencinin silinmesini engellerdi. |
| `fk_club_membership_club` | club → club_membership | CASCADE | Kulüp silindiğinde üyelik kayıtlarının tutulmasına gerek kalmaz. | RESTRICT, üyeleri bulunan kulübün silinmesini engellerdi. |
| `fk_event_club` | club → event | RESTRICT | Etkinliği bulunan kulübün yanlışlıkla silinmesi önlenir. | CASCADE, kulübün silinmesiyle etkinliklerin de silinmesine neden olurdu. |
| `fk_event_registration_student` | student → event_registration | CASCADE | Öğrenci silindiğinde etkinlik kayıtları da silinir. | RESTRICT, kaydı bulunan öğrencilerin silinmesini engellerdi. |
| `fk_event_registration_event` | event → event_registration | CASCADE | Etkinlik silindiğinde ona ait öğrenci kayıtları da silinir. | RESTRICT, kayıtlı katılımcısı olan etkinliğin silinmesini engellerdi. |

## 2. CASCADE ve RESTRICT Açıklaması

**CASCADE:** Ebeveyn tablodaki kayıt silindiğinde bu kayda bağlı çocuk tablodaki kayıtlar otomatik silinir.

**RESTRICT:** Ebeveyn kayda bağlı başka kayıtlar bulunuyorsa silme işlemi engellenir.

Bu projede iki farklı silme politikası kullanılarak veri bütünlüğünün korunması amaçlanmıştır.

## 3. RESTRICT ve NO ACTION Arasındaki Fark

`RESTRICT`, ilişkili kayıt bulunduğunda silme işlemini hemen engeller.

`NO ACTION` ise varsayılan olarak işlemin sonunda foreign key kuralını kontrol eder. Kısıt ertelenebilir (`DEFERRABLE`) olarak tanımlanmışsa kontrol daha sonraya bırakılabilir. `RESTRICT` kontrolü ertelenemez.


## 4. CASCADE Testi ve PostgreSQL Sonuçları

Bu testte, bir öğrenci silindiğinde ona bağlı kulüp üyeliği
ve etkinlik kaydının da otomatik olarak silindiği doğrulanmıştır.

Test, PostgreSQL 18 üzerinde transaction kullanılarak yapılmıştır.

### 4.1. Test Verilerinin Hazırlanması

Öncelikle aşağıdaki komutla transaction başlatılmıştır:

```sql
BEGIN;
```

Ardından yeni bir öğrenci oluşturulmuştur:

```sql
INSERT INTO student (first_name, last_name, email, department)
VALUES ('Test', 'Ogrenci', 'cascade_test_2026@example.edu', 'Bilgisayar')
RETURNING student_id;
```

Bu testte öğrenci numarası 7 olarak dönmüştür.

Öğrenci kulübe ve etkinliğe kaydedilmiştir:

```sql
INSERT INTO club_membership
(student_id, club_id, join_date)
VALUES (7, 1, '2026-11-10');

INSERT INTO event_registration
(student_id, event_id, registration_date)
VALUES (7, 1, '2026-11-10');
```

Her iki işlem de `INSERT 0 1` sonucunu vermiştir.

### 4.2. Silmeden Önceki Kayıt Sayıları

```sql
SELECT
    (SELECT COUNT(*) FROM student WHERE student_id = 7) AS student,
    (SELECT COUNT(*) FROM club_membership WHERE student_id = 7) AS club_membership,
    (SELECT COUNT(*) FROM event_registration WHERE student_id = 7) AS event_registration;
```

Gerçek PostgreSQL sonucu:

| student | club_membership | event_registration |
|---|---|---|
| 1 | 1 | 1 |

### 4.3. Öğrencinin Silinmesi

```sql
DELETE FROM student WHERE student_id = 7;
```

PostgreSQL sonucu:

`DELETE 1`

### 4.4. Silmeden Sonraki Kayıt Sayıları

```sql
SELECT
    (SELECT COUNT(*) FROM student WHERE student_id = 7) AS student,
    (SELECT COUNT(*) FROM club_membership WHERE student_id = 7) AS club_membership,
    (SELECT COUNT(*) FROM event_registration WHERE student_id = 7) AS event_registration;
```

Gerçek PostgreSQL sonucu:

| student | club_membership | event_registration |
|---|---|---|
| 0 | 0 | 0 |

### 4.5. İşlemin Geri Alınması

```sql
ROLLBACK;
```

PostgreSQL `ROLLBACK` sonucunu vermiştir.

Bu komutla transaction içindeki öğrenci oluşturma,
üyelik oluşturma, etkinlik kaydı ve silme işlemleri
geri alınmıştır.

### 4.6. Sonuç

CASCADE testi başarıyla tamamlanmıştır.

Öğrenci silinmeden önce üç tabloda da ilgili birer kayıt
bulunurken silme işleminden sonra üç tablodaki ilgili
kayıt sayısı sıfıra düşmüştür.

Bu sonuç, `ON DELETE CASCADE` kuralının doğru çalıştığını
kanıtlamaktadır.
