USE hotel_management;

CREATE OR REPLACE VIEW v_bugun_giris_cikis AS
SELECT CASE WHEN r.giris_tarihi = CURDATE() THEN 'Giriş' ELSE 'Çıkış' END AS hareket,
       r.id AS rezervasyon_id,
       m.ad,
       m.soyad,
       m.telefon,
       o.oda_no,
       r.giris_tarihi,
       r.cikis_tarihi,
       r.kisi_sayisi,
       r.durum,
       k.id AS konaklama_id -- NULL ise check-in henüz yapılmamış
FROM Rezervasyon r
         JOIN Misafir m ON r.misafir_id = m.id
         JOIN Oda o ON r.oda_id = o.id
         LEFT JOIN Konaklama k ON k.rezervasyon_id = r.id
WHERE CURDATE() IN (r.giris_tarihi, r.cikis_tarihi)
  AND r.durum != 'iptal';
-- Bugün giriş veya çıkış yapacak misafirleri listeler. Resepsiyon ekranındaki günlük liste bu view'dan beslenecek.


CREATE OR REPLACE VIEW v_oda_guncel_durum AS
SELECT o.id AS oda_id,
       o.oda_no,
       o.kat,
       o.durum,
       MAX(tg.tamamlanma_zamani) AS son_temizlik_tarihi
FROM Oda o
         LEFT JOIN TemizlikGorevleri tg ON tg.oda_id = o.id AND tg.durum = 'Tamamlandı'
GROUP BY o.id, o.oda_no, o.kat, o.durum;
-- Her odanın güncel durumunu ve en son tamamlanan temizlik tarihini gösterir.
-- LEFT JOIN sayesinde hiç temizlenmemiş odalar da listede çıkar (son_temizlik_tarihi NULL olur).


-- TEST SORGULARI

-- 1. Bugünün giriş-çıkış listesi (oda 101 giriş, oda 201 çıkış görünmeli)
-- SELECT * FROM v_bugun_giris_cikis;

-- 2. Odaların durumu ve son temizlik tarihleri
-- SELECT * FROM v_oda_guncel_durum ORDER BY oda_no;
