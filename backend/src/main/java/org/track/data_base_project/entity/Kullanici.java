package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity //ORM objesi yapar. hibernate e Veri tabanı ile ilişkili olduğunu söyler. ("Yani Service veya Controller gibi mantık/işlem sınıfı değil doğrudan veritabanındaki bir tabloyu modelleyen/temsil eden sınıftır.)
@Table(name = "Kullanici") // @Table ın sql tablolarındaki hangi tablo ile ilişkileneceğini söylüyor.
@Getter // bu otomatik olarak getterlaro arka planda yazıyor. senin yazmana gerek kalmıyo
@Setter // buda aynısnı setterlar için yapıyo
@NoArgsConstructor // bu hibernate için boş bi constructer yazar çünkü ilk önce sistem boşken ayağa kaldırır sonradan nesnelerin içi doldurulur. yani içi boş objeler açar.

public class Kullanici {

    @Id // bu hemen altındaki tanımlanacak şeyin primary key olduğunu söyler (01_schema.sql betiğinde de primary key olarak tanımlamıştık hatırlarsan.)
    @GeneratedValue(strategy = GenerationType.IDENTITY) // bu my sqlde yazdığımız AUTO_INCREMENT ın karşılığı her eklenen idye +1 ekliyo sen manuel olarak ekleme diye.
    @Setter(AccessLevel.NONE) // normalde Id benzeri primary keyler değiştirilemez olur. Yukarda @Setter tüm oluşturulan dosyalar için setter koyar. bu annotationda bunu @Setter'ın içine dahil etme der, Id değişkenin için setter oluşturmaz.
    private Integer id;

    @Column(name = "eposta", unique = true, nullable = false, length = 100) // buda tablo oluşturduğumuz sql betiğindeki özellikleri hibernate kütüphanesine söyler.
    private String eposta;

    @Column(name = "sifre", nullable = false, length = 255)
    private String sifre;

    @Enumerated(EnumType.STRING) // normalde java enumları numara olarak tutar bizde 3 tane rol var yani 0, 1, 2 olarak tutar ama sqlde yazı olarak tutarız. bu annotationda sqldeki yazıyla uyuşmasını sağlar. (zaten farkındaysan .STRING ile stringe çevirmiş enum türünü.
    @Column(name = "rol", nullable = false)
    private Rol rol;

    // Özel constructor (id hariç, yeni kullanıcı oluştururken)
    public Kullanici(String eposta, String sifre, Rol rol) {
        this.eposta = eposta;
        this.sifre = sifre;
        this.rol = rol;
    }

    public enum Rol {
        misafir,
        resepsiyon,
        yonetici
    }
}
