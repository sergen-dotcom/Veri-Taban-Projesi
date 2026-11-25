package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.AccessLevel;
import lombok.Setter;
import java.math.BigDecimal;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "Kampanya")
@Getter
@Setter
@NoArgsConstructor

public class Kampanya {
    @Id//tablonun birincil anahtarı primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY)//MySQL AUTO_INCREMENT özelliği +1 artar
    @Setter(AccessLevel.NONE)//ID dışarıdan değiştirlmez.
    private Integer id;

    @Column(name="kod" , nullable =false ,unique = true ,length=30) //misafirin girdiği indirim kodu
    private String kod;

    @Column(name = "indirim_orani" , nullable=false , precision =5 , scale= 2) //yüzde olarak (10.00 = %10)
    private BigDecimal indirimOrani;

    @Column(name= "baslangic_tarihi" , nullable= false)
    private LocalDate baslangicTarihi;

    @Column(name = "bitis_tarihi" , nullable = false)
    private LocalDate bitisTarihi;

    @Column(name = "kullanim_limiti" , nullable = false)
    private Integer kullanimLimiti;

    @Column(name="kullanim_sayisi") // her kullanımda trigger ile 1 artıyor
    private Integer kullanimSayisi = 0;

    public Kampanya(String kod , BigDecimal indirimOrani , LocalDate baslangicTarihi , LocalDate bitisTarihi , Integer kullanimLimiti) {
        this.kod = kod;
        this.indirimOrani = indirimOrani;
        this.baslangicTarihi = baslangicTarihi;
        this.bitisTarihi = bitisTarihi;
        this.kullanimLimiti = kullanimLimiti;
        this.kullanimSayisi = 0;
    }
}
