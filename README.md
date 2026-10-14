# 🏨 Otel Rezervasyon ve Konaklama Yönetim Sistemi

![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-brightgreen?style=for-the-badge&logo=springboot)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)
![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)

Bu proje; bir otelin **rezervasyon**, **konaklama**, **ek hizmet**, **temizlik** ve **ödeme** süreçlerini uçtan uca yöneten, veri bütünlüğü ve veritabanı mimarisi odaklı bir otomasyon sistemidir.

---

## 📋 İçindekiler

- [Proje Ekibi](#-proje-ekibi)
- [Teknoloji Yığını ve Mimari](#-teknoloji-yığını-ve-mimari)
- [Veritabanı Mimarisi](#-veritabanı-mimarisi)
- [ER Diyagramı](#-er-diyagramı)
- [Kurulum ve Çalıştırma](#-kurulum-ve-çalıştırma)

---

## 👥 Proje Ekibi

| Ad Soyad | Öğrenci Numarası | Sorumluluk Alanı ve Görevler |
| :--- | :---: | :--- |
| **Muhammed Ege Atılgan** | `462268` | **Backend & Veritabanı:** Veritabanı şeması, Trigger, Stored Procedure, Spring Boot geliştirmeleri |
| **Ali Sergen Erol** | `466814` | **Frontend, Backend & QA:** React arayüzü, API testleri, dokümantasyon ve Spring Boot geliştirmeleri |

> [!NOTE]
> Proje geliştirme sürecinin ilerleyişine göre görev dağılımında güncellemeler yapılabilir.

---

## 🛠 Teknoloji Yığını ve Mimari

Sistem, sürdürülebilirlik ve ölçeklenebilirlik ilkeleri doğrultusunda **Katmanlı Mimari** (*Entity, Repository, Service, Controller*) yapısıyla tasarlanmıştır.

* **Veritabanı:** **MySQL 8** *(InnoDB depolama motoru; ACID uyumu, transaction desteği ve foreign key bütünlüğü için tercih edilmiştir)*
* **Backend:** **Spring Boot (Java 17)**, Spring Data JPA, Maven
* **Frontend:** **React** & **Tailwind CSS** *(Arayüz geliştirme sürecinde üretken yapay zeka araçlarından yararlanılmaktadır)*
* **Altyapı & Konteyner:** **Docker**
* **API Belgelendirme & Test:** **Swagger (OpenAPI)**, **Postman**
* **Versiyon Kontrol Yapılandırması:** Proje `.gitignore` ve ortam yapılandırma şablonları AI desteğiyle optimize edilmiştir.

---

## 🗄️ Veritabanı Mimarisi

Sistem toplam **14 tablodan** oluşmakta olup, tablo ilişkileri ve bağımlılık sırasına göre **5 ana grupta** modellenmiştir:

| Grup Sırası | Kategori | Tablolar |
| :---: | :--- | :--- |
| **1** | **Temel Tanım Tabloları** | `OdaTipi`, `Kullanici`, `EkHizmet` |
| **2** | **İkincil Tablolar** | `HizmetEnvanter`, `Misafir`, `Personel` |
| **3** | **Ana Operasyon Tabloları** | `Oda`, `SezonFiyati`, `Rezervasyon`, `Konaklama` |
| **4** | **Hizmet, Ödeme ve Görev Tabloları** | `KonaklamaHizmeti`, `Odeme`, `TemizlikGorevleri` |
| **5** | **Denetim Kaydı (Audit Log)** | `IslemLog` |

---

## 📐 ER Diyagramı

Veritabanı tabloları arasındaki ilişkileri ve anahtar yapılarını gösteren varlık-ilişki (ER) diyagramı aşağıda yer almaktadır:

![ER Diyagramı](docs/Dbeaver_hotel_management_diagram.png)

---

## 🚀 Kurulum ve Çalıştırma

Veritabanını ve tabloları oluşturan ana SQL betiği `Data_base/01_schema.sql` dizininde yer almaktadır.

### 1. Docker ile MySQL Veritabanını Başlatma
Aşağıdaki komutu çalıştırarak MySQL 8 konteynerini ayağa kaldırın:

```bash
docker run -d \
  --name hotel-db \
  -e MYSQL_ROOT_PASSWORD=hakanaydin123 \
  -p 3306:3306 \
  mysql:8
```

### 2. SQL Şema Betiğini Çalıştırma
MySQL istemcisine bağlandıktan sonra şema dosyasını içe aktarın:

```sql
SOURCE Data_base/01_schema.sql;
```

*(Alternatif olarak doğrudan terminal üzerinden Docker konteynerine aktarmak isterseniz şu komutu kullanabilirsiniz:)*
```bash
docker exec -i hotel-db mysql -uroot -phakanaydin123 < Data_base/01_schema.sql
```