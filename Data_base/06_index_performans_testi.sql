USE hotel_management;

-- İNDEKS PERFORMANS KARŞILAŞTIRMASI (rapor için)
-- Asıl tablolarda 200 civarı satır olduğu için fark ölçülemeyecek kadar küçük çıkıyor.
-- Bu yüzden 200.000 satırlık, indekssiz test tabloları oluşturuyoruz. Asıl verilere dokunulmuyor.

SET SESSION cte_max_recursion_depth = 200000; -- recursive CTE varsayılan olarak 1000 satırda durur

DROP TABLE IF EXISTS test_rezervasyon, test_kullanici;

CREATE TABLE test_rezervasyon
WITH RECURSIVE sayac (sira) AS (SELECT 1 UNION ALL SELECT sira + 1 FROM sayac WHERE sira < 200000)
SELECT sira AS id,
       DATE '2022-01-01' + INTERVAL (sira * 7919) % 1825 DAY AS giris_tarihi -- 5 yıla dağılmış giriş tarihleri
FROM sayac;

CREATE TABLE test_kullanici
WITH RECURSIVE sayac (sira) AS (SELECT 1 UNION ALL SELECT sira + 1 FROM sayac WHERE sira < 200000)
SELECT sira AS id, CONCAT('misafir', sira, '@test.com') AS eposta
FROM sayac;


-- TEST 1: Rezervasyon tarih aralığı sorgusu
EXPLAIN ANALYZE SELECT * FROM test_rezervasyon WHERE giris_tarihi BETWEEN '2024-03-01' AND '2024-03-07'; -- indekssiz: Table scan
CREATE INDEX idx_test_tarih ON test_rezervasyon (giris_tarihi);
EXPLAIN ANALYZE SELECT * FROM test_rezervasyon WHERE giris_tarihi BETWEEN '2024-03-01' AND '2024-03-07'; -- indeksli: Index range scan

-- TEST 2: Giriş ekranında e-posta ile kullanıcı arama
EXPLAIN ANALYZE SELECT * FROM test_kullanici WHERE eposta = 'misafir154321@test.com'; -- indekssiz
CREATE INDEX idx_test_eposta ON test_kullanici (eposta);
EXPLAIN ANALYZE SELECT * FROM test_kullanici WHERE eposta = 'misafir154321@test.com'; -- indeksli


-- Rapora yazılacaklar: her testin indekssiz ve indeksli "actual time" değerleri ve okunan satır sayısı (rows).

-- TEMİZLİK
-- DROP TABLE IF EXISTS test_rezervasyon, test_kullanici;
