package org.track.data_base_project.entity;

import lombok.Setter;
import lombok.Getter;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@Entity 
@Getter 
@Setter 
@Table(name = "Oda")
@NoArgsConstructor 

public class Oda {
    @Id//tablonun birincil anahtarıdır primary key.
    @GeneratedValue(strategy = GenerationType.IDENTITY)//MySQL AUTO.INCREMENT karşılığıdır her id +1 ekler
    @Setter(AccessLevel.NONE)//id ler dışarıdan değiştirilemez.
    private Integer id;

    @Column(name="oda_no" , nullable = false , unique= true, length = 10)//odaların kapı numarasıdır.
    private String odaNo;

    @Column(name = "kat" , nullable = false)//odanın otelde hangi katta olduğu bilgisini tutar.
    private Integer kat;

    @ManyToOne(fetch=FetchType.LAZY)//ManyToOne bir oda tipinin örneğin standart veya kral dairesi birden fazla oda da olabilir. FetchType.LAZY performansı korur odayı çektiğimizde oda tipi bilgilerini sadece ihtiyaç anında yükler. 
    @JoinColumn(name="oda_tipi_id",nullable = false)//JoinColumn ise foreign key sütun adının "oda_tipi_id" olduğunu belirtir.
    private OdaTipi odaTipi;

    @Enumerated(EnumType.STRING)//EnumType.STRING normalde Java enum'ı 0, 1, 2 diye sayı tutarken veritabanındaki string metinle birebir eşleşmesini sağlar.
    @Column(name = "durum", nullable = false)
    private Durum durum = Durum.bos;

    // Özel constructor
    public Oda(String odaNo, Integer kat, OdaTipi odaTipi, Durum durum) {
        this.odaNo = odaNo;
        this.kat = kat;
        this.odaTipi = odaTipi;
        this.durum = (durum != null) ? durum : Durum.bos;
    }

    public enum Durum {
        bos,
        dolu,
        temizlikte,
        bakımda
    }

    
}
