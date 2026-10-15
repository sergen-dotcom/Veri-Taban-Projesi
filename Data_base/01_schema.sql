CREATE DATABASE IF NOT EXISTS hotel_management;
Use hotel_management;

-- temel tablolar(OdatTipi, Kullanıcı, EkHizmet)
CREATE TABLE OdaTipi (
    id INT AUTO_INCREMENT PRIMARY KEY, -- auto_increment otomatik oda ekledikçe id sayısını +1 yapacak, primary key de hem unique hem not null değeri sağlar. diğer tablolara bağlamada önemli
    ad VARCHAR(50) NOT NULL, -- 50 karaktere kadar isim alabilir
    kapasite INT NOT NULL,
    aciklama TEXT,  -- açıklamaları text saklar
    temel_fiyat DECIMAL(10, 2) NOT NULL -- decimal (10,2) 10 precision (total basamak sayısı) 2 scale (virgülden sonraki basamak sayısı) ifade eder.
    ) ENGINE = InnoDB; -- InnoDB transaction (ACID) ((aynı anda işlem yapmada daha iyi)) desteği sunuyor. (MYISAM da bu destek yok o yüzden)

CREATE TABLE Kullanici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    eposta VARCHAR(100) UNIQUE NOT NULL, -- unique aynı e postanın birden fazla kullanılmaması için
    sifre VARCHAR(255) NOT NULL,
    rol ENUM('misafir', 'resepsiyon', 'yonetici') NOT NULL -- ENUM rol atamalarında
) ENGINE=InnoDB;

CREATE TABLE EkHizmet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hizmet_adi VARCHAR(100) NOT NULL,
    birim_fiyat DECIMAL(10, 2) NOT NULL -- decimal yerine float veya double kullansaaydım "yaklaşık" sakladığı için kuruş kaybı meydana gelirdi (muhasebe işleri beni ne ilgilendiriyorsa)
) ENGINE=InnoDB; -- decimal exact sayıyı tutar son virgülünün son kuruşuna kadar.

-- bağımlı tablolar (secondary bağlayacakların)

CREATE TABLE HizmetEnvanter (
    hizmet_id INT PRIMARY KEY, -- id auto increment yok çünkü içilen kolanın tek bi stok kaydı olabilir. iki stok satırı olmaz. (bire bir / bire sıfır ilişkisiymiş.)
    stok_miktari INT DEFAULT 0, -- yeni ürün eklendiğinde otomatik stoğu 0 yapar.
    CONSTRAINT fk_envanter_hizmet FOREIGN KEY (hizmet_id) REFERENCES EkHizmet(id) ON DELETE CASCADE
)ENGINE=InnoDB; -- hizmet_id bağlandığı hizmet tablosundan geldiği için var olan bir id olmak zorunda hayali bir ürüne stok girilmez.
-- on delete cascede ekhizmet taablosundan birşey sildiğimde burdada silinmesini sağlıyormuş.
-- Bu tablonun bağıl olmasının sebebi her ek hizmetin fiziksel ürün olmaması KOLA vb. stoğu tutulabilir ürünler için. Masaj vb şeylerin stoğu tutulamayacağı için ek hizmetler tablosunda null döndürmem gerekecekti.

CREATE TABLE Misafir (
    id INT AUTO_INCREMENT PRIMARY KEY, -- her user eklediğinde +1 basıcak
    kullanici_id INT UNIQUE  NOT NULL, -- her misafirin bir kullanıcı adı olmalı
    tc_pasaport VARCHAR(20),
    telefon VARCHAR(20),
    dogum_tarihi DATE NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    toplam_puan INT DEFAULT 0, -- total puan anlık belirsiz ama kullanıcının otelde kaldıkça puan toplayıp indirim kazanmasını sağlayan  bi sistem düşünüyorum.
    CONSTRAINT fk_misafir_user FOREIGN KEY (kullanici_id) REFERENCES  Kullanici(id) ON DELETE CASCADE
)ENGINE=InnoDB; -- constraint line'ı burda kullanıcı tablosundaki bir id silindiğinde a.k.a kullanıcı_id otomatik bu tablodanda silecek.

CREATE TABLE Personel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kullanici_id INT UNIQUE NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    gorev VARCHAR(50) NOT NULL,
    ise_giris_tarihi DATE NOT NULL,
    CONSTRAINT fk_personel_user FOREIGN KEY (kullanici_id) REFERENCES Kullanici(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- business tabloları

CREATE TABLE Oda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oda_no VARCHAR(10) UNIQUE NOT NULL,
    kat INT NOT NULL,
    oda_tipi_id INT NOT NULL,
    durum ENUM('bos', 'dolu', 'temizlikte', 'bakımda') DEFAULT 'bos',
    CONSTRAINT fk_oda_tipi FOREIGN KEY (oda_tipi_id) REFERENCES  OdaTipi(id)
) ENGINE=InnoDB; -- foreign key oda_tipi_id OdaTipi tablosundaki idyi referaenceliyor.

CREATE  TABLE SezonFiyati (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oda_tipi_id INT NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    gecelik_fiyat DECIMAL(10,2) NOT NULL,
    CONSTRAINT  fk_sezon_tipi FOREIGN KEY (oda_tipi_id) REFERENCES OdaTipi(id)
) ENGINE=InnoDB;

CREATE TABLE Rezervasyon (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    misafir_id INT NOT NULL,
    oda_id INT NOT NULL,
    giris_tarihi DATE NOT NULL,
    cikis_tarihi DATE NOT NULL,
    kisi_sayisi INT NOT NULL,
    anlasilan_fiyat DECIMAL(10,2) NOT NULL, -- burda sezon fiyatı değiştikten sonra rezervasyonun fiyatı değişmesin diye.
    durum ENUM('beklemede', 'onaylı', 'iptal', 'tamamlandı') DEFAULT  'beklemede',
    olusturma_tarihi TIMESTAMP DEFAULT  CURRENT_TIMESTAMP, -- dakika saniyeye kdr tutuyor.
    CONSTRAINT fk_rez_misafir FOREIGN KEY (misafir_id) REFERENCES  Misafir(id),
    CONSTRAINT fk_rez_oda FOREIGN KEY  (oda_id) REFERENCES  Oda(id)
) ENGINE=InnoDB;

CREATE TABLE Konaklama (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rezervasyon_id INT UNIQUE NOT NULL,
    islem_yapan_personel_id INT NOT NULL,
    gercek_giris TIMESTAMP NULL,
    gercek_cikis TIMESTAMP NULL,
    CONSTRAINT fk_konaklama_rez FOREIGN KEY (rezervasyon_id) REFERENCES Rezervasyon(id),
    CONSTRAINT fk_konaklama_personel FOREIGN KEY (islem_yapan_personel_id) REFERENCES Personel(id)
) ENGINE=InnoDB;

-- hizmet ödemeler ve görev

CREATE TABLE KonaklamaHizmeti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    konaklama_id INT NOT NULL,
    ek_hizmet_id INT NOT NULL,
    adet INT NOT NULL,
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_kh_konaklama FOREIGN KEY (konaklama_id) REFERENCES Konaklama(id),
    CONSTRAINT fk_kh_hizmet FOREIGN KEY (ek_hizmet_id) REFERENCES EkHizmet(id)
) ENGINE=InnoDB;

CREATE TABLE Odeme (
    id INT AUTO_INCREMENT PRIMARY KEY,
    konaklama_id INT NOT NULL,
    tutar DECIMAL(10, 2) NOT NULL,
    odeme_turu ENUM('nakit', 'kart') NOT NULL,
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_odeme_konaklama FOREIGN KEY (konaklama_id) REFERENCES Konaklama(id)
) ENGINE=InnoDB;

CREATE TABLE TemizlikGorevleri (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oda_id INT NOT NULL,
    personel_id INT,
    oncelik ENUM('Düşük', 'Normal', 'Acil') DEFAULT 'Normal',
    durum ENUM('Beklemede', 'Yapılıyor', 'Tamamlandı') DEFAULT 'Beklemede',
    atama_zamani TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tamamlanma_zamani TIMESTAMP NULL,
    CONSTRAINT fk_temizlik_oda FOREIGN KEY (oda_id) REFERENCES Oda(id),
    CONSTRAINT fk_temizlik_personel FOREIGN KEY (personel_id) REFERENCES Personel(id)
) ENGINE=InnoDB;

-- log

CREATE TABLE IslemLog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tablo_adi VARCHAR(50),
    islem_turu ENUM('INSERT', 'UPDATE', 'DELETE'),
    eski_deger TEXT,
    yeni_deger TEXT,
    zaman_damgasi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ÖZEL GÜN TABLOSU **

CREATE TABLE OzelGun(
    id INT AUTO_INCREMENT PRIMARY KEY,
    etkinlik_adi VARCHAR(100) NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    fiyat_carpani DECIMAL(3,2) DEFAULT  1.20,
    aciklama VARCHAR(255)
) ENGINE=InnoDB;

CREATE INDEX idx_rez_oda_tarih ON Rezervasyon (oda_id,giris_tarihi, cikis_tarihi);

CREATE INDEX idx_rez_durum ON Rezervasyon (durum);

CREATE INDEX idx_oda_durum ON Oda (durum);

CREATE INDEX idx_sezon_tip_tarih ON SezonFiyati (oda_tipi_id, baslangic_tarihi, bitis_tarihi);

CREATE INDEX idx_temizlik_durum ON TemizlikGorevleri (durum, oncelik);

CREATE INDEX idx_ozel_gun_tarih ON OzelGun (baslangic_tarihi, bitis_tarihi);