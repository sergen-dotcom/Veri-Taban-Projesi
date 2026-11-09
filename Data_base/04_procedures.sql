USE hotel_management;

DELIMITER //

DROP FUNCTION IF EXISTS fn_oda_fiyati_hesapla//
CREATE FUNCTION fn_oda_fiyati_hesapla(
    p_oda_tipi_id INT,
    p_giris_tarihi DATE,
    p_cikis_tarihi DATE
) RETURNS DECIMAL(10, 2)
    READS SQL DATA -- binary log açıkken MySQL fonksiyonun veri okuduğunu belirtmemizi istiyor
BEGIN
    DECLARE v_toplam DECIMAL(10, 2);

    WITH RECURSIVE geceler (gun) AS (
        SELECT p_giris_tarihi
        WHERE p_giris_tarihi < p_cikis_tarihi
        UNION ALL
        SELECT gun + INTERVAL 1 DAY
        FROM geceler
        WHERE gun + INTERVAL 1 DAY < p_cikis_tarihi -- çıkış günü gece sayılmaz
    )
    SELECT SUM(
                   IFNULL((SELECT sf.gecelik_fiyat FROM SezonFiyati sf
                           WHERE sf.oda_tipi_id = p_oda_tipi_id AND g.gun BETWEEN sf.baslangic_tarihi AND sf.bitis_tarihi LIMIT 1),
                          (SELECT temel_fiyat FROM OdaTipi WHERE id = p_oda_tipi_id))
                       * IFNULL((SELECT oz.fiyat_carpani FROM OzelGun oz
                                 WHERE g.gun BETWEEN oz.baslangic_tarihi AND oz.bitis_tarihi
                                   AND (oz.oda_tipi_id IS NULL OR oz.oda_tipi_id = p_oda_tipi_id) LIMIT 1), 1)
           )
    INTO v_toplam
    FROM geceler g;

    RETURN v_toplam;
END //
-- Bir oda tipinin verilen tarihler arasındaki toplam konaklama ücretini hesaplar.
-- Her gece için o gecenin sezon fiyatı (yoksa temel fiyat) alınır, o gün özel gün varsa çarpanı uygulanır.
-- Fiyat hesabı tek yerde dursun diye fonksiyon yaptım: boş oda arama, tutar hesaplama ve fiyat teklifi hep bunu kullanıyor.


DROP PROCEDURE IF EXISTS sp_bos_odalari_listele//
CREATE PROCEDURE sp_bos_odalari_listele(
    IN p_giris_tarihi DATE,
    IN p_cikis_tarihi DATE,
    IN p_oda_tipi_id INT, -- NULL verilirse tüm oda tiplerinde arar
    IN p_olanaklar VARCHAR(100) -- istenen olanak id'leri virgülle ('6,7' gibi), NULL verilirse filtre yok
)
BEGIN
    SELECT o.id AS oda_id, o.oda_no, o.kat, ot.ad AS oda_tipi, ot.kapasite,
           fn_oda_fiyati_hesapla(o.oda_tipi_id, p_giris_tarihi, p_cikis_tarihi) AS toplam_fiyat
    FROM Oda o
             JOIN OdaTipi ot ON o.oda_tipi_id = ot.id
    WHERE (p_oda_tipi_id IS NULL OR o.oda_tipi_id = p_oda_tipi_id)
      AND o.durum != 'bakımda'
      AND NOT EXISTS (
        SELECT 1
        FROM Rezervasyon r
        WHERE r.oda_id = o.id
          AND r.durum != 'iptal'
          AND p_giris_tarihi < r.cikis_tarihi
          AND p_cikis_tarihi > r.giris_tarihi
    )
      AND NOT EXISTS (
        SELECT 1
        FROM Olanak ol
        WHERE FIND_IN_SET(ol.id, p_olanaklar)
          AND ol.id NOT IN (SELECT olanak_id FROM OdaTipiOlanak WHERE oda_tipi_id = o.oda_tipi_id)
    ) -- istenen olanaklardan odada olmayan bir tane bile varsa oda listelenmez
    ORDER BY o.oda_no;
END //
-- Verilen tarih aralığında çakışan rezervasyonu olmayan (ve bakımda olmayan) odaları listeler. İstenirse olanaklara göre de filtreler.
-- Çakışma koşulu trg_rezervasyon_cakisma_insert ile aynı, sadece NOT EXISTS ile tersine çevrildi.


DROP PROCEDURE IF EXISTS sp_konaklama_tutari_hesapla//
CREATE PROCEDURE sp_konaklama_tutari_hesapla(
    IN  p_konaklama_id INT,
    OUT p_oda_tutari DECIMAL(10, 2),
    OUT p_hizmet_tutari DECIMAL(10, 2),
    OUT p_toplam_tutar DECIMAL(10, 2)
)
BEGIN
    SELECT ROUND(fn_oda_fiyati_hesapla(o.oda_tipi_id, r.giris_tarihi, r.cikis_tarihi) * (100 - r.indirim_orani) / 100, 2)
    INTO p_oda_tutari
    FROM Konaklama k
             JOIN Rezervasyon r ON k.rezervasyon_id = r.id
             JOIN Oda o ON r.oda_id = o.id
    WHERE k.id = p_konaklama_id;

    SELECT IFNULL(SUM(kh.adet * eh.birim_fiyat), 0)
    INTO p_hizmet_tutari
    FROM KonaklamaHizmeti kh
             JOIN EkHizmet eh ON kh.ek_hizmet_id = eh.id
    WHERE kh.konaklama_id = p_konaklama_id;

    SET p_toplam_tutar = p_oda_tutari + p_hizmet_tutari;
END //
-- Konaklamanın toplam tutarını hesaplar: oda ücreti + ek hizmetler.
-- Oda ücreti her gecenin sezon fiyatından hesaplanır, rezervasyonda indirim uygulandıysa (indirim_orani) düşülür.
-- Kullanım: CALL sp_konaklama_tutari_hesapla(1, @oda, @hizmet, @toplam); SELECT @oda, @hizmet, @toplam;


DROP PROCEDURE IF EXISTS sp_fiyat_teklifi//
CREATE PROCEDURE sp_fiyat_teklifi(
    IN  p_oda_id INT,
    IN  p_giris_tarihi DATE,
    IN  p_cikis_tarihi DATE,
    IN  p_misafir_id INT,
    IN  p_kampanya_kodu VARCHAR(30), -- kod girilmediyse NULL
    OUT p_ham_fiyat DECIMAL(10, 2),
    OUT p_indirim_orani DECIMAL(5, 2),
    OUT p_toplam_fiyat DECIMAL(10, 2),
    OUT p_kampanya_id INT
)
BEGIN
    DECLARE v_erken_rezervasyon DECIMAL(5, 2) DEFAULT IF(DATEDIFF(p_giris_tarihi, CURDATE()) >= 60, 15, 0); -- 60 gün önceden %15
    DECLARE v_uzun_konaklama DECIMAL(5, 2) DEFAULT IF(DATEDIFF(p_cikis_tarihi, p_giris_tarihi) >= 7, 10, 0); -- 7 gece ve üstü %10
    DECLARE v_sadakat DECIMAL(5, 2) DEFAULT 0;
    DECLARE v_kampanya DECIMAL(5, 2) DEFAULT 0;

    SELECT fn_oda_fiyati_hesapla(oda_tipi_id, p_giris_tarihi, p_cikis_tarihi)
    INTO p_ham_fiyat
    FROM Oda
    WHERE id = p_oda_id;

    SELECT indirim_orani INTO v_sadakat FROM v_misafir_sadakat WHERE misafir_id = p_misafir_id;

    IF p_kampanya_kodu IS NOT NULL THEN
        SELECT id, indirim_orani
        INTO p_kampanya_id, v_kampanya
        FROM Kampanya
        WHERE kod = p_kampanya_kodu
          AND CURDATE() BETWEEN baslangic_tarihi AND bitis_tarihi
          AND kullanim_sayisi < kullanim_limiti;

        IF p_kampanya_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'HATA: Kampanya kodu geçersiz, süresi dolmuş veya kullanım limiti dolmuş.';
        END IF;
    END IF;

    SET p_indirim_orani = LEAST(v_erken_rezervasyon + v_uzun_konaklama + v_sadakat + v_kampanya, 50); -- toplam indirim en fazla %50
    SET p_toplam_fiyat = ROUND(p_ham_fiyat * (100 - p_indirim_orani) / 100, 2);
END //
-- Rezervasyon yapılmadan önce misafire gösterilecek fiyatı hesaplar.
-- İndirimler toplanır: erken rezervasyon + uzun konaklama + sadakat seviyesi (v_misafir_sadakat) + kampanya kodu.
-- Kullanım: CALL sp_fiyat_teklifi(4, '2027-03-10', '2027-03-17', 6, 'KTU2026', @ham, @oran, @toplam, @kampanya); SELECT @ham, @oran, @toplam;


DROP PROCEDURE IF EXISTS sp_rezervasyon_olustur//
CREATE PROCEDURE sp_rezervasyon_olustur(
    IN p_misafir_id INT,
    IN p_oda_id INT,
    IN p_giris_tarihi DATE,
    IN p_cikis_tarihi DATE,
    IN p_kisi_sayisi INT,
    IN p_kampanya_kodu VARCHAR(30)
)
BEGIN
    DECLARE v_oda_id INT;
    DECLARE v_rezervasyon_id INT;
    DECLARE v_ham_fiyat, v_toplam_fiyat DECIMAL(10, 2);
    DECLARE v_indirim_orani DECIMAL(5, 2);
    DECLARE v_kampanya_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_cikis_tarihi <= p_giris_tarihi THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Çıkış tarihi giriş tarihinden sonra olmalıdır.';
    END IF;

    START TRANSACTION;

    SELECT id INTO v_oda_id FROM Oda WHERE id = p_oda_id FOR UPDATE;
    -- odanın satırını kilitliyoruz: aynı odaya aynı anda iki rezervasyon gelirse ikincisi birincinin bitmesini bekler,
    -- sonra çakışma trigger'ı ilk rezervasyonu görüp ikinciyi engeller. kilit olmasa ikisi de aynı anda kontrolden geçebilirdi.

    CALL sp_fiyat_teklifi(p_oda_id, p_giris_tarihi, p_cikis_tarihi, p_misafir_id, p_kampanya_kodu,
                          v_ham_fiyat, v_indirim_orani, v_toplam_fiyat, v_kampanya_id);

    INSERT INTO Rezervasyon (misafir_id, oda_id, giris_tarihi, cikis_tarihi, kisi_sayisi, anlasilan_fiyat, indirim_orani, kampanya_id)
    VALUES (p_misafir_id, p_oda_id, p_giris_tarihi, p_cikis_tarihi, p_kisi_sayisi,
            ROUND(v_toplam_fiyat / DATEDIFF(p_cikis_tarihi, p_giris_tarihi), 2), v_indirim_orani, v_kampanya_id);
    -- çakışma, kapasite ve kampanya trigger'ları burda çalışır, biri hata verirse her şey geri alınır

    SET v_rezervasyon_id = LAST_INSERT_ID();

    COMMIT;

    SELECT v_rezervasyon_id AS rezervasyon_id, v_ham_fiyat AS ham_fiyat, v_indirim_orani AS indirim_orani, v_toplam_fiyat AS toplam_fiyat;
END //
-- Yeni rezervasyonu oluşturur. anlasilan_fiyat indirimli gecelik ortalama fiyattır, indirim_orani check-out'ta aynı indirimin uygulanması için saklanır.


DROP PROCEDURE IF EXISTS sp_aylik_doluluk_gelir_raporu//
CREATE PROCEDURE sp_aylik_doluluk_gelir_raporu(
    IN p_yil INT,
    IN p_ay INT
)
BEGIN
    DECLARE v_ay_basi DATE DEFAULT MAKEDATE(p_yil, 1) + INTERVAL (p_ay - 1) MONTH;
    DECLARE v_sonraki_ay DATE DEFAULT v_ay_basi + INTERVAL 1 MONTH;

    SELECT p_yil AS yil,
           p_ay AS ay,
           satilan_oda_gecesi,
           ROUND(satilan_oda_gecesi * 100 / ((SELECT COUNT(*) FROM Oda) * DAY(LAST_DAY(v_ay_basi))), 2) AS doluluk_orani,
           (SELECT IFNULL(SUM(tutar), 0) FROM Odeme WHERE tarih >= v_ay_basi AND tarih < v_sonraki_ay) AS toplam_gelir
    FROM (
             SELECT IFNULL(SUM(DATEDIFF(LEAST(cikis_tarihi, v_sonraki_ay), GREATEST(giris_tarihi, v_ay_basi))), 0) AS satilan_oda_gecesi
             FROM Rezervasyon
             WHERE durum IN ('onaylı', 'tamamlandı')
               AND giris_tarihi < v_sonraki_ay
               AND cikis_tarihi > v_ay_basi
         ) aylik;
END //
-- Doluluk oranı = o ay satılan oda gecesi / (oda sayısı * ayın gün sayısı). Ay sınırını taşan rezervasyonların sadece bu aya düşen geceleri sayılır.
-- Gelir = o ay alınan ödemelerin toplamı.


DROP PROCEDURE IF EXISTS sp_checkout//
CREATE PROCEDURE sp_checkout(
    IN p_konaklama_id INT,
    IN p_odeme_turu VARCHAR(10)
)
BEGIN
    DECLARE v_rezervasyon_id INT;
    DECLARE v_gercek_cikis TIMESTAMP;
    DECLARE v_oda_tutari, v_hizmet_tutari, v_toplam_tutar DECIMAL(10, 2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END; -- herhangi bir adımda hata olursa (SIGNAL dahil) yapılan her şey geri alınır, hata da çağırana iletilir

    START TRANSACTION;

    SELECT rezervasyon_id, gercek_cikis
    INTO v_rezervasyon_id, v_gercek_cikis
    FROM Konaklama
    WHERE id = p_konaklama_id
        FOR UPDATE; -- aynı konaklamaya aynı anda iki check-out gelirse ikincisi bunun bitmesini bekler

    IF v_rezervasyon_id IS NULL OR v_gercek_cikis IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Konaklama bulunamadı veya check-out zaten yapılmış.';
    END IF;

    -- 1. konaklamayı kapat (trg_checkout_oda_temizlik odayı 'temizlikte' yapar ve temizlik görevi açar)
    UPDATE Konaklama SET gercek_cikis = NOW() WHERE id = p_konaklama_id;

    -- 2. toplam tutarı hesapla
    CALL sp_konaklama_tutari_hesapla(p_konaklama_id, v_oda_tutari, v_hizmet_tutari, v_toplam_tutar);

    -- 3. ödemeyi kaydet (trg_misafir_puan_artir ve trg_odeme_ekleme_log çalışır)
    IF p_odeme_turu NOT IN ('nakit', 'kart') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'HATA: Geçersiz ödeme türü. İşlem geri alındı.';
    END IF; -- bilerek 1. adımdan sonra kontrol ediliyor, ROLLBACK testinde 1. adımın da geri alındığı görülsün diye

    INSERT INTO Odeme (konaklama_id, tutar, odeme_turu) VALUES (p_konaklama_id, v_toplam_tutar, p_odeme_turu);

    -- 4. rezervasyonu tamamla (trg_rezervasyon_islem_log çalışır)
    UPDATE Rezervasyon SET durum = 'tamamlandı' WHERE id = v_rezervasyon_id;

    COMMIT;

    SELECT v_oda_tutari AS oda_tutari, v_hizmet_tutari AS hizmet_tutari, v_toplam_tutar AS toplam_tutar;
END //
-- Check-out işlemini tek bir transaction içinde yapar: konaklama kapatılır, ödeme alınır, oda durumu güncellenir, rezervasyon tamamlanır.
-- Herhangi bir adım başarısız olursa hepsi ROLLBACK ile geri alınır.

DELIMITER ;


-- TEST SORGULARI

-- 1. Boş oda arama (Deluxe, gelecek hafta)
-- CALL sp_bos_odalari_listele(DATE_ADD(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), 2, NULL);

-- 2. Tüm oda tiplerinde bugün için boş oda arama
-- CALL sp_bos_odalari_listele(CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY), NULL, NULL);

-- 2b. Olanak filtresiyle boş oda arama (Jakuzi + Deniz Manzarası olan odalar, sadece Deluxe çıkmalı)
-- CALL sp_bos_odalari_listele(DATE_ADD(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL, '6,7');

-- 3. Konaklama tutarı hesaplama (Hakan Aydın aktif konaklaması, konaklama id 4)
-- CALL sp_konaklama_tutari_hesapla(4, @oda, @hizmet, @toplam);
-- SELECT @oda AS oda_tutari, @hizmet AS hizmet_tutari, @toplam AS toplam_tutar;

-- 3b. Fiyat teklifi (Hakan Aydın Platin %15 + kampanya %10 + uzun konaklama %10)
-- CALL sp_fiyat_teklifi(4, '2027-03-10', '2027-03-17', 6, 'KTU2026', @ham, @oran, @toplam, @kampanya);
-- SELECT @ham AS ham_fiyat, @oran AS indirim_orani, @toplam AS toplam_fiyat, @kampanya AS kampanya_id;

-- 3c. Rezervasyon oluşturma (indirim oranı saklanır, kampanya kullanım sayısı artar)
-- CALL sp_rezervasyon_olustur(6, 4, '2027-03-10', '2027-03-17', 2, 'KTU2026');

-- 3d. Aynı odaya çakışan rezervasyon denemesi (trigger engeller, hiçbir değişiklik kalmaz)
-- CALL sp_rezervasyon_olustur(7, 4, '2027-03-12', '2027-03-14', 2, NULL);

-- 4. Aylık doluluk ve gelir raporu
-- CALL sp_aylik_doluluk_gelir_raporu(2026, 7);

-- 5. Başarılı check-out (oda 102 -> temizlikte, ödeme ve log kayıtları oluşur)
-- CALL sp_checkout(1, 'kart');
-- SELECT oda_no, durum FROM Oda WHERE oda_no = '102';
-- SELECT * FROM IslemLog ORDER BY id DESC LIMIT 5;

-- 6. ROLLBACK testi: geçersiz ödeme türü, hiçbir değişiklik kalmamalı (oda 202 hala 'dolu', gercek_cikis hala NULL)
-- CALL sp_checkout(2, 'bitcoin');
-- SELECT id, gercek_cikis FROM Konaklama WHERE id = 2;
-- SELECT oda_no, durum FROM Oda WHERE oda_no = '202';

-- 7. Aynı konaklamaya ikinci kez check-out denemesi
-- CALL sp_checkout(1, 'nakit');
