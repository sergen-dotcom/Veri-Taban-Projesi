package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import lombok.Setter;

@Entity 
@Table(name = "EkHizmet") 
@Getter 
@Setter 
@NoArgsConstructor 

public class EkHizmet {
    @Id // tablonun birinci (primary key) olduğunu belirtir.
    @GeneratedValue (strategy = GenerationType.IDENTITY) // MySQL auto_increment her yeni kayıtta id otomatik +1 yapar.
    @Setter(AccessLevel.NONE) // ID değeri dışardan değiştirilemez.
    private Integer id;

    @Column(name ="hizmet_adi" , nullable = false , length = 100) // Ek hizmetin adıdır 
    private String hizmetAdi;

    @Column(name = "birim_fiyat" , nullable = false , precision = 10 , scale = 2)// 'precision = 10' bir fiyatta en fazla 10 basamak olabilir . 'scale = 2' ise virgülden sonra ki 2 basamak yani kuruş
    private BigDecimal birimFiyat; // double yerine BigDecimal kullanma nedeni BigDecimalin daha hassas olduğu için

    // Özel constructor (id hariç, yeni kullanıcı oluştururken)
    public EkHizmet(String hizmetAdi , BigDecimal birimFiyat){
        this.hizmetAdi=hizmetAdi;
        this.birimFiyat=birimFiyat;
    }
}
