# Üniversite Kulüp ve Etkinlik Yönetim Sistemi

Bu proje, üniversitedeki öğrenci kulüplerinin ve düzenledikleri etkinliklerin veritabanı üzerinden yönetilmesini amaçlamaktadır.

Sistemde öğrencilerin bilgileri, kulüpler, kulüp üyelikleri, etkinlikler ve etkinlik kayıtları tutulmaktadır.

Bir öğrenci birden fazla kulübe üye olabilir ve birden fazla etkinliğe kayıt yaptırabilir.

Öğrenciler ile kulüpler arasındaki çoktan çoğa (M:N) ilişki `club_membership`, öğrenciler ile etkinlikler arasındaki çoktan çoğa ilişki ise `event_registration` ara tablolarıyla çözümlenmiştir.

Bu tasarım, verilerin düzenli tutulmasını ve tablolar arasındaki ilişkilerin yabancı anahtarlar (FK) ile yönetilmesini sağlar.