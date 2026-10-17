USE hotel_management;

DELIMITER //

DROP TRIGGER IF EXISTS trg_rezervasyon_cakisma_insert//
CREATE TRIGGER trg_rezervasyon_cakisma_insert
    BEFORE INSERT ON Rezervasyon
    FOR EACH ROW
BEGIN
    DECLARE cakisma_sayisi INT DEFAULT 0;

    IF NEW.cikis_tarihi <= NEW.giris_tarihi THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Çıkış tarihi giriş tarihinden sonra olmalıdır.';
    END IF;

    SELECT COUNT(*) INTO cakisma_sayisi
    FROM Rezervasyon
    WHERE oda_id = NEW.oda_id
      AND durum != 'iptal'
      AND NEW.giris_tarihi < cikis_tarihi
      AND NEW.cikis_tarihi > giris_tarihi;

    IF cakisma_sayisi > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Seçilen tarihlerde oda rezerve edilmiştir.';
    END IF;
END //
  -- Çakışan tarihli rezervasyonları ve çıkış <= giriş mantıksızlığını engeller.


DROP TRIGGER IF EXISTS trg_rezervasyon_cakisma_update//
CREATE TRIGGER trg_rezervasyon_cakisma_update
    BEFORE UPDATE ON Rezervasyon
    FOR EACH ROW
BEGIN
    DECLARE cakisma_sayisi INT DEFAULT 0;

    IF NEW.cikis_tarihi <= NEW.giris_tarihi THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Çıkış tarihi giriş tarihinden sonra olmalıdır.';
    END IF;

    SELECT COUNT(*) INTO cakisma_sayisi
    FROM Rezervasyon
    WHERE oda_id = NEW.oda_id
      AND id != NEW.id
      AND durum != 'iptal'
      AND NEW.giris_tarihi < cikis_tarihi
      AND NEW.cikis_tarihi > giris_tarihi;

    IF cakisma_sayisi > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Seçilen tarihlerde oda rezerve edilmiştir.';
    END IF;
END //
-- Rezervasyon güncellemelerinde tarih çakışmalarını engeller.

DROP TRIGGER IF EXISTS trg_checkin_oda_dolu//
CREATE TRIGGER trg_checkin_oda_dolu
    AFTER INSERT ON Konaklama
    FOR EACH ROW
BEGIN
    DECLARE v_oda_id INT;

    IF NEW.gercek_cikis IS NULL THEN
        SELECT oda_id INTO v_oda_id
        FROM Rezervasyon
        WHERE id = NEW.rezervasyon_id;

        UPDATE Oda
        SET durum = 'dolu'
        WHERE id = v_oda_id;
    END IF;
END //
-- Check-in yapıldığında odayı otomatik 'dolu' durumuna geçirir.



DROP TRIGGER IF EXISTS trg_checkout_oda_temizlik//
CREATE TRIGGER trg_checkout_oda_temizlik
    AFTER UPDATE ON Konaklama
    FOR EACH ROW
BEGIN
    DECLARE v_oda_id INT;

    IF OLD.gercek_cikis IS NULL AND NEW.gercek_cikis IS NOT NULL THEN
        SELECT oda_id INTO v_oda_id
        FROM Rezervasyon
        WHERE id = NEW.rezervasyon_id;

        UPDATE Oda
        SET durum = 'temizlikte'
        WHERE id = v_oda_id;

        INSERT INTO TemizlikGorevleri (oda_id, personel_id, oncelik, durum, atama_zamani)
        VALUES (v_oda_id, NULL, 'Acil', 'Beklemede', NOW());
    END IF;
END //
-- Check-out anında odayı 'temizlikte' yapar ve TemizlikGorevleri tablosuna 'Acil' görev açar.



DROP TRIGGER IF EXISTS trg_rezervasyon_islem_log//
CREATE TRIGGER trg_rezervasyon_islem_log
    AFTER UPDATE ON Rezervasyon
    FOR EACH ROW
BEGIN
    IF OLD.durum != NEW.durum THEN
        INSERT INTO IslemLog (tablo_adi, islem_turu, eski_deger, yeni_deger, zaman_damgasi)
        VALUES (
                   'Rezervasyon',
                   'UPDATE',
                   CONCAT('ID: ', OLD.id, ' | Durum: ', OLD.durum),
                   CONCAT('ID: ', NEW.id, ' | Durum: ', NEW.durum),
                   NOW()
               );
    END IF;
END //
-- Rezervasyon durum değişikliklerini eski ve yeni değerleriyle IslemLog tablosuna kaydeder.


DROP TRIGGER IF EXISTS trg_hizmet_stok_dusumu//
CREATE TRIGGER trg_hizmet_stok_dusumu
    BEFORE INSERT ON KonaklamaHizmeti
    FOR EACH ROW
BEGIN
    DECLARE v_mevcut_stok INT DEFAULT NULL;

    SELECT stok_miktari INTO v_mevcut_stok
    FROM HizmetEnvanter
    WHERE hizmet_id = NEW.ek_hizmet_id;

    IF v_mevcut_stok IS NOT NULL THEN
        IF v_mevcut_stok < NEW.adet THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'HATA: Envanterde yeterli ürün yok.';
        ELSE
            UPDATE HizmetEnvanter
            SET stok_miktari = stok_miktari - NEW.adet
            WHERE hizmet_id = NEW.ek_hizmet_id;
        END IF;
    END IF;
END //
-- Fiziksel ürün siparişlerinde envanterden stok düşer; yetersiz stokta işlemi engeller.


DROP TRIGGER IF EXISTS trg_misafir_puan_artir//
CREATE TRIGGER trg_misafir_puan_artir
    AFTER INSERT ON Odeme
    FOR EACH ROW
BEGIN
    DECLARE v_misafir_id INT;
    DECLARE v_eklenecek_puan INT;

    SELECT r.misafir_id INTO v_misafir_id
    FROM Konaklama k
             JOIN Rezervasyon r ON k.rezervasyon_id = r.id
    WHERE k.id = NEW.konaklama_id;

    SET v_eklenecek_puan = FLOOR(NEW.tutar * 0.02);

    IF v_misafir_id IS NOT NULL AND v_eklenecek_puan > 0 THEN
        UPDATE Misafir
        SET toplam_puan = toplam_puan + v_eklenecek_puan
        WHERE id = v_misafir_id;
    END IF;
END //
-- Tahsil edilen ödeme tutarının %2'sini misafirin toplam_puan bakiyesine ekler.


DROP TRIGGER IF EXISTS trg_misafir_puan_kontrol_ve_log//
CREATE TRIGGER trg_misafir_puan_kontrol_ve_log
    BEFORE UPDATE ON Misafir
    FOR EACH ROW
BEGIN
    IF NEW.toplam_puan < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Yetersiz puan.';
    END IF;

    IF NEW.toplam_puan < OLD.toplam_puan THEN
        INSERT INTO IslemLog (tablo_adi, islem_turu, eski_deger, yeni_deger, zaman_damgasi)
        VALUES (
                   'Misafir',
                   'UPDATE',
                   CONCAT('Misafir ID: ', OLD.id, ' | Önceki Puan: ', OLD.toplam_puan),
                   CONCAT('Harcanan Puan: ', (OLD.toplam_puan - NEW.toplam_puan), ' | Kalan Puan: ', NEW.toplam_puan),
                   NOW()
               );
    END IF;
END //
-- Puan bakiyesinin sıfırın altına düşmesini engeller ve harcanan puanları IslemLog'a yazar.


DROP TRIGGER IF EXISTS trg_rezervasyon_kapasite_kontrol//
CREATE TRIGGER trg_rezervasyon_kapasite_kontrol
    BEFORE INSERT ON Rezervasyon
    FOR EACH ROW
BEGIN
    DECLARE v_kapasite INT DEFAULT 0;

    SELECT ot.kapasite INTO v_kapasite
    FROM Oda o
             JOIN OdaTipi ot ON o.oda_tipi_id = ot.id
    WHERE o.id = NEW.oda_id;

    IF NEW.kisi_sayisi > v_kapasite THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Kisi sayisi odanın maksimum kapasitesini aşamaz.';
    END IF;
END //
-- Odanın maksimum kişi kapasitesini aşan rezervasyon denemelerini engeller.


DROP TRIGGER IF EXISTS trg_temizlik_bitti_oda_bos//
CREATE TRIGGER trg_temizlik_bitti_oda_bos
    AFTER UPDATE ON TemizlikGorevleri
    FOR EACH ROW
BEGIN
    IF OLD.durum != 'Tamamlandı' AND NEW.durum = 'Tamamlandı' THEN
        UPDATE Oda
        SET durum = 'bos'
        WHERE id = NEW.oda_id;
    END IF;
END //
-- Temizlik görevi tamamlandığında odayı otomatik 'bos' durumuna çekerek satışa açar.

DELIMITER ;