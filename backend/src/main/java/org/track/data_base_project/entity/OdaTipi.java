package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.util.HashSet;//bir oda tipine ait olanakların tekrar etmesini önler.
import java.util.Set;//değişkeninin veri tipini (arayüzünü) tanımlayabilmeniz için kullandık.

@Entity 
@Getter 
@Setter 
@Table(name = "OdaTipi") 
@NoArgsConstructor 


public class OdaTipi {
    @Id // tablonun birinci anahtarıdı(primary key).
    @GeneratedValue (strategy = GenerationType.IDENTITY) // MySQL auto_increment her yeni kayıtta id otomatik +1 yapar.
    @Setter (AccessLevel.NONE) // ID değeri dışardan değiştirilemez.
    private Integer id;

    @Column(name = "ad", nullable = false , length = 50) // oda tipinin adı standart , suit gibi
    private String ad;

    @Column(name = "kapasite" , nullable = false) // odada kalabilecek en çok kişi sayısı.
    private Integer kapasite;

    @Column(name = "aciklama" , columnDefinition = "TEXT") //odanın tipi hakkında bize detaylı açıklama veriyor
    private String aciklama;
    
    @Column(name = "temel_fiyat" , nullable = false , precision = 10 , scale = 2) // 'precision = 10' bir fiyatta en fazla 10 basamak olabilir . 'scale = 2' ise virgülden sonra ki 2 basamak yani kuruş
    private BigDecimal temelFiyat; // double yerine BigDecimal kullanma nedeni BigDecimalin daha hassas olduğu için

    @ManyToMany(fetch = FetchType.LAZY)//OdaTipi ile Olanak arasındaki Many-to-Many ilişkiyi OdaTipiOlanak ara tablosuyla kurduk.
    @JoinTable(
    name = "OdaTipiOlanak",
    joinColumns = @JoinColumn(name = "oda_tipi_id"),
    inverseJoinColumns = @JoinColumn(name = "olanak_id")
    )
    private Set<Olanak> olanaklar = new HashSet<>();//tekrarlı kayıtları önler

    // Özel constructor (id hariç, yeni kullanıcı oluştururken)
    public OdaTipi(String ad , Integer kapasite , String aciklama , BigDecimal temelFiyat){
        this.ad=ad;
        this.kapasite=kapasite;
        this.aciklama=aciklama;
        this.temelFiyat=temelFiyat;
    }
}
