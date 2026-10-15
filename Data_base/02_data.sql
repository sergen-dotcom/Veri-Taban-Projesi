USE hotel_management;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE TemizlikGorevleri;
TRUNCATE TABLE Odeme;
TRUNCATE TABLE KonaklamaHizmeti;
TRUNCATE TABLE Konaklama;
TRUNCATE TABLE Rezervasyon;
TRUNCATE TABLE SezonFiyati;
TRUNCATE TABLE OzelGun;
TRUNCATE TABLE Oda;
TRUNCATE TABLE Personel;
TRUNCATE TABLE Misafir;
TRUNCATE TABLE HizmetEnvanter;
TRUNCATE TABLE EkHizmet;
TRUNCATE TABLE Kullanici;
TRUNCATE TABLE OdaTipi;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Oda Tipleri
INSERT INTO OdaTipi (ad, kapasite, aciklama, temel_fiyat) VALUES
('Standart Oda', 2, 'Çift kişilik yatak, şehir manzaralı, çalışma masası ve Wi-Fi', 1500.00),
('Deluxe Deniz Manzaralı', 2, 'Geniş balkonlu, panoramik deniz manzaralı, jakuzili banyo', 2600.00),
('Aile Süiti', 4, '2 ayrı yatak odası, 1 salon, çocuk alanı ve mini mutfak', 4200.00),
('Kral Dairesi', 4, 'Teras katı, özel sauna, şömine ve Hakan Aydın Onursal Çalışma Köşesi', 9500.00);

-- 2. Kullanıcılar (Şifreler: 'password')
SET @sifre = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

INSERT INTO Kullanici (eposta, sifre, rol) VALUES
('ahmet.celik@otel.com',      @sifre, 'yonetici'),
('selin.aksoy@otel.com',      @sifre, 'resepsiyon'),
('burak.ozturk@otel.com',     @sifre, 'resepsiyon'),
('fatma.sahin@otel.com',      @sifre, 'resepsiyon'),
('hasan.dogan@otel.com',      @sifre, 'resepsiyon'),
('ayse.demir@gmail.com',      @sifre, 'misafir'),
('mehmet.kaya@hotmail.com',   @sifre, 'misafir'),
('elif.yilmaz@yahoo.com',     @sifre, 'misafir'),
('john.smith@company.com',    @sifre, 'misafir'),
('zeynep.arslan@gmail.com',   @sifre, 'misafir'),
('hakan.aydin@ktu.edu.tr',    @sifre, 'misafir'),
('emre.can@outlook.com',      @sifre, 'misafir');

-- 3. Personel
INSERT INTO Personel (kullanici_id, ad, soyad, gorev, ise_giris_tarihi) VALUES
(1, 'Ahmet',  'Çelik',  'Genel Müdür',           '2021-02-15'),
(2, 'Selin',  'Aksoy',  'Kıdemli Resepsiyonist', '2022-05-10'),
(3, 'Burak',  'Öztürk', 'Gece Resepsiyonisti',   '2023-01-20'),
(4, 'Fatma',  'Şahin',  'Kat Hizmetleri Şefi',   '2021-08-01'),
(5, 'Hasan',  'Doğan',  'Temizlik Görevlisi',    '2022-11-15');

-- 4. Misafirler
INSERT INTO Misafir (kullanici_id, tc_pasaport, telefon, dogum_tarihi, ad, soyad, toplam_puan) VALUES
(6,  '11111111110', '05321112233', '1992-04-12', 'Ayşe',   'Demir',   45),
(7,  '22222222220', '05332223344', '1988-11-03', 'Mehmet', 'Kaya',    0),
(8,  '33333333330', '05353334455', '1995-07-21', 'Elif',   'Yılmaz',  120),
(9,  'US88492019',  '05364445566', '1982-01-15', 'John',   'Smith',   80),
(10, '55555555550', '05375556677', '1997-09-30', 'Zeynep', 'Arslan',  310),
(11, '66666666660', '05386667788', '1980-03-25', 'Hakan',  'Aydın',   6161),
(12, '77777777770', '05397778899', '2001-06-18', 'Emre',   'Can',     0);

-- 5. Odalar
INSERT INTO Oda (oda_no, kat, oda_tipi_id, durum) VALUES
('101', 1, 1, 'bos'),
('102', 1, 1, 'dolu'),
('103', 1, 1, 'temizlikte'),
('104', 1, 1, 'bos'),
('105', 1, 1, 'bakımda'),
('201', 2, 2, 'bos'),
('202', 2, 2, 'dolu'),
('203', 2, 2, 'bos'),
('204', 2, 2, 'bos'),
('205', 2, 2, 'temizlikte'),
('301', 3, 3, 'bos'),
('302', 3, 3, 'bos'),
('303', 3, 3, 'dolu'),
('304', 3, 3, 'bos'),
('401', 4, 4, 'bos'),
('402', 4, 4, 'bos');

-- 6. Ek Hizmetler ve Stok
INSERT INTO EkHizmet (hizmet_adi, birim_fiyat) VALUES
('Minibar - Su 0.5L',                  35.00),
('Minibar - Kutu Kola',                80.00),
('Minibar - Çikolata',                 60.00),
('Minibar - Bira',                    140.00),
('Serpme Kahvaltı',                   350.00),
('Kese & Köpük Masajı',               900.00),
('VIP Havalimanı Transferi',          750.00),
('Hakan Hoca İkramı (Çay & Fındık)',    0.00);

INSERT INTO HizmetEnvanter (hizmet_id, stok_miktari) VALUES
(1, 150),
(2, 85),
(3, 60),
(4, 40);

-- 7. Sezon Fiyatları
INSERT INTO SezonFiyati (oda_tipi_id, baslangic_tarihi, bitis_tarihi, gecelik_fiyat) VALUES
(1, '2026-06-01', '2026-09-30', 2200.00),
(1, '2026-10-01', '2027-05-31', 1500.00),
(2, '2026-06-01', '2026-09-30', 3800.00),
(2, '2026-10-01', '2027-05-31', 2600.00),
(3, '2026-06-01', '2026-09-30', 5800.00),
(3, '2026-10-01', '2027-05-31', 4200.00),
(4, '2026-06-01', '2026-09-30', 14000.00),
(4, '2026-10-01', '2027-05-31', 9500.00);

-- 8. Özel Günler
INSERT INTO OzelGun (etkinlik_adi, baslangic_tarihi, bitis_tarihi, fiyat_carpani, aciklama) VALUES
('Trabzonspor - Fenerbahçe Derbisi', DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), 1.40, 'Derbi maçı yoğunluğu'),
('Hakan Aydın Vizesi Sonrası İyileşme Kampı', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 18 DAY), 0.75, 'Veri tabanı sınavı sonrası kafa dinleme indirimi'),
('Cumhuriyet Bayramı Tatili', DATE_ADD(CURDATE(), INTERVAL 20 DAY), DATE_ADD(CURDATE(), INTERVAL 23 DAY), 1.25, 'Resmi tatil dönemi'),
('Yılbaşı Programı', '2026-12-31', '2027-01-02', 1.50, 'Yılbaşı gala programı');

-- 9. Rezervasyonlar
INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum) VALUES
-- Aktif rezervasyonlar
(1, 2,  DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 1500.00, 'onaylı'),
(2, 7,  DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, 2600.00, 'onaylı'),
-- Aynı gün giriş/çıkış turnover testi (Oda 201)
(3, 6,  DATE_ADD(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 6 DAY), 2, 2600.00, 'onaylı'),
(4, 6,  DATE_ADD(CURDATE(), INTERVAL 6 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), 2, 2600.00, 'onaylı'),
-- İptal senaryosu testi
(5, 11, DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 8 DAY), 4, 4200.00, 'iptal'),
(6, 11, DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 8 DAY), 3, 4200.00, 'onaylı'),
-- Tamamlanan rezervasyon
(5, 15, DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 2, 9500.00, 'tamamlandı');

-- 10. Konaklama Kayıtları
INSERT INTO Konaklama (rezervasyon_id, islem_yapan_personel_id, gercek_giris, gercek_cikis) VALUES
(1, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),
(2, 2, DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),
(7, 3, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY));

-- 11. Konaklama Hizmet Harcamaları
INSERT INTO KonaklamaHizmeti (konaklama_id, ek_hizmet_id, adet) VALUES
(1, 2, 2),
(1, 3, 1),
(2, 6, 1),
(3, 7, 1);

-- 12. Ödemeler
INSERT INTO Odeme (konaklama_id, tutar, odeme_turu) VALUES
(3, 29250.00, 'kart');

-- 13. Temizlik Görevleri
INSERT INTO TemizlikGorevleri (oda_id, personel_id, oncelik, durum, tamamlanma_zamani) VALUES
(3,  NULL, 'Acil',   'Beklemede', NULL),
(10, 5,    'Normal', 'Yapılıyor', NULL),
(15, 4,    'Normal', 'Tamamlandı', DATE_SUB(NOW(), INTERVAL 1 DAY));
