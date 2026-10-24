package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity 
@Table(name = "Konaklama") 
@Getter 
@Setter 
@NoArgsConstructor 

public class Konaklama {
    @Id//tablonun birincil anahtarı primary keyi 
    @GeneratedValue(strategy = GenerationType.IDENTITY )//MySQL auto_increment le otomatik +1 ekler
    @Setter(AccessLevel.NONE)//id dışarıdan elle değiştirilemez
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="rezervasyon_id", nullable = false)
    private Rezervasyon rezervasyon;

    @ManyToOne(fetch=FetchType.LAZY)//ManyToOne check-in veya check-out işlemini resepsiyonda hangi personel yaptıyor.
    @JoinColumn(name = "islem_yapan_personel_id" , nullable = false)
    private Personel islemYapanPersonel;

    @Column(name="gercek_giris" , nullable = false)
    private LocalDateTime gercekGiris;

    @Column(name="gercek_cikis")//misafir otelden ayrılana kadar null yazılır.
    private LocalDateTime gercekCikis;

    @PrePersist//INSERT anında giriş saati verilmemişse sistemin o anki saatini otomatik basar
    protected void onGiris() {
        if (this.gercekGiris == null) {
            this.gercekGiris = LocalDateTime.now();
        }
    }

    // Özel constructor
    public Konaklama(Rezervasyon rezervasyon , Personel islemYapanPersonel , LocalDateTime gercekGiris) {
        this.rezervasyon=rezervasyon;
        this.islemYapanPersonel=islemYapanPersonel;
        this.gercekGiris=(gercekGiris != null) ? gercekGiris : LocalDateTime.now();//çıkış tarihi henüz belli olmadığı için null başlar
        this.gercekCikis=null;
    }
}
