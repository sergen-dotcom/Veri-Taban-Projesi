package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity //ORM objesi yapar. hibernate e Veri tabanı ile ilişkili olduğunu söyler. ("Yani Service veya Controller gibi mantık/işlem sınıfı değil doğrudan veritabanındaki bir tabloyu modelleyen/temsil eden sınıftır.)
@Table(name = "OzelGun") // @Table ın sql tablolarındaki hangi tablo ile ilişkileneceğini söylüyor.
@Getter // bu otomatik olarak getterlaro arka planda yazıyor. senin yazmana gerek kalmıyo
@Setter // buda aynısnı setterlar için yapıyo
@NoArgsConstructor // bu hibernate için boş bi constructer yazar çünkü ilk önce sistem boşken ayağa kaldırır sonradan nesnelerin içi doldurulur. yani içi boş objeler açar.

public class OzelGun {
    @Id//tablonun birincil anahtarıdır(primary key)
    @GeneratedValue(strategy =GenerationType.IDENTITY)//MySQL auto_increment karşılığıdır id +1 oto ekler.
    @Setter(AccessLevel.NONE)//id değeri dışardan değiştirilmez
    private Integer id;

    @Column(name="etkinlik_adi",nullable=false,length=100)//etkinliğin adı örneğin trabzon-bjk maçı
    private String etkinlikAdi;

    @Column(name="baslangic_tarihi",nullable = false)//etkinliğin başlangıç tarihi
    private LocalDate baslangicTarihi;

    @Column(name="bitis_tarihi",nullable = false)//etkinliğin bitiş tarihi
    private LocalDate bitisTarihi;

    @Column(name = "fiyat_carpani" , precision = 3,scale = 2)//schema.sql de fiyat_carpani olarak decimal(3,2) dafault 1.20 o tarihlerde odalara indirim veya zam yapmak için.
    private BigDecimal fiyatCarpani = new BigDecimal("1.20");

    @Column(name = "aciklama" , length = 255)//etkinliğe dair açıklama
    private String aciklama;

    // Özel constructor
    public OzelGun(String etkinlikAdi , LocalDate baslangicTarihi , LocalDate bitisTarihi , BigDecimal fiyatCarpani , String aciklama){
        this.etkinlikAdi=etkinlikAdi;
        this.baslangicTarihi=baslangicTarihi;
        this.bitisTarihi=bitisTarihi;
        this.fiyatCarpani=fiyatCarpani;
        this.aciklama=aciklama;
    }
}
