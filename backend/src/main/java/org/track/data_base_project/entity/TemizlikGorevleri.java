package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;

@Entity
@Table(name = "TemizlikGorevleri")
@Getter
@Setter
@NoArgsConstructor

public class TemizlikGorevleri {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Setter(AccessLevel.NONE) 
    private Integer id;

    @ManyToOne(fetch= FetchType.LAZY)//hangi oda temizlenicek
    @JoinColumn(name = "oda_id" , nullable = false)
    private Oda oda;

    @ManyToOne(fetch = FetchType.LAZY)//temizliğin hangi personelin yapıcağını belirtiyor.
    @JoinColumn(name = "personel_id" , nullable = false)
    private Personel personel;

    @Column(name = "gorev_tarihi", nullable = false)//temizlik hangi zamanda yapılıcak.
    private LocalDate gorevTarihi;

    @Enumerated(EnumType.STRING)//schema.sql de oncelik dusuk , orta , yuksek ve acil olarak tanımlanmış. default değer olarak orta
    @Column(name = "oncelik", nullable = false)
    private Oncelik oncelik = Oncelik.orta;

    @Enumerated(EnumType.STRING)//burda da schema.sql durum enumu bekliyor , devam_ediyor ve tamamlandı default değer olarak bekliyor.
    @Column(name = "durum", nullable = false)
    private Durum durum = Durum.bekliyor;

    public TemizlikGorevleri(Oda oda, Personel personel, LocalDate gorevTarihi, Oncelik oncelik, Durum durum) {
        this.oda = oda;
        this.personel = personel;
        this.gorevTarihi = gorevTarihi;
        this.oncelik = (oncelik != null) ? oncelik : Oncelik.orta;
        this.durum = (durum != null) ? durum : Durum.bekliyor;
    }

    public enum Oncelik {
        dusuk,
        orta,
        yuksek,
        acil
    }

    public enum Durum {
        bekliyor,
        devam_ediyor,
        tamamlandi
    }
}
