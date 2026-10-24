package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "KonaklamaHizmeti")
@Setter
@Getter
@NoArgsConstructor

public class KonaklamaHizmeti {
    @Id 
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Setter(AccessLevel.NONE)
    private Integer id;

    @ManyToOne(fetch= FetchType.LAZY)//ManyToOne odada kalan hangi misafire hizmet yazıldığını belirtir
    @JoinColumn(name = "konaklama_id" , nullable = false)
    private Konaklama konaklama;

    @ManyToOne(fetch = FetchType.LAZY)//tüketilen ek hizmetin türü örneğin su , kola
    @JoinColumn(name = "ek_hizmet_id" , nullable = false)
    private EkHizmet ekHizmet;

    @Column(name = "adet" , nullable = false)//kaç tane hizmet alındı örneğin 1 kola
    private Integer adet = 1;

    @Column(name="siparis_zamani" , updatable = false)//hizmetin sipariş edildiği zamanı saat ve dakikayla tutar
    private LocalDateTime siparisZamani;

    @PrePersist//INSERT anında sistemin anlık saatini siparisZamani alanına otomatik basar
    protected void onSiparis() {
        this.siparisZamani = LocalDateTime.now();
    }

    public KonaklamaHizmeti(Konaklama konaklama , EkHizmet ekHizmet , Integer adet) {
        this.konaklama = konaklama;
        this.ekHizmet = ekHizmet;
        this.adet = (adet != null) ? adet : 1;
    }
}
