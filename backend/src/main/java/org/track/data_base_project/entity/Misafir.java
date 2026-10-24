package org.track.data_base_project.entity;

import lombok.NoArgsConstructor;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Setter;
import lombok.Getter;
import java.time.LocalDate;


@Entity //ORM objesi yapar. hibernate e Veri tabanı ile ilişkili olduğunu söyler. ("Yani Service veya Controller gibi mantık/işlem sınıfı değil doğrudan veritabanındaki bir tabloyu modelleyen/temsil eden sınıftır.)
@Table(name = "Misafir") // @Table ın sql tablolarındaki hangi tablo ile ilişkileneceğini söylüyor.
@Getter // bu otomatik olarak getterlaro arka planda yazıyor. senin yazmana gerek kalmıyo
@Setter // buda aynısnı setterlar için yapıyo
@NoArgsConstructor // bu hibernate için boş bi constructer yazar çünkü ilk önce sistem boşken ayağa kaldırır sonradan nesnelerin içi doldurulur. yani içi boş objeler açar.

public class Misafir {
    @Id // tablonun birinci anahtarıdır (primary key)
    @GeneratedValue (strategy = GenerationType.IDENTITY)// MySQL auto_increment karşılığıdır her id +1 ekliyor.
    @Setter(AccessLevel.NONE) // ID değerini dışardan elle değiştirilmesini engeller
    private Integer id;

    //her misafirin sisteme giriş yapabilmesi için bir hesabı olması gerekir.
    @OneToOne(fetch=FetchType.LAZY)// OneToOne 1 misafirin hesabı yalnızca 1 misafire karşılık gelir.
    @JoinColumn (name="kullanici_id" , nullable = false , unique = true) //JoinColumn ile veritabanın da bu bağlantıyı tutacak adı 'kullanici_id' olarak belirtiriz.
    private Kullanici kullanici;

    @Column(name ="tc_pasaport" , length=20) // T.C. kimlik kartın veya pasaportun
    private String tcPasaport;

    @Column(name="telefon" , length=20)// misafirin telefon numarası.
    private String telefon;

    @Column (name="dogum_tarihi" , nullable =  false) //doğum tarihi LocalDate burda kullanılır.
    private LocalDate dogumTarihi;

    @Column(name="ad" , nullable = false , length = 50)// misafirin adı
    private String ad;

    @Column (name = "soyad", nullable = false ,length = 50)// misafirin soyadı
    private String soyad;

    @Column(name = "toplam_puan") // Otel sadakat puanı 
    private Integer toplamPuan=0; // toplamPuan = 0 yazmamızın sebebi toplamPuanın Integer bir nesne olmasıdır eğer bir değer girmezsek varsayılan değer olarak java null değerini koyar.

    // Özel constructor (id hariç, yeni kullanıcı oluştururken)
    public Misafir(Kullanici kullanici , String tcPasaport , String telefon ,LocalDate dogumTarihi, String ad ,String soyad ,Integer toplamPuan){
        this.kullanici=kullanici;
        this.tcPasaport=tcPasaport;
        this.telefon=telefon;
        this.dogumTarihi=dogumTarihi;
        this.ad=ad;
        this.soyad=soyad;
        this.toplamPuan=(toplamPuan != null)? toplamPuan : 0; // (toplamPuan != null) --> parametre olarak gelen bu değer dolu mu . Doluysa toplamPuan değerini al . Boşsa yani null ise 0 gönder.
         
    }
}
