package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Odeme")
@Getter
@Setter
@NoArgsConstructor

public class Odeme {
    @Id//tablonun birincil anahtarı primary key
    @GeneratedValue(strategy=GenerationType.IDENTITY)//MySQL AUTO_INCREMENT özelliği +1 artar
    @Setter (AccessLevel.NONE)//ID dışarıdan değiştirlmez.
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)//hangi konaklama şekline göre ödeme yapılcak
    @JoinColumn(name = "konaklama_id", nullable = false)//konaklama ile odeme arasında bağlantı kurduk
    private Konaklama konaklama;

    @Column(name = "tutar" , nullable = false , precision = 10 , scale = 2)
    private BigDecimal tutar;

    @Enumerated(EnumType.STRING)//veritabanındaki metinle eşleşmesi için EnumType.STRING kullancaz.
    @Column(name = "odeme_turu", nullable = false)
    private OdemeTuru odemeTuru;

    @Column(name="odeme_zamani" , updatable=false)//ödemenin alındığı zaman tarih bilgilerini tutar
    private LocalDateTime odemeZamani;

    @PrePersist
    protected void onOdeme() {
        this.odemeZamani = LocalDateTime.now();
    }

    //yeni ödeme için kullanılacak değerler.
    public Odeme(Konaklama konaklama, BigDecimal tutar, OdemeTuru odemeTuru) {
        this.konaklama = konaklama;
        this.tutar = tutar;
        this.odemeTuru = odemeTuru;
    }

    public enum OdemeTuru {
        nakit,
        kart
    }
}
