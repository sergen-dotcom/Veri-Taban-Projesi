CREATE DATABASE IF NOT EXISTS hastane_otomasyonu;
USE hastane_otomasyonu;

CREATE TABLE Poliklinik (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poliklinik_adi VARCHAR(100) NOT NULL,
    kat_blok VARCHAR(50)
) ENGINE = InnoDB;

CREATE TABLE Laboratuvar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lab_adi VARCHAR(100) NOT NULL,
    konum VARCHAR(50)
) ENGINE = InnoDB;

CREATE TABLE Hasta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tc_kimlik VARCHAR(11) UNIQUE NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    dogum_tarihi DATE NOT NULL,
    telefon VARCHAR(20)
) ENGINE = InnoDB;

CREATE TABLE Doktor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poliklinik_id INT NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    uzmanlik VARCHAR(100) NOT NULL,
    diploma_no VARCHAR(50) UNIQUE,
    CONSTRAINT fk_doktor_poliklinik FOREIGN KEY (poliklinik_id) REFERENCES Poliklinik(id)
) ENGINE = InnoDB;

CREATE TABLE Servis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poliklinik_id INT NOT NULL,
    servis_adi VARCHAR(100) NOT NULL,
    yatak_kapasitesi INT DEFAULT 0,
    CONSTRAINT fk_servis_poliklinik FOREIGN KEY (poliklinik_id) REFERENCES Poliklinik(id)
) ENGINE = InnoDB;

CREATE TABLE Hemsire (
    id INT AUTO_INCREMENT PRIMARY KEY,
    servis_id INT NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(20),
    CONSTRAINT fk_hemsire_servis FOREIGN KEY (servis_id) REFERENCES Servis(id)
) ENGINE = InnoDB;

CREATE TABLE Tahlil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    laboratuvar_id INT NOT NULL,
    tahlil_adi VARCHAR(100) NOT NULL,
    ucret DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_tahlil_lab FOREIGN KEY (laboratuvar_id) REFERENCES Laboratuvar(id)
) ENGINE = InnoDB;

CREATE TABLE HastaPoliklinik (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hasta_id INT NOT NULL,
    poliklinik_id INT NOT NULL,
    muayene_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sikayet TEXT,
    CONSTRAINT fk_hp_hasta FOREIGN KEY (hasta_id) REFERENCES Hasta(id) ON DELETE CASCADE,
    CONSTRAINT fk_hp_poliklinik FOREIGN KEY (poliklinik_id) REFERENCES Poliklinik(id)
) ENGINE = InnoDB;

CREATE TABLE HastaTahlil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hasta_id INT NOT NULL,
    tahlil_id INT NOT NULL,
    doktor_id INT NOT NULL,
    istek_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sonuc VARCHAR(255),
    CONSTRAINT fk_ht_hasta FOREIGN KEY (hasta_id) REFERENCES Hasta(id) ON DELETE CASCADE,
    CONSTRAINT fk_ht_tahlil FOREIGN KEY (tahlil_id) REFERENCES Tahlil(id),
    CONSTRAINT fk_ht_doktor FOREIGN KEY (doktor_id) REFERENCES Doktor(id)
) ENGINE = InnoDB;
