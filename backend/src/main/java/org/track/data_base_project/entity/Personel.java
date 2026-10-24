package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Setter;
import lombok.Getter;
import java.time.LocalDate;
import lombok.NoArgsConstructor;

@Entity //ORM objesi yapar. hibernate e Veri tabanı ile ilişkili olduğunu söyler. ("Yani Service veya Controller gibi mantık/işlem sınıfı değil doğrudan veritabanındaki bir tabloyu modelleyen/temsil eden sınıftır.)
@Table(name = "Personel") // @Table ın sql tablolarındaki hangi tablo ile ilişkileneceğini söylüyor.
@Getter // bu otomatik olarak getterlaro arka planda yazıyor. senin yazmana gerek kalmıyo
@Setter // buda aynısnı setterlar için yapıyo
@NoArgsConstructor // bu hibernate için boş bi constructer yazar çünkü ilk önce sistem boşken ayağa kaldırır sonradan nesnelerin içi doldurulur. yani içi boş objeler açar.

public class Personel {
    @Id // tablonun birinci 'primary key'.
    @GeneratedValue (strategy = GenerationType.IDENTITY) // MySQL AUTO.INCREMENT özelliğini +1 arttırır.
    @Setter(AccessLevel.NONE) // ID değeri dışardan değiştirilemez
    private Integer id;

    //her bir personelin sisteme giriş yapabilmesi için bir hesabının olması lazım.
    @OneToOne(fetch=FetchType.LAZY)// OneToOne : 1 personelin hesabı yalnızca 1 personele karşılık gelir.
    @JoinColumn (name="kullanici_id" , nullable = false , unique = true) //JoinColumn ile veritabanın da bu bağlantıyı tutacak adı 'kullanici_id' olarak belirtiriz.
    private Kullanici kullanici;

    @Column(name = "ad" , nullable = false , length = 50)// personel adı
    private String ad;

    @Column (name = "soyad" , nullable = false , length = 50)// personelin soyadı
    private String soyad;

    @Column(name = "gorev" , nullable = false , length = 50)// personelin otelde ki görevi müdür , temizlikçi , aşçı vesayre
    private String gorev;

    @Column(name = "ise_giris_tarihi" , nullable = false) // işe başladığı gün , ay , yıl saat için ise LocalDate kullanıcaz.
    private LocalDate iseGirisTarihi;

    // Özel constructor (id hariç, yeni kullanıcı oluştururken)
    public Personel(Kullanici kullanici , String ad , String soyad , String gorev , LocalDate iseGirisTarihi){
        this.kullanici=kullanici;
        this.ad=ad;
        this.soyad=soyad;
        this.gorev=gorev;
        this.iseGirisTarihi=iseGirisTarihi;
    }
}
