package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.math.BigDecimal;

@Entity 
@Table(name = "SezonFiyati") 
@Getter 
@Setter 
@NoArgsConstructor 

public class SezonFiyati {
    @Id//tablonun birincil anahtarıdır.(primary key)
    @GeneratedValue(strategy = GenerationType.IDENTITY)//MySQL AUTO.INCREMENT karşılığıdır her id +1 ekler
    @Setter(AccessLevel.NONE)//id ler dışarıdan değiştirilemez.
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)//ManyToOne burdaki görevi bir oda tipine birden fazla sezon fiyatı sağlayabilmesi
    @JoinColumn(name ="oda_tipi_id" ,nullable = false)
    private OdaTipi odaTipi;

    @Column(name="baslangic_tarihi" , nullable = false)//Sezonun başlangıcı gün , ay , yıl
    private LocalDate baslangicTarihi;//saat tutulmadığı için javada ki LocalDate kullanılır.

    @Column(name = "bitis_tarihi", nullable = false)//sezonun bitişi 
    private LocalDate bitisTarihi;

    //sezon boyunca süren oda fiyatı
    @Column(name="gecelik_fiyat" ,nullable = false , precision = 10 , scale = 2)//precision = 10 en fazla 10 basamak , scale = 2 ise virgülden sonraki 2 basamak.
    private BigDecimal gecelikFiyat;//BigDecimal kullanıyoruz double daha hassas olduğu için

    //özel constructor
    public SezonFiyati(OdaTipi odaTipi,LocalDate baslangicTarihi , LocalDate bitisTarihi , BigDecimal gecelikFiyat) {
        this.odaTipi = odaTipi;
        this.baslangicTarihi = baslangicTarihi;
        this.bitisTarihi = bitisTarihi;
        this.gecelikFiyat = gecelikFiyat;
    }
    
}
