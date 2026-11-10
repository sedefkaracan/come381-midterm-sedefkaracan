
# Bölüm D – İlişkisel Cebir ve SQL Sorguları

## Üniversite Kulüp ve Etkinlik Yönetim Sistemi

Bu bölümde, hazırlanan veritabanı üzerinde altı farklı
ilişkisel cebir sorusu incelenmiştir.

SQL karşılıkları `algebra.sql` dosyasında D1-D6 olarak
numaralandırılacaktır.

Aşağıdaki sonuçlar `seed.sql` verilerine göre beklenen
sonuçlardır. SQL sorguları çalıştırılarak doğrulanacaktır.

---

## D1 – Selection (σ) ve Projection (π)

**Soru:** Kapasitesi 50'den büyük olan etkinliklerin adları nelerdir?

### İlişkisel Cebir

π_event_name (σ_capacity > 50 (event))

### SQL Karşılığı

`algebra.sql` dosyasındaki D1 sorgusu.

### PostgreSQL'de Doğrulanan Sonuç

| event_name |
|---|
| Basketbol Turnuvasi |
| Yuzme Yarisi |
| Veri Bilimi Semineri |
| Muzik Gecesi |
| Kariyer Bulusmasi |
| Fotograf Sergisi |

### DISTINCT Açıklaması

İlişkisel cebir küme mantığıyla çalıştığından tekrarları
otomatik kaldırır.

SQL'de farklı etkinliklerin adları aynı olabileceği için
`DISTINCT` kullanılması gerekir.

---

## D2 – Join (⋈)

**Soru:** Spor kategorisindeki etkinliklere kayıt yaptıran
öğrencilerin adları ve kayıt oldukları etkinlikler nelerdir?

### İlişkisel Cebir

π_student_id,first_name,last_name,event_name (
    σ_category='sport' (
        (student ⋈_student.student_id=event_registration.student_id
         event_registration)
        ⋈_event_registration.event_id=event.event_id event
    )
)

### SQL Karşılığı

`algebra.sql` dosyasındaki D2 sorgusu.

### PostgreSQL'de Doğrulanan Sonuç

| student_id | first_name | last_name | event_name |
|---|---|---|---|
| 1 | Ada | Yilmaz | Basketbol Turnuvasi |
| 1 | Ada | Yilmaz | Futbol Maci |
| 1 | Ada | Yilmaz | Yuzme Yarisi |
| 2 | Deniz | Kaya | Basketbol Turnuvasi |
| 2 | Deniz | Kaya | Futbol Maci |
| 3 | Ece | Demir | Futbol Maci |
| 3 | Ece | Demir | Yuzme Yarisi |
| 7 | Zeynep | Cetin | Basketbol Turnuvasi |

### DISTINCT Açıklaması

Her öğrencinin aynı etkinliğe bir kez kaydolması
`uq_event_registration_student_event` kuralıyla garanti
edilmiştir.

Bu sorguda öğrenci numarası ve etkinlik adı birlikte
gösterildiğinden, örnek verilerimizde tekrar bulunmaz.
Bu nedenle `DISTINCT` gerekli değildir.

---

## D3 – Union (∪)

**Soru:** Spor veya teknoloji kategorisindeki en az bir
etkinliğe kayıt yaptırmış öğrencilerin numaraları nelerdir?

### İlişkisel Cebir

π_student_id (
    event_registration
    ⋈_event_registration.event_id=event.event_id
    σ_category='sport' (event)
)
∪
π_student_id (
    event_registration
    ⋈_event_registration.event_id=event.event_id
    σ_category='technology' (event)
)

### SQL Karşılığı

`algebra.sql` dosyasındaki D3 sorgusu.

### PostgreSQL'de Doğrulanan Sonuç

| student_id |
|---|
| 1 |
| 2 |
| 3 |
| 4 |
| 7 |

### DISTINCT Açıklaması

`UNION` aynı öğrenci numarasını yalnızca bir kez döndürür.

SQL'de `UNION` zaten tekrarları kaldırdığı için ek
`DISTINCT` kullanılmasına gerek yoktur.

---

## D4 – Difference (−)

**Soru:** Hiçbir etkinliğe kayıt yaptırmamış öğrenciler
kimlerdir?

### İlişkisel Cebir

π_student_id (student)
−
π_student_id (event_registration)

### SQL Karşılığı

`algebra.sql` dosyasında iki farklı çözüm bulunacaktır:

1. D4-A: `EXCEPT`
2. D4-B: `NOT EXISTS`

İki yöntemin aynı sonucu vermesi beklenmektedir.

### PostgreSQL'de Doğrulanan Sonuç

| student_id | first_name | last_name |
|---|---|---|
| 8 | Burak | Aydin |

### Tuple Relational Calculus

{ s.student_id |
  student(s) ∧
  ¬∃r (event_registration(r) ∧
       r.student_id = s.student_id)
}

Bu ifade, hiçbir etkinlik kaydında bulunmayan
öğrencilerin numaralarını ifade eder.

### DISTINCT Açıklaması

`EXCEPT` tekrarları otomatik kaldırır.

`NOT EXISTS` sorgusunda ise her öğrenci
`student` tablosundan bir kez seçilir.
Birincil anahtar sayesinde ayrıca `DISTINCT`
kullanılması gerekli değildir.

---

## D5 – Rename (ρ) ve Self Join

**Soru:** Aynı bölümde okuyan farklı öğrenci çiftleri kimlerdir?

### İlişkisel Cebir

π_s1.student_id,s1.first_name,s2.student_id,s2.first_name (
    ρ_s1(student)
    ⋈_(s1.department=s2.department
       ∧ s1.student_id<s2.student_id)
    ρ_s2(student)
)

Burada `ρ` aynı tabloya farklı takma adlar verir.
Öğrenci numaralarının karşılaştırılması sayesinde
aynı çiftin ters sırayla tekrar gösterilmesi engellenir.

### SQL Karşılığı

`algebra.sql` dosyasındaki D5 sorgusu.

### PostgreSQL'de Doğrulanan Sonuç

| Ogrenci 1 | Ogrenci 2 | Bolum |
|---|---|---|
| Ada | Deniz | Bilgisayar Muhendisligi |
| Ada | Zeynep | Bilgisayar Muhendisligi |
| Deniz | Zeynep | Bilgisayar Muhendisligi |
| Ece | Mert | Isletme |
| Ece | Burak | Isletme |
| Mert | Burak | Isletme |
| Elif | Can | Mimarlik |

### DISTINCT Açıklaması

`student_id` değerleri farklı ve sıralı olarak
karşılaştırıldığı için her öğrenci çifti bir kez oluşur.

Bu nedenle `DISTINCT` gerekli değildir.

---

## D6 – Division (÷)

**Soru:** Spor kategorisindeki bütün etkinliklere
kayıt yaptırmış öğrenciler kimlerdir?

### İlişkisel Cebir

π_student_id,event_id (event_registration)
÷
π_event_id (σ_category='sport' (event))

Bölme işlemi, belirtilen kategorideki bütün etkinliklere
katılmış öğrencileri bulmak için kullanılır.

### SQL Karşılığı

`algebra.sql` dosyasındaki D6 sorgusu.

SQL'de doğrudan bölme operatörü bulunmadığı için
iç içe iki `NOT EXISTS` kullanılacaktır.

Bu yöntem, spor kategorisinde öğrencinin kaydolmadığı
herhangi bir etkinlik bulunup bulunmadığını kontrol eder.

### PostgreSQL'de Doğrulanan Sonuç

| student_id | first_name | last_name |
|---|---|---|
| 1 | Ada | Yilmaz |

### Neredeyse Aday

Deniz, üç etkinliğe kayıtlıdır fakat bunlardan biri
teknoloji kategorisindedir.

Üç spor etkinliğinin yalnızca ikisine kayıtlı olduğu
için D6 sorgusunda bulunmamalıdır.

Bu örnek, yalnızca toplam kayıt sayısını karşılaştıran
hatalı sorguları tespit etmek amacıyla hazırlanmıştır.

### DISTINCT Açıklaması

Öğrenciler `student` tablosundan seçildiğinden
ve öğrenci numarası birincil anahtar olduğundan
her öğrenci en fazla bir kez döner.

Bu nedenle `DISTINCT` gerekli değildir.

---

## Genel Değerlendirme

Bu bölümde seçim (σ), izdüşüm (π), birleştirme (⋈),
küme birleşimi (∪), küme farkı (−), yeniden adlandırma (ρ)
ve bölme (÷) işlemleri kullanılmıştır.

Altı sorunun SQL karşılıkları `algebra.sql` dosyasında
çalıştırılıp sonuçlar doğrulanacaktır.
