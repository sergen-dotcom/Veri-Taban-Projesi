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

-- 1. ODA TIPLERI
INSERT INTO OdaTipi (ad, kapasite, aciklama, temel_fiyat) VALUES
                                                              ('Standart Oda', 2, 'Çift kişilik yatak, şehir manzaralı, çalışma masası ve Wi-Fi', 1500.00),
                                                              ('Deluxe Deniz Manzaralı', 2, 'Geniş balkonlu, panoramik deniz manzaralı, jakuzili banyo', 2600.00),
                                                              ('Aile Süiti', 4, '2 ayrı yatak odası, 1 salon, çocuk alanı ve mini mutfak', 4200.00),
                                                              ('Kral Dairesi', 4, 'Teras katı, özel sauna, şömine ve Hakan Aydın Onursal Çalışma Köşesi', 9500.00);

-- 2. KULLANICILAR (1-5 Personel, 6-60 Misafir = Toplam 60 Kullanıcı)
SET @sifre = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'; -- 'password'

INSERT INTO Kullanici (eposta, sifre, rol) VALUES
-- Personel Kullanıcıları (ID: 1 - 5)
('ahmet.celik@otel.com',      @sifre, 'yonetici'),
('selin.aksoy@otel.com',      @sifre, 'resepsiyon'),
('burak.ozturk@otel.com',     @sifre, 'resepsiyon'),
('fatma.sahin@otel.com',      @sifre, 'resepsiyon'),
('hasan.dogan@otel.com',      @sifre, 'resepsiyon'),

-- Misafir Kullanıcıları (ID: 6 - 60)
('ayse.demir@gmail.com',      @sifre, 'misafir'),
('mehmet.kaya@hotmail.com',   @sifre, 'misafir'),
('elif.yilmaz@yahoo.com',     @sifre, 'misafir'),
('john.smith@company.com',    @sifre, 'misafir'),
('zeynep.arslan@gmail.com',   @sifre, 'misafir'),
('hakan.aydin@ktu.edu.tr',    @sifre, 'misafir'),  -- ID: 11 (Platin VIP)
('emre.can@outlook.com',      @sifre, 'misafir'),
('caner.erkin@mail.com',      @sifre, 'misafir'),
('burcu.gunes@mail.com',      @sifre, 'misafir'),
('oguzhan.koc@mail.com',      @sifre, 'misafir'),
('busra.pekin@mail.com',      @sifre, 'misafir'),
('kerem.akturk@mail.com',     @sifre, 'misafir'),
('baris.alper@mail.com',      @sifre, 'misafir'),
('ferdi.kadioglu@mail.com',   @sifre, 'misafir'),
('arda.guler@mail.com',       @sifre, 'misafir'),
('cenk.tosun@mail.com',       @sifre, 'misafir'),
('semih.kilicsoy@mail.com',   @sifre, 'misafir'),
('irfan.can@mail.com',        @sifre, 'misafir'),
('hakan.calhanoglu@mail.com', @sifre, 'misafir'),
('mert.gunok@mail.com',       @sifre, 'misafir'),
('ugurcan.cakir@mail.com',    @sifre, 'misafir'),
('altay.bayindir@mail.com',   @sifre, 'misafir'),
('merih.demiral@mail.com',    @sifre, 'misafir'),
('kaan.ayhan@mail.com',       @sifre, 'misafir'),
('zeki.celik@mail.com',       @sifre, 'misafir'),
('salih.ozcan@mail.com',      @sifre, 'misafir'),
('ismail.yuksek@mail.com',    @sifre, 'misafir'),
('yusuf.yazici@mail.com',     @sifre, 'misafir'),
('abdulkadir.omur@mail.com',  @sifre, 'misafir'),
('dorukhan.tokoz@mail.com',   @sifre, 'misafir'),
('okay.yokuslu@mail.com',     @sifre, 'misafir'),
('deniz.turuc@mail.com',      @sifre, 'misafir'),
('enes.unal@mail.com',        @sifre, 'misafir'),
('bertug.yildirim@mail.com',  @sifre, 'misafir'),
('kenan.yildiz@mail.com',     @sifre, 'misafir'),
('eren.dinkci@mail.com',      @sifre, 'misafir'),
('can.uzun@mail.com',         @sifre, 'misafir'),
('ahmetcan.kaplan@mail.com',  @sifre, 'misafir'),
('yasin.ozcan@mail.com',      @sifre, 'misafir'),
('emirhan.ilkhan@mail.com',   @sifre, 'misafir'),
('dogan.alemdar@mail.com',    @sifre, 'misafir'),
('berke.ozer@mail.com',       @sifre, 'misafir'),
('ridvan.yilmaz@mail.com',    @sifre, 'misafir'),
('ozan.kabak@mail.com',       @sifre, 'misafir'),
('caglar.soyuncu@mail.com',   @sifre, 'misafir'),
('serdar.aziz@mail.com',      @sifre, 'misafir'),
('taylan.antalyali@mail.com', @sifre, 'misafir'),
('berkan.kutlu@mail.com',     @sifre, 'misafir'),
('halil.dervisoglu@mail.com', @sifre, 'misafir'),
('yunus.akgun@mail.com',      @sifre, 'misafir'),
('emin.bayram@mail.com',      @sifre, 'misafir'),
('kazimcan.karatas@mail.com', @sifre, 'misafir'),
('metehan.baltaci@mail.com',  @sifre, 'misafir'),
('ali.turap@mail.com',        @sifre, 'misafir'),
('hamza.akman@mail.com',      @sifre, 'misafir');

-- 3. PERSONEL (5 Kişi)
INSERT INTO Personel (kullanici_id, ad, soyad, gorev, ise_giris_tarihi) VALUES
                                                                            (1, 'Ali',  'Sergen',  'Genel Müdür',           '2021-02-15'),
                                                                            (2, 'Ege',  'Atılgan',  'Kıdemli Resepsiyonist', '2022-05-10'),
                                                                            (3, 'Melih',  'Yanıbol', 'Gece Resepsiyonisti',   '2023-01-20'),
                                                                            (4, 'Fatma',  'Göksu',  'Kat Hizmetleri Şefi',   '2021-08-01'),
                                                                            (5, 'Ömer',  'Güleçoğlu',  'Temizlik Görevlisi',    '2022-11-15');

-- 4. MISAFIRLER (55 Adet - ID: 1 - 55)
INSERT INTO Misafir (kullanici_id, tc_pasaport, telefon, dogum_tarihi, ad, soyad, toplam_puan) VALUES
                                                                                                   (6,  '11111111110', '05321112233', '1992-04-12', 'Ayşe',        'Demir',      45),
                                                                                                   (7,  '22222222220', '05332223344', '1988-11-03', 'Mehmet',      'Kaya',       0),
                                                                                                   (8,  '33333333330', '05353334455', '1995-07-21', 'Elif',        'Yılmaz',     120),
                                                                                                   (9,  'US88492019',  '05364445566', '1982-01-15', 'John',        'Smith',      80),
                                                                                                   (10, '55555555550', '05375556677', '1997-09-30', 'Zeynep',      'Arslan',     310),
                                                                                                   (11, '66666666660', '05386667788', '1980-03-25', 'Hakan',       'Aydın',      6161), -- Misafir ID 6: Hakan Aydın
                                                                                                   (12, '77777777770', '05397778899', '2001-06-18', 'Emre',        'Can',        0),
                                                                                                   (13, '18462947192', '05318264910', '1989-02-14', 'Caner',       'Erkin',      150),
                                                                                                   (14, '29471938501', '05329374821', '1991-05-22', 'Burcu',       'Güneş',      85),
                                                                                                   (15, '38501928472', '05330485932', '1985-08-19', 'Oğuzhan',     'Koç',        210),
                                                                                                   (16, '49612039583', '05341596043', '1987-12-05', 'Büşra',       'Pekin',      95),
                                                                                                   (17, '50723140694', '05352607154', '1998-10-21', 'Kerem',       'Aktürkoğlu', 340),
                                                                                                   (18, '61834251705', '05363718265', '2000-03-04', 'Barış',       'Alper',      420),
                                                                                                   (19, '72945362816', '05374829376', '1999-10-07', 'Ferdi',       'Kadıoğlu',   510),
                                                                                                   (20, '83056473927', '05385930487', '2005-02-25', 'Arda',        'Güler',      600),
                                                                                                   (21, '94167584038', '05396041598', '1991-06-07', 'Cenk',        'Tosun',      180),
                                                                                                   (22, '15278695149', '05307152609', '2005-08-15', 'Semih',       'Kılıçsoy',   275),
                                                                                                   (23, '26389706250', '05318263710', '1995-07-25', 'İrfan',       'Can',        130),
                                                                                                   (24, '37490817361', '05329374821', '1994-02-08', 'Hakan',       'Çalhanoğlu', 890),
                                                                                                   (25, '48501928472', '05330485932', '1989-03-01', 'Mert',        'Günok',      90),
                                                                                                   (26, '59612039583', '05341596043', '1996-04-05', 'Uğurcan',     'Çakır',      450),
                                                                                                   (27, '60723140694', '05352607154', '1998-04-14', 'Altay',       'Bayındır',   110),
                                                                                                   (28, '71834251705', '05363718265', '1998-03-15', 'Merih',       'Demiral',    320),
                                                                                                   (29, '82945362816', '05374829376', '1994-06-04', 'Kaan',        'Ayhan',      140),
                                                                                                   (30, '93056473927', '05385930487', '1997-02-17', 'Zeki',        'Çelik',      160),
                                                                                                   (31, '14167584038', '05396041598', '1998-01-11', 'Salih',       'Özcan',      190),
                                                                                                   (32, '25278695149', '05307152609', '1999-01-26', 'İsmail',      'Yüksek',     220),
                                                                                                   (33, '36389706250', '05318263710', '1997-01-29', 'Yusuf',       'Yazıcı',     380),
                                                                                                   (34, '47490817361', '05329374821', '1999-06-25', 'Abdülkadir',  'Ömür',       290),
                                                                                                   (35, '58501928472', '05330485932', '1996-05-01', 'Dorukhan',    'Toköz',      115),
                                                                                                   (36, '69612039583', '05341596043', '1994-03-09', 'Okay',        'Yokuşlu',    240),
                                                                                                   (37, '70723140694', '05352607154', '1993-01-29', 'Deniz',       'Türüç',      75),
                                                                                                   (38, '81834251705', '05363718265', '1997-05-10', 'Enes',        'Ünal',       310),
                                                                                                   (39, '92945362816', '05374829376', '2002-07-12', 'Bertuğ',      'Yıldırım',   145),
                                                                                                   (40, '13056473927', '05385930487', '2005-05-04', 'Kenan',       'Yıldız',     520),
                                                                                                   (41, '24167584038', '05396041598', '2001-12-13', 'Eren',        'Dinkçi',     130),
                                                                                                   (42, '35278695149', '05307152609', '2005-11-11', 'Can',         'Uzun',       210),
                                                                                                   (43, '46389706250', '05318263710', '2002-09-17', 'Ahmetcan',    'Kaplan',     180),
                                                                                                   (44, '57490817361', '05329374821', '2006-01-01', 'Yasin',       'Özcan',      95),
                                                                                                   (45, '68501928472', '05330485932', '2004-06-08', 'Emirhan',     'İlkhan',     140),
                                                                                                   (46, '79612039583', '05341596043', '2002-10-29', 'Doğan',       'Alemdar',    60),
                                                                                                   (47, '80723140694', '05352607154', '2000-05-25', 'Berke',       'Özer',       80),
                                                                                                   (48, '91834251705', '05363718265', '2001-07-25', 'Rıdvan',      'Yılmaz',     190),
                                                                                                   (49, '12945362816', '05374829376', '2000-03-25', 'Ozan',        'Kabak',      230),
                                                                                                   (50, '23056473927', '05385930487', '1996-05-23', 'Çağlar',      'Söyüncü',    410),
                                                                                                   (51, '34167584038', '05396041598', '1990-10-23', 'Serdar',      'Aziz',       120),
                                                                                                   (52, '45278695149', '05307152609', '1995-01-08', 'Taylan',      'Antalyalı',  150),
                                                                                                   (53, '56389706250', '05318263710', '1998-01-25', 'Berkan',      'Kutlu',      175),
                                                                                                   (54, '67490817361', '05329374821', '1999-12-08', 'Halil',       'Dervişoğlu', 160),
                                                                                                   (55, '78501928472', '05330485932', '2000-07-07', 'Yunus',       'Akgün',      320);
-- 5. ODALAR (25 Adet - 5 Kat)
INSERT INTO Oda (oda_no, kat, oda_tipi_id, durum) VALUES
-- Kat 1: Standart Oda (Oda Tipi: 1)
('101', 1, 1, 'bos'),
('102', 1, 1, 'dolu'),
('103', 1, 1, 'temizlikte'),
('104', 1, 1, 'bos'),
('105', 1, 1, 'bakımda'),
-- Kat 2: Deluxe Deniz Manzaralı (Oda Tipi: 2)
('201', 2, 2, 'bos'),
('202', 2, 2, 'dolu'),
('203', 2, 2, 'bos'),
('204', 2, 2, 'bos'),
('205', 2, 2, 'temizlikte'),
-- Kat 3: Aile Süiti (Oda Tipi: 3)
('301', 3, 3, 'bos'),
('302', 3, 3, 'bos'),
('303', 3, 3, 'dolu'),
('304', 3, 3, 'bos'),
('305', 3, 3, 'bos'),
-- Kat 4: Kral Dairesi (Oda Tipi: 4)
('401', 4, 4, 'dolu'),        -- Hakan Aydın'ın kaldığı daire
('402', 4, 4, 'bos'),
('403', 4, 4, 'bos'),
('404', 4, 4, 'temizlikte'),
('405', 4, 4, 'bos'),
-- Kat 5: Deluxe Penthouse (Oda Tipi: 2)
('501', 5, 2, 'bos'),
('502', 5, 2, 'dolu'),
('503', 5, 2, 'bos'),
('504', 5, 2, 'bos'),
('505', 5, 2, 'bos');

-- 6. EK HIZMETLER VE STOK
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

-- 7. SEZON FIYATLARI
INSERT INTO SezonFiyati (oda_tipi_id, baslangic_tarihi, bitis_tarihi, gecelik_fiyat) VALUES
                                                                                         (1, '2026-06-01', '2026-09-30', 2200.00),
                                                                                         (1, '2026-10-01', '2027-05-31', 1500.00),
                                                                                         (2, '2026-06-01', '2026-09-30', 3800.00),
                                                                                         (2, '2026-10-01', '2027-05-31', 2600.00),
                                                                                         (3, '2026-06-01', '2026-09-30', 5800.00),
                                                                                         (3, '2026-10-01', '2027-05-31', 4200.00),
                                                                                         (4, '2026-06-01', '2026-09-30', 14000.00),
                                                                                         (4, '2026-10-01', '2027-05-31', 9500.00);

-- 8. OZEL GUNLER
INSERT INTO OzelGun (etkinlik_adi, baslangic_tarihi, bitis_tarihi, fiyat_carpani, aciklama) VALUES
                                                                                                ('Trabzonspor - Fenerbahçe Derbisi', DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), 1.40, 'Derbi maçı yoğunluğu'),
                                                                                                ('Hakan Aydın Vizesi Sonrası İyileşme Kampı', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 18 DAY), 0.75, 'Veri tabanı sınavı sonrası kafa dinleme indirimi'),
                                                                                                ('Cumhuriyet Bayramı Tatili', DATE_ADD(CURDATE(), INTERVAL 20 DAY), DATE_ADD(CURDATE(), INTERVAL 23 DAY), 0.65, 'Resmi tatil dönemi'),
                                                                                                ('Yılbaşı Programı', '2026-12-31', '2027-01-02', 0.75, 'Yılbaşı gala programı');

-- 9. REZERVASYONLAR (212 Adet - 25 Oda İçin Çakışmasız, Sıralı)
INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum) VALUES
-- Oda 1 (101 - Standart)
(1,  1, '2026-06-02', '2026-06-06', 2, 2200.00, 'tamamlandı'),
(7,  1, '2026-06-10', '2026-06-14', 2, 2200.00, 'tamamlandı'),
(13, 1, '2026-06-18', '2026-06-23', 2, 2200.00, 'tamamlandı'),
(19, 1, '2026-07-01', '2026-07-06', 2, 2200.00, 'tamamlandı'),
(25, 1, '2026-07-12', '2026-07-17', 2, 2200.00, 'tamamlandı'),
(31, 1, '2026-08-02', '2026-08-07', 2, 2200.00, 'tamamlandı'),
(37, 1, '2026-09-01', '2026-09-06', 2, 2200.00, 'tamamlandı'),
(1,  1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 2, 1500.00, 'onaylı'), -- Bugün giriş yapacak
(43, 1, '2026-11-05', '2026-11-10', 2, 1500.00, 'onaylı'),
(49, 1, '2026-11-15', '2026-11-20', 2, 1500.00, 'beklemede'),

-- Oda 2 (102 - Standart - Şu an DOLU)
(2,  2, '2026-06-03', '2026-06-07', 2, 2200.00, 'tamamlandı'),
(8,  2, '2026-06-12', '2026-06-16', 2, 2200.00, 'tamamlandı'),
(14, 2, '2026-07-03', '2026-07-08', 2, 2200.00, 'tamamlandı'),
(20, 2, '2026-07-15', '2026-07-20', 2, 2200.00, 'tamamlandı'),
(26, 2, '2026-08-05', '2026-08-10', 2, 2200.00, 'tamamlandı'),
(32, 2, '2026-09-03', '2026-09-08', 2, 2200.00, 'tamamlandı'),
(2,  2, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 1500.00, 'onaylı'), -- Aktif Dolu
(38, 2, '2026-11-01', '2026-11-05', 2, 1500.00, 'onaylı'),
(44, 2, '2026-12-05', '2026-12-10', 2, 1500.00, 'beklemede'),

-- Oda 3 (103 - Standart - TEMİZLİKTE)
(3,  3, '2026-06-01', '2026-06-05', 2, 2200.00, 'tamamlandı'),
(9,  3, '2026-06-15', '2026-06-20', 2, 2200.00, 'tamamlandı'),
(15, 3, '2026-07-05', '2026-07-10', 2, 2200.00, 'tamamlandı'),
(21, 3, '2026-08-01', '2026-08-06', 2, 2200.00, 'tamamlandı'),
(27, 3, '2026-08-20', '2026-08-25', 2, 2200.00, 'tamamlandı'),
(33, 3, '2026-09-10', '2026-09-15', 2, 2200.00, 'tamamlandı'),
(10, 3, '2026-11-01', '2026-11-04', 2, 1500.00, 'iptal'),
(39, 3, '2026-11-10', '2026-11-15', 2, 1500.00, 'onaylı'),

-- Oda 4 (104 - Standart)
(4,  4, '2026-06-04', '2026-06-08', 2, 2200.00, 'tamamlandı'),
(10, 4, '2026-06-16', '2026-06-21', 2, 2200.00, 'tamamlandı'),
(16, 4, '2026-07-08', '2026-07-13', 2, 2200.00, 'tamamlandı'),
(22, 4, '2026-08-04', '2026-08-09', 2, 2200.00, 'tamamlandı'),
(28, 4, '2026-09-02', '2026-09-07', 2, 2200.00, 'tamamlandı'),
(40, 4, '2026-11-02', '2026-11-07', 2, 1500.00, 'onaylı'),
(46, 4, '2026-12-28', '2027-01-02', 2, 1500.00, 'onaylı'),

-- Oda 5 (105 - Standart - BAKIMDA)
(5,  5, '2026-06-05', '2026-06-09', 2, 2200.00, 'tamamlandı'),
(11, 5, '2026-06-18', '2026-06-22', 2, 2200.00, 'tamamlandı'),
(17, 5, '2026-07-10', '2026-07-15', 2, 2200.00, 'tamamlandı'),
(23, 5, '2026-08-10', '2026-08-15', 2, 2200.00, 'tamamlandı'),
(29, 5, '2026-09-05', '2026-09-10', 2, 2200.00, 'tamamlandı'),
(41, 5, '2026-12-01', '2026-12-06', 2, 1500.00, 'beklemede'),

-- Oda 6 (201 - Deluxe Deniz Manzaralı)
(6,  6, '2026-06-02', '2026-06-06', 2, 3800.00, 'tamamlandı'),
(12, 6, '2026-06-12', '2026-06-17', 2, 3800.00, 'tamamlandı'),
(18, 6, '2026-07-02', '2026-07-07', 2, 3800.00, 'tamamlandı'),
(24, 6, '2026-08-01', '2026-08-06', 2, 3800.00, 'tamamlandı'),
(30, 6, '2026-09-01', '2026-09-06', 2, 3800.00, 'tamamlandı'),
(3,  6, DATE_SUB(CURDATE(), INTERVAL 3 DAY), CURDATE(), 2, 2600.00, 'onaylı'), -- Bugün çıkış yapacak
(42, 6, '2026-11-05', '2026-11-10', 2, 2600.00, 'onaylı'),

-- Oda 7 (202 - Deluxe - Şu an DOLU)
(7,  7, '2026-06-04', '2026-06-09', 2, 3800.00, 'tamamlandı'),
(13, 7, '2026-06-16', '2026-06-21', 2, 3800.00, 'tamamlandı'),
(19, 7, '2026-07-10', '2026-07-15', 2, 3800.00, 'tamamlandı'),
(25, 7, '2026-08-05', '2026-08-10', 2, 3800.00, 'tamamlandı'),
(31, 7, '2026-09-08', '2026-09-13', 2, 3800.00, 'tamamlandı'),
(4,  7, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, 2600.00, 'onaylı'), -- Aktif Dolu
(43, 7, '2026-11-12', '2026-11-17', 2, 2600.00, 'onaylı'),

-- Oda 8 (203 - Deluxe)
(8,  8, '2026-06-01', '2026-06-05', 2, 3800.00, 'tamamlandı'),
(14, 8, '2026-06-15', '2026-06-20', 2, 3800.00, 'tamamlandı'),
(20, 8, '2026-07-05', '2026-07-10', 2, 3800.00, 'tamamlandı'),
(26, 8, '2026-08-02', '2026-08-07', 2, 3800.00, 'tamamlandı'),
(32, 8, '2026-09-03', '2026-09-08', 2, 3800.00, 'tamamlandı'),
(10, 8, '2026-11-01', '2026-11-04', 2, 2600.00, 'iptal'),
(44, 8, '2026-11-15', '2026-11-20', 2, 2600.00, 'beklemede'),

-- Oda 9 (204 - Deluxe)
(9,  9, '2026-06-03', '2026-06-07', 2, 3800.00, 'tamamlandı'),
(15, 9, '2026-06-18', '2026-06-23', 2, 3800.00, 'tamamlandı'),
(21, 9, '2026-07-12', '2026-07-17', 2, 3800.00, 'tamamlandı'),
(27, 9, '2026-08-12', '2026-08-17', 2, 3800.00, 'tamamlandı'),
(33, 9, '2026-09-12', '2026-09-17', 2, 3800.00, 'tamamlandı'),
(45, 9, '2026-11-02', '2026-11-07', 2, 2600.00, 'onaylı'),

-- Oda 10 (205 - Deluxe - TEMİZLİKTE)
(10, 10, '2026-06-05', '2026-06-09', 2, 3800.00, 'tamamlandı'),
(16, 10, '2026-06-20', '2026-06-25', 2, 3800.00, 'tamamlandı'),
(22, 10, '2026-07-18', '2026-07-23', 2, 3800.00, 'tamamlandı'),
(28, 10, '2026-08-15', '2026-08-20', 2, 3800.00, 'tamamlandı'),
(34, 10, '2026-09-15', '2026-09-20', 2, 3800.00, 'tamamlandı'),
(46, 10, '2026-11-20', '2026-11-25', 2, 2600.00, 'onaylı'),

-- Oda 11 (301 - Aile Süiti)
(11, 11, '2026-06-01', '2026-06-06', 4, 5800.00, 'tamamlandı'),
(17, 11, '2026-06-15', '2026-06-20', 4, 5800.00, 'tamamlandı'),
(23, 11, '2026-07-01', '2026-07-06', 4, 5800.00, 'tamamlandı'),
(29, 11, '2026-08-01', '2026-08-07', 4, 5800.00, 'tamamlandı'),
(35, 11, '2026-09-01', '2026-09-06', 4, 5800.00, 'tamamlandı'),
(47, 11, '2026-11-01', '2026-11-06', 4, 4200.00, 'onaylı'),

-- Oda 12 (302 - Aile Süiti)
(12, 12, '2026-06-03', '2026-06-08', 4, 5800.00, 'tamamlandı'),
(18, 12, '2026-06-18', '2026-06-23', 4, 5800.00, 'tamamlandı'),
(24, 12, '2026-07-10', '2026-07-15', 4, 5800.00, 'tamamlandı'),
(30, 12, '2026-08-10', '2026-08-15', 4, 5800.00, 'tamamlandı'),
(36, 12, '2026-09-10', '2026-09-15', 4, 5800.00, 'tamamlandı'),
(10, 12, '2026-11-01', '2026-11-04', 4, 4200.00, 'iptal'),
(48, 12, '2026-11-15', '2026-11-20', 4, 4200.00, 'onaylı'),

-- Oda 13 (303 - Aile Süiti - Şu an DOLU)
(13, 13, '2026-06-05', '2026-06-10', 4, 5800.00, 'tamamlandı'),
(19, 13, '2026-06-22', '2026-06-27', 4, 5800.00, 'tamamlandı'),
(25, 13, '2026-07-15', '2026-07-20', 4, 5800.00, 'tamamlandı'),
(31, 13, '2026-08-15', '2026-08-20', 4, 5800.00, 'tamamlandı'),
(37, 13, '2026-09-15', '2026-09-20', 4, 5800.00, 'tamamlandı'),
(5,  13, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 4, 4200.00, 'onaylı'), -- Aktif Dolu
(49, 13, '2026-11-25', '2026-11-30', 4, 4200.00, 'onaylı'),

-- Oda 14 (304 - Aile Süiti)
(14, 14, '2026-06-02', '2026-06-07', 4, 5800.00, 'tamamlandı'),
(20, 14, '2026-06-16', '2026-06-21', 4, 5800.00, 'tamamlandı'),
(26, 14, '2026-07-20', '2026-07-25', 4, 5800.00, 'tamamlandı'),
(32, 14, '2026-08-20', '2026-08-25', 4, 5800.00, 'tamamlandı'),
(50, 14, '2026-11-05', '2026-11-10', 4, 4200.00, 'onaylı'),

-- Oda 15 (305 - Aile Süiti)
(15, 15, '2026-06-06', '2026-06-11', 4, 5800.00, 'tamamlandı'),
(21, 15, '2026-06-25', '2026-06-30', 4, 5800.00, 'tamamlandı'),
(27, 15, '2026-07-22', '2026-07-27', 4, 5800.00, 'tamamlandı'),
(33, 15, '2026-08-25', '2026-08-30', 4, 5800.00, 'tamamlandı'),
(51, 15, '2026-11-10', '2026-11-15', 4, 4200.00, 'onaylı'),

-- Oda 16 (401 - Kral Dairesi - HAKAN AYDIN VIP & Şu an DOLU)
(6,  16, '2026-06-05', '2026-06-10', 2, 14000.00, 'tamamlandı'),
(6,  16, '2026-07-15', '2026-07-20', 2, 14000.00, 'tamamlandı'),
(6,  16, '2026-08-20', '2026-08-25', 2, 14000.00, 'tamamlandı'),
(6,  16, '2026-09-10', '2026-09-15', 2, 14000.00, 'tamamlandı'),
(6,  16, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 2, 9500.00, 'onaylı'), -- Hakan Aydın Aktif Konaklaması
(6,  16, '2026-12-28', '2027-01-02', 2, 9500.00, 'onaylı'),

-- Oda 17 (402 - Kral Dairesi)
(17, 17, '2026-06-10', '2026-06-15', 3, 14000.00, 'tamamlandı'),
(23, 17, '2026-07-05', '2026-07-10', 3, 14000.00, 'tamamlandı'),
(29, 17, '2026-08-05', '2026-08-10', 3, 14000.00, 'tamamlandı'),
(35, 17, '2026-09-05', '2026-09-10', 3, 14000.00, 'tamamlandı'),
(52, 17, '2026-11-01', '2026-11-06', 3, 9500.00, 'onaylı'),

-- Oda 18 (403 - Kral Dairesi)
(18, 18, '2026-06-12', '2026-06-17', 2, 14000.00, 'tamamlandı'),
(24, 18, '2026-07-12', '2026-07-17', 2, 14000.00, 'tamamlandı'),
(30, 18, '2026-08-12', '2026-08-17', 2, 14000.00, 'tamamlandı'),
(10, 18, '2026-11-01', '2026-11-04', 2, 9500.00, 'iptal'),
(53, 18, '2026-11-15', '2026-11-20', 2, 9500.00, 'onaylı'),

-- Oda 19 (404 - Kral Dairesi - TEMİZLİKTE)
(19, 19, '2026-06-15', '2026-06-20', 2, 14000.00, 'tamamlandı'),
(25, 19, '2026-07-18', '2026-07-23', 2, 14000.00, 'tamamlandı'),
(31, 19, '2026-08-18', '2026-08-23', 2, 14000.00, 'tamamlandı'),
(54, 19, '2026-11-20', '2026-11-25', 2, 9500.00, 'onaylı'),

-- Oda 20 (405 - Kral Dairesi)
(20, 20, '2026-06-20', '2026-06-25', 2, 14000.00, 'tamamlandı'),
(26, 20, '2026-07-22', '2026-07-27', 2, 14000.00, 'tamamlandı'),
(32, 20, '2026-08-22', '2026-08-27', 2, 14000.00, 'tamamlandı'),
(55, 20, '2026-12-05', '2026-12-10', 2, 9500.00, 'beklemede'),

-- Oda 21 (501 - Deluxe Penthouse)
(21, 21, '2026-06-02', '2026-06-07', 2, 3800.00, 'tamamlandı'),
(27, 21, '2026-06-18', '2026-06-23', 2, 3800.00, 'tamamlandı'),
(33, 21, '2026-07-05', '2026-07-10', 2, 3800.00, 'tamamlandı'),
(39, 21, '2026-08-05', '2026-08-10', 2, 3800.00, 'tamamlandı'),
(1,  21, '2026-11-01', '2026-11-06', 2, 2600.00, 'onaylı'),

-- Oda 22 (502 - Deluxe Penthouse - Şu an DOLU)
(22, 22, '2026-06-04', '2026-06-09', 2, 3800.00, 'tamamlandı'),
(28, 22, '2026-06-20', '2026-06-25', 2, 3800.00, 'tamamlandı'),
(34, 22, '2026-07-12', '2026-07-17', 2, 3800.00, 'tamamlandı'),
(40, 22, '2026-08-12', '2026-08-17', 2, 3800.00, 'tamamlandı'),
(7,  22, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 2600.00, 'onaylı'), -- Aktif Dolu
(2,  22, '2026-11-10', '2026-11-15', 2, 2600.00, 'onaylı'),

-- Oda 23 (503 - Deluxe Penthouse)
(23, 23, '2026-06-06', '2026-06-11', 2, 3800.00, 'tamamlandı'),
(29, 23, '2026-06-24', '2026-06-29', 2, 3800.00, 'tamamlandı'),
(35, 23, '2026-07-18', '2026-07-23', 2, 3800.00, 'tamamlandı'),
(10, 23, '2026-11-01', '2026-11-04', 2, 2600.00, 'iptal'),
(3,  23, '2026-11-20', '2026-11-25', 2, 2600.00, 'onaylı'),

-- Oda 24 (504 - Deluxe Penthouse)
(24, 24, '2026-06-08', '2026-06-13', 2, 3800.00, 'tamamlandı'),
(30, 24, '2026-06-26', '2026-07-01', 2, 3800.00, 'tamamlandı'),
(36, 24, '2026-07-20', '2026-07-25', 2, 3800.00, 'tamamlandı'),
(4,  24, '2026-12-01', '2026-12-06', 2, 2600.00, 'beklemede'),

-- Oda 25 (505 - Deluxe Penthouse)
(25, 25, '2026-06-10', '2026-06-15', 2, 3800.00, 'tamamlandı'),
(31, 25, '2026-06-28', '2026-07-03', 2, 3800.00, 'tamamlandı'),
(37, 25, '2026-07-25', '2026-07-30', 2, 3800.00, 'tamamlandı'),
(5,  25, '2026-12-28', '2027-01-02', 2, 2600.00, 'onaylı'),

-- Ek Dönem Rezervasyonları (Ocak - Mart 2027 Kış Sezonu - Toplam 212 Adet Tamamlama)
(8,  1,  '2027-01-10', '2027-01-15', 2, 1500.00, 'onaylı'),
(14, 1,  '2027-02-01', '2027-02-05', 2, 1500.00, 'beklemede'),
(19, 2,  '2027-01-12', '2027-01-17', 2, 1500.00, 'onaylı'),
(25, 2,  '2027-02-10', '2027-02-14', 2, 1500.00, 'onaylı'),
(31, 3,  '2027-01-05', '2027-01-10', 2, 1500.00, 'onaylı'),
(37, 3,  '2027-02-05', '2027-02-09', 2, 1500.00, 'beklemede'),
(43, 4,  '2027-01-15', '2027-01-20', 2, 1500.00, 'onaylı'),
(49, 4,  '2027-02-15', '2027-02-20', 2, 1500.00, 'onaylı'),
(55, 5,  '2027-01-08', '2027-01-12', 2, 1500.00, 'beklemede'),
(12, 5,  '2027-02-12', '2027-02-16', 2, 1500.00, 'onaylı'),
(18, 6,  '2027-01-06', '2027-01-11', 2, 2600.00, 'onaylı'),
(24, 6,  '2027-02-02', '2027-02-07', 2, 2600.00, 'onaylı'),
(30, 6,  '2027-03-01', '2027-03-05', 2, 2600.00, 'beklemede'),
(36, 7,  '2027-01-14', '2027-01-19', 2, 2600.00, 'onaylı'),
(42, 7,  '2027-02-14', '2027-02-18', 2, 2600.00, 'onaylı'),
(48, 7,  '2027-03-05', '2027-03-10', 2, 2600.00, 'beklemede'),
(54, 8,  '2027-01-10', '2027-01-15', 2, 2600.00, 'onaylı'),
(9,  8,  '2027-02-10', '2027-02-15', 2, 2600.00, 'onaylı'),
(15, 8,  '2027-03-10', '2027-03-14', 2, 2600.00, 'onaylı'),
(21, 9,  '2027-01-05', '2027-01-09', 2, 2600.00, 'onaylı'),
(27, 9,  '2027-02-05', '2027-02-10', 2, 2600.00, 'beklemede'),
(33, 9,  '2027-03-02', '2027-03-06', 2, 2600.00, 'onaylı'),
(39, 10, '2027-01-18', '2027-01-23', 2, 2600.00, 'onaylı'),
(45, 10, '2027-02-18', '2027-02-22', 2, 2600.00, 'onaylı'),
(51, 10, '2027-03-12', '2027-03-16', 2, 2600.00, 'beklemede'),
(11, 11, '2027-01-07', '2027-01-12', 4, 4200.00, 'onaylı'),
(17, 11, '2027-02-07', '2027-02-12', 4, 4200.00, 'onaylı'),
(23, 11, '2027-03-07', '2027-03-11', 4, 4200.00, 'beklemede'),
(29, 12, '2027-01-15', '2027-01-20', 4, 4200.00, 'onaylı'),
(35, 12, '2027-02-15', '2027-02-19', 4, 4200.00, 'onaylı'),
(41, 13, '2027-01-10', '2027-01-14', 4, 4200.00, 'onaylı'),
(47, 13, '2027-02-10', '2027-02-15', 4, 4200.00, 'beklemede'),
(53, 14, '2027-01-04', '2027-01-09', 4, 4200.00, 'onaylı'),
(13, 14, '2027-02-04', '2027-02-08', 4, 4200.00, 'onaylı'),
(19, 14, '2027-03-04', '2027-03-09', 4, 4200.00, 'onaylı'),
(25, 15, '2027-01-12', '2027-01-17', 4, 4200.00, 'onaylı'),
(31, 15, '2027-02-12', '2027-02-17', 4, 4200.00, 'beklemede'),
(37, 15, '2027-03-12', '2027-03-16', 4, 4200.00, 'onaylı'),
(6,  16, '2027-01-20', '2027-01-25', 2, 9500.00, 'onaylı'),
(6,  16, '2027-02-20', '2027-02-25', 2, 9500.00, 'onaylı'),
(43, 17, '2027-01-08', '2027-01-13', 3, 9500.00, 'onaylı'),
(49, 17, '2027-02-08', '2027-02-12', 3, 9500.00, 'beklemede'),
(55, 18, '2027-01-14', '2027-01-18', 2, 9500.00, 'onaylı'),
(10, 18, '2027-02-14', '2027-02-19', 2, 9500.00, 'onaylı'),
(16, 19, '2027-01-05', '2027-01-10', 2, 9500.00, 'onaylı'),
(22, 19, '2027-02-05', '2027-02-09', 2, 9500.00, 'beklemede'),
(28, 19, '2027-03-05', '2027-03-09', 2, 9500.00, 'onaylı'),
(34, 20, '2027-01-11', '2027-01-16', 2, 9500.00, 'onaylı'),
(40, 20, '2027-02-11', '2027-02-15', 2, 9500.00, 'onaylı'),
(46, 20, '2027-03-11', '2027-03-15', 2, 9500.00, 'beklemede'),
(52, 21, '2027-01-06', '2027-01-10', 2, 2600.00, 'onaylı'),
(12, 21, '2027-02-06', '2027-02-11', 2, 2600.00, 'onaylı'),
(18, 22, '2027-01-15', '2027-01-20', 2, 2600.00, 'onaylı'),
(24, 22, '2027-02-15', '2027-02-19', 2, 2600.00, 'beklemede'),
(30, 23, '2027-01-09', '2027-01-14', 2, 2600.00, 'onaylı'),
(36, 23, '2027-02-09', '2027-02-13', 2, 2600.00, 'onaylı'),
(42, 24, '2027-01-12', '2027-01-17', 2, 2600.00, 'onaylı'),
(48, 24, '2027-02-12', '2027-02-16', 2, 2600.00, 'beklemede'),
(54, 24, '2027-03-01', '2027-03-05', 2, 2600.00, 'onaylı'),
(8,  25, '2027-01-18', '2027-01-22', 2, 2600.00, 'onaylı'),
(14, 25, '2027-02-18', '2027-02-23', 2, 2600.00, 'onaylı');

-- 10. KONAKLAMA KAYITLARI (Geçmiş Tamamlananlar + Şu Anki Aktifler)
INSERT INTO Konaklama (rezervasyon_id, islem_yapan_personel_id, gercek_giris, gercek_cikis) VALUES
-- Aktif Konaklamalar (Odalarda kalanlar, çıkış henüz yapılmadı NULL)
(17,  2, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),                    -- Oda 102
(53,  2, DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),                    -- Oda 202
(92,  3, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),                    -- Oda 303
(108, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),                    -- Oda 401 (Hakan Aydın)
(137, 3, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL),                    -- Oda 502
(46,  2, DATE_SUB(NOW(), INTERVAL 3 DAY), NULL),                    -- Oda 201 (Bugün çıkış bekleyen)

-- Örnek Tamamlanmış Geçmiş Konaklamalar (Ödemesi yapılmış)
(1,   2, '2026-06-02 14:00:00', '2026-06-06 11:30:00'),
(2,   3, '2026-06-10 14:30:00', '2026-06-14 10:45:00'),
(11,  2, '2026-06-03 15:00:00', '2026-06-07 11:00:00'),
(104, 2, '2026-06-05 14:00:00', '2026-06-10 12:00:00'),            -- Hakan Aydın Haziran
(105, 3, '2026-07-15 14:15:00', '2026-07-20 11:00:00'),            -- Hakan Aydın Temmuz
(106, 2, '2026-08-20 14:00:00', '2026-08-25 11:30:00');            -- Hakan Aydın Ağustos

-- 11. KONAKLAMA HIZMET HARCAMALARI
INSERT INTO KonaklamaHizmeti (konaklama_id, ek_hizmet_id, adet) VALUES
                                                                    (1, 1, 2),  -- Minibar su
                                                                    (1, 5, 2),  -- Serpme kahvaltı
                                                                    (2, 2, 2),  -- Kutu kola
                                                                    (3, 6, 1),  -- Kese & masaj
                                                                    (4, 7, 1),  -- Hakan Aydın transfer
                                                                    (4, 8, 2),  -- Hakan Hoca çay & fındık ikramı (0 TL)
                                                                    (5, 5, 2),
                                                                    (6, 6, 1);
-- 12. ODEMELER
INSERT INTO Odeme (konaklama_id, tutar, odeme_turu) VALUES
                                                        (7,  9570.00,  'kart'),
                                                        (8,  8960.00,  'kart'),
                                                        (9,  9700.00,  'nakit'),
                                                        (10, 70750.00, 'kart'),  -- Hakan Aydın Kral Dairesi ödemesi
                                                        (11, 70700.00, 'kart'),
                                                        (12, 70900.00, 'kart');


-- 13. TEMIZLIK GOREVLERI
INSERT INTO TemizlikGorevleri (oda_id, personel_id, oncelik, durum, tamamlanma_zamani) VALUES
                                                                                           (3,  NULL, 'Acil',   'Beklemede', NULL),
                                                                                           (10, 5,    'Normal', 'Yapılıyor', NULL),
                                                                                           (19, 4,    'Acil',   'Beklemede', NULL),
                                                                                           (15, 4,    'Normal', 'Tamamlandı', DATE_SUB(NOW(), INTERVAL 1 DAY)),
                                                                                           (1,  5,    'Normal', 'Tamamlandı', DATE_SUB(NOW(), INTERVAL 2 DAY)),
                                                                                           (6,  5,    'Normal', 'Tamamlandı', DATE_SUB(NOW(), INTERVAL 3 DAY));


-- 14. BILINCLI HATA TESTLERI VE TRIGGER KONTROLLERI ICIN MOCK DATA   (1-6 arası aynı triggerı farklı senaryolarda test etmek için)

-- 1. Tarih cakismasi testi aktif dolu odaya ayni tarihlerde rezervasyon denemesi
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (6, 16, DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 9500.00, 'onaylı');

-- 2.birebir ayni tarihe rezervasyon denemesi
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (8, 1, '2026-06-02', '2026-06-06', 2, 2200.00, 'onaylı');

-- 3.mevcut rezervasyonun tam ortasindaki gunlere rezervasyon denemesi
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (15, 2, '2026-06-13', '2026-06-15', 2, 2200.00, 'beklemede');

-- 4.oncesinde baslayip mevcut rezervasyonun icine tasan deneme
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (20, 6, '2026-06-30', '2026-07-04', 2, 3800.00, 'onaylı');

-- 5.mevcut rezervasyonun icinde baslayip sonrasina sarkan deneme
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (25, 16, '2026-08-23', '2026-08-28', 2, 14000.00, 'onaylı');

-- 6. Check in aninda odanin dolu durumuna gecisini kontrol etmek icin
-- INSERT INTO Konaklama (rezervasyon_id, islem_yapan_personel_id, gercek_giris)
-- VALUES (8, 2, NOW());
-- SELECT oda_no, durum FROM Oda WHERE oda_no = '101';

-- 7. Check out aninda odanin temizlikte olmasi ve acil gorev atanmasini kontrol etmek icin
-- UPDATE Konaklama SET gercek_cikis = NOW() WHERE id = 1;
-- SELECT oda_no, durum FROM Oda WHERE oda_no = '102';
-- SELECT * FROM TemizlikGorevleri WHERE oda_id = 2 ORDER BY id DESC LIMIT 1;

-- 8.Rezervasyon durumu degistiginde log kaydi olusmasini kontrol etmek icin
-- UPDATE Rezervasyon SET durum = 'iptal' WHERE id = 11;
-- SELECT * FROM IslemLog WHERE tablo_adi = 'Rezervasyon' ORDER BY id DESC LIMIT 1;

-- 9. Ek hizmet satildiginda envanterden stok dusulmesini kontrol etmek icin (Kola stogu 85 -> 83)
-- INSERT INTO KonaklamaHizmeti (konaklama_id, ek_hizmet_id, adet) VALUES (1, 2, 2)
-- SELECT * FROM HizmetEnvanter WHERE hizmet_id = 2;

-- 10. Yetersiz stokta siparisin engellenmesini kontrol etmek icin
-- INSERT INTO KonaklamaHizmeti (konaklama_id, ek_hizmet_id, adet) VALUES (1, 3, 500);

-- 11. Odeme yapildiginda misafirin sadakat puaninin %2 artmasini kontrol etmek icin (Puan +200)
-- INSERT INTO Odeme (konaklama_id, tutar, odeme_turu) VALUES (4, 10000.00, 'kart');
-- SELECT id, ad, soyad, toplam_puan FROM Misafir WHERE id = 6;

-- 12. Puanı eksiye düşürmeyi kontrol etmek içim
-- UPDATE Misafir SET toplam_puan = -10 WHERE id = 1;

-- 13. Puan harcamayı kontrol etmek için
-- UPDATE Misafir SET toplam_puan = 25 WHERE id = 1;
-- SELECT * FROM IslemLog WHERE tablo_adi = 'Misafir' ORDER BY id DESC LIMIT 1;

-- 14. Oda kapasitesini kontrol etme
-- INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi,kisi_sayisi, anlasilan_fiyat, durum)
-- VALUES (1,1, '2026-11-20', '2026-11-25', 5, 1500.00, 'onaylı');

-- 15. Temizlik sonrası odanın rezerv edilebilir oluşunu kontrol etme
-- UPDATE TemizlikGorevleri SET durum = 'Tamamlandı' WHERE id = 1;
-- SELECT oda_no, durum FROM Oda WHERE id = 3;