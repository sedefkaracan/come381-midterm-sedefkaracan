# Yapay Zekâ Kullanım Kaydı

## Ödev 1

Bu ödevde ChatGPT'den üniversite kulüp ve etkinlik yönetim sistemi senaryosunun veritabanı tasarımını oluştururken destek aldım.

ER diyagramının Mermaid formatında hazırlanması, tabloların SQL kodlarına dönüştürülmesi ve PostgreSQL kurulumu ile test aşamalarında yapay zekâdan yardım aldım.

Oluşturulan SQL kodlarını PostgreSQL 18 üzerinde çalıştırarak beş tablonun başarıyla oluşturulduğunu kontrol ettim.

README dosyasındaki proje açıklamasını hazırlarken de ChatGPT'den yararlandım.
## Ödev 2
### D6 – Yapay Zekâ ile Division Sorgusu

**Kullanılan yapay zekâ:** ChatGPT

**Yapay zekâya gönderdiğim prompt:**

> Üniversite Kulüp ve Etkinlik Yönetim Sistemi veritabanımda student(student_id, first_name, last_name), event(event_id, category) ve event_registration(student_id, event_id) tabloları bulunuyor.
>
> Spor kategorisindeki bütün etkinliklere kayıt yaptırmış öğrencileri bulan PostgreSQL SQL sorgusunu yaz. Division (÷) işlemini kullanarak çöz ve sorguyu açıkla.

**Yapay zekânın verdiği SQL sorgusu:**

```sql
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
```

**PostgreSQL test sonucu:**

| student_id | first_name | last_name |
|---|---|---|
| 1 | Ada | Yilmaz |

**Karşılaştırma:**

Yapay zekânın oluşturduğu sorgu, kendi yazdığım D6 sorgusuyla aynı sonucu vermiştir. Spor kategorisindeki üç etkinliğin tamamına kayıt yaptıran Ada Yılmaz doğru şekilde bulunmuştur.

**Yanıltıcı veri durumu:**

Deniz Kaya'nın iki spor etkinliği ve bir teknoloji etkinliği olmak üzere toplam üç etkinlik kaydı vardır. Yalnızca toplam kayıt sayısını spor etkinliği sayısıyla karşılaştıran hatalı bir `COUNT` sorgusu Deniz'i yanlışlıkla sonuçlara ekleyebilir.

Ancak yapay zekânın ürettiği iç içe `NOT EXISTS` sorgusu Deniz'i doğru şekilde elemiştir. Bu veri durumu, sorgunun dayanıklılığını test etmektedir; mevcut sorguda bir hata tespit edilmemiştir.

**Diğer yapay zekâ kullanımları:**

ChatGPT'den constraint kurallarının, ihlal testlerinin, silme politikalarının, örnek verilerin ve ilişkisel cebir sorgularının hazırlanması ile PostgreSQL testlerinin yürütülmesinde destek alınmıştır.

### Ek D6 Testi – Yanıltıcı Veri Durumu

Yapay zekânın verdiği NOT EXISTS sorgusu ilk testte doğru
sonuç verdiği için farklı veri durumları incelenmiştir.

seed.sql dosyasına Ada Yılmaz'ın bir teknoloji etkinliğine
daha katıldığını gösteren kayıt eklenmiştir:

```sql
INSERT INTO event_registration
(student_id, event_id, registration_date)
VALUES (1, 4, '2026-11-10');
```

Bu ekleme sonucunda event_registration tablosundaki
toplam kayıt sayısı 13'ten 14'e yükselmiştir.

Ada'nın 4 etkinlik kaydı vardır ve 3 spor etkinliğinin
tamamına katılmıştır. Deniz'in 3 etkinlik kaydı vardır,
ancak bunlardan sadece 2 tanesi spor etkinliğidir.

### Bilerek Hatalı COUNT Sorgusu

```sql
SELECT s.student_id, s.first_name, s.last_name
FROM student s
WHERE (
    SELECT COUNT(*)
    FROM event_registration er
    WHERE er.student_id = s.student_id
) = (
    SELECT COUNT(*)
    FROM event e
    WHERE e.category = 'sport'
)
ORDER BY s.student_id;
```

### PostgreSQL'de Doğrulanan Sonuçlar

| Sorgu | Dönen öğrenci |
|---|---|
| Doğru NOT EXISTS | Ada Yılmaz |
| Hatalı COUNT | Deniz Kaya |

Hatalı COUNT sorgusu spor dışı etkinlikleri de saydığı
için Deniz'i yanlışlıkla seçmiş, Ada'yı ise elemiştir.

Yapay zekânın ürettiği NOT EXISTS sorgusunda bu hata
bulunmamıştır. Ek veriyle yapılan testte de doğru sonuç
değişmemiştir.

Bu çalışma, yalnızca toplam kayıt sayısını karşılaştırmanın
"bütün spor etkinliklerine katılma" koşulunu doğrulamak
için yeterli olmadığını göstermiştir.
