
# Ödev 2 – Constraint'ler, İhlal Testleri ve İlişkisel Cebir

## 1. Proje Açıklaması

Bu ödev, Üniversite Kulüp ve Etkinlik Yönetim Sistemi
veritabanı üzerinde hazırlanmıştır.

Constraint kuralları, ihlal testleri, silme politikaları
ve ilişkisel cebir sorguları PostgreSQL 18 üzerinde
test edilmiştir.

## 2. Çalıştırma Sırası

Komutlar proje ana klasöründeki CMD terminalinde
çalıştırılmalıdır.

PostgreSQL'in kurulu olduğu konum:
C:\Program Files\PostgreSQL\18\bin

Kullanılan test veritabanı: come381_test

Dosyaların çalıştırılma sırası:

1. sql/schema.sql
2. week-05/constraints.sql
3. week-05/violations.sql
4. week-05/seed.sql
5. week-05/algebra.sql

Windows CMD komutları:

```bat
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f sql/schema.sql

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f week-05/constraints.sql

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f week-05/violations.sql

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f week-05/seed.sql

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f week-05/algebra.sql
```

Bu sıralama yeni ve boş bir veritabanı için geçerlidir.
schema.sql ve constraints.sql mevcut tablolar üzerine
tekrar çalıştırılmamalıdır.

violations.sql önce test verilerini temizlediği için
seed.sql dosyası ondan sonra çalıştırılmalıdır.

İhlal testi çıktısı aşağıdaki CMD komutuyla alınır:

```bat
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d come381_test -f week-05/violations.sql > week-05/violations_output.txt 2>&1
```

## 3. NULL Testinin Açıklaması

T28 testinde event tablosunun capacity sütununa
NULL değeri eklenmiştir.

Bu sütunda CHECK (capacity > 0) kuralı bulunmaktadır,
ancak NOT NULL kısıtlaması yoktur.

SQL'de NULL ile yapılan bu karşılaştırma UNKNOWN
sonucunu verir.

PostgreSQL CHECK kısıtlaması yalnızca FALSE sonucunu
reddettiğinden NULL değeri kabul edilmiştir.

Test sonucunda INSERT 0 1 mesajı alınmıştır.

## 4. Beklenmedik Sonuç ve Öğrendiklerim

T25 testinde RESTRICT silme kuralının ihlal edilmesi
için etkinliği bulunan bir kulüp silinmeye çalışılmıştır.

Başlangıçta 23503 hata kodu beklenmiştir.
Ancak PostgreSQL 23001 (restrict_violation)
hata kodunu döndürmüştür.

Bunun sonucunda RESTRICT kuralının silmeyi engellediği
ve bu hata durumunun farklı bir SQLSTATE koduyla
raporlanabildiği öğrenilmiştir.

Beklenen sonuç test dosyasında 23001 olarak düzeltilmiş
ve test yeniden çalıştırılmıştır.

## 5. İlişkisel Cebir ve Yapay Zekâ Testleri

D1-D6 sorguları PostgreSQL üzerinde test edilmiştir.

D4 sorusu EXCEPT ve NOT EXISTS yöntemleriyle çözülmüş,
her iki sorgu da Burak Aydın sonucunu vermiştir.

D6 sorusunda doğru NOT EXISTS sorgusu Ada Yılmaz'ı
bulmuştur. Hatalı COUNT sorgusu ise Deniz Kaya'yı
yanlışlıkla seçmiştir.

Yapay zekâ kullanımının ayrıntıları projenin
ana klasöründeki AI_LOG.md dosyasında bulunmaktadır.
